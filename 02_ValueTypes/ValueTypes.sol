// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract ValueTypes {
    // Boolean values
    bool public _bool = true;
    // Boolean operations
    bool public _bool1 = !_bool;        // Logical NOT
    bool public _bool2 = _bool && _bool1; // Logical AND
    bool public _bool3 = _bool || _bool1; // Logical OR
    bool public _bool4 = _bool == _bool1; // Equality
    bool public _bool5 = _bool != _bool1; // Inequality

    // Integer types
    int public _int = -1;
    uint public _uint = 1;
    uint256 public _number = 20220330;
    // Integer operations
    uint256 public _number1 = _number + 1;  // Addition
    uint256 public _number2 = 2 ** 2;       // Exponentiation
    uint256 public _number3 = 7 % 2;        // Modulo
    bool public _numberBool = _number2 > _number3; // Comparison

    // Address types
    address public _address = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    address payable public _address1 = payable(_address); // Payable address for transfers
    // Address members
    uint256 public balance; // Will be set in constructor

    // Fixed-size byte arrays
    bytes32 public _bytes32 = "MiniSolidity"; 
    bytes1 public _byte = _bytes32[0]; // First byte

    // Enumeration type
    enum ActionSet { Buy, Hold, Sell }
    ActionSet public action = ActionSet.Buy; // Made public for visibility

    constructor() {
        // Initialize balance in constructor to avoid gas costs on deployment
        balance = _address1.balance;
    }

    // Enum to uint conversion with explicit visibility
    function enumToUint() external view returns (uint) {
        return uint(action);
    }

    // Additional utility function to demonstrate address functionality
    function getAddressBalance(address addr) external view returns (uint256) {
        return addr.balance;
    }

    // Function to update enum value
    function setAction(ActionSet newAction) external {
        action = newAction;
    }

    // Function to demonstrate byte array manipulation
    function getByteAtIndex(uint8 index) external view returns (bytes1) {
        require(index < 32, "Index out of bounds");
        return _bytes32[index];
    }
}

