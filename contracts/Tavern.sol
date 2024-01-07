// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IProfileNFT.sol";
import "./interfaces/Quests/IQuest.sol";
//import "./interfaces/Quests/IEscrow.sol";
import "./interfaces/Quests/IQuest.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { ITavern } from "./interfaces/Quests/ITavern.sol";

/**
 * @title Quest Factory (Tavern)
 * @notice Deploys Quest Contracts and manages them
 */
contract Tavern is AccessControl, ITavern {
    address public owner;
    address private barkeeper;
    address public escrowNativeImplementation; // for native blockchain tokens
    address public escrowTokenImplementation; // for ERC20 tokens
    address public questImplementation;
    address public seekerFeesTreasury;
    address public solverFeesTreasury;
    address public disputeFeesTreasury;
    address private counselor; //mediator
    uint256 public reviewPeriod = 1;
    IProfileNFT private nFT;

    modifier onlyBarkeeper() {
        require(msg.sender == barkeeper, "only barkeeper");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    event QuestCreated(
        uint32 solverId,
        uint32 seekerId,
        address quest,
        uint256 paymentAmount
    );

    constructor(
        address _questImplementation,
        address _escrowNativeImplementation,
        address _profileNft
    ) {
        escrowNativeImplementation = _escrowNativeImplementation;
        questImplementation = _questImplementation;
        owner = msg.sender;
        nFT = IProfileNFT(_profileNft);
    }

    function createNewQuest(
        // user identificators
        uint32 _solverId,
        uint32 _seekerId,
        uint256 _paymentAmount,
        string memory infoURI,
        bool withTokens
    ) external payable onlyBarkeeper {
        IQuest quest = IQuest(Clones.clone(questImplementation));
        //_solver = nFT.belongsTo(_solver);
        quest.initialize(
            _solverId,
            _seekerId,
            _paymentAmount,
            infoURI,
            escrowNativeImplementation
        );
        emit QuestCreated(_seekerId, _solverId, address(quest), _paymentAmount);
    }

    function confirmNFTOwnership(
        address identity
    ) public view returns (bool confirmed) {
        confirmed = nFT.balanceOf(identity) > 0;
        return confirmed;
    }

    // in case of backend problem
    function setBarkeeper(address keeper) external onlyOwner {
        barkeeper = keeper;
    }

    // in case of serious emergency
    function setProfileNft(address nft) external onlyOwner {
        nFT = IProfileNFT(nft);
    }

    function setQuestImplementation(address impl) external onlyOwner {
        escrowNativeImplementation = impl;
    }

    function setEscrowNativeImplementation(address impl) external onlyOwner {
        escrowNativeImplementation = impl;
    }

    function setEscrowTokenImplementation(address impl) external onlyOwner {
        escrowTokenImplementation = impl;
    }

    function setSeekerTreasury(address treasury) external onlyOwner {
        seekerFeesTreasury = treasury;
    }

    function setSolverTreasury(address treasury) external onlyOwner {
        solverFeesTreasury = treasury;
    }

    function setDisputeTreasuryAddress(address treasury) external onlyOwner {
        disputeFeesTreasury = treasury;
    }

    function setCounselor(address _counselor) external onlyOwner {
        counselor = _counselor;
    }

    function setReviewPeriod(uint256 period) external onlyOwner {
        reviewPeriod = period;
    }

    function getCounselor() external view returns (address) {
        return counselor;
    }

    function getBarkeeper() external view onlyOwner returns (address) {
        return barkeeper;
    }

    function getProfileNFT() public view returns (address) {
        return address(nFT);
    }

    function ownerOf(uint32 nftId) external view override returns (address) {
        return nFT.ownerOf(nftId);
    }

    function createNewQuest(
        address _solver,
        address _seeker,
        uint256 _paymentAmount,
        string memory infoURI,
        bool withTokens
    ) external payable override {}


}