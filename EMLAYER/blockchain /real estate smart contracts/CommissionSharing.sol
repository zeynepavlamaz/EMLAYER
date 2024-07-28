// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CommissionSharing {
    address public seller;
    address public broker;
    address public buyer;
    uint256 public salePrice;
    uint256 public brokerCommissionPercentage; // Broker'ın komisyon yüzdesi (örneğin, 5 için 500)
    bool public saleCompleted;

    enum State { Created, Active, Completed }
    State public currentState;

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can perform this action");
        _;
    }

    modifier onlyBroker() {
        require(msg.sender == broker, "Only broker can perform this action");
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

    constructor(address _seller, address _broker, address _buyer, uint256 _salePrice, uint256 _brokerCommissionPercentage) {
        seller = _seller;
        broker = _broker;
        buyer = _buyer;
        salePrice = _salePrice;
        brokerCommissionPercentage = _brokerCommissionPercentage;
        saleCompleted = false;
        currentState = State.Created;
    }

    function activateAgreement() public onlySeller inState(State.Created) {
        currentState = State.Active;
    }

    function paySalePrice() public onlyBuyer inState(State.Active) payable {
        require(msg.value == salePrice, "Incorrect sale price amount");
        require(!saleCompleted, "Sale already completed");

        // Calculate commission
        uint256 commission = (salePrice * brokerCommissionPercentage) / 10000;
        uint256 amountToSeller = salePrice - commission;

        // Transfer funds
        payable(broker).transfer(commission);
        payable(seller).transfer(amountToSeller);

        saleCompleted = true;
        currentState = State.Completed;
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}