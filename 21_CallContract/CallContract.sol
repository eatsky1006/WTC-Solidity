// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract OtherContract {
    uint256 private _x = 0; // 状态变量x
    
    // 收到eth事件，记录amount和gas
    event Log(uint amount, uint gas);
    
    // 返回合约ETH余额
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    // 可以调整状态变量_x的函数，并且可以往合约转ETH (payable)
    function setX(uint256 x) external payable {
        _x = x;
        // 如果转入ETH，则释放Log事件
        if(msg.value > 0){
            emit Log(msg.value, gasleft());
        }
    }

    // 读取x
    function getX() external view returns(uint x){
        x = _x;
    }
}

contract CallContract {
    // Fixed: Added explicit error handling
    function callSetX(address _address, uint256 x) external {
        OtherContract(_address).setX(x);
    }

    // Fixed: Parameter name changed to avoid shadowing
    function callGetX(OtherContract otherContract) external view returns(uint x) {
        x = otherContract.getX();
    }

    function callGetX2(address _address) external view returns(uint x) {
        OtherContract oc = OtherContract(_address);
        x = oc.getX();
    }

    // Fixed: Added proper access control and validation
    function setXTransferETH(address otherContract, uint256 x) external payable {
        require(otherContract != address(0), "Invalid contract address");
        require(msg.value > 0, "ETH value must be greater than 0");
        
        OtherContract(otherContract).setX{value: msg.value}(x);
    }
    
    // Added: Emergency function to withdraw any accidentally sent ETH
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
    
    // Added: Receive function to handle plain ETH transfers
    receive() external payable {}
}
