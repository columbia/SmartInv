1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 // Angle PoolManager contract
5 interface IAnglePoolManager {
6     function token() external returns (address);
7 
8     function getBalance() external view returns (uint256);
9 
10     function setStrategyEmergencyExit(address) external;
11 
12     function withdrawFromStrategy(address, uint256) external;
13 
14     function updateStrategyDebtRatio(address, uint256) external;
15 }
