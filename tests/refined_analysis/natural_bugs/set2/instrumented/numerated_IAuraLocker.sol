1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 interface IAuraLocker {
5     struct LockedBalance {
6         uint112 amount;
7         uint32 unlockTime;
8     }
9     struct EarnedData {
10         address token;
11         uint256 amount;
12     }
13 
14     function balanceOf(address _user) external view returns (uint256);
15 
16     function lock(address _account, uint256 _amount) external;
17 
18     function getReward(address _account, bool _stake) external;
19 
20     function processExpiredLocks(bool _relock) external;
21 
22     function emergencyWithdraw() external;
23 
24     function delegates(address account) external view returns (address);
25 
26     function getVotes(address account) external view returns (uint256);
27 
28     function lockedBalances(address _user)
29         external
30         view
31         returns (
32             uint256 total,
33             uint256 unlockable,
34             uint256 locked,
35             LockedBalance[] memory lockData
36         );
37 
38     function claimableRewards(address _account) external view returns (EarnedData[] memory userRewards);
39 
40     function notifyRewardAmount(address _rewardsToken, uint256 _reward) external;
41 }
