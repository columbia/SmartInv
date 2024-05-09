1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.6;
3 
4 /**
5  * @dev Standard math utilities missing in the Solidity language.
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the average of two numbers. The result is rounded towards
24      * zero.
25      */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 }
31 
32 interface IStakingRewards {
33     // Views
34     function lastTimeRewardApplicable() external view returns (uint256);
35 
36     function rewardPerToken() external view returns (uint256);
37 
38     function earned(address account) external view returns (uint256);
39 
40     function getRewardForDuration() external view returns (uint256);
41 
42     function totalSupply() external view returns (uint256);
43 
44     function balanceOf(address account) external view returns (uint256);
45 
46     // Mutative
47 
48     function stake(uint256 amount) external;
49 
50     function withdraw(uint256 amount) external;
51 
52     function getReward() external;
53 
54     function exit() external;
55 }
56 
57 interface IUniswapV2ERC20 {
58     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
59 }
60 
61 abstract contract ReentrancyGuard {
62     /// @dev counter to allow mutex lock with only one SSTORE operation
63     uint256 private _guardCounter;
64 
65     constructor () {
66         // The counter starts at one to prevent changing it from zero to a non-zero
67         // value, which is a more expensive operation.
68         _guardCounter = 1;
69     }
70 
71     /**
72      * @dev Prevents a contract from calling itself, directly or indirectly.
73      * Calling a `nonReentrant` function from another `nonReentrant`
74      * function is not supported. It is possible to prevent this from happening
75      * by making the `nonReentrant` function external, and make it call a
76      * `private` function that does the actual work.
77      */
78     modifier nonReentrant() {
79         _guardCounter += 1;
80         uint256 localCounter = _guardCounter;
81         _;
82         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
83     }
84 }
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
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // This method relies on extcodesize, which returns 0 for contracts in
320         // construction, since the code is only stored at the end of the
321         // constructor execution.
322 
323         uint256 size;
324         // solhint-disable-next-line no-inline-assembly
325         assembly { size := extcodesize(account) }
326         return size > 0;
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
349         (bool success, ) = recipient.call{ value: amount }("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain`call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372       return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
407         require(address(this).balance >= value, "Address: insufficient balance for call");
408         require(isContract(target), "Address: call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = target.call{ value: value }(data);
412         return _verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
422         return functionStaticCall(target, data, "Address: low-level static call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
432         require(isContract(target), "Address: static call to non-contract");
433 
434         // solhint-disable-next-line avoid-low-level-calls
435         (bool success, bytes memory returndata) = target.staticcall(data);
436         return _verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
446         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
456         require(isContract(target), "Address: delegate call to non-contract");
457 
458         // solhint-disable-next-line avoid-low-level-calls
459         (bool success, bytes memory returndata) = target.delegatecall(data);
460         return _verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
464         if (success) {
465             return returndata;
466         } else {
467             // Look for revert reason and bubble it up if present
468             if (returndata.length > 0) {
469                 // The easiest way to bubble the revert reason is using memory via assembly
470 
471                 // solhint-disable-next-line no-inline-assembly
472                 assembly {
473                     let returndata_size := mload(returndata)
474                     revert(add(32, returndata), returndata_size)
475                 }
476             } else {
477                 revert(errorMessage);
478             }
479         }
480     }
481 }
482 
483 /**
484  * @dev Interface of the ERC20 standard as defined in the EIP.
485  */
486 interface IERC20 {
487     /**
488      * @dev Returns the amount of tokens in existence.
489      */
490     function totalSupply() external view returns (uint256);
491 
492     /**
493      * @dev Returns the amount of tokens owned by `account`.
494      */
495     function balanceOf(address account) external view returns (uint256);
496 
497     /**
498      * @dev Moves `amount` tokens from the caller's account to `recipient`.
499      *
500      * Returns a boolean value indicating whether the operation succeeded.
501      *
502      * Emits a {Transfer} event.
503      */
504     function transfer(address recipient, uint256 amount) external returns (bool);
505 
506     /**
507      * @dev Returns the remaining number of tokens that `spender` will be
508      * allowed to spend on behalf of `owner` through {transferFrom}. This is
509      * zero by default.
510      *
511      * This value changes when {approve} or {transferFrom} are called.
512      */
513     function allowance(address owner, address spender) external view returns (uint256);
514 
515     /**
516      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
517      *
518      * Returns a boolean value indicating whether the operation succeeded.
519      *
520      * IMPORTANT: Beware that changing an allowance with this method brings the risk
521      * that someone may use both the old and the new allowance by unfortunate
522      * transaction ordering. One possible solution to mitigate this race
523      * condition is to first reduce the spender's allowance to 0 and set the
524      * desired value afterwards:
525      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
526      *
527      * Emits an {Approval} event.
528      */
529     function approve(address spender, uint256 amount) external returns (bool);
530 
531     /**
532      * @dev Moves `amount` tokens from `sender` to `recipient` using the
533      * allowance mechanism. `amount` is then deducted from the caller's
534      * allowance.
535      *
536      * Returns a boolean value indicating whether the operation succeeded.
537      *
538      * Emits a {Transfer} event.
539      */
540     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
541 
542     /**
543      * @dev Emitted when `value` tokens are moved from one account (`from`) to
544      * another (`to`).
545      *
546      * Note that `value` may be zero.
547      */
548     event Transfer(address indexed from, address indexed to, uint256 value);
549 
550     /**
551      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
552      * a call to {approve}. `value` is the new allowance.
553      */
554     event Approval(address indexed owner, address indexed spender, uint256 value);
555 }
556 
557 /**
558  * @title SafeERC20
559  * @dev Wrappers around ERC20 operations that throw on failure (when the token
560  * contract returns false). Tokens that return no value (and instead revert or
561  * throw on failure) are also supported, non-reverting calls are assumed to be
562  * successful.
563  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
564  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
565  */
566 library SafeERC20 {
567     using SafeMath for uint256;
568     using Address for address;
569 
570     function safeTransfer(IERC20 token, address to, uint256 value) internal {
571         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
572     }
573 
574     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
575         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
576     }
577 
578     function safeApprove(IERC20 token, address spender, uint256 value) internal {
579         // safeApprove should only be called when setting an initial allowance,
580         // or when resetting it to zero. To increase and decrease it, use
581         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
582         // solhint-disable-next-line max-line-length
583         require((value == 0) || (token.allowance(address(this), spender) == 0),
584             "SafeERC20: approve from non-zero to non-zero allowance"
585         );
586         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
587     }
588 
589     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
590         uint256 newAllowance = token.allowance(address(this), spender).add(value);
591         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
592     }
593 
594     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
595         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
596         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
597     }
598 
599     /**
600      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
601      * on the return value: the return value is optional (but if data is returned, it must not be false).
602      * @param token The token targeted by the call.
603      * @param data The call data (encoded using abi.encode or one of its variants).
604      */
605     function callOptionalReturn(IERC20 token, bytes memory data) private {
606         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
607         // we're implementing it ourselves.
608 
609         // A Solidity high level call has three parts:
610         //  1. The target address is checked to verify it contains contract code
611         //  2. The call itself is made, and success asserted
612         //  3. The return value is decoded, which in turn checks the size of the returned data.
613         // solhint-disable-next-line max-line-length
614         require(address(token).isContract(), "SafeERC20: call to non-contract");
615 
616         // solhint-disable-next-line avoid-low-level-calls
617         (bool success, bytes memory returndata) = address(token).call(data);
618         require(success, "SafeERC20: low-level call failed");
619 
620         if (returndata.length > 0) { // Return data is optional
621             // solhint-disable-next-line max-line-length
622             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
623         }
624     }
625 }
626 
627 abstract contract RewardsDistributionRecipient {
628     address public rewardsDistribution;
629 
630     function notifyRewardAmount(uint256 reward) external virtual;
631 
632     modifier onlyRewardsDistribution() {
633         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
634         _;
635     }
636 }
637 
638 contract PeakStakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
639     using SafeMath for uint256;
640     using SafeERC20 for IERC20;
641 
642     /* ========== STATE VARIABLES ========== */
643 
644     IERC20 public rewardsToken;
645     IERC20 public stakingToken;
646     uint256 public periodFinish = 0;
647     uint256 public rewardRate = 0;
648     uint256 public rewardsDuration =30 days;
649     uint256 public lastUpdateTime;
650     uint256 public rewardPerTokenStored;
651 
652     mapping(address => uint256) public userRewardPerTokenPaid;
653     mapping(address => uint256) public rewards;
654 
655     uint256 private _totalSupply;
656     mapping(address => uint256) private _balances;
657 
658     /* ========== EVENTS ========== */
659 
660     event RewardAdded(uint256 reward);
661     event Staked(address indexed user, uint256 amount);
662     event Withdrawn(address indexed user, uint256 amount);
663     event RewardPaid(address indexed user, uint256 reward);
664 
665     /* ========== MODIFIERS ========== */
666 
667     modifier updateReward(address account) {
668         rewardPerTokenStored = rewardPerToken();
669         lastUpdateTime = lastTimeRewardApplicable();
670         if (account != address(0)) {
671             rewards[account] = earned(account);
672             userRewardPerTokenPaid[account] = rewardPerTokenStored;
673         }
674         _;
675     }
676 
677     /* ========== CONSTRUCTOR ========== */
678 
679     constructor(
680         address _rewardsDistribution,
681         address _rewardsToken,
682         address _stakingToken
683     ) ReentrancyGuard() {
684         rewardsToken = IERC20(_rewardsToken);
685         stakingToken = IERC20(_stakingToken);
686         rewardsDistribution = _rewardsDistribution;
687     }
688 
689     /* ========== VIEWS ========== */
690 
691     function totalSupply() external view override returns (uint256) {
692         return _totalSupply;
693     }
694 
695     function balanceOf(address account) external view override returns (uint256) {
696         return _balances[account];
697     }
698 
699     function lastTimeRewardApplicable() public view override returns (uint256) {
700         return Math.min(block.timestamp, periodFinish);
701     }
702 
703     function rewardPerToken() public view override returns (uint256) {
704         if (_totalSupply == 0) {
705             return rewardPerTokenStored;
706         }
707         return
708         rewardPerTokenStored.add(
709             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
710         );
711     }
712 
713     function earned(address account) public view override returns (uint256) {
714         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
715     }
716 
717     function getRewardForDuration() external view override returns (uint256) {
718         return rewardRate.mul(rewardsDuration);
719     }
720 
721     /* ========== MUTATIVE FUNCTIONS ========== */
722 
723     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
724         require(amount > 0, "Cannot stake 0");
725         _totalSupply = _totalSupply.add(amount);
726         _balances[msg.sender] = _balances[msg.sender].add(amount);
727 
728         // permit
729         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
730 
731         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
732         emit Staked(msg.sender, amount);
733     }
734 
735     function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
736         require(amount > 0, "Cannot stake 0");
737         _totalSupply = _totalSupply.add(amount);
738         _balances[msg.sender] = _balances[msg.sender].add(amount);
739         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
740         emit Staked(msg.sender, amount);
741     }
742 
743     function withdraw(uint256 amount) public override nonReentrant updateReward(msg.sender) {
744         require(amount > 0, "Cannot withdraw 0");
745         _totalSupply = _totalSupply.sub(amount);
746         _balances[msg.sender] = _balances[msg.sender].sub(amount);
747         stakingToken.safeTransfer(msg.sender, amount);
748         emit Withdrawn(msg.sender, amount);
749     }
750 
751     function getReward() public override nonReentrant updateReward(msg.sender) {
752         uint256 reward = rewards[msg.sender];
753         if (reward > 0) {
754             rewards[msg.sender] = 0;
755             rewardsToken.safeTransfer(msg.sender, reward);
756             emit RewardPaid(msg.sender, reward);
757         }
758     }
759 
760     function exit() external override {
761         withdraw(_balances[msg.sender]);
762         getReward();
763     }
764 
765     /* ========== RESTRICTED FUNCTIONS ========== */
766 
767     function notifyRewardAmount(uint256 reward) external override onlyRewardsDistribution updateReward(address(0)) {
768         if (block.timestamp >= periodFinish) {
769             rewardRate = reward.div(rewardsDuration);
770         } else {
771             uint256 remaining = periodFinish.sub(block.timestamp);
772             uint256 leftover = remaining.mul(rewardRate);
773             rewardRate = reward.add(leftover).div(rewardsDuration);
774         }
775 
776         // Ensure the provided reward amount is not more than the balance in the contract.
777         // This keeps the reward rate in the right range, preventing overflows due to
778         // very high values of rewardRate in the earned and rewardsPerToken functions;
779         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
780         uint balance = rewardsToken.balanceOf(address(this));
781         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
782 
783         lastUpdateTime = block.timestamp;
784         periodFinish = block.timestamp.add(rewardsDuration);
785         emit RewardAdded(reward);
786     }
787 }