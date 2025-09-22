// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
 * @title Strings
 * @dev String operations library with enhanced functionality and security
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    
    /**
     * @dev Error for insufficient hexadecimal length
     */
    error HexLengthInsufficient();

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     * @param value The uint256 value to convert
     * @return string The decimal string representation
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        
        uint256 temp = value;
        uint256 digits;
        
        // Calculate number of digits
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        
        bytes memory buffer = new bytes(digits);
        
        // Build the string from right to left
        temp = value;
        for (uint256 i = digits; i > 0; ) {
            unchecked {
                buffer[--i] = bytes1(uint8(48 + (temp % 10)));
                temp /= 10;
            }
        }
        
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     * @param value The uint256 value to convert
     * @return string The hexadecimal string representation with "0x" prefix
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        
        uint256 temp = value;
        uint256 length = 0;
        
        // Calculate required length
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     * @param value The uint256 value to convert
     * @param length The fixed length of the hexadecimal output (in bytes)
     * @return string The hexadecimal string representation with "0x" prefix
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        // Validate input
        if (length == 0) {
            return "0x";
        }
        
        // Check if the value fits in the specified length
        uint256 maxValue = (1 << (8 * length)) - 1;
        if (value > maxValue) {
            revert HexLengthInsufficient();
        }
        
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        
        // Convert each byte to hex characters
        for (uint256 i = 2 * length + 1; i > 1; ) {
            unchecked {
                buffer[i] = _HEX_SYMBOLS[value & 0xf];
                value >>= 4;
                i--;
            }
        }
        
        return string(buffer);
    }

    /**
     * @dev Converts an `address` to its ASCII `string` hexadecimal representation.
     * @param addr The address to convert
     * @return string The hexadecimal string representation
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), 20);
    }

    /**
     * @dev Concatenates two strings
     * @param a First string
     * @param b Second string
     * @return result Concatenated string
     */
    function concat(string memory a, string memory b) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }

    /**
     * @dev Checks if two strings are equal
     * @param a First string
     * @param b Second string
     * @return bool True if strings are equal
     */
    function equal(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}

/**
 * @title UseLibrary
 * @dev Contract demonstrating different ways to use library functions
 */
contract UseLibrary {
    // Using the library for uint256 type
    using Strings for uint256;
    
    /**
     * @dev Get hexadecimal string using using-for syntax
     * @param _number The number to convert
     * @return string Hexadecimal representation
     */
    function getString1(uint256 _number) public pure returns (string memory) {
        // Library function is automatically available as a member of uint256
        return _number.toHexString();
    }

    /**
     * @dev Get hexadecimal string using direct library call
     * @param _number The number to convert
     * @return string Hexadecimal representation
     */
    function getString2(uint256 _number) public pure returns (string memory) {
        return Strings.toHexString(_number);
    }

    /**
     * @dev Get decimal string representation
     * @param _number The number to convert
     * @return string Decimal representation
     */
    function getDecimalString(uint256 _number) public pure returns (string memory) {
        return _number.toString();
    }

    /**
     * @dev Get address as hexadecimal string
     * @param _addr The address to convert
     * @return string Hexadecimal representation
     */
    function getAddressString(address _addr) public pure returns (string memory) {
        return Strings.toHexString(_addr);
    }

    /**
     * @dev Get fixed-length hexadecimal string
     * @param _number The number to convert
     * @param _length The fixed length in bytes
     * @return string Hexadecimal representation
     */
    function getFixedLengthHex(uint256 _number, uint256 _length) public pure returns (string memory) {
        return Strings.toHexString(_number, _length);
    }

    /**
     * @dev Concatenate two strings using library
     * @param a First string
     * @param b Second string
     * @return string Concatenated result
     */
    function concatenateStrings(string memory a, string memory b) public pure returns (string memory) {
        return Strings.concat(a, b);
    }

    /**
     * @dev Compare two strings for equality
     * @param a First string
     * @param b Second string
     * @return bool True if strings are equal
     */
    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return Strings.equal(a, b);
    }

    /**
     * @dev Example showing multiple library usage patterns
     * @param number Input number
     * @return dec Decimal string
     * @return hex Hex string
     * @return fixedHex Fixed length hex string
     */
    function getAllRepresentations(uint256 number) public pure returns (
        string memory dec,
        string memory hex,
        string memory fixedHex
    ) {
        dec = number.toString();
        hex = number.toHexString();
        fixedHex = Strings.toHexString(number, 4); // 4 bytes fixed length
    }
}
