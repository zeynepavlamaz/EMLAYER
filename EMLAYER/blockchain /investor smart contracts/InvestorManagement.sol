// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InvestorManagement {
    address public admin; // Yönetici
    mapping(address => Investor) public investors; // Yatırımcı bilgileri

    struct Investor {
        string name;
        uint256 investmentAmount;
        bool exists;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addInvestor(address _investor, string memory _name, uint256 _investmentAmount) public onlyAdmin {
        require(!investors[_investor].exists, "Investor already exists");
        investors[_investor] = Investor(_name, _investmentAmount, true);
    }

    function removeInvestor(address _investor) public onlyAdmin {
        require(investors[_investor].exists, "Investor does not exist");
        delete investors[_investor];
    }

    function updateInvestmentAmount(address _investor, uint256 _investmentAmount) public onlyAdmin {
        require(investors[_investor].exists, "Investor does not exist");
        investors[_investor].investmentAmount = _investmentAmount;
    }

    function getInvestorInfo(address _investor) public view returns (string memory, uint256) {
        require(investors[_investor].exists, "Investor does not exist");
        Investor memory inv = investors[_investor];
        return (inv.name, inv.investmentAmount);
    }
}