1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 
6 interface IMockERC20 is IERC20 {
7     function mint(address account, uint256 amount) external returns (bool);
8 }
9 
10 contract MockAngleStakingRewards {
11     IERC20 public stakingToken;
12     IMockERC20 public rewardToken;
13 
14     mapping(address => uint256) public balanceOf;
15 
16     constructor(IERC20 _stakingToken, IMockERC20 _rewardToken) {
17         stakingToken = _stakingToken;
18         rewardToken = _rewardToken;
19     }
20 
21     function stake(uint256 amount) external {
22         SafeERC20.safeTransferFrom(IERC20(stakingToken), msg.sender, address(this), amount);
23         balanceOf[msg.sender] += amount;
24     }
25 
26     function withdraw(uint256 amount) external {
27         balanceOf[msg.sender] -= amount;
28         SafeERC20.safeTransfer(IERC20(stakingToken), msg.sender, amount);
29     }
30 
31     function getReward() external {
32         rewardToken.mint(msg.sender, balanceOf[msg.sender] / 100);
33     }
34 }
