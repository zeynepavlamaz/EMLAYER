// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RentalAgreement {
    address public landlord;
    address public tenant;
    uint256 public depositAmount;
    uint256 public rentAmount;
    uint256 public rentDueDate;
    uint256 public leaseEndDate;
    bool public depositReturned;

    enum State { Created, Active, Terminated }
    State public currentState;

    modifier onlyLandlord() {
        require(msg.sender == landlord, "Only landlord can perform this action");
        _;
    }

    modifier onlyTenant() {
        require(msg.sender == tenant, "Only tenant can perform this action");
        _;
    }

    modifier inState(State _state) {
        require(currentState == _state, "Invalid state for this action");
        _;
    }

    constructor(address _tenant, uint256 _depositAmount, uint256 _rentAmount, uint256 _rentDueDate, uint256 _leaseEndDate) {
        landlord = msg.sender;
        tenant = _tenant;
        depositAmount = _depositAmount;
        rentAmount = _rentAmount;
        rentDueDate = _rentDueDate;
        leaseEndDate = _leaseEndDate;
        depositReturned = false;
        currentState = State.Created;
    }

    function activateAgreement() public onlyLandlord inState(State.Created) {
        currentState = State.Active;
    }

    function payRent() public onlyTenant inState(State.Active) payable {
        require(msg.value == rentAmount, "Incorrect rent amount");
        require(block.timestamp <= rentDueDate, "Rent payment overdue");

        // Logic to handle rent payment (e.g., transfer funds to landlord) can be added here
    }

    function returnDeposit() public onlyLandlord inState(State.Terminated) {
        require(!depositReturned, "Deposit already returned");
        payable(tenant).transfer(depositAmount);
        depositReturned = true;
    }

    function terminateAgreement() public onlyLandlord inState(State.Active) {
        require(block.timestamp >= leaseEndDate, "Lease period not yet ended");
        currentState = State.Terminated;
        returnDeposit();
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}