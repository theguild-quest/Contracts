//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface ITavern {
    function createNewQuest(address _solver, address _seeker, uint256 _paymentAmount, string memory infoURI) external payable;
    function escrowImplementation() external view returns (address);
    function questImplementation() external view returns (address);
    function barkeeper() external view returns (address);
    function getProfileNFT() external view returns(address);
}