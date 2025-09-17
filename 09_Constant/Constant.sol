// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title Advanced Constant and Immutable Demo
/// @notice Demonstrates best practices for using constant and immutable variables
/// @dev Shows gas optimization techniques and proper initialization patterns
contract Constant {
    // Constant variables - must be initialized at declaration
    uint256 public constant CONSTANT_NUM = 10;
    string public constant CONSTANT_STRING = "0xAA";
    bytes public constant CONSTANT_BYTES = "WTF";
    address public constant CONSTANT_ADDRESS = address(0);
    bytes32 public constant CONSTANT_HASH = keccak256(abi.encodePacked("WTF_Academy"));
    
    // Compile-time constant expressions (more gas efficient)
    uint256 public constant CONSTANT_EXPRESSION = 2 ** 64 - 1;
    uint256 public constant GWEI_PER_ETHER = 1e9;
    uint256 public constant WEI_PER_ETHER = 1e18;

    // Immutable variables - initialized in constructor
    uint256 public immutable IMMUTABLE_NUM;
    address public immutable IMMUTABLE_ADDRESS;
    uint256 public immutable IMMUTABLE_BLOCK;
    uint256 public immutable IMMUTABLE_TIMESTAMP;
    string public immutable IMMUTABLE_NAME;
    bytes32 public immutable IMMUTABLE_CREATION_HASH;
    uint256 public immutable IMMUTABLE_CHAIN_ID;

    // Packed immutable variables for gas efficiency
    uint128 public immutable IMMUTABLE_PACKED_A;
    uint128 public immutable IMMUTABLE_PACKED_B;

    // Error definitions
    error InvalidName();
    error Unauthorized();

    // Events
    event ContractInitialized(string name, uint256 blockNumber, uint256 timestamp);
    event GasSaved(uint256 savedAmount, string operation);

    /// @notice Constructor initializes all immutable variables
    /// @param name_ The name for this contract instance
    constructor(string memory name_) {
        // Input validation
        if (bytes(name_).length == 0 || bytes(name_).length > 32) {
            revert InvalidName();
        }

        // Initialize immutable variables
        IMMUTABLE_NUM = 1118;
        IMMUTABLE_ADDRESS = address(this);
        IMMUTABLE_BLOCK = block.number;
        IMMUTABLE_TIMESTAMP = block.timestamp;
        IMMUTABLE_NAME = name_;
        IMMUTABLE_CREATION_HASH = keccak256(
            abi.encodePacked(blockhash(block.number - 1), block.timestamp, msg.sender)
        );
        IMMUTABLE_CHAIN_ID = block.chainid;
        
        // Packed immutables example
        IMMUTABLE_PACKED_A = uint128(block.timestamp % 2**128);
        IMMUTABLE_PACKED_B = uint128(block.number % 2**128);

        emit ContractInitialized(name_, block.number, block.timestamp);
    }

    // ============ CONSTANT FUNCTIONS ============

    /// @notice Get all constant values in a single call
    function getConstants() public pure returns (
        uint256 constantNum,
        string memory constantString,
        bytes memory constantBytes,
        address constantAddress,
        bytes32 constantHash,
        uint256 constantExpression
    ) {
        return (
            CONSTANT_NUM,
            CONSTANT_STRING,
            CONSTANT_BYTES,
            CONSTANT_ADDRESS,
            CONSTANT_HASH,
            CONSTANT_EXPRESSION
        );
    }

    /// @notice Calculate using constant (most gas efficient)
    function calculateWithConstant(uint256 input) public pure returns (uint256) {
        uint256 result = input * CONSTANT_NUM;
        emit GasSaved(2000, "constant multiplication");
        return result;
    }

    // ============ IMMUTABLE FUNCTIONS ============

    /// @notice Get all immutable values in a single call
    function getImmutables() public view returns (
        uint256 immutableNum,
        address immutableAddress,
        uint256 immutableBlock,
        uint256 immutableTimestamp,
        string memory immutableName,
        bytes32 immutableCreationHash,
        uint256 immutableChainId,
        uint128 immutablePackedA,
        uint128 immutablePackedB
    ) {
        return (
            IMMUTABLE_NUM,
            IMMUTABLE_ADDRESS,
            IMMUTABLE_BLOCK,
            IMMUTABLE_TIMESTAMP,
            IMMUTABLE_NAME,
            IMMUTABLE_CREATION_HASH,
            IMMUTABLE_CHAIN_ID,
            IMMUTABLE_PACKED_A,
            IMMUTABLE_PACKED_B
        );
    }

    /// @notice Calculate using immutable (gas efficient)
    function calculateWithImmutable(uint256 input) public view returns (uint256) {
        uint256 result = input * IMMUTABLE_NUM;
        emit GasSaved(1500, "immutable multiplication");
        return result;
    }

    // ============ VERIFICATION & UTILITY FUNCTIONS ============

    /// @notice Verify contract integrity
    function verifyContractInfo() public view returns (bool isIntegrityValid) {
        isIntegrityValid = 
            IMMUTABLE_ADDRESS == address(this) &&
            IMMUTABLE_BLOCK <= block.number &&
            IMMUTABLE_TIMESTAMP <= block.timestamp &&
            IMMUTABLE_CHAIN_ID == block.chainid;
        
        return isIntegrityValid;
    }

    /// @notice Get contract creation information
    function getCreationInfo() public view returns (
        uint256 creationBlock,
        uint256 creationTimestamp,
        string memory contractName,
        address contractAddress,
        uint256 chainId
    ) {
        return (
            IMMUTABLE_BLOCK,
            IMMUTABLE_TIMESTAMP,
            IMMUTABLE_NAME,
            IMMUTABLE_ADDRESS,
            IMMUTABLE_CHAIN_ID
        );
    }

    /// @notice Get contract age information
    function getContractAge() public view returns (
        uint256 ageInBlocks,
        uint256 ageInSeconds,
        uint256 currentChainId
    ) {
        return (
            block.number - IMMUTABLE_BLOCK,
            block.timestamp - IMMUTABLE_TIMESTAMP,
            block.chainid
        );
    }

    // ============ GAS OPTIMIZATION DEMONSTRATION ============

    /// @notice Demonstrate gas difference between storage and immutable
    function demonstrateGasSavings() public view returns (
        uint256 constantGasExample,
        uint256 immutableGasExample,
        uint256 storageGasExample
    ) {
        // These would be measured in actual gas usage tests
        return (100, 200, 2500); // Example gas costs
    }

    /// @notice Show packed immutables usage
    function getPackedImmutables() public view returns (uint256 packedValue) {
        // Demonstrating how packed immutables can be used
        return uint256(IMMUTABLE_PACKED_A) << 128 | uint256(IMMUTABLE_PACKED_B);
    }

    // ============ PURE/VIEW HELPERS ============

    /// @notice Pure function example using only constants
    function convertEthToWei(uint256 ethAmount) public pure returns (uint256 weiAmount) {
        return ethAmount * WEI_PER_ETHER;
    }

    /// @notice Pure function example using only constants
    function convertEthToGwei(uint256 ethAmount) public pure returns (uint256 gweiAmount) {
        return ethAmount * GWEI_PER_ETHER;
    }

    /// @notice View function using immutables
    function isOnSameChain() public view returns (bool) {
        return IMMUTABLE_CHAIN_ID == block.chainid;
    }

    // ============ FALLBACK & RECEIVE ============

    receive() external payable {
        // Accept ETH
    }

    fallback() external payable {
        revert("Function not implemented");
    }

    // ============ CONTRACT METADATA ============

    /// @notice Get contract version and info
    function getContractMetadata() public pure returns (
        string memory name,
        string memory version,
        string memory description
    ) {
        return (
            "AdvancedConstantDemo",
            "1.0.0",
            "Demonstrates best practices for constant and immutable variables"
        );
    }

    /// @notice Estimate gas savings explanation
    function getGasSavingsInfo() public pure returns (string memory info) {
        return "Constants: 0 gas (compile-time), Immutables: ~100 gas, Storage: ~2000+ gas";
    }
}
