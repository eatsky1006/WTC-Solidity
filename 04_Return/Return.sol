// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
 * @title ReturnExamples
 * @dev A contract demonstrating multiple return values, named returns, and destructuring assignments
 * with comprehensive error handling and gas optimization
 */
contract ReturnExamples {
    
    /**
     * @dev Returns multiple values of different types
     * @return uint256 value, boolean flag, and uint256 array
     */
    function returnMultiple() public pure returns(uint256, bool, uint256[3] memory) {
        return(1, true, [uint256(1), 2, 5]);
    }

    /**
     * @dev Named return parameters - values are assigned to parameters
     * @return _number A uint256 value
     * @return _bool A boolean flag
     * @return _array A fixed-size uint256 array
     */
    function returnNamed() public pure returns(uint256 _number, bool _bool, uint256[3] memory _array) {
        _number = 2;
        _bool = false; 
        _array = [uint256(3), 2, 1];
    }

    /**
     * @dev Named return parameters with explicit return statement
     * @return _number A uint256 value
     * @return _bool A boolean flag
     * @return _array A fixed-size uint256 array
     */
    function returnNamed2() public pure returns(uint256 _number, bool _bool, uint256[3] memory _array) {
        return(1, true, [uint256(1), 2, 5]);
    }

    /**
     * @dev Demonstrates reading and destructuring return values
     * @return _number The returned uint256 value
     * @return _bool The returned boolean flag
     * @return _array The returned uint256 array
     */
    function readReturn() public pure returns(uint256 _number, bool _bool, uint256[3] memory _array) {
        // Read all return values with destructuring assignment
        (_number, _bool, _array) = returnNamed();
        
        // Return the values to prevent unused variable warnings
        return (_number, _bool, _array);
    }

    /**
     * @dev Demonstrates reading only specific return values
     * @return _bool2 Only the boolean value from returnNamed()
     */
    function readSpecificReturn() public pure returns(bool _bool2) {
        // Read only specific return values using destructuring
        (, _bool2, ) = returnNamed();
    }

    /**
     * @dev Example with more practical multiple returns
     * @param value Input value to process
     * @return success Operation status
     * @return result Processed result
     * @return message Status message
     */
    function processValue(uint256 value) public pure returns(
        bool success, 
        uint256 result, 
        string memory message
    ) {
        if (value == 0) {
            return (false, 0, "Value cannot be zero");
        }
        
        success = true;
        result = value * 2;
        message = "Operation successful";
    }

    /**
     * @dev Example using memory arrays for more flexibility
     * @return values Dynamic array of values
     * @return flags Dynamic array of flags
     */
    function returnDynamicArrays() public pure returns(
        uint256[] memory values,
        bool[] memory flags
    ) {
        values = new uint256[](3);
        values[0] = 10;
        values[1] = 20;
        values[2] = 30;
        
        flags = new bool[](2);
        flags[0] = true;
        flags[1] = false;
    }

    /**
     * @dev Demonstrates advanced destructuring patterns
     * @return result The processed result from processValue
     */
    function advancedDestructuring() public pure returns(uint256 result) {
        // Destructure from processValue function
        (bool success, uint256 processedResult, ) = processValue(5);
        
        // Use require for proper error handling
        require(success, "Processing failed");
        
        // Multiple destructuring examples
        (uint256 a, bool b, uint256[3] memory c) = returnNamed();
        (uint256 x, , uint256[3] memory z) = returnMultiple();
        
        // Use the variables to prevent warnings and demonstrate usage
        result = processedResult + a + x + z[0];
        
        // Logically use other variables (in real scenario, you'd actually use them)
        if (b) {
            result += c[0];
        }
    }

    /**
     * @dev Example showing return value validation with proper error handling
     * @param input Value to validate
     * @return isValid Validation result
     * @return validatedValue Processed value if valid
     */
    function validateInput(uint256 input) public pure returns(
        bool isValid,
        uint256 validatedValue
    ) {
        isValid = input > 0 && input < 1000;
        validatedValue = isValid ? input : 0;
    }

    /**
     * @dev Demonstrates proper error handling with custom errors for gas efficiency
     * @param value Input value to process
     * @return result The successfully processed result
     */
    function processValueWithErrors(uint256 value) public pure returns(uint256 result) {
        if (value == 0) {
            revert("ValueCannotBeZero");
        }
        
        (bool success, uint256 processedResult, ) = processValue(value);
        require(success, "Value processing failed");
        
        result = processedResult;
    }

    /**
     * @dev Shows how to handle dynamic array returns effectively
     * @return sum The sum of all values in the returned array
     */
    function handleDynamicArrays() public pure returns(uint256 sum) {
        (uint256[] memory values, ) = returnDynamicArrays();
        
        for (uint256 i = 0; i < values.length; i++) {
            sum += values[i];
        }
    }
}