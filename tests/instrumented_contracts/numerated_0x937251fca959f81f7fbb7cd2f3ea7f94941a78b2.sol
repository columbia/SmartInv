1 // File: contracts/FlightDelayConstants.sol
2 
3 /**
4  * FlightDelay with Oraclized Underwriting and Payout
5  *
6  * @description	Events and Constants
7  * @copyright (c) 2017 etherisc GmbH
8  * @author Christoph Mussenbrock
9  */
10 
11 pragma solidity ^0.4.11;
12 
13 
14 contract FlightDelayConstants {
15 
16     /*
17     * General events
18     */
19 
20 // --> test-mode
21 //        event LogUint(string _message, uint _uint);
22 //        event LogUintEth(string _message, uint ethUint);
23 //        event LogUintTime(string _message, uint timeUint);
24 //        event LogInt(string _message, int _int);
25 //        event LogAddress(string _message, address _address);
26 //        event LogBytes32(string _message, bytes32 hexBytes32);
27 //        event LogBytes(string _message, bytes hexBytes);
28 //        event LogBytes32Str(string _message, bytes32 strBytes32);
29 //        event LogString(string _message, string _string);
30 //        event LogBool(string _message, bool _bool);
31 //        event Log(address);
32 // <-- test-mode
33 
34     event LogPolicyApplied(
35         uint _policyId,
36         address _customer,
37         bytes32 strCarrierFlightNumber,
38         uint ethPremium
39     );
40     event LogPolicyAccepted(
41         uint _policyId,
42         uint _statistics0,
43         uint _statistics1,
44         uint _statistics2,
45         uint _statistics3,
46         uint _statistics4,
47         uint _statistics5
48     );
49     event LogPolicyPaidOut(
50         uint _policyId,
51         uint ethAmount
52     );
53     event LogPolicyExpired(
54         uint _policyId
55     );
56     event LogPolicyDeclined(
57         uint _policyId,
58         bytes32 strReason
59     );
60     event LogPolicyManualPayout(
61         uint _policyId,
62         bytes32 strReason
63     );
64     event LogSendFunds(
65         address _recipient,
66         uint8 _from,
67         uint ethAmount
68     );
69     event LogReceiveFunds(
70         address _sender,
71         uint8 _to,
72         uint ethAmount
73     );
74     event LogSendFail(
75         uint _policyId,
76         bytes32 strReason
77     );
78     event LogOraclizeCall(
79         uint _policyId,
80         bytes32 hexQueryId,
81         string _oraclizeUrl,
82         uint256 _oraclizeTime
83     );
84     event LogOraclizeCallback(
85         uint _policyId,
86         bytes32 hexQueryId,
87         string _result,
88         bytes hexProof
89     );
90     event LogSetState(
91         uint _policyId,
92         uint8 _policyState,
93         uint _stateTime,
94         bytes32 _stateMessage
95     );
96     event LogExternal(
97         uint256 _policyId,
98         address _address,
99         bytes32 _externalId
100     );
101 
102     /*
103     * General constants
104     */
105 
106     // minimum observations for valid prediction
107     uint constant MIN_OBSERVATIONS = 10;
108     // minimum premium to cover costs
109     uint constant MIN_PREMIUM = 50 finney;
110     // maximum premium
111     uint constant MAX_PREMIUM = 1 ether;
112     // maximum payout
113     uint constant MAX_PAYOUT = 1100 finney;
114 
115     uint constant MIN_PREMIUM_EUR = 1500 wei;
116     uint constant MAX_PREMIUM_EUR = 29000 wei;
117     uint constant MAX_PAYOUT_EUR = 30000 wei;
118 
119     uint constant MIN_PREMIUM_USD = 1700 wei;
120     uint constant MAX_PREMIUM_USD = 34000 wei;
121     uint constant MAX_PAYOUT_USD = 35000 wei;
122 
123     uint constant MIN_PREMIUM_GBP = 1300 wei;
124     uint constant MAX_PREMIUM_GBP = 25000 wei;
125     uint constant MAX_PAYOUT_GBP = 270 wei;
126 
127     // maximum cumulated weighted premium per risk
128     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;
129     // 1 percent for DAO, 1 percent for maintainer
130     uint8 constant REWARD_PERCENT = 2;
131     // reserve for tail risks
132     uint8 constant RESERVE_PERCENT = 1;
133     // the weight pattern; in future versions this may become part of the policy struct.
134     // currently can't be constant because of compiler restrictions
135     // WEIGHT_PATTERN[0] is not used, just to be consistent
136     uint8[6] WEIGHT_PATTERN = [
137         0,
138         10,
139         20,
140         30,
141         50,
142         50
143     ];
144 
145 // --> prod-mode
146     // DEFINITIONS FOR ROPSTEN AND MAINNET
147     // minimum time before departure for applying
148     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
149     // check for delay after .. minutes after scheduled arrival
150     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
151 // <-- prod-mode
152 
153 // --> test-mode
154 //        // DEFINITIONS FOR LOCAL TESTNET
155 //        // minimum time before departure for applying
156 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
157 //        // check for delay after .. minutes after scheduled arrival
158 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
159 // <-- test-mode
160 
161     // maximum duration of flight
162     uint constant MAX_FLIGHT_DURATION = 2 days;
163     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
164     uint constant CONTRACT_DEAD_LINE = 1922396399;
165 
166     // gas Constants for oraclize
167     uint constant ORACLIZE_GAS = 700000;
168     uint constant ORACLIZE_GASPRICE = 4000000000;
169 
170 
171     /*
172     * URLs and query strings for oraclize
173     */
174 
175 // --> prod-mode
176     // DEFINITIONS FOR ROPSTEN AND MAINNET
177     string constant ORACLIZE_RATINGS_BASE_URL =
178         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
179         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
180     string constant ORACLIZE_RATINGS_QUERY =
181         "?${[decrypt] BAr6Z9QolM2PQimF/pNC6zXldOvZ2qquOSKm/qJkJWnSGgAeRw21wBGnBbXiamr/ISC5SlcJB6wEPKthdc6F+IpqM/iXavKsalRUrGNuBsGfaMXr8fRQw6gLzqk0ecOFNeCa48/yqBvC/kas+jTKHiYxA3wTJrVZCq76Y03lZI2xxLaoniRk}).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
182     string constant ORACLIZE_STATUS_BASE_URL =
183         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
184         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
185     string constant ORACLIZE_STATUS_QUERY =
186         // pattern:
187         "?${[decrypt] BJxpwRaHujYTT98qI5slQJplj/VbfV7vYkMOp/Mr5D/5+gkgJQKZb0gVSCa6aKx2Wogo/cG7yaWINR6vnuYzccQE5yVJSr7RQilRawxnAtZXt6JB70YpX4xlfvpipit4R+OmQTurJGGwb8Pgnr4LvotydCjup6wv2Bk/z3UdGA7Sl+FU5a+0}&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
188 // <-- prod-mode
189 
190 // --> test-mode
191 //        // DEFINITIONS FOR LOCAL TESTNET
192 //        string constant ORACLIZE_RATINGS_BASE_URL =
193 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
194 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
195 //        string constant ORACLIZE_RATINGS_QUERY =
196 //            // for testrpc:
197 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
198 //        string constant ORACLIZE_STATUS_BASE_URL =
199 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
200 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
201 //        string constant ORACLIZE_STATUS_QUERY =
202 //            // for testrpc:
203 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
204 // <-- test-mode
205 }
206 
207 // File: contracts/FlightDelayControllerInterface.sol
208 
209 /**
210  * FlightDelay with Oraclized Underwriting and Payout
211  *
212  * @description Contract interface
213  * @copyright (c) 2017 etherisc GmbH
214  * @author Christoph Mussenbrock, Stephan Karpischek
215  */
216 
217 pragma solidity ^0.4.11;
218 
219 
220 contract FlightDelayControllerInterface {
221 
222     function isOwner(address _addr) public returns (bool _isOwner);
223 
224     function selfRegister(bytes32 _id) public returns (bool result);
225 
226     function getContract(bytes32 _id) public returns (address _addr);
227 }
228 
229 // File: contracts/FlightDelayDatabaseModel.sol
230 
231 /**
232  * FlightDelay with Oraclized Underwriting and Payout
233  *
234  * @description Database model
235  * @copyright (c) 2017 etherisc GmbH
236  * @author Christoph Mussenbrock, Stephan Karpischek
237  */
238 
239 pragma solidity ^0.4.11;
240 
241 
242 contract FlightDelayDatabaseModel {
243 
244     // Ledger accounts.
245     enum Acc {
246         Premium,      // 0
247         RiskFund,     // 1
248         Payout,       // 2
249         Balance,      // 3
250         Reward,       // 4
251         OraclizeCosts // 5
252     }
253 
254     // policy Status Codes and meaning:
255     //
256     // 00 = Applied:	  the customer has payed a premium, but the oracle has
257     //					        not yet checked and confirmed.
258     //					        The customer can still revoke the policy.
259     // 01 = Accepted:	  the oracle has checked and confirmed.
260     //					        The customer can still revoke the policy.
261     // 02 = Revoked:	  The customer has revoked the policy.
262     //					        The premium minus cancellation fee is payed back to the
263     //					        customer by the oracle.
264     // 03 = PaidOut:	  The flight has ended with delay.
265     //					        The oracle has checked and payed out.
266     // 04 = Expired:	  The flight has endet with <15min. delay.
267     //					        No payout.
268     // 05 = Declined:	  The application was invalid.
269     //					        The premium minus cancellation fee is payed back to the
270     //					        customer by the oracle.
271     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
272     //					        for unknown reasons.
273     //					        The funds remain in the contracts RiskFund.
274 
275 
276     //                   00       01        02       03        04      05           06
277     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
278 
279     // oraclize callback types:
280     enum oraclizeState { ForUnderwriting, ForPayout }
281 
282     //               00   01   02   03
283     enum Currency { ETH, EUR, USD, GBP }
284 
285     // the policy structure: this structure keeps track of the individual parameters of a policy.
286     // typically customer address, premium and some status information.
287     struct Policy {
288         // 0 - the customer
289         address customer;
290 
291         // 1 - premium
292         uint premium;
293         // risk specific parameters:
294         // 2 - pointer to the risk in the risks mapping
295         bytes32 riskId;
296         // custom payout pattern
297         // in future versions, customer will be able to tamper with this array.
298         // to keep things simple, we have decided to hard-code the array for all policies.
299         // uint8[5] pattern;
300         // 3 - probability weight. this is the central parameter
301         uint weight;
302         // 4 - calculated Payout
303         uint calculatedPayout;
304         // 5 - actual Payout
305         uint actualPayout;
306 
307         // status fields:
308         // 6 - the state of the policy
309         policyState state;
310         // 7 - time of last state change
311         uint stateTime;
312         // 8 - state change message/reason
313         bytes32 stateMessage;
314         // 9 - TLSNotary Proof
315         bytes proof;
316         // 10 - Currency
317         Currency currency;
318         // 10 - External customer id
319         bytes32 customerExternalId;
320     }
321 
322     // the risk structure; this structure keeps track of the risk-
323     // specific parameters.
324     // several policies can share the same risk structure (typically
325     // some people flying with the same plane)
326     struct Risk {
327         // 0 - Airline Code + FlightNumber
328         bytes32 carrierFlightNumber;
329         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
330         bytes32 departureYearMonthDay;
331         // 2 - the inital arrival time
332         uint arrivalTime;
333         // 3 - the final delay in minutes
334         uint delayInMinutes;
335         // 4 - the determined delay category (0-5)
336         uint8 delay;
337         // 5 - we limit the cumulated weighted premium to avoid cluster risks
338         uint cumulatedWeightedPremium;
339         // 6 - max cumulated Payout for this risk
340         uint premiumMultiplier;
341     }
342 
343     // the oraclize callback structure: we use several oraclize calls.
344     // all oraclize calls will result in a common callback to __callback(...).
345     // to keep track of the different querys we have to introduce this struct.
346     struct OraclizeCallback {
347         // for which policy have we called?
348         uint policyId;
349         // for which purpose did we call? {ForUnderwrite | ForPayout}
350         oraclizeState oState;
351         // time
352         uint oraclizeTime;
353     }
354 
355     struct Customer {
356         bytes32 customerExternalId;
357         bool identityConfirmed;
358     }
359 }
360 
361 // File: contracts/FlightDelayControlledContract.sol
362 
363 /**
364  * FlightDelay with Oraclized Underwriting and Payout
365  *
366  * @description Controlled contract Interface
367  * @copyright (c) 2017 etherisc GmbH
368  * @author Christoph Mussenbrock
369  */
370 
371 pragma solidity ^0.4.11;
372 
373 
374 
375 
376 
377 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
378 
379     address public controller;
380     FlightDelayControllerInterface FD_CI;
381 
382     modifier onlyController() {
383         require(msg.sender == controller);
384         _;
385     }
386 
387     function setController(address _controller) internal returns (bool _result) {
388         controller = _controller;
389         FD_CI = FlightDelayControllerInterface(_controller);
390         _result = true;
391     }
392 
393     function destruct() public onlyController {
394         selfdestruct(controller);
395     }
396 
397     function setContracts() public onlyController {}
398 
399     function getContract(bytes32 _id) internal returns (address _addr) {
400         _addr = FD_CI.getContract(_id);
401     }
402 }
403 
404 // File: contracts/Owned.sol
405 
406 /**
407  * FlightDelay with Oraclized Underwriting and Payout
408  *
409  * @description	Owned pattern
410  * @copyright (c) 2017 etherisc GmbH
411  * @author Christoph Mussenbrock, Stephan Karpischek
412  */
413 
414 pragma solidity ^0.4.11;
415 
416 /**
417  * @title Ownable
418  * @dev The Ownable contract has an owner address, and provides basic authorization control
419  * functions, this simplifies the implementation of "user permissions".
420  */
421 contract Owned {
422 
423     address public owner;
424 
425     /**
426      * @dev The Owned constructor sets the original `owner` of the contract to the sender
427      * account.
428      */
429     function Owned() {
430         owner = msg.sender;
431     }
432 
433     /**
434      * @dev Throws if called by any account other than the owner.
435      */
436     modifier onlyOwner() {
437         require(owner == msg.sender);
438         _;
439     }
440 }
441 
442 // File: contracts/FlightDelayController.sol
443 
444 /**
445  * FlightDelay with Oraclized Underwriting and Payout
446  *
447  * @description Controller contract
448  * @copyright (c) 2017 etherisc GmbH
449  * @author Christoph Mussenbrock
450  */
451 
452 pragma solidity ^0.4.11;
453 
454 
455 
456 
457 
458 contract FlightDelayController is Owned, FlightDelayConstants {
459 
460     struct Controller {
461         address addr;
462         bool isControlled;
463         bool isInitialized;
464     }
465 
466     mapping (bytes32 => Controller) public contracts;
467     bytes32[] public contractIds;
468 
469     /**
470     * Constructor.
471     */
472     function FlightDelayController() public {
473         registerContract(owner, "FD.Owner", false);
474         registerContract(address(this), "FD.Controller", false);
475     }
476 
477     /**
478      * @dev Allows the current owner to transfer control of the contract to a newOwner.
479      * @param _newOwner The address to transfer ownership to.
480      */
481     function transferOwnership(address _newOwner) public onlyOwner {
482         require(_newOwner != address(0));
483         owner = _newOwner;
484         setContract(_newOwner, "FD.Owner", false);
485     }
486 
487     /**
488     * Store address of one contract in mapping.
489     * @param _addr       Address of contract
490     * @param _id         ID of contract
491     */
492     function setContract(address _addr, bytes32 _id, bool _isControlled) internal {
493         contracts[_id].addr = _addr;
494         contracts[_id].isControlled = _isControlled;
495     }
496 
497     /**
498     * Get contract address from ID. This function is called by the
499     * contract's setContracts function.
500     * @param _id         ID of contract
501     * @return The address of the contract.
502     */
503     function getContract(bytes32 _id) public returns (address _addr) {
504         _addr = contracts[_id].addr;
505     }
506 
507     /**
508     * Registration of contracts.
509     * It will only accept calls of deployments initiated by the owner.
510     * @param _id         ID of contract
511     * @return  bool        success
512     */
513     function registerContract(address _addr, bytes32 _id, bool _isControlled) public onlyOwner returns (bool _result) {
514         setContract(_addr, _id, _isControlled);
515         contractIds.push(_id);
516         _result = true;
517     }
518 
519     /**
520     * Deregister a contract.
521     * In future, contracts should be exchangeable.
522     * @param _id         ID of contract
523     * @return  bool        success
524     */
525     function deregister(bytes32 _id) public onlyOwner returns (bool _result) {
526         if (getContract(_id) == 0x0) {
527             return false;
528         }
529         setContract(0x0, _id, false);
530         _result = true;
531     }
532 
533     /**
534     * After deploying all contracts, this function is called and calls
535     * setContracts() for every registered contract.
536     * This call pulls the addresses of the needed contracts in the respective contract.
537     * We assume that contractIds.length is small, so this won't run out of gas.
538     */
539     function setAllContracts() public onlyOwner {
540         FlightDelayControlledContract controlledContract;
541         // TODO: Check for upper bound for i
542         // i = 0 is FD.Owner, we skip this. // check!
543         for (uint i = 0; i < contractIds.length; i++) {
544             if (contracts[contractIds[i]].isControlled == true) {
545                 controlledContract = FlightDelayControlledContract(contracts[contractIds[i]].addr);
546                 controlledContract.setContracts();
547             }
548         }
549     }
550 
551     function setOneContract(uint i) public onlyOwner {
552         FlightDelayControlledContract controlledContract;
553         // TODO: Check for upper bound for i
554         controlledContract = FlightDelayControlledContract(contracts[contractIds[i]].addr);
555         controlledContract.setContracts();
556     }
557 
558     /**
559     * Destruct one contract.
560     * @param _id         ID of contract to destroy.
561     */
562     function destructOne(bytes32 _id) public onlyOwner {
563         address addr = getContract(_id);
564         if (addr != 0x0) {
565             FlightDelayControlledContract(addr).destruct();
566         }
567     }
568 
569     /**
570     * Destruct all contracts.
571     * We assume that contractIds.length is small, so this won't run out of gas.
572     * Otherwise, you can still destroy one contract after the other with destructOne.
573     */
574     function destructAll() public onlyOwner {
575         // TODO: Check for upper bound for i
576         for (uint i = 0; i < contractIds.length; i++) {
577             if (contracts[contractIds[i]].isControlled == true) {
578                 destructOne(contractIds[i]);
579             }
580         }
581 
582         selfdestruct(owner);
583     }
584 }