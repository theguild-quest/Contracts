//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IEscrow } from "./interfaces/Quests/IEscrow.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { IQuest } from "./interfaces/Quests/IQuest.sol";

/**
 * @title Quest Implementation
 * @notice Controls the quest flow
 * @dev Implementation contract, instances are created as clones 
 */

contract Quest is IQuest{

    bool public initialized = false;
    bool public started = false;
    address public tavern;
    address escrowImplementation;

    address public solver;
    address public seeker;
    IEscrow escrow;
    uint256 public  paymentAmount;
    string public infoURI;

    modifier onlySeeker() {
    require(msg.sender == seeker, "only seeker");
    _;
    }

    modifier onlyTavern() {
        require(msg.sender == tavern, "only tavern");
        _;
    }

    constructor(address _escrowImplementation, address _tavern){
        tavern = _tavern;
        escrowImplementation = _escrowImplementation;
    }

    function initialize(
        address _solver,
        address _seeker,
        uint256 _paymentAmount,
        string memory _infoURI)
        external onlyTavern
        returns (bool)
        {
        require(!initialized);
        initialized = true;
        solver = _solver;
        seeker = _seeker;
        paymentAmount = _paymentAmount;
        infoURI = _infoURI;
        
        return true;
    }

    function startQuest() external payable onlySeeker{
        require(initialized, "not initialized");
        require(!started, "already started");
        require(msg.value >= paymentAmount, "wrong payment amount");
        escrow = IEscrow(Clones.clone(escrowImplementation));
        escrow.initialize{value: msg.value}();
        started = true;
    }

    function startDispute() external{
        require(started, "quest not started");

    }

    function resolveDispute(uint8 seekerShare, uint8 solverShare) external{

    }

    function finishQuest() external onlySeeker returns (bool) { // might be changed 
        require(started, "quest not started");

        escrow.proccessPayment(solver);
        return true;
    }
}