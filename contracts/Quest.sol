//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/ITavern.sol";

/**
 * @title Quest Implementation
 * @dev Executes the proxy calls
 */

contract Quest {

    bool public initialized = false;
    address public tavern;
    string infoURI;
    //uint32 seekerId
    address public solver;
    address public seeker;

    modifier onlySeeker() {
    require(msg.sender == seeker, "only seeker");
    _;
    }

    function initialize(
        //uint32 _seekerId, 
        address _solver,
        address _seeker,
        string memory _infoURI)
        external
        returns (bool)
        {
        require(!initialized);
        initialized = true;
        //seekerId = _seekerId;
        solver = _solver;
        seeker = _seeker;
        tavern = msg.sender;
        infoURI = _infoURI;
        
        return true;
    }

    function startDispute() external{}

    function resolveDispute(uint8 seekerShare, uint8 solverShare) external{}

    function finishQuest() external onlySeeker returns (bool) {
        require(initialized);
        ITavern(tavern).callProccessPayment(seeker);
        return true;
    }
}