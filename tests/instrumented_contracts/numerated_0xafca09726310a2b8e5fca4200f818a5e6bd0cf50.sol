1 pragma solidity ^0.4.11;
2 
3 
4 contract FlightDelayControllerInterface {
5 
6     function isOwner(address _addr) returns (bool _isOwner);
7 
8     function selfRegister(bytes32 _id) returns (bool result);
9 
10     function getContract(bytes32 _id) returns (address _addr);
11 }
12 
13 
14 
15 contract FlightDelayDatabaseModel {
16 
17     // Ledger accounts.
18     enum Acc {
19         Premium,      // 0
20         RiskFund,     // 1
21         Payout,       // 2
22         Balance,      // 3
23         Reward,       // 4
24         OraclizeCosts // 5
25     }
26 
27     // policy Status Codes and meaning:
28     //
29     // 00 = Applied:	  the customer has payed a premium, but the oracle has
30     //					        not yet checked and confirmed.
31     //					        The customer can still revoke the policy.
32     // 01 = Accepted:	  the oracle has checked and confirmed.
33     //					        The customer can still revoke the policy.
34     // 02 = Revoked:	  The customer has revoked the policy.
35     //					        The premium minus cancellation fee is payed back to the
36     //					        customer by the oracle.
37     // 03 = PaidOut:	  The flight has ended with delay.
38     //					        The oracle has checked and payed out.
39     // 04 = Expired:	  The flight has endet with <15min. delay.
40     //					        No payout.
41     // 05 = Declined:	  The application was invalid.
42     //					        The premium minus cancellation fee is payed back to the
43     //					        customer by the oracle.
44     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
45     //					        for unknown reasons.
46     //					        The funds remain in the contracts RiskFund.
47 
48 
49     //                   00       01        02       03        04      05           06
50     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
51 
52     // oraclize callback types:
53     enum oraclizeState { ForUnderwriting, ForPayout }
54 
55     //               00   01   02   03
56     enum Currency { ETH, EUR, USD, GBP }
57 
58     // the policy structure: this structure keeps track of the individual parameters of a policy.
59     // typically customer address, premium and some status information.
60     struct Policy {
61         // 0 - the customer
62         address customer;
63 
64         // 1 - premium
65         uint premium;
66         // risk specific parameters:
67         // 2 - pointer to the risk in the risks mapping
68         bytes32 riskId;
69         // custom payout pattern
70         // in future versions, customer will be able to tamper with this array.
71         // to keep things simple, we have decided to hard-code the array for all policies.
72         // uint8[5] pattern;
73         // 3 - probability weight. this is the central parameter
74         uint weight;
75         // 4 - calculated Payout
76         uint calculatedPayout;
77         // 5 - actual Payout
78         uint actualPayout;
79 
80         // status fields:
81         // 6 - the state of the policy
82         policyState state;
83         // 7 - time of last state change
84         uint stateTime;
85         // 8 - state change message/reason
86         bytes32 stateMessage;
87         // 9 - TLSNotary Proof
88         bytes proof;
89         // 10 - Currency
90         Currency currency;
91         // 10 - External customer id
92         bytes32 customerExternalId;
93     }
94 
95     // the risk structure; this structure keeps track of the risk-
96     // specific parameters.
97     // several policies can share the same risk structure (typically
98     // some people flying with the same plane)
99     struct Risk {
100         // 0 - Airline Code + FlightNumber
101         bytes32 carrierFlightNumber;
102         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
103         bytes32 departureYearMonthDay;
104         // 2 - the inital arrival time
105         uint arrivalTime;
106         // 3 - the final delay in minutes
107         uint delayInMinutes;
108         // 4 - the determined delay category (0-5)
109         uint8 delay;
110         // 5 - we limit the cumulated weighted premium to avoid cluster risks
111         uint cumulatedWeightedPremium;
112         // 6 - max cumulated Payout for this risk
113         uint premiumMultiplier;
114     }
115 
116     // the oraclize callback structure: we use several oraclize calls.
117     // all oraclize calls will result in a common callback to __callback(...).
118     // to keep track of the different querys we have to introduce this struct.
119     struct OraclizeCallback {
120         // for which policy have we called?
121         uint policyId;
122         // for which purpose did we call? {ForUnderwrite | ForPayout}
123         oraclizeState oState;
124         // time
125         uint oraclizeTime;
126     }
127 
128     struct Customer {
129         bytes32 customerExternalId;
130         bool identityConfirmed;
131     }
132 }
133 
134 
135 
136 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
137 
138     address public controller;
139     FlightDelayControllerInterface FD_CI;
140 
141     modifier onlyController() {
142         require(msg.sender == controller);
143         _;
144     }
145 
146     function setController(address _controller) internal returns (bool _result) {
147         controller = _controller;
148         FD_CI = FlightDelayControllerInterface(_controller);
149         _result = true;
150     }
151 
152     function destruct() onlyController {
153         selfdestruct(controller);
154     }
155 
156     function setContracts() onlyController {}
157 
158     function getContract(bytes32 _id) internal returns (address _addr) {
159         _addr = FD_CI.getContract(_id);
160     }
161 }
162 
163 
164 
165 contract FlightDelayConstants {
166 
167     /*
168     * General events
169     */
170 
171 // --> test-mode
172 //        event LogUint(string _message, uint _uint);
173 //        event LogUintEth(string _message, uint ethUint);
174 //        event LogUintTime(string _message, uint timeUint);
175 //        event LogInt(string _message, int _int);
176 //        event LogAddress(string _message, address _address);
177 //        event LogBytes32(string _message, bytes32 hexBytes32);
178 //        event LogBytes(string _message, bytes hexBytes);
179 //        event LogBytes32Str(string _message, bytes32 strBytes32);
180 //        event LogString(string _message, string _string);
181 //        event LogBool(string _message, bool _bool);
182 //        event Log(address);
183 // <-- test-mode
184 
185     event LogPolicyApplied(
186         uint _policyId,
187         address _customer,
188         bytes32 strCarrierFlightNumber,
189         uint ethPremium
190     );
191     event LogPolicyAccepted(
192         uint _policyId,
193         uint _statistics0,
194         uint _statistics1,
195         uint _statistics2,
196         uint _statistics3,
197         uint _statistics4,
198         uint _statistics5
199     );
200     event LogPolicyPaidOut(
201         uint _policyId,
202         uint ethAmount
203     );
204     event LogPolicyExpired(
205         uint _policyId
206     );
207     event LogPolicyDeclined(
208         uint _policyId,
209         bytes32 strReason
210     );
211     event LogPolicyManualPayout(
212         uint _policyId,
213         bytes32 strReason
214     );
215     event LogSendFunds(
216         address _recipient,
217         uint8 _from,
218         uint ethAmount
219     );
220     event LogReceiveFunds(
221         address _sender,
222         uint8 _to,
223         uint ethAmount
224     );
225     event LogSendFail(
226         uint _policyId,
227         bytes32 strReason
228     );
229     event LogOraclizeCall(
230         uint _policyId,
231         bytes32 hexQueryId,
232         string _oraclizeUrl
233     );
234     event LogOraclizeCallback(
235         uint _policyId,
236         bytes32 hexQueryId,
237         string _result,
238         bytes hexProof
239     );
240     event LogSetState(
241         uint _policyId,
242         uint8 _policyState,
243         uint _stateTime,
244         bytes32 _stateMessage
245     );
246     event LogExternal(
247         uint256 _policyId,
248         address _address,
249         bytes32 _externalId
250     );
251 
252     /*
253     * General constants
254     */
255 
256     // minimum observations for valid prediction
257     uint constant MIN_OBSERVATIONS = 10;
258     // minimum premium to cover costs
259     uint constant MIN_PREMIUM = 50 finney;
260     // maximum premium
261     uint constant MAX_PREMIUM = 1 ether;
262     // maximum payout
263     uint constant MAX_PAYOUT = 1100 finney;
264 
265     uint constant MIN_PREMIUM_EUR = 1500 wei;
266     uint constant MAX_PREMIUM_EUR = 29000 wei;
267     uint constant MAX_PAYOUT_EUR = 30000 wei;
268 
269     uint constant MIN_PREMIUM_USD = 1700 wei;
270     uint constant MAX_PREMIUM_USD = 34000 wei;
271     uint constant MAX_PAYOUT_USD = 35000 wei;
272 
273     uint constant MIN_PREMIUM_GBP = 1300 wei;
274     uint constant MAX_PREMIUM_GBP = 25000 wei;
275     uint constant MAX_PAYOUT_GBP = 270 wei;
276 
277     // maximum cumulated weighted premium per risk
278     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 300 ether;
279     // 1 percent for DAO, 1 percent for maintainer
280     uint8 constant REWARD_PERCENT = 2;
281     // reserve for tail risks
282     uint8 constant RESERVE_PERCENT = 1;
283     // the weight pattern; in future versions this may become part of the policy struct.
284     // currently can't be constant because of compiler restrictions
285     // WEIGHT_PATTERN[0] is not used, just to be consistent
286     uint8[6] WEIGHT_PATTERN = [
287         0,
288         10,
289         20,
290         30,
291         50,
292         50
293     ];
294 
295 // --> prod-mode
296     // DEFINITIONS FOR ROPSTEN AND MAINNET
297     // minimum time before departure for applying
298     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
299     // check for delay after .. minutes after scheduled arrival
300     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
301 // <-- prod-mode
302 
303 // --> test-mode
304 //        // DEFINITIONS FOR LOCAL TESTNET
305 //        // minimum time before departure for applying
306 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
307 //        // check for delay after .. minutes after scheduled arrival
308 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
309 // <-- test-mode
310 
311     // maximum duration of flight
312     uint constant MAX_FLIGHT_DURATION = 2 days;
313     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
314     uint constant CONTRACT_DEAD_LINE = 1922396399;
315 
316     uint constant MIN_DEPARTURE_LIM = 1508198400;
317 
318     uint constant MAX_DEPARTURE_LIM = 1509494400;
319 
320     // gas Constants for oraclize
321     uint constant ORACLIZE_GAS = 1000000;
322 
323 
324     /*
325     * URLs and query strings for oraclize
326     */
327 
328 // --> prod-mode
329     // DEFINITIONS FOR ROPSTEN AND MAINNET
330     string constant ORACLIZE_RATINGS_BASE_URL =
331         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
332         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
333     string constant ORACLIZE_RATINGS_QUERY =
334         "?${[decrypt] BDuCYocRMLSG1ps6CPtaKal1sRS+duDdEFlNoIro+789kuuKLR4nsoYqELn+G6OIGEY722F6PFw9Y5YW/NWLnOLYFdzSh+ulIZ7Uum736YAa6CuYSFZ/EQem6s1y8t+HKg4zfhVw84tY09xIFAM1+MywYvbg8lbm80bPjbWKvmDdx230oAbu}).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
335     string constant ORACLIZE_STATUS_BASE_URL =
336         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
337         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
338     string constant ORACLIZE_STATUS_QUERY =
339         // pattern:
340         "?${[decrypt] BHAF1MKJcAev0j66Q9G2s/HrMJdmq8io30+miL89TSfv6GH+vtfMYudd34mLjVCJaORzHpB+WOQgN19maTA0Rza4aSpN4TxV7v+eATjUiXWp/VL/GNMu+ACE9OseA2QA+HNhrviWAQPzkmKEVJfKd9l/5p5TN0b93whYFL9KiTn1eO0m61Wi}&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
341 // <-- prod-mode
342 
343 // --> test-mode
344 //        // DEFINITIONS FOR LOCAL TESTNET
345 //        string constant ORACLIZE_RATINGS_BASE_URL =
346 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
347 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
348 //        string constant ORACLIZE_RATINGS_QUERY =
349 //            // for testrpc:
350 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
351 //        string constant ORACLIZE_STATUS_BASE_URL =
352 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
353 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
354 //        string constant ORACLIZE_STATUS_QUERY =
355 //            // for testrpc:
356 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
357 // <-- test-mode
358 }
359 
360 contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {
361 
362     function setAccessControl(address _contract, address _caller, uint8 _perm);
363 
364     function setAccessControl(
365         address _contract,
366         address _caller,
367         uint8 _perm,
368         bool _access
369     );
370 
371     function getAccessControl(address _contract, address _caller, uint8 _perm) returns (bool _allowed);
372 
373     function setLedger(uint8 _index, int _value);
374 
375     function getLedger(uint8 _index) returns (int _value);
376 
377     function getCustomerPremium(uint _policyId) returns (address _customer, uint _premium);
378 
379     function getPolicyData(uint _policyId) returns (address _customer, uint _premium, uint _weight);
380 
381     function getPolicyState(uint _policyId) returns (policyState _state);
382 
383     function getRiskId(uint _policyId) returns (bytes32 _riskId);
384 
385     function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) returns (uint _policyId);
386 
387     function setState(
388         uint _policyId,
389         policyState _state,
390         uint _stateTime,
391         bytes32 _stateMessage
392     );
393 
394     function setWeight(uint _policyId, uint _weight, bytes _proof);
395 
396     function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout);
397 
398     function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes);
399 
400     function getRiskParameters(bytes32 _riskId)
401         returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime);
402 
403     function getPremiumFactors(bytes32 _riskId)
404         returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);
405 
406     function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)
407         returns (bytes32 _riskId);
408 
409     function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier);
410 
411     function getOraclizeCallback(bytes32 _queryId)
412         returns (uint _policyId, uint _arrivalTime);
413 
414     function getOraclizePolicyId(bytes32 _queryId)
415     returns (uint _policyId);
416 
417     function createOraclizeCallback(
418         bytes32 _queryId,
419         uint _policyId,
420         oraclizeState _oraclizeState,
421         uint _oraclizeTime
422     );
423 
424     function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)
425         returns (bool _result);
426 }
427 
428 contract FlightDelayAccessControllerInterface {
429 
430     function setPermissionById(uint8 _perm, bytes32 _id);
431 
432     function setPermissionById(uint8 _perm, bytes32 _id, bool _access);
433 
434     function setPermissionByAddress(uint8 _perm, address _addr);
435 
436     function setPermissionByAddress(uint8 _perm, address _addr, bool _access);
437 
438     function checkPermission(uint8 _perm, address _addr) returns (bool _success);
439 }
440 
441 
442 contract FlightDelayLedgerInterface is FlightDelayDatabaseModel {
443 
444     function receiveFunds(Acc _to) payable;
445 
446     function sendFunds(address _recipient, Acc _from, uint _amount) returns (bool _success);
447 
448     function bookkeeping(Acc _from, Acc _to, uint amount);
449 }
450 
451 contract FlightDelayUnderwriteInterface {
452 
453     function scheduleUnderwriteOraclizeCall(uint _policyId, bytes32 _carrierFlightNumber);
454 }
455 
456 contract ConvertLib {
457 
458     // .. since beginning of the year
459     uint16[12] days_since = [
460         11,
461         42,
462         70,
463         101,
464         131,
465         162,
466         192,
467         223,
468         254,
469         284,
470         315,
471         345
472     ];
473 
474     function b32toString(bytes32 x) internal returns (string) {
475         // gas usage: about 1K gas per char.
476         bytes memory bytesString = new bytes(32);
477         uint charCount = 0;
478 
479         for (uint j = 0; j < 32; j++) {
480             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
481             if (char != 0) {
482                 bytesString[charCount] = char;
483                 charCount++;
484             }
485         }
486 
487         bytes memory bytesStringTrimmed = new bytes(charCount);
488 
489         for (j = 0; j < charCount; j++) {
490             bytesStringTrimmed[j] = bytesString[j];
491         }
492 
493         return string(bytesStringTrimmed);
494     }
495 
496     function b32toHexString(bytes32 x) returns (string) {
497         bytes memory b = new bytes(64);
498         for (uint i = 0; i < 32; i++) {
499             uint8 by = uint8(uint(x) / (2**(8*(31 - i))));
500             uint8 high = by/16;
501             uint8 low = by - 16*high;
502             if (high > 9) {
503                 high += 39;
504             }
505             if (low > 9) {
506                 low += 39;
507             }
508             b[2*i] = byte(high+48);
509             b[2*i+1] = byte(low+48);
510         }
511 
512         return string(b);
513     }
514 
515     function parseInt(string _a) internal returns (uint) {
516         return parseInt(_a, 0);
517     }
518 
519     // parseInt(parseFloat*10^_b)
520     function parseInt(string _a, uint _b) internal returns (uint) {
521         bytes memory bresult = bytes(_a);
522         uint mint = 0;
523         bool decimals = false;
524         for (uint i = 0; i<bresult.length; i++) {
525             if ((bresult[i] >= 48)&&(bresult[i] <= 57)) {
526                 if (decimals) {
527                     if (_b == 0) {
528                         break;
529                     } else {
530                         _b--;
531                     }
532                 }
533                 mint *= 10;
534                 mint += uint(bresult[i]) - 48;
535             } else if (bresult[i] == 46) {
536                 decimals = true;
537             }
538         }
539         if (_b > 0) {
540             mint *= 10**_b;
541         }
542         return mint;
543     }
544 
545     // the following function yields correct results in the time between 1.3.2016 and 28.02.2020,
546     // so within the validity of the contract its correct.
547     function toUnixtime(bytes32 _dayMonthYear) constant returns (uint unixtime) {
548         // _day_month_year = /dep/2016/09/10
549         bytes memory bDmy = bytes(b32toString(_dayMonthYear));
550         bytes memory temp2 = bytes(new string(2));
551         bytes memory temp4 = bytes(new string(4));
552 
553         temp4[0] = bDmy[5];
554         temp4[1] = bDmy[6];
555         temp4[2] = bDmy[7];
556         temp4[3] = bDmy[8];
557         uint year = parseInt(string(temp4));
558 
559         temp2[0] = bDmy[10];
560         temp2[1] = bDmy[11];
561         uint month = parseInt(string(temp2));
562 
563         temp2[0] = bDmy[13];
564         temp2[1] = bDmy[14];
565         uint day = parseInt(string(temp2));
566 
567         unixtime = ((year - 1970) * 365 + days_since[month-1] + day) * 86400;
568     }
569 }
570 
571 contract FlightDelayNewPolicy is FlightDelayControlledContract, FlightDelayConstants, ConvertLib {
572 
573     FlightDelayAccessControllerInterface FD_AC;
574     FlightDelayDatabaseInterface FD_DB;
575     FlightDelayLedgerInterface FD_LG;
576     FlightDelayUnderwriteInterface FD_UW;
577 
578     function FlightDelayNewPolicy(address _controller) {
579         setController(_controller);
580     }
581 
582     function setContracts() onlyController {
583         FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));
584         FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));
585         FD_LG = FlightDelayLedgerInterface(getContract("FD.Ledger"));
586         FD_UW = FlightDelayUnderwriteInterface(getContract("FD.Underwrite"));
587 
588         FD_AC.setPermissionByAddress(101, 0x0);
589         FD_AC.setPermissionById(102, "FD.Controller");
590         FD_AC.setPermissionById(103, "FD.Owner");
591     }
592 
593     function bookAndCalcRemainingPremium() internal returns (uint) {
594         uint v = msg.value;
595         uint reserve = v * RESERVE_PERCENT / 100;
596         uint remain = v - reserve;
597         uint reward = remain * REWARD_PERCENT / 100;
598 
599         // FD_LG.bookkeeping(Acc.Balance, Acc.Premium, v);
600         FD_LG.bookkeeping(Acc.Premium, Acc.RiskFund, reserve);
601         FD_LG.bookkeeping(Acc.Premium, Acc.Reward, reward);
602 
603         return (uint(remain - reward));
604     }
605 
606     function maintenanceMode(bool _on) {
607         if (FD_AC.checkPermission(103, msg.sender)) {
608             FD_AC.setPermissionByAddress(101, 0x0, !_on);
609         }
610     }
611 
612     // create new policy
613     function newPolicy(
614         bytes32 _carrierFlightNumber,
615         bytes32 _departureYearMonthDay,
616         uint256 _departureTime,
617         uint256 _arrivalTime,
618         Currency _currency,
619         bytes32 _customerExternalId) payable
620     {
621         // here we can switch it off.
622         require(FD_AC.checkPermission(101, 0x0));
623 
624         require(uint256(_currency) <= 3);
625 
626         uint8 paymentType = uint8(_currency);
627 
628         if (paymentType == 0) {
629             // ETH
630             if (msg.value < MIN_PREMIUM || msg.value > MAX_PREMIUM) {
631                 LogPolicyDeclined(0, "Invalid premium value");
632                 FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
633                 return;
634             }
635         } else {
636             require(msg.sender == FD_CI.getContract("FD.CustomersAdmin"));
637 
638             if (paymentType == 1) {
639                 // EUR
640                 if (msg.value < MIN_PREMIUM_EUR || msg.value > MAX_PREMIUM_EUR) {
641                     LogPolicyDeclined(0, "Invalid premium value");
642                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
643                     return;
644                 }
645             }
646 
647             if (paymentType == 2) {
648                 // USD
649                 if (msg.value < MIN_PREMIUM_USD || msg.value > MAX_PREMIUM_USD) {
650                     LogPolicyDeclined(0, "Invalid premium value");
651                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
652                     return;
653                 }
654             }
655 
656             if (paymentType == 3) {
657                 // GBP
658                 if (msg.value < MIN_PREMIUM_GBP || msg.value > MAX_PREMIUM_GBP) {
659                     LogPolicyDeclined(0, "Invalid premium value");
660                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
661                     return;
662                 }
663             }
664         }
665 
666         // forward premium
667         FD_LG.receiveFunds.value(msg.value)(Acc.Premium);
668 
669 
670         // don't Accept flights with departure time earlier than in 24 hours,
671         // or arrivalTime before departureTime,
672         // or departureTime after Mon, 26 Sep 2016 12:00:00 GMT
673         uint dmy = toUnixtime(_departureYearMonthDay);
674 
675 // --> debug-mode
676 //            LogUintTime("NewPolicy: dmy: ", dmy);
677 //            LogUintTime("NewPolicy: _departureTime: ", _departureTime);
678 // <-- debug-mode
679 
680         if (
681             _arrivalTime < _departureTime ||
682             _arrivalTime > _departureTime + MAX_FLIGHT_DURATION ||
683             _departureTime < now + MIN_TIME_BEFORE_DEPARTURE ||
684             _departureTime > CONTRACT_DEAD_LINE ||
685             _departureTime < dmy ||
686             _departureTime > dmy + 24 hours ||
687             _departureTime < MIN_DEPARTURE_LIM ||
688             _departureTime > MAX_DEPARTURE_LIM
689         ) {
690             LogPolicyDeclined(0, "Invalid arrival/departure time");
691             FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
692             return;
693         }
694 
695         bytes32 riskId = FD_DB.createUpdateRisk(_carrierFlightNumber, _departureYearMonthDay, _arrivalTime);
696 
697         var (cumulatedWeightedPremium, premiumMultiplier) = FD_DB.getPremiumFactors(riskId);
698 
699         // roughly check, whether MAX_CUMULATED_WEIGHTED_PREMIUM will be exceeded
700         // (we Accept the inAccuracy that the real remaining premium is 3% lower),
701         // but we are conservative;
702         // if this is the first policy, the left side will be 0
703         if (msg.value * premiumMultiplier + cumulatedWeightedPremium >= MAX_CUMULATED_WEIGHTED_PREMIUM) {
704             // Let's ingore MAX_CUMULATED_WEIGHTED_PREMIUM for Cancun
705 
706             // LogPolicyDeclined(0, "Cluster risk");
707             // FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
708             // return;
709         } else if (cumulatedWeightedPremium == 0) {
710             // at the first police, we set r.cumulatedWeightedPremium to the max.
711             // this prevents further polices to be Accepted, until the correct
712             // value is calculated after the first callback from the oracle.
713             FD_DB.setPremiumFactors(riskId, MAX_CUMULATED_WEIGHTED_PREMIUM, premiumMultiplier);
714         }
715 
716         uint premium = bookAndCalcRemainingPremium();
717         uint policyId = FD_DB.createPolicy(msg.sender, premium, _currency, _customerExternalId, riskId);
718 
719         if (premiumMultiplier > 0) {
720             FD_DB.setPremiumFactors(
721                 riskId,
722                 cumulatedWeightedPremium + premium * premiumMultiplier,
723                 premiumMultiplier
724             );
725         }
726 
727         // now we have successfully applied
728         FD_DB.setState(
729             policyId,
730             policyState.Applied,
731             now,
732             "Policy applied by customer"
733         );
734 
735         LogPolicyApplied(
736             policyId,
737             msg.sender,
738             _carrierFlightNumber,
739             premium
740         );
741 
742         LogExternal(
743             policyId,
744             msg.sender,
745             _customerExternalId
746         );
747 
748         FD_UW.scheduleUnderwriteOraclizeCall(policyId, _carrierFlightNumber);
749     }
750 }