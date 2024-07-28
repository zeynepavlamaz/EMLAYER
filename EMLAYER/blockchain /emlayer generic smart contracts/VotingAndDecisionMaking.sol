// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingAndDecisionMaking {
    address public owner; // Sözleşmenin sahibi (deploy eden kişi)
    uint256 public proposalIdCounter; // Teklif ID'si sayaç

    enum VoteOption { NoVote, Yes, No } // Oy seçeneği
    enum ProposalStatus { Pending, Active, Completed } // Teklif durumu

    struct Proposal {
        uint256 id; // Teklif ID'si
        string description; // Teklif açıklaması
        address proposer; // Teklifi öneren kişinin adresi
        ProposalStatus status; // Teklif durumu
        uint256 yesVotes; // Evet oyları
        uint256 noVotes; // Hayır oyları
        mapping(address => VoteOption) votes; // Oy verenlerin oyları
    }

    mapping(uint256 => Proposal) public proposals; // Teklif bilgileri
    mapping(address => bool) public authorizedUsers; // Yetkilendirilmiş kullanıcılar haritası

    event ProposalCreated(uint256 indexed proposalId, address indexed proposer, string description);
    event ProposalUpdated(uint256 indexed proposalId, ProposalStatus status);
    event VoteCast(uint256 indexed proposalId, address indexed voter, VoteOption voteOption);
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
        proposalIdCounter = 1; // İlk teklif ID'si 1'den başlar
    }

    /**
     * @dev Yeni bir teklif oluşturur.
     * @param description Teklifin açıklaması.
     */
    function createProposal(string calldata description) public onlyAuthorizedUsers {
        uint256 proposalId = proposalIdCounter++;
        Proposal storage newProposal = proposals[proposalId];
        newProposal.id = proposalId;
        newProposal.description = description;
        newProposal.proposer = msg.sender;
        newProposal.status = ProposalStatus.Pending;

        emit ProposalCreated(proposalId, msg.sender, description);
    }

    /**
     * @dev Teklifin durumunu günceller (Active veya Completed).
     * @param proposalId Teklif ID'si.
     * @param status Teklif durumu (Pending, Active, Completed).
     */
    function updateProposalStatus(uint256 proposalId, ProposalStatus status) public onlyAuthorizedUsers {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.id != 0, "Teklif bulunamadı");
        require(status != proposal.status, "Teklif durumu zaten bu");

        proposal.status = status;
        emit ProposalUpdated(proposalId, status);
    }

    /**
     * @dev Teklife oy kullanır.
     * @param proposalId Teklif ID'si.
     * @param voteOption Oy seçeneği (Yes, No).
     */
    function castVote(uint256 proposalId, VoteOption voteOption) public onlyAuthorizedUsers {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.id != 0, "Teklif bulunamadı");
        require(proposal.status == ProposalStatus.Active, "Teklif aktif değil");

        VoteOption currentVote = proposal.votes[msg.sender];
        require(currentVote == VoteOption.NoVote, "Zaten oy kullandınız");

        if (currentVote == VoteOption.Yes) {
            proposal.yesVotes--;
        } else if (currentVote == VoteOption.No) {
            proposal.noVotes--;
        }

        if (voteOption == VoteOption.Yes) {
            proposal.yesVotes++;
        } else if (voteOption == VoteOption.No) {
            proposal.noVotes++;
        }

        proposal.votes[msg.sender] = voteOption;
        emit VoteCast(proposalId, msg.sender, voteOption);
    }

    /**
     * @dev Teklifin oy sonuçlarını raporlar.
     * @param proposalId Teklif ID'si.
     * @return Teklif açıklaması, teklif durumu, evet oyları ve hayır oyları.
     */
    function reportProposalResults(uint256 proposalId) public view returns (
        string memory description,
        ProposalStatus status,
        uint256 yesVotes,
        uint256 noVotes
    ) {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.id != 0, "Teklif bulunamadı");

        return (
            proposal.description,
            proposal.status,
            proposal.yesVotes,
            proposal.noVotes
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