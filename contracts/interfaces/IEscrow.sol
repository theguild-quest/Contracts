//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IEscrow {
    function initialize() external payable returns (bool);
    function proccessPayment(address _seeker) external returns (bool);
}