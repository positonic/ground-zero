// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.20;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract IncomeTracker is Ownable {
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

    constructor(string memory _initialOwner) {
        // Initial setup can be done here if required
        transferOwnership(_initialOwner);
    }

    // Setters for updating income streams
    function setDonations(
        uint256 _giveth,
        uint256 _gitcoin,
        uint256 _alloV2,
        uint256 _celo,
        uint256 _octant
    ) external onlyOwner {
        donations = Donation(_giveth, _gitcoin, _alloV2, _celo, _octant);
    }

    function setFundsRaised(
        uint256 _usv,
        uint256 _hyperspeed
    ) external onlyOwner {
        fundsRaised = FundsRaised(_usv, _hyperspeed);
    }

    function setIncome(
        uint256 _year2022,
        uint256 _year2023
    ) external onlyOwner {
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
