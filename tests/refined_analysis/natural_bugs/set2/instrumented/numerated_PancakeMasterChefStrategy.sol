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
19 contract PancakeMasterChefStrategy is BaseUpgradeableStrategy {
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
57       1e18, // sell floor
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
93   function exitRewardPool(uint256 bal) internal {
94     if (underlying() == rewardToken()) {
95       IMasterChef(rewardPool()).leaveStaking(bal);
96     } else {
97       IMasterChef(rewardPool()).withdraw(poolId(), bal);
98     }
99   }
100 
101   function unsalvagableTokens(address token) public view returns (bool) {
102     return (token == rewardToken() || token == underlying());
103   }
104 
105   function enterRewardPool() updatePendingReward internal {
106     uint256 entireBalance = IBEP20(underlying()).balanceOf(address(this));
107     IBEP20(underlying()).safeApprove(rewardPool(), 0);
108     IBEP20(underlying()).safeApprove(rewardPool(), entireBalance);
109 
110     if (underlying() == rewardToken()) {
111       IMasterChef(rewardPool()).enterStaking(entireBalance);
112     } else {
113       IMasterChef(rewardPool()).deposit(poolId(), entireBalance);
114     }
115   }
116 
117   /*
118   *   In case there are some issues discovered about the pool or underlying asset
119   *   Governance can exit the pool properly
120   *   The function is only used for emergency to exit the pool
121   */
122   function emergencyExit() updatePendingReward public onlyGovernance {
123     uint256 bal = rewardPoolBalance();
124     exitRewardPool(bal);
125     _setPausedInvesting(true);
126   }
127 
128   /*
129   *   Resumes the ability to invest into the underlying reward pools
130   */
131   function continueInvesting() public onlyGovernance {
132     _setPausedInvesting(false);
133   }
134 
135   function setLiquidationPath(address _token, address [] memory _route) public onlyGovernance {
136     require(_route[0] == rewardToken(), "Path should start with rewardToken");
137     require(_route[_route.length-1] == _token, "Path should end with given Token");
138     pancakeswapRoutes[_token] = _route;
139   }
140 
141   function _claimReward() internal {
142     if (underlying() == rewardToken()) {
143       IMasterChef(rewardPool()).leaveStaking(0); // withdraw 0 so that we dont notify fees on basis
144     } else {
145       IMasterChef(rewardPool()).withdraw(poolId(), 0);
146     }
147   }
148 
149   // We assume that all the tradings can be done on Pancakeswap
150   function _liquidateReward(uint256 rewardBalance) internal {
151     if (!sell() || rewardBalance < sellFloor()) {
152       // Profits can be disabled for possible simplified and rapid exit
153       emit ProfitsNotCollected(sell(), rewardBalance < sellFloor());
154       return;
155     }
156 
157     notifyProfitInRewardToken(rewardBalance);
158     uint256 remainingRewardBalance = IBEP20(rewardToken()).balanceOf(address(this));
159 
160     if (remainingRewardBalance == 0) {
161       return;
162     }
163 
164     // allow Pancakeswap to sell our reward
165     IBEP20(rewardToken()).safeApprove(pancakeswapRouterV2, 0);
166     IBEP20(rewardToken()).safeApprove(pancakeswapRouterV2, remainingRewardBalance);
167 
168     // we can accept 1 as minimum because this is called only by a trusted role
169     uint256 amountOutMin = 1;
170 
171     if (isLpAsset()) {
172       address uniLPComponentToken0 = IPancakePair(underlying()).token0();
173       address uniLPComponentToken1 = IPancakePair(underlying()).token1();
174 
175       uint256 toToken0 = remainingRewardBalance.div(2);
176       uint256 toToken1 = remainingRewardBalance.sub(toToken0);
177 
178       uint256 token0Amount;
179 
180       if (pancakeswapRoutes[uniLPComponentToken0].length > 1) {
181         // if we need to liquidate the token0
182         IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
183           toToken0,
184           amountOutMin,
185           pancakeswapRoutes[uniLPComponentToken0],
186           address(this),
187           block.timestamp
188         );
189         token0Amount = IBEP20(uniLPComponentToken0).balanceOf(address(this));
190       } else {
191         // otherwise we assme token0 is the reward token itself
192         token0Amount = toToken0;
193       }
194 
195       uint256 token1Amount;
196 
197       if (pancakeswapRoutes[uniLPComponentToken1].length > 1) {
198         // sell reward token to token1
199         IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
200           toToken1,
201           amountOutMin,
202           pancakeswapRoutes[uniLPComponentToken1],
203           address(this),
204           block.timestamp
205         );
206         token1Amount = IBEP20(uniLPComponentToken1).balanceOf(address(this));
207       } else {
208         token1Amount = toToken1;
209       }
210 
211       // provide token1 and token2 to Pancake
212       IBEP20(uniLPComponentToken0).safeApprove(pancakeswapRouterV2, 0);
213       IBEP20(uniLPComponentToken0).safeApprove(pancakeswapRouterV2, token0Amount);
214 
215       IBEP20(uniLPComponentToken1).safeApprove(pancakeswapRouterV2, 0);
216       IBEP20(uniLPComponentToken1).safeApprove(pancakeswapRouterV2, token1Amount);
217 
218       // we provide liquidity to Pancake
219       uint256 liquidity;
220       (,,liquidity) = IPancakeRouter02(pancakeswapRouterV2).addLiquidity(
221         uniLPComponentToken0,
222         uniLPComponentToken1,
223         token0Amount,
224         token1Amount,
225         1,  // we are willing to take whatever the pair gives us
226         1,  // we are willing to take whatever the pair gives us
227         address(this),
228         block.timestamp
229       );
230     } else {
231       if (underlying() != rewardToken()) {
232         IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
233           remainingRewardBalance,
234           amountOutMin,
235           pancakeswapRoutes[underlying()],
236           address(this),
237           block.timestamp
238         );
239       }
240     }
241   }
242 
243   /*
244   *   Stakes everything the strategy holds into the reward pool
245   */
246   function investAllUnderlying() internal onlyNotPausedInvesting {
247     // this check is needed, because most of the SNX reward pools will revert if
248     // you try to stake(0).
249     if(IBEP20(underlying()).balanceOf(address(this)) > 0) {
250       enterRewardPool();
251     }
252   }
253 
254   /*
255   *   Withdraws all the asset to the vault
256   */
257   function withdrawAllToVault() updatePendingReward public restricted {
258     if (address(rewardPool()) != address(0)) {
259       uint256 bal = rewardPoolBalance();
260       exitRewardPool(bal);
261     }
262     if (underlying() != rewardToken()) {
263       uint256 rewardBalance = IBEP20(rewardToken()).balanceOf(address(this));
264       _liquidateReward(rewardBalance);
265     }
266     IBEP20(underlying()).safeTransfer(vault(), IBEP20(underlying()).balanceOf(address(this)));
267   }
268 
269   /*
270   *   Withdraws all the asset to the vault
271   */
272   function withdrawToVault(uint256 amount) updatePendingReward public restricted {
273     // Typically there wouldn't be any amount here
274     // however, it is possible because of the emergencyExit
275     uint256 entireBalance = IBEP20(underlying()).balanceOf(address(this));
276 
277     if(amount > entireBalance){
278       // While we have the check above, we still using SafeMath below
279       // for the peace of mind (in case something gets changed in between)
280       uint256 needToWithdraw = amount.sub(entireBalance);
281       uint256 toWithdraw = MathUpgradeable.min(rewardPoolBalance(), needToWithdraw);
282       exitRewardPool(toWithdraw);
283     }
284 
285     IBEP20(underlying()).safeTransfer(vault(), amount);
286   }
287 
288   /*
289   *   Note that we currently do not have a mechanism here to include the
290   *   amount of reward that is accrued.
291   */
292   function investedUnderlyingBalance() external view returns (uint256) {
293     if (rewardPool() == address(0)) {
294       return IBEP20(underlying()).balanceOf(address(this));
295     }
296     // Adding the amount locked in the reward pool and the amount that is somehow in this contract
297     // both are in the units of "underlying"
298     // The second part is needed because there is the emergency exit mechanism
299     // which would break the assumption that all the funds are always inside of the reward pool
300     return rewardPoolBalance().add(IBEP20(underlying()).balanceOf(address(this)));
301   }
302 
303   /*
304   *   Governance or Controller can claim coins that are somehow transferred into the contract
305   *   Note that they cannot come in take away coins that are used and defined in the strategy itself
306   */
307   function salvage(address recipient, address token, uint256 amount) external onlyControllerOrGovernance {
308      // To make sure that governance cannot come in and take away the coins
309     require(!unsalvagableTokens(token), "token is defined as not salvagable");
310     IBEP20(token).safeTransfer(recipient, amount);
311   }
312 
313   /*
314   *   Get the reward, sell it in exchange for underlying, invest what you got.
315   *   It's not much, but it's honest work.
316   *
317   *   Note that although `onlyNotPausedInvesting` is not added here,
318   *   calling `investAllUnderlying()` affectively blocks the usage of `doHardWork`
319   *   when the investing is being paused by governance.
320   */
321   function doHardWork() updatePendingReward external onlyNotPausedInvesting restricted {
322     uint256 bal = rewardPoolBalance();
323     if (bal != 0) {
324       uint256 rewardBalanceBefore = IBEP20(rewardToken()).balanceOf(address(this));
325       _claimReward();
326       uint256 rewardBalanceAfter = IBEP20(rewardToken()).balanceOf(address(this));
327       uint256 claimedReward = rewardBalanceAfter.sub(rewardBalanceBefore).add(pendingReward);
328       _liquidateReward(claimedReward);
329     }
330 
331     investAllUnderlying();
332   }
333 
334   /**
335   * Can completely disable claiming rewards and selling. Good for emergency withdraw in the
336   * simplest possible way.
337   */
338   function setSell(bool s) public onlyGovernance {
339     _setSell(s);
340   }
341 
342   /**
343   * Sets the minimum amount needed to trigger a sale.
344   */
345   function setSellFloor(uint256 floor) public onlyGovernance {
346     _setSellFloor(floor);
347   }
348 
349   // masterchef rewards pool ID
350   function _setPoolId(uint256 _value) internal {
351     setUint256(_POOLID_SLOT, _value);
352   }
353 
354   function poolId() public view returns (uint256) {
355     return getUint256(_POOLID_SLOT);
356   }
357 
358   function isLpAsset() public view returns (bool) {
359     return getBoolean(_IS_LP_ASSET_SLOT);
360   }
361 
362   function finalizeUpgrade() external onlyGovernance {
363     _finalizeUpgrade();
364     // reset the liquidation paths
365     // they need to be re-set manually
366     if (isLpAsset()) {
367       pancakeswapRoutes[IPancakePair(underlying()).token0()] = new address[](0);
368       pancakeswapRoutes[IPancakePair(underlying()).token1()] = new address[](0);
369     } else {
370       pancakeswapRoutes[underlying()] = new address[](0);
371     }
372   }
373 }
