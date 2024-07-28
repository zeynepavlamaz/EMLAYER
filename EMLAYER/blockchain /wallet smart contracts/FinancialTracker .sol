// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FinancialTracker {
    address public owner;

    struct Transaction {
        uint256 amount;
        string description;
        uint256 timestamp;
    }

    Transaction[] public incomes;
    Transaction[] public expenses;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function recordIncome(uint256 _amount, string memory _description) public onlyOwner {
        incomes.push(Transaction(_amount, _description, block.timestamp));
    }

    function recordExpense(uint256 _amount, string memory _description) public onlyOwner {
        expenses.push(Transaction(_amount, _description, block.timestamp));
    }

    function getIncomes() public view returns (Transaction[] memory) {
        return incomes;
    }

    function getExpenses() public view returns (Transaction[] memory) {
        return expenses;
    }
}