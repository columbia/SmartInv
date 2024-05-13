1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
6 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
7 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
8 import "./VenusInteractorInitializableV2.sol";
9 import "../interface/IVault.sol";
10 import "../upgradability/BaseUpgradeableStrategy.sol";
11 
12 import "../interface/pancakeswap/IPancakeRouter02.sol";
13 
14 contract VenusFoldStrategyV2 is BaseUpgradeableStrategy, VenusInteractorInitializableV2 {
15 
16   using SafeMath for uint256;
17   using SafeBEP20 for IBEP20;
18 
19   event ProfitNotClaimed();
20   event TooLowBalance();
21 
22   address constant public pancakeswapRouterV2 = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);
23   bool public allowEmergencyLiquidityShortage = false;
24   uint256 public borrowMinThreshold = 0;
25 
26   // additional storage slots (on top of BaseUpgradeableStrategy ones) are defined here
27   bytes32 internal constant _COLLATERALFACTORNUMERATOR_SLOT = 0x129eccdfbcf3761d8e2f66393221fa8277b7623ad13ed7693a0025435931c64a;
28   bytes32 internal constant _COLLATERALFACTORDENOMINATOR_SLOT = 0x606ec222bff56fc4394b829203993803e413c3116299fce7ba56d1e18ce68869;
29   bytes32 internal constant _FOLDS_SLOT = 0xa62de150ef612c15565245b7898c849ef17c729d612c5cc6670d42dca253681b;
30   bytes32 internal constant _ALLOWED_FEE_NUMERATOR_SLOT = 0x4b6c6fa4369b03464dd976a7e6a631fb74f9eb091c5e8306254025c2e07dc416;
31 
32   uint256 public suppliedInUnderlying;
33   uint256 public borrowedInUnderlying;
34   address[] public liquidationPath;
35 
36   event Liquidated(
37     uint256 amount
38   );
39 
40   constructor() public BaseUpgradeableStrategy() {
41     assert(_COLLATERALFACTORNUMERATOR_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.collateralFactorNumerator")) - 1));
42     assert(_COLLATERALFACTORDENOMINATOR_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.collateralFactorDenominator")) - 1));
43     assert(_FOLDS_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.folds")) - 1));
44     assert(_ALLOWED_FEE_NUMERATOR_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.allowedFeeNumerator")) - 1));
45   }
46 
47   function initializeStrategy(
48     address _storage,
49     address _underlying,
50     address _vtoken,
51     address _vault,
52     address _comptroller,
53     address _xvs,
54     uint256 _collateralFactorNumerator,
55     uint256 _collateralFactorDenominator,
56     uint256 _folds
57   )
58   public initializer {
59     BaseUpgradeableStrategy.initialize(
60       _storage,
61       _underlying,
62       _vault,
63       _comptroller,
64       _xvs,
65       80, // profit sharing numerator
66       1000, // profit sharing denominator
67       true, // sell
68       1e16, // sell floor
69       12 hours // implementation change delay
70     );
71 
72     VenusInteractorInitializableV2.initialize(_underlying, _vtoken, _comptroller);
73 
74     require(IVault(_vault).underlying() == _underlying, "vault does not support underlying");
75     _setCollateralFactorDenominator(_collateralFactorDenominator);
76     _setCollateralFactorNumerator(_collateralFactorNumerator);
77     _setFolds(_folds);
78     _setAllowedFeeNumerator(9999);
79   }
80 
81   modifier updateSupplyInTheEnd() {
82     _;
83     suppliedInUnderlying = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
84     borrowedInUnderlying = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
85   }
86 
87   function depositArbCheck() public pure returns (bool) {
88     // there's no arb here.
89     return true;
90   }
91 
92   function unsalvagableTokens(address token) public view returns (bool) {
93     return (token == rewardToken() || token == underlying() || token == vToken());
94   }
95 
96   /**
97   * The strategy invests by supplying the underlying as a collateral.
98   */
99   function investAllUnderlying() public restricted updateSupplyInTheEnd {
100     uint256 balance = IBEP20(underlying()).balanceOf(address(this));
101     // Check before supplying
102     uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
103     uint256 borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
104     if (balance > 0) {
105       _supply(balance);
106     }
107     if (supplied.mul(collateralFactorNumerator()) > borrowed.mul(collateralFactorDenominator()) || supplied == 0) {
108       for (uint256 i = 0; i < folds(); i++) {
109         uint256 borrowAmount = balance.mul(collateralFactorNumerator()).div(collateralFactorDenominator());
110         _borrow(borrowAmount);
111         balance = IBEP20(underlying()).balanceOf(address(this));
112         if (balance > 0) {
113           _supply(balance);
114         }
115       }
116     }
117   }
118 
119   /**
120   * Exits Venus and transfers everything to the vault.
121   */
122   function withdrawAllToVault() external restricted updateSupplyInTheEnd {
123     if (allowEmergencyLiquidityShortage) {
124       withdrawMaximum();
125     } else {
126       withdrawAllWeInvested();
127     }
128     if (IBEP20(underlying()).balanceOf(address(this)) > 0) {
129       IBEP20(underlying()).safeTransfer(vault(), IBEP20(underlying()).balanceOf(address(this)));
130     }
131   }
132 
133   function emergencyExit() external onlyGovernance updateSupplyInTheEnd {
134     withdrawMaximum();
135   }
136 
137   function withdrawMaximum() internal updateSupplyInTheEnd {
138     if (sell()) {
139       liquidateVenus();
140     } else {
141       emit ProfitNotClaimed();
142     }
143     redeemMaximum();
144   }
145 
146   function withdrawAllWeInvested() internal updateSupplyInTheEnd {
147     if (sell()) {
148       liquidateVenus();
149     } else {
150       emit ProfitNotClaimed();
151     }
152     uint256 _currentSuppliedBalance = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
153     uint256 _currentBorrowedBalance = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
154 
155     mustRedeemPartial(_currentSuppliedBalance.sub(_currentBorrowedBalance));
156   }
157 
158   function withdrawToVault(uint256 amountUnderlying) external restricted updateSupplyInTheEnd {
159     uint256 balance = IBEP20(underlying()).balanceOf(address(this));
160     if (amountUnderlying <= balance) {
161       IBEP20(underlying()).safeTransfer(vault(), amountUnderlying);
162       return;
163     }
164 
165     uint256 toRedeem = amountUnderlying.sub(balance);
166     // get some of the underlying
167     mustRedeemPartial(toRedeem);
168 
169     // transfer the amount requested (or the amount we have) back to vault()
170     balance = IBEP20(underlying()).balanceOf(address(this));
171     IBEP20(underlying()).safeTransfer(vault(), MathUpgradeable.min(amountUnderlying, balance));
172 
173     balance = IBEP20(underlying()).balanceOf(address(this));
174     if (balance >0) {
175       // invest back to Venus
176       investAllUnderlying();
177     }
178   }
179 
180   /**
181   * Withdraws all assets, liquidates XVS, and invests again in the required ratio.
182   */
183   function doHardWork() public restricted {
184     if (sell()) {
185       liquidateVenus();
186     } else {
187       emit ProfitNotClaimed();
188     }
189     investAllUnderlying();
190   }
191 
192   /**
193   * Redeems maximum that can be redeemed from Venus.
194   * Redeem the minimum of the underlying we own, and the underlying that the vToken can
195   * immediately retrieve. Ensures that `redeemMaximum` doesn't fail silently.
196   *
197   * DOES NOT ensure that the strategy vUnderlying balance becomes 0.
198   */
199   function redeemMaximum() internal {
200     if (folds()>0) {
201       redeemMaximumWithLoan(
202         collateralFactorNumerator(),
203         collateralFactorDenominator(),
204         borrowMinThreshold
205       );
206     } else {
207       redeemMaximumNoFold();
208     }
209   }
210 
211   /**
212   * Redeems `amountUnderlying` or fails.
213   */
214   function mustRedeemPartial(uint256 amountUnderlyingToRedeem) internal {
215     uint256 initialBalance = IBEP20(underlying()).balanceOf(address(this));
216     require(
217       CompleteVToken(vToken()).getCash() >= amountUnderlyingToRedeem,
218       "market cash cannot cover liquidity"
219     );
220     if (folds() > 0) {
221       redeemMaximum();
222     } else {
223       _redeemUnderlying(amountUnderlyingToRedeem);
224     }
225     uint256 finalBalance = IBEP20(underlying()).balanceOf(address(this));
226     require(
227       finalBalance.sub(initialBalance) >= amountUnderlyingToRedeem.mul(allowedFeeNumerator()).div(10000),
228       "Unable to withdraw the entire amountUnderlyingToRedeem");
229   }
230 
231   /**
232   * Salvages a token.
233   */
234   function salvage(address recipient, address token, uint256 amount) public onlyGovernance {
235     // To make sure that governance cannot come in and take away the coins
236     require(!unsalvagableTokens(token), "token is defined as not salvagable");
237     IBEP20(token).safeTransfer(recipient, amount);
238   }
239 
240   function liquidateVenus() internal {
241     // Calculating rewardBalance is needed for the case underlying = reward token
242     uint256 balance = IBEP20(rewardToken()).balanceOf(address(this));
243     claimVenus();
244     uint256 balanceAfter = IBEP20(rewardToken()).balanceOf(address(this));
245     uint256 rewardBalance = balanceAfter.sub(balance);
246 
247     if (rewardBalance < sellFloor() || rewardBalance == 0) {
248       emit TooLowBalance();
249       return;
250     }
251 
252     // give a profit share to fee forwarder, which re-distributes this to
253     // the profit sharing pools
254     notifyProfitInRewardToken(rewardBalance);
255 
256     balance = IBEP20(rewardToken()).balanceOf(address(this));
257 
258     emit Liquidated(balance);
259 
260     // no liquidation needed when underlying is reward token
261     if (underlying() == rewardToken()) {
262       return;
263     }
264 
265     // we can accept 1 as minimum as this will be called by trusted roles only
266     uint256 amountOutMin = 1;
267     IBEP20(rewardToken()).safeApprove(address(pancakeswapRouterV2), 0);
268     IBEP20(rewardToken()).safeApprove(address(pancakeswapRouterV2), balance);
269 
270     IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
271       balance,
272       amountOutMin,
273       liquidationPath,
274       address(this),
275       block.timestamp
276     );
277   }
278 
279   /**
280   * Returns the current balance. Ignores XVS that was not liquidated and invested.
281   */
282   function investedUnderlyingBalance() public view returns (uint256) {
283     // underlying in this strategy + underlying redeemable from Venus + loan
284     return IBEP20(underlying()).balanceOf(address(this))
285     .add(suppliedInUnderlying)
286     .sub(borrowedInUnderlying);
287   }
288 
289   function setAllowLiquidityShortage(bool allowed) external restricted {
290     allowEmergencyLiquidityShortage = allowed;
291   }
292 
293   function setBorrowMinThreshold(uint256 threshold) public onlyGovernance {
294     borrowMinThreshold = threshold;
295   }
296 
297   // updating collateral factor
298   // note 1: one should settle the loan first before calling this
299   // note 2: collateralFactorDenominator is 1000, therefore, for 20%, you need 200
300   function _setCollateralFactorNumerator(uint256 _numerator) internal {
301     require(_numerator < uint(600).mul(collateralFactorDenominator()).div(1000), "Collateral factor cannot be this high");
302     setUint256(_COLLATERALFACTORNUMERATOR_SLOT, _numerator);
303   }
304 
305   function collateralFactorNumerator() public view returns (uint256) {
306     return getUint256(_COLLATERALFACTORNUMERATOR_SLOT);
307   }
308 
309   function _setCollateralFactorDenominator(uint256 _denominator) internal {
310     setUint256(_COLLATERALFACTORDENOMINATOR_SLOT, _denominator);
311   }
312 
313   function collateralFactorDenominator() public view returns (uint256) {
314     return getUint256(_COLLATERALFACTORDENOMINATOR_SLOT);
315   }
316 
317   function _setFolds(uint256 _folds) public onlyGovernance {
318     setUint256(_FOLDS_SLOT, _folds);
319   }
320 
321   function folds() public view returns (uint256) {
322     return getUint256(_FOLDS_SLOT);
323   }
324 
325   function allowedFeeNumerator() public view returns (uint256) {
326     return getUint256(_ALLOWED_FEE_NUMERATOR_SLOT);
327   }
328 
329   function setSellFloor(uint256 floor) public onlyGovernance {
330     _setSellFloor(floor);
331   }
332 
333   function _setAllowedFeeNumerator(uint256 numerator) public onlyGovernance {
334     setUint256(_ALLOWED_FEE_NUMERATOR_SLOT, numerator);
335   }
336 
337   function setSell(bool s) public onlyGovernance {
338     _setSell(s);
339   }
340 
341   function finalizeUpgrade() external onlyGovernance updateSupplyInTheEnd {
342     _finalizeUpgrade();
343   }
344 }
