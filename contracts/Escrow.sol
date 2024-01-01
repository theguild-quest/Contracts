// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { IEscrow } from "./interfaces/Quests/IEscrow.sol";

/**
 * @title Quest Escrow 
 * @notice Stores reward for quest
 * @dev Implementation contract, instances are created as clones 
 */
contract EscrowNative is IEscrow {
    using SafeERC20 for IERC20;

    bool public initialized = false;
    address public quest;
    uint256 public paymentAmount;

    modifier onlyQuest() {
        require(msg.sender == quest, "only quest");
        _;
    }

    constructor() {}

    // Initialize the contract with the quest as the sender and the provided payment amount
    function initialize() external payable {
        require(!initialized);
        initialized = true;
        quest = msg.sender;
        paymentAmount = msg.value;
    }

    // Process payment, allowing dynamic specification of the treasury percentage
    function proccessPayment(address solver, address treasury, uint8 treasuryPercentage) external onlyQuest {
        // Calculate treasury and solver amounts based on specified percentages
        uint256 treasuryAmount = (paymentAmount * treasuryPercentage) / 100;
        uint256 solverAmount = paymentAmount - treasuryAmount;

        // Transfer funds to treasury and solver
        require(payable(treasury).send(treasuryAmount), "Failed to send Ether to treasury");
        require(payable(solver).send(solverAmount), "Failed to send Ether to solver");
    }

    // Process resolution, allowing dynamic specification of seeker, solver, and treasury percentages
    function proccessResolution(
        address seeker,
        address solver,
        uint8 seekerShare,
        uint8 solverShare,
        address treasury,
        uint8 treasuryPercentage
    ) external onlyQuest {
        // Calculate seeker, solver, and treasury amounts based on specified percentages
        uint256 seekerAmount = (paymentAmount * seekerShare) / 100;
        uint256 solverAmount = (paymentAmount * solverShare) / 100;
        uint256 treasuryAmount = (paymentAmount * treasuryPercentage) / 100;

        // Transfer funds to seeker, solver, and treasury
        require(payable(seeker).send(seekerAmount), "Failed to send Ether to seeker");
        require(payable(solver).send(solverAmount), "Failed to send Ether to solver");
        require(payable(treasury).send(treasuryAmount), "Failed to send Ether to treasury");
    }
}
