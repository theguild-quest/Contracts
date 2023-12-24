// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IProfileNFT.sol";
import "./interfaces/Quests/IQuest.sol";
import "./interfaces/Quests/IEscrow.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { ITavern } from "./interfaces/Quests/ITavern.sol";

/**
 * @title Quest Factory (Tavern)
 * @notice Deploys Quest Contracts and manages them
 */
contract Tavern is AccessControl, ITavern {
    address public owner;
    address public barkeeper;
    address public escrowImplementation;
    address public questImplementation;
    IProfileNFT public nFT;
    mapping(address => uint32) public QuestToSeeker; //escrow

    modifier onlyBarkeeper() {
        require(msg.sender == barkeeper, "only barkeeper");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }
    event QuestCreated(
        address seeker,
        address solver,
        address quest,
        uint256 paymentAmount
    );

    constructor(
        address _questImplementation,
        address _escrowImplementation,
        address _profileNft
    ) {
        escrowImplementation = _escrowImplementation;
        questImplementation = _questImplementation;
        owner = msg.sender;
        nFT = IProfileNFT(_profileNft);
    }

    // Create
    function createNewQuest(
        address _solver,
        address _seeker,
        uint256 _paymentAmount,
        string memory infoURI
    ) external payable onlyBarkeeper {
        IQuest quest = IQuest(Clones.clone(questImplementation));
        quest.initialize(_solver, _seeker, _paymentAmount, infoURI);
        //QuestToStoreHouse[address(quest)] = address(escrow);
        emit QuestCreated(_seeker, _solver, address(quest), _paymentAmount);
    }

    // function callProccessPayment (address _seeker) external {
    //     //address escrow = QuestToStoreHouse[msg.sender];
    //     //require(escrow != address(0), "Quest doesn't exist");
    //     IEscrow(escrow).proccessPayment(_seeker);
    // }

    function getProfileNFT() public view returns (address) {
        return address(nFT);
    }

    function getEscrowImplementation() external view returns (address) {
        return escrowImplementation;
    }

    function getQuestImplementation() external view returns (address) {
        return questImplementation;
    }

}