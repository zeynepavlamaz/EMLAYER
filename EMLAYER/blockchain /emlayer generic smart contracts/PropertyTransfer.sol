// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PropertyTransfer {
    address public owner; // Sözleşmenin sahibi (deploy eden kişi)
    address public propertyOwner; // Mülkün şu anki sahibi
    uint256 public propertyPrice; // Mülkün satış fiyatı
    bool public propertyForSale; // Mülkün satılık olup olmadığını belirten bayrak

    mapping(address => bool) public authorizedUsers; // Yetkilendirilmiş kullanıcılar haritası
    mapping(address => uint256) public rentalIncome; // Kira gelirleri haritası

    // Olaylar
    event PropertyListed(address indexed owner, uint256 price); // Mülkün listelenmesi olayı
    event PropertySold(address indexed from, address indexed to, uint256 price); // Mülkün satılması olayı
    event PropertyDelisted(address indexed owner); // Mülkün listeden kaldırılması olayı
    event AuthorizedUserAdded(address indexed user); // Yetkilendirilmiş kullanıcı eklenmesi olayı
    event AuthorizedUserRemoved(address indexed user); // Yetkilendirilmiş kullanıcı çıkarılması olayı
    event RentalIncomeDistributed(address indexed owner, uint256 amount); // Kira gelirlerinin dağıtılması olayı

    // Yalnızca sözleşme sahibi tarafından kullanılabilir işaretleyici
    modifier onlyOwner() {
        require(msg.sender == owner, "Yalnızca sözleşme sahibi bu işlemi gerçekleştirebilir");
        _;
    }

    // Yalnızca mülk sahibi tarafından kullanılabilir işaretleyici
    modifier onlyPropertyOwner() {
        require(msg.sender == propertyOwner, "Yalnızca mülk sahibi bu işlemi gerçekleştirebilir");
        _;
    }

    // Yalnızca yetkilendirilmiş kullanıcılar tarafından kullanılabilir işaretleyici
    modifier onlyAuthorizedUsers() {
        require(authorizedUsers[msg.sender], "Bu işlemi gerçekleştirmek için yetkiniz yok");
        _;
    }

    constructor() {
        owner = msg.sender;
        propertyOwner = msg.sender; // Başlangıçta, sözleşmeyi dağıtan kişi mülk sahibidir
    }

    /**
     * @dev Mülkü belirli bir fiyatla satışa çıkar.
     * @param price Mülkün satış fiyatı.
     */
    function listProperty(uint256 price) public onlyPropertyOwner {
        require(price > 0, "Fiyat sıfırdan büyük olmalıdır");
        propertyPrice = price;
        propertyForSale = true;
        emit PropertyListed(msg.sender, price);
    }

    /**
     * @dev Mülkü satılıktan kaldır.
     */
    function delistProperty() public onlyPropertyOwner {
        propertyForSale = false;
        emit PropertyDelisted(msg.sender);
    }

    /**
     * @dev Mülkü satışa çıkarıldığında satın al.
     */
    function buyProperty() public payable {
        require(propertyForSale, "Mülk satışta değil");
        require(msg.value == propertyPrice, "Yanlış değer gönderildi");

        address previousOwner = propertyOwner;
        propertyOwner = msg.sender;
        propertyForSale = false;

        payable(previousOwner).transfer(msg.value);

        emit PropertySold(previousOwner, msg.sender, msg.value);
    }

    /**
     * @dev Mülkün detaylarını al.
     * @return Mevcut mülk sahibi, fiyat ve satış durumu.
     */
    function getPropertyDetails() public view returns (address, uint256, bool) {
        return (propertyOwner, propertyPrice, propertyForSale);
    }

    /**
     * @dev Belirli bir kullanıcıyı yetkilendir.
     * @param user Yetkilendirilecek kullanıcının adresi.
     */
    function addAuthorizedUser(address user) public onlyOwner {
        authorizedUsers[user] = true;
        emit AuthorizedUserAdded(user);
    }

    /**
     * @dev Belirli bir kullanıcıyı yetkiden çıkar.
     * @param user Yetkiden çıkarılacak kullanıcının adresi.
     */
    function removeAuthorizedUser(address user) public onlyOwner {
        authorizedUsers[user] = false;
        emit AuthorizedUserRemoved(user);
    }

    /**
     * @dev Kira gelirlerini mülk sahiplerine dağıt.
     */
    function distributeRentalIncome() public onlyAuthorizedUsers {
        uint256 income = rentalIncome[propertyOwner];
        require(income > 0, "Dağıtılacak kira geliri yok");
        rentalIncome[propertyOwner] = 0;
        payable(propertyOwner).transfer(income);
        emit RentalIncomeDistributed(propertyOwner, income);
    }

    /**
     * @dev Kira gelirlerini ekle.
     */
    function addRentalIncome() public payable {
        rentalIncome[propertyOwner] += msg.value;
    }

    /**
     * @dev Mülkiyet hissesini belirli bir adrese transfer et.
     * @param to Hisse transfer edilecek adres.
     * @param share Transfer edilecek hisse oranı (1 ile 100 arasında).
     */
    function transferPropertyShare(address to, uint256 share) public onlyPropertyOwner {
        require(share > 0 && share <= 100, "Hisse oranı 1 ile 100 arasında olmalıdır");
        // Hisse transferi mantığını burada uygula
        // Bu, hisse transferi mantığı için bir yerdir
    }

    /**
     * @dev Belirli bir karar için oylama yap.
     * @param decision Oylanacak karar.
     */
    function voteOnDecision(string memory decision) public onlyAuthorizedUsers {
        // Oylama mantığını burada uygula
        // Bu, oylama mantığı için bir yerdir
    }

    /**
     * @dev Sigorta tazminatı talep et.
     * @param claimAmount Talep edilecek tazminat miktarı.
     */
    function makeInsuranceClaim(uint256 claimAmount) public onlyPropertyOwner {
        // Sigorta tazminatı mantığını burada uygula
        // Bu, sigorta tazminatı mantığı için bir yerdir
    }

    /**
     * @dev Dinamik fiyatlandırmayı uygula.
     * @param newPrice Yeni fiyat.
     */
    function dynamicPricing(uint256 newPrice) public onlyPropertyOwner {
        require(newPrice > 0, "Fiyat sıfırdan büyük olmalıdır");
        propertyPrice = newPrice;
        // Dinamik fiyatlandırma mantığını burada uygula
    }

    /**
     * @dev Bakım ve onarım fonlarını dağıt.
     * @param amount Dağıtılacak miktar.
     */
    function distributeMaintenanceFunds(uint256 amount) public onlyAuthorizedUsers {
        require(amount > 0, "Miktar sıfırdan büyük olmalıdır");
        // Bakım fonları dağıtım mantığını burada uygula
        // Bu, bakım fonları dağıtım mantığı için bir yerdir
    }
}