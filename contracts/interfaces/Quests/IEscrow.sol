//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IEscrow {
    function initialize() external payable;
    function proccessPayment(address _seeker) external;
}