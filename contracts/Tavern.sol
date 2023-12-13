// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IProfileNFT.sol";
import "./interfaces/IQuest.sol";
import "./interfaces/IEscrow.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
/**
 * @title Quest Factory (Tavern)
 * @notice Deploys Quest Contracts and manages them
 */

contract Tavern is AccessControl {
    address public owner;
    address public escrowImplementation;
    address public questImplementation;
    //IProfileNFT public nFT;
    mapping(address => address) QuestToStoreHouse; //escrow

    event QuestCreated(address seeker, address solver, address quest, address escrow); 

    constructor(address _questImplementation, address _escrowImplementation
    //, address _profileNft
    ) {
        escrowImplementation = _escrowImplementation;
        questImplementation = _questImplementation;
        owner = msg.sender;
        //nFT = IProfileNFT(_profileNft);
    }

    function startNewQuest(address _solver, address _seeker, uint256 _paymentAmount, string memory infoURI) external payable {
        IEscrow escrow = IEscrow(Clones.clone(escrowImplementation));
        IQuest quest = IQuest(Clones.clone(questImplementation));
        escrow.initialize{value: msg.value}();
        quest.initialize(_solver, _seeker,  infoURI);
        QuestToStoreHouse[address(quest)] = address(escrow);
        emit QuestCreated(_seeker, _solver, address(quest), address(0));
    }

    function callProccessPayment (address _seeker) external {
        address escrow = QuestToStoreHouse[msg.sender];
        require(escrow != address(0), "Quest doesn't exist");
        IEscrow(escrow).proccessPayment(_seeker);
    }
    // function getProfileNFT() public view returns (address) {
    //     return address(nFT);
    // }

}