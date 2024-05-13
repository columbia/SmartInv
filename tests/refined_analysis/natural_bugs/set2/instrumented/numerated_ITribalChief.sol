1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IRewarder.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 
7 /// @title FEI stablecoin interface
8 /// @author Fei Protocol
9 interface ITribalChief {
10     /// @notice Data needed for governor to create a new lockup period
11     /// and associated reward multiplier
12     struct RewardData {
13         uint128 lockLength;
14         uint128 rewardMultiplier;
15     }
16 
17     /// @notice Info of each pool.
18     struct PoolInfo {
19         uint256 virtualTotalSupply;
20         uint256 accTribePerShare;
21         uint128 lastRewardBlock;
22         uint120 allocPoint;
23         bool unlocked;
24     }
25 
26     /// @notice view only functions that return data on pools, user deposit(s), tribe distributed per block, and other constants
27     function rewardMultipliers(uint256 _pid, uint128 _blocksLocked) external view returns (uint128);
28 
29     function stakedToken(uint256 _index) external view returns (IERC20);
30 
31     function poolInfo(uint256 _index)
32         external
33         view
34         returns (
35             uint256,
36             uint256,
37             uint128,
38             uint120,
39             bool
40         );
41 
42     function tribePerBlock() external view returns (uint256);
43 
44     function pendingRewards(uint256 _pid, address _user) external view returns (uint256);
45 
46     function getTotalStakedInPool(uint256 pid, address user) external view returns (uint256);
47 
48     function openUserDeposits(uint256 pid, address user) external view returns (uint256);
49 
50     function numPools() external view returns (uint256);
51 
52     function totalAllocPoint() external view returns (uint256);
53 
54     function SCALE_FACTOR() external view returns (uint256);
55 
56     /// @notice functions for users to deposit, withdraw and get rewards from our contracts
57     function deposit(
58         uint256 _pid,
59         uint256 _amount,
60         uint64 _lockLength
61     ) external;
62 
63     function harvest(uint256 pid, address to) external;
64 
65     function withdrawAllAndHarvest(uint256 pid, address to) external;
66 
67     function withdrawFromDeposit(
68         uint256 pid,
69         uint256 amount,
70         address to,
71         uint256 index
72     ) external;
73 
74     function emergencyWithdraw(uint256 pid, address to) external;
75 
76     /// @notice functions to update pools that can be called by anyone
77     function updatePool(uint256 pid) external;
78 
79     function massUpdatePools(uint256[] calldata pids) external;
80 
81     /// @notice functions to change and add pools and multipliers that can only be called by governor, guardian, or TribalChiefAdmin
82     function resetRewards(uint256 _pid) external;
83 
84     function set(
85         uint256 _pid,
86         uint120 _allocPoint,
87         IRewarder _rewarder,
88         bool overwrite
89     ) external;
90 
91     function add(
92         uint120 allocPoint,
93         IERC20 _stakedToken,
94         IRewarder _rewarder,
95         RewardData[] calldata rewardData
96     ) external;
97 
98     function governorWithdrawTribe(uint256 amount) external;
99 
100     function governorAddPoolMultiplier(
101         uint256 _pid,
102         uint64 lockLength,
103         uint64 newRewardsMultiplier
104     ) external;
105 
106     function unlockPool(uint256 _pid) external;
107 
108     function lockPool(uint256 _pid) external;
109 
110     function updateBlockReward(uint256 newBlockReward) external;
111 }
