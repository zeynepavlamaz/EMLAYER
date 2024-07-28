// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InvestmentReturns {
    address public owner; // Sözleşmenin sahibi (deploy eden kişi)
    uint256 public investmentIdCounter; // Yatırım ID'si sayaç

    struct Investment {
        uint256 id; // Yatırım ID'si
        address investor; // Yatırımcının adresi
        uint256 amount; // Yatırım miktarı
        uint256 returnRate; // Yatırım getirisi oranı
        uint256 investedAt; // Yatırımın yapıldığı zaman
    }

    struct InvestmentReturn {
        uint256 id; // Getiri ID'si
        uint256 investmentId; // İlgili yatırım ID'si
        uint256 returnAmount; // Getiri miktarı
    }

    mapping(uint256 => Investment) public investments; // Yatırım bilgileri
    mapping(uint256 => InvestmentReturn) public investmentReturns; // Yatırım getirisi bilgileri
    mapping(address => bool) public authorizedUsers; // Yetkilendirilmiş kullanıcılar haritası

    event InvestmentMade(uint256 indexed investmentId, address indexed investor, uint256 amount, uint256 returnRate);
    event InvestmentReturnCalculated(uint256 indexed investmentReturnId, uint256 indexed investmentId, uint256 returnAmount);
    event AuthorizedUserAdded(address indexed user);
    event AuthorizedUserRemoved(address indexed user);

    modifier onlyOwner() {
        require(msg.sender == owner, "Yalnızca sözleşme sahibi bu işlemi gerçekleştirebilir");
        _;
    }

    modifier onlyAuthorizedUsers() {
        require(authorizedUsers[msg.sender], "Bu işlemi gerçekleştirmek için yetkiniz yok");
        _;
    }

    constructor() {
        owner = msg.sender;
        investmentIdCounter = 1; // İlk yatırım ID'si 1'den başlar
    }

    /**
     * @dev Yatırım yapar ve yatırımı kaydeder.
     * @param amount Yatırım miktarı.
     * @param returnRate Yatırım getirisi oranı (yüzde olarak).
     */
    function makeInvestment(uint256 amount, uint256 returnRate) public {
        uint256 investmentId = investmentIdCounter++;
        investments[investmentId] = Investment({
            id: investmentId,
            investor: msg.sender,
            amount: amount,
            returnRate: returnRate,
            investedAt: block.timestamp
        });

        emit InvestmentMade(investmentId, msg.sender, amount, returnRate);
    }

    /**
     * @dev Yatırım getirilerini hesaplar ve kaydeder.
     * @param investmentId Yatırım ID'si.
     */
    function calculateInvestmentReturn(uint256 investmentId) public onlyAuthorizedUsers {
        Investment storage investment = investments[investmentId];
        require(investment.id != 0, "Yatırım bulunamadı");

        uint256 elapsedTime = block.timestamp - investment.investedAt; // Yatırım süresi
        uint256 returnAmount = (investment.amount * investment.returnRate * elapsedTime) / (365 days * 100); // Getiri hesaplama (yıllık oran)

        uint256 investmentReturnId = investmentId; // Burada basitlik olması açısından yatırım ID'sini getiri ID'si olarak kullanıyoruz
        investmentReturns[investmentReturnId] = InvestmentReturn({
            id: investmentReturnId,
            investmentId: investmentId,
            returnAmount: returnAmount
        });

        emit InvestmentReturnCalculated(investmentReturnId, investmentId, returnAmount);
    }

    /**
     * @dev Yatırım getirilerini raporlar.
     * @param investmentId Yatırım ID'si.
     * @return Yatırımcı adresi, yatırım miktarı, getiri oranı, getiri miktarı.
     */
    function reportInvestmentReturn(uint256 investmentId) public view returns (
        address investor,
        uint256 amount,
        uint256 returnRate,
        uint256 returnAmount
    ) {
        Investment storage investment = investments[investmentId];
        require(investment.id != 0, "Yatırım bulunamadı");

        InvestmentReturn storage investmentReturn = investmentReturns[investmentId];
        return (
            investment.investor,
            investment.amount,
            investment.returnRate,
            investmentReturn.returnAmount
        );
    }

    /**
     * @dev Yetkilendirilmiş bir kullanıcıyı ekler.
     * @param user Yetkilendirilecek kullanıcının adresi.
     */
    function addAuthorizedUser(address user) public onlyOwner {
        authorizedUsers[user] = true;
        emit AuthorizedUserAdded(user);
    }

    /**
     * @dev Yetkilendirilmiş bir kullanıcıyı kaldırır.
     * @param user Yetkilendirilmiş kullanıcıyı kaldırılacak adres.
     */
    function removeAuthorizedUser(address user) public onlyOwner {
        authorizedUsers[user] = false;
        emit AuthorizedUserRemoved(user);
    }
}