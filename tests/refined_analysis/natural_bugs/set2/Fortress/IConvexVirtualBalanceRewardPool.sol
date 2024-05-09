// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IConvexVirtualBalanceRewardPool {
  function earned(address account) external view returns (uint256);
}