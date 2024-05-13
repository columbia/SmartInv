1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import {LibAppStorage, AppStorage, Storage} from "./LibAppStorage.sol";
9 import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
10 import {SafeCast} from "@openzeppelin/contracts/utils/SafeCast.sol";
11 import {LibWhitelistedTokens} from "contracts/libraries/Silo/LibWhitelistedTokens.sol";
12 import {LibWhitelist} from "contracts/libraries/Silo/LibWhitelist.sol";
13 import {LibSafeMath32} from "contracts/libraries/LibSafeMath32.sol";
14 import {C} from "../C.sol";
15 import {LibWell} from "contracts/libraries/Well/LibWell.sol";
16 
17 /**
18  * @title LibGauge
19  * @author Brean, Brendan
20  * @notice LibGauge handles functionality related to the seed gauge system.
21  */
22 library LibGauge {
23     using SafeCast for uint256;
24     using SafeMath for uint256;
25     using LibSafeMath32 for uint32;
26 
27     uint256 internal constant BDV_PRECISION = 1e6;
28     uint256 internal constant GP_PRECISION = 1e18;
29 
30     // Max and min are the ranges that the beanToMaxLpGpPerBdvRatioScaled can output.
31     uint256 internal constant MAX_BEAN_MAX_LP_GP_PER_BDV_RATIO = 100e18;
32     uint256 internal constant MIN_BEAN_MAX_LP_GP_PER_BDV_RATIO = 50e18;
33     uint256 internal constant BEAN_MAX_LP_GP_RATIO_RANGE =
34         MAX_BEAN_MAX_LP_GP_PER_BDV_RATIO - MIN_BEAN_MAX_LP_GP_PER_BDV_RATIO;
35 
36     // The maximum value of beanToMaxLpGpPerBdvRatio.
37     uint256 internal constant ONE_HUNDRED_PERCENT = 100e18;
38 
39     // 24 * 30 * 6
40     uint256 internal constant TARGET_SEASONS_TO_CATCHUP = 4320;
41     uint256 internal constant STALK_BDV_PRECISION = 1e4;
42 
43     /**
44      * @notice Emitted when the AverageGrownStalkPerBdvPerSeason Updates.
45      */
46     event UpdateAverageStalkPerBdvPerSeason(uint256 newStalkPerBdvPerSeason);
47 
48     struct LpGaugePointData {
49         address lpToken;
50         uint256 gpPerBdv;
51     }
52     /**
53      * @notice Emitted when the gaugePoints for an LP silo token changes.
54      * @param season The current Season
55      * @param token The LP silo token whose gaugePoints was updated.
56      * @param gaugePoints The new gaugePoints for the LP silo token.
57      */
58     event GaugePointChange(uint256 indexed season, address indexed token, uint256 gaugePoints);
59 
60     /**
61      * @notice Updates the seed gauge system.
62      * @dev Updates the GaugePoints for LP assets (if applicable)
63      * and the distribution of grown Stalk to silo assets.
64      *
65      * If any of the LP price oracle failed,
66      * then the gauge system should be skipped, as a valid
67      * usd liquidity value cannot be computed.
68      */
69     function stepGauge() external {
70         (
71             uint256 maxLpGpPerBdv,
72             LpGaugePointData[] memory lpGpData,
73             uint256 totalGaugePoints,
74             uint256 totalLpBdv
75         ) = updateGaugePoints();
76 
77         // If totalLpBdv is max, it means that the gauge points has failed,
78         // and the gauge system should be skipped.
79         if (totalLpBdv == type(uint256).max) return;
80 
81         updateGrownStalkEarnedPerSeason(maxLpGpPerBdv, lpGpData, totalGaugePoints, totalLpBdv);
82     }
83 
84     /**
85      * @notice Evaluate the gauge points of each LP asset.
86      * @dev `totalLpBdv` is returned as type(uint256).max when an Oracle failure occurs.
87      */
88     function updateGaugePoints()
89         internal
90         returns (
91             uint256 maxLpGpPerBdv,
92             LpGaugePointData[] memory lpGpData,
93             uint256 totalGaugePoints,
94             uint256 totalLpBdv
95         )
96     {
97         AppStorage storage s = LibAppStorage.diamondStorage();
98         address[] memory whitelistedLpTokens = LibWhitelistedTokens.getWhitelistedLpTokens();
99         lpGpData = new LpGaugePointData[](whitelistedLpTokens.length);
100         // If there is only one pool, there is no need to update the gauge points.
101         if (whitelistedLpTokens.length == 1) {
102             // If the usd price oracle failed, skip gauge point update.
103             // Assumes that only Wells use USD price oracles.
104             if (
105                 LibWell.isWell(whitelistedLpTokens[0]) &&
106                 s.usdTokenPrice[whitelistedLpTokens[0]] == 0
107             ) {
108                 return (maxLpGpPerBdv, lpGpData, totalGaugePoints, type(uint256).max);
109             }
110             uint256 gaugePoints = s.ss[whitelistedLpTokens[0]].gaugePoints;
111 
112             lpGpData[0].lpToken = whitelistedLpTokens[0];
113             // If nothing has been deposited, skip gauge point update.
114             uint128 depositedBdv = s.siloBalances[whitelistedLpTokens[0]].depositedBdv;
115             if (depositedBdv == 0)
116                 return (maxLpGpPerBdv, lpGpData, totalGaugePoints, type(uint256).max);
117             lpGpData[0].gpPerBdv = gaugePoints.mul(BDV_PRECISION).div(
118                 s.siloBalances[whitelistedLpTokens[0]].depositedBdv
119             );
120             return (
121                 lpGpData[0].gpPerBdv,
122                 lpGpData,
123                 gaugePoints,
124                 s.siloBalances[whitelistedLpTokens[0]].depositedBdv
125             );
126         }
127 
128         // Summate total deposited BDV across all whitelisted LP tokens.
129         for (uint256 i; i < whitelistedLpTokens.length; ++i) {
130             // Assumes that only Wells use USD price oracles.
131             if (
132                 LibWell.isWell(whitelistedLpTokens[i]) &&
133                 s.usdTokenPrice[whitelistedLpTokens[i]] == 0
134             ) {
135                 return (maxLpGpPerBdv, lpGpData, totalGaugePoints, type(uint256).max);
136             }
137             totalLpBdv = totalLpBdv.add(s.siloBalances[whitelistedLpTokens[i]].depositedBdv);
138         }
139 
140         // If nothing has been deposited, skip gauge point update.
141         if (totalLpBdv == 0) return (maxLpGpPerBdv, lpGpData, totalGaugePoints, type(uint256).max);
142 
143         // Calculate and update the gauge points for each LP.
144         for (uint256 i; i < whitelistedLpTokens.length; ++i) {
145             Storage.SiloSettings storage ss = s.ss[whitelistedLpTokens[i]];
146 
147             uint256 depositedBdv = s.siloBalances[whitelistedLpTokens[i]].depositedBdv;
148 
149             // 1e6 = 1%
150             uint256 percentDepositedBdv = depositedBdv.mul(100e6).div(totalLpBdv);
151 
152             // Calculate the new gauge points of the token.
153             uint256 newGaugePoints = calcGaugePoints(
154                 ss.gpSelector,
155                 ss.gaugePoints,
156                 ss.optimalPercentDepositedBdv,
157                 percentDepositedBdv
158             );
159 
160             // Increment totalGaugePoints and calculate the gaugePoints per BDV:
161             totalGaugePoints = totalGaugePoints.add(newGaugePoints);
162             LpGaugePointData memory _lpGpData;
163             _lpGpData.lpToken = whitelistedLpTokens[i];
164 
165             // Gauge points has 18 decimal precision (GP_PRECISION = 1%)
166             // Deposited BDV has 6 decimal precision (1e6 = 1 unit of BDV)
167             uint256 gpPerBdv = depositedBdv > 0 ? newGaugePoints.mul(BDV_PRECISION).div(depositedBdv) : 0;
168 
169             // gpPerBdv has 18 decimal precision.
170             if (gpPerBdv > maxLpGpPerBdv) maxLpGpPerBdv = gpPerBdv;
171             _lpGpData.gpPerBdv = gpPerBdv;
172             lpGpData[i] = _lpGpData;
173 
174             ss.gaugePoints = newGaugePoints.toUint128();
175             emit GaugePointChange(s.season.current, whitelistedLpTokens[i], ss.gaugePoints);
176         }
177     }
178 
179     /**
180      * @notice Calculates the new gauge points for the given token.
181      * @dev Function calls the selector of the token's gauge point function.
182      * Currently all assets uses the default GaugePoint Function.
183      * {GaugePointFacet.defaultGaugePointFunction()}
184      */
185     function calcGaugePoints(
186         bytes4 gpSelector,
187         uint256 gaugePoints,
188         uint256 optimalPercentDepositedBdv,
189         uint256 percentDepositedBdv
190     ) internal view returns (uint256 newGaugePoints) {
191         bytes memory callData = abi.encodeWithSelector(
192             gpSelector,
193             gaugePoints,
194             optimalPercentDepositedBdv,
195             percentDepositedBdv
196         );
197         (bool success, bytes memory data) = address(this).staticcall(callData);
198         if (!success) {
199             if (data.length == 0) revert();
200             assembly {
201                 revert(add(32, data), mload(data))
202             }
203         }
204         assembly {
205             newGaugePoints := mload(add(data, add(0x20, 0)))
206         }
207     }
208 
209     /**
210      * @notice Updates the average grown stalk per BDV per Season for whitelisted Beanstalk assets.
211      * @dev Called at the end of each Season.
212      * The gauge system considers the total BDV of all whitelisted silo tokens, excluding unripe assets.
213      */
214     function updateGrownStalkEarnedPerSeason(
215         uint256 maxLpGpPerBdv,
216         LpGaugePointData[] memory lpGpData,
217         uint256 totalGaugePoints,
218         uint256 totalLpBdv
219     ) internal {
220         AppStorage storage s = LibAppStorage.diamondStorage();
221         uint256 beanDepositedBdv = s.siloBalances[C.BEAN].depositedBdv;
222         uint256 totalGaugeBdv = totalLpBdv.add(beanDepositedBdv);
223 
224         // If nothing has been deposited, skip grown stalk update.
225         if (totalGaugeBdv == 0) return;
226 
227         // Calculate the ratio between the bean and the max LP gauge points per BDV.
228         // 18 decimal precision.
229         uint256 beanToMaxLpGpPerBdvRatio = getBeanToMaxLpGpPerBdvRatioScaled(
230             s.seedGauge.beanToMaxLpGpPerBdvRatio
231         );
232 
233         // Get the GaugePoints and GPperBDV for bean
234         // BeanGpPerBdv and beanToMaxLpGpPerBdvRatio has 18 decimal precision.
235         uint256 beanGpPerBdv = maxLpGpPerBdv.mul(beanToMaxLpGpPerBdvRatio).div(100e18);
236 
237         totalGaugePoints = totalGaugePoints.add(
238             beanGpPerBdv.mul(beanDepositedBdv).div(BDV_PRECISION)
239         );
240 
241         // update the average grown stalk per BDV per Season.
242         // beanstalk must exist for a minimum of the catchup season in order to update the average.
243         if (s.season.current > TARGET_SEASONS_TO_CATCHUP) {
244             updateAverageStalkPerBdvPerSeason();
245         }
246 
247         // Calculate grown stalk issued this season and GrownStalk Per GaugePoint.
248         uint256 newGrownStalk = uint256(s.seedGauge.averageGrownStalkPerBdvPerSeason)
249             .mul(totalGaugeBdv)
250             .div(BDV_PRECISION);
251 
252         // Gauge points has 18 decimal precision.
253         uint256 newGrownStalkPerGp = newGrownStalk.mul(GP_PRECISION).div(totalGaugePoints);
254 
255         // Update stalkPerBdvPerSeason for bean.
256         issueGrownStalkPerBdv(C.BEAN, newGrownStalkPerGp, beanGpPerBdv);
257 
258         // Update stalkPerBdvPerSeason for LP
259         // If there is only one pool, then no need to read gauge points.
260         if (lpGpData.length == 1) {
261             issueGrownStalkPerBdv(lpGpData[0].lpToken, newGrownStalkPerGp, lpGpData[0].gpPerBdv);
262         } else {
263             for (uint256 i; i < lpGpData.length; i++) {
264                 issueGrownStalkPerBdv(
265                     lpGpData[i].lpToken,
266                     newGrownStalkPerGp,
267                     lpGpData[i].gpPerBdv
268                 );
269             }
270         }
271     }
272 
273     /**
274      * @notice issues the grown stalk per BDV for the given token.
275      * @param token the token to issue the grown stalk for.
276      * @param grownStalkPerGp the number of GrownStalk Per Gauge Point.
277      * @param gpPerBdv the amount of GaugePoints per BDV the token has.
278      */
279     function issueGrownStalkPerBdv(
280         address token,
281         uint256 grownStalkPerGp,
282         uint256 gpPerBdv
283     ) internal {
284         LibWhitelist.updateStalkPerBdvPerSeasonForToken(
285             token,
286             grownStalkPerGp.mul(gpPerBdv).div(GP_PRECISION).toUint32()
287         );
288     }
289 
290     /**
291      * @notice Updates the UpdateAverageStalkPerBdvPerSeason in the seed gauge.
292      * @dev The function updates the targetGrownStalkPerBdvPerSeason such that 
293      * it will take 6 months for the average new depositer to catch up to the current
294      * average grown stalk per BDV.
295      */
296     function updateAverageStalkPerBdvPerSeason() internal {
297         AppStorage storage s = LibAppStorage.diamondStorage();
298         // Will overflow if the average grown stalk per BDV exceeds 1.4e36,
299         // which is highly improbable assuming consistent new deposits.
300         // Thus, safeCast was determined is to be unnecessary.
301         s.seedGauge.averageGrownStalkPerBdvPerSeason = uint128(
302             getAverageGrownStalkPerBdv().mul(BDV_PRECISION).div(TARGET_SEASONS_TO_CATCHUP)
303         );
304         emit UpdateAverageStalkPerBdvPerSeason(s.seedGauge.averageGrownStalkPerBdvPerSeason);
305     }
306 
307     /**
308      * @notice Returns the total BDV in beanstalk.
309      * @dev The total BDV may differ from the instaneous BDV,
310      * as BDV is asyncronous.
311      * Note We get the silo Tokens, not the whitelisted tokens
312      * to account for grown stalk from dewhitelisted tokens.
313      */
314     function getTotalBdv() internal view returns (uint256 totalBdv) {
315         AppStorage storage s = LibAppStorage.diamondStorage();
316         address[] memory siloTokens = LibWhitelistedTokens.getSiloTokens();
317         for (uint256 i; i < siloTokens.length; ++i) {
318             totalBdv = totalBdv.add(s.siloBalances[siloTokens[i]].depositedBdv);
319         }
320     }
321 
322     /**
323      * @notice Returns the average grown stalk per BDV.
324      * @dev `totalBDV` refers to the total BDV deposited in the silo.
325      */
326     function getAverageGrownStalkPerBdv() internal view returns (uint256) {
327         AppStorage storage s = LibAppStorage.diamondStorage();
328         uint256 totalBdv = getTotalBdv();
329         if (totalBdv == 0) return 0;
330         return s.s.stalk.div(totalBdv).sub(STALK_BDV_PRECISION);
331     }
332 
333     /**
334      * @notice Returns the ratio between the bean and
335      * the max LP gauge points per BDV.
336      * @dev s.seedGauge.beanToMaxLpGpPerBdvRatio is a number between 0 and 100e18,
337      * where f(0) = MIN_BEAN_MAX_LPGP_RATIO and f(100e18) = MAX_BEAN_MAX_LPGP_RATIO.
338      * At the minimum value (0), beans should have half of the
339      * largest gauge points per BDV out of the LPs.
340      * At the maximum value (100e18), beans should have the same amount of
341      * gauge points per BDV as the largest out of the LPs.
342      */
343     function getBeanToMaxLpGpPerBdvRatioScaled(
344         uint256 beanToMaxLpGpPerBdvRatio
345     ) internal pure returns (uint256) {
346         return
347             beanToMaxLpGpPerBdvRatio.mul(BEAN_MAX_LP_GP_RATIO_RANGE).div(ONE_HUNDRED_PERCENT).add(
348                 MIN_BEAN_MAX_LP_GP_PER_BDV_RATIO
349             );
350     }
351 }
