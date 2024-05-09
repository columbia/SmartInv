// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IGlpRewardTracker {

    function claimable(address _account) external view returns (uint256);
}