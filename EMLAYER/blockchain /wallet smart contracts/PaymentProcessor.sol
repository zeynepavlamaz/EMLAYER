// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentProcessor {
    address public owner;
    address public propertyManager;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyManager() {
        require(msg.sender == propertyManager, "Only manager can perform this action");
        _;
    }

    constructor(address _propertyManager) {
        owner = msg.sender;
        propertyManager = _propertyManager;
    }

    function payRent() public payable onlyManager {
        // Handle rent payment
    }

    function makeSalePayment() public payable onlyOwner {
        // Handle sale payment
    }

    function payForMaintenance() public payable onlyManager {
        // Handle maintenance payment
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}