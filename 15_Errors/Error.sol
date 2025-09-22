// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// Custom errors with parameters for better debugging
error TransferNotOwner();
error TransferNotOwnerWithAddress(address sender);
error TransferNotOwnerWithDetails(address sender, uint256 tokenId);

contract Errors {
    // Mapping to record owner of each tokenId
    mapping(uint256 => address) private _owners;
    
    // Initialize some owners for testing
    constructor() {
        _owners[123] = msg.sender; // Set sender as owner of token 123 for testing
    }

    // Error method without parameters: gas efficient
    function transferOwner1(uint256 tokenId, address newOwner) public {
        if (_owners[tokenId] != msg.sender) {
            revert TransferNotOwner();
        }
        _owners[tokenId] = newOwner;
    }

    // Error method with parameter: provides sender address for debugging
    function transferOwner2(uint256 tokenId, address newOwner) public {
        if (_owners[tokenId] != msg.sender) {
            revert TransferNotOwnerWithAddress(msg.sender);
        }
        _owners[tokenId] = newOwner;
    }

    // Error method with multiple parameters: detailed debugging info
    function transferOwner3(uint256 tokenId, address newOwner) public {
        if (_owners[tokenId] != msg.sender) {
            revert TransferNotOwnerWithDetails(msg.sender, tokenId);
        }
        _owners[tokenId] = newOwner;
    }

    // Require method: traditional approach with string message
    function transferOwner4(uint256 tokenId, address newOwner) public {
        require(_owners[tokenId] == msg.sender, "Transfer Not Owner");
        _owners[tokenId] = newOwner;
    }

    // Assert method: for internal invariants (use carefully)
    function transferOwner5(uint256 tokenId, address newOwner) public {
        // Assert should be used for conditions that should never be false
        address currentOwner = _owners[tokenId];
        assert(currentOwner == msg.sender); // This should never fail if logic is correct
        _owners[tokenId] = newOwner;
    }

    // Helper function to set owner (for testing)
    function setOwner(uint256 tokenId, address owner) public {
        _owners[tokenId] = owner;
    }

    // Helper function to get owner
    function getOwner(uint256 tokenId) public view returns (address) {
        return _owners[tokenId];
    }

    // Additional best practice: event for ownership transfers
    event OwnershipTransferred(uint256 indexed tokenId, address previousOwner, address newOwner);

    // Recommended approach: use custom errors with events
    function transferOwnerRecommended(uint256 tokenId, address newOwner) public {
        address currentOwner = _owners[tokenId];
        if (currentOwner != msg.sender) {
            revert TransferNotOwnerWithDetails(msg.sender, tokenId);
        }
        
        _owners[tokenId] = newOwner;
        emit OwnershipTransferred(tokenId, currentOwner, newOwner);
    }
}
