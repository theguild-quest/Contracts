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
contract Escrow is IEscrow {
  using SafeERC20 for IERC20;

  bool public initialized = false;
  address public quest;
  uint256 paymentAmount;
  address[] public tokens;
  address public governance; // who is it?

  modifier onlyGov() {
    require(msg.sender == governance, "only gov");
    _;
  }

  modifier onlyQuest() {
    require(msg.sender == quest, "only quest");
    _;
  }

  constructor (address[] memory _tokens) {
    tokens = _tokens;
    governance = msg.sender;
  }

  function initialize() external payable {   
    require(!initialized);
    initialized = true;
    quest = msg.sender;
    paymentAmount = msg.value;
  }

  function proccessPayment(address solver) external onlyQuest{
    (bool sent, bytes memory data) = payable(solver).call{value: paymentAmount}("");
    require(sent, "Failed to send Ether");
  }
  // function approve(address _token, address to, uint256 amount) public onlyGov {
  //   IERC20(_token).approve(to, 0);
  //   IERC20(_token).approve(to, amount);
  // }

  // function transfer(address _token, address to, uint256 amount) public onlyGov {
  //   IERC20(_token).transfer(to, amount);
  // }

  function setGovernance(address account) external onlyGov {
    governance = account;
  }
}