//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface ITavern {
    function createNewQuest(address _solver, address _seeker, uint256 _paymentAmount, string memory infoURI) external payable;
    function getEscrowImplementation() external view returns (address);
}