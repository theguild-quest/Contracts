//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IQuest {
    function initialize(uint32 solverId, uint32 seekerId, address escrow, string[] memory infoURI) external;
    function startDispute() external;
    function resolveDispute(uint8 seekerShare, uint8 solverShare) external;
    function proccessPayment() external returns (bool);
}