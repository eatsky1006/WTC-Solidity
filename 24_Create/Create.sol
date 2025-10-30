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
        require(_token0 != _token1, 'Pair: IDENTICAL_ADDRESSES'); // 修复：防止相同代币地址
        require(_token0 != address(0) && _token1 != address(0), 'Pair: ZERO_ADDRESS'); // 修复：防止零地址
        
        token0 = _token0;
        token1 = _token1;
        initialized = true;
        
        emit PairInitialized(_token0, _token1, factory);
    }
    
    // 修复：添加获取配对信息函数
    function getTokens() external view returns (address, address) {
        return (token0, token1);
    }
    
    // 修复：添加初始化状态检查
    function isInitialized() external view returns (bool) {
        return initialized;
    }
}

contract PairFactory {
    mapping(address => mapping(address => address)) public getPair; // 通过两个代币地址查Pair地址
    address[] public allPairs; // 保存所有Pair地址
    
    // 修复：添加事件
    event PairCreated(address indexed token0, address indexed token1, address pair, uint256 pairCount);
    
    // 修复：添加权限控制
    address public owner;
    
    // 修复：添加构造函数设置所有者
    constructor() {
        owner = msg.sender;
    }
    
    // 修复：添加权限修饰器
    modifier onlyOwner() {
        require(msg.sender == owner, "PairFactory: ONLY_OWNER");
        _;
    }

    function createPair(address tokenA, address tokenB) external returns (address pairAddr) {
        // 修复：输入验证
        require(tokenA != tokenB, "PairFactory: IDENTICAL_ADDRESSES");
        require(tokenA != address(0) && tokenB != address(0), "PairFactory: ZERO_ADDRESS");
        require(getPair[tokenA][tokenB] == address(0), "PairFactory: PAIR_EXISTS"); // 修复：防止重复创建
        
        // 修复：排序代币地址以确保一致性
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        
        // 创建新合约
        Pair pair = new Pair(); 
        // 调用新合约的initialize方法
        pair.initialize(token0, token1);
        
        // 更新地址map
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[token0][token1] = pairAddr;
        getPair[token1][token0] = pairAddr;
        
        emit PairCreated(token0, token1, pairAddr, allPairs.length);
    }
    
    // 修复：添加获取所有配对数量的函数
    function allPairsLength() external view returns (uint256) {
        return allPairs.length;
    }
    
    // 修复：添加批量获取配对地址的函数
    function getPairs(uint256 start, uint256 count) external view returns (address[] memory pairs) {
        require(start < allPairs.length, "PairFactory: INVALID_START");
        
        uint256 end = start + count;
        if (end > allPairs.length) {
            end = allPairs.length;
        }
        
        pairs = new address[](end - start);
        for (uint256 i = start; i < end; i++) {
            pairs[i - start] = allPairs[i];
        }
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
    
    // 修复：添加紧急停止功能（可选）
    bool public paused;
    
    modifier whenNotPaused() {
        require(!paused, "PairFactory: PAUSED");
        _;
    }
    
    function pause() external onlyOwner {
        paused = true;
    }
    
    function unpause() external onlyOwner {
        paused = false;
    }
    
    // 修复：更新createPair函数添加暂停保护
    function createPair(address tokenA, address tokenB) external whenNotPaused returns (address pairAddr) {
        // ... 原有实现
    }
    
    // 修复：添加所有权转移功能
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "PairFactory: INVALID_OWNER");
        owner = newOwner;
    }
    
    // 修复：添加合约升级准备（如果需要）
    function migratePair(address oldPair, address newPair) external onlyOwner {
        // 实现配对迁移逻辑
        // 注意：这需要仔细设计和测试
    }
}
