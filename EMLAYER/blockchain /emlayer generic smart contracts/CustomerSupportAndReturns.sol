// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CustomerSupportAndReturns {
    address public owner; // Sözleşmenin sahibi (deploy eden kişi)
    uint256 public requestIdCounter; // Destek ve iade talepleri için sayaç

    enum RequestStatus { Open, InProgress, Resolved, Closed } // Destek ve iade talep durumları
    enum RequestType { Support, Return } // Talep türleri

    struct Request {
        address requester; // Talep sahibinin adresi
        RequestType requestType; // Talep türü
        string description; // Talep açıklaması
        RequestStatus status; // Talep durumu
        uint256 createdAt; // Talep oluşturulma zamanı
        uint256 updatedAt; // Talep güncellenme zamanı
    }

    mapping(uint256 => Request) public requests; // Taleplerin ID'ye göre saklanması
    mapping(address => uint256[]) public userRequests; // Kullanıcıya göre taleplerin listesi

    event RequestCreated(uint256 requestId, address indexed requester, RequestType requestType, string description);
    event RequestStatusUpdated(uint256 requestId, RequestStatus newStatus);
    event RequestResponded(uint256 requestId, string response);
    event ReturnProcessed(uint256 requestId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Yalnızca sözleşme sahibi bu işlemi gerçekleştirebilir");
        _;
    }

    constructor() {
        owner = msg.sender;
        requestIdCounter = 1; // Başlangıçta talep ID'si 1'den başlar
    }

    /**
     * @dev Müşteri destek talebi oluşturur.
     * @param description Talep açıklaması.
     */
    function createSupportRequest(string memory description) public {
        uint256 requestId = requestIdCounter++;
        requests[requestId] = Request({
            requester: msg.sender,
            requestType: RequestType.Support,
            description: description,
            status: RequestStatus.Open,
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        userRequests[msg.sender].push(requestId);

        emit RequestCreated(requestId, msg.sender, RequestType.Support, description);
    }

    /**
     * @dev İade talebi oluşturur.
     * @param description Talep açıklaması.
     */
    function createReturnRequest(string memory description) public {
        uint256 requestId = requestIdCounter++;
        requests[requestId] = Request({
            requester: msg.sender,
            requestType: RequestType.Return,
            description: description,
            status: RequestStatus.Open,
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        userRequests[msg.sender].push(requestId);

        emit RequestCreated(requestId, msg.sender, RequestType.Return, description);
    }

    /**
     * @dev Destek veya iade talebinin durumunu günceller.
     * @param requestId Talep ID'si.
     * @param newStatus Yeni talep durumu.
     */
    function updateRequestStatus(uint256 requestId, RequestStatus newStatus) public onlyOwner {
        require(requests[requestId].status != RequestStatus.Closed, "Talep zaten kapatıldı");
        requests[requestId].status = newStatus;
        requests[requestId].updatedAt = block.timestamp;

        emit RequestStatusUpdated(requestId, newStatus);
    }

    /**
     * @dev Talebe yanıt verir.
     * @param requestId Talep ID'si.
     * @param response Yanıt metni.
     */
    function respondToRequest(uint256 requestId, string memory response) public onlyOwner {
        require(requests[requestId].status != RequestStatus.Closed, "Talep zaten kapatıldı");

        emit RequestResponded(requestId, response);
    }

    /**
     * @dev İade talebini işleme alır ve kapatır.
     * @param requestId Talep ID'si.
     */
    function processReturn(uint256 requestId) public onlyOwner {
        require(requests[requestId].requestType == RequestType.Return, "Bu bir iade talebi değil");
        require(requests[requestId].status == RequestStatus.Open, "Talep kapalı");

        requests[requestId].status = RequestStatus.Closed;
        requests[requestId].updatedAt = block.timestamp;

        emit ReturnProcessed(requestId);
    }

    /**
     * @dev Kullanıcının taleplerini getirir.
     * @param user Kullanıcının adresi.
     * @return Kullanıcının talep ID'leri listesi.
     */
    function getUserRequests(address user) public view returns (uint256[] memory) {
        return userRequests[user];
    }
}