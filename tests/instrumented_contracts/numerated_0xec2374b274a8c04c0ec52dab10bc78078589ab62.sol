1 /**
2  * FlightDelay with Oraclized Underwriting and Payout
3  *
4  * @description Controlled contract Interface
5  * @copyright (c) 2017 etherisc GmbH
6  * @author Christoph Mussenbrock
7  */
8 
9 pragma solidity ^0.4.11;
10 
11 contract FlightDelayAccessControllerInterface {
12 
13     function setPermissionById(uint8 _perm, bytes32 _id);
14 
15     function setPermissionById(uint8 _perm, bytes32 _id, bool _access);
16 
17     function setPermissionByAddress(uint8 _perm, address _addr);
18 
19     function setPermissionByAddress(uint8 _perm, address _addr, bool _access);
20 
21     function checkPermission(uint8 _perm, address _addr) returns (bool _success);
22 }
23 
24 contract FlightDelayDatabaseModel {
25 
26     // Ledger accounts.
27     enum Acc {
28         Premium,      // 0
29         RiskFund,     // 1
30         Payout,       // 2
31         Balance,      // 3
32         Reward,       // 4
33         OraclizeCosts // 5
34     }
35 
36     // policy Status Codes and meaning:
37     //
38     // 00 = Applied:      the customer has payed a premium, but the oracle has
39     //                          not yet checked and confirmed.
40     //                          The customer can still revoke the policy.
41     // 01 = Accepted:     the oracle has checked and confirmed.
42     //                          The customer can still revoke the policy.
43     // 02 = Revoked:      The customer has revoked the policy.
44     //                          The premium minus cancellation fee is payed back to the
45     //                          customer by the oracle.
46     // 03 = PaidOut:      The flight has ended with delay.
47     //                          The oracle has checked and payed out.
48     // 04 = Expired:      The flight has endet with <15min. delay.
49     //                          No payout.
50     // 05 = Declined:     The application was invalid.
51     //                          The premium minus cancellation fee is payed back to the
52     //                          customer by the oracle.
53     // 06 = SendFailed: During Revoke, Decline or Payout, sending ether failed
54     //                          for unknown reasons.
55     //                          The funds remain in the contracts RiskFund.
56 
57 
58     //                   00       01        02       03        04      05           06
59     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
60 
61     // oraclize callback types:
62     enum oraclizeState { ForUnderwriting, ForPayout }
63 
64     //               00   01   02   03
65     enum Currency { ETH, EUR, USD, GBP }
66 
67     // the policy structure: this structure keeps track of the individual parameters of a policy.
68     // typically customer address, premium and some status information.
69     struct Policy {
70         // 0 - the customer
71         address customer;
72 
73         // 1 - premium
74         uint premium;
75         // risk specific parameters:
76         // 2 - pointer to the risk in the risks mapping
77         bytes32 riskId;
78         // custom payout pattern
79         // in future versions, customer will be able to tamper with this array.
80         // to keep things simple, we have decided to hard-code the array for all policies.
81         // uint8[5] pattern;
82         // 3 - probability weight. this is the central parameter
83         uint weight;
84         // 4 - calculated Payout
85         uint calculatedPayout;
86         // 5 - actual Payout
87         uint actualPayout;
88 
89         // status fields:
90         // 6 - the state of the policy
91         policyState state;
92         // 7 - time of last state change
93         uint stateTime;
94         // 8 - state change message/reason
95         bytes32 stateMessage;
96         // 9 - TLSNotary Proof
97         bytes proof;
98         // 10 - Currency
99         Currency currency;
100         // 10 - External customer id
101         bytes32 customerExternalId;
102     }
103 
104     // the risk structure; this structure keeps track of the risk-
105     // specific parameters.
106     // several policies can share the same risk structure (typically
107     // some people flying with the same plane)
108     struct Risk {
109         // 0 - Airline Code + FlightNumber
110         bytes32 carrierFlightNumber;
111         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
112         bytes32 departureYearMonthDay;
113         // 2 - the inital arrival time
114         uint arrivalTime;
115         // 3 - the final delay in minutes
116         uint delayInMinutes;
117         // 4 - the determined delay category (0-5)
118         uint8 delay;
119         // 5 - we limit the cumulated weighted premium to avoid cluster risks
120         uint cumulatedWeightedPremium;
121         // 6 - max cumulated Payout for this risk
122         uint premiumMultiplier;
123     }
124 
125     // the oraclize callback structure: we use several oraclize calls.
126     // all oraclize calls will result in a common callback to __callback(...).
127     // to keep track of the different querys we have to introduce this struct.
128     struct OraclizeCallback {
129         // for which policy have we called?
130         uint policyId;
131         // for which purpose did we call? {ForUnderwrite | ForPayout}
132         oraclizeState oState;
133         // time
134         uint oraclizeTime;
135     }
136 
137     struct Customer {
138         bytes32 customerExternalId;
139         bool identityConfirmed;
140     }
141 }
142 
143 
144 contract FlightDelayControllerInterface {
145 
146     function isOwner(address _addr) returns (bool _isOwner);
147 
148     function selfRegister(bytes32 _id) returns (bool result);
149 
150     function getContract(bytes32 _id) returns (address _addr);
151 }
152 
153 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
154 
155     address public controller;
156     FlightDelayControllerInterface FD_CI;
157 
158     modifier onlyController() {
159         require(msg.sender == controller);
160         _;
161     }
162 
163     function setController(address _controller) internal returns (bool _result) {
164         controller = _controller;
165         FD_CI = FlightDelayControllerInterface(_controller);
166         _result = true;
167     }
168 
169     function destruct() onlyController {
170         selfdestruct(controller);
171     }
172 
173     function setContracts() onlyController {}
174 
175     function getContract(bytes32 _id) internal returns (address _addr) {
176         _addr = FD_CI.getContract(_id);
177     }
178 }
179 
180 contract FlightDelayConstants {
181 
182     /*
183     * General events
184     */
185 
186 // --> test-mode
187 //        event LogUint(string _message, uint _uint);
188 //        event LogUintEth(string _message, uint ethUint);
189 //        event LogUintTime(string _message, uint timeUint);
190 //        event LogInt(string _message, int _int);
191 //        event LogAddress(string _message, address _address);
192 //        event LogBytes32(string _message, bytes32 hexBytes32);
193 //        event LogBytes(string _message, bytes hexBytes);
194 //        event LogBytes32Str(string _message, bytes32 strBytes32);
195 //        event LogString(string _message, string _string);
196 //        event LogBool(string _message, bool _bool);
197 //        event Log(address);
198 // <-- test-mode
199 
200     event LogPolicyApplied(
201         uint _policyId,
202         address _customer,
203         bytes32 strCarrierFlightNumber,
204         uint ethPremium
205     );
206     event LogPolicyAccepted(
207         uint _policyId,
208         uint _statistics0,
209         uint _statistics1,
210         uint _statistics2,
211         uint _statistics3,
212         uint _statistics4,
213         uint _statistics5
214     );
215     event LogPolicyPaidOut(
216         uint _policyId,
217         uint ethAmount
218     );
219     event LogPolicyExpired(
220         uint _policyId
221     );
222     event LogPolicyDeclined(
223         uint _policyId,
224         bytes32 strReason
225     );
226     event LogPolicyManualPayout(
227         uint _policyId,
228         bytes32 strReason
229     );
230     event LogSendFunds(
231         address _recipient,
232         uint8 _from,
233         uint ethAmount
234     );
235     event LogReceiveFunds(
236         address _sender,
237         uint8 _to,
238         uint ethAmount
239     );
240     event LogSendFail(
241         uint _policyId,
242         bytes32 strReason
243     );
244     event LogOraclizeCall(
245         uint _policyId,
246         bytes32 hexQueryId,
247         string _oraclizeUrl,
248         uint256 _oraclizeTime
249     );
250     event LogOraclizeCallback(
251         uint _policyId,
252         bytes32 hexQueryId,
253         string _result,
254         bytes hexProof
255     );
256     event LogSetState(
257         uint _policyId,
258         uint8 _policyState,
259         uint _stateTime,
260         bytes32 _stateMessage
261     );
262     event LogExternal(
263         uint256 _policyId,
264         address _address,
265         bytes32 _externalId
266     );
267 
268     /*
269     * General constants
270     */
271 
272     // minimum observations for valid prediction
273     uint constant MIN_OBSERVATIONS = 10;
274     // minimum premium to cover costs
275     uint constant MIN_PREMIUM = 50 finney;
276     // maximum premium
277     uint constant MAX_PREMIUM = 1 ether;
278     // maximum payout
279     uint constant MAX_PAYOUT = 1100 finney;
280 
281     uint constant MIN_PREMIUM_EUR = 1500 wei;
282     uint constant MAX_PREMIUM_EUR = 29000 wei;
283     uint constant MAX_PAYOUT_EUR = 30000 wei;
284 
285     uint constant MIN_PREMIUM_USD = 1700 wei;
286     uint constant MAX_PREMIUM_USD = 34000 wei;
287     uint constant MAX_PAYOUT_USD = 35000 wei;
288 
289     uint constant MIN_PREMIUM_GBP = 1300 wei;
290     uint constant MAX_PREMIUM_GBP = 25000 wei;
291     uint constant MAX_PAYOUT_GBP = 270 wei;
292 
293     // maximum cumulated weighted premium per risk
294     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;
295     // 1 percent for DAO, 1 percent for maintainer
296     uint8 constant REWARD_PERCENT = 2;
297     // reserve for tail risks
298     uint8 constant RESERVE_PERCENT = 1;
299     // the weight pattern; in future versions this may become part of the policy struct.
300     // currently can't be constant because of compiler restrictions
301     // WEIGHT_PATTERN[0] is not used, just to be consistent
302     uint8[6] WEIGHT_PATTERN = [
303         0,
304         10,
305         20,
306         30,
307         50,
308         50
309     ];
310 
311 // --> prod-mode
312     // DEFINITIONS FOR ROPSTEN AND MAINNET
313     // minimum time before departure for applying
314     uint constant MIN_TIME_BEFORE_DEPARTURE = 24 hours; // for production
315     // check for delay after .. minutes after scheduled arrival
316     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
317 // <-- prod-mode
318 
319 // --> test-mode
320 //        // DEFINITIONS FOR LOCAL TESTNET
321 //        // minimum time before departure for applying
322 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
323 //        // check for delay after .. minutes after scheduled arrival
324 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
325 // <-- test-mode
326 
327     // maximum duration of flight
328     uint constant MAX_FLIGHT_DURATION = 2 days;
329     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
330     uint constant CONTRACT_DEAD_LINE = 1922396399;
331 
332     uint constant MIN_DEPARTURE_LIM = 1508198400;
333 
334     uint constant MAX_DEPARTURE_LIM = 1509840000;
335 
336     // gas Constants for oraclize
337     uint constant ORACLIZE_GAS = 1000000;
338 
339 
340     /*
341     * URLs and query strings for oraclize
342     */
343 
344 // --> prod-mode
345     // DEFINITIONS FOR ROPSTEN AND MAINNET
346     string constant ORACLIZE_RATINGS_BASE_URL =
347         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
348         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
349     string constant ORACLIZE_RATINGS_QUERY =
350         "?${[decrypt] <!--PUT ENCRYPTED_QUERY HERE--> }).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
351     string constant ORACLIZE_STATUS_BASE_URL =
352         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
353         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
354     string constant ORACLIZE_STATUS_QUERY =
355         // pattern:
356         "?${[decrypt] <!--PUT ENCRYPTED_QUERY HERE--> }&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
357 // <-- prod-mode
358 
359 // --> test-mode
360 //        // DEFINITIONS FOR LOCAL TESTNET
361 //        string constant ORACLIZE_RATINGS_BASE_URL =
362 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
363 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
364 //        string constant ORACLIZE_RATINGS_QUERY =
365 //            // for testrpc:
366 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
367 //        string constant ORACLIZE_STATUS_BASE_URL =
368 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
369 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
370 //        string constant ORACLIZE_STATUS_QUERY =
371 //            // for testrpc:
372 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
373 // <-- test-mode
374 }
375 
376 contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {
377 
378     function setAccessControl(address _contract, address _caller, uint8 _perm);
379 
380     function setAccessControl(
381         address _contract,
382         address _caller,
383         uint8 _perm,
384         bool _access
385     );
386 
387     function getAccessControl(address _contract, address _caller, uint8 _perm) returns (bool _allowed);
388 
389     function setLedger(uint8 _index, int _value);
390 
391     function getLedger(uint8 _index) returns (int _value);
392 
393     function getCustomerPremium(uint _policyId) returns (address _customer, uint _premium);
394 
395     function getPolicyData(uint _policyId) returns (address _customer, uint _premium, uint _weight);
396 
397     function getPolicyState(uint _policyId) returns (policyState _state);
398 
399     function getRiskId(uint _policyId) returns (bytes32 _riskId);
400 
401     function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) returns (uint _policyId);
402 
403     function setState(
404         uint _policyId,
405         policyState _state,
406         uint _stateTime,
407         bytes32 _stateMessage
408     );
409 
410     function setWeight(uint _policyId, uint _weight, bytes _proof);
411 
412     function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout);
413 
414     function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes);
415 
416     function getRiskParameters(bytes32 _riskId)
417         returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime);
418 
419     function getPremiumFactors(bytes32 _riskId)
420         returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);
421 
422     function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)
423         returns (bytes32 _riskId);
424 
425     function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier);
426 
427     function getOraclizeCallback(bytes32 _queryId)
428         returns (uint _policyId, uint _arrivalTime);
429 
430     function getOraclizePolicyId(bytes32 _queryId)
431     returns (uint _policyId);
432 
433     function createOraclizeCallback(
434         bytes32 _queryId,
435         uint _policyId,
436         oraclizeState _oraclizeState,
437         uint _oraclizeTime
438     );
439 
440     function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)
441         returns (bool _result);
442 }
443 
444 contract FlightDelayLedgerInterface is FlightDelayDatabaseModel {
445 
446     function receiveFunds(Acc _to) payable;
447 
448     function sendFunds(address _recipient, Acc _from, uint _amount) returns (bool _success);
449 
450     function bookkeeping(Acc _from, Acc _to, uint amount);
451 }
452 
453 contract FlightDelayPayoutInterface {
454 
455     function schedulePayoutOraclizeCall(uint _policyId, bytes32 _riskId, uint _offset);
456 }
457 
458 contract OraclizeI {
459     address public cbAddress;
460     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
461     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
462     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
463     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
464     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
465     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
466     function getPrice(string _datasource) returns (uint _dsprice);
467     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
468     function useCoupon(string _coupon);
469     function setProofType(byte _proofType);
470     function setConfig(bytes32 _config);
471     function setCustomGasPrice(uint _gasPrice);
472     function randomDS_getSessionPubKeyHash() returns(bytes32);
473 }
474 contract OraclizeAddrResolverI {
475     function getAddress() returns (address _addr);
476 }
477 contract usingOraclize {
478     uint constant day = 60*60*24;
479     uint constant week = 60*60*24*7;
480     uint constant month = 60*60*24*30;
481     byte constant proofType_NONE = 0x00;
482     byte constant proofType_TLSNotary = 0x10;
483     byte constant proofType_Android = 0x20;
484     byte constant proofType_Ledger = 0x30;
485     byte constant proofType_Native = 0xF0;
486     byte constant proofStorage_IPFS = 0x01;
487     uint8 constant networkID_auto = 0;
488     uint8 constant networkID_mainnet = 1;
489     uint8 constant networkID_testnet = 2;
490     uint8 constant networkID_morden = 2;
491     uint8 constant networkID_consensys = 161;
492 
493     OraclizeAddrResolverI OAR;
494 
495     OraclizeI oraclize;
496     modifier oraclizeAPI {
497         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
498         oraclize = OraclizeI(OAR.getAddress());
499         _;
500     }
501     modifier coupon(string code){
502         oraclize = OraclizeI(OAR.getAddress());
503         oraclize.useCoupon(code);
504         _;
505     }
506 
507     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
508         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
509             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
510             oraclize_setNetworkName("eth_mainnet");
511             return true;
512         }
513         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
514             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
515             oraclize_setNetworkName("eth_ropsten3");
516             return true;
517         }
518         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
519             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
520             oraclize_setNetworkName("eth_kovan");
521             return true;
522         }
523         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
524             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
525             oraclize_setNetworkName("eth_rinkeby");
526             return true;
527         }
528         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
529             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
530             return true;
531         }
532         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
533             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
534             return true;
535         }
536         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
537             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
538             return true;
539         }
540         return false;
541     }
542 
543     function __callback(bytes32 myid, string result) {
544         __callback(myid, result, new bytes(0));
545     }
546     function __callback(bytes32 myid, string result, bytes proof) {
547     }
548 
549     function oraclize_useCoupon(string code) oraclizeAPI internal {
550         oraclize.useCoupon(code);
551     }
552 
553     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
554         return oraclize.getPrice(datasource);
555     }
556 
557     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
558         return oraclize.getPrice(datasource, gaslimit);
559     }
560 
561     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
562         uint price = oraclize.getPrice(datasource);
563         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
564         return oraclize.query.value(price)(0, datasource, arg);
565     }
566     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
567         uint price = oraclize.getPrice(datasource);
568         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
569         return oraclize.query.value(price)(timestamp, datasource, arg);
570     }
571     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
572         uint price = oraclize.getPrice(datasource, gaslimit);
573         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
574         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
575     }
576     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
577         uint price = oraclize.getPrice(datasource, gaslimit);
578         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
579         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
580     }
581     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
582         uint price = oraclize.getPrice(datasource);
583         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
584         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
585     }
586     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
587         uint price = oraclize.getPrice(datasource);
588         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
589         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
590     }
591     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
592         uint price = oraclize.getPrice(datasource, gaslimit);
593         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
594         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
595     }
596     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
597         uint price = oraclize.getPrice(datasource, gaslimit);
598         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
599         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
600     }
601     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
602         uint price = oraclize.getPrice(datasource);
603         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
604         bytes memory args = stra2cbor(argN);
605         return oraclize.queryN.value(price)(0, datasource, args);
606     }
607     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
608         uint price = oraclize.getPrice(datasource);
609         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
610         bytes memory args = stra2cbor(argN);
611         return oraclize.queryN.value(price)(timestamp, datasource, args);
612     }
613     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
614         uint price = oraclize.getPrice(datasource, gaslimit);
615         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
616         bytes memory args = stra2cbor(argN);
617         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
618     }
619     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
620         uint price = oraclize.getPrice(datasource, gaslimit);
621         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
622         bytes memory args = stra2cbor(argN);
623         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
624     }
625     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
626         string[] memory dynargs = new string[](1);
627         dynargs[0] = args[0];
628         return oraclize_query(datasource, dynargs);
629     }
630     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
631         string[] memory dynargs = new string[](1);
632         dynargs[0] = args[0];
633         return oraclize_query(timestamp, datasource, dynargs);
634     }
635     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
636         string[] memory dynargs = new string[](1);
637         dynargs[0] = args[0];
638         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
639     }
640     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
641         string[] memory dynargs = new string[](1);
642         dynargs[0] = args[0];
643         return oraclize_query(datasource, dynargs, gaslimit);
644     }
645 
646     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
647         string[] memory dynargs = new string[](2);
648         dynargs[0] = args[0];
649         dynargs[1] = args[1];
650         return oraclize_query(datasource, dynargs);
651     }
652     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
653         string[] memory dynargs = new string[](2);
654         dynargs[0] = args[0];
655         dynargs[1] = args[1];
656         return oraclize_query(timestamp, datasource, dynargs);
657     }
658     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
659         string[] memory dynargs = new string[](2);
660         dynargs[0] = args[0];
661         dynargs[1] = args[1];
662         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
663     }
664     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
665         string[] memory dynargs = new string[](2);
666         dynargs[0] = args[0];
667         dynargs[1] = args[1];
668         return oraclize_query(datasource, dynargs, gaslimit);
669     }
670     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
671         string[] memory dynargs = new string[](3);
672         dynargs[0] = args[0];
673         dynargs[1] = args[1];
674         dynargs[2] = args[2];
675         return oraclize_query(datasource, dynargs);
676     }
677     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
678         string[] memory dynargs = new string[](3);
679         dynargs[0] = args[0];
680         dynargs[1] = args[1];
681         dynargs[2] = args[2];
682         return oraclize_query(timestamp, datasource, dynargs);
683     }
684     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
685         string[] memory dynargs = new string[](3);
686         dynargs[0] = args[0];
687         dynargs[1] = args[1];
688         dynargs[2] = args[2];
689         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
690     }
691     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
692         string[] memory dynargs = new string[](3);
693         dynargs[0] = args[0];
694         dynargs[1] = args[1];
695         dynargs[2] = args[2];
696         return oraclize_query(datasource, dynargs, gaslimit);
697     }
698 
699     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
700         string[] memory dynargs = new string[](4);
701         dynargs[0] = args[0];
702         dynargs[1] = args[1];
703         dynargs[2] = args[2];
704         dynargs[3] = args[3];
705         return oraclize_query(datasource, dynargs);
706     }
707     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
708         string[] memory dynargs = new string[](4);
709         dynargs[0] = args[0];
710         dynargs[1] = args[1];
711         dynargs[2] = args[2];
712         dynargs[3] = args[3];
713         return oraclize_query(timestamp, datasource, dynargs);
714     }
715     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
716         string[] memory dynargs = new string[](4);
717         dynargs[0] = args[0];
718         dynargs[1] = args[1];
719         dynargs[2] = args[2];
720         dynargs[3] = args[3];
721         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
722     }
723     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
724         string[] memory dynargs = new string[](4);
725         dynargs[0] = args[0];
726         dynargs[1] = args[1];
727         dynargs[2] = args[2];
728         dynargs[3] = args[3];
729         return oraclize_query(datasource, dynargs, gaslimit);
730     }
731     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
732         string[] memory dynargs = new string[](5);
733         dynargs[0] = args[0];
734         dynargs[1] = args[1];
735         dynargs[2] = args[2];
736         dynargs[3] = args[3];
737         dynargs[4] = args[4];
738         return oraclize_query(datasource, dynargs);
739     }
740     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
741         string[] memory dynargs = new string[](5);
742         dynargs[0] = args[0];
743         dynargs[1] = args[1];
744         dynargs[2] = args[2];
745         dynargs[3] = args[3];
746         dynargs[4] = args[4];
747         return oraclize_query(timestamp, datasource, dynargs);
748     }
749     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
750         string[] memory dynargs = new string[](5);
751         dynargs[0] = args[0];
752         dynargs[1] = args[1];
753         dynargs[2] = args[2];
754         dynargs[3] = args[3];
755         dynargs[4] = args[4];
756         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
757     }
758     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
759         string[] memory dynargs = new string[](5);
760         dynargs[0] = args[0];
761         dynargs[1] = args[1];
762         dynargs[2] = args[2];
763         dynargs[3] = args[3];
764         dynargs[4] = args[4];
765         return oraclize_query(datasource, dynargs, gaslimit);
766     }
767     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
768         uint price = oraclize.getPrice(datasource);
769         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
770         bytes memory args = ba2cbor(argN);
771         return oraclize.queryN.value(price)(0, datasource, args);
772     }
773     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
774         uint price = oraclize.getPrice(datasource);
775         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
776         bytes memory args = ba2cbor(argN);
777         return oraclize.queryN.value(price)(timestamp, datasource, args);
778     }
779     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
780         uint price = oraclize.getPrice(datasource, gaslimit);
781         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
782         bytes memory args = ba2cbor(argN);
783         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
784     }
785     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
786         uint price = oraclize.getPrice(datasource, gaslimit);
787         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
788         bytes memory args = ba2cbor(argN);
789         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
790     }
791     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
792         bytes[] memory dynargs = new bytes[](1);
793         dynargs[0] = args[0];
794         return oraclize_query(datasource, dynargs);
795     }
796     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
797         bytes[] memory dynargs = new bytes[](1);
798         dynargs[0] = args[0];
799         return oraclize_query(timestamp, datasource, dynargs);
800     }
801     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
802         bytes[] memory dynargs = new bytes[](1);
803         dynargs[0] = args[0];
804         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
805     }
806     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
807         bytes[] memory dynargs = new bytes[](1);
808         dynargs[0] = args[0];
809         return oraclize_query(datasource, dynargs, gaslimit);
810     }
811 
812     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
813         bytes[] memory dynargs = new bytes[](2);
814         dynargs[0] = args[0];
815         dynargs[1] = args[1];
816         return oraclize_query(datasource, dynargs);
817     }
818     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
819         bytes[] memory dynargs = new bytes[](2);
820         dynargs[0] = args[0];
821         dynargs[1] = args[1];
822         return oraclize_query(timestamp, datasource, dynargs);
823     }
824     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
825         bytes[] memory dynargs = new bytes[](2);
826         dynargs[0] = args[0];
827         dynargs[1] = args[1];
828         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
829     }
830     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
831         bytes[] memory dynargs = new bytes[](2);
832         dynargs[0] = args[0];
833         dynargs[1] = args[1];
834         return oraclize_query(datasource, dynargs, gaslimit);
835     }
836     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
837         bytes[] memory dynargs = new bytes[](3);
838         dynargs[0] = args[0];
839         dynargs[1] = args[1];
840         dynargs[2] = args[2];
841         return oraclize_query(datasource, dynargs);
842     }
843     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
844         bytes[] memory dynargs = new bytes[](3);
845         dynargs[0] = args[0];
846         dynargs[1] = args[1];
847         dynargs[2] = args[2];
848         return oraclize_query(timestamp, datasource, dynargs);
849     }
850     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
851         bytes[] memory dynargs = new bytes[](3);
852         dynargs[0] = args[0];
853         dynargs[1] = args[1];
854         dynargs[2] = args[2];
855         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
856     }
857     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
858         bytes[] memory dynargs = new bytes[](3);
859         dynargs[0] = args[0];
860         dynargs[1] = args[1];
861         dynargs[2] = args[2];
862         return oraclize_query(datasource, dynargs, gaslimit);
863     }
864 
865     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
866         bytes[] memory dynargs = new bytes[](4);
867         dynargs[0] = args[0];
868         dynargs[1] = args[1];
869         dynargs[2] = args[2];
870         dynargs[3] = args[3];
871         return oraclize_query(datasource, dynargs);
872     }
873     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
874         bytes[] memory dynargs = new bytes[](4);
875         dynargs[0] = args[0];
876         dynargs[1] = args[1];
877         dynargs[2] = args[2];
878         dynargs[3] = args[3];
879         return oraclize_query(timestamp, datasource, dynargs);
880     }
881     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
882         bytes[] memory dynargs = new bytes[](4);
883         dynargs[0] = args[0];
884         dynargs[1] = args[1];
885         dynargs[2] = args[2];
886         dynargs[3] = args[3];
887         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
888     }
889     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
890         bytes[] memory dynargs = new bytes[](4);
891         dynargs[0] = args[0];
892         dynargs[1] = args[1];
893         dynargs[2] = args[2];
894         dynargs[3] = args[3];
895         return oraclize_query(datasource, dynargs, gaslimit);
896     }
897     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
898         bytes[] memory dynargs = new bytes[](5);
899         dynargs[0] = args[0];
900         dynargs[1] = args[1];
901         dynargs[2] = args[2];
902         dynargs[3] = args[3];
903         dynargs[4] = args[4];
904         return oraclize_query(datasource, dynargs);
905     }
906     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
907         bytes[] memory dynargs = new bytes[](5);
908         dynargs[0] = args[0];
909         dynargs[1] = args[1];
910         dynargs[2] = args[2];
911         dynargs[3] = args[3];
912         dynargs[4] = args[4];
913         return oraclize_query(timestamp, datasource, dynargs);
914     }
915     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
916         bytes[] memory dynargs = new bytes[](5);
917         dynargs[0] = args[0];
918         dynargs[1] = args[1];
919         dynargs[2] = args[2];
920         dynargs[3] = args[3];
921         dynargs[4] = args[4];
922         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
923     }
924     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
925         bytes[] memory dynargs = new bytes[](5);
926         dynargs[0] = args[0];
927         dynargs[1] = args[1];
928         dynargs[2] = args[2];
929         dynargs[3] = args[3];
930         dynargs[4] = args[4];
931         return oraclize_query(datasource, dynargs, gaslimit);
932     }
933 
934     function oraclize_cbAddress() oraclizeAPI internal returns (address){
935         return oraclize.cbAddress();
936     }
937     function oraclize_setProof(byte proofP) oraclizeAPI internal {
938         return oraclize.setProofType(proofP);
939     }
940     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
941         return oraclize.setCustomGasPrice(gasPrice);
942     }
943     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
944         return oraclize.setConfig(config);
945     }
946 
947     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
948         return oraclize.randomDS_getSessionPubKeyHash();
949     }
950 
951     function getCodeSize(address _addr) constant internal returns(uint _size) {
952         assembly {
953             _size := extcodesize(_addr)
954         }
955     }
956 
957     function parseAddr(string _a) internal returns (address){
958         bytes memory tmp = bytes(_a);
959         uint160 iaddr = 0;
960         uint160 b1;
961         uint160 b2;
962         for (uint i=2; i<2+2*20; i+=2){
963             iaddr *= 256;
964             b1 = uint160(tmp[i]);
965             b2 = uint160(tmp[i+1]);
966             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
967             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
968             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
969             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
970             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
971             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
972             iaddr += (b1*16+b2);
973         }
974         return address(iaddr);
975     }
976 
977     function strCompare(string _a, string _b) internal returns (int) {
978         bytes memory a = bytes(_a);
979         bytes memory b = bytes(_b);
980         uint minLength = a.length;
981         if (b.length < minLength) minLength = b.length;
982         for (uint i = 0; i < minLength; i ++)
983             if (a[i] < b[i])
984                 return -1;
985             else if (a[i] > b[i])
986                 return 1;
987         if (a.length < b.length)
988             return -1;
989         else if (a.length > b.length)
990             return 1;
991         else
992             return 0;
993     }
994 
995     function indexOf(string _haystack, string _needle) internal returns (int) {
996         bytes memory h = bytes(_haystack);
997         bytes memory n = bytes(_needle);
998         if(h.length < 1 || n.length < 1 || (n.length > h.length))
999             return -1;
1000         else if(h.length > (2**128 -1))
1001             return -1;
1002         else
1003         {
1004             uint subindex = 0;
1005             for (uint i = 0; i < h.length; i ++)
1006             {
1007                 if (h[i] == n[0])
1008                 {
1009                     subindex = 1;
1010                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1011                     {
1012                         subindex++;
1013                     }
1014                     if(subindex == n.length)
1015                         return int(i);
1016                 }
1017             }
1018             return -1;
1019         }
1020     }
1021 
1022     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1023         bytes memory _ba = bytes(_a);
1024         bytes memory _bb = bytes(_b);
1025         bytes memory _bc = bytes(_c);
1026         bytes memory _bd = bytes(_d);
1027         bytes memory _be = bytes(_e);
1028         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1029         bytes memory babcde = bytes(abcde);
1030         uint k = 0;
1031         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1032         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1033         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1034         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1035         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1036         return string(babcde);
1037     }
1038 
1039     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1040         return strConcat(_a, _b, _c, _d, "");
1041     }
1042 
1043     function strConcat(string _a, string _b, string _c) internal returns (string) {
1044         return strConcat(_a, _b, _c, "", "");
1045     }
1046 
1047     function strConcat(string _a, string _b) internal returns (string) {
1048         return strConcat(_a, _b, "", "", "");
1049     }
1050 
1051     // parseInt
1052     function parseInt(string _a) internal returns (uint) {
1053         return parseInt(_a, 0);
1054     }
1055 
1056     // parseInt(parseFloat*10^_b)
1057     function parseInt(string _a, uint _b) internal returns (uint) {
1058         bytes memory bresult = bytes(_a);
1059         uint mint = 0;
1060         bool decimals = false;
1061         for (uint i=0; i<bresult.length; i++){
1062             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1063                 if (decimals){
1064                    if (_b == 0) break;
1065                     else _b--;
1066                 }
1067                 mint *= 10;
1068                 mint += uint(bresult[i]) - 48;
1069             } else if (bresult[i] == 46) decimals = true;
1070         }
1071         if (_b > 0) mint *= 10**_b;
1072         return mint;
1073     }
1074 
1075     function uint2str(uint i) internal returns (string){
1076         if (i == 0) return "0";
1077         uint j = i;
1078         uint len;
1079         while (j != 0){
1080             len++;
1081             j /= 10;
1082         }
1083         bytes memory bstr = new bytes(len);
1084         uint k = len - 1;
1085         while (i != 0){
1086             bstr[k--] = byte(48 + i % 10);
1087             i /= 10;
1088         }
1089         return string(bstr);
1090     }
1091 
1092     function stra2cbor(string[] arr) internal returns (bytes) {
1093             uint arrlen = arr.length;
1094 
1095             // get correct cbor output length
1096             uint outputlen = 0;
1097             bytes[] memory elemArray = new bytes[](arrlen);
1098             for (uint i = 0; i < arrlen; i++) {
1099                 elemArray[i] = (bytes(arr[i]));
1100                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1101             }
1102             uint ctr = 0;
1103             uint cborlen = arrlen + 0x80;
1104             outputlen += byte(cborlen).length;
1105             bytes memory res = new bytes(outputlen);
1106 
1107             while (byte(cborlen).length > ctr) {
1108                 res[ctr] = byte(cborlen)[ctr];
1109                 ctr++;
1110             }
1111             for (i = 0; i < arrlen; i++) {
1112                 res[ctr] = 0x5F;
1113                 ctr++;
1114                 for (uint x = 0; x < elemArray[i].length; x++) {
1115                     // if there's a bug with larger strings, this may be the culprit
1116                     if (x % 23 == 0) {
1117                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1118                         elemcborlen += 0x40;
1119                         uint lctr = ctr;
1120                         while (byte(elemcborlen).length > ctr - lctr) {
1121                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1122                             ctr++;
1123                         }
1124                     }
1125                     res[ctr] = elemArray[i][x];
1126                     ctr++;
1127                 }
1128                 res[ctr] = 0xFF;
1129                 ctr++;
1130             }
1131             return res;
1132         }
1133 
1134     function ba2cbor(bytes[] arr) internal returns (bytes) {
1135             uint arrlen = arr.length;
1136 
1137             // get correct cbor output length
1138             uint outputlen = 0;
1139             bytes[] memory elemArray = new bytes[](arrlen);
1140             for (uint i = 0; i < arrlen; i++) {
1141                 elemArray[i] = (bytes(arr[i]));
1142                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1143             }
1144             uint ctr = 0;
1145             uint cborlen = arrlen + 0x80;
1146             outputlen += byte(cborlen).length;
1147             bytes memory res = new bytes(outputlen);
1148 
1149             while (byte(cborlen).length > ctr) {
1150                 res[ctr] = byte(cborlen)[ctr];
1151                 ctr++;
1152             }
1153             for (i = 0; i < arrlen; i++) {
1154                 res[ctr] = 0x5F;
1155                 ctr++;
1156                 for (uint x = 0; x < elemArray[i].length; x++) {
1157                     // if there's a bug with larger strings, this may be the culprit
1158                     if (x % 23 == 0) {
1159                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1160                         elemcborlen += 0x40;
1161                         uint lctr = ctr;
1162                         while (byte(elemcborlen).length > ctr - lctr) {
1163                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1164                             ctr++;
1165                         }
1166                     }
1167                     res[ctr] = elemArray[i][x];
1168                     ctr++;
1169                 }
1170                 res[ctr] = 0xFF;
1171                 ctr++;
1172             }
1173             return res;
1174         }
1175 
1176 
1177     string oraclize_network_name;
1178     function oraclize_setNetworkName(string _network_name) internal {
1179         oraclize_network_name = _network_name;
1180     }
1181 
1182     function oraclize_getNetworkName() internal returns (string) {
1183         return oraclize_network_name;
1184     }
1185 
1186     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1187         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1188         bytes memory nbytes = new bytes(1);
1189         nbytes[0] = byte(_nbytes);
1190         bytes memory unonce = new bytes(32);
1191         bytes memory sessionKeyHash = new bytes(32);
1192         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1193         assembly {
1194             mstore(unonce, 0x20)
1195             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1196             mstore(sessionKeyHash, 0x20)
1197             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1198         }
1199         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
1200         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
1201         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
1202         return queryId;
1203     }
1204 
1205     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1206         oraclize_randomDS_args[queryId] = commitment;
1207     }
1208 
1209     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1210     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1211 
1212     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1213         bool sigok;
1214         address signer;
1215 
1216         bytes32 sigr;
1217         bytes32 sigs;
1218 
1219         bytes memory sigr_ = new bytes(32);
1220         uint offset = 4+(uint(dersig[3]) - 0x20);
1221         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1222         bytes memory sigs_ = new bytes(32);
1223         offset += 32 + 2;
1224         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1225 
1226         assembly {
1227             sigr := mload(add(sigr_, 32))
1228             sigs := mload(add(sigs_, 32))
1229         }
1230 
1231 
1232         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1233         if (address(sha3(pubkey)) == signer) return true;
1234         else {
1235             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1236             return (address(sha3(pubkey)) == signer);
1237         }
1238     }
1239 
1240     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1241         bool sigok;
1242 
1243         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1244         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1245         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1246 
1247         bytes memory appkey1_pubkey = new bytes(64);
1248         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1249 
1250         bytes memory tosign2 = new bytes(1+65+32);
1251         tosign2[0] = 1; //role
1252         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1253         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1254         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1255         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1256 
1257         if (sigok == false) return false;
1258 
1259 
1260         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1261         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1262 
1263         bytes memory tosign3 = new bytes(1+65);
1264         tosign3[0] = 0xFE;
1265         copyBytes(proof, 3, 65, tosign3, 1);
1266 
1267         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1268         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1269 
1270         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1271 
1272         return sigok;
1273     }
1274 
1275     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1276         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1277         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1278 
1279         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1280         if (proofVerified == false) throw;
1281 
1282         _;
1283     }
1284 
1285     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1286         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1287         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1288 
1289         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1290         if (proofVerified == false) return 2;
1291 
1292         return 0;
1293     }
1294 
1295     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
1296         bool match_ = true;
1297 
1298         for (var i=0; i<prefix.length; i++){
1299             if (content[i] != prefix[i]) match_ = false;
1300         }
1301 
1302         return match_;
1303     }
1304 
1305     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1306         bool checkok;
1307 
1308 
1309         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1310         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1311         bytes memory keyhash = new bytes(32);
1312         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1313         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
1314         if (checkok == false) return false;
1315 
1316         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1317         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1318 
1319 
1320         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1321         checkok = matchBytes32Prefix(sha256(sig1), result);
1322         if (checkok == false) return false;
1323 
1324 
1325         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1326         // This is to verify that the computed args match with the ones specified in the query.
1327         bytes memory commitmentSlice1 = new bytes(8+1+32);
1328         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1329 
1330         bytes memory sessionPubkey = new bytes(64);
1331         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1332         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1333 
1334         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1335         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1336             delete oraclize_randomDS_args[queryId];
1337         } else return false;
1338 
1339 
1340         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1341         bytes memory tosign1 = new bytes(32+8+1+32);
1342         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1343         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
1344         if (checkok == false) return false;
1345 
1346         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1347         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1348             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1349         }
1350 
1351         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1352     }
1353 
1354 
1355     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1356     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1357         uint minLength = length + toOffset;
1358 
1359         if (to.length < minLength) {
1360             // Buffer too small
1361             throw; // Should be a better way?
1362         }
1363 
1364         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1365         uint i = 32 + fromOffset;
1366         uint j = 32 + toOffset;
1367 
1368         while (i < (32 + fromOffset + length)) {
1369             assembly {
1370                 let tmp := mload(add(from, i))
1371                 mstore(add(to, j), tmp)
1372             }
1373             i += 32;
1374             j += 32;
1375         }
1376 
1377         return to;
1378     }
1379 
1380     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1381     // Duplicate Solidity's ecrecover, but catching the CALL return value
1382     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1383         // We do our own memory management here. Solidity uses memory offset
1384         // 0x40 to store the current end of memory. We write past it (as
1385         // writes are memory extensions), but don't update the offset so
1386         // Solidity will reuse it. The memory used here is only needed for
1387         // this context.
1388 
1389         // FIXME: inline assembly can't access return values
1390         bool ret;
1391         address addr;
1392 
1393         assembly {
1394             let size := mload(0x40)
1395             mstore(size, hash)
1396             mstore(add(size, 32), v)
1397             mstore(add(size, 64), r)
1398             mstore(add(size, 96), s)
1399 
1400             // NOTE: we can reuse the request memory because we deal with
1401             //       the return code
1402             ret := call(3000, 1, 0, size, 128, size, 32)
1403             addr := mload(size)
1404         }
1405 
1406         return (ret, addr);
1407     }
1408 
1409     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1410     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1411         bytes32 r;
1412         bytes32 s;
1413         uint8 v;
1414 
1415         if (sig.length != 65)
1416           return (false, 0);
1417 
1418         // The signature format is a compact form of:
1419         //   {bytes32 r}{bytes32 s}{uint8 v}
1420         // Compact means, uint8 is not padded to 32 bytes.
1421         assembly {
1422             r := mload(add(sig, 32))
1423             s := mload(add(sig, 64))
1424 
1425             // Here we are loading the last 32 bytes. We exploit the fact that
1426             // 'mload' will pad with zeroes if we overread.
1427             // There is no 'mload8' to do this, but that would be nicer.
1428             v := byte(0, mload(add(sig, 96)))
1429 
1430             // Alternative solution:
1431             // 'byte' is not working due to the Solidity parser, so lets
1432             // use the second best option, 'and'
1433             // v := and(mload(add(sig, 65)), 255)
1434         }
1435 
1436         // albeit non-transactional signatures are not specified by the YP, one would expect it
1437         // to match the YP range of [27, 28]
1438         //
1439         // geth uses [0, 1] and some clients have followed. This might change, see:
1440         //  https://github.com/ethereum/go-ethereum/issues/2053
1441         if (v < 27)
1442           v += 27;
1443 
1444         if (v != 27 && v != 28)
1445             return (false, 0);
1446 
1447         return safer_ecrecover(hash, v, r, s);
1448     }
1449 
1450 }
1451 // </ORACLIZE_API>
1452 
1453 contract FlightDelayOraclizeInterface is usingOraclize {
1454 
1455     modifier onlyOraclizeOr (address _emergency) {
1456 // --> prod-mode
1457         require(msg.sender == oraclize_cbAddress() || msg.sender == _emergency);
1458 // <-- prod-mode
1459         _;
1460     }
1461 }
1462 
1463 contract ConvertLib {
1464 
1465     // .. since beginning of the year
1466     uint16[12] days_since = [
1467         11,
1468         42,
1469         70,
1470         101,
1471         131,
1472         162,
1473         192,
1474         223,
1475         254,
1476         284,
1477         315,
1478         345
1479     ];
1480 
1481     function b32toString(bytes32 x) internal returns (string) {
1482         // gas usage: about 1K gas per char.
1483         bytes memory bytesString = new bytes(32);
1484         uint charCount = 0;
1485 
1486         for (uint j = 0; j < 32; j++) {
1487             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
1488             if (char != 0) {
1489                 bytesString[charCount] = char;
1490                 charCount++;
1491             }
1492         }
1493 
1494         bytes memory bytesStringTrimmed = new bytes(charCount);
1495 
1496         for (j = 0; j < charCount; j++) {
1497             bytesStringTrimmed[j] = bytesString[j];
1498         }
1499 
1500         return string(bytesStringTrimmed);
1501     }
1502 
1503     function b32toHexString(bytes32 x) returns (string) {
1504         bytes memory b = new bytes(64);
1505         for (uint i = 0; i < 32; i++) {
1506             uint8 by = uint8(uint(x) / (2**(8*(31 - i))));
1507             uint8 high = by/16;
1508             uint8 low = by - 16*high;
1509             if (high > 9) {
1510                 high += 39;
1511             }
1512             if (low > 9) {
1513                 low += 39;
1514             }
1515             b[2*i] = byte(high+48);
1516             b[2*i+1] = byte(low+48);
1517         }
1518 
1519         return string(b);
1520     }
1521 
1522     function parseInt(string _a) internal returns (uint) {
1523         return parseInt(_a, 0);
1524     }
1525 
1526     // parseInt(parseFloat*10^_b)
1527     function parseInt(string _a, uint _b) internal returns (uint) {
1528         bytes memory bresult = bytes(_a);
1529         uint mint = 0;
1530         bool decimals = false;
1531         for (uint i = 0; i<bresult.length; i++) {
1532             if ((bresult[i] >= 48)&&(bresult[i] <= 57)) {
1533                 if (decimals) {
1534                     if (_b == 0) {
1535                         break;
1536                     } else {
1537                         _b--;
1538                     }
1539                 }
1540                 mint *= 10;
1541                 mint += uint(bresult[i]) - 48;
1542             } else if (bresult[i] == 46) {
1543                 decimals = true;
1544             }
1545         }
1546         if (_b > 0) {
1547             mint *= 10**_b;
1548         }
1549         return mint;
1550     }
1551 
1552     // the following function yields correct results in the time between 1.3.2016 and 28.02.2020,
1553     // so within the validity of the contract its correct.
1554     function toUnixtime(bytes32 _dayMonthYear) constant returns (uint unixtime) {
1555         // _day_month_year = /dep/2016/09/10
1556         bytes memory bDmy = bytes(b32toString(_dayMonthYear));
1557         bytes memory temp2 = bytes(new string(2));
1558         bytes memory temp4 = bytes(new string(4));
1559 
1560         temp4[0] = bDmy[5];
1561         temp4[1] = bDmy[6];
1562         temp4[2] = bDmy[7];
1563         temp4[3] = bDmy[8];
1564         uint year = parseInt(string(temp4));
1565 
1566         temp2[0] = bDmy[10];
1567         temp2[1] = bDmy[11];
1568         uint month = parseInt(string(temp2));
1569 
1570         temp2[0] = bDmy[13];
1571         temp2[1] = bDmy[14];
1572         uint day = parseInt(string(temp2));
1573 
1574         unixtime = ((year - 1970) * 365 + days_since[month-1] + day) * 86400;
1575     }
1576 }
1577 
1578 library strings {
1579     struct slice {
1580         uint _len;
1581         uint _ptr;
1582     }
1583 
1584     function memcpy(uint dest, uint src, uint len) private {
1585         // Copy word-length chunks while possible
1586         for(; len >= 32; len -= 32) {
1587             assembly {
1588                 mstore(dest, mload(src))
1589             }
1590             dest += 32;
1591             src += 32;
1592         }
1593 
1594         // Copy remaining bytes
1595         uint mask = 256 ** (32 - len) - 1;
1596         assembly {
1597             let srcpart := and(mload(src), not(mask))
1598             let destpart := and(mload(dest), mask)
1599             mstore(dest, or(destpart, srcpart))
1600         }
1601     }
1602 
1603     /*
1604      * @dev Returns a slice containing the entire string.
1605      * @param self The string to make a slice from.
1606      * @return A newly allocated slice containing the entire string.
1607      */
1608     function toSlice(string self) internal returns (slice) {
1609         uint ptr;
1610         assembly {
1611             ptr := add(self, 0x20)
1612         }
1613         return slice(bytes(self).length, ptr);
1614     }
1615 
1616     /*
1617      * @dev Returns the length of a null-terminated bytes32 string.
1618      * @param self The value to find the length of.
1619      * @return The length of the string, from 0 to 32.
1620      */
1621     function len(bytes32 self) internal returns (uint) {
1622         uint ret;
1623         if (self == 0)
1624             return 0;
1625         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1626             ret += 16;
1627             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1628         }
1629         if (self & 0xffffffffffffffff == 0) {
1630             ret += 8;
1631             self = bytes32(uint(self) / 0x10000000000000000);
1632         }
1633         if (self & 0xffffffff == 0) {
1634             ret += 4;
1635             self = bytes32(uint(self) / 0x100000000);
1636         }
1637         if (self & 0xffff == 0) {
1638             ret += 2;
1639             self = bytes32(uint(self) / 0x10000);
1640         }
1641         if (self & 0xff == 0) {
1642             ret += 1;
1643         }
1644         return 32 - ret;
1645     }
1646 
1647     /*
1648      * @dev Returns a slice containing the entire bytes32, interpreted as a
1649      *      null-termintaed utf-8 string.
1650      * @param self The bytes32 value to convert to a slice.
1651      * @return A new slice containing the value of the input argument up to the
1652      *         first null.
1653      */
1654     function toSliceB32(bytes32 self) internal returns (slice ret) {
1655         // Allocate space for `self` in memory, copy it there, and point ret at it
1656         assembly {
1657             let ptr := mload(0x40)
1658             mstore(0x40, add(ptr, 0x20))
1659             mstore(ptr, self)
1660             mstore(add(ret, 0x20), ptr)
1661         }
1662         ret._len = len(self);
1663     }
1664 
1665     /*
1666      * @dev Returns a new slice containing the same data as the current slice.
1667      * @param self The slice to copy.
1668      * @return A new slice containing the same data as `self`.
1669      */
1670     function copy(slice self) internal returns (slice) {
1671         return slice(self._len, self._ptr);
1672     }
1673 
1674     /*
1675      * @dev Copies a slice to a new string.
1676      * @param self The slice to copy.
1677      * @return A newly allocated string containing the slice's text.
1678      */
1679     function toString(slice self) internal returns (string) {
1680         var ret = new string(self._len);
1681         uint retptr;
1682         assembly { retptr := add(ret, 32) }
1683 
1684         memcpy(retptr, self._ptr, self._len);
1685         return ret;
1686     }
1687 
1688     /*
1689      * @dev Returns the length in runes of the slice. Note that this operation
1690      *      takes time proportional to the length of the slice; avoid using it
1691      *      in loops, and call `slice.empty()` if you only need to know whether
1692      *      the slice is empty or not.
1693      * @param self The slice to operate on.
1694      * @return The length of the slice in runes.
1695      */
1696     function len(slice self) internal returns (uint) {
1697         // Starting at ptr-31 means the LSB will be the byte we care about
1698         var ptr = self._ptr - 31;
1699         var end = ptr + self._len;
1700         for (uint len = 0; ptr < end; len++) {
1701             uint8 b;
1702             assembly { b := and(mload(ptr), 0xFF) }
1703             if (b < 0x80) {
1704                 ptr += 1;
1705             } else if(b < 0xE0) {
1706                 ptr += 2;
1707             } else if(b < 0xF0) {
1708                 ptr += 3;
1709             } else if(b < 0xF8) {
1710                 ptr += 4;
1711             } else if(b < 0xFC) {
1712                 ptr += 5;
1713             } else {
1714                 ptr += 6;
1715             }
1716         }
1717         return len;
1718     }
1719 
1720     /*
1721      * @dev Returns true if the slice is empty (has a length of 0).
1722      * @param self The slice to operate on.
1723      * @return True if the slice is empty, False otherwise.
1724      */
1725     function empty(slice self) internal returns (bool) {
1726         return self._len == 0;
1727     }
1728 
1729     /*
1730      * @dev Returns a positive number if `other` comes lexicographically after
1731      *      `self`, a negative number if it comes before, or zero if the
1732      *      contents of the two slices are equal. Comparison is done per-rune,
1733      *      on unicode codepoints.
1734      * @param self The first slice to compare.
1735      * @param other The second slice to compare.
1736      * @return The result of the comparison.
1737      */
1738     function compare(slice self, slice other) internal returns (int) {
1739         uint shortest = self._len;
1740         if (other._len < self._len)
1741             shortest = other._len;
1742 
1743         var selfptr = self._ptr;
1744         var otherptr = other._ptr;
1745         for (uint idx = 0; idx < shortest; idx += 32) {
1746             uint a;
1747             uint b;
1748             assembly {
1749                 a := mload(selfptr)
1750                 b := mload(otherptr)
1751             }
1752             if (a != b) {
1753                 // Mask out irrelevant bytes and check again
1754                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1755                 var diff = (a & mask) - (b & mask);
1756                 if (diff != 0)
1757                     return int(diff);
1758             }
1759             selfptr += 32;
1760             otherptr += 32;
1761         }
1762         return int(self._len) - int(other._len);
1763     }
1764 
1765     /*
1766      * @dev Returns true if the two slices contain the same text.
1767      * @param self The first slice to compare.
1768      * @param self The second slice to compare.
1769      * @return True if the slices are equal, false otherwise.
1770      */
1771     function equals(slice self, slice other) internal returns (bool) {
1772         return compare(self, other) == 0;
1773     }
1774 
1775     /*
1776      * @dev Extracts the first rune in the slice into `rune`, advancing the
1777      *      slice to point to the next rune and returning `self`.
1778      * @param self The slice to operate on.
1779      * @param rune The slice that will contain the first rune.
1780      * @return `rune`.
1781      */
1782     function nextRune(slice self, slice rune) internal returns (slice) {
1783         rune._ptr = self._ptr;
1784 
1785         if (self._len == 0) {
1786             rune._len = 0;
1787             return rune;
1788         }
1789 
1790         uint len;
1791         uint b;
1792         // Load the first byte of the rune into the LSBs of b
1793         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1794         if (b < 0x80) {
1795             len = 1;
1796         } else if(b < 0xE0) {
1797             len = 2;
1798         } else if(b < 0xF0) {
1799             len = 3;
1800         } else {
1801             len = 4;
1802         }
1803 
1804         // Check for truncated codepoints
1805         if (len > self._len) {
1806             rune._len = self._len;
1807             self._ptr += self._len;
1808             self._len = 0;
1809             return rune;
1810         }
1811 
1812         self._ptr += len;
1813         self._len -= len;
1814         rune._len = len;
1815         return rune;
1816     }
1817 
1818     /*
1819      * @dev Returns the first rune in the slice, advancing the slice to point
1820      *      to the next rune.
1821      * @param self The slice to operate on.
1822      * @return A slice containing only the first rune from `self`.
1823      */
1824     function nextRune(slice self) internal returns (slice ret) {
1825         nextRune(self, ret);
1826     }
1827 
1828     /*
1829      * @dev Returns the number of the first codepoint in the slice.
1830      * @param self The slice to operate on.
1831      * @return The number of the first codepoint in the slice.
1832      */
1833     function ord(slice self) internal returns (uint ret) {
1834         if (self._len == 0) {
1835             return 0;
1836         }
1837 
1838         uint word;
1839         uint len;
1840         uint div = 2 ** 248;
1841 
1842         // Load the rune into the MSBs of b
1843         assembly { word:= mload(mload(add(self, 32))) }
1844         var b = word / div;
1845         if (b < 0x80) {
1846             ret = b;
1847             len = 1;
1848         } else if(b < 0xE0) {
1849             ret = b & 0x1F;
1850             len = 2;
1851         } else if(b < 0xF0) {
1852             ret = b & 0x0F;
1853             len = 3;
1854         } else {
1855             ret = b & 0x07;
1856             len = 4;
1857         }
1858 
1859         // Check for truncated codepoints
1860         if (len > self._len) {
1861             return 0;
1862         }
1863 
1864         for (uint i = 1; i < len; i++) {
1865             div = div / 256;
1866             b = (word / div) & 0xFF;
1867             if (b & 0xC0 != 0x80) {
1868                 // Invalid UTF-8 sequence
1869                 return 0;
1870             }
1871             ret = (ret * 64) | (b & 0x3F);
1872         }
1873 
1874         return ret;
1875     }
1876 
1877     /*
1878      * @dev Returns the keccak-256 hash of the slice.
1879      * @param self The slice to hash.
1880      * @return The hash of the slice.
1881      */
1882     function keccak(slice self) internal returns (bytes32 ret) {
1883         assembly {
1884             ret := sha3(mload(add(self, 32)), mload(self))
1885         }
1886     }
1887 
1888     /*
1889      * @dev Returns true if `self` starts with `needle`.
1890      * @param self The slice to operate on.
1891      * @param needle The slice to search for.
1892      * @return True if the slice starts with the provided text, false otherwise.
1893      */
1894     function startsWith(slice self, slice needle) internal returns (bool) {
1895         if (self._len < needle._len) {
1896             return false;
1897         }
1898 
1899         if (self._ptr == needle._ptr) {
1900             return true;
1901         }
1902 
1903         bool equal;
1904         assembly {
1905             let len := mload(needle)
1906             let selfptr := mload(add(self, 0x20))
1907             let needleptr := mload(add(needle, 0x20))
1908             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1909         }
1910         return equal;
1911     }
1912 
1913     /*
1914      * @dev If `self` starts with `needle`, `needle` is removed from the
1915      *      beginning of `self`. Otherwise, `self` is unmodified.
1916      * @param self The slice to operate on.
1917      * @param needle The slice to search for.
1918      * @return `self`
1919      */
1920     function beyond(slice self, slice needle) internal returns (slice) {
1921         if (self._len < needle._len) {
1922             return self;
1923         }
1924 
1925         bool equal = true;
1926         if (self._ptr != needle._ptr) {
1927             assembly {
1928                 let len := mload(needle)
1929                 let selfptr := mload(add(self, 0x20))
1930                 let needleptr := mload(add(needle, 0x20))
1931                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1932             }
1933         }
1934 
1935         if (equal) {
1936             self._len -= needle._len;
1937             self._ptr += needle._len;
1938         }
1939 
1940         return self;
1941     }
1942 
1943     /*
1944      * @dev Returns true if the slice ends with `needle`.
1945      * @param self The slice to operate on.
1946      * @param needle The slice to search for.
1947      * @return True if the slice starts with the provided text, false otherwise.
1948      */
1949     function endsWith(slice self, slice needle) internal returns (bool) {
1950         if (self._len < needle._len) {
1951             return false;
1952         }
1953 
1954         var selfptr = self._ptr + self._len - needle._len;
1955 
1956         if (selfptr == needle._ptr) {
1957             return true;
1958         }
1959 
1960         bool equal;
1961         assembly {
1962             let len := mload(needle)
1963             let needleptr := mload(add(needle, 0x20))
1964             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1965         }
1966 
1967         return equal;
1968     }
1969 
1970     /*
1971      * @dev If `self` ends with `needle`, `needle` is removed from the
1972      *      end of `self`. Otherwise, `self` is unmodified.
1973      * @param self The slice to operate on.
1974      * @param needle The slice to search for.
1975      * @return `self`
1976      */
1977     function until(slice self, slice needle) internal returns (slice) {
1978         if (self._len < needle._len) {
1979             return self;
1980         }
1981 
1982         var selfptr = self._ptr + self._len - needle._len;
1983         bool equal = true;
1984         if (selfptr != needle._ptr) {
1985             assembly {
1986                 let len := mload(needle)
1987                 let needleptr := mload(add(needle, 0x20))
1988                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
1989             }
1990         }
1991 
1992         if (equal) {
1993             self._len -= needle._len;
1994         }
1995 
1996         return self;
1997     }
1998 
1999     // Returns the memory address of the first byte of the first occurrence of
2000     // `needle` in `self`, or the first byte after `self` if not found.
2001     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
2002         uint ptr;
2003         uint idx;
2004 
2005         if (needlelen <= selflen) {
2006             if (needlelen <= 32) {
2007                 // Optimized assembly for 68 gas per byte on short strings
2008                 assembly {
2009                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
2010                     let needledata := and(mload(needleptr), mask)
2011                     let end := add(selfptr, sub(selflen, needlelen))
2012                     ptr := selfptr
2013                     loop:
2014                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
2015                     ptr := add(ptr, 1)
2016                     jumpi(loop, lt(sub(ptr, 1), end))
2017                     ptr := add(selfptr, selflen)
2018                     exit:
2019                 }
2020                 return ptr;
2021             } else {
2022                 // For long needles, use hashing
2023                 bytes32 hash;
2024                 assembly { hash := sha3(needleptr, needlelen) }
2025                 ptr = selfptr;
2026                 for (idx = 0; idx <= selflen - needlelen; idx++) {
2027                     bytes32 testHash;
2028                     assembly { testHash := sha3(ptr, needlelen) }
2029                     if (hash == testHash)
2030                         return ptr;
2031                     ptr += 1;
2032                 }
2033             }
2034         }
2035         return selfptr + selflen;
2036     }
2037 
2038     // Returns the memory address of the first byte after the last occurrence of
2039     // `needle` in `self`, or the address of `self` if not found.
2040     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
2041         uint ptr;
2042 
2043         if (needlelen <= selflen) {
2044             if (needlelen <= 32) {
2045                 // Optimized assembly for 69 gas per byte on short strings
2046                 assembly {
2047                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
2048                     let needledata := and(mload(needleptr), mask)
2049                     ptr := add(selfptr, sub(selflen, needlelen))
2050                     loop:
2051                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
2052                     ptr := sub(ptr, 1)
2053                     jumpi(loop, gt(add(ptr, 1), selfptr))
2054                     ptr := selfptr
2055                     jump(exit)
2056                     ret:
2057                     ptr := add(ptr, needlelen)
2058                     exit:
2059                 }
2060                 return ptr;
2061             } else {
2062                 // For long needles, use hashing
2063                 bytes32 hash;
2064                 assembly { hash := sha3(needleptr, needlelen) }
2065                 ptr = selfptr + (selflen - needlelen);
2066                 while (ptr >= selfptr) {
2067                     bytes32 testHash;
2068                     assembly { testHash := sha3(ptr, needlelen) }
2069                     if (hash == testHash)
2070                         return ptr + needlelen;
2071                     ptr -= 1;
2072                 }
2073             }
2074         }
2075         return selfptr;
2076     }
2077 
2078     /*
2079      * @dev Modifies `self` to contain everything from the first occurrence of
2080      *      `needle` to the end of the slice. `self` is set to the empty slice
2081      *      if `needle` is not found.
2082      * @param self The slice to search and modify.
2083      * @param needle The text to search for.
2084      * @return `self`.
2085      */
2086     function find(slice self, slice needle) internal returns (slice) {
2087         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2088         self._len -= ptr - self._ptr;
2089         self._ptr = ptr;
2090         return self;
2091     }
2092 
2093     /*
2094      * @dev Modifies `self` to contain the part of the string from the start of
2095      *      `self` to the end of the first occurrence of `needle`. If `needle`
2096      *      is not found, `self` is set to the empty slice.
2097      * @param self The slice to search and modify.
2098      * @param needle The text to search for.
2099      * @return `self`.
2100      */
2101     function rfind(slice self, slice needle) internal returns (slice) {
2102         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2103         self._len = ptr - self._ptr;
2104         return self;
2105     }
2106 
2107     /*
2108      * @dev Splits the slice, setting `self` to everything after the first
2109      *      occurrence of `needle`, and `token` to everything before it. If
2110      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2111      *      and `token` is set to the entirety of `self`.
2112      * @param self The slice to split.
2113      * @param needle The text to search for in `self`.
2114      * @param token An output parameter to which the first token is written.
2115      * @return `token`.
2116      */
2117     function split(slice self, slice needle, slice token) internal returns (slice) {
2118         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2119         token._ptr = self._ptr;
2120         token._len = ptr - self._ptr;
2121         if (ptr == self._ptr + self._len) {
2122             // Not found
2123             self._len = 0;
2124         } else {
2125             self._len -= token._len + needle._len;
2126             self._ptr = ptr + needle._len;
2127         }
2128         return token;
2129     }
2130 
2131     /*
2132      * @dev Splits the slice, setting `self` to everything after the first
2133      *      occurrence of `needle`, and returning everything before it. If
2134      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2135      *      and the entirety of `self` is returned.
2136      * @param self The slice to split.
2137      * @param needle The text to search for in `self`.
2138      * @return The part of `self` up to the first occurrence of `delim`.
2139      */
2140     function split(slice self, slice needle) internal returns (slice token) {
2141         split(self, needle, token);
2142     }
2143 
2144     /*
2145      * @dev Splits the slice, setting `self` to everything before the last
2146      *      occurrence of `needle`, and `token` to everything after it. If
2147      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2148      *      and `token` is set to the entirety of `self`.
2149      * @param self The slice to split.
2150      * @param needle The text to search for in `self`.
2151      * @param token An output parameter to which the first token is written.
2152      * @return `token`.
2153      */
2154     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
2155         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2156         token._ptr = ptr;
2157         token._len = self._len - (ptr - self._ptr);
2158         if (ptr == self._ptr) {
2159             // Not found
2160             self._len = 0;
2161         } else {
2162             self._len -= token._len + needle._len;
2163         }
2164         return token;
2165     }
2166 
2167     /*
2168      * @dev Splits the slice, setting `self` to everything before the last
2169      *      occurrence of `needle`, and returning everything after it. If
2170      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2171      *      and the entirety of `self` is returned.
2172      * @param self The slice to split.
2173      * @param needle The text to search for in `self`.
2174      * @return The part of `self` after the last occurrence of `delim`.
2175      */
2176     function rsplit(slice self, slice needle) internal returns (slice token) {
2177         rsplit(self, needle, token);
2178     }
2179 
2180     /*
2181      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
2182      * @param self The slice to search.
2183      * @param needle The text to search for in `self`.
2184      * @return The number of occurrences of `needle` found in `self`.
2185      */
2186     function count(slice self, slice needle) internal returns (uint count) {
2187         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
2188         while (ptr <= self._ptr + self._len) {
2189             count++;
2190             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
2191         }
2192     }
2193 
2194     /*
2195      * @dev Returns True if `self` contains `needle`.
2196      * @param self The slice to search.
2197      * @param needle The text to search for in `self`.
2198      * @return True if `needle` is found in `self`, false otherwise.
2199      */
2200     function contains(slice self, slice needle) internal returns (bool) {
2201         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
2202     }
2203 
2204     /*
2205      * @dev Returns a newly allocated string containing the concatenation of
2206      *      `self` and `other`.
2207      * @param self The first slice to concatenate.
2208      * @param other The second slice to concatenate.
2209      * @return The concatenation of the two strings.
2210      */
2211     function concat(slice self, slice other) internal returns (string) {
2212         var ret = new string(self._len + other._len);
2213         uint retptr;
2214         assembly { retptr := add(ret, 32) }
2215         memcpy(retptr, self._ptr, self._len);
2216         memcpy(retptr + self._len, other._ptr, other._len);
2217         return ret;
2218     }
2219 
2220     /*
2221      * @dev Joins an array of slices, using `self` as a delimiter, returning a
2222      *      newly allocated string.
2223      * @param self The delimiter to use.
2224      * @param parts A list of slices to join.
2225      * @return A newly allocated string containing all the slices in `parts`,
2226      *         joined with `self`.
2227      */
2228     function join(slice self, slice[] parts) internal returns (string) {
2229         if (parts.length == 0)
2230             return "";
2231 
2232         uint len = self._len * (parts.length - 1);
2233         for(uint i = 0; i < parts.length; i++)
2234             len += parts[i]._len;
2235 
2236         var ret = new string(len);
2237         uint retptr;
2238         assembly { retptr := add(ret, 32) }
2239 
2240         for(i = 0; i < parts.length; i++) {
2241             memcpy(retptr, parts[i]._ptr, parts[i]._len);
2242             retptr += parts[i]._len;
2243             if (i < parts.length - 1) {
2244                 memcpy(retptr, self._ptr, self._len);
2245                 retptr += self._len;
2246             }
2247         }
2248 
2249         return ret;
2250     }
2251 }
2252 
2253 contract FlightDelayPayout is FlightDelayControlledContract, FlightDelayConstants, FlightDelayOraclizeInterface, ConvertLib {
2254 
2255     using strings for *;
2256 
2257     FlightDelayDatabaseInterface FD_DB;
2258     FlightDelayLedgerInterface FD_LG;
2259     FlightDelayAccessControllerInterface FD_AC;
2260 
2261     /*
2262      * @dev Contract constructor sets its controller
2263      * @param _controller FD.Controller
2264      */
2265     function FlightDelayPayout(address _controller) {
2266         setController(_controller);
2267     }
2268 
2269     /*
2270      * Public methods
2271      */
2272 
2273     /*
2274      * @dev Set access permissions for methods
2275      */
2276     function setContracts() public onlyController {
2277         FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));
2278         FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));
2279         FD_LG = FlightDelayLedgerInterface(getContract("FD.Ledger"));
2280 
2281         FD_AC.setPermissionById(101, "FD.Underwrite");
2282         FD_AC.setPermissionById(101, "FD.Payout");
2283         FD_AC.setPermissionById(102, "FD.Funder");
2284     }
2285 
2286     /*
2287      * @dev Fund contract
2288      */
2289     function fund() payable {
2290         require(FD_AC.checkPermission(102, msg.sender));
2291 
2292         // todo: bookkeeping
2293         // todo: fire funding event
2294     }
2295 
2296     /*
2297      * @dev Schedule oraclize call for payout
2298      * @param _policyId
2299      * @param _riskId
2300      * @param _oraclizeTime
2301      */
2302     function schedulePayoutOraclizeCall(uint _policyId, bytes32 _riskId, uint _oraclizeTime) public {
2303         require(FD_AC.checkPermission(101, msg.sender));
2304 
2305         var (carrierFlightNumber, departureYearMonthDay,) = FD_DB.getRiskParameters(_riskId);
2306 
2307         string memory oraclizeUrl = strConcat(
2308             ORACLIZE_STATUS_BASE_URL,
2309             b32toString(carrierFlightNumber),
2310             b32toString(departureYearMonthDay),
2311             ORACLIZE_STATUS_QUERY
2312         );
2313 
2314         bytes32 queryId = oraclize_query(
2315             _oraclizeTime,
2316             "nested",
2317             oraclizeUrl,
2318             ORACLIZE_GAS
2319         );
2320 
2321         FD_DB.createOraclizeCallback(
2322             queryId,
2323             _policyId,
2324             oraclizeState.ForPayout,
2325             _oraclizeTime
2326         );
2327 
2328         LogOraclizeCall(_policyId, queryId, oraclizeUrl, _oraclizeTime);
2329     }
2330 
2331     /*
2332      * @dev Oraclize callback. In an emergency case, we can call this directly from FD.Emergency Account.
2333      * @param _queryId
2334      * @param _result
2335      * @param _proof
2336      */
2337     function __callback(bytes32 _queryId, string _result, bytes _proof) public onlyOraclizeOr(getContract('FD.Emergency')) {
2338 
2339         var (policyId, oraclizeTime) = FD_DB.getOraclizeCallback(_queryId);
2340         LogOraclizeCallback(policyId, _queryId, _result, _proof);
2341 
2342         // check if policy was declined after this callback was scheduled
2343         var state = FD_DB.getPolicyState(policyId);
2344         require(uint8(state) != 5);
2345 
2346         bytes32 riskId = FD_DB.getRiskId(policyId);
2347 
2348 // --> debug-mode
2349 //            LogBytes32("riskId", riskId);
2350 // <-- debug-mode
2351 
2352         var slResult = _result.toSlice();
2353 
2354         if (bytes(_result).length == 0) { // empty Result
2355             if (FD_DB.checkTime(_queryId, riskId, 180 minutes)) {
2356                 LogPolicyManualPayout(policyId, "No Callback at +120 min");
2357                 return;
2358             } else {
2359                 schedulePayoutOraclizeCall(policyId, riskId, oraclizeTime + 45 minutes);
2360             }
2361         } else {
2362             // first check status
2363             // extract the status field:
2364             slResult.find("\"".toSlice()).beyond("\"".toSlice());
2365             slResult.until(slResult.copy().find("\"".toSlice()));
2366             bytes1 status = bytes(slResult.toString())[0];	// s = L
2367             if (status == "C") {
2368                 // flight cancelled --> payout
2369                 payOut(policyId, 4, 0);
2370                 return;
2371             } else if (status == "D") {
2372                 // flight diverted --> payout
2373                 payOut(policyId, 5, 0);
2374                 return;
2375             } else if (status != "L" && status != "A" && status != "C" && status != "D") {
2376                 LogPolicyManualPayout(policyId, "Unprocessable status");
2377                 return;
2378             }
2379 
2380             // process the rest of the response:
2381             slResult = _result.toSlice();
2382             bool arrived = slResult.contains("actualGateArrival".toSlice());
2383 
2384             if (status == "A" || (status == "L" && !arrived)) {
2385                 // flight still active or not at gate --> reschedule
2386                 if (FD_DB.checkTime(_queryId, riskId, 180 minutes)) {
2387                     LogPolicyManualPayout(policyId, "No arrival at +180 min");
2388                 } else {
2389                     schedulePayoutOraclizeCall(policyId, riskId, oraclizeTime + 45 minutes);
2390                 }
2391             } else if (status == "L" && arrived) {
2392                 var aG = "\"arrivalGateDelayMinutes\": ".toSlice();
2393                 if (slResult.contains(aG)) {
2394                     slResult.find(aG).beyond(aG);
2395                     slResult.until(slResult.copy().find("\"".toSlice()).beyond("\"".toSlice()));
2396                     // truffle bug, replace by "}" as soon as it is fixed.
2397                     slResult.until(slResult.copy().find("\x7D".toSlice()));
2398                     slResult.until(slResult.copy().find(",".toSlice()));
2399                     uint delayInMinutes = parseInt(slResult.toString());
2400                 } else {
2401                     delayInMinutes = 0;
2402                 }
2403 
2404                 if (delayInMinutes < 15) {
2405                     payOut(policyId, 0, 0);
2406                 } else if (delayInMinutes < 30) {
2407                     payOut(policyId, 1, delayInMinutes);
2408                 } else if (delayInMinutes < 45) {
2409                     payOut(policyId, 2, delayInMinutes);
2410                 } else {
2411                     payOut(policyId, 3, delayInMinutes);
2412                 }
2413             } else { // no delay info
2414                 payOut(policyId, 0, 0);
2415             }
2416         }
2417     }
2418 
2419     /*
2420      * Internal methods
2421      */
2422 
2423     /*
2424      * @dev Payout
2425      * @param _policyId
2426      * @param _delay
2427      * @param _delayInMinutes
2428      */
2429     function payOut(uint _policyId, uint8 _delay, uint _delayInMinutes)	internal {
2430 // --> debug-mode
2431 //            LogString("im payOut", "");
2432 //            LogUint("policyId", _policyId);
2433 //            LogUint("delay", _delay);
2434 //            LogUint("in minutes", _delayInMinutes);
2435 // <-- debug-mode
2436 
2437         FD_DB.setDelay(_policyId, _delay, _delayInMinutes);
2438 
2439         if (_delay == 0) {
2440             FD_DB.setState(
2441                 _policyId,
2442                 policyState.Expired,
2443                 now,
2444                 "Expired - no delay!"
2445             );
2446         } else {
2447             var (customer, weight, premium) = FD_DB.getPolicyData(_policyId);
2448 
2449 // --> debug-mode
2450 //                LogUint("weight", weight);
2451 // <-- debug-mode
2452 
2453             if (weight == 0) {
2454                 weight = 20000;
2455             }
2456 
2457             uint payout = premium * WEIGHT_PATTERN[_delay] * 10000 / weight;
2458             uint calculatedPayout = payout;
2459 
2460             if (payout > MAX_PAYOUT) {
2461                 payout = MAX_PAYOUT;
2462             }
2463 
2464             FD_DB.setPayouts(_policyId, calculatedPayout, payout);
2465 
2466             if (!FD_LG.sendFunds(customer, Acc.Payout, payout)) {
2467                 FD_DB.setState(
2468                     _policyId,
2469                     policyState.SendFailed,
2470                     now,
2471                     "Payout, send failed!"
2472                 );
2473 
2474                 FD_DB.setPayouts(_policyId, calculatedPayout, 0);
2475             } else {
2476                 FD_DB.setState(
2477                     _policyId,
2478                     policyState.PaidOut,
2479                     now,
2480                     "Payout successful!"
2481                 );
2482             }
2483         }
2484     }
2485 }