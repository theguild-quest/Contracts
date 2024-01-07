//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IEscrow } from "./interfaces/Quests/IEscrow.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { IQuest } from "./interfaces/Quests/IQuest.sol";
import { ITavern } from "./interfaces/Quests/ITavern.sol";
/**
 * @title Quest Implementation
 * @notice Controls the quest flow
 * @dev Implementation contract, instances are created as ERC1167 clones 
 */

contract Quest is IQuest{

    // state variables 
    bool public initialized = false;
    bool public started = false;
    bool public submitted = false;
    bool public extended = false;
    bool public beingDisputed = false;
    bool public finished = false; 
    bool public rewarded = false;

    ITavern private Tavern;
    address public escrowImplemntation;  // native or with token

    uint32 public solverId;
    uint32 public seekerId;
    IEscrow private escrow;
    uint256 public  paymentAmount;
    string public infoURI;
    uint256 public rewardTime = 0;
    address public magistrate;

    modifier onlySeeker() {
    require(Tavern.ownerOf(seekerId) == msg.sender, "only Seeker");
    _;
    }

    modifier onlySolver() {
    require(Tavern.ownerOf(solverId) == msg.sender, "only Solver");
    _;
    }

    modifier onlyMagistrate() {
    require(msg.sender == magistrate, "only magistrate");
    _;
    }

    modifier onlyTavern() {
        require(msg.sender == address(Tavern), "only tavern");
        _;
    }

    constructor(address _tavern){
        Tavern = ITavern(_tavern);
    }

    function initialize(
        uint32 _solverNftId,
        uint32 _seekerNftId,
        uint256 _paymentAmount,
        string memory _infoURI,
        address _escrowImplemntation 
        )
        external onlyTavern
        returns (bool)
        {
        require(!initialized);
        initialized = true;
        solverId = _solverNftId;
        seekerId = _seekerNftId;
        paymentAmount = _paymentAmount;
        infoURI = _infoURI;
        escrowImplemntation = _escrowImplemntation;
        return true;
    }

    function startQuest() external payable onlySeeker { 
        require(initialized, "not initialized");
        require(!started, "already started");
        require(msg.value >= paymentAmount, "wrong payment amount");
        escrow = IEscrow(Clones.clone(escrowImplemntation));
        escrow.initialize{value: msg.value}();
        started = true;
    }

    function startDispute() external onlySeeker {
        require(started, "quest not started");
        require(!beingDisputed, "Dispute started before");
        beingDisputed = true;
        //magistrate = Tavern.magistrate();
    }

    function resolveDispute(uint8 seekerShare, uint8 solverShare) external onlyMagistrate{
        require(beingDisputed, "Dispute not started");
        require(!rewarded, "Rewarded before");
        require(seekerShare + solverShare == 100, "Shares should sum to 100");
        rewarded = true;
        escrow.proccessResolution(seekerId, solverId, seekerShare, solverShare);
    }

    function finishQuest() external onlySolver { // might be changed 
        require(started, "quest not started");

        finished = true;
        rewardTime = block.timestamp + Tavern.reviewPeriod();  // arbitrary time
    }

    function extend() external onlySeeker{
        require(finished, "Quest not finished");
        require(!rewarded, "Was rewarded before");
        require(!extended, "Was extended before");
        extended = true;
        rewardTime += Tavern.reviewPeriod();  
    }

    function getReward() external onlySolver {
        require(finished, "Quest not finished");
        require(!rewarded, "Rewarded before");
        require(!beingDisputed, "Is under dispute");
        require(rewardTime <= block.timestamp, "Not reward time yet");
        rewarded = true;
        escrow.proccessPayment(solverId, Tavern.solverFeesTreasury());
    }

    
}