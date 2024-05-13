1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import './base/BaseStrategy.sol';
10 
11 import '../interfaces/maple/IPool.sol';
12 import '../interfaces/maple/IMplRewards.sol';
13 
14 // This contract contains logic for depositing staker funds into maple finance as a yield strategy
15 // https://github.com/maple-labs/maple-core/blob/main/contracts/Pool.sol
16 // https://github.com/maple-labs/maple-core/wiki/Pools
17 
18 contract MapleStrategy is BaseStrategy {
19   using SafeERC20 for IERC20;
20   // MPL Reward contract  0x7C57bF654Bc16B0C9080F4F75FF62876f50B8259
21   // Current Maven11 USDC pool: 0x6F6c8013f639979C84b756C7FC1500eB5aF18Dc4
22   // https://app.maple.finance/#/earn/pool/0x6f6c8013f639979c84b756c7fc1500eb5af18dc4
23 
24   // MPL Reward contract 0x7869D7a3B074b5fa484dc04798E254c9C06A5e90
25   // Current Orthogonal Trading  USDC pool: 0xFeBd6F15Df3B73DC4307B1d7E65D46413e710C27
26   // https://app.maple.finance/#/earn/pool/0xfebd6f15df3b73dc4307b1d7e65d46413e710c27
27   IPool public immutable maplePool;
28   IMplRewards public immutable mapleRewards;
29 
30   // Address to receive rewards
31   address public constant LIQUIDITY_MINING_RECEIVER = 0x666B8EbFbF4D5f0CE56962a25635CfF563F13161;
32 
33   /// @param _initialParent Contract that will be the parent in the tree structure
34   /// @param _mapleRewards Maple rewards contract linked to USDC staking pool
35   constructor(IMaster _initialParent, IMplRewards _mapleRewards) BaseNode(_initialParent) {
36     // Get Maple Pool based on the reward pool
37     // Store maple pool for future usage
38     maplePool = IPool(_mapleRewards.stakingToken());
39 
40     // revert if the pool isn't USDC
41     if (_initialParent.want() != maplePool.liquidityAsset()) revert InvalidArg();
42     // revert if the pool isn't public
43     if (maplePool.openToPublic() == false) revert InvalidState();
44 
45     // Approve maple mool max amount of USDC
46     want.safeIncreaseAllowance(address(maplePool), type(uint256).max);
47 
48     // Store maple rewards for future usage
49     mapleRewards = _mapleRewards;
50   }
51 
52   /// @notice Signal if strategy is ready to be used
53   /// @return Boolean indicating if strategy is ready
54   function setupCompleted() external view override returns (bool) {
55     return true;
56   }
57 
58   /// @notice View timestamp the deposit matures
59   /// @dev After this timestamp admin is able to call `withdraw()` if this contract is in the unstake window
60   /// @dev Step 1: call `intendToWithdraw()` on `maturityTime` - `stakerCooldownPeriod`
61   /// @dev Step 2: when `maturityTime` is reached, the contract is in the unstake window, call `withdraw()` to unstake USDC
62   /// @dev https://etherscan.io/address/0xc234c62c8c09687dff0d9047e40042cd166f3600#readContract
63   /// @dev stakerCooldownPeriod uint256 :  864000 (10 days to cooldown)
64   /// @dev stakerUnstakeWindow  uint256 :  172800 (2 days to unstake)
65   function maturityTime() external view returns (uint256) {
66     // Get current deposit date from the maple pool
67     // Value uses a weigthed average on multiple deposits
68     uint256 date = maplePool.depositDate(address(this));
69 
70     // Return 0 if no USDC is deposited into the Maple pool
71     if (date == 0) return 0;
72 
73     // Deposit will mature when lockup period ends
74     return date + maplePool.lockupPeriod();
75   }
76 
77   /// @notice Deposit all USDC in this contract in Maple
78   /// @notice Works under the assumption this contract contains USDC
79   /// @dev Weighted average is used for depositDate calculation
80   /// @dev https://github.com/maple-labs/maple-core/blob/main/contracts/Pool.sol#L377
81   /// @dev Multiple deposits = weighted average of unlock time https://github.com/maple-labs/maple-core/blob/main/contracts/library/PoolLib.sol#L209
82   function _deposit() internal override whenNotPaused {
83     // How many maplePool tokens do we currently own
84     uint256 maplePoolBalanceBefore = maplePool.balanceOf(address(this));
85 
86     // Deposit all USDC into maple
87     maplePool.deposit(want.balanceOf(address(this)));
88 
89     // How many maplePool tokens did we gain after depositing
90     uint256 maplePoolDifference = maplePool.balanceOf(address(this)) - maplePoolBalanceBefore;
91 
92     if (maplePoolDifference == 0) return;
93 
94     // Approve newly gained maple pool tokens to mapleRewards
95     maplePool.increaseCustodyAllowance(address(mapleRewards), maplePoolDifference);
96 
97     // "Stake" new tokens in the mapleRewards pool
98     // Note that maple pool tokens are not actually transferred
99     // https://github.com/maple-labs/mpl-rewards/blob/main/contracts/MplRewards.sol#L87
100     mapleRewards.stake(maplePoolDifference);
101   }
102 
103   /// @notice Send all USDC in this contract to core
104   /// @notice Funds need to be withdrawn using `withdrawFromMaple()` first
105   /// @return amount Amount of USDC withdrawn
106   function _withdrawAll() internal override returns (uint256 amount) {
107     // Amount of USDC in the contract
108     amount = want.balanceOf(address(this));
109     // Transfer USDC to core
110     if (amount != 0) want.safeTransfer(core, amount);
111   }
112 
113   /// @notice Send `_amount` USDC in this contract to core
114   /// @notice Funds need to be withdrawn using `withdrawFromMaple()` first
115   /// @param _amount Amount of USDC to withdraw
116   function _withdraw(uint256 _amount) internal override {
117     // Transfer USDC to core
118     want.safeTransfer(core, _amount);
119   }
120 
121   /// @notice View USDC in this contract + USDC in Maple
122   /// @dev Important the balance is only increasing after a `claim()` call by the pool admin
123   /// @dev This means people can get anticipate these `claim()` calls and get a better entry/exit position in the Sherlock pool
124   /// @return Amount of USDC in this strategy
125   // Ideally `withdrawableFundsOf` would be incrementing every block
126   // This value mostly depends on `accumulativeFundsOf` https://github.com/maple-labs/maple-core/blob/main/contracts/token/BasicFDT.sol#L70
127   // Where `pointsPerShare` is the main variable used to increase balance https://github.com/maple-labs/maple-core/blob/main/contracts/token/BasicFDT.sol#L92
128   // This variable is mutated in the internal `_distributeFunds` function https://github.com/maple-labs/maple-core/blob/main/contracts/token/BasicFDT.sol#L47
129   // This internal function is called by the public `updateFundsReceived()` which depends on `_updateFundsTokenBalance()` to be > 0 https://github.com/maple-labs/maple-core/blob/main/contracts/token/BasicFDT.sol#L179
130   // This can only be >0 if `interestSum` mutates to a bigger value https://github.com/maple-labs/maple-core/blob/main/contracts/token/PoolFDT.sol#L51
131   // The place where `interestSum` is mutated is the `claim()` function restricted by pool admin / delegate https://github.com/maple-labs/maple-core/blob/main/contracts/Pool.sol#L222
132   function _balanceOf() internal view override returns (uint256) {
133     // Source Lucas Manuel | Maple
134     // Even though we 'stake' maple pool tokens in the reward contract
135     // They are actually not transferred to the reward contract
136     // Maple uses custom 'custody' logic in the staking contract
137     // https://github.com/maple-labs/mpl-rewards/blob/main/contracts/MplRewards.sol#L92
138     return
139       want.balanceOf(address(this)) +
140       ((maplePool.balanceOf(address(this)) +
141         maplePool.withdrawableFundsOf(address(this)) -
142         maplePool.recognizableLossesOf(address(this))) / 10**12);
143   }
144 
145   /// @notice Start cooldown period for Maple withdrawal
146   /// @dev Can only be called by owner
147   function intendToWithdraw() external onlyOwner {
148     // https://github.com/maple-labs/maple-core/blob/main/contracts/Pool.sol#L398
149     maplePool.intendToWithdraw();
150   }
151 
152   /// @notice Withdraw funds to this contract
153   /// @dev Can only be called by owner
154   /// @notice Actual USDC amount can be bigger or greater based on losses or gains
155   /// @notice If `_maplePoolTokenAmount` == `maplePool.balanceOf(address(this)` it will withdraw the max amount of USDC
156   /// @notice If `_maplePoolTokenAmount` < `recognizableLossesOf(this)` the transaction will revert
157   /// @notice If `_maplePoolTokenAmount` = `recognizableLossesOf(this)`, it will send `withdrawableFundsOf` USDC
158   /// @param _maplePoolTokenAmount Amount of maple pool tokens to withdraw (usdc * 10**12)
159   function withdrawFromMaple(uint256 _maplePoolTokenAmount) external onlyOwner {
160     // Exiting 0 tokens doesn't make sense
161     if (_maplePoolTokenAmount == 0) revert ZeroArg();
162 
163     // Withdraw all USDC
164     if (_maplePoolTokenAmount == type(uint256).max) {
165       // Withdraw all maple pool tokens
166       _maplePoolTokenAmount = maplePool.balanceOf(address(this));
167 
168       // Exiting 0 tokens doesn't make sense
169       if (_maplePoolTokenAmount == 0) revert InvalidState();
170     }
171 
172     // 'Withdraw' maplePool tokens from maple rewards
173     // note that maple pool tokens are not actually transferred
174     // https://github.com/maple-labs/mpl-rewards/blob/main/contracts/MplRewards.sol#L98
175     mapleRewards.withdraw(_maplePoolTokenAmount);
176 
177     // Maple pool = 18 decimals
178     // USDC = 6 decimals
179     // Exchange rate is 1:1
180     // Divide by 10**12 to get USDC amount
181     uint256 usdcAmount = _maplePoolTokenAmount / 10**12;
182 
183     // On withdraw this function is used for the `withdrawableFundsOf()` https://github.com/maple-labs/maple-core/blob/main/contracts/Pool.sol#L438
184     // As it's calling `_prepareWithdraw()` https://github.com/maple-labs/maple-core/blob/main/contracts/Pool.sol#L472
185     // Which is using the `withdrawableFundsOf()` function https://github.com/maple-labs/maple-core/blob/main/contracts/token/BasicFDT.sol#L58
186     // These earned funds ar send to this contract https://github.com/maple-labs/maple-core/blob/main/contracts/Pool.sol#L476
187     // It will automatically add USDC gains and subtract USDC losses.
188     // It sends USDC to this contract
189     maplePool.withdraw(usdcAmount);
190   }
191 
192   /// @notice Claim Maple tokens earned by farming
193   /// @dev Maple tokens will be send to LIQUIDITY_MINING_RECEIVER
194   function claimReward() external {
195     // Claim reward tokens
196     mapleRewards.getReward();
197 
198     // Cache reward token address
199     IERC20 rewardToken = mapleRewards.rewardsToken();
200 
201     // Query reward token balance
202     uint256 balance = rewardToken.balanceOf(address(this));
203 
204     // Send all reward tokens to LIQUIDITY_MINING_RECEIVER
205     if (balance != 0) rewardToken.safeTransfer(LIQUIDITY_MINING_RECEIVER, balance);
206   }
207 }
