1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0;
4 
5 import "./interface/IMasterChef.sol";
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
19 contract GeneralMasterChefStrategyNewRouter is BaseUpgradeableStrategy {
20   using SafeMath for uint256;
21   using SafeBEP20 for IBEP20;
22 
23   address constant public pancakeswapRouterV2 = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);
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
62     (_lpt,,,) = IMasterChef(rewardPool()).poolInfo(_poolID);
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
90       (bal,) = IMasterChef(rewardPool()).userInfo(poolId(), address(this));
91   }
92 
93   function unsalvagableTokens(address token) public view returns (bool) {
94     return (token == rewardToken() || token == underlying());
95   }
96 
97   function enterRewardPool() updatePendingReward internal {
98     uint256 entireBalance = IBEP20(underlying()).balanceOf(address(this));
99     IBEP20(underlying()).safeApprove(rewardPool(), 0);
100     IBEP20(underlying()).safeApprove(rewardPool(), entireBalance);
101 
102     IMasterChef(rewardPool()).deposit(poolId(), entireBalance);
103   }
104 
105   /*
106   *   In case there are some issues discovered about the pool or underlying asset
107   *   Governance can exit the pool properly
108   *   The function is only used for emergency to exit the pool
109   */
110   function emergencyExit() updatePendingReward public onlyGovernance {
111     uint256 bal = rewardPoolBalance();
112     IMasterChef(rewardPool()).withdraw(poolId(), bal);
113     _setPausedInvesting(true);
114   }
115 
116   /*
117   *   Resumes the ability to invest into the underlying reward pools
118   */
119   function continueInvesting() public onlyGovernance {
120     _setPausedInvesting(false);
121   }
122 
123   function setLiquidationPath(address _token, address [] memory _route) public onlyGovernance {
124     require(_route[0] == rewardToken(), "Path should start with rewardToken");
125     require(_route[_route.length-1] == _token, "Path should end with given Token");
126     pancakeswapRoutes[_token] = _route;
127   }
128 
129   // We assume that all the tradings can be done on Pancakeswap
130   function _liquidateReward(uint256 rewardBalance) internal {
131     if (!sell() || rewardBalance < sellFloor()) {
132       // Profits can be disabled for possible simplified and rapid exit
133       emit ProfitsNotCollected(sell(), rewardBalance < sellFloor());
134       return;
135     }
136 
137     notifyProfitInRewardToken(rewardBalance);
138     uint256 remainingRewardBalance = IBEP20(rewardToken()).balanceOf(address(this));
139 
140     if (remainingRewardBalance == 0) {
141       return;
142     }
143 
144     // allow Pancakeswap to sell our reward
145     IBEP20(rewardToken()).safeApprove(pancakeswapRouterV2, 0);
146     IBEP20(rewardToken()).safeApprove(pancakeswapRouterV2, remainingRewardBalance);
147 
148     // we can accept 1 as minimum because this is called only by a trusted role
149     uint256 amountOutMin = 1;
150 
151     if (isLpAsset()) {
152       address uniLPComponentToken0 = IPancakePair(underlying()).token0();
153       address uniLPComponentToken1 = IPancakePair(underlying()).token1();
154 
155       uint256 toToken0 = remainingRewardBalance.div(2);
156       uint256 toToken1 = remainingRewardBalance.sub(toToken0);
157 
158       uint256 token0Amount;
159 
160       if (pancakeswapRoutes[uniLPComponentToken0].length > 1) {
161         // if we need to liquidate the token0
162         IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
163           toToken0,
164           amountOutMin,
165           pancakeswapRoutes[uniLPComponentToken0],
166           address(this),
167           block.timestamp
168         );
169         token0Amount = IBEP20(uniLPComponentToken0).balanceOf(address(this));
170       } else {
171         // otherwise we assme token0 is the reward token itself
172         token0Amount = toToken0;
173       }
174 
175       uint256 token1Amount;
176 
177       if (pancakeswapRoutes[uniLPComponentToken1].length > 1) {
178         // sell reward token to token1
179         IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
180           toToken1,
181           amountOutMin,
182           pancakeswapRoutes[uniLPComponentToken1],
183           address(this),
184           block.timestamp
185         );
186         token1Amount = IBEP20(uniLPComponentToken1).balanceOf(address(this));
187       } else {
188         token1Amount = toToken1;
189       }
190 
191       // provide token0 and token1 to Pancake
192       IBEP20(uniLPComponentToken0).safeApprove(pancakeswapRouterV2, 0);
193       IBEP20(uniLPComponentToken0).safeApprove(pancakeswapRouterV2, token0Amount);
194 
195       IBEP20(uniLPComponentToken1).safeApprove(pancakeswapRouterV2, 0);
196       IBEP20(uniLPComponentToken1).safeApprove(pancakeswapRouterV2, token1Amount);
197 
198       // we provide liquidity to Pancake
199       uint256 liquidity;
200       (,,liquidity) = IPancakeRouter02(pancakeswapRouterV2).addLiquidity(
201         uniLPComponentToken0,
202         uniLPComponentToken1,
203         token0Amount,
204         token1Amount,
205         1,  // we are willing to take whatever the pair gives us
206         1,  // we are willing to take whatever the pair gives us
207         address(this),
208         block.timestamp
209       );
210     } else {
211       if (underlying() != rewardToken()) {
212         IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
213           remainingRewardBalance,
214           amountOutMin,
215           pancakeswapRoutes[underlying()],
216           address(this),
217           block.timestamp
218         );
219       }
220     }
221   }
222 
223   /*
224   *   Stakes everything the strategy holds into the reward pool
225   */
226   function investAllUnderlying() internal onlyNotPausedInvesting {
227     // this check is needed, because most of the SNX reward pools will revert if
228     // you try to stake(0).
229     if(IBEP20(underlying()).balanceOf(address(this)) > 0) {
230       enterRewardPool();
231     }
232   }
233 
234   /*
235   *   Withdraws all the asset to the vault
236   */
237   function withdrawAllToVault() updatePendingReward public restricted {
238     if (address(rewardPool()) != address(0)) {
239       uint256 bal = rewardPoolBalance();
240       if (bal != 0) {
241         IMasterChef(rewardPool()).withdraw(poolId(), bal);
242       }
243     }
244     if (underlying() != rewardToken()) {
245       uint256 rewardBalance = IBEP20(rewardToken()).balanceOf(address(this));
246       _liquidateReward(rewardBalance);
247     }
248     IBEP20(underlying()).safeTransfer(vault(), IBEP20(underlying()).balanceOf(address(this)));
249   }
250 
251   /*
252   *   Withdraws all the asset to the vault
253   */
254   function withdrawToVault(uint256 amount) updatePendingReward public restricted {
255     // Typically there wouldn't be any amount here
256     // however, it is possible because of the emergencyExit
257     uint256 entireBalance = IBEP20(underlying()).balanceOf(address(this));
258 
259     if(amount > entireBalance){
260       // While we have the check above, we still using SafeMath below
261       // for the peace of mind (in case something gets changed in between)
262       uint256 needToWithdraw = amount.sub(entireBalance);
263       uint256 toWithdraw = MathUpgradeable.min(rewardPoolBalance(), needToWithdraw);
264       IMasterChef(rewardPool()).withdraw(poolId(), toWithdraw);
265     }
266 
267     IBEP20(underlying()).safeTransfer(vault(), amount);
268   }
269 
270   /*
271   *   Note that we currently do not have a mechanism here to include the
272   *   amount of reward that is accrued.
273   */
274   function investedUnderlyingBalance() external view returns (uint256) {
275     if (rewardPool() == address(0)) {
276       return IBEP20(underlying()).balanceOf(address(this));
277     }
278     // Adding the amount locked in the reward pool and the amount that is somehow in this contract
279     // both are in the units of "underlying"
280     // The second part is needed because there is the emergency exit mechanism
281     // which would break the assumption that all the funds are always inside of the reward pool
282     return rewardPoolBalance().add(IBEP20(underlying()).balanceOf(address(this)));
283   }
284 
285   /*
286   *   Governance or Controller can claim coins that are somehow transferred into the contract
287   *   Note that they cannot come in take away coins that are used and defined in the strategy itself
288   */
289   function salvage(address recipient, address token, uint256 amount) external onlyControllerOrGovernance {
290      // To make sure that governance cannot come in and take away the coins
291     require(!unsalvagableTokens(token), "token is defined as not salvagable");
292     IBEP20(token).safeTransfer(recipient, amount);
293   }
294 
295   /*
296   *   Get the reward, sell it in exchange for underlying, invest what you got.
297   *   It's not much, but it's honest work.
298   *
299   *   Note that although `onlyNotPausedInvesting` is not added here,
300   *   calling `investAllUnderlying()` affectively blocks the usage of `doHardWork`
301   *   when the investing is being paused by governance.
302   */
303   function doHardWork() updatePendingReward external onlyNotPausedInvesting restricted {
304     uint256 bal = rewardPoolBalance();
305     if (bal != 0) {
306       uint256 rewardBalanceBefore = IBEP20(rewardToken()).balanceOf(address(this));
307       IMasterChef(rewardPool()).withdraw(poolId(), 0);
308       uint256 rewardBalanceAfter = IBEP20(rewardToken()).balanceOf(address(this));
309       uint256 claimedReward = rewardBalanceAfter.sub(rewardBalanceBefore).add(pendingReward);
310       _liquidateReward(claimedReward);
311     }
312 
313     investAllUnderlying();
314   }
315 
316   /**
317   * Can completely disable claiming rewards and selling. Good for emergency withdraw in the
318   * simplest possible way.
319   */
320   function setSell(bool s) public onlyGovernance {
321     _setSell(s);
322   }
323 
324   /**
325   * Sets the minimum amount needed to trigger a sale.
326   */
327   function setSellFloor(uint256 floor) public onlyGovernance {
328     _setSellFloor(floor);
329   }
330 
331   // masterchef rewards pool ID
332   function _setPoolId(uint256 _value) internal {
333     setUint256(_POOLID_SLOT, _value);
334   }
335 
336   function poolId() public view returns (uint256) {
337     return getUint256(_POOLID_SLOT);
338   }
339 
340   function isLpAsset() public view returns (bool) {
341     return getBoolean(_IS_LP_ASSET_SLOT);
342   }
343 
344   function finalizeUpgrade() external onlyGovernance {
345     _finalizeUpgrade();
346     // reset the liquidation paths
347     // they need to be re-set manually
348     if (isLpAsset()) {
349       pancakeswapRoutes[IPancakePair(underlying()).token0()] = new address[](0);
350       pancakeswapRoutes[IPancakePair(underlying()).token1()] = new address[](0);
351     } else {
352       pancakeswapRoutes[underlying()] = new address[](0);
353     }
354   }
355 }
