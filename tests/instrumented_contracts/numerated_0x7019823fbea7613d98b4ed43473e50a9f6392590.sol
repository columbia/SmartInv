1 /**
2  * FlightDelay with Oraclized Underwriting and Payout
3  *
4  * @description	AccessControllerInterface
5  * @copyright (c) 2017 etherisc GmbH
6  * @author Christoph Mussenbrock
7  */
8 
9 pragma solidity ^0.4.11;
10 
11 
12 contract FlightDelayAccessControllerInterface {
13 
14     function setPermissionById(uint8 _perm, bytes32 _id) public;
15 
16     function setPermissionById(uint8 _perm, bytes32 _id, bool _access) public;
17 
18     function setPermissionByAddress(uint8 _perm, address _addr) public;
19 
20     function setPermissionByAddress(uint8 _perm, address _addr, bool _access) public;
21 
22     function checkPermission(uint8 _perm, address _addr) public returns (bool _success);
23 }
24 
25 // File: contracts/FlightDelayConstants.sol
26 
27 /**
28  * FlightDelay with Oraclized Underwriting and Payout
29  *
30  * @description	Events and Constants
31  * @copyright (c) 2017 etherisc GmbH
32  * @author Christoph Mussenbrock
33  */
34 
35 pragma solidity ^0.4.11;
36 
37 
38 contract FlightDelayConstants {
39 
40     /*
41     * General events
42     */
43 
44 // --> test-mode
45 //        event LogUint(string _message, uint _uint);
46 //        event LogUintEth(string _message, uint ethUint);
47 //        event LogUintTime(string _message, uint timeUint);
48 //        event LogInt(string _message, int _int);
49 //        event LogAddress(string _message, address _address);
50 //        event LogBytes32(string _message, bytes32 hexBytes32);
51 //        event LogBytes(string _message, bytes hexBytes);
52 //        event LogBytes32Str(string _message, bytes32 strBytes32);
53 //        event LogString(string _message, string _string);
54 //        event LogBool(string _message, bool _bool);
55 //        event Log(address);
56 // <-- test-mode
57 
58     event LogPolicyApplied(
59         uint _policyId,
60         address _customer,
61         bytes32 strCarrierFlightNumber,
62         uint ethPremium
63     );
64     event LogPolicyAccepted(
65         uint _policyId,
66         uint _statistics0,
67         uint _statistics1,
68         uint _statistics2,
69         uint _statistics3,
70         uint _statistics4,
71         uint _statistics5
72     );
73     event LogPolicyPaidOut(
74         uint _policyId,
75         uint ethAmount
76     );
77     event LogPolicyExpired(
78         uint _policyId
79     );
80     event LogPolicyDeclined(
81         uint _policyId,
82         bytes32 strReason
83     );
84     event LogPolicyManualPayout(
85         uint _policyId,
86         bytes32 strReason
87     );
88     event LogSendFunds(
89         address _recipient,
90         uint8 _from,
91         uint ethAmount
92     );
93     event LogReceiveFunds(
94         address _sender,
95         uint8 _to,
96         uint ethAmount
97     );
98     event LogSendFail(
99         uint _policyId,
100         bytes32 strReason
101     );
102     event LogOraclizeCall(
103         uint _policyId,
104         bytes32 hexQueryId,
105         string _oraclizeUrl,
106         uint256 _oraclizeTime
107     );
108     event LogOraclizeCallback(
109         uint _policyId,
110         bytes32 hexQueryId,
111         string _result,
112         bytes hexProof
113     );
114     event LogSetState(
115         uint _policyId,
116         uint8 _policyState,
117         uint _stateTime,
118         bytes32 _stateMessage
119     );
120     event LogExternal(
121         uint256 _policyId,
122         address _address,
123         bytes32 _externalId
124     );
125 
126     /*
127     * General constants
128     */
129 
130     // minimum observations for valid prediction
131     uint constant MIN_OBSERVATIONS = 10;
132     // minimum premium to cover costs
133     uint constant MIN_PREMIUM = 50 finney;
134     // maximum premium
135     uint constant MAX_PREMIUM = 1 ether;
136     // maximum payout
137     uint constant MAX_PAYOUT = 1100 finney;
138 
139     uint constant MIN_PREMIUM_EUR = 1500 wei;
140     uint constant MAX_PREMIUM_EUR = 29000 wei;
141     uint constant MAX_PAYOUT_EUR = 30000 wei;
142 
143     uint constant MIN_PREMIUM_USD = 1700 wei;
144     uint constant MAX_PREMIUM_USD = 34000 wei;
145     uint constant MAX_PAYOUT_USD = 35000 wei;
146 
147     uint constant MIN_PREMIUM_GBP = 1300 wei;
148     uint constant MAX_PREMIUM_GBP = 25000 wei;
149     uint constant MAX_PAYOUT_GBP = 270 wei;
150 
151     // maximum cumulated weighted premium per risk
152     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;
153     // 1 percent for DAO, 1 percent for maintainer
154     uint8 constant REWARD_PERCENT = 2;
155     // reserve for tail risks
156     uint8 constant RESERVE_PERCENT = 1;
157     // the weight pattern; in future versions this may become part of the policy struct.
158     // currently can't be constant because of compiler restrictions
159     // WEIGHT_PATTERN[0] is not used, just to be consistent
160     uint8[6] WEIGHT_PATTERN = [
161         0,
162         10,
163         20,
164         30,
165         50,
166         50
167     ];
168 
169 // --> prod-mode
170     // DEFINITIONS FOR ROPSTEN AND MAINNET
171     // minimum time before departure for applying
172     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
173     // check for delay after .. minutes after scheduled arrival
174     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
175 // <-- prod-mode
176 
177 // --> test-mode
178 //        // DEFINITIONS FOR LOCAL TESTNET
179 //        // minimum time before departure for applying
180 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
181 //        // check for delay after .. minutes after scheduled arrival
182 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
183 // <-- test-mode
184 
185     // maximum duration of flight
186     uint constant MAX_FLIGHT_DURATION = 2 days;
187     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
188     uint constant CONTRACT_DEAD_LINE = 1922396399;
189 
190     // gas Constants for oraclize
191     uint constant ORACLIZE_GAS = 700000;
192     uint constant ORACLIZE_GASPRICE = 4000000000;
193 
194 
195     /*
196     * URLs and query strings for oraclize
197     */
198 
199 // --> prod-mode
200     // DEFINITIONS FOR ROPSTEN AND MAINNET
201     string constant ORACLIZE_RATINGS_BASE_URL =
202         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
203         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
204     string constant ORACLIZE_RATINGS_QUERY =
205         "?${[decrypt] BAr6Z9QolM2PQimF/pNC6zXldOvZ2qquOSKm/qJkJWnSGgAeRw21wBGnBbXiamr/ISC5SlcJB6wEPKthdc6F+IpqM/iXavKsalRUrGNuBsGfaMXr8fRQw6gLzqk0ecOFNeCa48/yqBvC/kas+jTKHiYxA3wTJrVZCq76Y03lZI2xxLaoniRk}).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
206     string constant ORACLIZE_STATUS_BASE_URL =
207         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
208         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
209     string constant ORACLIZE_STATUS_QUERY =
210         // pattern:
211         "?${[decrypt] BJxpwRaHujYTT98qI5slQJplj/VbfV7vYkMOp/Mr5D/5+gkgJQKZb0gVSCa6aKx2Wogo/cG7yaWINR6vnuYzccQE5yVJSr7RQilRawxnAtZXt6JB70YpX4xlfvpipit4R+OmQTurJGGwb8Pgnr4LvotydCjup6wv2Bk/z3UdGA7Sl+FU5a+0}&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
212 // <-- prod-mode
213 
214 // --> test-mode
215 //        // DEFINITIONS FOR LOCAL TESTNET
216 //        string constant ORACLIZE_RATINGS_BASE_URL =
217 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
218 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
219 //        string constant ORACLIZE_RATINGS_QUERY =
220 //            // for testrpc:
221 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
222 //        string constant ORACLIZE_STATUS_BASE_URL =
223 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
224 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
225 //        string constant ORACLIZE_STATUS_QUERY =
226 //            // for testrpc:
227 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
228 // <-- test-mode
229 }
230 
231 // File: contracts/FlightDelayControllerInterface.sol
232 
233 /**
234  * FlightDelay with Oraclized Underwriting and Payout
235  *
236  * @description Contract interface
237  * @copyright (c) 2017 etherisc GmbH
238  * @author Christoph Mussenbrock, Stephan Karpischek
239  */
240 
241 pragma solidity ^0.4.11;
242 
243 
244 contract FlightDelayControllerInterface {
245 
246     function isOwner(address _addr) public returns (bool _isOwner);
247 
248     function selfRegister(bytes32 _id) public returns (bool result);
249 
250     function getContract(bytes32 _id) public returns (address _addr);
251 }
252 
253 // File: contracts/FlightDelayDatabaseModel.sol
254 
255 /**
256  * FlightDelay with Oraclized Underwriting and Payout
257  *
258  * @description Database model
259  * @copyright (c) 2017 etherisc GmbH
260  * @author Christoph Mussenbrock, Stephan Karpischek
261  */
262 
263 pragma solidity ^0.4.11;
264 
265 
266 contract FlightDelayDatabaseModel {
267 
268     // Ledger accounts.
269     enum Acc {
270         Premium,      // 0
271         RiskFund,     // 1
272         Payout,       // 2
273         Balance,      // 3
274         Reward,       // 4
275         OraclizeCosts // 5
276     }
277 
278     // policy Status Codes and meaning:
279     //
280     // 00 = Applied:	  the customer has payed a premium, but the oracle has
281     //					        not yet checked and confirmed.
282     //					        The customer can still revoke the policy.
283     // 01 = Accepted:	  the oracle has checked and confirmed.
284     //					        The customer can still revoke the policy.
285     // 02 = Revoked:	  The customer has revoked the policy.
286     //					        The premium minus cancellation fee is payed back to the
287     //					        customer by the oracle.
288     // 03 = PaidOut:	  The flight has ended with delay.
289     //					        The oracle has checked and payed out.
290     // 04 = Expired:	  The flight has endet with <15min. delay.
291     //					        No payout.
292     // 05 = Declined:	  The application was invalid.
293     //					        The premium minus cancellation fee is payed back to the
294     //					        customer by the oracle.
295     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
296     //					        for unknown reasons.
297     //					        The funds remain in the contracts RiskFund.
298 
299 
300     //                   00       01        02       03        04      05           06
301     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
302 
303     // oraclize callback types:
304     enum oraclizeState { ForUnderwriting, ForPayout }
305 
306     //               00   01   02   03
307     enum Currency { ETH, EUR, USD, GBP }
308 
309     // the policy structure: this structure keeps track of the individual parameters of a policy.
310     // typically customer address, premium and some status information.
311     struct Policy {
312         // 0 - the customer
313         address customer;
314 
315         // 1 - premium
316         uint premium;
317         // risk specific parameters:
318         // 2 - pointer to the risk in the risks mapping
319         bytes32 riskId;
320         // custom payout pattern
321         // in future versions, customer will be able to tamper with this array.
322         // to keep things simple, we have decided to hard-code the array for all policies.
323         // uint8[5] pattern;
324         // 3 - probability weight. this is the central parameter
325         uint weight;
326         // 4 - calculated Payout
327         uint calculatedPayout;
328         // 5 - actual Payout
329         uint actualPayout;
330 
331         // status fields:
332         // 6 - the state of the policy
333         policyState state;
334         // 7 - time of last state change
335         uint stateTime;
336         // 8 - state change message/reason
337         bytes32 stateMessage;
338         // 9 - TLSNotary Proof
339         bytes proof;
340         // 10 - Currency
341         Currency currency;
342         // 10 - External customer id
343         bytes32 customerExternalId;
344     }
345 
346     // the risk structure; this structure keeps track of the risk-
347     // specific parameters.
348     // several policies can share the same risk structure (typically
349     // some people flying with the same plane)
350     struct Risk {
351         // 0 - Airline Code + FlightNumber
352         bytes32 carrierFlightNumber;
353         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
354         bytes32 departureYearMonthDay;
355         // 2 - the inital arrival time
356         uint arrivalTime;
357         // 3 - the final delay in minutes
358         uint delayInMinutes;
359         // 4 - the determined delay category (0-5)
360         uint8 delay;
361         // 5 - we limit the cumulated weighted premium to avoid cluster risks
362         uint cumulatedWeightedPremium;
363         // 6 - max cumulated Payout for this risk
364         uint premiumMultiplier;
365     }
366 
367     // the oraclize callback structure: we use several oraclize calls.
368     // all oraclize calls will result in a common callback to __callback(...).
369     // to keep track of the different querys we have to introduce this struct.
370     struct OraclizeCallback {
371         // for which policy have we called?
372         uint policyId;
373         // for which purpose did we call? {ForUnderwrite | ForPayout}
374         oraclizeState oState;
375         // time
376         uint oraclizeTime;
377     }
378 
379     struct Customer {
380         bytes32 customerExternalId;
381         bool identityConfirmed;
382     }
383 }
384 
385 // File: contracts/FlightDelayControlledContract.sol
386 
387 /**
388  * FlightDelay with Oraclized Underwriting and Payout
389  *
390  * @description Controlled contract Interface
391  * @copyright (c) 2017 etherisc GmbH
392  * @author Christoph Mussenbrock
393  */
394 
395 pragma solidity ^0.4.11;
396 
397 
398 
399 
400 
401 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
402 
403     address public controller;
404     FlightDelayControllerInterface FD_CI;
405 
406     modifier onlyController() {
407         require(msg.sender == controller);
408         _;
409     }
410 
411     function setController(address _controller) internal returns (bool _result) {
412         controller = _controller;
413         FD_CI = FlightDelayControllerInterface(_controller);
414         _result = true;
415     }
416 
417     function destruct() public onlyController {
418         selfdestruct(controller);
419     }
420 
421     function setContracts() public onlyController {}
422 
423     function getContract(bytes32 _id) internal returns (address _addr) {
424         _addr = FD_CI.getContract(_id);
425     }
426 }
427 
428 // File: contracts/FlightDelayDatabaseInterface.sol
429 
430 /**
431  * FlightDelay with Oraclized Underwriting and Payout
432  *
433  * @description Database contract interface
434  * @copyright (c) 2017 etherisc GmbH
435  * @author Christoph Mussenbrock, Stephan Karpischek
436  */
437 
438 pragma solidity ^0.4.11;
439 
440 
441 
442 
443 contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {
444 
445     uint public MIN_DEPARTURE_LIM;
446 
447     uint public MAX_DEPARTURE_LIM;
448 
449     bytes32[] public validOrigins;
450 
451     bytes32[] public validDestinations;
452 
453     function countOrigins() public constant returns (uint256 _length);
454 
455     function getOriginByIndex(uint256 _i) public constant returns (bytes32 _origin);
456 
457     function countDestinations() public constant returns (uint256 _length);
458 
459     function getDestinationByIndex(uint256 _i) public constant returns (bytes32 _destination);
460 
461     function setAccessControl(address _contract, address _caller, uint8 _perm) public;
462 
463     function setAccessControl(
464         address _contract,
465         address _caller,
466         uint8 _perm,
467         bool _access
468     ) public;
469 
470     function getAccessControl(address _contract, address _caller, uint8 _perm) public returns (bool _allowed) ;
471 
472     function setLedger(uint8 _index, int _value) public;
473 
474     function getLedger(uint8 _index) public returns (int _value) ;
475 
476     function getCustomerPremium(uint _policyId) public returns (address _customer, uint _premium) ;
477 
478     function getPolicyData(uint _policyId) public returns (address _customer, uint _premium, uint _weight) ;
479 
480     function getPolicyState(uint _policyId) public returns (policyState _state) ;
481 
482     function getRiskId(uint _policyId) public returns (bytes32 _riskId);
483 
484     function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) public returns (uint _policyId) ;
485 
486     function setState(
487         uint _policyId,
488         policyState _state,
489         uint _stateTime,
490         bytes32 _stateMessage
491     ) public;
492 
493     function setWeight(uint _policyId, uint _weight, bytes _proof) public;
494 
495     function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout) public;
496 
497     function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes) public;
498 
499     function getRiskParameters(bytes32 _riskId)
500         public returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime) ;
501 
502     function getPremiumFactors(bytes32 _riskId)
503         public returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);
504 
505     function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)
506         public returns (bytes32 _riskId);
507 
508     function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier) public;
509 
510     function getOraclizeCallback(bytes32 _queryId)
511         public returns (uint _policyId, uint _oraclizeTime) ;
512 
513     function getOraclizePolicyId(bytes32 _queryId)
514         public returns (uint _policyId) ;
515 
516     function createOraclizeCallback(
517         bytes32 _queryId,
518         uint _policyId,
519         oraclizeState _oraclizeState,
520         uint _oraclizeTime
521     ) public;
522 
523     function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)
524         public returns (bool _result) ;
525 }
526 
527 // File: contracts/FlightDelayDatabase.sol
528 
529 /**
530  * FlightDelay with Oraclized Underwriting and Payout
531  *
532  * @description Database contract
533  * @copyright (c) 2017 etherisc GmbH
534  * @author Christoph Mussenbrock, Stephan Karpischek
535  */
536 
537 pragma solidity ^0.4.11;
538 
539 
540 
541 
542 
543 
544 
545 contract FlightDelayDatabase is FlightDelayControlledContract, FlightDelayDatabaseInterface, FlightDelayConstants {
546 
547     uint public MIN_DEPARTURE_LIM;
548 
549     uint public MAX_DEPARTURE_LIM;
550 
551     bytes32[] public validOrigins;
552     bytes32[] public validDestinations;
553 
554     // Table of policies
555     Policy[] public policies;
556 
557     mapping (bytes32 => uint[]) public extCustomerPolicies;
558 
559     mapping (address => Customer) public customers;
560 
561     // Lookup policyIds from customer addresses
562     mapping (address => uint[]) public customerPolicies;
563 
564     // Lookup policy Ids from queryIds
565     mapping (bytes32 => OraclizeCallback) public oraclizeCallbacks;
566 
567     // Lookup risks from risk IDs
568     mapping (bytes32 => Risk) public risks;
569 
570     // Lookup AccessControl
571     mapping(address => mapping(address => mapping(uint8 => bool))) public accessControl;
572 
573     // Lookup accounts of internal ledger
574     int[6] public ledger;
575 
576     FlightDelayAccessControllerInterface FD_AC;
577 
578     function FlightDelayDatabase (address _controller) public {
579         setController(_controller);
580     }
581 
582     function setContracts() public onlyController {
583         FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));
584 
585         FD_AC.setPermissionById(101, "FD.NewPolicy");
586         FD_AC.setPermissionById(101, "FD.Underwrite");
587 
588         FD_AC.setPermissionById(101, "FD.Payout");
589         FD_AC.setPermissionById(101, "FD.Ledger");
590 
591         FD_AC.setPermissionById(102, "FD.Owner");
592     }
593 
594     function setMinDepartureLim(uint _timestamp) returns (bool _success) {
595         require(FD_AC.checkPermission(102, msg.sender));
596 
597         MIN_DEPARTURE_LIM = _timestamp;
598         _success = true;
599     }
600 
601     function setMaxDepartureLim(uint _timestamp) returns (bool _success) {
602         require(FD_AC.checkPermission(102, msg.sender));
603 
604         MAX_DEPARTURE_LIM = _timestamp;
605         _success = true;
606     }
607 
608     function addOrigin(bytes32 _origin) returns (uint256 _index) {
609         require(FD_AC.checkPermission(102, msg.sender));
610 
611         validOrigins.push(_origin);
612         _index = validOrigins.length - 1;
613     }
614 
615     function removeOriginByIndex(uint256 _index) returns (bool _success) {
616         require(FD_AC.checkPermission(102, msg.sender));
617 
618         if (validOrigins.length == 0) {
619             return false;
620         } else {
621             bytes32 lastElement = validOrigins[validOrigins.length - 1];
622             validOrigins[_index] = lastElement;
623             validOrigins.length--;
624             return true;
625         }
626     }
627 
628     function countOrigins() public constant returns (uint256 _length) {
629         _length = validOrigins.length;
630     }
631 
632     function getOriginByIndex(uint256 _i) public constant returns (bytes32 _origin) {
633         _origin = validOrigins[_i];
634     }
635 
636     function addDestination(bytes32 _origin) returns (uint256 _index) {
637         require(FD_AC.checkPermission(102, msg.sender));
638 
639         validDestinations.push(_origin);
640         _index = validDestinations.length - 1;
641     }
642 
643     function removeDestinationByIndex(uint256 _index) returns (bool _success) {
644         require(FD_AC.checkPermission(102, msg.sender));
645 
646         if (validDestinations.length == 0) {
647             return false;
648         } else {
649             bytes32 lastElement = validDestinations[validDestinations.length - 1];
650             validDestinations[_index] = lastElement;
651             validDestinations.length--;
652             return true;
653         }
654     }
655 
656     function countDestinations() public constant returns (uint256 _length) {
657         _length = validDestinations.length;
658     }
659 
660     function getDestinationByIndex(uint256 _i) public constant returns (bytes32 _destination) {
661         _destination = validDestinations[_i];
662     }
663 
664 
665     // Getter and Setter for AccessControl
666     function setAccessControl (
667         address _contract,
668         address _caller,
669         uint8 _perm,
670         bool _access
671     ) public {
672         // one and only hardcoded accessControl
673         require(msg.sender == FD_CI.getContract("FD.AccessController"));
674         accessControl[_contract][_caller][_perm] = _access;
675     }
676 
677 // --> test-mode
678 //        function setAccessControlTestOnly (
679 //            address _contract,
680 //            address _caller,
681 //            uint8 _perm,
682 //            bool _access
683 //        ) public {
684 //            accessControl[_contract][_caller][_perm] = _access;
685 //        }
686 // <-- test-mode
687 
688     function setAccessControl(address _contract, address _caller, uint8 _perm) public {
689         setAccessControl(
690             _contract,
691             _caller,
692             _perm,
693             true
694         );
695     }
696 
697     function getAccessControl(address _contract, address _caller, uint8 _perm) public returns (bool _allowed) {
698         _allowed = accessControl[_contract][_caller][_perm];
699     }
700 
701     // Getter and Setter for ledger
702     function setLedger(uint8 _index, int _value) public {
703         require(FD_AC.checkPermission(101, msg.sender));
704 
705         int previous = ledger[_index];
706         ledger[_index] += _value;
707 
708 // --> debug-mode
709 //            LogInt("previous", previous);
710 //            LogInt("ledger[_index]", ledger[_index]);
711 //            LogInt("_value", _value);
712 // <-- debug-mode
713 
714         // check for int overflow
715         if (_value < 0) {
716             assert(ledger[_index] < previous);
717         } else if (_value > 0) {
718             assert(ledger[_index] > previous);
719         }
720     }
721 
722     function getLedger(uint8 _index) public returns (int _value) {
723         _value = ledger[_index];
724     }
725 
726     // Getter and Setter for policies
727     function getCustomerPremium(uint _policyId) public returns (address _customer, uint _premium) {
728         Policy storage p = policies[_policyId];
729         _customer = p.customer;
730         _premium = p.premium;
731     }
732 
733     function getPolicyData(uint _policyId) public returns (address _customer, uint _weight, uint _premium) {
734         Policy storage p = policies[_policyId];
735         _customer = p.customer;
736         _weight = p.weight;
737         _premium = p.premium;
738     }
739 
740     function getPolicyState(uint _policyId) public returns (policyState _state) {
741         Policy storage p = policies[_policyId];
742         _state = p.state;
743     }
744 
745     function getRiskId(uint _policyId) public returns (bytes32 _riskId) {
746         Policy storage p = policies[_policyId];
747         _riskId = p.riskId;
748     }
749 
750     function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) public returns (uint _policyId) {
751         require(FD_AC.checkPermission(101, msg.sender));
752 
753         _policyId = policies.length++;
754 
755         //todo: check for ovewflows
756 
757 // --> test-mode
758 //            LogUint("_policyId", _policyId);
759 // <-- test-mode
760 
761         customerPolicies[_customer].push(_policyId);
762         extCustomerPolicies[_customerExternalId].push(_policyId);
763 
764         Policy storage p = policies[_policyId];
765 
766         p.customer = _customer;
767         p.currency = _currency;
768         p.customerExternalId = _customerExternalId;
769         p.premium = _premium;
770         p.riskId = _riskId;
771     }
772 
773     function setState(
774         uint _policyId,
775         policyState _state,
776         uint _stateTime,
777         bytes32 _stateMessage
778     ) public {
779         require(FD_AC.checkPermission(101, msg.sender));
780 
781         LogSetState(
782             _policyId,
783             uint8(_state),
784             _stateTime,
785             _stateMessage
786         );
787 
788         Policy storage p = policies[_policyId];
789 
790         p.state = _state;
791         p.stateTime = _stateTime;
792         p.stateMessage = _stateMessage;
793     }
794 
795     function setWeight(uint _policyId, uint _weight, bytes _proof) public {
796         require(FD_AC.checkPermission(101, msg.sender));
797 
798         Policy storage p = policies[_policyId];
799 
800         p.weight = _weight;
801         p.proof = _proof;
802     }
803 
804     function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout) public {
805         require(FD_AC.checkPermission(101, msg.sender));
806 
807         Policy storage p = policies[_policyId];
808 
809         p.calculatedPayout = _calculatedPayout;
810         p.actualPayout = _actualPayout;
811     }
812 
813     function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes) public {
814         require(FD_AC.checkPermission(101, msg.sender));
815 
816         Risk storage r = risks[policies[_policyId].riskId];
817 
818         r.delay = _delay;
819         r.delayInMinutes = _delayInMinutes;
820     }
821 
822     // Getter and Setter for risks
823     function getRiskParameters(bytes32 _riskId) public returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime) {
824         Risk storage r = risks[_riskId];
825         _carrierFlightNumber = r.carrierFlightNumber;
826         _departureYearMonthDay = r.departureYearMonthDay;
827         _arrivalTime = r.arrivalTime;
828     }
829 
830     function getPremiumFactors(bytes32 _riskId) public returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier) {
831         Risk storage r = risks[_riskId];
832         _cumulatedWeightedPremium = r.cumulatedWeightedPremium;
833         _premiumMultiplier = r.premiumMultiplier;
834     }
835 
836     function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime) returns (bytes32 _riskId) {
837         require(FD_AC.checkPermission(101, msg.sender));
838 
839         _riskId = sha3(
840             _carrierFlightNumber,
841             _departureYearMonthDay,
842             _arrivalTime
843         );
844 
845 // --> test-mode
846 //            LogBytes32("riskId", _riskId);
847 // <-- test-mode
848 
849         Risk storage r = risks[_riskId];
850 
851         if (r.premiumMultiplier == 0) {
852             r.carrierFlightNumber = _carrierFlightNumber;
853             r.departureYearMonthDay = _departureYearMonthDay;
854             r.arrivalTime = _arrivalTime;
855         }
856     }
857 
858     function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier) public {
859         require(FD_AC.checkPermission(101, msg.sender));
860 
861         Risk storage r = risks[_riskId];
862         r.cumulatedWeightedPremium = _cumulatedWeightedPremium;
863         r.premiumMultiplier = _premiumMultiplier;
864     }
865 
866     // Getter and Setter for oraclizeCallbacks
867     function getOraclizeCallback(bytes32 _queryId) public returns (uint _policyId, uint _oraclizeTime) {
868         OraclizeCallback storage o = oraclizeCallbacks[_queryId];
869         _policyId = o.policyId;
870         _oraclizeTime = o.oraclizeTime;
871     }
872 
873     function getOraclizePolicyId(bytes32 _queryId) public returns (uint _policyId) {
874         OraclizeCallback storage o = oraclizeCallbacks[_queryId];
875         _policyId = o.policyId;
876     }
877 
878     function createOraclizeCallback(
879         bytes32 _queryId,
880         uint _policyId,
881         oraclizeState _oraclizeState,
882         uint _oraclizeTime) public {
883 
884         require(FD_AC.checkPermission(101, msg.sender));
885 
886         oraclizeCallbacks[_queryId] = OraclizeCallback(_policyId, _oraclizeState, _oraclizeTime);
887     }
888 
889     // mixed
890     function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset) public returns (bool _result) {
891         OraclizeCallback storage o = oraclizeCallbacks[_queryId];
892         Risk storage r = risks[_riskId];
893 
894         _result = o.oraclizeTime > r.arrivalTime + _offset;
895     }
896 }