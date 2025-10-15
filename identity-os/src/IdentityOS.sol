//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IdentityOS {
    // User's evolved identity
    struct Identity {
        address userAddress;
        string identityName;
        string archetype;
        uint256 reputationScore;
        uint256 transactionCount;
        uint256 createdAt;
        bool isRevealed;
    }

    // Mapping from address to their identity
    mapping(address => Identity) public identities;

    // Track all registered users
    address[] public allUsers;

    // Behavior metrics (simplified for MVP)
    mapping(address => uint256) public dexSwaps;
    mapping(address => uint256) public nftActivity;
    mapping(address => uint256) public governanceVotes;
    mapping(address => uint256) public totalValueTransferred;

    // Events
    event IdentityCreated(address indexed user, uint256 timestamp);
    event IdentityEvolved(
        address indexed user,
        string newName,
        string archetype
    );
    event BehaviorTracked(address indexed user, string actionType);

    constructor() {}

    /**
     * @dev Create initial identity for a user
     */
    function createIdentity() external {
        require(
            identities[msg.sender].userAddress == address(0),
            "Identity already exists"
        );

        identities[msg.sender] = Identity({
            userAddress: msg.sender,
            identityName: "Unforged",
            archetype: "Unknown",
            reputationScore: 0,
            transactionCount: 0,
            createdAt: block.timestamp,
            isRevealed: false
        });

        allUsers.push(msg.sender);
        emit IdentityCreated(msg.sender, block.timestamp);
    }

    /**
     * @dev Track user behavior (simplified - in production this would be automated)
     */
    function trackBehavior(string memory actionType) external {
        require(
            identities[msg.sender].userAddress != address(0),
            "Create identity first"
        );

        identities[msg.sender].transactionCount++;

        // Simple behavior tracking
        if (keccak256(bytes(actionType)) == keccak256(bytes("dex_swap"))) {
            dexSwaps[msg.sender]++;
        } else if (keccak256(bytes(actionType)) == keccak256(bytes("nft"))) {
            nftActivity[msg.sender]++;
        } else if (
            keccak256(bytes(actionType)) == keccak256(bytes("governance"))
        ) {
            governanceVotes[msg.sender]++;
        }

        emit BehaviorTracked(msg.sender, actionType);

        // Auto-evolve identity if threshold reached
        if (
            identities[msg.sender].transactionCount >= 10 &&
            !identities[msg.sender].isRevealed
        ) {
            _evolveIdentity(msg.sender);
        }
    }

    /**
     * @dev Internal function to evolve identity based on behavior
     */
    function _evolveIdentity(address user) internal {
        Identity storage identity = identities[user];

        // Simple archetype determination
        uint256 dexScore = dexSwaps[user];
        uint256 nftScore = nftActivity[user];
        uint256 govScore = governanceVotes[user];

        string memory newName;
        string memory archetype;

        // Determine archetype based on dominant behavior
        if (dexScore > nftScore && dexScore > govScore) {
            archetype = "DeFi Native";
            newName = "TheYieldSeeker";
        } else if (nftScore > dexScore && nftScore > govScore) {
            archetype = "NFT Collector";
            newName = "TheArtCurator";
        } else if (govScore > dexScore && govScore > nftScore) {
            archetype = "Governance Delegate";
            newName = "TheVoteKeeper";
        } else {
            archetype = "Renaissance";
            newName = "TheChainPioneer";
        }

        identity.identityName = newName;
        identity.archetype = archetype;
        identity.reputationScore = identity.transactionCount * 10;
        identity.isRevealed = true;

        emit IdentityEvolved(user, newName, archetype);
    }

    /**
     * @dev Get user's identity
     */
    function getIdentity(address user) external view returns (Identity memory) {
        require(
            identities[user].userAddress != address(0),
            "Identity does not exist"
        );
        return identities[user];
    }

    /**
     * @dev Get user's behavior metrics
     */
    function getBehaviorMetrics(
        address user
    ) external view returns (uint256, uint256, uint256) {
        return (dexSwaps[user], nftActivity[user], governanceVotes[user]);
    }

    /**
     * @dev Check if identity is revealed (10+ transactions)
     */
    function isIdentityRevealed(address user) external view returns (bool) {
        return identities[user].isRevealed;
    }

    /**
     * @dev Get total registered users
     */
    function getTotalUsers() external view returns (uint256) {
        return allUsers.length;
    }

    /**
     * @dev Get all users (for leaderboard)
     */
    function getAllUsers() external view returns (address[] memory) {
        return allUsers;
    }

    /**
     * @dev Get identity name (returns "Unforged" if not revealed yet)
     */
    function getIdentityName(
        address user
    ) external view returns (string memory) {
        if (identities[user].userAddress == address(0)) {
            return "No Identity";
        }
        return identities[user].identityName;
    }

    /**
     * @dev Get archetype
     */
    function getArchetype(address user) external view returns (string memory) {
        if (identities[user].userAddress == address(0)) {
            return "Unknown";
        }
        return identities[user].archetype;
    }

    /**
     * @dev Get reputation score
     */
    function getReputationScore(address user) external view returns (uint256) {
        return identities[user].reputationScore;
    }
}
