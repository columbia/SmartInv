1 /**
2  * FlightDelay with Oraclized Underwriting and Payout
3  *
4  * @description	Events and Constants
5  * @copyright (c) 2017 etherisc GmbH
6  * @author Christoph Mussenbrock
7  */
8 
9 pragma solidity ^0.4.11;
10 
11 
12 contract FlightDelayConstants {
13 
14     /*
15     * General events
16     */
17 
18 // --> test-mode
19 //        event LogUint(string _message, uint _uint);
20 //        event LogUintEth(string _message, uint ethUint);
21 //        event LogUintTime(string _message, uint timeUint);
22 //        event LogInt(string _message, int _int);
23 //        event LogAddress(string _message, address _address);
24 //        event LogBytes32(string _message, bytes32 hexBytes32);
25 //        event LogBytes(string _message, bytes hexBytes);
26 //        event LogBytes32Str(string _message, bytes32 strBytes32);
27 //        event LogString(string _message, string _string);
28 //        event LogBool(string _message, bool _bool);
29 //        event Log(address);
30 // <-- test-mode
31 
32     event LogPolicyApplied(
33         uint _policyId,
34         address _customer,
35         bytes32 strCarrierFlightNumber,
36         uint ethPremium
37     );
38     event LogPolicyAccepted(
39         uint _policyId,
40         uint _statistics0,
41         uint _statistics1,
42         uint _statistics2,
43         uint _statistics3,
44         uint _statistics4,
45         uint _statistics5
46     );
47     event LogPolicyPaidOut(
48         uint _policyId,
49         uint ethAmount
50     );
51     event LogPolicyExpired(
52         uint _policyId
53     );
54     event LogPolicyDeclined(
55         uint _policyId,
56         bytes32 strReason
57     );
58     event LogPolicyManualPayout(
59         uint _policyId,
60         bytes32 strReason
61     );
62     event LogSendFunds(
63         address _recipient,
64         uint8 _from,
65         uint ethAmount
66     );
67     event LogReceiveFunds(
68         address _sender,
69         uint8 _to,
70         uint ethAmount
71     );
72     event LogSendFail(
73         uint _policyId,
74         bytes32 strReason
75     );
76     event LogOraclizeCall(
77         uint _policyId,
78         bytes32 hexQueryId,
79         string _oraclizeUrl,
80         uint256 _oraclizeTime
81     );
82     event LogOraclizeCallback(
83         uint _policyId,
84         bytes32 hexQueryId,
85         string _result,
86         bytes hexProof
87     );
88     event LogSetState(
89         uint _policyId,
90         uint8 _policyState,
91         uint _stateTime,
92         bytes32 _stateMessage
93     );
94     event LogExternal(
95         uint256 _policyId,
96         address _address,
97         bytes32 _externalId
98     );
99 
100     /*
101     * General constants
102     */
103 
104     // minimum observations for valid prediction
105     uint constant MIN_OBSERVATIONS = 10;
106     // minimum premium to cover costs
107     uint constant MIN_PREMIUM = 50 finney;
108     // maximum premium
109     uint constant MAX_PREMIUM = 1 ether;
110     // maximum payout
111     uint constant MAX_PAYOUT = 1100 finney;
112 
113     uint constant MIN_PREMIUM_EUR = 1500 wei;
114     uint constant MAX_PREMIUM_EUR = 29000 wei;
115     uint constant MAX_PAYOUT_EUR = 30000 wei;
116 
117     uint constant MIN_PREMIUM_USD = 1700 wei;
118     uint constant MAX_PREMIUM_USD = 34000 wei;
119     uint constant MAX_PAYOUT_USD = 35000 wei;
120 
121     uint constant MIN_PREMIUM_GBP = 1300 wei;
122     uint constant MAX_PREMIUM_GBP = 25000 wei;
123     uint constant MAX_PAYOUT_GBP = 270 wei;
124 
125     // maximum cumulated weighted premium per risk
126     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;
127     // 1 percent for DAO, 1 percent for maintainer
128     uint8 constant REWARD_PERCENT = 2;
129     // reserve for tail risks
130     uint8 constant RESERVE_PERCENT = 1;
131     // the weight pattern; in future versions this may become part of the policy struct.
132     // currently can't be constant because of compiler restrictions
133     // WEIGHT_PATTERN[0] is not used, just to be consistent
134     uint8[6] WEIGHT_PATTERN = [
135         0,
136         10,
137         20,
138         30,
139         50,
140         50
141     ];
142 
143 // --> prod-mode
144     // DEFINITIONS FOR ROPSTEN AND MAINNET
145     // minimum time before departure for applying
146     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
147     // check for delay after .. minutes after scheduled arrival
148     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
149 // <-- prod-mode
150 
151 // --> test-mode
152 //        // DEFINITIONS FOR LOCAL TESTNET
153 //        // minimum time before departure for applying
154 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
155 //        // check for delay after .. minutes after scheduled arrival
156 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
157 // <-- test-mode
158 
159     // maximum duration of flight
160     uint constant MAX_FLIGHT_DURATION = 2 days;
161     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
162     uint constant CONTRACT_DEAD_LINE = 1922396399;
163 
164     // gas Constants for oraclize
165     uint constant ORACLIZE_GAS = 700000;
166     uint constant ORACLIZE_GASPRICE = 4000000000;
167 
168 
169     /*
170     * URLs and query strings for oraclize
171     */
172 
173 // --> prod-mode
174     // DEFINITIONS FOR ROPSTEN AND MAINNET
175     string constant ORACLIZE_RATINGS_BASE_URL =
176         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
177         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
178     string constant ORACLIZE_RATINGS_QUERY =
179         "?${[decrypt] BAr6Z9QolM2PQimF/pNC6zXldOvZ2qquOSKm/qJkJWnSGgAeRw21wBGnBbXiamr/ISC5SlcJB6wEPKthdc6F+IpqM/iXavKsalRUrGNuBsGfaMXr8fRQw6gLzqk0ecOFNeCa48/yqBvC/kas+jTKHiYxA3wTJrVZCq76Y03lZI2xxLaoniRk}).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
180     string constant ORACLIZE_STATUS_BASE_URL =
181         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
182         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
183     string constant ORACLIZE_STATUS_QUERY =
184         // pattern:
185         "?${[decrypt] BJxpwRaHujYTT98qI5slQJplj/VbfV7vYkMOp/Mr5D/5+gkgJQKZb0gVSCa6aKx2Wogo/cG7yaWINR6vnuYzccQE5yVJSr7RQilRawxnAtZXt6JB70YpX4xlfvpipit4R+OmQTurJGGwb8Pgnr4LvotydCjup6wv2Bk/z3UdGA7Sl+FU5a+0}&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
186 // <-- prod-mode
187 
188 // --> test-mode
189 //        // DEFINITIONS FOR LOCAL TESTNET
190 //        string constant ORACLIZE_RATINGS_BASE_URL =
191 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
192 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
193 //        string constant ORACLIZE_RATINGS_QUERY =
194 //            // for testrpc:
195 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
196 //        string constant ORACLIZE_STATUS_BASE_URL =
197 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
198 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
199 //        string constant ORACLIZE_STATUS_QUERY =
200 //            // for testrpc:
201 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
202 // <-- test-mode
203 }
204 
205 // File: contracts/FlightDelayControllerInterface.sol
206 
207 /**
208  * FlightDelay with Oraclized Underwriting and Payout
209  *
210  * @description Contract interface
211  * @copyright (c) 2017 etherisc GmbH
212  * @author Christoph Mussenbrock, Stephan Karpischek
213  */
214 
215 pragma solidity ^0.4.11;
216 
217 
218 contract FlightDelayControllerInterface {
219 
220     function isOwner(address _addr) public returns (bool _isOwner);
221 
222     function selfRegister(bytes32 _id) public returns (bool result);
223 
224     function getContract(bytes32 _id) public returns (address _addr);
225 }
226 
227 // File: contracts/FlightDelayDatabaseModel.sol
228 
229 /**
230  * FlightDelay with Oraclized Underwriting and Payout
231  *
232  * @description Database model
233  * @copyright (c) 2017 etherisc GmbH
234  * @author Christoph Mussenbrock, Stephan Karpischek
235  */
236 
237 pragma solidity ^0.4.11;
238 
239 
240 contract FlightDelayDatabaseModel {
241 
242     // Ledger accounts.
243     enum Acc {
244         Premium,      // 0
245         RiskFund,     // 1
246         Payout,       // 2
247         Balance,      // 3
248         Reward,       // 4
249         OraclizeCosts // 5
250     }
251 
252     // policy Status Codes and meaning:
253     //
254     // 00 = Applied:	  the customer has payed a premium, but the oracle has
255     //					        not yet checked and confirmed.
256     //					        The customer can still revoke the policy.
257     // 01 = Accepted:	  the oracle has checked and confirmed.
258     //					        The customer can still revoke the policy.
259     // 02 = Revoked:	  The customer has revoked the policy.
260     //					        The premium minus cancellation fee is payed back to the
261     //					        customer by the oracle.
262     // 03 = PaidOut:	  The flight has ended with delay.
263     //					        The oracle has checked and payed out.
264     // 04 = Expired:	  The flight has endet with <15min. delay.
265     //					        No payout.
266     // 05 = Declined:	  The application was invalid.
267     //					        The premium minus cancellation fee is payed back to the
268     //					        customer by the oracle.
269     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
270     //					        for unknown reasons.
271     //					        The funds remain in the contracts RiskFund.
272 
273 
274     //                   00       01        02       03        04      05           06
275     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
276 
277     // oraclize callback types:
278     enum oraclizeState { ForUnderwriting, ForPayout }
279 
280     //               00   01   02   03
281     enum Currency { ETH, EUR, USD, GBP }
282 
283     // the policy structure: this structure keeps track of the individual parameters of a policy.
284     // typically customer address, premium and some status information.
285     struct Policy {
286         // 0 - the customer
287         address customer;
288 
289         // 1 - premium
290         uint premium;
291         // risk specific parameters:
292         // 2 - pointer to the risk in the risks mapping
293         bytes32 riskId;
294         // custom payout pattern
295         // in future versions, customer will be able to tamper with this array.
296         // to keep things simple, we have decided to hard-code the array for all policies.
297         // uint8[5] pattern;
298         // 3 - probability weight. this is the central parameter
299         uint weight;
300         // 4 - calculated Payout
301         uint calculatedPayout;
302         // 5 - actual Payout
303         uint actualPayout;
304 
305         // status fields:
306         // 6 - the state of the policy
307         policyState state;
308         // 7 - time of last state change
309         uint stateTime;
310         // 8 - state change message/reason
311         bytes32 stateMessage;
312         // 9 - TLSNotary Proof
313         bytes proof;
314         // 10 - Currency
315         Currency currency;
316         // 10 - External customer id
317         bytes32 customerExternalId;
318     }
319 
320     // the risk structure; this structure keeps track of the risk-
321     // specific parameters.
322     // several policies can share the same risk structure (typically
323     // some people flying with the same plane)
324     struct Risk {
325         // 0 - Airline Code + FlightNumber
326         bytes32 carrierFlightNumber;
327         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
328         bytes32 departureYearMonthDay;
329         // 2 - the inital arrival time
330         uint arrivalTime;
331         // 3 - the final delay in minutes
332         uint delayInMinutes;
333         // 4 - the determined delay category (0-5)
334         uint8 delay;
335         // 5 - we limit the cumulated weighted premium to avoid cluster risks
336         uint cumulatedWeightedPremium;
337         // 6 - max cumulated Payout for this risk
338         uint premiumMultiplier;
339     }
340 
341     // the oraclize callback structure: we use several oraclize calls.
342     // all oraclize calls will result in a common callback to __callback(...).
343     // to keep track of the different querys we have to introduce this struct.
344     struct OraclizeCallback {
345         // for which policy have we called?
346         uint policyId;
347         // for which purpose did we call? {ForUnderwrite | ForPayout}
348         oraclizeState oState;
349         // time
350         uint oraclizeTime;
351     }
352 
353     struct Customer {
354         bytes32 customerExternalId;
355         bool identityConfirmed;
356     }
357 }
358 
359 // File: contracts/FlightDelayControlledContract.sol
360 
361 /**
362  * FlightDelay with Oraclized Underwriting and Payout
363  *
364  * @description Controlled contract Interface
365  * @copyright (c) 2017 etherisc GmbH
366  * @author Christoph Mussenbrock
367  */
368 
369 pragma solidity ^0.4.11;
370 
371 
372 
373 
374 
375 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
376 
377     address public controller;
378     FlightDelayControllerInterface FD_CI;
379 
380     modifier onlyController() {
381         require(msg.sender == controller);
382         _;
383     }
384 
385     function setController(address _controller) internal returns (bool _result) {
386         controller = _controller;
387         FD_CI = FlightDelayControllerInterface(_controller);
388         _result = true;
389     }
390 
391     function destruct() public onlyController {
392         selfdestruct(controller);
393     }
394 
395     function setContracts() public onlyController {}
396 
397     function getContract(bytes32 _id) internal returns (address _addr) {
398         _addr = FD_CI.getContract(_id);
399     }
400 }
401 
402 // File: contracts/FlightDelayDatabaseInterface.sol
403 
404 /**
405  * FlightDelay with Oraclized Underwriting and Payout
406  *
407  * @description Database contract interface
408  * @copyright (c) 2017 etherisc GmbH
409  * @author Christoph Mussenbrock, Stephan Karpischek
410  */
411 
412 pragma solidity ^0.4.11;
413 
414 
415 
416 
417 contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {
418 
419     uint public MIN_DEPARTURE_LIM;
420 
421     uint public MAX_DEPARTURE_LIM;
422 
423     bytes32[] public validOrigins;
424 
425     bytes32[] public validDestinations;
426 
427     function countOrigins() public constant returns (uint256 _length);
428 
429     function getOriginByIndex(uint256 _i) public constant returns (bytes32 _origin);
430 
431     function countDestinations() public constant returns (uint256 _length);
432 
433     function getDestinationByIndex(uint256 _i) public constant returns (bytes32 _destination);
434 
435     function setAccessControl(address _contract, address _caller, uint8 _perm) public;
436 
437     function setAccessControl(
438         address _contract,
439         address _caller,
440         uint8 _perm,
441         bool _access
442     ) public;
443 
444     function getAccessControl(address _contract, address _caller, uint8 _perm) public returns (bool _allowed) ;
445 
446     function setLedger(uint8 _index, int _value) public;
447 
448     function getLedger(uint8 _index) public returns (int _value) ;
449 
450     function getCustomerPremium(uint _policyId) public returns (address _customer, uint _premium) ;
451 
452     function getPolicyData(uint _policyId) public returns (address _customer, uint _premium, uint _weight) ;
453 
454     function getPolicyState(uint _policyId) public returns (policyState _state) ;
455 
456     function getRiskId(uint _policyId) public returns (bytes32 _riskId);
457 
458     function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) public returns (uint _policyId) ;
459 
460     function setState(
461         uint _policyId,
462         policyState _state,
463         uint _stateTime,
464         bytes32 _stateMessage
465     ) public;
466 
467     function setWeight(uint _policyId, uint _weight, bytes _proof) public;
468 
469     function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout) public;
470 
471     function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes) public;
472 
473     function getRiskParameters(bytes32 _riskId)
474         public returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime) ;
475 
476     function getPremiumFactors(bytes32 _riskId)
477         public returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);
478 
479     function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)
480         public returns (bytes32 _riskId);
481 
482     function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier) public;
483 
484     function getOraclizeCallback(bytes32 _queryId)
485         public returns (uint _policyId, uint _oraclizeTime) ;
486 
487     function getOraclizePolicyId(bytes32 _queryId)
488         public returns (uint _policyId) ;
489 
490     function createOraclizeCallback(
491         bytes32 _queryId,
492         uint _policyId,
493         oraclizeState _oraclizeState,
494         uint _oraclizeTime
495     ) public;
496 
497     function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)
498         public returns (bool _result) ;
499 }
500 
501 // File: contracts/FlightDelayAccessController.sol
502 
503 /**
504  * FlightDelay with Oraclized Underwriting and Payout
505  *
506  * @description	Access controller
507  * @copyright (c) 2017 etherisc GmbH
508  * @author Christoph Mussenbrock
509  */
510 
511 pragma solidity ^0.4.11;
512 
513 
514 
515 
516 
517 
518 contract FlightDelayAccessController is FlightDelayControlledContract, FlightDelayConstants {
519 
520     FlightDelayDatabaseInterface FD_DB;
521 
522     modifier onlyEmergency() {
523         require(msg.sender == FD_CI.getContract('FD.Emergency'));
524         _;
525     }
526 
527     function FlightDelayAccessController(address _controller) public {
528         setController(_controller);
529     }
530 
531     function setContracts() public onlyController {
532         FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));
533     }
534 
535     function setPermissionById(uint8 _perm, bytes32 _id) public {
536         FD_DB.setAccessControl(msg.sender, FD_CI.getContract(_id), _perm);
537     }
538 
539     function fixPermission(address _target, address _accessor, uint8 _perm, bool _access) public onlyEmergency {
540         FD_DB.setAccessControl(
541             _target,
542             _accessor,
543             _perm,
544             _access
545         );
546 
547     }
548 
549     function setPermissionById(uint8 _perm, bytes32 _id, bool _access) public {
550         FD_DB.setAccessControl(
551             msg.sender,
552             FD_CI.getContract(_id),
553             _perm,
554             _access
555         );
556     }
557 
558     function setPermissionByAddress(uint8 _perm, address _addr) public {
559         FD_DB.setAccessControl(msg.sender, _addr, _perm);
560     }
561 
562     function setPermissionByAddress(uint8 _perm, address _addr, bool _access) public {
563         FD_DB.setAccessControl(
564             msg.sender,
565             _addr,
566             _perm,
567             _access
568         );
569     }
570 
571     function checkPermission(uint8 _perm, address _addr) public returns (bool _success) {
572 // --> debug-mode
573 //            // LogUint("_perm", _perm);
574 //            // LogAddress("_addr", _addr);
575 //            // LogAddress("msg.sender", msg.sender);
576 //            // LogBool("getAccessControl", FD_DB.getAccessControl(msg.sender, _addr, _perm));
577 // <-- debug-mode
578         _success = FD_DB.getAccessControl(msg.sender, _addr, _perm);
579     }
580 }