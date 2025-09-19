// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract InitialValue {
    // Value Types
    bool public _bool; // false
    string public _string; // ""
    int public _int; // 0
    uint public _uint; // 0
    address public _address; // 0x0000000000000000000000000000000000000000

    enum ActionSet { Buy, Hold, Sell }
    ActionSet public _enum; // 第一个元素 0

    function fi() internal pure {} // internal空白方程 
    function fe() external pure {} // external空白方程 

    // Reference Types
    uint[8] public _staticArray; // 所有成员设为其默认值的静态数组[0,0,0,0,0,0,0,0]
    uint[] public _dynamicArray; // `[]`
    mapping(uint => address) public _mapping; // 所有元素都为其默认值的mapping
    
    // 结构体定义
    struct Student {
        uint256 id;
        uint256 score; 
        string name;
        bool isActive;
    }
    Student public student; // 所有成员设为其默认值的结构体: 0, 0, "", false

    // 带初始值的变量
    bool public _bool2 = true; 
    uint public initializedUint = 100;
    address public owner;
    string public constant CONTRACT_NAME = "InitialValueDemo";

    // 事件
    event ValueReset(string variableName, address resetBy);
    event StudentUpdated(uint256 id, uint256 score, string name);

    // 构造函数
    constructor() {
        owner = msg.sender;
        
        // 初始化一些示例数据
        student = Student(1, 95, "Alice", true);
        _dynamicArray.push(10);
        _dynamicArray.push(20);
        _mapping[1] = msg.sender;
    }

    // delete操作符演示函数
    function deleteBool() external {
        emit ValueReset("_bool2", msg.sender);
        delete _bool2; // delete 会让_bool2变为默认值，false
    }

    function deleteUint() external {
        emit ValueReset("initializedUint", msg.sender);
        delete initializedUint; // 重置为 0
    }

    function deleteArrayElement(uint index) external {
        require(index < _dynamicArray.length, "Index out of bounds");
        delete _dynamicArray[index]; // 将特定元素重置为 0
    }

    function deleteStudent() external {
        emit ValueReset("student", msg.sender);
        delete student; // 重置所有结构体字段为默认值
    }

    // 设置函数
    function setStudent(uint256 _id, uint256 _score, string memory _name, bool _isActive) external {
        student = Student(_id, _score, _name, _isActive);
        emit StudentUpdated(_id, _score, _name);
    }

    function addToArray(uint _value) external {
        _dynamicArray.push(_value);
    }

    function setMapping(uint _key, address _value) external {
        _mapping[_key] = _value;
    }

    // 视图函数
    function getArrayLength() external view returns (uint) {
        return _dynamicArray.length;
    }

    function getArrayElement(uint index) external view returns (uint) {
        require(index < _dynamicArray.length, "Index out of bounds");
        return _dynamicArray[index];
    }

    function getStudentInfo() external view returns (uint256, uint256, string memory, bool) {
        return (student.id, student.score, student.name, student.isActive);
    }

    function getAllDefaultValues() external pure returns (
        bool defaultBool,
        string memory defaultString,
        int defaultInt,
        uint defaultUint,
        address defaultAddress,
        ActionSet defaultEnum
    ) {
        return (false, "", 0, 0, address(0), ActionSet.Buy);
    }

    // 工具函数
    function resetAllValues() external {
        require(msg.sender == owner, "Only owner can reset all values");
        
        delete _bool2;
        delete initializedUint;
        delete student;
        
        // 清空动态数组
        delete _dynamicArray;
        
        emit ValueReset("All values", msg.sender);
    }

    // 检查默认值状态
    function isAtDefaultValue() external view returns (
        bool boolIsDefault,
        bool uintIsDefault,
        bool studentIsDefault,
        bool arrayIsEmpty
    ) {
        boolIsDefault = (_bool2 == false);
        uintIsDefault = (initializedUint == 0);
        studentIsDefault = (student.id == 0 && student.score == 0 && bytes(student.name).length == 0 && student.isActive == false);
        arrayIsEmpty = (_dynamicArray.length == 0);
        
        return (boolIsDefault, uintIsDefault, studentIsDefault, arrayIsEmpty);
    }
}
