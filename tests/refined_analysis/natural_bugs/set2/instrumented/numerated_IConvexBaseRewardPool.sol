1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 interface IConvexBaseRewardPool {
5     function rewardToken() external view returns (address);
6 
7     function stakingToken() external view returns (address);
8 
9     function duration() external view returns (uint256);
10 
11     function operator() external view returns (address);
12 
13     function rewardManager() external view returns (address);
14 
15     function pid() external view returns (uint256);
16 
17     function periodFinish() external view returns (uint256);
18 
19     function rewardRate() external view returns (uint256);
20 
21     function lastUpdateTime() external view returns (uint256);
22 
23     function rewardPerTokenStored() external view returns (uint256);
24 
25     function queuedRewards() external view returns (uint256);
26 
27     function currentRewards() external view returns (uint256);
28 
29     function historicalRewards() external view returns (uint256);
30 
31     function newRewardRatio() external view returns (uint256);
32 
33     function userRewardPerTokenPaid(address user) external view returns (uint256);
34 
35     function rewards(address user) external view returns (uint256);
36 
37     function extraRewards(uint256 i) external view returns (address);
38 
39     function totalSupply() external view returns (uint256);
40 
41     function balanceOf(address account) external view returns (uint256);
42 
43     function extraRewardsLength() external view returns (uint256);
44 
45     function addExtraReward(address _reward) external returns (bool);
46 
47     function clearExtraRewards() external;
48 
49     function lastTimeRewardApplicable() external view returns (uint256);
50 
51     function rewardPerToken() external view returns (uint256);
52 
53     function earned(address account) external view returns (uint256);
54 
55     function stake(uint256 _amount) external returns (bool);
56 
57     function stakeAll() external returns (bool);
58 
59     function stakeFor(address _for, uint256 _amount) external returns (bool);
60 
61     function withdraw(uint256 amount, bool claim) external returns (bool);
62 
63     function withdrawAll(bool claim) external;
64 
65     function withdrawAndUnwrap(uint256 amount, bool claim) external returns (bool);
66 
67     function withdrawAllAndUnwrap(bool claim) external;
68 
69     function getReward(address _account, bool _claimExtras) external returns (bool);
70 
71     function getReward() external returns (bool);
72 
73     function donate(uint256 _amount) external returns (bool);
74 
75     function queueNewRewards(uint256 _rewards) external returns (bool);
76 }
