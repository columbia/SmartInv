1 // Dependency file: @openzeppelin/contracts/utils/Address.sol
2 
3 // pragma solidity ^0.6.2;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [// importANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // This method relies in extcodesize, which returns 0 for contracts in
28         // construction, since the code is only stored at the end of the
29         // constructor execution.
30 
31         uint256 size;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { size := extcodesize(account) }
34         return size > 0;
35     }
36 
37     /**
38      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39      * `recipient`, forwarding all available gas and reverting on errors.
40      *
41      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42      * of certain opcodes, possibly making contracts go over the 2300 gas limit
43      * imposed by `transfer`, making them unable to receive funds via
44      * `transfer`. {sendValue} removes this limitation.
45      *
46      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47      *
48      * // importANT: because control is transferred to `recipient`, care must be
49      * taken to not create reentrancy vulnerabilities. Consider using
50      * {ReentrancyGuard} or the
51      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52      */
53     function sendValue(address payable recipient, uint256 amount) internal {
54         require(address(this).balance >= amount, "Address: insufficient balance");
55 
56         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
57         (bool success, ) = recipient.call{ value: amount }("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain`call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80       return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90         return _functionCallWithValue(target, data, 0, errorMessage);
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95      * but also transferring `value` wei to `target`.
96      *
97      * Requirements:
98      *
99      * - the calling contract must have an ETH balance of at least `value`.
100      * - the called Solidity function must be `payable`.
101      *
102      * _Available since v3.1._
103      */
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
110      * with `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
124         if (success) {
125             return returndata;
126         } else {
127             // Look for revert reason and bubble it up if present
128             if (returndata.length > 0) {
129                 // The easiest way to bubble the revert reason is using memory via assembly
130 
131                 // solhint-disable-next-line no-inline-assembly
132                 assembly {
133                     let returndata_size := mload(returndata)
134                     revert(add(32, returndata), returndata_size)
135                 }
136             } else {
137                 revert(errorMessage);
138             }
139         }
140     }
141 }
142 
143 // Dependency file: contracts/staking/RewardsDistributionRecipient.sol
144 
145 // pragma solidity ^0.6.10;
146 
147 abstract contract RewardsDistributionRecipient {
148     address public rewardsDistribution;
149 
150     function notifyRewardAmount(uint256 reward) external virtual;
151 
152     modifier onlyRewardsDistribution() {
153         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
154         _;
155     }
156 }
157 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
158 
159 // pragma solidity ^0.6.0;
160 
161 /**
162  * @dev Contract module that helps prevent reentrant calls to a function.
163  *
164  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
165  * available, which can be applied to functions to make sure there are no nested
166  * (reentrant) calls to them.
167  *
168  * Note that because there is a single `nonReentrant` guard, functions marked as
169  * `nonReentrant` may not call one another. This can be worked around by making
170  * those functions `private`, and then adding `external` `nonReentrant` entry
171  * points to them.
172  *
173  * TIP: If you would like to learn more about reentrancy and alternative ways
174  * to protect against it, check out our blog post
175  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
176  */
177 contract ReentrancyGuard {
178     // Booleans are more expensive than uint256 or any type that takes up a full
179     // word because each write operation emits an extra SLOAD to first read the
180     // slot's contents, replace the bits taken up by the boolean, and then write
181     // back. This is the compiler's defense against contract upgrades and
182     // pointer aliasing, and it cannot be disabled.
183 
184     // The values being non-zero value makes deployment a bit more expensive,
185     // but in exchange the refund on every call to nonReentrant will be lower in
186     // amount. Since refunds are capped to a percentage of the total
187     // transaction's gas, it is best to keep them low in cases like this one, to
188     // increase the likelihood of the full refund coming into effect.
189     uint256 private constant _NOT_ENTERED = 1;
190     uint256 private constant _ENTERED = 2;
191 
192     uint256 private _status;
193 
194     constructor () internal {
195         _status = _NOT_ENTERED;
196     }
197 
198     /**
199      * @dev Prevents a contract from calling itself, directly or indirectly.
200      * Calling a `nonReentrant` function from another `nonReentrant`
201      * function is not supported. It is possible to prevent this from happening
202      * by making the `nonReentrant` function external, and make it call a
203      * `private` function that does the actual work.
204      */
205     modifier nonReentrant() {
206         // On the first call to nonReentrant, _notEntered will be true
207         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
208 
209         // Any calls to nonReentrant after this point will fail
210         _status = _ENTERED;
211 
212         _;
213 
214         // By storing the original value once again, a refund is triggered (see
215         // https://eips.ethereum.org/EIPS/eip-2200)
216         _status = _NOT_ENTERED;
217     }
218 }
219 
220 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
221 
222 // pragma solidity ^0.6.0;
223 
224 // import "./IERC20.sol";
225 // import "../../math/SafeMath.sol";
226 // import "../../utils/Address.sol";
227 
228 /**
229  * @title SafeERC20
230  * @dev Wrappers around ERC20 operations that throw on failure (when the token
231  * contract returns false). Tokens that return no value (and instead revert or
232  * throw on failure) are also supported, non-reverting calls are assumed to be
233  * successful.
234  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
235  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
236  */
237 library SafeERC20 {
238     using SafeMath for uint256;
239     using Address for address;
240 
241     function safeTransfer(IERC20 token, address to, uint256 value) internal {
242         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
243     }
244 
245     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
246         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
247     }
248 
249     /**
250      * @dev Deprecated. This function has issues similar to the ones found in
251      * {IERC20-approve}, and its usage is discouraged.
252      *
253      * Whenever possible, use {safeIncreaseAllowance} and
254      * {safeDecreaseAllowance} instead.
255      */
256     function safeApprove(IERC20 token, address spender, uint256 value) internal {
257         // safeApprove should only be called when setting an initial allowance,
258         // or when resetting it to zero. To increase and decrease it, use
259         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
260         // solhint-disable-next-line max-line-length
261         require((value == 0) || (token.allowance(address(this), spender) == 0),
262             "SafeERC20: approve from non-zero to non-zero allowance"
263         );
264         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
265     }
266 
267     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
268         uint256 newAllowance = token.allowance(address(this), spender).add(value);
269         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
270     }
271 
272     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
273         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
274         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
275     }
276 
277     /**
278      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
279      * on the return value: the return value is optional (but if data is returned, it must not be false).
280      * @param token The token targeted by the call.
281      * @param data The call data (encoded using abi.encode or one of its variants).
282      */
283     function _callOptionalReturn(IERC20 token, bytes memory data) private {
284         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
285         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
286         // the target address contains contract code and also asserts for success in the low-level call.
287 
288         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
289         if (returndata.length > 0) { // Return data is optional
290             // solhint-disable-next-line max-line-length
291             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
292         }
293     }
294 }
295 
296 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
297 
298 // pragma solidity ^0.6.0;
299 
300 /**
301  * @dev Wrappers over Solidity's arithmetic operations with added overflow
302  * checks.
303  *
304  * Arithmetic operations in Solidity wrap on overflow. This can easily result
305  * in bugs, because programmers usually assume that an overflow raises an
306  * error, which is the standard behavior in high level programming languages.
307  * `SafeMath` restores this intuition by reverting the transaction when an
308  * operation overflows.
309  *
310  * Using this library instead of the unchecked operations eliminates an entire
311  * class of bugs, so it's recommended to use it always.
312  */
313 library SafeMath {
314     /**
315      * @dev Returns the addition of two unsigned integers, reverting on
316      * overflow.
317      *
318      * Counterpart to Solidity's `+` operator.
319      *
320      * Requirements:
321      *
322      * - Addition cannot overflow.
323      */
324     function add(uint256 a, uint256 b) internal pure returns (uint256) {
325         uint256 c = a + b;
326         require(c >= a, "SafeMath: addition overflow");
327 
328         return c;
329     }
330 
331     /**
332      * @dev Returns the subtraction of two unsigned integers, reverting on
333      * overflow (when the result is negative).
334      *
335      * Counterpart to Solidity's `-` operator.
336      *
337      * Requirements:
338      *
339      * - Subtraction cannot overflow.
340      */
341     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
342         return sub(a, b, "SafeMath: subtraction overflow");
343     }
344 
345     /**
346      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
347      * overflow (when the result is negative).
348      *
349      * Counterpart to Solidity's `-` operator.
350      *
351      * Requirements:
352      *
353      * - Subtraction cannot overflow.
354      */
355     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
356         require(b <= a, errorMessage);
357         uint256 c = a - b;
358 
359         return c;
360     }
361 
362     /**
363      * @dev Returns the multiplication of two unsigned integers, reverting on
364      * overflow.
365      *
366      * Counterpart to Solidity's `*` operator.
367      *
368      * Requirements:
369      *
370      * - Multiplication cannot overflow.
371      */
372     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
373         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
374         // benefit is lost if 'b' is also tested.
375         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
376         if (a == 0) {
377             return 0;
378         }
379 
380         uint256 c = a * b;
381         require(c / a == b, "SafeMath: multiplication overflow");
382 
383         return c;
384     }
385 
386     /**
387      * @dev Returns the integer division of two unsigned integers. Reverts on
388      * division by zero. The result is rounded towards zero.
389      *
390      * Counterpart to Solidity's `/` operator. Note: this function uses a
391      * `revert` opcode (which leaves remaining gas untouched) while Solidity
392      * uses an invalid opcode to revert (consuming all remaining gas).
393      *
394      * Requirements:
395      *
396      * - The divisor cannot be zero.
397      */
398     function div(uint256 a, uint256 b) internal pure returns (uint256) {
399         return div(a, b, "SafeMath: division by zero");
400     }
401 
402     /**
403      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
404      * division by zero. The result is rounded towards zero.
405      *
406      * Counterpart to Solidity's `/` operator. Note: this function uses a
407      * `revert` opcode (which leaves remaining gas untouched) while Solidity
408      * uses an invalid opcode to revert (consuming all remaining gas).
409      *
410      * Requirements:
411      *
412      * - The divisor cannot be zero.
413      */
414     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
415         require(b > 0, errorMessage);
416         uint256 c = a / b;
417         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
418 
419         return c;
420     }
421 
422     /**
423      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
424      * Reverts when dividing by zero.
425      *
426      * Counterpart to Solidity's `%` operator. This function uses a `revert`
427      * opcode (which leaves remaining gas untouched) while Solidity uses an
428      * invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      *
432      * - The divisor cannot be zero.
433      */
434     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
435         return mod(a, b, "SafeMath: modulo by zero");
436     }
437 
438     /**
439      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
440      * Reverts with custom message when dividing by zero.
441      *
442      * Counterpart to Solidity's `%` operator. This function uses a `revert`
443      * opcode (which leaves remaining gas untouched) while Solidity uses an
444      * invalid opcode to revert (consuming all remaining gas).
445      *
446      * Requirements:
447      *
448      * - The divisor cannot be zero.
449      */
450     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
451         require(b != 0, errorMessage);
452         return a % b;
453     }
454 }
455 
456 // Dependency file: @openzeppelin/contracts/math/Math.sol
457 
458 // pragma solidity ^0.6.0;
459 
460 /**
461  * @dev Standard math utilities missing in the Solidity language.
462  */
463 library Math {
464     /**
465      * @dev Returns the largest of two numbers.
466      */
467     function max(uint256 a, uint256 b) internal pure returns (uint256) {
468         return a >= b ? a : b;
469     }
470 
471     /**
472      * @dev Returns the smallest of two numbers.
473      */
474     function min(uint256 a, uint256 b) internal pure returns (uint256) {
475         return a < b ? a : b;
476     }
477 
478     /**
479      * @dev Returns the average of two numbers. The result is rounded towards
480      * zero.
481      */
482     function average(uint256 a, uint256 b) internal pure returns (uint256) {
483         // (a + b) / 2 can overflow, so we distribute
484         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
485     }
486 }
487 
488 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
489 
490 // SPDX-License-Identifier: MIT
491 
492 // pragma solidity ^0.6.0;
493 
494 /**
495  * @dev Interface of the ERC20 standard as defined in the EIP.
496  */
497 interface IERC20 {
498     /**
499      * @dev Returns the amount of tokens in existence.
500      */
501     function totalSupply() external view returns (uint256);
502 
503     /**
504      * @dev Returns the amount of tokens owned by `account`.
505      */
506     function balanceOf(address account) external view returns (uint256);
507 
508     /**
509      * @dev Moves `amount` tokens from the caller's account to `recipient`.
510      *
511      * Returns a boolean value indicating whether the operation succeeded.
512      *
513      * Emits a {Transfer} event.
514      */
515     function transfer(address recipient, uint256 amount) external returns (bool);
516 
517     /**
518      * @dev Returns the remaining number of tokens that `spender` will be
519      * allowed to spend on behalf of `owner` through {transferFrom}. This is
520      * zero by default.
521      *
522      * This value changes when {approve} or {transferFrom} are called.
523      */
524     function allowance(address owner, address spender) external view returns (uint256);
525 
526     /**
527      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
528      *
529      * Returns a boolean value indicating whether the operation succeeded.
530      *
531      * // importANT: Beware that changing an allowance with this method brings the risk
532      * that someone may use both the old and the new allowance by unfortunate
533      * transaction ordering. One possible solution to mitigate this race
534      * condition is to first reduce the spender's allowance to 0 and set the
535      * desired value afterwards:
536      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
537      *
538      * Emits an {Approval} event.
539      */
540     function approve(address spender, uint256 amount) external returns (bool);
541 
542     /**
543      * @dev Moves `amount` tokens from `sender` to `recipient` using the
544      * allowance mechanism. `amount` is then deducted from the caller's
545      * allowance.
546      *
547      * Returns a boolean value indicating whether the operation succeeded.
548      *
549      * Emits a {Transfer} event.
550      */
551     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
552 
553     /**
554      * @dev Emitted when `value` tokens are moved from one account (`from`) to
555      * another (`to`).
556      *
557      * Note that `value` may be zero.
558      */
559     event Transfer(address indexed from, address indexed to, uint256 value);
560 
561     /**
562      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
563      * a call to {approve}. `value` is the new allowance.
564      */
565     event Approval(address indexed owner, address indexed spender, uint256 value);
566 }
567 
568 pragma solidity ^0.6.10;
569 
570 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
571 // import { Math } from  "@openzeppelin/contracts/math/Math.sol";
572 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
573 // import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
574 // import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
575 
576 // Inheritance
577 // import { RewardsDistributionRecipient } from  "./RewardsDistributionRecipient.sol";
578 
579 // NOTE: V2 allows setting of rewardsDuration in constructor
580 contract StakingRewardsV2 is RewardsDistributionRecipient, ReentrancyGuard {
581     using SafeMath for uint256;
582     using SafeERC20 for IERC20;
583 
584     /* ========== STATE VARIABLES ========== */
585 
586     IERC20 public rewardsToken;
587     IERC20 public stakingToken;
588     uint256 public periodFinish = 0;
589     uint256 public rewardRate = 0;
590     uint256 public rewardsDuration;
591     uint256 public lastUpdateTime;
592     uint256 public rewardPerTokenStored;
593 
594     mapping(address => uint256) public userRewardPerTokenPaid;
595     mapping(address => uint256) public rewards;
596 
597     uint256 private _totalSupply;
598     mapping(address => uint256) private _balances;
599 
600     /* ========== CONSTRUCTOR ========== */
601 
602     constructor(
603         address _rewardsDistribution,
604         address _rewardsToken,
605         address _stakingToken,
606         uint256 _rewardsDuration
607     ) public {
608         rewardsToken = IERC20(_rewardsToken);
609         stakingToken = IERC20(_stakingToken);
610         rewardsDistribution = _rewardsDistribution;
611         rewardsDuration = _rewardsDuration;
612     }
613 
614     /* ========== VIEWS ========== */
615 
616     function totalSupply() external view returns (uint256) {
617         return _totalSupply;
618     }
619 
620     function balanceOf(address account) external view returns (uint256) {
621         return _balances[account];
622     }
623 
624     function lastTimeRewardApplicable() public view returns (uint256) {
625         return Math.min(block.timestamp, periodFinish);
626     }
627 
628     function rewardPerToken() public view returns (uint256) {
629         if (_totalSupply == 0) {
630             return rewardPerTokenStored;
631         }
632         return
633             rewardPerTokenStored.add(
634                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
635             );
636     }
637 
638     function earned(address account) public view returns (uint256) {
639         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
640     }
641 
642     function getRewardForDuration() external view returns (uint256) {
643         return rewardRate.mul(rewardsDuration);
644     }
645 
646     /* ========== MUTATIVE FUNCTIONS ========== */
647 
648     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
649         require(amount > 0, "Cannot stake 0");
650         _totalSupply = _totalSupply.add(amount);
651         _balances[msg.sender] = _balances[msg.sender].add(amount);
652         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
653         emit Staked(msg.sender, amount);
654     }
655 
656     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
657         require(amount > 0, "Cannot withdraw 0");
658         _totalSupply = _totalSupply.sub(amount);
659         _balances[msg.sender] = _balances[msg.sender].sub(amount);
660         stakingToken.safeTransfer(msg.sender, amount);
661         emit Withdrawn(msg.sender, amount);
662     }
663 
664     function getReward() public nonReentrant updateReward(msg.sender) {
665         uint256 reward = rewards[msg.sender];
666         if (reward > 0) {
667             rewards[msg.sender] = 0;
668             rewardsToken.safeTransfer(msg.sender, reward);
669             emit RewardPaid(msg.sender, reward);
670         }
671     }
672 
673     function exit() external {
674         withdraw(_balances[msg.sender]);
675         getReward();
676     }
677 
678     /* ========== RESTRICTED FUNCTIONS ========== */
679 
680     function notifyRewardAmount(uint256 reward) external override onlyRewardsDistribution updateReward(address(0)) {
681         if (block.timestamp >= periodFinish) {
682             rewardRate = reward.div(rewardsDuration);
683         } else {
684             uint256 remaining = periodFinish.sub(block.timestamp);
685             uint256 leftover = remaining.mul(rewardRate);
686             rewardRate = reward.add(leftover).div(rewardsDuration);
687         }
688 
689         // Ensure the provided reward amount is not more than the balance in the contract.
690         // This keeps the reward rate in the right range, preventing overflows due to
691         // very high values of rewardRate in the earned and rewardsPerToken functions;
692         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
693         uint balance = rewardsToken.balanceOf(address(this));
694         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
695 
696         lastUpdateTime = block.timestamp;
697         periodFinish = block.timestamp.add(rewardsDuration);
698         emit RewardAdded(reward);
699     }
700 
701     /* ========== MODIFIERS ========== */
702 
703     modifier updateReward(address account) {
704         rewardPerTokenStored = rewardPerToken();
705         lastUpdateTime = lastTimeRewardApplicable();
706         if (account != address(0)) {
707             rewards[account] = earned(account);
708             userRewardPerTokenPaid[account] = rewardPerTokenStored;
709         }
710         _;
711     }
712 
713     /* ========== EVENTS ========== */
714 
715     event RewardAdded(uint256 reward);
716     event Staked(address indexed user, uint256 amount);
717     event Withdrawn(address indexed user, uint256 amount);
718     event RewardPaid(address indexed user, uint256 reward);
719 }