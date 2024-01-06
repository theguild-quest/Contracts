// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "./interfaces/INexus.sol";
import "./interfaces/IReferralHandler.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ProfileNFT is ERC721URIStorage {
    using SafeERC20 for IERC20;
    
    uint32 private _tokenCounter;

    address public councelor;
    address public nexus;
    // Mapping from owner address to token ID
    mapping(address => uint32[]) private _tokenIdsByAddress;


    modifier onlyNexus() { // nexus / hub
        require(msg.sender == nexus, "only nexus");
        _;
    }

    modifier onlyCouncelor() {
        require(msg.sender == councelor, "only Councelor");
        _;
    }

    constructor(address _factory) ERC721("The Guild profike NFT", "GuildNFT") {
        councelor = msg.sender;
        nexus = _factory;
        _tokenCounter++; // Start Token IDs from 1 instead of 0, we use 0 to indicate absense of NFT on a wallet
    }

    function setAdmin(address account) public onlyCouncelor {
        councelor = account;
    }

    function setNexus(address account) public onlyCouncelor {
        nexus = account;
    }

    function issueProfile(
        address user,
        string memory tokenURI
    ) public onlyNexus returns (uint32) {
        uint32 newNFTId = _tokenCounter;
        _tokenCounter++;
        _mint(user, newNFTId);
        _setTokenURI(newNFTId, tokenURI);
        _tokenIdsByAddress[user].push(newNFTId);
        return newNFTId;
    }

    function owns(address addr) external view returns (uint32[] memory) {
        uint32[] memory tokenIds = _owns(addr);
        return tokenIds; // Returns 0 if address holds no token
    }

    /**
     * @dev Returns the tokenID owner of the `owner`. Does NOT revert if owner doesn't exist
     */
    function _owns(address addr) internal view returns (uint32[] memory ) {
        return _tokenIdsByAddress[addr];
    }

    function changeURI(uint32 tokenID, string memory tokenURI) public {
        address handler = INexus(nexus).getHandler(tokenID);
        require(msg.sender == handler, "Only Handler can update Token's URI");
        _setTokenURI(tokenID, tokenURI);
    }

    function tier(uint32 tokenID) public view returns (uint8) {
        address handler = INexus(nexus).getHandler(tokenID);
        return IReferralHandler(handler).getTier(); 
    }

    function transfer( // internal + is never used 
        address _to,
        uint32 _tokenId
    ) external {
        _tokenIdsByAddress[msg.sender][0];
        //INexus(nexus).registerUserEpoch(_to); // Alerting NFT Factory to update incase of new user address
        super.transferFrom(msg.sender, _to, _tokenId);
        uint32[] storage ids = _tokenIdsByAddress[_to];
        uint256 l = ids.length + 1;
        uint32[] storage i = ids;
        i.push(_tokenId);
    }

    function getTransferLimit(uint256 tokenID) public view returns (uint256) {
        address handler = INexus(nexus).getHandler(tokenID);
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
    ) public onlyCouncelor {
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
        uint32 tokenId
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