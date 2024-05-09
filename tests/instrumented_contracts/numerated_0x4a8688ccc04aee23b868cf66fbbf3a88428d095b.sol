1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity 0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity 0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two unsigned integers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity 0.5.0;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123     * @dev Total number of tokens in existence
124     */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param owner The address to query the balance of.
132     * @return An uint256 representing the amount owned by the passed address.
133     */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149     * @dev Transfer token for a specified address
150     * @param to The address to transfer to.
151     * @param value The amount to be transferred.
152     */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         require(spender != address(0));
169 
170         _allowed[msg.sender][spender] = value;
171         emit Approval(msg.sender, spender, value);
172         return true;
173     }
174 
175     /**
176      * @dev Transfer tokens from one address to another.
177      * Note that while this function emits an Approval event, this is not required as per the specification,
178      * and other compliant implementations may not emit the event.
179      * @param from address The address which you want to send tokens from
180      * @param to address The address which you want to transfer to
181      * @param value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(address from, address to, uint256 value) public returns (bool) {
184         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
185         _transfer(from, to, value);
186         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
187         return true;
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      * approve should be called when allowed_[_spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         require(spender != address(0));
202 
203         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
204         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when allowed_[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219         require(spender != address(0));
220 
221         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
222         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Transfer token for a specified addresses
228     * @param from The address to transfer from.
229     * @param to The address to transfer to.
230     * @param value The amount to be transferred.
231     */
232     function _transfer(address from, address to, uint256 value) internal {
233         require(to != address(0));
234 
235         _balances[from] = _balances[from].sub(value);
236         _balances[to] = _balances[to].add(value);
237         emit Transfer(from, to, value);
238     }
239 
240     /**
241      * @dev Internal function that mints an amount of the token and assigns it to
242      * an account. This encapsulates the modification of balances such that the
243      * proper events are emitted.
244      * @param account The account that will receive the created tokens.
245      * @param value The amount that will be created.
246      */
247     function _mint(address account, uint256 value) internal {
248         require(account != address(0));
249 
250         _totalSupply = _totalSupply.add(value);
251         _balances[account] = _balances[account].add(value);
252         emit Transfer(address(0), account, value);
253     }
254 
255     /**
256      * @dev Internal function that burns an amount of the token of a given
257      * account.
258      * @param account The account whose tokens will be burnt.
259      * @param value The amount that will be burnt.
260      */
261     function _burn(address account, uint256 value) internal {
262         require(account != address(0));
263 
264         _totalSupply = _totalSupply.sub(value);
265         _balances[account] = _balances[account].sub(value);
266         emit Transfer(account, address(0), value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account, deducting from the sender's allowance for said account. Uses the
272      * internal burn function.
273      * Emits an Approval event (reflecting the reduced allowance).
274      * @param account The account whose tokens will be burnt.
275      * @param value The amount that will be burnt.
276      */
277     function _burnFrom(address account, uint256 value) internal {
278         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
279         _burn(account, value);
280         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
281     }
282 }
283 
284 // File: openzeppelin-solidity/contracts/access/Roles.sol
285 
286 pragma solidity 0.5.0;
287 
288 /**
289  * @title Roles
290  * @dev Library for managing addresses assigned to a Role.
291  */
292 library Roles {
293     struct Role {
294         mapping (address => bool) bearer;
295     }
296 
297     /**
298      * @dev give an account access to this role
299      */
300     function add(Role storage role, address account) internal {
301         require(account != address(0));
302         require(!has(role, account));
303 
304         role.bearer[account] = true;
305     }
306 
307     /**
308      * @dev remove an account's access to this role
309      */
310     function remove(Role storage role, address account) internal {
311         require(account != address(0));
312         require(has(role, account));
313 
314         role.bearer[account] = false;
315     }
316 
317     /**
318      * @dev check if an account has this role
319      * @return bool
320      */
321     function has(Role storage role, address account) internal view returns (bool) {
322         require(account != address(0));
323         return role.bearer[account];
324     }
325 }
326 
327 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
328 
329 pragma solidity 0.5.0;
330 
331 
332 contract MinterRole {
333     using Roles for Roles.Role;
334 
335     event MinterAdded(address indexed account);
336     event MinterRemoved(address indexed account);
337 
338     Roles.Role private _minters;
339 
340     constructor () internal {
341         _addMinter(msg.sender);
342     }
343 
344     modifier onlyMinter() {
345         require(isMinter(msg.sender));
346         _;
347     }
348 
349     function isMinter(address account) public view returns (bool) {
350         return _minters.has(account);
351     }
352 
353     function addMinter(address account) public onlyMinter {
354         _addMinter(account);
355     }
356 
357     function renounceMinter() public {
358         _removeMinter(msg.sender);
359     }
360 
361     function _addMinter(address account) internal {
362         _minters.add(account);
363         emit MinterAdded(account);
364     }
365 
366     function _removeMinter(address account) internal {
367         _minters.remove(account);
368         emit MinterRemoved(account);
369     }
370 }
371 
372 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
373 
374 pragma solidity 0.5.0;
375 
376 
377 
378 /**
379  * @title ERC20Mintable
380  * @dev ERC20 minting logic
381  */
382 contract ERC20Mintable is ERC20, MinterRole {
383     /**
384      * @dev Function to mint tokens
385      * @param to The address that will receive the minted tokens.
386      * @param value The amount of tokens to mint.
387      * @return A boolean that indicates if the operation was successful.
388      */
389     function mint(address to, uint256 value) public onlyMinter returns (bool) {
390         _mint(to, value);
391         return true;
392     }
393 }
394 
395 // File: contracts/PumaPayToken.sol
396 
397 pragma solidity 0.5.0;
398 
399 
400 
401 /// PumaPayToken inherits from MintableToken, which in turn inherits from StandardToken.
402 /// Super is used to bypass the original function signature and include the whenNotMinting modifier.
403 
404 contract PumaPayToken is ERC20Mintable {
405 
406     string public name = "PumaPay";
407     string public symbol = "PMA";
408     uint8 public decimals = 18;
409 
410     constructor() public {
411     }
412 
413     /// @dev transfer token for a specified address
414     /// @param _to address The address to transfer to.
415     /// @param _value uint256 The amount to be transferred.
416     /// @return success bool Calling super.transfer and returns true if successful.
417     function transfer(address _to, uint256 _value) public returns (bool) {
418         return super.transfer(_to, _value);
419     }
420 
421     /// @dev Transfer tokens from one address to another.
422     /// @param _from address The address which you want to send tokens from.
423     /// @param _to address The address which you want to transfer to.
424     /// @param _value uint256 the amount of tokens to be transferred.
425     /// @return success bool Calling super.transferFrom and returns true if successful.
426     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
427         return super.transferFrom(_from, _to, _value);
428     }
429 }
430 
431 // File: contracts/ownership/PayableOwnable.sol
432 
433 pragma solidity 0.5.0;
434 
435 /**
436  * @title PayableOwnable
437  * @dev The PayableOwnable contract has an owner address, and provides basic authorization control
438  * functions, this simplifies the implementation of "user permissions".
439  * PayableOwnable is extended from open-zeppelin Ownable smart contract, with the difference of making the owner
440  * a payable address.
441  */
442 contract PayableOwnable {
443     address payable private _owner;
444 
445     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
446 
447     /**
448      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
449      * account.
450      */
451     constructor () internal {
452         _owner = msg.sender;
453         emit OwnershipTransferred(address(0), _owner);
454     }
455 
456     /**
457      * @return the address of the owner.
458      */
459     function owner() public view returns (address payable) {
460         return _owner;
461     }
462 
463     /**
464      * @dev Throws if called by any account other than the owner.
465      */
466     modifier onlyOwner() {
467         require(isOwner());
468         _;
469     }
470 
471     /**
472      * @return true if `msg.sender` is the owner of the contract.
473      */
474     function isOwner() public view returns (bool) {
475         return msg.sender == _owner;
476     }
477 
478     /**
479      * @dev Allows the current owner to relinquish control of the contract.
480      * @notice Renouncing to ownership will leave the contract without an owner.
481      * It will not be possible to call the functions with the `onlyOwner`
482      * modifier anymore.
483      */
484     function renounceOwnership() public onlyOwner {
485         emit OwnershipTransferred(_owner, address(0));
486         _owner = address(0);
487     }
488 
489     /**
490      * @dev Allows the current owner to transfer control of the contract to a newOwner.
491      * @param newOwner The address to transfer ownership to.
492      */
493     function transferOwnership(address payable newOwner) public onlyOwner {
494         _transferOwnership(newOwner);
495     }
496 
497     /**
498      * @dev Transfers control of the contract to a newOwner.
499      * @param newOwner The address to transfer ownership to.
500      */
501     function _transferOwnership(address payable newOwner) internal {
502         require(newOwner != address(0));
503         emit OwnershipTransferred(_owner, newOwner);
504         _owner = newOwner;
505     }
506 }
507 
508 // File: contracts/PumaPayPullPayment.sol
509 
510 pragma solidity 0.5.0;
511 
512 
513 
514 
515 /// @title PumaPay Pull Payment - Contract that facilitates our pull payment protocol
516 /// @author PumaPay Dev Team - <developers@pumapay.io>
517 
518 contract PumaPayPullPayment is PayableOwnable {
519 
520     using SafeMath for uint256;
521 
522     /// ===============================================================================================================
523     ///                                      Events
524     /// ===============================================================================================================
525 
526     event LogExecutorAdded(address executor);
527     event LogExecutorRemoved(address executor);
528     event LogSetConversionRate(string currency, uint256 conversionRate);
529 
530     event LogPaymentRegistered(
531         address customerAddress,
532         bytes32 paymentID,
533         bytes32 businessID,
534         bytes32 uniqueReferenceID
535     );
536     event LogPaymentCancelled(
537         address customerAddress,
538         bytes32 paymentID,
539         bytes32 businessID,
540         bytes32 uniqueReferenceID
541     );
542     event LogPullPaymentExecuted(
543         address customerAddress,
544         bytes32 paymentID,
545         bytes32 businessID,
546         bytes32 uniqueReferenceID
547     );
548 
549     /// ===============================================================================================================
550     ///                                      Constants
551     /// ===============================================================================================================
552 
553     uint256 constant private DECIMAL_FIXER = 10 ** 10; /// 1e^10 - This transforms the Rate from decimals to uint256
554     uint256 constant private FIAT_TO_CENT_FIXER = 100;    /// Fiat currencies have 100 cents in 1 basic monetary unit.
555     uint256 constant private OVERFLOW_LIMITER_NUMBER = 10 ** 20; /// 1e^20 - Prevent numeric overflows
556 
557     uint256 constant private ONE_ETHER = 1 ether;         /// PumaPay token has 18 decimals - same as one ETHER
558     uint256 constant private FUNDING_AMOUNT = 1 ether;  /// Amount to transfer to owner/executor
559     uint256 constant private MINIMUM_AMOUNT_OF_ETH_FOR_OPERATORS = 0.15 ether; /// min amount of ETH for owner/executor
560 
561     /// ===============================================================================================================
562     ///                                      Members
563     /// ===============================================================================================================
564 
565     PumaPayToken public token;
566 
567     mapping(string => uint256) private conversionRates;
568     mapping(address => bool) public executors;
569     mapping(address => mapping(address => PullPayment)) public pullPayments;
570 
571     struct PullPayment {
572         bytes32 paymentID;                      /// ID of the payment
573         bytes32 businessID;                     /// ID of the business
574         bytes32 uniqueReferenceID;              /// unique reference ID the business is adding on the pull payment
575         string currency;                        /// 3-letter abbr i.e. 'EUR' / 'USD' etc.
576         uint256 initialPaymentAmountInCents;    /// initial payment amount in fiat in cents
577         uint256 fiatAmountInCents;              /// payment amount in fiat in cents
578         uint256 frequency;                      /// how often merchant can pull - in seconds
579         uint256 numberOfPayments;               /// amount of pull payments merchant can make
580         uint256 startTimestamp;                 /// when subscription starts - in seconds
581         uint256 nextPaymentTimestamp;           /// timestamp of next payment
582         uint256 lastPaymentTimestamp;           /// timestamp of last payment
583         uint256 cancelTimestamp;                /// timestamp the payment was cancelled
584         address treasuryAddress;                /// address which pma tokens will be transfer to on execution
585     }
586 
587     /// ===============================================================================================================
588     ///                                      Modifiers
589     /// ===============================================================================================================
590     modifier isExecutor() {
591         require(executors[msg.sender], "msg.sender not an executor");
592         _;
593     }
594 
595     modifier executorExists(address _executor) {
596         require(executors[_executor], "Executor does not exists.");
597         _;
598     }
599 
600     modifier executorDoesNotExists(address _executor) {
601         require(!executors[_executor], "Executor already exists.");
602         _;
603     }
604 
605     modifier paymentExists(address _client, address _pullPaymentExecutor) {
606         require(doesPaymentExist(_client, _pullPaymentExecutor), "Pull Payment does not exists");
607         _;
608     }
609 
610     modifier paymentNotCancelled(address _client, address _pullPaymentExecutor) {
611         require(pullPayments[_client][_pullPaymentExecutor].cancelTimestamp == 0, "Pull Payment is cancelled.");
612         _;
613     }
614 
615     modifier isValidPullPaymentExecutionRequest(address _client, address _pullPaymentExecutor, bytes32 _paymentID) {
616         require(
617             (pullPayments[_client][_pullPaymentExecutor].initialPaymentAmountInCents > 0 ||
618         (now >= pullPayments[_client][_pullPaymentExecutor].startTimestamp &&
619         now >= pullPayments[_client][_pullPaymentExecutor].nextPaymentTimestamp)
620             ), "Invalid pull payment execution request - Time of execution is invalid."
621         );
622         require(pullPayments[_client][_pullPaymentExecutor].numberOfPayments > 0,
623             "Invalid pull payment execution request - Number of payments is zero.");
624 
625         require((pullPayments[_client][_pullPaymentExecutor].cancelTimestamp == 0 ||
626         pullPayments[_client][_pullPaymentExecutor].cancelTimestamp > pullPayments[_client][_pullPaymentExecutor].nextPaymentTimestamp),
627             "Invalid pull payment execution request - Pull payment is cancelled");
628         require(keccak256(
629             abi.encodePacked(pullPayments[_client][_pullPaymentExecutor].paymentID)
630         ) == keccak256(abi.encodePacked(_paymentID)),
631             "Invalid pull payment execution request - Payment ID not matching.");
632         _;
633     }
634 
635     modifier isValidDeletionRequest(bytes32 _paymentID, address _client, address _pullPaymentExecutor) {
636         require(_client != address(0), "Invalid deletion request - Client address is ZERO_ADDRESS.");
637         require(_pullPaymentExecutor != address(0), "Invalid deletion request - Beneficiary address is ZERO_ADDRESS.");
638         require(_paymentID.length != 0, "Invalid deletion request - Payment ID is empty.");
639         _;
640     }
641 
642     modifier isValidAddress(address _address) {
643         require(_address != address(0), "Invalid address - ZERO_ADDRESS provided");
644         _;
645     }
646 
647     modifier validConversionRate(string memory _currency) {
648         require(bytes(_currency).length != 0, "Invalid conversion rate - Currency is empty.");
649         require(conversionRates[_currency] > 0, "Invalid conversion rate - Must be higher than zero.");
650         _;
651     }
652 
653     modifier validAmount(uint256 _fiatAmountInCents) {
654         require(_fiatAmountInCents > 0, "Invalid amount - Must be higher than zero");
655         _;
656     }
657 
658     /// ===============================================================================================================
659     ///                                      Constructor
660     /// ===============================================================================================================
661 
662     /// @dev Contract constructor - sets the token address that the contract facilitates.
663     /// @param _token Token Address.
664 
665     constructor (address _token)
666     public {
667         require(_token != address(0), "Invalid address for token - ZERO_ADDRESS provided");
668         token = PumaPayToken(_token);
669     }
670 
671     // @notice Will receive any eth sent to the contract
672     function() external payable {
673     }
674 
675     /// ===============================================================================================================
676     ///                                      Public Functions - Owner Only
677     /// ===============================================================================================================
678 
679     /// @dev Adds a new executor. - can be executed only by the onwer.
680     /// When adding a new executor 1 ETH is tranferred to allow the executor to pay for gas.
681     /// The balance of the owner is also checked and if funding is needed 1 ETH is transferred.
682     /// @param _executor - address of the executor which cannot be zero address.
683 
684     function addExecutor(address payable _executor)
685     public
686     onlyOwner
687     isValidAddress(_executor)
688     executorDoesNotExists(_executor)
689     {
690         _executor.transfer(FUNDING_AMOUNT);
691         executors[_executor] = true;
692 
693         if (isFundingNeeded(owner())) {
694             owner().transfer(FUNDING_AMOUNT);
695         }
696 
697         emit LogExecutorAdded(_executor);
698     }
699 
700     /// @dev Removes a new executor. - can be executed only by the onwer.
701     /// The balance of the owner is checked and if funding is needed 1 ETH is transferred.
702     /// @param _executor - address of the executor which cannot be zero address.
703     function removeExecutor(address payable _executor)
704     public
705     onlyOwner
706     isValidAddress(_executor)
707     executorExists(_executor)
708     {
709         executors[_executor] = false;
710         if (isFundingNeeded(owner())) {
711             owner().transfer(FUNDING_AMOUNT);
712         }
713         emit LogExecutorRemoved(_executor);
714     }
715 
716     /// @dev Sets the exchange rate for a currency. - can be executed only by the onwer.
717     /// Emits 'LogSetConversionRate' with the currency and the updated rate.
718     /// The balance of the owner is checked and if funding is needed 1 ETH is transferred.
719     /// @param _currency - address of the executor which cannot be zero address
720     /// @param _rate - address of the executor which cannot be zero address
721     function setRate(string memory _currency, uint256 _rate)
722     public
723     onlyOwner
724     returns (bool) {
725         conversionRates[_currency] = _rate;
726         emit LogSetConversionRate(_currency, _rate);
727 
728         if (isFundingNeeded(owner())) {
729             owner().transfer(FUNDING_AMOUNT);
730         }
731 
732         return true;
733     }
734 
735     /// ===============================================================================================================
736     ///                                      Public Functions - Executors Only
737     /// ===============================================================================================================
738 
739     /// @dev Registers a new pull payment to the PumaPay Pull Payment Contract - The registration can be executed only
740     /// by one of the executors of the PumaPay Pull Payment Contract
741     /// and the PumaPay Pull Payment Contract checks that the pull payment has been singed by the client of the account.
742     /// The balance of the executor (msg.sender) is checked and if funding is needed 1 ETH is transferred.
743     /// Emits 'LogPaymentRegistered' with client address, beneficiary address and paymentID.
744     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
745     /// @param r - R output of ECDSA signature.
746     /// @param s - S output of ECDSA signature.
747     /// @param _ids - all the relevant IDs for the payment.
748     /// @param _addresses - all the relevant addresses for the payment.
749     /// @param _currency - currency of the payment / 3-letter abbr i.e. 'EUR'.
750     /// @param _fiatAmountInCents - payment amount in fiat in cents.
751     /// @param _frequency - how often merchant can pull - in seconds.
752     /// @param _numberOfPayments - amount of pull payments merchant can make
753     /// @param _startTimestamp - when subscription starts - in seconds.
754     function registerPullPayment(
755         uint8 v,
756         bytes32 r,
757         bytes32 s,
758         bytes32[3] memory _ids, // 0 paymentID, 1 businessID, 2 uniqueReferenceID
759         address[3] memory _addresses, // 0 customer, 1 pull payment executor, 2 treasury
760         string memory _currency,
761         uint256 _initialPaymentAmountInCents,
762         uint256 _fiatAmountInCents,
763         uint256 _frequency,
764         uint256 _numberOfPayments,
765         uint256 _startTimestamp
766     )
767     public
768     isExecutor()
769     {
770         require(_ids[0].length > 0, "Payment ID is empty.");
771         require(_ids[1].length > 0, "Business ID is empty.");
772         require(_ids[2].length > 0, "Unique Reference ID is empty.");
773         require(bytes(_currency).length > 0, "Currency is empty");
774         require(_addresses[0] != address(0), "Customer Address is ZERO_ADDRESS.");
775         require(_addresses[1] != address(0), "Beneficiary Address is ZERO_ADDRESS.");
776         require(_addresses[2] != address(0), "Treasury Address is ZERO_ADDRESS.");
777         require(_fiatAmountInCents > 0, "Payment amount in fiat is zero.");
778         require(_frequency > 0, "Payment frequency is zero.");
779         require(_frequency < OVERFLOW_LIMITER_NUMBER, "Payment frequency is higher thant the overflow limit.");
780         require(_numberOfPayments > 0, "Payment number of payments is zero.");
781         require(_numberOfPayments < OVERFLOW_LIMITER_NUMBER, "Payment number of payments is higher thant the overflow limit.");
782         require(_startTimestamp > 0, "Payment start time is zero.");
783         require(_startTimestamp < OVERFLOW_LIMITER_NUMBER, "Payment start time is higher thant the overflow limit.");
784 
785         pullPayments[_addresses[0]][_addresses[1]].currency = _currency;
786         pullPayments[_addresses[0]][_addresses[1]].initialPaymentAmountInCents = _initialPaymentAmountInCents;
787         pullPayments[_addresses[0]][_addresses[1]].fiatAmountInCents = _fiatAmountInCents;
788         pullPayments[_addresses[0]][_addresses[1]].frequency = _frequency;
789         pullPayments[_addresses[0]][_addresses[1]].startTimestamp = _startTimestamp;
790         pullPayments[_addresses[0]][_addresses[1]].numberOfPayments = _numberOfPayments;
791         pullPayments[_addresses[0]][_addresses[1]].paymentID = _ids[0];
792         pullPayments[_addresses[0]][_addresses[1]].businessID = _ids[1];
793         pullPayments[_addresses[0]][_addresses[1]].uniqueReferenceID = _ids[2];
794         pullPayments[_addresses[0]][_addresses[1]].treasuryAddress = _addresses[2];
795 
796         require(isValidRegistration(
797                 v,
798                 r,
799                 s,
800                 _addresses[0],
801                 _addresses[1],
802                 pullPayments[_addresses[0]][_addresses[1]]),
803             "Invalid pull payment registration - ECRECOVER_FAILED"
804         );
805 
806         pullPayments[_addresses[0]][_addresses[1]].nextPaymentTimestamp = _startTimestamp;
807         pullPayments[_addresses[0]][_addresses[1]].lastPaymentTimestamp = 0;
808         pullPayments[_addresses[0]][_addresses[1]].cancelTimestamp = 0;
809 
810         if (isFundingNeeded(msg.sender)) {
811             msg.sender.transfer(FUNDING_AMOUNT);
812         }
813 
814         emit LogPaymentRegistered(_addresses[0], _ids[0], _ids[1], _ids[2]);
815     }
816 
817     /// @dev Deletes a pull payment for a beneficiary - The deletion needs can be executed only by one of the
818     /// executors of the PumaPay Pull Payment Contract
819     /// and the PumaPay Pull Payment Contract checks that the beneficiary and the paymentID have
820     /// been singed by the client of the account.
821     /// This method sets the cancellation of the pull payment in the pull payments array for this beneficiary specified.
822     /// The balance of the executor (msg.sender) is checked and if funding is needed 1 ETH is transferred.
823     /// Emits 'LogPaymentCancelled' with beneficiary address and paymentID.
824     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
825     /// @param r - R output of ECDSA signature.
826     /// @param s - S output of ECDSA signature.
827     /// @param _paymentID - ID of the payment.
828     /// @param _client - client address that is linked to this pull payment.
829     /// @param _pullPaymentExecutor - address that is allowed to execute this pull payment.
830     function deletePullPayment(
831         uint8 v,
832         bytes32 r,
833         bytes32 s,
834         bytes32 _paymentID,
835         address _client,
836         address _pullPaymentExecutor
837     )
838     public
839     isExecutor()
840     paymentExists(_client, _pullPaymentExecutor)
841     paymentNotCancelled(_client, _pullPaymentExecutor)
842     isValidDeletionRequest(_paymentID, _client, _pullPaymentExecutor)
843     {
844         require(isValidDeletion(v, r, s, _paymentID, _client, _pullPaymentExecutor), "Invalid deletion - ECRECOVER_FAILED.");
845 
846         pullPayments[_client][_pullPaymentExecutor].cancelTimestamp = now;
847 
848         if (isFundingNeeded(msg.sender)) {
849             msg.sender.transfer(FUNDING_AMOUNT);
850         }
851 
852         emit LogPaymentCancelled(
853             _client,
854             _paymentID,
855             pullPayments[_client][_pullPaymentExecutor].businessID,
856             pullPayments[_client][_pullPaymentExecutor].uniqueReferenceID
857         );
858     }
859 
860     /// ===============================================================================================================
861     ///                                      Public Functions
862     /// ===============================================================================================================
863 
864     /// @dev Executes a pull payment for the msg.sender - The pull payment should exist and the payment request
865     /// should be valid in terms of when it can be executed.
866     /// Emits 'LogPullPaymentExecuted' with client address, msg.sender as the beneficiary address and the paymentID.
867     /// Use Case 1: Single/Recurring Fixed Pull Payment (initialPaymentAmountInCents == 0 )
868     /// ------------------------------------------------
869     /// We calculate the amount in PMA using the rate for the currency specified in the pull payment
870     /// and the 'fiatAmountInCents' and we transfer from the client account the amount in PMA.
871     /// After execution we set the last payment timestamp to NOW, the next payment timestamp is incremented by
872     /// the frequency and the number of payments is decreased by 1.
873     /// Use Case 2: Recurring Fixed Pull Payment with initial fee (initialPaymentAmountInCents > 0)
874     /// ------------------------------------------------------------------------------------------------
875     /// We calculate the amount in PMA using the rate for the currency specified in the pull payment
876     /// and the 'initialPaymentAmountInCents' and we transfer from the client account the amount in PMA.
877     /// After execution we set the last payment timestamp to NOW and the 'initialPaymentAmountInCents to ZERO.
878     /// @param _client - address of the client from which the msg.sender requires to pull funds.
879     /// @param _paymentID - ID of the payment.
880     function executePullPayment(address _client, bytes32 _paymentID)
881     public
882     paymentExists(_client, msg.sender)
883     isValidPullPaymentExecutionRequest(_client, msg.sender, _paymentID)
884     {
885         uint256 amountInPMA;
886 
887         if (pullPayments[_client][msg.sender].initialPaymentAmountInCents > 0) {
888             amountInPMA = calculatePMAFromFiat(
889                 pullPayments[_client][msg.sender].initialPaymentAmountInCents,
890                 pullPayments[_client][msg.sender].currency
891             );
892             pullPayments[_client][msg.sender].initialPaymentAmountInCents = 0;
893         } else {
894             amountInPMA = calculatePMAFromFiat(
895                 pullPayments[_client][msg.sender].fiatAmountInCents,
896                 pullPayments[_client][msg.sender].currency
897             );
898 
899             pullPayments[_client][msg.sender].nextPaymentTimestamp =
900             pullPayments[_client][msg.sender].nextPaymentTimestamp + pullPayments[_client][msg.sender].frequency;
901             pullPayments[_client][msg.sender].numberOfPayments = pullPayments[_client][msg.sender].numberOfPayments - 1;
902         }
903 
904         pullPayments[_client][msg.sender].lastPaymentTimestamp = now;
905         token.transferFrom(
906             _client,
907             pullPayments[_client][msg.sender].treasuryAddress,
908             amountInPMA
909         );
910 
911         emit LogPullPaymentExecuted(
912             _client,
913             pullPayments[_client][msg.sender].paymentID,
914             pullPayments[_client][msg.sender].businessID,
915             pullPayments[_client][msg.sender].uniqueReferenceID
916         );
917     }
918 
919     function getRate(string memory _currency) public view returns (uint256) {
920         return conversionRates[_currency];
921     }
922 
923     /// ===============================================================================================================
924     ///                                      Internal Functions
925     /// ===============================================================================================================
926 
927     /// @dev Calculates the PMA Rate for the fiat currency specified - The rate is set every 10 minutes by our PMA server
928     /// for the currencies specified in the smart contract.
929     /// @param _fiatAmountInCents - payment amount in fiat CENTS so that is always integer
930     /// @param _currency - currency in which the payment needs to take place
931     /// RATE CALCULATION EXAMPLE
932     /// ------------------------
933     /// RATE ==> 1 PMA = 0.01 USD$
934     /// 1 USD$ = 1/0.01 PMA = 100 PMA
935     /// Start the calculation from one ether - PMA Token has 18 decimals
936     /// Multiply by the DECIMAL_FIXER (1e+10) to fix the multiplication of the rate
937     /// Multiply with the fiat amount in cents
938     /// Divide by the Rate of PMA to Fiat in cents
939     /// Divide by the FIAT_TO_CENT_FIXER to fix the _fiatAmountInCents
940     function calculatePMAFromFiat(uint256 _fiatAmountInCents, string memory _currency)
941     internal
942     view
943     validConversionRate(_currency)
944     validAmount(_fiatAmountInCents)
945     returns (uint256) {
946         return ONE_ETHER.mul(DECIMAL_FIXER).mul(_fiatAmountInCents).div(conversionRates[_currency]).div(FIAT_TO_CENT_FIXER);
947     }
948 
949     /// @dev Checks if a registration request is valid by comparing the v, r, s params
950     /// and the hashed params with the client address.
951     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
952     /// @param r - R output of ECDSA signature.
953     /// @param s - S output of ECDSA signature.
954     /// @param _client - client address that is linked to this pull payment.
955     /// @param _pullPaymentExecutor - address that is allowed to execute this pull payment.
956     /// @param _pullPayment - pull payment to be validated.
957     /// @return bool - if the v, r, s params with the hashed params match the client address
958     function isValidRegistration(
959         uint8 v,
960         bytes32 r,
961         bytes32 s,
962         address _client,
963         address _pullPaymentExecutor,
964         PullPayment memory _pullPayment
965     )
966     internal
967     pure
968     returns (bool)
969     {
970         return ecrecover(
971             keccak256(
972                 abi.encodePacked(
973                     _pullPaymentExecutor,
974                     _pullPayment.paymentID,
975                     _pullPayment.businessID,
976                     _pullPayment.uniqueReferenceID,
977                     _pullPayment.treasuryAddress,
978                     _pullPayment.currency,
979                     _pullPayment.initialPaymentAmountInCents,
980                     _pullPayment.fiatAmountInCents,
981                     _pullPayment.frequency,
982                     _pullPayment.numberOfPayments,
983                     _pullPayment.startTimestamp
984                 )
985             ),
986             v, r, s) == _client;
987     }
988 
989     /// @dev Checks if a deletion request is valid by comparing the v, r, s params
990     /// and the hashed params with the client address.
991     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
992     /// @param r - R output of ECDSA signature.
993     /// @param s - S output of ECDSA signature.
994     /// @param _paymentID - ID of the payment.
995     /// @param _client - client address that is linked to this pull payment.
996     /// @param _pullPaymentExecutor - address that is allowed to execute this pull payment.
997     /// @return bool - if the v, r, s params with the hashed params match the client address
998     function isValidDeletion(
999         uint8 v,
1000         bytes32 r,
1001         bytes32 s,
1002         bytes32 _paymentID,
1003         address _client,
1004         address _pullPaymentExecutor
1005     )
1006     internal
1007     view
1008     returns (bool)
1009     {
1010         return ecrecover(
1011             keccak256(
1012                 abi.encodePacked(
1013                     _paymentID,
1014                     _pullPaymentExecutor
1015                 )
1016             ), v, r, s) == _client
1017         && keccak256(
1018             abi.encodePacked(pullPayments[_client][_pullPaymentExecutor].paymentID)
1019         ) == keccak256(abi.encodePacked(_paymentID)
1020         );
1021     }
1022 
1023     /// @dev Checks if a payment for a beneficiary of a client exists.
1024     /// @param _client - client address that is linked to this pull payment.
1025     /// @param _pullPaymentExecutor - address to execute a pull payment.
1026     /// @return bool - whether the beneficiary for this client has a pull payment to execute.
1027     function doesPaymentExist(address _client, address _pullPaymentExecutor)
1028     internal
1029     view
1030     returns (bool) {
1031         return (
1032         bytes(pullPayments[_client][_pullPaymentExecutor].currency).length > 0 &&
1033         pullPayments[_client][_pullPaymentExecutor].fiatAmountInCents > 0 &&
1034         pullPayments[_client][_pullPaymentExecutor].frequency > 0 &&
1035         pullPayments[_client][_pullPaymentExecutor].startTimestamp > 0 &&
1036         pullPayments[_client][_pullPaymentExecutor].numberOfPayments > 0 &&
1037         pullPayments[_client][_pullPaymentExecutor].nextPaymentTimestamp > 0
1038         );
1039     }
1040 
1041     /// @dev Checks if the address of an owner/executor needs to be funded.
1042     /// The minimum amount the owner/executors should always have is 0.001 ETH
1043     /// @param _address - address of owner/executors that the balance is checked against.
1044     /// @return bool - whether the address needs more ETH.
1045     function isFundingNeeded(address _address)
1046     private
1047     view
1048     returns (bool) {
1049         return address(_address).balance <= MINIMUM_AMOUNT_OF_ETH_FOR_OPERATORS;
1050     }
1051 }