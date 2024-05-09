1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of /nix/store/n0zrh7hav4swn38ckv0y2panmrlaxy1s-geb-fsm/dapp/geb-fsm/src/OSM.sol
4 pragma solidity =0.6.7;
5 
6 ////// /nix/store/3d3msxain9q01swpn63dsh9wl2hsal24-geb-treasury-reimbursement/dapp/geb-treasury-reimbursement/src/math/GebMath.sol
7 /* pragma solidity 0.6.7; */
8 
9 contract GebMath {
10     uint256 public constant RAY = 10 ** 27;
11     uint256 public constant WAD = 10 ** 18;
12 
13     function ray(uint x) public pure returns (uint z) {
14         z = multiply(x, 10 ** 9);
15     }
16     function rad(uint x) public pure returns (uint z) {
17         z = multiply(x, 10 ** 27);
18     }
19     function minimum(uint x, uint y) public pure returns (uint z) {
20         z = (x <= y) ? x : y;
21     }
22     function addition(uint x, uint y) public pure returns (uint z) {
23         z = x + y;
24         require(z >= x, "uint-uint-add-overflow");
25     }
26     function subtract(uint x, uint y) public pure returns (uint z) {
27         z = x - y;
28         require(z <= x, "uint-uint-sub-underflow");
29     }
30     function multiply(uint x, uint y) public pure returns (uint z) {
31         require(y == 0 || (z = x * y) / y == x, "uint-uint-mul-overflow");
32     }
33     function rmultiply(uint x, uint y) public pure returns (uint z) {
34         z = multiply(x, y) / RAY;
35     }
36     function rdivide(uint x, uint y) public pure returns (uint z) {
37         z = multiply(x, RAY) / y;
38     }
39     function wdivide(uint x, uint y) public pure returns (uint z) {
40         z = multiply(x, WAD) / y;
41     }
42     function wmultiply(uint x, uint y) public pure returns (uint z) {
43         z = multiply(x, y) / WAD;
44     }
45     function rpower(uint x, uint n, uint base) public pure returns (uint z) {
46         assembly {
47             switch x case 0 {switch n case 0 {z := base} default {z := 0}}
48             default {
49                 switch mod(n, 2) case 0 { z := base } default { z := x }
50                 let half := div(base, 2)  // for rounding.
51                 for { n := div(n, 2) } n { n := div(n,2) } {
52                     let xx := mul(x, x)
53                     if iszero(eq(div(xx, x), x)) { revert(0,0) }
54                     let xxRound := add(xx, half)
55                     if lt(xxRound, xx) { revert(0,0) }
56                     x := div(xxRound, base)
57                     if mod(n,2) {
58                         let zx := mul(z, x)
59                         if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
60                         let zxRound := add(zx, half)
61                         if lt(zxRound, zx) { revert(0,0) }
62                         z := div(zxRound, base)
63                     }
64                 }
65             }
66         }
67     }
68 }
69 
70 ////// /nix/store/3d3msxain9q01swpn63dsh9wl2hsal24-geb-treasury-reimbursement/dapp/geb-treasury-reimbursement/src/reimbursement/NoSetupNoAuthIncreasingTreasuryReimbursement.sol
71 /* pragma solidity 0.6.7; */
72 
73 /* import "../math/GebMath.sol"; */
74 
75 abstract contract StabilityFeeTreasuryLike_2 {
76     function getAllowance(address) virtual external view returns (uint, uint);
77     function systemCoin() virtual external view returns (address);
78     function pullFunds(address, address, uint) virtual external;
79 }
80 
81 contract NoSetupNoAuthIncreasingTreasuryReimbursement is GebMath {
82     // --- Variables ---
83     // Starting reward for the fee receiver/keeper
84     uint256 public baseUpdateCallerReward;          // [wad]
85     // Max possible reward for the fee receiver/keeper
86     uint256 public maxUpdateCallerReward;           // [wad]
87     // Max delay taken into consideration when calculating the adjusted reward
88     uint256 public maxRewardIncreaseDelay;          // [seconds]
89     // Rate applied to baseUpdateCallerReward every extra second passed beyond a certain point (e.g next time when a specific function needs to be called)
90     uint256 public perSecondCallerRewardIncrease;   // [ray]
91 
92     // SF treasury
93     StabilityFeeTreasuryLike_2  public treasury;
94 
95     // --- Events ---
96     event ModifyParameters(
97       bytes32 parameter,
98       address addr
99     );
100     event ModifyParameters(
101       bytes32 parameter,
102       uint256 val
103     );
104     event FailRewardCaller(bytes revertReason, address feeReceiver, uint256 amount);
105 
106     constructor() public {
107         maxRewardIncreaseDelay = uint(-1);
108     }
109 
110     // --- Boolean Logic ---
111     function either(bool x, bool y) internal pure returns (bool z) {
112         assembly{ z := or(x, y)}
113     }
114     function both(bool x, bool y) internal pure returns (bool z) {
115         assembly{ z := and(x, y)}
116     }
117 
118     // --- Treasury ---
119     /**
120     * @notice This returns the stability fee treasury allowance for this contract by taking the minimum between the per block and the total allowances
121     **/
122     function treasuryAllowance() public view returns (uint256) {
123         (uint total, uint perBlock) = treasury.getAllowance(address(this));
124         return minimum(total, perBlock);
125     }
126     /*
127     * @notice Get the SF reward that can be sent to a function caller right now
128     * @param timeOfLastUpdate The last time when the function that the treasury pays for has been updated
129     * @param defaultDelayBetweenCalls Enforced delay between calls to the function for which the treasury reimburses callers
130     */
131     function getCallerReward(uint256 timeOfLastUpdate, uint256 defaultDelayBetweenCalls) public view returns (uint256) {
132         // If the rewards are null or if the time of the last update is in the future or present, return 0
133         bool nullRewards = (baseUpdateCallerReward == 0 && maxUpdateCallerReward == 0);
134         if (either(timeOfLastUpdate >= now, nullRewards)) return 0;
135 
136         // If the time elapsed is smaller than defaultDelayBetweenCalls or if the base reward is zero, return 0
137         uint256 timeElapsed = (timeOfLastUpdate == 0) ? defaultDelayBetweenCalls : subtract(now, timeOfLastUpdate);
138         if (either(timeElapsed < defaultDelayBetweenCalls, baseUpdateCallerReward == 0)) {
139             return 0;
140         }
141 
142         // If too much time elapsed, return the max reward
143         uint256 adjustedTime      = subtract(timeElapsed, defaultDelayBetweenCalls);
144         uint256 maxPossibleReward = minimum(maxUpdateCallerReward, treasuryAllowance() / RAY);
145         if (adjustedTime > maxRewardIncreaseDelay) {
146             return maxPossibleReward;
147         }
148 
149         // Calculate the reward
150         uint256 calculatedReward = baseUpdateCallerReward;
151         if (adjustedTime > 0) {
152             calculatedReward = rmultiply(rpower(perSecondCallerRewardIncrease, adjustedTime, RAY), calculatedReward);
153         }
154 
155         // If the reward is higher than max, set it to max
156         if (calculatedReward > maxPossibleReward) {
157             calculatedReward = maxPossibleReward;
158         }
159         return calculatedReward;
160     }
161     /**
162     * @notice Send a stability fee reward to an address
163     * @param proposedFeeReceiver The SF receiver
164     * @param reward The system coin amount to send
165     **/
166     function rewardCaller(address proposedFeeReceiver, uint256 reward) internal {
167         // If the receiver is the treasury itself or if the treasury is null or if the reward is zero, return
168         if (address(treasury) == proposedFeeReceiver) return;
169         if (either(address(treasury) == address(0), reward == 0)) return;
170 
171         // Determine the actual receiver and send funds
172         address finalFeeReceiver = (proposedFeeReceiver == address(0)) ? msg.sender : proposedFeeReceiver;
173         try treasury.pullFunds(finalFeeReceiver, treasury.systemCoin(), reward) {}
174         catch(bytes memory revertReason) {
175             emit FailRewardCaller(revertReason, finalFeeReceiver, reward);
176         }
177     }
178 }
179 
180 ////// /nix/store/n0zrh7hav4swn38ckv0y2panmrlaxy1s-geb-fsm/dapp/geb-fsm/src/OSM.sol
181 /* pragma solidity 0.6.7; */
182 
183 /* import "geb-treasury-reimbursement/reimbursement/NoSetupNoAuthIncreasingTreasuryReimbursement.sol"; */
184 
185 abstract contract DSValueLike_2 {
186     function getResultWithValidity() virtual external view returns (uint256, bool);
187 }
188 abstract contract FSMWrapperLike_2 {
189     function renumerateCaller(address) virtual external;
190 }
191 
192 contract OSM {
193     // --- Auth ---
194     mapping (address => uint) public authorizedAccounts;
195     /**
196      * @notice Add auth to an account
197      * @param account Account to add auth to
198      */
199     function addAuthorization(address account) virtual external isAuthorized {
200         authorizedAccounts[account] = 1;
201         emit AddAuthorization(account);
202     }
203     /**
204      * @notice Remove auth from an account
205      * @param account Account to remove auth from
206      */
207     function removeAuthorization(address account) virtual external isAuthorized {
208         authorizedAccounts[account] = 0;
209         emit RemoveAuthorization(account);
210     }
211     /**
212     * @notice Checks whether msg.sender can call an authed function
213     **/
214     modifier isAuthorized {
215         require(authorizedAccounts[msg.sender] == 1, "OSM/account-not-authorized");
216         _;
217     }
218 
219     // --- Stop ---
220     uint256 public stopped;
221     modifier stoppable { require(stopped == 0, "OSM/is-stopped"); _; }
222 
223     // --- Variables ---
224     address public priceSource;
225     uint16  constant ONE_HOUR = uint16(3600);
226     uint16  public updateDelay = ONE_HOUR;
227     uint64  public lastUpdateTime;
228 
229     // --- Structs ---
230     struct Feed {
231         uint128 value;
232         uint128 isValid;
233     }
234 
235     Feed currentFeed;
236     Feed nextFeed;
237 
238     // --- Events ---
239     event AddAuthorization(address account);
240     event RemoveAuthorization(address account);
241     event ModifyParameters(bytes32 parameter, uint256 val);
242     event ModifyParameters(bytes32 parameter, address val);
243     event Start();
244     event Stop();
245     event ChangePriceSource(address priceSource);
246     event ChangeDelay(uint16 delay);
247     event RestartValue();
248     event UpdateResult(uint256 newMedian, uint256 lastUpdateTime);
249 
250     constructor (address priceSource_) public {
251         authorizedAccounts[msg.sender] = 1;
252         priceSource = priceSource_;
253         if (priceSource != address(0)) {
254           (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
255           if (hasValidValue) {
256             nextFeed = Feed(uint128(uint(priceFeedValue)), 1);
257             currentFeed = nextFeed;
258             lastUpdateTime = latestUpdateTime(currentTime());
259             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
260           }
261         }
262         emit AddAuthorization(msg.sender);
263         emit ChangePriceSource(priceSource);
264     }
265 
266     // --- Math ---
267     function addition(uint64 x, uint64 y) internal pure returns (uint64 z) {
268         z = x + y;
269         require(z >= x);
270     }
271 
272     // --- Core Logic ---
273     /*
274     * @notify Stop the OSM
275     */
276     function stop() external isAuthorized {
277         stopped = 1;
278         emit Stop();
279     }
280     /*
281     * @notify Start the OSM
282     */
283     function start() external isAuthorized {
284         stopped = 0;
285         emit Start();
286     }
287 
288     /*
289     * @notify Change the oracle from which the OSM reads
290     * @param priceSource_ The address of the oracle from which the OSM reads
291     */
292     function changePriceSource(address priceSource_) external isAuthorized {
293         priceSource = priceSource_;
294         emit ChangePriceSource(priceSource);
295     }
296 
297     /*
298     * @notify Helper that returns the current block timestamp
299     */
300     function currentTime() internal view returns (uint) {
301         return block.timestamp;
302     }
303 
304     /*
305     * @notify Return the latest update time
306     * @param timestamp Custom reference timestamp to determine the latest update time from
307     */
308     function latestUpdateTime(uint timestamp) internal view returns (uint64) {
309         require(updateDelay != 0, "OSM/update-delay-is-zero");
310         return uint64(timestamp - (timestamp % updateDelay));
311     }
312 
313     /*
314     * @notify Change the delay between updates
315     * @param delay The new delay
316     */
317     function changeDelay(uint16 delay) external isAuthorized {
318         require(delay > 0, "OSM/delay-is-zero");
319         updateDelay = delay;
320         emit ChangeDelay(updateDelay);
321     }
322 
323     /*
324     * @notify Restart/set to zero the feeds stored in the OSM
325     */
326     function restartValue() external isAuthorized {
327         currentFeed = nextFeed = Feed(0, 0);
328         stopped = 1;
329         emit RestartValue();
330     }
331 
332     /*
333     * @notify View function that returns whether the delay between calls has been passed
334     */
335     function passedDelay() public view returns (bool ok) {
336         return currentTime() >= uint(addition(lastUpdateTime, uint64(updateDelay)));
337     }
338 
339     /*
340     * @notify Update the price feeds inside the OSM
341     */
342     function updateResult() virtual external stoppable {
343         // Check if the delay passed
344         require(passedDelay(), "OSM/not-passed");
345         // Read the price from the median
346         (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
347         // If the value is valid, update storage
348         if (hasValidValue) {
349             // Update state
350             currentFeed    = nextFeed;
351             nextFeed       = Feed(uint128(uint(priceFeedValue)), 1);
352             lastUpdateTime = latestUpdateTime(currentTime());
353             // Emit event
354             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
355         }
356     }
357 
358     // --- Getters ---
359     /*
360     * @notify Internal helper that reads a price and its validity from the priceSource
361     */
362     function getPriceSourceUpdate() internal view returns (uint256, bool) {
363         try DSValueLike_2(priceSource).getResultWithValidity() returns (uint256 priceFeedValue, bool hasValidValue) {
364           return (priceFeedValue, hasValidValue);
365         }
366         catch(bytes memory) {
367           return (0, false);
368         }
369     }
370     /*
371     * @notify Return the current feed value and its validity
372     */
373     function getResultWithValidity() external view returns (uint256,bool) {
374         return (uint(currentFeed.value), currentFeed.isValid == 1);
375     }
376     /*
377     * @notify Return the next feed's value and its validity
378     */
379     function getNextResultWithValidity() external view returns (uint256,bool) {
380         return (nextFeed.value, nextFeed.isValid == 1);
381     }
382     /*
383     * @notify Return the current feed's value only if it's valid, otherwise revert
384     */
385     function read() external view returns (uint256) {
386         require(currentFeed.isValid == 1, "OSM/no-current-value");
387         return currentFeed.value;
388     }
389 }
390 
391 contract SelfFundedOSM is OSM, NoSetupNoAuthIncreasingTreasuryReimbursement {
392     constructor (address priceSource_) public OSM(priceSource_) {}
393 
394     // --- Administration ---
395     /*
396     * @notify Modify a uint256 parameter
397     * @param parameter The parameter name
398     * @param val The new value for the parameter
399     */
400     function modifyParameters(bytes32 parameter, uint256 val) external isAuthorized {
401         if (parameter == "baseUpdateCallerReward") {
402           require(val < maxUpdateCallerReward, "SelfFundedOSM/invalid-base-caller-reward");
403           baseUpdateCallerReward = val;
404         }
405         else if (parameter == "maxUpdateCallerReward") {
406           require(val >= baseUpdateCallerReward, "SelfFundedOSM/invalid-max-reward");
407           maxUpdateCallerReward = val;
408         }
409         else if (parameter == "perSecondCallerRewardIncrease") {
410           require(val >= RAY, "SelfFundedOSM/invalid-reward-increase");
411           perSecondCallerRewardIncrease = val;
412         }
413         else if (parameter == "maxRewardIncreaseDelay") {
414           require(val > 0, "SelfFundedOSM/invalid-max-increase-delay");
415           maxRewardIncreaseDelay = val;
416         }
417         else revert("SelfFundedOSM/modify-unrecognized-param");
418         emit ModifyParameters(parameter, val);
419     }
420     /*
421     * @notify Modify an address parameter
422     * @param parameter The parameter name
423     * @param val The new value for the parameter
424     */
425     function modifyParameters(bytes32 parameter, address val) external isAuthorized {
426         if (parameter == "treasury") {
427           require(val != address(0), "SelfFundedOSM/invalid-treasury");
428           treasury = StabilityFeeTreasuryLike_2(val);
429         }
430         else revert("SelfFundedOSM/modify-unrecognized-param");
431         emit ModifyParameters(parameter, val);
432     }
433 
434     /*
435     * @notify Update the price feeds inside the OSM
436     */
437     function updateResult() override external stoppable {
438         // Check if the delay passed
439         require(passedDelay(), "SelfFundedOSM/not-passed");
440         // Read the price from the median
441         (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
442         // If the value is valid, update storage
443         if (hasValidValue) {
444             // Get the caller's reward
445             uint256 callerReward = getCallerReward(lastUpdateTime, updateDelay);
446             // Update state
447             currentFeed    = nextFeed;
448             nextFeed       = Feed(uint128(uint(priceFeedValue)), 1);
449             lastUpdateTime = latestUpdateTime(currentTime());
450             // Emit event
451             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
452             // Pay the caller
453             rewardCaller(msg.sender, callerReward);
454         }
455     }
456 }
457 
458 contract ExternallyFundedOSM is OSM {
459     // --- Variables ---
460     FSMWrapperLike_2 public fsmWrapper;
461 
462     // --- Evemts ---
463     event FailRenumerateCaller(address wrapper, address caller);
464 
465     constructor (address priceSource_) public OSM(priceSource_) {}
466 
467     // --- Administration ---
468     /*
469     * @notify Modify an address parameter
470     * @param parameter The parameter name
471     * @param val The new value for the parameter
472     */
473     function modifyParameters(bytes32 parameter, address val) external isAuthorized {
474         if (parameter == "fsmWrapper") {
475           require(val != address(0), "ExternallyFundedOSM/invalid-fsm-wrapper");
476           fsmWrapper = FSMWrapperLike_2(val);
477         }
478         else revert("ExternallyFundedOSM/modify-unrecognized-param");
479         emit ModifyParameters(parameter, val);
480     }
481 
482     /*
483     * @notify Update the price feeds inside the OSM
484     */
485     function updateResult() override external stoppable {
486         // Check if the delay passed
487         require(passedDelay(), "ExternallyFundedOSM/not-passed");
488         // Check that the wrapper is set
489         require(address(fsmWrapper) != address(0), "ExternallyFundedOSM/null-wrapper");
490         // Read the price from the median
491         (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
492         // If the value is valid, update storage
493         if (hasValidValue) {
494             // Update state
495             currentFeed    = nextFeed;
496             nextFeed       = Feed(uint128(uint(priceFeedValue)), 1);
497             lastUpdateTime = latestUpdateTime(currentTime());
498             // Emit event
499             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
500             // Pay the caller
501             try fsmWrapper.renumerateCaller(msg.sender) {}
502             catch(bytes memory revertReason) {
503               emit FailRenumerateCaller(address(fsmWrapper), msg.sender);
504             }
505         }
506     }
507 }
