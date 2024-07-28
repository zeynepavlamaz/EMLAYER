// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsuranceManagement {
    address public owner; // Sözleşmenin sahibi (deploy eden kişi)
    uint256 public policyIdCounter; // Poliçe ID'si sayaç
    uint256 public claimIdCounter; // Talep ID'si sayaç

    enum PolicyStatus { Active, Inactive } // Poliçe durumu
    enum ClaimStatus { Pending, Approved, Rejected } // Talep durumu

    struct Policy {
        uint256 id; // Poliçe ID'si
        address policyHolder; // Poliçe sahibinin adresi
        string description; // Poliçe açıklaması
        uint256 coverageAmount; // Sigorta teminat tutarı
        PolicyStatus status; // Poliçe durumu
    }

    struct Claim {
        uint256 id; // Talep ID'si
        uint256 policyId; // İlgili poliçe ID'si
        address claimant; // Talep eden kişinin adresi
        uint256 claimAmount; // Talep edilen tutar
        ClaimStatus status; // Talep durumu
    }

    mapping(uint256 => Policy) public policies; // Poliçe bilgileri
    mapping(uint256 => Claim) public claims; // Sigorta talep bilgileri
    mapping(address => bool) public authorizedUsers; // Yetkilendirilmiş kullanıcılar haritası

    event PolicyCreated(uint256 indexed policyId, address indexed policyHolder, string description, uint256 coverageAmount);
    event PolicyUpdated(uint256 indexed policyId, PolicyStatus status);
    event ClaimCreated(uint256 indexed claimId, uint256 indexed policyId, address indexed claimant, uint256 claimAmount);
    event ClaimReviewed(uint256 indexed claimId, ClaimStatus status);
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
        policyIdCounter = 1; // İlk poliçe ID'si 1'den başlar
        claimIdCounter = 1; // İlk talep ID'si 1'den başlar
    }

    /**
     * @dev Yeni bir sigorta poliçesi oluşturur.
     * @param description Poliçenin açıklaması.
     * @param coverageAmount Sigorta teminat tutarı.
     */
    function createPolicy(string calldata description, uint256 coverageAmount) public {
        uint256 policyId = policyIdCounter++;
        policies[policyId] = Policy({
            id: policyId,
            policyHolder: msg.sender,
            description: description,
            coverageAmount: coverageAmount,
            status: PolicyStatus.Active
        });

        emit PolicyCreated(policyId, msg.sender, description, coverageAmount);
    }

    /**
     * @dev Poliçe bilgilerini günceller.
     * @param policyId Poliçe ID'si.
     * @param status Poliçe durumu (Active veya Inactive).
     */
    function updatePolicyStatus(uint256 policyId, PolicyStatus status) public onlyAuthorizedUsers {
        Policy storage policy = policies[policyId];
        require(policy.id != 0, "Poliçe bulunamadı");
        require(status != policy.status, "Poliçe durumu zaten bu");

        policy.status = status;
        emit PolicyUpdated(policyId, status);
    }

    /**
     * @dev Sigorta talebi oluşturur.
     * @param policyId Poliçe ID'si.
     * @param claimAmount Talep edilen tutar.
     */
    function createClaim(uint256 policyId, uint256 claimAmount) public {
        Policy storage policy = policies[policyId];
        require(policy.id != 0, "Poliçe bulunamadı");
        require(policy.status == PolicyStatus.Active, "Poliçe aktif değil");

        uint256 claimId = claimIdCounter++;
        claims[claimId] = Claim({
            id: claimId,
            policyId: policyId,
            claimant: msg.sender,
            claimAmount: claimAmount,
            status: ClaimStatus.Pending
        });

        emit ClaimCreated(claimId, policyId, msg.sender, claimAmount);
    }

    /**
     * @dev Sigorta talebini inceler ve onaylar veya reddeder.
     * @param claimId Talep ID'si.
     * @param status Talep durumu (Pending, Approved, Rejected).
     */
    function reviewClaim(uint256 claimId, ClaimStatus status) public onlyAuthorizedUsers {
        Claim storage claim = claims[claimId];
        require(claim.id != 0, "Talep bulunamadı");
        require(status != claim.status, "Talep durumu zaten bu");

        claim.status = status;
        emit ClaimReviewed(claimId, status);
    }

    /**
     * @dev Sigorta talep bilgilerini raporlar.
     * @param claimId Talep ID'si.
     * @return Poliçe ID'si, talep eden kişi, talep edilen tutar, talep durumu.
     */
    function reportClaim(uint256 claimId) public view returns (
        uint256 policyId,
        address claimant,
        uint256 claimAmount,
        ClaimStatus status
    ) {
        Claim storage claim = claims[claimId];
        require(claim.id != 0, "Talep bulunamadı");

        return (
            claim.policyId,
            claim.claimant,
            claim.claimAmount,
            claim.status
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