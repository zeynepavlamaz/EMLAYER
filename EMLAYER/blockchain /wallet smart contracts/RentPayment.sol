// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RentPayment {
    address public landlord;
    address public tenant;
    uint256 public rentAmount;
    uint256 public dueDate;
    uint256 public lateFee;

    modifier onlyTenant() {
        require(msg.sender == tenant, "Only tenant can perform this action");
        _;
    }

    modifier onlyLandlord() {
        require(msg.sender == landlord, "Only landlord can perform this action");
        _;
    }

    constructor(address _tenant, uint256 _rentAmount, uint256 _dueDate, uint256 _lateFee) {
        landlord = msg.sender;
        tenant = _tenant;
        rentAmount = _rentAmount;
        dueDate = _dueDate;
        lateFee = _lateFee;
    }

    function payRent() public payable onlyTenant {
        require(block.timestamp <= dueDate, "Rent payment is overdue");
        require(msg.value >= rentAmount, "Insufficient rent payment");

        uint256 excessAmount = msg.value - rentAmount;
        payable(landlord).transfer(rentAmount);

        if (excessAmount > 0) {
            payable(tenant).transfer(excessAmount);
        }
    }

    function payLateFee() public payable onlyTenant {
        require(block.timestamp > dueDate, "Rent payment is not overdue");
        require(msg.value >= lateFee, "Insufficient late fee payment");

        payable(landlord).transfer(lateFee);
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}