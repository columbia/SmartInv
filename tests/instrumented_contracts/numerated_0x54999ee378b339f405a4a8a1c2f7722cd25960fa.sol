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
64 
65 abstract contract StabilityFeeTreasuryLike {
66     function getAllowance(address) virtual external view returns (uint, uint);
67     function systemCoin() virtual external view returns (address);
68     function pullFunds(address, address, uint) virtual external;
69     function setTotalAllowance(address, uint256) external virtual;
70     function setPerBlockAllowance(address, uint256) external virtual;
71 }
72 
73 contract IncreasingTreasuryReimbursement is GebMath {
74     // --- Auth ---
75     mapping (address => uint) public authorizedAccounts;
76     /**
77      * @notice Add auth to an account
78      * @param account Account to add auth to
79      */
80     function addAuthorization(address account) virtual external isAuthorized {
81         authorizedAccounts[account] = 1;
82         emit AddAuthorization(account);
83     }
84     /**
85      * @notice Remove auth from an account
86      * @param account Account to remove auth from
87      */
88     function removeAuthorization(address account) virtual external isAuthorized {
89         authorizedAccounts[account] = 0;
90         emit RemoveAuthorization(account);
91     }
92     /**
93     * @notice Checks whether msg.sender can call an authed function
94     **/
95     modifier isAuthorized {
96         require(authorizedAccounts[msg.sender] == 1, "IncreasingTreasuryReimbursement/account-not-authorized");
97         _;
98     }
99 
100     // --- Variables ---
101     // Starting reward for the fee receiver/keeper
102     uint256 public baseUpdateCallerReward;          // [wad]
103     // Max possible reward for the fee receiver/keeper
104     uint256 public maxUpdateCallerReward;           // [wad]
105     // Max delay taken into consideration when calculating the adjusted reward
106     uint256 public maxRewardIncreaseDelay;          // [seconds]
107     // Rate applied to baseUpdateCallerReward every extra second passed beyond a certain point (e.g next time when a specific function needs to be called)
108     uint256 public perSecondCallerRewardIncrease;   // [ray]
109 
110     // SF treasury
111     StabilityFeeTreasuryLike  public treasury;
112 
113     // --- Events ---
114     event AddAuthorization(address account);
115     event RemoveAuthorization(address account);
116     event ModifyParameters(
117       bytes32 parameter,
118       address addr
119     );
120     event ModifyParameters(
121       bytes32 parameter,
122       uint256 val
123     );
124     event FailRewardCaller(bytes revertReason, address feeReceiver, uint256 amount);
125 
126     constructor(
127       address treasury_,
128       uint256 baseUpdateCallerReward_,
129       uint256 maxUpdateCallerReward_,
130       uint256 perSecondCallerRewardIncrease_
131     ) public {
132         if (address(treasury_) != address(0)) {
133           require(StabilityFeeTreasuryLike(treasury_).systemCoin() != address(0), "IncreasingTreasuryReimbursement/treasury-coin-not-set");
134         }
135         require(maxUpdateCallerReward_ >= baseUpdateCallerReward_, "IncreasingTreasuryReimbursement/invalid-max-caller-reward");
136         require(perSecondCallerRewardIncrease_ >= RAY, "IncreasingTreasuryReimbursement/invalid-per-second-reward-increase");
137         authorizedAccounts[msg.sender] = 1;
138 
139         treasury                        = StabilityFeeTreasuryLike(treasury_);
140         baseUpdateCallerReward          = baseUpdateCallerReward_;
141         maxUpdateCallerReward           = maxUpdateCallerReward_;
142         perSecondCallerRewardIncrease   = perSecondCallerRewardIncrease_;
143         maxRewardIncreaseDelay          = uint(-1);
144 
145         emit AddAuthorization(msg.sender);
146         emit ModifyParameters("treasury", treasury_);
147         emit ModifyParameters("baseUpdateCallerReward", baseUpdateCallerReward);
148         emit ModifyParameters("maxUpdateCallerReward", maxUpdateCallerReward);
149         emit ModifyParameters("perSecondCallerRewardIncrease", perSecondCallerRewardIncrease);
150     }
151 
152     // --- Boolean Logic ---
153     function either(bool x, bool y) internal pure returns (bool z) {
154         assembly{ z := or(x, y)}
155     }
156 
157     // --- Treasury ---
158     /**
159     * @notice This returns the stability fee treasury allowance for this contract by taking the minimum between the per block and the total allowances
160     **/
161     function treasuryAllowance() public view returns (uint256) {
162         (uint total, uint perBlock) = treasury.getAllowance(address(this));
163         return minimum(total, perBlock);
164     }
165     /*
166     * @notice Get the SF reward that can be sent to a function caller right now
167     * @param timeOfLastUpdate The last time when the function that the treasury pays for has been updated
168     * @param defaultDelayBetweenCalls Enforced delay between calls to the function for which the treasury reimburses callers
169     */
170     function getCallerReward(uint256 timeOfLastUpdate, uint256 defaultDelayBetweenCalls) public view returns (uint256) {
171         // If the rewards are null or if the time of the last update is in the future or present, return 0
172         bool nullRewards = (baseUpdateCallerReward == 0 && maxUpdateCallerReward == 0);
173         if (either(timeOfLastUpdate >= now, nullRewards)) return 0;
174 
175         // If the time elapsed is smaller than defaultDelayBetweenCalls or if the base reward is zero, return 0
176         uint256 timeElapsed = (timeOfLastUpdate == 0) ? defaultDelayBetweenCalls : subtract(now, timeOfLastUpdate);
177         if (either(timeElapsed < defaultDelayBetweenCalls, baseUpdateCallerReward == 0)) {
178             return 0;
179         }
180 
181         // If too much time elapsed, return the max reward
182         uint256 adjustedTime      = subtract(timeElapsed, defaultDelayBetweenCalls);
183         uint256 maxPossibleReward = minimum(maxUpdateCallerReward, treasuryAllowance() / RAY);
184         if (adjustedTime > maxRewardIncreaseDelay) {
185             return maxPossibleReward;
186         }
187 
188         // Calculate the reward
189         uint256 calculatedReward = baseUpdateCallerReward;
190         if (adjustedTime > 0) {
191             calculatedReward = rmultiply(rpower(perSecondCallerRewardIncrease, adjustedTime, RAY), calculatedReward);
192         }
193 
194         // If the reward is higher than max, set it to max
195         if (calculatedReward > maxPossibleReward) {
196             calculatedReward = maxPossibleReward;
197         }
198         return calculatedReward;
199     }
200     /**
201     * @notice Send a stability fee reward to an address
202     * @param proposedFeeReceiver The SF receiver
203     * @param reward The system coin amount to send
204     **/
205     function rewardCaller(address proposedFeeReceiver, uint256 reward) internal {
206         // If the receiver is the treasury itself or if the treasury is null or if the reward is zero, return
207         if (address(treasury) == proposedFeeReceiver) return;
208         if (either(address(treasury) == address(0), reward == 0)) return;
209 
210         // Determine the actual receiver and send funds
211         address finalFeeReceiver = (proposedFeeReceiver == address(0)) ? msg.sender : proposedFeeReceiver;
212         try treasury.pullFunds(finalFeeReceiver, treasury.systemCoin(), reward) {}
213         catch(bytes memory revertReason) {
214             emit FailRewardCaller(revertReason, finalFeeReceiver, reward);
215         }
216     }
217 }
218 
219 abstract contract SAFEEngineLike {
220     function collateralTypes(bytes32) virtual public view returns (
221         uint256 debtAmount,        // [wad]
222         uint256 accumulatedRate,   // [ray]
223         uint256 safetyPrice,       // [ray]
224         uint256 debtCeiling,       // [rad]
225         uint256 debtFloor          // [rad]
226     );
227     function globalDebtCeiling() virtual public view returns (uint256);
228     function modifyParameters(
229         bytes32 parameter,
230         uint256 data
231     ) virtual external;
232     function modifyParameters(
233         bytes32 collateralType,
234         bytes32 parameter,
235         uint256 data
236     ) virtual external;
237     function addAuthorization(address) external virtual;
238     function removeAuthorization(address) external virtual;
239 }
240 abstract contract OracleRelayerLike {
241     function redemptionRate() virtual public view returns (uint256);
242 }
243 
244 contract SingleSpotDebtCeilingSetter is IncreasingTreasuryReimbursement {
245     // --- Auth ---
246     // Mapping of addresses that are allowed to manually recompute the debt ceiling (without being rewarded for it)
247     mapping (address => uint256) public manualSetters;
248     /*
249     * @notify Add a new manual setter
250     * @param account The address of the new manual setter
251     */
252     function addManualSetter(address account) external isAuthorized {
253         manualSetters[account] = 1;
254         emit AddManualSetter(account);
255     }
256     /*
257     * @notify Remove a manual setter
258     * @param account The address of the manual setter to remove
259     */
260     function removeManualSetter(address account) external isAuthorized {
261         manualSetters[account] = 0;
262         emit RemoveManualSetter(account);
263     }
264     /*
265     * @notice Modifier for checking that the msg.sender is a whitelisted manual setter
266     */
267     modifier isManualSetter {
268         require(manualSetters[msg.sender] == 1, "SingleSpotDebtCeilingSetter/not-manual-setter");
269         _;
270     }
271 
272     // --- Variables ---
273     // The max amount of system coins that can be generated using this collateral type
274     uint256 public maxCollateralCeiling;            // [rad]
275     // The min amount of system coins that must be generated using this collateral type
276     uint256 public minCollateralCeiling;            // [rad]
277     // Premium on top of the current amount of debt (backed by the collateral type with collateralName) minted. This is used to calculate a new ceiling
278     uint256 public ceilingPercentageChange;         // [hundred]
279     // When the debt ceiling was last updated
280     uint256 public lastUpdateTime;                  // [timestamp]
281     // Enforced time gap between calls
282     uint256 public updateDelay;                     // [seconds]
283     // Last timestamp of a manual update
284     uint256 public lastManualUpdateTime;            // [seconds]
285     // Flag that blocks an increase in the debt ceiling when the redemption rate is positive
286     uint256 public blockIncreaseWhenRevalue;
287     // Flag that blocks a decrease in the debt ceiling when the redemption rate is negative
288     uint256 public blockDecreaseWhenDevalue;
289     // The collateral's name
290     bytes32 public collateralName;
291 
292     // The SAFEEngine contract
293     SAFEEngineLike    public safeEngine;
294     // The OracleRelayer contract
295     OracleRelayerLike public oracleRelayer;
296 
297     // --- Events ---
298     event AddManualSetter(address account);
299     event RemoveManualSetter(address account);
300     event UpdateCeiling(uint256 nextCeiling);
301 
302     constructor(
303       address safeEngine_,
304       address oracleRelayer_,
305       address treasury_,
306       bytes32 collateralName_,
307       uint256 baseUpdateCallerReward_,
308       uint256 maxUpdateCallerReward_,
309       uint256 perSecondCallerRewardIncrease_,
310       uint256 updateDelay_,
311       uint256 ceilingPercentageChange_,
312       uint256 maxCollateralCeiling_,
313       uint256 minCollateralCeiling_
314     ) public IncreasingTreasuryReimbursement(treasury_, baseUpdateCallerReward_, maxUpdateCallerReward_, perSecondCallerRewardIncrease_) {
315         require(safeEngine_ != address(0), "SingleSpotDebtCeilingSetter/invalid-safe-engine");
316         require(oracleRelayer_ != address(0), "SingleSpotDebtCeilingSetter/invalid-oracle-relayer");
317         require(updateDelay_ > 0, "SingleSpotDebtCeilingSetter/invalid-update-delay");
318         require(both(ceilingPercentageChange_ > HUNDRED, ceilingPercentageChange_ <= THOUSAND), "SingleSpotDebtCeilingSetter/invalid-percentage-change");
319         require(minCollateralCeiling_ > 0, "SingleSpotDebtCeilingSetter/invalid-min-ceiling");
320         require(both(maxCollateralCeiling_ > 0, maxCollateralCeiling_ > minCollateralCeiling_), "SingleSpotDebtCeilingSetter/invalid-max-ceiling");
321 
322         manualSetters[msg.sender] = 1;
323 
324         safeEngine                = SAFEEngineLike(safeEngine_);
325         oracleRelayer             = OracleRelayerLike(oracleRelayer_);
326         collateralName            = collateralName_;
327         updateDelay               = updateDelay_;
328         ceilingPercentageChange   = ceilingPercentageChange_;
329         maxCollateralCeiling      = maxCollateralCeiling_;
330         minCollateralCeiling      = minCollateralCeiling_;
331         lastManualUpdateTime      = now;
332 
333         // Check that the oracleRelayer has the redemption rate in it
334         oracleRelayer.redemptionRate();
335 
336 	emit AddManualSetter(msg.sender);
337         emit ModifyParameters("updateDelay", updateDelay);
338         emit ModifyParameters("ceilingPercentageChange", ceilingPercentageChange);
339         emit ModifyParameters("maxCollateralCeiling", maxCollateralCeiling);
340         emit ModifyParameters("minCollateralCeiling", minCollateralCeiling);
341     }
342 
343     // --- Math ---
344     uint256 constant HUNDRED  = 100;
345     uint256 constant THOUSAND = 1000;
346 
347     function maximum(uint256 x, uint256 y) internal pure returns (uint256 z) {
348         z = (x <= y) ? y : x;
349     }
350 
351     // --- Boolean Logic ---
352     function both(bool x, bool y) internal pure returns (bool z) {
353         assembly{ z := and(x, y)}
354     }
355 
356     // --- Management ---
357     /*
358     * @notify Modify the treasury or the oracle relayer address
359     * @param parameter The contract address to modify
360     * @param addr The new address for the contract
361     */
362     function modifyParameters(bytes32 parameter, address addr) external isAuthorized {
363         if (parameter == "treasury") {
364           require(StabilityFeeTreasuryLike(addr).systemCoin() != address(0), "SingleSpotDebtCeilingSetter/treasury-coin-not-set");
365           treasury = StabilityFeeTreasuryLike(addr);
366         }
367         else if (parameter == "oracleRelayer") {
368           require(addr != address(0), "SingleSpotDebtCeilingSetter/null-addr");
369           oracleRelayer = OracleRelayerLike(addr);
370           // Check that it has the redemption rate
371           oracleRelayer.redemptionRate();
372         }
373         else revert("SingleSpotDebtCeilingSetter/modify-unrecognized-param");
374         emit ModifyParameters(
375           parameter,
376           addr
377         );
378     }
379     /*
380     * @notify Modify an uint256 param
381     * @param parameter The name of the parameter to modify
382     * @param val The new parameter value
383     */
384     function modifyParameters(bytes32 parameter, uint256 val) external isAuthorized {
385         if (parameter == "baseUpdateCallerReward") {
386           require(val <= maxUpdateCallerReward, "SingleSpotDebtCeilingSetter/invalid-base-caller-reward");
387           baseUpdateCallerReward = val;
388         }
389         else if (parameter == "maxUpdateCallerReward") {
390           require(val >= baseUpdateCallerReward, "SingleSpotDebtCeilingSetter/invalid-max-caller-reward");
391           maxUpdateCallerReward = val;
392         }
393         else if (parameter == "perSecondCallerRewardIncrease") {
394           require(val >= RAY, "SingleSpotDebtCeilingSetter/invalid-caller-reward-increase");
395           perSecondCallerRewardIncrease = val;
396         }
397         else if (parameter == "maxRewardIncreaseDelay") {
398           require(val > 0, "SingleSpotDebtCeilingSetter/invalid-max-increase-delay");
399           maxRewardIncreaseDelay = val;
400         }
401         else if (parameter == "updateDelay") {
402           require(val >= 0, "SingleSpotDebtCeilingSetter/invalid-call-gap-length");
403           updateDelay = val;
404         }
405         else if (parameter == "maxCollateralCeiling") {
406           require(both(val > 0, val > minCollateralCeiling), "SingleSpotDebtCeilingSetter/invalid-max-ceiling");
407           maxCollateralCeiling = val;
408         }
409         else if (parameter == "minCollateralCeiling") {
410           require(both(val > 0, val < maxCollateralCeiling), "SingleSpotDebtCeilingSetter/invalid-min-ceiling");
411           minCollateralCeiling = val;
412         }
413         else if (parameter == "ceilingPercentageChange") {
414           require(both(val > HUNDRED, val <= THOUSAND), "SingleSpotDebtCeilingSetter/invalid-percentage-change");
415           ceilingPercentageChange = val;
416         }
417         else if (parameter == "lastUpdateTime") {
418           require(val > now, "SingleSpotDebtCeilingSetter/invalid-update-time");
419           lastUpdateTime = val;
420         }
421         else if (parameter == "blockIncreaseWhenRevalue") {
422           require(either(val == 1, val == 0), "SingleSpotDebtCeilingSetter/invalid-block-increase-value");
423           blockIncreaseWhenRevalue = val;
424         }
425         else if (parameter == "blockDecreaseWhenDevalue") {
426           require(either(val == 1, val == 0), "SingleSpotDebtCeilingSetter/invalid-block-decrease-value");
427           blockDecreaseWhenDevalue = val;
428         }
429         else revert("SingleSpotDebtCeilingSetter/modify-unrecognized-param");
430         emit ModifyParameters(
431           parameter,
432           val
433         );
434     }
435 
436     // --- Utils ---
437     /*
438     * @notify Internal function meant to modify the collateral's debt ceiling as well as the global debt ceiling (if needed)
439     * @param nextDebtCeiling The new ceiling to set
440     */
441     function setCeiling(uint256 nextDebtCeiling) internal {
442         (uint256 debtAmount, uint256 accumulatedRate, uint256 safetyPrice, uint256 currentDebtCeiling,) = safeEngine.collateralTypes(collateralName);
443 
444         if (safeEngine.globalDebtCeiling() < nextDebtCeiling) {
445             safeEngine.modifyParameters("globalDebtCeiling", nextDebtCeiling);
446         }
447 
448         if (currentDebtCeiling != nextDebtCeiling) {
449             safeEngine.modifyParameters(collateralName, "debtCeiling", nextDebtCeiling);
450             emit UpdateCeiling(nextDebtCeiling);
451         }
452     }
453 
454     // --- Auto Updates ---
455     /*
456     * @notify Periodically updates the debt ceiling. Can be called by anyone
457     * @param feeReceiver The address that will receive the reward for updating the ceiling
458     */
459     function autoUpdateCeiling(address feeReceiver) external {
460         // Check that the update time is not in the future
461         require(lastUpdateTime < now, "SingleSpotDebtCeilingSetter/update-time-in-the-future");
462         // Check delay between calls
463         require(either(subtract(now, lastUpdateTime) >= updateDelay, lastUpdateTime == 0), "SingleSpotDebtCeilingSetter/wait-more");
464 
465         // Get the caller's reward
466         uint256 callerReward = getCallerReward(lastUpdateTime, updateDelay);
467         // Update lastUpdateTime
468         lastUpdateTime = now;
469 
470         // Get the next ceiling and set it
471         uint256 nextCollateralCeiling = getNextCollateralCeiling();
472         setCeiling(nextCollateralCeiling);
473 
474         // Pay the caller for updating the ceiling
475         rewardCaller(feeReceiver, callerReward);
476     }
477 
478     // --- Manual Updates ---
479     /*
480     * @notify Authed function that allows manualSetters to update the debt ceiling whenever they want
481     */
482     function manualUpdateCeiling() external isManualSetter {
483         require(now > lastManualUpdateTime, "SingleSpotDebtCeilingSetter/cannot-update-twice-same-block");
484         uint256 nextCollateralCeiling = getNextCollateralCeiling();
485         lastManualUpdateTime = now;
486         setCeiling(nextCollateralCeiling);
487     }
488 
489     // --- Getters ---
490     /*
491     * @notify View function meant to return the new and upcoming debt ceiling. It also applies checks regarding re or devaluation blocks
492     */
493     function getNextCollateralCeiling() public view returns (uint256) {
494         (uint256 debtAmount, uint256 accumulatedRate, uint256 safetyPrice, uint256 currentDebtCeiling, uint256 debtFloor) = safeEngine.collateralTypes(collateralName);
495         uint256 adjustedCurrentDebt   = multiply(debtAmount, accumulatedRate);
496         uint256 lowestPossibleCeiling = maximum(debtFloor, minCollateralCeiling);
497 
498         if (debtAmount == 0) return lowestPossibleCeiling;
499 
500         uint256 updatedCeiling = multiply(adjustedCurrentDebt, ceilingPercentageChange) / HUNDRED;
501         if (updatedCeiling <= lowestPossibleCeiling) return lowestPossibleCeiling;
502         else if (updatedCeiling >= maxCollateralCeiling) return maxCollateralCeiling;
503 
504         uint256 redemptionRate = oracleRelayer.redemptionRate();
505 
506         if (either(
507           allowsIncrease(redemptionRate, currentDebtCeiling, updatedCeiling),
508           allowsDecrease(redemptionRate, currentDebtCeiling, updatedCeiling))
509         ) return updatedCeiling;
510 
511         return currentDebtCeiling;
512     }
513     /*
514     * @notify View function meant to return the new and upcoming debt ceiling. It does not perform checks for boundaries
515     */
516     function getRawUpdatedCeiling() external view returns (uint256) {
517         (uint256 debtAmount, uint256 accumulatedRate, uint256 safetyPrice, uint256 currentDebtCeiling, uint256 debtFloor) = safeEngine.collateralTypes(collateralName);
518         uint256 adjustedCurrentDebt = multiply(debtAmount, accumulatedRate);
519         return multiply(adjustedCurrentDebt, ceilingPercentageChange) / HUNDRED;
520     }
521     /*
522     * @notify View function meant to return whether an increase in the debt ceiling is currently allowed
523     * @param redemptionRate A custom redemption rate
524     * @param currentDebtCeiling The current debt ceiling for the collateral type with collateralName
525     * @param updatedCeiling The new ceiling computed for the collateral type with collateralName
526     */
527     function allowsIncrease(uint256 redemptionRate, uint256 currentDebtCeiling, uint256 updatedCeiling) public view returns (bool allowIncrease) {
528         allowIncrease = either(redemptionRate <= RAY, both(redemptionRate > RAY, blockIncreaseWhenRevalue == 0));
529         allowIncrease = both(currentDebtCeiling <= updatedCeiling, allowIncrease);
530     }
531     /*
532     * @notify View function meant to return whether a decrease in the debt ceiling is currently allowed
533     * @param redemptionRate A custom redemption rate
534     * @param currentDebtCeiling The current debt ceiling for the collateral type with collateralName
535     * @param updatedCeiling The new ceiling computed for the collateral type with collateralName
536     */
537     function allowsDecrease(uint256 redemptionRate, uint256 currentDebtCeiling, uint256 updatedCeiling) public view returns (bool allowDecrease) {
538         allowDecrease = either(redemptionRate >= RAY, both(redemptionRate < RAY, blockDecreaseWhenDevalue == 0));
539         allowDecrease = both(currentDebtCeiling >= updatedCeiling, allowDecrease);
540     }
541 }