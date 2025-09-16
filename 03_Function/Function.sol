// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
 * @title FunctionTypes
 * @dev A contract demonstrating different function types and modifiers in Solidity
 */
contract FunctionTypes {
    uint256 public number = 5;
    
    /**
     * @dev Constructor that can receive ETH
     */
    constructor() payable {}

    /**
     * @dev Default external function that modifies state
     */
    function add() external {
        number += 1;
    }

    /**
     * @dev Pure function - no state access, only parameters and computation
     * @param _number Input number to increment
     * @return new_number The input number plus one
     */
    function addPure(uint256 _number) external pure returns(uint256 new_number) {
        new_number = _number + 1;
    }
    
    /**
     * @dev View function - reads state but doesn't modify it
     * @return new_number Current number plus one
     */
    function addView() external view returns(uint256 new_number) {
        new_number = number + 1;
    }

    /**
     * @dev Internal function - can only be called within contract
     */
    function minus() internal {
        // Add underflow protection (though Solidity 0.8+ has built-in checks)
        require(number > 0, "Number cannot be negative");
        number -= 1;
    }

    /**
     * @dev External function that calls internal function
     */
    function minusCall() external {
        minus();
    }

    /**
     * @dev Payable function - can receive ETH and returns contract balance
     * @return balance The current contract balance in wei
     */
    function minusPayable() external payable returns(uint256 balance) {
        minus();    
        balance = address(this).balance;
    }

    /**
     * @dev Get current contract balance
     * @return Current ETH balance of the contract
     */
    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }

    /**
     * @dev Example of a private function (even more restricted than internal)
     */
    function resetNumber() private {
        number = 0;
    }

    /**
     * @dev Function to demonstrate private function call
     */
    function reset() external {
        resetNumber();
    }

    /**
     * @dev Example function with multiple return values
     * @return currentNumber Current stored number
     * @return contractBalance Current contract balance
     */
    function getStats() external view returns(uint256 currentNumber, uint256 contractBalance) {
        currentNumber = number;
        contractBalance = address(this).balance;
    }
}