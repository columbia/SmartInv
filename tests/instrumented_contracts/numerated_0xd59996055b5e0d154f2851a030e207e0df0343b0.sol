1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 pragma solidity ^0.6.0;
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
85 pragma solidity ^0.6.0;
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
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
465 
466 
467 
468 pragma solidity ^0.6.0;
469 
470 /**
471  * @dev Contract module that helps prevent reentrant calls to a function.
472  *
473  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
474  * available, which can be applied to functions to make sure there are no nested
475  * (reentrant) calls to them.
476  *
477  * Note that because there is a single `nonReentrant` guard, functions marked as
478  * `nonReentrant` may not call one another. This can be worked around by making
479  * those functions `private`, and then adding `external` `nonReentrant` entry
480  * points to them.
481  *
482  * TIP: If you would like to learn more about reentrancy and alternative ways
483  * to protect against it, check out our blog post
484  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
485  */
486 contract ReentrancyGuard {
487     // Booleans are more expensive than uint256 or any type that takes up a full
488     // word because each write operation emits an extra SLOAD to first read the
489     // slot's contents, replace the bits taken up by the boolean, and then write
490     // back. This is the compiler's defense against contract upgrades and
491     // pointer aliasing, and it cannot be disabled.
492 
493     // The values being non-zero value makes deployment a bit more expensive,
494     // but in exchange the refund on every call to nonReentrant will be lower in
495     // amount. Since refunds are capped to a percentage of the total
496     // transaction's gas, it is best to keep them low in cases like this one, to
497     // increase the likelihood of the full refund coming into effect.
498     uint256 private constant _NOT_ENTERED = 1;
499     uint256 private constant _ENTERED = 2;
500 
501     uint256 private _status;
502 
503     constructor () internal {
504         _status = _NOT_ENTERED;
505     }
506 
507     /**
508      * @dev Prevents a contract from calling itself, directly or indirectly.
509      * Calling a `nonReentrant` function from another `nonReentrant`
510      * function is not supported. It is possible to prevent this from happening
511      * by making the `nonReentrant` function external, and make it call a
512      * `private` function that does the actual work.
513      */
514     modifier nonReentrant() {
515         // On the first call to nonReentrant, _notEntered will be true
516         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
517 
518         // Any calls to nonReentrant after this point will fail
519         _status = _ENTERED;
520 
521         _;
522 
523         // By storing the original value once again, a refund is triggered (see
524         // https://eips.ethereum.org/EIPS/eip-2200)
525         _status = _NOT_ENTERED;
526     }
527 }
528 
529 // File: contracts/interfaces/vesper/IController.sol
530 
531 
532 
533 pragma solidity 0.6.12;
534 
535 interface IController {
536     function aaveReferralCode() external view returns (uint16);
537 
538     function feeCollector(address) external view returns (address);
539 
540     function founderFee() external view returns (uint256);
541 
542     function founderVault() external view returns (address);
543 
544     function interestFee(address) external view returns (uint256);
545 
546     function isPool(address) external view returns (bool);
547 
548     function pools() external view returns (address);
549 
550     function strategy(address) external view returns (address);
551 
552     function rebalanceFriction(address) external view returns (uint256);
553 
554     function poolRewards(address) external view returns (address);
555 
556     function treasuryPool() external view returns (address);
557 
558     function uniswapRouter() external view returns (address);
559 
560     function withdrawFee(address) external view returns (uint256);
561 }
562 
563 // File: contracts/interfaces/vesper/IPoolRewards.sol
564 
565 
566 
567 pragma solidity 0.6.12;
568 
569 interface IPoolRewards {
570     function notifyRewardAmount(uint256) external;
571 
572     function claimReward(address) external;
573 
574     function updateReward(address) external;
575 
576     function rewardForDuration() external view returns (uint256);
577 
578     function claimable(address) external view returns (uint256);
579 
580     function pool() external view returns (address);
581 
582     function lastTimeRewardApplicable() external view returns (uint256);
583 
584     function rewardPerToken() external view returns (uint256);
585 }
586 
587 // File: contracts/pools/PoolRewards.sol
588 
589 
590 
591 pragma solidity 0.6.12;
592 
593 
594 
595 
596 
597 
598 contract PoolRewards is IPoolRewards, ReentrancyGuard {
599     using SafeMath for uint256;
600     using SafeERC20 for IERC20;
601     address public immutable override pool;
602     IERC20 public immutable rewardToken;
603     IController public immutable controller;
604     uint256 public periodFinish = 0;
605     uint256 public rewardRate = 0;
606     uint256 public constant REWARD_DURATION = 30 days;
607     uint256 public lastUpdateTime;
608     uint256 public rewardPerTokenStored;
609     mapping(address => uint256) public userRewardPerTokenPaid;
610     mapping(address => uint256) public rewards;
611     event RewardAdded(uint256 reward);
612 
613     constructor(
614         address _pool,
615         address _rewardToken,
616         address _controller
617     ) public {
618         require(_controller != address(0), "Controller address is zero");
619         controller = IController(_controller);
620         rewardToken = IERC20(_rewardToken);
621         pool = _pool;
622     }
623 
624     event RewardPaid(address indexed user, uint256 reward);
625 
626     /**
627      * @dev Notify that reward is added.
628      * Also updates reward rate and reward earning period.
629      */
630     function notifyRewardAmount(uint256 rewardAmount) external override {
631         _updateReward(address(0));
632         require(msg.sender == address(controller), "Not authorized");
633         require(address(rewardToken) != address(0), "Rewards token not set");
634         if (block.timestamp >= periodFinish) {
635             rewardRate = rewardAmount.div(REWARD_DURATION);
636         } else {
637             uint256 remaining = periodFinish.sub(block.timestamp);
638             uint256 leftover = remaining.mul(rewardRate);
639             rewardRate = rewardAmount.add(leftover).div(REWARD_DURATION);
640         }
641 
642         uint256 balance = rewardToken.balanceOf(address(this));
643         require(rewardRate <= balance.div(REWARD_DURATION), "Reward too high");
644 
645         lastUpdateTime = block.timestamp;
646         periodFinish = block.timestamp.add(REWARD_DURATION);
647         emit RewardAdded(rewardAmount);
648     }
649 
650     /// @dev Claim reward earned so far.
651     function claimReward(address account) external override nonReentrant {
652         _updateReward(account);
653         uint256 reward = rewards[account];
654         if (reward != 0) {
655             rewards[account] = 0;
656             rewardToken.safeTransfer(account, reward);
657             emit RewardPaid(account, reward);
658         }
659     }
660 
661     /**
662      * @dev Updated reward for given account. Only Pool can call
663      */
664     function updateReward(address _account) external override {
665         require(msg.sender == pool, "Only pool can update reward");
666         _updateReward(_account);
667     }
668 
669     function rewardForDuration() external view override returns (uint256) {
670         return rewardRate.mul(REWARD_DURATION);
671     }
672 
673     /// @dev Returns claimable reward amount.
674     function claimable(address account) public view override returns (uint256) {
675         return
676             IERC20(pool)
677                 .balanceOf(account)
678                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
679                 .div(1e18)
680                 .add(rewards[account]);
681     }
682 
683     /// @dev Returns timestamp of last reward update
684     function lastTimeRewardApplicable() public view override returns (uint256) {
685         return block.timestamp < periodFinish ? block.timestamp : periodFinish;
686     }
687 
688     function rewardPerToken() public view override returns (uint256) {
689         if (IERC20(pool).totalSupply() == 0) {
690             return rewardPerTokenStored;
691         }
692         return
693             rewardPerTokenStored.add(
694                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(
695                     IERC20(pool).totalSupply()
696                 )
697             );
698     }
699 
700     function _updateReward(address _account) private {
701         rewardPerTokenStored = rewardPerToken();
702         lastUpdateTime = lastTimeRewardApplicable();
703         if (_account != address(0)) {
704             rewards[_account] = claimable(_account);
705             userRewardPerTokenPaid[_account] = rewardPerTokenStored;
706         }
707     }
708 }