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
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Owned {
18 
19     address public owner;
20 
21     /**
22      * @dev The Owned constructor sets the original `owner` of the contract to the sender
23      * account.
24      */
25     function Owned() {
26         owner = msg.sender;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(owner == msg.sender);
34         _;
35     }
36 }
37 
38 contract FlightDelayControllerInterface {
39 
40     function isOwner(address _addr) returns (bool _isOwner);
41 
42     function selfRegister(bytes32 _id) returns (bool result);
43 
44     function getContract(bytes32 _id) returns (address _addr);
45 }
46 
47 contract FlightDelayDatabaseModel {
48 
49     // Ledger accounts.
50     enum Acc {
51         Premium,      // 0
52         RiskFund,     // 1
53         Payout,       // 2
54         Balance,      // 3
55         Reward,       // 4
56         OraclizeCosts // 5
57     }
58 
59     // policy Status Codes and meaning:
60     //
61     // 00 = Applied:	  the customer has payed a premium, but the oracle has
62     //					        not yet checked and confirmed.
63     //					        The customer can still revoke the policy.
64     // 01 = Accepted:	  the oracle has checked and confirmed.
65     //					        The customer can still revoke the policy.
66     // 02 = Revoked:	  The customer has revoked the policy.
67     //					        The premium minus cancellation fee is payed back to the
68     //					        customer by the oracle.
69     // 03 = PaidOut:	  The flight has ended with delay.
70     //					        The oracle has checked and payed out.
71     // 04 = Expired:	  The flight has endet with <15min. delay.
72     //					        No payout.
73     // 05 = Declined:	  The application was invalid.
74     //					        The premium minus cancellation fee is payed back to the
75     //					        customer by the oracle.
76     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
77     //					        for unknown reasons.
78     //					        The funds remain in the contracts RiskFund.
79 
80 
81     //                   00       01        02       03        04      05           06
82     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
83 
84     // oraclize callback types:
85     enum oraclizeState { ForUnderwriting, ForPayout }
86 
87     //               00   01   02   03
88     enum Currency { ETH, EUR, USD, GBP }
89 
90     // the policy structure: this structure keeps track of the individual parameters of a policy.
91     // typically customer address, premium and some status information.
92     struct Policy {
93         // 0 - the customer
94         address customer;
95 
96         // 1 - premium
97         uint premium;
98         // risk specific parameters:
99         // 2 - pointer to the risk in the risks mapping
100         bytes32 riskId;
101         // custom payout pattern
102         // in future versions, customer will be able to tamper with this array.
103         // to keep things simple, we have decided to hard-code the array for all policies.
104         // uint8[5] pattern;
105         // 3 - probability weight. this is the central parameter
106         uint weight;
107         // 4 - calculated Payout
108         uint calculatedPayout;
109         // 5 - actual Payout
110         uint actualPayout;
111 
112         // status fields:
113         // 6 - the state of the policy
114         policyState state;
115         // 7 - time of last state change
116         uint stateTime;
117         // 8 - state change message/reason
118         bytes32 stateMessage;
119         // 9 - TLSNotary Proof
120         bytes proof;
121         // 10 - Currency
122         Currency currency;
123         // 10 - External customer id
124         bytes32 customerExternalId;
125     }
126 
127     // the risk structure; this structure keeps track of the risk-
128     // specific parameters.
129     // several policies can share the same risk structure (typically
130     // some people flying with the same plane)
131     struct Risk {
132         // 0 - Airline Code + FlightNumber
133         bytes32 carrierFlightNumber;
134         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
135         bytes32 departureYearMonthDay;
136         // 2 - the inital arrival time
137         uint arrivalTime;
138         // 3 - the final delay in minutes
139         uint delayInMinutes;
140         // 4 - the determined delay category (0-5)
141         uint8 delay;
142         // 5 - we limit the cumulated weighted premium to avoid cluster risks
143         uint cumulatedWeightedPremium;
144         // 6 - max cumulated Payout for this risk
145         uint premiumMultiplier;
146     }
147 
148     // the oraclize callback structure: we use several oraclize calls.
149     // all oraclize calls will result in a common callback to __callback(...).
150     // to keep track of the different querys we have to introduce this struct.
151     struct OraclizeCallback {
152         // for which policy have we called?
153         uint policyId;
154         // for which purpose did we call? {ForUnderwrite | ForPayout}
155         oraclizeState oState;
156         // time
157         uint oraclizeTime;
158     }
159 
160     struct Customer {
161         bytes32 customerExternalId;
162         bool identityConfirmed;
163     }
164 }
165 
166 contract FlightDelayConstants {
167 
168     /*
169     * General events
170     */
171 
172 // --> test-mode
173 //        event LogUint(string _message, uint _uint);
174 //        event LogUintEth(string _message, uint ethUint);
175 //        event LogUintTime(string _message, uint timeUint);
176 //        event LogInt(string _message, int _int);
177 //        event LogAddress(string _message, address _address);
178 //        event LogBytes32(string _message, bytes32 hexBytes32);
179 //        event LogBytes(string _message, bytes hexBytes);
180 //        event LogBytes32Str(string _message, bytes32 strBytes32);
181 //        event LogString(string _message, string _string);
182 //        event LogBool(string _message, bool _bool);
183 //        event Log(address);
184 // <-- test-mode
185 
186     event LogPolicyApplied(
187         uint _policyId,
188         address _customer,
189         bytes32 strCarrierFlightNumber,
190         uint ethPremium
191     );
192     event LogPolicyAccepted(
193         uint _policyId,
194         uint _statistics0,
195         uint _statistics1,
196         uint _statistics2,
197         uint _statistics3,
198         uint _statistics4,
199         uint _statistics5
200     );
201     event LogPolicyPaidOut(
202         uint _policyId,
203         uint ethAmount
204     );
205     event LogPolicyExpired(
206         uint _policyId
207     );
208     event LogPolicyDeclined(
209         uint _policyId,
210         bytes32 strReason
211     );
212     event LogPolicyManualPayout(
213         uint _policyId,
214         bytes32 strReason
215     );
216     event LogSendFunds(
217         address _recipient,
218         uint8 _from,
219         uint ethAmount
220     );
221     event LogReceiveFunds(
222         address _sender,
223         uint8 _to,
224         uint ethAmount
225     );
226     event LogSendFail(
227         uint _policyId,
228         bytes32 strReason
229     );
230     event LogOraclizeCall(
231         uint _policyId,
232         bytes32 hexQueryId,
233         string _oraclizeUrl
234     );
235     event LogOraclizeCallback(
236         uint _policyId,
237         bytes32 hexQueryId,
238         string _result,
239         bytes hexProof
240     );
241     event LogSetState(
242         uint _policyId,
243         uint8 _policyState,
244         uint _stateTime,
245         bytes32 _stateMessage
246     );
247     event LogExternal(
248         uint256 _policyId,
249         address _address,
250         bytes32 _externalId
251     );
252 
253     /*
254     * General constants
255     */
256 
257     // minimum observations for valid prediction
258     uint constant MIN_OBSERVATIONS = 10;
259     // minimum premium to cover costs
260     uint constant MIN_PREMIUM = 50 finney;
261     // maximum premium
262     uint constant MAX_PREMIUM = 1 ether;
263     // maximum payout
264     uint constant MAX_PAYOUT = 1100 finney;
265 
266     uint constant MIN_PREMIUM_EUR = 1500 wei;
267     uint constant MAX_PREMIUM_EUR = 29000 wei;
268     uint constant MAX_PAYOUT_EUR = 30000 wei;
269 
270     uint constant MIN_PREMIUM_USD = 1700 wei;
271     uint constant MAX_PREMIUM_USD = 34000 wei;
272     uint constant MAX_PAYOUT_USD = 35000 wei;
273 
274     uint constant MIN_PREMIUM_GBP = 1300 wei;
275     uint constant MAX_PREMIUM_GBP = 25000 wei;
276     uint constant MAX_PAYOUT_GBP = 270 wei;
277 
278     // maximum cumulated weighted premium per risk
279     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 300 ether;
280     // 1 percent for DAO, 1 percent for maintainer
281     uint8 constant REWARD_PERCENT = 2;
282     // reserve for tail risks
283     uint8 constant RESERVE_PERCENT = 1;
284     // the weight pattern; in future versions this may become part of the policy struct.
285     // currently can't be constant because of compiler restrictions
286     // WEIGHT_PATTERN[0] is not used, just to be consistent
287     uint8[6] WEIGHT_PATTERN = [
288         0,
289         10,
290         20,
291         30,
292         50,
293         50
294     ];
295 
296 // --> prod-mode
297     // DEFINITIONS FOR ROPSTEN AND MAINNET
298     // minimum time before departure for applying
299     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
300     // check for delay after .. minutes after scheduled arrival
301     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
302 // <-- prod-mode
303 
304 // --> test-mode
305 //        // DEFINITIONS FOR LOCAL TESTNET
306 //        // minimum time before departure for applying
307 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
308 //        // check for delay after .. minutes after scheduled arrival
309 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
310 // <-- test-mode
311 
312     // maximum duration of flight
313     uint constant MAX_FLIGHT_DURATION = 2 days;
314     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
315     uint constant CONTRACT_DEAD_LINE = 1922396399;
316 
317     uint constant MIN_DEPARTURE_LIM = 1508198400;
318 
319     uint constant MAX_DEPARTURE_LIM = 1509494400;
320 
321     // gas Constants for oraclize
322     uint constant ORACLIZE_GAS = 1000000;
323 
324 
325     /*
326     * URLs and query strings for oraclize
327     */
328 
329 // --> prod-mode
330     // DEFINITIONS FOR ROPSTEN AND MAINNET
331     string constant ORACLIZE_RATINGS_BASE_URL =
332         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
333         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
334     string constant ORACLIZE_RATINGS_QUERY =
335         "?${[decrypt] <!--PUT ENCRYPTED_QUERY HERE--> }).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
336     string constant ORACLIZE_STATUS_BASE_URL =
337         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
338         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
339     string constant ORACLIZE_STATUS_QUERY =
340         // pattern:
341         "?${[decrypt] <!--PUT ENCRYPTED_QUERY HERE--> }&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
342 // <-- prod-mode
343 
344 // --> test-mode
345 //        // DEFINITIONS FOR LOCAL TESTNET
346 //        string constant ORACLIZE_RATINGS_BASE_URL =
347 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
348 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
349 //        string constant ORACLIZE_RATINGS_QUERY =
350 //            // for testrpc:
351 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode']";
352 //        string constant ORACLIZE_STATUS_BASE_URL =
353 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
354 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
355 //        string constant ORACLIZE_STATUS_QUERY =
356 //            // for testrpc:
357 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
358 // <-- test-mode
359 }
360 
361 
362 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
363 
364     address public controller;
365     FlightDelayControllerInterface FD_CI;
366 
367     modifier onlyController() {
368         require(msg.sender == controller);
369         _;
370     }
371 
372     function setController(address _controller) internal returns (bool _result) {
373         controller = _controller;
374         FD_CI = FlightDelayControllerInterface(_controller);
375         _result = true;
376     }
377 
378     function destruct() onlyController {
379         selfdestruct(controller);
380     }
381 
382     function setContracts() onlyController {}
383 
384     function getContract(bytes32 _id) internal returns (address _addr) {
385         _addr = FD_CI.getContract(_id);
386     }
387 }
388 
389 contract FlightDelayController is Owned, FlightDelayConstants {
390 
391     struct Controller {
392         address addr;
393         bool isControlled;
394         bool isInitialized;
395     }
396 
397     mapping (bytes32 => Controller) public contracts;
398     bytes32[] public contractIds;
399 
400     /**
401     * Constructor.
402     */
403     function FlightDelayController() {
404         registerContract(owner, "FD.Owner", false);
405         registerContract(address(this), "FD.Controller", false);
406     }
407 
408     /**
409      * @dev Allows the current owner to transfer control of the contract to a newOwner.
410      * @param _newOwner The address to transfer ownership to.
411      */
412     function transferOwnership(address _newOwner) onlyOwner {
413         require(_newOwner != address(0));
414         owner = _newOwner;
415         setContract(_newOwner, "FD.Owner", false);
416     }
417 
418     /**
419     * Store address of one contract in mapping.
420     * @param _addr       Address of contract
421     * @param _id         ID of contract
422     */
423     function setContract(address _addr, bytes32 _id, bool _isControlled) internal {
424         contracts[_id].addr = _addr;
425         contracts[_id].isControlled = _isControlled;
426     }
427 
428     /**
429     * Get contract address from ID. This function is called by the
430     * contract's setContracts function.
431     * @param _id         ID of contract
432     * @return The address of the contract.
433     */
434     function getContract(bytes32 _id) returns (address _addr) {
435         _addr = contracts[_id].addr;
436     }
437 
438     /**
439     * Registration of contracts.
440     * It will only accept calls of deployments initiated by the owner.
441     * @param _id         ID of contract
442     * @return  bool        success
443     */
444     function registerContract(address _addr, bytes32 _id, bool _isControlled) onlyOwner returns (bool _result) {
445         setContract(_addr, _id, _isControlled);
446         contractIds.push(_id);
447         _result = true;
448     }
449 
450     /**
451     * Deregister a contract.
452     * In future, contracts should be exchangeable.
453     * @param _id         ID of contract
454     * @return  bool        success
455     */
456     function deregister(bytes32 _id) onlyOwner returns (bool _result) {
457         if (getContract(_id) == 0x0) {
458             return false;
459         }
460         setContract(0x0, _id, false);
461         _result = true;
462     }
463 
464     /**
465     * After deploying all contracts, this function is called and calls
466     * setContracts() for every registered contract.
467     * This call pulls the addresses of the needed contracts in the respective contract.
468     * We assume that contractIds.length is small, so this won't run out of gas.
469     */
470     function setAllContracts() onlyOwner {
471         FlightDelayControlledContract controlledContract;
472         // TODO: Check for upper bound for i
473         // i = 0 is FD.Owner, we skip this. // check!
474         for (uint i = 0; i < contractIds.length; i++) {
475             if (contracts[contractIds[i]].isControlled == true) {
476                 controlledContract = FlightDelayControlledContract(contracts[contractIds[i]].addr);
477                 controlledContract.setContracts();
478             }
479         }
480     }
481 
482     function setOneContract(uint i) onlyOwner {
483         FlightDelayControlledContract controlledContract;
484         // TODO: Check for upper bound for i
485         controlledContract = FlightDelayControlledContract(contracts[contractIds[i]].addr);
486         controlledContract.setContracts();
487     }
488 
489     /**
490     * Destruct one contract.
491     * @param _id         ID of contract to destroy.
492     */
493     function destructOne(bytes32 _id) onlyOwner {
494         address addr = getContract(_id);
495         if (addr != 0x0) {
496             FlightDelayControlledContract(addr).destruct();
497         }
498     }
499 
500     /**
501     * Destruct all contracts.
502     * We assume that contractIds.length is small, so this won't run out of gas.
503     * Otherwise, you can still destroy one contract after the other with destructOne.
504     */
505     function destructAll() onlyOwner {
506         // TODO: Check for upper bound for i
507         for (uint i = 0; i < contractIds.length; i++) {
508             if (contracts[contractIds[i]].isControlled == true) {
509                 destructOne(contractIds[i]);
510             }
511         }
512 
513         selfdestruct(owner);
514     }
515 }