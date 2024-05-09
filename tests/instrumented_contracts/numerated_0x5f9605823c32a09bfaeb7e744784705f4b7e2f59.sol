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
527 // File: contracts/FlightDelayLedgerInterface.sol
528 
529 /**
530  * FlightDelay with Oraclized Underwriting and Payout
531  *
532  * @description	Ledger contract interface
533  * @copyright (c) 2017 etherisc GmbH
534  * @author Christoph Mussenbrock, Stephan Karpischek
535  */
536 
537 pragma solidity ^0.4.11;
538 
539 
540 
541 
542 contract FlightDelayLedgerInterface is FlightDelayDatabaseModel {
543 
544     function receiveFunds(Acc _to) public payable;
545 
546     function sendFunds(address _recipient, Acc _from, uint _amount) public returns (bool _success);
547 
548     function bookkeeping(Acc _from, Acc _to, uint amount) public;
549 }
550 
551 // File: contracts/FlightDelayUnderwriteInterface.sol
552 
553 /**
554  * FlightDelay with Oraclized Underwriting and Payout
555  *
556  * @description	Underwrite contract interface
557  * @copyright (c) 2017 etherisc GmbH
558  * @author Christoph Mussenbrock, Stephan Karpischek
559  */
560 
561 pragma solidity ^0.4.11;
562 
563 
564 contract FlightDelayUnderwriteInterface {
565 
566     function scheduleUnderwriteOraclizeCall(uint _policyId, bytes32 _carrierFlightNumber) public;
567 }
568 
569 // File: contracts/convertLib.sol
570 
571 /**
572  * FlightDelay with Oraclized Underwriting and Payout
573  *
574  * @description	Conversions
575  * @copyright (c) 2017 etherisc GmbH
576  * @author Christoph Mussenbrock
577  */
578 
579 pragma solidity ^0.4.11;
580 
581 
582 contract ConvertLib {
583 
584     // .. since beginning of the year
585     uint16[12] days_since = [
586         11,
587         42,
588         70,
589         101,
590         131,
591         162,
592         192,
593         223,
594         254,
595         284,
596         315,
597         345
598     ];
599 
600     function b32toString(bytes32 x) internal returns (string) {
601         // gas usage: about 1K gas per char.
602         bytes memory bytesString = new bytes(32);
603         uint charCount = 0;
604 
605         for (uint j = 0; j < 32; j++) {
606             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
607             if (char != 0) {
608                 bytesString[charCount] = char;
609                 charCount++;
610             }
611         }
612 
613         bytes memory bytesStringTrimmed = new bytes(charCount);
614 
615         for (j = 0; j < charCount; j++) {
616             bytesStringTrimmed[j] = bytesString[j];
617         }
618 
619         return string(bytesStringTrimmed);
620     }
621 
622     function b32toHexString(bytes32 x) returns (string) {
623         bytes memory b = new bytes(64);
624         for (uint i = 0; i < 32; i++) {
625             uint8 by = uint8(uint(x) / (2**(8*(31 - i))));
626             uint8 high = by/16;
627             uint8 low = by - 16*high;
628             if (high > 9) {
629                 high += 39;
630             }
631             if (low > 9) {
632                 low += 39;
633             }
634             b[2*i] = byte(high+48);
635             b[2*i+1] = byte(low+48);
636         }
637 
638         return string(b);
639     }
640 
641     function parseInt(string _a) internal returns (uint) {
642         return parseInt(_a, 0);
643     }
644 
645     // parseInt(parseFloat*10^_b)
646     function parseInt(string _a, uint _b) internal returns (uint) {
647         bytes memory bresult = bytes(_a);
648         uint mint = 0;
649         bool decimals = false;
650         for (uint i = 0; i<bresult.length; i++) {
651             if ((bresult[i] >= 48)&&(bresult[i] <= 57)) {
652                 if (decimals) {
653                     if (_b == 0) {
654                         break;
655                     } else {
656                         _b--;
657                     }
658                 }
659                 mint *= 10;
660                 mint += uint(bresult[i]) - 48;
661             } else if (bresult[i] == 46) {
662                 decimals = true;
663             }
664         }
665         if (_b > 0) {
666             mint *= 10**_b;
667         }
668         return mint;
669     }
670 
671     // the following function yields correct results in the time between 1.3.2016 and 28.02.2020,
672     // so within the validity of the contract its correct.
673     function toUnixtime(bytes32 _dayMonthYear) constant returns (uint unixtime) {
674         // _day_month_year = /dep/2016/09/10
675         bytes memory bDmy = bytes(b32toString(_dayMonthYear));
676         bytes memory temp2 = bytes(new string(2));
677         bytes memory temp4 = bytes(new string(4));
678 
679         temp4[0] = bDmy[5];
680         temp4[1] = bDmy[6];
681         temp4[2] = bDmy[7];
682         temp4[3] = bDmy[8];
683         uint year = parseInt(string(temp4));
684 
685         temp2[0] = bDmy[10];
686         temp2[1] = bDmy[11];
687         uint month = parseInt(string(temp2));
688 
689         temp2[0] = bDmy[13];
690         temp2[1] = bDmy[14];
691         uint day = parseInt(string(temp2));
692 
693         unixtime = ((year - 1970) * 365 + days_since[month-1] + day) * 86400;
694     }
695 }
696 
697 // File: contracts/FlightDelayNewPolicy.sol
698 
699 /**
700  * FlightDelay with Oraclized Underwriting and Payout
701  *
702  * @description NewPolicy contract.
703  * @copyright (c) 2017 etherisc GmbH
704  * @author Christoph Mussenbrock
705  */
706 
707 pragma solidity ^0.4.11;
708 
709 
710 
711 
712 
713 
714 
715 
716 
717 
718 contract FlightDelayNewPolicy is FlightDelayControlledContract, FlightDelayConstants, ConvertLib {
719 
720     FlightDelayAccessControllerInterface FD_AC;
721     FlightDelayDatabaseInterface FD_DB;
722     FlightDelayLedgerInterface FD_LG;
723     FlightDelayUnderwriteInterface FD_UW;
724 
725     function FlightDelayNewPolicy(address _controller) public {
726         setController(_controller);
727     }
728 
729     function setContracts() public onlyController {
730         FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));
731         FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));
732         FD_LG = FlightDelayLedgerInterface(getContract("FD.Ledger"));
733         FD_UW = FlightDelayUnderwriteInterface(getContract("FD.Underwrite"));
734 
735         FD_AC.setPermissionByAddress(101, 0x0);
736         FD_AC.setPermissionById(102, "FD.Controller");
737         FD_AC.setPermissionById(103, "FD.Owner");
738     }
739 
740     function bookAndCalcRemainingPremium() internal returns (uint) {
741         uint v = msg.value;
742         uint reserve = v * RESERVE_PERCENT / 100;
743         uint remain = v - reserve;
744         uint reward = remain * REWARD_PERCENT / 100;
745 
746         // FD_LG.bookkeeping(Acc.Balance, Acc.Premium, v);
747         FD_LG.bookkeeping(Acc.Premium, Acc.RiskFund, reserve);
748         FD_LG.bookkeeping(Acc.Premium, Acc.Reward, reward);
749 
750         return (uint(remain - reward));
751     }
752 
753     function maintenanceMode(bool _on) public {
754         if (FD_AC.checkPermission(103, msg.sender)) {
755             FD_AC.setPermissionByAddress(101, 0x0, !_on);
756         }
757     }
758 
759     // create new policy
760     function newPolicy(
761         bytes32 _carrierFlightNumber,
762         bytes32 _departureYearMonthDay,
763         uint256 _departureTime,
764         uint256 _arrivalTime,
765         Currency _currency,
766         bytes32 _customerExternalId) public payable
767     {
768         // here we can switch it off.
769         require(FD_AC.checkPermission(101, 0x0));
770 
771         // solidity checks for valid _currency parameter
772         if (_currency == Currency.ETH) {
773             // ETH
774             if (msg.value < MIN_PREMIUM || msg.value > MAX_PREMIUM) {
775                 LogPolicyDeclined(0, "Invalid premium value ETH");
776                 FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
777                 return;
778             }
779         } else {
780             require(msg.sender == getContract("FD.CustomersAdmin"));
781 
782             if (_currency == Currency.EUR) {
783                 // EUR
784                 if (msg.value < MIN_PREMIUM_EUR || msg.value > MAX_PREMIUM_EUR) {
785                     LogPolicyDeclined(0, "Invalid premium value EUR");
786                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
787                     return;
788                 }
789             }
790 
791             if (_currency == Currency.USD) {
792                 // USD
793                 if (msg.value < MIN_PREMIUM_USD || msg.value > MAX_PREMIUM_USD) {
794                     LogPolicyDeclined(0, "Invalid premium value USD");
795                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
796                     return;
797                 }
798             }
799 
800             if (_currency == Currency.GBP) {
801                 // GBP
802                 if (msg.value < MIN_PREMIUM_GBP || msg.value > MAX_PREMIUM_GBP) {
803                     LogPolicyDeclined(0, "Invalid premium value GBP");
804                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
805                     return;
806                 }
807             }
808         }
809 
810         // forward premium
811         FD_LG.receiveFunds.value(msg.value)(Acc.Premium);
812 
813 
814         // don't Accept flights with departure time earlier than in 24 hours,
815         // or arrivalTime before departureTime,
816         // or departureTime after Mon, 26 Sep 2016 12:00:00 GMT
817         uint dmy = toUnixtime(_departureYearMonthDay);
818 
819 // --> debug-mode
820 //            LogUintTime("NewPolicy: dmy: ", dmy);
821 //            LogUintTime("NewPolicy: _departureTime: ", _departureTime);
822 // <-- debug-mode
823 
824         if (
825             _arrivalTime < _departureTime ||
826             _arrivalTime > _departureTime + MAX_FLIGHT_DURATION ||
827             _departureTime < now + MIN_TIME_BEFORE_DEPARTURE ||
828             _departureTime > CONTRACT_DEAD_LINE ||
829             _departureTime < dmy ||
830             _departureTime > dmy + 24 hours ||
831             _departureTime < FD_DB.MIN_DEPARTURE_LIM() ||
832             _departureTime > FD_DB.MAX_DEPARTURE_LIM()
833         ) {
834             LogPolicyDeclined(0, "Invalid arrival/departure time");
835             FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
836             return;
837         }
838 
839         bytes32 riskId = FD_DB.createUpdateRisk(_carrierFlightNumber, _departureYearMonthDay, _arrivalTime);
840 
841         var (cumulatedWeightedPremium, premiumMultiplier) = FD_DB.getPremiumFactors(riskId);
842 
843         // roughly check, whether MAX_CUMULATED_WEIGHTED_PREMIUM will be exceeded
844         // (we Accept the inAccuracy that the real remaining premium is 3% lower),
845         // but we are conservative;
846         // if this is the first policy, the left side will be 0
847         if (msg.value * premiumMultiplier + cumulatedWeightedPremium >= MAX_CUMULATED_WEIGHTED_PREMIUM) {
848             LogPolicyDeclined(0, "Cluster risk");
849             FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
850             return;
851         } else if (cumulatedWeightedPremium == 0) {
852             // at the first police, we set r.cumulatedWeightedPremium to the max.
853             // this prevents further polices to be Accepted, until the correct
854             // value is calculated after the first callback from the oracle.
855             FD_DB.setPremiumFactors(riskId, MAX_CUMULATED_WEIGHTED_PREMIUM, premiumMultiplier);
856         }
857 
858         uint premium = bookAndCalcRemainingPremium();
859         uint policyId = FD_DB.createPolicy(msg.sender, premium, _currency, _customerExternalId, riskId);
860 
861         if (premiumMultiplier > 0) {
862             FD_DB.setPremiumFactors(
863                 riskId,
864                 cumulatedWeightedPremium + premium * premiumMultiplier,
865                 premiumMultiplier
866             );
867         }
868 
869         // now we have successfully applied
870         FD_DB.setState(
871             policyId,
872             policyState.Applied,
873             now,
874             "Policy applied by customer"
875         );
876 
877         LogPolicyApplied(
878             policyId,
879             msg.sender,
880             _carrierFlightNumber,
881             premium
882         );
883 
884         LogExternal(
885             policyId,
886             msg.sender,
887             _customerExternalId
888         );
889 
890         FD_UW.scheduleUnderwriteOraclizeCall(policyId, _carrierFlightNumber);
891     }
892 }