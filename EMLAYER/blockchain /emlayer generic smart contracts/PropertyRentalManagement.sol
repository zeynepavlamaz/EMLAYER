// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PropertyRentalManagement {
    address public owner; // Sözleşmenin sahibi (deploy eden kişi)
    address public propertyOwner; // Mülkün sahibi
    uint256 public rentAmount; // Kira bedeli
    uint256 public rentDueDate; // Kira ödeme tarihi

    mapping(address => bool) public authorizedUsers; // Yetkilendirilmiş kullanıcılar haritası
    mapping(address => uint256) public tenantBalances; // Kiracıların bakiye bilgileri
    mapping(address => uint256) public rentalPayments; // Kiraların ödenme bilgileri

    event RentCollected(address indexed tenant, uint256 amount);
    event RentDueDateUpdated(uint256 newDueDate);
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

    modifier onlyAuthorizedUsers() {
        require(authorizedUsers[msg.sender], "Bu işlemi gerçekleştirmek için yetkiniz yok");
        _;
    }

    constructor() {
        owner = msg.sender;
        propertyOwner = msg.sender; // Başlangıçta, sözleşmeyi dağıtan kişi mülk sahibidir
    }

    /**
     * @dev Kira bedelini belirle ve kira ödeme tarihini ayarla.
     * @param amount Kira bedeli.
     * @param dueDate Kira ödeme tarihi (timestamp olarak).
     */
    function setRentDetails(uint256 amount, uint256 dueDate) public onlyPropertyOwner {
        rentAmount = amount;
        rentDueDate = dueDate;
        emit RentDueDateUpdated(dueDate);
    }

    /**
     * @dev Kiracının kira bedelini ödemesini sağlar.
     */
    function payRent() public payable {
        require(msg.value == rentAmount, "Yanlış kira bedeli gönderildi");
        require(block.timestamp <= rentDueDate, "Kira ödeme tarihi geçti");

        tenantBalances[msg.sender] += msg.value;
        rentalPayments[msg.sender] += msg.value;

        emit RentCollected(msg.sender, msg.value);
    }

    /**
     * @dev Kiracının ödemelerini kontrol eder.
     * @return Kiracının bakiye bilgisi.
     */
    function checkBalance() public view returns (uint256) {
        return tenantBalances[msg.sender];
    }

    /**
     * @dev Kira ödeme tarihini günceller.
     * @param newDueDate Yeni kira ödeme tarihi (timestamp olarak).
     */
    function updateRentDueDate(uint256 newDueDate) public onlyPropertyOwner {
        rentDueDate = newDueDate;
        emit RentDueDateUpdated(newDueDate);
    }

    /**
     * @dev Belirli bir kiracının kira ödemelerini toplar ve mülk sahibine gönderir.
     * @param tenant Kiracının adresi.
     */
    function collectRentFromTenant(address tenant) public onlyAuthorizedUsers {
        uint256 amount = rentalPayments[tenant];
        require(amount > 0, "Kiracıdan toplanacak kira ödemesi yok");

        rentalPayments[tenant] = 0;
        payable(propertyOwner).transfer(amount);
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
     * @dev Kira gelirlerinin raporlanmasını sağlar.
     * @param tenant Kiracının adresi.
     * @return Kiracının ödedikleri toplam miktar.
     */
    function reportRentalPayments(address tenant) public view onlyAuthorizedUsers returns (uint256) {
        return rentalPayments[tenant];
    }
}