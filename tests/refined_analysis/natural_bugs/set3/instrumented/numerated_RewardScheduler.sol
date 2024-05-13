1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 import "@openzeppelin/contracts-4.7.3/token/ERC20/IERC20.sol";
5 import "@openzeppelin/contracts-4.7.3/token/ERC20/utils/SafeERC20.sol";
6 import "@openzeppelin/contracts-4.7.3/access/Ownable.sol";
7 import "@openzeppelin/contracts-4.7.3/security/ReentrancyGuard.sol";
8 import "../xchainGauges/RewardForwarder.sol";
9 
10 // POC of a reward scheduler contract that can schedule N weeks worth of rewards
11 // This contract is only a proof of concept and should not be used in production as is
12 contract RewardScheduler is Ownable, ReentrancyGuard {
13     using SafeERC20 for IERC20;
14 
15     // state variables
16     uint256 public lastTimestamp;
17     uint256 public numOfWeeksLeft;
18     uint256 public amountPerWeek;
19 
20     // immutable variables set at construction
21     address public immutable rewardForwarder;
22     address public immutable rewardToken;
23 
24     /**
25      * @notice Emitted when a reward is scheduled
26      * @param rewardToken address of the reward token
27      * @param amountPerWeek amount of reward tokens to be distributed per week
28      * @param numOfWeeks number of weeks the reward is scheduled for
29      */
30     event RewardScheduled(
31         address rewardToken,
32         uint256 amountPerWeek,
33         uint256 numOfWeeks
34     );
35 
36     /**
37      * @notice RewardScheduler constructor
38      * @param _rewardForwader address of the reward forwarder contract
39      */
40     constructor(address _rewardForwader, address _rewardToken) {
41         require(_rewardForwader != address(0), "RewardScheduler: zero address");
42         require(_rewardToken != address(0), "RewardScheduler: zero address");
43         rewardForwarder = _rewardForwader;
44         rewardToken = _rewardToken;
45     }
46 
47     /**
48      * @notice Schedule a reward for N weeks
49      * @dev This function will transfer the reward tokens from the caller to this contract
50      * @dev This function can only be called by the owner
51      * @param _amount amount of reward tokens to schedule
52      * @param numberOfWeeks number of weeks to schedule the reward for
53      * @param shouldTriggerDeposit whether to trigger the depositRewardToken function on the reward forwarder
54      */
55     function scheduleReward(
56         uint256 _amount,
57         uint256 numberOfWeeks,
58         bool shouldTriggerDeposit
59     ) external onlyOwner nonReentrant {
60         // Check parameters and state
61         require(
62             numOfWeeksLeft == 0,
63             "RewardScheduler: reward already scheduled"
64         );
65         uint256 _amountPerWeek = _amount / numberOfWeeks;
66         require(_amountPerWeek > 0, "RewardScheduler: amount too small");
67 
68         // Update state
69         numOfWeeksLeft = numberOfWeeks;
70         amountPerWeek = _amountPerWeek;
71 
72         // Transfer reward tokens to this contract
73         address _rewardToken = rewardToken;
74         IERC20(_rewardToken).safeTransferFrom(
75             msg.sender,
76             address(this),
77             _amount
78         );
79 
80         // Trigger event
81         emit RewardScheduled(_rewardToken, _amountPerWeek, numberOfWeeks);
82 
83         // Transfer reward to the reward forwarder
84         // Trigger depositRewardToken on the reward forwarder if needed
85         _transferReward(shouldTriggerDeposit);
86     }
87 
88     function _transferReward(bool shouldTriggerDeposit) internal {
89         uint256 _numOfWeeksLeft = numOfWeeksLeft;
90         require(_numOfWeeksLeft > 0, "RewardScheduler: no reward scheduled");
91         require(
92             block.timestamp - lastTimestamp >= 1 weeks,
93             "RewardScheduler: not enough time has passed"
94         );
95 
96         numOfWeeksLeft = _numOfWeeksLeft - 1;
97         lastTimestamp = block.timestamp;
98 
99         IERC20(rewardToken).safeTransfer(
100             address(rewardForwarder),
101             amountPerWeek
102         );
103 
104         if (shouldTriggerDeposit) _triggerdepositRewardToken();
105     }
106 
107     function _triggerdepositRewardToken() internal {
108         RewardForwarder(rewardForwarder).depositRewardToken(rewardToken);
109     }
110 
111     /**
112      * @notice Transfer the reward to the reward forwarder. Reward must be scheduled first
113      * or this function will revert. Can only be called weekly.
114      * @dev This function can be called by anyone
115      * @param shouldTriggerDeposit whether to trigger the depositRewardToken function on the reward forwarder
116      * If set to true, rewards will start immediately. If set to false, rewards will start whenever
117      * depositRewardToken is called on the reward forwarder
118      */
119     function transferReward(bool shouldTriggerDeposit) external nonReentrant {
120         _transferReward(shouldTriggerDeposit);
121     }
122 
123     /**
124      * @notice Cancel any scheduled reward
125      * @dev This function can only be called by the owner
126      * @dev This function will transfer the remaining reward tokens back to the owner
127      */
128     function cancelReward() external onlyOwner nonReentrant {
129         // Reset the state to allow scheduling a new reward
130         numOfWeeksLeft = 0;
131         amountPerWeek = 0;
132         lastTimestamp = 0;
133 
134         // Transfer the remaining reward tokens back to the owner
135         address _rewardToken = rewardToken;
136         uint256 currentBalance = IERC20(_rewardToken).balanceOf(address(this));
137         if (currentBalance > 0) {
138             IERC20(_rewardToken).safeTransfer(msg.sender, currentBalance);
139         }
140     }
141 }
