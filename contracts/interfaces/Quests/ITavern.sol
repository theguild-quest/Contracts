//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface ITavern {
    function createNewQuest(address _solver, address _seeker, uint256 _paymentAmount, string memory infoURI, bool withTokens) external payable;
    function escrowNativeImplementation() external view returns (address);
    function escrowTokenImplementation() external view returns (address);
    function questImplementation() external view returns (address);
    function seekerFeesTreasury() external view returns (address);
    function solverFeesTreasury() external view returns (address);
    function disputeFeesTreasury() external view returns (address);
    function reviewPeriod() external view returns (uint256);
    //function barkeeper() external view returns (address);
    function getProfileNFT() external view returns(address);
    function getMagistrate() external view returns(address);
}