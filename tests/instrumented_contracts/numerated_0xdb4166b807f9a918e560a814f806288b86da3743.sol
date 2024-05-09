1 pragma solidity 0.5.16;
2 
3 library ExtendedMath {
4     /**
5      * @return The given number raised to the power of 2
6      */
7     function pow2(uint256 a) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * a;
12         require(c / a == a, "ExtendedMath: squaring overflow");
13         return c;
14     }
15 
16     /**
17      * @return The square root of the given number
18      */
19     function sqrt(uint y) internal pure returns (uint z) {
20         if (y > 3) {
21             z = y;
22             uint x = y / 2 + 1;
23             while (x < z) {
24                 z = x;
25                 x = (y / x + x) / 2;
26             }
27         } else if (y != 0) {
28             z = 1;
29         }
30     }
31 }
32 
33 
34 /**
35  * @dev Collection of functions related to the address type
36  */
37 library Address {
38     /**
39      * @dev Returns true if `account` is a contract.
40      *
41      * [IMPORTANT]
42      * ====
43      * It is unsafe to assume that an address for which this function returns
44      * false is an externally-owned account (EOA) and not a contract.
45      *
46      * Among others, `isContract` will return false for the following 
47      * types of addresses:
48      *
49      *  - an externally-owned account
50      *  - a contract in construction
51      *  - an address where a contract will be created
52      *  - an address where a contract lived, but was destroyed
53      * ====
54      */
55     function isContract(address account) internal view returns (bool) {
56         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
57         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
58         // for accounts without code, i.e. `keccak256('')`
59         bytes32 codehash;
60         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
61         // solhint-disable-next-line no-inline-assembly
62         assembly { codehash := extcodehash(account) }
63         return (codehash != accountHash && codehash != 0x0);
64     }
65 
66     /**
67      * @dev Converts an `address` into `address payable`. Note that this is
68      * simply a type cast: the actual underlying value is not changed.
69      *
70      * _Available since v2.4.0._
71      */
72     function toPayable(address account) internal pure returns (address payable) {
73         return address(uint160(account));
74     }
75 
76     /**
77      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
78      * `recipient`, forwarding all available gas and reverting on errors.
79      *
80      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
81      * of certain opcodes, possibly making contracts go over the 2300 gas limit
82      * imposed by `transfer`, making them unable to receive funds via
83      * `transfer`. {sendValue} removes this limitation.
84      *
85      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
86      *
87      * IMPORTANT: because control is transferred to `recipient`, care must be
88      * taken to not create reentrancy vulnerabilities. Consider using
89      * {ReentrancyGuard} or the
90      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
91      *
92      * _Available since v2.4.0._
93      */
94     function sendValue(address payable recipient, uint256 amount) internal {
95         require(address(this).balance >= amount, "Address: insufficient balance");
96 
97         // solhint-disable-next-line avoid-call-value
98         (bool success, ) = recipient.call.value(amount)("");
99         require(success, "Address: unable to send value, recipient may have reverted");
100     }
101 }
102 
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      * - Subtraction cannot overflow.
155      *
156      * _Available since v2.4.0._
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      *
214      * _Available since v2.4.0._
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         // Solidity only automatically asserts when dividing by 0
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      * - The divisor cannot be zero.
250      *
251      * _Available since v2.4.0._
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 
260 contract Sacrifice {
261     constructor(address payable _recipient) public payable {
262         selfdestruct(_recipient);
263     }
264 }
265 
266 
267 
268 interface IERC20Mintable {
269     function transfer(address _to, uint256 _value) external returns (bool);
270     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
271     function mint(address _to, uint256 _value) external returns (bool);
272     function balanceOf(address _account) external view returns (uint256);
273     function totalSupply() external view returns (uint256);
274 }
275 
276 
277 
278 
279 
280 
281 
282 /**
283  * @title Initializable
284  *
285  * @dev Helper contract to support initializer functions. To use it, replace
286  * the constructor with a function that has the `initializer` modifier.
287  * WARNING: Unlike constructors, initializer functions must be manually
288  * invoked. This applies both to deploying an Initializable contract, as well
289  * as extending an Initializable contract via inheritance.
290  * WARNING: When used with inheritance, manual care must be taken to not invoke
291  * a parent initializer twice, or ensure that all initializers are idempotent,
292  * because this is not dealt with automatically as with constructors.
293  */
294 contract Initializable {
295 
296   /**
297    * @dev Indicates that the contract has been initialized.
298    */
299   bool private initialized;
300 
301   /**
302    * @dev Indicates that the contract is in the process of being initialized.
303    */
304   bool private initializing;
305 
306   /**
307    * @dev Modifier to use in the initializer function of a contract.
308    */
309   modifier initializer() {
310     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
311 
312     bool isTopLevelCall = !initializing;
313     if (isTopLevelCall) {
314       initializing = true;
315       initialized = true;
316     }
317 
318     _;
319 
320     if (isTopLevelCall) {
321       initializing = false;
322     }
323   }
324 
325   /// @dev Returns true if and only if the function is running in the constructor
326   function isConstructor() private view returns (bool) {
327     // extcodesize checks the size of the code stored in an address, and
328     // address returns the current address. Since the code is still not
329     // deployed when running a constructor, any checks on its code size will
330     // yield zero, making it an effective way to detect if a contract is
331     // under construction or not.
332     address self = address(this);
333     uint256 cs;
334     assembly { cs := extcodesize(self) }
335     return cs == 0;
336   }
337 
338   // Reserved storage space to allow for layout changes in the future.
339   uint256[50] private ______gap;
340 }
341 
342 
343 
344 
345 
346 
347 /*
348  * @dev Provides information about the current execution context, including the
349  * sender of the transaction and its data. While these are generally available
350  * via msg.sender and msg.data, they should not be accessed in such a direct
351  * manner, since when dealing with GSN meta-transactions the account sending and
352  * paying for execution may not be the actual sender (as far as an application
353  * is concerned).
354  *
355  * This contract is only required for intermediate, library-like contracts.
356  */
357 contract Context is Initializable {
358     // Empty internal constructor, to prevent people from mistakenly deploying
359     // an instance of this contract, which should be used via inheritance.
360     constructor () internal { }
361     // solhint-disable-previous-line no-empty-blocks
362 
363     function _msgSender() internal view returns (address payable) {
364         return msg.sender;
365     }
366 
367     function _msgData() internal view returns (bytes memory) {
368         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
369         return msg.data;
370     }
371 }
372 
373 
374 /**
375  * @dev Contract module which provides a basic access control mechanism, where
376  * there is an account (an owner) that can be granted exclusive access to
377  * specific functions.
378  *
379  * This module is used through inheritance. It will make available the modifier
380  * `onlyOwner`, which can be aplied to your functions to restrict their use to
381  * the owner.
382  */
383 contract Ownable is Initializable, Context {
384     address private _owner;
385 
386     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
387 
388     /**
389      * @dev Initializes the contract setting the deployer as the initial owner.
390      */
391     function initialize(address sender) public initializer {
392         _owner = sender;
393         emit OwnershipTransferred(address(0), _owner);
394     }
395 
396     /**
397      * @dev Returns the address of the current owner.
398      */
399     function owner() public view returns (address) {
400         return _owner;
401     }
402 
403     /**
404      * @dev Throws if called by any account other than the owner.
405      */
406     modifier onlyOwner() {
407         require(isOwner(), "Ownable: caller is not the owner");
408         _;
409     }
410 
411     /**
412      * @dev Returns true if the caller is the current owner.
413      */
414     function isOwner() public view returns (bool) {
415         return _msgSender() == _owner;
416     }
417 
418     /**
419      * @dev Leaves the contract without owner. It will not be possible to call
420      * `onlyOwner` functions anymore. Can only be called by the current owner.
421      *
422      * > Note: Renouncing ownership will leave the contract without an owner,
423      * thereby removing any functionality that is only available to the owner.
424      */
425     function renounceOwnership() public onlyOwner {
426         emit OwnershipTransferred(_owner, address(0));
427         _owner = address(0);
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Can only be called by the current owner.
433      */
434     function transferOwnership(address newOwner) public onlyOwner {
435         _transferOwnership(newOwner);
436     }
437 
438     /**
439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
440      */
441     function _transferOwnership(address newOwner) internal {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         emit OwnershipTransferred(_owner, newOwner);
444         _owner = newOwner;
445     }
446 
447     uint256[50] private ______gap;
448 }
449 
450 
451 
452 
453 
454 
455 
456 /**
457  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
458  * the optional functions; to access them see {ERC20Detailed}.
459  */
460 interface IERC20 {
461     /**
462      * @dev Returns the amount of tokens in existence.
463      */
464     function totalSupply() external view returns (uint256);
465 
466     /**
467      * @dev Returns the amount of tokens owned by `account`.
468      */
469     function balanceOf(address account) external view returns (uint256);
470 
471     /**
472      * @dev Moves `amount` tokens from the caller's account to `recipient`.
473      *
474      * Returns a boolean value indicating whether the operation succeeded.
475      *
476      * Emits a {Transfer} event.
477      */
478     function transfer(address recipient, uint256 amount) external returns (bool);
479 
480     /**
481      * @dev Returns the remaining number of tokens that `spender` will be
482      * allowed to spend on behalf of `owner` through {transferFrom}. This is
483      * zero by default.
484      *
485      * This value changes when {approve} or {transferFrom} are called.
486      */
487     function allowance(address owner, address spender) external view returns (uint256);
488 
489     /**
490      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
491      *
492      * Returns a boolean value indicating whether the operation succeeded.
493      *
494      * IMPORTANT: Beware that changing an allowance with this method brings the risk
495      * that someone may use both the old and the new allowance by unfortunate
496      * transaction ordering. One possible solution to mitigate this race
497      * condition is to first reduce the spender's allowance to 0 and set the
498      * desired value afterwards:
499      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
500      *
501      * Emits an {Approval} event.
502      */
503     function approve(address spender, uint256 amount) external returns (bool);
504 
505     /**
506      * @dev Moves `amount` tokens from `sender` to `recipient` using the
507      * allowance mechanism. `amount` is then deducted from the caller's
508      * allowance.
509      *
510      * Returns a boolean value indicating whether the operation succeeded.
511      *
512      * Emits a {Transfer} event.
513      */
514     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
515 
516     /**
517      * @dev Emitted when `value` tokens are moved from one account (`from`) to
518      * another (`to`).
519      *
520      * Note that `value` may be zero.
521      */
522     event Transfer(address indexed from, address indexed to, uint256 value);
523 
524     /**
525      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
526      * a call to {approve}. `value` is the new allowance.
527      */
528     event Approval(address indexed owner, address indexed spender, uint256 value);
529 }
530 
531 
532 
533 
534 /**
535  * @title SafeERC20
536  * @dev Wrappers around ERC20 operations that throw on failure (when the token
537  * contract returns false). Tokens that return no value (and instead revert or
538  * throw on failure) are also supported, non-reverting calls are assumed to be
539  * successful.
540  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
541  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
542  */
543 library SafeERC20 {
544     using SafeMath for uint256;
545     using Address for address;
546 
547     function safeTransfer(IERC20 token, address to, uint256 value) internal {
548         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
549     }
550 
551     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
552         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
553     }
554 
555     function safeApprove(IERC20 token, address spender, uint256 value) internal {
556         // safeApprove should only be called when setting an initial allowance,
557         // or when resetting it to zero. To increase and decrease it, use
558         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
559         // solhint-disable-next-line max-line-length
560         require((value == 0) || (token.allowance(address(this), spender) == 0),
561             "SafeERC20: approve from non-zero to non-zero allowance"
562         );
563         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
564     }
565 
566     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
567         uint256 newAllowance = token.allowance(address(this), spender).add(value);
568         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
569     }
570 
571     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
572         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
573         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
574     }
575 
576     /**
577      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
578      * on the return value: the return value is optional (but if data is returned, it must not be false).
579      * @param token The token targeted by the call.
580      * @param data The call data (encoded using abi.encode or one of its variants).
581      */
582     function callOptionalReturn(IERC20 token, bytes memory data) private {
583         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
584         // we're implementing it ourselves.
585 
586         // A Solidity high level call has three parts:
587         //  1. The target address is checked to verify it contains contract code
588         //  2. The call itself is made, and success asserted
589         //  3. The return value is decoded, which in turn checks the size of the returned data.
590         // solhint-disable-next-line max-line-length
591         require(address(token).isContract(), "SafeERC20: call to non-contract");
592 
593         // solhint-disable-next-line avoid-low-level-calls
594         (bool success, bytes memory returndata) = address(token).call(data);
595         require(success, "SafeERC20: low-level call failed");
596 
597         if (returndata.length > 0) { // Return data is optional
598             // solhint-disable-next-line max-line-length
599             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
600         }
601     }
602 }
603 
604 
605 
606 
607 
608 /**
609  * @dev Contract module that helps prevent reentrant calls to a function.
610  *
611  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
612  * available, which can be applied to functions to make sure there are no nested
613  * (reentrant) calls to them.
614  *
615  * Note that because there is a single `nonReentrant` guard, functions marked as
616  * `nonReentrant` may not call one another. This can be worked around by making
617  * those functions `private`, and then adding `external` `nonReentrant` entry
618  * points to them.
619  */
620 contract ReentrancyGuard is Initializable {
621     // counter to allow mutex lock with only one SSTORE operation
622     uint256 private _guardCounter;
623 
624     function initialize() public initializer {
625         // The counter starts at one to prevent changing it from zero to a non-zero
626         // value, which is a more expensive operation.
627         _guardCounter = 1;
628     }
629 
630     /**
631      * @dev Prevents a contract from calling itself, directly or indirectly.
632      * Calling a `nonReentrant` function from another `nonReentrant`
633      * function is not supported. It is possible to prevent this from happening
634      * by making the `nonReentrant` function external, and make it call a
635      * `private` function that does the actual work.
636      */
637     modifier nonReentrant() {
638         _guardCounter += 1;
639         uint256 localCounter = _guardCounter;
640         _;
641         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
642     }
643 
644     uint256[50] private ______gap;
645 }
646 
647 
648 
649 /**
650  * @title EasyStaking
651  *
652  * Note: all percentage values are between 0 (0%) and 1 (100%)
653  * and represented as fixed point numbers containing 18 decimals like with Ether
654  * 100% == 1 ether
655  */
656 contract EasyStaking is Ownable, ReentrancyGuard {
657     using Address for address;
658     using SafeMath for uint256;
659     using SafeERC20 for IERC20;
660 
661 
662     /**
663      * @dev Emitted when a user deposits tokens.
664      * @param sender User address.
665      * @param id User's unique deposit ID.
666      * @param amount The amount of deposited tokens.
667      * @param balance Current user balance.
668      * @param accruedEmission User's accrued emission.
669      * @param prevDepositDuration Duration of the previous deposit in seconds.
670      */
671     event Deposited(
672         address indexed sender,
673         uint256 indexed id,
674         uint256 amount,
675         uint256 balance,
676         uint256 accruedEmission,
677         uint256 prevDepositDuration
678     );
679 
680 
681     /**
682      * @dev Emitted when a user withdraws tokens.
683      * @param sender User address.
684      * @param id User's unique deposit ID.
685      * @param amount The amount of withdrawn tokens.
686      * @param balance Current user balance.
687      * @param accruedEmission User's accrued emission.
688      * @param lastDepositDuration Duration of the last deposit in seconds.
689      */
690     event Withdrawn(
691         address indexed sender,
692         uint256 indexed id,
693         uint256 amount,
694         uint256 balance,
695         uint256 accruedEmission,
696         uint256 lastDepositDuration
697     );
698 
699     /**
700      * @dev Emitted when a user withdraws Reward tokens.
701      * @param sender User address.
702      * @param id User's unique deposit ID.
703      * @param rewardAmount The amount of withdrawn tokens.
704      * @param claimedRewards The amount of already claimed rewards.
705      */
706     event WithdrawnRewards(
707         address indexed sender,
708         uint256 indexed id,
709         uint256 rewardAmount,
710         uint256 claimedRewards
711     );
712     
713 
714     /**
715      * @dev Emitted when a new Liquidity Provider address value is set.
716      * @param value A new address value.
717      * @param sender The owner address at the moment of address changing.
718      */
719     event LiquidityProviderAddressSet(address value, address sender);
720 
721     uint256 private constant YEAR = 365 days;
722     // The maximum emission rate (in percentage)
723     uint256 public constant MAX_EMISSION_RATE = 150 finney; // 15%, 0.15 ether
724     // The period after which the new value of the parameter is set
725     uint256 public constant PARAM_UPDATE_DELAY = 7 days;
726 
727     // STAKE token
728     IERC20Mintable public token;
729     
730     // Reward Token
731     IERC20Mintable public tokenReward;
732     
733     
734     struct UintParam {
735         uint256 oldValue;
736         uint256 newValue;
737         uint256 timestamp;
738     }
739 
740     struct AddressParam {
741         address oldValue;
742         address newValue;
743         uint256 timestamp;
744     }
745 
746 
747     // The address for the Liquidity Providers 
748     AddressParam public liquidityProviderAddressParam;
749 
750     // The deposit balances of users
751     mapping (address => mapping (uint256 => uint256)) public balances;
752     // The dates of users' deposits
753     mapping (address => mapping (uint256 => uint256)) public depositDates;
754     // The last deposit id
755     mapping (address => uint256) public lastDepositIds;
756     // Rewards tokens sum 
757     mapping (address => mapping (uint256 => uint256)) public claimedRewards;
758     // To claim rewards tokens sum
759     mapping (address => mapping (uint256 => uint256)) public toClaimRewards;
760     // The total staked amount
761     uint256 public totalStaked;
762 
763     // Variable that prevents _deposit method from being called 2 times
764     bool private locked;
765     // The library that is used to calculate user's current emission rate
766 
767 
768     /**
769      * @dev Initializes the contract.
770      * @param _owner The owner of the contract.
771      * @param _tokenAddress The address of the STAKE token contract.
772      * @param _liquidityProviderAddress The address for the Liquidity Providers reward.
773      */
774     function initialize(
775         address _owner,
776         address _tokenAddress,
777         address _tokenReward,
778         address _liquidityProviderAddress
779     ) external initializer {
780         require(_owner != address(0), "zero address");
781         require(_tokenAddress.isContract(), "not a contract address");
782         Ownable.initialize(msg.sender);
783         ReentrancyGuard.initialize();
784         token = IERC20Mintable(_tokenAddress);
785         tokenReward = IERC20Mintable(_tokenReward);
786         setLiquidityProviderAddress(_liquidityProviderAddress);
787         Ownable.transferOwnership(_owner);
788     }
789 
790 
791     /**
792      * @dev This method is used to deposit tokens to the deposit opened before.
793      * It calls the internal "_deposit" method and transfers tokens from sender to contract.
794      * Sender must approve tokens first.
795      *
796      * Instead this, user can use the simple "transfer" method of STAKE token contract to make a deposit.
797      * Sender's approval is not needed in this case.
798      *
799      * Note: each call updates the deposit date so be careful if you want to make a long staking.
800      *
801      * @param _depositId User's unique deposit ID.
802      * @param _amount The amount to deposit.
803      */
804     function deposit(uint256 _depositId, uint256 _amount) public {
805         require (_depositId <=4 );
806         lastDepositIds[msg.sender]=3;
807         _deposit(msg.sender, _depositId, _amount);
808         _setLocked(true);
809         require(token.transferFrom(msg.sender, address(this), _amount), "transfer failed");
810         _setLocked(false);
811     }
812 
813  
814     /**
815      * @dev This method is used to make a withdrawal.
816      * It calls the internal "_withdraw" method.
817      * @param _depositId User's unique deposit ID
818      * @param _amount The amount to withdraw (0 - to withdraw all).
819      */
820     function makeWithdrawal(uint256 _depositId, uint256 _amount) external {
821         uint256 requestDate = depositDates[msg.sender][_depositId];
822         uint256 timestamp = _now();
823         uint256 lockEnd = 0;
824         if (_depositId==1) {
825             lockEnd=60;
826         } else if (_depositId==2) {
827             lockEnd=60*60*24*30*3; // 3 months
828         } else {
829             lockEnd=60*60*24*30*6; // 6 months
830         }
831         require(timestamp >= requestDate+lockEnd, "too early. Lockup period");
832         _withdraw(msg.sender, _depositId, _amount);
833     }
834 
835     /**
836      * @dev This method is used to make a Rewards withdrawal.
837      * It calls the internal "_withdraw" method.
838      * @param _depositId User's unique deposit ID
839      */
840     function makeWithdrawalRewards(uint256 _depositId) external {
841         _withdrawRewards(msg.sender, _depositId);
842     }
843 
844 
845     /**
846      * @dev This method is used to claim unsupported tokens accidentally sent to the contract.
847      * It can only be called by the owner.
848      * @param _token The address of the token contract (zero address for claiming native coins).
849      * @param _to The address of the tokens/coins receiver.
850      * @param _amount Amount to claim.
851      */
852     function claimTokens(address _token, address payable _to, uint256 _amount) external onlyOwner {
853         require(_to != address(0) && _to != address(this), "not a valid recipient");
854         require(_amount > 0, "amount should be greater than 0");
855         if (_token == address(0)) {
856             if (!_to.send(_amount)) { // solium-disable-line security/no-send
857                 (new Sacrifice).value(_amount)(_to);
858             }
859         } else if (_token == address(token)) {
860             uint256 availableAmount = token.balanceOf(address(this)).sub(totalStaked);
861             require(availableAmount >= _amount, "insufficient funds");
862             require(token.transfer(_to, _amount), "transfer failed");
863         } else {
864             IERC20 customToken = IERC20(_token);
865             customToken.safeTransfer(_to, _amount);
866         }
867     }
868 
869 
870     /**
871      * @dev Sets the address for the Liquidity Providers reward.
872      * Can only be called by owner.
873      * @param _address The new address.
874      */
875     function setLiquidityProviderAddress(address _address) public onlyOwner {
876         require(_address != address(0), "zero address");
877         require(_address != address(this), "wrong address");
878         AddressParam memory param = liquidityProviderAddressParam;
879         if (param.timestamp == 0) {
880             param.oldValue = _address;
881         } else if (_paramUpdateDelayElapsed(param.timestamp)) {
882             param.oldValue = param.newValue;
883         }
884         param.newValue = _address;
885         param.timestamp = _now();
886         liquidityProviderAddressParam = param;
887         emit LiquidityProviderAddressSet(_address, msg.sender);
888     }
889     
890     /**
891      * @param _depositDate Deposit date.
892      * @param _amount Amount based on which emission is calculated and accrued.
893      * @return Total accrued emission user share, and seconds passed since the previous deposit started.
894      */
895     function getAccruedEmission(
896         uint256 _depositDate,
897         uint256 _amount,
898         uint256 stakeType
899     ) public view returns (uint256 userShare, uint256 timePassed) {
900         if (_amount == 0 || _depositDate == 0) return (0, 0);
901         timePassed = _now().sub(_depositDate);
902         if (timePassed == 0) return (0, 0);
903         
904         uint256 stakeRate = 0 finney; 
905         
906         if (stakeType==1) {
907             stakeRate = 50 finney; //5%
908         } else if (stakeType==2) {
909             stakeRate = 100 finney; //10%
910         } else if (stakeType==3) {
911             stakeRate = 150 finney; //15%
912         }
913         userShare = _amount.mul(stakeRate).mul(timePassed).div(YEAR * 1 ether);
914     }
915 
916 
917     /**
918      * @dev Calls internal "_mint" method, increases the user balance, and updates the deposit date.
919      * @param _sender The address of the sender.
920      * @param _id User's unique deposit ID.
921      * @param _amount The amount to deposit.
922      */
923     function _deposit(address _sender, uint256 _id, uint256 _amount) internal nonReentrant {
924         require(_amount > 0, "deposit amount should be more than 0");
925         //(uint256 sigmoidParamA,,) = getSigmoidParameters();
926         //if (sigmoidParamA == 0 && totalSupplyFactor() == 0) revert("emission stopped");
927         // new deposit, calculate interests
928         (uint256 userShare, uint256 timePassed) = _calcRewards(_sender, _id, 0);
929         uint256 newBalance = balances[_sender][_id].add(_amount);
930         balances[_sender][_id] = newBalance;
931         totalStaked = totalStaked.add(_amount);
932         depositDates[_sender][_id] = _now();
933         emit Deposited(_sender, _id, _amount, newBalance, userShare, timePassed);
934     }
935 
936     /**
937      * @dev Calls internal "_mint" method and then transfers tokens to the sender.
938      * @param _sender The address of the sender.
939      * @param _id User's unique deposit ID.
940      * @param _amount The amount to withdraw (0 - to withdraw all).
941      */
942     function _withdraw(address _sender, uint256 _id, uint256 _amount) internal nonReentrant {
943         require(_id > 0, "wrong deposit id");
944         require(balances[_sender][_id] > 0 && balances[_sender][_id] >= _amount, "insufficient funds");
945         uint256 amount = _amount == 0 ? balances[_sender][_id] : _amount;
946         require(token.transfer(_sender, amount), "transfer failed");
947 
948         (uint256 accruedEmission, uint256 timePassed) = _calcRewards(_sender, _id, amount);
949         balances[_sender][_id] = balances[_sender][_id].sub(amount);
950         totalStaked = totalStaked.sub(amount);
951         if (balances[_sender][_id] == 0) {
952             depositDates[_sender][_id] = 0;
953         }
954         emit Withdrawn(_sender, _id, _amount, balances[_sender][_id], accruedEmission, timePassed);
955     }
956 
957     /**
958      * @dev Calls internal "_mint" method and then transfers tokens to the sender.
959      * @param _sender The address of the sender.
960      * @param _id User's unique deposit ID.
961      */
962     function _withdrawRewards(address _sender, uint256 _id) internal nonReentrant {
963         require(_id > 0, "wrong deposit id");
964         (uint256 userShare, uint256 timePassed) = _calcRewards(_sender, _id, 0);
965         uint256 toClaim=0;
966         if (toClaimRewards[_sender][_id] < claimedRewards[_sender][_id]) {
967             toClaim = 0;
968         } else {
969             toClaim = toClaimRewards[_sender][_id].sub(claimedRewards[_sender][_id]);
970         }
971         require(toClaim > 0, "nothing to claim");
972         claimedRewards[_sender][_id]=claimedRewards[_sender][_id].add(toClaimRewards[_sender][_id]); 
973         require(tokenReward.transferFrom(liquidityProviderAddress(),_sender, toClaim), "Liquidity pool transfer failed");
974         emit WithdrawnRewards(
975         _sender,
976         _id,
977         toClaim,
978         claimedRewards[_sender][_id]);
979     }
980     
981 
982     /**
983      * @dev Calculate MAX_EMISSION_RATE per annum and distributes.
984      * @param _user User's address.
985      * @param _id User's unique deposit ID.
986      * @param _amount Amount based on which emission is calculated and accrued. When 0, current deposit balance is used.
987      */
988     function _calcRewards(address _user, uint256 _id, uint256 _amount) internal returns (uint256, uint256) {
989         uint256 currentBalance = balances[_user][_id]; 
990         uint256 amount = _amount == 0 ? currentBalance : _amount;
991         (uint256 accruedEmission, uint256 timePassed) = getAccruedEmission(depositDates[_user][_id], amount,_id);
992         toClaimRewards[_user][_id]=toClaimRewards[_user][_id].add(accruedEmission);
993         return (accruedEmission, timePassed);
994     }
995 
996     /**
997      * @dev Sets the next value of the parameter and the timestamp of this setting.
998      */
999     function _updateUintParam(UintParam storage _param, uint256 _newValue) internal {
1000         if (_param.timestamp == 0) {
1001             _param.oldValue = _newValue;
1002         } else if (_paramUpdateDelayElapsed(_param.timestamp)) {
1003             _param.oldValue = _param.newValue;
1004         }
1005         _param.newValue = _newValue;
1006         _param.timestamp = _now();
1007     }
1008 
1009     /**
1010      * @return Returns current liquidity providers reward address.
1011      */
1012     function liquidityProviderAddress() public view returns (address) {
1013         AddressParam memory param = liquidityProviderAddressParam;
1014         return param.newValue;
1015     }
1016     
1017     /**
1018      * @return Returns the current value of the parameter.
1019      */
1020     function _getUintParamValue(UintParam memory _param) internal view returns (uint256) {
1021         return _paramUpdateDelayElapsed(_param.timestamp) ? _param.newValue : _param.oldValue;
1022     }
1023 
1024     /**
1025      * @return Returns true if param update delay elapsed.
1026      */
1027     function _paramUpdateDelayElapsed(uint256 _paramTimestamp) internal view returns (bool) {
1028         return _now() > _paramTimestamp.add(PARAM_UPDATE_DELAY);
1029     }
1030 
1031     /**
1032      * @dev Sets lock to prevent reentrance.
1033      */
1034     function _setLocked(bool _locked) internal {
1035         locked = _locked;
1036     }
1037 
1038     /**
1039      * @return Returns current timestamp.
1040      */
1041     function _now() internal view returns (uint256) {
1042         // Note that the timestamp can have a 900-second error:
1043         // https://github.com/ethereum/wiki/blob/c02254611f218f43cbb07517ca8e5d00fd6d6d75/Block-Protocol-2.0.md
1044         return now; // solium-disable-line security/no-block-members
1045     }
1046 }