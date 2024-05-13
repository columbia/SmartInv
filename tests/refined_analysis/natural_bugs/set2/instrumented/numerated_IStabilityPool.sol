1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 // Ref: https://github.com/backstop-protocol/dev/blob/main/packages/contracts/contracts/StabilityPool.sol
5 interface IStabilityPool {
6     function getCompoundedLUSDDeposit(address holder) external view returns (uint256 lusdValue);
7 
8     function getDepositorETHGain(address holder) external view returns (uint256 ethValue);
9 }
