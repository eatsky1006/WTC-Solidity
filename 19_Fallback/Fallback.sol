// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Fallback {
    /* 触发fallback() 还是 receive()?
           接收ETH
              |
         msg.data是空？
            /  \
          是    否
          /      \
receive()存在?   fallback()
        / \
       是  否
      /     \
receive()  fallback()   
    */

    // 定义事件
    event ReceivedCalled(address Sender, uint Value);
    event FallbackCalled(address Sender, uint Value, bytes Data);

    // 接收ETH时释放ReceivedCalled事件
    receive() external payable {
        emit ReceivedCalled(msg.sender, msg.value);
    }

    // fallback
    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value, msg.data);
    }
    
    // 辅助函数：获取合约余额
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
