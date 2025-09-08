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
    address payable public _address1;
    // Address members
    uint256 public balance;

    // Fixed-size byte arrays
    bytes32 public _bytes32 = "MiniSolidity"; 
    bytes1 public _byte;

    // Enumeration type
    enum ActionSet { Buy, Hold, Sell }
    ActionSet public action = ActionSet.Buy;

    constructor() payable {
        // Initialize payable address safely
        _address1 = payable(_address);
        
        // Initialize byte value
        _byte = _bytes32[0];
        
        // Get balance - note: this will be 0 unless contract is funded
        balance = address(this).balance;
    }

    // Enum to uint conversion
    function enumToUint() external view returns (uint) {
        return uint(action);
    }

    // Get balance of any address
    function getAddressBalance(address addr) external view returns (uint256) {
        return addr.balance;
    }

    // Function to update enum value
    function setAction(ActionSet newAction) external {
        action = newAction;
    }

    // Function to get byte at specific index with proper bounds checking
    function getByteAtIndex(uint8 index) external view returns (bytes1) {
        require(index < 32, "ValueTypes: index out of bounds");
        return _bytes32[index];
    }

    // Additional utility function to convert bytes32 to string
    function bytes32ToString() external view returns (string memory) {
        // Convert bytes32 to bytes memory first, then to string
        bytes memory bytesArray = new bytes(32);
        for (uint256 i = 0; i < 32; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }

    // Function to receive Ether (makes contract payable)
    receive() external payable {}

    // Function to get contract balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Function to transfer Ether from contract (only owner for security)
    function transferEther(address payable recipient, uint256 amount) external {
        require(amount <= address(this).balance, "ValueTypes: insufficient balance");
        recipient.transfer(amount);
    }
}