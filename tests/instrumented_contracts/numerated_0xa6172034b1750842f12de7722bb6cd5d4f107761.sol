1 // File: contracts\interface\IStakingRewards.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity ^0.6.12;
5 
6 interface IStakingRewards {
7     // Views
8     function lastTimeRewardApplicable() external view returns (uint256);
9     
10     function rewardPerToken() external view returns (uint256);
11 
12     function earned(address account) external view returns (uint256, uint256);
13 
14     function getRewardForDuration() external view returns (uint256);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     // Mutative
21 
22     function stake(uint256 amount) external;
23 
24     function withdraw(uint256 amount) external;
25 
26     function getReward() external;
27 
28     function exit() external;
29 }
30 
31 // File: contracts\pool\RewardsDistributionRecipient.sol
32 
33 pragma solidity ^0.6.12;
34 
35 abstract contract RewardsDistributionRecipient {
36     address public rewardsDistribution;
37 
38     function notifyRewardAmount(uint256 reward, uint duration) external virtual;
39 
40     modifier onlyRewardsDistribution() {
41         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
42         _;
43     }
44 }
45 
46 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
47 
48 pragma solidity ^0.6.0;
49 
50 /**
51  * @dev Contract module that helps prevent reentrant calls to a function.
52  *
53  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
54  * available, which can be applied to functions to make sure there are no nested
55  * (reentrant) calls to them.
56  *
57  * Note that because there is a single `nonReentrant` guard, functions marked as
58  * `nonReentrant` may not call one another. This can be worked around by making
59  * those functions `private`, and then adding `external` `nonReentrant` entry
60  * points to them.
61  *
62  * TIP: If you would like to learn more about reentrancy and alternative ways
63  * to protect against it, check out our blog post
64  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
65  */
66 contract ReentrancyGuard {
67     // Booleans are more expensive than uint256 or any type that takes up a full
68     // word because each write operation emits an extra SLOAD to first read the
69     // slot's contents, replace the bits taken up by the boolean, and then write
70     // back. This is the compiler's defense against contract upgrades and
71     // pointer aliasing, and it cannot be disabled.
72 
73     // The values being non-zero value makes deployment a bit more expensive,
74     // but in exchange the refund on every call to nonReentrant will be lower in
75     // amount. Since refunds are capped to a percentage of the total
76     // transaction's gas, it is best to keep them low in cases like this one, to
77     // increase the likelihood of the full refund coming into effect.
78     uint256 private constant _NOT_ENTERED = 1;
79     uint256 private constant _ENTERED = 2;
80 
81     uint256 private _status;
82 
83     constructor () internal {
84         _status = _NOT_ENTERED;
85     }
86 
87     /**
88      * @dev Prevents a contract from calling itself, directly or indirectly.
89      * Calling a `nonReentrant` function from another `nonReentrant`
90      * function is not supported. It is possible to prevent this from happening
91      * by making the `nonReentrant` function external, and make it call a
92      * `private` function that does the actual work.
93      */
94     modifier nonReentrant() {
95         // On the first call to nonReentrant, _notEntered will be true
96         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
97 
98         // Any calls to nonReentrant after this point will fail
99         _status = _ENTERED;
100 
101         _;
102 
103         // By storing the original value once again, a refund is triggered (see
104         // https://eips.ethereum.org/EIPS/eip-2200)
105         _status = _NOT_ENTERED;
106     }
107 }
108 
109 // File: @openzeppelin\contracts\math\SafeMath.sol
110 
111 pragma solidity ^0.6.0;
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      *
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      *
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187         // benefit is lost if 'b' is also tested.
188         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
189         if (a == 0) {
190             return 0;
191         }
192 
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, "SafeMath: modulo by zero");
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin\contracts\math\Math.sol
270 
271 pragma solidity ^0.6.0;
272 
273 /**
274  * @dev Standard math utilities missing in the Solidity language.
275  */
276 library Math {
277     /**
278      * @dev Returns the largest of two numbers.
279      */
280     function max(uint256 a, uint256 b) internal pure returns (uint256) {
281         return a >= b ? a : b;
282     }
283 
284     /**
285      * @dev Returns the smallest of two numbers.
286      */
287     function min(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a < b ? a : b;
289     }
290 
291     /**
292      * @dev Returns the average of two numbers. The result is rounded towards
293      * zero.
294      */
295     function average(uint256 a, uint256 b) internal pure returns (uint256) {
296         // (a + b) / 2 can overflow, so we distribute
297         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
298     }
299 }
300 
301 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
302 
303 pragma solidity ^0.6.0;
304 
305 /**
306  * @dev Interface of the ERC20 standard as defined in the EIP.
307  */
308 interface IERC20 {
309     /**
310      * @dev Returns the amount of tokens in existence.
311      */
312     function totalSupply() external view returns (uint256);
313 
314     /**
315      * @dev Returns the amount of tokens owned by `account`.
316      */
317     function balanceOf(address account) external view returns (uint256);
318 
319     /**
320      * @dev Moves `amount` tokens from the caller's account to `recipient`.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * Emits a {Transfer} event.
325      */
326     function transfer(address recipient, uint256 amount) external returns (bool);
327 
328     /**
329      * @dev Returns the remaining number of tokens that `spender` will be
330      * allowed to spend on behalf of `owner` through {transferFrom}. This is
331      * zero by default.
332      *
333      * This value changes when {approve} or {transferFrom} are called.
334      */
335     function allowance(address owner, address spender) external view returns (uint256);
336 
337     /**
338      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
339      *
340      * Returns a boolean value indicating whether the operation succeeded.
341      *
342      * IMPORTANT: Beware that changing an allowance with this method brings the risk
343      * that someone may use both the old and the new allowance by unfortunate
344      * transaction ordering. One possible solution to mitigate this race
345      * condition is to first reduce the spender's allowance to 0 and set the
346      * desired value afterwards:
347      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
348      *
349      * Emits an {Approval} event.
350      */
351     function approve(address spender, uint256 amount) external returns (bool);
352 
353     /**
354      * @dev Moves `amount` tokens from `sender` to `recipient` using the
355      * allowance mechanism. `amount` is then deducted from the caller's
356      * allowance.
357      *
358      * Returns a boolean value indicating whether the operation succeeded.
359      *
360      * Emits a {Transfer} event.
361      */
362     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
363 
364     /**
365      * @dev Emitted when `value` tokens are moved from one account (`from`) to
366      * another (`to`).
367      *
368      * Note that `value` may be zero.
369      */
370     event Transfer(address indexed from, address indexed to, uint256 value);
371 
372     /**
373      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
374      * a call to {approve}. `value` is the new allowance.
375      */
376     event Approval(address indexed owner, address indexed spender, uint256 value);
377 }
378 
379 
380 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
381 
382 pragma solidity ^0.6.2;
383 
384 /**
385  * @dev Collection of functions related to the address type
386  */
387 library Address {
388     /**
389      * @dev Returns true if `account` is a contract.
390      *
391      * [IMPORTANT]
392      * ====
393      * It is unsafe to assume that an address for which this function returns
394      * false is an externally-owned account (EOA) and not a contract.
395      *
396      * Among others, `isContract` will return false for the following
397      * types of addresses:
398      *
399      *  - an externally-owned account
400      *  - a contract in construction
401      *  - an address where a contract will be created
402      *  - an address where a contract lived, but was destroyed
403      * ====
404      */
405     function isContract(address account) internal view returns (bool) {
406         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
407         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
408         // for accounts without code, i.e. `keccak256('')`
409         bytes32 codehash;
410         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
411         // solhint-disable-next-line no-inline-assembly
412         assembly { codehash := extcodehash(account) }
413         return (codehash != accountHash && codehash != 0x0);
414     }
415 
416     /**
417      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
418      * `recipient`, forwarding all available gas and reverting on errors.
419      *
420      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
421      * of certain opcodes, possibly making contracts go over the 2300 gas limit
422      * imposed by `transfer`, making them unable to receive funds via
423      * `transfer`. {sendValue} removes this limitation.
424      *
425      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
426      *
427      * IMPORTANT: because control is transferred to `recipient`, care must be
428      * taken to not create reentrancy vulnerabilities. Consider using
429      * {ReentrancyGuard} or the
430      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
431      */
432     function sendValue(address payable recipient, uint256 amount) internal {
433         require(address(this).balance >= amount, "Address: insufficient balance");
434 
435         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
436         (bool success, ) = recipient.call{ value: amount }("");
437         require(success, "Address: unable to send value, recipient may have reverted");
438     }
439 
440     /**
441      * @dev Performs a Solidity function call using a low level `call`. A
442      * plain`call` is an unsafe replacement for a function call: use this
443      * function instead.
444      *
445      * If `target` reverts with a revert reason, it is bubbled up by this
446      * function (like regular Solidity function calls).
447      *
448      * Returns the raw returned data. To convert to the expected return value,
449      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
450      *
451      * Requirements:
452      *
453      * - `target` must be a contract.
454      * - calling `target` with `data` must not revert.
455      *
456      * _Available since v3.1._
457      */
458     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
459       return functionCall(target, data, "Address: low-level call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
464      * `errorMessage` as a fallback revert reason when `target` reverts.
465      *
466      * _Available since v3.1._
467      */
468     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
469         return _functionCallWithValue(target, data, 0, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but also transferring `value` wei to `target`.
475      *
476      * Requirements:
477      *
478      * - the calling contract must have an ETH balance of at least `value`.
479      * - the called Solidity function must be `payable`.
480      *
481      * _Available since v3.1._
482      */
483     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
484         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
489      * with `errorMessage` as a fallback revert reason when `target` reverts.
490      *
491      * _Available since v3.1._
492      */
493     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
494         require(address(this).balance >= value, "Address: insufficient balance for call");
495         return _functionCallWithValue(target, data, value, errorMessage);
496     }
497 
498     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
499         require(isContract(target), "Address: call to non-contract");
500 
501         // solhint-disable-next-line avoid-low-level-calls
502         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
503         if (success) {
504             return returndata;
505         } else {
506             // Look for revert reason and bubble it up if present
507             if (returndata.length > 0) {
508                 // The easiest way to bubble the revert reason is using memory via assembly
509 
510                 // solhint-disable-next-line no-inline-assembly
511                 assembly {
512                     let returndata_size := mload(returndata)
513                     revert(add(32, returndata), returndata_size)
514                 }
515             } else {
516                 revert(errorMessage);
517             }
518         }
519     }
520 }
521 
522 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
523 
524 pragma solidity ^0.6.0;
525 
526 
527 /**
528  * @title SafeERC20
529  * @dev Wrappers around ERC20 operations that throw on failure (when the token
530  * contract returns false). Tokens that return no value (and instead revert or
531  * throw on failure) are also supported, non-reverting calls are assumed to be
532  * successful.
533  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
534  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
535  */
536 library SafeERC20 {
537     using SafeMath for uint256;
538     using Address for address;
539 
540     function safeTransfer(IERC20 token, address to, uint256 value) internal {
541         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
542     }
543 
544     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
545         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
546     }
547 
548     /**
549      * @dev Deprecated. This function has issues similar to the ones found in
550      * {IERC20-approve}, and its usage is discouraged.
551      *
552      * Whenever possible, use {safeIncreaseAllowance} and
553      * {safeDecreaseAllowance} instead.
554      */
555     function safeApprove(IERC20 token, address spender, uint256 value) internal {
556         // safeApprove should only be called when setting an initial allowance,
557         // or when resetting it to zero. To increase and decrease it, use
558         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
559         // solhint-disable-next-line max-line-length
560         require((value == 0) || (token.allowance(address(this), spender) == 0),
561             "SafeERC20: approve from non-zero to non-zero allowance"
562         );
563         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
564     }
565 
566     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
567         uint256 newAllowance = token.allowance(address(this), spender).add(value);
568         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
569     }
570 
571     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
572         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
573         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
574     }
575 
576     /**
577      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
578      * on the return value: the return value is optional (but if data is returned, it must not be false).
579      * @param token The token targeted by the call.
580      * @param data The call data (encoded using abi.encode or one of its variants).
581      */
582     function _callOptionalReturn(IERC20 token, bytes memory data) private {
583         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
584         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
585         // the target address contains contract code and also asserts for success in the low-level call.
586 
587         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
588         if (returndata.length > 0) { // Return data is optional
589             // solhint-disable-next-line max-line-length
590             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
591         }
592     }
593 }
594 
595 // File: contracts\pool\StakingRewardsLock.sol
596 
597 pragma solidity ^0.6.12;
598 
599 contract StakingRewardsLock is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
600 
601     using SafeMath for uint;
602     using Math for uint;
603     using SafeERC20 for IERC20;
604 
605     IERC20 public rewardsToken;
606     IERC20 public stakingToken;
607     uint256 public periodFinish = 0;
608     uint256 public rewardRate = 0;
609     uint256 public rewardsDuration;
610     uint256 public lastUpdateTime;
611     uint256 public rewardPerTokenStored;
612     uint256 public lockDuration;
613 
614     mapping(address => uint256) public userRewardPerTokenPaid;
615     mapping(address => uint256) public unlockRewards;
616     mapping(address => uint256) public lockRewards;
617     mapping(address => uint256) public userLockTime;
618 
619     uint256 private _totalSupply;
620     mapping(address => uint256) private _balances;
621 
622     uint public unlockPercent;
623     uint public lockPercent;
624 
625     constructor(
626         address _rewardsDistribution,
627         address _rewardsToken,
628         address _stakingToken,
629         uint256 _lockDuration,
630         uint256 _unlockPercent,
631         uint256 _lockPercent
632     ) public {
633         rewardsToken = IERC20(_rewardsToken);
634         stakingToken = IERC20(_stakingToken);
635         rewardsDistribution = _rewardsDistribution;
636         lockDuration = _lockDuration;
637         unlockPercent = _unlockPercent;
638         lockPercent = _lockPercent;
639     }
640 
641     /* ========== VIEWS ========== */
642 
643     function totalSupply() external override view returns (uint256) {
644         return _totalSupply;
645     }
646 
647     function balanceOf(address account) external override view returns (uint256) {
648         return _balances[account];
649     }
650 
651     function lastTimeRewardApplicable() public override view returns (uint256) {
652         return Math.min(block.timestamp, periodFinish);
653     }
654 
655     function rewardPerToken() public override view returns (uint256) {
656         if (_totalSupply == 0) {
657             return rewardPerTokenStored;
658         }
659         return
660             rewardPerTokenStored.add(
661                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
662             );
663     }
664 
665     function earned(address account) public override view returns (uint256, uint256) {
666         uint earnedToken = earnedDuration(account);
667         if(block.timestamp >= userLockTime[account]) {
668             uint unlockAmount = unlockRewards[account].add(lockRewards[account]).add(earnedToken);
669             return (unlockAmount, 0);
670         } else {
671             uint unlockAmount = unlockRewards[account].add(earnedToken.mul(unlockPercent).div(100));
672             uint lockAmount = lockRewards[account].add(earnedToken.mul(lockPercent).div(100));
673             return (unlockAmount, lockAmount);
674         }
675     }
676 
677 
678     function earnedDuration(address account) internal view returns (uint256) {
679         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18);
680     }
681 
682     function getRewardForDuration() external override view returns (uint256) {
683         return rewardRate.mul(rewardsDuration);
684     }
685 
686     /* ========== MUTATIVE FUNCTIONS ========== */
687 
688     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
689         require(amount > 0, "Cannot stake 0");
690         if (userLockTime[msg.sender] == 0) {
691             userLockTime[msg.sender] = block.timestamp.add(lockDuration);
692         }
693         _totalSupply = _totalSupply.add(amount);
694         _balances[msg.sender] = _balances[msg.sender].add(amount);
695 
696         // permit
697         IBORERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
698 
699         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
700         emit Staked(msg.sender, amount);
701     }
702 
703     function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
704         require(amount > 0, "Cannot stake 0");
705         if (userLockTime[msg.sender] == 0) {
706             userLockTime[msg.sender] = block.timestamp.add(lockDuration);
707         }
708         _totalSupply = _totalSupply.add(amount);
709         _balances[msg.sender] = _balances[msg.sender].add(amount);
710         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
711         emit Staked(msg.sender, amount);
712     }
713 
714     function withdraw(uint256 amount) public override virtual nonReentrant updateReward(msg.sender) {
715         require(amount > 0, "Cannot withdraw 0");
716         _totalSupply = _totalSupply.sub(amount);
717         _balances[msg.sender] = _balances[msg.sender].sub(amount);
718         stakingToken.safeTransfer(msg.sender, amount);
719         emit Withdrawn(msg.sender, amount);
720     }
721 
722     function getReward() public override nonReentrant updateReward(msg.sender) {
723         uint256 reward = unlockRewards[msg.sender];
724         if (reward > 0) {
725             unlockRewards[msg.sender] = 0;
726             rewardsToken.safeTransfer(msg.sender, reward);
727             emit RewardPaid(msg.sender, reward);
728         }
729     }
730 
731     function exit() external override {
732         withdraw(_balances[msg.sender]);
733         getReward();
734     }
735 
736     /* ========== RESTRICTED FUNCTIONS ========== */
737 
738     function notifyRewardAmount(uint256 reward, uint duration) external override onlyRewardsDistribution updateReward(address(0)) {
739         rewardsDuration = duration;
740         if (block.timestamp >= periodFinish) { 
741             rewardRate = reward.div(rewardsDuration);
742         } else {
743             uint256 remaining = periodFinish.sub(block.timestamp);
744             uint256 leftover = remaining.mul(rewardRate);
745             rewardRate = reward.add(leftover).div(rewardsDuration);
746         }
747 
748         // Ensure the provided reward amount is not more than the balance in the contract.
749         // This keeps the reward rate in the right range, preventing overflows due to
750         // very high values of rewardRate in the earned and rewardsPerToken functions;
751         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
752         uint balance = rewardsToken.balanceOf(address(this));
753         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
754 
755         lastUpdateTime = block.timestamp;
756         periodFinish = block.timestamp.add(rewardsDuration);
757         emit RewardAdded(reward);
758     }
759 
760     /* ========== MODIFIERS ========== */
761 
762     modifier updateReward(address account) {
763         rewardPerTokenStored = rewardPerToken();
764         lastUpdateTime = lastTimeRewardApplicable();
765         if (account != address(0)) {
766             (uint unlock, uint lock) = earned(account);
767             unlockRewards[account] = unlock;
768             lockRewards[account] = lock;
769             userRewardPerTokenPaid[account] = rewardPerTokenStored;
770         }
771         _;
772     }
773 
774     /* ========== EVENTS ========== */
775 
776     event RewardAdded(uint256 reward);
777     event Staked(address indexed user, uint256 amount);
778     event Withdrawn(address indexed user, uint256 amount);
779     event RewardPaid(address indexed user, uint256 reward);
780 
781 
782 
783 }
784 
785 interface IBORERC20 {
786     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
787 }
788 
789 // File: contracts\interface\IOracle.sol
790 
791 pragma solidity ^0.6.12;
792 
793 interface IOracle {
794     
795     function setPrice(bytes32 _symbol, uint _price) external;
796     function getPrice(bytes32 _symbol) external view returns (uint);
797 }
798 
799 // File: contracts\lib\SafeDecimalMath.sol
800 
801 pragma solidity ^0.6.8;
802 
803 // Libraries
804 
805 
806 // https://docs.synthetix.io/contracts/SafeDecimalMath
807 library SafeDecimalMath {
808     using SafeMath for uint;
809 
810     /* Number of decimal places in the representations. */
811     uint8 public constant decimals = 18;
812     uint8 public constant highPrecisionDecimals = 27;
813 
814     /* The number representing 1.0. */
815     uint public constant UNIT = 10**uint(decimals);
816 
817     /* The number representing 1.0 for higher fidelity numbers. */
818     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
819     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
820 
821     /**
822      * @return Provides an interface to UNIT.
823      */
824     function unit() external pure returns (uint) {
825         return UNIT;
826     }
827 
828     /**
829      * @return Provides an interface to PRECISE_UNIT.
830      */
831     function preciseUnit() external pure returns (uint) {
832         return PRECISE_UNIT;
833     }
834 
835     /**
836      * @return The result of multiplying x and y, interpreting the operands as fixed-point
837      * decimals.
838      *
839      * @dev A unit factor is divided out after the product of x and y is evaluated,
840      * so that product must be less than 2**256. As this is an integer division,
841      * the internal division always rounds down. This helps save on gas. Rounding
842      * is more expensive on gas.
843      */
844     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
845         /* Divide by UNIT to remove the extra factor introduced by the product. */
846         return x.mul(y) / UNIT;
847     }
848 
849     /**
850      * @return The result of safely multiplying x and y, interpreting the operands
851      * as fixed-point decimals of the specified precision unit.
852      *
853      * @dev The operands should be in the form of a the specified unit factor which will be
854      * divided out after the product of x and y is evaluated, so that product must be
855      * less than 2**256.
856      *
857      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
858      * Rounding is useful when you need to retain fidelity for small decimal numbers
859      * (eg. small fractions or percentages).
860      */
861     function _multiplyDecimalRound(
862         uint x,
863         uint y,
864         uint precisionUnit
865     ) private pure returns (uint) {
866         /* Divide by UNIT to remove the extra factor introduced by the product. */
867         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
868 
869         if (quotientTimesTen % 10 >= 5) {
870             quotientTimesTen += 10;
871         }
872 
873         return quotientTimesTen / 10;
874     }
875 
876     /**
877      * @return The result of safely multiplying x and y, interpreting the operands
878      * as fixed-point decimals of a precise unit.
879      *
880      * @dev The operands should be in the precise unit factor which will be
881      * divided out after the product of x and y is evaluated, so that product must be
882      * less than 2**256.
883      *
884      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
885      * Rounding is useful when you need to retain fidelity for small decimal numbers
886      * (eg. small fractions or percentages).
887      */
888     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
889         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
890     }
891 
892     /**
893      * @return The result of safely multiplying x and y, interpreting the operands
894      * as fixed-point decimals of a standard unit.
895      *
896      * @dev The operands should be in the standard unit factor which will be
897      * divided out after the product of x and y is evaluated, so that product must be
898      * less than 2**256.
899      *
900      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
901      * Rounding is useful when you need to retain fidelity for small decimal numbers
902      * (eg. small fractions or percentages).
903      */
904     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
905         return _multiplyDecimalRound(x, y, UNIT);
906     }
907 
908     /**
909      * @return The result of safely dividing x and y. The return value is a high
910      * precision decimal.
911      *
912      * @dev y is divided after the product of x and the standard precision unit
913      * is evaluated, so the product of x and UNIT must be less than 2**256. As
914      * this is an integer division, the result is always rounded down.
915      * This helps save on gas. Rounding is more expensive on gas.
916      */
917     function divideDecimal(uint x, uint y) internal pure returns (uint) {
918         /* Reintroduce the UNIT factor that will be divided out by y. */
919         return x.mul(UNIT).div(y);
920     }
921 
922     /**
923      * @return The result of safely dividing x and y. The return value is as a rounded
924      * decimal in the precision unit specified in the parameter.
925      *
926      * @dev y is divided after the product of x and the specified precision unit
927      * is evaluated, so the product of x and the specified precision unit must
928      * be less than 2**256. The result is rounded to the nearest increment.
929      */
930     function _divideDecimalRound(
931         uint x,
932         uint y,
933         uint precisionUnit
934     ) private pure returns (uint) {
935         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
936 
937         if (resultTimesTen % 10 >= 5) {
938             resultTimesTen += 10;
939         }
940 
941         return resultTimesTen / 10;
942     }
943 
944     /**
945      * @return The result of safely dividing x and y. The return value is as a rounded
946      * standard precision decimal.
947      *
948      * @dev y is divided after the product of x and the standard precision unit
949      * is evaluated, so the product of x and the standard precision unit must
950      * be less than 2**256. The result is rounded to the nearest increment.
951      */
952     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
953         return _divideDecimalRound(x, y, UNIT);
954     }
955 
956     /**
957      * @return The result of safely dividing x and y. The return value is as a rounded
958      * high precision decimal.
959      *
960      * @dev y is divided after the product of x and the high precision unit
961      * is evaluated, so the product of x and the high precision unit must
962      * be less than 2**256. The result is rounded to the nearest increment.
963      */
964     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
965         return _divideDecimalRound(x, y, PRECISE_UNIT);
966     }
967 
968     /**
969      * @dev Convert a standard decimal representation to a high precision one.
970      */
971     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
972         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
973     }
974 
975     /**
976      * @dev Convert a high precision decimal to a standard decimal representation.
977      */
978     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
979         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
980 
981         if (quotientTimesTen % 10 >= 5) {
982             quotientTimesTen += 10;
983         }
984 
985         return quotientTimesTen / 10;
986     }
987 }
988 
989 // File: contracts\interface\ILiquidate.sol
990 
991 pragma solidity ^0.6.12;
992 
993 interface ILiquidate {
994     function liquidate(address account) external;
995 }
996 
997 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
998 
999 pragma solidity ^0.6.0;
1000 
1001 /*
1002  * @dev Provides information about the current execution context, including the
1003  * sender of the transaction and its data. While these are generally available
1004  * via msg.sender and msg.data, they should not be accessed in such a direct
1005  * manner, since when dealing with GSN meta-transactions the account sending and
1006  * paying for execution may not be the actual sender (as far as an application
1007  * is concerned).
1008  *
1009  * This contract is only required for intermediate, library-like contracts.
1010  */
1011 abstract contract Context {
1012     function _msgSender() internal view virtual returns (address payable) {
1013         return msg.sender;
1014     }
1015 
1016     function _msgData() internal view virtual returns (bytes memory) {
1017         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1018         return msg.data;
1019     }
1020 }
1021 
1022 // File: @openzeppelin\contracts\utils\Pausable.sol
1023 
1024 pragma solidity ^0.6.0;
1025 
1026 
1027 /**
1028  * @dev Contract module which allows children to implement an emergency stop
1029  * mechanism that can be triggered by an authorized account.
1030  *
1031  * This module is used through inheritance. It will make available the
1032  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1033  * the functions of your contract. Note that they will not be pausable by
1034  * simply including this module, only once the modifiers are put in place.
1035  */
1036 contract Pausable is Context {
1037     /**
1038      * @dev Emitted when the pause is triggered by `account`.
1039      */
1040     event Paused(address account);
1041 
1042     /**
1043      * @dev Emitted when the pause is lifted by `account`.
1044      */
1045     event Unpaused(address account);
1046 
1047     bool private _paused;
1048 
1049     /**
1050      * @dev Initializes the contract in unpaused state.
1051      */
1052     constructor () internal {
1053         _paused = false;
1054     }
1055 
1056     /**
1057      * @dev Returns true if the contract is paused, and false otherwise.
1058      */
1059     function paused() public view returns (bool) {
1060         return _paused;
1061     }
1062 
1063     /**
1064      * @dev Modifier to make a function callable only when the contract is not paused.
1065      *
1066      * Requirements:
1067      *
1068      * - The contract must not be paused.
1069      */
1070     modifier whenNotPaused() {
1071         require(!_paused, "Pausable: paused");
1072         _;
1073     }
1074 
1075     /**
1076      * @dev Modifier to make a function callable only when the contract is paused.
1077      *
1078      * Requirements:
1079      *
1080      * - The contract must be paused.
1081      */
1082     modifier whenPaused() {
1083         require(_paused, "Pausable: not paused");
1084         _;
1085     }
1086 
1087     /**
1088      * @dev Triggers stopped state.
1089      *
1090      * Requirements:
1091      *
1092      * - The contract must not be paused.
1093      */
1094     function _pause() internal virtual whenNotPaused {
1095         _paused = true;
1096         emit Paused(_msgSender());
1097     }
1098 
1099     /**
1100      * @dev Returns to normal state.
1101      *
1102      * Requirements:
1103      *
1104      * - The contract must be paused.
1105      */
1106     function _unpause() internal virtual whenPaused {
1107         _paused = false;
1108         emit Unpaused(_msgSender());
1109     }
1110 }
1111 
1112 // File: contracts\interface\IPause.sol
1113 
1114 pragma solidity ^0.6.12;
1115 
1116 interface IPause {
1117     function pause() external;
1118     function unpause() external;
1119 }
1120 
1121 // File: contracts\pool\SatellitePool.sol
1122 
1123 pragma solidity ^0.6.12;
1124 
1125 contract SatellitePool is StakingRewardsLock, ILiquidate, Pausable, IPause{
1126     using SafeDecimalMath for uint;
1127 
1128     address public liquidation;
1129     IOracle public oracle;
1130     bytes32 public stakingTokenSymbol;
1131     address public owner;
1132     uint256 public diffDecimal;
1133 
1134     constructor(
1135         address _liquidation,
1136         address _rewardsDistribution,
1137         address _rewardsToken,
1138         address _stakingToken,
1139         address _oracle,
1140         bytes32 _sts,
1141         uint256 _lockDuration,
1142         uint256 _unlockPercent,
1143         uint256 _lockPercent,
1144         address _owner,
1145         uint256 _diffDecimal
1146     ) public 
1147         StakingRewardsLock(_rewardsDistribution, _rewardsToken, _stakingToken, _lockDuration, _unlockPercent, _lockPercent)
1148     {
1149         liquidation = _liquidation;
1150         oracle = IOracle(_oracle);
1151         stakingTokenSymbol = _sts;
1152         owner = _owner;
1153         diffDecimal = _diffDecimal;
1154     }
1155 
1156     function liquidate(address account) public override onlyLiquidation {
1157         stakingToken.safeTransfer(account, stakingToken.balanceOf(address(this)));
1158     }
1159 
1160     function tvl() public view returns(uint){
1161         uint tokenAmount = stakingToken.balanceOf(address(this));
1162         uint price = oracle.getPrice(stakingTokenSymbol);
1163         return tokenAmount.mul(10**(diffDecimal)).multiplyDecimal(price);
1164     }
1165     
1166     function withdraw(uint amount) public override whenNotPaused{
1167         super.withdraw(amount);
1168     } 
1169 
1170     function pause() public override onlyLiquidation {
1171         _pause();
1172     }
1173 
1174     function unpause() public override onlyLiquidation {
1175         _unpause();
1176     }
1177 
1178     function setLiquidation(address liqui) public onlyOwner {
1179         liquidation = liqui;
1180     }
1181 
1182     modifier onlyLiquidation {
1183         require(msg.sender == liquidation, "caller is not liquidator");
1184         _;
1185     }
1186 
1187      modifier onlyOwner() {
1188         require(owner == msg.sender, "SatellitePool: caller is not the owner");
1189         _;
1190     }
1191 
1192     function transferOwnership(address newOwner) public onlyOwner {
1193         require(newOwner != address(0), "Ownable: new owner is the zero address");
1194         owner = newOwner;
1195     }
1196 }