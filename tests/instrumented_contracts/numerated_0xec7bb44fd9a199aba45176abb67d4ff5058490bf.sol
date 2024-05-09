1 pragma solidity 0.5.10;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31      * @dev Multiplies two unsigned integers, reverts on overflow.
32      */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49      */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Adds two unsigned integers, reverts on overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81      * reverts when dividing by zero.
82      */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 /**
90  * @title PayableOwnable
91  * @dev The PayableOwnable contract has an owner address, and provides basic authorization control
92  * functions, this simplifies the implementation of "user permissions".
93  * PayableOwnable is extended from open-zeppelin Ownable smart contract, with the difference of making the owner
94  * a payable address.
95  */
96 contract PayableOwnable {
97     address payable internal _owner;
98 
99     event OwnershipTransferred(
100         address indexed previousOwner,
101         address indexed newOwner
102     );
103 
104     /**
105      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
106      * account.
107      */
108     constructor() internal {
109         _owner = msg.sender;
110         emit OwnershipTransferred(address(0), _owner);
111     }
112 
113     /**
114      * @return the address of the owner.
115      */
116     function owner() public view returns (address payable) {
117         return _owner;
118     }
119 
120     /**
121      * @dev Throws if called by any account other than the owner.
122      */
123     modifier onlyOwner() {
124         require(isOwner());
125         _;
126     }
127 
128     /**
129      * @return true if `msg.sender` is the owner of the contract.
130      */
131     function isOwner() public view returns (bool) {
132         return msg.sender == _owner;
133     }
134 
135     /**
136      * @dev Allows the current owner to relinquish control of the contract.
137      * @notice Renouncing to ownership will leave the contract without an owner.
138      * It will not be possible to call the functions with the `onlyOwner`
139      * modifier anymore.
140      */
141     function renounceOwnership() public onlyOwner {
142         emit OwnershipTransferred(_owner, address(0));
143         _owner = address(0);
144     }
145 
146     /**
147      * @dev Allows the current owner to transfer control of the contract to a newOwner.
148      * @param newOwner The address to transfer ownership to.
149      */
150     function transferOwnership(address payable newOwner) public onlyOwner {
151         _transferOwnership(newOwner);
152     }
153 
154     /**
155      * @dev Transfers control of the contract to a newOwner.
156      * @param newOwner The address to transfer ownership to.
157      */
158     function _transferOwnership(address payable newOwner) internal {
159         require(newOwner != address(0));
160         emit OwnershipTransferred(_owner, newOwner);
161         _owner = newOwner;
162     }
163 }
164 
165 /// @title PumaPay Pull Payment V2.1 - Contract that facilitates our pull payment protocol
166 /// V2.1 of the protocol removes the notion of the `pull payment executors` i.e. the addresses
167 /// that can execute a pull payment `executePullPayment()`. That function is now publicly available.
168 /// We are also changing the `pullPayments` mapping. Instead of having address -> address -> PullPayment,
169 /// ot will be address -> bytes32 -> PullPayment, with bytes32 being the pull payment ID.
170 /// @author PumaPay Dev Team - <developers@pumapay.io>
171 contract PumaPayPullPaymentV2_2 is PayableOwnable {
172     using SafeMath for uint256;
173     /// ===============================================================================================================
174     ///                                      Events
175     /// ===============================================================================================================
176     event LogExecutorAdded(address executor);
177     event LogExecutorRemoved(address executor);
178     event LogSmartContractActorFunded(string actorRole, address actor, uint256 timestamp);
179     event LogPaymentRegistered(
180         address customerAddress,
181         bytes32 paymentID,
182         bytes32 businessID,
183         bytes32 uniqueReferenceID
184     );
185     event LogPaymentCancelled(
186         address customerAddress,
187         bytes32 paymentID,
188         bytes32 businessID,
189         bytes32 uniqueReferenceID
190     );
191     event LogPullPaymentExecuted(
192         address customerAddress,
193         bytes32 paymentID,
194         bytes32 businessID,
195         bytes32 uniqueReferenceID,
196         uint256 amountInPMA,
197         uint256 conversionRate
198     );
199     /// ===============================================================================================================
200     ///                                      Constants
201     /// ===============================================================================================================
202 
203     uint256 constant private RATE_CALCULATION_NUMBER = 10 ** 26;    /// Check `calculatePMAFromFiat()` for more details
204     uint256 constant private OVERFLOW_LIMITER_NUMBER = 10 ** 20;    /// 1e^20 - Prevent numeric overflows
205     /// @dev The following variables are not needed any more, but are kept hre for clarity on the calculation that
206     /// is being done for the PMA to Fiat from rate.
207     /// uint256 constant private DECIMAL_FIXER = 10 ** 10; /// 1e^10 - This transforms the Rate from decimals to uint256
208     /// uint256 constant private FIAT_TO_CENT_FIXER = 100; /// Fiat currencies have 100 cents in 1 basic monetary unit.
209     uint256 constant private ONE_ETHER = 1 ether;                                  /// PumaPay token has 18 decimals - same as one ETHER
210     uint256 constant private FUNDING_AMOUNT = 0.5 ether;                           /// Amount to transfer to owner/executor
211     uint256 constant private MINIMUM_AMOUNT_OF_ETH_FOR_OPERATORS = 0.15 ether;     /// min amount of ETH for owner/executor
212     bytes32 constant private TYPE_SINGLE_PULL_PAYMENT = "2";
213     bytes32 constant private TYPE_RECURRING_PULL_PAYMENT = "3";
214     bytes32 constant private TYPE_RECURRING_PULL_PAYMENT_WITH_INITIAL = "4";
215     bytes32 constant private TYPE_PULL_PAYMENT_WITH_FREE_TRIAL = "5";
216     bytes32 constant private TYPE_PULL_PAYMENT_WITH_PAID_TRIAL = "6";
217     bytes32 constant private TYPE_SINGLE_DYNAMIC_PULL_PAYMENT = "7";
218     bytes32 constant private EMPTY_BYTES32 = "";
219     /// ===============================================================================================================
220     ///                                      Members
221     /// ===============================================================================================================
222     IERC20 public token;
223     mapping(address => bool) public executors;
224     mapping(bytes32 => PullPayment) public pullPayments;
225 
226     struct PullPayment {
227         bytes32[3] paymentIds;                  /// [0] paymentID / [1] businessID / [2] uniqueReferenceID
228         bytes32 paymentType;                    /// Type of Pull Payment - must be one of the defined pull payment types
229         string currency;                        /// 3-letter abbr i.e. 'EUR' / 'USD' etc.
230         uint256 initialConversionRate;          /// conversion rate for first payment execution
231         uint256 initialPaymentAmountInCents;    /// initial payment amount in fiat in cents
232         uint256 fiatAmountInCents;              /// payment amount in fiat in cents
233         uint256 frequency;                      /// how often merchant can pull - in seconds
234         uint256 numberOfPayments;               /// amount of pull payments merchant can make
235         uint256 startTimestamp;                 /// when subscription starts - in seconds
236         uint256 trialPeriod;                    /// trial period of the pull payment - in seconds
237         uint256 nextPaymentTimestamp;           /// timestamp of next payment
238         uint256 lastPaymentTimestamp;           /// timestamp of last payment
239         uint256 cancelTimestamp;                /// timestamp the payment was cancelled
240         address treasuryAddress;                /// address which pma tokens will be transfer to on execution
241         address executorAddress;                /// address that can execute the pull payment
242     }
243     /// ===============================================================================================================
244     ///                                      Modifiers
245     /// ===============================================================================================================
246     modifier isExecutor() {
247         require(executors[msg.sender], "msg.sender not an executor");
248         _;
249     }
250     modifier executorExists(address _executor) {
251         require(executors[_executor], "Executor does not exists.");
252         _;
253     }
254     modifier executorDoesNotExists(address _executor) {
255         require(!executors[_executor], "Executor already exists.");
256         _;
257     }
258     modifier paymentExists(bytes32 _paymentID) {
259         require(pullPayments[_paymentID].paymentIds[0] != "", "Pull Payment does not exists.");
260         _;
261     }
262     modifier paymentNotCancelled(bytes32 _paymentID) {
263         require(pullPayments[_paymentID].cancelTimestamp == 0, "Pull Payment is cancelled");
264         _;
265     }
266     modifier isValidPullPaymentExecutionRequest(
267         bytes32 _paymentID,
268         uint256 _paymentNumber) {
269         require(pullPayments[_paymentID].numberOfPayments == _paymentNumber,
270             "Invalid pull payment execution request - Pull payment number of payment is invalid");
271         require((pullPayments[_paymentID].initialPaymentAmountInCents > 0 ||
272         (now >= pullPayments[_paymentID].startTimestamp &&
273         now >= pullPayments[_paymentID].nextPaymentTimestamp)
274             ), "Invalid pull payment execution request - Time of execution is invalid."
275         );
276         require(pullPayments[_paymentID].numberOfPayments > 0,
277             "Invalid pull payment execution request - Number of payments is zero.");
278         require(
279             (pullPayments[_paymentID].cancelTimestamp == 0 ||
280         pullPayments[_paymentID].cancelTimestamp >
281         pullPayments[_paymentID].nextPaymentTimestamp),
282             "Invalid pull payment execution request - Pull payment is cancelled");
283         require(keccak256(
284             abi.encodePacked(pullPayments[_paymentID].paymentIds[0])
285         ) == keccak256(abi.encodePacked(_paymentID)),
286             "Invalid pull payment execution request - Payment ID not matching.");
287         _;
288     }
289     modifier isValidDeletionRequest(bytes32 _paymentID, address _customerAddress) {
290         require(_paymentID != EMPTY_BYTES32, "Invalid deletion request - Payment ID is empty.");
291         require(_customerAddress != address(0), "Invalid deletion request - Client address is ZERO_ADDRESS.");
292         _;
293     }
294     modifier isValidAddress(address _address) {
295         require(_address != address(0), "Invalid address - ZERO_ADDRESS provided");
296         _;
297     }
298     modifier validAmount(uint256 _amount) {
299         require(_amount > 0, "Invalid amount - Must be higher than zero");
300         require(_amount <= OVERFLOW_LIMITER_NUMBER, "Invalid amount - Must be lower than the overflow limit.");
301         _;
302     }
303     /// ===============================================================================================================
304     ///                                      Constructor
305     /// ===============================================================================================================
306     /// @dev Contract constructor - sets the token address that the contract facilitates.
307     /// @param _token Token Address.
308     constructor(address _token)
309     public {
310         require(_token != address(0), "Invalid address for token - ZERO_ADDRESS provided");
311         token = IERC20(_token);
312     }
313     // @notice Will receive any eth sent to the contract
314     function() external payable {
315     }
316     /// ===============================================================================================================
317     ///                                      Public Functions - Owner Only
318     /// ===============================================================================================================
319     /// @dev Adds a new executor. - can be executed only by the onwer.
320     /// When adding a new executor 0.5 ETH is transferred to allow the executor to pay for gas.
321     /// The balance of the owner is also checked and if funding is needed 0.5 ETH is transferred.
322     /// @param _executor - address of the executor which cannot be zero address.
323     function addExecutor(address payable _executor)
324     public
325     onlyOwner
326     isValidAddress(_executor)
327     executorDoesNotExists(_executor)
328     {
329         executors[_executor] = true;
330         if (isFundingNeeded(_executor)) {
331             _executor.transfer(FUNDING_AMOUNT);
332             emit LogSmartContractActorFunded("executor", _executor, now);
333         }
334 
335         if (isFundingNeeded(owner())) {
336             owner().transfer(FUNDING_AMOUNT);
337             emit LogSmartContractActorFunded("owner", owner(), now);
338         }
339         emit LogExecutorAdded(_executor);
340     }
341     /// @dev Removes a new executor. - can be executed only by the owner.
342     /// The balance of the owner is checked and if funding is needed 0.5 ETH is transferred.
343     /// @param _executor - address of the executor which cannot be zero address.
344     function removeExecutor(address payable _executor)
345     public
346     onlyOwner
347     isValidAddress(_executor)
348     executorExists(_executor)
349     {
350         executors[_executor] = false;
351         if (isFundingNeeded(owner())) {
352             owner().transfer(FUNDING_AMOUNT);
353             emit LogSmartContractActorFunded("owner", owner(), now);
354         }
355         emit LogExecutorRemoved(_executor);
356     }
357     /// ===============================================================================================================
358     ///                                      Public Functions - Executors Only
359     /// ===============================================================================================================
360     /// @dev Registers a new pull payment to the PumaPay Pull Payment Contract - The registration can be executed only
361     /// by one of the executors of the PumaPay Pull Payment Contract
362     /// and the PumaPay Pull Payment Contract checks that the pull payment has been singed by the customer of the account.
363     /// If the pull payment doesn't have a trial period, the first execution will take place.'
364     /// The pull payment is updated accordingly in terms of how many payments can happen, and when is the next payment date.
365     /// (For more details on the above check the 'executePullPayment' method.
366     /// The balance of the executor (msg.sender) is checked and if funding is needed 0.5 ETH is transferred.
367     /// Emits 'LogPaymentRegistered' with customer address, pull payment executor address and paymentID.
368     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
369     /// @param r - R output of ECDSA signature.
370     /// @param s - S output of ECDSA signature.
371     /// @param _paymentDetails - all the relevant id-related details for the payment.
372     /// @param _addresses - all the relevant addresses for the payment.
373     /// @param _paymentAmounts - all the relevant amounts for the payment.
374     /// @param _paymentTimestamps - all the relevant timestamps for the payment.
375     /// @param _currency - currency of the payment / 3-letter abbr i.e. 'EUR'.
376     function registerPullPayment(
377         uint8 v,
378         bytes32 r,
379         bytes32 s,
380         bytes32[4] memory _paymentDetails, // 0 paymentID, 1 businessID, 2 uniqueReferenceID, 3 paymentType
381         address[3] memory _addresses, // 0 customer, 1 executor, 2 treasury
382         uint256[3] memory _paymentAmounts, // 0 _initialConversionRate, 1 _fiatAmountInCents, 2 _initialPaymentAmountInCents
383         uint256[4] memory _paymentTimestamps, // 0 _frequency, 1 _numberOfPayments, 2 _startTimestamp, 3 _trialPeriod
384         string memory _currency
385     )
386     public
387     isExecutor()
388     {
389         require(pullPayments[_paymentDetails[0]].paymentIds[0] == "", "Pull Payment already exists.");
390         require(_paymentDetails[0] != EMPTY_BYTES32, "Payment ID is empty.");
391         require(_paymentDetails[1] != EMPTY_BYTES32, "Business ID is empty.");
392         require(_paymentDetails[2] != EMPTY_BYTES32, "Unique Reference ID is empty.");
393         require(_paymentDetails[3] != EMPTY_BYTES32, "Payment Type is empty.");
394         require(_addresses[0] != address(0), "Customer Address is ZERO_ADDRESS.");
395         require(_addresses[1] != address(0), "Treasury Address is ZERO_ADDRESS.");
396         require(_paymentAmounts[0] > 0, "Initial conversion rate is zero.");
397         require(_paymentAmounts[1] > 0, "Payment amount in fiat is zero.");
398         require(_paymentAmounts[2] >= 0, "Initial payment amount in fiat is less than zero.");
399         require(_paymentTimestamps[0] > 0, "Payment frequency is zero.");
400         require(_paymentTimestamps[1] > 0, "Payment number of payments is zero.");
401         require(_paymentTimestamps[2] > 0, "Payment start time is zero.");
402         require(_paymentTimestamps[3] >= 0, "Payment trial period is less than zero.");
403         require(_paymentAmounts[0] <= OVERFLOW_LIMITER_NUMBER, "Initial conversion rate is higher thant the overflow limit.");
404         require(_paymentAmounts[1] <= OVERFLOW_LIMITER_NUMBER, "Payment amount in fiat is higher thant the overflow limit.");
405         require(_paymentAmounts[2] <= OVERFLOW_LIMITER_NUMBER, "Payment initial amount in fiat is higher thant the overflow limit.");
406         require(_paymentTimestamps[0] <= OVERFLOW_LIMITER_NUMBER, "Payment frequency is higher thant the overflow limit.");
407         require(_paymentTimestamps[1] <= OVERFLOW_LIMITER_NUMBER, "Payment number of payments is higher thant the overflow limit.");
408         require(_paymentTimestamps[2] <= OVERFLOW_LIMITER_NUMBER, "Payment start time is higher thant the overflow limit.");
409         require(_paymentTimestamps[3] <= OVERFLOW_LIMITER_NUMBER, "Payment trial period is higher thant the overflow limit.");
410         require(bytes(_currency).length > 0, "Currency is empty");
411         pullPayments[_paymentDetails[0]].paymentIds[0] = _paymentDetails[0];
412         pullPayments[_paymentDetails[0]].paymentType = _paymentDetails[3];
413         pullPayments[_paymentDetails[0]].executorAddress = _addresses[1];
414         pullPayments[_paymentDetails[0]].treasuryAddress = _addresses[2];
415         pullPayments[_paymentDetails[0]].initialConversionRate = _paymentAmounts[0];
416         pullPayments[_paymentDetails[0]].fiatAmountInCents = _paymentAmounts[1];
417         pullPayments[_paymentDetails[0]].initialPaymentAmountInCents = _paymentAmounts[2];
418         pullPayments[_paymentDetails[0]].frequency = _paymentTimestamps[0];
419         pullPayments[_paymentDetails[0]].numberOfPayments = _paymentTimestamps[1];
420         pullPayments[_paymentDetails[0]].startTimestamp = _paymentTimestamps[2];
421         pullPayments[_paymentDetails[0]].trialPeriod = _paymentTimestamps[3];
422         pullPayments[_paymentDetails[0]].currency = _currency;
423         require(isValidRegistration(
424                 v,
425                 r,
426                 s,
427                 _addresses[0],
428                 pullPayments[_paymentDetails[0]]),
429             "Invalid pull payment registration - ECRECOVER_FAILED"
430         );
431         pullPayments[_paymentDetails[0]].paymentIds[1] = _paymentDetails[1];
432         pullPayments[_paymentDetails[0]].paymentIds[2] = _paymentDetails[2];
433         pullPayments[_paymentDetails[0]].cancelTimestamp = 0;
434         /// @dev In case of a free trial period the start timestamp of the payment
435         /// is the start timestamp that was signed by the customer + the trial period.
436         /// A payment is not needed during registration.
437         if (_paymentDetails[3] == TYPE_PULL_PAYMENT_WITH_FREE_TRIAL) {
438             pullPayments[_paymentDetails[0]].nextPaymentTimestamp = _paymentTimestamps[2] + _paymentTimestamps[3];
439             pullPayments[_paymentDetails[0]].lastPaymentTimestamp = 0;
440             /// @dev In case of a recurring payment with initial amount
441             /// the first payment of the 'initialPaymentAmountInCents' and 'initialConversionRate'
442             /// will happen on registration.
443             /// Once it happens, we set the next payment timestamp as
444             /// the start timestamp signed by the customer + trial period
445         } else if (_paymentDetails[3] == TYPE_RECURRING_PULL_PAYMENT_WITH_INITIAL) {
446             require(executePullPaymentOnRegistration(
447                     [_paymentDetails[0], _paymentDetails[1], _paymentDetails[2]], // 0 paymentID, 1 businessID, 2 uniqueReferenceID
448                     [_addresses[0], _addresses[1], _addresses[2]], // 0 Customer Address, 1 executor Address, 2 Treasury Address
449                     [_paymentAmounts[2], _paymentAmounts[0]] // 0 initialPaymentAmountInCents, 1 initialConversionRate
450                 ));
451             pullPayments[_paymentDetails[0]].lastPaymentTimestamp = now;
452             pullPayments[_paymentDetails[0]].nextPaymentTimestamp = _paymentTimestamps[2] + _paymentTimestamps[0];
453             /// @dev In the case od a paid trial, the first payment happens
454             /// on registration using the 'initialPaymentAmountInCents' and 'initialConversionRate'.
455             /// When the first payment takes place we set the next payment timestamp
456             /// as the start timestamp that was signed by the customer + the trial period
457         } else if (_paymentDetails[3] == TYPE_PULL_PAYMENT_WITH_PAID_TRIAL) {
458             require(executePullPaymentOnRegistration(
459                     [_paymentDetails[0], _paymentDetails[1], _paymentDetails[2]], /// paymentID , businessID , uniqueReferenceID
460                     [_addresses[0], _addresses[1], _addresses[2]], // 0 Customer Address, 1 executor Address, 2 Treasury Address
461                     [_paymentAmounts[2], _paymentAmounts[0]] /// 0 initialPaymentAmountInCents, 1 initialConversionRate
462                 ));
463             pullPayments[_paymentDetails[0]].lastPaymentTimestamp = now;
464             pullPayments[_paymentDetails[0]].nextPaymentTimestamp = _paymentTimestamps[2] + _paymentTimestamps[3];
465             /// @dev For the rest of the cases the first payment happens on registration
466             /// using the 'fiatAmountInCents' and 'initialConversionRate'.
467             /// When the first payment takes place, the number of payment is decreased by 1,
468             /// and the next payment timestamp is set to the start timestamp signed by the
469             /// customer + the frequency of the payment.
470         } else {
471             require(executePullPaymentOnRegistration(
472                     [_paymentDetails[0], _paymentDetails[1], _paymentDetails[2]], /// paymentID , businessID , uniqueReferenceID
473                     [_addresses[0], _addresses[1], _addresses[2]], // 0 Customer Address, 1 executor Address, 2 Treasury Address
474                     [_paymentAmounts[1], _paymentAmounts[0]] /// fiatAmountInCents, initialConversionRate
475                 ));
476             pullPayments[_paymentDetails[0]].lastPaymentTimestamp = now;
477             pullPayments[_paymentDetails[0]].nextPaymentTimestamp = _paymentTimestamps[2] + _paymentTimestamps[0];
478             pullPayments[_paymentDetails[0]].numberOfPayments = _paymentTimestamps[1] - 1;
479         }
480         if (isFundingNeeded(msg.sender)) {
481             msg.sender.transfer(FUNDING_AMOUNT);
482             emit LogSmartContractActorFunded("executor", msg.sender, now);
483         }
484         emit LogPaymentRegistered(_addresses[0], _paymentDetails[0], _paymentDetails[1], _paymentDetails[2]);
485     }
486     /// @dev Deletes a pull payment for a pull payment executor - The deletion needs can be executed only by one of the
487     /// executors of the PumaPay Pull Payment Contract
488     /// and the PumaPay Pull Payment Contract checks that the pull payment executor and the paymentID have
489     /// been singed by the customer of the account.
490     /// This method sets the cancellation of the pull payment in the pull payments array for this pull payment executor specified.
491     /// The balance of the executor (msg.sender) is checked and if funding is needed 0.5 ETH is transferred.
492     /// Emits 'LogPaymentCancelled' with pull payment executor address and paymentID.
493     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
494     /// @param r - R output of ECDSA signature.
495     /// @param s - S output of ECDSA signature.
496     /// @param _paymentID - ID of the payment.
497     /// @param _customerAddress - customer address that is linked to this pull payment.
498     /// @param _pullPaymentExecutor - address that is allowed to execute this pull payment.
499     function deletePullPayment(
500         uint8 v,
501         bytes32 r,
502         bytes32 s,
503         bytes32 _paymentID,
504         address _customerAddress,
505         address _pullPaymentExecutor
506     )
507     public
508     isExecutor()
509     paymentExists(_paymentID)
510     paymentNotCancelled(_paymentID)
511     isValidDeletionRequest(_paymentID, _customerAddress)
512     {
513         require(isValidDeletion(v, r, s, _paymentID, _customerAddress, _pullPaymentExecutor), "Invalid deletion - ECRECOVER_FAILED.");
514         pullPayments[_paymentID].cancelTimestamp = now;
515         if (isFundingNeeded(msg.sender)) {
516             msg.sender.transfer(FUNDING_AMOUNT);
517             emit LogSmartContractActorFunded("executor", msg.sender, now);
518         }
519         emit LogPaymentCancelled(
520             _customerAddress,
521             _paymentID,
522             pullPayments[_paymentID].paymentIds[1],
523             pullPayments[_paymentID].paymentIds[2]
524         );
525     }
526     /// ===============================================================================================================
527     ///                                      Public Functions
528     /// ===============================================================================================================
529     /// @dev Executes a pull payment for the msg.sender - The pull payment should exist and the payment request
530     /// should be valid in terms of when it can be executed.
531     /// Emits 'LogPullPaymentExecuted' with customer address, msg.sender as the pull payment executor address and the paymentID.
532     /// Use Case: Single/Recurring Fixed Pull Payment
533     /// ------------------------------------------------
534     /// We calculate the amount in PMA using the conversion rate specified when calling the method.
535     /// From the 'conversionRate' and the 'fiatAmountInCents' we calculate the amount of PMA that
536     /// the business need to receive in their treasuryAddress.
537     /// The smart contract transfers from the customer account to the treasury wallet the amount in PMA.
538     /// After execution we set the last payment timestamp to NOW, the next payment timestamp is incremented by
539     /// the frequency and the number of payments is decreased by 1.
540     /// @param _customerAddress - address of the customer from which the msg.sender requires to pull funds.
541     /// @param _paymentID - ID of the payment.
542     /// @param _paymentDetails - Payment details - [0] conversion rate // [1] payment Number
543     function executePullPayment(address _customerAddress, bytes32 _paymentID, uint256[2] memory _paymentDetails)
544     public
545     paymentExists(_paymentID)
546     isValidPullPaymentExecutionRequest(_paymentID, _paymentDetails[1])
547     validAmount(_paymentDetails[0])
548     returns (bool)
549     {
550         uint256 conversionRate = _paymentDetails[0];
551         address customerAddress = _customerAddress;
552         bytes32[3] memory paymentIds = pullPayments[_paymentID].paymentIds;
553         address treasury = pullPayments[_paymentID].treasuryAddress;
554         uint256 amountInPMA = calculatePMAFromFiat(pullPayments[paymentIds[0]].fiatAmountInCents, conversionRate);
555 
556         pullPayments[paymentIds[0]].nextPaymentTimestamp =
557         pullPayments[paymentIds[0]].nextPaymentTimestamp + pullPayments[paymentIds[0]].frequency;
558         pullPayments[paymentIds[0]].numberOfPayments = pullPayments[paymentIds[0]].numberOfPayments - 1;
559         pullPayments[paymentIds[0]].lastPaymentTimestamp = now;
560         require(token.transferFrom(
561                 customerAddress,
562                 treasury,
563                 amountInPMA
564             ));
565         emit LogPullPaymentExecuted(
566             customerAddress,
567             paymentIds[0],
568             paymentIds[1],
569             paymentIds[2],
570             amountInPMA,
571             conversionRate
572         );
573         return true;
574     }
575 
576     /// ===============================================================================================================
577     ///                                      Internal Functions
578     /// ===============================================================================================================
579     /// @dev The new version of the smart contract allows for the first execution to happen on registration,
580     /// unless the pull payment has free trial. Check the comments on 'registerPullPayment' method for more details.
581     function executePullPaymentOnRegistration(
582         bytes32[3] memory _paymentDetails, // 0 paymentID, 1 businessID, 2 uniqueReferenceID
583         address[3] memory _addresses, // 0 customer Address, 1, executor Address, 2 treasury Address
584         uint256[2] memory _paymentAmounts // 0 _fiatAmountInCents, 1 _conversionRate
585     )
586     internal
587     returns (bool) {
588         uint256 amountInPMA = calculatePMAFromFiat(_paymentAmounts[0], _paymentAmounts[1]);
589         require(token.transferFrom(_addresses[0], _addresses[2], amountInPMA));
590         emit LogPullPaymentExecuted(
591             _addresses[0],
592             _paymentDetails[0],
593             _paymentDetails[1],
594             _paymentDetails[2],
595             amountInPMA,
596             _paymentAmounts[1]
597         );
598         return true;
599     }
600 
601     /// @dev Calculates the PMA Rate for the fiat currency specified - The rate is set every 10 minutes by our PMA server
602     /// for the currencies specified in the smart contract.
603     /// @param _fiatAmountInCents - payment amount in fiat CENTS so that is always integer
604     /// @param _conversionRate - conversion rate with which the payment needs to take place
605     /// RATE CALCULATION EXAMPLE
606     /// ------------------------
607     /// RATE ==> 1 PMA = 0.01 USD$
608     /// 1 USD$ = 1/0.01 PMA = 100 PMA
609     /// Start the calculation from one ether - PMA Token has 18 decimals
610     /// Multiply by the DECIMAL_FIXER (1e+10) to fix the multiplication of the rate
611     /// Multiply with the fiat amount in cents
612     /// Divide by the Rate of PMA to Fiat in cents
613     /// Divide by the FIAT_TO_CENT_FIXER to fix the _fiatAmountInCents
614     /// ---------------------------------------------------------------------------------------------------------------
615     /// To save on gas, we have 'pre-calculated' the equation below and have set a constant in its place.
616     /// ONE_ETHER.mul(DECIMAL_FIXER).div(FIAT_TO_CENT_FIXER) = RATE_CALCULATION_NUMBER
617     /// ONE_ETHER = 10^18           |
618     /// DECIMAL_FIXER = 10^10       |   => 10^18 * 10^10 / 100 ==> 10^26  => RATE_CALCULATION_NUMBER = 10^26
619     /// FIAT_TO_CENT_FIXER = 100    |
620     /// NOTE: The aforementioned value is linked to the OVERFLOW_LIMITER_NUMBER which is set to 10^20.
621     /// ---------------------------------------------------------------------------------------------------------------
622     function calculatePMAFromFiat(uint256 _fiatAmountInCents, uint256 _conversionRate)
623     internal
624     pure
625     validAmount(_fiatAmountInCents)
626     validAmount(_conversionRate)
627     returns (uint256) {
628         return RATE_CALCULATION_NUMBER.mul(_fiatAmountInCents).div(_conversionRate);
629     }
630     /// @dev Checks if a registration request is valid by comparing the v, r, s params
631     /// and the hashed params with the customer address.
632     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
633     /// @param r - R output of ECDSA signature.
634     /// @param s - S output of ECDSA signature.
635     /// @param _customerAddress - customer address that is linked to this pull payment.
636     /// @param _pullPayment - pull payment to be validated.
637     /// @return bool - if the v, r, s params with the hashed params match the customer address
638     function isValidRegistration(
639         uint8 v,
640         bytes32 r,
641         bytes32 s,
642         address _customerAddress,
643         PullPayment memory _pullPayment
644     )
645     internal
646     pure
647     returns (bool)
648     {
649         return ecrecover(
650             keccak256(
651                 abi.encodePacked(
652                     _pullPayment.executorAddress,
653                     _pullPayment.paymentIds[0],
654                     _pullPayment.paymentType,
655                     _pullPayment.treasuryAddress,
656                     _pullPayment.currency,
657                     _pullPayment.initialPaymentAmountInCents,
658                     _pullPayment.fiatAmountInCents,
659                     _pullPayment.frequency,
660                     _pullPayment.numberOfPayments,
661                     _pullPayment.startTimestamp,
662                     _pullPayment.trialPeriod
663                 )
664             ),
665             v, r, s) == _customerAddress;
666     }
667     /// @dev Checks if a deletion request is valid by comparing the v, r, s params
668     /// and the hashed params with the customer address.
669     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
670     /// @param r - R output of ECDSA signature.
671     /// @param s - S output of ECDSA signature.
672     /// @param _paymentID - ID of the payment.
673     /// @param _customerAddress - customer address that is linked to this pull payment.
674     /// @param _pullPaymentExecutor - address that is allowed to execute this pull payment.
675     /// @return bool - if the v, r, s params with the hashed params match the customer address
676     function isValidDeletion(
677         uint8 v,
678         bytes32 r,
679         bytes32 s,
680         bytes32 _paymentID,
681         address _customerAddress,
682         address _pullPaymentExecutor
683     )
684     internal
685     view
686     returns (bool)
687     {
688         return ecrecover(
689             keccak256(
690                 abi.encodePacked(
691                     _paymentID,
692                     _pullPaymentExecutor
693                 )
694             ), v, r, s) == _customerAddress
695         && keccak256(
696             abi.encodePacked(pullPayments[_paymentID].paymentIds[0])
697         ) == keccak256(abi.encodePacked(_paymentID)
698         );
699     }
700     /// @dev Checks if the address of an owner/executor needs to be funded.
701     /// The minimum amount the owner/executors should always have is 0.15 ETH
702     /// @param _address - address of owner/executors that the balance is checked against.
703     /// @return bool - whether the address needs more ETH.
704     function isFundingNeeded(address _address)
705     private
706     view
707     returns (bool) {
708         return address(_address).balance <= MINIMUM_AMOUNT_OF_ETH_FOR_OPERATORS;
709     }
710 }