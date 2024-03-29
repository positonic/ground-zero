// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.20;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./IncomeTracker.sol"; // Import the IncomeTracker contract

error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();

contract NFT is ERC721, Ownable {
    using Strings for uint256;

    string public baseURI;
    uint256 public currentTokenId;
    uint256 public constant TOTAL_SUPPLY = 50;
    address public constant INITIAL_OWNER =
        0x63A32F1595a68E811496D820680B74A5ccA303c5;
    IncomeTracker public incomeTracker; // Reference to the IncomeTracker contract
    address public evaluator;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI,
        address _evaluator
    ) ERC721(_name, _symbol) Ownable(INITIAL_OWNER) {
        baseURI = _baseURI;
        evaluator = _evaluator;
        incomeTracker = new IncomeTracker(address(this)); // Initialize the IncomeTracker
    }

    function mintTo(address recipient) public returns (uint256) {
        uint256 newTokenId = ++currentTokenId;
        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert NonExistentTokenURI();
        }
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    function withdrawPayments(address payable payee) external onlyOwner {
        uint256 balance = address(this).balance;
        (bool transferTx, ) = payee.call{value: balance}("");
        if (!transferTx) {
            revert WithdrawTransfer();
        }
    }

    // Modifier to restrict access to Evaluator only
    modifier onlyEvaluator() {
        require(msg.sender == evaluator, "NFT: Not an Evaluator");
        _;
    }

    // Modifier that requires the current caller to be the owner of the token.
    modifier onlyTokenOwner(uint256 tokenId) {
        require(
            ownerOf(tokenId) == msg.sender,
            "Caller is not the token owner"
        );
        _;
    }

    // Interaction functions with IncomeTracker (Optional: For direct access from NFT contract)
    function updateDonations(
        uint256 _giveth,
        uint256 _gitcoin,
        uint256 _alloV2,
        uint256 _celo,
        uint256 _octant
    ) external onlyEvaluator onlyTokenOwner(tokenId) {
        incomeTracker.setDonations(_giveth, _gitcoin, _alloV2, _celo, _octant);
    }

    function updateFundsRaised(
        uint256 _usv,
        uint256 _hyperspeed
    ) external onlyEvaluator onlyTokenOwner(tokenId) {
        incomeTracker.setFundsRaised(_usv, _hyperspeed);
    }

    function updateIncome(
        uint256 _year2022,
        uint256 _year2023
    ) external onlyEvaluator onlyTokenOwner(tokenId) c {
        incomeTracker.setIncome(_year2022, _year2023);
    }
}
