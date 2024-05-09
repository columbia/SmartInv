1 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 
5 // pragma solidity >=0.6.0 <0.8.0;
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
44      * // importANT: Beware that changing an allowance with this method brings the risk
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
81 
82 // Dependency file: @openzeppelin/contracts/math/Math.sol
83 
84 
85 // pragma solidity >=0.6.0 <0.8.0;
86 
87 /**
88  * @dev Standard math utilities missing in the Solidity language.
89  */
90 library Math {
91     /**
92      * @dev Returns the largest of two numbers.
93      */
94     function max(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a >= b ? a : b;
96     }
97 
98     /**
99      * @dev Returns the smallest of two numbers.
100      */
101     function min(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a < b ? a : b;
103     }
104 
105     /**
106      * @dev Returns the average of two numbers. The result is rounded towards
107      * zero.
108      */
109     function average(uint256 a, uint256 b) internal pure returns (uint256) {
110         // (a + b) / 2 can overflow, so we distribute
111         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
112     }
113 }
114 
115 
116 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
117 
118 
119 // pragma solidity >=0.6.0 <0.8.0;
120 
121 /**
122  * @dev Wrappers over Solidity's arithmetic operations with added overflow
123  * checks.
124  *
125  * Arithmetic operations in Solidity wrap on overflow. This can easily result
126  * in bugs, because programmers usually assume that an overflow raises an
127  * error, which is the standard behavior in high level programming languages.
128  * `SafeMath` restores this intuition by reverting the transaction when an
129  * operation overflows.
130  *
131  * Using this library instead of the unchecked operations eliminates an entire
132  * class of bugs, so it's recommended to use it always.
133  */
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `+` operator.
140      *
141      * Requirements:
142      *
143      * - Addition cannot overflow.
144      */
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         require(c >= a, "SafeMath: addition overflow");
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         return sub(a, b, "SafeMath: subtraction overflow");
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b <= a, errorMessage);
178         uint256 c = a - b;
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
195         // benefit is lost if 'b' is also tested.
196         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
197         if (a == 0) {
198             return 0;
199         }
200 
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b > 0, errorMessage);
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return mod(a, b, "SafeMath: modulo by zero");
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts with custom message when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b != 0, errorMessage);
273         return a % b;
274     }
275 }
276 
277 
278 // Dependency file: @openzeppelin/contracts/utils/Address.sol
279 
280 
281 // pragma solidity >=0.6.2 <0.8.0;
282 
283 /**
284  * @dev Collection of functions related to the address type
285  */
286 library Address {
287     /**
288      * @dev Returns true if `account` is a contract.
289      *
290      * [// importANT]
291      * ====
292      * It is unsafe to assume that an address for which this function returns
293      * false is an externally-owned account (EOA) and not a contract.
294      *
295      * Among others, `isContract` will return false for the following
296      * types of addresses:
297      *
298      *  - an externally-owned account
299      *  - a contract in construction
300      *  - an address where a contract will be created
301      *  - an address where a contract lived, but was destroyed
302      * ====
303      */
304     function isContract(address account) internal view returns (bool) {
305         // This method relies on extcodesize, which returns 0 for contracts in
306         // construction, since the code is only stored at the end of the
307         // constructor execution.
308 
309         uint256 size;
310         // solhint-disable-next-line no-inline-assembly
311         assembly { size := extcodesize(account) }
312         return size > 0;
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * // importANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(address(this).balance >= amount, "Address: insufficient balance");
333 
334         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
335         (bool success, ) = recipient.call{ value: amount }("");
336         require(success, "Address: unable to send value, recipient may have reverted");
337     }
338 
339     /**
340      * @dev Performs a Solidity function call using a low level `call`. A
341      * plain`call` is an unsafe replacement for a function call: use this
342      * function instead.
343      *
344      * If `target` reverts with a revert reason, it is bubbled up by this
345      * function (like regular Solidity function calls).
346      *
347      * Returns the raw returned data. To convert to the expected return value,
348      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
349      *
350      * Requirements:
351      *
352      * - `target` must be a contract.
353      * - calling `target` with `data` must not revert.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
358       return functionCall(target, data, "Address: low-level call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
363      * `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but also transferring `value` wei to `target`.
374      *
375      * Requirements:
376      *
377      * - the calling contract must have an ETH balance of at least `value`.
378      * - the called Solidity function must be `payable`.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
393         require(address(this).balance >= value, "Address: insufficient balance for call");
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{ value: value }(data);
398         return _verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
408         return functionStaticCall(target, data, "Address: low-level static call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
418         require(isContract(target), "Address: static call to non-contract");
419 
420         // solhint-disable-next-line avoid-low-level-calls
421         (bool success, bytes memory returndata) = target.staticcall(data);
422         return _verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
426         if (success) {
427             return returndata;
428         } else {
429             // Look for revert reason and bubble it up if present
430             if (returndata.length > 0) {
431                 // The easiest way to bubble the revert reason is using memory via assembly
432 
433                 // solhint-disable-next-line no-inline-assembly
434                 assembly {
435                     let returndata_size := mload(returndata)
436                     revert(add(32, returndata), returndata_size)
437                 }
438             } else {
439                 revert(errorMessage);
440             }
441         }
442     }
443 }
444 
445 
446 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
447 
448 
449 // pragma solidity >=0.6.0 <0.8.0;
450 
451 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
452 // import "@openzeppelin/contracts/math/SafeMath.sol";
453 // import "@openzeppelin/contracts/utils/Address.sol";
454 
455 /**
456  * @title SafeERC20
457  * @dev Wrappers around ERC20 operations that throw on failure (when the token
458  * contract returns false). Tokens that return no value (and instead revert or
459  * throw on failure) are also supported, non-reverting calls are assumed to be
460  * successful.
461  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
462  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
463  */
464 library SafeERC20 {
465     using SafeMath for uint256;
466     using Address for address;
467 
468     function safeTransfer(IERC20 token, address to, uint256 value) internal {
469         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
470     }
471 
472     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
473         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
474     }
475 
476     /**
477      * @dev Deprecated. This function has issues similar to the ones found in
478      * {IERC20-approve}, and its usage is discouraged.
479      *
480      * Whenever possible, use {safeIncreaseAllowance} and
481      * {safeDecreaseAllowance} instead.
482      */
483     function safeApprove(IERC20 token, address spender, uint256 value) internal {
484         // safeApprove should only be called when setting an initial allowance,
485         // or when resetting it to zero. To increase and decrease it, use
486         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
487         // solhint-disable-next-line max-line-length
488         require((value == 0) || (token.allowance(address(this), spender) == 0),
489             "SafeERC20: approve from non-zero to non-zero allowance"
490         );
491         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
492     }
493 
494     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
495         uint256 newAllowance = token.allowance(address(this), spender).add(value);
496         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
497     }
498 
499     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
500         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
501         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
502     }
503 
504     /**
505      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
506      * on the return value: the return value is optional (but if data is returned, it must not be false).
507      * @param token The token targeted by the call.
508      * @param data The call data (encoded using abi.encode or one of its variants).
509      */
510     function _callOptionalReturn(IERC20 token, bytes memory data) private {
511         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
512         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
513         // the target address contains contract code and also asserts for success in the low-level call.
514 
515         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
516         if (returndata.length > 0) { // Return data is optional
517             // solhint-disable-next-line max-line-length
518             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
519         }
520     }
521 }
522 
523 
524 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
525 
526 
527 // pragma solidity >=0.6.0 <0.8.0;
528 
529 /**
530  * @dev Contract module that helps prevent reentrant calls to a function.
531  *
532  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
533  * available, which can be applied to functions to make sure there are no nested
534  * (reentrant) calls to them.
535  *
536  * Note that because there is a single `nonReentrant` guard, functions marked as
537  * `nonReentrant` may not call one another. This can be worked around by making
538  * those functions `private`, and then adding `external` `nonReentrant` entry
539  * points to them.
540  *
541  * TIP: If you would like to learn more about reentrancy and alternative ways
542  * to protect against it, check out our blog post
543  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
544  */
545 abstract contract ReentrancyGuard {
546     // Booleans are more expensive than uint256 or any type that takes up a full
547     // word because each write operation emits an extra SLOAD to first read the
548     // slot's contents, replace the bits taken up by the boolean, and then write
549     // back. This is the compiler's defense against contract upgrades and
550     // pointer aliasing, and it cannot be disabled.
551 
552     // The values being non-zero value makes deployment a bit more expensive,
553     // but in exchange the refund on every call to nonReentrant will be lower in
554     // amount. Since refunds are capped to a percentage of the total
555     // transaction's gas, it is best to keep them low in cases like this one, to
556     // increase the likelihood of the full refund coming into effect.
557     uint256 private constant _NOT_ENTERED = 1;
558     uint256 private constant _ENTERED = 2;
559 
560     uint256 private _status;
561 
562     constructor () internal {
563         _status = _NOT_ENTERED;
564     }
565 
566     /**
567      * @dev Prevents a contract from calling itself, directly or indirectly.
568      * Calling a `nonReentrant` function from another `nonReentrant`
569      * function is not supported. It is possible to prevent this from happening
570      * by making the `nonReentrant` function external, and make it call a
571      * `private` function that does the actual work.
572      */
573     modifier nonReentrant() {
574         // On the first call to nonReentrant, _notEntered will be true
575         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
576 
577         // Any calls to nonReentrant after this point will fail
578         _status = _ENTERED;
579 
580         _;
581 
582         // By storing the original value once again, a refund is triggered (see
583         // https://eips.ethereum.org/EIPS/eip-2200)
584         _status = _NOT_ENTERED;
585     }
586 }
587 
588 
589 // Dependency file: contracts/staking/RewardsDistributionRecipient.sol
590 
591 // pragma solidity ^0.6.10;
592 
593 abstract contract RewardsDistributionRecipient {
594     address public rewardsDistribution;
595 
596     function notifyRewardAmount(uint256 reward) external virtual;
597 
598     modifier onlyRewardsDistribution() {
599         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
600         _;
601     }
602 }
603 
604 // Root file: contracts/staking/StakingRewardsV2.sol
605 
606 pragma solidity ^0.6.10;
607 
608 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
609 // import { Math } from  "@openzeppelin/contracts/math/Math.sol";
610 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
611 // import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
612 // import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
613 
614 // Inheritance
615 // import { RewardsDistributionRecipient } from  "contracts/staking/RewardsDistributionRecipient.sol";
616 
617 // NOTE: V2 allows setting of rewardsDuration in constructor
618 contract StakingRewardsV2 is RewardsDistributionRecipient, ReentrancyGuard {
619     using SafeMath for uint256;
620     using SafeERC20 for IERC20;
621 
622     /* ========== STATE VARIABLES ========== */
623 
624     IERC20 public rewardsToken;
625     IERC20 public stakingToken;
626     uint256 public periodFinish = 0;
627     uint256 public rewardRate = 0;
628     uint256 public rewardsDuration;
629     uint256 public lastUpdateTime;
630     uint256 public rewardPerTokenStored;
631 
632     mapping(address => uint256) public userRewardPerTokenPaid;
633     mapping(address => uint256) public rewards;
634 
635     uint256 private _totalSupply;
636     mapping(address => uint256) private _balances;
637 
638     /* ========== CONSTRUCTOR ========== */
639 
640     constructor(
641         address _rewardsDistribution,
642         address _rewardsToken,
643         address _stakingToken,
644         uint256 _rewardsDuration
645     ) public {
646         rewardsToken = IERC20(_rewardsToken);
647         stakingToken = IERC20(_stakingToken);
648         rewardsDistribution = _rewardsDistribution;
649         rewardsDuration = _rewardsDuration;
650     }
651 
652     /* ========== VIEWS ========== */
653 
654     function totalSupply() external view returns (uint256) {
655         return _totalSupply;
656     }
657 
658     function balanceOf(address account) external view returns (uint256) {
659         return _balances[account];
660     }
661 
662     function lastTimeRewardApplicable() public view returns (uint256) {
663         return Math.min(block.timestamp, periodFinish);
664     }
665 
666     function rewardPerToken() public view returns (uint256) {
667         if (_totalSupply == 0) {
668             return rewardPerTokenStored;
669         }
670         return
671             rewardPerTokenStored.add(
672                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
673             );
674     }
675 
676     function earned(address account) public view returns (uint256) {
677         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
678     }
679 
680     function getRewardForDuration() external view returns (uint256) {
681         return rewardRate.mul(rewardsDuration);
682     }
683 
684     /* ========== MUTATIVE FUNCTIONS ========== */
685 
686     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
687         require(amount > 0, "Cannot stake 0");
688         _totalSupply = _totalSupply.add(amount);
689         _balances[msg.sender] = _balances[msg.sender].add(amount);
690         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
691         emit Staked(msg.sender, amount);
692     }
693 
694     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
695         require(amount > 0, "Cannot withdraw 0");
696         _totalSupply = _totalSupply.sub(amount);
697         _balances[msg.sender] = _balances[msg.sender].sub(amount);
698         stakingToken.safeTransfer(msg.sender, amount);
699         emit Withdrawn(msg.sender, amount);
700     }
701 
702     function getReward() public nonReentrant updateReward(msg.sender) {
703         uint256 reward = rewards[msg.sender];
704         if (reward > 0) {
705             rewards[msg.sender] = 0;
706             rewardsToken.safeTransfer(msg.sender, reward);
707             emit RewardPaid(msg.sender, reward);
708         }
709     }
710 
711     function exit() external {
712         withdraw(_balances[msg.sender]);
713         getReward();
714     }
715 
716     /* ========== RESTRICTED FUNCTIONS ========== */
717 
718     function notifyRewardAmount(uint256 reward) external override onlyRewardsDistribution updateReward(address(0)) {
719         if (block.timestamp >= periodFinish) {
720             rewardRate = reward.div(rewardsDuration);
721         } else {
722             uint256 remaining = periodFinish.sub(block.timestamp);
723             uint256 leftover = remaining.mul(rewardRate);
724             rewardRate = reward.add(leftover).div(rewardsDuration);
725         }
726 
727         // Ensure the provided reward amount is not more than the balance in the contract.
728         // This keeps the reward rate in the right range, preventing overflows due to
729         // very high values of rewardRate in the earned and rewardsPerToken functions;
730         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
731         uint balance = rewardsToken.balanceOf(address(this));
732         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
733 
734         lastUpdateTime = block.timestamp;
735         periodFinish = block.timestamp.add(rewardsDuration);
736         emit RewardAdded(reward);
737     }
738 
739     /* ========== MODIFIERS ========== */
740 
741     modifier updateReward(address account) {
742         rewardPerTokenStored = rewardPerToken();
743         lastUpdateTime = lastTimeRewardApplicable();
744         if (account != address(0)) {
745             rewards[account] = earned(account);
746             userRewardPerTokenPaid[account] = rewardPerTokenStored;
747         }
748         _;
749     }
750 
751     /* ========== EVENTS ========== */
752 
753     event RewardAdded(uint256 reward);
754     event Staked(address indexed user, uint256 amount);
755     event Withdrawn(address indexed user, uint256 amount);
756     event RewardPaid(address indexed user, uint256 reward);
757 }