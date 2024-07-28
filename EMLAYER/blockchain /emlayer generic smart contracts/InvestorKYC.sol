// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InvestorKYC {
    address public owner; // Sözleşmenin sahibi (deploy eden kişi)
    uint256 public kycIdCounter; // KYC ID'si sayaç

    enum KYCStatus { Pending, Approved, Rejected } // KYC durumu

    struct KYC {
        uint256 id; // KYC ID'si
        address investor; // Yatırımcının adresi
        string fullName; // Tam isim
        string documentType; // Belge türü (e.g., kimlik, pasaport)
        string documentNumber; // Belge numarası
        KYCStatus status; // KYC durumu
    }

    mapping(uint256 => KYC) public kycs; // KYC bilgileri
    mapping(address => uint256) public investorKYC; // Yatırımcıların KYC ID'leri
    mapping(address => bool) public authorizedUsers; // Yetkilendirilmiş kullanıcılar haritası

    event KYCSubmitted(uint256 indexed kycId, address indexed investor, string fullName, string documentType, string documentNumber);
    event KYCStatusUpdated(uint256 indexed kycId, KYCStatus status);
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
        kycIdCounter = 1; // İlk KYC ID'si 1'den başlar
    }

    /**
     * @dev Yatırımcıların KYC bilgilerini kaydeder.
     * @param fullName Yatırımcının tam adı.
     * @param documentType KYC belgesinin türü (e.g., kimlik, pasaport).
     * @param documentNumber KYC belgesinin numarası.
     */
    function submitKYC(string calldata fullName, string calldata documentType, string calldata documentNumber) public {
        require(investorKYC[msg.sender] == 0, "Bu yatırımcı zaten KYC bilgilerini göndermiş");
        
        uint256 kycId = kycIdCounter++;
        kycs[kycId] = KYC({
            id: kycId,
            investor: msg.sender,
            fullName: fullName,
            documentType: documentType,
            documentNumber: documentNumber,
            status: KYCStatus.Pending
        });

        investorKYC[msg.sender] = kycId;

        emit KYCSubmitted(kycId, msg.sender, fullName, documentType, documentNumber);
    }

    /**
     * @dev Yatırımcının KYC bilgilerini günceller.
     * @param kycId KYC ID'si.
     * @param fullName Güncellenmiş tam isim.
     * @param documentType Güncellenmiş belge türü.
     * @param documentNumber Güncellenmiş belge numarası.
     */
    function updateKYC(uint256 kycId, string calldata fullName, string calldata documentType, string calldata documentNumber) public onlyAuthorizedUsers {
        KYC storage kyc = kycs[kycId];
        require(kyc.id != 0, "KYC bulunamadı");
        require(kyc.investor == msg.sender || authorizedUsers[msg.sender], "Bu işlem için yetkiniz yok");

        kyc.fullName = fullName;
        kyc.documentType = documentType;
        kyc.documentNumber = documentNumber;

        emit KYCStatusUpdated(kycId, kyc.status);
    }

    /**
     * @dev KYC bilgilerini inceler ve onaylar veya reddeder.
     * @param kycId KYC ID'si.
     * @param status KYC durumu (Pending, Approved, Rejected).
     */
    function reviewKYC(uint256 kycId, KYCStatus status) public onlyAuthorizedUsers {
        KYC storage kyc = kycs[kycId];
        require(kyc.id != 0, "KYC bulunamadı");
        require(status != kyc.status, "KYC durumu zaten bu");

        kyc.status = status;
        emit KYCStatusUpdated(kycId, status);
    }

    /**
     * @dev Yatırımcının KYC bilgilerini raporlar.
     * @param investor Yatırımcının adresi.
     * @return KYC ID'si, tam isim, belge türü, belge numarası, KYC durumu.
     */
    function reportKYC(address investor) public view returns (
        uint256 kycId,
        string memory fullName,
        string memory documentType,
        string memory documentNumber,
        KYCStatus status
    ) {
        uint256 id = investorKYC[investor];
        KYC storage kyc = kycs[id];
        require(kyc.id != 0, "KYC bulunamadı");

        return (
            kyc.id,
            kyc.fullName,
            kyc.documentType,
            kyc.documentNumber,
            kyc.status
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