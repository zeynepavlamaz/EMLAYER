// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InvestorVerification {
    address public admin; // Yöneticiler
    mapping(address => bool) public verifiedInvestors; // Doğrulanmış yatırımcılar

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function verifyInvestor(address _investor) public onlyAdmin {
        verifiedInvestors[_investor] = true;
    }

    function revokeVerification(address _investor) public onlyAdmin {
        verifiedInvestors[_investor] = false;
    }

    function isVerified(address _investor) public view returns (bool) {
        return verifiedInvestors[_investor];
    }
}