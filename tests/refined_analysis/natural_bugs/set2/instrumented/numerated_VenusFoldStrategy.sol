1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
6 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
7 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
8 import "./VenusInteractorInitializable.sol";
9 import "../interface/IVault.sol";
10 import "../upgradability/BaseUpgradeableStrategy.sol";
11 
12 import "../interface/pancakeswap/IPancakeRouter02.sol";
13 
14 contract VenusFoldStrategy is BaseUpgradeableStrategy, VenusInteractorInitializable {
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
30 
31   uint256 public suppliedInUnderlying;
32   uint256 public borrowedInUnderlying;
33   address[] public liquidationPath;
34 
35   event Liquidated(
36     uint256 amount
37   );
38 
39   constructor() public BaseUpgradeableStrategy() {
40     assert(_COLLATERALFACTORNUMERATOR_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.collateralFactorNumerator")) - 1));
41     assert(_COLLATERALFACTORDENOMINATOR_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.collateralFactorDenominator")) - 1));
42     assert(_FOLDS_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.folds")) - 1));
43   }
44 
45   function initializeStrategy(
46     address _storage,
47     address _underlying,
48     address _vtoken,
49     address _vault,
50     address _comptroller,
51     address _xvs,
52     uint256 _collateralFactorNumerator,
53     uint256 _collateralFactorDenominator,
54     uint256 _folds
55   )
56   public initializer {
57     BaseUpgradeableStrategy.initialize(
58       _storage,
59       _underlying,
60       _vault,
61       _comptroller,
62       _xvs,
63       80, // profit sharing numerator
64       1000, // profit sharing denominator
65       true, // sell
66       1e16, // sell floor
67       12 hours // implementation change delay
68     );
69 
70     VenusInteractorInitializable.initialize(_underlying, _vtoken, _comptroller);
71 
72     require(IVault(_vault).underlying() == _underlying, "vault does not support underlying");
73     _setCollateralFactorDenominator(_collateralFactorDenominator);
74     _setCollateralFactorNumerator(_collateralFactorNumerator);
75     _setFolds(_folds);
76   }
77 
78   modifier updateSupplyInTheEnd() {
79     _;
80     suppliedInUnderlying = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
81     borrowedInUnderlying = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
82   }
83 
84   function depositArbCheck() public pure returns (bool) {
85     // there's no arb here.
86     return true;
87   }
88 
89   function unsalvagableTokens(address token) public view returns (bool) {
90     return (token == rewardToken() || token == underlying() || token == vToken());
91   }
92 
93   /**
94   * The strategy invests by supplying the underlying as a collateral.
95   */
96   function investAllUnderlying() public restricted updateSupplyInTheEnd {
97     uint256 balance = IBEP20(underlying()).balanceOf(address(this));
98     // Check before supplying
99     uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
100     uint256 borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
101     if (balance > 0) {
102       _supply(balance);
103     }
104     if (supplied.mul(collateralFactorNumerator()) > borrowed.mul(collateralFactorDenominator()) || supplied == 0) {
105       for (uint256 i = 0; i < folds(); i++) {
106         uint256 borrowAmount = balance.mul(collateralFactorNumerator()).div(collateralFactorDenominator());
107         _borrow(borrowAmount);
108         balance = IBEP20(underlying()).balanceOf(address(this));
109         if (balance > 0) {
110           _supply(balance);
111         }
112       }
113     }
114   }
115 
116   /**
117   * Exits Venus and transfers everything to the vault.
118   */
119   function withdrawAllToVault() external restricted updateSupplyInTheEnd {
120     if (allowEmergencyLiquidityShortage) {
121       withdrawMaximum();
122     } else {
123       withdrawAllWeInvested();
124     }
125     if (IBEP20(underlying()).balanceOf(address(this)) > 0) {
126       IBEP20(underlying()).safeTransfer(vault(), IBEP20(underlying()).balanceOf(address(this)));
127     }
128   }
129 
130   function emergencyExit() external onlyGovernance updateSupplyInTheEnd {
131     withdrawMaximum();
132   }
133 
134   function withdrawMaximum() internal updateSupplyInTheEnd {
135     if (sell()) {
136       liquidateVenus();
137     } else {
138       emit ProfitNotClaimed();
139     }
140     redeemMaximum();
141   }
142 
143   function withdrawAllWeInvested() internal updateSupplyInTheEnd {
144     if (sell()) {
145       liquidateVenus();
146     } else {
147       emit ProfitNotClaimed();
148     }
149     uint256 _currentSuppliedBalance = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
150     uint256 _currentBorrowedBalance = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
151 
152     mustRedeemPartial(_currentSuppliedBalance.sub(_currentBorrowedBalance));
153   }
154 
155   function withdrawToVault(uint256 amountUnderlying) external restricted updateSupplyInTheEnd {
156     if (amountUnderlying <= IBEP20(underlying()).balanceOf(address(this))) {
157       IBEP20(underlying()).safeTransfer(vault(), amountUnderlying);
158       return;
159     }
160 
161     // get some of the underlying
162     mustRedeemPartial(amountUnderlying);
163 
164     // transfer the amount requested (or the amount we have) back to vault()
165     IBEP20(underlying()).safeTransfer(vault(), amountUnderlying);
166 
167     // invest back to Venus
168     investAllUnderlying();
169   }
170 
171   /**
172   * Withdraws all assets, liquidates XVS, and invests again in the required ratio.
173   */
174   function doHardWork() public restricted {
175     if (sell()) {
176       liquidateVenus();
177     } else {
178       emit ProfitNotClaimed();
179     }
180     investAllUnderlying();
181   }
182 
183   /**
184   * Redeems maximum that can be redeemed from Venus.
185   * Redeem the minimum of the underlying we own, and the underlying that the vToken can
186   * immediately retrieve. Ensures that `redeemMaximum` doesn't fail silently.
187   *
188   * DOES NOT ensure that the strategy vUnderlying balance becomes 0.
189   */
190   function redeemMaximum() internal {
191     redeemMaximumWithLoan(
192       collateralFactorNumerator(),
193       collateralFactorDenominator(),
194       borrowMinThreshold
195     );
196   }
197 
198   /**
199   * Redeems `amountUnderlying` or fails.
200   */
201   function mustRedeemPartial(uint256 amountUnderlying) internal {
202     require(
203       CompleteVToken(vToken()).getCash() >= amountUnderlying,
204       "market cash cannot cover liquidity"
205     );
206     redeemMaximum();
207     require(IBEP20(underlying()).balanceOf(address(this)) >= amountUnderlying, "Unable to withdraw the entire amountUnderlying");
208   }
209 
210   /**
211   * Salvages a token.
212   */
213   function salvage(address recipient, address token, uint256 amount) public onlyGovernance {
214     // To make sure that governance cannot come in and take away the coins
215     require(!unsalvagableTokens(token), "token is defined as not salvagable");
216     IBEP20(token).safeTransfer(recipient, amount);
217   }
218 
219   function liquidateVenus() internal {
220     // Calculating rewardBalance is needed for the case underlying = reward token
221     uint256 balance = IBEP20(rewardToken()).balanceOf(address(this));
222     claimVenus();
223     uint256 balanceAfter = IBEP20(rewardToken()).balanceOf(address(this));
224     uint256 rewardBalance = balanceAfter.sub(balance);
225 
226     if (rewardBalance < sellFloor() || rewardBalance == 0) {
227       emit TooLowBalance();
228       return;
229     }
230 
231     // give a profit share to fee forwarder, which re-distributes this to
232     // the profit sharing pools
233     notifyProfitInRewardToken(rewardBalance);
234 
235     balance = IBEP20(rewardToken()).balanceOf(address(this));
236 
237     emit Liquidated(balance);
238 
239     // no liquidation needed when underlying is reward token
240     if (underlying() == rewardToken()) {
241       return;
242     }
243 
244     // we can accept 1 as minimum as this will be called by trusted roles only
245     uint256 amountOutMin = 1;
246     IBEP20(rewardToken()).safeApprove(address(pancakeswapRouterV2), 0);
247     IBEP20(rewardToken()).safeApprove(address(pancakeswapRouterV2), balance);
248 
249     IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
250       balance,
251       amountOutMin,
252       liquidationPath,
253       address(this),
254       block.timestamp
255     );
256   }
257 
258   /**
259   * Returns the current balance. Ignores XVS that was not liquidated and invested.
260   */
261   function investedUnderlyingBalance() public view returns (uint256) {
262     // underlying in this strategy + underlying redeemable from Venus + loan
263     return IBEP20(underlying()).balanceOf(address(this))
264     .add(suppliedInUnderlying)
265     .sub(borrowedInUnderlying);
266   }
267 
268   function setAllowLiquidityShortage(bool allowed) external restricted {
269     allowEmergencyLiquidityShortage = allowed;
270   }
271 
272   function setBorrowMinThreshold(uint256 threshold) public onlyGovernance {
273     borrowMinThreshold = threshold;
274   }
275 
276   // updating collateral factor
277   // note 1: one should settle the loan first before calling this
278   // note 2: collateralFactorDenominator is 1000, therefore, for 20%, you need 200
279   function _setCollateralFactorNumerator(uint256 _numerator) internal {
280     require(_numerator < uint(600).mul(collateralFactorDenominator()).div(1000), "Collateral factor cannot be this high");
281     setUint256(_COLLATERALFACTORNUMERATOR_SLOT, _numerator);
282   }
283 
284   function collateralFactorNumerator() public view returns (uint256) {
285     return getUint256(_COLLATERALFACTORNUMERATOR_SLOT);
286   }
287 
288   function _setCollateralFactorDenominator(uint256 _denominator) internal {
289     setUint256(_COLLATERALFACTORDENOMINATOR_SLOT, _denominator);
290   }
291 
292   function collateralFactorDenominator() public view returns (uint256) {
293     return getUint256(_COLLATERALFACTORDENOMINATOR_SLOT);
294   }
295 
296   function _setFolds(uint256 _folds) public onlyGovernance {
297     setUint256(_FOLDS_SLOT, _folds);
298   }
299 
300   function folds() public view returns (uint256) {
301     return getUint256(_FOLDS_SLOT);
302   }
303 
304   function setSellFloor(uint256 floor) public onlyGovernance {
305     _setSellFloor(floor);
306   }
307 
308   function setSell(bool s) public onlyGovernance {
309     _setSell(s);
310   }
311 
312   function finalizeUpgrade() external onlyGovernance updateSupplyInTheEnd {
313     _finalizeUpgrade();
314   }
315 }
