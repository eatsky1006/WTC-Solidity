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
=======
/**
 * @title Overload
 * @dev A contract demonstrating function overloading with best practices
 */
contract Overload {
    /**
     * @dev Default saySomething function with no parameters
     * @return string A default message
     */
    function saySomething() public pure returns (string memory) {
        return "Nothing";
    }

    /**
     * @dev Overloaded saySomething function with a custom message
     * @param something The custom message to return
     * @return string The custom message provided
     */
    function saySomething(string memory something) public pure returns (string memory) {
        return something;
    }

    /**
     * @dev Process a uint8 input value
     * @param _in The input value (uint8)
     * @return out The same uint8 value
     */
    function f(uint8 _in) public pure returns (uint8 out) {
        out = _in;
    }

    /**
     * @dev Process a uint256 input value
     * @param _in The input value (uint256)
     * @return out The same uint256 value
     */
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
