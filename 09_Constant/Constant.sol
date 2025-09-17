// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Constant {
    // constant变量必须在声明的时候初始化，之后不能改变
    uint256 public constant CONSTANT_NUM = 10;
    string public constant CONSTANT_STRING = "0xAA";
    bytes public constant CONSTANT_BYTES = "WTF";
    address public constant CONSTANT_ADDRESS = 0x0000000000000000000000000000000000000000;
    bytes32 public constant CONSTANT_HASH = keccak256(abi.encodePacked("WTF_Academy"));

    // immutable变量可以在constructor里初始化，之后不能改变
    uint256 public immutable IMMUTABLE_NUM;
    address public immutable IMMUTABLE_ADDRESS;
    uint256 public immutable IMMUTABLE_BLOCK;
    uint256 public immutable IMMUTABLE_TEST;
    uint256 public immutable IMMUTABLE_TIMESTAMP;
    string public immutable IMMUTABLE_NAME;
    bytes32 public immutable IMMUTABLE_CREATION_HASH;

    // 错误定义
    error AlreadyInitialized();
    error InvalidValue();

    // 事件
    event ImmutableInitialized(string name, uint256 blockNumber, uint256 timestamp);

    // 利用constructor初始化immutable变量
    constructor(string memory name_){
        // 检查输入有效性
        if (bytes(name_).length == 0) {
            revert InvalidValue();
        }

        // 初始化immutable变量
        IMMUTABLE_NUM = 1118;
        IMMUTABLE_ADDRESS = address(this);
        IMMUTABLE_BLOCK = block.number;
        IMMUTABLE_TIMESTAMP = block.timestamp;
        IMMUTABLE_TEST = test();
        IMMUTABLE_NAME = name_;
        IMMUTABLE_CREATION_HASH = keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp));

        emit ImmutableInitialized(name_, block.number, block.timestamp);
    }

    function test() public pure returns(uint256){
        uint256 what = 9;
        return what;
    }

    // 获取所有常量值的视图函数
    function getConstants() public pure returns (
        uint256 constantNum,
        string memory constantString,
        bytes memory constantBytes,
        address constantAddress,
        bytes32 constantHash
    ) {
        return (
            CONSTANT_NUM,
            CONSTANT_STRING,
            CONSTANT_BYTES,
            CONSTANT_ADDRESS,
            CONSTANT_HASH
        );
    }

    // 获取所有不可变值的视图函数
    function getImmutables() public view returns (
        uint256 immutableNum,
        address immutableAddress,
        uint256 immutableBlock,
        uint256 immutableTest,
        uint256 immutableTimestamp,
        string memory immutableName,
        bytes32 immutableCreationHash
    ) {
        return (
            IMMUTABLE_NUM,
            IMMUTABLE_ADDRESS,
            IMMUTABLE_BLOCK,
            IMMUTABLE_TEST,
            IMMUTABLE_TIMESTAMP,
            IMMUTABLE_NAME,
            IMMUTABLE_CREATION_HASH
        );
    }

    // 计算gas节省的示例函数
    function calculateWithConstant(uint256 input) public pure returns (uint256) {
        return input * CONSTANT_NUM;
    }

    function calculateWithImmutable(uint256 input) public view returns (uint256) {
        return input * IMMUTABLE_NUM;
    }

    // 验证合约信息的函数
    function verifyContractInfo() public view returns (bool) {
        return 
            IMMUTABLE_ADDRESS == address(this) &&
            IMMUTABLE_BLOCK <= block.number &&
            IMMUTABLE_TIMESTAMP <= block.timestamp;
    }

    // 获取合约创建信息
    function getCreationInfo() public view returns (
        uint256 creationBlock,
        uint256 creationTimestamp,
        string memory contractName,
        address contractAddress
    ) {
        return (
            IMMUTABLE_BLOCK,
            IMMUTABLE_TIMESTAMP,
            IMMUTABLE_NAME,
            IMMUTABLE_ADDRESS
        );
    }

    // 演示immutable变量不可修改（编译时会报错）
    /*
    function tryToModifyImmutable() public {
        // 以下代码会编译失败，因为immutable变量不能被修改
        // IMMUTABLE_NUM = 999;
        // IMMUTABLE_ADDRESS = address(0);
    }
    */

    // 演示constant变量不可修改（编译时会报错）
    /*
    function tryToModifyConstant() public {
        // 以下代码会编译失败，因为constant变量不能被修改
        // CONSTANT_NUM = 999;
        // CONSTANT_STRING = "modified";
    }
    */

    // 工具函数：计算使用constant/immutable的gas节省
    function estimateGasSavings() public pure returns (string memory) {
        return "使用constant和immutable可以节省gas，因为它们在编译时就被替换，不需要存储读取操作";
    }

    // 获取合约摘要信息
    function getContractSummary() public view returns (
        string memory name,
        uint256 constantValue,
        uint256 immutableValue,
        uint256 ageInBlocks
    ) {
        return (
            IMMUTABLE_NAME,
            CONSTANT_NUM,
            IMMUTABLE_NUM,
            block.number - IMMUTABLE_BLOCK
        );
    }
}
