// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProfitSharing {
    address public company; // Şirket
    address[] public investors; // Yatırımcılar
    uint256 public totalProfit; // Toplam kâr
    mapping(address => uint256) public investmentShares; // Yatırımcı hisse oranları

    modifier onlyCompany() {
        require(msg.sender == company, "Only company can perform this action");
        _;
    }

    constructor() {
        company = msg.sender;
    }

    function addInvestor(address _investor, uint256 _share) public onlyCompany {
        investors.push(_investor);
        investmentShares[_investor] = _share;
    }

    function distributeProfit() public onlyCompany {
        require(totalProfit > 0, "No profit to distribute");

        for (uint256 i = 0; i < investors.length; i++) {
            address investor = investors[i];
            uint256 share = investmentShares[investor];
            uint256 payment = (totalProfit * share) / 100;
            payable(investor).transfer(payment);
        }

        totalProfit = 0; // Reset profit after distribution
    }

    receive() external payable {
        totalProfit += msg.value;
    }
}