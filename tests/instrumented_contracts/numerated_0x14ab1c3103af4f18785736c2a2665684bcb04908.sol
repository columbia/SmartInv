1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: openzeppelin-solidity/contracts/GSN/Context.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /*
165  * @dev Provides information about the current execution context, including the
166  * sender of the transaction and its data. While these are generally available
167  * via msg.sender and msg.data, they should not be accessed in such a direct
168  * manner, since when dealing with GSN meta-transactions the account sending and
169  * paying for execution may not be the actual sender (as far as an application
170  * is concerned).
171  *
172  * This contract is only required for intermediate, library-like contracts.
173  */
174 contract Context {
175     // Empty internal constructor, to prevent people from mistakenly deploying
176     // an instance of this contract, which should be used via inheritance.
177     constructor () internal { }
178     // solhint-disable-previous-line no-empty-blocks
179 
180     function _msgSender() internal view returns (address payable) {
181         return msg.sender;
182     }
183 
184     function _msgData() internal view returns (bytes memory) {
185         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
186         return msg.data;
187     }
188 }
189 
190 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /**
195  * @dev Contract module which provides a basic access control mechanism, where
196  * there is an account (an owner) that can be granted exclusive access to
197  * specific functions.
198  *
199  * This module is used through inheritance. It will make available the modifier
200  * `onlyOwner`, which can be applied to your functions to restrict their use to
201  * the owner.
202  */
203 contract Ownable is Context {
204     address private _owner;
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208     /**
209      * @dev Initializes the contract setting the deployer as the initial owner.
210      */
211     constructor () internal {
212         _owner = _msgSender();
213         emit OwnershipTransferred(address(0), _owner);
214     }
215 
216     /**
217      * @dev Returns the address of the current owner.
218      */
219     function owner() public view returns (address) {
220         return _owner;
221     }
222 
223     /**
224      * @dev Throws if called by any account other than the owner.
225      */
226     modifier onlyOwner() {
227         require(isOwner(), "Ownable: caller is not the owner");
228         _;
229     }
230 
231     /**
232      * @dev Returns true if the caller is the current owner.
233      */
234     function isOwner() public view returns (bool) {
235         return _msgSender() == _owner;
236     }
237 
238     /**
239      * @dev Leaves the contract without owner. It will not be possible to call
240      * `onlyOwner` functions anymore. Can only be called by the current owner.
241      *
242      * NOTE: Renouncing ownership will leave the contract without an owner,
243      * thereby removing any functionality that is only available to the owner.
244      */
245     function renounceOwnership() public onlyOwner {
246         emit OwnershipTransferred(_owner, address(0));
247         _owner = address(0);
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Can only be called by the current owner.
253      */
254     function transferOwnership(address newOwner) public onlyOwner {
255         _transferOwnership(newOwner);
256     }
257 
258     /**
259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
260      */
261     function _transferOwnership(address newOwner) internal {
262         require(newOwner != address(0), "Ownable: new owner is the zero address");
263         emit OwnershipTransferred(_owner, newOwner);
264         _owner = newOwner;
265     }
266 }
267 
268 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
269 
270 pragma solidity ^0.5.0;
271 
272 /**
273  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
274  * the optional functions; to access them see {ERC20Detailed}.
275  */
276 interface IERC20 {
277     /**
278      * @dev Returns the amount of tokens in existence.
279      */
280     function totalSupply() external view returns (uint256);
281 
282     /**
283      * @dev Returns the amount of tokens owned by `account`.
284      */
285     function balanceOf(address account) external view returns (uint256);
286 
287     /**
288      * @dev Moves `amount` tokens from the caller's account to `recipient`.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transfer(address recipient, uint256 amount) external returns (bool);
295 
296     /**
297      * @dev Returns the remaining number of tokens that `spender` will be
298      * allowed to spend on behalf of `owner` through {transferFrom}. This is
299      * zero by default.
300      *
301      * This value changes when {approve} or {transferFrom} are called.
302      */
303     function allowance(address owner, address spender) external view returns (uint256);
304 
305     /**
306      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
307      *
308      * Returns a boolean value indicating whether the operation succeeded.
309      *
310      * IMPORTANT: Beware that changing an allowance with this method brings the risk
311      * that someone may use both the old and the new allowance by unfortunate
312      * transaction ordering. One possible solution to mitigate this race
313      * condition is to first reduce the spender's allowance to 0 and set the
314      * desired value afterwards:
315      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316      *
317      * Emits an {Approval} event.
318      */
319     function approve(address spender, uint256 amount) external returns (bool);
320 
321     /**
322      * @dev Moves `amount` tokens from `sender` to `recipient` using the
323      * allowance mechanism. `amount` is then deducted from the caller's
324      * allowance.
325      *
326      * Returns a boolean value indicating whether the operation succeeded.
327      *
328      * Emits a {Transfer} event.
329      */
330     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
331 
332     /**
333      * @dev Emitted when `value` tokens are moved from one account (`from`) to
334      * another (`to`).
335      *
336      * Note that `value` may be zero.
337      */
338     event Transfer(address indexed from, address indexed to, uint256 value);
339 
340     /**
341      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
342      * a call to {approve}. `value` is the new allowance.
343      */
344     event Approval(address indexed owner, address indexed spender, uint256 value);
345 }
346 
347 // File: openzeppelin-solidity/contracts/utils/Address.sol
348 
349 pragma solidity ^0.5.5;
350 
351 /**
352  * @dev Collection of functions related to the address type
353  */
354 library Address {
355     /**
356      * @dev Returns true if `account` is a contract.
357      *
358      * This test is non-exhaustive, and there may be false-negatives: during the
359      * execution of a contract's constructor, its address will be reported as
360      * not containing a contract.
361      *
362      * IMPORTANT: It is unsafe to assume that an address for which this
363      * function returns false is an externally-owned account (EOA) and not a
364      * contract.
365      */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies in extcodesize, which returns 0 for contracts in
368         // construction, since the code is only stored at the end of the
369         // constructor execution.
370 
371         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
372         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
373         // for accounts without code, i.e. `keccak256('')`
374         bytes32 codehash;
375         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
376         // solhint-disable-next-line no-inline-assembly
377         assembly { codehash := extcodehash(account) }
378         return (codehash != 0x0 && codehash != accountHash);
379     }
380 
381     /**
382      * @dev Converts an `address` into `address payable`. Note that this is
383      * simply a type cast: the actual underlying value is not changed.
384      *
385      * _Available since v2.4.0._
386      */
387     function toPayable(address account) internal pure returns (address payable) {
388         return address(uint160(account));
389     }
390 
391     /**
392      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
393      * `recipient`, forwarding all available gas and reverting on errors.
394      *
395      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
396      * of certain opcodes, possibly making contracts go over the 2300 gas limit
397      * imposed by `transfer`, making them unable to receive funds via
398      * `transfer`. {sendValue} removes this limitation.
399      *
400      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
401      *
402      * IMPORTANT: because control is transferred to `recipient`, care must be
403      * taken to not create reentrancy vulnerabilities. Consider using
404      * {ReentrancyGuard} or the
405      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
406      *
407      * _Available since v2.4.0._
408      */
409     function sendValue(address payable recipient, uint256 amount) internal {
410         require(address(this).balance >= amount, "Address: insufficient balance");
411 
412         // solhint-disable-next-line avoid-call-value
413         (bool success, ) = recipient.call.value(amount)("");
414         require(success, "Address: unable to send value, recipient may have reverted");
415     }
416 }
417 
418 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
419 
420 pragma solidity ^0.5.0;
421 
422 
423 
424 
425 /**
426  * @title SafeERC20
427  * @dev Wrappers around ERC20 operations that throw on failure (when the token
428  * contract returns false). Tokens that return no value (and instead revert or
429  * throw on failure) are also supported, non-reverting calls are assumed to be
430  * successful.
431  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
432  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
433  */
434 library SafeERC20 {
435     using SafeMath for uint256;
436     using Address for address;
437 
438     function safeTransfer(IERC20 token, address to, uint256 value) internal {
439         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
440     }
441 
442     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
443         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
444     }
445 
446     function safeApprove(IERC20 token, address spender, uint256 value) internal {
447         // safeApprove should only be called when setting an initial allowance,
448         // or when resetting it to zero. To increase and decrease it, use
449         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
450         // solhint-disable-next-line max-line-length
451         require((value == 0) || (token.allowance(address(this), spender) == 0),
452             "SafeERC20: approve from non-zero to non-zero allowance"
453         );
454         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
455     }
456 
457     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
458         uint256 newAllowance = token.allowance(address(this), spender).add(value);
459         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
460     }
461 
462     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
463         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
464         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
465     }
466 
467     /**
468      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
469      * on the return value: the return value is optional (but if data is returned, it must not be false).
470      * @param token The token targeted by the call.
471      * @param data The call data (encoded using abi.encode or one of its variants).
472      */
473     function callOptionalReturn(IERC20 token, bytes memory data) private {
474         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
475         // we're implementing it ourselves.
476 
477         // A Solidity high level call has three parts:
478         //  1. The target address is checked to verify it contains contract code
479         //  2. The call itself is made, and success asserted
480         //  3. The return value is decoded, which in turn checks the size of the returned data.
481         // solhint-disable-next-line max-line-length
482         require(address(token).isContract(), "SafeERC20: call to non-contract");
483 
484         // solhint-disable-next-line avoid-low-level-calls
485         (bool success, bytes memory returndata) = address(token).call(data);
486         require(success, "SafeERC20: low-level call failed");
487 
488         if (returndata.length > 0) { // Return data is optional
489             // solhint-disable-next-line max-line-length
490             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
491         }
492     }
493 }
494 
495 // File: contracts/Lock.sol
496 
497 pragma solidity 0.5.15;
498 
499 
500 
501 
502 
503 
504 /**
505 * @dev This contract will hold user locked funds which will be unlocked after
506 * lock-up period ends
507 */
508 contract Lock is Ownable {
509     using SafeERC20 for IERC20;
510     using SafeMath for uint256;
511 
512     enum Status { _, OPEN, CLOSED }
513     enum TokenStatus {_, ACTIVE, INACTIVE }
514 
515     struct Token {
516         address tokenAddress;
517         uint256 minAmount;
518         bool emergencyUnlock;
519         TokenStatus status;
520         uint256[] tierAmounts;
521         uint256[] tierFees;
522     }
523 
524     Token[] private _tokens;
525 
526     IERC20 private _lockToken;
527 
528     //Fee per lock in lock token
529     uint256 private _lockTokenFee;
530 
531     //Keeps track of token index in above array
532     mapping(address => uint256) private _tokenVsIndex;
533 
534     //Wallet where fees will go
535     address payable private _wallet;
536 
537     address constant private ETH_ADDRESS = address(
538         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
539     );
540 
541     struct LockedAsset {
542         address token;// Token address
543         uint256 amount;// Amount locked
544         uint256 startDate;// Start date. We can remove this later
545         uint256 endDate;
546         uint256 lastLocked;
547         //Amount threshold after a locked asset can be unlocked
548         uint256 amountThreshold;
549         address payable beneficiary;// Beneficary who will receive funds
550         Status status;
551     }
552 
553     struct Airdrop {
554         address destToken;
555         //numerator and denominator will be used to calculate ratio
556         //Example 1DAI will get you 4 SAI
557         //which means numerator = 4 and denominator = 1
558         uint256 numerator;
559         uint256 denominator;
560         uint256 date;// Date at which time this entry was made
561         //Only those locked asset which were locked before this date will be
562         //given airdropped tokens
563     }
564 
565     //Mapping of base token versus airdropped token
566     mapping(address => Airdrop[]) private _baseTokenVsAirdrops;
567 
568     //Global lockedasset id. Also give total number of lock-ups made so far
569     uint256 private _lockId;
570 
571     //list of all asset ids for a user/beneficiary
572     mapping(address => uint256[]) private _userVsLockIds;
573 
574     mapping(uint256 => LockedAsset) private _idVsLockedAsset;
575 
576     bool private _paused;
577 
578     event TokenAdded(address indexed token);
579     event TokenInactivated(address indexed token);
580     event TokenActivated(address indexed token);
581     event WalletChanged(address indexed wallet);
582     event AssetLocked(
583         address indexed token,
584         address indexed sender,
585         address indexed beneficiary,
586         uint256 id,
587         uint256 amount,
588         uint256 startDate,
589         uint256 endDate,
590         bool lockTokenFee,
591         uint256 fee
592     );
593     event TokenUpdated(
594         uint256 indexed id,
595         address indexed token,
596         uint256 minAmount,
597         bool emergencyUnlock,
598         uint256[] tierAmounts,
599         uint256[] tierFees
600     );
601     event Paused();
602     event Unpaused();
603 
604     event AssetClaimed(
605         uint256 indexed id,
606         address indexed beneficiary,
607         address indexed token
608     );
609 
610     event AirdropAdded(
611         address indexed baseToken,
612         address indexed destToken,
613         uint256 index,
614         uint256 airdropDate,
615         uint256 numerator,
616         uint256 denominator
617     );
618 
619     event AirdropUpdated(
620         address indexed baseToken,
621         address indexed destToken,
622         uint256 index,
623         uint256 airdropDate,
624         uint256 numerator,
625         uint256 denominator
626     );
627 
628     event TokensAirdropped(
629         address indexed destToken,
630         uint256 amount
631     );
632 
633     event LockTokenUpdated(address indexed lockTokenAddress);
634     event LockTokenFeeUpdated(uint256 fee);
635 
636     event AmountAdded(address indexed beneficiary, uint256 id, uint256 amount);
637 
638     modifier tokenExist(address token) {
639         require(_tokenVsIndex[token] > 0, "Lock: Token does not exist!!");
640         _;
641     }
642 
643     modifier tokenDoesNotExist(address token) {
644         require(_tokenVsIndex[token] == 0, "Lock: Token already exist!!");
645         _;
646     }
647 
648     modifier canLockAsset(address token) {
649         uint256 index = _tokenVsIndex[token];
650 
651         require(index > 0, "Lock: Token does not exist!!");
652 
653         require(
654             _tokens[index.sub(1)].status == TokenStatus.ACTIVE,
655             "Lock: Token not active!!"
656         );
657 
658         require(
659             !_tokens[index.sub(1)].emergencyUnlock,
660             "Lock: Token is in emergency unlock state!!"
661         );
662         _;
663     }
664 
665     modifier canClaim(uint256 id) {
666 
667         require(claimable(id), "Lock: Can't claim asset");
668 
669         require(
670             _idVsLockedAsset[id].beneficiary == msg.sender,
671             "Lock: Unauthorized access!!"
672         );
673         _;
674     }
675 
676     /**
677     * @dev Modifier to make a function callable only when the contract is not paused.
678     */
679     modifier whenNotPaused() {
680         require(!_paused, "Lock: paused");
681         _;
682     }
683 
684     /**
685     * @dev Modifier to make a function callable only when the contract is paused.
686     */
687     modifier whenPaused() {
688         require(_paused, "Lock: not paused");
689         _;
690     }
691 
692     /**
693     * @dev Constructor
694     * @param wallet Wallet address where fees will go
695     * @param lockTokenAddress Address of the lock token
696     * @param lockTokenFee Fee for each lock in lock token
697     */
698     constructor(
699         address payable wallet,
700         address lockTokenAddress,
701         uint256 lockTokenFee
702     )
703         public
704     {
705         require(
706             wallet != address(0),
707             "Lock: Please provide valid wallet address!!"
708         );
709         require(
710             lockTokenAddress != address(0),
711             "Lock: Invalid lock token address"
712         );
713         _lockToken = IERC20(lockTokenAddress);
714         _wallet = wallet;
715         _lockTokenFee = lockTokenFee;
716     }
717 
718     /**
719     * @dev Returns true if the contract is paused, and false otherwise.
720     */
721     function paused() external view returns (bool) {
722         return _paused;
723     }
724 
725     /**
726     * @dev returns the fee receiver wallet address
727     */
728     function getWallet() external view returns(address) {
729         return _wallet;
730     }
731 
732     /**
733     * @dev Returns total token count
734     */
735     function getTokenCount() external view returns(uint256) {
736         return _tokens.length;
737     }
738 
739     /**
740     * @dev Returns lock token address
741     */
742     function getLockToken() external view returns(address) {
743         return address(_lockToken);
744     }
745 
746     /**
747     * @dev Returns fee per lock in lock token
748     */
749     function getLockTokenFee() external view returns(uint256) {
750         return _lockTokenFee;
751     }
752 
753     /**
754     * @dev Returns list of supported tokens
755     * This will be a paginated method which will only send 15 tokens in one request
756     * This is done to prevent infinite loops and overflow of gas limits
757     * @param start start index for pagination
758     * @param length Amount of tokens to fetch
759     */
760     function getTokens(uint256 start, uint256 length) external view returns(
761         address[] memory tokenAddresses,
762         uint256[] memory minAmounts,
763         bool[] memory emergencyUnlocks,
764         TokenStatus[] memory statuses
765     )
766     {
767         tokenAddresses = new address[](length);
768         minAmounts = new uint256[](length);
769         emergencyUnlocks = new bool[](length);
770         statuses = new TokenStatus[](length);
771 
772         require(start.add(length) <= _tokens.length, "Lock: Invalid input");
773         require(length > 0 && length <= 15, "Lock: Invalid length");
774         uint256 count = 0;
775         for(uint256 i = start; i < start.add(length); i++) {
776             tokenAddresses[count] = _tokens[i].tokenAddress;
777             minAmounts[count] = _tokens[i].minAmount;
778             emergencyUnlocks[count] = _tokens[i].emergencyUnlock;
779             statuses[count] = _tokens[i].status;
780             count = count.add(1);
781         }
782 
783         return(
784             tokenAddresses,
785             minAmounts,
786             emergencyUnlocks,
787             statuses
788         );
789     }
790 
791     /**
792     * @dev Returns information about specific token
793     * @dev tokenAddress Address of the token
794     */
795     function getTokenInfo(address tokenAddress) external view returns(
796         uint256 minAmount,
797         bool emergencyUnlock,
798         TokenStatus status,
799         uint256[] memory tierAmounts,
800         uint256[] memory tierFees
801     )
802     {
803         uint256 index = _tokenVsIndex[tokenAddress];
804 
805         if(index > 0){
806             index = index.sub(1);
807             Token memory token = _tokens[index];
808             return (
809                 token.minAmount,
810                 token.emergencyUnlock,
811                 token.status,
812                 token.tierAmounts,
813                 token.tierFees
814             );
815         }
816     }
817 
818     /**
819     * @dev Returns information about a locked asset
820     * @param id Asset id
821     */
822     function getLockedAsset(uint256 id) external view returns(
823         address token,
824         uint256 amount,
825         uint256 startDate,
826         uint256 endDate,
827         uint256 lastLocked,
828         address beneficiary,
829         Status status,
830         uint256 amountThreshold
831     )
832     {
833         LockedAsset memory asset = _idVsLockedAsset[id];
834         token = asset.token;
835         amount = asset.amount;
836         startDate = asset.startDate;
837         endDate = asset.endDate;
838         beneficiary = asset.beneficiary;
839         status = asset.status;
840         amountThreshold = asset.amountThreshold;
841         lastLocked = asset.lastLocked;
842 
843         return(
844             token,
845             amount,
846             startDate,
847             endDate,
848             lastLocked,
849             beneficiary,
850             status,
851             amountThreshold
852         );
853     }
854 
855     /**
856     * @dev Returns all asset ids for a user
857     * @param user Address of the user
858     */
859     function getAssetIds(
860         address user
861     )
862         external
863         view
864         returns (uint256[] memory ids)
865     {
866         return _userVsLockIds[user];
867     }
868 
869     /**
870     * @dev Returns airdrop info for a given token
871     * @param token Token address
872     */
873     function getAirdrops(address token) external view returns(
874         address[] memory destTokens,
875         uint256[] memory numerators,
876         uint256[] memory denominators,
877         uint256[] memory dates
878     )
879     {
880         uint256 length = _baseTokenVsAirdrops[token].length;
881 
882         destTokens = new address[](length);
883         numerators = new uint256[](length);
884         denominators = new uint256[](length);
885         dates = new uint256[](length);
886 
887         //This loop can be very costly if there are very large number of airdrops for a token.
888         //Which we presume will not be the case
889         for(uint256 i = 0; i < length; i++){
890 
891             Airdrop memory airdrop = _baseTokenVsAirdrops[token][i];
892             destTokens[i] = airdrop.destToken;
893             numerators[i] = airdrop.numerator;
894             denominators[i] = airdrop.denominator;
895             dates[i] = airdrop.date;
896         }
897 
898         return (
899             destTokens,
900             numerators,
901             denominators,
902             dates
903         );
904     }
905 
906     /**
907     * @dev Returns specific airdrop for a base token
908     * @param token Base token address
909     * @param index Index at which this airdrop is in array
910     */
911     function getAirdrop(address token, uint256 index) external view returns(
912         address destToken,
913         uint256 numerator,
914         uint256 denominator,
915         uint256 date
916     )
917     {
918         return (
919             _baseTokenVsAirdrops[token][index].destToken,
920             _baseTokenVsAirdrops[token][index].numerator,
921             _baseTokenVsAirdrops[token][index].denominator,
922             _baseTokenVsAirdrops[token][index].date
923         );
924     }
925 
926     /**
927     * @dev Called by an admin to pause, triggers stopped state.
928     */
929     function pause() external onlyOwner whenNotPaused {
930         _paused = true;
931         emit Paused();
932     }
933 
934     /**
935     * @dev Called by an admin to unpause, returns to normal state.
936     */
937     function unpause() external onlyOwner whenPaused {
938         _paused = false;
939         emit Unpaused();
940     }
941 
942     /**
943     * @dev Allows admin to set airdrop token for a given base token
944     * @param baseToken Address of the base token
945     * @param destToken Address of the airdropped token
946     * @param numerator Numerator to calculate ratio
947     * @param denominator Denominator to calculate ratio
948     * @param date Date at which airdrop happened or will happen
949     */
950     function setAirdrop(
951         address baseToken,
952         address destToken,
953         uint256 numerator,
954         uint256 denominator,
955         uint256 date
956     )
957         external
958         onlyOwner
959         tokenExist(baseToken)
960     {
961         require(destToken != address(0), "Lock: Invalid destination token!!");
962         require(numerator > 0, "Lock: Invalid numerator!!");
963         require(denominator > 0, "Lock: Invalid denominator!!");
964         require(isActive(baseToken), "Lock: Base token is not active!!");
965 
966         _baseTokenVsAirdrops[baseToken].push(Airdrop({
967             destToken: destToken,
968             numerator: numerator,
969             denominator: denominator,
970             date: date
971         }));
972 
973         emit AirdropAdded(
974             baseToken,
975             destToken,
976             _baseTokenVsAirdrops[baseToken].length.sub(1),
977             date,
978             numerator,
979             denominator
980         );
981     }
982 
983     /**
984     * @dev Update lock token address
985     * @param lockTokenAddress New lock token address
986     */
987     function updateLockToken(address lockTokenAddress) external onlyOwner {
988         require(
989             lockTokenAddress != address(0),
990             "Lock: Invalid lock token address"
991         );
992         _lockToken = IERC20(lockTokenAddress);
993         emit LockTokenUpdated(lockTokenAddress);
994     }
995 
996     /**
997     * @dev Update fee in lock token
998     * @param lockTokenFee Fee per lock in lock token
999     */
1000     function updateLockTokenFee(uint256 lockTokenFee) external onlyOwner {
1001         _lockTokenFee = lockTokenFee;
1002         emit LockTokenFeeUpdated(lockTokenFee);
1003     }
1004 
1005     /**
1006     * @dev Allows admin to update airdrop at given index
1007     * @param baseToken Base token address for which airdrop has to be updated
1008     * @param numerator New numerator
1009     * @param denominator New denominator
1010     * @param date New airdrop date
1011     * @param index Index at which this airdrop resides for the basetoken
1012     */
1013     function updateAirdrop(
1014         address baseToken,
1015         uint256 numerator,
1016         uint256 denominator,
1017         uint256 date,
1018         uint256 index
1019     )
1020         external
1021         onlyOwner
1022     {
1023         require(
1024             _baseTokenVsAirdrops[baseToken].length > index,
1025             "Lock: Invalid index value!!"
1026         );
1027         require(numerator > 0, "Lock: Invalid numerator!!");
1028         require(denominator > 0, "Lock: Invalid denominator!!");
1029 
1030         Airdrop storage airdrop = _baseTokenVsAirdrops[baseToken][index];
1031         airdrop.numerator = numerator;
1032         airdrop.denominator = denominator;
1033         airdrop.date = date;
1034 
1035         emit AirdropUpdated(
1036             baseToken,
1037             airdrop.destToken,
1038             index,
1039             date,
1040             numerator,
1041             denominator
1042         );
1043     }
1044 
1045     /**
1046     * @dev Allows admin to set fee receiver wallet
1047     * @param wallet New wallet address
1048     */
1049     function setWallet(address payable wallet) external onlyOwner {
1050         require(
1051             wallet != address(0),
1052             "Lock: Please provider valid wallet address!!"
1053         );
1054         _wallet = wallet;
1055 
1056         emit WalletChanged(wallet);
1057     }
1058 
1059     /**
1060     * @dev Allows admin to update token info
1061     * @param tokenAddress Address of the token to be updated
1062     * @param minAmount Min amount of tokens required to lock
1063     * @param emergencyUnlock If token is in emergency unlock state
1064     * @param tierAmounts Threshold amount for chargin fee
1065     * @param tierFees Fees for each tier
1066     */
1067     function updateToken(
1068         address tokenAddress,
1069         uint256 minAmount,
1070         bool emergencyUnlock,
1071         uint256[] calldata tierAmounts,
1072         uint256[] calldata tierFees
1073     )
1074         external
1075         onlyOwner
1076         tokenExist(tokenAddress)
1077     {
1078         require(
1079             tierAmounts.length == tierFees.length,
1080             "Lock: Tiers does not match"
1081         );
1082 
1083         uint256 index = _tokenVsIndex[tokenAddress].sub(1);
1084         Token storage token = _tokens[index];
1085         token.minAmount = minAmount;
1086         token.emergencyUnlock = emergencyUnlock;
1087         token.tierAmounts = tierAmounts;
1088         token.tierFees = tierFees;
1089         emit TokenUpdated(
1090             index,
1091             tokenAddress,
1092             minAmount,
1093             emergencyUnlock,
1094             tierAmounts,
1095             tierFees
1096         );
1097     }
1098 
1099     /**
1100     * @dev Allows admin to add new token to the list
1101     * @param token Address of the token
1102     * @param minAmount Minimum amount of tokens to lock for this token
1103     * @param tierAmounts Threshold amount for chargin fee
1104     * @param tierFees Fees for each tier
1105     */
1106     function addToken(
1107         address token,
1108         uint256 minAmount,
1109         uint256[] calldata tierAmounts,
1110         uint256[] calldata tierFees
1111     )
1112         external
1113         onlyOwner
1114         tokenDoesNotExist(token)
1115     {
1116         require(
1117             tierAmounts.length == tierFees.length,
1118             "Lock: Tiers does not match"
1119         );
1120 
1121         _tokens.push(Token({
1122             tokenAddress: token,
1123             minAmount: minAmount,
1124             emergencyUnlock: false,
1125             status: TokenStatus.ACTIVE,
1126             tierAmounts: tierAmounts,
1127             tierFees: tierFees
1128         }));
1129         _tokenVsIndex[token] = _tokens.length;
1130 
1131         emit TokenAdded(token);
1132     }
1133 
1134 
1135     /**
1136     * @dev Allows admin to inactivate token
1137     * @param token Address of the token to be inactivated
1138     */
1139     function inactivateToken(
1140         address token
1141     )
1142         external
1143         onlyOwner
1144         tokenExist(token)
1145     {
1146         uint256 index = _tokenVsIndex[token].sub(1);
1147 
1148         require(
1149             _tokens[index].status == TokenStatus.ACTIVE,
1150             "Lock: Token already inactive!!"
1151         );
1152 
1153         _tokens[index].status = TokenStatus.INACTIVE;
1154 
1155         emit TokenInactivated(token);
1156     }
1157 
1158     /**
1159     * @dev Allows admin to activate any existing token
1160     * @param token Address of the token to be activated
1161     */
1162     function activateToken(
1163         address token
1164     )
1165         external
1166         onlyOwner
1167         tokenExist(token)
1168     {
1169         uint256 index = _tokenVsIndex[token].sub(1);
1170 
1171         require(
1172             _tokens[index].status == TokenStatus.INACTIVE,
1173             "Lock: Token already active!!"
1174         );
1175 
1176         _tokens[index].status = TokenStatus.ACTIVE;
1177 
1178         emit TokenActivated(token);
1179     }
1180 
1181     /**
1182     * @dev Allows user to lock asset. In case of ERC-20 token the user will
1183     * first have to approve the contract to spend on his/her behalf
1184     * @param tokenAddress Address of the token to be locked
1185     * @param amount Amount of tokens to lock
1186     * @param duration Duration for which tokens to be locked. In seconds
1187     * @param beneficiary Address of the beneficiary
1188     * @param amountThreshold Threshold amount which is when locked in a single lock will make that lock claimable
1189     * @param lockFee Bool to check if fee to be paid in lock token or not
1190     */
1191     function lock(
1192         address tokenAddress,
1193         uint256 amount,
1194         uint256 duration,
1195         address payable beneficiary,
1196         uint256 amountThreshold,
1197         bool lockFee
1198     )
1199         external
1200         payable
1201         whenNotPaused
1202         canLockAsset(tokenAddress)
1203     {
1204         uint256 remValue = _lock(
1205             tokenAddress,
1206             amount,
1207             duration,
1208             beneficiary,
1209             amountThreshold,
1210             msg.value,
1211             lockFee
1212         );
1213 
1214         require(
1215             remValue < 10000000000,
1216             "Lock: Sent more ethers then required"
1217         );
1218 
1219     }
1220 
1221     /**
1222     * @dev Allows user to lock asset. In case of ERC-20 token the user will
1223     * first have to approve the contract to spend on his/her behalf
1224     * @param tokenAddress Address of the token to be locked
1225     * @param amounts List of amount of tokens to lock
1226     * @param durations List of duration for which tokens to be locked. In seconds
1227     * @param beneficiaries List of addresses of the beneficiaries
1228     * @param amountThresholds List of threshold amounts which is when locked in a single lock will make that lock claimable
1229     * @param lockFee Bool to check if fee to be paid in lock token or not
1230     */
1231     function bulkLock(
1232         address tokenAddress,
1233         uint256[] calldata amounts,
1234         uint256[] calldata durations,
1235         address payable[] calldata beneficiaries,
1236         uint256[] calldata amountThresholds,
1237         bool lockFee
1238     )
1239         external
1240         payable
1241         whenNotPaused
1242         canLockAsset(tokenAddress)
1243     {
1244         uint256 remValue = msg.value;
1245         require(amounts.length == durations.length, "Lock: Invalid input");
1246         require(amounts.length == beneficiaries.length, "Lock: Invalid input");
1247         require(
1248             amounts.length == amountThresholds.length,
1249             "Lock: Invalid input"
1250         );
1251 
1252         for(uint256 i = 0; i < amounts.length; i++){
1253             remValue = _lock(
1254                 tokenAddress,
1255                 amounts[i],
1256                 durations[i],
1257                 beneficiaries[i],
1258                 amountThresholds[i],
1259                 remValue,
1260                 lockFee
1261             );
1262         }
1263 
1264         require(
1265             remValue < 10000000000,
1266             "Lock: Sent more ethers then required"
1267         );
1268 
1269     }
1270 
1271     /**
1272     * @dev Allows beneficiary of locked asset to claim asset after lock-up period ends
1273     * @param id Id of the locked asset
1274     */
1275     function claim(uint256 id) external canClaim(id) {
1276         LockedAsset memory lockedAsset = _idVsLockedAsset[id];
1277         if(ETH_ADDRESS == lockedAsset.token) {
1278             _claimETH(
1279                 id
1280             );
1281         }
1282 
1283         else {
1284             _claimERC20(
1285                 id
1286             );
1287         }
1288 
1289         emit AssetClaimed(
1290             id,
1291             lockedAsset.beneficiary,
1292             lockedAsset.token
1293         );
1294     }
1295 
1296     /**
1297     * @dev Allows anyone to add more tokens in the existing lock
1298     * @param id id of the locked asset
1299     * @param amount Amount to be added
1300     * @param lockFee Bool to check if fee to be paid in lock token or not
1301     */
1302     function addAmount(
1303         uint256 id,
1304         uint256 amount,
1305         bool lockFee
1306     )
1307         external
1308         payable
1309         whenNotPaused
1310     {
1311         LockedAsset storage lockedAsset = _idVsLockedAsset[id];
1312 
1313         require(lockedAsset.status == Status.OPEN, "Lock: Lock is not open");
1314         
1315         Token memory token = _tokens[_tokenVsIndex[lockedAsset.token].sub(1)];
1316 
1317         //At the time of addition of tokens previous aridrops will be claimed
1318         _claimAirdroppedTokens(
1319             lockedAsset.token,
1320             lockedAsset.lastLocked,
1321             lockedAsset.amount
1322         );
1323 
1324 
1325         uint256 fee = 0;
1326         uint256 newAmount = 0;
1327         (fee, newAmount) = _calculateFee(amount, lockFee, token);
1328 
1329         if(lockFee) {
1330             _lockToken.safeTransferFrom(msg.sender, _wallet, _lockTokenFee);
1331         }
1332         if(ETH_ADDRESS == lockedAsset.token) {
1333             require(amount == msg.value, "Lock: Insufficient value sent");
1334 
1335             if(!lockFee) {
1336                 (bool success,) = _wallet.call.value(fee)("");
1337                 require(success, "Lock: Transfer of fee failed");
1338             }
1339         }
1340         else {
1341             if(!lockFee){
1342                 IERC20(lockedAsset.token).safeTransferFrom(msg.sender, _wallet, fee);
1343             }
1344 
1345             IERC20(lockedAsset.token).safeTransferFrom(msg.sender, address(this), newAmount);
1346         }
1347 
1348         lockedAsset.amount = lockedAsset.amount.add(newAmount);
1349         lockedAsset.lastLocked = block.timestamp;
1350 
1351         emit AmountAdded(lockedAsset.beneficiary, id, newAmount);
1352 
1353     }
1354 
1355 
1356     /**
1357     * @dev Returns whether given asset can be claimed or not
1358     * @param id id of an asset
1359     */
1360     function claimable(uint256 id) public view returns(bool){
1361 
1362         LockedAsset memory asset = _idVsLockedAsset[id];
1363         if(
1364             asset.status == Status.OPEN &&
1365             (
1366                 asset.endDate <= block.timestamp ||
1367                 _tokens[_tokenVsIndex[asset.token].sub(1)].emergencyUnlock ||
1368                 (asset.amountThreshold > 0 && asset.amount >= asset.amountThreshold)
1369             )
1370         )
1371         {
1372             return true;
1373         }
1374         return false;
1375     }
1376 
1377     /**
1378     * @dev Returns whether provided token is active or not
1379     * @param token Address of the token to be checked
1380     */
1381     function isActive(address token) public view returns(bool) {
1382         uint256 index = _tokenVsIndex[token];
1383 
1384         if(index > 0){
1385             return (_tokens[index.sub(1)].status == TokenStatus.ACTIVE);
1386         }
1387         return false;
1388     }
1389 
1390     /**
1391     * @dev Helper method to lock asset
1392     */
1393     function _lock(
1394         address tokenAddress,
1395         uint256 amount,
1396         uint256 duration,
1397         address payable beneficiary,
1398         uint256 amountThreshold,
1399         uint256 value,
1400         bool lockFee
1401     )
1402         private
1403         returns(uint256)
1404     {
1405         require(
1406             beneficiary != address(0),
1407             "Lock: Provide valid beneficiary address!!"
1408         );
1409 
1410         Token memory token = _tokens[_tokenVsIndex[tokenAddress].sub(1)];
1411 
1412         require(
1413             amount >= token.minAmount,
1414             "Lock: Please provide minimum amount of tokens!!"
1415         );
1416 
1417         uint256 endDate = block.timestamp.add(duration);
1418         uint256 fee = 0;
1419         uint256 newAmount = 0;
1420 
1421         (fee, newAmount) = _calculateFee(amount, lockFee, token);
1422 
1423         uint256 remValue = value;
1424 
1425         if(ETH_ADDRESS == tokenAddress) {
1426             _lockETH(
1427                 newAmount,
1428                 fee,
1429                 endDate,
1430                 beneficiary,
1431                 amountThreshold,
1432                 value,
1433                 lockFee
1434             );
1435 
1436             remValue = remValue.sub(amount);
1437         }
1438 
1439         else {
1440             _lockERC20(
1441                 tokenAddress,
1442                 newAmount,
1443                 fee,
1444                 endDate,
1445                 beneficiary,
1446                 amountThreshold,
1447                 lockFee
1448             );
1449         }
1450 
1451         emit AssetLocked(
1452             tokenAddress,
1453             msg.sender,
1454             beneficiary,
1455             _lockId,
1456             newAmount,
1457             block.timestamp,
1458             endDate,
1459             lockFee,
1460             fee
1461         );
1462 
1463         return remValue;
1464     }
1465 
1466     /**
1467     * @dev Helper method to lock ETH
1468     */
1469     function _lockETH(
1470         uint256 amount,
1471         uint256 fee,
1472         uint256 endDate,
1473         address payable beneficiary,
1474         uint256 amountThreshold,
1475         uint256 value,
1476         bool lockFee
1477     )
1478         private
1479     {
1480 
1481         //Transferring fee to the wallet
1482 
1483         if(lockFee){
1484 	    require(value >= amount, "Lock: Enough ETH not sent!!");
1485             _lockToken.safeTransferFrom(msg.sender, _wallet, fee);
1486         }
1487         else {
1488             require(value >= amount.add(fee), "Lock: Enough ETH not sent!!");
1489             (bool success,) = _wallet.call.value(fee)("");
1490             require(success, "Lock: Transfer of fee failed");
1491         }
1492         
1493 
1494         _lockId = _lockId.add(1);
1495 
1496         _idVsLockedAsset[_lockId] = LockedAsset({
1497             token: ETH_ADDRESS,
1498             amount: amount,
1499             startDate: block.timestamp,
1500             endDate: endDate,
1501             lastLocked: block.timestamp,
1502             beneficiary: beneficiary,
1503             status: Status.OPEN,
1504             amountThreshold: amountThreshold
1505         });
1506         _userVsLockIds[beneficiary].push(_lockId);
1507     }
1508 
1509     /**
1510     * @dev Helper method to lock ERC-20 tokens
1511     */
1512     function _lockERC20(
1513         address token,
1514         uint256 amount,
1515         uint256 fee,
1516         uint256 endDate,
1517         address payable beneficiary,
1518         uint256 amountThreshold,
1519         bool lockFee
1520     )
1521         private
1522     {
1523 
1524         //Transfer fee to the wallet
1525         if(lockFee){
1526             _lockToken.safeTransferFrom(msg.sender, _wallet, fee);
1527         }
1528         else {
1529             IERC20(token).safeTransferFrom(msg.sender, _wallet, fee);
1530         }
1531         
1532         //Transfer required amount of tokens to the contract from user balance
1533         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
1534 
1535         _lockId = _lockId.add(1);
1536 
1537         _idVsLockedAsset[_lockId] = LockedAsset({
1538             token: token,
1539             amount: amount,
1540             startDate: block.timestamp,
1541             endDate: endDate,
1542             lastLocked: block.timestamp,
1543             beneficiary: beneficiary,
1544             status: Status.OPEN,
1545             amountThreshold: amountThreshold
1546         });
1547         _userVsLockIds[beneficiary].push(_lockId);
1548     }
1549 
1550     /**
1551     * @dev Helper method to claim ETH
1552     */
1553     function _claimETH(uint256 id) private {
1554         LockedAsset storage asset = _idVsLockedAsset[id];
1555         asset.status = Status.CLOSED;
1556         (bool success,) = msg.sender.call.value(asset.amount)("");
1557         require(success, "Lock: Failed to transfer eth!!");
1558 
1559         _claimAirdroppedTokens(
1560             asset.token,
1561             asset.lastLocked,
1562             asset.amount
1563         );
1564     }
1565 
1566     /**
1567     * @dev Helper method to claim ERC-20
1568     */
1569     function _claimERC20(uint256 id) private {
1570         LockedAsset storage asset = _idVsLockedAsset[id];
1571         asset.status = Status.CLOSED;
1572         IERC20(asset.token).safeTransfer(msg.sender, asset.amount);
1573         _claimAirdroppedTokens(
1574             asset.token,
1575             asset.lastLocked,
1576             asset.amount
1577         );
1578     }
1579 
1580     /**
1581     * @dev Helper method to claim airdropped tokens
1582     * @param baseToken Base Token address
1583     * @param lastLocked Date when base tokens were last locked
1584     * @param amount Amount of base tokens locked
1585     */
1586     function _claimAirdroppedTokens(
1587         address baseToken,
1588         uint256 lastLocked,
1589         uint256 amount
1590     )
1591         private
1592     {
1593         //This loop can be very costly if number of airdropped tokens
1594         //for base token is very large. But we assume that it is not going to be the case
1595         for(uint256 i = 0; i < _baseTokenVsAirdrops[baseToken].length; i++) {
1596 
1597             Airdrop memory airdrop = _baseTokenVsAirdrops[baseToken][i];
1598 
1599             if(airdrop.date > lastLocked && airdrop.date < block.timestamp) {
1600                 uint256 airdropAmount = amount.mul(airdrop.numerator).div(airdrop.denominator);
1601                 IERC20(airdrop.destToken).safeTransfer(msg.sender, airdropAmount);
1602                 emit TokensAirdropped(airdrop.destToken, airdropAmount);
1603             }
1604         }
1605 
1606     }
1607 
1608     //Helper method to calculate fee
1609     function _calculateFee(
1610         uint256 amount,
1611         bool lockFee,
1612         Token memory token
1613     )
1614         private
1615         view
1616         returns(uint256 fee, uint256 newAmount)
1617     {
1618         newAmount = amount;
1619 
1620         if(lockFee){
1621             fee = _lockTokenFee;
1622         }
1623         else{
1624             uint256 tempAmount = amount;
1625             for(
1626             uint256 i = 0; (i < token.tierAmounts.length - 1 && tempAmount > 0); i++
1627             )
1628             {
1629                 if(tempAmount >= token.tierAmounts[i]){
1630                     tempAmount = tempAmount.sub(token.tierAmounts[i]);
1631                     fee = fee.add(token.tierAmounts[i].mul(token.tierFees[i]).div(10000));
1632                 }
1633                 else{
1634                     fee = fee.add(tempAmount.mul(token.tierFees[i]).div(10000));
1635                     tempAmount = 0;
1636                 }
1637             }
1638             //All remaining tokens will be calculated in last tier
1639             fee = fee.add(
1640                 tempAmount.mul(token.tierFees[token.tierAmounts.length - 1])
1641                 .div(10000)
1642             );
1643             newAmount = amount.sub(fee);
1644         }
1645         return(fee, newAmount);
1646     }
1647 }