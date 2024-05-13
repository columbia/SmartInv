1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0;
4 
5 import "./interface/IMasterChefDepositFee.sol";
6 import "../interface/IStrategy.sol";
7 
8 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
9 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
10 
11 import "@openzeppelin/contracts-upgradeable/math/MathUpgradeable.sol";
12 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
13 
14 import "../interface/IVault.sol";
15 import "../upgradability/BaseUpgradeableStrategy.sol";
16 import "../interface/pancakeswap/IPancakePair.sol";
17 import "../interface/pancakeswap/IPancakeRouter02.sol";
18 
19 contract GeneralMasterChefStrategyDepositFee is BaseUpgradeableStrategy {
20   using SafeMath for uint256;
21   using SafeBEP20 for IBEP20;
22 
23   address constant public pancakeswapRouterV2 = address(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
24 
25   // additional storage slots (on top of BaseUpgradeableStrategy ones) are defined here
26   bytes32 internal constant _POOLID_SLOT = 0x3fd729bfa2e28b7806b03a6e014729f59477b530f995be4d51defc9dad94810b;
27   bytes32 internal constant _IS_LP_ASSET_SLOT = 0xc2f3dabf55b1bdda20d5cf5fcba9ba765dfc7c9dbaf28674ce46d43d60d58768;
28 
29   // this would be reset on each upgrade
30   mapping (address => address[]) public pancakeswapRoutes;
31   uint256 public pendingReward;
32 
33   constructor() public BaseUpgradeableStrategy() {
34     assert(_POOLID_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.poolId")) - 1));
35     assert(_IS_LP_ASSET_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.isLpAsset")) - 1));
36   }
37 
38   function initializeStrategy(
39     address _storage,
40     address _underlying,
41     address _vault,
42     address _rewardPool,
43     address _rewardToken,
44     uint256 _poolID,
45     bool _isLpToken
46   ) public initializer {
47 
48     BaseUpgradeableStrategy.initialize(
49       _storage,
50       _underlying,
51       _vault,
52       _rewardPool,
53       _rewardToken,
54       80, // profit sharing numerator
55       1000, // profit sharing denominator
56       true, // sell
57       1e16, // sell floor
58       12 hours // implementation change delay
59     );
60 
61     address _lpt;
62     (_lpt,,,,) = IMasterChefDepositFee(rewardPool()).poolInfo(_poolID);
63     require(_lpt == underlying(), "Pool Info does not match underlying");
64     _setPoolId(_poolID);
65 
66     if (_isLpToken) {
67       address uniLPComponentToken0 = IPancakePair(underlying()).token0();
68       address uniLPComponentToken1 = IPancakePair(underlying()).token1();
69 
70       // these would be required to be initialized separately by governance
71       pancakeswapRoutes[uniLPComponentToken0] = new address[](0);
72       pancakeswapRoutes[uniLPComponentToken1] = new address[](0);
73     } else {
74       pancakeswapRoutes[underlying()] = new address[](0);
75     }
76 
77     setBoolean(_IS_LP_ASSET_SLOT, _isLpToken);
78   }
79 
80   modifier updatePendingReward() {
81     _;
82     pendingReward = IBEP20(rewardToken()).balanceOf(address(this));
83   }
84 
85   function depositArbCheck() public pure returns(bool) {
86     return true;
87   }
88 
89   function rewardPoolBalance() internal view returns (uint256 bal) {
90       (bal,) = IMasterChefDepositFee(rewardPool()).userInfo(poolId(), address(this));
91   }
92 
93   function unsalvagableTokens(address token) public view returns (bool) {
94     return (token == rewardToken() || token == underlying());
95   }
96 
97   function enterRewardPool() updatePendingReward internal {
98     uint16 depositFee;
99     (,,,,depositFee) = IMasterChefDepositFee(rewardPool()).poolInfo(poolId());
100     require(depositFee == 0, "Deposit fee is non-zero");
101     uint256 entireBalance = IBEP20(underlying()).balanceOf(address(this));
102     IBEP20(underlying()).safeApprove(rewardPool(), 0);
103     IBEP20(underlying()).safeApprove(rewardPool(), entireBalance);
104 
105     IMasterChefDepositFee(rewardPool()).deposit(poolId(), entireBalance);
106   }
107 
108   /*
109   *   In case there are some issues discovered about the pool or underlying asset
110   *   Governance can exit the pool properly
111   *   The function is only used for emergency to exit the pool
112   */
113   function emergencyExit() updatePendingReward public onlyGovernance {
114     uint256 bal = rewardPoolBalance();
115     IMasterChefDepositFee(rewardPool()).withdraw(poolId(), bal);
116     _setPausedInvesting(true);
117   }
118 
119   /*
120   *   Resumes the ability to invest into the underlying reward pools
121   */
122   function continueInvesting() public onlyGovernance {
123     _setPausedInvesting(false);
124   }
125 
126   function setLiquidationPath(address _token, address [] memory _route) public onlyGovernance {
127     require(_route[0] == rewardToken(), "Path should start with rewardToken");
128     require(_route[_route.length-1] == _token, "Path should end with given Token");
129     pancakeswapRoutes[_token] = _route;
130   }
131 
132   // We assume that all the tradings can be done on Pancakeswap
133   function _liquidateReward(uint256 rewardBalance) internal {
134     if (!sell() || rewardBalance < sellFloor()) {
135       // Profits can be disabled for possible simplified and rapid exit
136       emit ProfitsNotCollected(sell(), rewardBalance < sellFloor());
137       return;
138     }
139 
140     notifyProfitInRewardToken(rewardBalance);
141     uint256 remainingRewardBalance = IBEP20(rewardToken()).balanceOf(address(this));
142 
143     if (remainingRewardBalance == 0) {
144       return;
145     }
146 
147     // allow Pancakeswap to sell our reward
148     IBEP20(rewardToken()).safeApprove(pancakeswapRouterV2, 0);
149     IBEP20(rewardToken()).safeApprove(pancakeswapRouterV2, remainingRewardBalance);
150 
151     // we can accept 1 as minimum because this is called only by a trusted role
152     uint256 amountOutMin = 1;
153 
154     if (isLpAsset()) {
155       address uniLPComponentToken0 = IPancakePair(underlying()).token0();
156       address uniLPComponentToken1 = IPancakePair(underlying()).token1();
157 
158       uint256 toToken0 = remainingRewardBalance.div(2);
159       uint256 toToken1 = remainingRewardBalance.sub(toToken0);
160 
161       uint256 token0Amount;
162 
163       if (pancakeswapRoutes[uniLPComponentToken0].length > 1) {
164         // if we need to liquidate the token0
165         IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
166           toToken0,
167           amountOutMin,
168           pancakeswapRoutes[uniLPComponentToken0],
169           address(this),
170           block.timestamp
171         );
172         token0Amount = IBEP20(uniLPComponentToken0).balanceOf(address(this));
173       } else {
174         // otherwise we assme token0 is the reward token itself
175         token0Amount = toToken0;
176       }
177 
178       uint256 token1Amount;
179 
180       if (pancakeswapRoutes[uniLPComponentToken1].length > 1) {
181         // sell reward token to token1
182         IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
183           toToken1,
184           amountOutMin,
185           pancakeswapRoutes[uniLPComponentToken1],
186           address(this),
187           block.timestamp
188         );
189         token1Amount = IBEP20(uniLPComponentToken1).balanceOf(address(this));
190       } else {
191         token1Amount = toToken1;
192       }
193 
194       // provide token0 and token1 to Pancake
195       IBEP20(uniLPComponentToken0).safeApprove(pancakeswapRouterV2, 0);
196       IBEP20(uniLPComponentToken0).safeApprove(pancakeswapRouterV2, token0Amount);
197 
198       IBEP20(uniLPComponentToken1).safeApprove(pancakeswapRouterV2, 0);
199       IBEP20(uniLPComponentToken1).safeApprove(pancakeswapRouterV2, token1Amount);
200 
201       // we provide liquidity to Pancake
202       uint256 liquidity;
203       (,,liquidity) = IPancakeRouter02(pancakeswapRouterV2).addLiquidity(
204         uniLPComponentToken0,
205         uniLPComponentToken1,
206         token0Amount,
207         token1Amount,
208         1,  // we are willing to take whatever the pair gives us
209         1,  // we are willing to take whatever the pair gives us
210         address(this),
211         block.timestamp
212       );
213     } else {
214       if (underlying() != rewardToken()) {
215         IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
216           remainingRewardBalance,
217           amountOutMin,
218           pancakeswapRoutes[underlying()],
219           address(this),
220           block.timestamp
221         );
222       }
223     }
224   }
225 
226   /*
227   *   Stakes everything the strategy holds into the reward pool
228   */
229   function investAllUnderlying() internal onlyNotPausedInvesting {
230     // this check is needed, because most of the SNX reward pools will revert if
231     // you try to stake(0).
232     if(IBEP20(underlying()).balanceOf(address(this)) > 0) {
233       enterRewardPool();
234     }
235   }
236 
237   /*
238   *   Withdraws all the asset to the vault
239   */
240   function withdrawAllToVault() updatePendingReward public restricted {
241     if (address(rewardPool()) != address(0)) {
242       uint256 bal = rewardPoolBalance();
243       IMasterChefDepositFee(rewardPool()).withdraw(poolId(), bal);
244     }
245     if (underlying() != rewardToken()) {
246       uint256 rewardBalance = IBEP20(rewardToken()).balanceOf(address(this));
247       _liquidateReward(rewardBalance);
248     }
249     IBEP20(underlying()).safeTransfer(vault(), IBEP20(underlying()).balanceOf(address(this)));
250   }
251 
252   /*
253   *   Withdraws all the asset to the vault
254   */
255   function withdrawToVault(uint256 amount) updatePendingReward public restricted {
256     // Typically there wouldn't be any amount here
257     // however, it is possible because of the emergencyExit
258     uint256 entireBalance = IBEP20(underlying()).balanceOf(address(this));
259 
260     if(amount > entireBalance){
261       // While we have the check above, we still using SafeMath below
262       // for the peace of mind (in case something gets changed in between)
263       uint256 needToWithdraw = amount.sub(entireBalance);
264       uint256 toWithdraw = MathUpgradeable.min(rewardPoolBalance(), needToWithdraw);
265       IMasterChefDepositFee(rewardPool()).withdraw(poolId(), toWithdraw);
266     }
267 
268     IBEP20(underlying()).safeTransfer(vault(), amount);
269   }
270 
271   /*
272   *   Note that we currently do not have a mechanism here to include the
273   *   amount of reward that is accrued.
274   */
275   function investedUnderlyingBalance() external view returns (uint256) {
276     if (rewardPool() == address(0)) {
277       return IBEP20(underlying()).balanceOf(address(this));
278     }
279     // Adding the amount locked in the reward pool and the amount that is somehow in this contract
280     // both are in the units of "underlying"
281     // The second part is needed because there is the emergency exit mechanism
282     // which would break the assumption that all the funds are always inside of the reward pool
283     return rewardPoolBalance().add(IBEP20(underlying()).balanceOf(address(this)));
284   }
285 
286   /*
287   *   Governance or Controller can claim coins that are somehow transferred into the contract
288   *   Note that they cannot come in take away coins that are used and defined in the strategy itself
289   */
290   function salvage(address recipient, address token, uint256 amount) external onlyControllerOrGovernance {
291      // To make sure that governance cannot come in and take away the coins
292     require(!unsalvagableTokens(token), "token is defined as not salvagable");
293     IBEP20(token).safeTransfer(recipient, amount);
294   }
295 
296   /*
297   *   Get the reward, sell it in exchange for underlying, invest what you got.
298   *   It's not much, but it's honest work.
299   *
300   *   Note that although `onlyNotPausedInvesting` is not added here,
301   *   calling `investAllUnderlying()` affectively blocks the usage of `doHardWork`
302   *   when the investing is being paused by governance.
303   */
304   function doHardWork() updatePendingReward external onlyNotPausedInvesting restricted {
305     uint256 bal = rewardPoolBalance();
306     if (bal != 0) {
307       uint256 rewardBalanceBefore = IBEP20(rewardToken()).balanceOf(address(this));
308       IMasterChefDepositFee(rewardPool()).withdraw(poolId(), 0);
309       uint256 rewardBalanceAfter = IBEP20(rewardToken()).balanceOf(address(this));
310       uint256 claimedReward = rewardBalanceAfter.sub(rewardBalanceBefore).add(pendingReward);
311       _liquidateReward(claimedReward);
312     }
313 
314     investAllUnderlying();
315   }
316 
317   /**
318   * Can completely disable claiming rewards and selling. Good for emergency withdraw in the
319   * simplest possible way.
320   */
321   function setSell(bool s) public onlyGovernance {
322     _setSell(s);
323   }
324 
325   /**
326   * Sets the minimum amount needed to trigger a sale.
327   */
328   function setSellFloor(uint256 floor) public onlyGovernance {
329     _setSellFloor(floor);
330   }
331 
332   // masterchef rewards pool ID
333   function _setPoolId(uint256 _value) internal {
334     setUint256(_POOLID_SLOT, _value);
335   }
336 
337   function poolId() public view returns (uint256) {
338     return getUint256(_POOLID_SLOT);
339   }
340 
341   function isLpAsset() public view returns (bool) {
342     return getBoolean(_IS_LP_ASSET_SLOT);
343   }
344 
345   function finalizeUpgrade() external onlyGovernance {
346     _finalizeUpgrade();
347     // reset the liquidation paths
348     // they need to be re-set manually
349     if (isLpAsset()) {
350       pancakeswapRoutes[IPancakePair(underlying()).token0()] = new address[](0);
351       pancakeswapRoutes[IPancakePair(underlying()).token1()] = new address[](0);
352     } else {
353       pancakeswapRoutes[underlying()] = new address[](0);
354     }
355   }
356 }
