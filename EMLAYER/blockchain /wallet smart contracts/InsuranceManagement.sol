// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsuranceManagement {
    address public owner;
    address public insuranceProvider;
    uint256 public insurancePremium;
    uint256 public lastPremiumPayment;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyProvider() {
        require(msg.sender == insuranceProvider, "Only provider can perform this action");
        _;
    }

    constructor(address _insuranceProvider, uint256 _insurancePremium) {
        owner = msg.sender;
        insuranceProvider = _insuranceProvider;
        insurancePremium = _insurancePremium;
        lastPremiumPayment = block.timestamp;
    }

    function payPremium() public onlyOwner payable {
        require(msg.value == insurancePremium, "Incorrect premium amount");
        payable(insuranceProvider).transfer(msg.value);
        lastPremiumPayment = block.timestamp;
    }

    function fileClaim() public onlyOwner {
        // Handle insurance claim
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}