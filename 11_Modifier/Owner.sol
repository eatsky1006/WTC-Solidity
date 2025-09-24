// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Owner {
   address public owner; // 定义owner变量

   // 构造函数 - 添加零地址检查
   constructor(address initialOwner) {
      require(initialOwner != address(0), "Owner: initial owner cannot be zero address");
      owner = initialOwner; // 在部署合约的时候，将owner设置为传入的initialOwner地址
   }

   // 定义modifier
   modifier onlyOwner {
      require(msg.sender == owner, "Owner: caller is not the owner"); // 检查调用者是否为owner地址，添加错误信息
      _; // 如果是的话，继续运行函数主体；否则报错并revert交易
   }

   // 定义一个带onlyOwner修饰符的函数 - 添加零地址检查
   function changeOwner(address _newOwner) external onlyOwner {
      require(_newOwner != address(0), "Owner: new owner cannot be zero address");
      owner = _newOwner; // 只有owner地址运行这个函数，并改变owner
   }

   // 添加事件以便更好的追踪所有权变更
   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
}
