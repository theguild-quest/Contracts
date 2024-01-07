//SPDX-License-Identifier: MIT
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
  uint256 paymentAmount;

  modifier onlyQuest() {
    require(msg.sender == quest, "only quest");
    _;
  }

  constructor () {
  }

  function initialize() external payable {   
    require(!initialized);
    initialized = true;
    quest = msg.sender;
    paymentAmount = msg.value;
  }

  function proccessPayment(uint32 solverId) external onlyQuest{
    // (bool sentTreasury, bytes memory dataT) = payable(treasury).call{value: (paymentAmount * 10) / 100}(""); // change to flexible % 
    // require(sentTreasury, "Failed to send Ether to solver");
    // (bool sentSolver, bytes memory dataS) = payable(solver).call{value: (paymentAmount * 90) / 100}(""); // change to flexible % 
    // require(sentSolver, "Failed to send Ether to solver");
  }
  
  function proccessResolution(uint32 seekerId, uint32 solverId, uint8 seekerShare, uint8 solverShare) external onlyQuest{
    //(bool sentSeeker, bytes memory data) = payable(seeker).call{value: (paymentAmount * seekerShare) / 100}("");
    //require(sentSeeker, "Failed to send Ether");
    //(bool sentSolver, bytes memory datas) = payable(solver).call{value: (paymentAmount * solverShare) / 100}(""); // change to flexible % 
    //require(sentSolver, "Failed to send Ether");
  }

}