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
    mapping(uint256 => address) public tokenMinter;
    address public admin;
    address public nftFactory;

    modifier onlyFactory() {
        require(msg.sender == nftFactory, "only factory");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "only Admin");
        _;
    }

    constructor(address _factory) ERC721("Guild embership NFT", "GuildNFT") {
        admin = msg.sender;
        nftFactory = _factory;
        _tokenCounter++; // Start Token IDs from 1 instead of 0, we use 0 to indicate absense of NFT on a wallet
    }

    function setAdmin(address account) public onlyAdmin {
        admin = account;
    }

    function setFactory(address account) public onlyAdmin {
        nftFactory = account;
    }

    function issueNFT(
        address user,
        string memory tokenURI
    ) public onlyFactory returns (uint256) {
        uint256 newNFTId = _tokenCounter;
        _mint(user, newNFTId);
        _setTokenURI(newNFTId, tokenURI);
        tokenMinter[newNFTId] = user;
        _tokenCounter++;
        return newNFTId;
    }

    function changeURI(uint256 tokenID, string memory tokenURI) public {
        address handler = INFTFactory(nftFactory).getHandler(tokenID);
        require(msg.sender == handler, "Only Handler can update Token's URI");
        _setTokenURI(tokenID, tokenURI);
    }

    function tier(uint256 tokenID) public view returns (uint256) {
        address handler = INFTFactory(nftFactory).getHandler(tokenID);
        return IReferralHandler(handler).getTier();
    }

    function transfer( // internal + is never used 
        address from,
        address to,
        uint256 tokenId
    ) internal virtual  {
        INFTFactory(nftFactory).registerUserEpoch(to); // Alerting NFT Factory to update incase of new user
        super._transfer(from, to, tokenId);
    }

    function getTransferLimit(uint256 tokenID) public view returns (uint256) {
        address handler = INFTFactory(nftFactory).getHandler(tokenID);
        return IReferralHandler(handler).getTransferLimit();
    }

    function recoverTokens(
        address _token,
        address benefactor
    ) public onlyAdmin {
        uint256 tokenBalance = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(benefactor, tokenBalance);
    }
}