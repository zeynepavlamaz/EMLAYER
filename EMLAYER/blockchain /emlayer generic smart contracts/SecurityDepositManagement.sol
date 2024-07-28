// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SecurityDepositManagement {
    address public owner; // Sözleşmenin sahibi (deploy eden kişi)
    address public propertyOwner; // Mülkün sahibi
    address public tenant; // Kiracı
    uint256 public depositAmount; // Depozito miktarı
    uint256 public depositCollected; // Toplanan depozito miktarı

    mapping(address => bool) public authorizedUsers; // Yetkilendirilmiş kullanıcılar haritası
    mapping(address => uint256) public tenantDeposits; // Kiracının depozito bilgileri
    mapping(address => bool) public depositReturned; // Depozitonun iade edilip edilmediğini gösteren harita

    event DepositCollected(address indexed tenant, uint256 amount);
    event DepositReturned(address indexed tenant, uint256 amount);
    event DepositClaimed(address indexed tenant, uint256 amount);
    event AuthorizedUserAdded(address indexed user);
    event AuthorizedUserRemoved(address indexed user);

    modifier onlyOwner() {
        require(msg.sender == owner, "Yalnızca sözleşme sahibi bu işlemi gerçekleştirebilir");
        _;
    }

    modifier onlyPropertyOwner() {
        require(msg.sender == propertyOwner, "Yalnızca mülk sahibi bu işlemi gerçekleştirebilir");
        _;
    }

    modifier onlyTenant() {
        require(msg.sender == tenant, "Yalnızca kiracı bu işlemi gerçekleştirebilir");
        _;
    }

    modifier onlyAuthorizedUsers() {
        require(authorizedUsers[msg.sender], "Bu işlemi gerçekleştirmek için yetkiniz yok");
        _;
    }

    constructor() {
        owner = msg.sender;
        // Başlangıçta sözleşmeyi dağıtan kişi mülk sahibi ve kiracı olarak ayarlanabilir
    }

    /**
     * @dev Depozito miktarını belirler.
     * @param amount Depozito miktarı.
     */
    function setDepositAmount(uint256 amount) public onlyPropertyOwner {
        depositAmount = amount;
    }

    /**
     * @dev Kiracı depozito ödemesini yapar.
     */
    function payDeposit() public payable onlyTenant {
        require(msg.value == depositAmount, "Yanlış depozito miktarı gönderildi");
        tenantDeposits[msg.sender] += msg.value;
        depositCollected += msg.value;
        emit DepositCollected(msg.sender, msg.value);
    }

    /**
     * @dev Depozitoyu iade eder.
     * @param tenant Kiracının adresi.
     */
    function returnDeposit(address tenant) public onlyPropertyOwner {
        uint256 amount = tenantDeposits[tenant];
        require(amount > 0, "İade edilecek depozito yok");
        require(!depositReturned[tenant], "Depozito zaten iade edildi");

        tenantDeposits[tenant] = 0;
        depositReturned[tenant] = true;
        payable(tenant).transfer(amount);

        emit DepositReturned(tenant, amount);
    }

    /**
     * @dev Kiracı depozito iadesini talep eder.
     */
    function claimDeposit() public onlyTenant {
        require(depositCollected > 0, "İade edilecek depozito bulunmuyor");
        require(tenantDeposits[msg.sender] > 0, "İade edilecek depozito bulunmuyor");
        
        uint256 amount = tenantDeposits[msg.sender];
        tenantDeposits[msg.sender] = 0;
        depositCollected -= amount;
        
        payable(msg.sender).transfer(amount);
        emit DepositClaimed(msg.sender, amount);
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
     * @dev Depozito miktarını raporlar.
     * @return Kiracının depozito miktarı.
     */
    function reportDepositAmount() public view returns (uint256) {
        return tenantDeposits[msg.sender];
    }
}