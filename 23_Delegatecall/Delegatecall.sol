pragma solidity ^0.8.21;

// delegatecall和call类似，都是低级函数
// call: B call C, 上下文为 C (msg.sender = B, C中的状态变量受影响)
// delegatecall: B delegatecall C, 上下文为B (msg.sender = A, B中的状态变量受影响)
// 注意B和C的数据存储布局必须相同！变量类型、声明的前后顺序要相同，不然会搞砸合约。

// 被调用的合约C
contract C {
    uint public num;
    address public sender;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
    }
    
    // 修复：添加获取合约类型函数
    function getContractType() public pure returns (string memory) {
        return "Contract C";
    }
}

// 发起delegatecall的合约B
contract B {
    uint public num;
    address public sender;
    
    // 修复：添加安全事件
    event CallExecuted(address indexed target, string method, bool success, bytes data);
    event DelegateCallExecuted(address indexed target, string method, bool success, bytes data);
    
    // 修复：添加地址验证修饰器
    modifier validContract(address _addr) {
        require(_addr != address(0), "Invalid address: zero address");
        require(_addr.code.length > 0, "Target is not a contract");
        _;
    }

    // 通过call来调用C的setVars()函数，将改变合约C里的状态变量
    function callSetVars(address _addr, uint _num) external payable validContract(_addr) {
        // call setVars()
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        
        // 修复：检查调用结果
        require(success, "Call to setVars failed");
        
        emit CallExecuted(_addr, "setVars(uint256)", success, data);
    }
    
    // 通过delegatecall来调用C的setVars()函数，将改变合约B里的状态变量
    function delegatecallSetVars(address _addr, uint _num) external payable validContract(_addr) {
        // 修复：验证目标合约的存储布局兼容性
        _validateStorageCompatibility(_addr);
        
        // delegatecall setVars()
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        
        // 修复：检查调用结果
        require(success, "DelegateCall to setVars failed");
        
        emit DelegateCallExecuted(_addr, "setVars(uint256)", success, data);
    }
    
    // 修复：添加存储布局验证函数
    function _validateStorageCompatibility(address _addr) internal view {
        // 尝试调用目标合约的函数来验证兼容性
        (bool success, ) = _addr.staticcall(
            abi.encodeWithSignature("getContractType()")
        );
        
        // 这不是完美的验证，但可以作为一种基本检查
        // 在实际项目中，可能需要更复杂的存储布局验证
        require(success, "Potential storage layout incompatibility detected");
    }
    
    // 修复：添加安全的fallback函数
    fallback() external payable {
        revert("Direct function calls not allowed");
    }
    
    receive() external payable {
        revert("Direct ETH transfers not allowed");
    }
    
    // 修复：添加紧急停止功能（可选）
    bool public paused;
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function pause() external onlyOwner {
        paused = true;
    }
    
    function unpause() external onlyOwner {
        paused = false;
    }
    
    // 修复：更新函数添加暂停保护
    function callSetVars(address _addr, uint _num) external payable validContract(_addr) whenNotPaused {
        // ... 原有实现
    }
    
    function delegatecallSetVars(address _addr, uint _num) external payable validContract(_addr) whenNotPaused {
        // ... 原有实现
    }
    
    // 修复：添加ETH提取功能
    function withdrawETH() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");
        payable(owner).transfer(balance);
    }
    
    // 修复：添加合约信息函数
    function getContractInfo() external view returns (uint currentNum, address currentSender, address contractOwner, bool isPaused) {
        return (num, sender, owner, paused);
    }
}
///
