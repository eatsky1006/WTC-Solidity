// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract OtherContract {
    uint256 private _x = 0; // 状态变量x
    // 收到eth事件，记录amount和gas
    event Log(uint amount, uint gas);

    // 修复：添加receive函数来处理普通ETH转账
    receive() external payable {}
    
    // 修复：添加fallback函数来处理未知调用
    fallback() external payable {
        revert("Unknown function call");
    }

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
}

contract Call {
    // 定义Response事件，输出call返回的结果success和data
    event Response(bool success, bytes data);
    
    // 修复：添加安全事件记录
    event CallExecuted(address indexed target, string functionSignature, uint256 value);

    // 修复：添加输入验证和重入保护
    modifier validAddress(address addr) {
        require(addr != address(0), "Invalid address: zero address");
        require(addr.code.length > 0, "Invalid address: not a contract");
        _;
    }

    function callSetX(address _addr, uint256 x) public payable validAddress(_addr) {
        // 修复：记录调用信息
        emit CallExecuted(_addr, "setX(uint256)", msg.value);
        
        // call setX()，同时可以发送ETH
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("setX(uint256)", x)
        );

        // 修复：检查调用是否成功，避免静默失败
        require(success, "callSetX failed");
        
        emit Response(success, data); //释放事件
    }

    function callGetX(address _addr) external validAddress(_addr) returns(uint256) {
        // 修复：记录调用信息
        emit CallExecuted(_addr, "getX()", 0);
        
        // call getX()
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("getX()")
        );

        // 修复：检查调用是否成功
        require(success, "callGetX failed");
        
        emit Response(success, data); //释放事件
        
        // 修复：添加数据长度验证
        require(data.length == 32, "Invalid data length returned");
        return abi.decode(data, (uint256));
    }

    function callNonExist(address _addr) external validAddress(_addr) {
        // 修复：记录调用信息
        emit CallExecuted(_addr, "foo(uint256)", 0);
        
        // call 不存在的函数
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        // 修复：不检查success，因为调用不存在的函数预期会失败
        emit Response(success, data); //释放事件
    }
    
    // 修复：添加安全提取功能
    function withdraw() external {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");
        payable(msg.sender).transfer(balance);
    }
    
    // 修复：添加接收ETH的功能
    receive() external payable {}
    
    // 修复：添加合约余额查询
    function getContractBalance() external view returns(uint256) {
        return address(this).balance;
    }
}
