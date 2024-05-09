1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
4 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `to`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address to, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `from` to `to` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address from,
67         address to,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
88 
89 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
90 
91 pragma solidity ^0.8.1;
92 
93 /**
94  * @dev Collection of functions related to the address type
95  */
96 library Address {
97     /**
98      * @dev Returns true if `account` is a contract.
99      *
100      * [IMPORTANT]
101      * ====
102      * It is unsafe to assume that an address for which this function returns
103      * false is an externally-owned account (EOA) and not a contract.
104      *
105      * Among others, `isContract` will return false for the following
106      * types of addresses:
107      *
108      *  - an externally-owned account
109      *  - a contract in construction
110      *  - an address where a contract will be created
111      *  - an address where a contract lived, but was destroyed
112      * ====
113      *
114      * [IMPORTANT]
115      * ====
116      * You shouldn't rely on `isContract` to protect against flash loan attacks!
117      *
118      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
119      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
120      * constructor.
121      * ====
122      */
123     function isContract(address account) internal view returns (bool) {
124         // This method relies on extcodesize/address.code.length, which returns 0
125         // for contracts in construction, since the code is only stored at the end
126         // of the constructor execution.
127 
128         return account.code.length > 0;
129     }
130 
131     /**
132      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
133      * `recipient`, forwarding all available gas and reverting on errors.
134      *
135      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
136      * of certain opcodes, possibly making contracts go over the 2300 gas limit
137      * imposed by `transfer`, making them unable to receive funds via
138      * `transfer`. {sendValue} removes this limitation.
139      *
140      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
141      *
142      * IMPORTANT: because control is transferred to `recipient`, care must be
143      * taken to not create reentrancy vulnerabilities. Consider using
144      * {ReentrancyGuard} or the
145      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
146      */
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         (bool success, ) = recipient.call{value: amount}("");
151         require(success, "Address: unable to send value, recipient may have reverted");
152     }
153 
154     /**
155      * @dev Performs a Solidity function call using a low level `call`. A
156      * plain `call` is an unsafe replacement for a function call: use this
157      * function instead.
158      *
159      * If `target` reverts with a revert reason, it is bubbled up by this
160      * function (like regular Solidity function calls).
161      *
162      * Returns the raw returned data. To convert to the expected return value,
163      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
164      *
165      * Requirements:
166      *
167      * - `target` must be a contract.
168      * - calling `target` with `data` must not revert.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionCall(target, data, "Address: low-level call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
178      * `errorMessage` as a fallback revert reason when `target` reverts.
179      *
180      * _Available since v3.1._
181      */
182     function functionCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, 0, errorMessage);
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
192      * but also transferring `value` wei to `target`.
193      *
194      * Requirements:
195      *
196      * - the calling contract must have an ETH balance of at least `value`.
197      * - the called Solidity function must be `payable`.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value
205     ) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
211      * with `errorMessage` as a fallback revert reason when `target` reverts.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(address(this).balance >= value, "Address: insufficient balance for call");
222         require(isContract(target), "Address: call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.call{value: value}(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but performing a static call.
231      *
232      * _Available since v3.3._
233      */
234     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
235         return functionStaticCall(target, data, "Address: low-level static call failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
240      * but performing a static call.
241      *
242      * _Available since v3.3._
243      */
244     function functionStaticCall(
245         address target,
246         bytes memory data,
247         string memory errorMessage
248     ) internal view returns (bytes memory) {
249         require(isContract(target), "Address: static call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.staticcall(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a delegate call.
258      *
259      * _Available since v3.4._
260      */
261     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a delegate call.
268      *
269      * _Available since v3.4._
270      */
271     function functionDelegateCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         require(isContract(target), "Address: delegate call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.delegatecall(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
284      * revert reason using the provided one.
285      *
286      * _Available since v4.3._
287      */
288     function verifyCallResult(
289         bool success,
290         bytes memory returndata,
291         string memory errorMessage
292     ) internal pure returns (bytes memory) {
293         if (success) {
294             return returndata;
295         } else {
296             // Look for revert reason and bubble it up if present
297             if (returndata.length > 0) {
298                 // The easiest way to bubble the revert reason is using memory via assembly
299 
300                 assembly {
301                     let returndata_size := mload(returndata)
302                     revert(add(32, returndata), returndata_size)
303                 }
304             } else {
305                 revert(errorMessage);
306             }
307         }
308     }
309 }
310 
311 
312 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.5.0
313 
314 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
315 
316 pragma solidity ^0.8.0;
317 
318 
319 /**
320  * @title SafeERC20
321  * @dev Wrappers around ERC20 operations that throw on failure (when the token
322  * contract returns false). Tokens that return no value (and instead revert or
323  * throw on failure) are also supported, non-reverting calls are assumed to be
324  * successful.
325  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
326  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
327  */
328 library SafeERC20 {
329     using Address for address;
330 
331     function safeTransfer(
332         IERC20 token,
333         address to,
334         uint256 value
335     ) internal {
336         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
337     }
338 
339     function safeTransferFrom(
340         IERC20 token,
341         address from,
342         address to,
343         uint256 value
344     ) internal {
345         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
346     }
347 
348     /**
349      * @dev Deprecated. This function has issues similar to the ones found in
350      * {IERC20-approve}, and its usage is discouraged.
351      *
352      * Whenever possible, use {safeIncreaseAllowance} and
353      * {safeDecreaseAllowance} instead.
354      */
355     function safeApprove(
356         IERC20 token,
357         address spender,
358         uint256 value
359     ) internal {
360         // safeApprove should only be called when setting an initial allowance,
361         // or when resetting it to zero. To increase and decrease it, use
362         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
363         require(
364             (value == 0) || (token.allowance(address(this), spender) == 0),
365             "SafeERC20: approve from non-zero to non-zero allowance"
366         );
367         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
368     }
369 
370     function safeIncreaseAllowance(
371         IERC20 token,
372         address spender,
373         uint256 value
374     ) internal {
375         uint256 newAllowance = token.allowance(address(this), spender) + value;
376         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
377     }
378 
379     function safeDecreaseAllowance(
380         IERC20 token,
381         address spender,
382         uint256 value
383     ) internal {
384         unchecked {
385             uint256 oldAllowance = token.allowance(address(this), spender);
386             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
387             uint256 newAllowance = oldAllowance - value;
388             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
389         }
390     }
391 
392     /**
393      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
394      * on the return value: the return value is optional (but if data is returned, it must not be false).
395      * @param token The token targeted by the call.
396      * @param data The call data (encoded using abi.encode or one of its variants).
397      */
398     function _callOptionalReturn(IERC20 token, bytes memory data) private {
399         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
400         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
401         // the target address contains contract code and also asserts for success in the low-level call.
402 
403         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
404         if (returndata.length > 0) {
405             // Return data is optional
406             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
407         }
408     }
409 }
410 
411 
412 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.5.0
413 
414 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 // CAUTION
419 // This version of SafeMath should only be used with Solidity 0.8 or later,
420 // because it relies on the compiler's built in overflow checks.
421 
422 /**
423  * @dev Wrappers over Solidity's arithmetic operations.
424  *
425  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
426  * now has built in overflow checking.
427  */
428 library SafeMath {
429     /**
430      * @dev Returns the addition of two unsigned integers, with an overflow flag.
431      *
432      * _Available since v3.4._
433      */
434     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
435         unchecked {
436             uint256 c = a + b;
437             if (c < a) return (false, 0);
438             return (true, c);
439         }
440     }
441 
442     /**
443      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
444      *
445      * _Available since v3.4._
446      */
447     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
448         unchecked {
449             if (b > a) return (false, 0);
450             return (true, a - b);
451         }
452     }
453 
454     /**
455      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
456      *
457      * _Available since v3.4._
458      */
459     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
460         unchecked {
461             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
462             // benefit is lost if 'b' is also tested.
463             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
464             if (a == 0) return (true, 0);
465             uint256 c = a * b;
466             if (c / a != b) return (false, 0);
467             return (true, c);
468         }
469     }
470 
471     /**
472      * @dev Returns the division of two unsigned integers, with a division by zero flag.
473      *
474      * _Available since v3.4._
475      */
476     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
477         unchecked {
478             if (b == 0) return (false, 0);
479             return (true, a / b);
480         }
481     }
482 
483     /**
484      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
485      *
486      * _Available since v3.4._
487      */
488     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
489         unchecked {
490             if (b == 0) return (false, 0);
491             return (true, a % b);
492         }
493     }
494 
495     /**
496      * @dev Returns the addition of two unsigned integers, reverting on
497      * overflow.
498      *
499      * Counterpart to Solidity's `+` operator.
500      *
501      * Requirements:
502      *
503      * - Addition cannot overflow.
504      */
505     function add(uint256 a, uint256 b) internal pure returns (uint256) {
506         return a + b;
507     }
508 
509     /**
510      * @dev Returns the subtraction of two unsigned integers, reverting on
511      * overflow (when the result is negative).
512      *
513      * Counterpart to Solidity's `-` operator.
514      *
515      * Requirements:
516      *
517      * - Subtraction cannot overflow.
518      */
519     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
520         return a - b;
521     }
522 
523     /**
524      * @dev Returns the multiplication of two unsigned integers, reverting on
525      * overflow.
526      *
527      * Counterpart to Solidity's `*` operator.
528      *
529      * Requirements:
530      *
531      * - Multiplication cannot overflow.
532      */
533     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
534         return a * b;
535     }
536 
537     /**
538      * @dev Returns the integer division of two unsigned integers, reverting on
539      * division by zero. The result is rounded towards zero.
540      *
541      * Counterpart to Solidity's `/` operator.
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function div(uint256 a, uint256 b) internal pure returns (uint256) {
548         return a / b;
549     }
550 
551     /**
552      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
553      * reverting when dividing by zero.
554      *
555      * Counterpart to Solidity's `%` operator. This function uses a `revert`
556      * opcode (which leaves remaining gas untouched) while Solidity uses an
557      * invalid opcode to revert (consuming all remaining gas).
558      *
559      * Requirements:
560      *
561      * - The divisor cannot be zero.
562      */
563     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
564         return a % b;
565     }
566 
567     /**
568      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
569      * overflow (when the result is negative).
570      *
571      * CAUTION: This function is deprecated because it requires allocating memory for the error
572      * message unnecessarily. For custom revert reasons use {trySub}.
573      *
574      * Counterpart to Solidity's `-` operator.
575      *
576      * Requirements:
577      *
578      * - Subtraction cannot overflow.
579      */
580     function sub(
581         uint256 a,
582         uint256 b,
583         string memory errorMessage
584     ) internal pure returns (uint256) {
585         unchecked {
586             require(b <= a, errorMessage);
587             return a - b;
588         }
589     }
590 
591     /**
592      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
593      * division by zero. The result is rounded towards zero.
594      *
595      * Counterpart to Solidity's `/` operator. Note: this function uses a
596      * `revert` opcode (which leaves remaining gas untouched) while Solidity
597      * uses an invalid opcode to revert (consuming all remaining gas).
598      *
599      * Requirements:
600      *
601      * - The divisor cannot be zero.
602      */
603     function div(
604         uint256 a,
605         uint256 b,
606         string memory errorMessage
607     ) internal pure returns (uint256) {
608         unchecked {
609             require(b > 0, errorMessage);
610             return a / b;
611         }
612     }
613 
614     /**
615      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
616      * reverting with custom message when dividing by zero.
617      *
618      * CAUTION: This function is deprecated because it requires allocating memory for the error
619      * message unnecessarily. For custom revert reasons use {tryMod}.
620      *
621      * Counterpart to Solidity's `%` operator. This function uses a `revert`
622      * opcode (which leaves remaining gas untouched) while Solidity uses an
623      * invalid opcode to revert (consuming all remaining gas).
624      *
625      * Requirements:
626      *
627      * - The divisor cannot be zero.
628      */
629     function mod(
630         uint256 a,
631         uint256 b,
632         string memory errorMessage
633     ) internal pure returns (uint256) {
634         unchecked {
635             require(b > 0, errorMessage);
636             return a % b;
637         }
638     }
639 }
640 
641 
642 // File contracts/rewardPools/GenesisRewardPool.sol
643 
644 pragma solidity 0.8.1;
645 // Note that this pool has no minter key of vApe (rewards).
646 // Instead, the governance will call vApe distributeReward method and send reward to this pool at the beginning.
647 contract ApeGenesisRewardPool {
648     using SafeMath for uint256;
649     using SafeERC20 for IERC20;
650 
651     // governance
652     address public operator;
653     address public devFund;
654 
655     // Info of each user.
656     struct UserInfo {
657         uint256 amount; // How many tokens the user has provided.
658         uint256 rewardDebt; // Rewards already claimed by the user.
659     }
660 
661     // Info of each pool.
662     struct PoolInfo {
663         IERC20 token; // Address of LP token contract.
664         uint256 allocPoint; // How many allocation points assigned to this pool. Ape to distribute.
665         uint256 lastRewardTime; // Last time that Ape distribution occurs.
666         uint256 accApePerShare; // Accumulated Ape per share, times 1e18. See below.
667         bool isStarted; // if lastRewardBlock has passed
668     }
669 
670     IERC20 public ape;
671 
672     // Info of each pool.
673     PoolInfo[] public poolInfo;
674 
675     // Info of each user that stakes LP tokens.
676     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
677 
678     // Total allocation points. Must be the sum of all allocation points in all pools.
679     uint256 public totalAllocPoint = 0;
680 
681     // The time when Ape mining starts.
682     uint256 public poolStartTime;
683 
684     // The time when Ape mining ends.
685     uint256 public poolEndTime;
686 
687     // Token distribution
688     uint256 public apePerSecond = 0.0424382716 ether; // 11000 Ape / (3days * 24hr * 60min * 60s)
689     uint256 public runningTime = 3 days; // 3 days
690     uint256 public constant TOTAL_REWARDS = 11000 ether;
691 
692     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
693     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
694     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
695     event RewardPaid(address indexed user, uint256 amount);
696 
697     constructor(
698         address _ape,
699         address _devFund,
700         uint256 _poolStartTime
701     ) {
702         require(block.timestamp < _poolStartTime, "late");
703         if (_ape != address(0)) ape = IERC20(_ape);
704         poolStartTime = _poolStartTime;
705         poolEndTime = poolStartTime + runningTime;
706         operator = msg.sender;
707         devFund = _devFund;
708     }
709 
710     modifier onlyOperator() {
711         require(operator == msg.sender, "ApeGenesisPool: caller is not the operator");
712         _;
713     }
714 
715     function checkPoolDuplicate(IERC20 _token) internal view {
716         uint256 length = poolInfo.length;
717         for (uint256 pid = 0; pid < length; ++pid) {
718             require(poolInfo[pid].token != _token, "ApeGenesisPool: existing pool?");
719         }
720     }
721 
722     // Add a new token to the pool. Can only be called by the owner.
723     function add(
724         uint256 _allocPoint,
725         IERC20 _token,
726         bool _withUpdate,
727         uint256 _lastRewardTime
728     ) public onlyOperator {
729         checkPoolDuplicate(_token);
730         if (_withUpdate) {
731             massUpdatePools();
732         }
733         if (block.timestamp < poolStartTime) {
734             // chef is sleeping
735             if (_lastRewardTime == 0) {
736                 _lastRewardTime = poolStartTime;
737             } else {
738                 if (_lastRewardTime < poolStartTime) {
739                     _lastRewardTime = poolStartTime;
740                 }
741             }
742         } else {
743             // chef is cooking
744             if (_lastRewardTime == 0 || _lastRewardTime < block.timestamp) {
745                 _lastRewardTime = block.timestamp;
746             }
747         }
748         bool _isStarted =
749         (_lastRewardTime <= poolStartTime) ||
750         (_lastRewardTime <= block.timestamp);
751         poolInfo.push(PoolInfo({
752             token : _token,
753             allocPoint : _allocPoint,
754             lastRewardTime : _lastRewardTime,
755             accApePerShare : 0,
756             isStarted : _isStarted
757             }));
758         if (_isStarted) {
759             totalAllocPoint = totalAllocPoint.add(_allocPoint);
760         }
761     }
762 
763     // Update the given pool's Ape allocation point. Can only be called by the owner.
764     function set(uint256 _pid, uint256 _allocPoint) public onlyOperator {
765         massUpdatePools();
766         PoolInfo storage pool = poolInfo[_pid];
767         if (pool.isStarted) {
768             totalAllocPoint = totalAllocPoint.sub(pool.allocPoint).add(
769                 _allocPoint
770             );
771         }
772         pool.allocPoint = _allocPoint;
773     }
774 
775     // Return accumulate rewards over the given _from to _to block.
776     function getGeneratedReward(uint256 _fromTime, uint256 _toTime) public view returns (uint256) {
777         if (_fromTime >= _toTime) return 0;
778         if (_toTime >= poolEndTime) {
779             if (_fromTime >= poolEndTime) return 0;
780             if (_fromTime <= poolStartTime) return poolEndTime.sub(poolStartTime).mul(apePerSecond);
781             return poolEndTime.sub(_fromTime).mul(apePerSecond);
782         } else {
783             if (_toTime <= poolStartTime) return 0;
784             if (_fromTime <= poolStartTime) return _toTime.sub(poolStartTime).mul(apePerSecond);
785             return _toTime.sub(_fromTime).mul(apePerSecond);
786         }
787     }
788 
789     // View function to see pending Ape on frontend.
790     function pendingAPE(uint256 _pid, address _user) external view returns (uint256) {
791         PoolInfo storage pool = poolInfo[_pid];
792         UserInfo storage user = userInfo[_pid][_user];
793         uint256 accApePerShare = pool.accApePerShare;
794         uint256 tokenSupply = pool.token.balanceOf(address(this));
795         if (block.timestamp > pool.lastRewardTime && tokenSupply != 0) {
796             uint256 _generatedReward = getGeneratedReward(pool.lastRewardTime, block.timestamp);
797             uint256 _apeReward = _generatedReward.mul(pool.allocPoint).div(totalAllocPoint);
798             accApePerShare = accApePerShare.add(_apeReward.mul(1e18).div(tokenSupply));
799         }
800         return user.amount.mul(accApePerShare).div(1e18).sub(user.rewardDebt);
801     }
802 
803     // Update reward variables for all pools. Be careful of gas spending!
804     function massUpdatePools() public {
805         uint256 length = poolInfo.length;
806         for (uint256 pid = 0; pid < length; ++pid) {
807             updatePool(pid);
808         }
809     }
810 
811     // Update reward variables of the given pool to be up-to-date.
812     function updatePool(uint256 _pid) public {
813         PoolInfo storage pool = poolInfo[_pid];
814         if (block.timestamp <= pool.lastRewardTime) {
815             return;
816         }
817         uint256 tokenSupply = pool.token.balanceOf(address(this));
818         if (tokenSupply == 0) {
819             pool.lastRewardTime = block.timestamp;
820             return;
821         }
822         if (!pool.isStarted) {
823             pool.isStarted = true;
824             totalAllocPoint = totalAllocPoint.add(pool.allocPoint);
825         }
826         if (totalAllocPoint > 0) {
827             uint256 _generatedReward = getGeneratedReward(pool.lastRewardTime, block.timestamp);
828             uint256 _apeReward = _generatedReward.mul(pool.allocPoint).div(totalAllocPoint);
829             pool.accApePerShare = pool.accApePerShare.add(_apeReward.mul(1e18).div(tokenSupply));
830         }
831         pool.lastRewardTime = block.timestamp;
832     }
833 
834     // Deposit tokens.
835     function deposit(uint256 _pid, uint256 _amount) public {
836         address _sender = msg.sender;
837         PoolInfo storage pool = poolInfo[_pid];
838         UserInfo storage user = userInfo[_pid][_sender];
839         updatePool(_pid);
840         if (user.amount > 0) {
841             uint256 _pending = user.amount.mul(pool.accApePerShare).div(1e18).sub(user.rewardDebt);
842             if (_pending > 0) {
843                 safeApeTransfer(_sender, _pending);
844                 emit RewardPaid(_sender, _pending);
845             }
846         }
847         if (_amount > 0) {
848             uint256 depositFee = _amount.mul(25).div(10000); // 0.25% fee
849             pool.token.safeTransferFrom(_sender, devFund, depositFee);
850 
851             uint256 remaining = _amount-depositFee;
852             pool.token.safeTransferFrom(_sender, address(this), remaining);
853             user.amount = user.amount.add(remaining);
854         }
855         user.rewardDebt = user.amount.mul(pool.accApePerShare).div(1e18);
856         emit Deposit(_sender, _pid, _amount);
857     }
858 
859     // Withdraw tokens.
860     function withdraw(uint256 _pid, uint256 _amount) public {
861         address _sender = msg.sender;
862         PoolInfo storage pool = poolInfo[_pid];
863         UserInfo storage user = userInfo[_pid][_sender];
864         require(user.amount >= _amount, "withdraw: not good");
865         updatePool(_pid);
866         uint256 _pending = user.amount.mul(pool.accApePerShare).div(1e18).sub(user.rewardDebt);
867         if (_pending > 0) {
868             safeApeTransfer(_sender, _pending);
869             emit RewardPaid(_sender, _pending);
870         }
871         if (_amount > 0) {
872             user.amount = user.amount.sub(_amount);
873             pool.token.safeTransfer(_sender, _amount);
874         }
875         user.rewardDebt = user.amount.mul(pool.accApePerShare).div(1e18);
876         emit Withdraw(_sender, _pid, _amount);
877     }
878 
879     // Withdraw without caring about rewards. EMERGENCY ONLY.
880     function emergencyWithdraw(uint256 _pid) public {
881         PoolInfo storage pool = poolInfo[_pid];
882         UserInfo storage user = userInfo[_pid][msg.sender];
883         uint256 _amount = user.amount;
884         user.amount = 0;
885         user.rewardDebt = 0;
886         pool.token.safeTransfer(msg.sender, _amount);
887         emit EmergencyWithdraw(msg.sender, _pid, _amount);
888     }
889 
890     // Safe Ape transfer function, just in case if rounding error causes pool to not have enough Apes.
891     function safeApeTransfer(address _to, uint256 _amount) internal {
892         uint256 _apeBalance = ape.balanceOf(address(this));
893         if (_apeBalance > 0) {
894             if (_amount > _apeBalance) {
895                 ape.safeTransfer(_to, _apeBalance);
896             } else {
897                 ape.safeTransfer(_to, _amount);
898             }
899         }
900     }
901 
902     function setOperator(address _operator) external onlyOperator {
903         operator = _operator;
904     }
905 
906     function governanceRecoverUnsupported(IERC20 _token, uint256 amount, address to) external onlyOperator {
907         if (block.timestamp < poolEndTime + 30 days) {
908             // do not allow to drain core token (Ape or lps) if less than 30 days after pool ends
909             require(_token != ape, "ape");
910             uint256 length = poolInfo.length;
911             for (uint256 pid = 0; pid < length; ++pid) {
912                 PoolInfo storage pool = poolInfo[pid];
913                 require(_token != pool.token, "pool.token");
914             }
915         }
916         _token.safeTransfer(to, amount);
917     }
918 }