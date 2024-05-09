1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 
4 pragma solidity ^0.7.0;
5 
6 /**
7  * @dev Standard math utilities missing in the Solidity language.
8  */
9 library Math {
10     /**
11      * @dev Returns the largest of two numbers.
12      */
13     function max(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a >= b ? a : b;
15     }
16 
17     /**
18      * @dev Returns the smallest of two numbers.
19      */
20     function min(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a < b ? a : b;
22     }
23 
24     /**
25      * @dev Returns the average of two numbers. The result is rounded towards
26      * zero.
27      */
28     function average(uint256 a, uint256 b) internal pure returns (uint256) {
29         // (a + b) / 2 can overflow, so we distribute
30         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
31     }
32 }
33 
34 // File: @openzeppelin/contracts/math/SafeMath.sol
35 
36 
37 pragma solidity ^0.7.0;
38 
39 /**
40  * @dev Wrappers over Solidity's arithmetic operations with added overflow
41  * checks.
42  *
43  * Arithmetic operations in Solidity wrap on overflow. This can easily result
44  * in bugs, because programmers usually assume that an overflow raises an
45  * error, which is the standard behavior in high level programming languages.
46  * `SafeMath` restores this intuition by reverting the transaction when an
47  * operation overflows.
48  *
49  * Using this library instead of the unchecked operations eliminates an entire
50  * class of bugs, so it's recommended to use it always.
51  */
52 library SafeMath {
53     /**
54      * @dev Returns the addition of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `+` operator.
58      *
59      * Requirements:
60      *
61      * - Addition cannot overflow.
62      */
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the subtraction of two unsigned integers, reverting on
72      * overflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      *
78      * - Subtraction cannot overflow.
79      */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83 
84     /**
85      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
86      * overflow (when the result is negative).
87      *
88      * Counterpart to Solidity's `-` operator.
89      *
90      * Requirements:
91      *
92      * - Subtraction cannot overflow.
93      */
94     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the multiplication of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `*` operator.
106      *
107      * Requirements:
108      *
109      * - Multiplication cannot overflow.
110      */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
113         // benefit is lost if 'b' is also tested.
114         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
115         if (a == 0) {
116             return 0;
117         }
118 
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers. Reverts on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return div(a, b, "SafeMath: division by zero");
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b > 0, errorMessage);
155         uint256 c = a / b;
156         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
163      * Reverts when dividing by zero.
164      *
165      * Counterpart to Solidity's `%` operator. This function uses a `revert`
166      * opcode (which leaves remaining gas untouched) while Solidity uses an
167      * invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174         return mod(a, b, "SafeMath: modulo by zero");
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts with custom message when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b != 0, errorMessage);
191         return a % b;
192     }
193 }
194 
195 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
196 
197 
198 pragma solidity ^0.7.0;
199 
200 /**
201  * @dev Interface of the ERC20 standard as defined in the EIP.
202  */
203 interface IERC20 {
204     /**
205      * @dev Returns the amount of tokens in existence.
206      */
207     function totalSupply() external view returns (uint256);
208 
209     /**
210      * @dev Returns the amount of tokens owned by `account`.
211      */
212     function balanceOf(address account) external view returns (uint256);
213 
214     /**
215      * @dev Moves `amount` tokens from the caller's account to `recipient`.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transfer(address recipient, uint256 amount) external returns (bool);
222 
223     /**
224      * @dev Returns the remaining number of tokens that `spender` will be
225      * allowed to spend on behalf of `owner` through {transferFrom}. This is
226      * zero by default.
227      *
228      * This value changes when {approve} or {transferFrom} are called.
229      */
230     function allowance(address owner, address spender) external view returns (uint256);
231 
232     /**
233      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * IMPORTANT: Beware that changing an allowance with this method brings the risk
238      * that someone may use both the old and the new allowance by unfortunate
239      * transaction ordering. One possible solution to mitigate this race
240      * condition is to first reduce the spender's allowance to 0 and set the
241      * desired value afterwards:
242      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243      *
244      * Emits an {Approval} event.
245      */
246     function approve(address spender, uint256 amount) external returns (bool);
247 
248     /**
249      * @dev Moves `amount` tokens from `sender` to `recipient` using the
250      * allowance mechanism. `amount` is then deducted from the caller's
251      * allowance.
252      *
253      * Returns a boolean value indicating whether the operation succeeded.
254      *
255      * Emits a {Transfer} event.
256      */
257     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
258 
259     /**
260      * @dev Emitted when `value` tokens are moved from one account (`from`) to
261      * another (`to`).
262      *
263      * Note that `value` may be zero.
264      */
265     event Transfer(address indexed from, address indexed to, uint256 value);
266 
267     /**
268      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
269      * a call to {approve}. `value` is the new allowance.
270      */
271     event Approval(address indexed owner, address indexed spender, uint256 value);
272 }
273 
274 // File: @openzeppelin/contracts/utils/Address.sol
275 
276 
277 pragma solidity ^0.7.0;
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
302         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
303         // for accounts without code, i.e. `keccak256('')`
304         bytes32 codehash;
305         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
306         // solhint-disable-next-line no-inline-assembly
307         assembly { codehash := extcodehash(account) }
308         return (codehash != accountHash && codehash != 0x0);
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
331         (bool success, ) = recipient.call{ value: amount }("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain`call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354       return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
364         return _functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
384      * with `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         return _functionCallWithValue(target, data, value, errorMessage);
391     }
392 
393     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 // solhint-disable-next-line no-inline-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
418 
419 
420 pragma solidity ^0.7.0;
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
431  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
432  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
433  */
434 library SafeERC20 {
435     using SafeMath for uint256;
436     using Address for address;
437 
438     function safeTransfer(IERC20 token, address to, uint256 value) internal {
439         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
440     }
441 
442     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
443         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
444     }
445 
446     /**
447      * @dev Deprecated. This function has issues similar to the ones found in
448      * {IERC20-approve}, and its usage is discouraged.
449      *
450      * Whenever possible, use {safeIncreaseAllowance} and
451      * {safeDecreaseAllowance} instead.
452      */
453     function safeApprove(IERC20 token, address spender, uint256 value) internal {
454         // safeApprove should only be called when setting an initial allowance,
455         // or when resetting it to zero. To increase and decrease it, use
456         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
457         // solhint-disable-next-line max-line-length
458         require((value == 0) || (token.allowance(address(this), spender) == 0),
459             "SafeERC20: approve from non-zero to non-zero allowance"
460         );
461         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
462     }
463 
464     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
465         uint256 newAllowance = token.allowance(address(this), spender).add(value);
466         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
467     }
468 
469     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
470         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
471         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
472     }
473 
474     /**
475      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
476      * on the return value: the return value is optional (but if data is returned, it must not be false).
477      * @param token The token targeted by the call.
478      * @param data The call data (encoded using abi.encode or one of its variants).
479      */
480     function _callOptionalReturn(IERC20 token, bytes memory data) private {
481         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
482         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
483         // the target address contains contract code and also asserts for success in the low-level call.
484 
485         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
486         if (returndata.length > 0) { // Return data is optional
487             // solhint-disable-next-line max-line-length
488             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
489         }
490     }
491 }
492 
493 // File: contracts/interfaces/ILPPool.sol
494 
495 
496 pragma solidity ^0.7.4;
497 
498 
499 interface ILPPool {
500     //================== Callers ==================//
501     function mir() external view returns (IERC20);
502 
503     function startTime() external view returns (uint256);
504 
505     function totalReward() external view returns (uint256);
506 
507     function earned(address account) external view returns (uint256);
508 
509     //================== Transactors ==================//
510 
511     function stake(uint256 amount) external;
512 
513     function withdraw(uint256 amount) external;
514 
515     function exit() external;
516 
517     function getReward() external;
518 }
519 
520 // File: @openzeppelin/contracts/GSN/Context.sol
521 
522 
523 pragma solidity ^0.7.0;
524 
525 /*
526  * @dev Provides information about the current execution context, including the
527  * sender of the transaction and its data. While these are generally available
528  * via msg.sender and msg.data, they should not be accessed in such a direct
529  * manner, since when dealing with GSN meta-transactions the account sending and
530  * paying for execution may not be the actual sender (as far as an application
531  * is concerned).
532  *
533  * This contract is only required for intermediate, library-like contracts.
534  */
535 abstract contract Context {
536     function _msgSender() internal view virtual returns (address payable) {
537         return msg.sender;
538     }
539 
540     function _msgData() internal view virtual returns (bytes memory) {
541         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
542         return msg.data;
543     }
544 }
545 
546 // File: @openzeppelin/contracts/access/Ownable.sol
547 
548 
549 pragma solidity ^0.7.0;
550 
551 /**
552  * @dev Contract module which provides a basic access control mechanism, where
553  * there is an account (an owner) that can be granted exclusive access to
554  * specific functions.
555  *
556  * By default, the owner account will be the one that deploys the contract. This
557  * can later be changed with {transferOwnership}.
558  *
559  * This module is used through inheritance. It will make available the modifier
560  * `onlyOwner`, which can be applied to your functions to restrict their use to
561  * the owner.
562  */
563 abstract contract Ownable is Context {
564     address private _owner;
565 
566     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
567 
568     /**
569      * @dev Initializes the contract setting the deployer as the initial owner.
570      */
571     constructor () {
572         address msgSender = _msgSender();
573         _owner = msgSender;
574         emit OwnershipTransferred(address(0), msgSender);
575     }
576 
577     /**
578      * @dev Returns the address of the current owner.
579      */
580     function owner() public view returns (address) {
581         return _owner;
582     }
583 
584     /**
585      * @dev Throws if called by any account other than the owner.
586      */
587     modifier onlyOwner() {
588         require(_owner == _msgSender(), "Ownable: caller is not the owner");
589         _;
590     }
591 
592     /**
593      * @dev Leaves the contract without owner. It will not be possible to call
594      * `onlyOwner` functions anymore. Can only be called by the current owner.
595      *
596      * NOTE: Renouncing ownership will leave the contract without an owner,
597      * thereby removing any functionality that is only available to the owner.
598      */
599     function renounceOwnership() public virtual onlyOwner {
600         emit OwnershipTransferred(_owner, address(0));
601         _owner = address(0);
602     }
603 
604     /**
605      * @dev Transfers ownership of the contract to a new account (`newOwner`).
606      * Can only be called by the current owner.
607      */
608     function transferOwnership(address newOwner) public virtual onlyOwner {
609         require(newOwner != address(0), "Ownable: new owner is the zero address");
610         emit OwnershipTransferred(_owner, newOwner);
611         _owner = newOwner;
612     }
613 }
614 
615 // File: contracts/interfaces/IRewardDistributionRecipient.sol
616 
617 
618 pragma solidity ^0.7.4;
619 
620 
621 abstract contract IRewardDistributionRecipient is Ownable {
622     address public rewardDistribution;
623 
624     function notifyReward() external virtual;
625 
626     modifier onlyRewardDistribution() {
627         require(
628             _msgSender() == rewardDistribution,
629             'Caller is not reward distribution'
630         );
631         _;
632     }
633 
634     function setRewardDistribution(address _rewardDistribution)
635         external
636         virtual
637         onlyOwner
638     {
639         rewardDistribution = _rewardDistribution;
640     }
641 }
642 
643 // File: contracts/token/LPTokenWrapper.sol
644 
645 
646 pragma solidity ^0.7.4;
647 
648 
649 
650 
651 contract LPTokenWrapper {
652     using SafeMath for uint256;
653     using SafeERC20 for IERC20;
654 
655     IERC20 public lpt;
656 
657     uint256 private _totalSupply;
658     mapping(address => uint256) private _balances;
659 
660     function totalSupply() public view returns (uint256) {
661         return _totalSupply;
662     }
663 
664     function balanceOf(address account) public view returns (uint256) {
665         return _balances[account];
666     }
667 
668     function stake(uint256 amount) public virtual {
669         _totalSupply = _totalSupply.add(amount);
670         _balances[msg.sender] = _balances[msg.sender].add(amount);
671         lpt.safeTransferFrom(msg.sender, address(this), amount);
672     }
673 
674     function withdraw(uint256 amount) public virtual {
675         _totalSupply = _totalSupply.sub(amount);
676         _balances[msg.sender] = _balances[msg.sender].sub(amount);
677         lpt.safeTransfer(msg.sender, amount);
678     }
679 }
680 
681 // File: contracts/distribution/LPPool.sol
682 
683 
684 pragma solidity ^0.7.4;
685 
686 
687 
688 
689 
690 
691 
692 
693 
694 contract LPPool is ILPPool, LPTokenWrapper, IRewardDistributionRecipient {
695     using SafeMath for uint256;
696     using SafeERC20 for IERC20;
697 
698     uint256 public constant DURATION = 365 days;
699 
700     // Immutable
701     IERC20 public immutable override mir;
702     uint256 public immutable override startTime;
703     uint256 public immutable override totalReward;
704 
705     // Time
706     uint256 public periodFinish;
707     uint256 public lastUpdateTime;
708 
709     // Reward
710     uint256[] public rewards;
711     uint256 public rewardRate;
712     uint256 public rewardPerTokenStored;
713 
714     // Deflation
715     uint256 public deflationCount = 0;
716 
717     mapping(address => uint256) public userRewardPerTokenPaid;
718     mapping(address => uint256) public rewardEarned;
719 
720     // Events
721     event RewardNotified(uint256 reward);
722     event RewardUpdated(uint256 reward);
723     event Staked(address indexed user, uint256 amount);
724     event Withdrawn(address indexed user, uint256 amount);
725     event RewardPaid(address indexed user, uint256 reward);
726 
727     constructor(
728         address _mir,
729         address _lpt,
730         uint256 _startTime,
731         uint256[] memory _rewards,
732         uint256 _totalReward
733     ) {
734         require(
735             _rewards.length > 0,
736             "LPPool: initReward should be greater than zero"
737         );
738         require(
739             _startTime > block.timestamp,
740             "LPPool: startTime should be greater than current timestamp"
741         );
742 
743         mir = IERC20(_mir);
744         lpt = IERC20(_lpt);
745         startTime = _startTime;
746         rewards = _rewards;
747         totalReward = _totalReward;
748     }
749 
750     //================== Modifier ==================//
751 
752     modifier updateReward(address account) {
753         rewardPerTokenStored = rewardPerToken();
754         lastUpdateTime = lastTimeRewardApplicable();
755         if (account != address(0)) {
756             rewardEarned[account] = earned(account);
757             userRewardPerTokenPaid[account] = rewardPerTokenStored;
758         }
759         _;
760     }
761 
762     modifier checkHalve() {
763         if (block.timestamp >= periodFinish && deflationCount < rewards.length.sub(1)) {
764             deflationCount = deflationCount.add(1);
765             rewardRate = currentReward().div(DURATION);
766             periodFinish = block.timestamp.add(DURATION);
767             emit RewardUpdated(currentReward());
768         }
769         _;
770     }
771 
772     modifier checkStart() {
773         require(block.timestamp >= startTime, "not start");
774         _;
775     }
776 
777     //================== Callers ==================//
778 
779     function currentReward() public view returns (uint256) {
780         return rewards[deflationCount];
781     }
782 
783     function lastTimeRewardApplicable() public view returns (uint256) {
784         return Math.min(block.timestamp, periodFinish);
785     }
786 
787     function rewardPerToken() public view returns (uint256) {
788         if (totalSupply() == 0) {
789             return rewardPerTokenStored;
790         }
791         return
792             rewardPerTokenStored.add(
793                 lastTimeRewardApplicable()
794                     .sub(lastUpdateTime)
795                     .mul(rewardRate)
796                     .mul(1e18)
797                     .div(totalSupply())
798             );
799     }
800 
801     function earned(address account) public override view returns (uint256) {
802         return
803             balanceOf(account)
804                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
805                 .div(1e18)
806                 .add(rewardEarned[account]);
807     }
808 
809     //================== Transactors ==================//
810 
811     // stake visibility is public as overriding LPTokenWrapper's stake() function
812     function stake(uint256 amount)
813         public
814         override(ILPPool, LPTokenWrapper)
815         updateReward(msg.sender)
816         checkHalve
817         checkStart
818     {
819         require(amount > 0, "Cannot stake 0");
820         super.stake(amount);
821         emit Staked(msg.sender, amount);
822     }
823 
824     function withdraw(uint256 amount)
825         public
826         override(ILPPool, LPTokenWrapper)
827         updateReward(msg.sender)
828         checkHalve
829         checkStart
830     {
831         require(amount > 0, "Cannot withdraw 0");
832         super.withdraw(amount);
833         emit Withdrawn(msg.sender, amount);
834     }
835 
836     function exit() external override {
837         withdraw(balanceOf(msg.sender));
838         getReward();
839     }
840 
841     function getReward()
842         public
843         override
844         updateReward(msg.sender)
845         checkHalve
846         checkStart
847     {
848         uint256 reward = earned(msg.sender);
849         if (reward > 0) {
850             rewardEarned[msg.sender] = 0;
851             mir.safeTransfer(msg.sender, reward);
852             emit RewardPaid(msg.sender, reward);
853         }
854     }
855 
856     function notifyReward()
857         external
858         override
859         onlyRewardDistribution
860         updateReward(address(0))
861     {
862         rewardRate = currentReward().div(DURATION);
863         lastUpdateTime = startTime;
864         periodFinish = startTime.add(DURATION);
865         emit RewardNotified(currentReward());
866     }
867 }