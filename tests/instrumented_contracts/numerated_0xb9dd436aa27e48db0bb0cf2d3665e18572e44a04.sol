1 // SPDX-License-Identifier: MIT
2 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
3 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
4 
5 pragma solidity ^0.8.0;
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
22      * @dev Moves `amount` tokens from the caller's account to `to`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address to, uint256 amount) external returns (bool);
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
56      * @dev Moves `amount` tokens from `from` to `to` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address from,
66         address to,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 
86 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
87 
88 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
89 
90 pragma solidity ^0.8.1;
91 
92 /**
93  * @dev Collection of functions related to the address type
94  */
95 library Address {
96     /**
97      * @dev Returns true if `account` is a contract.
98      *
99      * [IMPORTANT]
100      * ====
101      * It is unsafe to assume that an address for which this function returns
102      * false is an externally-owned account (EOA) and not a contract.
103      *
104      * Among others, `isContract` will return false for the following
105      * types of addresses:
106      *
107      *  - an externally-owned account
108      *  - a contract in construction
109      *  - an address where a contract will be created
110      *  - an address where a contract lived, but was destroyed
111      * ====
112      *
113      * [IMPORTANT]
114      * ====
115      * You shouldn't rely on `isContract` to protect against flash loan attacks!
116      *
117      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
118      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
119      * constructor.
120      * ====
121      */
122     function isContract(address account) internal view returns (bool) {
123         // This method relies on extcodesize/address.code.length, which returns 0
124         // for contracts in construction, since the code is only stored at the end
125         // of the constructor execution.
126 
127         return account.code.length > 0;
128     }
129 
130     /**
131      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
132      * `recipient`, forwarding all available gas and reverting on errors.
133      *
134      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
135      * of certain opcodes, possibly making contracts go over the 2300 gas limit
136      * imposed by `transfer`, making them unable to receive funds via
137      * `transfer`. {sendValue} removes this limitation.
138      *
139      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
140      *
141      * IMPORTANT: because control is transferred to `recipient`, care must be
142      * taken to not create reentrancy vulnerabilities. Consider using
143      * {ReentrancyGuard} or the
144      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
145      */
146     function sendValue(address payable recipient, uint256 amount) internal {
147         require(address(this).balance >= amount, "Address: insufficient balance");
148 
149         (bool success, ) = recipient.call{value: amount}("");
150         require(success, "Address: unable to send value, recipient may have reverted");
151     }
152 
153     /**
154      * @dev Performs a Solidity function call using a low level `call`. A
155      * plain `call` is an unsafe replacement for a function call: use this
156      * function instead.
157      *
158      * If `target` reverts with a revert reason, it is bubbled up by this
159      * function (like regular Solidity function calls).
160      *
161      * Returns the raw returned data. To convert to the expected return value,
162      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
163      *
164      * Requirements:
165      *
166      * - `target` must be a contract.
167      * - calling `target` with `data` must not revert.
168      *
169      * _Available since v3.1._
170      */
171     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionCall(target, data, "Address: low-level call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
177      * `errorMessage` as a fallback revert reason when `target` reverts.
178      *
179      * _Available since v3.1._
180      */
181     function functionCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, 0, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but also transferring `value` wei to `target`.
192      *
193      * Requirements:
194      *
195      * - the calling contract must have an ETH balance of at least `value`.
196      * - the called Solidity function must be `payable`.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value
204     ) internal returns (bytes memory) {
205         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
210      * with `errorMessage` as a fallback revert reason when `target` reverts.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         require(address(this).balance >= value, "Address: insufficient balance for call");
221         require(isContract(target), "Address: call to non-contract");
222 
223         (bool success, bytes memory returndata) = target.call{value: value}(data);
224         return verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
234         return functionStaticCall(target, data, "Address: low-level static call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal view returns (bytes memory) {
248         require(isContract(target), "Address: static call to non-contract");
249 
250         (bool success, bytes memory returndata) = target.staticcall(data);
251         return verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but performing a delegate call.
257      *
258      * _Available since v3.4._
259      */
260     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
261         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
266      * but performing a delegate call.
267      *
268      * _Available since v3.4._
269      */
270     function functionDelegateCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         require(isContract(target), "Address: delegate call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.delegatecall(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
283      * revert reason using the provided one.
284      *
285      * _Available since v4.3._
286      */
287     function verifyCallResult(
288         bool success,
289         bytes memory returndata,
290         string memory errorMessage
291     ) internal pure returns (bytes memory) {
292         if (success) {
293             return returndata;
294         } else {
295             // Look for revert reason and bubble it up if present
296             if (returndata.length > 0) {
297                 // The easiest way to bubble the revert reason is using memory via assembly
298 
299                 assembly {
300                     let returndata_size := mload(returndata)
301                     revert(add(32, returndata), returndata_size)
302                 }
303             } else {
304                 revert(errorMessage);
305             }
306         }
307     }
308 }
309 
310 
311 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.5.0
312 
313 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 
318 /**
319  * @title SafeERC20
320  * @dev Wrappers around ERC20 operations that throw on failure (when the token
321  * contract returns false). Tokens that return no value (and instead revert or
322  * throw on failure) are also supported, non-reverting calls are assumed to be
323  * successful.
324  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
325  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
326  */
327 library SafeERC20 {
328     using Address for address;
329 
330     function safeTransfer(
331         IERC20 token,
332         address to,
333         uint256 value
334     ) internal {
335         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
336     }
337 
338     function safeTransferFrom(
339         IERC20 token,
340         address from,
341         address to,
342         uint256 value
343     ) internal {
344         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
345     }
346 
347     /**
348      * @dev Deprecated. This function has issues similar to the ones found in
349      * {IERC20-approve}, and its usage is discouraged.
350      *
351      * Whenever possible, use {safeIncreaseAllowance} and
352      * {safeDecreaseAllowance} instead.
353      */
354     function safeApprove(
355         IERC20 token,
356         address spender,
357         uint256 value
358     ) internal {
359         // safeApprove should only be called when setting an initial allowance,
360         // or when resetting it to zero. To increase and decrease it, use
361         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
362         require(
363             (value == 0) || (token.allowance(address(this), spender) == 0),
364             "SafeERC20: approve from non-zero to non-zero allowance"
365         );
366         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
367     }
368 
369     function safeIncreaseAllowance(
370         IERC20 token,
371         address spender,
372         uint256 value
373     ) internal {
374         uint256 newAllowance = token.allowance(address(this), spender) + value;
375         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
376     }
377 
378     function safeDecreaseAllowance(
379         IERC20 token,
380         address spender,
381         uint256 value
382     ) internal {
383         unchecked {
384             uint256 oldAllowance = token.allowance(address(this), spender);
385             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
386             uint256 newAllowance = oldAllowance - value;
387             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
388         }
389     }
390 
391     /**
392      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
393      * on the return value: the return value is optional (but if data is returned, it must not be false).
394      * @param token The token targeted by the call.
395      * @param data The call data (encoded using abi.encode or one of its variants).
396      */
397     function _callOptionalReturn(IERC20 token, bytes memory data) private {
398         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
399         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
400         // the target address contains contract code and also asserts for success in the low-level call.
401 
402         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
403         if (returndata.length > 0) {
404             // Return data is optional
405             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
406         }
407     }
408 }
409 
410 
411 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.5.0
412 
413 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
414 
415 pragma solidity ^0.8.0;
416 
417 // CAUTION
418 // This version of SafeMath should only be used with Solidity 0.8 or later,
419 // because it relies on the compiler's built in overflow checks.
420 
421 /**
422  * @dev Wrappers over Solidity's arithmetic operations.
423  *
424  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
425  * now has built in overflow checking.
426  */
427 library SafeMath {
428     /**
429      * @dev Returns the addition of two unsigned integers, with an overflow flag.
430      *
431      * _Available since v3.4._
432      */
433     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
434         unchecked {
435             uint256 c = a + b;
436             if (c < a) return (false, 0);
437             return (true, c);
438         }
439     }
440 
441     /**
442      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
443      *
444      * _Available since v3.4._
445      */
446     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
447         unchecked {
448             if (b > a) return (false, 0);
449             return (true, a - b);
450         }
451     }
452 
453     /**
454      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
455      *
456      * _Available since v3.4._
457      */
458     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
459         unchecked {
460             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
461             // benefit is lost if 'b' is also tested.
462             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
463             if (a == 0) return (true, 0);
464             uint256 c = a * b;
465             if (c / a != b) return (false, 0);
466             return (true, c);
467         }
468     }
469 
470     /**
471      * @dev Returns the division of two unsigned integers, with a division by zero flag.
472      *
473      * _Available since v3.4._
474      */
475     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
476         unchecked {
477             if (b == 0) return (false, 0);
478             return (true, a / b);
479         }
480     }
481 
482     /**
483      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
484      *
485      * _Available since v3.4._
486      */
487     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
488         unchecked {
489             if (b == 0) return (false, 0);
490             return (true, a % b);
491         }
492     }
493 
494     /**
495      * @dev Returns the addition of two unsigned integers, reverting on
496      * overflow.
497      *
498      * Counterpart to Solidity's `+` operator.
499      *
500      * Requirements:
501      *
502      * - Addition cannot overflow.
503      */
504     function add(uint256 a, uint256 b) internal pure returns (uint256) {
505         return a + b;
506     }
507 
508     /**
509      * @dev Returns the subtraction of two unsigned integers, reverting on
510      * overflow (when the result is negative).
511      *
512      * Counterpart to Solidity's `-` operator.
513      *
514      * Requirements:
515      *
516      * - Subtraction cannot overflow.
517      */
518     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
519         return a - b;
520     }
521 
522     /**
523      * @dev Returns the multiplication of two unsigned integers, reverting on
524      * overflow.
525      *
526      * Counterpart to Solidity's `*` operator.
527      *
528      * Requirements:
529      *
530      * - Multiplication cannot overflow.
531      */
532     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
533         return a * b;
534     }
535 
536     /**
537      * @dev Returns the integer division of two unsigned integers, reverting on
538      * division by zero. The result is rounded towards zero.
539      *
540      * Counterpart to Solidity's `/` operator.
541      *
542      * Requirements:
543      *
544      * - The divisor cannot be zero.
545      */
546     function div(uint256 a, uint256 b) internal pure returns (uint256) {
547         return a / b;
548     }
549 
550     /**
551      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
552      * reverting when dividing by zero.
553      *
554      * Counterpart to Solidity's `%` operator. This function uses a `revert`
555      * opcode (which leaves remaining gas untouched) while Solidity uses an
556      * invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
563         return a % b;
564     }
565 
566     /**
567      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
568      * overflow (when the result is negative).
569      *
570      * CAUTION: This function is deprecated because it requires allocating memory for the error
571      * message unnecessarily. For custom revert reasons use {trySub}.
572      *
573      * Counterpart to Solidity's `-` operator.
574      *
575      * Requirements:
576      *
577      * - Subtraction cannot overflow.
578      */
579     function sub(
580         uint256 a,
581         uint256 b,
582         string memory errorMessage
583     ) internal pure returns (uint256) {
584         unchecked {
585             require(b <= a, errorMessage);
586             return a - b;
587         }
588     }
589 
590     /**
591      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
592      * division by zero. The result is rounded towards zero.
593      *
594      * Counterpart to Solidity's `/` operator. Note: this function uses a
595      * `revert` opcode (which leaves remaining gas untouched) while Solidity
596      * uses an invalid opcode to revert (consuming all remaining gas).
597      *
598      * Requirements:
599      *
600      * - The divisor cannot be zero.
601      */
602     function div(
603         uint256 a,
604         uint256 b,
605         string memory errorMessage
606     ) internal pure returns (uint256) {
607         unchecked {
608             require(b > 0, errorMessage);
609             return a / b;
610         }
611     }
612 
613     /**
614      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
615      * reverting with custom message when dividing by zero.
616      *
617      * CAUTION: This function is deprecated because it requires allocating memory for the error
618      * message unnecessarily. For custom revert reasons use {tryMod}.
619      *
620      * Counterpart to Solidity's `%` operator. This function uses a `revert`
621      * opcode (which leaves remaining gas untouched) while Solidity uses an
622      * invalid opcode to revert (consuming all remaining gas).
623      *
624      * Requirements:
625      *
626      * - The divisor cannot be zero.
627      */
628     function mod(
629         uint256 a,
630         uint256 b,
631         string memory errorMessage
632     ) internal pure returns (uint256) {
633         unchecked {
634             require(b > 0, errorMessage);
635             return a % b;
636         }
637     }
638 }
639 
640 
641 // File contracts/rewardPools/RewardPool.sol
642 
643 pragma solidity 0.8.1;
644 // Note that this pool has no minter key of vApe (rewards).
645 // Instead, the governance will call vApe distributeReward method and send reward to this pool at the beginning.
646 contract ApeRewardPool {
647     using SafeMath for uint256;
648     using SafeERC20 for IERC20;
649 
650     // governance
651     address public operator;
652 
653     // Info of each user.
654     struct UserInfo {
655         uint256 amount; // How many LP tokens the user has provided.
656         uint256 rewardDebt; // Rewards already claimed by the user.
657     }
658 
659     // Info of each pool.
660     struct PoolInfo {
661         IERC20 token; // Address of LP token contract.
662         uint256 allocPoint; // How many allocation points assigned to this pool. Apes to distribute in the pool.
663         uint256 lastRewardTime; // Last time that Apes distribution occurred.
664         uint256 accApePerShare; // Accumulated Apes per share, times 1e18. See below.
665         bool isStarted; // if lastRewardTime has passed
666     }
667 
668     IERC20 public ape;
669 
670     // Info of each pool.
671     PoolInfo[] public poolInfo;
672 
673     // Info of each user that stakes LP tokens.
674     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
675 
676     // Total allocation points. Must be the sum of all allocation points in all pools.
677     uint256 public totalAllocPoint = 0;
678 
679     // The time when Ape mining starts.
680     uint256 public poolStartTime;
681 
682     uint256[] public epochTotalRewards = [80000 ether, 60000 ether];
683 
684     // Time when each epoch ends.
685     uint256[3] public epochEndTimes;
686 
687     // Reward per second for each of 2 epochs (last item is equal to 0 - for sanity).
688     uint256[3] public epochApePerSecond;
689 
690     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
691     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
692     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
693     event RewardPaid(address indexed user, uint256 amount);
694 
695     constructor(address _ape, uint256 _poolStartTime) {
696         require(block.timestamp < _poolStartTime, "late");
697         if (_ape != address(0)) ape = IERC20(_ape);
698 
699         poolStartTime = _poolStartTime;
700 
701         epochEndTimes[0] = poolStartTime + 1 days;
702         epochEndTimes[1] = epochEndTimes[0] + 1 days;
703 
704         epochApePerSecond[0] = epochTotalRewards[0].div(1 days);
705         epochApePerSecond[1] = epochTotalRewards[1].div(1 days);
706 
707         epochApePerSecond[2] = 0;
708         operator = msg.sender;
709     }
710 
711     modifier onlyOperator() {
712         require(operator == msg.sender, "ApeRewardPool: caller is not the operator");
713         _;
714     }
715 
716     function checkPoolDuplicate(IERC20 _token) internal view {
717         uint256 length = poolInfo.length;
718         for (uint256 pid = 0; pid < length; ++pid) {
719             require(poolInfo[pid].token != _token, "ApeRewardPool: existing pool?");
720         }
721     }
722 
723     // Add a new token to the pool. Can only be called by the owner.
724     function add(
725         uint256 _allocPoint,
726         IERC20 _token,
727         bool _withUpdate,
728         uint256 _lastRewardTime
729     ) public onlyOperator {
730         checkPoolDuplicate(_token);
731         if (_withUpdate) {
732             massUpdatePools();
733         }
734         if (block.timestamp < poolStartTime) {
735             // chef is sleeping
736             if (_lastRewardTime == 0) {
737                 _lastRewardTime = poolStartTime;
738             } else {
739                 if (_lastRewardTime < poolStartTime) {
740                     _lastRewardTime = poolStartTime;
741                 }
742             }
743         } else {
744             // chef is cooking
745             if (_lastRewardTime == 0 || _lastRewardTime < block.timestamp) {
746                 _lastRewardTime = block.timestamp;
747             }
748         }
749         bool _isStarted = (_lastRewardTime <= poolStartTime) || (_lastRewardTime <= block.timestamp);
750         poolInfo.push(PoolInfo({token: _token, allocPoint: _allocPoint, lastRewardTime: _lastRewardTime, accApePerShare: 0, isStarted: _isStarted}));
751         if (_isStarted) {
752             totalAllocPoint = totalAllocPoint.add(_allocPoint);
753         }
754     }
755 
756     // Update the given pool's Ape allocation point. Can only be called by the owner.
757     function set(uint256 _pid, uint256 _allocPoint) public onlyOperator {
758         massUpdatePools();
759         PoolInfo storage pool = poolInfo[_pid];
760         if (pool.isStarted) {
761             totalAllocPoint = totalAllocPoint.sub(pool.allocPoint).add(_allocPoint);
762         }
763         pool.allocPoint = _allocPoint;
764     }
765 
766     // Return accumulate rewards over the given _fromTime to _toTime.
767     function getGeneratedReward(uint256 _fromTime, uint256 _toTime) public view returns (uint256) {
768         for (uint8 epochId = 2; epochId >= 1; --epochId) {
769             if (_toTime >= epochEndTimes[epochId - 1]) {
770                 if (_fromTime >= epochEndTimes[epochId - 1]) {
771                     return _toTime.sub(_fromTime).mul(epochApePerSecond[epochId]);
772                 }
773 
774                 uint256 _generatedReward = _toTime.sub(epochEndTimes[epochId - 1]).mul(epochApePerSecond[epochId]);
775                 if (epochId == 1) {
776                     return _generatedReward.add(epochEndTimes[0].sub(_fromTime).mul(epochApePerSecond[0]));
777                 }
778                 for (epochId = epochId - 1; epochId >= 1; --epochId) {
779                     if (_fromTime >= epochEndTimes[epochId - 1]) {
780                         return _generatedReward.add(epochEndTimes[epochId].sub(_fromTime).mul(epochApePerSecond[epochId]));
781                     }
782                     _generatedReward = _generatedReward.add(epochEndTimes[epochId].sub(epochEndTimes[epochId - 1]).mul(epochApePerSecond[epochId]));
783                 }
784                 return _generatedReward.add(epochEndTimes[0].sub(_fromTime).mul(epochApePerSecond[0]));
785             }
786         }
787         return _toTime.sub(_fromTime).mul(epochApePerSecond[0]);
788     }
789 
790     // View function to see pending Apes on frontend.
791     function pendingAPE(uint256 _pid, address _user) external view returns (uint256) {
792         PoolInfo storage pool = poolInfo[_pid];
793         UserInfo storage user = userInfo[_pid][_user];
794         uint256 accApePerShare = pool.accApePerShare;
795         uint256 tokenSupply = pool.token.balanceOf(address(this));
796         if (block.timestamp > pool.lastRewardTime && tokenSupply != 0) {
797             uint256 _generatedReward = getGeneratedReward(pool.lastRewardTime, block.timestamp);
798             uint256 _apeReward = _generatedReward.mul(pool.allocPoint).div(totalAllocPoint);
799             accApePerShare = accApePerShare.add(_apeReward.mul(1e18).div(tokenSupply));
800         }
801         return user.amount.mul(accApePerShare).div(1e18).sub(user.rewardDebt);
802     }
803 
804     // Update reward variables for all pools. Be careful of gas spending!
805     function massUpdatePools() public {
806         uint256 length = poolInfo.length;
807         for (uint256 pid = 0; pid < length; ++pid) {
808             updatePool(pid);
809         }
810     }
811 
812     // Update reward variables of the given pool to be up-to-date.
813     function updatePool(uint256 _pid) public {
814         PoolInfo storage pool = poolInfo[_pid];
815         if (block.timestamp <= pool.lastRewardTime) {
816             return;
817         }
818         uint256 tokenSupply = pool.token.balanceOf(address(this));
819         if (tokenSupply == 0) {
820             pool.lastRewardTime = block.timestamp;
821             return;
822         }
823         if (!pool.isStarted) {
824             pool.isStarted = true;
825             totalAllocPoint = totalAllocPoint.add(pool.allocPoint);
826         }
827         if (totalAllocPoint > 0) {
828             uint256 _generatedReward = getGeneratedReward(pool.lastRewardTime, block.timestamp);
829             uint256 _apeReward = _generatedReward.mul(pool.allocPoint).div(totalAllocPoint);
830             pool.accApePerShare = pool.accApePerShare.add(_apeReward.mul(1e18).div(tokenSupply));
831         }
832         pool.lastRewardTime = block.timestamp;
833     }
834 
835     // Deposit LP tokens.
836     function deposit(uint256 _pid, uint256 _amount) public {
837         address _sender = msg.sender;
838         PoolInfo storage pool = poolInfo[_pid];
839         UserInfo storage user = userInfo[_pid][_sender];
840         updatePool(_pid);
841         if (user.amount > 0) {
842             uint256 _pending = user.amount.mul(pool.accApePerShare).div(1e18).sub(user.rewardDebt);
843             if (_pending > 0) {
844                 safeApeTransfer(_sender, _pending);
845                 emit RewardPaid(_sender, _pending);
846             }
847         }
848         if (_amount > 0) {
849             pool.token.safeTransferFrom(_sender, address(this), _amount);
850             user.amount = user.amount.add(_amount);
851         }
852         user.rewardDebt = user.amount.mul(pool.accApePerShare).div(1e18);
853         emit Deposit(_sender, _pid, _amount);
854     }
855 
856     // Withdraw LP tokens.
857     function withdraw(uint256 _pid, uint256 _amount) public {
858         address _sender = msg.sender;
859         PoolInfo storage pool = poolInfo[_pid];
860         UserInfo storage user = userInfo[_pid][_sender];
861         require(user.amount >= _amount, "withdraw: not good");
862         updatePool(_pid);
863         uint256 _pending = user.amount.mul(pool.accApePerShare).div(1e18).sub(user.rewardDebt);
864         if (_pending > 0) {
865             safeApeTransfer(_sender, _pending);
866             emit RewardPaid(_sender, _pending);
867         }
868         if (_amount > 0) {
869             user.amount = user.amount.sub(_amount);
870             pool.token.safeTransfer(_sender, _amount);
871         }
872         user.rewardDebt = user.amount.mul(pool.accApePerShare).div(1e18);
873         emit Withdraw(_sender, _pid, _amount);
874     }
875 
876     // Withdraw without caring about rewards. EMERGENCY ONLY.
877     function emergencyWithdraw(uint256 _pid) public {
878         PoolInfo storage pool = poolInfo[_pid];
879         UserInfo storage user = userInfo[_pid][msg.sender];
880         uint256 _amount = user.amount;
881         user.amount = 0;
882         user.rewardDebt = 0;
883         pool.token.safeTransfer(msg.sender, _amount);
884         emit EmergencyWithdraw(msg.sender, _pid, _amount);
885     }
886 
887     // Safe ape transfer function, just in case if rounding error causes pool to not have enough Apes.
888     function safeApeTransfer(address _to, uint256 _amount) internal {
889         uint256 _apeBal = ape.balanceOf(address(this));
890         if (_apeBal > 0) {
891             if (_amount > _apeBal) {
892                 ape.safeTransfer(_to, _apeBal);
893             } else {
894                 ape.safeTransfer(_to, _amount);
895             }
896         }
897     }
898 
899     function setOperator(address _operator) external onlyOperator {
900         operator = _operator;
901     }
902 
903     function governanceRecoverUnsupported(
904         IERC20 _token,
905         uint256 amount,
906         address to
907     ) external onlyOperator {
908         if (block.timestamp < epochEndTimes[1] + 30 days) {
909             // do not allow to drain token if less than 30 days after farming
910             require(_token != ape, "!ape");
911             uint256 length = poolInfo.length;
912             for (uint256 pid = 0; pid < length; ++pid) {
913                 PoolInfo storage pool = poolInfo[pid];
914                 require(_token != pool.token, "!pool.token");
915             }
916         }
917         _token.safeTransfer(to, amount);
918     }
919 }