// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/NFT.sol"; // Update the import path as needed

contract NFTTest is Test {
    NFT nft;
    address recipient = address(0x123);
    address constant initialOwner = 0x63A32F1595a68E811496D820680B74A5ccA303c5;

    function setUp() public {
        nft = new NFT("TestNFT", "TNFT", "https://example.com/");
    }

    function testMintTo() public {
        vm.prank(initialOwner); // Simulate transaction from initial owner
        uint256 tokenId = nft.mintTo(recipient);
        assertEq(
            nft.ownerOf(tokenId),
            recipient,
            "Recipient should own the new token"
        );
    }

    function testTokenURI() public {
        vm.prank(initialOwner); // Simulate transaction from initial owner
        uint256 tokenId = nft.mintTo(recipient);
        string memory expectedURI = string(
            abi.encodePacked("https://example.com/", Strings.toString(tokenId))
        );
        assertEq(
            nft.tokenURI(tokenId),
            expectedURI,
            "tokenURI should return the correct string"
        );
    }

    function testWithdrawPayments() public {
        // Setup: Mint a token to ensure there's some balance in the contract
        vm.prank(initialOwner); // Simulate transaction from initial owner
        nft.mintTo(recipient);

        // Simulate sending ether to the contract (if needed)
        payable(address(nft)).transfer(1 ether);

        // Withdraw balance
        uint256 contractBalanceBefore = address(nft).balance;
        address payable payee = payable(address(this));
        uint256 payeeBalanceBefore = payee.balance;

        vm.prank(initialOwner); // Simulate transaction from initial owner
        nft.withdrawPayments(payee);

        uint256 contractBalanceAfter = address(nft).balance;
        uint256 payeeBalanceAfter = payee.balance;

        assertEq(
            contractBalanceAfter,
            0,
            "Contract balance should be zero after withdrawal"
        );
        assertEq(
            payeeBalanceAfter,
            payeeBalanceBefore + contractBalanceBefore,
            "Payee balance should increase by the withdrawn amount"
        );
    }
}
