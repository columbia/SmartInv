1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of /nix/store/n0zrh7hav4swn38ckv0y2panmrlaxy1s-geb-fsm/dapp/geb-fsm/src/DSM.sol
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
180 ////// /nix/store/n0zrh7hav4swn38ckv0y2panmrlaxy1s-geb-fsm/dapp/geb-fsm/src/DSM.sol
181 /* pragma solidity 0.6.7; */
182 
183 /* import "geb-treasury-reimbursement/reimbursement/NoSetupNoAuthIncreasingTreasuryReimbursement.sol"; */
184 
185 abstract contract DSValueLike_1 {
186     function getResultWithValidity() virtual external view returns (uint256, bool);
187 }
188 abstract contract FSMWrapperLike_1 {
189     function renumerateCaller(address) virtual external;
190 }
191 
192 contract DSM {
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
215         require(authorizedAccounts[msg.sender] == 1, "DSM/account-not-authorized");
216         _;
217     }
218 
219     // --- Stop ---
220     uint256 public stopped;
221     modifier stoppable { require(stopped == 0, "DSM/is-stopped"); _; }
222 
223     // --- Variables ---
224     address public priceSource;
225     uint16  public updateDelay = ONE_HOUR;      // [seconds]
226     uint64  public lastUpdateTime;              // [timestamp]
227     uint256 public newPriceDeviation;           // [wad]
228 
229     uint16  constant ONE_HOUR = uint16(3600);   // [seconds]
230 
231     // --- Structs ---
232     struct Feed {
233         uint128 value;
234         uint128 isValid;
235     }
236 
237     Feed currentFeed;
238     Feed nextFeed;
239 
240     // --- Events ---
241     event AddAuthorization(address account);
242     event RemoveAuthorization(address account);
243     event ModifyParameters(bytes32 parameter, uint256 val);
244     event ModifyParameters(bytes32 parameter, address val);
245     event Start();
246     event Stop();
247     event ChangePriceSource(address priceSource);
248     event ChangeDeviation(uint deviation);
249     event ChangeDelay(uint16 delay);
250     event RestartValue();
251     event UpdateResult(uint256 newMedian, uint256 lastUpdateTime);
252 
253     constructor (address priceSource_, uint256 deviation) public {
254         require(deviation > 0 && deviation < WAD, "DSM/invalid-deviation");
255 
256         authorizedAccounts[msg.sender] = 1;
257 
258         priceSource       = priceSource_;
259         newPriceDeviation = deviation;
260 
261         if (priceSource != address(0)) {
262           // Read from the median
263           (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
264           // If the price is valid, update state
265           if (hasValidValue) {
266             nextFeed = Feed(uint128(uint(priceFeedValue)), 1);
267             currentFeed = nextFeed;
268             lastUpdateTime = latestUpdateTime(currentTime());
269             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
270           }
271         }
272 
273         emit AddAuthorization(msg.sender);
274         emit ChangePriceSource(priceSource);
275         emit ChangeDeviation(deviation);
276     }
277 
278     // --- DSM Specific Math ---
279     uint256 private constant WAD = 10 ** 18;
280 
281     function add(uint64 x, uint64 y) internal pure returns (uint64 z) {
282         z = x + y;
283         require(z >= x);
284     }
285     function sub(uint x, uint y) private pure returns (uint z) {
286         z = x - y;
287         require(z <= x, "uint-uint-sub-underflow");
288     }
289     function mul(uint x, uint y) private pure returns (uint z) {
290         require(y == 0 || (z = x * y) / y == x, "uint-uint-mul-overflow");
291     }
292     function wmul(uint x, uint y) private pure returns (uint z) {
293         z = mul(x, y) / WAD;
294     }
295 
296     // --- Core Logic ---
297     /*
298     * @notify Stop the DSM
299     */
300     function stop() external isAuthorized {
301         stopped = 1;
302         emit Stop();
303     }
304     /*
305     * @notify Start the DSM
306     */
307     function start() external isAuthorized {
308         stopped = 0;
309         emit Start();
310     }
311 
312     /*
313     * @notify Change the oracle from which the DSM reads
314     * @param priceSource_ The address of the oracle from which the DSM reads
315     */
316     function changePriceSource(address priceSource_) external isAuthorized {
317         priceSource = priceSource_;
318         emit ChangePriceSource(priceSource);
319     }
320 
321     /*
322     * @notify Helper that returns the current block timestamp
323     */
324     function currentTime() internal view returns (uint) {
325         return block.timestamp;
326     }
327 
328     /*
329     * @notify Return the latest update time
330     * @param timestamp Custom reference timestamp to determine the latest update time from
331     */
332     function latestUpdateTime(uint timestamp) internal view returns (uint64) {
333         require(updateDelay != 0, "DSM/update-delay-is-zero");
334         return uint64(timestamp - (timestamp % updateDelay));
335     }
336 
337     /*
338     * @notify Change the deviation supported for the next price
339     * @param deviation Allowed deviation for the next price compared to the current one
340     */
341     function changeNextPriceDeviation(uint deviation) external isAuthorized {
342         require(deviation > 0 && deviation < WAD, "DSM/invalid-deviation");
343         newPriceDeviation = deviation;
344         emit ChangeDeviation(deviation);
345     }
346 
347     /*
348     * @notify Change the delay between updates
349     * @param delay The new delay
350     */
351     function changeDelay(uint16 delay) external isAuthorized {
352         require(delay > 0, "DSM/delay-is-zero");
353         updateDelay = delay;
354         emit ChangeDelay(updateDelay);
355     }
356 
357     /*
358     * @notify Restart/set to zero the feeds stored in the DSM
359     */
360     function restartValue() external isAuthorized {
361         currentFeed = nextFeed = Feed(0, 0);
362         stopped = 1;
363         emit RestartValue();
364     }
365 
366     /*
367     * @notify View function that returns whether the delay between calls has been passed
368     */
369     function passedDelay() public view returns (bool ok) {
370         return currentTime() >= uint(add(lastUpdateTime, uint64(updateDelay)));
371     }
372 
373     /*
374     * @notify Update the price feeds inside the DSM
375     */
376     function updateResult() virtual external stoppable {
377         // Check if the delay passed
378         require(passedDelay(), "DSM/not-passed");
379         // Read the price from the median
380         (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
381         // If the value is valid, update storage
382         if (hasValidValue) {
383             // Update state
384             currentFeed.isValid = nextFeed.isValid;
385             currentFeed.value   = getNextBoundedPrice();
386             nextFeed            = Feed(uint128(priceFeedValue), 1);
387             lastUpdateTime      = latestUpdateTime(currentTime());
388             // Emit event
389             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
390         }
391     }
392 
393     // --- Getters ---
394     /*
395     * @notify Internal helper that reads a price and its validity from the priceSource
396     */
397     function getPriceSourceUpdate() internal view returns (uint256, bool) {
398         try DSValueLike_1(priceSource).getResultWithValidity() returns (uint256 priceFeedValue, bool hasValidValue) {
399           return (priceFeedValue, hasValidValue);
400         }
401         catch(bytes memory) {
402           return (0, false);
403         }
404     }
405 
406     /*
407     * @notify View function that returns what the next bounded price would be (taking into account the deviation set in this contract)
408     */
409     function getNextBoundedPrice() public view returns (uint128 boundedPrice) {
410         boundedPrice = nextFeed.value;
411         if (currentFeed.value == 0) return boundedPrice;
412 
413         uint128 lowerBound = uint128(wmul(uint(currentFeed.value), newPriceDeviation));
414         uint128 upperBound = uint128(wmul(uint(currentFeed.value), sub(mul(uint(2), WAD), newPriceDeviation)));
415 
416         if (nextFeed.value < lowerBound) {
417           boundedPrice = lowerBound;
418         } else if (nextFeed.value > upperBound) {
419           boundedPrice = upperBound;
420         }
421     }
422 
423     /*
424     * @notify Returns the lower bound for the upcoming price (taking into account the deviation var)
425     */
426     function getNextPriceLowerBound() public view returns (uint128) {
427         return uint128(wmul(uint(currentFeed.value), newPriceDeviation));
428     }
429 
430     /*
431     * @notify Returns the upper bound for the upcoming price (taking into account the deviation var)
432     */
433     function getNextPriceUpperBound() public view returns (uint128) {
434         return uint128(wmul(uint(currentFeed.value), sub(mul(uint(2), WAD), newPriceDeviation)));
435     }
436 
437     /*
438     * @notify Return the current feed value and its validity
439     */
440     function getResultWithValidity() external view returns (uint256, bool) {
441         return (uint(currentFeed.value), currentFeed.isValid == 1);
442     }
443     /*
444     * @notify Return the next feed's value and its validity
445     */
446     function getNextResultWithValidity() external view returns (uint256, bool) {
447         return (nextFeed.value, nextFeed.isValid == 1);
448     }
449     /*
450     * @notify Return the current feed's value only if it's valid, otherwise revert
451     */
452     function read() external view returns (uint256) {
453         require(currentFeed.isValid == 1, "DSM/no-current-value");
454         return currentFeed.value;
455     }
456 }
457 
458 contract SelfFundedDSM is DSM, NoSetupNoAuthIncreasingTreasuryReimbursement {
459     constructor (address priceSource_, uint256 deviation) public DSM(priceSource_, deviation) {}
460 
461     // --- Administration ---
462     /*
463     * @notify Modify a uint256 parameter
464     * @param parameter The parameter name
465     * @param val The new value for the parameter
466     */
467     function modifyParameters(bytes32 parameter, uint256 val) external isAuthorized {
468         if (parameter == "baseUpdateCallerReward") {
469           require(val < maxUpdateCallerReward, "SelfFundedDSM/invalid-base-caller-reward");
470           baseUpdateCallerReward = val;
471         }
472         else if (parameter == "maxUpdateCallerReward") {
473           require(val >= baseUpdateCallerReward, "SelfFundedDSM/invalid-max-reward");
474           maxUpdateCallerReward = val;
475         }
476         else if (parameter == "perSecondCallerRewardIncrease") {
477           require(val >= RAY, "SelfFundedDSM/invalid-reward-increase");
478           perSecondCallerRewardIncrease = val;
479         }
480         else if (parameter == "maxRewardIncreaseDelay") {
481           require(val > 0, "SelfFundedDSM/invalid-max-increase-delay");
482           maxRewardIncreaseDelay = val;
483         }
484         else revert("SelfFundedDSM/modify-unrecognized-param");
485         emit ModifyParameters(parameter, val);
486     }
487     /*
488     * @notify Modify an address parameter
489     * @param parameter The parameter name
490     * @param val The new value for the parameter
491     */
492     function modifyParameters(bytes32 parameter, address val) external isAuthorized {
493         if (parameter == "treasury") {
494           require(val != address(0), "SelfFundedDSM/invalid-treasury");
495           treasury = StabilityFeeTreasuryLike_2(val);
496         }
497         else revert("SelfFundedDSM/modify-unrecognized-param");
498         emit ModifyParameters(parameter, val);
499     }
500 
501     // --- Core Logic ---
502     /*
503     * @notify Update the price feeds inside the DSM
504     */
505     function updateResult() override external stoppable {
506         // Check if the delay passed
507         require(passedDelay(), "SelfFundedDSM/not-passed");
508         // Read the price from the median
509         (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
510         // If the value is valid, update storage
511         if (hasValidValue) {
512             // Get the caller's reward
513             uint256 callerReward = getCallerReward(lastUpdateTime, updateDelay);
514             // Update state
515             currentFeed.isValid = nextFeed.isValid;
516             currentFeed.value   = getNextBoundedPrice();
517             nextFeed            = Feed(uint128(priceFeedValue), 1);
518             lastUpdateTime      = latestUpdateTime(currentTime());
519             // Emit event
520             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
521             // Pay the caller
522             rewardCaller(msg.sender, callerReward);
523         }
524     }
525 }
526 
527 contract ExternallyFundedDSM is DSM {
528     // --- Variables ---
529     // The wrapper for this DSM. It can relay treasury rewards
530     FSMWrapperLike_1 public fsmWrapper;
531 
532     // --- Evemts ---
533     event FailRenumerateCaller(address wrapper, address caller);
534 
535     constructor (address priceSource_, uint256 deviation) public DSM(priceSource_, deviation) {}
536 
537     // --- Administration ---
538     /*
539     * @notify Modify an address parameter
540     * @param parameter The parameter name
541     * @param val The new value for the parameter
542     */
543     function modifyParameters(bytes32 parameter, address val) external isAuthorized {
544         if (parameter == "fsmWrapper") {
545           require(val != address(0), "ExternallyFundedDSM/invalid-fsm-wrapper");
546           fsmWrapper = FSMWrapperLike_1(val);
547         }
548         else revert("ExternallyFundedDSM/modify-unrecognized-param");
549         emit ModifyParameters(parameter, val);
550     }
551 
552     // --- Core Logic ---
553     /*
554     * @notify Update the price feeds inside the DSM
555     */
556     function updateResult() override external stoppable {
557         // Check if the delay passed
558         require(passedDelay(), "ExternallyFundedDSM/not-passed");
559         // Check that the wrapper is set
560         require(address(fsmWrapper) != address(0), "ExternallyFundedDSM/null-wrapper");
561         // Read the price from the median
562         (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
563         // If the value is valid, update storage
564         if (hasValidValue) {
565             // Update state
566             currentFeed.isValid = nextFeed.isValid;
567             currentFeed.value   = getNextBoundedPrice();
568             nextFeed            = Feed(uint128(priceFeedValue), 1);
569             lastUpdateTime      = latestUpdateTime(currentTime());
570             // Emit event
571             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
572             // Pay the caller
573             try fsmWrapper.renumerateCaller(msg.sender) {}
574             catch(bytes memory revertReason) {
575               emit FailRenumerateCaller(address(fsmWrapper), msg.sender);
576             }
577         }
578     }
579 }
