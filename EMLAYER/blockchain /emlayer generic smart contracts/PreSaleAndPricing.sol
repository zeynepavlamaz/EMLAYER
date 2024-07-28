// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PreSaleAndPricing {
    address public owner; // Sözleşmenin sahibi (deploy eden kişi)
    uint256 public preSaleStart; // Ön satış başlangıç zamanı
    uint256 public preSaleEnd; // Ön satış bitiş zamanı
    uint256 public tokenPrice; // Token fiyatı (wei cinsinden)
    uint256 public totalTokensForSale; // Ön satışta satılacak toplam token miktarı
    uint256 public totalTokensSold; // Satılan toplam token miktarı
    uint256 public maxPurchaseLimit; // Kişi başına alım limiti
    uint256 public totalPurchaseLimit; // Toplam alım limiti
    uint256 public totalFundsRaised; // Toplam toplanan fon

    mapping(address => uint256) public purchases; // Yatırımcı başına satın alınan token miktarı
    mapping(address => bool) public authorizedUsers; // Yetkilendirilmiş kullanıcılar haritası

    enum PreSaleStatus { NotStarted, Ongoing, Ended } // Ön satış durumu

    PreSaleStatus public saleStatus; // Ön satış durumu

    event PreSaleStarted(uint256 startTime, uint256 endTime, uint256 tokenPrice, uint256 totalTokensForSale);
    event PreSaleEnded(uint256 endTime);
    event TokenPriceUpdated(uint256 newTokenPrice);
    event PurchaseMade(address indexed buyer, uint256 amountPaid, uint256 tokensPurchased);
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
        saleStatus = PreSaleStatus.NotStarted; // Başlangıçta ön satış durumu "Başlamadı"
    }

    /**
     * @dev Ön satış dönemi başlatır.
     * @param startTime Ön satışın başlayacağı zaman (Unix timestamp).
     * @param endTime Ön satışın biteceği zaman (Unix timestamp).
     * @param price Token fiyatı (wei cinsinden).
     * @param tokensForSale Ön satışta satılacak toplam token miktarı.
     * @param purchaseLimit Kişi başına alım limiti (token cinsinden).
     * @param totalLimit Toplam alım limiti (token cinsinden).
     */
    function startPreSale(
        uint256 startTime,
        uint256 endTime,
        uint256 price,
        uint256 tokensForSale,
        uint256 purchaseLimit,
        uint256 totalLimit
    ) public onlyOwner {
        require(saleStatus == PreSaleStatus.NotStarted, "Ön satış zaten başladı veya bitti");
        require(startTime < endTime, "Başlangıç zamanı bitiş zamanından önce olmalıdır");

        preSaleStart = startTime;
        preSaleEnd = endTime;
        tokenPrice = price;
        totalTokensForSale = tokensForSale;
        totalTokensSold = 0;
        maxPurchaseLimit = purchaseLimit;
        totalPurchaseLimit = totalLimit;
        totalFundsRaised = 0;
        saleStatus = PreSaleStatus.Ongoing;

        emit PreSaleStarted(startTime, endTime, price, tokensForSale);
    }

    /**
     * @dev Ön satış dönemini bitirir.
     */
    function endPreSale() public onlyOwner {
        require(saleStatus == PreSaleStatus.Ongoing, "Ön satış devam etmiyor");

        saleStatus = PreSaleStatus.Ended;
        emit PreSaleEnded(block.timestamp);
    }

    /**
     * @dev Token fiyatını günceller.
     * @param newPrice Yeni token fiyatı (wei cinsinden).
     */
    function updateTokenPrice(uint256 newPrice) public onlyAuthorizedUsers {
        require(saleStatus == PreSaleStatus.NotStarted, "Ön satış başladı, fiyat güncellenemez");
        tokenPrice = newPrice;
        emit TokenPriceUpdated(newPrice);
    }

    /**
     * @dev Yatırımcıların ön satışa katılmasını sağlar.
     */
    function participateInPreSale() public payable {
        require(saleStatus == PreSaleStatus.Ongoing, "Ön satış devam etmiyor");
        require(block.timestamp >= preSaleStart && block.timestamp <= preSaleEnd, "Ön satış dönemi geçerli değil");

        uint256 amountPaid = msg.value;
        uint256 tokensToBuy = amountPaid / tokenPrice;
        uint256 totalTokensToBuy = purchases[msg.sender] + tokensToBuy;

        require(totalTokensToBuy <= maxPurchaseLimit, "Kişi başına alım limiti aşıldı");
        require(totalTokensSold + tokensToBuy <= totalPurchaseLimit, "Toplam alım limiti aşıldı");

        purchases[msg.sender] += tokensToBuy;
        totalTokensSold += tokensToBuy;
        totalFundsRaised += amountPaid;

        emit PurchaseMade(msg.sender, amountPaid, tokensToBuy);
    }

    /**
     * @dev Yatırımcıların satın aldığı token miktarını sorgular.
     * @param investor Yatırımcının adresi.
     * @return Satın alınan token miktarı.
     */
    function checkPurchase(address investor) public view returns (uint256) {
        return purchases[investor];
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

    /**
     * @dev Toplam fonları çeker (örneğin, satış gelirleri).
     * @param to Çekilecek fonların gönderileceği adres.
     */
    function withdrawFunds(address payable to) public onlyOwner {
        require(address(this).balance > 0, "Çekilecek fon yok");
        to.transfer(address(this).balance);
    }
}