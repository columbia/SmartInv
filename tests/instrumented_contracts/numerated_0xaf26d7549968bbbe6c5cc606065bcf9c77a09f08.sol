1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: @openzeppelin/contracts/math/SafeMath.sol
80 
81 pragma solidity ^0.6.0;
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 pragma solidity ^0.6.2;
241 
242 /**
243  * @dev Collection of functions related to the address type
244  */
245 library Address {
246     /**
247      * @dev Returns true if `account` is a contract.
248      *
249      * [IMPORTANT]
250      * ====
251      * It is unsafe to assume that an address for which this function returns
252      * false is an externally-owned account (EOA) and not a contract.
253      *
254      * Among others, `isContract` will return false for the following
255      * types of addresses:
256      *
257      *  - an externally-owned account
258      *  - a contract in construction
259      *  - an address where a contract will be created
260      *  - an address where a contract lived, but was destroyed
261      * ====
262      */
263     function isContract(address account) internal view returns (bool) {
264         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
265         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
266         // for accounts without code, i.e. `keccak256('')`
267         bytes32 codehash;
268         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
269         // solhint-disable-next-line no-inline-assembly
270         assembly { codehash := extcodehash(account) }
271         return (codehash != accountHash && codehash != 0x0);
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
294         (bool success, ) = recipient.call{ value: amount }("");
295         require(success, "Address: unable to send value, recipient may have reverted");
296     }
297 
298     /**
299      * @dev Performs a Solidity function call using a low level `call`. A
300      * plain`call` is an unsafe replacement for a function call: use this
301      * function instead.
302      *
303      * If `target` reverts with a revert reason, it is bubbled up by this
304      * function (like regular Solidity function calls).
305      *
306      * Returns the raw returned data. To convert to the expected return value,
307      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
308      *
309      * Requirements:
310      *
311      * - `target` must be a contract.
312      * - calling `target` with `data` must not revert.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
317       return functionCall(target, data, "Address: low-level call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
322      * `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
327         return _functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         return _functionCallWithValue(target, data, value, errorMessage);
354     }
355 
356     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
357         require(isContract(target), "Address: call to non-contract");
358 
359         // solhint-disable-next-line avoid-low-level-calls
360         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
361         if (success) {
362             return returndata;
363         } else {
364             // Look for revert reason and bubble it up if present
365             if (returndata.length > 0) {
366                 // The easiest way to bubble the revert reason is using memory via assembly
367 
368                 // solhint-disable-next-line no-inline-assembly
369                 assembly {
370                     let returndata_size := mload(returndata)
371                     revert(add(32, returndata), returndata_size)
372                 }
373             } else {
374                 revert(errorMessage);
375             }
376         }
377     }
378 }
379 
380 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
381 pragma solidity ^0.6.0;
382 
383 /**
384  * @title SafeERC20
385  * @dev Wrappers around ERC20 operations that throw on failure (when the token
386  * contract returns false). Tokens that return no value (and instead revert or
387  * throw on failure) are also supported, non-reverting calls are assumed to be
388  * successful.
389  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
390  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
391  */
392 library SafeERC20 {
393     using SafeMath for uint256;
394     using Address for address;
395 
396     function safeTransfer(IERC20 token, address to, uint256 value) internal {
397         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
398     }
399 
400     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
401         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
402     }
403 
404     /**
405      * @dev Deprecated. This function has issues similar to the ones found in
406      * {IERC20-approve}, and its usage is discouraged.
407      *
408      * Whenever possible, use {safeIncreaseAllowance} and
409      * {safeDecreaseAllowance} instead.
410      */
411     function safeApprove(IERC20 token, address spender, uint256 value) internal {
412         // safeApprove should only be called when setting an initial allowance,
413         // or when resetting it to zero. To increase and decrease it, use
414         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
415         // solhint-disable-next-line max-line-length
416         require((value == 0) || (token.allowance(address(this), spender) == 0),
417             "SafeERC20: approve from non-zero to non-zero allowance"
418         );
419         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
420     }
421 
422     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
423         uint256 newAllowance = token.allowance(address(this), spender).add(value);
424         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
425     }
426 
427     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
428         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
429         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
430     }
431 
432     /**
433      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
434      * on the return value: the return value is optional (but if data is returned, it must not be false).
435      * @param token The token targeted by the call.
436      * @param data The call data (encoded using abi.encode or one of its variants).
437      */
438     function _callOptionalReturn(IERC20 token, bytes memory data) private {
439         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
440         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
441         // the target address contains contract code and also asserts for success in the low-level call.
442 
443         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
444         if (returndata.length > 0) { // Return data is optional
445             // solhint-disable-next-line max-line-length
446             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
447         }
448     }
449 }
450 
451 // File: @openzeppelin/contracts/GSN/Context.sol
452 pragma solidity ^0.6.0;
453 
454 /*
455  * @dev Provides information about the current execution context, including the
456  * sender of the transaction and its data. While these are generally available
457  * via msg.sender and msg.data, they should not be accessed in such a direct
458  * manner, since when dealing with GSN meta-transactions the account sending and
459  * paying for execution may not be the actual sender (as far as an application
460  * is concerned).
461  *
462  * This contract is only required for intermediate, library-like contracts.
463  */
464 abstract contract Context {
465     function _msgSender() internal view virtual returns (address payable) {
466         return msg.sender;
467     }
468 
469     function _msgData() internal view virtual returns (bytes memory) {
470         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
471         return msg.data;
472     }
473 }
474 
475 // File: @openzeppelin/contracts/access/Ownable.sol
476 pragma solidity ^0.6.0;
477 
478 /**
479  * @dev Contract module which provides a basic access control mechanism, where
480  * there is an account (an owner) that can be granted exclusive access to
481  * specific functions.
482  *
483  * By default, the owner account will be the one that deploys the contract. This
484  * can later be changed with {transferOwnership}.
485  *
486  * This module is used through inheritance. It will make available the modifier
487  * `onlyOwner`, which can be applied to your functions to restrict their use to
488  * the owner.
489  */
490 contract Ownable is Context {
491     address private _owner;
492 
493     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
494 
495     /**
496      * @dev Initializes the contract setting the deployer as the initial owner.
497      */
498     constructor () internal {
499         address msgSender = _msgSender();
500         _owner = msgSender;
501         emit OwnershipTransferred(address(0), msgSender);
502     }
503 
504     /**
505      * @dev Returns the address of the current owner.
506      */
507     function owner() public view returns (address) {
508         return _owner;
509     }
510 
511     /**
512      * @dev Throws if called by any account other than the owner.
513      */
514     modifier onlyOwner() {
515         require(_owner == _msgSender(), "Ownable: caller is not the owner");
516         _;
517     }
518 
519     /**
520      * @dev Leaves the contract without owner. It will not be possible to call
521      * `onlyOwner` functions anymore. Can only be called by the current owner.
522      *
523      * NOTE: Renouncing ownership will leave the contract without an owner,
524      * thereby removing any functionality that is only available to the owner.
525      */
526     function renounceOwnership() public virtual onlyOwner {
527         emit OwnershipTransferred(_owner, address(0));
528         _owner = address(0);
529     }
530 
531     /**
532      * @dev Transfers ownership of the contract to a new account (`newOwner`).
533      * Can only be called by the current owner.
534      */
535     function transferOwnership(address newOwner) public virtual onlyOwner {
536         require(newOwner != address(0), "Ownable: new owner is the zero address");
537         emit OwnershipTransferred(_owner, newOwner);
538         _owner = newOwner;
539     }
540 }
541 
542 // File: contracts/interface/IDFI.sol
543 
544 pragma solidity ^0.6.0;
545 
546 
547 // definition, define interface is better..
548 interface IDFI is IERC20 {
549     function mint(address _to, uint256 _amount) external returns (bool);
550 }
551 
552 
553 pragma solidity ^0.6.0;
554 
555 contract DfiChef is Ownable {
556     using SafeMath for uint256;
557     using SafeERC20 for IERC20;
558 
559     // Info of each user.
560     struct UserInfo {
561         uint256 amount;     // How many LP tokens the user has provided.
562         uint256 rewardDebt; // Reward debt. See explanation below.
563         uint256 depositAt;  // deposit time
564     }
565 
566     // Info of each pool.
567     struct PoolInfo {
568         IERC20 lpToken;           // Address of LP token contract.
569         uint256 allocPoint;       // How many allocation points assigned to this pool. CHIFIs to distribute per block.
570         uint256 lastRewardBlock;  // Last block number that CHIFIs distribution occurs.
571         uint256 accDfiPerShare; // Accumulated CHIFIs per share, times 1e12. See below.
572     }
573 
574     // The DFI TOKEN!
575     IDFI public dfi;
576 
577     // Dev address.
578     address public devaddr;
579     uint256 public teamRatio        = 10;        // team ratio
580 
581     address public treasuryAddr;
582     uint256 public treasuryRatio    = 10;        // treasury ratio
583 
584     // Block number when bonus DFI period ends.
585     uint256 public bonusEndBlock;
586 
587     // DFI tokens created per block.
588     uint256 public initDfiPerBlock;
589 
590     // Bonus muliplier for early dfi makers.
591     uint256 public constant BONUS_MULTIPLIER = 1;
592 
593 	uint256 public halvingPeriod    = 46523;    // for about two weeks
594 
595     uint256 public halvingTimes     = 1;
596 
597     uint256 public pendingDuration  = 24 hours;
598 
599 
600     // Info of each pool.
601     PoolInfo[] public poolInfo;
602     // Info of each user that stakes LP tokens.
603     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
604     // Total allocation poitns. Must be the sum of all allocation points in all pools.
605     uint256 public totalAllocPoint = 0;
606     // The block number when DFI mining starts.
607     uint256 public startBlock;
608 
609     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
610     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
611     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
612 
613     constructor(
614         IDFI _dfi,
615         address _devaddr,
616         address _treasuryAddr,
617         uint256 _dfiPerBlock,
618         uint256 _startBlock,
619         uint256 _bonusEndBlock
620     ) public {
621         dfi             = _dfi;
622         devaddr         = _devaddr;
623         treasuryAddr    = _treasuryAddr;
624         initDfiPerBlock = _dfiPerBlock;
625         startBlock      = _startBlock;
626         bonusEndBlock   = _bonusEndBlock;
627     }
628 
629 
630     function poolLength() public view returns (uint256) {
631         return poolInfo.length;
632     }
633 
634     // Add a new lp to the pool. Can only be called by the owner.
635     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
636         for(uint256 i=0; i<poolLength(); i++) {
637             require(address(_lpToken) != address(poolInfo[i].lpToken), "Duplicate Token!");
638         }
639 
640         if (_withUpdate) {
641             massUpdatePools();
642         }
643 
644         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
645         totalAllocPoint = totalAllocPoint.add(_allocPoint);
646         poolInfo.push(PoolInfo({
647             lpToken: _lpToken,
648             allocPoint: _allocPoint,
649             lastRewardBlock: lastRewardBlock,
650             accDfiPerShare: 0
651         }));
652     }
653 
654     // Update the given pool's DFI allocation point. Can only be called by the owner.
655     function set(uint256 _pid, uint256 _allocPoint, uint8 _withUpdate) public onlyOwner {
656         if (_withUpdate != 0) {
657             massUpdatePools();
658         }
659         
660         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
661         poolInfo[_pid].allocPoint = _allocPoint;
662     }
663 
664     function updatePendingDuration(uint256 _time) external onlyOwner {
665         pendingDuration = _time;
666     }
667 
668 
669     // Return reward multiplier over the given _from to _to block.
670     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
671         if (_to <= bonusEndBlock) {
672             return _to.sub(_from).mul(BONUS_MULTIPLIER);
673         } else if (_from >= bonusEndBlock) {
674             return _to.sub(_from);
675         } else {
676             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
677                 _to.sub(bonusEndBlock)
678             );
679         }
680     }
681 
682 
683     // View function to see pending DFIs on frontend.
684     function pendingDfi(uint256 _pid, address _user) external view returns (uint256) {
685         PoolInfo storage pool = poolInfo[_pid];
686         UserInfo storage user = userInfo[_pid][_user];
687         uint256 accDfiPerShare = pool.accDfiPerShare;
688         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
689         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
690             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
691             uint256 blockReward = getDfiBlockReward();
692 
693             uint256 dfiReward = multiplier.mul(blockReward).mul(pool.allocPoint).div(totalAllocPoint);
694             accDfiPerShare = accDfiPerShare.add(dfiReward.mul(1e12).div(lpSupply));
695         }
696 
697         return user.amount.mul(accDfiPerShare).div(1e12).sub(user.rewardDebt);
698     }
699 
700     // Update reward vairables for all pools. Be careful of gas spending!
701     function massUpdatePools() public {
702         uint256 length = poolInfo.length;
703         for (uint256 pid = 0; pid < length; ++pid) {
704             updatePool(pid);
705         }
706     }
707 
708 
709     function getDfiBlockReward() public view returns (uint256) {
710         uint256 parseHalving = block.number.sub(startBlock).div(halvingPeriod);
711 		uint256 havingFactor = 2 ** parseHalving;
712         if (parseHalving > halvingTimes) {
713 			return 0;
714 		}
715 
716         return initDfiPerBlock.div(havingFactor);
717     }
718 
719     // Update reward variables of the given pool to be up-to-date.
720     function updatePool(uint256 _pid) public {
721         PoolInfo storage pool = poolInfo[_pid];
722         if (block.number <= pool.lastRewardBlock) {
723             return;
724         }
725         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
726         if (lpSupply == 0) {
727             pool.lastRewardBlock = block.number;
728             return;
729         }
730 
731 		uint256 blockReward = getDfiBlockReward();
732 		if (blockReward <= 0) {
733 			return;
734 		}
735 
736         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
737         uint256 dfiReward = multiplier.mul(blockReward).mul(pool.allocPoint).div(totalAllocPoint);
738 
739         // if blocks reaches the totalSupply, will mint nothing..
740         dfi.mint(devaddr, dfiReward.mul(teamRatio).div(100));
741         dfi.mint(treasuryAddr, dfiReward.mul(treasuryRatio).div(100));
742 
743         // if mint success, add the share
744         bool mintRet = dfi.mint(address(this), dfiReward);
745         if(mintRet) {
746             pool.accDfiPerShare = pool.accDfiPerShare.add(dfiReward.mul(1e12).div(lpSupply));
747         }
748 
749         pool.lastRewardBlock = block.number;
750     }
751 
752     function isPending(uint256 _pid) external view returns (bool) {
753         UserInfo storage user = userInfo[_pid][msg.sender];
754         if(block.timestamp >= user.depositAt.add(pendingDuration)) {
755             return false;
756         }
757 
758         return true;
759     }
760 
761     // Deposit LP tokens to MasterChef for DFI allocation.
762     function deposit(uint256 _pid, uint256 _amount) public {
763         PoolInfo storage pool = poolInfo[_pid];
764         UserInfo storage user = userInfo[_pid][msg.sender];
765 
766         updatePool(_pid);
767         if (user.amount > 0) {
768             uint256 pending = user.amount.mul(pool.accDfiPerShare).div(1e12).sub(user.rewardDebt);
769             safeDfiTransfer(msg.sender, pending);
770         }
771 
772         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
773         user.amount     = user.amount.add(_amount);
774         user.rewardDebt = user.amount.mul(pool.accDfiPerShare).div(1e12);
775         user.depositAt  = block.timestamp;
776 
777         emit Deposit(msg.sender, _pid, _amount);
778     }
779 
780     // Withdraw LP tokens from DfiChef.
781     function withdraw(uint256 _pid, uint256 _amount) public {
782         PoolInfo storage pool = poolInfo[_pid];
783         UserInfo storage user = userInfo[_pid][msg.sender];
784 
785         require(user.amount >= _amount, "withdraw: !balance");
786         require(block.timestamp >= user.depositAt.add(pendingDuration) ,"withdraw: pending.");
787 
788         updatePool(_pid);
789         uint256 pending = user.amount.mul(pool.accDfiPerShare).div(1e12).sub(user.rewardDebt);
790         safeDfiTransfer(msg.sender, pending);
791         
792         user.amount = user.amount.sub(_amount);
793         user.rewardDebt = user.amount.mul(pool.accDfiPerShare).div(1e12);
794         pool.lpToken.safeTransfer(address(msg.sender), _amount);
795 
796         emit Withdraw(msg.sender, _pid, _amount);
797     }
798 
799     // claim rewards
800     function claim(uint256 _pid) public {
801         PoolInfo storage pool = poolInfo[_pid];
802         UserInfo storage user = userInfo[_pid][msg.sender];
803 
804         updatePool(_pid);
805         uint256 pending = user.amount.mul(pool.accDfiPerShare).div(1e12).sub(user.rewardDebt);
806         safeDfiTransfer(msg.sender, pending);
807 
808         user.rewardDebt = user.amount.mul(pool.accDfiPerShare).div(1e12);
809     }
810 
811     // Withdraw without caring about rewards. EMERGENCY ONLY.
812     function emergencyWithdraw(uint256 _pid) public {
813         PoolInfo storage pool = poolInfo[_pid];
814         UserInfo storage user = userInfo[_pid][msg.sender];
815         
816         require(block.timestamp >= user.depositAt.add(pendingDuration) ,"withdraw: pending.");
817 
818         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
819         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
820         user.amount = 0;
821         user.rewardDebt = 0;
822     }
823 
824     // Safe dif transfer function, just in case if rounding error causes pool to not have enough dfis.
825     function safeDfiTransfer(address _to, uint256 _amount) internal {
826         if(_amount > 0) {
827             uint256 dfiBalance = dfi.balanceOf(address(this));
828             if (_amount > dfiBalance) {
829                 dfi.transfer(_to, dfiBalance);
830             } else {
831                 dfi.transfer(_to, _amount);
832             }
833         }
834     }
835 
836     // Update dev address by the previous dev.
837     function dev(address _devaddr) public {
838         require(msg.sender == devaddr, "DynamicDollar.Finance: wrong dev?");
839         devaddr = _devaddr;
840     }
841 }