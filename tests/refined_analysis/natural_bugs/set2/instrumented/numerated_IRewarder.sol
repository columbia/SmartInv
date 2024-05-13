1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 
7 interface IRewarder {
8     function onSushiReward(
9         uint256 pid,
10         address user,
11         address recipient,
12         uint256 sushiAmount,
13         uint256 newLpAmount
14     ) external;
15 
16     function pendingTokens(
17         uint256 pid,
18         address user,
19         uint256 sushiAmount
20     ) external view returns (IERC20[] memory, uint256[] memory);
21 }
