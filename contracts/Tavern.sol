// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IProfileNFT.sol";
import "./interfaces/IQuest.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
/**
 * @title QuestFactory (Tavern)
 * @notice Deploys QuestContracts and manages them
 */

contract Tavern {

    address public questImplementation;
    IProfileNFT public nFT;
    mapping(address => address) QuestToStoreHouse; 

    event QuestCreated(uint256 timestamp, address seeker, address quest); 

    constructor(address _questImplementation, address _profileNft) {
        questImplementation = _questImplementation;
        nFT = IProfileNFT(_profileNft);
    }

    function deployQuest() external {
        IQuest quest = IQuest(Clones.clone(questImplementation));
        quest.initialize();
    }

    function getQuestImplementation() public view returns (address) {
        return questImplementation;
    }

    function getProfileNFT() public view returns (address) {
        return address(nFT);
    }

}