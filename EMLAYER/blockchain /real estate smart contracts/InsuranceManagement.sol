// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsuranceManagement {
    address public insurer; // Sigortacı
    address public policyHolder; // Sigorta poliçe sahibi
    uint256 public insurancePremium; // Sigorta primi
    uint256 public claimAmount; // Sigorta talebi miktarı
    bool public policyActive; // Sigorta poliçesi aktif mi?
    bool public claimProcessed; // Sigorta talebi işlenmiş mi?

    enum State { Created, Active, ClaimRequested, ClaimProcessed, Terminated }
    State public currentState;

    modifier onlyInsurer() {
        require(msg.sender == insurer, "Only insurer can perform this action");
        _;
    }

    modifier onlyPolicyHolder() {
        require(msg.sender == policyHolder, "Only policy holder can perform this action");
        _;
    }

    modifier inState(State _state) {
        require(currentState == _state, "Invalid state for this action");
        _;
    }

    constructor(address _policyHolder, uint256 _insurancePremium) {
        insurer = msg.sender; // Sözleşmeyi başlatan kişi sigortacı olur
        policyHolder = _policyHolder;
        insurancePremium = _insurancePremium;
        claimAmount = 0;
        policyActive = false;
        claimProcessed = false;
        currentState = State.Created;
    }

    function activatePolicy() public onlyInsurer inState(State.Created) {
        currentState = State.Active;
        policyActive = true;
    }

    function payPremium() public payable onlyPolicyHolder inState(State.Active) {
        require(msg.value == insurancePremium, "Incorrect premium amount");
        // Sigorta primi sigortacıya transfer edilir
        payable(insurer).transfer(msg.value);
    }

    function requestClaim(uint256 _claimAmount) public onlyPolicyHolder inState(State.Active) {
        require(!claimProcessed, "Claim already processed");
        claimAmount = _claimAmount;
        currentState = State.ClaimRequested;
    }

    function processClaim() public onlyInsurer inState(State.ClaimRequested) {
        require(!claimProcessed, "Claim already processed");
        require(claimAmount > 0, "No claim amount set");
        // Sigorta talebi miktarı poliçe sahibine ödenir
        payable(policyHolder).transfer(claimAmount);
        claimProcessed = true;
        currentState = State.ClaimProcessed;
    }

    function terminatePolicy() public onlyInsurer inState(State.Active) {
        require(claimProcessed, "Claim not yet processed");
        policyActive = false;
        currentState = State.Terminated;
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}