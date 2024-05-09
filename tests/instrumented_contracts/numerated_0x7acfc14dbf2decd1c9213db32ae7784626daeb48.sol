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
64 abstract contract OracleLike {
65     function getResultWithValidity() virtual external view returns (uint256, bool);
66 }
67 
68 abstract contract PIDCalculator {
69     function computeRate(uint256, uint256, uint256) virtual external returns (uint256);
70     function rt(uint256, uint256, uint256) virtual external view returns (uint256);
71     function pscl() virtual external view returns (uint256);
72     function tlv() virtual external view returns (uint256);
73 }
74 
75 contract PIRateSetter is GebMath {
76     // --- Auth ---
77     mapping (address => uint) public authorizedAccounts;
78     /**
79      * @notice Add auth to an account
80      * @param account Account to add auth to
81      */
82     function addAuthorization(address account) external isAuthorized {
83         authorizedAccounts[account] = 1;
84         emit AddAuthorization(account);
85     }
86     /**
87      * @notice Remove auth from an account
88      * @param account Account to remove auth from
89      */
90     function removeAuthorization(address account) external isAuthorized {
91         authorizedAccounts[account] = 0;
92         emit RemoveAuthorization(account);
93     }
94     /**
95     * @notice Checks whether msg.sender can call an authed function
96     **/
97     modifier isAuthorized {
98         require(authorizedAccounts[msg.sender] == 1, "PIRateSetter/account-not-authorized");
99         _;
100     }
101 
102     // --- Variables ---
103     // When the price feed was last updated
104     uint256 public lastUpdateTime;                  // [timestamp]
105     // Enforced gap between calls
106     uint256 public updateRateDelay;                 // [seconds]
107     // Whether the leak is set to zero by default
108     uint256 public defaultLeak;                     // [0 or 1]
109 
110     // --- System Dependencies ---
111     // OSM or medianizer for the system coin
112     OracleLike                public orcl;
113     // OracleRelayer where the redemption price is stored
114     OracleRelayerLike         public oracleRelayer;
115     // The contract that will pass the new redemption rate to the oracle relayer
116     SetterRelayer             public setterRelayer;
117     // Calculator for the redemption rate
118     PIDCalculator             public pidCalculator;
119 
120     // --- Events ---
121     event AddAuthorization(address account);
122     event RemoveAuthorization(address account);
123     event ModifyParameters(
124       bytes32 parameter,
125       address addr
126     );
127     event ModifyParameters(
128       bytes32 parameter,
129       uint256 val
130     );
131     event UpdateRedemptionRate(
132         uint marketPrice,
133         uint redemptionPrice,
134         uint redemptionRate
135     );
136     event FailUpdateRedemptionRate(
137         uint marketPrice,
138         uint redemptionPrice,
139         uint redemptionRate,
140         bytes reason
141     );
142 
143     constructor(
144       address oracleRelayer_,
145       address setterRelayer_,
146       address orcl_,
147       address pidCalculator_,
148       uint256 updateRateDelay_
149     ) public {
150         require(oracleRelayer_ != address(0), "PIRateSetter/null-oracle-relayer");
151         require(setterRelayer_ != address(0), "PIRateSetter/null-setter-relayer");
152         require(orcl_ != address(0), "PIRateSetter/null-orcl");
153         require(pidCalculator_ != address(0), "PIRateSetter/null-calculator");
154 
155         authorizedAccounts[msg.sender] = 1;
156         defaultLeak                    = 1;
157 
158         oracleRelayer    = OracleRelayerLike(oracleRelayer_);
159         setterRelayer    = SetterRelayer(setterRelayer_);
160         orcl             = OracleLike(orcl_);
161         pidCalculator    = PIDCalculator(pidCalculator_);
162 
163         updateRateDelay  = updateRateDelay_;
164 
165         emit AddAuthorization(msg.sender);
166         emit ModifyParameters("orcl", orcl_);
167         emit ModifyParameters("oracleRelayer", oracleRelayer_);
168         emit ModifyParameters("setterRelayer", setterRelayer_);
169         emit ModifyParameters("pidCalculator", pidCalculator_);
170         emit ModifyParameters("updateRateDelay", updateRateDelay_);
171     }
172 
173     // --- Boolean Logic ---
174     function either(bool x, bool y) internal pure returns (bool z) {
175         assembly{ z := or(x, y)}
176     }
177 
178     // --- Management ---
179     /*
180     * @notify Modify the address of a contract that the setter is connected to
181     * @param parameter Contract name
182     * @param addr The new contract address
183     */
184     function modifyParameters(bytes32 parameter, address addr) external isAuthorized {
185         require(addr != address(0), "PIRateSetter/null-addr");
186         if (parameter == "orcl") orcl = OracleLike(addr);
187         else if (parameter == "oracleRelayer") oracleRelayer = OracleRelayerLike(addr);
188         else if (parameter == "setterRelayer") setterRelayer = SetterRelayer(addr);
189         else if (parameter == "pidCalculator") {
190           pidCalculator = PIDCalculator(addr);
191         }
192         else revert("PIRateSetter/modify-unrecognized-param");
193         emit ModifyParameters(
194           parameter,
195           addr
196         );
197     }
198     /*
199     * @notify Modify a uint256 parameter
200     * @param parameter The parameter name
201     * @param val The new parameter value
202     */
203     function modifyParameters(bytes32 parameter, uint256 val) external isAuthorized {
204         if (parameter == "updateRateDelay") {
205           require(val > 0, "PIRateSetter/null-update-delay");
206           updateRateDelay = val;
207         }
208         else if (parameter == "defaultLeak") {
209           require(val <= 1, "PIRateSetter/invalid-default-leak");
210           defaultLeak = val;
211         }
212         else revert("PIRateSetter/modify-unrecognized-param");
213         emit ModifyParameters(
214           parameter,
215           val
216         );
217     }
218 
219     // --- Feedback Mechanism ---
220     /**
221     * @notice Compute and set a new redemption rate
222     * @param feeReceiver The proposed address that should receive the reward for calling this function
223     *        (unless it's address(0) in which case msg.sender will get it)
224     **/
225     function updateRate(address feeReceiver) external {
226         // The fee receiver must not be null
227         require(feeReceiver != address(0), "PIRateSetter/null-fee-receiver");
228         // Check delay between calls
229         require(either(subtract(now, lastUpdateTime) >= updateRateDelay, lastUpdateTime == 0), "PIRateSetter/wait-more");
230         // Get price feed updates
231         (uint256 marketPrice, bool hasValidValue) = orcl.getResultWithValidity();
232         // If the oracle has a value
233         require(hasValidValue, "PIRateSetter/invalid-oracle-value");
234         // If the price is non-zero
235         require(marketPrice > 0, "PIRateSetter/null-price");
236         // Get the latest redemption price
237         uint redemptionPrice = oracleRelayer.redemptionPrice();
238         // Calculate the rate
239         uint256 iapcr      = (defaultLeak == 1) ? RAY : rpower(pidCalculator.pscl(), pidCalculator.tlv(), RAY);
240         uint256 calculated = pidCalculator.computeRate(
241             marketPrice,
242             redemptionPrice,
243             iapcr
244         );
245         // Store the timestamp of the update
246         lastUpdateTime = now;
247         // Update the rate using the setter relayer
248         try setterRelayer.relayRate(calculated, feeReceiver) {
249           // Emit success event
250           emit UpdateRedemptionRate(
251             ray(marketPrice),
252             redemptionPrice,
253             calculated
254           );
255         }
256         catch(bytes memory revertReason) {
257           emit FailUpdateRedemptionRate(
258             ray(marketPrice),
259             redemptionPrice,
260             calculated,
261             revertReason
262           );
263         }
264     }
265 
266     // --- Getters ---
267     /**
268     * @notice Get the market price from the system coin oracle
269     **/
270     function getMarketPrice() external view returns (uint256) {
271         (uint256 marketPrice, ) = orcl.getResultWithValidity();
272         return marketPrice;
273     }
274     /**
275     * @notice Get the redemption and the market prices for the system coin
276     **/
277     function getRedemptionAndMarketPrices() external returns (uint256 marketPrice, uint256 redemptionPrice) {
278         (marketPrice, ) = orcl.getResultWithValidity();
279         redemptionPrice = oracleRelayer.redemptionPrice();
280     }
281 }
282 
283 
284 abstract contract StabilityFeeTreasuryLike {
285     function getAllowance(address) virtual external view returns (uint, uint);
286     function systemCoin() virtual external view returns (address);
287     function pullFunds(address, address, uint) virtual external;
288     function setTotalAllowance(address, uint256) external virtual;
289     function setPerBlockAllowance(address, uint256) external virtual;
290 }
291 
292 contract IncreasingTreasuryReimbursement is GebMath {
293     // --- Auth ---
294     mapping (address => uint) public authorizedAccounts;
295     /**
296      * @notice Add auth to an account
297      * @param account Account to add auth to
298      */
299     function addAuthorization(address account) virtual external isAuthorized {
300         authorizedAccounts[account] = 1;
301         emit AddAuthorization(account);
302     }
303     /**
304      * @notice Remove auth from an account
305      * @param account Account to remove auth from
306      */
307     function removeAuthorization(address account) virtual external isAuthorized {
308         authorizedAccounts[account] = 0;
309         emit RemoveAuthorization(account);
310     }
311     /**
312     * @notice Checks whether msg.sender can call an authed function
313     **/
314     modifier isAuthorized {
315         require(authorizedAccounts[msg.sender] == 1, "IncreasingTreasuryReimbursement/account-not-authorized");
316         _;
317     }
318 
319     // --- Variables ---
320     // Starting reward for the fee receiver/keeper
321     uint256 public baseUpdateCallerReward;          // [wad]
322     // Max possible reward for the fee receiver/keeper
323     uint256 public maxUpdateCallerReward;           // [wad]
324     // Max delay taken into consideration when calculating the adjusted reward
325     uint256 public maxRewardIncreaseDelay;          // [seconds]
326     // Rate applied to baseUpdateCallerReward every extra second passed beyond a certain point (e.g next time when a specific function needs to be called)
327     uint256 public perSecondCallerRewardIncrease;   // [ray]
328 
329     // SF treasury
330     StabilityFeeTreasuryLike  public treasury;
331 
332     // --- Events ---
333     event AddAuthorization(address account);
334     event RemoveAuthorization(address account);
335     event ModifyParameters(
336       bytes32 parameter,
337       address addr
338     );
339     event ModifyParameters(
340       bytes32 parameter,
341       uint256 val
342     );
343     event FailRewardCaller(bytes revertReason, address feeReceiver, uint256 amount);
344 
345     constructor(
346       address treasury_,
347       uint256 baseUpdateCallerReward_,
348       uint256 maxUpdateCallerReward_,
349       uint256 perSecondCallerRewardIncrease_
350     ) public {
351         if (address(treasury_) != address(0)) {
352           require(StabilityFeeTreasuryLike(treasury_).systemCoin() != address(0), "IncreasingTreasuryReimbursement/treasury-coin-not-set");
353         }
354         require(maxUpdateCallerReward_ >= baseUpdateCallerReward_, "IncreasingTreasuryReimbursement/invalid-max-caller-reward");
355         require(perSecondCallerRewardIncrease_ >= RAY, "IncreasingTreasuryReimbursement/invalid-per-second-reward-increase");
356         authorizedAccounts[msg.sender] = 1;
357 
358         treasury                        = StabilityFeeTreasuryLike(treasury_);
359         baseUpdateCallerReward          = baseUpdateCallerReward_;
360         maxUpdateCallerReward           = maxUpdateCallerReward_;
361         perSecondCallerRewardIncrease   = perSecondCallerRewardIncrease_;
362         maxRewardIncreaseDelay          = uint(-1);
363 
364         emit AddAuthorization(msg.sender);
365         emit ModifyParameters("treasury", treasury_);
366         emit ModifyParameters("baseUpdateCallerReward", baseUpdateCallerReward);
367         emit ModifyParameters("maxUpdateCallerReward", maxUpdateCallerReward);
368         emit ModifyParameters("perSecondCallerRewardIncrease", perSecondCallerRewardIncrease);
369     }
370 
371     // --- Boolean Logic ---
372     function either(bool x, bool y) internal pure returns (bool z) {
373         assembly{ z := or(x, y)}
374     }
375 
376     // --- Treasury ---
377     /**
378     * @notice This returns the stability fee treasury allowance for this contract by taking the minimum between the per block and the total allowances
379     **/
380     function treasuryAllowance() public view returns (uint256) {
381         (uint total, uint perBlock) = treasury.getAllowance(address(this));
382         return minimum(total, perBlock);
383     }
384     /*
385     * @notice Get the SF reward that can be sent to a function caller right now
386     * @param timeOfLastUpdate The last time when the function that the treasury pays for has been updated
387     * @param defaultDelayBetweenCalls Enforced delay between calls to the function for which the treasury reimburses callers
388     */
389     function getCallerReward(uint256 timeOfLastUpdate, uint256 defaultDelayBetweenCalls) public view returns (uint256) {
390         // If the rewards are null or if the time of the last update is in the future or present, return 0
391         bool nullRewards = (baseUpdateCallerReward == 0 && maxUpdateCallerReward == 0);
392         if (either(timeOfLastUpdate >= now, nullRewards)) return 0;
393 
394         // If the time elapsed is smaller than defaultDelayBetweenCalls or if the base reward is zero, return 0
395         uint256 timeElapsed = (timeOfLastUpdate == 0) ? defaultDelayBetweenCalls : subtract(now, timeOfLastUpdate);
396         if (either(timeElapsed < defaultDelayBetweenCalls, baseUpdateCallerReward == 0)) {
397             return 0;
398         }
399 
400         // If too much time elapsed, return the max reward
401         uint256 adjustedTime      = subtract(timeElapsed, defaultDelayBetweenCalls);
402         uint256 maxPossibleReward = minimum(maxUpdateCallerReward, treasuryAllowance() / RAY);
403         if (adjustedTime > maxRewardIncreaseDelay) {
404             return maxPossibleReward;
405         }
406 
407         // Calculate the reward
408         uint256 calculatedReward = baseUpdateCallerReward;
409         if (adjustedTime > 0) {
410             calculatedReward = rmultiply(rpower(perSecondCallerRewardIncrease, adjustedTime, RAY), calculatedReward);
411         }
412 
413         // If the reward is higher than max, set it to max
414         if (calculatedReward > maxPossibleReward) {
415             calculatedReward = maxPossibleReward;
416         }
417         return calculatedReward;
418     }
419     /**
420     * @notice Send a stability fee reward to an address
421     * @param proposedFeeReceiver The SF receiver
422     * @param reward The system coin amount to send
423     **/
424     function rewardCaller(address proposedFeeReceiver, uint256 reward) internal {
425         // If the receiver is the treasury itself or if the treasury is null or if the reward is zero, return
426         if (address(treasury) == proposedFeeReceiver) return;
427         if (either(address(treasury) == address(0), reward == 0)) return;
428 
429         // Determine the actual receiver and send funds
430         address finalFeeReceiver = (proposedFeeReceiver == address(0)) ? msg.sender : proposedFeeReceiver;
431         try treasury.pullFunds(finalFeeReceiver, treasury.systemCoin(), reward) {}
432         catch(bytes memory revertReason) {
433             emit FailRewardCaller(revertReason, finalFeeReceiver, reward);
434         }
435     }
436 }
437 
438 abstract contract OracleRelayerLike {
439     function redemptionPrice() virtual external returns (uint256);
440     function modifyParameters(bytes32,uint256) virtual external;
441 }
442 
443 contract SetterRelayer is IncreasingTreasuryReimbursement {
444     // --- Events ---
445     event RelayRate(address setter, uint256 redemptionRate);
446 
447     // --- Variables ---
448     // When the rate has last been relayed
449     uint256           public lastUpdateTime;                      // [timestamp]
450     // Enforced gap between relays
451     uint256           public relayDelay;                          // [seconds]
452     // The address that's allowed to pass new redemption rates
453     address           public setter;
454     // The oracle relayer contract
455     OracleRelayerLike public oracleRelayer;
456 
457     constructor(
458       address oracleRelayer_,
459       address treasury_,
460       uint256 baseUpdateCallerReward_,
461       uint256 maxUpdateCallerReward_,
462       uint256 perSecondCallerRewardIncrease_,
463       uint256 relayDelay_
464     ) public IncreasingTreasuryReimbursement(treasury_, baseUpdateCallerReward_, maxUpdateCallerReward_, perSecondCallerRewardIncrease_) {
465         relayDelay    = relayDelay_;
466         oracleRelayer = OracleRelayerLike(oracleRelayer_);
467 
468         emit ModifyParameters("relayDelay", relayDelay_);
469     }
470 
471     // --- Administration ---
472     /*
473     * @notice Change the addresses of contracts that this relayer is connected to
474     * @param parameter The contract whose address is changed
475     * @param addr The new contract address
476     */
477     function modifyParameters(bytes32 parameter, address addr) external isAuthorized {
478         require(addr != address(0), "SetterRelayer/null-addr");
479         if (parameter == "setter") {
480           setter = addr;
481         }
482         else if (parameter == "treasury") {
483           require(StabilityFeeTreasuryLike(addr).systemCoin() != address(0), "SetterRelayer/treasury-coin-not-set");
484           treasury = StabilityFeeTreasuryLike(addr);
485         }
486         else revert("SetterRelayer/modify-unrecognized-param");
487         emit ModifyParameters(
488           parameter,
489           addr
490         );
491     }
492     /*
493     * @notify Modify a uint256 parameter
494     * @param parameter The parameter name
495     * @param val The new parameter value
496     */
497     function modifyParameters(bytes32 parameter, uint256 val) external isAuthorized {
498         if (parameter == "baseUpdateCallerReward") {
499           require(val <= maxUpdateCallerReward, "SetterRelayer/invalid-base-caller-reward");
500           baseUpdateCallerReward = val;
501         }
502         else if (parameter == "maxUpdateCallerReward") {
503           require(val >= baseUpdateCallerReward, "SetterRelayer/invalid-max-caller-reward");
504           maxUpdateCallerReward = val;
505         }
506         else if (parameter == "perSecondCallerRewardIncrease") {
507           require(val >= RAY, "SetterRelayer/invalid-caller-reward-increase");
508           perSecondCallerRewardIncrease = val;
509         }
510         else if (parameter == "maxRewardIncreaseDelay") {
511           require(val > 0, "SetterRelayer/invalid-max-increase-delay");
512           maxRewardIncreaseDelay = val;
513         }
514         else if (parameter == "relayDelay") {
515           relayDelay = val;
516         }
517         else revert("SetterRelayer/modify-unrecognized-param");
518         emit ModifyParameters(
519           parameter,
520           val
521         );
522     }
523 
524     // --- Core Logic ---
525     /*
526     * @notice Relay a new redemption rate to the OracleRelayer
527     * @param redemptionRate The new redemption rate to relay
528     */
529     function relayRate(uint256 redemptionRate, address feeReceiver) external {
530         // Perform checks
531         require(setter == msg.sender, "SetterRelayer/invalid-caller");
532         require(feeReceiver != address(0), "SetterRelayer/null-fee-receiver");
533         require(feeReceiver != setter, "SetterRelayer/setter-cannot-receive-fees");
534         // Check delay between calls
535         require(either(subtract(now, lastUpdateTime) >= relayDelay, lastUpdateTime == 0), "SetterRelayer/wait-more");
536         // Get the caller's reward
537         uint256 callerReward = getCallerReward(lastUpdateTime, relayDelay);
538         // Store the timestamp of the update
539         lastUpdateTime = now;
540         // Update the redemption price and then set the rate
541         oracleRelayer.redemptionPrice();
542         oracleRelayer.modifyParameters("redemptionRate", redemptionRate);
543         // Emit an event
544         emit RelayRate(setter, redemptionRate);
545         // Pay the caller for relaying the rate
546         rewardCaller(feeReceiver, callerReward);
547     }
548 }