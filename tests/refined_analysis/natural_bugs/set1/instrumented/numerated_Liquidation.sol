1 // SPDX-License-Identifier: BUSL-1.1
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 
7 
8 /// @notice Liquidate users who are in collateral violation to protect lenders
9 contract Liquidation is BaseLogic {
10     constructor(bytes32 moduleGitCommit_) BaseLogic(MODULEID__LIQUIDATION, moduleGitCommit_) {}
11 
12     // How much of a liquidation is credited to the underlying's reserves.
13     uint public constant UNDERLYING_RESERVES_FEE = 0.02 * 1e18;
14 
15     // Maximum discount that can be awarded under any conditions.
16     uint public constant MAXIMUM_DISCOUNT = 0.20 * 1e18;
17 
18     // How much faster the booster grows for a fully funded supplier. Partially-funded suppliers
19     // have this scaled proportional to their free-liquidity divided by the violator's liability.
20     uint public constant DISCOUNT_BOOSTER_SLOPE = 2 * 1e18;
21 
22     // How much booster discount can be awarded beyond the base discount.
23     uint public constant MAXIMUM_BOOSTER_DISCOUNT = 0.025 * 1e18;
24 
25     // Post-liquidation target health score that limits maximum liquidation sizes. Must be >= 1.
26     uint public constant TARGET_HEALTH = 1.25 * 1e18;
27 
28 
29     /// @notice Information about a prospective liquidation opportunity
30     struct LiquidationOpportunity {
31         uint repay;
32         uint yield;
33         uint healthScore;
34 
35         // Only populated if repay > 0:
36         uint baseDiscount;
37         uint discount;
38         uint conversionRate;
39     }
40 
41     struct LiquidationLocals {
42         address liquidator;
43         address violator;
44         address underlying;
45         address collateral;
46 
47         uint underlyingPrice;
48         uint collateralPrice;
49 
50         LiquidationOpportunity liqOpp;
51 
52         uint repayPreFees;
53     }
54 
55     function computeLiqOpp(LiquidationLocals memory liqLocs) private {
56         require(!isSubAccountOf(liqLocs.violator, liqLocs.liquidator), "e/liq/self-liquidation");
57         require(isEnteredInMarket(liqLocs.violator, liqLocs.underlying), "e/liq/violator-not-entered-underlying");
58         require(isEnteredInMarket(liqLocs.violator, liqLocs.collateral), "e/liq/violator-not-entered-collateral");
59 
60         liqLocs.underlyingPrice = getAssetPrice(liqLocs.underlying);
61         liqLocs.collateralPrice = getAssetPrice(liqLocs.collateral);
62 
63         LiquidationOpportunity memory liqOpp = liqLocs.liqOpp;
64 
65         AssetStorage storage underlyingAssetStorage = eTokenLookup[underlyingLookup[liqLocs.underlying].eTokenAddress];
66         AssetCache memory underlyingAssetCache = loadAssetCache(liqLocs.underlying, underlyingAssetStorage);
67 
68         AssetStorage storage collateralAssetStorage = eTokenLookup[underlyingLookup[liqLocs.collateral].eTokenAddress];
69         AssetCache memory collateralAssetCache = loadAssetCache(liqLocs.collateral, collateralAssetStorage);
70 
71         liqOpp.repay = liqOpp.yield = 0;
72 
73         (uint collateralValue, uint liabilityValue) = getAccountLiquidity(liqLocs.violator);
74 
75         if (liabilityValue == 0) {
76             liqOpp.healthScore = type(uint).max;
77             return; // no violation
78         }
79 
80         liqOpp.healthScore = collateralValue * 1e18 / liabilityValue;
81 
82         if (collateralValue >= liabilityValue) {
83             return; // no violation
84         }
85 
86         // At this point healthScore must be < 1 since collateral < liability
87 
88         // Compute discount
89 
90         {
91             uint baseDiscount = UNDERLYING_RESERVES_FEE + (1e18 - liqOpp.healthScore);
92 
93             uint discountBooster = computeDiscountBooster(liqLocs.liquidator, liabilityValue);
94 
95             uint discount = baseDiscount * discountBooster / 1e18;
96 
97             if (discount > (baseDiscount + MAXIMUM_BOOSTER_DISCOUNT)) discount = baseDiscount + MAXIMUM_BOOSTER_DISCOUNT;
98             if (discount > MAXIMUM_DISCOUNT) discount = MAXIMUM_DISCOUNT;
99 
100             liqOpp.baseDiscount = baseDiscount;
101             liqOpp.discount = discount;
102             liqOpp.conversionRate = liqLocs.underlyingPrice * 1e18 / liqLocs.collateralPrice * 1e18 / (1e18 - discount);
103         }
104 
105         // Determine amount to repay to bring user to target health
106 
107         if (liqLocs.underlying == liqLocs.collateral) {
108             liqOpp.repay = type(uint).max;
109         } else {
110             AssetConfig memory collateralConfig = resolveAssetConfig(liqLocs.collateral);
111             AssetConfig memory underlyingConfig = resolveAssetConfig(liqLocs.underlying);
112 
113             uint collateralFactor = collateralConfig.collateralFactor;
114             uint borrowFactor = underlyingConfig.borrowFactor;
115 
116             uint liabilityValueTarget = liabilityValue * TARGET_HEALTH / 1e18;
117 
118             // These factors are first converted into standard 1e18-scale fractions, then adjusted according to TARGET_HEALTH and the discount:
119             uint borrowAdj = borrowFactor != 0 ? TARGET_HEALTH * CONFIG_FACTOR_SCALE / borrowFactor : MAX_SANE_DEBT_AMOUNT;
120             uint collateralAdj = 1e18 * uint(collateralFactor) / CONFIG_FACTOR_SCALE * 1e18 / (1e18 - liqOpp.discount);
121 
122             if (borrowAdj <= collateralAdj) {
123                 liqOpp.repay = type(uint).max;
124             } else {
125                 // liabilityValueTarget >= liabilityValue > collateralValue
126                 uint maxRepayInReference = (liabilityValueTarget - collateralValue) * 1e18 / (borrowAdj - collateralAdj);
127                 liqOpp.repay = maxRepayInReference * 1e18 / liqLocs.underlyingPrice;
128             }
129         }
130 
131         // Limit repay to current owed
132         // This can happen when there are multiple borrows and liquidating this one won't bring the violator back to solvency
133 
134         {
135             uint currentOwed = getCurrentOwed(underlyingAssetStorage, underlyingAssetCache, liqLocs.violator);
136             if (liqOpp.repay > currentOwed) liqOpp.repay = currentOwed;
137         }
138 
139         // Limit yield to borrower's available collateral, and reduce repay if necessary
140         // This can happen when borrower has multiple collaterals and seizing all of this one won't bring the violator back to solvency
141 
142         liqOpp.yield = liqOpp.repay * liqOpp.conversionRate / 1e18;
143 
144         {
145             uint collateralBalance = balanceToUnderlyingAmount(collateralAssetCache, collateralAssetStorage.users[liqLocs.violator].balance);
146 
147             if (collateralBalance < liqOpp.yield) {
148                 liqOpp.repay = collateralBalance * 1e18 / liqOpp.conversionRate;
149                 liqOpp.yield = collateralBalance;
150             }
151         }
152 
153         // Adjust repay to account for reserves fee
154 
155         liqLocs.repayPreFees = liqOpp.repay;
156         liqOpp.repay = liqOpp.repay * (1e18 + UNDERLYING_RESERVES_FEE) / 1e18;
157     }
158 
159 
160     // Returns 1e18-scale fraction > 1 representing how much faster the booster grows for this liquidator
161 
162     function computeDiscountBooster(address liquidator, uint violatorLiabilityValue) private returns (uint) {
163         uint booster = getUpdatedAverageLiquidityWithDelegate(liquidator) * 1e18 / violatorLiabilityValue;
164         if (booster > 1e18) booster = 1e18;
165 
166         booster = booster * (DISCOUNT_BOOSTER_SLOPE - 1e18) / 1e18;
167 
168         return booster + 1e18;
169     }
170 
171 
172     /// @notice Checks to see if a liquidation would be profitable, without actually doing anything
173     /// @param liquidator Address that will initiate the liquidation
174     /// @param violator Address that may be in collateral violation
175     /// @param underlying Token that is to be repayed
176     /// @param collateral Token that is to be seized
177     /// @return liqOpp The details about the liquidation opportunity
178     function checkLiquidation(address liquidator, address violator, address underlying, address collateral) external nonReentrant returns (LiquidationOpportunity memory liqOpp) {
179         LiquidationLocals memory liqLocs;
180 
181         liqLocs.liquidator = liquidator;
182         liqLocs.violator = violator;
183         liqLocs.underlying = underlying;
184         liqLocs.collateral = collateral;
185 
186         computeLiqOpp(liqLocs);
187 
188         return liqLocs.liqOpp;
189     }
190 
191 
192     /// @notice Attempts to perform a liquidation
193     /// @param violator Address that may be in collateral violation
194     /// @param underlying Token that is to be repayed
195     /// @param collateral Token that is to be seized
196     /// @param repay The amount of underlying DTokens to be transferred from violator to sender, in units of underlying
197     /// @param minYield The minimum acceptable amount of collateral ETokens to be transferred from violator to sender, in units of collateral
198     function liquidate(address violator, address underlying, address collateral, uint repay, uint minYield) external nonReentrant {
199         require(accountLookup[violator].deferLiquidityStatus == DEFERLIQUIDITY__NONE, "e/liq/violator-liquidity-deferred");
200 
201         address liquidator = unpackTrailingParamMsgSender();
202 
203         emit RequestLiquidate(liquidator, violator, underlying, collateral, repay, minYield);
204 
205         updateAverageLiquidity(liquidator);
206         updateAverageLiquidity(violator);
207 
208 
209         LiquidationLocals memory liqLocs;
210 
211         liqLocs.liquidator = liquidator;
212         liqLocs.violator = violator;
213         liqLocs.underlying = underlying;
214         liqLocs.collateral = collateral;
215 
216         computeLiqOpp(liqLocs);
217 
218 
219         executeLiquidation(liqLocs, repay, minYield);
220     }
221 
222     function executeLiquidation(LiquidationLocals memory liqLocs, uint desiredRepay, uint minYield) private {
223         require(desiredRepay <= liqLocs.liqOpp.repay, "e/liq/excessive-repay-amount");
224 
225 
226         uint repay;
227 
228         {
229             AssetStorage storage underlyingAssetStorage = eTokenLookup[underlyingLookup[liqLocs.underlying].eTokenAddress];
230             AssetCache memory underlyingAssetCache = loadAssetCache(liqLocs.underlying, underlyingAssetStorage);
231 
232             if (desiredRepay == liqLocs.liqOpp.repay) repay = liqLocs.repayPreFees;
233             else repay = desiredRepay * (1e18 * 1e18 / (1e18 + UNDERLYING_RESERVES_FEE)) / 1e18;
234 
235             {
236                 uint repayExtra = desiredRepay - repay;
237 
238                 // Liquidator takes on violator's debt:
239 
240                 transferBorrow(underlyingAssetStorage, underlyingAssetCache, underlyingAssetStorage.dTokenAddress, liqLocs.violator, liqLocs.liquidator, repay);
241 
242                 // Extra debt is minted and assigned to liquidator:
243 
244                 increaseBorrow(underlyingAssetStorage, underlyingAssetCache, underlyingAssetStorage.dTokenAddress, liqLocs.liquidator, repayExtra);
245 
246                 // The underlying's reserve is credited to compensate for this extra debt:
247 
248                 {
249                     uint poolAssets = underlyingAssetCache.poolSize + (underlyingAssetCache.totalBorrows / INTERNAL_DEBT_PRECISION);
250                     uint newTotalBalances = poolAssets * underlyingAssetCache.totalBalances / (poolAssets - repayExtra);
251                     increaseReserves(underlyingAssetStorage, underlyingAssetCache, newTotalBalances - underlyingAssetCache.totalBalances);
252                 }
253             }
254 
255             logAssetStatus(underlyingAssetCache);
256         }
257 
258 
259         uint yield;
260 
261         {
262             AssetStorage storage collateralAssetStorage = eTokenLookup[underlyingLookup[liqLocs.collateral].eTokenAddress];
263             AssetCache memory collateralAssetCache = loadAssetCache(liqLocs.collateral, collateralAssetStorage);
264 
265             yield = repay * liqLocs.liqOpp.conversionRate / 1e18;
266             require(yield >= minYield, "e/liq/min-yield");
267 
268             // Liquidator gets violator's collateral:
269 
270             address eTokenAddress = underlyingLookup[collateralAssetCache.underlying].eTokenAddress;
271 
272             transferBalance(collateralAssetStorage, collateralAssetCache, eTokenAddress, liqLocs.violator, liqLocs.liquidator, underlyingAmountToBalance(collateralAssetCache, yield));
273 
274             logAssetStatus(collateralAssetCache);
275         }
276 
277 
278         // Since liquidator is taking on new debt, liquidity must be checked:
279 
280         checkLiquidity(liqLocs.liquidator);
281 
282         emitLiquidationLog(liqLocs, repay, yield);
283     }
284 
285     function emitLiquidationLog(LiquidationLocals memory liqLocs, uint repay, uint yield) private {
286         emit Liquidation(liqLocs.liquidator, liqLocs.violator, liqLocs.underlying, liqLocs.collateral, repay, yield, liqLocs.liqOpp.healthScore, liqLocs.liqOpp.baseDiscount, liqLocs.liqOpp.discount);
287     }
288 }
