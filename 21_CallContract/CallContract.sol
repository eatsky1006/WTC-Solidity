// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract OtherContract {
    uint256 private _x = 0; // 状态变量x
    
    // 收到eth事件，记录amount和gas
    event Log(uint amount, uint gas);
    
    // 返回合约ETH余额
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    // 可以调整状态变量_x的函数，并且可以往合约转ETH (payable)
    function setX(uint256 x) external payable {
        _x = x;
        // 如果转入ETH，则释放Log事件
        if(msg.value > 0){
            emit Log(msg.value, gasleft());
        }
    }

    // 读取x
    function getX() external view returns(uint x){
        x = _x;
    }
    
    // 添加：接收ETH的函数
    receive() external payable {}
}

contract CallContract {
    // 添加事件记录重要操作
    event CallOperation(address indexed target, address indexed caller, string operation, uint256 value);
    
    // 修复：参数命名规范，添加地址验证
    function callSetX(address targetAddress, uint256 x) external {
        require(targetAddress != address(0), "Invalid contract address");
        require(targetAddress.code.length > 0, "Target is not a contract");
        
        OtherContract(targetAddress).setX(x);
        emit CallOperation(targetAddress, msg.sender, "callSetX", 0);
    }

    // 修复：参数命名避免混淆
    function callGetX(OtherContract targetContract) external view returns(uint x) {
        x = targetContract.getX();
    }

    // 修复：参数命名规范，添加地址验证
    function callGetX2(address targetAddress) external view returns(uint x) {
        require(targetAddress != address(0), "Invalid contract address");
        require(targetAddress.code.length > 0, "Target is not a contract");
        
        OtherContract oc = OtherContract(targetAddress);
        x = oc.getX();
    }

    // 修复：添加安全检查
    function setXTransferETH(address otherContract, uint256 x) external payable {
        require(otherContract != address(0), "Invalid contract address");
        require(otherContract.code.length > 0, "Target is not a contract");
        require(msg.value > 0, "ETH value must be greater than 0");
        
        OtherContract(otherContract).setX{value: msg.value}(x);
        emit CallOperation(otherContract, msg.sender, "setXTransferETH", msg.value);
    }
    
    // 添加：安全提取函数（防止ETH被意外锁定）
    function withdraw() external {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");
        payable(msg.sender).transfer(balance);
    }
    
    // 添加：接收ETH的函数
    receive() external payable {}
    
    // 添加：获取合约余额
    function getContractBalance() external view returns(uint) {
        return address(this).balance;
    }
}
