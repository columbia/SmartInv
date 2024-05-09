1 pragma solidity ^0.4.11;
2 
3 contract FlightDelayControllerInterface {
4 
5     function isOwner(address _addr) returns (bool _isOwner);
6 
7     function selfRegister(bytes32 _id) returns (bool result);
8 
9     function getContract(bytes32 _id) returns (address _addr);
10 }
11 
12 contract FlightDelayDatabaseModel {
13 
14     // Ledger accounts.
15     enum Acc {
16         Premium,      // 0
17         RiskFund,     // 1
18         Payout,       // 2
19         Balance,      // 3
20         Reward,       // 4
21         OraclizeCosts // 5
22     }
23 
24     // policy Status Codes and meaning:
25     //
26     // 00 = Applied:	  the customer has payed a premium, but the oracle has
27     //					        not yet checked and confirmed.
28     //					        The customer can still revoke the policy.
29     // 01 = Accepted:	  the oracle has checked and confirmed.
30     //					        The customer can still revoke the policy.
31     // 02 = Revoked:	  The customer has revoked the policy.
32     //					        The premium minus cancellation fee is payed back to the
33     //					        customer by the oracle.
34     // 03 = PaidOut:	  The flight has ended with delay.
35     //					        The oracle has checked and payed out.
36     // 04 = Expired:	  The flight has endet with <15min. delay.
37     //					        No payout.
38     // 05 = Declined:	  The application was invalid.
39     //					        The premium minus cancellation fee is payed back to the
40     //					        customer by the oracle.
41     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
42     //					        for unknown reasons.
43     //					        The funds remain in the contracts RiskFund.
44 
45 
46     //                   00       01        02       03        04      05           06
47     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
48 
49     // oraclize callback types:
50     enum oraclizeState { ForUnderwriting, ForPayout }
51 
52     //               00   01   02   03
53     enum Currency { ETH, EUR, USD, GBP }
54 
55     // the policy structure: this structure keeps track of the individual parameters of a policy.
56     // typically customer address, premium and some status information.
57     struct Policy {
58         // 0 - the customer
59         address customer;
60 
61         // 1 - premium
62         uint premium;
63         // risk specific parameters:
64         // 2 - pointer to the risk in the risks mapping
65         bytes32 riskId;
66         // custom payout pattern
67         // in future versions, customer will be able to tamper with this array.
68         // to keep things simple, we have decided to hard-code the array for all policies.
69         // uint8[5] pattern;
70         // 3 - probability weight. this is the central parameter
71         uint weight;
72         // 4 - calculated Payout
73         uint calculatedPayout;
74         // 5 - actual Payout
75         uint actualPayout;
76 
77         // status fields:
78         // 6 - the state of the policy
79         policyState state;
80         // 7 - time of last state change
81         uint stateTime;
82         // 8 - state change message/reason
83         bytes32 stateMessage;
84         // 9 - TLSNotary Proof
85         bytes proof;
86         // 10 - Currency
87         Currency currency;
88         // 10 - External customer id
89         bytes32 customerExternalId;
90     }
91 
92     // the risk structure; this structure keeps track of the risk-
93     // specific parameters.
94     // several policies can share the same risk structure (typically
95     // some people flying with the same plane)
96     struct Risk {
97         // 0 - Airline Code + FlightNumber
98         bytes32 carrierFlightNumber;
99         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
100         bytes32 departureYearMonthDay;
101         // 2 - the inital arrival time
102         uint arrivalTime;
103         // 3 - the final delay in minutes
104         uint delayInMinutes;
105         // 4 - the determined delay category (0-5)
106         uint8 delay;
107         // 5 - we limit the cumulated weighted premium to avoid cluster risks
108         uint cumulatedWeightedPremium;
109         // 6 - max cumulated Payout for this risk
110         uint premiumMultiplier;
111     }
112 
113     // the oraclize callback structure: we use several oraclize calls.
114     // all oraclize calls will result in a common callback to __callback(...).
115     // to keep track of the different querys we have to introduce this struct.
116     struct OraclizeCallback {
117         // for which policy have we called?
118         uint policyId;
119         // for which purpose did we call? {ForUnderwrite | ForPayout}
120         oraclizeState oState;
121         // time
122         uint oraclizeTime;
123     }
124 
125     struct Customer {
126         bytes32 customerExternalId;
127         bool identityConfirmed;
128     }
129 }
130 
131 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
132 
133     address public controller;
134     FlightDelayControllerInterface FD_CI;
135 
136     modifier onlyController() {
137         require(msg.sender == controller);
138         _;
139     }
140 
141     function setController(address _controller) internal returns (bool _result) {
142         controller = _controller;
143         FD_CI = FlightDelayControllerInterface(_controller);
144         _result = true;
145     }
146 
147     function destruct() onlyController {
148         selfdestruct(controller);
149     }
150 
151     function setContracts() onlyController {}
152 
153     function getContract(bytes32 _id) internal returns (address _addr) {
154         _addr = FD_CI.getContract(_id);
155     }
156 }
157 
158 contract FlightDelayAccessControllerInterface {
159 
160     function setPermissionById(uint8 _perm, bytes32 _id);
161 
162     function setPermissionById(uint8 _perm, bytes32 _id, bool _access);
163 
164     function setPermissionByAddress(uint8 _perm, address _addr);
165 
166     function setPermissionByAddress(uint8 _perm, address _addr, bool _access);
167 
168     function checkPermission(uint8 _perm, address _addr) returns (bool _success);
169 }
170 
171 contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {
172 
173     function setAccessControl(address _contract, address _caller, uint8 _perm);
174 
175     function setAccessControl(
176         address _contract,
177         address _caller,
178         uint8 _perm,
179         bool _access
180     );
181 
182     function getAccessControl(address _contract, address _caller, uint8 _perm) returns (bool _allowed);
183 
184     function setLedger(uint8 _index, int _value);
185 
186     function getLedger(uint8 _index) returns (int _value);
187 
188     function getCustomerPremium(uint _policyId) returns (address _customer, uint _premium);
189 
190     function getPolicyData(uint _policyId) returns (address _customer, uint _premium, uint _weight);
191 
192     function getPolicyState(uint _policyId) returns (policyState _state);
193 
194     function getRiskId(uint _policyId) returns (bytes32 _riskId);
195 
196     function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) returns (uint _policyId);
197 
198     function setState(
199         uint _policyId,
200         policyState _state,
201         uint _stateTime,
202         bytes32 _stateMessage
203     );
204 
205     function setWeight(uint _policyId, uint _weight, bytes _proof);
206 
207     function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout);
208 
209     function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes);
210 
211     function getRiskParameters(bytes32 _riskId)
212         returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime);
213 
214     function getPremiumFactors(bytes32 _riskId)
215         returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);
216 
217     function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)
218         returns (bytes32 _riskId);
219 
220     function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier);
221 
222     function getOraclizeCallback(bytes32 _queryId)
223         returns (uint _policyId, uint _arrivalTime);
224 
225     function getOraclizePolicyId(bytes32 _queryId)
226     returns (uint _policyId);
227 
228     function createOraclizeCallback(
229         bytes32 _queryId,
230         uint _policyId,
231         oraclizeState _oraclizeState,
232         uint _oraclizeTime
233     );
234 
235     function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)
236         returns (bool _result);
237 }
238 
239 contract FlightDelayLedgerInterface is FlightDelayDatabaseModel {
240 
241     function receiveFunds(Acc _to) payable;
242 
243     function sendFunds(address _recipient, Acc _from, uint _amount) returns (bool _success);
244 
245     function bookkeeping(Acc _from, Acc _to, uint amount);
246 }
247 
248 contract FlightDelayConstants {
249 
250     /*
251     * General events
252     */
253 
254 // --> test-mode
255 //        event LogUint(string _message, uint _uint);
256 //        event LogUintEth(string _message, uint ethUint);
257 //        event LogUintTime(string _message, uint timeUint);
258 //        event LogInt(string _message, int _int);
259 //        event LogAddress(string _message, address _address);
260 //        event LogBytes32(string _message, bytes32 hexBytes32);
261 //        event LogBytes(string _message, bytes hexBytes);
262 //        event LogBytes32Str(string _message, bytes32 strBytes32);
263 //        event LogString(string _message, string _string);
264 //        event LogBool(string _message, bool _bool);
265 //        event Log(address);
266 // <-- test-mode
267 
268     event LogPolicyApplied(
269         uint _policyId,
270         address _customer,
271         bytes32 strCarrierFlightNumber,
272         uint ethPremium
273     );
274     event LogPolicyAccepted(
275         uint _policyId,
276         uint _statistics0,
277         uint _statistics1,
278         uint _statistics2,
279         uint _statistics3,
280         uint _statistics4,
281         uint _statistics5
282     );
283     event LogPolicyPaidOut(
284         uint _policyId,
285         uint ethAmount
286     );
287     event LogPolicyExpired(
288         uint _policyId
289     );
290     event LogPolicyDeclined(
291         uint _policyId,
292         bytes32 strReason
293     );
294     event LogPolicyManualPayout(
295         uint _policyId,
296         bytes32 strReason
297     );
298     event LogSendFunds(
299         address _recipient,
300         uint8 _from,
301         uint ethAmount
302     );
303     event LogReceiveFunds(
304         address _sender,
305         uint8 _to,
306         uint ethAmount
307     );
308     event LogSendFail(
309         uint _policyId,
310         bytes32 strReason
311     );
312     event LogOraclizeCall(
313         uint _policyId,
314         bytes32 hexQueryId,
315         string _oraclizeUrl,
316         uint256 _oraclizeTime
317     );
318     event LogOraclizeCallback(
319         uint _policyId,
320         bytes32 hexQueryId,
321         string _result,
322         bytes hexProof
323     );
324     event LogSetState(
325         uint _policyId,
326         uint8 _policyState,
327         uint _stateTime,
328         bytes32 _stateMessage
329     );
330     event LogExternal(
331         uint256 _policyId,
332         address _address,
333         bytes32 _externalId
334     );
335 
336     /*
337     * General constants
338     */
339 
340     // minimum observations for valid prediction
341     uint constant MIN_OBSERVATIONS = 10;
342     // minimum premium to cover costs
343     uint constant MIN_PREMIUM = 50 finney;
344     // maximum premium
345     uint constant MAX_PREMIUM = 1 ether;
346     // maximum payout
347     uint constant MAX_PAYOUT = 1100 finney;
348 
349     uint constant MIN_PREMIUM_EUR = 1500 wei;
350     uint constant MAX_PREMIUM_EUR = 29000 wei;
351     uint constant MAX_PAYOUT_EUR = 30000 wei;
352 
353     uint constant MIN_PREMIUM_USD = 1700 wei;
354     uint constant MAX_PREMIUM_USD = 34000 wei;
355     uint constant MAX_PAYOUT_USD = 35000 wei;
356 
357     uint constant MIN_PREMIUM_GBP = 1300 wei;
358     uint constant MAX_PREMIUM_GBP = 25000 wei;
359     uint constant MAX_PAYOUT_GBP = 270 wei;
360 
361     // maximum cumulated weighted premium per risk
362     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;
363     // 1 percent for DAO, 1 percent for maintainer
364     uint8 constant REWARD_PERCENT = 2;
365     // reserve for tail risks
366     uint8 constant RESERVE_PERCENT = 1;
367     // the weight pattern; in future versions this may become part of the policy struct.
368     // currently can't be constant because of compiler restrictions
369     // WEIGHT_PATTERN[0] is not used, just to be consistent
370     uint8[6] WEIGHT_PATTERN = [
371         0,
372         10,
373         20,
374         30,
375         50,
376         50
377     ];
378 
379 // --> prod-mode
380     // DEFINITIONS FOR ROPSTEN AND MAINNET
381     // minimum time before departure for applying
382     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
383     // check for delay after .. minutes after scheduled arrival
384     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
385 // <-- prod-mode
386 
387 // --> test-mode
388 //        // DEFINITIONS FOR LOCAL TESTNET
389 //        // minimum time before departure for applying
390 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
391 //        // check for delay after .. minutes after scheduled arrival
392 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
393 // <-- test-mode
394 
395     // maximum duration of flight
396     uint constant MAX_FLIGHT_DURATION = 2 days;
397     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
398     uint constant CONTRACT_DEAD_LINE = 1922396399;
399 
400     uint constant MIN_DEPARTURE_LIM = 1508198400;
401 
402     uint constant MAX_DEPARTURE_LIM = 1509840000;
403 
404     // gas Constants for oraclize
405     uint constant ORACLIZE_GAS = 1000000;
406 
407 
408     /*
409     * URLs and query strings for oraclize
410     */
411 
412 // --> prod-mode
413     // DEFINITIONS FOR ROPSTEN AND MAINNET
414     string constant ORACLIZE_RATINGS_BASE_URL =
415         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
416         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
417     string constant ORACLIZE_RATINGS_QUERY =
418         "?${[decrypt] <!--PUT ENCRYPTED_QUERY HERE--> }).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
419     string constant ORACLIZE_STATUS_BASE_URL =
420         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
421         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
422     string constant ORACLIZE_STATUS_QUERY =
423         // pattern:
424         "?${[decrypt] <!--PUT ENCRYPTED_QUERY HERE--> }&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
425 // <-- prod-mode
426 
427 // --> test-mode
428 //        // DEFINITIONS FOR LOCAL TESTNET
429 //        string constant ORACLIZE_RATINGS_BASE_URL =
430 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
431 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
432 //        string constant ORACLIZE_RATINGS_QUERY =
433 //            // for testrpc:
434 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
435 //        string constant ORACLIZE_STATUS_BASE_URL =
436 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
437 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
438 //        string constant ORACLIZE_STATUS_QUERY =
439 //            // for testrpc:
440 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
441 // <-- test-mode
442 }
443 
444 contract FlightDelayLedger is FlightDelayControlledContract, FlightDelayLedgerInterface, FlightDelayConstants {
445 
446     FlightDelayDatabaseInterface FD_DB;
447     FlightDelayAccessControllerInterface FD_AC;
448 
449     function FlightDelayLedger(address _controller) {
450         setController(_controller);
451     }
452 
453     function setContracts() onlyController {
454         FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));
455         FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));
456 
457         FD_AC.setPermissionById(101, "FD.NewPolicy");
458         FD_AC.setPermissionById(101, "FD.Controller"); // todo: check!
459 
460         FD_AC.setPermissionById(102, "FD.Payout");
461         FD_AC.setPermissionById(102, "FD.NewPolicy");
462         FD_AC.setPermissionById(102, "FD.Controller"); // todo: check!
463         FD_AC.setPermissionById(102, "FD.Underwrite");
464         FD_AC.setPermissionById(102, "FD.Owner");
465 
466         FD_AC.setPermissionById(103, "FD.Funder");
467         FD_AC.setPermissionById(103, "FD.Underwrite");
468         FD_AC.setPermissionById(103, "FD.Payout");
469         FD_AC.setPermissionById(103, "FD.Ledger");
470         FD_AC.setPermissionById(103, "FD.NewPolicy");
471         FD_AC.setPermissionById(103, "FD.Controller");
472         FD_AC.setPermissionById(103, "FD.Owner");
473 
474         FD_AC.setPermissionById(104, "FD.Funder");
475     }
476 
477     /*
478      * @dev Fund contract
479      */
480     function fund() payable {
481         require(FD_AC.checkPermission(104, msg.sender));
482 
483         bookkeeping(Acc.Balance, Acc.RiskFund, msg.value);
484 
485         // todo: fire funding event
486     }
487 
488     function receiveFunds(Acc _to) payable {
489         require(FD_AC.checkPermission(101, msg.sender));
490 
491         LogReceiveFunds(msg.sender, uint8(_to), msg.value);
492 
493         bookkeeping(Acc.Balance, _to, msg.value);
494     }
495 
496     function sendFunds(address _recipient, Acc _from, uint _amount) returns (bool _success) {
497         require(FD_AC.checkPermission(102, msg.sender));
498 
499         if (this.balance < _amount) {
500             return false; // unsufficient funds
501         }
502 
503         LogSendFunds(_recipient, uint8(_from), _amount);
504 
505         bookkeeping(_from, Acc.Balance, _amount); // cash out payout
506 
507         if (!_recipient.send(_amount)) {
508             bookkeeping(Acc.Balance, _from, _amount);
509             _success = false;
510         } else {
511             _success = true;
512         }
513     }
514 
515     // invariant: acc_Premium + acc_RiskFund + acc_Payout + acc_Balance + acc_Reward + acc_OraclizeCosts == 0
516 
517     function bookkeeping(Acc _from, Acc _to, uint256 _amount) {
518         require(FD_AC.checkPermission(103, msg.sender));
519 
520         // check against type cast overflow
521         assert(int256(_amount) > 0);
522 
523         // overflow check is done in FD_DB
524         FD_DB.setLedger(uint8(_from), -int(_amount));
525         FD_DB.setLedger(uint8(_to), int(_amount));
526     }
527 }