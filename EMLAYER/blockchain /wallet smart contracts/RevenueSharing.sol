// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RevenueSharing {
    address public owner;
    address[] public investors;
    mapping(address => uint256) public shares;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addInvestor(address _investor, uint256 _share) public onlyOwner {
        investors.push(_investor);
        shares[_investor] = _share;
    }

    function distributeRevenue() public onlyOwner {
        uint256 totalRevenue = address(this).balance;
        for (uint256 i = 0; i < investors.length; i++) {
            address investor = investors[i];
            uint256 share = shares[investor];
            uint256 payment = (totalRevenue * share) / 100;
            payable(investor).transfer(payment);
        }
    }

    receive() external payable {
        // Fallback function to receive Ether
    }
}