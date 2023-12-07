//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface INFTFactory {
    function isHandler(address) external view returns (bool);
    function getHandler(uint256) external view returns (address);
    function getEpoch(address) external view returns (uint256);
    function notifyLevel(uint256, uint256) external;
    function notifySelfTaxClaimed(uint256, uint256) external;
    function notifyReferralClaimed(uint256, uint256) external;
    function notifyDepositClaimed(uint256, uint256) external;
    function registerUserEpoch(address) external;
    function updateUserEpoch(address, uint256) external;
    function getTierManager() external view returns(address);
    function getTaxManager() external view returns(address);
    function getRebaser() external view returns(address);
    function getRewarder() external view returns(address);
    function getAdmin() external view returns(address);
    function getHandlerForUser(address) external view returns (address);
    function getDepositBox(uint256) external view returns (address);
}