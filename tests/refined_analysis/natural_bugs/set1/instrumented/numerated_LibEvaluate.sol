1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
7 import {Decimal, SafeMath} from "contracts/libraries/Decimal.sol";
8 import {LibWhitelistedTokens, C} from "contracts/libraries/Silo/LibWhitelistedTokens.sol";
9 import {LibUnripe} from "contracts/libraries/LibUnripe.sol";
10 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
11 import {LibSafeMath32} from "contracts/libraries/LibSafeMath32.sol";
12 import {LibWell} from "contracts/libraries/Well/LibWell.sol";
13 
14 import {LibBarnRaise} from "contracts/libraries/LibBarnRaise.sol";
15 
16 /**
17  * @author Brean
18  * @title LibEvaluate calculates the caseId based on the state of Beanstalk.
19  * @dev the current parameters that beanstalk uses to evaluate its state are:
20  * - DeltaB, the amount of Beans needed to be bought/sold to reach peg.
21  * - PodRate, the ratio of Pods outstanding against the bean supply.
22  * - Delta Soil demand, the change in demand of Soil between the current and previous Season.
23  * - LpToSupplyRatio (L2SR), the ratio of liquidity to the circulating Bean supply.
24  *
25  * based on the caseId, Beanstalk adjusts:
26  * - the Temperature
27  * - the ratio of the gaugePoints per BDV of bean and the largest GpPerBdv for a given LP token. 
28  */
29 
30 library DecimalExtended {
31     uint256 private constant PERCENT_BASE = 1e18;
32 
33     function toDecimal(uint256 a) internal pure returns (Decimal.D256 memory) {
34         return Decimal.D256({ value: a });
35     }
36 }
37 
38 library LibEvaluate {
39     using SafeMath for uint256;
40     using DecimalExtended for uint256;
41     using Decimal for Decimal.D256;
42     using LibSafeMath32 for uint32;
43 
44     // Pod rate bounds
45     uint256 internal constant POD_RATE_LOWER_BOUND = 0.05e18; // 5%
46     uint256 internal constant POD_RATE_OPTIMAL = 0.15e18; // 15%
47     uint256 internal constant POD_RATE_UPPER_BOUND = 0.25e18; // 25%
48 
49     // Change in Soil demand bounds
50     uint256 internal constant DELTA_POD_DEMAND_LOWER_BOUND = 0.95e18; // 95%
51     uint256 internal constant DELTA_POD_DEMAND_UPPER_BOUND = 1.05e18; // 105%
52 
53     /// @dev If all Soil is Sown faster than this, Beanstalk considers demand for Soil to be increasing.
54     uint256 internal constant SOW_TIME_DEMAND_INCR = 600; // seconds
55 
56     uint32 internal constant SOW_TIME_STEADY = 60; // seconds
57 
58     // Liquidity to supply ratio bounds
59     uint256 internal constant LP_TO_SUPPLY_RATIO_UPPER_BOUND = 0.8e18; // 80%
60     uint256 internal constant LP_TO_SUPPLY_RATIO_OPTIMAL = 0.4e18; // 40%
61     uint256 internal constant LP_TO_SUPPLY_RATIO_LOWER_BOUND = 0.12e18; // 12%
62 
63     // Excessive price threshold constant
64     uint256 internal constant EXCESSIVE_PRICE_THRESHOLD = 1.05e6;
65 
66     uint256 internal constant LIQUIDITY_PRECISION = 1e12;
67 
68     /**
69      * @notice evaluates the pod rate and returns the caseId
70      * @param podRate the length of the podline (debt), divided by the bean supply.
71      */
72     function evalPodRate(Decimal.D256 memory podRate) internal pure returns (uint256 caseId) {
73         if (podRate.greaterThanOrEqualTo(POD_RATE_UPPER_BOUND.toDecimal())) {
74             caseId = 27;
75         } else if (podRate.greaterThanOrEqualTo(POD_RATE_OPTIMAL.toDecimal())) {
76             caseId = 18;
77         } else if (podRate.greaterThanOrEqualTo(POD_RATE_LOWER_BOUND.toDecimal())) {
78             caseId = 9;
79         }
80     }
81 
82     /**
83      * @notice updates the caseId based on the price of bean (deltaB)
84      * @param deltaB the amount of beans needed to be sold or bought to get bean to peg.
85      * @param podRate the length of the podline (debt), divided by the bean supply.
86      * @param well the well address to get the bean price from. 
87      */
88     function evalPrice(
89         int256 deltaB,
90         Decimal.D256 memory podRate,
91         address well
92     ) internal view returns (uint256 caseId) {
93         // p > 1
94         if (
95             deltaB > 0 || (deltaB == 0 && podRate.lessThanOrEqualTo(POD_RATE_OPTIMAL.toDecimal()))
96         ) {
97             // Beanstalk will only use the largest liquidity well to compute the Bean price,
98             // and thus will skip the p > EXCESSIVE_PRICE_THRESHOLD check if the well oracle fails to
99             // compute a valid price this Season.
100             // deltaB > 0 implies that address(well) != address(0).
101             uint256 beanTknPrice = LibWell.getWellPriceFromTwaReserves(well);
102             if (beanTknPrice > 1) {
103                 uint256 beanUsdPrice = LibWell.getUsdTokenPriceForWell(well)
104                     .mul(beanTknPrice)
105                     .div(1e18);
106                 if (beanUsdPrice > EXCESSIVE_PRICE_THRESHOLD) {
107                     // p > EXCESSIVE_PRICE_THRESHOLD
108                     return caseId = 6;
109                 }
110             }
111             caseId = 3;
112         }
113         // p < 1
114     }
115 
116     /**
117      * @notice Updates the caseId based on the change in Soil demand.
118      * @param deltaPodDemand The change in Soil demand from the previous Season.
119      */
120     function evalDeltaPodDemand(
121         Decimal.D256 memory deltaPodDemand
122     ) internal pure returns (uint256 caseId) {
123         // increasing
124         if (deltaPodDemand.greaterThanOrEqualTo(DELTA_POD_DEMAND_UPPER_BOUND.toDecimal())) {
125             caseId = 2;
126         // steady
127         } else if (deltaPodDemand.greaterThanOrEqualTo(DELTA_POD_DEMAND_LOWER_BOUND.toDecimal())) {
128             caseId = 1;
129         }
130         // decreasing (caseId = 0)
131     }
132 
133     /**
134      * @notice Evaluates the lp to supply ratio and returns the caseId.
135      * @param lpToSupplyRatio The ratio of liquidity to supply.
136      * 
137      * @dev 'liquidity' is definied as the non-bean value in a pool that trades beans.
138      */
139     function evalLpToSupplyRatio(
140         Decimal.D256 memory lpToSupplyRatio
141     ) internal pure returns (uint256 caseId) {
142         // Extremely High
143         if (lpToSupplyRatio.greaterThanOrEqualTo(LP_TO_SUPPLY_RATIO_UPPER_BOUND.toDecimal())) {
144             caseId = 108;
145         // Reasonably High
146         } else if (lpToSupplyRatio.greaterThanOrEqualTo(LP_TO_SUPPLY_RATIO_OPTIMAL.toDecimal())) {
147             caseId = 72;
148         // Reasonably Low
149         } else if (
150             lpToSupplyRatio.greaterThanOrEqualTo(LP_TO_SUPPLY_RATIO_LOWER_BOUND.toDecimal())
151         ) {
152             caseId = 36;
153         }
154         // excessively low (caseId = 0)
155     }
156 
157     /**
158      * @notice Calculates the change in soil demand from the previous season.
159      * @param dsoil The amount of soil sown this season.
160      */
161     function calcDeltaPodDemand(
162         uint256 dsoil
163     )
164         internal
165         view
166         returns (Decimal.D256 memory deltaPodDemand, uint32 lastSowTime, uint32 thisSowTime)
167     {
168         AppStorage storage s = LibAppStorage.diamondStorage();
169 
170         // `s.w.thisSowTime` is set to the number of seconds in it took for
171         // Soil to sell out during the current Season. If Soil didn't sell out,
172         // it remains `type(uint32).max`.
173         if (s.w.thisSowTime < type(uint32).max) {
174             if (
175                 s.w.lastSowTime == type(uint32).max || // Didn't Sow all last Season
176                 s.w.thisSowTime < SOW_TIME_DEMAND_INCR || // Sow'd all instantly this Season
177                 (s.w.lastSowTime > SOW_TIME_STEADY &&
178                     s.w.thisSowTime < s.w.lastSowTime.sub(SOW_TIME_STEADY)) // Sow'd all faster
179             ) {
180                 deltaPodDemand = Decimal.from(1e18);
181             } else if (s.w.thisSowTime <= s.w.lastSowTime.add(SOW_TIME_STEADY)) {
182                 // Sow'd all in same time
183                 deltaPodDemand = Decimal.one();
184             } else {
185                 deltaPodDemand = Decimal.zero();
186             }
187         } else {
188             // Soil didn't sell out
189             uint256 lastDSoil = s.w.lastDSoil;
190 
191             if (dsoil == 0) {
192                 deltaPodDemand = Decimal.zero(); // If no one Sow'd
193             } else if (lastDSoil == 0) {
194                 deltaPodDemand = Decimal.from(1e18); // If no one Sow'd last Season
195             } else {
196                 deltaPodDemand = Decimal.ratio(dsoil, lastDSoil);
197             }
198         }
199 
200         lastSowTime = s.w.thisSowTime; // Overwrite last Season
201         thisSowTime = type(uint32).max; // Reset for next Season
202     }
203 
204     /**
205      * @notice Calculates the liquidity to supply ratio, where liquidity is measured in USD.
206      * @param beanSupply The total supply of Beans.
207      * corresponding to the well addresses in the whitelist.
208      * @dev No support for non-well AMMs at this time.
209      */
210     function calcLPToSupplyRatio(
211         uint256 beanSupply
212     ) internal view returns (Decimal.D256 memory lpToSupplyRatio, address largestLiqWell) {
213         AppStorage storage s = LibAppStorage.diamondStorage();
214 
215         // prevent infinite L2SR
216         if (beanSupply == 0) return (Decimal.zero(), address(0));
217 
218         address[] memory pools = LibWhitelistedTokens.getWhitelistedLpTokens();
219         uint256[] memory twaReserves;
220         uint256 totalUsdLiquidity;
221         uint256 largestLiq;
222         uint256 wellLiquidity;
223         uint256 liquidityWeight;
224         for (uint256 i; i < pools.length; i++) {
225             // get the liquidity weight.
226             liquidityWeight = getLiquidityWeight(s.ss[pools[i]].lwSelector);
227             
228             // get the non-bean value in an LP.
229             twaReserves = LibWell.getTwaReservesFromStorageOrBeanstalkPump(
230                 pools[i]
231             );
232 
233             // calculate the non-bean liqudity in the pool.
234             wellLiquidity = liquidityWeight.mul(
235                 LibWell.getWellTwaUsdLiquidityFromReserves(pools[i], twaReserves)
236             ).div(1e18);
237 
238             // if the liquidity is the largest, update `largestLiqWell`,  
239             // and add the liquidity to the total.
240             // `largestLiqWell` is only used to initalize `s.sopWell` upon a sop,
241             // but a hot storage load to skip the block below 
242             // is significantly more expensive than performing the logic on every sunrise.
243             if (wellLiquidity > largestLiq) {
244                 largestLiq = wellLiquidity;
245                 largestLiqWell = pools[i];
246             }
247             totalUsdLiquidity = totalUsdLiquidity.add(wellLiquidity);
248             
249             if (pools[i] == LibBarnRaise.getBarnRaiseWell()) {
250                 // Scale down bean supply by the locked beans, if there is fertilizer to be paid off.
251                 // Note: This statement is put into the for loop to prevent another extraneous read of 
252                 // the twaReserves from storage as `twaReserves` are already loaded into memory.
253                 if (LibAppStorage.diamondStorage().season.fertilizing == true) {
254                     beanSupply = beanSupply.sub(LibUnripe.getLockedBeans(twaReserves));
255                 }
256             }
257             
258             // If a new non-Well LP is added, functionality to calculate the USD value of the 
259             // liquidity should be added here.
260         }
261 
262         // if there is no liquidity,
263         // return 0 to save gas.
264         if (totalUsdLiquidity == 0) return (Decimal.zero(), address(0));
265 
266         // USD liquidity is scaled down from 1e18 to match Bean precision (1e6).
267         lpToSupplyRatio = Decimal.ratio(totalUsdLiquidity.div(LIQUIDITY_PRECISION), beanSupply);
268     }
269 
270     /**
271      * @notice Get the deltaPodDemand, lpToSupplyRatio, and podRate, and update soil demand
272      * parameters.
273      */
274     function getBeanstalkState(
275         uint256 beanSupply
276     )
277         internal
278         returns (
279             Decimal.D256 memory deltaPodDemand,
280             Decimal.D256 memory lpToSupplyRatio,
281             Decimal.D256 memory podRate,
282             address largestLiqWell
283         )
284     {
285         AppStorage storage s = LibAppStorage.diamondStorage();
286         // Calculate Delta Soil Demand
287         uint256 dsoil = s.f.beanSown;
288         s.f.beanSown = 0;
289         (deltaPodDemand, s.w.lastSowTime, s.w.thisSowTime) = calcDeltaPodDemand(dsoil);
290         s.w.lastDSoil = uint128(dsoil); // SafeCast not necessary as `s.f.beanSown` is uint128.
291 
292         // Calculate Lp To Supply Ratio, fetching the twaReserves in storage:
293         (lpToSupplyRatio, largestLiqWell) = calcLPToSupplyRatio(
294             beanSupply
295         );
296 
297         // Calculate PodRate
298         podRate = Decimal.ratio(s.f.pods.sub(s.f.harvestable), beanSupply); // Pod Rate
299     }
300 
301     /**
302      * @notice Evaluates beanstalk based on deltaB, podRate, deltaPodDemand and lpToSupplyRatio.
303      * and returns the associated caseId.
304      */
305     function evaluateBeanstalk(
306         int256 deltaB,
307         uint256 beanSupply
308     ) internal returns (uint256, address) {
309         (
310             Decimal.D256 memory deltaPodDemand,
311             Decimal.D256 memory lpToSupplyRatio,
312             Decimal.D256 memory podRate,
313             address largestLiqWell
314         ) = getBeanstalkState(beanSupply);
315         uint256 caseId = evalPodRate(podRate) // Evaluate Pod Rate
316         .add(evalPrice(deltaB, podRate, largestLiqWell)) // Evaluate Price
317         .add(evalDeltaPodDemand(deltaPodDemand)) // Evaluate Delta Soil Demand 
318         .add(evalLpToSupplyRatio(lpToSupplyRatio)); // Evaluate LP to Supply Ratio
319         return(caseId, largestLiqWell);
320     }
321 
322     /**
323      * @notice calculates the liquidity weight of a token.
324      * @dev the liquidity weight determines the percentage of
325      * liquidity is considered in evaluating the liquidity of bean.
326      * At 0, no liquidity is added. at 1e18, all liquidity is added.
327      * 
328      * if failure, returns 0 (no liquidity is considered) instead of reverting.
329      */
330     function getLiquidityWeight(
331         bytes4 lwSelector
332     ) internal view returns (uint256 liquidityWeight) {
333         bytes memory callData = abi.encodeWithSelector(lwSelector);
334         (bool success, bytes memory data) = address(this).staticcall(callData);
335         if (!success) {
336             return 0;
337         }
338         assembly {
339             liquidityWeight := mload(add(data, add(0x20, 0)))
340         }
341     }
342 }
