//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IQuest {
    //function initialize(uint32 seekerId, address escrow, string memory infoURI) external returns (bool);
    function initialize(address solver, address seeker, string memory infoURI) external returns (bool);
    function startDispute() external;
    function resolveDispute(uint8 seekerShare, uint8 solverShare) external;
    function finishQuest() external returns (bool);
}