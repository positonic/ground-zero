// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.20;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract IncomeTracker is Ownable {
    // Mapping from token ID to its donations
    mapping(uint256 => Donation) public projectDonations;

    struct Donation {
        uint256 giveth;
        uint256 gitcoin;
        uint256 alloV2;
        uint256 celo;
        uint256 octant;
    }

    struct FundsRaised {
        uint256 usv;
        uint256 hyperspeed;
    }

    struct Income {
        uint256 year2022;
        uint256 year2023;
    }

    Donation public donations;
    FundsRaised public fundsRaised;
    Income public income;

    // Evaluator address (hardcoded)
    address public evaluator;
    address public constant INITIAL_OWNER =
        0x63A32F1595a68E811496D820680B74A5ccA303c5;

    constructor(address _evaluator) Ownable(INITIAL_OWNER) {
        // Initial setup can be done here if required
        //transferOwnership(_initialOwner);
        evaluator = _evaluator;
    }

    // Modifier to restrict access to Evaluator only
    modifier onlyEvaluator() {
        require(msg.sender == evaluator, "IT: Not an Evaluator");
        _;
    }

    // Setters for updating income streams
    function updateDonations(
        uint256 tokenId,
        uint256 _giveth,
        uint256 _gitcoin,
        uint256 _alloV2,
        uint256 _celo,
        uint256 _octant
    ) external onlyEvaluator {
        require(
            _exists(tokenId),
            "ERC721: operator query for nonexistent token"
        );
        // Add more checks as necessary, e.g., only owner or approved can update
        tokenDonations[tokenId] = Donation(
            _giveth,
            _gitcoin,
            _alloV2,
            _celo,
            _octant
        );
    }

    function setFundsRaised(
        uint256 _usv,
        uint256 _hyperspeed
    ) external onlyEvaluator {
        fundsRaised = FundsRaised(_usv, _hyperspeed);
    }

    function setIncome(
        uint256 _year2022,
        uint256 _year2023
    ) external onlyEvaluator {
        income = Income(_year2022, _year2023);
    }

    // Getters (if needed, as public variables have auto-generated getters)
    function getDonations() external view returns (Donation memory) {
        return donations;
    }

    function getFundsRaised() external view returns (FundsRaised memory) {
        return fundsRaised;
    }

    function getIncome() external view returns (Income memory) {
        return income;
    }
}
