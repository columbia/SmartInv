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
13 contract FlightDelayDatabaseModel {
14 
15     // Ledger accounts.
16     enum Acc {
17         Premium,      // 0
18         RiskFund,     // 1
19         Payout,       // 2
20         Balance,      // 3
21         Reward,       // 4
22         OraclizeCosts // 5
23     }
24 
25     // policy Status Codes and meaning:
26     //
27     // 00 = Applied:	  the customer has payed a premium, but the oracle has
28     //					        not yet checked and confirmed.
29     //					        The customer can still revoke the policy.
30     // 01 = Accepted:	  the oracle has checked and confirmed.
31     //					        The customer can still revoke the policy.
32     // 02 = Revoked:	  The customer has revoked the policy.
33     //					        The premium minus cancellation fee is payed back to the
34     //					        customer by the oracle.
35     // 03 = PaidOut:	  The flight has ended with delay.
36     //					        The oracle has checked and payed out.
37     // 04 = Expired:	  The flight has endet with <15min. delay.
38     //					        No payout.
39     // 05 = Declined:	  The application was invalid.
40     //					        The premium minus cancellation fee is payed back to the
41     //					        customer by the oracle.
42     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
43     //					        for unknown reasons.
44     //					        The funds remain in the contracts RiskFund.
45 
46 
47     //                   00       01        02       03        04      05           06
48     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
49 
50     // oraclize callback types:
51     enum oraclizeState { ForUnderwriting, ForPayout }
52 
53     //               00   01   02   03
54     enum Currency { ETH, EUR, USD, GBP }
55 
56     // the policy structure: this structure keeps track of the individual parameters of a policy.
57     // typically customer address, premium and some status information.
58     struct Policy {
59         // 0 - the customer
60         address customer;
61 
62         // 1 - premium
63         uint premium;
64         // risk specific parameters:
65         // 2 - pointer to the risk in the risks mapping
66         bytes32 riskId;
67         // custom payout pattern
68         // in future versions, customer will be able to tamper with this array.
69         // to keep things simple, we have decided to hard-code the array for all policies.
70         // uint8[5] pattern;
71         // 3 - probability weight. this is the central parameter
72         uint weight;
73         // 4 - calculated Payout
74         uint calculatedPayout;
75         // 5 - actual Payout
76         uint actualPayout;
77 
78         // status fields:
79         // 6 - the state of the policy
80         policyState state;
81         // 7 - time of last state change
82         uint stateTime;
83         // 8 - state change message/reason
84         bytes32 stateMessage;
85         // 9 - TLSNotary Proof
86         bytes proof;
87         // 10 - Currency
88         Currency currency;
89         // 10 - External customer id
90         bytes32 customerExternalId;
91     }
92 
93     // the risk structure; this structure keeps track of the risk-
94     // specific parameters.
95     // several policies can share the same risk structure (typically
96     // some people flying with the same plane)
97     struct Risk {
98         // 0 - Airline Code + FlightNumber
99         bytes32 carrierFlightNumber;
100         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
101         bytes32 departureYearMonthDay;
102         // 2 - the inital arrival time
103         uint arrivalTime;
104         // 3 - the final delay in minutes
105         uint delayInMinutes;
106         // 4 - the determined delay category (0-5)
107         uint8 delay;
108         // 5 - we limit the cumulated weighted premium to avoid cluster risks
109         uint cumulatedWeightedPremium;
110         // 6 - max cumulated Payout for this risk
111         uint premiumMultiplier;
112     }
113 
114     // the oraclize callback structure: we use several oraclize calls.
115     // all oraclize calls will result in a common callback to __callback(...).
116     // to keep track of the different querys we have to introduce this struct.
117     struct OraclizeCallback {
118         // for which policy have we called?
119         uint policyId;
120         // for which purpose did we call? {ForUnderwrite | ForPayout}
121         oraclizeState oState;
122         // time
123         uint oraclizeTime;
124     }
125 
126     struct Customer {
127         bytes32 customerExternalId;
128         bool identityConfirmed;
129     }
130 }
131 
132 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
133 
134     address public controller;
135     FlightDelayControllerInterface FD_CI;
136 
137     modifier onlyController() {
138         require(msg.sender == controller);
139         _;
140     }
141 
142     function setController(address _controller) internal returns (bool _result) {
143         controller = _controller;
144         FD_CI = FlightDelayControllerInterface(_controller);
145         _result = true;
146     }
147 
148     function destruct() onlyController {
149         selfdestruct(controller);
150     }
151 
152     function setContracts() onlyController {}
153 
154     function getContract(bytes32 _id) internal returns (address _addr) {
155         _addr = FD_CI.getContract(_id);
156     }
157 }
158 
159 contract FlightDelayConstants {
160 
161     /*
162     * General events
163     */
164 
165 // --> test-mode
166 //        event LogUint(string _message, uint _uint);
167 //        event LogUintEth(string _message, uint ethUint);
168 //        event LogUintTime(string _message, uint timeUint);
169 //        event LogInt(string _message, int _int);
170 //        event LogAddress(string _message, address _address);
171 //        event LogBytes32(string _message, bytes32 hexBytes32);
172 //        event LogBytes(string _message, bytes hexBytes);
173 //        event LogBytes32Str(string _message, bytes32 strBytes32);
174 //        event LogString(string _message, string _string);
175 //        event LogBool(string _message, bool _bool);
176 //        event Log(address);
177 // <-- test-mode
178 
179     event LogPolicyApplied(
180         uint _policyId,
181         address _customer,
182         bytes32 strCarrierFlightNumber,
183         uint ethPremium
184     );
185     event LogPolicyAccepted(
186         uint _policyId,
187         uint _statistics0,
188         uint _statistics1,
189         uint _statistics2,
190         uint _statistics3,
191         uint _statistics4,
192         uint _statistics5
193     );
194     event LogPolicyPaidOut(
195         uint _policyId,
196         uint ethAmount
197     );
198     event LogPolicyExpired(
199         uint _policyId
200     );
201     event LogPolicyDeclined(
202         uint _policyId,
203         bytes32 strReason
204     );
205     event LogPolicyManualPayout(
206         uint _policyId,
207         bytes32 strReason
208     );
209     event LogSendFunds(
210         address _recipient,
211         uint8 _from,
212         uint ethAmount
213     );
214     event LogReceiveFunds(
215         address _sender,
216         uint8 _to,
217         uint ethAmount
218     );
219     event LogSendFail(
220         uint _policyId,
221         bytes32 strReason
222     );
223     event LogOraclizeCall(
224         uint _policyId,
225         bytes32 hexQueryId,
226         string _oraclizeUrl,
227         uint256 _oraclizeTime
228     );
229     event LogOraclizeCallback(
230         uint _policyId,
231         bytes32 hexQueryId,
232         string _result,
233         bytes hexProof
234     );
235     event LogSetState(
236         uint _policyId,
237         uint8 _policyState,
238         uint _stateTime,
239         bytes32 _stateMessage
240     );
241     event LogExternal(
242         uint256 _policyId,
243         address _address,
244         bytes32 _externalId
245     );
246 
247     /*
248     * General constants
249     */
250 
251     // minimum observations for valid prediction
252     uint constant MIN_OBSERVATIONS = 10;
253     // minimum premium to cover costs
254     uint constant MIN_PREMIUM = 50 finney;
255     // maximum premium
256     uint constant MAX_PREMIUM = 1 ether;
257     // maximum payout
258     uint constant MAX_PAYOUT = 1100 finney;
259 
260     uint constant MIN_PREMIUM_EUR = 1500 wei;
261     uint constant MAX_PREMIUM_EUR = 29000 wei;
262     uint constant MAX_PAYOUT_EUR = 30000 wei;
263 
264     uint constant MIN_PREMIUM_USD = 1700 wei;
265     uint constant MAX_PREMIUM_USD = 34000 wei;
266     uint constant MAX_PAYOUT_USD = 35000 wei;
267 
268     uint constant MIN_PREMIUM_GBP = 1300 wei;
269     uint constant MAX_PREMIUM_GBP = 25000 wei;
270     uint constant MAX_PAYOUT_GBP = 270 wei;
271 
272     // maximum cumulated weighted premium per risk
273     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;
274     // 1 percent for DAO, 1 percent for maintainer
275     uint8 constant REWARD_PERCENT = 2;
276     // reserve for tail risks
277     uint8 constant RESERVE_PERCENT = 1;
278     // the weight pattern; in future versions this may become part of the policy struct.
279     // currently can't be constant because of compiler restrictions
280     // WEIGHT_PATTERN[0] is not used, just to be consistent
281     uint8[6] WEIGHT_PATTERN = [
282         0,
283         10,
284         20,
285         30,
286         50,
287         50
288     ];
289 
290 // --> prod-mode
291     // DEFINITIONS FOR ROPSTEN AND MAINNET
292     // minimum time before departure for applying
293     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
294     // check for delay after .. minutes after scheduled arrival
295     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
296 // <-- prod-mode
297 
298 // --> test-mode
299 //        // DEFINITIONS FOR LOCAL TESTNET
300 //        // minimum time before departure for applying
301 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
302 //        // check for delay after .. minutes after scheduled arrival
303 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
304 // <-- test-mode
305 
306     // maximum duration of flight
307     uint constant MAX_FLIGHT_DURATION = 2 days;
308     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
309     uint constant CONTRACT_DEAD_LINE = 1922396399;
310 
311     uint constant MIN_DEPARTURE_LIM = 1508198400;
312 
313     uint constant MAX_DEPARTURE_LIM = 1509840000;
314 
315     // gas Constants for oraclize
316     uint constant ORACLIZE_GAS = 1000000;
317 
318 
319     /*
320     * URLs and query strings for oraclize
321     */
322 
323 // --> prod-mode
324     // DEFINITIONS FOR ROPSTEN AND MAINNET
325     string constant ORACLIZE_RATINGS_BASE_URL =
326         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
327         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
328     string constant ORACLIZE_RATINGS_QUERY =
329         "?${[decrypt] <!--PUT ENCRYPTED_QUERY HERE--> }).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
330     string constant ORACLIZE_STATUS_BASE_URL =
331         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
332         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
333     string constant ORACLIZE_STATUS_QUERY =
334         // pattern:
335         "?${[decrypt] <!--PUT ENCRYPTED_QUERY HERE--> }&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
336 // <-- prod-mode
337 
338 // --> test-mode
339 //        // DEFINITIONS FOR LOCAL TESTNET
340 //        string constant ORACLIZE_RATINGS_BASE_URL =
341 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
342 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
343 //        string constant ORACLIZE_RATINGS_QUERY =
344 //            // for testrpc:
345 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
346 //        string constant ORACLIZE_STATUS_BASE_URL =
347 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
348 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
349 //        string constant ORACLIZE_STATUS_QUERY =
350 //            // for testrpc:
351 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
352 // <-- test-mode
353 }
354 
355 contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {
356 
357     function setAccessControl(address _contract, address _caller, uint8 _perm);
358 
359     function setAccessControl(
360         address _contract,
361         address _caller,
362         uint8 _perm,
363         bool _access
364     );
365 
366     function getAccessControl(address _contract, address _caller, uint8 _perm) returns (bool _allowed);
367 
368     function setLedger(uint8 _index, int _value);
369 
370     function getLedger(uint8 _index) returns (int _value);
371 
372     function getCustomerPremium(uint _policyId) returns (address _customer, uint _premium);
373 
374     function getPolicyData(uint _policyId) returns (address _customer, uint _premium, uint _weight);
375 
376     function getPolicyState(uint _policyId) returns (policyState _state);
377 
378     function getRiskId(uint _policyId) returns (bytes32 _riskId);
379 
380     function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) returns (uint _policyId);
381 
382     function setState(
383         uint _policyId,
384         policyState _state,
385         uint _stateTime,
386         bytes32 _stateMessage
387     );
388 
389     function setWeight(uint _policyId, uint _weight, bytes _proof);
390 
391     function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout);
392 
393     function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes);
394 
395     function getRiskParameters(bytes32 _riskId)
396         returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime);
397 
398     function getPremiumFactors(bytes32 _riskId)
399         returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);
400 
401     function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)
402         returns (bytes32 _riskId);
403 
404     function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier);
405 
406     function getOraclizeCallback(bytes32 _queryId)
407         returns (uint _policyId, uint _arrivalTime);
408 
409     function getOraclizePolicyId(bytes32 _queryId)
410     returns (uint _policyId);
411 
412     function createOraclizeCallback(
413         bytes32 _queryId,
414         uint _policyId,
415         oraclizeState _oraclizeState,
416         uint _oraclizeTime
417     );
418 
419     function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)
420         returns (bool _result);
421 }
422 
423 contract FlightDelayAccessControllerInterface {
424 
425     function setPermissionById(uint8 _perm, bytes32 _id);
426 
427     function setPermissionById(uint8 _perm, bytes32 _id, bool _access);
428 
429     function setPermissionByAddress(uint8 _perm, address _addr);
430 
431     function setPermissionByAddress(uint8 _perm, address _addr, bool _access);
432 
433     function checkPermission(uint8 _perm, address _addr) returns (bool _success);
434 }
435 
436 
437 contract FlightDelayLedgerInterface is FlightDelayDatabaseModel {
438 
439     function receiveFunds(Acc _to) payable;
440 
441     function sendFunds(address _recipient, Acc _from, uint _amount) returns (bool _success);
442 
443     function bookkeeping(Acc _from, Acc _to, uint amount);
444 }
445 
446 contract FlightDelayUnderwriteInterface {
447 
448     function scheduleUnderwriteOraclizeCall(uint _policyId, bytes32 _carrierFlightNumber);
449 }
450 
451 contract ConvertLib {
452 
453     // .. since beginning of the year
454     uint16[12] days_since = [
455         11,
456         42,
457         70,
458         101,
459         131,
460         162,
461         192,
462         223,
463         254,
464         284,
465         315,
466         345
467     ];
468 
469     function b32toString(bytes32 x) internal returns (string) {
470         // gas usage: about 1K gas per char.
471         bytes memory bytesString = new bytes(32);
472         uint charCount = 0;
473 
474         for (uint j = 0; j < 32; j++) {
475             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
476             if (char != 0) {
477                 bytesString[charCount] = char;
478                 charCount++;
479             }
480         }
481 
482         bytes memory bytesStringTrimmed = new bytes(charCount);
483 
484         for (j = 0; j < charCount; j++) {
485             bytesStringTrimmed[j] = bytesString[j];
486         }
487 
488         return string(bytesStringTrimmed);
489     }
490 
491     function b32toHexString(bytes32 x) returns (string) {
492         bytes memory b = new bytes(64);
493         for (uint i = 0; i < 32; i++) {
494             uint8 by = uint8(uint(x) / (2**(8*(31 - i))));
495             uint8 high = by/16;
496             uint8 low = by - 16*high;
497             if (high > 9) {
498                 high += 39;
499             }
500             if (low > 9) {
501                 low += 39;
502             }
503             b[2*i] = byte(high+48);
504             b[2*i+1] = byte(low+48);
505         }
506 
507         return string(b);
508     }
509 
510     function parseInt(string _a) internal returns (uint) {
511         return parseInt(_a, 0);
512     }
513 
514     // parseInt(parseFloat*10^_b)
515     function parseInt(string _a, uint _b) internal returns (uint) {
516         bytes memory bresult = bytes(_a);
517         uint mint = 0;
518         bool decimals = false;
519         for (uint i = 0; i<bresult.length; i++) {
520             if ((bresult[i] >= 48)&&(bresult[i] <= 57)) {
521                 if (decimals) {
522                     if (_b == 0) {
523                         break;
524                     } else {
525                         _b--;
526                     }
527                 }
528                 mint *= 10;
529                 mint += uint(bresult[i]) - 48;
530             } else if (bresult[i] == 46) {
531                 decimals = true;
532             }
533         }
534         if (_b > 0) {
535             mint *= 10**_b;
536         }
537         return mint;
538     }
539 
540     // the following function yields correct results in the time between 1.3.2016 and 28.02.2020,
541     // so within the validity of the contract its correct.
542     function toUnixtime(bytes32 _dayMonthYear) constant returns (uint unixtime) {
543         // _day_month_year = /dep/2016/09/10
544         bytes memory bDmy = bytes(b32toString(_dayMonthYear));
545         bytes memory temp2 = bytes(new string(2));
546         bytes memory temp4 = bytes(new string(4));
547 
548         temp4[0] = bDmy[5];
549         temp4[1] = bDmy[6];
550         temp4[2] = bDmy[7];
551         temp4[3] = bDmy[8];
552         uint year = parseInt(string(temp4));
553 
554         temp2[0] = bDmy[10];
555         temp2[1] = bDmy[11];
556         uint month = parseInt(string(temp2));
557 
558         temp2[0] = bDmy[13];
559         temp2[1] = bDmy[14];
560         uint day = parseInt(string(temp2));
561 
562         unixtime = ((year - 1970) * 365 + days_since[month-1] + day) * 86400;
563     }
564 }
565 
566 contract FlightDelayNewPolicy is FlightDelayControlledContract, FlightDelayConstants, ConvertLib {
567 
568     FlightDelayAccessControllerInterface FD_AC;
569     FlightDelayDatabaseInterface FD_DB;
570     FlightDelayLedgerInterface FD_LG;
571     FlightDelayUnderwriteInterface FD_UW;
572 
573     function FlightDelayNewPolicy(address _controller) {
574         setController(_controller);
575     }
576 
577     function setContracts() onlyController {
578         FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));
579         FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));
580         FD_LG = FlightDelayLedgerInterface(getContract("FD.Ledger"));
581         FD_UW = FlightDelayUnderwriteInterface(getContract("FD.Underwrite"));
582 
583         FD_AC.setPermissionByAddress(101, 0x0);
584         FD_AC.setPermissionById(102, "FD.Controller");
585         FD_AC.setPermissionById(103, "FD.Owner");
586     }
587 
588     function bookAndCalcRemainingPremium() internal returns (uint) {
589         uint v = msg.value;
590         uint reserve = v * RESERVE_PERCENT / 100;
591         uint remain = v - reserve;
592         uint reward = remain * REWARD_PERCENT / 100;
593 
594         // FD_LG.bookkeeping(Acc.Balance, Acc.Premium, v);
595         FD_LG.bookkeeping(Acc.Premium, Acc.RiskFund, reserve);
596         FD_LG.bookkeeping(Acc.Premium, Acc.Reward, reward);
597 
598         return (uint(remain - reward));
599     }
600 
601     function maintenanceMode(bool _on) {
602         if (FD_AC.checkPermission(103, msg.sender)) {
603             FD_AC.setPermissionByAddress(101, 0x0, !_on);
604         }
605     }
606 
607     // create new policy
608     function newPolicy(
609         bytes32 _carrierFlightNumber,
610         bytes32 _departureYearMonthDay,
611         uint256 _departureTime,
612         uint256 _arrivalTime,
613         Currency _currency,
614         bytes32 _customerExternalId) payable
615     {
616         // here we can switch it off.
617         require(FD_AC.checkPermission(101, 0x0));
618 
619         require(uint256(_currency) <= 3);
620 
621         uint8 paymentType = uint8(_currency);
622 
623         if (paymentType == 0) {
624             // ETH
625             if (msg.value < MIN_PREMIUM || msg.value > MAX_PREMIUM) {
626                 LogPolicyDeclined(0, "Invalid premium value");
627                 FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
628                 return;
629             }
630         } else {
631             require(msg.sender == FD_CI.getContract("FD.CustomersAdmin"));
632 
633             if (paymentType == 1) {
634                 // EUR
635                 if (msg.value < MIN_PREMIUM_EUR || msg.value > MAX_PREMIUM_EUR) {
636                     LogPolicyDeclined(0, "Invalid premium value");
637                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
638                     return;
639                 }
640             }
641 
642             if (paymentType == 2) {
643                 // USD
644                 if (msg.value < MIN_PREMIUM_USD || msg.value > MAX_PREMIUM_USD) {
645                     LogPolicyDeclined(0, "Invalid premium value");
646                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
647                     return;
648                 }
649             }
650 
651             if (paymentType == 3) {
652                 // GBP
653                 if (msg.value < MIN_PREMIUM_GBP || msg.value > MAX_PREMIUM_GBP) {
654                     LogPolicyDeclined(0, "Invalid premium value");
655                     FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
656                     return;
657                 }
658             }
659         }
660 
661         // forward premium
662         FD_LG.receiveFunds.value(msg.value)(Acc.Premium);
663 
664 
665         // don't Accept flights with departure time earlier than in 24 hours,
666         // or arrivalTime before departureTime,
667         // or departureTime after Mon, 26 Sep 2016 12:00:00 GMT
668         uint dmy = toUnixtime(_departureYearMonthDay);
669 
670 // --> debug-mode
671 //            LogUintTime("NewPolicy: dmy: ", dmy);
672 //            LogUintTime("NewPolicy: _departureTime: ", _departureTime);
673 // <-- debug-mode
674 
675         if (
676             _arrivalTime < _departureTime ||
677             _arrivalTime > _departureTime + MAX_FLIGHT_DURATION ||
678             _departureTime < now + MIN_TIME_BEFORE_DEPARTURE ||
679             _departureTime > CONTRACT_DEAD_LINE ||
680             _departureTime < dmy ||
681             _departureTime > dmy + 24 hours ||
682             _departureTime < MIN_DEPARTURE_LIM ||
683             _departureTime > MAX_DEPARTURE_LIM
684         ) {
685             LogPolicyDeclined(0, "Invalid arrival/departure time");
686             FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
687             return;
688         }
689 
690         bytes32 riskId = FD_DB.createUpdateRisk(_carrierFlightNumber, _departureYearMonthDay, _arrivalTime);
691 
692         var (cumulatedWeightedPremium, premiumMultiplier) = FD_DB.getPremiumFactors(riskId);
693 
694         // roughly check, whether MAX_CUMULATED_WEIGHTED_PREMIUM will be exceeded
695         // (we Accept the inAccuracy that the real remaining premium is 3% lower),
696         // but we are conservative;
697         // if this is the first policy, the left side will be 0
698         if (msg.value * premiumMultiplier + cumulatedWeightedPremium >= MAX_CUMULATED_WEIGHTED_PREMIUM) {
699             LogPolicyDeclined(0, "Cluster risk");
700             FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);
701             return;
702         } else if (cumulatedWeightedPremium == 0) {
703             // at the first police, we set r.cumulatedWeightedPremium to the max.
704             // this prevents further polices to be Accepted, until the correct
705             // value is calculated after the first callback from the oracle.
706             FD_DB.setPremiumFactors(riskId, MAX_CUMULATED_WEIGHTED_PREMIUM, premiumMultiplier);
707         }
708 
709         uint premium = bookAndCalcRemainingPremium();
710         uint policyId = FD_DB.createPolicy(msg.sender, premium, _currency, _customerExternalId, riskId);
711 
712         if (premiumMultiplier > 0) {
713             FD_DB.setPremiumFactors(
714                 riskId,
715                 cumulatedWeightedPremium + premium * premiumMultiplier,
716                 premiumMultiplier
717             );
718         }
719 
720         // now we have successfully applied
721         FD_DB.setState(
722             policyId,
723             policyState.Applied,
724             now,
725             "Policy applied by customer"
726         );
727 
728         LogPolicyApplied(
729             policyId,
730             msg.sender,
731             _carrierFlightNumber,
732             premium
733         );
734 
735         LogExternal(
736             policyId,
737             msg.sender,
738             _customerExternalId
739         );
740 
741         FD_UW.scheduleUnderwriteOraclizeCall(policyId, _carrierFlightNumber);
742     }
743 }