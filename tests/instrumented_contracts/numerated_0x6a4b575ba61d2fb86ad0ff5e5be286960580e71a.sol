1 pragma solidity 0.6.7;
2 
3 interface AggregatorInterface {
4   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
5   event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
6 
7   function latestAnswer() external returns (int256);
8   function latestTimestamp() external returns (uint256);
9   function latestRound() external returns (uint256);
10   function getAnswer(uint256 roundId) external returns (int256);
11   function getTimestamp(uint256 roundId) external returns (uint256);
12 
13   // post-Historic
14 
15   function decimals() external returns (uint8);
16   function getRoundData(uint256 _roundId)
17     external
18     returns (
19       uint256 roundId,
20       int256 answer,
21       uint256 startedAt,
22       uint256 updatedAt,
23       uint256 answeredInRound
24     );
25   function latestRoundData()
26     external
27     returns (
28       uint256 roundId,
29       int256 answer,
30       uint256 startedAt,
31       uint256 updatedAt,
32       uint256 answeredInRound
33     );
34 }
35 
36 contract GebMath {
37     uint256 public constant RAY = 10 ** 27;
38     uint256 public constant WAD = 10 ** 18;
39 
40     function ray(uint x) public pure returns (uint z) {
41         z = multiply(x, 10 ** 9);
42     }
43     function rad(uint x) public pure returns (uint z) {
44         z = multiply(x, 10 ** 27);
45     }
46     function minimum(uint x, uint y) public pure returns (uint z) {
47         z = (x <= y) ? x : y;
48     }
49     function addition(uint x, uint y) public pure returns (uint z) {
50         z = x + y;
51         require(z >= x, "uint-uint-add-overflow");
52     }
53     function subtract(uint x, uint y) public pure returns (uint z) {
54         z = x - y;
55         require(z <= x, "uint-uint-sub-underflow");
56     }
57     function multiply(uint x, uint y) public pure returns (uint z) {
58         require(y == 0 || (z = x * y) / y == x, "uint-uint-mul-overflow");
59     }
60     function rmultiply(uint x, uint y) public pure returns (uint z) {
61         z = multiply(x, y) / RAY;
62     }
63     function rdivide(uint x, uint y) public pure returns (uint z) {
64         z = multiply(x, RAY) / y;
65     }
66     function wdivide(uint x, uint y) public pure returns (uint z) {
67         z = multiply(x, WAD) / y;
68     }
69     function wmultiply(uint x, uint y) public pure returns (uint z) {
70         z = multiply(x, y) / WAD;
71     }
72     function rpower(uint x, uint n, uint base) public pure returns (uint z) {
73         assembly {
74             switch x case 0 {switch n case 0 {z := base} default {z := 0}}
75             default {
76                 switch mod(n, 2) case 0 { z := base } default { z := x }
77                 let half := div(base, 2)  // for rounding.
78                 for { n := div(n, 2) } n { n := div(n,2) } {
79                     let xx := mul(x, x)
80                     if iszero(eq(div(xx, x), x)) { revert(0,0) }
81                     let xxRound := add(xx, half)
82                     if lt(xxRound, xx) { revert(0,0) }
83                     x := div(xxRound, base)
84                     if mod(n,2) {
85                         let zx := mul(z, x)
86                         if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
87                         let zxRound := add(zx, half)
88                         if lt(zxRound, zx) { revert(0,0) }
89                         z := div(zxRound, base)
90                     }
91                 }
92             }
93         }
94     }
95 }
96 
97 abstract contract StabilityFeeTreasuryLike {
98     function getAllowance(address) virtual external view returns (uint, uint);
99     function systemCoin() virtual external view returns (address);
100     function pullFunds(address, address, uint) virtual external;
101 }
102 
103 contract IncreasingTreasuryReimbursement is GebMath {
104     // --- Auth ---
105     mapping (address => uint) public authorizedAccounts;
106     function addAuthorization(address account) virtual external isAuthorized {
107         authorizedAccounts[account] = 1;
108         emit AddAuthorization(account);
109     }
110     function removeAuthorization(address account) virtual external isAuthorized {
111         authorizedAccounts[account] = 0;
112         emit RemoveAuthorization(account);
113     }
114     modifier isAuthorized {
115         require(authorizedAccounts[msg.sender] == 1, "IncreasingTreasuryReimbursement/account-not-authorized");
116         _;
117     }
118 
119     // --- Variables ---
120     // Starting reward for the fee receiver/keeper
121     uint256 public baseUpdateCallerReward;          // [wad]
122     // Max possible reward for the fee receiver/keeper
123     uint256 public maxUpdateCallerReward;           // [wad]
124     // Max delay taken into consideration when calculating the adjusted reward
125     uint256 public maxRewardIncreaseDelay;          // [seconds]
126     // Rate applied to baseUpdateCallerReward every extra second passed beyond a certain point (e.g next time when a specific function needs to be called)
127     uint256 public perSecondCallerRewardIncrease;   // [ray]
128 
129     // SF treasury
130     StabilityFeeTreasuryLike  public treasury;
131 
132     // --- Events ---
133     event AddAuthorization(address account);
134     event RemoveAuthorization(address account);
135     event ModifyParameters(
136       bytes32 parameter,
137       address addr
138     );
139     event ModifyParameters(
140       bytes32 parameter,
141       uint256 val
142     );
143     event FailRewardCaller(bytes revertReason, address feeReceiver, uint256 amount);
144 
145     constructor(
146       address treasury_,
147       uint256 baseUpdateCallerReward_,
148       uint256 maxUpdateCallerReward_,
149       uint256 perSecondCallerRewardIncrease_
150     ) public {
151         if (address(treasury_) != address(0)) {
152           require(StabilityFeeTreasuryLike(treasury_).systemCoin() != address(0), "IncreasingTreasuryReimbursement/treasury-coin-not-set");
153         }
154         require(maxUpdateCallerReward_ >= baseUpdateCallerReward_, "IncreasingTreasuryReimbursement/invalid-max-caller-reward");
155         require(perSecondCallerRewardIncrease_ >= RAY, "IncreasingTreasuryReimbursement/invalid-per-second-reward-increase");
156         authorizedAccounts[msg.sender] = 1;
157 
158         treasury                        = StabilityFeeTreasuryLike(treasury_);
159         baseUpdateCallerReward          = baseUpdateCallerReward_;
160         maxUpdateCallerReward           = maxUpdateCallerReward_;
161         perSecondCallerRewardIncrease   = perSecondCallerRewardIncrease_;
162         maxRewardIncreaseDelay          = uint(-1);
163 
164         emit AddAuthorization(msg.sender);
165         emit ModifyParameters("treasury", treasury_);
166         emit ModifyParameters("baseUpdateCallerReward", baseUpdateCallerReward);
167         emit ModifyParameters("maxUpdateCallerReward", maxUpdateCallerReward);
168         emit ModifyParameters("perSecondCallerRewardIncrease", perSecondCallerRewardIncrease);
169     }
170 
171     // --- Boolean Logic ---
172     function either(bool x, bool y) internal pure returns (bool z) {
173         assembly{ z := or(x, y)}
174     }
175 
176     // --- Treasury ---
177     /**
178     * @notice This returns the stability fee treasury allowance for this contract by taking the minimum between the per block and the total allowances
179     **/
180     function treasuryAllowance() public view returns (uint256) {
181         (uint total, uint perBlock) = treasury.getAllowance(address(this));
182         return minimum(total, perBlock);
183     }
184     /*
185     * @notice Get the SF reward that can be sent to a function caller right now
186     */
187     function getCallerReward(uint256 timeOfLastUpdate, uint256 defaultDelayBetweenCalls) public view returns (uint256) {
188         bool nullRewards = (baseUpdateCallerReward == 0 && maxUpdateCallerReward == 0);
189         if (either(timeOfLastUpdate >= now, nullRewards)) return 0;
190         uint256 timeElapsed = (timeOfLastUpdate == 0) ? defaultDelayBetweenCalls : subtract(now, timeOfLastUpdate);
191         if (either(timeElapsed < defaultDelayBetweenCalls, baseUpdateCallerReward == 0)) {
192             return 0;
193         }
194         uint256 adjustedTime      = subtract(timeElapsed, defaultDelayBetweenCalls);
195         uint256 maxPossibleReward = minimum(maxUpdateCallerReward, treasuryAllowance() / RAY);
196         if (adjustedTime > maxRewardIncreaseDelay) {
197             return maxPossibleReward;
198         }
199         uint256 calculatedReward = baseUpdateCallerReward;
200         if (adjustedTime > 0) {
201             calculatedReward = rmultiply(rpower(perSecondCallerRewardIncrease, adjustedTime, RAY), calculatedReward);
202         }
203         if (calculatedReward > maxPossibleReward) {
204             calculatedReward = maxPossibleReward;
205         }
206         return calculatedReward;
207     }
208     /**
209     * @notice Send a stability fee reward to an address
210     * @param proposedFeeReceiver The SF receiver
211     * @param reward The system coin amount to send
212     **/
213     function rewardCaller(address proposedFeeReceiver, uint256 reward) internal {
214         if (address(treasury) == proposedFeeReceiver) return;
215         if (either(address(treasury) == address(0), reward == 0)) return;
216         address finalFeeReceiver = (proposedFeeReceiver == address(0)) ? msg.sender : proposedFeeReceiver;
217         try treasury.pullFunds(finalFeeReceiver, treasury.systemCoin(), reward) {}
218         catch(bytes memory revertReason) {
219             emit FailRewardCaller(revertReason, finalFeeReceiver, reward);
220         }
221     }
222 }
223 
224 contract ChainlinkPriceFeedMedianizer is IncreasingTreasuryReimbursement {
225     // --- Variables ---
226     AggregatorInterface public chainlinkAggregator;
227 
228     // Delay between updates after which the reward starts to increase
229     uint256 public periodSize;
230     // Latest median price
231     uint256 private medianPrice;                    // [wad]
232     // Timestamp of the Chainlink aggregator
233     uint256 public linkAggregatorTimestamp;
234     // Last timestamp when the median was updated
235     uint256 public  lastUpdateTime;                 // [unix timestamp]
236     // Multiplier for the Chainlink price feed in order to scaled it to 18 decimals. Default to 10 for USD price feeds
237     uint8   public  multiplier = 10;
238 
239     // You want to change these every deployment
240     uint256 public staleThreshold = 3;
241     bytes32 public symbol         = "ethusd";
242 
243     // --- Events ---
244     event UpdateResult(uint256 medianPrice, uint256 lastUpdateTime);
245 
246     constructor(
247       address aggregator,
248       address treasury_,
249       uint256 periodSize_,
250       uint256 baseUpdateCallerReward_,
251       uint256 maxUpdateCallerReward_,
252       uint256 perSecondCallerRewardIncrease_
253     ) public IncreasingTreasuryReimbursement(treasury_, baseUpdateCallerReward_, maxUpdateCallerReward_, perSecondCallerRewardIncrease_) {
254         require(aggregator != address(0), "ChainlinkPriceFeedMedianizer/null-aggregator");
255         require(multiplier >= 1, "ChainlinkPriceFeedMedianizer/null-multiplier");
256         require(periodSize_ > 0, "ChainlinkPriceFeedMedianizer/null-period-size");
257 
258         lastUpdateTime      = now;
259         periodSize          = periodSize_;
260         chainlinkAggregator = AggregatorInterface(aggregator);
261 
262         emit ModifyParameters(bytes32("periodSize"), periodSize);
263         emit ModifyParameters(bytes32("aggregator"), aggregator);
264     }
265 
266     // --- General Utils ---
267     function both(bool x, bool y) internal pure returns (bool z) {
268         assembly{ z := and(x, y)}
269     }
270 
271     // --- Administration ---
272     function modifyParameters(bytes32 parameter, uint256 data) external isAuthorized {
273         if (parameter == "baseUpdateCallerReward") baseUpdateCallerReward = data;
274         else if (parameter == "maxUpdateCallerReward") {
275           require(data > baseUpdateCallerReward, "ChainlinkPriceFeedMedianizer/invalid-max-reward");
276           maxUpdateCallerReward = data;
277         }
278         else if (parameter == "perSecondCallerRewardIncrease") {
279           require(data >= RAY, "ChainlinkPriceFeedMedianizer/invalid-reward-increase");
280           perSecondCallerRewardIncrease = data;
281         }
282         else if (parameter == "maxRewardIncreaseDelay") {
283           require(data > 0, "ChainlinkPriceFeedMedianizer/invalid-max-increase-delay");
284           maxRewardIncreaseDelay = data;
285         }
286         else if (parameter == "periodSize") {
287           require(data > 0, "ChainlinkPriceFeedMedianizer/null-period-size");
288           periodSize = data;
289         }
290         else if (parameter == "staleThreshold") {
291           require(data > 1, "ChainlinkPriceFeedMedianizer/invalid-stale-threshold");
292           staleThreshold = data;
293         }
294         else revert("ChainlinkPriceFeedMedianizer/modify-unrecognized-param");
295         emit ModifyParameters(parameter, data);
296     }
297     function modifyParameters(bytes32 parameter, address addr) external isAuthorized {
298         if (parameter == "aggregator") chainlinkAggregator = AggregatorInterface(addr);
299         else if (parameter == "treasury") {
300           require(StabilityFeeTreasuryLike(addr).systemCoin() != address(0), "ChainlinkPriceFeedMedianizer/treasury-coin-not-set");
301       	  treasury = StabilityFeeTreasuryLike(addr);
302         }
303         else revert("ChainlinkPriceFeedMedianizer/modify-unrecognized-param");
304         emit ModifyParameters(parameter, addr);
305     }
306 
307     function read() external view returns (uint256) {
308         require(both(medianPrice > 0, subtract(now, linkAggregatorTimestamp) <= multiply(periodSize, staleThreshold)), "ChainlinkPriceFeedMedianizer/invalid-price-feed");
309         return medianPrice;
310     }
311 
312     function getResultWithValidity() external view returns (uint256,bool) {
313         return (medianPrice, both(medianPrice > 0, subtract(now, linkAggregatorTimestamp) <= multiply(periodSize, staleThreshold)));
314     }
315 
316     // --- Median Updates ---
317     function updateResult(address feeReceiver) external {
318         int256 aggregatorPrice      = chainlinkAggregator.latestAnswer();
319         uint256 aggregatorTimestamp = chainlinkAggregator.latestTimestamp();
320 
321         require(aggregatorPrice > 0, "ChainlinkPriceFeedMedianizer/invalid-price-feed");
322         require(both(aggregatorTimestamp > 0, aggregatorTimestamp > linkAggregatorTimestamp), "ChainlinkPriceFeedMedianizer/invalid-timestamp");
323 
324         uint256 callerReward    = getCallerReward(lastUpdateTime, periodSize);
325         medianPrice             = multiply(uint(aggregatorPrice), 10 ** uint(multiplier));
326         linkAggregatorTimestamp = aggregatorTimestamp;
327         lastUpdateTime          = now;
328 
329         emit UpdateResult(medianPrice, lastUpdateTime);
330         rewardCaller(feeReceiver, callerReward);
331     }
332 }
333 
334 contract ChainlinkMedianETHUSD is ChainlinkPriceFeedMedianizer {
335   constructor(
336     address aggregator,
337     uint256 periodSize,
338     uint256 baseUpdateCallerReward,
339     uint256 maxUpdateCallerReward,
340     uint256 perSecondCallerRewardIncrease
341   ) ChainlinkPriceFeedMedianizer(aggregator, address(0), periodSize, baseUpdateCallerReward, maxUpdateCallerReward, perSecondCallerRewardIncrease) public {
342         symbol = "ETHUSD";
343         multiplier = 10;
344         staleThreshold = 6;
345     }
346 }