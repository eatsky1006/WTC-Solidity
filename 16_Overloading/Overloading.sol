// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

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
        out = _in;
    }

    // Additional overload examples demonstrating best practices:

    /**
     * @dev Calculate square of a number (uint256 version)
     * @param x The number to square
     * @return result The squared result
     */
    function square(uint256 x) public pure returns (uint256 result) {
        result = x * x;
    }

    /**
     * @dev Calculate square of a number (int256 version)
     * @param x The number to square
     * @return result The squared result
     */
    function square(int256 x) public pure returns (int256 result) {
        result = x * x;
    }

    /**
     * @dev Concatenate two strings
     * @param a First string
     * @param b Second string
     * @return Combined string
     */
    function concatenate(string memory a, string memory b) public pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }

    /**
     * @dev Concatenate three strings
     * @param a First string
     * @param b Second string
     * @param c Third string
     * @return Combined string
     */
    function concatenate(string memory a, string memory b, string memory c) public pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }

    /**
     * @dev Get a greeting with default name
     * @return Greeting message
     */
    function greet() public pure returns (string memory) {
        return "Hello, World!";
    }

    /**
     * @dev Get a personalized greeting
     * @param name The name to include in the greeting
     * @return Personalized greeting message
     */
    function greet(string memory name) public pure returns (string memory) {
        return string(abi.encodePacked("Hello, ", name, "!"));
    }

    // Event for logging function calls
    event FunctionCalled(string functionName, bytes inputData, bytes outputData);

    /**
     * @dev Example function with event logging (uint8 version)
     * @param _in Input value
     * @return out Output value
     */
    function processWithLog(uint8 _in) public returns (uint8 out) {
        out = _in;
        emit FunctionCalled("processWithLog(uint8)", abi.encode(_in), abi.encode(out));
    }

    /**
     * @dev Example function with event logging (uint256 version)
     * @param _in Input value
     * @return out Output value
     */
    function processWithLog(uint256 _in) public returns (uint256 out) {
        out = _in;
        emit FunctionCalled("processWithLog(uint256)", abi.encode(_in), abi.encode(out));
    }
}

/**
 * @title OverloadUsage
 * @dev Example contract showing how to use overloaded functions
 */
contract OverloadUsage {
    Overload public overloadContract;

    constructor() {
        overloadContract = new Overload();
    }

    /**
     * @dev Demonstrate calling different overloaded functions
     * @return defaultMessage Default message from saySomething()
     * @return customMessage Custom message from saySomething(string)
     * @return resultUint8 Result from f(uint8)
     * @return resultUint256 Result from f(uint256)
     */
    function demonstrateOverloading() public view returns (
        string memory defaultMessage,
        string memory customMessage,
        uint8 resultUint8,
        uint256 resultUint256
    ) {
        defaultMessage = overloadContract.saySomething();
        customMessage = overloadContract.saySomething("Something custom");
        
        resultUint8 = overloadContract.f(uint8(42));
        resultUint256 = overloadContract.f(uint256(1000));
    }

    /**
     * @dev Test string concatenation functions
     * @return twoStrings Two strings concatenated
     * @return threeStrings Three strings concatenated
     */
    function testConcatenation() public view returns (
        string memory twoStrings,
        string memory threeStrings
    ) {
        twoStrings = overloadContract.concatenate("Hello", " World");
        threeStrings = overloadContract.concatenate("Hello", " Amazing", " World!");
    }

    /**
     * @dev Test greeting functions
     * @return defaultGreeting Default greeting
     * @return personalizedGreeting Personalized greeting
     */
    function testGreetings() public view returns (
        string memory defaultGreeting,
        string memory personalizedGreeting
    ) {
        defaultGreeting = overloadContract.greet();
        personalizedGreeting = overloadContract.greet("Alice");
    }

    /**
     * @dev Test square functions with different types
     * @return uintSquare Square of uint256
     * @return intSquare Square of int256
     */
    function testSquares() public view returns (
        uint256 uintSquare,
        int256 intSquare
    ) {
        uintSquare = overloadContract.square(5);
        intSquare = overloadContract.square(-5);
    }
}
