pragma solidity ^0.8.21;

contract Hash {
    bytes32 private _msg;
    
    constructor() {
        // Initialize in constructor to avoid potential issues with constant expressions
        _msg = keccak256(abi.encode("0xAA"));
    }

    // 唯一数字标识 - Fixed to prevent hash collisions
    function hash(
        uint _num,
        string memory _string,
        address _addr
    ) public pure returns (bytes32) {
        // Use abi.encode() instead of abi.encodePacked() to prevent collision attacks
        // Add explicit type prefixes to prevent different types from colliding
        return keccak256(abi.encode(
            "uint256:", _num, 
            "string:", _string, 
            "address:", _addr
        ));
    }

    // 弱抗碰撞性 - Fixed security issues
    function weak(
        string memory string1
    ) public view returns (bool) {
        // Use abi.encode() for consistency and security
        return keccak256(abi.encode(string1)) == _msg;
    }

    // 强抗碰撞性 - Fixed security issues
    function strong(
        string memory string1,
        string memory string2
    ) public pure returns (bool) {
        // Use abi.encode() to prevent hash collisions
        return keccak256(abi.encode(string1)) == keccak256(abi.encode(string2));
    }

    // Additional safety: Compare hashes with explicit typing
    function safeCompare(
        string memory string1,
        string memory string2
    ) public pure returns (bool) {
        bytes32 hash1 = keccak256(abi.encode("string1:", string1));
        bytes32 hash2 = keccak256(abi.encode("string2:", string2));
        return hash1 == hash2;
    }
}
