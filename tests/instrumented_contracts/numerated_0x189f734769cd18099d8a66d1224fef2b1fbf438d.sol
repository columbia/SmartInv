1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
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
79 
80 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
81 
82 
83 
84 pragma solidity >=0.6.0 <0.8.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, with an overflow flag.
102      *
103      * _Available since v3.4._
104      */
105     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
106         uint256 c = a + b;
107         if (c < a) return (false, 0);
108         return (true, c);
109     }
110 
111     /**
112      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
113      *
114      * _Available since v3.4._
115      */
116     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         if (b > a) return (false, 0);
118         return (true, a - b);
119     }
120 
121     /**
122      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
123      *
124      * _Available since v3.4._
125      */
126     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
128         // benefit is lost if 'b' is also tested.
129         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
130         if (a == 0) return (true, 0);
131         uint256 c = a * b;
132         if (c / a != b) return (false, 0);
133         return (true, c);
134     }
135 
136     /**
137      * @dev Returns the division of two unsigned integers, with a division by zero flag.
138      *
139      * _Available since v3.4._
140      */
141     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         if (b == 0) return (false, 0);
143         return (true, a / b);
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         if (b == 0) return (false, 0);
153         return (true, a % b);
154     }
155 
156     /**
157      * @dev Returns the addition of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `+` operator.
161      *
162      * Requirements:
163      *
164      * - Addition cannot overflow.
165      */
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         require(c >= a, "SafeMath: addition overflow");
169         return c;
170     }
171 
172     /**
173      * @dev Returns the subtraction of two unsigned integers, reverting on
174      * overflow (when the result is negative).
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183         require(b <= a, "SafeMath: subtraction overflow");
184         return a - b;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      *
195      * - Multiplication cannot overflow.
196      */
197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198         if (a == 0) return 0;
199         uint256 c = a * b;
200         require(c / a == b, "SafeMath: multiplication overflow");
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers, reverting on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         require(b > 0, "SafeMath: division by zero");
218         return a / b;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * reverting when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         require(b > 0, "SafeMath: modulo by zero");
235         return a % b;
236     }
237 
238     /**
239      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
240      * overflow (when the result is negative).
241      *
242      * CAUTION: This function is deprecated because it requires allocating memory for the error
243      * message unnecessarily. For custom revert reasons use {trySub}.
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      *
249      * - Subtraction cannot overflow.
250      */
251     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b <= a, errorMessage);
253         return a - b;
254     }
255 
256     /**
257      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
258      * division by zero. The result is rounded towards zero.
259      *
260      * CAUTION: This function is deprecated because it requires allocating memory for the error
261      * message unnecessarily. For custom revert reasons use {tryDiv}.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b > 0, errorMessage);
273         return a / b;
274     }
275 
276     /**
277      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
278      * reverting with custom message when dividing by zero.
279      *
280      * CAUTION: This function is deprecated because it requires allocating memory for the error
281      * message unnecessarily. For custom revert reasons use {tryMod}.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b > 0, errorMessage);
293         return a % b;
294     }
295 }
296 
297 
298 // File @openzeppelin/contracts/utils/Address.sol@v3.4.2
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
490 
491 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.2
492 
493 
494 
495 pragma solidity >=0.6.0 <0.8.0;
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
567 
568 // File contracts/distribution/SGldmRewardPool.sol
569 
570 
571 
572 pragma solidity 0.6.12;
573 
574 
575 
576 // Note that this pool has no minter key of tSHARE (rewards).
577 // Instead, the governance will call tSHARE distributeReward method and send reward to this pool at the beginning.
578 contract SGldmRewardPool {
579     using SafeMath for uint256;
580     using SafeERC20 for IERC20;
581 
582     // governance
583     address public operator;
584 
585     // Info of each user.
586     struct UserInfo {
587         uint256 amount; // How many LP tokens the user has provided.
588         uint256 rewardDebt; // Reward debt. See explanation below.
589     }
590 
591     // Info of each pool.
592     struct PoolInfo {
593         IERC20 token; // Address of LP token contract.
594         uint256 allocPoint; // How many allocation points assigned to this pool. tSHAREs to distribute per block.
595         uint256 lastRewardTime; // Last time that tSHAREs distribution occurs.
596         uint256 accSGldmPerShare; // Accumulated tSHAREs per share, times 1e18. See below.
597         bool isStarted; // if lastRewardTime has passed
598     }
599 
600     IERC20 public sgldm;
601 
602     // Info of each pool.
603     PoolInfo[] public poolInfo;
604 
605     // Info of each user that stakes LP tokens.
606     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
607 
608     // Total allocation points. Must be the sum of all allocation points in all pools.
609     uint256 public totalAllocPoint = 0;
610 
611     // The time when tSHARE mining starts.
612     uint256 public poolStartTime;
613 
614     // The time when tSHARE mining ends.
615     uint256 public poolEndTime;
616 
617     uint256 public sGLDMPerSecond = 0.000943 ether; // 59500 sgldm / (370 days * 24h * 60min * 60s)
618     uint256 public runningTime = 730 days; // 370 days
619     uint256 public constant TOTAL_REWARDS = 59500 ether;
620 
621     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
622     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
623     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
624     event RewardPaid(address indexed user, uint256 amount);
625 
626     constructor(
627         address _sgldm,
628         uint256 _poolStartTime
629     ) public {
630         require(block.timestamp < _poolStartTime, "late");
631         if (_sgldm != address(0)) sgldm = IERC20(_sgldm);
632         poolStartTime = _poolStartTime;
633         poolEndTime = poolStartTime + runningTime;
634         operator = msg.sender;
635     }
636 
637     modifier onlyOperator() {
638         require(operator == msg.sender, "SGldmRewardPool: caller is not the operator");
639         _;
640     }
641 
642     function checkPoolDuplicate(IERC20 _token) internal view {
643         uint256 length = poolInfo.length;
644         for (uint256 pid = 0; pid < length; ++pid) {
645             require(poolInfo[pid].token != _token, "SGldmRewardPool: existing pool?");
646         }
647     }
648 
649     // Add a new lp to the pool. Can only be called by the owner.
650     function add(
651         uint256 _allocPoint,
652         IERC20 _token,
653         bool _withUpdate,
654         uint256 _lastRewardTime
655     ) public onlyOperator {
656         checkPoolDuplicate(_token);
657         if (_withUpdate) {
658             massUpdatePools();
659         }
660         if (block.timestamp < poolStartTime) {
661             // chef is sleeping
662             if (_lastRewardTime == 0) {
663                 _lastRewardTime = poolStartTime;
664             } else {
665                 if (_lastRewardTime < poolStartTime) {
666                     _lastRewardTime = poolStartTime;
667                 }
668             }
669         } else {
670             // chef is cooking
671             if (_lastRewardTime == 0 || _lastRewardTime < block.timestamp) {
672                 _lastRewardTime = block.timestamp;
673             }
674         }
675         bool _isStarted =
676         (_lastRewardTime <= poolStartTime) ||
677         (_lastRewardTime <= block.timestamp);
678         poolInfo.push(PoolInfo({
679             token : _token,
680             allocPoint : _allocPoint,
681             lastRewardTime : _lastRewardTime,
682             accSGldmPerShare : 0,
683             isStarted : _isStarted
684             }));
685         if (_isStarted) {
686             totalAllocPoint = totalAllocPoint.add(_allocPoint);
687         }
688     }
689 
690     // Update the given pool's tSHARE allocation point. Can only be called by the owner.
691     function set(uint256 _pid, uint256 _allocPoint) public onlyOperator {
692         massUpdatePools();
693         PoolInfo storage pool = poolInfo[_pid];
694         if (pool.isStarted) {
695             totalAllocPoint = totalAllocPoint.sub(pool.allocPoint).add(
696                 _allocPoint
697             );
698         }
699         pool.allocPoint = _allocPoint;
700     }
701 
702     // Return accumulate rewards over the given _from to _to block.
703     function getGeneratedReward(uint256 _fromTime, uint256 _toTime) public view returns (uint256) {
704         if (_fromTime >= _toTime) return 0;
705         if (_toTime >= poolEndTime) {
706             if (_fromTime >= poolEndTime) return 0;
707             if (_fromTime <= poolStartTime) return poolEndTime.sub(poolStartTime).mul(sGLDMPerSecond);
708             return poolEndTime.sub(_fromTime).mul(sGLDMPerSecond);
709         } else {
710             if (_toTime <= poolStartTime) return 0;
711             if (_fromTime <= poolStartTime) return _toTime.sub(poolStartTime).mul(sGLDMPerSecond);
712             return _toTime.sub(_fromTime).mul(sGLDMPerSecond);
713         }
714     }
715 
716     // View function to see pending tSHAREs on frontend.
717     function pendingShare(uint256 _pid, address _user) external view returns (uint256) {
718         PoolInfo storage pool = poolInfo[_pid];
719         UserInfo storage user = userInfo[_pid][_user];
720         uint256 accSGldmPerShare = pool.accSGldmPerShare;
721         uint256 tokenSupply = pool.token.balanceOf(address(this));
722         if (block.timestamp > pool.lastRewardTime && tokenSupply != 0) {
723             uint256 _generatedReward = getGeneratedReward(pool.lastRewardTime, block.timestamp);
724             uint256 _sgldmReward = _generatedReward.mul(pool.allocPoint).div(totalAllocPoint);
725             accSGldmPerShare = accSGldmPerShare.add(_sgldmReward.mul(1e18).div(tokenSupply));
726         }
727         return user.amount.mul(accSGldmPerShare).div(1e18).sub(user.rewardDebt);
728     }
729 
730     // Update reward variables for all pools. Be careful of gas spending!
731     function massUpdatePools() public {
732         uint256 length = poolInfo.length;
733         for (uint256 pid = 0; pid < length; ++pid) {
734             updatePool(pid);
735         }
736     }
737 
738     // Update reward variables of the given pool to be up-to-date.
739     function updatePool(uint256 _pid) public {
740         PoolInfo storage pool = poolInfo[_pid];
741         if (block.timestamp <= pool.lastRewardTime) {
742             return;
743         }
744         uint256 tokenSupply = pool.token.balanceOf(address(this));
745         if (tokenSupply == 0) {
746             pool.lastRewardTime = block.timestamp;
747             return;
748         }
749         if (!pool.isStarted) {
750             pool.isStarted = true;
751             totalAllocPoint = totalAllocPoint.add(pool.allocPoint);
752         }
753         if (totalAllocPoint > 0) {
754             uint256 _generatedReward = getGeneratedReward(pool.lastRewardTime, block.timestamp);
755             uint256 _sgldmReward = _generatedReward.mul(pool.allocPoint).div(totalAllocPoint);
756             pool.accSGldmPerShare = pool.accSGldmPerShare.add(_sgldmReward.mul(1e18).div(tokenSupply));
757         }
758         pool.lastRewardTime = block.timestamp;
759     }
760 
761     // Deposit LP tokens.
762     function deposit(uint256 _pid, uint256 _amount) public {
763         address _sender = msg.sender;
764         PoolInfo storage pool = poolInfo[_pid];
765         UserInfo storage user = userInfo[_pid][_sender];
766         updatePool(_pid);
767         if (user.amount > 0) {
768             uint256 _pending = user.amount.mul(pool.accSGldmPerShare).div(1e18).sub(user.rewardDebt);
769             if (_pending > 0) {
770                 safeSGldmTransfer(_sender, _pending);
771                 emit RewardPaid(_sender, _pending);
772             }
773         }
774         if (_amount > 0) {
775             pool.token.safeTransferFrom(_sender, address(this), _amount);
776             user.amount = user.amount.add(_amount);
777         }
778         user.rewardDebt = user.amount.mul(pool.accSGldmPerShare).div(1e18);
779         emit Deposit(_sender, _pid, _amount);
780     }
781 
782     // Withdraw LP tokens.
783     function withdraw(uint256 _pid, uint256 _amount) public {
784         address _sender = msg.sender;
785         PoolInfo storage pool = poolInfo[_pid];
786         UserInfo storage user = userInfo[_pid][_sender];
787         require(user.amount >= _amount, "withdraw: not good");
788         updatePool(_pid);
789         uint256 _pending = user.amount.mul(pool.accSGldmPerShare).div(1e18).sub(user.rewardDebt);
790         if (_pending > 0) {
791             safeSGldmTransfer(_sender, _pending);
792             emit RewardPaid(_sender, _pending);
793         }
794         if (_amount > 0) {
795             user.amount = user.amount.sub(_amount);
796             pool.token.safeTransfer(_sender, _amount);
797         }
798         user.rewardDebt = user.amount.mul(pool.accSGldmPerShare).div(1e18);
799         emit Withdraw(_sender, _pid, _amount);
800     }
801 
802     // Withdraw without caring about rewards. EMERGENCY ONLY.
803     function emergencyWithdraw(uint256 _pid) public {
804         PoolInfo storage pool = poolInfo[_pid];
805         UserInfo storage user = userInfo[_pid][msg.sender];
806         uint256 _amount = user.amount;
807         user.amount = 0;
808         user.rewardDebt = 0;
809         pool.token.safeTransfer(msg.sender, _amount);
810         emit EmergencyWithdraw(msg.sender, _pid, _amount);
811     }
812 
813     // Safe sgldm transfer function, just in case if rounding error causes pool to not have enough tSHAREs.
814     function safeSGldmTransfer(address _to, uint256 _amount) internal {
815         uint256 _sgldmBal = sgldm.balanceOf(address(this));
816         if (_sgldmBal > 0) {
817             if (_amount > _sgldmBal) {
818                 sgldm.safeTransfer(_to, _sgldmBal);
819             } else {
820                 sgldm.safeTransfer(_to, _amount);
821             }
822         }
823     }
824 
825     function setOperator(address _operator) external onlyOperator {
826         operator = _operator;
827     }
828 
829     function governanceRecoverUnsupported(IERC20 _token, uint256 amount, address to) external onlyOperator {
830         if (block.timestamp < poolEndTime + 90 days) {
831             // do not allow to drain core token (tSHARE or lps) if less than 90 days after pool ends
832             require(_token != sgldm, "sgldm");
833             uint256 length = poolInfo.length;
834             for (uint256 pid = 0; pid < length; ++pid) {
835                 PoolInfo storage pool = poolInfo[pid];
836                 require(_token != pool.token, "pool.token");
837             }
838         }
839         _token.safeTransfer(to, amount);
840     }
841 }