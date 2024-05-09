1 /**
2  * FlightDelay with Oraclized Underwriting and Payout
3  *
4  * @description Contract interface
5  * @copyright (c) 2017 etherisc GmbH
6  * @author Christoph Mussenbrock, Stephan Karpischek
7  */
8 
9 pragma solidity ^0.4.11;
10 
11 
12 contract FlightDelayControllerInterface {
13 
14     function isOwner(address _addr) returns (bool _isOwner);
15 
16     function selfRegister(bytes32 _id) returns (bool result);
17 
18     function getContract(bytes32 _id) returns (address _addr);
19 }
20 
21 contract FlightDelayDatabaseModel {
22 
23     // Ledger accounts.
24     enum Acc {
25         Premium,      // 0
26         RiskFund,     // 1
27         Payout,       // 2
28         Balance,      // 3
29         Reward,       // 4
30         OraclizeCosts // 5
31     }
32 
33     // policy Status Codes and meaning:
34     //
35     // 00 = Applied:	  the customer has payed a premium, but the oracle has
36     //					        not yet checked and confirmed.
37     //					        The customer can still revoke the policy.
38     // 01 = Accepted:	  the oracle has checked and confirmed.
39     //					        The customer can still revoke the policy.
40     // 02 = Revoked:	  The customer has revoked the policy.
41     //					        The premium minus cancellation fee is payed back to the
42     //					        customer by the oracle.
43     // 03 = PaidOut:	  The flight has ended with delay.
44     //					        The oracle has checked and payed out.
45     // 04 = Expired:	  The flight has endet with <15min. delay.
46     //					        No payout.
47     // 05 = Declined:	  The application was invalid.
48     //					        The premium minus cancellation fee is payed back to the
49     //					        customer by the oracle.
50     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
51     //					        for unknown reasons.
52     //					        The funds remain in the contracts RiskFund.
53 
54 
55     //                   00       01        02       03        04      05           06
56     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
57 
58     // oraclize callback types:
59     enum oraclizeState { ForUnderwriting, ForPayout }
60 
61     //               00   01   02   03
62     enum Currency { ETH, EUR, USD, GBP }
63 
64     // the policy structure: this structure keeps track of the individual parameters of a policy.
65     // typically customer address, premium and some status information.
66     struct Policy {
67         // 0 - the customer
68         address customer;
69 
70         // 1 - premium
71         uint premium;
72         // risk specific parameters:
73         // 2 - pointer to the risk in the risks mapping
74         bytes32 riskId;
75         // custom payout pattern
76         // in future versions, customer will be able to tamper with this array.
77         // to keep things simple, we have decided to hard-code the array for all policies.
78         // uint8[5] pattern;
79         // 3 - probability weight. this is the central parameter
80         uint weight;
81         // 4 - calculated Payout
82         uint calculatedPayout;
83         // 5 - actual Payout
84         uint actualPayout;
85 
86         // status fields:
87         // 6 - the state of the policy
88         policyState state;
89         // 7 - time of last state change
90         uint stateTime;
91         // 8 - state change message/reason
92         bytes32 stateMessage;
93         // 9 - TLSNotary Proof
94         bytes proof;
95         // 10 - Currency
96         Currency currency;
97         // 10 - External customer id
98         bytes32 customerExternalId;
99     }
100 
101     // the risk structure; this structure keeps track of the risk-
102     // specific parameters.
103     // several policies can share the same risk structure (typically
104     // some people flying with the same plane)
105     struct Risk {
106         // 0 - Airline Code + FlightNumber
107         bytes32 carrierFlightNumber;
108         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
109         bytes32 departureYearMonthDay;
110         // 2 - the inital arrival time
111         uint arrivalTime;
112         // 3 - the final delay in minutes
113         uint delayInMinutes;
114         // 4 - the determined delay category (0-5)
115         uint8 delay;
116         // 5 - we limit the cumulated weighted premium to avoid cluster risks
117         uint cumulatedWeightedPremium;
118         // 6 - max cumulated Payout for this risk
119         uint premiumMultiplier;
120     }
121 
122     // the oraclize callback structure: we use several oraclize calls.
123     // all oraclize calls will result in a common callback to __callback(...).
124     // to keep track of the different querys we have to introduce this struct.
125     struct OraclizeCallback {
126         // for which policy have we called?
127         uint policyId;
128         // for which purpose did we call? {ForUnderwrite | ForPayout}
129         oraclizeState oState;
130         // time
131         uint oraclizeTime;
132     }
133 
134     struct Customer {
135         bytes32 customerExternalId;
136         bool identityConfirmed;
137     }
138 }
139 
140 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
141 
142     address public controller;
143     FlightDelayControllerInterface FD_CI;
144 
145     modifier onlyController() {
146         require(msg.sender == controller);
147         _;
148     }
149 
150     function setController(address _controller) internal returns (bool _result) {
151         controller = _controller;
152         FD_CI = FlightDelayControllerInterface(_controller);
153         _result = true;
154     }
155 
156     function destruct() onlyController {
157         selfdestruct(controller);
158     }
159 
160     function setContracts() onlyController {}
161 
162     function getContract(bytes32 _id) internal returns (address _addr) {
163         _addr = FD_CI.getContract(_id);
164     }
165 }
166 
167 
168 contract FlightDelayConstants {
169 
170     /*
171     * General events
172     */
173 
174 // --> test-mode
175 //        event LogUint(string _message, uint _uint);
176 //        event LogUintEth(string _message, uint ethUint);
177 //        event LogUintTime(string _message, uint timeUint);
178 //        event LogInt(string _message, int _int);
179 //        event LogAddress(string _message, address _address);
180 //        event LogBytes32(string _message, bytes32 hexBytes32);
181 //        event LogBytes(string _message, bytes hexBytes);
182 //        event LogBytes32Str(string _message, bytes32 strBytes32);
183 //        event LogString(string _message, string _string);
184 //        event LogBool(string _message, bool _bool);
185 //        event Log(address);
186 // <-- test-mode
187 
188     event LogPolicyApplied(
189         uint _policyId,
190         address _customer,
191         bytes32 strCarrierFlightNumber,
192         uint ethPremium
193     );
194     event LogPolicyAccepted(
195         uint _policyId,
196         uint _statistics0,
197         uint _statistics1,
198         uint _statistics2,
199         uint _statistics3,
200         uint _statistics4,
201         uint _statistics5
202     );
203     event LogPolicyPaidOut(
204         uint _policyId,
205         uint ethAmount
206     );
207     event LogPolicyExpired(
208         uint _policyId
209     );
210     event LogPolicyDeclined(
211         uint _policyId,
212         bytes32 strReason
213     );
214     event LogPolicyManualPayout(
215         uint _policyId,
216         bytes32 strReason
217     );
218     event LogSendFunds(
219         address _recipient,
220         uint8 _from,
221         uint ethAmount
222     );
223     event LogReceiveFunds(
224         address _sender,
225         uint8 _to,
226         uint ethAmount
227     );
228     event LogSendFail(
229         uint _policyId,
230         bytes32 strReason
231     );
232     event LogOraclizeCall(
233         uint _policyId,
234         bytes32 hexQueryId,
235         string _oraclizeUrl,
236         uint256 _oraclizeTime
237     );
238     event LogOraclizeCallback(
239         uint _policyId,
240         bytes32 hexQueryId,
241         string _result,
242         bytes hexProof
243     );
244     event LogSetState(
245         uint _policyId,
246         uint8 _policyState,
247         uint _stateTime,
248         bytes32 _stateMessage
249     );
250     event LogExternal(
251         uint256 _policyId,
252         address _address,
253         bytes32 _externalId
254     );
255 
256     /*
257     * General constants
258     */
259 
260     // minimum observations for valid prediction
261     uint constant MIN_OBSERVATIONS = 10;
262     // minimum premium to cover costs
263     uint constant MIN_PREMIUM = 50 finney;
264     // maximum premium
265     uint constant MAX_PREMIUM = 1 ether;
266     // maximum payout
267     uint constant MAX_PAYOUT = 1100 finney;
268 
269     uint constant MIN_PREMIUM_EUR = 1500 wei;
270     uint constant MAX_PREMIUM_EUR = 29000 wei;
271     uint constant MAX_PAYOUT_EUR = 30000 wei;
272 
273     uint constant MIN_PREMIUM_USD = 1700 wei;
274     uint constant MAX_PREMIUM_USD = 34000 wei;
275     uint constant MAX_PAYOUT_USD = 35000 wei;
276 
277     uint constant MIN_PREMIUM_GBP = 1300 wei;
278     uint constant MAX_PREMIUM_GBP = 25000 wei;
279     uint constant MAX_PAYOUT_GBP = 270 wei;
280 
281     // maximum cumulated weighted premium per risk
282     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;
283     // 1 percent for DAO, 1 percent for maintainer
284     uint8 constant REWARD_PERCENT = 2;
285     // reserve for tail risks
286     uint8 constant RESERVE_PERCENT = 1;
287     // the weight pattern; in future versions this may become part of the policy struct.
288     // currently can't be constant because of compiler restrictions
289     // WEIGHT_PATTERN[0] is not used, just to be consistent
290     uint8[6] WEIGHT_PATTERN = [
291         0,
292         10,
293         20,
294         30,
295         50,
296         50
297     ];
298 
299 // --> prod-mode
300     // DEFINITIONS FOR ROPSTEN AND MAINNET
301     // minimum time before departure for applying
302     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
303     // check for delay after .. minutes after scheduled arrival
304     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
305 // <-- prod-mode
306 
307 // --> test-mode
308 //        // DEFINITIONS FOR LOCAL TESTNET
309 //        // minimum time before departure for applying
310 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
311 //        // check for delay after .. minutes after scheduled arrival
312 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
313 // <-- test-mode
314 
315     // maximum duration of flight
316     uint constant MAX_FLIGHT_DURATION = 2 days;
317     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
318     uint constant CONTRACT_DEAD_LINE = 1922396399;
319 
320     uint constant MIN_DEPARTURE_LIM = 1508198400;
321 
322     uint constant MAX_DEPARTURE_LIM = 1509840000;
323 
324     // gas Constants for oraclize
325     uint constant ORACLIZE_GAS = 1000000;
326 
327 
328     /*
329     * URLs and query strings for oraclize
330     */
331 
332 // --> prod-mode
333     // DEFINITIONS FOR ROPSTEN AND MAINNET
334     string constant ORACLIZE_RATINGS_BASE_URL =
335         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
336         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
337     string constant ORACLIZE_RATINGS_QUERY =
338         "?${[decrypt] <!--PUT ENCRYPTED_QUERY HERE--> }).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
339     string constant ORACLIZE_STATUS_BASE_URL =
340         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
341         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
342     string constant ORACLIZE_STATUS_QUERY =
343         // pattern:
344         "?${[decrypt] BO9eB+Q5EVeSEGUo+LcDHLdAzJ6RUtcLnddOO/IHLh0yYkzNhoZIND26/cz8yzXkxzJaiS4dGGkhaAKMiI8WxhJc3ZxVfB+cfHAcGcg8Kj4x/9WLlakqB3EPMYQrDWHONuyD1G9i0g0IVRcO/s7pqwK+LKDcxQFYgkMtpcrWBrgAre40lN/S}&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
345 
346 
347 // <-- prod-mode
348 
349 // --> test-mode
350 //        // DEFINITIONS FOR LOCAL TESTNET
351 //        string constant ORACLIZE_RATINGS_BASE_URL =
352 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
353 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
354 //        string constant ORACLIZE_RATINGS_QUERY =
355 //            // for testrpc:
356 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
357 //        string constant ORACLIZE_STATUS_BASE_URL =
358 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
359 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
360 //        string constant ORACLIZE_STATUS_QUERY =
361 //            // for testrpc:
362 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
363 // <-- test-mode
364 }
365 
366 contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {
367 
368     function setAccessControl(address _contract, address _caller, uint8 _perm);
369 
370     function setAccessControl(
371         address _contract,
372         address _caller,
373         uint8 _perm,
374         bool _access
375     );
376 
377     function getAccessControl(address _contract, address _caller, uint8 _perm) returns (bool _allowed);
378 
379     function setLedger(uint8 _index, int _value);
380 
381     function getLedger(uint8 _index) returns (int _value);
382 
383     function getCustomerPremium(uint _policyId) returns (address _customer, uint _premium);
384 
385     function getPolicyData(uint _policyId) returns (address _customer, uint _premium, uint _weight);
386 
387     function getPolicyState(uint _policyId) returns (policyState _state);
388 
389     function getRiskId(uint _policyId) returns (bytes32 _riskId);
390 
391     function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) returns (uint _policyId);
392 
393     function setState(
394         uint _policyId,
395         policyState _state,
396         uint _stateTime,
397         bytes32 _stateMessage
398     );
399 
400     function setWeight(uint _policyId, uint _weight, bytes _proof);
401 
402     function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout);
403 
404     function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes);
405 
406     function getRiskParameters(bytes32 _riskId)
407         returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime);
408 
409     function getPremiumFactors(bytes32 _riskId)
410         returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);
411 
412     function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)
413         returns (bytes32 _riskId);
414 
415     function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier);
416 
417     function getOraclizeCallback(bytes32 _queryId)
418         returns (uint _policyId, uint _arrivalTime);
419 
420     function getOraclizePolicyId(bytes32 _queryId)
421     returns (uint _policyId);
422 
423     function createOraclizeCallback(
424         bytes32 _queryId,
425         uint _policyId,
426         oraclizeState _oraclizeState,
427         uint _oraclizeTime
428     );
429 
430     function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)
431         returns (bool _result);
432 }
433 
434 contract FlightDelayAccessControllerInterface {
435 
436     function setPermissionById(uint8 _perm, bytes32 _id);
437 
438     function setPermissionById(uint8 _perm, bytes32 _id, bool _access);
439 
440     function setPermissionByAddress(uint8 _perm, address _addr);
441 
442     function setPermissionByAddress(uint8 _perm, address _addr, bool _access);
443 
444     function checkPermission(uint8 _perm, address _addr) returns (bool _success);
445 }
446 
447 contract FlightDelayLedgerInterface is FlightDelayDatabaseModel {
448 
449     function receiveFunds(Acc _to) payable;
450 
451     function sendFunds(address _recipient, Acc _from, uint _amount) returns (bool _success);
452 
453     function bookkeeping(Acc _from, Acc _to, uint amount);
454 }
455 
456 
457 contract FlightDelayPayoutInterface {
458 
459     function schedulePayoutOraclizeCall(uint _policyId, bytes32 _riskId, uint _offset);
460 }
461 contract OraclizeI {
462     address public cbAddress;
463     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
464     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
465     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
466     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
467     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
468     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
469     function getPrice(string _datasource) returns (uint _dsprice);
470     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
471     function useCoupon(string _coupon);
472     function setProofType(byte _proofType);
473     function setConfig(bytes32 _config);
474     function setCustomGasPrice(uint _gasPrice);
475     function randomDS_getSessionPubKeyHash() returns(bytes32);
476 }
477 contract OraclizeAddrResolverI {
478     function getAddress() returns (address _addr);
479 }
480 contract usingOraclize {
481     uint constant day = 60*60*24;
482     uint constant week = 60*60*24*7;
483     uint constant month = 60*60*24*30;
484     byte constant proofType_NONE = 0x00;
485     byte constant proofType_TLSNotary = 0x10;
486     byte constant proofType_Android = 0x20;
487     byte constant proofType_Ledger = 0x30;
488     byte constant proofType_Native = 0xF0;
489     byte constant proofStorage_IPFS = 0x01;
490     uint8 constant networkID_auto = 0;
491     uint8 constant networkID_mainnet = 1;
492     uint8 constant networkID_testnet = 2;
493     uint8 constant networkID_morden = 2;
494     uint8 constant networkID_consensys = 161;
495 
496     OraclizeAddrResolverI OAR;
497 
498     OraclizeI oraclize;
499     modifier oraclizeAPI {
500         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
501         oraclize = OraclizeI(OAR.getAddress());
502         _;
503     }
504     modifier coupon(string code){
505         oraclize = OraclizeI(OAR.getAddress());
506         oraclize.useCoupon(code);
507         _;
508     }
509 
510     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
511         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
512             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
513             oraclize_setNetworkName("eth_mainnet");
514             return true;
515         }
516         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
517             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
518             oraclize_setNetworkName("eth_ropsten3");
519             return true;
520         }
521         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
522             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
523             oraclize_setNetworkName("eth_kovan");
524             return true;
525         }
526         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
527             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
528             oraclize_setNetworkName("eth_rinkeby");
529             return true;
530         }
531         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
532             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
533             return true;
534         }
535         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
536             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
537             return true;
538         }
539         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
540             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
541             return true;
542         }
543         return false;
544     }
545 
546     function __callback(bytes32 myid, string result) {
547         __callback(myid, result, new bytes(0));
548     }
549     function __callback(bytes32 myid, string result, bytes proof) {
550     }
551 
552     function oraclize_useCoupon(string code) oraclizeAPI internal {
553         oraclize.useCoupon(code);
554     }
555 
556     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
557         return oraclize.getPrice(datasource);
558     }
559 
560     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
561         return oraclize.getPrice(datasource, gaslimit);
562     }
563 
564     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
565         uint price = oraclize.getPrice(datasource);
566         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
567         return oraclize.query.value(price)(0, datasource, arg);
568     }
569     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
570         uint price = oraclize.getPrice(datasource);
571         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
572         return oraclize.query.value(price)(timestamp, datasource, arg);
573     }
574     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
575         uint price = oraclize.getPrice(datasource, gaslimit);
576         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
577         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
578     }
579     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
580         uint price = oraclize.getPrice(datasource, gaslimit);
581         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
582         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
583     }
584     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
585         uint price = oraclize.getPrice(datasource);
586         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
587         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
588     }
589     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
590         uint price = oraclize.getPrice(datasource);
591         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
592         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
593     }
594     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
595         uint price = oraclize.getPrice(datasource, gaslimit);
596         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
597         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
598     }
599     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
600         uint price = oraclize.getPrice(datasource, gaslimit);
601         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
602         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
603     }
604     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
605         uint price = oraclize.getPrice(datasource);
606         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
607         bytes memory args = stra2cbor(argN);
608         return oraclize.queryN.value(price)(0, datasource, args);
609     }
610     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
611         uint price = oraclize.getPrice(datasource);
612         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
613         bytes memory args = stra2cbor(argN);
614         return oraclize.queryN.value(price)(timestamp, datasource, args);
615     }
616     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
617         uint price = oraclize.getPrice(datasource, gaslimit);
618         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
619         bytes memory args = stra2cbor(argN);
620         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
621     }
622     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
623         uint price = oraclize.getPrice(datasource, gaslimit);
624         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
625         bytes memory args = stra2cbor(argN);
626         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
627     }
628     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
629         string[] memory dynargs = new string[](1);
630         dynargs[0] = args[0];
631         return oraclize_query(datasource, dynargs);
632     }
633     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
634         string[] memory dynargs = new string[](1);
635         dynargs[0] = args[0];
636         return oraclize_query(timestamp, datasource, dynargs);
637     }
638     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
639         string[] memory dynargs = new string[](1);
640         dynargs[0] = args[0];
641         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
642     }
643     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
644         string[] memory dynargs = new string[](1);
645         dynargs[0] = args[0];
646         return oraclize_query(datasource, dynargs, gaslimit);
647     }
648 
649     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
650         string[] memory dynargs = new string[](2);
651         dynargs[0] = args[0];
652         dynargs[1] = args[1];
653         return oraclize_query(datasource, dynargs);
654     }
655     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
656         string[] memory dynargs = new string[](2);
657         dynargs[0] = args[0];
658         dynargs[1] = args[1];
659         return oraclize_query(timestamp, datasource, dynargs);
660     }
661     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
662         string[] memory dynargs = new string[](2);
663         dynargs[0] = args[0];
664         dynargs[1] = args[1];
665         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
666     }
667     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
668         string[] memory dynargs = new string[](2);
669         dynargs[0] = args[0];
670         dynargs[1] = args[1];
671         return oraclize_query(datasource, dynargs, gaslimit);
672     }
673     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
674         string[] memory dynargs = new string[](3);
675         dynargs[0] = args[0];
676         dynargs[1] = args[1];
677         dynargs[2] = args[2];
678         return oraclize_query(datasource, dynargs);
679     }
680     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
681         string[] memory dynargs = new string[](3);
682         dynargs[0] = args[0];
683         dynargs[1] = args[1];
684         dynargs[2] = args[2];
685         return oraclize_query(timestamp, datasource, dynargs);
686     }
687     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
688         string[] memory dynargs = new string[](3);
689         dynargs[0] = args[0];
690         dynargs[1] = args[1];
691         dynargs[2] = args[2];
692         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
693     }
694     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
695         string[] memory dynargs = new string[](3);
696         dynargs[0] = args[0];
697         dynargs[1] = args[1];
698         dynargs[2] = args[2];
699         return oraclize_query(datasource, dynargs, gaslimit);
700     }
701 
702     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
703         string[] memory dynargs = new string[](4);
704         dynargs[0] = args[0];
705         dynargs[1] = args[1];
706         dynargs[2] = args[2];
707         dynargs[3] = args[3];
708         return oraclize_query(datasource, dynargs);
709     }
710     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
711         string[] memory dynargs = new string[](4);
712         dynargs[0] = args[0];
713         dynargs[1] = args[1];
714         dynargs[2] = args[2];
715         dynargs[3] = args[3];
716         return oraclize_query(timestamp, datasource, dynargs);
717     }
718     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
719         string[] memory dynargs = new string[](4);
720         dynargs[0] = args[0];
721         dynargs[1] = args[1];
722         dynargs[2] = args[2];
723         dynargs[3] = args[3];
724         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
725     }
726     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
727         string[] memory dynargs = new string[](4);
728         dynargs[0] = args[0];
729         dynargs[1] = args[1];
730         dynargs[2] = args[2];
731         dynargs[3] = args[3];
732         return oraclize_query(datasource, dynargs, gaslimit);
733     }
734     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
735         string[] memory dynargs = new string[](5);
736         dynargs[0] = args[0];
737         dynargs[1] = args[1];
738         dynargs[2] = args[2];
739         dynargs[3] = args[3];
740         dynargs[4] = args[4];
741         return oraclize_query(datasource, dynargs);
742     }
743     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
744         string[] memory dynargs = new string[](5);
745         dynargs[0] = args[0];
746         dynargs[1] = args[1];
747         dynargs[2] = args[2];
748         dynargs[3] = args[3];
749         dynargs[4] = args[4];
750         return oraclize_query(timestamp, datasource, dynargs);
751     }
752     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
753         string[] memory dynargs = new string[](5);
754         dynargs[0] = args[0];
755         dynargs[1] = args[1];
756         dynargs[2] = args[2];
757         dynargs[3] = args[3];
758         dynargs[4] = args[4];
759         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
760     }
761     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
762         string[] memory dynargs = new string[](5);
763         dynargs[0] = args[0];
764         dynargs[1] = args[1];
765         dynargs[2] = args[2];
766         dynargs[3] = args[3];
767         dynargs[4] = args[4];
768         return oraclize_query(datasource, dynargs, gaslimit);
769     }
770     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
771         uint price = oraclize.getPrice(datasource);
772         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
773         bytes memory args = ba2cbor(argN);
774         return oraclize.queryN.value(price)(0, datasource, args);
775     }
776     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
777         uint price = oraclize.getPrice(datasource);
778         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
779         bytes memory args = ba2cbor(argN);
780         return oraclize.queryN.value(price)(timestamp, datasource, args);
781     }
782     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
783         uint price = oraclize.getPrice(datasource, gaslimit);
784         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
785         bytes memory args = ba2cbor(argN);
786         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
787     }
788     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
789         uint price = oraclize.getPrice(datasource, gaslimit);
790         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
791         bytes memory args = ba2cbor(argN);
792         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
793     }
794     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
795         bytes[] memory dynargs = new bytes[](1);
796         dynargs[0] = args[0];
797         return oraclize_query(datasource, dynargs);
798     }
799     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
800         bytes[] memory dynargs = new bytes[](1);
801         dynargs[0] = args[0];
802         return oraclize_query(timestamp, datasource, dynargs);
803     }
804     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
805         bytes[] memory dynargs = new bytes[](1);
806         dynargs[0] = args[0];
807         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
808     }
809     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
810         bytes[] memory dynargs = new bytes[](1);
811         dynargs[0] = args[0];
812         return oraclize_query(datasource, dynargs, gaslimit);
813     }
814 
815     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
816         bytes[] memory dynargs = new bytes[](2);
817         dynargs[0] = args[0];
818         dynargs[1] = args[1];
819         return oraclize_query(datasource, dynargs);
820     }
821     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
822         bytes[] memory dynargs = new bytes[](2);
823         dynargs[0] = args[0];
824         dynargs[1] = args[1];
825         return oraclize_query(timestamp, datasource, dynargs);
826     }
827     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
828         bytes[] memory dynargs = new bytes[](2);
829         dynargs[0] = args[0];
830         dynargs[1] = args[1];
831         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
832     }
833     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
834         bytes[] memory dynargs = new bytes[](2);
835         dynargs[0] = args[0];
836         dynargs[1] = args[1];
837         return oraclize_query(datasource, dynargs, gaslimit);
838     }
839     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
840         bytes[] memory dynargs = new bytes[](3);
841         dynargs[0] = args[0];
842         dynargs[1] = args[1];
843         dynargs[2] = args[2];
844         return oraclize_query(datasource, dynargs);
845     }
846     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
847         bytes[] memory dynargs = new bytes[](3);
848         dynargs[0] = args[0];
849         dynargs[1] = args[1];
850         dynargs[2] = args[2];
851         return oraclize_query(timestamp, datasource, dynargs);
852     }
853     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
854         bytes[] memory dynargs = new bytes[](3);
855         dynargs[0] = args[0];
856         dynargs[1] = args[1];
857         dynargs[2] = args[2];
858         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
859     }
860     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
861         bytes[] memory dynargs = new bytes[](3);
862         dynargs[0] = args[0];
863         dynargs[1] = args[1];
864         dynargs[2] = args[2];
865         return oraclize_query(datasource, dynargs, gaslimit);
866     }
867 
868     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
869         bytes[] memory dynargs = new bytes[](4);
870         dynargs[0] = args[0];
871         dynargs[1] = args[1];
872         dynargs[2] = args[2];
873         dynargs[3] = args[3];
874         return oraclize_query(datasource, dynargs);
875     }
876     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
877         bytes[] memory dynargs = new bytes[](4);
878         dynargs[0] = args[0];
879         dynargs[1] = args[1];
880         dynargs[2] = args[2];
881         dynargs[3] = args[3];
882         return oraclize_query(timestamp, datasource, dynargs);
883     }
884     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
885         bytes[] memory dynargs = new bytes[](4);
886         dynargs[0] = args[0];
887         dynargs[1] = args[1];
888         dynargs[2] = args[2];
889         dynargs[3] = args[3];
890         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
891     }
892     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
893         bytes[] memory dynargs = new bytes[](4);
894         dynargs[0] = args[0];
895         dynargs[1] = args[1];
896         dynargs[2] = args[2];
897         dynargs[3] = args[3];
898         return oraclize_query(datasource, dynargs, gaslimit);
899     }
900     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
901         bytes[] memory dynargs = new bytes[](5);
902         dynargs[0] = args[0];
903         dynargs[1] = args[1];
904         dynargs[2] = args[2];
905         dynargs[3] = args[3];
906         dynargs[4] = args[4];
907         return oraclize_query(datasource, dynargs);
908     }
909     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
910         bytes[] memory dynargs = new bytes[](5);
911         dynargs[0] = args[0];
912         dynargs[1] = args[1];
913         dynargs[2] = args[2];
914         dynargs[3] = args[3];
915         dynargs[4] = args[4];
916         return oraclize_query(timestamp, datasource, dynargs);
917     }
918     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
919         bytes[] memory dynargs = new bytes[](5);
920         dynargs[0] = args[0];
921         dynargs[1] = args[1];
922         dynargs[2] = args[2];
923         dynargs[3] = args[3];
924         dynargs[4] = args[4];
925         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
926     }
927     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
928         bytes[] memory dynargs = new bytes[](5);
929         dynargs[0] = args[0];
930         dynargs[1] = args[1];
931         dynargs[2] = args[2];
932         dynargs[3] = args[3];
933         dynargs[4] = args[4];
934         return oraclize_query(datasource, dynargs, gaslimit);
935     }
936 
937     function oraclize_cbAddress() oraclizeAPI internal returns (address){
938         return oraclize.cbAddress();
939     }
940     function oraclize_setProof(byte proofP) oraclizeAPI internal {
941         return oraclize.setProofType(proofP);
942     }
943     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
944         return oraclize.setCustomGasPrice(gasPrice);
945     }
946     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
947         return oraclize.setConfig(config);
948     }
949 
950     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
951         return oraclize.randomDS_getSessionPubKeyHash();
952     }
953 
954     function getCodeSize(address _addr) constant internal returns(uint _size) {
955         assembly {
956             _size := extcodesize(_addr)
957         }
958     }
959 
960     function parseAddr(string _a) internal returns (address){
961         bytes memory tmp = bytes(_a);
962         uint160 iaddr = 0;
963         uint160 b1;
964         uint160 b2;
965         for (uint i=2; i<2+2*20; i+=2){
966             iaddr *= 256;
967             b1 = uint160(tmp[i]);
968             b2 = uint160(tmp[i+1]);
969             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
970             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
971             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
972             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
973             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
974             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
975             iaddr += (b1*16+b2);
976         }
977         return address(iaddr);
978     }
979 
980     function strCompare(string _a, string _b) internal returns (int) {
981         bytes memory a = bytes(_a);
982         bytes memory b = bytes(_b);
983         uint minLength = a.length;
984         if (b.length < minLength) minLength = b.length;
985         for (uint i = 0; i < minLength; i ++)
986             if (a[i] < b[i])
987                 return -1;
988             else if (a[i] > b[i])
989                 return 1;
990         if (a.length < b.length)
991             return -1;
992         else if (a.length > b.length)
993             return 1;
994         else
995             return 0;
996     }
997 
998     function indexOf(string _haystack, string _needle) internal returns (int) {
999         bytes memory h = bytes(_haystack);
1000         bytes memory n = bytes(_needle);
1001         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1002             return -1;
1003         else if(h.length > (2**128 -1))
1004             return -1;
1005         else
1006         {
1007             uint subindex = 0;
1008             for (uint i = 0; i < h.length; i ++)
1009             {
1010                 if (h[i] == n[0])
1011                 {
1012                     subindex = 1;
1013                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1014                     {
1015                         subindex++;
1016                     }
1017                     if(subindex == n.length)
1018                         return int(i);
1019                 }
1020             }
1021             return -1;
1022         }
1023     }
1024 
1025     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1026         bytes memory _ba = bytes(_a);
1027         bytes memory _bb = bytes(_b);
1028         bytes memory _bc = bytes(_c);
1029         bytes memory _bd = bytes(_d);
1030         bytes memory _be = bytes(_e);
1031         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1032         bytes memory babcde = bytes(abcde);
1033         uint k = 0;
1034         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1035         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1036         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1037         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1038         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1039         return string(babcde);
1040     }
1041 
1042     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1043         return strConcat(_a, _b, _c, _d, "");
1044     }
1045 
1046     function strConcat(string _a, string _b, string _c) internal returns (string) {
1047         return strConcat(_a, _b, _c, "", "");
1048     }
1049 
1050     function strConcat(string _a, string _b) internal returns (string) {
1051         return strConcat(_a, _b, "", "", "");
1052     }
1053 
1054     // parseInt
1055     function parseInt(string _a) internal returns (uint) {
1056         return parseInt(_a, 0);
1057     }
1058 
1059     // parseInt(parseFloat*10^_b)
1060     function parseInt(string _a, uint _b) internal returns (uint) {
1061         bytes memory bresult = bytes(_a);
1062         uint mint = 0;
1063         bool decimals = false;
1064         for (uint i=0; i<bresult.length; i++){
1065             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1066                 if (decimals){
1067                    if (_b == 0) break;
1068                     else _b--;
1069                 }
1070                 mint *= 10;
1071                 mint += uint(bresult[i]) - 48;
1072             } else if (bresult[i] == 46) decimals = true;
1073         }
1074         if (_b > 0) mint *= 10**_b;
1075         return mint;
1076     }
1077 
1078     function uint2str(uint i) internal returns (string){
1079         if (i == 0) return "0";
1080         uint j = i;
1081         uint len;
1082         while (j != 0){
1083             len++;
1084             j /= 10;
1085         }
1086         bytes memory bstr = new bytes(len);
1087         uint k = len - 1;
1088         while (i != 0){
1089             bstr[k--] = byte(48 + i % 10);
1090             i /= 10;
1091         }
1092         return string(bstr);
1093     }
1094 
1095     function stra2cbor(string[] arr) internal returns (bytes) {
1096             uint arrlen = arr.length;
1097 
1098             // get correct cbor output length
1099             uint outputlen = 0;
1100             bytes[] memory elemArray = new bytes[](arrlen);
1101             for (uint i = 0; i < arrlen; i++) {
1102                 elemArray[i] = (bytes(arr[i]));
1103                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1104             }
1105             uint ctr = 0;
1106             uint cborlen = arrlen + 0x80;
1107             outputlen += byte(cborlen).length;
1108             bytes memory res = new bytes(outputlen);
1109 
1110             while (byte(cborlen).length > ctr) {
1111                 res[ctr] = byte(cborlen)[ctr];
1112                 ctr++;
1113             }
1114             for (i = 0; i < arrlen; i++) {
1115                 res[ctr] = 0x5F;
1116                 ctr++;
1117                 for (uint x = 0; x < elemArray[i].length; x++) {
1118                     // if there's a bug with larger strings, this may be the culprit
1119                     if (x % 23 == 0) {
1120                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1121                         elemcborlen += 0x40;
1122                         uint lctr = ctr;
1123                         while (byte(elemcborlen).length > ctr - lctr) {
1124                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1125                             ctr++;
1126                         }
1127                     }
1128                     res[ctr] = elemArray[i][x];
1129                     ctr++;
1130                 }
1131                 res[ctr] = 0xFF;
1132                 ctr++;
1133             }
1134             return res;
1135         }
1136 
1137     function ba2cbor(bytes[] arr) internal returns (bytes) {
1138             uint arrlen = arr.length;
1139 
1140             // get correct cbor output length
1141             uint outputlen = 0;
1142             bytes[] memory elemArray = new bytes[](arrlen);
1143             for (uint i = 0; i < arrlen; i++) {
1144                 elemArray[i] = (bytes(arr[i]));
1145                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1146             }
1147             uint ctr = 0;
1148             uint cborlen = arrlen + 0x80;
1149             outputlen += byte(cborlen).length;
1150             bytes memory res = new bytes(outputlen);
1151 
1152             while (byte(cborlen).length > ctr) {
1153                 res[ctr] = byte(cborlen)[ctr];
1154                 ctr++;
1155             }
1156             for (i = 0; i < arrlen; i++) {
1157                 res[ctr] = 0x5F;
1158                 ctr++;
1159                 for (uint x = 0; x < elemArray[i].length; x++) {
1160                     // if there's a bug with larger strings, this may be the culprit
1161                     if (x % 23 == 0) {
1162                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1163                         elemcborlen += 0x40;
1164                         uint lctr = ctr;
1165                         while (byte(elemcborlen).length > ctr - lctr) {
1166                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1167                             ctr++;
1168                         }
1169                     }
1170                     res[ctr] = elemArray[i][x];
1171                     ctr++;
1172                 }
1173                 res[ctr] = 0xFF;
1174                 ctr++;
1175             }
1176             return res;
1177         }
1178 
1179 
1180     string oraclize_network_name;
1181     function oraclize_setNetworkName(string _network_name) internal {
1182         oraclize_network_name = _network_name;
1183     }
1184 
1185     function oraclize_getNetworkName() internal returns (string) {
1186         return oraclize_network_name;
1187     }
1188 
1189     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1190         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1191         bytes memory nbytes = new bytes(1);
1192         nbytes[0] = byte(_nbytes);
1193         bytes memory unonce = new bytes(32);
1194         bytes memory sessionKeyHash = new bytes(32);
1195         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1196         assembly {
1197             mstore(unonce, 0x20)
1198             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1199             mstore(sessionKeyHash, 0x20)
1200             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1201         }
1202         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
1203         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
1204         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
1205         return queryId;
1206     }
1207 
1208     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1209         oraclize_randomDS_args[queryId] = commitment;
1210     }
1211 
1212     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1213     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1214 
1215     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1216         bool sigok;
1217         address signer;
1218 
1219         bytes32 sigr;
1220         bytes32 sigs;
1221 
1222         bytes memory sigr_ = new bytes(32);
1223         uint offset = 4+(uint(dersig[3]) - 0x20);
1224         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1225         bytes memory sigs_ = new bytes(32);
1226         offset += 32 + 2;
1227         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1228 
1229         assembly {
1230             sigr := mload(add(sigr_, 32))
1231             sigs := mload(add(sigs_, 32))
1232         }
1233 
1234 
1235         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1236         if (address(sha3(pubkey)) == signer) return true;
1237         else {
1238             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1239             return (address(sha3(pubkey)) == signer);
1240         }
1241     }
1242 
1243     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1244         bool sigok;
1245 
1246         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1247         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1248         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1249 
1250         bytes memory appkey1_pubkey = new bytes(64);
1251         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1252 
1253         bytes memory tosign2 = new bytes(1+65+32);
1254         tosign2[0] = 1; //role
1255         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1256         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1257         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1258         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1259 
1260         if (sigok == false) return false;
1261 
1262 
1263         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1264         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1265 
1266         bytes memory tosign3 = new bytes(1+65);
1267         tosign3[0] = 0xFE;
1268         copyBytes(proof, 3, 65, tosign3, 1);
1269 
1270         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1271         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1272 
1273         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1274 
1275         return sigok;
1276     }
1277 
1278     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1279         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1280         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1281 
1282         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1283         if (proofVerified == false) throw;
1284 
1285         _;
1286     }
1287 
1288     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1289         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1290         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1291 
1292         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1293         if (proofVerified == false) return 2;
1294 
1295         return 0;
1296     }
1297 
1298     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
1299         bool match_ = true;
1300 
1301         for (var i=0; i<prefix.length; i++){
1302             if (content[i] != prefix[i]) match_ = false;
1303         }
1304 
1305         return match_;
1306     }
1307 
1308     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1309         bool checkok;
1310 
1311 
1312         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1313         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1314         bytes memory keyhash = new bytes(32);
1315         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1316         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
1317         if (checkok == false) return false;
1318 
1319         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1320         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1321 
1322 
1323         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1324         checkok = matchBytes32Prefix(sha256(sig1), result);
1325         if (checkok == false) return false;
1326 
1327 
1328         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1329         // This is to verify that the computed args match with the ones specified in the query.
1330         bytes memory commitmentSlice1 = new bytes(8+1+32);
1331         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1332 
1333         bytes memory sessionPubkey = new bytes(64);
1334         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1335         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1336 
1337         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1338         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1339             delete oraclize_randomDS_args[queryId];
1340         } else return false;
1341 
1342 
1343         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1344         bytes memory tosign1 = new bytes(32+8+1+32);
1345         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1346         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
1347         if (checkok == false) return false;
1348 
1349         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1350         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1351             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1352         }
1353 
1354         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1355     }
1356 
1357 
1358     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1359     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1360         uint minLength = length + toOffset;
1361 
1362         if (to.length < minLength) {
1363             // Buffer too small
1364             throw; // Should be a better way?
1365         }
1366 
1367         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1368         uint i = 32 + fromOffset;
1369         uint j = 32 + toOffset;
1370 
1371         while (i < (32 + fromOffset + length)) {
1372             assembly {
1373                 let tmp := mload(add(from, i))
1374                 mstore(add(to, j), tmp)
1375             }
1376             i += 32;
1377             j += 32;
1378         }
1379 
1380         return to;
1381     }
1382 
1383     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1384     // Duplicate Solidity's ecrecover, but catching the CALL return value
1385     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1386         // We do our own memory management here. Solidity uses memory offset
1387         // 0x40 to store the current end of memory. We write past it (as
1388         // writes are memory extensions), but don't update the offset so
1389         // Solidity will reuse it. The memory used here is only needed for
1390         // this context.
1391 
1392         // FIXME: inline assembly can't access return values
1393         bool ret;
1394         address addr;
1395 
1396         assembly {
1397             let size := mload(0x40)
1398             mstore(size, hash)
1399             mstore(add(size, 32), v)
1400             mstore(add(size, 64), r)
1401             mstore(add(size, 96), s)
1402 
1403             // NOTE: we can reuse the request memory because we deal with
1404             //       the return code
1405             ret := call(3000, 1, 0, size, 128, size, 32)
1406             addr := mload(size)
1407         }
1408 
1409         return (ret, addr);
1410     }
1411 
1412     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1413     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1414         bytes32 r;
1415         bytes32 s;
1416         uint8 v;
1417 
1418         if (sig.length != 65)
1419           return (false, 0);
1420 
1421         // The signature format is a compact form of:
1422         //   {bytes32 r}{bytes32 s}{uint8 v}
1423         // Compact means, uint8 is not padded to 32 bytes.
1424         assembly {
1425             r := mload(add(sig, 32))
1426             s := mload(add(sig, 64))
1427 
1428             // Here we are loading the last 32 bytes. We exploit the fact that
1429             // 'mload' will pad with zeroes if we overread.
1430             // There is no 'mload8' to do this, but that would be nicer.
1431             v := byte(0, mload(add(sig, 96)))
1432 
1433             // Alternative solution:
1434             // 'byte' is not working due to the Solidity parser, so lets
1435             // use the second best option, 'and'
1436             // v := and(mload(add(sig, 65)), 255)
1437         }
1438 
1439         // albeit non-transactional signatures are not specified by the YP, one would expect it
1440         // to match the YP range of [27, 28]
1441         //
1442         // geth uses [0, 1] and some clients have followed. This might change, see:
1443         //  https://github.com/ethereum/go-ethereum/issues/2053
1444         if (v < 27)
1445           v += 27;
1446 
1447         if (v != 27 && v != 28)
1448             return (false, 0);
1449 
1450         return safer_ecrecover(hash, v, r, s);
1451     }
1452 
1453 }
1454 // </ORACLIZE_API>
1455 
1456 contract FlightDelayOraclizeInterface is usingOraclize {
1457 
1458     modifier onlyOraclizeOr (address _emergency) {
1459 // --> prod-mode
1460         require(msg.sender == oraclize_cbAddress() || msg.sender == _emergency);
1461 // <-- prod-mode
1462         _;
1463     }
1464 }
1465 
1466 contract ConvertLib {
1467 
1468     // .. since beginning of the year
1469     uint16[12] days_since = [
1470         11,
1471         42,
1472         70,
1473         101,
1474         131,
1475         162,
1476         192,
1477         223,
1478         254,
1479         284,
1480         315,
1481         345
1482     ];
1483 
1484     function b32toString(bytes32 x) internal returns (string) {
1485         // gas usage: about 1K gas per char.
1486         bytes memory bytesString = new bytes(32);
1487         uint charCount = 0;
1488 
1489         for (uint j = 0; j < 32; j++) {
1490             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
1491             if (char != 0) {
1492                 bytesString[charCount] = char;
1493                 charCount++;
1494             }
1495         }
1496 
1497         bytes memory bytesStringTrimmed = new bytes(charCount);
1498 
1499         for (j = 0; j < charCount; j++) {
1500             bytesStringTrimmed[j] = bytesString[j];
1501         }
1502 
1503         return string(bytesStringTrimmed);
1504     }
1505 
1506     function b32toHexString(bytes32 x) returns (string) {
1507         bytes memory b = new bytes(64);
1508         for (uint i = 0; i < 32; i++) {
1509             uint8 by = uint8(uint(x) / (2**(8*(31 - i))));
1510             uint8 high = by/16;
1511             uint8 low = by - 16*high;
1512             if (high > 9) {
1513                 high += 39;
1514             }
1515             if (low > 9) {
1516                 low += 39;
1517             }
1518             b[2*i] = byte(high+48);
1519             b[2*i+1] = byte(low+48);
1520         }
1521 
1522         return string(b);
1523     }
1524 
1525     function parseInt(string _a) internal returns (uint) {
1526         return parseInt(_a, 0);
1527     }
1528 
1529     // parseInt(parseFloat*10^_b)
1530     function parseInt(string _a, uint _b) internal returns (uint) {
1531         bytes memory bresult = bytes(_a);
1532         uint mint = 0;
1533         bool decimals = false;
1534         for (uint i = 0; i<bresult.length; i++) {
1535             if ((bresult[i] >= 48)&&(bresult[i] <= 57)) {
1536                 if (decimals) {
1537                     if (_b == 0) {
1538                         break;
1539                     } else {
1540                         _b--;
1541                     }
1542                 }
1543                 mint *= 10;
1544                 mint += uint(bresult[i]) - 48;
1545             } else if (bresult[i] == 46) {
1546                 decimals = true;
1547             }
1548         }
1549         if (_b > 0) {
1550             mint *= 10**_b;
1551         }
1552         return mint;
1553     }
1554 
1555     // the following function yields correct results in the time between 1.3.2016 and 28.02.2020,
1556     // so within the validity of the contract its correct.
1557     function toUnixtime(bytes32 _dayMonthYear) constant returns (uint unixtime) {
1558         // _day_month_year = /dep/2016/09/10
1559         bytes memory bDmy = bytes(b32toString(_dayMonthYear));
1560         bytes memory temp2 = bytes(new string(2));
1561         bytes memory temp4 = bytes(new string(4));
1562 
1563         temp4[0] = bDmy[5];
1564         temp4[1] = bDmy[6];
1565         temp4[2] = bDmy[7];
1566         temp4[3] = bDmy[8];
1567         uint year = parseInt(string(temp4));
1568 
1569         temp2[0] = bDmy[10];
1570         temp2[1] = bDmy[11];
1571         uint month = parseInt(string(temp2));
1572 
1573         temp2[0] = bDmy[13];
1574         temp2[1] = bDmy[14];
1575         uint day = parseInt(string(temp2));
1576 
1577         unixtime = ((year - 1970) * 365 + days_since[month-1] + day) * 86400;
1578     }
1579 }
1580 
1581 library strings {
1582     struct slice {
1583         uint _len;
1584         uint _ptr;
1585     }
1586 
1587     function memcpy(uint dest, uint src, uint len) private {
1588         // Copy word-length chunks while possible
1589         for(; len >= 32; len -= 32) {
1590             assembly {
1591                 mstore(dest, mload(src))
1592             }
1593             dest += 32;
1594             src += 32;
1595         }
1596 
1597         // Copy remaining bytes
1598         uint mask = 256 ** (32 - len) - 1;
1599         assembly {
1600             let srcpart := and(mload(src), not(mask))
1601             let destpart := and(mload(dest), mask)
1602             mstore(dest, or(destpart, srcpart))
1603         }
1604     }
1605 
1606     /*
1607      * @dev Returns a slice containing the entire string.
1608      * @param self The string to make a slice from.
1609      * @return A newly allocated slice containing the entire string.
1610      */
1611     function toSlice(string self) internal returns (slice) {
1612         uint ptr;
1613         assembly {
1614             ptr := add(self, 0x20)
1615         }
1616         return slice(bytes(self).length, ptr);
1617     }
1618 
1619     /*
1620      * @dev Returns the length of a null-terminated bytes32 string.
1621      * @param self The value to find the length of.
1622      * @return The length of the string, from 0 to 32.
1623      */
1624     function len(bytes32 self) internal returns (uint) {
1625         uint ret;
1626         if (self == 0)
1627             return 0;
1628         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1629             ret += 16;
1630             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1631         }
1632         if (self & 0xffffffffffffffff == 0) {
1633             ret += 8;
1634             self = bytes32(uint(self) / 0x10000000000000000);
1635         }
1636         if (self & 0xffffffff == 0) {
1637             ret += 4;
1638             self = bytes32(uint(self) / 0x100000000);
1639         }
1640         if (self & 0xffff == 0) {
1641             ret += 2;
1642             self = bytes32(uint(self) / 0x10000);
1643         }
1644         if (self & 0xff == 0) {
1645             ret += 1;
1646         }
1647         return 32 - ret;
1648     }
1649 
1650     /*
1651      * @dev Returns a slice containing the entire bytes32, interpreted as a
1652      *      null-termintaed utf-8 string.
1653      * @param self The bytes32 value to convert to a slice.
1654      * @return A new slice containing the value of the input argument up to the
1655      *         first null.
1656      */
1657     function toSliceB32(bytes32 self) internal returns (slice ret) {
1658         // Allocate space for `self` in memory, copy it there, and point ret at it
1659         assembly {
1660             let ptr := mload(0x40)
1661             mstore(0x40, add(ptr, 0x20))
1662             mstore(ptr, self)
1663             mstore(add(ret, 0x20), ptr)
1664         }
1665         ret._len = len(self);
1666     }
1667 
1668     /*
1669      * @dev Returns a new slice containing the same data as the current slice.
1670      * @param self The slice to copy.
1671      * @return A new slice containing the same data as `self`.
1672      */
1673     function copy(slice self) internal returns (slice) {
1674         return slice(self._len, self._ptr);
1675     }
1676 
1677     /*
1678      * @dev Copies a slice to a new string.
1679      * @param self The slice to copy.
1680      * @return A newly allocated string containing the slice's text.
1681      */
1682     function toString(slice self) internal returns (string) {
1683         var ret = new string(self._len);
1684         uint retptr;
1685         assembly { retptr := add(ret, 32) }
1686 
1687         memcpy(retptr, self._ptr, self._len);
1688         return ret;
1689     }
1690 
1691     /*
1692      * @dev Returns the length in runes of the slice. Note that this operation
1693      *      takes time proportional to the length of the slice; avoid using it
1694      *      in loops, and call `slice.empty()` if you only need to know whether
1695      *      the slice is empty or not.
1696      * @param self The slice to operate on.
1697      * @return The length of the slice in runes.
1698      */
1699     function len(slice self) internal returns (uint) {
1700         // Starting at ptr-31 means the LSB will be the byte we care about
1701         var ptr = self._ptr - 31;
1702         var end = ptr + self._len;
1703         for (uint len = 0; ptr < end; len++) {
1704             uint8 b;
1705             assembly { b := and(mload(ptr), 0xFF) }
1706             if (b < 0x80) {
1707                 ptr += 1;
1708             } else if(b < 0xE0) {
1709                 ptr += 2;
1710             } else if(b < 0xF0) {
1711                 ptr += 3;
1712             } else if(b < 0xF8) {
1713                 ptr += 4;
1714             } else if(b < 0xFC) {
1715                 ptr += 5;
1716             } else {
1717                 ptr += 6;
1718             }
1719         }
1720         return len;
1721     }
1722 
1723     /*
1724      * @dev Returns true if the slice is empty (has a length of 0).
1725      * @param self The slice to operate on.
1726      * @return True if the slice is empty, False otherwise.
1727      */
1728     function empty(slice self) internal returns (bool) {
1729         return self._len == 0;
1730     }
1731 
1732     /*
1733      * @dev Returns a positive number if `other` comes lexicographically after
1734      *      `self`, a negative number if it comes before, or zero if the
1735      *      contents of the two slices are equal. Comparison is done per-rune,
1736      *      on unicode codepoints.
1737      * @param self The first slice to compare.
1738      * @param other The second slice to compare.
1739      * @return The result of the comparison.
1740      */
1741     function compare(slice self, slice other) internal returns (int) {
1742         uint shortest = self._len;
1743         if (other._len < self._len)
1744             shortest = other._len;
1745 
1746         var selfptr = self._ptr;
1747         var otherptr = other._ptr;
1748         for (uint idx = 0; idx < shortest; idx += 32) {
1749             uint a;
1750             uint b;
1751             assembly {
1752                 a := mload(selfptr)
1753                 b := mload(otherptr)
1754             }
1755             if (a != b) {
1756                 // Mask out irrelevant bytes and check again
1757                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1758                 var diff = (a & mask) - (b & mask);
1759                 if (diff != 0)
1760                     return int(diff);
1761             }
1762             selfptr += 32;
1763             otherptr += 32;
1764         }
1765         return int(self._len) - int(other._len);
1766     }
1767 
1768     /*
1769      * @dev Returns true if the two slices contain the same text.
1770      * @param self The first slice to compare.
1771      * @param self The second slice to compare.
1772      * @return True if the slices are equal, false otherwise.
1773      */
1774     function equals(slice self, slice other) internal returns (bool) {
1775         return compare(self, other) == 0;
1776     }
1777 
1778     /*
1779      * @dev Extracts the first rune in the slice into `rune`, advancing the
1780      *      slice to point to the next rune and returning `self`.
1781      * @param self The slice to operate on.
1782      * @param rune The slice that will contain the first rune.
1783      * @return `rune`.
1784      */
1785     function nextRune(slice self, slice rune) internal returns (slice) {
1786         rune._ptr = self._ptr;
1787 
1788         if (self._len == 0) {
1789             rune._len = 0;
1790             return rune;
1791         }
1792 
1793         uint len;
1794         uint b;
1795         // Load the first byte of the rune into the LSBs of b
1796         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1797         if (b < 0x80) {
1798             len = 1;
1799         } else if(b < 0xE0) {
1800             len = 2;
1801         } else if(b < 0xF0) {
1802             len = 3;
1803         } else {
1804             len = 4;
1805         }
1806 
1807         // Check for truncated codepoints
1808         if (len > self._len) {
1809             rune._len = self._len;
1810             self._ptr += self._len;
1811             self._len = 0;
1812             return rune;
1813         }
1814 
1815         self._ptr += len;
1816         self._len -= len;
1817         rune._len = len;
1818         return rune;
1819     }
1820 
1821     /*
1822      * @dev Returns the first rune in the slice, advancing the slice to point
1823      *      to the next rune.
1824      * @param self The slice to operate on.
1825      * @return A slice containing only the first rune from `self`.
1826      */
1827     function nextRune(slice self) internal returns (slice ret) {
1828         nextRune(self, ret);
1829     }
1830 
1831     /*
1832      * @dev Returns the number of the first codepoint in the slice.
1833      * @param self The slice to operate on.
1834      * @return The number of the first codepoint in the slice.
1835      */
1836     function ord(slice self) internal returns (uint ret) {
1837         if (self._len == 0) {
1838             return 0;
1839         }
1840 
1841         uint word;
1842         uint len;
1843         uint div = 2 ** 248;
1844 
1845         // Load the rune into the MSBs of b
1846         assembly { word:= mload(mload(add(self, 32))) }
1847         var b = word / div;
1848         if (b < 0x80) {
1849             ret = b;
1850             len = 1;
1851         } else if(b < 0xE0) {
1852             ret = b & 0x1F;
1853             len = 2;
1854         } else if(b < 0xF0) {
1855             ret = b & 0x0F;
1856             len = 3;
1857         } else {
1858             ret = b & 0x07;
1859             len = 4;
1860         }
1861 
1862         // Check for truncated codepoints
1863         if (len > self._len) {
1864             return 0;
1865         }
1866 
1867         for (uint i = 1; i < len; i++) {
1868             div = div / 256;
1869             b = (word / div) & 0xFF;
1870             if (b & 0xC0 != 0x80) {
1871                 // Invalid UTF-8 sequence
1872                 return 0;
1873             }
1874             ret = (ret * 64) | (b & 0x3F);
1875         }
1876 
1877         return ret;
1878     }
1879 
1880     /*
1881      * @dev Returns the keccak-256 hash of the slice.
1882      * @param self The slice to hash.
1883      * @return The hash of the slice.
1884      */
1885     function keccak(slice self) internal returns (bytes32 ret) {
1886         assembly {
1887             ret := sha3(mload(add(self, 32)), mload(self))
1888         }
1889     }
1890 
1891     /*
1892      * @dev Returns true if `self` starts with `needle`.
1893      * @param self The slice to operate on.
1894      * @param needle The slice to search for.
1895      * @return True if the slice starts with the provided text, false otherwise.
1896      */
1897     function startsWith(slice self, slice needle) internal returns (bool) {
1898         if (self._len < needle._len) {
1899             return false;
1900         }
1901 
1902         if (self._ptr == needle._ptr) {
1903             return true;
1904         }
1905 
1906         bool equal;
1907         assembly {
1908             let len := mload(needle)
1909             let selfptr := mload(add(self, 0x20))
1910             let needleptr := mload(add(needle, 0x20))
1911             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1912         }
1913         return equal;
1914     }
1915 
1916     /*
1917      * @dev If `self` starts with `needle`, `needle` is removed from the
1918      *      beginning of `self`. Otherwise, `self` is unmodified.
1919      * @param self The slice to operate on.
1920      * @param needle The slice to search for.
1921      * @return `self`
1922      */
1923     function beyond(slice self, slice needle) internal returns (slice) {
1924         if (self._len < needle._len) {
1925             return self;
1926         }
1927 
1928         bool equal = true;
1929         if (self._ptr != needle._ptr) {
1930             assembly {
1931                 let len := mload(needle)
1932                 let selfptr := mload(add(self, 0x20))
1933                 let needleptr := mload(add(needle, 0x20))
1934                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1935             }
1936         }
1937 
1938         if (equal) {
1939             self._len -= needle._len;
1940             self._ptr += needle._len;
1941         }
1942 
1943         return self;
1944     }
1945 
1946     /*
1947      * @dev Returns true if the slice ends with `needle`.
1948      * @param self The slice to operate on.
1949      * @param needle The slice to search for.
1950      * @return True if the slice starts with the provided text, false otherwise.
1951      */
1952     function endsWith(slice self, slice needle) internal returns (bool) {
1953         if (self._len < needle._len) {
1954             return false;
1955         }
1956 
1957         var selfptr = self._ptr + self._len - needle._len;
1958 
1959         if (selfptr == needle._ptr) {
1960             return true;
1961         }
1962 
1963         bool equal;
1964         assembly {
1965             let len := mload(needle)
1966             let needleptr := mload(add(needle, 0x20))
1967             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1968         }
1969 
1970         return equal;
1971     }
1972 
1973     /*
1974      * @dev If `self` ends with `needle`, `needle` is removed from the
1975      *      end of `self`. Otherwise, `self` is unmodified.
1976      * @param self The slice to operate on.
1977      * @param needle The slice to search for.
1978      * @return `self`
1979      */
1980     function until(slice self, slice needle) internal returns (slice) {
1981         if (self._len < needle._len) {
1982             return self;
1983         }
1984 
1985         var selfptr = self._ptr + self._len - needle._len;
1986         bool equal = true;
1987         if (selfptr != needle._ptr) {
1988             assembly {
1989                 let len := mload(needle)
1990                 let needleptr := mload(add(needle, 0x20))
1991                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1992             }
1993         }
1994 
1995         if (equal) {
1996             self._len -= needle._len;
1997         }
1998 
1999         return self;
2000     }
2001 
2002     // Returns the memory address of the first byte of the first occurrence of
2003     // `needle` in `self`, or the first byte after `self` if not found.
2004     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
2005         uint ptr;
2006         uint idx;
2007 
2008         if (needlelen <= selflen) {
2009             if (needlelen <= 32) {
2010                 // Optimized assembly for 68 gas per byte on short strings
2011                 assembly {
2012                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
2013                     let needledata := and(mload(needleptr), mask)
2014                     let end := add(selfptr, sub(selflen, needlelen))
2015                     ptr := selfptr
2016                     loop:
2017                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
2018                     ptr := add(ptr, 1)
2019                     jumpi(loop, lt(sub(ptr, 1), end))
2020                     ptr := add(selfptr, selflen)
2021                     exit:
2022                 }
2023                 return ptr;
2024             } else {
2025                 // For long needles, use hashing
2026                 bytes32 hash;
2027                 assembly { hash := sha3(needleptr, needlelen) }
2028                 ptr = selfptr;
2029                 for (idx = 0; idx <= selflen - needlelen; idx++) {
2030                     bytes32 testHash;
2031                     assembly { testHash := sha3(ptr, needlelen) }
2032                     if (hash == testHash)
2033                         return ptr;
2034                     ptr += 1;
2035                 }
2036             }
2037         }
2038         return selfptr + selflen;
2039     }
2040 
2041     // Returns the memory address of the first byte after the last occurrence of
2042     // `needle` in `self`, or the address of `self` if not found.
2043     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
2044         uint ptr;
2045 
2046         if (needlelen <= selflen) {
2047             if (needlelen <= 32) {
2048                 // Optimized assembly for 69 gas per byte on short strings
2049                 assembly {
2050                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
2051                     let needledata := and(mload(needleptr), mask)
2052                     ptr := add(selfptr, sub(selflen, needlelen))
2053                     loop:
2054                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
2055                     ptr := sub(ptr, 1)
2056                     jumpi(loop, gt(add(ptr, 1), selfptr))
2057                     ptr := selfptr
2058                     jump(exit)
2059                     ret:
2060                     ptr := add(ptr, needlelen)
2061                     exit:
2062                 }
2063                 return ptr;
2064             } else {
2065                 // For long needles, use hashing
2066                 bytes32 hash;
2067                 assembly { hash := sha3(needleptr, needlelen) }
2068                 ptr = selfptr + (selflen - needlelen);
2069                 while (ptr >= selfptr) {
2070                     bytes32 testHash;
2071                     assembly { testHash := sha3(ptr, needlelen) }
2072                     if (hash == testHash)
2073                         return ptr + needlelen;
2074                     ptr -= 1;
2075                 }
2076             }
2077         }
2078         return selfptr;
2079     }
2080 
2081     /*
2082      * @dev Modifies `self` to contain everything from the first occurrence of
2083      *      `needle` to the end of the slice. `self` is set to the empty slice
2084      *      if `needle` is not found.
2085      * @param self The slice to search and modify.
2086      * @param needle The text to search for.
2087      * @return `self`.
2088      */
2089     function find(slice self, slice needle) internal returns (slice) {
2090         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2091         self._len -= ptr - self._ptr;
2092         self._ptr = ptr;
2093         return self;
2094     }
2095 
2096     /*
2097      * @dev Modifies `self` to contain the part of the string from the start of
2098      *      `self` to the end of the first occurrence of `needle`. If `needle`
2099      *      is not found, `self` is set to the empty slice.
2100      * @param self The slice to search and modify.
2101      * @param needle The text to search for.
2102      * @return `self`.
2103      */
2104     function rfind(slice self, slice needle) internal returns (slice) {
2105         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2106         self._len = ptr - self._ptr;
2107         return self;
2108     }
2109 
2110     /*
2111      * @dev Splits the slice, setting `self` to everything after the first
2112      *      occurrence of `needle`, and `token` to everything before it. If
2113      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2114      *      and `token` is set to the entirety of `self`.
2115      * @param self The slice to split.
2116      * @param needle The text to search for in `self`.
2117      * @param token An output parameter to which the first token is written.
2118      * @return `token`.
2119      */
2120     function split(slice self, slice needle, slice token) internal returns (slice) {
2121         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2122         token._ptr = self._ptr;
2123         token._len = ptr - self._ptr;
2124         if (ptr == self._ptr + self._len) {
2125             // Not found
2126             self._len = 0;
2127         } else {
2128             self._len -= token._len + needle._len;
2129             self._ptr = ptr + needle._len;
2130         }
2131         return token;
2132     }
2133 
2134     /*
2135      * @dev Splits the slice, setting `self` to everything after the first
2136      *      occurrence of `needle`, and returning everything before it. If
2137      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2138      *      and the entirety of `self` is returned.
2139      * @param self The slice to split.
2140      * @param needle The text to search for in `self`.
2141      * @return The part of `self` up to the first occurrence of `delim`.
2142      */
2143     function split(slice self, slice needle) internal returns (slice token) {
2144         split(self, needle, token);
2145     }
2146 
2147     /*
2148      * @dev Splits the slice, setting `self` to everything before the last
2149      *      occurrence of `needle`, and `token` to everything after it. If
2150      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2151      *      and `token` is set to the entirety of `self`.
2152      * @param self The slice to split.
2153      * @param needle The text to search for in `self`.
2154      * @param token An output parameter to which the first token is written.
2155      * @return `token`.
2156      */
2157     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
2158         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2159         token._ptr = ptr;
2160         token._len = self._len - (ptr - self._ptr);
2161         if (ptr == self._ptr) {
2162             // Not found
2163             self._len = 0;
2164         } else {
2165             self._len -= token._len + needle._len;
2166         }
2167         return token;
2168     }
2169 
2170     /*
2171      * @dev Splits the slice, setting `self` to everything before the last
2172      *      occurrence of `needle`, and returning everything after it. If
2173      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2174      *      and the entirety of `self` is returned.
2175      * @param self The slice to split.
2176      * @param needle The text to search for in `self`.
2177      * @return The part of `self` after the last occurrence of `delim`.
2178      */
2179     function rsplit(slice self, slice needle) internal returns (slice token) {
2180         rsplit(self, needle, token);
2181     }
2182 
2183     /*
2184      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
2185      * @param self The slice to search.
2186      * @param needle The text to search for in `self`.
2187      * @return The number of occurrences of `needle` found in `self`.
2188      */
2189     function count(slice self, slice needle) internal returns (uint count) {
2190         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
2191         while (ptr <= self._ptr + self._len) {
2192             count++;
2193             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
2194         }
2195     }
2196 
2197     /*
2198      * @dev Returns True if `self` contains `needle`.
2199      * @param self The slice to search.
2200      * @param needle The text to search for in `self`.
2201      * @return True if `needle` is found in `self`, false otherwise.
2202      */
2203     function contains(slice self, slice needle) internal returns (bool) {
2204         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
2205     }
2206 
2207     /*
2208      * @dev Returns a newly allocated string containing the concatenation of
2209      *      `self` and `other`.
2210      * @param self The first slice to concatenate.
2211      * @param other The second slice to concatenate.
2212      * @return The concatenation of the two strings.
2213      */
2214     function concat(slice self, slice other) internal returns (string) {
2215         var ret = new string(self._len + other._len);
2216         uint retptr;
2217         assembly { retptr := add(ret, 32) }
2218         memcpy(retptr, self._ptr, self._len);
2219         memcpy(retptr + self._len, other._ptr, other._len);
2220         return ret;
2221     }
2222 
2223     /*
2224      * @dev Joins an array of slices, using `self` as a delimiter, returning a
2225      *      newly allocated string.
2226      * @param self The delimiter to use.
2227      * @param parts A list of slices to join.
2228      * @return A newly allocated string containing all the slices in `parts`,
2229      *         joined with `self`.
2230      */
2231     function join(slice self, slice[] parts) internal returns (string) {
2232         if (parts.length == 0)
2233             return "";
2234 
2235         uint len = self._len * (parts.length - 1);
2236         for(uint i = 0; i < parts.length; i++)
2237             len += parts[i]._len;
2238 
2239         var ret = new string(len);
2240         uint retptr;
2241         assembly { retptr := add(ret, 32) }
2242 
2243         for(i = 0; i < parts.length; i++) {
2244             memcpy(retptr, parts[i]._ptr, parts[i]._len);
2245             retptr += parts[i]._len;
2246             if (i < parts.length - 1) {
2247                 memcpy(retptr, self._ptr, self._len);
2248                 retptr += self._len;
2249             }
2250         }
2251 
2252         return ret;
2253     }
2254 }
2255 
2256 contract FlightDelayPayout is FlightDelayControlledContract, FlightDelayConstants, FlightDelayOraclizeInterface, ConvertLib {
2257 
2258     using strings for *;
2259 
2260     FlightDelayDatabaseInterface FD_DB;
2261     FlightDelayLedgerInterface FD_LG;
2262     FlightDelayAccessControllerInterface FD_AC;
2263 
2264     /*
2265      * @dev Contract constructor sets its controller
2266      * @param _controller FD.Controller
2267      */
2268     function FlightDelayPayout(address _controller) {
2269         setController(_controller);
2270     }
2271 
2272     /*
2273      * Public methods
2274      */
2275 
2276     /*
2277      * @dev Set access permissions for methods
2278      */
2279     function setContracts() public onlyController {
2280         FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));
2281         FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));
2282         FD_LG = FlightDelayLedgerInterface(getContract("FD.Ledger"));
2283 
2284         FD_AC.setPermissionById(101, "FD.Underwrite");
2285         //FD_AC.setPermissionByAddress(101, oraclize_cbAddress());
2286         FD_AC.setPermissionById(102, "FD.Funder");
2287     }
2288 
2289     /*
2290      * @dev Fund contract
2291      */
2292     function fund() payable {
2293         require(FD_AC.checkPermission(102, msg.sender));
2294 
2295         // todo: bookkeeping
2296         // todo: fire funding event
2297     }
2298 
2299     /*
2300      * @dev Schedule oraclize call for payout
2301      * @param _policyId
2302      * @param _riskId
2303      * @param _oraclizeTime
2304      */
2305     function schedulePayoutOraclizeCall(uint _policyId, bytes32 _riskId, uint _oraclizeTime) public {
2306         require(FD_AC.checkPermission(101, msg.sender));
2307 
2308         var (carrierFlightNumber, departureYearMonthDay,) = FD_DB.getRiskParameters(_riskId);
2309 
2310         string memory oraclizeUrl = strConcat(
2311             ORACLIZE_STATUS_BASE_URL,
2312             b32toString(carrierFlightNumber),
2313             b32toString(departureYearMonthDay),
2314             ORACLIZE_STATUS_QUERY
2315         );
2316 
2317         bytes32 queryId = oraclize_query(
2318             _oraclizeTime,
2319             "nested",
2320             oraclizeUrl,
2321             ORACLIZE_GAS
2322         );
2323 
2324         FD_DB.createOraclizeCallback(
2325             queryId,
2326             _policyId,
2327             oraclizeState.ForPayout,
2328             _oraclizeTime
2329         );
2330 
2331         LogOraclizeCall(_policyId, queryId, oraclizeUrl, _oraclizeTime);
2332     }
2333 
2334     /*
2335      * @dev Oraclize callback. In an emergency case, we can call this directly from FD.Emergency Account.
2336      * @param _queryId
2337      * @param _result
2338      * @param _proof
2339      */
2340     function __callback(bytes32 _queryId, string _result, bytes _proof) public onlyOraclizeOr(getContract('FD.Emergency')) {
2341 
2342         var (policyId, oraclizeTime) = FD_DB.getOraclizeCallback(_queryId);
2343         LogOraclizeCallback(policyId, _queryId, _result, _proof);
2344 
2345         // check if policy was declined after this callback was scheduled
2346         var state = FD_DB.getPolicyState(policyId);
2347         require(uint8(state) != 5);
2348 
2349         bytes32 riskId = FD_DB.getRiskId(policyId);
2350 
2351 // --> debug-mode
2352 //            LogBytes32("riskId", riskId);
2353 // <-- debug-mode
2354 
2355         var slResult = _result.toSlice();
2356 
2357         if (bytes(_result).length == 0) { // empty Result
2358             if (FD_DB.checkTime(_queryId, riskId, 180 minutes)) {
2359                 LogPolicyManualPayout(policyId, "No Callback at +120 min");
2360                 return;
2361             } else {
2362                 schedulePayoutOraclizeCall(policyId, riskId, oraclizeTime + 45 minutes);
2363             }
2364         } else {
2365             // first check status
2366             // extract the status field:
2367             slResult.find("\"".toSlice()).beyond("\"".toSlice());
2368             slResult.until(slResult.copy().find("\"".toSlice()));
2369             bytes1 status = bytes(slResult.toString())[0];	// s = L
2370             if (status == "C") {
2371                 // flight cancelled --> payout
2372                 payOut(policyId, 4, 0);
2373                 return;
2374             } else if (status == "D") {
2375                 // flight diverted --> payout
2376                 payOut(policyId, 5, 0);
2377                 return;
2378             } else if (status != "L" && status != "A" && status != "C" && status != "D") {
2379                 LogPolicyManualPayout(policyId, "Unprocessable status");
2380                 return;
2381             }
2382 
2383             // process the rest of the response:
2384             slResult = _result.toSlice();
2385             bool arrived = slResult.contains("actualGateArrival".toSlice());
2386 
2387             if (status == "A" || (status == "L" && !arrived)) {
2388                 // flight still active or not at gate --> reschedule
2389                 if (FD_DB.checkTime(_queryId, riskId, 180 minutes)) {
2390                     LogPolicyManualPayout(policyId, "No arrival at +180 min");
2391                 } else {
2392                     schedulePayoutOraclizeCall(policyId, riskId, oraclizeTime + 45 minutes);
2393                 }
2394             } else if (status == "L" && arrived) {
2395                 var aG = "\"arrivalGateDelayMinutes\": ".toSlice();
2396                 if (slResult.contains(aG)) {
2397                     slResult.find(aG).beyond(aG);
2398                     slResult.until(slResult.copy().find("\"".toSlice()).beyond("\"".toSlice()));
2399                     // truffle bug, replace by "}" as soon as it is fixed.
2400                     slResult.until(slResult.copy().find("\x7D".toSlice()));
2401                     slResult.until(slResult.copy().find(",".toSlice()));
2402                     uint delayInMinutes = parseInt(slResult.toString());
2403                 } else {
2404                     delayInMinutes = 0;
2405                 }
2406 
2407                 if (delayInMinutes < 15) {
2408                     payOut(policyId, 0, 0);
2409                 } else if (delayInMinutes < 30) {
2410                     payOut(policyId, 1, delayInMinutes);
2411                 } else if (delayInMinutes < 45) {
2412                     payOut(policyId, 2, delayInMinutes);
2413                 } else {
2414                     payOut(policyId, 3, delayInMinutes);
2415                 }
2416             } else { // no delay info
2417                 payOut(policyId, 0, 0);
2418             }
2419         }
2420     }
2421 
2422     /*
2423      * Internal methods
2424      */
2425 
2426     /*
2427      * @dev Payout
2428      * @param _policyId
2429      * @param _delay
2430      * @param _delayInMinutes
2431      */
2432     function payOut(uint _policyId, uint8 _delay, uint _delayInMinutes)	internal {
2433 // --> debug-mode
2434 //            LogString("im payOut", "");
2435 //            LogUint("policyId", _policyId);
2436 //            LogUint("delay", _delay);
2437 //            LogUint("in minutes", _delayInMinutes);
2438 // <-- debug-mode
2439 
2440         FD_DB.setDelay(_policyId, _delay, _delayInMinutes);
2441 
2442         if (_delay == 0) {
2443             FD_DB.setState(
2444                 _policyId,
2445                 policyState.Expired,
2446                 now,
2447                 "Expired - no delay!"
2448             );
2449         } else {
2450             var (customer, weight, premium) = FD_DB.getPolicyData(_policyId);
2451 
2452 // --> debug-mode
2453 //                LogUint("weight", weight);
2454 // <-- debug-mode
2455 
2456             if (weight == 0) {
2457                 weight = 20000;
2458             }
2459 
2460             uint payout = premium * WEIGHT_PATTERN[_delay] * 10000 / weight;
2461             uint calculatedPayout = payout;
2462 
2463             if (payout > MAX_PAYOUT) {
2464                 payout = MAX_PAYOUT;
2465             }
2466 
2467             FD_DB.setPayouts(_policyId, calculatedPayout, payout);
2468 
2469             if (!FD_LG.sendFunds(customer, Acc.Payout, payout)) {
2470                 FD_DB.setState(
2471                     _policyId,
2472                     policyState.SendFailed,
2473                     now,
2474                     "Payout, send failed!"
2475                 );
2476 
2477                 FD_DB.setPayouts(_policyId, calculatedPayout, 0);
2478             } else {
2479                 FD_DB.setState(
2480                     _policyId,
2481                     policyState.PaidOut,
2482                     now,
2483                     "Payout successful!"
2484                 );
2485             }
2486         }
2487     }
2488 }