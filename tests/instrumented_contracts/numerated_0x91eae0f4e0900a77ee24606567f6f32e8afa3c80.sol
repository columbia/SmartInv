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
105     // contracts release version
106     uint public constant MAJOR_VERSION = 1;
107     uint public constant MINOR_VERSION = 0;
108     uint public constant PATCH_VERSION = 2;
109 
110     // minimum observations for valid prediction
111     uint constant MIN_OBSERVATIONS = 10;
112     // minimum premium to cover costs
113     uint constant MIN_PREMIUM = 50 finney;
114     // maximum premium
115     uint constant MAX_PREMIUM = 1 ether;
116     // maximum payout
117     uint constant MAX_PAYOUT = 1100 finney;
118 
119     uint constant MIN_PREMIUM_EUR = 1500 wei;
120     uint constant MAX_PREMIUM_EUR = 29000 wei;
121     uint constant MAX_PAYOUT_EUR = 30000 wei;
122 
123     uint constant MIN_PREMIUM_USD = 1700 wei;
124     uint constant MAX_PREMIUM_USD = 34000 wei;
125     uint constant MAX_PAYOUT_USD = 35000 wei;
126 
127     uint constant MIN_PREMIUM_GBP = 1300 wei;
128     uint constant MAX_PREMIUM_GBP = 25000 wei;
129     uint constant MAX_PAYOUT_GBP = 270 wei;
130 
131     // maximum cumulated weighted premium per risk
132     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;
133     // 1 percent for DAO, 1 percent for maintainer
134     uint8 constant REWARD_PERCENT = 2;
135     // reserve for tail risks
136     uint8 constant RESERVE_PERCENT = 1;
137     // the weight pattern; in future versions this may become part of the policy struct.
138     // currently can't be constant because of compiler restrictions
139     // WEIGHT_PATTERN[0] is not used, just to be consistent
140     uint8[6] WEIGHT_PATTERN = [
141         0,
142         0,
143         0,
144         30,
145         50,
146         50
147     ];
148 
149 // --> prod-mode
150     // DEFINITIONS FOR ROPSTEN AND MAINNET
151     // minimum time before departure for applying
152     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
153     // check for delay after .. minutes after scheduled arrival
154     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
155 // <-- prod-mode
156 
157 // --> test-mode
158 //        // DEFINITIONS FOR LOCAL TESTNET
159 //        // minimum time before departure for applying
160 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
161 //        // check for delay after .. minutes after scheduled arrival
162 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
163 // <-- test-mode
164 
165     // maximum duration of flight
166     uint constant MAX_FLIGHT_DURATION = 2 days;
167     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
168     uint constant CONTRACT_DEAD_LINE = 1922396399;
169 
170     // gas Constants for oraclize
171     uint constant ORACLIZE_GAS = 700000;
172     uint constant ORACLIZE_GASPRICE = 4000000000;
173 
174 
175     /*
176     * URLs and query strings for oraclize
177     */
178 
179 // --> prod-mode
180     // DEFINITIONS FOR ROPSTEN AND MAINNET
181     string constant ORACLIZE_RATINGS_BASE_URL =
182         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
183         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
184     string constant ORACLIZE_RATINGS_QUERY =
185         "?${[decrypt] BJoM0BfTe82RtghrzzCbNA7b9E9tQIX8LtM+pRRh22RfQ5QhnVAv6Kk4SyaMwQKczC7YtinJ/Xm6PZMgKnWN7+/pFUfI2YcxaAW0vYuXJF4zCTxPYXa6j4shhce60AMBeKoZZsgn6Og+olgSpgpfi4MwkmmytwdCLHqat3gGUPklBhM1HR0x}).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
186     string constant ORACLIZE_STATUS_BASE_URL =
187         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
188         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
189     string constant ORACLIZE_STATUS_QUERY =
190         // pattern:
191         "?${[decrypt] BA3YyqF4iMQszBawvgG82bqX3fw7JoWA1thFsboUECR/L8JkBCgvaThg1LcUWbIntosEKs/kvqyzOtvdQfMgjYPV0c6hsq/gKQkmJYILZmLY4SgBebH8g0qbfrrjxF5gEbfCi2qoR6PSxcQzKIjgd4HvAaumlQd4CkJLmY463ymqNN9B8/PL}&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
192 // <-- prod-mode
193 
194 // --> test-mode
195 //        // DEFINITIONS FOR LOCAL TESTNET
196 //        string constant ORACLIZE_RATINGS_BASE_URL =
197 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
198 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
199 //        string constant ORACLIZE_RATINGS_QUERY =
200 //            // for testrpc:
201 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
202 //        string constant ORACLIZE_STATUS_BASE_URL =
203 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
204 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
205 //        string constant ORACLIZE_STATUS_QUERY =
206 //            // for testrpc:
207 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
208 // <-- test-mode
209 }
210 
211 // File: contracts/FlightDelayControllerInterface.sol
212 
213 /**
214  * FlightDelay with Oraclized Underwriting and Payout
215  *
216  * @description Contract interface
217  * @copyright (c) 2017 etherisc GmbH
218  * @author Christoph Mussenbrock, Stephan Karpischek
219  */
220 
221 pragma solidity ^0.4.11;
222 
223 
224 contract FlightDelayControllerInterface {
225 
226     function isOwner(address _addr) public returns (bool _isOwner);
227 
228     function selfRegister(bytes32 _id) public returns (bool result);
229 
230     function getContract(bytes32 _id) public returns (address _addr);
231 }
232 
233 // File: contracts/FlightDelayDatabaseModel.sol
234 
235 /**
236  * FlightDelay with Oraclized Underwriting and Payout
237  *
238  * @description Database model
239  * @copyright (c) 2017 etherisc GmbH
240  * @author Christoph Mussenbrock, Stephan Karpischek
241  */
242 
243 pragma solidity ^0.4.11;
244 
245 
246 contract FlightDelayDatabaseModel {
247 
248     // Ledger accounts.
249     enum Acc {
250         Premium,      // 0
251         RiskFund,     // 1
252         Payout,       // 2
253         Balance,      // 3
254         Reward,       // 4
255         OraclizeCosts // 5
256     }
257 
258     // policy Status Codes and meaning:
259     //
260     // 00 = Applied:	  the customer has payed a premium, but the oracle has
261     //					        not yet checked and confirmed.
262     //					        The customer can still revoke the policy.
263     // 01 = Accepted:	  the oracle has checked and confirmed.
264     //					        The customer can still revoke the policy.
265     // 02 = Revoked:	  The customer has revoked the policy.
266     //					        The premium minus cancellation fee is payed back to the
267     //					        customer by the oracle.
268     // 03 = PaidOut:	  The flight has ended with delay.
269     //					        The oracle has checked and payed out.
270     // 04 = Expired:	  The flight has endet with <15min. delay.
271     //					        No payout.
272     // 05 = Declined:	  The application was invalid.
273     //					        The premium minus cancellation fee is payed back to the
274     //					        customer by the oracle.
275     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
276     //					        for unknown reasons.
277     //					        The funds remain in the contracts RiskFund.
278 
279 
280     //                   00       01        02       03        04      05           06
281     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
282 
283     // oraclize callback types:
284     enum oraclizeState { ForUnderwriting, ForPayout }
285 
286     //               00   01   02   03
287     enum Currency { ETH, EUR, USD, GBP }
288 
289     // the policy structure: this structure keeps track of the individual parameters of a policy.
290     // typically customer address, premium and some status information.
291     struct Policy {
292         // 0 - the customer
293         address customer;
294 
295         // 1 - premium
296         uint premium;
297         // risk specific parameters:
298         // 2 - pointer to the risk in the risks mapping
299         bytes32 riskId;
300         // custom payout pattern
301         // in future versions, customer will be able to tamper with this array.
302         // to keep things simple, we have decided to hard-code the array for all policies.
303         // uint8[5] pattern;
304         // 3 - probability weight. this is the central parameter
305         uint weight;
306         // 4 - calculated Payout
307         uint calculatedPayout;
308         // 5 - actual Payout
309         uint actualPayout;
310 
311         // status fields:
312         // 6 - the state of the policy
313         policyState state;
314         // 7 - time of last state change
315         uint stateTime;
316         // 8 - state change message/reason
317         bytes32 stateMessage;
318         // 9 - TLSNotary Proof
319         bytes proof;
320         // 10 - Currency
321         Currency currency;
322         // 10 - External customer id
323         bytes32 customerExternalId;
324     }
325 
326     // the risk structure; this structure keeps track of the risk-
327     // specific parameters.
328     // several policies can share the same risk structure (typically
329     // some people flying with the same plane)
330     struct Risk {
331         // 0 - Airline Code + FlightNumber
332         bytes32 carrierFlightNumber;
333         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
334         bytes32 departureYearMonthDay;
335         // 2 - the inital arrival time
336         uint arrivalTime;
337         // 3 - the final delay in minutes
338         uint delayInMinutes;
339         // 4 - the determined delay category (0-5)
340         uint8 delay;
341         // 5 - we limit the cumulated weighted premium to avoid cluster risks
342         uint cumulatedWeightedPremium;
343         // 6 - max cumulated Payout for this risk
344         uint premiumMultiplier;
345     }
346 
347     // the oraclize callback structure: we use several oraclize calls.
348     // all oraclize calls will result in a common callback to __callback(...).
349     // to keep track of the different querys we have to introduce this struct.
350     struct OraclizeCallback {
351         // for which policy have we called?
352         uint policyId;
353         // for which purpose did we call? {ForUnderwrite | ForPayout}
354         oraclizeState oState;
355         // time
356         uint oraclizeTime;
357     }
358 
359     struct Customer {
360         bytes32 customerExternalId;
361         bool identityConfirmed;
362     }
363 }
364 
365 // File: contracts/FlightDelayControlledContract.sol
366 
367 /**
368  * FlightDelay with Oraclized Underwriting and Payout
369  *
370  * @description Controlled contract Interface
371  * @copyright (c) 2017 etherisc GmbH
372  * @author Christoph Mussenbrock
373  */
374 
375 pragma solidity ^0.4.11;
376 
377 
378 
379 
380 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
381 
382     address public controller;
383     FlightDelayControllerInterface FD_CI;
384 
385     modifier onlyController() {
386         require(msg.sender == controller);
387         _;
388     }
389 
390     function setController(address _controller) internal returns (bool _result) {
391         controller = _controller;
392         FD_CI = FlightDelayControllerInterface(_controller);
393         _result = true;
394     }
395 
396     function destruct() public onlyController {
397         selfdestruct(controller);
398     }
399 
400     function setContracts() public onlyController {}
401 
402     function getContract(bytes32 _id) internal returns (address _addr) {
403         _addr = FD_CI.getContract(_id);
404     }
405 }
406 
407 // File: contracts/Owned.sol
408 
409 /**
410  * FlightDelay with Oraclized Underwriting and Payout
411  *
412  * @description	Owned pattern
413  * @copyright (c) 2017 etherisc GmbH
414  * @author Christoph Mussenbrock, Stephan Karpischek
415  */
416 
417 pragma solidity ^0.4.11;
418 
419 /**
420  * @title Ownable
421  * @dev The Ownable contract has an owner address, and provides basic authorization control
422  * functions, this simplifies the implementation of "user permissions".
423  */
424 contract Owned {
425 
426     address public owner;
427 
428     /**
429      * @dev The Owned constructor sets the original `owner` of the contract to the sender
430      * account.
431      */
432     function Owned() {
433         owner = msg.sender;
434     }
435 
436     /**
437      * @dev Throws if called by any account other than the owner.
438      */
439     modifier onlyOwner() {
440         require(owner == msg.sender);
441         _;
442     }
443 }
444 
445 // File: contracts/FlightDelayController.sol
446 
447 /**
448  * FlightDelay with Oraclized Underwriting and Payout
449  *
450  * @description Controller contract
451  * @copyright (c) 2017 etherisc GmbH
452  * @author Christoph Mussenbrock
453  */
454 
455 pragma solidity ^0.4.11;
456 
457 
458 
459 
460 contract FlightDelayController is Owned, FlightDelayConstants {
461 
462     struct Controller {
463         address addr;
464         bool isControlled;
465         bool isInitialized;
466     }
467 
468     mapping (bytes32 => Controller) public contracts;
469     bytes32[] public contractIds;
470 
471     /**
472     * Constructor.
473     */
474     function FlightDelayController() public {
475         registerContract(owner, "FD.Owner", false);
476         registerContract(address(this), "FD.Controller", false);
477     }
478 
479     /**
480      * @dev Allows the current owner to transfer control of the contract to a newOwner.
481      * @param _newOwner The address to transfer ownership to.
482      */
483     function transferOwnership(address _newOwner) public onlyOwner {
484         require(_newOwner != address(0));
485         owner = _newOwner;
486         setContract(_newOwner, "FD.Owner", false);
487     }
488 
489     /**
490     * Store address of one contract in mapping.
491     * @param _addr       Address of contract
492     * @param _id         ID of contract
493     */
494     function setContract(address _addr, bytes32 _id, bool _isControlled) internal {
495         contracts[_id].addr = _addr;
496         contracts[_id].isControlled = _isControlled;
497     }
498 
499     /**
500     * Get contract address from ID. This function is called by the
501     * contract's setContracts function.
502     * @param _id         ID of contract
503     * @return The address of the contract.
504     */
505     function getContract(bytes32 _id) public returns (address _addr) {
506         _addr = contracts[_id].addr;
507     }
508 
509     /**
510     * Registration of contracts.
511     * It will only accept calls of deployments initiated by the owner.
512     * @param _id         ID of contract
513     * @return  bool        success
514     */
515     function registerContract(address _addr, bytes32 _id, bool _isControlled) public onlyOwner returns (bool _result) {
516         setContract(_addr, _id, _isControlled);
517         contractIds.push(_id);
518         _result = true;
519     }
520 
521     /**
522     * Deregister a contract.
523     * In future, contracts should be exchangeable.
524     * @param _id         ID of contract
525     * @return  bool        success
526     */
527     function deregister(bytes32 _id) public onlyOwner returns (bool _result) {
528         if (getContract(_id) == 0x0) {
529             return false;
530         }
531         setContract(0x0, _id, false);
532         _result = true;
533     }
534 
535     /**
536     * After deploying all contracts, this function is called and calls
537     * setContracts() for every registered contract.
538     * This call pulls the addresses of the needed contracts in the respective contract.
539     * We assume that contractIds.length is small, so this won't run out of gas.
540     */
541     function setAllContracts() public onlyOwner {
542         FlightDelayControlledContract controlledContract;
543         // TODO: Check for upper bound for i
544         // i = 0 is FD.Owner, we skip this. // check!
545         for (uint i = 0; i < contractIds.length; i++) {
546             if (contracts[contractIds[i]].isControlled == true) {
547                 controlledContract = FlightDelayControlledContract(contracts[contractIds[i]].addr);
548                 controlledContract.setContracts();
549             }
550         }
551     }
552 
553     function setOneContract(uint i) public onlyOwner {
554         FlightDelayControlledContract controlledContract;
555         // TODO: Check for upper bound for i
556         controlledContract = FlightDelayControlledContract(contracts[contractIds[i]].addr);
557         controlledContract.setContracts();
558     }
559 
560     /**
561     * Destruct one contract.
562     * @param _id         ID of contract to destroy.
563     */
564     function destructOne(bytes32 _id) public onlyOwner {
565         address addr = getContract(_id);
566         if (addr != 0x0) {
567             FlightDelayControlledContract(addr).destruct();
568         }
569     }
570 
571     /**
572     * Destruct all contracts.
573     * We assume that contractIds.length is small, so this won't run out of gas.
574     * Otherwise, you can still destroy one contract after the other with destructOne.
575     */
576     function destructAll() public onlyOwner {
577         // TODO: Check for upper bound for i
578         for (uint i = 0; i < contractIds.length; i++) {
579             if (contracts[contractIds[i]].isControlled == true) {
580                 destructOne(contractIds[i]);
581             }
582         }
583 
584         selfdestruct(owner);
585     }
586 }