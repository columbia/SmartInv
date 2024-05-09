1 pragma solidity 0.6.7;
2 
3 contract GebMath {
4     uint256 public constant RAY = 10 ** 27;
5     uint256 public constant WAD = 10 ** 18;
6 
7     function ray(uint x) public pure returns (uint z) {
8         z = multiply(x, 10 ** 9);
9     }
10     function rad(uint x) public pure returns (uint z) {
11         z = multiply(x, 10 ** 27);
12     }
13     function minimum(uint x, uint y) public pure returns (uint z) {
14         z = (x <= y) ? x : y;
15     }
16     function addition(uint x, uint y) public pure returns (uint z) {
17         z = x + y;
18         require(z >= x, "uint-uint-add-overflow");
19     }
20     function subtract(uint x, uint y) public pure returns (uint z) {
21         z = x - y;
22         require(z <= x, "uint-uint-sub-underflow");
23     }
24     function multiply(uint x, uint y) public pure returns (uint z) {
25         require(y == 0 || (z = x * y) / y == x, "uint-uint-mul-overflow");
26     }
27     function rmultiply(uint x, uint y) public pure returns (uint z) {
28         z = multiply(x, y) / RAY;
29     }
30     function rdivide(uint x, uint y) public pure returns (uint z) {
31         z = multiply(x, RAY) / y;
32     }
33     function wdivide(uint x, uint y) public pure returns (uint z) {
34         z = multiply(x, WAD) / y;
35     }
36     function wmultiply(uint x, uint y) public pure returns (uint z) {
37         z = multiply(x, y) / WAD;
38     }
39     function rpower(uint x, uint n, uint base) public pure returns (uint z) {
40         assembly {
41             switch x case 0 {switch n case 0 {z := base} default {z := 0}}
42             default {
43                 switch mod(n, 2) case 0 { z := base } default { z := x }
44                 let half := div(base, 2)  // for rounding.
45                 for { n := div(n, 2) } n { n := div(n,2) } {
46                     let xx := mul(x, x)
47                     if iszero(eq(div(xx, x), x)) { revert(0,0) }
48                     let xxRound := add(xx, half)
49                     if lt(xxRound, xx) { revert(0,0) }
50                     x := div(xxRound, base)
51                     if mod(n,2) {
52                         let zx := mul(z, x)
53                         if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
54                         let zxRound := add(zx, half)
55                         if lt(zxRound, zx) { revert(0,0) }
56                         z := div(zxRound, base)
57                     }
58                 }
59             }
60         }
61     }
62 }
63 
64 interface AggregatorInterface {
65     event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
66     event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
67 
68     function latestAnswer() external view returns (int256);
69     function latestTimestamp() external view returns (uint256);
70     function latestRound() external view returns (uint256);
71     function getAnswer(uint256 roundId) external view returns (int256);
72     function getTimestamp(uint256 roundId) external view returns (uint256);
73 
74     // post-Historic
75 
76     function decimals() external view returns (uint8);
77     function getRoundData(uint256 _roundId)
78       external
79       returns (
80         uint256 roundId,
81         int256 answer,
82         uint256 startedAt,
83         uint256 updatedAt,
84         uint256 answeredInRound
85       );
86     function latestRoundData()
87       external
88       returns (
89         uint256 roundId,
90         int256 answer,
91         uint256 startedAt,
92         uint256 updatedAt,
93         uint256 answeredInRound
94       );
95 }
96 
97 abstract contract IncreasingRewardRelayerLike {
98     function reimburseCaller(address) virtual external;
99 }
100 
101 contract ChainlinkTWAP is GebMath {
102     // --- Auth ---
103     mapping (address => uint) public authorizedAccounts;
104     /**
105      * @notice Add auth to an account
106      * @param account Account to add auth to
107      */
108     function addAuthorization(address account) virtual external isAuthorized {
109         authorizedAccounts[account] = 1;
110         emit AddAuthorization(account);
111     }
112     /**
113      * @notice Remove auth from an account
114      * @param account Account to remove auth from
115      */
116     function removeAuthorization(address account) virtual external isAuthorized {
117         authorizedAccounts[account] = 0;
118         emit RemoveAuthorization(account);
119     }
120     /**
121     * @notice Checks whether msg.sender can call an authed function
122     **/
123     modifier isAuthorized {
124         require(authorizedAccounts[msg.sender] == 1, "ChainlinkTWAP/account-not-authorized");
125         _;
126     }
127 
128     // --- Variables ---
129     AggregatorInterface         public chainlinkAggregator;
130     IncreasingRewardRelayerLike public rewardRelayer;
131 
132     // Delay between updates after which the reward starts to increase
133     uint256 public periodSize;
134     // Timestamp of the Chainlink aggregator
135     uint256 public linkAggregatorTimestamp;
136     // Last timestamp when the median was updated
137     uint256 public lastUpdateTime;                  // [unix timestamp]
138     // Cumulative result
139     uint256 public converterResultCumulative;
140     // Latest result
141     uint256 private medianResult;                   // [wad]
142     /**
143       The ideal amount of time over which the moving average should be computed, e.g. 24 hours.
144       In practice it can and most probably will be different than the actual window over which the contract medianizes.
145     **/
146     uint256 public windowSize;
147     // Maximum window size used to determine if the median is 'valid' (close to the real one) or not
148     uint256 public maxWindowSize;
149     // Total number of updates
150     uint256 public updates;
151     // Multiplier for the Chainlink result
152     uint256 public multiplier = 1;
153     // Number of updates in the window
154     uint8   public granularity;
155 
156     // You want to change these every deployment
157     uint256 public staleThreshold = 3;
158     bytes32 public symbol         = "RAI-USD-TWAP";
159 
160     ChainlinkObservation[] public chainlinkObservations;
161 
162     // --- Structs ---
163     struct ChainlinkObservation {
164         uint timestamp;
165         uint timeAdjustedResult;
166     }
167 
168     // --- Events ---
169     event AddAuthorization(address account);
170     event RemoveAuthorization(address account);
171     event ModifyParameters(
172       bytes32 parameter,
173       address addr
174     );
175     event ModifyParameters(
176       bytes32 parameter,
177       uint256 val
178     );
179     event UpdateResult(uint256 result);
180 
181     constructor(
182       address aggregator,
183       uint256 windowSize_,
184       uint256 maxWindowSize_,
185       uint256 multiplier_,
186       uint8   granularity_
187     ) public {
188         require(aggregator != address(0), "ChainlinkTWAP/null-aggregator");
189         require(multiplier_ >= 1, "ChainlinkTWAP/null-multiplier");
190         require(granularity_ > 1, 'ChainlinkTWAP/null-granularity');
191         require(windowSize_ > 0, 'ChainlinkTWAP/null-window-size');
192         require(
193           (periodSize = windowSize_ / granularity_) * granularity_ == windowSize_,
194           'ChainlinkTWAP/window-not-evenly-divisible'
195         );
196 
197         authorizedAccounts[msg.sender] = 1;
198 
199         lastUpdateTime                 = now;
200         windowSize                     = windowSize_;
201         maxWindowSize                  = maxWindowSize_;
202         granularity                    = granularity_;
203         multiplier                     = multiplier_;
204 
205         chainlinkAggregator            = AggregatorInterface(aggregator);
206 
207         emit AddAuthorization(msg.sender);
208         emit ModifyParameters("maxWindowSize", maxWindowSize);
209         emit ModifyParameters("aggregator", aggregator);
210     }
211 
212     // --- Boolean Utils ---
213     function both(bool x, bool y) internal pure returns (bool z) {
214         assembly{ z := and(x, y)}
215     }
216 
217     // --- General Utils ---
218     /**
219     * @notice Returns the oldest observations (relative to the current index in the Uniswap/Converter lists)
220     **/
221     function getFirstObservationInWindow()
222       private view returns (ChainlinkObservation storage firstChainlinkObservation) {
223         uint256 earliestObservationIndex = earliestObservationIndex();
224         firstChainlinkObservation        = chainlinkObservations[earliestObservationIndex];
225     }
226     /**
227       @notice It returns the time passed since the first observation in the window
228     **/
229     function timeElapsedSinceFirstObservation() public view returns (uint256) {
230         if (updates > 1) {
231           ChainlinkObservation memory firstChainlinkObservation = getFirstObservationInWindow();
232           return subtract(now, firstChainlinkObservation.timestamp);
233         }
234         return 0;
235     }
236     /**
237     * @notice Returns the index of the earliest observation in the window
238     **/
239     function earliestObservationIndex() public view returns (uint256) {
240         if (updates <= granularity) {
241           return 0;
242         }
243         return subtract(updates, uint(granularity));
244     }
245     /**
246     * @notice Get the observation list length
247     **/
248     function getObservationListLength() public view returns (uint256) {
249         return chainlinkObservations.length;
250     }
251 
252     // --- Administration ---
253     /*
254     * @notify Modify an uin256 parameter
255     * @param parameter The name of the parameter to change
256     * @param data The new parameter value
257     */
258     function modifyParameters(bytes32 parameter, uint256 data) external isAuthorized {
259         if (parameter == "maxWindowSize") {
260           require(data > windowSize, 'ChainlinkTWAP/invalid-max-window-size');
261           maxWindowSize = data;
262         }
263         else if (parameter == "staleThreshold") {
264           require(data > 1, "ChainlinkTWAP/invalid-stale-threshold");
265           staleThreshold = data;
266         }
267         else revert("ChainlinkTWAP/modify-unrecognized-param");
268         emit ModifyParameters(parameter, data);
269     }
270     /*
271     * @notify Modify an address parameter
272     * @param parameter The name of the parameter to change
273     * @param addr The new parameter address
274     */
275     function modifyParameters(bytes32 parameter, address addr) external isAuthorized {
276         if (parameter == "aggregator") chainlinkAggregator = AggregatorInterface(addr);
277         else if (parameter == "rewardRelayer") {
278           rewardRelayer = IncreasingRewardRelayerLike(addr);
279         }
280         else revert("ChainlinkTWAP/modify-unrecognized-param");
281         emit ModifyParameters(parameter, addr);
282     }
283 
284     // --- Main Getters ---
285     /**
286     * @notice Fetch the latest medianResult or revert if is is null
287     **/
288     function read() external view returns (uint256) {
289         require(
290           both(both(medianResult > 0, updates > granularity), timeElapsedSinceFirstObservation() <= maxWindowSize),
291           "ChainlinkTWAP/invalid-price-feed"
292         );
293         return multiply(medianResult, multiplier);
294     }
295     /**
296     * @notice Fetch the latest medianResult and whether it is null or not
297     **/
298     function getResultWithValidity() external view returns (uint256, bool) {
299         return (
300           multiply(medianResult, multiplier),
301           both(both(medianResult > 0, updates > granularity), timeElapsedSinceFirstObservation() <= maxWindowSize)
302         );
303     }
304 
305     // --- Median Updates ---
306     /*
307     * @notify Update the moving average
308     * @param feeReceiver The address that will receive a SF payout for calling this function
309     */
310     function updateResult(address feeReceiver) external {
311         require(address(rewardRelayer) != address(0), "ChainlinkTWAP/null-reward-relayer");
312 
313         uint256 elapsedTime = (chainlinkObservations.length == 0) ?
314           subtract(now, lastUpdateTime) : subtract(now, chainlinkObservations[chainlinkObservations.length - 1].timestamp);
315 
316         // Check delay between calls
317         require(elapsedTime >= periodSize, "ChainlinkTWAP/wait-more");
318 
319         int256 aggregatorResult     = chainlinkAggregator.latestAnswer();
320         uint256 aggregatorTimestamp = chainlinkAggregator.latestTimestamp();
321 
322         require(aggregatorResult > 0, "ChainlinkTWAP/invalid-feed-result");
323         require(both(aggregatorTimestamp > 0, aggregatorTimestamp > linkAggregatorTimestamp), "ChainlinkTWAP/invalid-timestamp");
324 
325         // Get current first observation timestamp
326         uint256 timeSinceFirst;
327         if (updates > 0) {
328           ChainlinkObservation memory firstUniswapObservation = getFirstObservationInWindow();
329           timeSinceFirst = subtract(now, firstUniswapObservation.timestamp);
330         } else {
331           timeSinceFirst = elapsedTime;
332         }
333 
334         // Update the observations array
335         updateObservations(elapsedTime, uint256(aggregatorResult));
336 
337         // Update var state
338         medianResult            = converterResultCumulative / timeSinceFirst;
339         updates                 = addition(updates, 1);
340         linkAggregatorTimestamp = aggregatorTimestamp;
341         lastUpdateTime          = now;
342 
343         emit UpdateResult(medianResult);
344 
345         // Get final fee receiver
346         address finalFeeReceiver = (feeReceiver == address(0)) ? msg.sender : feeReceiver;
347 
348         // Send the reward
349         rewardRelayer.reimburseCaller(finalFeeReceiver);
350     }
351     /**
352     * @notice Push new observation data in the observation array
353     * @param timeElapsedSinceLatest Time elapsed between now and the earliest observation in the window
354     * @param newResult Latest result coming from Chainlink
355     **/
356     function updateObservations(
357       uint256 timeElapsedSinceLatest,
358       uint256 newResult
359     ) internal {
360         // Compute the new time adjusted result
361         uint256 newTimeAdjustedResult = multiply(newResult, timeElapsedSinceLatest);
362         // Add Chainlink observation
363         chainlinkObservations.push(ChainlinkObservation(now, newTimeAdjustedResult));
364         // Add the new update
365         converterResultCumulative = addition(converterResultCumulative, newTimeAdjustedResult);
366 
367         // Subtract the earliest update
368         if (updates >= granularity) {
369           ChainlinkObservation memory chainlinkObservation = getFirstObservationInWindow();
370           converterResultCumulative = subtract(converterResultCumulative, chainlinkObservation.timeAdjustedResult);
371         }
372     }
373 }