1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.6;
3 
4 interface IRewardStaking {
5     function stakeFor(address, uint256) external;
6     function stake( uint256) external;
7     function withdraw(uint256 amount, bool claim) external;
8     function withdrawAndUnwrap(uint256 amount, bool claim) external;
9     function earned(address account) external view returns (uint256);
10     function getReward() external;
11     function getReward(address _account, bool _claimExtras) external;
12     function extraRewardsLength() external view returns (uint256);
13     function extraRewards(uint256 _pid) external view returns (address);
14     function rewardToken() external view returns (address);
15     function balanceOf(address _account) external view returns (uint256);
16 }