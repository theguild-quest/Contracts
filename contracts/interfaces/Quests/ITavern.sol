//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface ITavern {
    function createNewQuest(address _solver, address _seeker, uint256 _paymentAmount, string memory infoURI, bool withTokens) external payable;
    function confirmNFTOwnership(address seeker) external view returns (bool); 
    function escrowNativeImplementation() external view returns (address);
    function escrowTokenImplementation() external view returns (address);
    function questImplementation() external view returns (address);
    function seekerFeesTreasury() external view returns (address);
    function solverFeesTreasury() external view returns (address);
    function disputeFeesTreasury() external view returns (address);
    function reviewPeriod() external view returns (uint256);
    function getProfileNFT() external view returns(address);
    function getCounselor() external view returns(address);
    function ownerOf(uint32) external view returns (address);
}