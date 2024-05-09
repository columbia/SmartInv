1 // SPDX-License-Identifier: https://github.com/lendroidproject/protocol.2.0/blob/master/LICENSE.md
2 
3 
4 // File: @openzeppelin/contracts/math/Math.sol
5 
6 pragma solidity ^0.7.0;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     /**
13      * @dev Returns the largest of two numbers.
14      */
15     function max(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a >= b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two numbers.
21      */
22     function min(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the average of two numbers. The result is rounded towards
28      * zero.
29      */
30     function average(uint256 a, uint256 b) internal pure returns (uint256) {
31         // (a + b) / 2 can overflow, so we distribute
32         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
33     }
34 }
35 
36 // File: @openzeppelin/contracts/math/SafeMath.sol
37 
38 pragma solidity ^0.7.0;
39 
40 /**
41  * @dev Wrappers over Solidity's arithmetic operations with added overflow
42  * checks.
43  *
44  * Arithmetic operations in Solidity wrap on overflow. This can easily result
45  * in bugs, because programmers usually assume that an overflow raises an
46  * error, which is the standard behavior in high level programming languages.
47  * `SafeMath` restores this intuition by reverting the transaction when an
48  * operation overflows.
49  *
50  * Using this library instead of the unchecked operations eliminates an entire
51  * class of bugs, so it's recommended to use it always.
52  */
53 library SafeMath {
54     /**
55      * @dev Returns the addition of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `+` operator.
59      *
60      * Requirements:
61      *
62      * - Addition cannot overflow.
63      */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a, "SafeMath: addition overflow");
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      *
79      * - Subtraction cannot overflow.
80      */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         return sub(a, b, "SafeMath: subtraction overflow");
83     }
84 
85     /**
86      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
87      * overflow (when the result is negative).
88      *
89      * Counterpart to Solidity's `-` operator.
90      *
91      * Requirements:
92      *
93      * - Subtraction cannot overflow.
94      */
95     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the multiplication of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `*` operator.
107      *
108      * Requirements:
109      *
110      * - Multiplication cannot overflow.
111      */
112     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114         // benefit is lost if 'b' is also tested.
115         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
116         if (a == 0) {
117             return 0;
118         }
119 
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers. Reverts on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator. Note: this function uses a
131      * `revert` opcode (which leaves remaining gas untouched) while Solidity
132      * uses an invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return div(a, b, "SafeMath: division by zero");
140     }
141 
142     /**
143      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
144      * division by zero. The result is rounded towards zero.
145      *
146      * Counterpart to Solidity's `/` operator. Note: this function uses a
147      * `revert` opcode (which leaves remaining gas untouched) while Solidity
148      * uses an invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b > 0, errorMessage);
156         uint256 c = a / b;
157         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * Reverts when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         return mod(a, b, "SafeMath: modulo by zero");
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts with custom message when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b != 0, errorMessage);
192         return a % b;
193     }
194 }
195 
196 // File: contracts/heartbeat/Pacemaker.sol
197 
198 pragma solidity 0.7.5;
199 
200 
201 
202 /** @title Pacemaker
203     @author Lendroid Foundation
204     @notice Smart contract based on which various events in the Protocol take place
205     @dev Audit certificate : https://certificate.quantstamp.com/view/lendroid-whalestreet
206 */
207 
208 
209 // solhint-disable-next-line
210 abstract contract Pacemaker {
211 
212     using SafeMath for uint256;
213     uint256 constant public HEART_BEAT_START_TIME = 1607212800;// 2020-12-06 00:00:00 UTC (UTC +00:00)
214     uint256 constant public EPOCH_PERIOD = 8 hours;
215 
216     /**
217         @notice Displays the epoch which contains the given timestamp
218         @return uint256 : Epoch value
219     */
220     function epochFromTimestamp(uint256 timestamp) public pure returns (uint256) {
221         if (timestamp > HEART_BEAT_START_TIME) {
222             return timestamp.sub(HEART_BEAT_START_TIME).div(EPOCH_PERIOD).add(1);
223         }
224         return 0;
225     }
226 
227     /**
228         @notice Displays timestamp when a given epoch began
229         @return uint256 : Epoch start time
230     */
231     function epochStartTimeFromTimestamp(uint256 timestamp) public pure returns (uint256) {
232         if (timestamp <= HEART_BEAT_START_TIME) {
233             return HEART_BEAT_START_TIME;
234         } else {
235             return HEART_BEAT_START_TIME.add((epochFromTimestamp(timestamp).sub(1)).mul(EPOCH_PERIOD));
236         }
237     }
238 
239     /**
240         @notice Displays timestamp when a given epoch will end
241         @return uint256 : Epoch end time
242     */
243     function epochEndTimeFromTimestamp(uint256 timestamp) public pure returns (uint256) {
244         if (timestamp < HEART_BEAT_START_TIME) {
245             return HEART_BEAT_START_TIME;
246         } else if (timestamp == HEART_BEAT_START_TIME) {
247             return HEART_BEAT_START_TIME.add(EPOCH_PERIOD);
248         } else {
249             return epochStartTimeFromTimestamp(timestamp).add(EPOCH_PERIOD);
250         }
251     }
252 
253     /**
254         @notice Calculates current epoch value from the block timestamp
255         @dev Calculates the nth 8-hour window frame since the heartbeat's start time
256         @return uint256 : Current epoch value
257     */
258     function currentEpoch() public view returns (uint256) {
259         return epochFromTimestamp(block.timestamp);// solhint-disable-line not-rely-on-time
260     }
261 
262 }
263 
264 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
265 
266 pragma solidity ^0.7.0;
267 
268 /**
269  * @dev Interface of the ERC20 standard as defined in the EIP.
270  */
271 interface IERC20 {
272     /**
273      * @dev Returns the amount of tokens in existence.
274      */
275     function totalSupply() external view returns (uint256);
276 
277     /**
278      * @dev Returns the amount of tokens owned by `account`.
279      */
280     function balanceOf(address account) external view returns (uint256);
281 
282     /**
283      * @dev Moves `amount` tokens from the caller's account to `recipient`.
284      *
285      * Returns a boolean value indicating whether the operation succeeded.
286      *
287      * Emits a {Transfer} event.
288      */
289     function transfer(address recipient, uint256 amount) external returns (bool);
290 
291     /**
292      * @dev Returns the remaining number of tokens that `spender` will be
293      * allowed to spend on behalf of `owner` through {transferFrom}. This is
294      * zero by default.
295      *
296      * This value changes when {approve} or {transferFrom} are called.
297      */
298     function allowance(address owner, address spender) external view returns (uint256);
299 
300     /**
301      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
302      *
303      * Returns a boolean value indicating whether the operation succeeded.
304      *
305      * IMPORTANT: Beware that changing an allowance with this method brings the risk
306      * that someone may use both the old and the new allowance by unfortunate
307      * transaction ordering. One possible solution to mitigate this race
308      * condition is to first reduce the spender's allowance to 0 and set the
309      * desired value afterwards:
310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311      *
312      * Emits an {Approval} event.
313      */
314     function approve(address spender, uint256 amount) external returns (bool);
315 
316     /**
317      * @dev Moves `amount` tokens from `sender` to `recipient` using the
318      * allowance mechanism. `amount` is then deducted from the caller's
319      * allowance.
320      *
321      * Returns a boolean value indicating whether the operation succeeded.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
326 
327     /**
328      * @dev Emitted when `value` tokens are moved from one account (`from`) to
329      * another (`to`).
330      *
331      * Note that `value` may be zero.
332      */
333     event Transfer(address indexed from, address indexed to, uint256 value);
334 
335     /**
336      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
337      * a call to {approve}. `value` is the new allowance.
338      */
339     event Approval(address indexed owner, address indexed spender, uint256 value);
340 }
341 
342 // File: @openzeppelin/contracts/utils/Address.sol
343 
344 pragma solidity ^0.7.0;
345 
346 /**
347  * @dev Collection of functions related to the address type
348  */
349 library Address {
350     /**
351      * @dev Returns true if `account` is a contract.
352      *
353      * [IMPORTANT]
354      * ====
355      * It is unsafe to assume that an address for which this function returns
356      * false is an externally-owned account (EOA) and not a contract.
357      *
358      * Among others, `isContract` will return false for the following
359      * types of addresses:
360      *
361      *  - an externally-owned account
362      *  - a contract in construction
363      *  - an address where a contract will be created
364      *  - an address where a contract lived, but was destroyed
365      * ====
366      */
367     function isContract(address account) internal view returns (bool) {
368         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
369         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
370         // for accounts without code, i.e. `keccak256('')`
371         bytes32 codehash;
372         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
373         // solhint-disable-next-line no-inline-assembly
374         assembly { codehash := extcodehash(account) }
375         return (codehash != accountHash && codehash != 0x0);
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
398         (bool success, ) = recipient.call{ value: amount }("");
399         require(success, "Address: unable to send value, recipient may have reverted");
400     }
401 
402     /**
403      * @dev Performs a Solidity function call using a low level `call`. A
404      * plain`call` is an unsafe replacement for a function call: use this
405      * function instead.
406      *
407      * If `target` reverts with a revert reason, it is bubbled up by this
408      * function (like regular Solidity function calls).
409      *
410      * Returns the raw returned data. To convert to the expected return value,
411      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
412      *
413      * Requirements:
414      *
415      * - `target` must be a contract.
416      * - calling `target` with `data` must not revert.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
421       return functionCall(target, data, "Address: low-level call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
426      * `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
431         return _functionCallWithValue(target, data, 0, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but also transferring `value` wei to `target`.
437      *
438      * Requirements:
439      *
440      * - the calling contract must have an ETH balance of at least `value`.
441      * - the called Solidity function must be `payable`.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
446         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
451      * with `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
456         require(address(this).balance >= value, "Address: insufficient balance for call");
457         return _functionCallWithValue(target, data, value, errorMessage);
458     }
459 
460     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
461         require(isContract(target), "Address: call to non-contract");
462 
463         // solhint-disable-next-line avoid-low-level-calls
464         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
465         if (success) {
466             return returndata;
467         } else {
468             // Look for revert reason and bubble it up if present
469             if (returndata.length > 0) {
470                 // The easiest way to bubble the revert reason is using memory via assembly
471 
472                 // solhint-disable-next-line no-inline-assembly
473                 assembly {
474                     let returndata_size := mload(returndata)
475                     revert(add(32, returndata), returndata_size)
476                 }
477             } else {
478                 revert(errorMessage);
479             }
480         }
481     }
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
485 
486 pragma solidity ^0.7.0;
487 
488 
489 
490 
491 /**
492  * @title SafeERC20
493  * @dev Wrappers around ERC20 operations that throw on failure (when the token
494  * contract returns false). Tokens that return no value (and instead revert or
495  * throw on failure) are also supported, non-reverting calls are assumed to be
496  * successful.
497  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
498  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
499  */
500 library SafeERC20 {
501     using SafeMath for uint256;
502     using Address for address;
503 
504     function safeTransfer(IERC20 token, address to, uint256 value) internal {
505         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
506     }
507 
508     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
509         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
510     }
511 
512     /**
513      * @dev Deprecated. This function has issues similar to the ones found in
514      * {IERC20-approve}, and its usage is discouraged.
515      *
516      * Whenever possible, use {safeIncreaseAllowance} and
517      * {safeDecreaseAllowance} instead.
518      */
519     function safeApprove(IERC20 token, address spender, uint256 value) internal {
520         // safeApprove should only be called when setting an initial allowance,
521         // or when resetting it to zero. To increase and decrease it, use
522         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
523         // solhint-disable-next-line max-line-length
524         require((value == 0) || (token.allowance(address(this), spender) == 0),
525             "SafeERC20: approve from non-zero to non-zero allowance"
526         );
527         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
528     }
529 
530     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
531         uint256 newAllowance = token.allowance(address(this), spender).add(value);
532         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
533     }
534 
535     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
536         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
537         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
538     }
539 
540     /**
541      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
542      * on the return value: the return value is optional (but if data is returned, it must not be false).
543      * @param token The token targeted by the call.
544      * @param data The call data (encoded using abi.encode or one of its variants).
545      */
546     function _callOptionalReturn(IERC20 token, bytes memory data) private {
547         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
548         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
549         // the target address contains contract code and also asserts for success in the low-level call.
550 
551         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
552         if (returndata.length > 0) { // Return data is optional
553             // solhint-disable-next-line max-line-length
554             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
555         }
556     }
557 }
558 
559 // File: contracts/farming/LPTokenWrapper.sol
560 
561 pragma solidity 0.7.5;
562 
563 
564 
565 
566 
567 /** @title LPTokenWrapper
568     @author Lendroid Foundation
569     @notice Tracks the state of the LP Token staked / unstaked both in total
570         and on a per account basis.
571     @dev Audit certificate : https://certificate.quantstamp.com/view/lendroid-whalestreet
572 */
573 
574 
575 // solhint-disable-next-line
576 abstract contract LPTokenWrapper {
577     using SafeMath for uint256;
578     using SafeERC20 for IERC20;
579     using Address for address;
580 
581     IERC20 public lpToken;
582 
583     uint256 private _totalSupply;
584     mapping(address => uint256) private _balances;
585 
586     /**
587         @notice Registers the LP Token address
588         @param lpTokenAddress : address of the LP Token
589     */
590     // solhint-disable-next-line func-visibility
591     constructor(address lpTokenAddress) {
592         require(lpTokenAddress.isContract(), "invalid lpTokenAddress");
593         lpToken = IERC20(lpTokenAddress);
594     }
595 
596     /**
597         @notice Displays the total LP Token staked
598         @return uint256 : value of the _totalSupply which stores total LP Tokens staked
599     */
600     function totalSupply() public view returns (uint256) {
601         return _totalSupply;
602     }
603 
604     /**
605         @notice Displays LP Token staked per account
606         @param account : address of a user account
607         @return uint256 : total LP staked by given account address
608     */
609     function balanceOf(address account) public view returns (uint256) {
610         return _balances[account];
611     }
612 
613     /**
614         @notice Stake / Deposit LP Token into the Pool
615         @dev : Increases count of total LP Token staked.
616                Increases count of LP Token staked for the msg.sender.
617                LP Token is transferred from msg.sender to the Pool.
618         @param amount : Amount of LP Token to stake
619     */
620     function stake(uint256 amount) public virtual {
621         _totalSupply = _totalSupply.add(amount);
622         _balances[msg.sender] = _balances[msg.sender].add(amount);
623         lpToken.safeTransferFrom(msg.sender, address(this), amount);
624     }
625 
626     /**
627         @notice Unstake / Withdraw staked LP Token from the Pool
628         @dev : Decreases count of total LP Token staked
629                Decreases count of LP Token staked for the msg.sender
630                LP Token is transferred from the Pool to the msg.sender
631         @param amount : Amount of LP Token to withdraw / unstake
632     */
633     function unstake(uint256 amount) public virtual {
634         _totalSupply = _totalSupply.sub(amount);
635         _balances[msg.sender] = _balances[msg.sender].sub(amount);
636         lpToken.safeTransfer(msg.sender, amount);
637     }
638 }
639 
640 // File: contracts/farming/BasePool.sol
641 
642 pragma solidity 0.7.5;
643 
644 
645 
646 
647 
648 /** @title BasePool
649     @author Lendroid Foundation
650     @notice Inherits the LPTokenWrapper contract, performs additional functions
651         on the stake and unstake functions, and includes logic to calculate and
652         withdraw rewards.
653         This contract is inherited by all Pool contracts.
654     @dev Audit certificate : https://certificate.quantstamp.com/view/lendroid-whalestreet
655 */
656 
657 
658 // solhint-disable-next-line
659 abstract contract BasePool is LPTokenWrapper, Pacemaker {
660     using SafeMath for uint256;
661     using SafeERC20 for IERC20;
662     using Address for address;
663 
664     string public poolName;
665     IERC20 public rewardToken;
666 
667     uint256 public lastUpdateTime;
668     uint256 public cachedRewardPerStake;
669 
670     mapping(address => uint256) public userRewardPerStakePaid;
671     mapping(address => uint256) public lastEpochStaked;
672     mapping(address => uint256) public rewards;
673 
674     uint256 public startTime = HEART_BEAT_START_TIME;// 2020-12-04 00:00:00 (UTC UTC +00:00)
675 
676     event Staked(address indexed user, uint256 amount);
677     event Unstaked(address indexed user, uint256 amount);
678     event RewardClaimed(address indexed user, uint256 reward);
679 
680     /**
681         @notice Registers the Pool name, Reward Token address, and LP Token address.
682         @param name : Name of the Pool
683         @param rewardTokenAddress : address of the Reward Token
684         @param lpTokenAddress : address of the LP Token
685     */
686     // solhint-disable-next-line func-visibility
687     constructor(string memory name, address rewardTokenAddress, address lpTokenAddress) LPTokenWrapper(lpTokenAddress) {
688         require(rewardTokenAddress.isContract(), "invalid rewardTokenAddress");
689         rewardToken = IERC20(rewardTokenAddress);
690         // It's OK for the pool name to be empty.
691         poolName = name;
692     }
693 
694     /**
695         @notice modifier to check if the startTime has been reached
696         @dev Pacemaker.currentEpoch() returns values > 0 only from
697             HEART_BEAT_START_TIME+1. Therefore, staking is possible only from
698             epoch 1
699     */
700     modifier checkStart() {
701         // solhint-disable-next-line not-rely-on-time
702         require(block.timestamp > startTime, "startTime has not been reached");
703         _;
704     }
705 
706     /**
707         @notice Unstake the staked LP Token and claim corresponding earnings from the Pool
708         @dev : Perform actions from unstake()
709                Perform actions from claim()
710     */
711     function unstakeAndClaim() external updateRewards(msg.sender) checkStart {
712         unstake(balanceOf(msg.sender));
713         claim();
714     }
715 
716     /**
717         @notice Displays reward tokens per Lp token staked. Useful to display APY on the frontend
718     */
719     function rewardPerStake() public view returns (uint256) {
720         if (totalSupply() == 0) {
721             return cachedRewardPerStake;
722         }
723         // solhint-disable-next-line not-rely-on-time
724         return cachedRewardPerStake.add(block.timestamp.sub(lastUpdateTime).mul(
725                 rewardRate(currentEpoch())).mul(1e18).div(totalSupply())
726             );
727     }
728 
729     /**
730         @notice Displays earnings of an address so far. Useful to display claimable rewards on the frontend
731         @param account : the given user address
732         @return earnings of given address
733     */
734     function earned(address account) public view returns (uint256) {
735         return balanceOf(account).mul(rewardPerStake().sub(
736             userRewardPerStakePaid[account])).div(1e18).add(rewards[account]);
737     }
738 
739     /**
740         @notice modifier to update system and user info whenever a user makes a
741             function call to stake, unstake, claim or unstakeAndClaim.
742         @dev Updates rewardPerStake and time when system is updated
743             Recalculates user rewards
744     */
745     modifier updateRewards(address account) {
746         cachedRewardPerStake = rewardPerStake();
747         lastUpdateTime = block.timestamp;// solhint-disable-line not-rely-on-time
748         rewards[account] = earned(account);
749         userRewardPerStakePaid[account] = cachedRewardPerStake;
750         _;
751     }
752 
753     /**
754         @notice Displays reward tokens per second for a given epoch. This
755         function is implemented in contracts that inherit this contract.
756     */
757     function rewardRate(uint256 epoch) public pure virtual returns (uint256);
758 
759     /**
760         @notice Stake / Deposit LP Token into the Pool.
761         @dev Increases count of total LP Token staked in the current epoch.
762              Increases count of LP Token staked for the caller in the current epoch.
763              Register that caller last staked in the current epoch.
764              Perform actions from BasePool.stake().
765         @param amount : Amount of LP Token to stake
766     */
767     function stake(uint256 amount) public checkStart updateRewards(msg.sender) override {
768         require(amount > 0, "Cannot stake 0");
769         lastEpochStaked[msg.sender] = currentEpoch();
770         super.stake(amount);
771         emit Staked(msg.sender, amount);
772     }
773 
774     /**
775         @notice Unstake / Withdraw staked LP Token from the Pool
776         @inheritdoc LPTokenWrapper
777     */
778     function unstake(uint256 amount) public checkStart updateRewards(msg.sender) override {
779         require(amount > 0, "Cannot unstake 0");
780         require(lastEpochStaked[msg.sender] < currentEpoch(), "Cannot unstake in staked epoch.");
781         super.unstake(amount);
782         emit Unstaked(msg.sender, amount);
783     }
784 
785     /**
786         @notice Transfers earnings from previous epochs to the caller
787     */
788     function claim() public checkStart updateRewards(msg.sender) {
789         require(rewards[msg.sender] > 0, "No rewards to claim");
790         uint256 rewardsEarned = rewards[msg.sender];
791         rewards[msg.sender] = 0;
792         rewardToken.safeTransfer(msg.sender, rewardsEarned);
793         emit RewardClaimed(msg.sender, rewardsEarned);
794     }
795 
796 }
797 
798 // File: contracts/farming/B20ETHUNIV2B20Pool.sol
799 
800 pragma solidity 0.7.5;
801 
802 
803 
804 /** @title UNIV2SHRIMPPool
805     @author Lendroid Foundation
806     @notice Inherits the BasePool contract, and contains reward distribution
807         logic for the B20 token.
808 */
809 
810 
811 // solhint-disable-next-line
812 contract B20ETHUNIV2B20Pool is BasePool {
813 
814     using SafeMath for uint256;
815 
816     /**
817         @notice Registers the Pool name as B20ETHUNIV2B20Pool as Pool name,
818                 B20-WETH-UNIV2 as the LP Token, and
819                 B20 as the Reward Token.
820         @param rewardTokenAddress : B20 Token address
821         @param lpTokenAddress : B20-WETH-UNIV2 Token address
822     */
823     // solhint-disable-next-line func-visibility
824     constructor(address rewardTokenAddress, address lpTokenAddress) BasePool("B20ETHUNIV2B20Pool",
825         rewardTokenAddress, lpTokenAddress) {}// solhint-disable-line no-empty-blocks
826 
827     /**
828         @notice Displays total B20 rewards distributed per second in a given epoch.
829         @dev Series 1 :
830                 Epochs : 162-254
831                 Total B20 distributed : 32,812.50
832                 Distribution duration : 31 days and 8 hours (Jan 28:16:00 to Feb 29 59:59:59 GMT)
833             Series 2 :
834                 Epochs : 255-347
835                 Total B20 distributed : 18,750
836                 Distribution duration : 31 days (Mar 1 00:00:00 GMT to Mar 31 59:59:59 GMT)
837             Series 3 :
838                 Epochs : 348-437
839                 Total B20 distributed : 14,062.50
840                 Distribution duration : 30 days (Apr 1 00:00:00 GMT to Apr 30 59:59:59 GMT)
841             Series 4 :
842                 Epochs : 438-530
843                 Total B20 distributed : 9,375
844                 Distribution duration : 31 days (May 1 00:00:00 GMT to May 31 59:59:59 GMT)
845             Series 5 :
846                 Epochs : 531-620
847                 Total B20 distributed : 9,375
848                 Distribution duration : 30 days (Jun 1 00:00:00 GMT to Jun 30 59:59:59 GMT)
849             Series 6 :
850                 Epochs : 621-713
851                 Total B20 distributed : 9,375
852                 Distribution duration : 31 days (Jul 1 00:00:00 GMT to Jul 31 59:59:59 GMT)
853         @param epoch : 8-hour window number
854         @return B20 Tokens distributed per second during the given epoch
855     */
856     function rewardRate(uint256 epoch) public pure override returns (uint256) {
857         uint256 seriesRewards = 0;
858         require(epoch > 0, "epoch cannot be 0");
859         if (epoch > 161 && epoch <= 254) {
860             seriesRewards = 328125;// 32,812.50
861             return seriesRewards.mul(1e17).div(752 hours);
862         } else if (epoch > 254 && epoch <= 347) {
863             seriesRewards = 18750;// 10.8 M
864             return seriesRewards.mul(1e18).div(31 days);
865         } else if (epoch > 347 && epoch <= 437) {
866             seriesRewards = 140625;// 14,062.50
867             return seriesRewards.mul(1e17).div(30 days);
868         } else if (epoch > 437 && epoch <= 530) {
869             seriesRewards = 9375;// 9,375
870             return seriesRewards.mul(1e18).div(31 days);
871         } else if (epoch > 530 && epoch <= 620) {
872             seriesRewards = 9375;// 9,375
873             return seriesRewards.mul(1e18).div(30 days);
874         } else if (epoch > 620 && epoch <= 713) {
875             seriesRewards = 9375;// 9,375
876             return seriesRewards.mul(1e18).div(31 days);
877         } else {
878             return 0;
879         }
880     }
881 
882 }