1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
6 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
7 
8 import "@openzeppelin/contracts-upgradeable/math/MathUpgradeable.sol";
9 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
10 
11 import "./VenusInteractorInitializableV2.sol";
12 import "../upgradability/BaseUpgradeableStrategy.sol";
13 import "../interface/IVault.sol";
14 import "../interface/pancakeswap/IPancakeRouter02.sol";
15 
16 contract VenusWBNBFoldStrategyV2 is BaseUpgradeableStrategy, VenusInteractorInitializableV2 {
17 
18   using SafeMath for uint256;
19   using SafeBEP20 for IBEP20;
20 
21   event ProfitNotClaimed();
22   event TooLowBalance();
23 
24   address constant public pancakeswapRouterV2 = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);
25   bool public allowEmergencyLiquidityShortage = false;
26   uint256 public borrowMinThreshold = 0;
27 
28   // additional storage slots (on top of BaseUpgradeableStrategy ones) are defined here
29   bytes32 internal constant _COLLATERALFACTORNUMERATOR_SLOT = 0x129eccdfbcf3761d8e2f66393221fa8277b7623ad13ed7693a0025435931c64a;
30   bytes32 internal constant _COLLATERALFACTORDENOMINATOR_SLOT = 0x606ec222bff56fc4394b829203993803e413c3116299fce7ba56d1e18ce68869;
31   bytes32 internal constant _FOLDS_SLOT = 0xa62de150ef612c15565245b7898c849ef17c729d612c5cc6670d42dca253681b;
32   bytes32 internal constant _ALLOWED_FEE_NUMERATOR_SLOT = 0x4b6c6fa4369b03464dd976a7e6a631fb74f9eb091c5e8306254025c2e07dc416;
33 
34   uint256 public suppliedInUnderlying;
35   uint256 public borrowedInUnderlying;
36   address[] public liquidationPath;
37 
38   event Liquidated(
39     uint256 amount
40   );
41 
42   constructor() public BaseUpgradeableStrategy() {
43     assert(_ALLOWED_FEE_NUMERATOR_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.allowedFeeNumerator")) - 1));
44   }
45 
46   function initializeStrategy(
47     address _storage,
48     address _underlying,
49     address _vtoken,
50     address _vault,
51     address _comptroller,
52     address _xvs,
53     uint256 _collateralFactorNumerator,
54     uint256 _collateralFactorDenominator,
55     uint256 _folds
56   )
57   public initializer {
58     BaseUpgradeableStrategy.initialize(
59       _storage,
60       _underlying,
61       _vault,
62       _comptroller,
63       _xvs,
64       80, // profit sharing numerator
65       1000, // profit sharing denominator
66       true, // sell
67       1e16, // sell floor
68       12 hours // implementation change delay
69     );
70 
71     VenusInteractorInitializableV2.initialize(_underlying, _vtoken, _comptroller);
72 
73     require(IVault(_vault).underlying() == _underlying, "vault does not support underlying");
74     _setCollateralFactorDenominator(_collateralFactorDenominator);
75     _setCollateralFactorNumerator(_collateralFactorNumerator);
76     _setFolds(_folds);
77     _setAllowedFeeNumerator(9999);
78   }
79 
80   modifier updateSupplyInTheEnd() {
81     _;
82     suppliedInUnderlying = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
83     borrowedInUnderlying = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
84   }
85 
86   function depositArbCheck() public pure returns (bool) {
87     // there's no arb here.
88     return true;
89   }
90 
91   function unsalvagableTokens(address token) public view returns (bool) {
92     return (token == rewardToken() || token == underlying() || token == vToken());
93   }
94 
95   /**
96   * The strategy invests by supplying the underlying as a collateral.
97   */
98   function investAllUnderlying() public restricted updateSupplyInTheEnd {
99     uint256 balance = IBEP20(underlying()).balanceOf(address(this));
100     // Check before supplying
101     uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
102     uint256 borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
103     if (balance > 0) {
104       _supplyBNBInWBNB(balance);
105     }
106 
107     if (supplied.mul(collateralFactorNumerator()) > borrowed.mul(collateralFactorDenominator()) || supplied == 0) {
108       for (uint256 i = 0; i < folds(); i++) {
109         uint256 borrowAmount = balance.mul(collateralFactorNumerator()).div(collateralFactorDenominator());
110         _borrowInWBNB(borrowAmount);
111         balance = IBEP20(underlying()).balanceOf(address(this));
112         if (balance > 0) {
113           _supplyBNBInWBNB(balance);
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
139       claimVenus();
140       liquidateVenus();
141     } else {
142       emit ProfitNotClaimed();
143     }
144     redeemMaximum();
145   }
146 
147   function withdrawAllWeInvested() internal updateSupplyInTheEnd {
148     if (sell()) {
149       claimVenus();
150       liquidateVenus();
151     } else {
152       emit ProfitNotClaimed();
153     }
154     uint256 _currentSuppliedBalance = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
155     uint256 _currentBorrowedBalance = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
156 
157     mustRedeemPartial(_currentSuppliedBalance.sub(_currentBorrowedBalance));
158   }
159 
160   function withdrawToVault(uint256 amountUnderlying) external restricted updateSupplyInTheEnd {
161     uint256 balance = IBEP20(underlying()).balanceOf(address(this));
162     if (amountUnderlying <= IBEP20(underlying()).balanceOf(address(this))) {
163       IBEP20(underlying()).safeTransfer(vault(), amountUnderlying);
164       return;
165     }
166 
167     uint256 toRedeem = amountUnderlying.sub(balance);
168     // get some of the underlying
169     mustRedeemPartial(toRedeem);
170 
171     // transfer the amount requested (or the amount we have) back to vault
172     balance = IBEP20(underlying()).balanceOf(address(this));
173     IBEP20(underlying()).safeTransfer(vault(), MathUpgradeable.min(amountUnderlying, balance));
174 
175     balance = IBEP20(underlying()).balanceOf(address(this));
176     if (balance >0) {
177       // invest back to Venus
178       investAllUnderlying();
179     }
180   }
181 
182   /**
183   * Withdraws all assets, liquidates XVS, and invests again in the required ratio.
184   */
185   function doHardWork() public restricted {
186     if (sell()) {
187       claimVenus();
188       liquidateVenus();
189     } else {
190       emit ProfitNotClaimed();
191     }
192     investAllUnderlying();
193   }
194 
195   /**
196   * Redeems maximum that can be redeemed from Venus.
197   * Redeem the minimum of the underlying we own, and the underlying that the vToken can
198   * immediately retrieve. Ensures that `redeemMaximum` doesn't fail silently.
199   *
200   * DOES NOT ensure that the strategy cUnderlying balance becomes 0.
201   */
202   function redeemMaximum() internal {
203     if (folds() > 0) {
204       redeemMaximumWBNBWithLoan(
205         collateralFactorNumerator(),
206         collateralFactorDenominator(),
207         borrowMinThreshold
208       );
209     } else {
210       redeemMaximumWBNBNoFold();
211     }
212   }
213 
214   /**
215   * Redeems `amountUnderlying` or fails.
216   */
217 
218   function mustRedeemPartial(uint256 amountUnderlyingToRedeem) internal {
219     uint256 initialBalance = IBEP20(underlying()).balanceOf(address(this));
220     require(
221       CompleteVToken(vToken()).getCash() >= amountUnderlyingToRedeem,
222       "market cash cannot cover liquidity"
223     );
224     if (folds() > 0) {
225       redeemMaximum();
226     } else {
227       redeemUnderlyingInWBNB(amountUnderlyingToRedeem);
228     }
229     uint256 finalBalance = IBEP20(underlying()).balanceOf(address(this));
230     require(
231       finalBalance.sub(initialBalance) >= amountUnderlyingToRedeem.mul(allowedFeeNumerator()).div(10000),
232       "Unable to withdraw the entire amountUnderlyingToRedeem");
233   }
234 
235   /**
236   * Salvages a token.
237   */
238   function salvage(address recipient, address token, uint256 amount) public onlyGovernance {
239     // To make sure that governance cannot come in and take away the coins
240     require(!unsalvagableTokens(token), "token is defined as not salvagable");
241     IBEP20(token).safeTransfer(recipient, amount);
242   }
243 
244   function liquidateVenus() internal {
245     uint256 balance = IBEP20(rewardToken()).balanceOf(address(this));
246     if (balance < sellFloor() || balance == 0) {
247       emit TooLowBalance();
248       return;
249     }
250 
251     // give a profit share to fee forwarder, which re-distributes this to
252     // the profit sharing pools
253     notifyProfitInRewardToken(balance);
254 
255     balance = IBEP20(rewardToken()).balanceOf(address(this));
256 
257     emit Liquidated(balance);
258     // we can accept 1 as minimum as this will be called by trusted roles only
259     uint256 amountOutMin = 1;
260     IBEP20(rewardToken()).safeApprove(address(pancakeswapRouterV2), 0);
261     IBEP20(rewardToken()).safeApprove(address(pancakeswapRouterV2), balance);
262 
263     IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
264       balance,
265       amountOutMin,
266       liquidationPath,
267       address(this),
268       block.timestamp
269     );
270   }
271 
272   /**
273   * Returns the current balance. Ignores XVS that was not liquidated and invested.
274   */
275   function investedUnderlyingBalance() public view returns (uint256) {
276     // underlying in this strategy + underlying redeemable from Venus + loan
277     return IBEP20(underlying()).balanceOf(address(this))
278     .add(suppliedInUnderlying)
279     .sub(borrowedInUnderlying);
280   }
281 
282   function setAllowLiquidityShortage(bool allowed) external restricted {
283     allowEmergencyLiquidityShortage = allowed;
284   }
285 
286   function setBorrowMinThreshold(uint256 threshold) public onlyGovernance {
287     borrowMinThreshold = threshold;
288   }
289 
290   // updating collateral factor
291   // note 1: one should settle the loan first before calling this
292   // note 2: collateralFactorDenominator is 1000, therefore, for 20%, you need 200
293   function _setCollateralFactorNumerator(uint256 _numerator) internal {
294     require(_numerator < uint(600).mul(collateralFactorDenominator()).div(1000), "Collateral factor cannot be this high");
295     setUint256(_COLLATERALFACTORNUMERATOR_SLOT, _numerator);
296   }
297 
298   function collateralFactorNumerator() public view returns (uint256) {
299     return getUint256(_COLLATERALFACTORNUMERATOR_SLOT);
300   }
301 
302   function _setCollateralFactorDenominator(uint256 _denominator) internal {
303     setUint256(_COLLATERALFACTORDENOMINATOR_SLOT, _denominator);
304   }
305 
306   function collateralFactorDenominator() public view returns (uint256) {
307     return getUint256(_COLLATERALFACTORDENOMINATOR_SLOT);
308   }
309 
310   function _setFolds(uint256 _folds) public onlyGovernance {
311     setUint256(_FOLDS_SLOT, _folds);
312   }
313 
314   function folds() public view returns (uint256) {
315     return getUint256(_FOLDS_SLOT);
316   }
317 
318   function allowedFeeNumerator() public view returns (uint256) {
319     return getUint256(_ALLOWED_FEE_NUMERATOR_SLOT);
320   }
321 
322   function setSellFloor(uint256 floor) public onlyGovernance {
323     _setSellFloor(floor);
324   }
325 
326   function _setAllowedFeeNumerator(uint256 numerator) public onlyGovernance {
327     setUint256(_ALLOWED_FEE_NUMERATOR_SLOT, numerator);
328   }
329 
330   function setSell(bool s) public onlyGovernance {
331     _setSell(s);
332   }
333 
334   function finalizeUpgrade() external onlyGovernance updateSupplyInTheEnd {
335     _finalizeUpgrade();
336   }
337 }
