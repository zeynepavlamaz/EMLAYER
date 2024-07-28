// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SaleAgreement {
    address public seller;
    address public buyer;
    uint256 public salePrice;
    uint256 public depositAmount;
    uint256 public saleEndDate;
    bool public saleCompleted;
    bool public depositRefunded;

    enum State { Created, Active, Completed }
    State public currentState;

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can perform this action");
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can perform this action");
        _;
    }

    modifier inState(State _state) {
        require(currentState == _state, "Invalid state for this action");
        _;
    }

    constructor(address _buyer, uint256 _salePrice, uint256 _depositAmount, uint256 _saleEndDate) {
        seller = msg.sender;
        buyer = _buyer;
        salePrice = _salePrice;
        depositAmount = _depositAmount;
        saleEndDate = _saleEndDate;
        saleCompleted = false;
        depositRefunded = false;
        currentState = State.Created;
    }

    function activateAgreement() public onlySeller inState(State.Created) {
        currentState = State.Active;
    }

    function payDeposit() public onlyBuyer inState(State.Active) payable {
        require(msg.value == depositAmount, "Incorrect deposit amount");
    }

    function payRemainingAmount() public onlyBuyer inState(State.Active) payable {
        require(msg.value == (salePrice - depositAmount), "Incorrect remaining amount");
        require(block.timestamp <= saleEndDate, "Sale period ended");
        saleCompleted = true;
        currentState = State.Completed;
        // Transfer the sale price to the seller
        payable(seller).transfer(salePrice);
    }

    function refundDeposit() public onlySeller inState(State.Active) {
        require(!saleCompleted, "Sale already completed");
        require(block.timestamp > saleEndDate, "Sale period not ended");
        require(!depositRefunded, "Deposit already refunded");
        payable(buyer).transfer(depositAmount);
        depositRefunded = true;
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}