// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Events {
    // 定义_balances映射变量，记录每个地址的持币数量
    mapping(address => uint256) public _balances;
    
    // 添加合约所有者
    address public owner;

    // 定义Transfer event，记录transfer交易的转账地址，接收地址和转账数量
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 构造函数，设置合约所有者
    constructor() {
        owner = msg.sender;
    }

    // 修饰符，限制只有所有者可以调用
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    // 初始化余额函数，只有所有者可以调用
    function initializeBalance(address account, uint256 amount) external onlyOwner {
        _balances[account] = amount;
    }

    // 定义_transfer函数，执行转账逻辑 - 改为internal
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(from != address(0), "Transfer from zero address");
        require(to != address(0), "Transfer to zero address");
        require(amount > 0, "Transfer amount must be positive");
        require(_balances[from] >= amount, "Insufficient balance");

        _balances[from] -= amount; // from地址减去转账数量
        _balances[to] += amount; // to地址加上转账数量

        // 释放事件
        emit Transfer(from, to, amount);
    }

    // 外部转账函数，用户可以调用
    function transfer(address to, uint256 amount) external {
        _transfer(msg.sender, to, amount);
    }

    // 所有者可以代转账（如果需要）
    function transferFrom(address from, address to, uint256 amount) external onlyOwner {
        _transfer(from, to, amount);
    }
}
