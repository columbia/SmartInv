1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./IAssetManager.sol";
5 import "./IVault.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 
8 // interface with required methods from Balancer V2 IBasePool
9 // https://github.com/balancer-labs/balancer-v2-monorepo/blob/389b52f1fc9e468de854810ce9dc3251d2d5b212/pkg/pool-utils/contracts/BasePool.sol
10 
11 interface IBasePool is IERC20 {
12     function getSwapFeePercentage() external view returns (uint256);
13 
14     function setSwapFeePercentage(uint256 swapFeePercentage) external;
15 
16     function setAssetManagerPoolConfig(IERC20 token, IAssetManager.PoolConfig memory poolConfig) external;
17 
18     function setPaused(bool paused) external;
19 
20     function getVault() external view returns (IVault);
21 
22     function getPoolId() external view returns (bytes32);
23 
24     function getOwner() external view returns (address);
25 }
