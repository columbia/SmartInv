1 // Dependency file: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 
5 // pragma solidity ^0.6.2;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [// importANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // This method relies in extcodesize, which returns 0 for contracts in
30         // construction, since the code is only stored at the end of the
31         // constructor execution.
32 
33         uint256 size;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { size := extcodesize(account) }
36         return size > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * // importANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
59         (bool success, ) = recipient.call{ value: amount }("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain`call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82       return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return _functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
97      * but also transferring `value` wei to `target`.
98      *
99      * Requirements:
100      *
101      * - the calling contract must have an ETH balance of at least `value`.
102      * - the called Solidity function must be `payable`.
103      *
104      * _Available since v3.1._
105      */
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
112      * with `errorMessage` as a fallback revert reason when `target` reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         return _functionCallWithValue(target, data, value, errorMessage);
119     }
120 
121     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
122         require(isContract(target), "Address: call to non-contract");
123 
124         // solhint-disable-next-line avoid-low-level-calls
125         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
126         if (success) {
127             return returndata;
128         } else {
129             // Look for revert reason and bubble it up if present
130             if (returndata.length > 0) {
131                 // The easiest way to bubble the revert reason is using memory via assembly
132 
133                 // solhint-disable-next-line no-inline-assembly
134                 assembly {
135                     let returndata_size := mload(returndata)
136                     revert(add(32, returndata), returndata_size)
137                 }
138             } else {
139                 revert(errorMessage);
140             }
141         }
142     }
143 }
144 
145 // Dependency file: contracts/staking/RewardsDistributionRecipient.sol
146 
147 // pragma solidity ^0.6.10;
148 
149 abstract contract RewardsDistributionRecipient {
150     address public rewardsDistribution;
151 
152     function notifyRewardAmount(uint256 reward) external virtual;
153 
154     modifier onlyRewardsDistribution() {
155         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
156         _;
157     }
158 }
159 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
160 
161 
162 
163 // pragma solidity ^0.6.0;
164 
165 /**
166  * @dev Contract module that helps prevent reentrant calls to a function.
167  *
168  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
169  * available, which can be applied to functions to make sure there are no nested
170  * (reentrant) calls to them.
171  *
172  * Note that because there is a single `nonReentrant` guard, functions marked as
173  * `nonReentrant` may not call one another. This can be worked around by making
174  * those functions `private`, and then adding `external` `nonReentrant` entry
175  * points to them.
176  *
177  * TIP: If you would like to learn more about reentrancy and alternative ways
178  * to protect against it, check out our blog post
179  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
180  */
181 contract ReentrancyGuard {
182     // Booleans are more expensive than uint256 or any type that takes up a full
183     // word because each write operation emits an extra SLOAD to first read the
184     // slot's contents, replace the bits taken up by the boolean, and then write
185     // back. This is the compiler's defense against contract upgrades and
186     // pointer aliasing, and it cannot be disabled.
187 
188     // The values being non-zero value makes deployment a bit more expensive,
189     // but in exchange the refund on every call to nonReentrant will be lower in
190     // amount. Since refunds are capped to a percentage of the total
191     // transaction's gas, it is best to keep them low in cases like this one, to
192     // increase the likelihood of the full refund coming into effect.
193     uint256 private constant _NOT_ENTERED = 1;
194     uint256 private constant _ENTERED = 2;
195 
196     uint256 private _status;
197 
198     constructor () internal {
199         _status = _NOT_ENTERED;
200     }
201 
202     /**
203      * @dev Prevents a contract from calling itself, directly or indirectly.
204      * Calling a `nonReentrant` function from another `nonReentrant`
205      * function is not supported. It is possible to prevent this from happening
206      * by making the `nonReentrant` function external, and make it call a
207      * `private` function that does the actual work.
208      */
209     modifier nonReentrant() {
210         // On the first call to nonReentrant, _notEntered will be true
211         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
212 
213         // Any calls to nonReentrant after this point will fail
214         _status = _ENTERED;
215 
216         _;
217 
218         // By storing the original value once again, a refund is triggered (see
219         // https://eips.ethereum.org/EIPS/eip-2200)
220         _status = _NOT_ENTERED;
221     }
222 }
223 
224 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
225 
226 
227 
228 // pragma solidity ^0.6.0;
229 
230 // import "./IERC20.sol";
231 // import "../../math/SafeMath.sol";
232 // import "../../utils/Address.sol";
233 
234 /**
235  * @title SafeERC20
236  * @dev Wrappers around ERC20 operations that throw on failure (when the token
237  * contract returns false). Tokens that return no value (and instead revert or
238  * throw on failure) are also supported, non-reverting calls are assumed to be
239  * successful.
240  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
241  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
242  */
243 library SafeERC20 {
244     using SafeMath for uint256;
245     using Address for address;
246 
247     function safeTransfer(IERC20 token, address to, uint256 value) internal {
248         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
249     }
250 
251     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
252         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
253     }
254 
255     /**
256      * @dev Deprecated. This function has issues similar to the ones found in
257      * {IERC20-approve}, and its usage is discouraged.
258      *
259      * Whenever possible, use {safeIncreaseAllowance} and
260      * {safeDecreaseAllowance} instead.
261      */
262     function safeApprove(IERC20 token, address spender, uint256 value) internal {
263         // safeApprove should only be called when setting an initial allowance,
264         // or when resetting it to zero. To increase and decrease it, use
265         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
266         // solhint-disable-next-line max-line-length
267         require((value == 0) || (token.allowance(address(this), spender) == 0),
268             "SafeERC20: approve from non-zero to non-zero allowance"
269         );
270         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
271     }
272 
273     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
274         uint256 newAllowance = token.allowance(address(this), spender).add(value);
275         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
276     }
277 
278     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
279         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
280         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
281     }
282 
283     /**
284      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
285      * on the return value: the return value is optional (but if data is returned, it must not be false).
286      * @param token The token targeted by the call.
287      * @param data The call data (encoded using abi.encode or one of its variants).
288      */
289     function _callOptionalReturn(IERC20 token, bytes memory data) private {
290         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
291         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
292         // the target address contains contract code and also asserts for success in the low-level call.
293 
294         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
295         if (returndata.length > 0) { // Return data is optional
296             // solhint-disable-next-line max-line-length
297             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
298         }
299     }
300 }
301 
302 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
303 
304 
305 
306 // pragma solidity ^0.6.0;
307 
308 /**
309  * @dev Wrappers over Solidity's arithmetic operations with added overflow
310  * checks.
311  *
312  * Arithmetic operations in Solidity wrap on overflow. This can easily result
313  * in bugs, because programmers usually assume that an overflow raises an
314  * error, which is the standard behavior in high level programming languages.
315  * `SafeMath` restores this intuition by reverting the transaction when an
316  * operation overflows.
317  *
318  * Using this library instead of the unchecked operations eliminates an entire
319  * class of bugs, so it's recommended to use it always.
320  */
321 library SafeMath {
322     /**
323      * @dev Returns the addition of two unsigned integers, reverting on
324      * overflow.
325      *
326      * Counterpart to Solidity's `+` operator.
327      *
328      * Requirements:
329      *
330      * - Addition cannot overflow.
331      */
332     function add(uint256 a, uint256 b) internal pure returns (uint256) {
333         uint256 c = a + b;
334         require(c >= a, "SafeMath: addition overflow");
335 
336         return c;
337     }
338 
339     /**
340      * @dev Returns the subtraction of two unsigned integers, reverting on
341      * overflow (when the result is negative).
342      *
343      * Counterpart to Solidity's `-` operator.
344      *
345      * Requirements:
346      *
347      * - Subtraction cannot overflow.
348      */
349     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
350         return sub(a, b, "SafeMath: subtraction overflow");
351     }
352 
353     /**
354      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
355      * overflow (when the result is negative).
356      *
357      * Counterpart to Solidity's `-` operator.
358      *
359      * Requirements:
360      *
361      * - Subtraction cannot overflow.
362      */
363     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
364         require(b <= a, errorMessage);
365         uint256 c = a - b;
366 
367         return c;
368     }
369 
370     /**
371      * @dev Returns the multiplication of two unsigned integers, reverting on
372      * overflow.
373      *
374      * Counterpart to Solidity's `*` operator.
375      *
376      * Requirements:
377      *
378      * - Multiplication cannot overflow.
379      */
380     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
381         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
382         // benefit is lost if 'b' is also tested.
383         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
384         if (a == 0) {
385             return 0;
386         }
387 
388         uint256 c = a * b;
389         require(c / a == b, "SafeMath: multiplication overflow");
390 
391         return c;
392     }
393 
394     /**
395      * @dev Returns the integer division of two unsigned integers. Reverts on
396      * division by zero. The result is rounded towards zero.
397      *
398      * Counterpart to Solidity's `/` operator. Note: this function uses a
399      * `revert` opcode (which leaves remaining gas untouched) while Solidity
400      * uses an invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function div(uint256 a, uint256 b) internal pure returns (uint256) {
407         return div(a, b, "SafeMath: division by zero");
408     }
409 
410     /**
411      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
412      * division by zero. The result is rounded towards zero.
413      *
414      * Counterpart to Solidity's `/` operator. Note: this function uses a
415      * `revert` opcode (which leaves remaining gas untouched) while Solidity
416      * uses an invalid opcode to revert (consuming all remaining gas).
417      *
418      * Requirements:
419      *
420      * - The divisor cannot be zero.
421      */
422     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
423         require(b > 0, errorMessage);
424         uint256 c = a / b;
425         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
426 
427         return c;
428     }
429 
430     /**
431      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
432      * Reverts when dividing by zero.
433      *
434      * Counterpart to Solidity's `%` operator. This function uses a `revert`
435      * opcode (which leaves remaining gas untouched) while Solidity uses an
436      * invalid opcode to revert (consuming all remaining gas).
437      *
438      * Requirements:
439      *
440      * - The divisor cannot be zero.
441      */
442     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
443         return mod(a, b, "SafeMath: modulo by zero");
444     }
445 
446     /**
447      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
448      * Reverts with custom message when dividing by zero.
449      *
450      * Counterpart to Solidity's `%` operator. This function uses a `revert`
451      * opcode (which leaves remaining gas untouched) while Solidity uses an
452      * invalid opcode to revert (consuming all remaining gas).
453      *
454      * Requirements:
455      *
456      * - The divisor cannot be zero.
457      */
458     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
459         require(b != 0, errorMessage);
460         return a % b;
461     }
462 }
463 
464 // Dependency file: @openzeppelin/contracts/math/Math.sol
465 
466 
467 
468 // pragma solidity ^0.6.0;
469 
470 /**
471  * @dev Standard math utilities missing in the Solidity language.
472  */
473 library Math {
474     /**
475      * @dev Returns the largest of two numbers.
476      */
477     function max(uint256 a, uint256 b) internal pure returns (uint256) {
478         return a >= b ? a : b;
479     }
480 
481     /**
482      * @dev Returns the smallest of two numbers.
483      */
484     function min(uint256 a, uint256 b) internal pure returns (uint256) {
485         return a < b ? a : b;
486     }
487 
488     /**
489      * @dev Returns the average of two numbers. The result is rounded towards
490      * zero.
491      */
492     function average(uint256 a, uint256 b) internal pure returns (uint256) {
493         // (a + b) / 2 can overflow, so we distribute
494         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
495     }
496 }
497 
498 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
499 
500 
501 
502 // pragma solidity ^0.6.0;
503 
504 /**
505  * @dev Interface of the ERC20 standard as defined in the EIP.
506  */
507 interface IERC20 {
508     /**
509      * @dev Returns the amount of tokens in existence.
510      */
511     function totalSupply() external view returns (uint256);
512 
513     /**
514      * @dev Returns the amount of tokens owned by `account`.
515      */
516     function balanceOf(address account) external view returns (uint256);
517 
518     /**
519      * @dev Moves `amount` tokens from the caller's account to `recipient`.
520      *
521      * Returns a boolean value indicating whether the operation succeeded.
522      *
523      * Emits a {Transfer} event.
524      */
525     function transfer(address recipient, uint256 amount) external returns (bool);
526 
527     /**
528      * @dev Returns the remaining number of tokens that `spender` will be
529      * allowed to spend on behalf of `owner` through {transferFrom}. This is
530      * zero by default.
531      *
532      * This value changes when {approve} or {transferFrom} are called.
533      */
534     function allowance(address owner, address spender) external view returns (uint256);
535 
536     /**
537      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
538      *
539      * Returns a boolean value indicating whether the operation succeeded.
540      *
541      * // importANT: Beware that changing an allowance with this method brings the risk
542      * that someone may use both the old and the new allowance by unfortunate
543      * transaction ordering. One possible solution to mitigate this race
544      * condition is to first reduce the spender's allowance to 0 and set the
545      * desired value afterwards:
546      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
547      *
548      * Emits an {Approval} event.
549      */
550     function approve(address spender, uint256 amount) external returns (bool);
551 
552     /**
553      * @dev Moves `amount` tokens from `sender` to `recipient` using the
554      * allowance mechanism. `amount` is then deducted from the caller's
555      * allowance.
556      *
557      * Returns a boolean value indicating whether the operation succeeded.
558      *
559      * Emits a {Transfer} event.
560      */
561     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
562 
563     /**
564      * @dev Emitted when `value` tokens are moved from one account (`from`) to
565      * another (`to`).
566      *
567      * Note that `value` may be zero.
568      */
569     event Transfer(address indexed from, address indexed to, uint256 value);
570 
571     /**
572      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
573      * a call to {approve}. `value` is the new allowance.
574      */
575     event Approval(address indexed owner, address indexed spender, uint256 value);
576 }
577 
578 pragma solidity ^0.6.10;
579 
580 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
581 // import { Math } from  "@openzeppelin/contracts/math/Math.sol";
582 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
583 // import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
584 // import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
585 
586 // Inheritance
587 // import { RewardsDistributionRecipient } from  "./RewardsDistributionRecipient.sol";
588 
589 contract StakingRewards is RewardsDistributionRecipient, ReentrancyGuard {
590     using SafeMath for uint256;
591     using SafeERC20 for IERC20;
592 
593     /* ========== STATE VARIABLES ========== */
594 
595     IERC20 public rewardsToken;
596     IERC20 public stakingToken;
597     uint256 public periodFinish = 0;
598     uint256 public rewardRate = 0;
599     uint256 public rewardsDuration = 60 days;
600     uint256 public lastUpdateTime;
601     uint256 public rewardPerTokenStored;
602 
603     mapping(address => uint256) public userRewardPerTokenPaid;
604     mapping(address => uint256) public rewards;
605 
606     uint256 private _totalSupply;
607     mapping(address => uint256) private _balances;
608 
609     /* ========== CONSTRUCTOR ========== */
610 
611     constructor(
612         address _rewardsDistribution,
613         address _rewardsToken,
614         address _stakingToken
615     ) public {
616         rewardsToken = IERC20(_rewardsToken);
617         stakingToken = IERC20(_stakingToken);
618         rewardsDistribution = _rewardsDistribution;
619     }
620 
621     /* ========== VIEWS ========== */
622 
623     function totalSupply() external view returns (uint256) {
624         return _totalSupply;
625     }
626 
627     function balanceOf(address account) external view returns (uint256) {
628         return _balances[account];
629     }
630 
631     function lastTimeRewardApplicable() public view returns (uint256) {
632         return Math.min(block.timestamp, periodFinish);
633     }
634 
635     function rewardPerToken() public view returns (uint256) {
636         if (_totalSupply == 0) {
637             return rewardPerTokenStored;
638         }
639         return
640             rewardPerTokenStored.add(
641                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
642             );
643     }
644 
645     function earned(address account) public view returns (uint256) {
646         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
647     }
648 
649     function getRewardForDuration() external view returns (uint256) {
650         return rewardRate.mul(rewardsDuration);
651     }
652 
653     /* ========== MUTATIVE FUNCTIONS ========== */
654 
655     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
656         require(amount > 0, "Cannot stake 0");
657         _totalSupply = _totalSupply.add(amount);
658         _balances[msg.sender] = _balances[msg.sender].add(amount);
659         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
660         emit Staked(msg.sender, amount);
661     }
662 
663     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
664         require(amount > 0, "Cannot withdraw 0");
665         _totalSupply = _totalSupply.sub(amount);
666         _balances[msg.sender] = _balances[msg.sender].sub(amount);
667         stakingToken.safeTransfer(msg.sender, amount);
668         emit Withdrawn(msg.sender, amount);
669     }
670 
671     function getReward() public nonReentrant updateReward(msg.sender) {
672         uint256 reward = rewards[msg.sender];
673         if (reward > 0) {
674             rewards[msg.sender] = 0;
675             rewardsToken.safeTransfer(msg.sender, reward);
676             emit RewardPaid(msg.sender, reward);
677         }
678     }
679 
680     function exit() external {
681         withdraw(_balances[msg.sender]);
682         getReward();
683     }
684 
685     /* ========== RESTRICTED FUNCTIONS ========== */
686 
687     function notifyRewardAmount(uint256 reward) external override onlyRewardsDistribution updateReward(address(0)) {
688         if (block.timestamp >= periodFinish) {
689             rewardRate = reward.div(rewardsDuration);
690         } else {
691             uint256 remaining = periodFinish.sub(block.timestamp);
692             uint256 leftover = remaining.mul(rewardRate);
693             rewardRate = reward.add(leftover).div(rewardsDuration);
694         }
695 
696         // Ensure the provided reward amount is not more than the balance in the contract.
697         // This keeps the reward rate in the right range, preventing overflows due to
698         // very high values of rewardRate in the earned and rewardsPerToken functions;
699         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
700         uint balance = rewardsToken.balanceOf(address(this));
701         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
702 
703         lastUpdateTime = block.timestamp;
704         periodFinish = block.timestamp.add(rewardsDuration);
705         emit RewardAdded(reward);
706     }
707 
708     /* ========== MODIFIERS ========== */
709 
710     modifier updateReward(address account) {
711         rewardPerTokenStored = rewardPerToken();
712         lastUpdateTime = lastTimeRewardApplicable();
713         if (account != address(0)) {
714             rewards[account] = earned(account);
715             userRewardPerTokenPaid[account] = rewardPerTokenStored;
716         }
717         _;
718     }
719 
720     /* ========== EVENTS ========== */
721 
722     event RewardAdded(uint256 reward);
723     event Staked(address indexed user, uint256 amount);
724     event Withdrawn(address indexed user, uint256 amount);
725     event RewardPaid(address indexed user, uint256 reward);
726 }