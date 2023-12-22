//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface ITavern {
    function startNewQuest(address _solver, address _seeker, uint256 _paymentAmount, string memory infoURI) external payable;
    function callProccessPayment (address _seeker) external;
    function getProfileNFT() external view returns (address);
}