//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IQuest {
    function initialize(uint32 solverId, uint32 seekerId, uint256 paymentAmount, string memory infoURI, address escrowImplementation) external returns (bool);
    function startDispute() external;
    function resolveDispute(uint8 seekerShare, uint8 solverShare) external;
    function finishQuest() external;
}