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
11 import "./VenusInteractorInitializable.sol";
12 import "../upgradability/BaseUpgradeableStrategy.sol";
13 import "../interface/IVault.sol";
14 import "../interface/pancakeswap/IPancakeRouter02.sol";
15 
16 contract VenusWBNBFoldStrategy is BaseUpgradeableStrategy, VenusInteractorInitializable {
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
32 
33   uint256 public suppliedInUnderlying;
34   uint256 public borrowedInUnderlying;
35   address[] public liquidationPath;
36 
37   event Liquidated(
38     uint256 amount
39   );
40 
41   constructor() public BaseUpgradeableStrategy() {
42   }
43 
44   function initializeStrategy(
45     address _storage,
46     address _underlying,
47     address _vtoken,
48     address _vault,
49     address _comptroller,
50     address _xvs,
51     uint256 _collateralFactorNumerator,
52     uint256 _collateralFactorDenominator,
53     uint256 _folds
54   )
55   public initializer {
56     BaseUpgradeableStrategy.initialize(
57       _storage,
58       _underlying,
59       _vault,
60       _comptroller,
61       _xvs,
62       80, // profit sharing numerator
63       1000, // profit sharing denominator
64       true, // sell
65       1e16, // sell floor
66       12 hours // implementation change delay
67     );
68 
69     VenusInteractorInitializable.initialize(_underlying, _vtoken, _comptroller);
70 
71     require(IVault(_vault).underlying() == _underlying, "vault does not support underlying");
72     _setCollateralFactorDenominator(_collateralFactorDenominator);
73     _setCollateralFactorNumerator(_collateralFactorNumerator);
74     _setFolds(_folds);
75   }
76 
77   modifier updateSupplyInTheEnd() {
78     _;
79     suppliedInUnderlying = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
80     borrowedInUnderlying = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
81   }
82 
83   function depositArbCheck() public pure returns (bool) {
84     // there's no arb here.
85     return true;
86   }
87 
88   function unsalvagableTokens(address token) public view returns (bool) {
89     return (token == rewardToken() || token == underlying() || token == vToken());
90   }
91 
92   /**
93   * The strategy invests by supplying the underlying as a collateral.
94   */
95   function investAllUnderlying() public restricted updateSupplyInTheEnd {
96     uint256 balance = IBEP20(underlying()).balanceOf(address(this));
97     // Check before supplying
98     uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
99     uint256 borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
100     if (balance > 0) {
101       _supplyBNBInWBNB(balance);
102     }
103 
104     if (supplied.mul(collateralFactorNumerator()) > borrowed.mul(collateralFactorDenominator()) || supplied == 0) {
105       for (uint256 i = 0; i < folds(); i++) {
106         uint256 borrowAmount = balance.mul(collateralFactorNumerator()).div(collateralFactorDenominator());
107         _borrowInWBNB(borrowAmount);
108         balance = IBEP20(underlying()).balanceOf(address(this));
109         if (balance > 0) {
110           _supplyBNBInWBNB(balance);
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
136       claimVenus();
137       liquidateVenus();
138     } else {
139       emit ProfitNotClaimed();
140     }
141     redeemMaximum();
142   }
143 
144   function withdrawAllWeInvested() internal updateSupplyInTheEnd {
145     if (sell()) {
146       claimVenus();
147       liquidateVenus();
148     } else {
149       emit ProfitNotClaimed();
150     }
151     uint256 _currentSuppliedBalance = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
152     uint256 _currentBorrowedBalance = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
153 
154     mustRedeemPartial(_currentSuppliedBalance.sub(_currentBorrowedBalance));
155   }
156 
157   function withdrawToVault(uint256 amountUnderlying) external restricted updateSupplyInTheEnd {
158     if (amountUnderlying <= IBEP20(underlying()).balanceOf(address(this))) {
159       IBEP20(underlying()).safeTransfer(vault(), amountUnderlying);
160       return;
161     }
162 
163     // get some of the underlying
164     mustRedeemPartial(amountUnderlying);
165 
166     // transfer the amount requested (or the amount we have) back to vault
167     IBEP20(underlying()).safeTransfer(vault(), amountUnderlying);
168 
169     // invest back to compound
170     investAllUnderlying();
171   }
172 
173   /**
174   * Withdraws all assets, liquidates XVS, and invests again in the required ratio.
175   */
176   function doHardWork() public restricted {
177     if (sell()) {
178       claimVenus();
179       liquidateVenus();
180     } else {
181       emit ProfitNotClaimed();
182     }
183     investAllUnderlying();
184   }
185 
186   /**
187   * Redeems maximum that can be redeemed from Venus.
188   * Redeem the minimum of the underlying we own, and the underlying that the vToken can
189   * immediately retrieve. Ensures that `redeemMaximum` doesn't fail silently.
190   *
191   * DOES NOT ensure that the strategy cUnderlying balance becomes 0.
192   */
193   function redeemMaximum() internal {
194     redeemMaximumWBNBWithLoan(
195       collateralFactorNumerator(),
196       collateralFactorDenominator(),
197       borrowMinThreshold
198     );
199   }
200 
201   /**
202   * Redeems `amountUnderlying` or fails.
203   */
204   function mustRedeemPartial(uint256 amountUnderlying) internal {
205     require(
206       CompleteVToken(vToken()).getCash() >= amountUnderlying,
207       "market cash cannot cover liquidity"
208     );
209     redeemMaximum();
210     require(IBEP20(underlying()).balanceOf(address(this)) >= amountUnderlying, "Unable to withdraw the entire amountUnderlying");
211   }
212 
213   /**
214   * Salvages a token.
215   */
216   function salvage(address recipient, address token, uint256 amount) public onlyGovernance {
217     // To make sure that governance cannot come in and take away the coins
218     require(!unsalvagableTokens(token), "token is defined as not salvagable");
219     IBEP20(token).safeTransfer(recipient, amount);
220   }
221 
222   function liquidateVenus() internal {
223     uint256 balance = IBEP20(rewardToken()).balanceOf(address(this));
224     if (balance < sellFloor() || balance == 0) {
225       emit TooLowBalance();
226       return;
227     }
228 
229     // give a profit share to fee forwarder, which re-distributes this to
230     // the profit sharing pools
231     notifyProfitInRewardToken(balance);
232 
233     balance = IBEP20(rewardToken()).balanceOf(address(this));
234 
235     emit Liquidated(balance);
236     // we can accept 1 as minimum as this will be called by trusted roles only
237     uint256 amountOutMin = 1;
238     IBEP20(rewardToken()).safeApprove(address(pancakeswapRouterV2), 0);
239     IBEP20(rewardToken()).safeApprove(address(pancakeswapRouterV2), balance);
240 
241     IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
242       balance,
243       amountOutMin,
244       liquidationPath,
245       address(this),
246       block.timestamp
247     );
248   }
249 
250   /**
251   * Returns the current balance. Ignores XVS that was not liquidated and invested.
252   */
253   function investedUnderlyingBalance() public view returns (uint256) {
254     // underlying in this strategy + underlying redeemable from Venus + loan
255     return IBEP20(underlying()).balanceOf(address(this))
256     .add(suppliedInUnderlying)
257     .sub(borrowedInUnderlying);
258   }
259 
260   function setAllowLiquidityShortage(bool allowed) external restricted {
261     allowEmergencyLiquidityShortage = allowed;
262   }
263 
264   function setBorrowMinThreshold(uint256 threshold) public onlyGovernance {
265     borrowMinThreshold = threshold;
266   }
267 
268   // updating collateral factor
269   // note 1: one should settle the loan first before calling this
270   // note 2: collateralFactorDenominator is 1000, therefore, for 20%, you need 200
271   function _setCollateralFactorNumerator(uint256 _numerator) internal {
272     require(_numerator < uint(600).mul(collateralFactorDenominator()).div(1000), "Collateral factor cannot be this high");
273     setUint256(_COLLATERALFACTORNUMERATOR_SLOT, _numerator);
274   }
275 
276   function collateralFactorNumerator() public view returns (uint256) {
277     return getUint256(_COLLATERALFACTORNUMERATOR_SLOT);
278   }
279 
280   function _setCollateralFactorDenominator(uint256 _denominator) internal {
281     setUint256(_COLLATERALFACTORDENOMINATOR_SLOT, _denominator);
282   }
283 
284   function collateralFactorDenominator() public view returns (uint256) {
285     return getUint256(_COLLATERALFACTORDENOMINATOR_SLOT);
286   }
287 
288   function _setFolds(uint256 _folds) public onlyGovernance {
289     setUint256(_FOLDS_SLOT, _folds);
290   }
291 
292   function folds() public view returns (uint256) {
293     return getUint256(_FOLDS_SLOT);
294   }
295 
296   function setSellFloor(uint256 floor) public onlyGovernance {
297     _setSellFloor(floor);
298   }
299 
300   function setSell(bool s) public onlyGovernance {
301     _setSell(s);
302   }
303 
304   function finalizeUpgrade() external onlyGovernance updateSupplyInTheEnd {
305     _finalizeUpgrade();
306   }
307 }
