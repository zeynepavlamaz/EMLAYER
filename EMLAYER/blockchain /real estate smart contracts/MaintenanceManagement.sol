// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MaintenanceManagement {
    address public propertyManager; // Mülk yöneticisi
    address public propertyOwner; // Mülk sahibi
    uint256 public maintenanceFee; // Bakım ücreti
    uint256 public maintenanceRequestId; // Bakım talebi kimliği
    uint256 public maintenanceCompletionId; // Bakım tamamlanma kimliği
    bool public maintenanceRequested; // Bakım talebi var mı?
    bool public maintenanceCompleted; // Bakım tamamlandı mı?

    enum State { Created, Active, MaintenanceRequested, MaintenanceCompleted, Terminated }
    State public currentState;

    modifier onlyPropertyManager() {
        require(msg.sender == propertyManager, "Only property manager can perform this action");
        _;
    }

    modifier onlyPropertyOwner() {
        require(msg.sender == propertyOwner, "Only property owner can perform this action");
        _;
    }

    modifier inState(State _state) {
        require(currentState == _state, "Invalid state for this action");
        _;
    }

    constructor(address _propertyOwner, address _propertyManager, uint256 _maintenanceFee) {
        propertyOwner = _propertyOwner;
        propertyManager = _propertyManager;
        maintenanceFee = _maintenanceFee;
        maintenanceRequestId = 0;
        maintenanceCompletionId = 0;
        maintenanceRequested = false;
        maintenanceCompleted = false;
        currentState = State.Created;
    }

    function activateContract() public onlyPropertyOwner inState(State.Created) {
        currentState = State.Active;
    }

    function requestMaintenance() public onlyPropertyManager inState(State.Active) {
        require(!maintenanceRequested, "Maintenance already requested");
        maintenanceRequested = true;
        maintenanceRequestId++;
        currentState = State.MaintenanceRequested;
    }

    function completeMaintenance() public onlyPropertyManager inState(State.MaintenanceRequested) {
        require(maintenanceRequested, "Maintenance not requested");
        maintenanceRequested = false;
        maintenanceCompleted = true;
        maintenanceCompletionId++;
        currentState = State.MaintenanceCompleted;
        // Bakım ücreti mülk sahibine ödenir
        payable(propertyOwner).transfer(maintenanceFee);
    }

    function terminateContract() public onlyPropertyOwner inState(State.MaintenanceCompleted) {
        currentState = State.Terminated;
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}