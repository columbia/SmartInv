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
33 
34 pragma solidity ^0.6.12;
35 
36 abstract contract RewardsDistributionRecipient {
37     address public rewardsDistribution;
38 
39     function notifyRewardAmount(uint256 reward, uint duration) external virtual;
40 
41     modifier onlyRewardsDistribution() {
42         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
43         _;
44     }
45 }
46 
47 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
48 
49 
50 pragma solidity ^0.6.0;
51 
52 /**
53  * @dev Contract module that helps prevent reentrant calls to a function.
54  *
55  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
56  * available, which can be applied to functions to make sure there are no nested
57  * (reentrant) calls to them.
58  *
59  * Note that because there is a single `nonReentrant` guard, functions marked as
60  * `nonReentrant` may not call one another. This can be worked around by making
61  * those functions `private`, and then adding `external` `nonReentrant` entry
62  * points to them.
63  *
64  * TIP: If you would like to learn more about reentrancy and alternative ways
65  * to protect against it, check out our blog post
66  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
67  */
68 contract ReentrancyGuard {
69     // Booleans are more expensive than uint256 or any type that takes up a full
70     // word because each write operation emits an extra SLOAD to first read the
71     // slot's contents, replace the bits taken up by the boolean, and then write
72     // back. This is the compiler's defense against contract upgrades and
73     // pointer aliasing, and it cannot be disabled.
74 
75     // The values being non-zero value makes deployment a bit more expensive,
76     // but in exchange the refund on every call to nonReentrant will be lower in
77     // amount. Since refunds are capped to a percentage of the total
78     // transaction's gas, it is best to keep them low in cases like this one, to
79     // increase the likelihood of the full refund coming into effect.
80     uint256 private constant _NOT_ENTERED = 1;
81     uint256 private constant _ENTERED = 2;
82 
83     uint256 private _status;
84 
85     constructor () internal {
86         _status = _NOT_ENTERED;
87     }
88 
89     /**
90      * @dev Prevents a contract from calling itself, directly or indirectly.
91      * Calling a `nonReentrant` function from another `nonReentrant`
92      * function is not supported. It is possible to prevent this from happening
93      * by making the `nonReentrant` function external, and make it call a
94      * `private` function that does the actual work.
95      */
96     modifier nonReentrant() {
97         // On the first call to nonReentrant, _notEntered will be true
98         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
99 
100         // Any calls to nonReentrant after this point will fail
101         _status = _ENTERED;
102 
103         _;
104 
105         // By storing the original value once again, a refund is triggered (see
106         // https://eips.ethereum.org/EIPS/eip-2200)
107         _status = _NOT_ENTERED;
108     }
109 }
110 
111 // File: @openzeppelin\contracts\math\SafeMath.sol
112 
113 
114 pragma solidity ^0.6.0;
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      *
138      * - Addition cannot overflow.
139      */
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         require(c >= a, "SafeMath: addition overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `*` operator.
183      *
184      * Requirements:
185      *
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b > 0, errorMessage);
232         uint256 c = a / b;
233         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 // File: @openzeppelin\contracts\math\Math.sol
273 
274 
275 pragma solidity ^0.6.0;
276 
277 /**
278  * @dev Standard math utilities missing in the Solidity language.
279  */
280 library Math {
281     /**
282      * @dev Returns the largest of two numbers.
283      */
284     function max(uint256 a, uint256 b) internal pure returns (uint256) {
285         return a >= b ? a : b;
286     }
287 
288     /**
289      * @dev Returns the smallest of two numbers.
290      */
291     function min(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a < b ? a : b;
293     }
294 
295     /**
296      * @dev Returns the average of two numbers. The result is rounded towards
297      * zero.
298      */
299     function average(uint256 a, uint256 b) internal pure returns (uint256) {
300         // (a + b) / 2 can overflow, so we distribute
301         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
302     }
303 }
304 
305 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
306 
307 
308 pragma solidity ^0.6.0;
309 
310 /**
311  * @dev Interface of the ERC20 standard as defined in the EIP.
312  */
313 interface IERC20 {
314     /**
315      * @dev Returns the amount of tokens in existence.
316      */
317     function totalSupply() external view returns (uint256);
318 
319     /**
320      * @dev Returns the amount of tokens owned by `account`.
321      */
322     function balanceOf(address account) external view returns (uint256);
323 
324     /**
325      * @dev Moves `amount` tokens from the caller's account to `recipient`.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transfer(address recipient, uint256 amount) external returns (bool);
332 
333     /**
334      * @dev Returns the remaining number of tokens that `spender` will be
335      * allowed to spend on behalf of `owner` through {transferFrom}. This is
336      * zero by default.
337      *
338      * This value changes when {approve} or {transferFrom} are called.
339      */
340     function allowance(address owner, address spender) external view returns (uint256);
341 
342     /**
343      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * IMPORTANT: Beware that changing an allowance with this method brings the risk
348      * that someone may use both the old and the new allowance by unfortunate
349      * transaction ordering. One possible solution to mitigate this race
350      * condition is to first reduce the spender's allowance to 0 and set the
351      * desired value afterwards:
352      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
353      *
354      * Emits an {Approval} event.
355      */
356     function approve(address spender, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Moves `amount` tokens from `sender` to `recipient` using the
360      * allowance mechanism. `amount` is then deducted from the caller's
361      * allowance.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
368 
369     /**
370      * @dev Emitted when `value` tokens are moved from one account (`from`) to
371      * another (`to`).
372      *
373      * Note that `value` may be zero.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 value);
376 
377     /**
378      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
379      * a call to {approve}. `value` is the new allowance.
380      */
381     event Approval(address indexed owner, address indexed spender, uint256 value);
382 }
383 
384 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
385 
386 
387 pragma solidity ^0.6.2;
388 
389 /**
390  * @dev Collection of functions related to the address type
391  */
392 library Address {
393     /**
394      * @dev Returns true if `account` is a contract.
395      *
396      * [IMPORTANT]
397      * ====
398      * It is unsafe to assume that an address for which this function returns
399      * false is an externally-owned account (EOA) and not a contract.
400      *
401      * Among others, `isContract` will return false for the following
402      * types of addresses:
403      *
404      *  - an externally-owned account
405      *  - a contract in construction
406      *  - an address where a contract will be created
407      *  - an address where a contract lived, but was destroyed
408      * ====
409      */
410     function isContract(address account) internal view returns (bool) {
411         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
412         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
413         // for accounts without code, i.e. `keccak256('')`
414         bytes32 codehash;
415         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
416         // solhint-disable-next-line no-inline-assembly
417         assembly { codehash := extcodehash(account) }
418         return (codehash != accountHash && codehash != 0x0);
419     }
420 
421     /**
422      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
423      * `recipient`, forwarding all available gas and reverting on errors.
424      *
425      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
426      * of certain opcodes, possibly making contracts go over the 2300 gas limit
427      * imposed by `transfer`, making them unable to receive funds via
428      * `transfer`. {sendValue} removes this limitation.
429      *
430      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
431      *
432      * IMPORTANT: because control is transferred to `recipient`, care must be
433      * taken to not create reentrancy vulnerabilities. Consider using
434      * {ReentrancyGuard} or the
435      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
436      */
437     function sendValue(address payable recipient, uint256 amount) internal {
438         require(address(this).balance >= amount, "Address: insufficient balance");
439 
440         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
441         (bool success, ) = recipient.call{ value: amount }("");
442         require(success, "Address: unable to send value, recipient may have reverted");
443     }
444 
445     /**
446      * @dev Performs a Solidity function call using a low level `call`. A
447      * plain`call` is an unsafe replacement for a function call: use this
448      * function instead.
449      *
450      * If `target` reverts with a revert reason, it is bubbled up by this
451      * function (like regular Solidity function calls).
452      *
453      * Returns the raw returned data. To convert to the expected return value,
454      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
455      *
456      * Requirements:
457      *
458      * - `target` must be a contract.
459      * - calling `target` with `data` must not revert.
460      *
461      * _Available since v3.1._
462      */
463     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
464       return functionCall(target, data, "Address: low-level call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
469      * `errorMessage` as a fallback revert reason when `target` reverts.
470      *
471      * _Available since v3.1._
472      */
473     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
474         return _functionCallWithValue(target, data, 0, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but also transferring `value` wei to `target`.
480      *
481      * Requirements:
482      *
483      * - the calling contract must have an ETH balance of at least `value`.
484      * - the called Solidity function must be `payable`.
485      *
486      * _Available since v3.1._
487      */
488     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
489         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
494      * with `errorMessage` as a fallback revert reason when `target` reverts.
495      *
496      * _Available since v3.1._
497      */
498     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
499         require(address(this).balance >= value, "Address: insufficient balance for call");
500         return _functionCallWithValue(target, data, value, errorMessage);
501     }
502 
503     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
504         require(isContract(target), "Address: call to non-contract");
505 
506         // solhint-disable-next-line avoid-low-level-calls
507         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514 
515                 // solhint-disable-next-line no-inline-assembly
516                 assembly {
517                     let returndata_size := mload(returndata)
518                     revert(add(32, returndata), returndata_size)
519                 }
520             } else {
521                 revert(errorMessage);
522             }
523         }
524     }
525 }
526 
527 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
528 
529 
530 pragma solidity ^0.6.0;
531 
532 
533 
534 
535 /**
536  * @title SafeERC20
537  * @dev Wrappers around ERC20 operations that throw on failure (when the token
538  * contract returns false). Tokens that return no value (and instead revert or
539  * throw on failure) are also supported, non-reverting calls are assumed to be
540  * successful.
541  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
542  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
543  */
544 library SafeERC20 {
545     using SafeMath for uint256;
546     using Address for address;
547 
548     function safeTransfer(IERC20 token, address to, uint256 value) internal {
549         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
550     }
551 
552     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
553         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
554     }
555 
556     /**
557      * @dev Deprecated. This function has issues similar to the ones found in
558      * {IERC20-approve}, and its usage is discouraged.
559      *
560      * Whenever possible, use {safeIncreaseAllowance} and
561      * {safeDecreaseAllowance} instead.
562      */
563     function safeApprove(IERC20 token, address spender, uint256 value) internal {
564         // safeApprove should only be called when setting an initial allowance,
565         // or when resetting it to zero. To increase and decrease it, use
566         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
567         // solhint-disable-next-line max-line-length
568         require((value == 0) || (token.allowance(address(this), spender) == 0),
569             "SafeERC20: approve from non-zero to non-zero allowance"
570         );
571         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
572     }
573 
574     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
575         uint256 newAllowance = token.allowance(address(this), spender).add(value);
576         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
577     }
578 
579     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
580         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
581         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
582     }
583 
584     /**
585      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
586      * on the return value: the return value is optional (but if data is returned, it must not be false).
587      * @param token The token targeted by the call.
588      * @param data The call data (encoded using abi.encode or one of its variants).
589      */
590     function _callOptionalReturn(IERC20 token, bytes memory data) private {
591         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
592         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
593         // the target address contains contract code and also asserts for success in the low-level call.
594 
595         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
596         if (returndata.length > 0) { // Return data is optional
597             // solhint-disable-next-line max-line-length
598             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
599         }
600     }
601 }
602 
603 
604 // File: contracts\pool\StakingRewardsLock.sol
605 
606 
607 pragma solidity ^0.6.12;
608 
609 
610 contract StakingRewardsLock is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
611 
612     using SafeMath for uint;
613     using Math for uint;
614     using SafeERC20 for IERC20;
615 
616     IERC20 public rewardsToken;
617     IERC20 public stakingToken;
618     uint256 public periodFinish = 0;
619     uint256 public rewardRate = 0;
620     uint256 public rewardsDuration;
621     uint256 public lastUpdateTime;
622     uint256 public rewardPerTokenStored;
623     uint256 public lockDuration;
624 
625     mapping(address => uint256) public userRewardPerTokenPaid;
626     mapping(address => uint256) public unlockRewards;
627     mapping(address => uint256) public lockRewards;
628     mapping(address => uint256) public userLockTime;
629 
630     uint256 private _totalSupply;
631     mapping(address => uint256) private _balances;
632 
633     uint public unlockPercent;
634     uint public lockPercent;
635 
636     constructor(
637         address _rewardsDistribution,
638         address _rewardsToken,
639         address _stakingToken,
640         uint256 _lockDuration,
641         uint256 _unlockPercent,
642         uint256 _lockPercent
643     ) public {
644         rewardsToken = IERC20(_rewardsToken);
645         stakingToken = IERC20(_stakingToken);
646         rewardsDistribution = _rewardsDistribution;
647         lockDuration = _lockDuration;
648         unlockPercent = _unlockPercent;
649         lockPercent = _lockPercent;
650     }
651 
652     /* ========== VIEWS ========== */
653 
654     function totalSupply() external override view returns (uint256) {
655         return _totalSupply;
656     }
657 
658     function balanceOf(address account) external override view returns (uint256) {
659         return _balances[account];
660     }
661 
662     function lastTimeRewardApplicable() public override view returns (uint256) {
663         return Math.min(block.timestamp, periodFinish);
664     }
665 
666     function rewardPerToken() public override view returns (uint256) {
667         if (_totalSupply == 0) {
668             return rewardPerTokenStored;
669         }
670         return
671             rewardPerTokenStored.add(
672                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
673             );
674     }
675 
676     function earned(address account) public override view returns (uint256, uint256) {
677         uint earnedToken = earnedDuration(account);
678         if(block.timestamp >= userLockTime[account]) {
679             uint unlockAmount = unlockRewards[account].add(lockRewards[account]).add(earnedToken);
680             return (unlockAmount, 0);
681         } else {
682             uint unlockAmount = unlockRewards[account].add(earnedToken.mul(unlockPercent).div(100));
683             uint lockAmount = lockRewards[account].add(earnedToken.mul(lockPercent).div(100));
684             return (unlockAmount, lockAmount);
685         }
686     }
687 
688 
689     function earnedDuration(address account) internal view returns (uint256) {
690         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18);
691     }
692 
693     function getRewardForDuration() external override view returns (uint256) {
694         return rewardRate.mul(rewardsDuration);
695     }
696 
697     /* ========== MUTATIVE FUNCTIONS ========== */
698 
699     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
700         require(amount > 0, "Cannot stake 0");
701         if (userLockTime[msg.sender] == 0) {
702             userLockTime[msg.sender] = block.timestamp.add(lockDuration);
703         }
704         _totalSupply = _totalSupply.add(amount);
705         _balances[msg.sender] = _balances[msg.sender].add(amount);
706 
707         // permit
708         IBORERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
709 
710         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
711         emit Staked(msg.sender, amount);
712     }
713 
714     function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
715         require(amount > 0, "Cannot stake 0");
716         if (userLockTime[msg.sender] == 0) {
717             userLockTime[msg.sender] = block.timestamp.add(lockDuration);
718         }
719         _totalSupply = _totalSupply.add(amount);
720         _balances[msg.sender] = _balances[msg.sender].add(amount);
721         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
722         emit Staked(msg.sender, amount);
723     }
724 
725     function withdraw(uint256 amount) public override virtual nonReentrant updateReward(msg.sender) {
726         require(amount > 0, "Cannot withdraw 0");
727         _totalSupply = _totalSupply.sub(amount);
728         _balances[msg.sender] = _balances[msg.sender].sub(amount);
729         stakingToken.safeTransfer(msg.sender, amount);
730         emit Withdrawn(msg.sender, amount);
731     }
732 
733     function getReward() public override nonReentrant updateReward(msg.sender) {
734         uint256 reward = unlockRewards[msg.sender];
735         if (reward > 0) {
736             unlockRewards[msg.sender] = 0;
737             rewardsToken.safeTransfer(msg.sender, reward);
738             emit RewardPaid(msg.sender, reward);
739         }
740     }
741 
742     function exit() external override {
743         withdraw(_balances[msg.sender]);
744         getReward();
745     }
746 
747     /* ========== RESTRICTED FUNCTIONS ========== */
748 
749     function notifyRewardAmount(uint256 reward, uint duration) external override onlyRewardsDistribution updateReward(address(0)) {
750         rewardsDuration = duration;
751         if (block.timestamp >= periodFinish) { 
752             rewardRate = reward.div(rewardsDuration);
753         } else {
754             uint256 remaining = periodFinish.sub(block.timestamp);
755             uint256 leftover = remaining.mul(rewardRate);
756             rewardRate = reward.add(leftover).div(rewardsDuration);
757         }
758 
759         // Ensure the provided reward amount is not more than the balance in the contract.
760         // This keeps the reward rate in the right range, preventing overflows due to
761         // very high values of rewardRate in the earned and rewardsPerToken functions;
762         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
763         uint balance = rewardsToken.balanceOf(address(this));
764         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
765 
766         lastUpdateTime = block.timestamp;
767         periodFinish = block.timestamp.add(rewardsDuration);
768         emit RewardAdded(reward);
769     }
770 
771     /* ========== MODIFIERS ========== */
772 
773     modifier updateReward(address account) {
774         rewardPerTokenStored = rewardPerToken();
775         lastUpdateTime = lastTimeRewardApplicable();
776         if (account != address(0)) {
777             (uint unlock, uint lock) = earned(account);
778             unlockRewards[account] = unlock;
779             lockRewards[account] = lock;
780             userRewardPerTokenPaid[account] = rewardPerTokenStored;
781         }
782         _;
783     }
784 
785     /* ========== EVENTS ========== */
786 
787     event RewardAdded(uint256 reward);
788     event Staked(address indexed user, uint256 amount);
789     event Withdrawn(address indexed user, uint256 amount);
790     event RewardPaid(address indexed user, uint256 reward);
791 
792 
793 
794 }
795 
796 interface IBORERC20 {
797     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
798 }