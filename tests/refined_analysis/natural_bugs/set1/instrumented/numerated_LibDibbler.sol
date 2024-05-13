1 // SPDX-License-Identifier: MIT
2  
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
7 import {LibSafeMath128} from "./LibSafeMath128.sol";
8 import {LibSafeMath32} from "./LibSafeMath32.sol";
9 import {LibPRBMath} from "./LibPRBMath.sol";
10 import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
11 /**
12  * @title LibDibbler
13  * @author Publius, Brean
14  * @notice Calculates the amount of Pods received for Sowing under certain conditions.
15  * Provides functions to calculate the instantaneous Temperature, which is adjusted by the
16  * Morning Auction functionality. Provides math helpers for scaling Soil.
17  */
18 library LibDibbler {
19     using SafeMath for uint256;
20     using LibPRBMath for uint256;
21     using LibSafeMath32 for uint32;
22     using LibSafeMath128 for uint128;
23 
24     /// @dev Morning Auction scales temperature by 1e6.
25     uint256 internal constant TEMPERATURE_PRECISION = 1e6; 
26 
27     /// @dev Simplifies conversion of Beans to Pods:
28     /// `pods = beans * (1 + temperature)`
29     /// `pods = beans * (100% + temperature) / 100%`
30     uint256 private constant ONE_HUNDRED_PCT = 100 * TEMPERATURE_PRECISION;
31 
32     /// @dev If less than `SOIL_SOLD_OUT_THRESHOLD` Soil is left, consider 
33     /// Soil to be "sold out"; affects how Temperature is adjusted.
34     uint256 private constant SOIL_SOLD_OUT_THRESHOLD = 1e6;
35     
36     event Sow(
37         address indexed account,
38         uint256 index,
39         uint256 beans,
40         uint256 pods
41     );
42 
43     //////////////////// SOW ////////////////////
44 
45     /**
46      * @param beans The number of Beans to Sow
47      * @param _morningTemperature Pre-calculated {morningTemperature()}
48      * @param account The account sowing Beans
49      * @param abovePeg Whether the TWA deltaB of the previous season was positive (true) or negative (false)
50      * @dev 
51      * 
52      * ## Above Peg 
53      * 
54      * | t   | Max pods  | s.f.soil              | soil                    | temperature              | maxTemperature |
55      * |-----|-----------|-----------------------|-------------------------|--------------------------|----------------|
56      * | 0   | 500e6     | ~37e6 500e6/(1+1250%) | ~495e6 500e6/(1+1%))    | 1e6 (1%)                 | 1250 (1250%)   |
57      * | 12  | 500e6     | ~37e6                 | ~111e6 500e6/(1+348%))  | 348.75e6 (27.9% * 1250)  | 1250           |
58      * | 300 | 500e6     | ~37e6                 |  ~37e6 500e6/(1+1250%)  | 1250e6                   | 1250           |
59      * 
60      * ## Below Peg
61      * 
62      * | t   | Max pods                        | soil  | temperature                   | maxTemperature     |
63      * |-----|---------------------------------|-------|-------------------------------|--------------------|
64      * | 0   | 505e6 (500e6 * (1+1%))          | 500e6 | 1e6 (1%)                      | 1250 (1250%)       |
65      * | 12  | 2243.75e6 (500e6 * (1+348.75%)) | 500e6 | 348.75e6 (27.9% * 1250 * 1e6) | 1250               |
66      * | 300 | 6750e6 (500e6 * (1+1250%))      | 500e6 | 1250e6                        | 1250               |
67      */
68     function sow(uint256 beans, uint256 _morningTemperature, address account, bool abovePeg) internal returns (uint256) {
69         AppStorage storage s = LibAppStorage.diamondStorage();
70         
71         uint256 pods;
72         if (abovePeg) {
73             uint256 maxTemperature = uint256(s.w.t).mul(TEMPERATURE_PRECISION);
74             // amount sown is rounded up, because 
75             // 1: temperature is rounded down.
76             // 2: pods are rounded down.
77             beans = scaleSoilDown(beans, _morningTemperature, maxTemperature);
78             pods = beansToPods(beans, maxTemperature);
79         } else {
80             pods = beansToPods(beans, _morningTemperature);
81         }
82 
83         // we use trySub here because in the case of an overflow, its equivalent to having no soil left. 
84         (, s.f.soil) = s.f.soil.trySub(uint128(beans));
85 
86         return sowNoSoil(account, beans, pods);
87     }
88 
89     /**
90      * @dev Sows a new Plot, increments total Pods, updates Sow time.
91      */
92     function sowNoSoil(address account, uint256 beans, uint256 pods)
93         internal
94         returns (uint256)
95     {
96         AppStorage storage s = LibAppStorage.diamondStorage();
97 
98         _sowPlot(account, beans, pods);
99         s.f.pods = s.f.pods.add(pods);
100         _saveSowTime();
101         return pods;
102     }
103 
104     /**
105      * @dev Create a Plot.
106      */
107     function _sowPlot(address account, uint256 beans, uint256 pods) private {
108         AppStorage storage s = LibAppStorage.diamondStorage();
109         s.a[account].field.plots[s.f.pods] = pods;
110         emit Sow(account, s.f.pods, beans, pods);
111     }
112 
113     /** 
114      * @dev Stores the time elapsed from the start of the Season to the time
115      * at which Soil is "sold out", i.e. the remaining Soil is less than a 
116      * threshold `SOIL_SOLD_OUT_THRESHOLD`.
117      * 
118      * RATIONALE: Beanstalk utilizes the time elapsed for Soil to "sell out" to 
119      * gauge demand for Soil, which affects how the Temperature is adjusted. For
120      * example, if all Soil is Sown in 1 second vs. 1 hour, Beanstalk assumes 
121      * that the former shows more demand than the latter.
122      *
123      * `thisSowTime` represents the target time of the first Sow for the *next*
124      * Season to be considered increasing in demand.
125      * 
126      * `thisSowTime` should only be updated if:
127      *  (a) there is less than 1 Soil available after this Sow, and 
128      *  (b) it has not yet been updated this Season.
129      * 
130      * Note that:
131      *  - `s.f.soil` was decremented in the upstream {sow} function.
132      *  - `s.w.thisSowTime` is set to `type(uint32).max` during {sunrise}.
133      */
134     function _saveSowTime() private {
135         AppStorage storage s = LibAppStorage.diamondStorage();
136 
137         // s.f.soil is now the soil remaining after this Sow.
138         if (s.f.soil > SOIL_SOLD_OUT_THRESHOLD || s.w.thisSowTime < type(uint32).max) {
139             // haven't sold enough soil, or already set thisSowTime for this Season.
140             return;
141         }
142 
143         s.w.thisSowTime = uint32(block.timestamp.sub(s.season.timestamp));
144     }
145 
146     //////////////////// TEMPERATURE ////////////////////
147     
148     /**
149      * @dev Returns the temperature `s.w.t` scaled down based on the block delta.
150      * Precision level 1e6, as soil has 1e6 precision (1% = 1e6)
151      * the formula `log51(A * MAX_BLOCK_ELAPSED + 1)` is applied, where:
152      * `A = 2`
153      * `MAX_BLOCK_ELAPSED = 25`
154      */
155     function morningTemperature() internal view returns (uint256) {
156         AppStorage storage s = LibAppStorage.diamondStorage();
157         uint256 delta = block.number.sub(s.season.sunriseBlock);
158 
159         // check most likely case first
160         if (delta > 24) {
161             return uint256(s.w.t).mul(TEMPERATURE_PRECISION);
162         }
163 
164         // Binary Search
165         if (delta < 13) {
166             if (delta < 7) { 
167                 if (delta < 4) {
168                     if (delta < 2) {
169                         // delta == 0, same block as sunrise
170                         if (delta < 1) {
171                             return TEMPERATURE_PRECISION;
172                         }
173                         // delta == 1
174                         else {
175                             return _scaleTemperature(279415312704);
176                         }
177                     }
178                     if (delta == 2) {
179                        return _scaleTemperature(409336034395);
180                     }
181                     else { // delta == 3
182                         return _scaleTemperature(494912626048);
183                     }
184                 }
185                 if (delta < 6) {
186                     if (delta == 4) {
187                         return _scaleTemperature(558830625409);
188                     }
189                     else { // delta == 5
190                         return _scaleTemperature(609868162219);
191                     }
192                 }
193                 else { // delta == 6
194                     return _scaleTemperature(652355825780); 
195                 }
196             }
197             if (delta < 10) {
198                 if (delta < 9) {
199                     if (delta == 7) {
200                         return _scaleTemperature(688751347100);
201                     }
202                     else { // delta == 8
203                         return _scaleTemperature(720584687295);
204                     }
205                 }
206                 else { // delta == 9
207                     return _scaleTemperature(748873234524); 
208                 }
209             }
210             if (delta < 12) {
211                 if (delta == 10) {
212                     return _scaleTemperature(774327938752);
213                 }
214                 else { // delta == 11
215                     return _scaleTemperature(797465225780); 
216                 }
217             }
218             else { // delta == 12
219                 return _scaleTemperature(818672068791); 
220             }
221         } 
222         if (delta < 19){
223             if (delta < 16) {
224                 if (delta < 15) {
225                     if (delta == 13) {
226                         return _scaleTemperature(838245938114); 
227                     }
228                     else { // delta == 14
229                         return _scaleTemperature(856420437864);
230                     }
231                 }
232                 else { // delta == 15
233                     return _scaleTemperature(873382373802);
234                 }
235             }
236             if (delta < 18) {
237                 if (delta == 16) {
238                     return _scaleTemperature(889283474924);
239                 }
240                 else { // delta == 17
241                     return _scaleTemperature(904248660443);
242                 }
243             }
244             else { // delta == 18
245                 return _scaleTemperature(918382006208); 
246             }
247         }
248         if (delta < 22) {
249             if (delta < 21) {
250                 if (delta == 19) {
251                     return _scaleTemperature(931771138485); 
252                 }
253                 else { // delta == 20
254                     return _scaleTemperature(944490527707);
255                 }
256             } 
257             else { // delta = 21
258                 return _scaleTemperature(956603996980); 
259             }
260         }
261         if (delta <= 23){ 
262             if (delta == 22) {
263                 return _scaleTemperature(968166659804);
264             }
265             else { // delta == 23
266                 return _scaleTemperature(979226436102);
267             }
268         }
269         else { // delta == 24
270             return _scaleTemperature(989825252096);
271         }
272     }
273 
274     /**
275      * @param pct The percentage to scale down by, measured to 1e12.
276      * @return scaledTemperature The scaled temperature, measured to 1e8 = 100e6 = 100% = 1.
277      * @dev Scales down `s.w.t` and imposes a minimum of 1e6 (1%) unless 
278      * `s.w.t` is 0%.
279      */
280     function _scaleTemperature(uint256 pct) private view returns (uint256 scaledTemperature) {
281         AppStorage storage s = LibAppStorage.diamondStorage();
282 
283         uint256 maxTemperature = s.w.t;
284         if(maxTemperature == 0) return 0; 
285 
286         scaledTemperature = LibPRBMath.max(
287             // To save gas, `pct` is pre-calculated to 12 digits. Here we
288             // perform the following transformation:
289             // (1e2)    maxTemperature
290             // (1e12)    * pct
291             // (1e6)     / TEMPERATURE_PRECISION
292             // (1e8)     = scaledYield
293             maxTemperature.mulDiv(
294                 pct, 
295                 TEMPERATURE_PRECISION,
296                 LibPRBMath.Rounding.Up
297             ),
298             // Floor at TEMPERATURE_PRECISION (1%)
299             TEMPERATURE_PRECISION
300         );
301     }
302 
303     /**
304      * @param beans The number of Beans to convert to Pods.
305      * @param _morningTemperature The current Temperature, measured to 1e8. 
306      * @dev Converts Beans to Pods based on `_morningTemperature`.
307      * 
308      * `pods = beans * (100e6 + _morningTemperature) / 100e6`
309      * `pods = beans * (1 + _morningTemperature / 100e6)`
310      *
311      * Beans and Pods are measured to 6 decimals.
312      * 
313      * 1e8 = 100e6 = 100% = 1.
314      */
315     function beansToPods(uint256 beans, uint256 _morningTemperature)
316         internal
317         pure
318         returns (uint256 pods)
319     {
320         pods = beans.mulDiv(
321             _morningTemperature.add(ONE_HUNDRED_PCT),
322             ONE_HUNDRED_PCT
323         );
324     }
325 
326     /**
327      * @dev Scales Soil up when Beanstalk is above peg.
328      * `(1 + maxTemperature) / (1 + morningTemperature)`
329      */
330     function scaleSoilUp(
331         uint256 soil, 
332         uint256 maxTemperature,
333         uint256 _morningTemperature
334     ) internal pure returns (uint256) {
335         return soil.mulDiv(
336             maxTemperature.add(ONE_HUNDRED_PCT),
337             _morningTemperature.add(ONE_HUNDRED_PCT)
338         );
339     }
340     
341     /**
342      * @dev Scales Soil down when Beanstalk is above peg.
343      * 
344      * When Beanstalk is above peg, the Soil issued changes. Example:
345      * 
346      * If 500 Soil is issued when `s.w.t = 100e2 = 100%`
347      * At delta = 0: 
348      *  morningTemperature() = 1%
349      *  Soil = `500*(100 + 100%)/(100 + 1%)` = 990.09901 soil
350      *
351      * If someone sow'd ~495 soil, it's equilivant to sowing 250 soil at t > 25.
352      * Thus when someone sows during this time, the amount subtracted from s.f.soil
353      * should be scaled down.
354      * 
355      * Note: param ordering matches the mulDiv operation
356      */
357     function scaleSoilDown(
358         uint256 soil, 
359         uint256 _morningTemperature, 
360         uint256 maxTemperature
361     ) internal pure returns (uint256) {
362         return soil.mulDiv(
363             _morningTemperature.add(ONE_HUNDRED_PCT),
364             maxTemperature.add(ONE_HUNDRED_PCT),
365             LibPRBMath.Rounding.Up
366         );
367     }
368 
369     /**
370      * @notice Returns the remaining Pods that could be issued this Season.
371      */
372     function remainingPods() internal view returns (uint256) {
373         AppStorage storage s = LibAppStorage.diamondStorage();
374 
375         // Above peg: number of Pods is fixed, Soil adjusts
376         if(s.season.abovePeg) {
377             return beansToPods(
378                 s.f.soil, // 1 bean = 1 soil
379                 uint256(s.w.t).mul(TEMPERATURE_PRECISION) // 1e2 -> 1e8
380             );
381         } else {
382             // Below peg: amount of Soil is fixed, temperature adjusts
383             return beansToPods(
384                 s.f.soil, // 1 bean = 1 soil
385                 morningTemperature()
386             );
387         }
388     }
389 }
