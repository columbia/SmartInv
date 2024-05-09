1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 
84 
85 pragma solidity >=0.6.0 <0.8.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, with an overflow flag.
103      *
104      * _Available since v3.4._
105      */
106     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         uint256 c = a + b;
108         if (c < a) return (false, 0);
109         return (true, c);
110     }
111 
112     /**
113      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
114      *
115      * _Available since v3.4._
116      */
117     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
118         if (b > a) return (false, 0);
119         return (true, a - b);
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
124      *
125      * _Available since v3.4._
126      */
127     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
128         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129         // benefit is lost if 'b' is also tested.
130         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131         if (a == 0) return (true, 0);
132         uint256 c = a * b;
133         if (c / a != b) return (false, 0);
134         return (true, c);
135     }
136 
137     /**
138      * @dev Returns the division of two unsigned integers, with a division by zero flag.
139      *
140      * _Available since v3.4._
141      */
142     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
143         if (b == 0) return (false, 0);
144         return (true, a / b);
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
149      *
150      * _Available since v3.4._
151      */
152     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
153         if (b == 0) return (false, 0);
154         return (true, a % b);
155     }
156 
157     /**
158      * @dev Returns the addition of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `+` operator.
162      *
163      * Requirements:
164      *
165      * - Addition cannot overflow.
166      */
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         uint256 c = a + b;
169         require(c >= a, "SafeMath: addition overflow");
170         return c;
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
184         require(b <= a, "SafeMath: subtraction overflow");
185         return a - b;
186     }
187 
188     /**
189      * @dev Returns the multiplication of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `*` operator.
193      *
194      * Requirements:
195      *
196      * - Multiplication cannot overflow.
197      */
198     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
199         if (a == 0) return 0;
200         uint256 c = a * b;
201         require(c / a == b, "SafeMath: multiplication overflow");
202         return c;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers, reverting on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         require(b > 0, "SafeMath: division by zero");
219         return a / b;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * reverting when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b > 0, "SafeMath: modulo by zero");
236         return a % b;
237     }
238 
239     /**
240      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
241      * overflow (when the result is negative).
242      *
243      * CAUTION: This function is deprecated because it requires allocating memory for the error
244      * message unnecessarily. For custom revert reasons use {trySub}.
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      *
250      * - Subtraction cannot overflow.
251      */
252     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b <= a, errorMessage);
254         return a - b;
255     }
256 
257     /**
258      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
259      * division by zero. The result is rounded towards zero.
260      *
261      * CAUTION: This function is deprecated because it requires allocating memory for the error
262      * message unnecessarily. For custom revert reasons use {tryDiv}.
263      *
264      * Counterpart to Solidity's `/` operator. Note: this function uses a
265      * `revert` opcode (which leaves remaining gas untouched) while Solidity
266      * uses an invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b > 0, errorMessage);
274         return a / b;
275     }
276 
277     /**
278      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
279      * reverting with custom message when dividing by zero.
280      *
281      * CAUTION: This function is deprecated because it requires allocating memory for the error
282      * message unnecessarily. For custom revert reasons use {tryMod}.
283      *
284      * Counterpart to Solidity's `%` operator. This function uses a `revert`
285      * opcode (which leaves remaining gas untouched) while Solidity uses an
286      * invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      *
290      * - The divisor cannot be zero.
291      */
292     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b > 0, errorMessage);
294         return a % b;
295     }
296 }
297 
298 // File: @openzeppelin/contracts/utils/Address.sol
299 
300 
301 
302 pragma solidity >=0.6.2 <0.8.0;
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies on extcodesize, which returns 0 for contracts in
327         // construction, since the code is only stored at the end of the
328         // constructor execution.
329 
330         uint256 size;
331         // solhint-disable-next-line no-inline-assembly
332         assembly { size := extcodesize(account) }
333         return size > 0;
334     }
335 
336     /**
337      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
338      * `recipient`, forwarding all available gas and reverting on errors.
339      *
340      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
341      * of certain opcodes, possibly making contracts go over the 2300 gas limit
342      * imposed by `transfer`, making them unable to receive funds via
343      * `transfer`. {sendValue} removes this limitation.
344      *
345      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
346      *
347      * IMPORTANT: because control is transferred to `recipient`, care must be
348      * taken to not create reentrancy vulnerabilities. Consider using
349      * {ReentrancyGuard} or the
350      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
351      */
352     function sendValue(address payable recipient, uint256 amount) internal {
353         require(address(this).balance >= amount, "Address: insufficient balance");
354 
355         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
356         (bool success, ) = recipient.call{ value: amount }("");
357         require(success, "Address: unable to send value, recipient may have reverted");
358     }
359 
360     /**
361      * @dev Performs a Solidity function call using a low level `call`. A
362      * plain`call` is an unsafe replacement for a function call: use this
363      * function instead.
364      *
365      * If `target` reverts with a revert reason, it is bubbled up by this
366      * function (like regular Solidity function calls).
367      *
368      * Returns the raw returned data. To convert to the expected return value,
369      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370      *
371      * Requirements:
372      *
373      * - `target` must be a contract.
374      * - calling `target` with `data` must not revert.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
379       return functionCall(target, data, "Address: low-level call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
384      * `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, 0, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but also transferring `value` wei to `target`.
395      *
396      * Requirements:
397      *
398      * - the calling contract must have an ETH balance of at least `value`.
399      * - the called Solidity function must be `payable`.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
414         require(address(this).balance >= value, "Address: insufficient balance for call");
415         require(isContract(target), "Address: call to non-contract");
416 
417         // solhint-disable-next-line avoid-low-level-calls
418         (bool success, bytes memory returndata) = target.call{ value: value }(data);
419         return _verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
429         return functionStaticCall(target, data, "Address: low-level static call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
439         require(isContract(target), "Address: static call to non-contract");
440 
441         // solhint-disable-next-line avoid-low-level-calls
442         (bool success, bytes memory returndata) = target.staticcall(data);
443         return _verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
453         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
463         require(isContract(target), "Address: delegate call to non-contract");
464 
465         // solhint-disable-next-line avoid-low-level-calls
466         (bool success, bytes memory returndata) = target.delegatecall(data);
467         return _verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
471         if (success) {
472             return returndata;
473         } else {
474             // Look for revert reason and bubble it up if present
475             if (returndata.length > 0) {
476                 // The easiest way to bubble the revert reason is using memory via assembly
477 
478                 // solhint-disable-next-line no-inline-assembly
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
491 
492 
493 
494 pragma solidity >=0.6.0 <0.8.0;
495 
496 
497 
498 
499 /**
500  * @title SafeERC20
501  * @dev Wrappers around ERC20 operations that throw on failure (when the token
502  * contract returns false). Tokens that return no value (and instead revert or
503  * throw on failure) are also supported, non-reverting calls are assumed to be
504  * successful.
505  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
506  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
507  */
508 library SafeERC20 {
509     using SafeMath for uint256;
510     using Address for address;
511 
512     function safeTransfer(IERC20 token, address to, uint256 value) internal {
513         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
514     }
515 
516     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
517         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
518     }
519 
520     /**
521      * @dev Deprecated. This function has issues similar to the ones found in
522      * {IERC20-approve}, and its usage is discouraged.
523      *
524      * Whenever possible, use {safeIncreaseAllowance} and
525      * {safeDecreaseAllowance} instead.
526      */
527     function safeApprove(IERC20 token, address spender, uint256 value) internal {
528         // safeApprove should only be called when setting an initial allowance,
529         // or when resetting it to zero. To increase and decrease it, use
530         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
531         // solhint-disable-next-line max-line-length
532         require((value == 0) || (token.allowance(address(this), spender) == 0),
533             "SafeERC20: approve from non-zero to non-zero allowance"
534         );
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
536     }
537 
538     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
539         uint256 newAllowance = token.allowance(address(this), spender).add(value);
540         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
541     }
542 
543     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
544         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
545         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
546     }
547 
548     /**
549      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
550      * on the return value: the return value is optional (but if data is returned, it must not be false).
551      * @param token The token targeted by the call.
552      * @param data The call data (encoded using abi.encode or one of its variants).
553      */
554     function _callOptionalReturn(IERC20 token, bytes memory data) private {
555         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
556         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
557         // the target address contains contract code and also asserts for success in the low-level call.
558 
559         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
560         if (returndata.length > 0) { // Return data is optional
561             // solhint-disable-next-line max-line-length
562             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
563         }
564     }
565 }
566 
567 // File: contracts/interfaces/IBurnable.sol
568 
569 //SPDX-License-Identifier: Unlicense
570 pragma solidity 0.7.6;
571 
572 interface IBurnable {
573   function burn(uint256 amount) external;
574   function balanceOf(address account) external view returns (uint256);
575 }
576 
577 // File: contracts/interfaces/IFarmManager.sol
578 
579 
580 pragma solidity 0.7.6;
581 
582 interface IFarmManager {
583     function getPaused() external view returns(bool);
584     function getBurnRate() external view returns(uint256);
585     function getUnstakeEpochs() external view returns(uint256);
586     function getRedistributor() external view returns(address);
587     function getLpLock() external view returns(address);
588 }
589 
590 // File: contracts/Farm.sol
591 
592 
593 pragma solidity 0.7.6;
594 pragma abicoder v2;
595 
596 
597 
598 
599 
600 
601 // Farm distributes the ERC20 rewards based on staked LP to each user.
602 contract Farm {
603     using SafeMath for uint256;
604     using SafeERC20 for IERC20;
605 
606         // Info of each user.
607     struct UserInfo {
608         uint256 amount;     // How many LP tokens the user has provided.
609         uint256 rewardDebt; // Reward debt. See explanation below.
610         uint256 lastClaimTime;
611         uint256 withdrawTime;
612         
613         // We do some fancy math here. Basically, any point in time, the amount of ERC20s
614         // entitled to a user but is pending to be distributed is:
615         //
616         //   pending reward = (user.amount * pool.accERC20PerShare) - user.rewardDebt
617         //
618         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
619         //   1. The pool's `accERC20PerShare` (and `lastRewardBlock`) gets updated.
620         //   2. User receives the pending reward sent to his/her address.
621         //   3. User's `amount` gets updated.
622         //   4. User's `rewardDebt` gets updated.
623     }
624 
625     // Info of each pool.
626     struct PoolInfo {
627         IERC20 stakingToken;         // Address of staking token contract.
628         uint256 allocPoint;         // How many allocation points assigned to this pool. ERC20s to distribute per block.
629         uint256 lastRewardBlock;    // Last block number that ERC20s distribution occurs.
630         uint256 accERC20PerShare;   // Accumulated ERC20s per share, times 1e36.
631         uint256 supply;             // changes with unstakes.
632         bool    isLP;               // if the staking token is an LP token.
633     }
634 
635     // Address of the ERC20 Token contract.
636     IERC20 public erc20;
637     // The total amount of ERC20 that's paid out as reward.
638     uint256 public paidOut = 0;
639     // ERC20 tokens rewarded per block.
640     uint256 public rewardPerBlock;
641     // Manager interface to get globals for all farms.
642     IFarmManager public manager;
643     // Info of each pool.
644     PoolInfo[] public poolInfo;
645     // Info of each user that stakes LP tokens.
646     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
647     // Total allocation points. Must be the sum of all allocation points in all pools.
648     uint256 public totalAllocPoint = 0;
649     // The block number when farming starts.
650     uint256 public startBlock;
651     // The block number when farming ends.
652     uint256 public endBlock;
653     // Seconds per epoch (1 day)
654     uint256 public constant SECS_EPOCH = 86400;
655 
656     // events
657     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
658     event Withdraw(address indexed user, uint256 indexed pid);
659     event Claim(address indexed user, uint256 indexed pid);
660     event Unstake(address indexed user, uint256 indexed pid);
661     event Initialize(IERC20 erc20, uint256 rewardPerBlock, uint256 startBlock, address manager);
662 
663     constructor(IERC20 _erc20, uint256 _rewardPerBlock, uint256 _startBlock, address _manager) public {
664         erc20 = _erc20;
665         rewardPerBlock = _rewardPerBlock;
666         startBlock = _startBlock;
667         endBlock = _startBlock;
668         manager = IFarmManager(_manager);
669         emit Initialize(_erc20, _rewardPerBlock, _startBlock, _manager);
670     }
671 
672     // Fund the farm, increase the end block.
673     function fund(uint256 _amount) external {
674         require(msg.sender == address(manager), "fund: sender is not manager");
675         require(block.number <= endBlock, "fund: too late, the farm is closed");
676 
677         erc20.safeTransferFrom(address(tx.origin), address(this), _amount);
678         endBlock += _amount.div(rewardPerBlock);
679     }
680 
681     // Update the given pool's ERC20 allocation point. Can only be called by the manager.
682     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) external {
683         require(msg.sender == address(manager), "set: sender is not manager");
684         if (_withUpdate) {
685             massUpdatePools();
686         }
687         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
688         poolInfo[_pid].allocPoint = _allocPoint;
689     }
690 
691     // Add a new staking token to the pool. Can only be called by the manager.
692     function add(uint256 _allocPoint, IERC20 _stakingToken, bool _isLP, bool _withUpdate) external {
693         require(msg.sender == address(manager), "fund: sender is not manager");
694         if (_withUpdate) {
695             massUpdatePools();
696         }
697         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
698         totalAllocPoint = totalAllocPoint.add(_allocPoint);
699         poolInfo.push(PoolInfo({
700             stakingToken: _stakingToken,
701             supply: 0,
702             allocPoint: _allocPoint,
703             lastRewardBlock: lastRewardBlock,
704             accERC20PerShare: 0,
705             isLP: _isLP
706         }));
707     }
708 
709     // Update reward variables for all pools. Be careful of gas spending!
710     function massUpdatePools() public {
711         uint256 length = poolInfo.length;
712         for (uint256 pid = 0; pid < length; ++pid) {
713             updatePool(pid);
714         }
715     }
716 
717     // Update reward variables of the given pool to be up-to-date.
718     function updatePool(uint256 _pid) public {
719         PoolInfo storage pool = poolInfo[_pid];
720         uint256 lastBlock = block.number < endBlock ? block.number : endBlock;
721 
722         if (lastBlock <= pool.lastRewardBlock) {
723             return;
724         }
725         if (pool.supply == 0) {
726             pool.lastRewardBlock = lastBlock;
727             return;
728         }
729 
730         uint256 nrOfBlocks = lastBlock.sub(pool.lastRewardBlock);
731         uint256 erc20Reward = nrOfBlocks.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
732 
733         pool.accERC20PerShare = pool.accERC20PerShare.add(erc20Reward.mul(1e36).div(pool.supply));
734         pool.lastRewardBlock = block.number;
735     }
736 
737     // move LP tokens from one farm to another. only callable by Manager. 
738     // tx.origin is user EOA, msg.sender is the Manager.
739     function move(uint256 _pid) external {
740         require(msg.sender == address(manager), "move: sender is not manager");
741         PoolInfo storage pool = poolInfo[_pid];
742         UserInfo storage user = userInfo[_pid][tx.origin];
743         updatePool(_pid);
744         uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
745         erc20Transfer(tx.origin, pendingAmount);
746         pool.supply = pool.supply.sub(user.amount);
747         pool.stakingToken.safeTransfer(address(manager), user.amount);
748         user.amount = 0;
749         user.rewardDebt = user.amount.mul(pool.accERC20PerShare).div(1e36);
750         emit Withdraw(msg.sender, _pid);
751     }
752 
753     // Deposit LP tokens to Farm for ERC20 allocation. 
754     // can come from manager or user address directly; in either case, tx.origin is the user.
755     // In the case the call is coming from the mananger, msg.sender is the manager.
756     function deposit(uint256 _pid, uint256 _amount) external {
757         require(manager.getPaused()==false, "deposit: farm paused");
758         address userAddress = ((msg.sender == address(manager)) ? tx.origin : msg.sender);
759         PoolInfo storage pool = poolInfo[_pid];
760         UserInfo storage user = userInfo[_pid][userAddress];
761         require(user.withdrawTime == 0, "deposit: user is unstaking");
762         updatePool(_pid);
763         if (user.amount > 0) {
764             uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
765             erc20Transfer(userAddress, pendingAmount);
766         }
767         pool.stakingToken.safeTransferFrom(address(msg.sender), address(this), _amount);
768         pool.supply = pool.supply.add(_amount);
769         user.amount = user.amount.add(_amount);
770         user.rewardDebt = user.amount.mul(pool.accERC20PerShare).div(1e36);
771         emit Deposit(userAddress, _pid, _amount);
772     }
773 
774     // Distribute rewards and start unstake period.
775     function withdraw(uint256 _pid) external {
776         require(manager.getPaused()==false, "withdraw: farm paused");
777         PoolInfo storage pool = poolInfo[_pid];
778         UserInfo storage user = userInfo[_pid][msg.sender];
779         require(user.amount > 0, "withdraw: amount must be greater than 0");
780         require(user.withdrawTime == 0, "withdraw: user is unstaking");
781         updatePool(_pid);
782 
783         // transfer any rewards due
784         uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
785         erc20Transfer(msg.sender, pendingAmount);
786         pool.supply = pool.supply.sub(user.amount);
787         user.rewardDebt = 0;
788         user.withdrawTime = block.timestamp;
789         emit Withdraw(msg.sender, _pid);
790     }
791 
792     // unstake LP tokens from Farm. if done within "unstakeEpochs" days, apply burn.
793     function unstake(uint256 _pid) external {
794         require(manager.getPaused()==false, "unstake: farm paused");
795         PoolInfo storage pool = poolInfo[_pid];
796         UserInfo storage user = userInfo[_pid][msg.sender];
797         require(user.withdrawTime > 0, "unstake: user is not unstaking");
798         updatePool(_pid);
799         //apply burn fee if unstaking before unstake epochs.
800         uint256 unstakeEpochs = manager.getUnstakeEpochs();
801         uint256 burnRate = manager.getBurnRate();
802         address redistributor = manager.getRedistributor();
803         if((user.withdrawTime.add(SECS_EPOCH.mul(unstakeEpochs)) > block.timestamp) && burnRate > 0){
804             uint penalty = user.amount.div(1000).mul(burnRate);
805             user.amount = user.amount.sub(penalty);
806             // if the staking address is an LP, send 50% of penalty to redistributor, and 50% to lp lock address.
807             if(pool.isLP){
808                 pool.stakingToken.safeTransfer(redistributor, penalty.div(2));
809                 pool.stakingToken.safeTransfer(manager.getLpLock(), penalty.div(2));
810             }else {
811                 // for normal ERC20 tokens, 50% of the penalty is sent to the redistributor address, 50% is burned from the supply.
812                 pool.stakingToken.safeTransfer(redistributor, penalty.div(2));
813                 IBurnable(address(pool.stakingToken)).burn(penalty.div(2));
814             }
815         }
816         uint userAmount = user.amount;
817         // allows user to stake again.
818         user.withdrawTime = 0;
819         user.amount = 0;
820         pool.stakingToken.safeTransfer(address(msg.sender), userAmount);
821         emit Unstake(msg.sender, _pid);
822     }
823 
824     // claim LP tokens from Farm.
825     function claim(uint256 _pid) external {
826         require(manager.getPaused() == false, "claim: farm paused");
827         PoolInfo storage pool = poolInfo[_pid];
828         UserInfo storage user = userInfo[_pid][msg.sender];
829         require(user.amount > 0, "claim: amount is equal to 0");
830         require(user.withdrawTime == 0, "claim: user is unstaking");
831         updatePool(_pid);
832         uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
833         erc20Transfer(msg.sender, pendingAmount);
834         user.rewardDebt = user.amount.mul(pool.accERC20PerShare).div(1e36);
835         user.lastClaimTime = block.timestamp;
836         emit Claim(msg.sender, _pid);
837     }
838 
839     // Transfer ERC20 and update the required ERC20 to payout all rewards
840     function erc20Transfer(address _to, uint256 _amount) internal {
841         erc20.transfer(_to, _amount);
842         paidOut += _amount;
843     }
844 
845     // emergency withdraw rewards. only owner. EMERGENCY ONLY.
846     function emergencyWithdrawRewards() external {
847         require(msg.sender == address(manager), "emergencyWithdrawRewards: sender is not manager");
848         uint balance = erc20.balanceOf(address(this));
849         erc20.safeTransfer(address(tx.origin), balance);
850     }
851 }