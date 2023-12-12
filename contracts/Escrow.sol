//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Escrow {
  using SafeERC20 for IERC20;

  bool public initialized = false;
  address public tavern;
  uint256 paymentAmount;
  address[] public tokens;
  address public governance; // who is it?

  modifier onlyGov() {
    require(msg.sender == governance, "only gov");
    _;
  }

  modifier onlyTavern() {
    require(msg.sender == tavern, "only tavern");
    _;
  }

  constructor (address[] memory _tokens) {
    tokens = _tokens;
    governance = msg.sender;
  }

  function initialize() external payable returns (bool){
    require(!initialized);
    initialized = true;
    tavern = msg.sender;
    paymentAmount = msg.value;
    return true;
  }

  function proccessPayment(address seeker) external{
    (bool sent, bytes memory data) = seeker.call{value: paymentAmount}("");
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