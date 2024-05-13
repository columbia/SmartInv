1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "./StrategySwapper.sol";
5 
6 contract MockStrategySwapper is StrategySwapper {
7     constructor(address addressProvider_, uint256 slippageTolerance_)
8         StrategySwapper(addressProvider_, slippageTolerance_)
9     {}
10 
11     function overrideSlippageTolerance(uint256 slippageTolerance_) external {
12         slippageTolerance = slippageTolerance_;
13     }
14 }
