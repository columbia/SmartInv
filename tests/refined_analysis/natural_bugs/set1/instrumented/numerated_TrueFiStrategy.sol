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
11 import '../interfaces/truefi/ITrueFiPool2.sol';
12 import '../interfaces/truefi/ITrueMultiFarm.sol';
13 
14 // This contract contains logic for depositing staker funds into TrueFi as a yield strategy
15 // https://github.com/trusttoken/contracts-pre22/blob/main/contracts/truefi2/TrueFiPool2.sol
16 // https://docs.truefi.io/faq/main-lending-pools/pool#lending-pools-smart-contracts
17 
18 // TRU farming
19 // https://docs.truefi.io/faq/main-lending-pools/farming-liquidity-mining
20 
21 // Joining fee is currently 0, is able to change
22 
23 /*
24 Thoughts on adding `liquidExitPenalty` to `balanceOf()`
25 
26 In the most extreme example where all our money is in TrueFi and we don't assume the exit fee,
27 people will see balance = 100 USDC, but when actually withdrawing it will be 90 USDC
28 (because of the exit fee)
29 
30 In the other most extreme example where all our money is not yet in TrueFi and we do assume the exit fee,
31 people can see balance = 100 USDC but when we deposit it, it will be 90 USDC (because of the exit fee)
32 (note: this affects the exit fee in a positive way as it adds liquidity)
33 
34 ^ these extremes assume our deposits/withdraws don't have any effect on the exit fee.
35 But with the current 180m$ pool it will take 9m$ to move the poolLiquidty 5%,
36 which is 0.91% -> 10% in the most extreme scenario
37 
38 Takeaways
39 - We want to account the exit fee to not 'surprise' people on withdraw with a lower balance
40 - We want to be a small part of the pool (<=5%?) to keep it liquid and not move the exitFee to 10% on exit.
41 
42 What happen if we are a large part of the pool?
43 
44 For example if balanceOf = totalSupply and we have deposited 100 USDC
45 Only 10 USDC is liquid (10%) which makes the exit fee 0.48%
46 
47 `balanceOf()` would show 99,52 USDC as the exit fee is applied
48 If we call `liquidExit()` with 10 USDC, 0% will be liquid and the exit fee jumps up to 10%
49 `balanceOf()` would show 10 USDC + 81 (90 USDC - 10% exit fee) = 91 USDC
50 */
51 
52 // All tfUSDC will be staked in the farm at any time (except runtime of a transaction)
53 contract TrueFiStrategy is BaseStrategy {
54   using SafeERC20 for IERC20;
55   using SafeERC20 for ITrueFiPool2;
56 
57   // Value copied from https://github.com/trusttoken/contracts-pre22/blob/main/contracts/truefi2/TrueFiPool2.sol#L487
58   uint256 private constant BASIS_PRECISION = 10000;
59 
60   // the tfUSDC pool
61   ITrueFiPool2 public constant tfUSDC = ITrueFiPool2(0xA991356d261fbaF194463aF6DF8f0464F8f1c742);
62   // TrueFi farm, used to stake tfUSDC and earn TrueFi tokens
63   ITrueMultiFarm public constant tfFarm =
64     ITrueMultiFarm(0xec6c3FD795D6e6f202825Ddb56E01b3c128b0b10);
65   // The TrueFi token
66   IERC20 public constant rewardToken = IERC20(0x4C19596f5aAfF459fA38B0f7eD92F11AE6543784);
67 
68   // Address to receive rewards
69   address public constant LIQUIDITY_MINING_RECEIVER = 0x666B8EbFbF4D5f0CE56962a25635CfF563F13161;
70 
71   /// @param _initialParent Contract that will be the parent in the tree structure
72   constructor(IMaster _initialParent) BaseNode(_initialParent) {
73     // Approve tfUSDC max amount of USDC
74     want.safeIncreaseAllowance(address(tfUSDC), type(uint256).max);
75     // Approve tfFarm max amount of tfUSDC
76     tfUSDC.safeIncreaseAllowance(address(tfFarm), type(uint256).max);
77   }
78 
79   /// @notice Signal if strategy is ready to be used
80   /// @return Boolean indicating if strategy is ready
81   function setupCompleted() external view override returns (bool) {
82     return true;
83   }
84 
85   /// @notice Deposit all USDC in this contract in TrueFi
86   /// @notice Joining fee may apply, this will lower the balance of the system on deposit
87   /// @notice Works under the assumption this contract contains USDC
88   function _deposit() internal override whenNotPaused {
89     // https://github.com/trusttoken/contracts-pre22/blob/main/contracts/truefi2/TrueFiPool2.sol#L469
90     tfUSDC.join(want.balanceOf(address(this)));
91 
92     // Don't stake in the tfFarm if shares are 0
93     // This would make the function call revert
94     // https://github.com/trusttoken/contracts-pre22/blob/main/contracts/truefi2/TrueMultiFarm.sol#L101
95     if (tfFarm.getShare(tfUSDC) == 0) return;
96 
97     // How much tfUSDC is in this contract
98     // Could both be tfUSDC that was already in here before the `_deposit()` call
99     // And new tfUSDC that was minted in the `tfUSDC.join()` call
100     uint256 tfUsdcBalance = tfUSDC.balanceOf(address(this));
101 
102     // Stake all tfUSDC in the tfFarm
103     tfFarm.stake(tfUSDC, tfUsdcBalance);
104   }
105 
106   /// @notice Send all USDC in this contract to core
107   /// @notice Funds need to be withdrawn using `liquidExit()` first
108   /// @return amount Amount of USDC withdrawn
109   function _withdrawAll() internal override returns (uint256 amount) {
110     // Amount of USDC in the contract
111     amount = want.balanceOf(address(this));
112     // Transfer USDC to core
113     if (amount != 0) want.safeTransfer(core, amount);
114   }
115 
116   /// @notice Send `_amount` USDC in this contract to core
117   /// @notice Funds need to be withdrawn using `liquidExit()` first
118   /// @param _amount Amount of USDC to withdraw
119   function _withdraw(uint256 _amount) internal override {
120     // Transfer USDC to core
121     want.safeTransfer(core, _amount);
122   }
123 
124   /// @notice View how much tfUSDC is staked in the farm
125   /// @return Amount of tfUSDC staked
126   function _viewTfUsdcStaked() private view returns (uint256) {
127     // Amount of tfUSDC staked in the tfFarm
128     return tfFarm.staked(tfUSDC, address(this));
129   }
130 
131   /// @notice View USDC in this contract + USDC in TrueFi
132   /// @notice Takes into account exit penalty for liquidating full tfUSDC balance
133   /// @return Amount of USDC in this strategy
134   function _balanceOf() internal view override returns (uint256) {
135     // https://docs.truefi.io/faq/main-lending-pools/developer-guide/truefipool2-contract#calculating-lending-pool-token-prices
136 
137     // How much USDC is locked in TrueFi
138     // Based on staked tfUSDC + tfUSDC in this contract
139     uint256 tfUsdcBalance = (tfUSDC.poolValue() *
140       (_viewTfUsdcStaked() + tfUSDC.balanceOf(address(this)))) / tfUSDC.totalSupply();
141 
142     // How much USDC we get if we liquidate the full position
143     tfUsdcBalance = (tfUsdcBalance * tfUSDC.liquidExitPenalty(tfUsdcBalance)) / BASIS_PRECISION;
144 
145     // Return USDC in contract + USDC we can get from TrueFi
146     return want.balanceOf(address(this)) + tfUsdcBalance;
147   }
148 
149   /// @notice Exit `_amount` of tfUSDC (pool LP tokens)
150   /// @notice Up to 10% exit fee may apply.
151   /// @notice There are two situations in which the pool will not let you withdraw via Liquid Exit:
152   /// @notice 1) If there is no liquid asset in the lending pool and no liquid exit is deployed in Curve.
153   /// @notice 2) If the pool needs to liquidate its position in Curve and will incur a loss of more than 10 basis points.
154   /// @dev Can only be called by owner
155   function liquidExit(uint256 _amount) external onlyOwner {
156     // https://github.com/trusttoken/contracts-pre22/blob/main/contracts/truefi2/TrueFiPool2.sol#L487
157     // here's a spreadsheet that shows the exit penalty at different liquidRatio levels ( = liquidValue / poolValue):
158     // https://docs.google.com/spreadsheets/d/1ZXGRxunIwe0eYPu7j4QjCwXxe63tNKtpCvRiJnqK0jo/edit#gid=0
159 
160     // Exiting 0 tokens doesn't make sense
161     if (_amount == 0) revert ZeroArg();
162 
163     // Amount of tfUSDC in this contract
164     uint256 tfUsdcBalance = tfUSDC.balanceOf(address(this));
165     uint256 tfUsdcStaked = _viewTfUsdcStaked();
166 
167     // Exit MAX amount of tokens
168     if (_amount == type(uint256).max) {
169       _amount = tfUsdcBalance + tfUsdcStaked;
170       // Exiting 0 tokens doesn't make sense
171       if (_amount == 0) revert InvalidState();
172     }
173     // We can not withdraw more tfUSDC than we have access to
174     else if (_amount > tfUsdcBalance + tfUsdcStaked) revert InvalidArg();
175 
176     // Unstake tfUSDC if it isn't in the contract already
177     if (_amount > tfUsdcBalance) {
178       // Unstake tfUSDC from tfFarm so we are able to exit `_amount`
179       tfFarm.unstake(tfUSDC, _amount - tfUsdcBalance);
180     }
181 
182     // At this point there should be at least `_amount` of tfUSDC in the contract
183     // Unstake tfUSDC tokens from the pool, this will send USDC to this contract
184     tfUSDC.liquidExit(_amount);
185   }
186 
187   /// @notice Claim TrueFi tokens earned by farming
188   /// @dev TrueFi tokens will be send to LIQUIDITY_MINING_RECEIVER
189   function claimReward() external {
190     IERC20[] memory tokens = new IERC20[](1);
191     tokens[0] = tfUSDC;
192 
193     // Claim TrueFi tokens for tfUSDC
194     tfFarm.claim(tokens);
195 
196     // How much TrueFi tokens does this contract hold
197     uint256 rewardBalance = rewardToken.balanceOf(address(this));
198 
199     // Send all TrueFi tokens to LIQUIDITY_MINING_RECEIVER
200     if (rewardBalance != 0) rewardToken.safeTransfer(LIQUIDITY_MINING_RECEIVER, rewardBalance);
201   }
202 }
