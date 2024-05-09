1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity 0.5.8;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
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
29 pragma solidity 0.5.8;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
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
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
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
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity 0.5.8;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://eips.ethereum.org/EIPS/eip-20
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
123      * @dev Total number of tokens in existence
124      */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130      * @dev Gets the balance of the specified address.
131      * @param owner The address to query the balance of.
132      * @return A uint256 representing the amount owned by the passed address.
133      */
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
149      * @dev Transfer token to a specified address
150      * @param to The address to transfer to.
151      * @param value The amount to be transferred.
152      */
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
168         _approve(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _transfer(from, to, value);
182         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     /**
217      * @dev Transfer token for a specified addresses
218      * @param from The address to transfer from.
219      * @param to The address to transfer to.
220      * @param value The amount to be transferred.
221      */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0));
224 
225         _balances[from] = _balances[from].sub(value);
226         _balances[to] = _balances[to].add(value);
227         emit Transfer(from, to, value);
228     }
229 
230     /**
231      * @dev Internal function that mints an amount of the token and assigns it to
232      * an account. This encapsulates the modification of balances such that the
233      * proper events are emitted.
234      * @param account The account that will receive the created tokens.
235      * @param value The amount that will be created.
236      */
237     function _mint(address account, uint256 value) internal {
238         require(account != address(0));
239 
240         _totalSupply = _totalSupply.add(value);
241         _balances[account] = _balances[account].add(value);
242         emit Transfer(address(0), account, value);
243     }
244 
245     /**
246      * @dev Internal function that burns an amount of the token of a given
247      * account.
248      * @param account The account whose tokens will be burnt.
249      * @param value The amount that will be burnt.
250      */
251     function _burn(address account, uint256 value) internal {
252         require(account != address(0));
253 
254         _totalSupply = _totalSupply.sub(value);
255         _balances[account] = _balances[account].sub(value);
256         emit Transfer(account, address(0), value);
257     }
258 
259     /**
260      * @dev Approve an address to spend another addresses' tokens.
261      * @param owner The address that owns the tokens.
262      * @param spender The address that will spend the tokens.
263      * @param value The number of tokens that can be spent.
264      */
265     function _approve(address owner, address spender, uint256 value) internal {
266         require(spender != address(0));
267         require(owner != address(0));
268 
269         _allowed[owner][spender] = value;
270         emit Approval(owner, spender, value);
271     }
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account, deducting from the sender's allowance for said account. Uses the
276      * internal burn function.
277      * Emits an Approval event (reflecting the reduced allowance).
278      * @param account The account whose tokens will be burnt.
279      * @param value The amount that will be burnt.
280      */
281     function _burnFrom(address account, uint256 value) internal {
282         _burn(account, value);
283         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
284     }
285 }
286 
287 // File: openzeppelin-solidity/contracts/access/Roles.sol
288 
289 pragma solidity 0.5.8;
290 
291 /**
292  * @title Roles
293  * @dev Library for managing addresses assigned to a Role.
294  */
295 library Roles {
296     struct Role {
297         mapping (address => bool) bearer;
298     }
299 
300     /**
301      * @dev give an account access to this role
302      */
303     function add(Role storage role, address account) internal {
304         require(account != address(0));
305         require(!has(role, account));
306 
307         role.bearer[account] = true;
308     }
309 
310     /**
311      * @dev remove an account's access to this role
312      */
313     function remove(Role storage role, address account) internal {
314         require(account != address(0));
315         require(has(role, account));
316 
317         role.bearer[account] = false;
318     }
319 
320     /**
321      * @dev check if an account has this role
322      * @return bool
323      */
324     function has(Role storage role, address account) internal view returns (bool) {
325         require(account != address(0));
326         return role.bearer[account];
327     }
328 }
329 
330 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
331 
332 pragma solidity 0.5.8;
333 
334 
335 contract MinterRole {
336     using Roles for Roles.Role;
337 
338     event MinterAdded(address indexed account);
339     event MinterRemoved(address indexed account);
340 
341     Roles.Role private _minters;
342 
343     constructor () internal {
344         _addMinter(msg.sender);
345     }
346 
347     modifier onlyMinter() {
348         require(isMinter(msg.sender));
349         _;
350     }
351 
352     function isMinter(address account) public view returns (bool) {
353         return _minters.has(account);
354     }
355 
356     function addMinter(address account) public onlyMinter {
357         _addMinter(account);
358     }
359 
360     function renounceMinter() public {
361         _removeMinter(msg.sender);
362     }
363 
364     function _addMinter(address account) internal {
365         _minters.add(account);
366         emit MinterAdded(account);
367     }
368 
369     function _removeMinter(address account) internal {
370         _minters.remove(account);
371         emit MinterRemoved(account);
372     }
373 }
374 
375 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
376 
377 pragma solidity 0.5.8;
378 
379 
380 
381 /**
382  * @title ERC20Mintable
383  * @dev ERC20 minting logic
384  */
385 contract ERC20Mintable is ERC20, MinterRole {
386     /**
387      * @dev Function to mint tokens
388      * @param to The address that will receive the minted tokens.
389      * @param value The amount of tokens to mint.
390      * @return A boolean that indicates if the operation was successful.
391      */
392     function mint(address to, uint256 value) public onlyMinter returns (bool) {
393         _mint(to, value);
394         return true;
395     }
396 }
397 
398 // File: contracts/ownership/PayableOwnable.sol
399 
400 pragma solidity 0.5.8;
401 
402 /**
403  * @title PayableOwnable
404  * @dev The PayableOwnable contract has an owner address, and provides basic authorization control
405  * functions, this simplifies the implementation of "user permissions".
406  * PayableOwnable is extended from open-zeppelin Ownable smart contract, with the difference of making the owner
407  * a payable address.
408  */
409 contract PayableOwnable {
410     address payable private _owner;
411 
412     event OwnershipTransferred(
413         address indexed previousOwner,
414         address indexed newOwner
415     );
416 
417     /**
418      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
419      * account.
420      */
421     constructor() internal {
422         _owner = msg.sender;
423         emit OwnershipTransferred(address(0), _owner);
424     }
425 
426     /**
427      * @return the address of the owner.
428      */
429     function owner() public view returns (address payable) {
430         return _owner;
431     }
432 
433     /**
434      * @dev Throws if called by any account other than the owner.
435      */
436     modifier onlyOwner() {
437         require(isOwner());
438         _;
439     }
440 
441     /**
442      * @return true if `msg.sender` is the owner of the contract.
443      */
444     function isOwner() public view returns (bool) {
445         return msg.sender == _owner;
446     }
447 
448     /**
449      * @dev Allows the current owner to relinquish control of the contract.
450      * @notice Renouncing to ownership will leave the contract without an owner.
451      * It will not be possible to call the functions with the `onlyOwner`
452      * modifier anymore.
453      */
454     function renounceOwnership() public onlyOwner {
455         emit OwnershipTransferred(_owner, address(0));
456         _owner = address(0);
457     }
458 
459     /**
460      * @dev Allows the current owner to transfer control of the contract to a newOwner.
461      * @param newOwner The address to transfer ownership to.
462      */
463     function transferOwnership(address payable newOwner) public onlyOwner {
464         _transferOwnership(newOwner);
465     }
466 
467     /**
468      * @dev Transfers control of the contract to a newOwner.
469      * @param newOwner The address to transfer ownership to.
470      */
471     function _transferOwnership(address payable newOwner) internal {
472         require(newOwner != address(0));
473         emit OwnershipTransferred(_owner, newOwner);
474         _owner = newOwner;
475     }
476 }
477 
478 // File: contracts/PumaPayPullPaymentV2.sol
479 
480 pragma solidity 0.5.8;
481 
482 
483 
484 contract PumaPayPullPayment is PayableOwnable {
485 
486     using SafeMath for uint256;
487 
488     /// ===============================================================================================================
489     ///                                      Events
490     /// ===============================================================================================================
491 
492     event LogExecutorAdded(address executor);
493     event LogExecutorRemoved(address executor);
494     event LogSetConversionRate(string currency, uint256 conversionRate);
495 
496     event LogPullPaymentRegistered(
497         address customerAddress,
498         bytes32 paymentID,
499         string uniqueReferenceID
500     );
501 
502     event LogPullPaymentCancelled(
503         address customerAddress,
504         bytes32 paymentID,
505         string uniqueReferenceID
506     );
507 
508     event LogPullPaymentExecuted(
509         address customerAddress,
510         bytes32 paymentID,
511         string uniqueReferenceID,
512         uint256 pmaAmountTransferred
513     );
514 
515     /// ===============================================================================================================
516     ///                                      Constants
517     /// ===============================================================================================================
518 
519     uint256 constant private DECIMAL_FIXER = 10 ** 10;              /// 1e^10 - This transforms the Rate from decimals to uint256
520     uint256 constant private FIAT_TO_CENT_FIXER = 100;              /// Fiat currencies have 100 cents in 1 basic monetary unit.
521     uint256 constant private OVERFLOW_LIMITER_NUMBER = 10 ** 20;    /// 1e^20 - Prevent numeric overflows
522 
523     uint256 constant private ONE_ETHER = 1 ether;                               /// PumaPay token has 18 decimals - same as one ETHER
524     uint256 constant private FUNDING_AMOUNT = 0.5 ether;                          /// Amount to transfer to owner/executor
525     uint256 constant private MINIMUM_AMOUNT_OF_ETH_FOR_OPERATORS = 0.15 ether;  /// min amount of ETH for owner/executor
526 
527     /// ===============================================================================================================
528     ///                                      Members
529     /// ===============================================================================================================
530 
531     IERC20 public token;
532 
533     mapping(string => uint256) private conversionRates;
534     mapping(address => bool) public executors;
535     mapping(address => mapping(address => PullPayment)) public pullPayments;
536 
537     struct PullPayment {
538         bytes32 paymentID;                      /// ID of the payment
539         bytes32 businessID;                     /// ID of the business
540         string uniqueReferenceID;               /// unique reference ID the business is adding on the pull payment
541         string currency;                        /// 3-letter abbr i.e. 'EUR' / 'USD' etc.
542         uint256 initialPaymentAmountInCents;    /// initial payment amount in fiat in cents
543         uint256 fiatAmountInCents;              /// payment amount in fiat in cents
544         uint256 frequency;                      /// how often merchant can pull - in seconds
545         uint256 numberOfPayments;               /// amount of pull payments merchant can make
546         uint256 startTimestamp;                 /// when subscription starts - in seconds
547         uint256 nextPaymentTimestamp;           /// timestamp of next payment
548         uint256 lastPaymentTimestamp;           /// timestamp of last payment
549         uint256 cancelTimestamp;                /// timestamp the payment was cancelled
550         address treasuryAddress;                /// address which pma tokens will be transfer to on execution
551     }
552 
553     /// ===============================================================================================================
554     ///                                      Modifiers
555     /// ===============================================================================================================
556     modifier isExecutor() {
557         require(executors[msg.sender], "msg.sender not an executor");
558         _;
559     }
560 
561     modifier executorExists(address _executor) {
562         require(executors[_executor], "Executor does not exists.");
563         _;
564     }
565 
566     modifier executorDoesNotExists(address _executor) {
567         require(!executors[_executor], "Executor already exists.");
568         _;
569     }
570 
571     modifier paymentExists(address _customer, address _pullPaymentExecutor) {
572         require(doesPaymentExist(_customer, _pullPaymentExecutor), "Pull Payment does not exists");
573         _;
574     }
575 
576     modifier paymentNotCancelled(address _customer, address _pullPaymentExecutor) {
577         require(pullPayments[_customer][_pullPaymentExecutor].cancelTimestamp == 0, "Pull Payment is cancelled.");
578         _;
579     }
580 
581     modifier isValidPullPaymentExecutionRequest(address _customer, address _pullPaymentExecutor, bytes32 _paymentID) {
582         require(
583             (pullPayments[_customer][_pullPaymentExecutor].initialPaymentAmountInCents > 0 ||
584         (now >= pullPayments[_customer][_pullPaymentExecutor].startTimestamp &&
585         now >= pullPayments[_customer][_pullPaymentExecutor].nextPaymentTimestamp)
586             ), "Invalid pull payment execution request - Time of execution is invalid."
587         );
588         require(pullPayments[_customer][_pullPaymentExecutor].numberOfPayments > 0,
589             "Invalid pull payment execution request - Number of payments is zero.");
590 
591         require((pullPayments[_customer][_pullPaymentExecutor].cancelTimestamp == 0 ||
592         pullPayments[_customer][_pullPaymentExecutor].cancelTimestamp > pullPayments[_customer][_pullPaymentExecutor].nextPaymentTimestamp),
593             "Invalid pull payment execution request - Pull payment is cancelled");
594         require(keccak256(
595             abi.encodePacked(pullPayments[_customer][_pullPaymentExecutor].paymentID)
596         ) == keccak256(abi.encodePacked(_paymentID)),
597             "Invalid pull payment execution request - Payment ID not matching.");
598         _;
599     }
600 
601     modifier isValidDeletionRequest(bytes32 _paymentID, address _customer, address _pullPaymentExecutor) {
602         require(_customer != address(0), "Invalid deletion request - Client address is ZERO_ADDRESS.");
603         require(_pullPaymentExecutor != address(0), "Invalid deletion request - Beneficiary address is ZERO_ADDRESS.");
604         require(_paymentID.length != 0, "Invalid deletion request - Payment ID is empty.");
605         _;
606     }
607 
608     modifier isValidAddress(address _address) {
609         require(_address != address(0), "Invalid address - ZERO_ADDRESS provided");
610         _;
611     }
612 
613     modifier validConversionRate(string memory _currency) {
614         require(bytes(_currency).length != 0, "Invalid conversion rate - Currency is empty.");
615         require(conversionRates[_currency] > 0, "Invalid conversion rate - Must be higher than zero.");
616         _;
617     }
618 
619     modifier validAmount(uint256 _fiatAmountInCents) {
620         require(_fiatAmountInCents > 0, "Invalid amount - Must be higher than zero");
621         _;
622     }
623 
624     /// ===============================================================================================================
625     ///                                      Constructor
626     /// ===============================================================================================================
627 
628     /// @dev Contract constructor - sets the token address that the contract facilitates.
629     /// @param _token Token Address.
630     constructor (address _token)
631     public {
632         require(_token != address(0), "Invalid address for token - ZERO_ADDRESS provided");
633         token = IERC20(_token);
634     }
635 
636     // @notice Will receive any eth sent to the contract
637     function() external payable {
638     }
639 
640     /// ===============================================================================================================
641     ///                                      Public Functions - Owner Only
642     /// ===============================================================================================================
643 
644     /// @dev Adds a new executor. - can be executed only by the onwer.
645     /// When adding a new executor 1 ETH is tranferred to allow the executor to pay for gas.
646     /// The balance of the owner is also checked and if funding is needed 1 ETH is transferred.
647     /// @param _executor - address of the executor which cannot be zero address.
648 
649     function addExecutor(address payable _executor)
650     public
651     onlyOwner
652     isValidAddress(_executor)
653     executorDoesNotExists(_executor)
654     {
655         _executor.transfer(FUNDING_AMOUNT);
656         executors[_executor] = true;
657 
658         if (isFundingNeeded(owner())) {
659             owner().transfer(FUNDING_AMOUNT);
660         }
661 
662         emit LogExecutorAdded(_executor);
663     }
664 
665     /// @dev Removes a new executor. - can be executed only by the onwer.
666     /// The balance of the owner is checked and if funding is needed 1 ETH is transferred.
667     /// @param _executor - address of the executor which cannot be zero address.
668     function removeExecutor(address payable _executor)
669     public
670     onlyOwner
671     isValidAddress(_executor)
672     executorExists(_executor)
673     {
674         executors[_executor] = false;
675         if (isFundingNeeded(owner())) {
676             owner().transfer(FUNDING_AMOUNT);
677         }
678         emit LogExecutorRemoved(_executor);
679     }
680 
681     /// @dev Sets the exchange rate for a currency. - can be executed only by the onwer.
682     /// Emits 'LogSetConversionRate' with the currency and the updated rate.
683     /// The balance of the owner is checked and if funding is needed 1 ETH is transferred.
684     /// @param _currency - address of the executor which cannot be zero address
685     /// @param _rate - address of the executor which cannot be zero address
686     function setRate(string memory _currency, uint256 _rate)
687     public
688     onlyOwner
689     returns (bool) {
690         conversionRates[_currency] = _rate;
691         emit LogSetConversionRate(_currency, _rate);
692 
693         if (isFundingNeeded(owner())) {
694             owner().transfer(FUNDING_AMOUNT);
695         }
696 
697         return true;
698     }
699 
700     /// ===============================================================================================================
701     ///                                      Public Functions - Executors Only
702     /// ===============================================================================================================
703 
704     /// @dev Registers a new pull payment to the PumaPay Pull Payment Contract - The registration can be executed only
705     /// by one of the executors of the PumaPay Pull Payment Contract
706     /// and the PumaPay Pull Payment Contract checks that the pull payment has been singed by the customer of the account.
707     /// The balance of the executor (msg.sender) is checked and if funding is needed 1 ETH is transferred.
708     /// Emits 'LogPullPaymentRegistered' with customer address, beneficiary address and paymentID.
709     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
710     /// @param r - R output of ECDSA signature.
711     /// @param s - S output of ECDSA signature.
712     /// @param _ids - array with the IDs for the payment ([0] paymentID, [1] businessID).
713     /// @param _addresses - all the relevant addresses for the payment.
714     /// @param _currency - currency of the payment / 3-letter abbr i.e. 'EUR'.
715     /// @param _uniqueReferenceID - unique reference ID is the id that the business uses within their system.
716     /// @param _fiatAmountInCents - payment amount in fiat in cents.
717     /// @param _frequency - how often merchant can pull - in seconds.
718     /// @param _numberOfPayments - amount of pull payments merchant can make
719     /// @param _startTimestamp - when subscription starts - in seconds.
720     function registerPullPayment(
721         uint8 v,
722         bytes32 r,
723         bytes32 s,
724         bytes32[2] memory _ids, // [0] paymentID, [1] businessID
725         address[3] memory _addresses, // [0] customer, [1] pull payment executor, [2] treasury wallet
726         string memory _currency,
727         string memory _uniqueReferenceID,
728         uint256 _initialPaymentAmountInCents,
729         uint256 _fiatAmountInCents,
730         uint256 _frequency,
731         uint256 _numberOfPayments,
732         uint256 _startTimestamp
733     )
734     public
735     isExecutor()
736     {
737         require(_ids[0].length > 0, "Payment ID is empty.");
738         require(_ids[1].length > 0, "Business ID is empty.");
739         require(bytes(_currency).length > 0, "Currency is empty.");
740         require(bytes(_uniqueReferenceID).length > 0, "Unique Reference ID is empty.");
741         require(_addresses[0] != address(0), "Customer Address is ZERO_ADDRESS.");
742         require(_addresses[1] != address(0), "Beneficiary Address is ZERO_ADDRESS.");
743         require(_addresses[2] != address(0), "Treasury Address is ZERO_ADDRESS.");
744         require(_fiatAmountInCents > 0, "Payment amount in fiat is zero.");
745         require(_frequency > 0, "Payment frequency is zero.");
746         require(_frequency < OVERFLOW_LIMITER_NUMBER, "Payment frequency is higher thant the overflow limit.");
747         require(_numberOfPayments > 0, "Payment number of payments is zero.");
748         require(_numberOfPayments < OVERFLOW_LIMITER_NUMBER, "Payment number of payments is higher thant the overflow limit.");
749         require(_startTimestamp > 0, "Payment start time is zero.");
750         require(_startTimestamp < OVERFLOW_LIMITER_NUMBER, "Payment start time is higher thant the overflow limit.");
751 
752         pullPayments[_addresses[0]][_addresses[1]].currency = _currency;
753         pullPayments[_addresses[0]][_addresses[1]].initialPaymentAmountInCents = _initialPaymentAmountInCents;
754         pullPayments[_addresses[0]][_addresses[1]].fiatAmountInCents = _fiatAmountInCents;
755         pullPayments[_addresses[0]][_addresses[1]].frequency = _frequency;
756         pullPayments[_addresses[0]][_addresses[1]].startTimestamp = _startTimestamp;
757         pullPayments[_addresses[0]][_addresses[1]].numberOfPayments = _numberOfPayments;
758         pullPayments[_addresses[0]][_addresses[1]].paymentID = _ids[0];
759         pullPayments[_addresses[0]][_addresses[1]].businessID = _ids[1];
760         pullPayments[_addresses[0]][_addresses[1]].uniqueReferenceID = _uniqueReferenceID;
761         pullPayments[_addresses[0]][_addresses[1]].treasuryAddress = _addresses[2];
762 
763         require(isValidRegistration(
764                 v,
765                 r,
766                 s,
767                 _addresses[0],
768                 _addresses[1],
769                 pullPayments[_addresses[0]][_addresses[1]]),
770             "Invalid pull payment registration - ECRECOVER_FAILED"
771         );
772 
773         pullPayments[_addresses[0]][_addresses[1]].nextPaymentTimestamp = _startTimestamp;
774         pullPayments[_addresses[0]][_addresses[1]].lastPaymentTimestamp = 0;
775         pullPayments[_addresses[0]][_addresses[1]].cancelTimestamp = 0;
776 
777         if (isFundingNeeded(msg.sender)) {
778             msg.sender.transfer(FUNDING_AMOUNT);
779         }
780 
781         emit LogPullPaymentRegistered(
782             _addresses[0],
783             _ids[0],
784             _uniqueReferenceID
785         );
786     }
787 
788     /// @dev Deletes a pull payment for a beneficiary - The deletion needs can be executed only by one of the
789     /// executors of the PumaPay Pull Payment Contract
790     /// and the PumaPay Pull Payment Contract checks that the beneficiary and the paymentID have
791     /// been singed by the customer of the account.
792     /// This method sets the cancellation of the pull payment in the pull payments array for this beneficiary specified.
793     /// The balance of the executor (msg.sender) is checked and if funding is needed 1 ETH is transferred.
794     /// Emits 'LogPullPaymentCancelled' with beneficiary address and paymentID.
795     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
796     /// @param r - R output of ECDSA signature.
797     /// @param s - S output of ECDSA signature.
798     /// @param _paymentID - ID of the payment.
799     /// @param _customer - customer address that is linked to this pull payment.
800     /// @param _pullPaymentExecutor - address that is allowed to execute this pull payment.
801     function deletePullPayment(
802         uint8 v,
803         bytes32 r,
804         bytes32 s,
805         bytes32 _paymentID,
806         address _customer,
807         address _pullPaymentExecutor
808     )
809     public
810     isExecutor()
811     paymentExists(_customer, _pullPaymentExecutor)
812     paymentNotCancelled(_customer, _pullPaymentExecutor)
813     isValidDeletionRequest(_paymentID, _customer, _pullPaymentExecutor)
814     {
815         require(isValidDeletion(v, r, s, _paymentID, _customer, _pullPaymentExecutor), "Invalid deletion - ECRECOVER_FAILED.");
816 
817         pullPayments[_customer][_pullPaymentExecutor].cancelTimestamp = now;
818 
819         if (isFundingNeeded(msg.sender)) {
820             msg.sender.transfer(FUNDING_AMOUNT);
821         }
822 
823         emit LogPullPaymentCancelled(
824             _customer,
825             _paymentID,
826             pullPayments[_customer][_pullPaymentExecutor].uniqueReferenceID
827         );
828     }
829 
830     /// ===============================================================================================================
831     ///                                      Public Functions
832     /// ===============================================================================================================
833 
834     /// @dev Executes a pull payment for the msg.sender - The pull payment should exist and the payment request
835     /// should be valid in terms of when it can be executed.
836     /// Emits 'LogPullPaymentExecuted' with customer address, msg.sender as the beneficiary address and the paymentID.
837     /// Use Case 1: Single/Recurring Fixed Pull Payment (initialPaymentAmountInCents == 0 )
838     /// ------------------------------------------------
839     /// We calculate the amount in PMA using the rate for the currency specified in the pull payment
840     /// and the 'fiatAmountInCents' and we transfer from the customer account the amount in PMA.
841     /// After execution we set the last payment timestamp to NOW, the next payment timestamp is incremented by
842     /// the frequency and the number of payments is decreased by 1.
843     /// Use Case 2: Recurring Fixed Pull Payment with initial fee (initialPaymentAmountInCents > 0)
844     /// ------------------------------------------------------------------------------------------------
845     /// We calculate the amount in PMA using the rate for the currency specified in the pull payment
846     /// and the 'initialPaymentAmountInCents' and we transfer from the customer account the amount in PMA.
847     /// After execution we set the last payment timestamp to NOW and the 'initialPaymentAmountInCents to ZERO.
848     /// @param _customer - address of the customer from which the msg.sender requires to pull funds.
849     /// @param _paymentID - ID of the payment.
850     function executePullPayment(address _customer, bytes32 _paymentID)
851     public
852     paymentExists(_customer, msg.sender)
853     isValidPullPaymentExecutionRequest(_customer, msg.sender, _paymentID)
854     {
855         uint256 amountInPMA;
856 
857         if (pullPayments[_customer][msg.sender].initialPaymentAmountInCents > 0) {
858             amountInPMA = calculatePMAFromFiat(
859                 pullPayments[_customer][msg.sender].initialPaymentAmountInCents,
860                 pullPayments[_customer][msg.sender].currency
861             );
862             pullPayments[_customer][msg.sender].initialPaymentAmountInCents = 0;
863         } else {
864             amountInPMA = calculatePMAFromFiat(
865                 pullPayments[_customer][msg.sender].fiatAmountInCents,
866                 pullPayments[_customer][msg.sender].currency
867             );
868 
869             pullPayments[_customer][msg.sender].nextPaymentTimestamp =
870             pullPayments[_customer][msg.sender].nextPaymentTimestamp + pullPayments[_customer][msg.sender].frequency;
871             pullPayments[_customer][msg.sender].numberOfPayments = pullPayments[_customer][msg.sender].numberOfPayments - 1;
872         }
873 
874         pullPayments[_customer][msg.sender].lastPaymentTimestamp = now;
875         token.transferFrom(
876             _customer,
877             pullPayments[_customer][msg.sender].treasuryAddress,
878             amountInPMA
879         );
880 
881         emit LogPullPaymentExecuted(
882             _customer,
883             pullPayments[_customer][msg.sender].paymentID,
884             pullPayments[_customer][msg.sender].uniqueReferenceID,
885             amountInPMA
886         );
887     }
888 
889     function getRate(string memory _currency) public view returns (uint256) {
890         return conversionRates[_currency];
891     }
892 
893     /// ===============================================================================================================
894     ///                                      Internal Functions
895     /// ===============================================================================================================
896 
897     /// @dev Calculates the PMA Rate for the fiat currency specified - The rate is set every 10 minutes by our PMA server
898     /// for the currencies specified in the smart contract.
899     /// @param _fiatAmountInCents - payment amount in fiat CENTS so that is always integer
900     /// @param _currency - currency in which the payment needs to take place
901     /// RATE CALCULATION EXAMPLE
902     /// ------------------------
903     /// RATE ==> 1 PMA = 0.01 USD$
904     /// 1 USD$ = 1/0.01 PMA = 100 PMA
905     /// Start the calculation from one ether - PMA Token has 18 decimals
906     /// Multiply by the DECIMAL_FIXER (1e+10) to fix the multiplication of the rate
907     /// Multiply with the fiat amount in cents
908     /// Divide by the Rate of PMA to Fiat in cents
909     /// Divide by the FIAT_TO_CENT_FIXER to fix the _fiatAmountInCents
910     function calculatePMAFromFiat(uint256 _fiatAmountInCents, string memory _currency)
911     internal
912     view
913     validConversionRate(_currency)
914     validAmount(_fiatAmountInCents)
915     returns (uint256) {
916         return ONE_ETHER.mul(DECIMAL_FIXER).mul(_fiatAmountInCents).div(conversionRates[_currency]).div(FIAT_TO_CENT_FIXER);
917     }
918 
919     /// @dev Checks if a registration request is valid by comparing the v, r, s params
920     /// and the hashed params with the customer address.
921     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
922     /// @param r - R output of ECDSA signature.
923     /// @param s - S output of ECDSA signature.
924     /// @param _customer - customer address that is linked to this pull payment.
925     /// @param _pullPaymentExecutor - address that is allowed to execute this pull payment.
926     /// @param _pullPayment - pull payment to be validated.
927     /// @return bool - if the v, r, s params with the hashed params match the customer address
928     function isValidRegistration(
929         uint8 v,
930         bytes32 r,
931         bytes32 s,
932         address _customer,
933         address _pullPaymentExecutor,
934         PullPayment memory _pullPayment
935     )
936     internal
937     pure
938     returns (bool)
939     {
940         return ecrecover(
941             keccak256(
942                 abi.encodePacked(
943                     _pullPaymentExecutor,
944                     _pullPayment.paymentID,
945                     _pullPayment.businessID,
946                     _pullPayment.uniqueReferenceID,
947                     _pullPayment.treasuryAddress,
948                     _pullPayment.currency,
949                     _pullPayment.initialPaymentAmountInCents,
950                     _pullPayment.fiatAmountInCents,
951                     _pullPayment.frequency,
952                     _pullPayment.numberOfPayments,
953                     _pullPayment.startTimestamp
954                 )
955             ),
956             v, r, s) == _customer;
957     }
958 
959     /// @dev Checks if a deletion request is valid by comparing the v, r, s params
960     /// and the hashed params with the customer address.
961     /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
962     /// @param r - R output of ECDSA signature.
963     /// @param s - S output of ECDSA signature.
964     /// @param _paymentID - ID of the payment.
965     /// @param _customer - customer address that is linked to this pull payment.
966     /// @param _pullPaymentExecutor - address that is allowed to execute this pull payment.
967     /// @return bool - if the v, r, s params with the hashed params match the customer address
968     function isValidDeletion(
969         uint8 v,
970         bytes32 r,
971         bytes32 s,
972         bytes32 _paymentID,
973         address _customer,
974         address _pullPaymentExecutor
975     )
976     internal
977     view
978     returns (bool)
979     {
980         return ecrecover(
981             keccak256(
982                 abi.encodePacked(
983                     _paymentID,
984                     _pullPaymentExecutor
985                 )
986             ), v, r, s) == _customer
987         && keccak256(
988             abi.encodePacked(pullPayments[_customer][_pullPaymentExecutor].paymentID)
989         ) == keccak256(abi.encodePacked(_paymentID)
990         );
991     }
992 
993     /// @dev Checks if a payment for a beneficiary of a customer exists.
994     /// @param _customer - customer address that is linked to this pull payment.
995     /// @param _pullPaymentExecutor - address to execute a pull payment.
996     /// @return bool - whether the beneficiary for this customer has a pull payment to execute.
997     function doesPaymentExist(address _customer, address _pullPaymentExecutor)
998     internal
999     view
1000     returns (bool) {
1001         return (
1002         bytes(pullPayments[_customer][_pullPaymentExecutor].currency).length > 0 &&
1003         pullPayments[_customer][_pullPaymentExecutor].fiatAmountInCents > 0 &&
1004         pullPayments[_customer][_pullPaymentExecutor].frequency > 0 &&
1005         pullPayments[_customer][_pullPaymentExecutor].startTimestamp > 0 &&
1006         pullPayments[_customer][_pullPaymentExecutor].numberOfPayments > 0 &&
1007         pullPayments[_customer][_pullPaymentExecutor].nextPaymentTimestamp > 0
1008         );
1009     }
1010 
1011     /// @dev Checks if the address of an owner/executor needs to be funded.
1012     /// The minimum amount the owner/executors should always have is 0.001 ETH
1013     /// @param _address - address of owner/executors that the balance is checked against.
1014     /// @return bool - whether the address needs more ETH.
1015     function isFundingNeeded(address _address)
1016     private
1017     view
1018     returns (bool) {
1019         return address(_address).balance <= MINIMUM_AMOUNT_OF_ETH_FOR_OPERATORS;
1020     }
1021 }