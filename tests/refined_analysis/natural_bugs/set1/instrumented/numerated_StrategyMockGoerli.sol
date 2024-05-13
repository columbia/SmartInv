1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '../managers/Manager.sol';
10 import '../interfaces/managers/IStrategyManager.sol';
11 
12 contract StrategyMockGoerli is IStrategyManager, Manager {
13   IERC20 public override want;
14 
15   constructor(IERC20 _token, address _mock) {}
16 
17   function withdrawAll() external override returns (uint256 b) {}
18 
19   function withdraw(uint256 _amount) external override {}
20 
21   function deposit() external override {}
22 
23   function balanceOf() public view override returns (uint256) {}
24 }
