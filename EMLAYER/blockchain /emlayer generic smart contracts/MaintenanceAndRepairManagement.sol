// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MaintenanceAndRepairManagement {
    address public owner; // Sözleşmenin sahibi (deploy eden kişi)
    address public propertyOwner; // Mülkün sahibi
    address public maintenancePersonnel; // Bakım ve onarım personeli
    uint256 public requestIdCounter; // Talep ID'si sayaç

    enum RequestStatus { Pending, Approved, Completed } // Talep durumu
    struct MaintenanceRequest {
        uint256 id; // Talep ID'si
        string description; // Talep açıklaması
        address requester; // Talep eden kişinin adresi
        RequestStatus status; // Talep durumu
    }

    mapping(uint256 => MaintenanceRequest) public requests; // Talep bilgileri
    mapping(address => bool) public authorizedUsers; // Yetkilendirilmiş kullanıcılar haritası

    event MaintenanceRequestCreated(uint256 indexed requestId, address indexed requester, string description);
    event MaintenanceRequestUpdated(uint256 indexed requestId, RequestStatus status);
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

    modifier onlyMaintenancePersonnel() {
        require(msg.sender == maintenancePersonnel, "Yalnızca bakım ve onarım personeli bu işlemi gerçekleştirebilir");
        _;
    }

    modifier onlyAuthorizedUsers() {
        require(authorizedUsers[msg.sender], "Bu işlemi gerçekleştirmek için yetkiniz yok");
        _;
    }

    constructor() {
        owner = msg.sender;
        requestIdCounter = 1; // İlk talep ID'si 1'den başlar
    }

    /**
     * @dev Mülk sahibinin bakım ve onarım personelini ayarlamasını sağlar.
     * @param personnel Bakım ve onarım personelinin adresi.
     */
    function setMaintenancePersonnel(address personnel) public onlyOwner {
        maintenancePersonnel = personnel;
    }

    /**
     * @dev Bakım ve onarım talebi oluşturur.
     * @param description Talebin açıklaması.
     */
    function createMaintenanceRequest(string calldata description) public {
        uint256 requestId = requestIdCounter++;
        requests[requestId] = MaintenanceRequest({
            id: requestId,
            description: description,
            requester: msg.sender,
            status: RequestStatus.Pending
        });

        emit MaintenanceRequestCreated(requestId, msg.sender, description);
    }

    /**
     * @dev Bakım ve onarım talebini günceller (onaylar veya tamamlar).
     * @param requestId Talep ID'si.
     * @param status Talep durumu (Pending, Approved, Completed).
     */
    function updateMaintenanceRequest(uint256 requestId, RequestStatus status) public onlyMaintenancePersonnel {
        MaintenanceRequest storage request = requests[requestId];
        require(request.id != 0, "Talep bulunamadı");
        require(status != request.status, "Talep durumu zaten bu");

        request.status = status;
        emit MaintenanceRequestUpdated(requestId, status);
    }

    /**
     * @dev Bakım ve onarım taleplerini raporlar.
     * @param requestId Talep ID'si.
     * @return Talebin açıklaması, talep eden kişinin adresi ve durumu.
     */
    function reportMaintenanceRequest(uint256 requestId) public view returns (string memory, address, RequestStatus) {
        MaintenanceRequest storage request = requests[requestId];
        require(request.id != 0, "Talep bulunamadı");

        return (request.description, request.requester, request.status);
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