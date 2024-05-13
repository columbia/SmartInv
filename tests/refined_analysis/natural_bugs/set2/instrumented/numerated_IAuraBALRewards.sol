1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IAuraBALRewards {
5 
6     function balanceOf(address account) external view returns (uint256);
7 
8     function earned(address account) external view returns (uint256);
9     
10     function stake(uint256 _amount) external returns (bool);
11 
12     function getReward() external returns (bool);
13 
14     function withdraw(uint256 amount, bool claim) external returns (bool);
15 
16     // event RewardAdded(uint256 reward);
17     // event RewardPaid(address indexed user, uint256 reward);
18     // event Staked(address indexed user, uint256 amount);
19     // event Withdrawn(address indexed user, uint256 amount);
20 
21     // function addExtraReward(address _reward) external returns (bool);
22 
23     // function clearExtraRewards() external;
24 
25     // function currentRewards() external view returns (uint256);
26 
27     // function donate(uint256 _amount) external returns (bool);
28 
29     // function duration() external view returns (uint256);
30 
31     // function extraRewards(uint256) external view returns (address);
32 
33     // function extraRewardsLength() external view returns (uint256);
34 
35     // function getReward(address _account, bool _claimExtras) external returns (bool);
36 
37     // function historicalRewards() external view returns (uint256);
38 
39     // function lastTimeRewardApplicable() external view returns (uint256);
40 
41     // function lastUpdateTime() external view returns (uint256);
42 
43     // function newRewardRatio() external view returns (uint256);
44 
45     // function operator() external view returns (address);
46 
47     // function periodFinish() external view returns (uint256);
48 
49     // function pid() external view returns (uint256);
50 
51     // function processIdleRewards() external;
52 
53     // function queueNewRewards(uint256 _rewards) external returns (bool);
54 
55     // function queuedRewards() external view returns (uint256);
56 
57     // function rewardManager() external view returns (address);
58 
59     // function rewardPerToken() external view returns (uint256);
60 
61     // function rewardPerTokenStored() external view returns (uint256);
62 
63     // function rewardRate() external view returns (uint256);
64 
65     // function rewardToken() external view returns (address);
66 
67     // function rewards(address) external view returns (uint256);
68 
69     // function stakeAll() external returns (bool);
70 
71     // function stakeFor(address _for, uint256 _amount) external returns (bool);
72 
73     // function stakingToken() external view returns (address);
74 
75     // function totalSupply() external view returns (uint256);
76 
77     // function userRewardPerTokenPaid(address) external view returns (uint256);
78 
79     // function withdrawAll(bool claim) external;
80 
81     // function withdrawAllAndUnwrap(bool claim) external;
82 
83     // function withdrawAndUnwrap(uint256 amount, bool claim) external returns (bool);
84 }