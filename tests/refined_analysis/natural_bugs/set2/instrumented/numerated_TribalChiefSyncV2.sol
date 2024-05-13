1 pragma solidity ^0.8.0;
2 
3 import "./ITribalChief.sol";
4 
5 interface IAutoRewardsDistributor {
6     function setAutoRewardsDistribution() external;
7 }
8 
9 interface ITimelock {
10     function execute(
11         address target,
12         uint256 value,
13         bytes calldata data,
14         bytes32 predecessor,
15         bytes32 salt
16     ) external;
17 }
18 
19 /**
20     @title TribalChief Synchronize contract
21     This contract is able to keep the tribalChief and autoRewardsDistributor in sync when either:
22     1. adding pools or 
23     2. updating block rewards
24 
25     It needs the EXECUTOR role on the optimistic timelock, so it can atomically trigger the 3 actions.
26 
27     It also includes a mapping for updating block rewards according to the schedule in https://tribe.fei.money/t/tribe-liquidity-mining-emission-schedule/3549
28     It needs the TRIBAL_CHIEF_ADMIN_ROLE role to auto trigger reward decreases.
29  */
30 contract TribalChiefSyncV2 {
31     ITribalChief public immutable tribalChief;
32     IAutoRewardsDistributor public immutable autoRewardsDistributor;
33     ITimelock public immutable timelock;
34 
35     /// @notice a mapping from reward rates to timestamps after which they become active
36     mapping(uint256 => uint256) public rewardsSchedule;
37 
38     /// @notice rewards schedule in reverse order
39     uint256[] public rewardsArray;
40 
41     // TribalChief struct
42     struct RewardData {
43         uint128 lockLength;
44         uint128 rewardMultiplier;
45     }
46 
47     constructor(
48         ITribalChief _tribalChief,
49         IAutoRewardsDistributor _autoRewardsDistributor,
50         ITimelock _timelock,
51         uint256[] memory rewards,
52         uint256[] memory timestamps
53     ) {
54         tribalChief = _tribalChief;
55         autoRewardsDistributor = _autoRewardsDistributor;
56         timelock = _timelock;
57 
58         require(rewards.length == timestamps.length, "length");
59 
60         uint256 lastReward = type(uint256).max;
61         uint256 lastTimestamp = block.timestamp;
62         uint256 len = rewards.length;
63         rewardsArray = new uint256[](len);
64 
65         for (uint256 i = 0; i < len; i++) {
66             uint256 nextReward = rewards[i];
67             uint256 nextTimestamp = timestamps[i];
68 
69             require(nextReward < lastReward, "rewards");
70             require(nextTimestamp > lastTimestamp, "timestamp");
71 
72             rewardsSchedule[nextReward] = nextTimestamp;
73             rewardsArray[len - i - 1] = nextReward;
74 
75             lastReward = nextReward;
76             lastTimestamp = nextTimestamp;
77         }
78     }
79 
80     /// @notice Before an action, mass update all pools, after sync the autoRewardsDistributor
81     modifier update() {
82         uint256 numPools = tribalChief.numPools();
83         uint256[] memory pids = new uint256[](numPools);
84         for (uint256 i = 0; i < numPools; i++) {
85             pids[i] = i;
86         }
87         tribalChief.massUpdatePools(pids);
88         _;
89         autoRewardsDistributor.setAutoRewardsDistribution();
90     }
91 
92     /// @notice Sync a rewards rate change automatically using pre-approved map
93     function autoDecreaseRewards() external update {
94         require(isRewardDecreaseAvailable(), "time not passed");
95         uint256 tribePerBlock = nextRewardsRate();
96         tribalChief.updateBlockReward(tribePerBlock);
97         rewardsArray.pop();
98     }
99 
100     function isRewardDecreaseAvailable() public view returns (bool) {
101         return rewardsArray.length > 0 && nextRewardTimestamp() < block.timestamp;
102     }
103 
104     function nextRewardTimestamp() public view returns (uint256) {
105         return rewardsSchedule[nextRewardsRate()];
106     }
107 
108     function nextRewardsRate() public view returns (uint256) {
109         return rewardsArray[rewardsArray.length - 1];
110     }
111 
112     /// @notice Sync a rewards rate change
113     function decreaseRewards(uint256 tribePerBlock, bytes32 salt) external update {
114         bytes memory data = abi.encodeWithSelector(tribalChief.updateBlockReward.selector, tribePerBlock);
115         timelock.execute(address(tribalChief), 0, data, bytes32(0), salt);
116     }
117 
118     /// @notice Sync a pool addition
119     function addPool(
120         uint120 allocPoint,
121         address stakedToken,
122         address rewarder,
123         RewardData[] memory rewardData,
124         bytes32 salt
125     ) external update {
126         bytes memory data = abi.encodeWithSelector(
127             tribalChief.add.selector,
128             allocPoint,
129             stakedToken,
130             rewarder,
131             rewardData
132         );
133         timelock.execute(address(tribalChief), 0, data, bytes32(0), salt);
134     }
135 
136     /// @notice Sync a pool set action
137     function setPool(
138         uint256 pid,
139         uint120 allocPoint,
140         IRewarder rewarder,
141         bool overwrite,
142         bytes32 salt
143     ) external update {
144         bytes memory data = abi.encodeWithSelector(tribalChief.set.selector, pid, allocPoint, rewarder, overwrite);
145         timelock.execute(address(tribalChief), 0, data, bytes32(0), salt);
146     }
147 
148     /// @notice Sync a pool reset rewards action
149     function resetPool(uint256 pid, bytes32 salt) external update {
150         bytes memory data = abi.encodeWithSelector(tribalChief.resetRewards.selector, pid);
151         timelock.execute(address(tribalChief), 0, data, bytes32(0), salt);
152     }
153 }
