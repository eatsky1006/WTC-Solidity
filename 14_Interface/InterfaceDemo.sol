// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface Base {
    function getFirstName() external pure returns(string memory);
    function getLastName() external pure returns(string memory);
}

contract BaseImpl is Base {
    function getFirstName() external pure override returns(string memory) {
        return "Amazing";
    }
    
    function getLastName() external pure override returns(string memory) {
        return "Ang";
    }
    
    // Optional: Add a function that returns the full name
    function getFullName() external pure returns(string memory) {
        return string(abi.encodePacked(this.getFirstName(), " ", this.getLastName()));
    }
}

// Additional implementation showing interface inheritance flexibility
contract AlternativeBaseImpl is Base {
    function getFirstName() external pure override returns(string memory) {
        return "John";
    }
    
    function getLastName() external pure override returns(string memory) {
        return "Doe";
    }
}

// Contract demonstrating interface usage
contract NameProcessor {
    Base public nameContract;
    
    constructor(Base _nameContract) {
        nameContract = _nameContract;
    }
    
    function getProcessedName() external view returns(string memory) {
        string memory firstName = nameContract.getFirstName();
        string memory lastName = nameContract.getLastName();
        return string(abi.encodePacked("Processed: ", firstName, " ", lastName));
    }
    
    function changeNameContract(Base _newContract) external {
        nameContract = _newContract;
    }
}
