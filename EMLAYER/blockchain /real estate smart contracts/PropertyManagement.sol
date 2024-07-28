// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PropertyManagement {
    address public owner;
    address public propertyManager;
    uint256 public rentAmount;
    uint256 public maintenanceFee;
    uint256 public depositAmount;
    uint256 public leaseEndDate;
    bool public leaseActive;
    bool public maintenanceRequested;
    bool public maintenanceCompleted;

    enum State { Created, Active, MaintenanceRequested, MaintenanceCompleted, Terminated }
    State public currentState;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyManager() {
        require(msg.sender == propertyManager, "Only property manager can perform this action");
        _;
    }

    modifier inState(State _state) {
        require(currentState == _state, "Invalid state for this action");
        _;
    }

    constructor(address _propertyManager, uint256 _rentAmount, uint256 _maintenanceFee, uint256 _depositAmount, uint256 _leaseEndDate) {
        owner = msg.sender;
        propertyManager = _propertyManager;
        rentAmount = _rentAmount;
        maintenanceFee = _maintenanceFee;
        depositAmount = _depositAmount;
        leaseEndDate = _leaseEndDate;
        leaseActive = false;
        maintenanceRequested = false;
        maintenanceCompleted = false;
        currentState = State.Created;
    }

    function activateLease() public onlyOwner inState(State.Created) {
        currentState = State.Active;
        leaseActive = true;
    }

    function payRent() public payable inState(State.Active) {
        require(msg.value == rentAmount, "Incorrect rent amount");
        // Transfer rent amount to owner
        payable(owner).transfer(msg.value);
    }

    function requestMaintenance() public onlyManager inState(State.Active) {
        maintenanceRequested = true;
        currentState = State.MaintenanceRequested;
    }

    function completeMaintenance() public onlyManager inState(State.MaintenanceRequested) {
        maintenanceRequested = false;
        maintenanceCompleted = true;
        currentState = State.MaintenanceCompleted;
        // Transfer maintenance fee to manager
        payable(propertyManager).transfer(maintenanceFee);
    }

    function terminateLease() public onlyOwner inState(State.Active) {
        require(block.timestamp >= leaseEndDate, "Lease period not yet ended");
        leaseActive = false;
        currentState = State.Terminated;
    }

    function refundDeposit() public onlyOwner inState(State.Terminated) {
        require(!maintenanceRequested, "Maintenance still pending");
        require(!maintenanceCompleted, "Maintenance already completed");
        // Refund deposit to tenant (assuming tenant's address is known)
        // This part would require tenant's address to be stored
        payable(/*tenantAddress*/).transfer(depositAmount);
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}