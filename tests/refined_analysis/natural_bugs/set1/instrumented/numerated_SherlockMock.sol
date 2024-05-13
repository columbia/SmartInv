1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
10 import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
11 import '@openzeppelin/contracts/access/Ownable.sol';
12 import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
13 
14 import '../interfaces/ISherlock.sol';
15 
16 contract SherlockMock is ISherlock, ERC721, Ownable {
17   mapping(uint256 => bool) public override stakingPeriods;
18 
19   mapping(uint256 => uint256) public override lockupEnd;
20   mapping(uint256 => uint256) public override sherRewards;
21 
22   IStrategyManager public override yieldStrategy;
23   ISherDistributionManager public override sherDistributionManager;
24   address public override nonStakersAddress;
25   ISherlockProtocolManager public override sherlockProtocolManager;
26   ISherlockClaimManager public override sherlockClaimManager;
27 
28   IERC20 token;
29 
30   constructor() ERC721('mock', 'm') {}
31 
32   function setNonStakersAddress(address _a) external {
33     nonStakersAddress = _a;
34   }
35 
36   //
37   // View functions
38   //
39   function tokenBalanceOf(uint256 _tokenID) public view override returns (uint256) {}
40 
41   function setToken(IERC20 _token) external {
42     token = _token;
43   }
44 
45   function totalTokenBalanceStakers() public view override returns (uint256) {
46     return token.balanceOf(address(this));
47   }
48 
49   //
50   // Gov functions
51   //
52 
53   function _setStakingPeriod(uint256 _period) internal {}
54 
55   function enableStakingPeriod(uint256 _period) external override onlyOwner {}
56 
57   function disableStakingPeriod(uint256 _period) external override onlyOwner {}
58 
59   function pullSherReward(
60     uint256 _amount,
61     uint256 _period,
62     uint256 _id,
63     address _receiver
64   ) external {
65     sherDistributionManager.pullReward(_amount, _period, _id, _receiver);
66   }
67 
68   function updateSherDistributionManager(ISherDistributionManager _manager)
69     external
70     override
71     onlyOwner
72   {
73     sherDistributionManager = _manager;
74   }
75 
76   function removeSherDistributionManager() external override onlyOwner {}
77 
78   function updateNonStakersAddress(address _nonStakers) external override onlyOwner {
79     nonStakersAddress = _nonStakers;
80   }
81 
82   function updateSherlockProtocolManager(ISherlockProtocolManager _protocolManager)
83     external
84     override
85     onlyOwner
86   {
87     sherlockProtocolManager = _protocolManager;
88   }
89 
90   function updateSherlockClaimManager(ISherlockClaimManager _sherlockClaimManager)
91     external
92     override
93     onlyOwner
94   {
95     sherlockClaimManager = _sherlockClaimManager;
96   }
97 
98   function updateYieldStrategy(IStrategyManager _yieldStrategy) external override onlyOwner {}
99 
100   function updateYieldStrategyForce(IStrategyManager _yieldStrategy) external override onlyOwner {}
101 
102   function yieldStrategyDeposit(uint256 _amount) external override onlyOwner {}
103 
104   function yieldStrategyWithdraw(uint256 _amount) external override onlyOwner {}
105 
106   function yieldStrategyWithdrawAll() external override onlyOwner {}
107 
108   //
109   // Access control functions
110   //
111 
112   function payoutClaim(address _receiver, uint256 _amount) external override {}
113 
114   //
115   // Non-access control functions
116   //
117 
118   function _stake(
119     uint256 _amount,
120     uint256 _period,
121     uint256 _id
122   ) internal returns (uint256 _sher) {}
123 
124   function _verifyUnlockableByOwner(uint256 _id) internal view returns (address _nftOwner) {}
125 
126   function _sendSherRewardsToOwner(uint256 _id, address _nftOwner) internal {}
127 
128   function _transferTokensOut(address _receiver, uint256 _amount) internal {}
129 
130   function _redeemSharesCalc(uint256 _stakeShares) internal view returns (uint256) {}
131 
132   function _redeemShares(
133     uint256 _id,
134     uint256 _stakeShares,
135     address _receiver
136   ) internal returns (uint256 _amount) {}
137 
138   function _restake(
139     uint256 _id,
140     uint256 _period,
141     address _nftOwner
142   ) internal returns (uint256 _sher) {}
143 
144   function initialStake(
145     uint256 _amount,
146     uint256 _period,
147     address _receiver
148   ) external override returns (uint256 _id, uint256 _sher) {}
149 
150   function redeemNFT(uint256 _id) external override returns (uint256 _amount) {}
151 
152   function ownerRestake(uint256 _id, uint256 _period) external override returns (uint256 _sher) {}
153 
154   function _calcSharesForArbRestake(uint256 _id) internal view returns (uint256) {}
155 
156   function viewRewardForArbRestake(uint256 _id) external view returns (uint256) {}
157 
158   function arbRestake(uint256 _id) external override returns (uint256 _sher, uint256 _arbReward) {}
159 }
