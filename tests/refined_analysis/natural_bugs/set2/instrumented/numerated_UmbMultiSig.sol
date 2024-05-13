1 //SPDX-License-Identifier: MIT
2 pragma solidity >=0.7.5;
3 
4 // Inheritance
5 import "./interfaces/PowerMultiSig.sol";
6 
7 /// @title   Umbrella MultiSig contract
8 /// @author  umb.network
9 /// @notice  This is extended version of PowerMultiSig wallet, that will allow to execute commands without FE.
10 /// @dev     Original MultiSig requires FE to run, but here, we have some predefined data for few transactions
11 ///          so we can run it directly from Etherscan and not worry about data bytes
12 contract UmbMultiSig is PowerMultiSig {
13 
14   // ========== MODIFIERS ========== //
15 
16   // ========== CONSTRUCTOR ========== //
17 
18   constructor(address[] memory _owners, uint256[] memory _powers, uint256 _requiredPower)
19   PowerMultiSig(_owners, _powers, _requiredPower) {
20   }
21 
22   // ========== VIEWS ========== //
23 
24   function createFunctionSignature(string memory _f) public pure returns (bytes memory) {
25     return abi.encodeWithSignature(_f);
26   }
27 
28   // ========== MUTATIVE FUNCTIONS ========== //
29 
30   // ========== helpers for: UMB, rUMB
31 
32   function submitTokenMintTx(address _destination, address _holder, uint _amount) public returns (uint) {
33     bytes memory data = abi.encodeWithSignature("mint(address,uint256)", _holder, _amount);
34     return submitTransaction(_destination, 0, data);
35   }
36 
37   // ========== helpers for: UMB
38 
39   function submitUMBSetRewardTokensTx(address _destination, address[] memory _tokens, bool[] memory _statuses) public returns (uint) {
40     bytes memory data = abi.encodeWithSignature("setRewardTokens(address[],bool[])", _tokens, _statuses);
41     return submitTransaction(_destination, 0, data);
42   }
43 
44   // ========== helpers for: Auction
45 
46   function submitAuctionStartTx(address _destination) public returns (uint) {
47     bytes memory data = abi.encodeWithSignature("start()");
48     return submitTransaction(_destination, 0, data);
49   }
50 
51   function submitAuctionSetupTx(
52     address _destination,
53     uint256 _minimalEthPricePerToken,
54     uint256 _minimalRequiredLockedEth,
55     uint256 _maximumLockedEth
56   ) public returns (uint) {
57     bytes memory data = abi.encodeWithSignature(
58       "setup(uint256,uint256,uint256)",
59         _minimalEthPricePerToken,
60         _minimalRequiredLockedEth,
61         _maximumLockedEth
62     );
63 
64     return submitTransaction(_destination, 0, data);
65   }
66 
67   // ========== helpers for: rUMB
68 
69   function submitRUMBStartSwapNowTx(address _destination) public returns (uint) {
70     bytes memory data = abi.encodeWithSignature("startSwapNow()");
71     return submitTransaction(_destination, 0, data);
72   }
73 
74   // ========== helpers for: Rewards
75 
76   function submitRewardsStartDistributionTx(
77     address _destination,
78     address _rewardToken,
79     uint _startTime,
80     address[] calldata _participants,
81     uint[] calldata _rewards,
82     uint[] calldata _durations
83   ) public returns (uint) {
84     bytes memory data = abi.encodeWithSignature(
85       "startDistribution(address,uint256,address[],uint256[],uint256[])",
86       _rewardToken,
87       _startTime,
88       _participants,
89       _rewards,
90       _durations
91     );
92 
93     return submitTransaction(_destination, 0, data);
94   }
95 
96   // ========== helpers for: StakingRewards
97 
98   function submitStakingRewardsSetRewardsDistributionTx(address _destination, address _rewardsDistributor) public returns (uint) {
99     bytes memory data = abi.encodeWithSignature("setRewardsDistribution(address)", _rewardsDistributor);
100     return submitTransaction(_destination, 0, data);
101   }
102 
103   function submitStakingRewardsSetRewardsDurationTx(address _destination, uint _duration) public returns (uint) {
104     bytes memory data = abi.encodeWithSignature("setRewardsDuration(uint256)", _duration);
105     return submitTransaction(_destination, 0, data);
106   }
107 
108   function submitStakingRewardsNotifyRewardAmountTx(address _destination, uint _amount) public returns (uint) {
109     bytes memory data = abi.encodeWithSignature("notifyRewardAmount(uint256)", _amount);
110     return submitTransaction(_destination, 0, data);
111   }
112 
113   // ========== EVENTS ========== //
114 }
