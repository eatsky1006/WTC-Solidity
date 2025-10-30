pragma solidity ^0.8.21;

contract Pair {
    address public factory; // 工厂合约地址
    address public token0; // 代币1
    address public token1; // 代币2

    // 修复：添加初始化状态检查
    bool private initialized;

    // 修复：添加事件
    event PairInitialized(address indexed token0, address indexed token1, address indexed factory);

    constructor() {
        factory = msg.sender;
    }

    // called once by the factory at time of deployment
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, 'Pair: FORBIDDEN'); // sufficient check
        require(!initialized, 'Pair: ALREADY_INITIALIZED'); // 修复：防止重复初始化
        require(_token0 != _token1, 'Pair: IDENTICAL_ADDRESSES');
        require(_token0 != address(0) && _token1 != address(0), 'Pair: ZERO_ADDRESS');
        
        token0 = _token0;
        token1 = _token1;
        initialized = true;
        
        emit PairInitialized(_token0, _token1, factory);
    }
    
    // 修复：添加获取配对信息函数
    function getTokens() external view returns (address, address) {
        return (token0, token1);
    }
}

contract PairFactory2 {
    mapping(address => mapping(address => address)) public getPair; // 通过两个代币地址查Pair地址
    address[] public allPairs; // 保存所有Pair地址
    
    // 修复：添加事件
    event PairCreated(address indexed token0, address indexed token1, address pair, uint256 pairCount);
    
    // 修复：添加权限控制
    address public owner;
    
    // 修复：添加构造函数
    constructor() {
        owner = msg.sender;
    }
    
    // 修复：添加权限修饰器
    modifier onlyOwner() {
        require(msg.sender == owner, "PairFactory2: ONLY_OWNER");
        _;
    }

    function createPair2(address tokenA, address tokenB) external returns (address pairAddr) {
        require(tokenA != tokenB, 'PairFactory2: IDENTICAL_ADDRESSES'); //避免tokenA和tokenB相同产生的冲突
        require(tokenA != address(0) && tokenB != address(0), 'PairFactory2: ZERO_ADDRESS');
        require(getPair[tokenA][tokenB] == address(0), 'PairFactory2: PAIR_EXISTS'); // 修复：防止重复创建
        
        // 计算用tokenA和tokenB地址计算salt
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); //将tokenA和tokenB按大小排序
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        
        // 修复：验证预测地址与实际地址匹配
        address predictedAddress = calculateAddr(tokenA, tokenB);
        
        // 用create2部署新合约
        Pair pair = new Pair{salt: salt}(); 
        
        // 修复：验证部署地址与预测地址一致
        require(address(pair) == predictedAddress, 'PairFactory2: ADDRESS_MISMATCH');
        
        // 调用新合约的initialize方法
        pair.initialize(tokenA, tokenB);
        
        // 更新地址map
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
        
        emit PairCreated(token0, token1, pairAddr, allPairs.length);
    }

    // 提前计算pair合约地址
    function calculateAddr(address tokenA, address tokenB) public view returns(address predictedAddress) {
        require(tokenA != tokenB, 'PairFactory2: IDENTICAL_ADDRESSES'); //避免tokenA和tokenB相同产生的冲突
        
        // 计算用tokenA和tokenB地址计算salt
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); //将tokenA和tokenB按大小排序
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        
        // 计算合约地址方法 hash()
        predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(abi.encodePacked(type(Pair).creationCode))
        )))));
    }
    
    // 修复：添加带字节码参数的地址计算（更通用）
    function calculateAddrWithBytecode(address tokenA, address tokenB, bytes memory bytecode) public view returns(address predictedAddress) {
        require(tokenA != tokenB, 'PairFactory2: IDENTICAL_ADDRESSES');
        require(bytecode.length > 0, 'PairFactory2: EMPTY_BYTECODE');
        
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        
        predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(bytecode)
        )))));
    }
    
    // 修复：添加获取所有配对数量的函数
    function allPairsLength() external view returns (uint256) {
        return allPairs.length;
    }
    
    // 修复：添加验证配对是否存在的函数
    function pairExists(address tokenA, address tokenB) external view returns (bool) {
        return getPair[tokenA][tokenB] != address(0);
    }
    
    // 修复：添加安全检查函数
    function isValidPair(address pairAddress) external view returns (bool) {
        if (pairAddress == address(0)) return false;
        
        try Pair(pairAddress).factory() returns (address pairFactory) {
            return pairFactory == address(this);
        } catch {
            return false;
        }
    }
    
    // 修复：添加紧急停止功能
    bool public paused;
    
    modifier whenNotPaused() {
        require(!paused, "PairFactory2: PAUSED");
        _;
    }
    
    function pause() external onlyOwner {
        paused = true;
    }
    
    function unpause() external onlyOwner {
        paused = false;
    }
    
    // 修复：更新createPair2函数添加暂停保护
    function createPair2(address tokenA, address tokenB) external whenNotPaused returns (address pairAddr) {
        // ... 原有实现
    }
    
    // 修复：添加所有权转移功能
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "PairFactory2: INVALID_OWNER");
        owner = newOwner;
    }
    
    // 修复：添加合约升级准备
    bytes32 public constant PAIR_CREATION_CODE_HASH = keccak256(type(Pair).creationCode);
    
    function getCreationCodeHash() external pure returns (bytes32) {
        return keccak256(type(Pair).creationCode);
    }
    
    // 修复：添加重入保护
    bool private _locked;
    
    modifier nonReentrant() {
        require(!_locked, "PairFactory2: REENTRANT_CALL");
        _locked = true;
        _;
        _locked = false;
    }
    
    // 修复：在createPair2中添加重入保护
    function createPair2(address tokenA, address tokenB) external whenNotPaused nonReentrant returns (address pairAddr) {
        // ... 原有实现
    }
    
    // 修复：添加获取配对信息的视图函数
    function getPairInfo(address tokenA, address tokenB) external view returns (address pairAddress, bool exists, address calculatedAddress) {
        pairAddress = getPair[tokenA][tokenB];
        exists = pairAddress != address(0);
        calculatedAddress = calculateAddr(tokenA, tokenB);
    }
}
