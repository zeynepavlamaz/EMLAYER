// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InvestmentAgreement {
    address public investor; // Yatırımcı
    address public investee; // Yatırım yapılan şirket
    uint256 public investmentAmount; // Yatırım miktarı
    uint256 public repaymentAmount; // Geri ödeme miktarı
    uint256 public investmentDate; // Yatırım tarihi
    uint256 public maturityDate; // Vade tarihi

    enum State { Created, Funded, Repayed, Terminated }
    State public currentState;

    modifier onlyInvestor() {
        require(msg.sender == investor, "Only investor can perform this action");
        _;
    }

    modifier onlyInvestee() {
        require(msg.sender == investee, "Only investee can perform this action");
        _;
    }

    modifier inState(State _state) {
        require(currentState == _state, "Invalid state for this action");
        _;
    }

    constructor(address _investor, address _investee, uint256 _investmentAmount, uint256 _repaymentAmount, uint256 _maturityDate) {
        investor = _investor;
        investee = _investee;
        investmentAmount = _investmentAmount;
        repaymentAmount = _repaymentAmount;
        investmentDate = block.timestamp;
        maturityDate = _maturityDate;
        currentState = State.Created;
    }

    function fundInvestment() public payable onlyInvestor inState(State.Created) {
        require(msg.value == investmentAmount, "Incorrect investment amount");
        payable(investee).transfer(msg.value);
        currentState = State.Funded;
    }

    function repayInvestment() public onlyInvestee inState(State.Funded) {
        require(block.timestamp >= maturityDate, "Investment not yet matured");
        payable(investor).transfer(repaymentAmount);
        currentState = State.Repayed;
    }

    function terminateContract() public onlyInvestee inState(State.Repayed) {
        currentState = State.Terminated;
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}