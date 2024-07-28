// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransactionSecurity {
    address public seller;
    address public buyer;
    address public escrow;
    uint256 public salePrice;
    uint256 public depositAmount;
    bool public transactionCompleted;
    bool public depositRefunded;

    enum State { Created, Escrowed, Completed, Refunded }
    State public currentState;

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can perform this action");
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can perform this action");
        _;
    }

    modifier onlyEscrow() {
        require(msg.sender == escrow, "Only escrow can perform this action");
        _;
    }

    modifier inState(State _state) {
        require(currentState == _state, "Invalid state for this action");
        _;
    }

    constructor(address _buyer, address _escrow, uint256 _salePrice, uint256 _depositAmount) {
        seller = msg.sender;
        buyer = _buyer;
        escrow = _escrow;
        salePrice = _salePrice;
        depositAmount = _depositAmount;
        transactionCompleted = false;
        depositRefunded = false;
        currentState = State.Created;
    }

    function depositFunds() public onlyBuyer inState(State.Created) payable {
        require(msg.value == depositAmount, "Incorrect deposit amount");
        currentState = State.Escrowed;
    }

    function completeTransaction() public onlyEscrow inState(State.Escrowed) {
        require(!transactionCompleted, "Transaction already completed");
        payable(seller).transfer(salePrice);
        transactionCompleted = true;
        currentState = State.Completed;
    }

    function refundDeposit() public onlyEscrow inState(State.Escrowed) {
        require(!transactionCompleted, "Transaction already completed");
        require(!depositRefunded, "Deposit already refunded");
        payable(buyer).transfer(depositAmount);
        depositRefunded = true;
        currentState = State.Refunded;
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}