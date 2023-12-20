// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "./interfaces/INFTFactory.sol";
import "./interfaces/IReferralHandler.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ProfileNFT is ERC721URIStorage {
    using SafeERC20 for IERC20;
    
    uint32 private _tokenCounter;
    mapping(uint256 => address) public tokenMinter; // not needed
    address public admin;
    address public nexus;

    modifier onlyNexus() { // nexus / hub
        require(msg.sender == nexus, "only nexus");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "only Admin");
        _;
    }

    constructor(address _factory) ERC721("Guild membership NFT", "GuildNFT") {
        admin = msg.sender;
        nexus = _factory;
        _tokenCounter++; // Start Token IDs from 1 instead of 0, we use 0 to indicate absense of NFT on a wallet
    }

    function setAdmin(address account) public onlyAdmin {
        admin = account;
    }

    function setNexus(address account) public onlyAdmin {
        nexus = account;
    }

    function issueNFT(
        address user,
        string memory tokenURI
    ) public onlyNexus returns (uint32) {
        uint32 newNFTId = _tokenCounter;
        _mint(user, newNFTId);
        _setTokenURI(newNFTId, tokenURI);
        tokenMinter[newNFTId] = user; // do we need  this?
        _tokenCounter++;
        return newNFTId;
    }

    function changeURI(uint256 tokenID, string memory tokenURI) public {
        address handler = INFTFactory(nexus).getHandler(tokenID);
        require(msg.sender == handler, "Only Handler can update Token's URI");
        _setTokenURI(tokenID, tokenURI);
    }

    function tier(uint256 tokenID) public view returns (uint256) {
        address handler = INFTFactory(nexus).getHandler(tokenID);
        return IReferralHandler(handler).getTier(); // unit256 for tier?
    }

    function transfer( // internal + is never used 
        address _to,
        uint256 _tokenId
    ) external virtual  {
        INFTFactory(nexus).registerUserEpoch(_to); // Alerting NFT Factory to update incase of new user address
        super.transferFrom(msg.sender, _to, _tokenId);
        //_transfer(msg.sender, to, tokenId);
    }

    function getTransferLimit(uint256 tokenID) public view returns (uint256) {
        address handler = INFTFactory(nexus).getHandler(tokenID);
        return IReferralHandler(handler).getTransferLimit();
    }


    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    function recoverTokens(
        address _token,
        address benefactor
    ) public onlyAdmin {
        uint256 tokenBalance = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(benefactor, tokenBalance);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function transfer(
        address from,
        address to,
        uint256 tokenId
    ) external virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        //_beforeTokenTransfer(from, to, tokenId, 1);

        // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(balanceOf(to) == 0, "One address cannot have multiple tokens");

        _transfer(from, to, tokenId);
    }
}