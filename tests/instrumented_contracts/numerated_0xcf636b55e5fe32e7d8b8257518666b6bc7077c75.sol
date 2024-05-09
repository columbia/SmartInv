1 // File: contracts/FlightDelayAccessControllerInterface.sol
2 
3 /**
4  * FlightDelay with Oraclized Underwriting and Payout
5  *
6  * @description	AccessControllerInterface
7  * @copyright (c) 2017 etherisc GmbH
8  * @author Christoph Mussenbrock
9  */
10 
11 pragma solidity ^0.4.11;
12 
13 
14 contract FlightDelayAccessControllerInterface {
15 
16     function setPermissionById(uint8 _perm, bytes32 _id) public;
17 
18     function setPermissionById(uint8 _perm, bytes32 _id, bool _access) public;
19 
20     function setPermissionByAddress(uint8 _perm, address _addr) public;
21 
22     function setPermissionByAddress(uint8 _perm, address _addr, bool _access) public;
23 
24     function checkPermission(uint8 _perm, address _addr) public returns (bool _success);
25 }
26 
27 // File: contracts/FlightDelayConstants.sol
28 
29 /**
30  * FlightDelay with Oraclized Underwriting and Payout
31  *
32  * @description	Events and Constants
33  * @copyright (c) 2017 etherisc GmbH
34  * @author Christoph Mussenbrock
35  */
36 
37 pragma solidity ^0.4.11;
38 
39 
40 contract FlightDelayConstants {
41 
42     /*
43     * General events
44     */
45 
46 // --> test-mode
47 //        event LogUint(string _message, uint _uint);
48 //        event LogUintEth(string _message, uint ethUint);
49 //        event LogUintTime(string _message, uint timeUint);
50 //        event LogInt(string _message, int _int);
51 //        event LogAddress(string _message, address _address);
52 //        event LogBytes32(string _message, bytes32 hexBytes32);
53 //        event LogBytes(string _message, bytes hexBytes);
54 //        event LogBytes32Str(string _message, bytes32 strBytes32);
55 //        event LogString(string _message, string _string);
56 //        event LogBool(string _message, bool _bool);
57 //        event Log(address);
58 // <-- test-mode
59 
60     event LogPolicyApplied(
61         uint _policyId,
62         address _customer,
63         bytes32 strCarrierFlightNumber,
64         uint ethPremium
65     );
66     event LogPolicyAccepted(
67         uint _policyId,
68         uint _statistics0,
69         uint _statistics1,
70         uint _statistics2,
71         uint _statistics3,
72         uint _statistics4,
73         uint _statistics5
74     );
75     event LogPolicyPaidOut(
76         uint _policyId,
77         uint ethAmount
78     );
79     event LogPolicyExpired(
80         uint _policyId
81     );
82     event LogPolicyDeclined(
83         uint _policyId,
84         bytes32 strReason
85     );
86     event LogPolicyManualPayout(
87         uint _policyId,
88         bytes32 strReason
89     );
90     event LogSendFunds(
91         address _recipient,
92         uint8 _from,
93         uint ethAmount
94     );
95     event LogReceiveFunds(
96         address _sender,
97         uint8 _to,
98         uint ethAmount
99     );
100     event LogSendFail(
101         uint _policyId,
102         bytes32 strReason
103     );
104     event LogOraclizeCall(
105         uint _policyId,
106         bytes32 hexQueryId,
107         string _oraclizeUrl,
108         uint256 _oraclizeTime
109     );
110     event LogOraclizeCallback(
111         uint _policyId,
112         bytes32 hexQueryId,
113         string _result,
114         bytes hexProof
115     );
116     event LogSetState(
117         uint _policyId,
118         uint8 _policyState,
119         uint _stateTime,
120         bytes32 _stateMessage
121     );
122     event LogExternal(
123         uint256 _policyId,
124         address _address,
125         bytes32 _externalId
126     );
127 
128     /*
129     * General constants
130     */
131     // contracts release version
132     uint public constant MAJOR_VERSION = 1;
133     uint public constant MINOR_VERSION = 0;
134     uint public constant PATCH_VERSION = 2;
135 
136     // minimum observations for valid prediction
137     uint constant MIN_OBSERVATIONS = 10;
138     // minimum premium to cover costs
139     uint constant MIN_PREMIUM = 50 finney;
140     // maximum premium
141     uint constant MAX_PREMIUM = 1 ether;
142     // maximum payout
143     uint constant MAX_PAYOUT = 1100 finney;
144 
145     uint constant MIN_PREMIUM_EUR = 1500 wei;
146     uint constant MAX_PREMIUM_EUR = 29000 wei;
147     uint constant MAX_PAYOUT_EUR = 30000 wei;
148 
149     uint constant MIN_PREMIUM_USD = 1700 wei;
150     uint constant MAX_PREMIUM_USD = 34000 wei;
151     uint constant MAX_PAYOUT_USD = 35000 wei;
152 
153     uint constant MIN_PREMIUM_GBP = 1300 wei;
154     uint constant MAX_PREMIUM_GBP = 25000 wei;
155     uint constant MAX_PAYOUT_GBP = 270 wei;
156 
157     // maximum cumulated weighted premium per risk
158     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;
159     // 1 percent for DAO, 1 percent for maintainer
160     uint8 constant REWARD_PERCENT = 2;
161     // reserve for tail risks
162     uint8 constant RESERVE_PERCENT = 1;
163     // the weight pattern; in future versions this may become part of the policy struct.
164     // currently can't be constant because of compiler restrictions
165     // WEIGHT_PATTERN[0] is not used, just to be consistent
166     uint8[6] WEIGHT_PATTERN = [
167         0,
168         0,
169         0,
170         30,
171         50,
172         50
173     ];
174 
175 // --> prod-mode
176     // DEFINITIONS FOR ROPSTEN AND MAINNET
177     // minimum time before departure for applying
178     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
179     // check for delay after .. minutes after scheduled arrival
180     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
181 // <-- prod-mode
182 
183 // --> test-mode
184 //        // DEFINITIONS FOR LOCAL TESTNET
185 //        // minimum time before departure for applying
186 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
187 //        // check for delay after .. minutes after scheduled arrival
188 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
189 // <-- test-mode
190 
191     // maximum duration of flight
192     uint constant MAX_FLIGHT_DURATION = 2 days;
193     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
194     uint constant CONTRACT_DEAD_LINE = 1922396399;
195 
196     // gas Constants for oraclize
197     uint constant ORACLIZE_GAS = 700000;
198     uint constant ORACLIZE_GASPRICE = 4000000000;
199 
200 
201     /*
202     * URLs and query strings for oraclize
203     */
204 
205 // --> prod-mode
206     // DEFINITIONS FOR ROPSTEN AND MAINNET
207     string constant ORACLIZE_RATINGS_BASE_URL =
208         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
209         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
210     string constant ORACLIZE_RATINGS_QUERY =
211         "?${[decrypt] BJoM0BfTe82RtghrzzCbNA7b9E9tQIX8LtM+pRRh22RfQ5QhnVAv6Kk4SyaMwQKczC7YtinJ/Xm6PZMgKnWN7+/pFUfI2YcxaAW0vYuXJF4zCTxPYXa6j4shhce60AMBeKoZZsgn6Og+olgSpgpfi4MwkmmytwdCLHqat3gGUPklBhM1HR0x}).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
212     string constant ORACLIZE_STATUS_BASE_URL =
213         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
214         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
215     string constant ORACLIZE_STATUS_QUERY =
216         // pattern:
217         "?${[decrypt] BA3YyqF4iMQszBawvgG82bqX3fw7JoWA1thFsboUECR/L8JkBCgvaThg1LcUWbIntosEKs/kvqyzOtvdQfMgjYPV0c6hsq/gKQkmJYILZmLY4SgBebH8g0qbfrrjxF5gEbfCi2qoR6PSxcQzKIjgd4HvAaumlQd4CkJLmY463ymqNN9B8/PL}&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
218 // <-- prod-mode
219 
220 // --> test-mode
221 //        // DEFINITIONS FOR LOCAL TESTNET
222 //        string constant ORACLIZE_RATINGS_BASE_URL =
223 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
224 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
225 //        string constant ORACLIZE_RATINGS_QUERY =
226 //            // for testrpc:
227 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
228 //        string constant ORACLIZE_STATUS_BASE_URL =
229 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
230 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
231 //        string constant ORACLIZE_STATUS_QUERY =
232 //            // for testrpc:
233 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
234 // <-- test-mode
235 }
236 
237 // File: contracts/FlightDelayControllerInterface.sol
238 
239 /**
240  * FlightDelay with Oraclized Underwriting and Payout
241  *
242  * @description Contract interface
243  * @copyright (c) 2017 etherisc GmbH
244  * @author Christoph Mussenbrock, Stephan Karpischek
245  */
246 
247 pragma solidity ^0.4.11;
248 
249 
250 contract FlightDelayControllerInterface {
251 
252     function isOwner(address _addr) public returns (bool _isOwner);
253 
254     function selfRegister(bytes32 _id) public returns (bool result);
255 
256     function getContract(bytes32 _id) public returns (address _addr);
257 }
258 
259 // File: contracts/FlightDelayDatabaseModel.sol
260 
261 /**
262  * FlightDelay with Oraclized Underwriting and Payout
263  *
264  * @description Database model
265  * @copyright (c) 2017 etherisc GmbH
266  * @author Christoph Mussenbrock, Stephan Karpischek
267  */
268 
269 pragma solidity ^0.4.11;
270 
271 
272 contract FlightDelayDatabaseModel {
273 
274     // Ledger accounts.
275     enum Acc {
276         Premium,      // 0
277         RiskFund,     // 1
278         Payout,       // 2
279         Balance,      // 3
280         Reward,       // 4
281         OraclizeCosts // 5
282     }
283 
284     // policy Status Codes and meaning:
285     //
286     // 00 = Applied:	  the customer has payed a premium, but the oracle has
287     //					        not yet checked and confirmed.
288     //					        The customer can still revoke the policy.
289     // 01 = Accepted:	  the oracle has checked and confirmed.
290     //					        The customer can still revoke the policy.
291     // 02 = Revoked:	  The customer has revoked the policy.
292     //					        The premium minus cancellation fee is payed back to the
293     //					        customer by the oracle.
294     // 03 = PaidOut:	  The flight has ended with delay.
295     //					        The oracle has checked and payed out.
296     // 04 = Expired:	  The flight has endet with <15min. delay.
297     //					        No payout.
298     // 05 = Declined:	  The application was invalid.
299     //					        The premium minus cancellation fee is payed back to the
300     //					        customer by the oracle.
301     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
302     //					        for unknown reasons.
303     //					        The funds remain in the contracts RiskFund.
304 
305 
306     //                   00       01        02       03        04      05           06
307     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
308 
309     // oraclize callback types:
310     enum oraclizeState { ForUnderwriting, ForPayout }
311 
312     //               00   01   02   03
313     enum Currency { ETH, EUR, USD, GBP }
314 
315     // the policy structure: this structure keeps track of the individual parameters of a policy.
316     // typically customer address, premium and some status information.
317     struct Policy {
318         // 0 - the customer
319         address customer;
320 
321         // 1 - premium
322         uint premium;
323         // risk specific parameters:
324         // 2 - pointer to the risk in the risks mapping
325         bytes32 riskId;
326         // custom payout pattern
327         // in future versions, customer will be able to tamper with this array.
328         // to keep things simple, we have decided to hard-code the array for all policies.
329         // uint8[5] pattern;
330         // 3 - probability weight. this is the central parameter
331         uint weight;
332         // 4 - calculated Payout
333         uint calculatedPayout;
334         // 5 - actual Payout
335         uint actualPayout;
336 
337         // status fields:
338         // 6 - the state of the policy
339         policyState state;
340         // 7 - time of last state change
341         uint stateTime;
342         // 8 - state change message/reason
343         bytes32 stateMessage;
344         // 9 - TLSNotary Proof
345         bytes proof;
346         // 10 - Currency
347         Currency currency;
348         // 10 - External customer id
349         bytes32 customerExternalId;
350     }
351 
352     // the risk structure; this structure keeps track of the risk-
353     // specific parameters.
354     // several policies can share the same risk structure (typically
355     // some people flying with the same plane)
356     struct Risk {
357         // 0 - Airline Code + FlightNumber
358         bytes32 carrierFlightNumber;
359         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
360         bytes32 departureYearMonthDay;
361         // 2 - the inital arrival time
362         uint arrivalTime;
363         // 3 - the final delay in minutes
364         uint delayInMinutes;
365         // 4 - the determined delay category (0-5)
366         uint8 delay;
367         // 5 - we limit the cumulated weighted premium to avoid cluster risks
368         uint cumulatedWeightedPremium;
369         // 6 - max cumulated Payout for this risk
370         uint premiumMultiplier;
371     }
372 
373     // the oraclize callback structure: we use several oraclize calls.
374     // all oraclize calls will result in a common callback to __callback(...).
375     // to keep track of the different querys we have to introduce this struct.
376     struct OraclizeCallback {
377         // for which policy have we called?
378         uint policyId;
379         // for which purpose did we call? {ForUnderwrite | ForPayout}
380         oraclizeState oState;
381         // time
382         uint oraclizeTime;
383     }
384 
385     struct Customer {
386         bytes32 customerExternalId;
387         bool identityConfirmed;
388     }
389 }
390 
391 // File: contracts/FlightDelayControlledContract.sol
392 
393 /**
394  * FlightDelay with Oraclized Underwriting and Payout
395  *
396  * @description Controlled contract Interface
397  * @copyright (c) 2017 etherisc GmbH
398  * @author Christoph Mussenbrock
399  */
400 
401 pragma solidity ^0.4.11;
402 
403 
404 
405 
406 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
407 
408     address public controller;
409     FlightDelayControllerInterface FD_CI;
410 
411     modifier onlyController() {
412         require(msg.sender == controller);
413         _;
414     }
415 
416     function setController(address _controller) internal returns (bool _result) {
417         controller = _controller;
418         FD_CI = FlightDelayControllerInterface(_controller);
419         _result = true;
420     }
421 
422     function destruct() public onlyController {
423         selfdestruct(controller);
424     }
425 
426     function setContracts() public onlyController {}
427 
428     function getContract(bytes32 _id) internal returns (address _addr) {
429         _addr = FD_CI.getContract(_id);
430     }
431 }
432 
433 // File: contracts/FlightDelayDatabaseInterface.sol
434 
435 /**
436  * FlightDelay with Oraclized Underwriting and Payout
437  *
438  * @description Database contract interface
439  * @copyright (c) 2017 etherisc GmbH
440  * @author Christoph Mussenbrock, Stephan Karpischek
441  */
442 
443 pragma solidity ^0.4.11;
444 
445 
446 
447 contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {
448 
449     uint public MIN_DEPARTURE_LIM;
450 
451     uint public MAX_DEPARTURE_LIM;
452 
453     bytes32[] public validOrigins;
454 
455     bytes32[] public validDestinations;
456 
457     function countOrigins() public constant returns (uint256 _length);
458 
459     function getOriginByIndex(uint256 _i) public constant returns (bytes32 _origin);
460 
461     function countDestinations() public constant returns (uint256 _length);
462 
463     function getDestinationByIndex(uint256 _i) public constant returns (bytes32 _destination);
464 
465     function setAccessControl(address _contract, address _caller, uint8 _perm) public;
466 
467     function setAccessControl(
468         address _contract,
469         address _caller,
470         uint8 _perm,
471         bool _access
472     ) public;
473 
474     function getAccessControl(address _contract, address _caller, uint8 _perm) public returns (bool _allowed) ;
475 
476     function setLedger(uint8 _index, int _value) public;
477 
478     function getLedger(uint8 _index) public returns (int _value) ;
479 
480     function getCustomerPremium(uint _policyId) public returns (address _customer, uint _premium) ;
481 
482     function getPolicyData(uint _policyId) public returns (address _customer, uint _premium, uint _weight) ;
483 
484     function getPolicyState(uint _policyId) public returns (policyState _state) ;
485 
486     function getRiskId(uint _policyId) public returns (bytes32 _riskId);
487 
488     function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) public returns (uint _policyId) ;
489 
490     function setState(
491         uint _policyId,
492         policyState _state,
493         uint _stateTime,
494         bytes32 _stateMessage
495     ) public;
496 
497     function setWeight(uint _policyId, uint _weight, bytes _proof) public;
498 
499     function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout) public;
500 
501     function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes) public;
502 
503     function getRiskParameters(bytes32 _riskId)
504         public returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime) ;
505 
506     function getPremiumFactors(bytes32 _riskId)
507         public returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);
508 
509     function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)
510         public returns (bytes32 _riskId);
511 
512     function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier) public;
513 
514     function getOraclizeCallback(bytes32 _queryId)
515         public returns (uint _policyId, uint _oraclizeTime) ;
516 
517     function getOraclizePolicyId(bytes32 _queryId)
518         public returns (uint _policyId) ;
519 
520     function createOraclizeCallback(
521         bytes32 _queryId,
522         uint _policyId,
523         oraclizeState _oraclizeState,
524         uint _oraclizeTime
525     ) public;
526 
527     function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)
528         public returns (bool _result) ;
529 }
530 
531 // File: contracts/FlightDelayLedgerInterface.sol
532 
533 /**
534  * FlightDelay with Oraclized Underwriting and Payout
535  *
536  * @description	Ledger contract interface
537  * @copyright (c) 2017 etherisc GmbH
538  * @author Christoph Mussenbrock, Stephan Karpischek
539  */
540 
541 pragma solidity ^0.4.11;
542 
543 
544 
545 contract FlightDelayLedgerInterface is FlightDelayDatabaseModel {
546 
547     function receiveFunds(Acc _to) public payable;
548 
549     function sendFunds(address _recipient, Acc _from, uint _amount) public returns (bool _success);
550 
551     function bookkeeping(Acc _from, Acc _to, uint amount) public;
552 }
553 
554 // File: contracts/FlightDelayUnderwriteInterface.sol
555 
556 /**
557  * FlightDelay with Oraclized Underwriting and Payout
558  *
559  * @description	Underwrite contract interface
560  * @copyright (c) 2017 etherisc GmbH
561  * @author Christoph Mussenbrock, Stephan Karpischek
562  */
563 
564 pragma solidity ^0.4.11;
565 
566 
567 contract FlightDelayUnderwriteInterface {
568 
569     function scheduleUnderwriteOraclizeCall(uint _policyId, bytes32 _carrierFlightNumber) public;
570 }
571 
572 // File: contracts/convertLib.sol
573 
574 /**
575  * FlightDelay with Oraclized Underwriting and Payout
576  *
577  * @description	Conversions
578  * @copyright (c) 2017 etherisc GmbH
579  * @author Christoph Mussenbrock
580  */
581 
582 pragma solidity ^0.4.11;
583 
584 
585 contract ConvertLib {
586 
587     // .. since beginning of the year
588     uint16[12] days_since = [
589         11,
590         42,
591         70,
592         101,
593         131,
594         162,
595         192,
596         223,
597         254,
598         284,
599         315,
600         345
601     ];
602 
603     function b32toString(bytes32 x) internal returns (string) {
604         // gas usage: about 1K gas per char.
605         bytes memory bytesString = new bytes(32);
606         uint charCount = 0;
607 
608         for (uint j = 0; j < 32; j++) {
609             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
610             if (char != 0) {
611                 bytesString[charCount] = char;
612                 charCount++;
613             }
614         }
615 
616         bytes memory bytesStringTrimmed = new bytes(charCount);
617 
618         for (j = 0; j < charCount; j++) {
619             bytesStringTrimmed[j] = bytesString[j];
620         }
621 
622         return string(bytesStringTrimmed);
623     }
624 
625     function b32toHexString(bytes32 x) returns (string) {
626         bytes memory b = new bytes(64);
627         for (uint i = 0; i < 32; i++) {
628             uint8 by = uint8(uint(x) / (2**(8*(31 - i))));
629             uint8 high = by/16;
630             uint8 low = by - 16*high;
631             if (high > 9) {
632                 high += 39;
633             }
634             if (low > 9) {
635                 low += 39;
636             }
637             b[2*i] = byte(high+48);
638             b[2*i+1] = byte(low+48);
639         }
640 
641         return string(b);
642     }
643 
644     function parseInt(string _a) internal returns (uint) {
645         return parseInt(_a, 0);
646     }
647 
648     // parseInt(parseFloat*10^_b)
649     function parseInt(string _a, uint _b) internal returns (uint) {
650         bytes memory bresult = bytes(_a);
651         uint mint = 0;
652         bool decimals = false;
653         for (uint i = 0; i<bresult.length; i++) {
654             if ((bresult[i] >= 48)&&(bresult[i] <= 57)) {
655                 if (decimals) {
656                     if (_b == 0) {
657                         break;
658                     } else {
659                         _b--;
660                     }
661                 }
662                 mint *= 10;
663                 mint += uint(bresult[i]) - 48;
664             } else if (bresult[i] == 46) {
665                 decimals = true;
666             }
667         }
668         if (_b > 0) {
669             mint *= 10**_b;
670         }
671         return mint;
672     }
673 
674     // the following function yields correct results in the time between 1.3.2016 and 28.02.2020,
675     // so within the validity of the contract its correct.
676     function toUnixtime(bytes32 _dayMonthYear) constant returns (uint unixtime) {
677         // _day_month_year = /dep/2016/09/10
678         bytes memory bDmy = bytes(b32toString(_dayMonthYear));
679         bytes memory temp2 = bytes(new string(2));
680         bytes memory temp4 = bytes(new string(4));
681 
682         temp4[0] = bDmy[5];
683         temp4[1] = bDmy[6];
684         temp4[2] = bDmy[7];
685         temp4[3] = bDmy[8];
686         uint year = parseInt(string(temp4));
687 
688         temp2[0] = bDmy[10];
689         temp2[1] = bDmy[11];
690         uint month = parseInt(string(temp2));
691 
692         temp2[0] = bDmy[13];
693         temp2[1] = bDmy[14];
694         uint day = parseInt(string(temp2));
695 
696         unixtime = ((year - 1970) * 365 + days_since[month-1] + day) * 86400;
697     }
698 }
699 
700 // File: contracts/FlightDelayNewPolicy.sol
701 
702 /**
703  * FlightDelay with Oraclized Underwriting and Payout
704  *
705  * @description NewPolicy contract.
706  * @copyright (c) 2017 etherisc GmbH
707  * @author Christoph Mussenbrock
708  */
709 
710 pragma solidity ^0.4.11;
711 
712 
713 
714 
715 
716 
717 
718 
719 
720 contract FlightDelayNewPolicy is FlightDelayControlledContract, FlightDelayConstants, ConvertLib {
721 
722     FlightDelayAccessControllerInterface FD_AC;
723     FlightDelayDatabaseInterface FD_DB;
724     FlightDelayLedgerInterface FD_LG;
725     FlightDelayUnderwriteInterface FD_UW;
726 
727     function FlightDelayNewPolicy(address _controller) public {
728         setController(_controller);
729     }
730 
731     function setContracts() public onlyController {
732         FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));
733         FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));
734         FD_LG = FlightDelayLedgerInterface(getContract("FD.Ledger"));
735         FD_UW = FlightDelayUnderwriteInterface(getContract("FD.Underwrite"));
736 
737         FD_AC.setPermissionByAddress(101, 0x0);
738         FD_AC.setPermissionById(102, "FD.Controller");
739         FD_AC.setPermissionById(103, "FD.Owner");
740     }
741 
742     function bookAndCalcRemainingPremium() internal returns (uint) {
743         uint v = msg.value;
744         uint reserve = v * RESERVE_PERCENT / 100;
745         uint remain = v - reserve;
746         uint reward = remain * REWARD_PERCENT / 100;
747 
748         // FD_LG.bookkeeping(Acc.Balance, Acc.Premium, v);
749         FD_LG.bookkeeping(Acc.Premium, Acc.RiskFund, reserve);
750         FD_LG.bookkeeping(Acc.Premium, Acc.Reward, reward);
751 
752         return (uint(remain - reward));
753     }
754 
755     function maintenanceMode(bool _on) public {
756         if (FD_AC.checkPermission(103, msg.sender)) {
757             FD_AC.setPermissionByAddress(101, 0x0, !_on);
758         }
759     }
760 
761     // create new policy
762     function newPolicy(
763         bytes32 _carrierFlightNumber,
764         bytes32 _departureYearMonthDay,
765         uint256 _departureTime,
766         uint256 _arrivalTime,
767         Currency _currency,
768         bytes32 _customerExternalId) public payable
769     {
770         // here we can switch it off.
771         require(FD_AC.checkPermission(101, 0x0));
772 
773         // solidity checks for valid _currency parameter
774         if (_currency == Currency.ETH) {
775             // ETH
776             if (msg.value < MIN_PREMIUM || msg.value > MAX_PREMIUM) {
777                 LogPolicyDeclined(0, "Invalid premium value ETH");
778                 FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
779                 return;
780             }
781         } else {
782             require(msg.sender == getContract("FD.CustomersAdmin"));
783 
784             if (_currency == Currency.EUR) {
785                 // EUR
786                 if (msg.value < MIN_PREMIUM_EUR || msg.value > MAX_PREMIUM_EUR) {
787                     LogPolicyDeclined(0, "Invalid premium value EUR");
788                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
789                     return;
790                 }
791             }
792 
793             if (_currency == Currency.USD) {
794                 // USD
795                 if (msg.value < MIN_PREMIUM_USD || msg.value > MAX_PREMIUM_USD) {
796                     LogPolicyDeclined(0, "Invalid premium value USD");
797                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
798                     return;
799                 }
800             }
801 
802             if (_currency == Currency.GBP) {
803                 // GBP
804                 if (msg.value < MIN_PREMIUM_GBP || msg.value > MAX_PREMIUM_GBP) {
805                     LogPolicyDeclined(0, "Invalid premium value GBP");
806                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
807                     return;
808                 }
809             }
810         }
811 
812         // forward premium
813         FD_LG.receiveFunds.value(msg.value)(Acc.Premium);
814 
815 
816         // don't Accept flights with departure time earlier than in 24 hours,
817         // or arrivalTime before departureTime,
818         // or departureTime after Mon, 26 Sep 2016 12:00:00 GMT
819         uint dmy = toUnixtime(_departureYearMonthDay);
820 
821 // --> debug-mode
822 //            LogUintTime("NewPolicy: dmy: ", dmy);
823 //            LogUintTime("NewPolicy: _departureTime: ", _departureTime);
824 // <-- debug-mode
825 
826         if (
827             _arrivalTime < _departureTime ||
828             _arrivalTime > _departureTime + MAX_FLIGHT_DURATION ||
829             _departureTime < now + MIN_TIME_BEFORE_DEPARTURE ||
830             _departureTime > CONTRACT_DEAD_LINE ||
831             _departureTime < dmy ||
832             _departureTime > dmy + 24 hours ||
833             _departureTime < FD_DB.MIN_DEPARTURE_LIM() ||
834             _departureTime > FD_DB.MAX_DEPARTURE_LIM()
835         ) {
836             LogPolicyDeclined(0, "Invalid arrival/departure time");
837             FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
838             return;
839         }
840 
841         bytes32 riskId = FD_DB.createUpdateRisk(_carrierFlightNumber, _departureYearMonthDay, _arrivalTime);
842 
843         var (cumulatedWeightedPremium, premiumMultiplier) = FD_DB.getPremiumFactors(riskId);
844 
845         // roughly check, whether MAX_CUMULATED_WEIGHTED_PREMIUM will be exceeded
846         // (we Accept the inAccuracy that the real remaining premium is 3% lower),
847         // but we are conservative;
848         // if this is the first policy, the left side will be 0
849         if (msg.value * premiumMultiplier + cumulatedWeightedPremium >= MAX_CUMULATED_WEIGHTED_PREMIUM) {
850             LogPolicyDeclined(0, "Cluster risk");
851             FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
852             return;
853         } else if (cumulatedWeightedPremium == 0) {
854             // at the first police, we set r.cumulatedWeightedPremium to the max.
855             // this prevents further polices to be Accepted, until the correct
856             // value is calculated after the first callback from the oracle.
857             FD_DB.setPremiumFactors(riskId, MAX_CUMULATED_WEIGHTED_PREMIUM, premiumMultiplier);
858         }
859 
860         uint premium = bookAndCalcRemainingPremium();
861         uint policyId = FD_DB.createPolicy(msg.sender, premium, _currency, _customerExternalId, riskId);
862 
863         if (premiumMultiplier > 0) {
864             FD_DB.setPremiumFactors(
865                 riskId,
866                 cumulatedWeightedPremium + premium * premiumMultiplier,
867                 premiumMultiplier
868             );
869         }
870 
871         // now we have successfully applied
872         FD_DB.setState(
873             policyId,
874             policyState.Applied,
875             now,
876             "Policy applied by customer"
877         );
878 
879         LogPolicyApplied(
880             policyId,
881             msg.sender,
882             _carrierFlightNumber,
883             premium
884         );
885 
886         LogExternal(
887             policyId,
888             msg.sender,
889             _customerExternalId
890         );
891 
892         FD_UW.scheduleUnderwriteOraclizeCall(policyId, _carrierFlightNumber);
893     }
894 }