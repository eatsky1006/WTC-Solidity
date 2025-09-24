// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Overload {
    // Overloaded saySomething functions
    function saySomething() public pure returns(string memory) {
        return "Nothing";
    }

    function saySomething(string memory something) public pure returns(string memory) {
        require(bytes(something).length > 0, "Input string cannot be empty");
        return something;
    }

    // Overloaded f functions with explicit casting and bounds checking
    function f(uint8 _in) public pure returns (uint8 out) {
        out = _in;
    }

    function f(uint256 _in) public pure returns (uint256 out) {
        // Ensure the value fits in uint256 (always true for uint256 param, but good practice)
        require(_in <= type(uint256).max, "Value too large");
        out = _in;
    }

    // Additional utility function to demonstrate which overload is called
    function testOverloads() public pure returns (string memory, string memory, uint8, uint256) {
        return (
            saySomething(),
            saySomething("Hello World"),
            f(uint8(42)),
            f(uint256(1000))
        );
    }
}
