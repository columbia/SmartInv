1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 contract MockStakingRewards {
7     uint256 public rewardAmount;
8 
9     function notifyRewardAmount(uint256 amount) external {
10         rewardAmount = amount;
11     }
12 
13     function recoverERC20(
14         address tokenAddress,
15         address to,
16         uint256 tokenAmount
17     ) external {
18         IERC20(tokenAddress).transfer(to, tokenAmount);
19     }
20 }
