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
568 // File contracts/utils/ContractGuard.sol
569 
570 
571 
572 pragma solidity 0.6.12;
573 
574 contract ContractGuard {
575     mapping(uint256 => mapping(address => bool)) private _status;
576 
577     function checkSameOriginReentranted() internal view returns (bool) {
578         return _status[block.number][tx.origin];
579     }
580 
581     function checkSameSenderReentranted() internal view returns (bool) {
582         return _status[block.number][msg.sender];
583     }
584 
585     modifier onlyOneBlock() {
586         require(!checkSameOriginReentranted(), "ContractGuard: one block, one function");
587         require(!checkSameSenderReentranted(), "ContractGuard: one block, one function");
588 
589         _;
590 
591         _status[block.number][tx.origin] = true;
592         _status[block.number][msg.sender] = true;
593     }
594 }
595 
596 
597 // File contracts/interfaces/IBasisAsset.sol
598 
599 
600 
601 pragma solidity ^0.6.0;
602 
603 interface IBasisAsset {
604     function mint(address recipient, uint256 amount) external returns (bool);
605 
606     function burn(uint256 amount) external;
607 
608     function burnFrom(address from, uint256 amount) external;
609 
610     function isOperator() external returns (bool);
611 
612     function operator() external view returns (address);
613 
614     function transferOperator(address newOperator_) external;
615 }
616 
617 
618 // File contracts/interfaces/ITreasury.sol
619 
620 
621 
622 pragma solidity 0.6.12;
623 
624 interface ITreasury {
625     function epoch() external view returns (uint256);
626 
627     function nextEpochPoint() external view returns (uint256);
628 
629     function getGldmPrice() external view returns (uint256);
630 
631     function buyBonds(uint256 amount, uint256 targetPrice) external;
632 
633     function redeemBonds(uint256 amount, uint256 targetPrice) external;
634 }
635 
636 
637 // File contracts/Boardroom.sol
638 
639 
640 
641 pragma solidity 0.6.12;
642 
643 
644 
645 
646 contract ShareWrapper {
647     using SafeMath for uint256;
648     using SafeERC20 for IERC20;
649 
650     IERC20 public share;
651 
652     uint256 private _totalSupply;
653     mapping(address => uint256) private _balances;
654 
655     function totalSupply() public view returns (uint256) {
656         return _totalSupply;
657     }
658 
659     function balanceOf(address account) public view returns (uint256) {
660         return _balances[account];
661     }
662 
663     function stake(uint256 amount) public virtual {
664         _totalSupply = _totalSupply.add(amount);
665         _balances[msg.sender] = _balances[msg.sender].add(amount);
666         share.safeTransferFrom(msg.sender, address(this), amount);
667     }
668 
669     function withdraw(uint256 amount) public virtual {
670         uint256 memberShare = _balances[msg.sender];
671         require(memberShare >= amount, "Boardroom: withdraw request greater than staked amount");
672         _totalSupply = _totalSupply.sub(amount);
673         _balances[msg.sender] = memberShare.sub(amount);
674         share.safeTransfer(msg.sender, amount);
675     }
676 }
677 
678 
679 contract Boardroom is ShareWrapper, ContractGuard {
680     using SafeERC20 for IERC20;
681     using Address for address;
682     using SafeMath for uint256;
683 
684     /* ========== DATA STRUCTURES ========== */
685 
686     struct Memberseat {
687         uint256 lastSnapshotIndex;
688         uint256 rewardEarned;
689         uint256 epochTimerStart;
690     }
691 
692     struct BoardroomSnapshot {
693         uint256 time;
694         uint256 rewardReceived;
695         uint256 rewardPerShare;
696     }
697 
698     /* ========== STATE VARIABLES ========== */
699 
700     // governance
701     address public operator;
702 
703     // flags
704     bool public initialized = false;
705 
706     IERC20 public gldm;
707     ITreasury public treasury;
708 
709     mapping(address => Memberseat) public members;
710     BoardroomSnapshot[] public boardroomHistory;
711 
712     uint256 public withdrawLockupEpochs;
713     uint256 public rewardLockupEpochs;
714 
715     /* ========== EVENTS ========== */
716 
717     event Initialized(address indexed executor, uint256 at);
718     event Staked(address indexed user, uint256 amount);
719     event Withdrawn(address indexed user, uint256 amount);
720     event RewardPaid(address indexed user, uint256 reward);
721     event RewardAdded(address indexed user, uint256 reward);
722 
723     /* ========== Modifiers =============== */
724 
725     modifier onlyOperator() {
726         require(operator == msg.sender, "Boardroom: caller is not the operator");
727         _;
728     }
729 
730     modifier memberExists() {
731         require(balanceOf(msg.sender) > 0, "Boardroom: The member does not exist");
732         _;
733     }
734 
735     modifier updateReward(address member) {
736         if (member != address(0)) {
737             Memberseat memory seat = members[member];
738             seat.rewardEarned = earned(member);
739             seat.lastSnapshotIndex = latestSnapshotIndex();
740             members[member] = seat;
741         }
742         _;
743     }
744 
745     modifier notInitialized() {
746         require(!initialized, "Boardroom: already initialized");
747         _;
748     }
749 
750     /* ========== GOVERNANCE ========== */
751 
752     function initialize(
753         IERC20 _gldm,
754         IERC20 _share,
755         ITreasury _treasury
756     ) public notInitialized {
757         gldm = _gldm;
758         share = _share;
759         treasury = _treasury;
760 
761         BoardroomSnapshot memory genesisSnapshot = BoardroomSnapshot({time: block.number, rewardReceived: 0, rewardPerShare: 0});
762         boardroomHistory.push(genesisSnapshot);
763 
764         withdrawLockupEpochs = 6; // Lock for 6 epochs (36h) before release withdraw
765         rewardLockupEpochs = 3; // Lock for 3 epochs (18h) before release claimReward
766 
767         initialized = true;
768         operator = msg.sender;
769         emit Initialized(msg.sender, block.number);
770     }
771 
772     function setOperator(address _operator) external onlyOperator {
773         operator = _operator;
774     }
775 
776     function setLockUp(uint256 _withdrawLockupEpochs, uint256 _rewardLockupEpochs) external onlyOperator {
777         require(_withdrawLockupEpochs >= _rewardLockupEpochs && _withdrawLockupEpochs <= 56, "_withdrawLockupEpochs: out of range"); // <= 2 week
778         withdrawLockupEpochs = _withdrawLockupEpochs;
779         rewardLockupEpochs = _rewardLockupEpochs;
780     }
781 
782     /* ========== VIEW FUNCTIONS ========== */
783 
784     // =========== Snapshot getters
785 
786     function latestSnapshotIndex() public view returns (uint256) {
787         return boardroomHistory.length.sub(1);
788     }
789 
790     function getLatestSnapshot() internal view returns (BoardroomSnapshot memory) {
791         return boardroomHistory[latestSnapshotIndex()];
792     }
793 
794     function getLastSnapshotIndexOf(address member) public view returns (uint256) {
795         return members[member].lastSnapshotIndex;
796     }
797 
798     function getLastSnapshotOf(address member) internal view returns (BoardroomSnapshot memory) {
799         return boardroomHistory[getLastSnapshotIndexOf(member)];
800     }
801 
802     function canWithdraw(address member) external view returns (bool) {
803         return members[member].epochTimerStart.add(withdrawLockupEpochs) <= treasury.epoch();
804     }
805 
806     function canClaimReward(address member) external view returns (bool) {
807         return members[member].epochTimerStart.add(rewardLockupEpochs) <= treasury.epoch();
808     }
809 
810     function epoch() external view returns (uint256) {
811         return treasury.epoch();
812     }
813 
814     function nextEpochPoint() external view returns (uint256) {
815         return treasury.nextEpochPoint();
816     }
817 
818     function getGldmPrice() external view returns (uint256) {
819         return treasury.getGldmPrice();
820     }
821 
822     // =========== Member getters
823 
824     function rewardPerShare() public view returns (uint256) {
825         return getLatestSnapshot().rewardPerShare;
826     }
827 
828     function earned(address member) public view returns (uint256) {
829         uint256 latestRPS = getLatestSnapshot().rewardPerShare;
830         uint256 storedRPS = getLastSnapshotOf(member).rewardPerShare;
831 
832         return balanceOf(member).mul(latestRPS.sub(storedRPS)).div(1e18).add(members[member].rewardEarned);
833     }
834 
835     /* ========== MUTATIVE FUNCTIONS ========== */
836 
837     function stake(uint256 amount) public override onlyOneBlock updateReward(msg.sender) {
838         require(amount > 0, "Boardroom: Cannot stake 0");
839         super.stake(amount);
840         members[msg.sender].epochTimerStart = treasury.epoch(); // reset timer
841         emit Staked(msg.sender, amount);
842     }
843 
844     function withdraw(uint256 amount) public override onlyOneBlock memberExists updateReward(msg.sender) {
845         require(amount > 0, "Boardroom: Cannot withdraw 0");
846         require(members[msg.sender].epochTimerStart.add(withdrawLockupEpochs) <= treasury.epoch(), "Boardroom: still in withdraw lockup");
847         claimReward();
848         super.withdraw(amount);
849         emit Withdrawn(msg.sender, amount);
850     }
851 
852     function exit() external {
853         withdraw(balanceOf(msg.sender));
854     }
855 
856     function claimReward() public updateReward(msg.sender) {
857         uint256 reward = members[msg.sender].rewardEarned;
858         if (reward > 0) {
859             require(members[msg.sender].epochTimerStart.add(rewardLockupEpochs) <= treasury.epoch(), "Boardroom: still in reward lockup");
860             members[msg.sender].epochTimerStart = treasury.epoch(); // reset timer
861             members[msg.sender].rewardEarned = 0;
862             gldm.safeTransfer(msg.sender, reward);
863             emit RewardPaid(msg.sender, reward);
864         }
865     }
866 
867     function allocateSeigniorage(uint256 amount) external onlyOneBlock onlyOperator {
868         require(amount > 0, "Boardroom: Cannot allocate 0");
869         require(totalSupply() > 0, "Boardroom: Cannot allocate when totalSupply is 0");
870 
871         // Create & add new snapshot
872         uint256 prevRPS = getLatestSnapshot().rewardPerShare;
873         uint256 nextRPS = prevRPS.add(amount.mul(1e18).div(totalSupply()));
874 
875         BoardroomSnapshot memory newSnapshot = BoardroomSnapshot({time: block.number, rewardReceived: amount, rewardPerShare: nextRPS});
876         boardroomHistory.push(newSnapshot);
877 
878         gldm.safeTransferFrom(msg.sender, address(this), amount);
879         emit RewardAdded(msg.sender, amount);
880     }
881 
882     function governanceRecoverUnsupported(
883         IERC20 _token,
884         uint256 _amount,
885         address _to
886     ) external onlyOperator {
887         // do not allow to drain core tokens
888         require(address(_token) != address(gldm), "gldm");
889         require(address(_token) != address(share), "share");
890         _token.safeTransfer(_to, _amount);
891     }
892 }