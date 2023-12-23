// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "../src/NFT.sol"; // Update the import path as needed
import "forge-std/console.sol";

contract NFTTest is Test {
    NFT nft;
    IncomeTracker incomeTracker;
    address public constant INITIAL_OWNER =
        0x63A32F1595a68E811496D820680B74A5ccA303c5;
    // Addresses for the initial owner and evaluator (use test addresses or mock values)
    address evaluator = address(this); // Mock evaluator address; replace with actual for real testing

    function setUp() public {
        // Deploy the IncomeTracker contract with initial owner and evaluator
        incomeTracker = new IncomeTracker(evaluator);

        // Deploy the NFT contract, initializing it with the IncomeTracker address
        nft = new NFT("MyNFT", "MNFT", "https://mybaseuri.com/", evaluator);
    }

    function testInitialOwner() public {
        // Check that the deployer (this test contract) is the owner
        assertEq(nft.owner(), INITIAL_OWNER);
    }

    function testMinting() public {
        // Try minting a new token
        uint256 tokenId = nft.mintTo(INITIAL_OWNER);
        assertEq(tokenId, 1); // Token IDs typically start at 1
        assertEq(nft.ownerOf(tokenId), INITIAL_OWNER); // Check owner of minted token
    }

    function testFailMintBeyondMaxSupply() public {
        // Mint up to the maximum
        for (uint256 i = 0; i < nft.TOTAL_SUPPLY(); i++) {
            nft.mintTo(address(this));
        }
        // This next mint should fail
        nft.mintTo(address(this));
    }

    function testUpdateIncome() public {
        vm.prank(evaluator);

        // Update income via NFT contract
        nft.updateIncome(100, 200); // Example values for 2022, 2023

        // Fetch income from the IncomeTracker and verify
        IncomeTracker.Income memory income = nft.incomeTracker().getIncome();
        uint256 year2022 = income.year2022;
        uint256 year2023 = income.year2023;
        console.log("Income after update - 2022:", year2022);
        console.log("Income after update - 2023:", year2023);
        assertEq(year2022, 100);
        assertEq(year2023, 200);
    }
}
