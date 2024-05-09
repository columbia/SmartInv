1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-06
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.2 <0.8.0;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.3._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.3._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
196 
197 
198 pragma solidity >=0.6.0 <0.8.0;
199 
200 /**
201  * @dev Interface of the ERC20 standard as defined in the EIP.
202  */
203 interface IERC20 {
204     /**
205      * @dev Returns the amount of tokens in existence.
206      */
207     function totalSupply() external view returns (uint256);
208 
209     /**
210      * @dev Returns the amount of tokens owned by `account`.
211      */
212     function balanceOf(address account) external view returns (uint256);
213 
214     /**
215      * @dev Moves `amount` tokens from the caller's account to `recipient`.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transfer(address recipient, uint256 amount) external returns (bool);
222 
223     /**
224      * @dev Returns the remaining number of tokens that `spender` will be
225      * allowed to spend on behalf of `owner` through {transferFrom}. This is
226      * zero by default.
227      *
228      * This value changes when {approve} or {transferFrom} are called.
229      */
230     function allowance(address owner, address spender) external view returns (uint256);
231 
232     /**
233      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * IMPORTANT: Beware that changing an allowance with this method brings the risk
238      * that someone may use both the old and the new allowance by unfortunate
239      * transaction ordering. One possible solution to mitigate this race
240      * condition is to first reduce the spender's allowance to 0 and set the
241      * desired value afterwards:
242      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243      *
244      * Emits an {Approval} event.
245      */
246     function approve(address spender, uint256 amount) external returns (bool);
247 
248     /**
249      * @dev Moves `amount` tokens from `sender` to `recipient` using the
250      * allowance mechanism. `amount` is then deducted from the caller's
251      * allowance.
252      *
253      * Returns a boolean value indicating whether the operation succeeded.
254      *
255      * Emits a {Transfer} event.
256      */
257     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
258 
259     /**
260      * @dev Emitted when `value` tokens are moved from one account (`from`) to
261      * another (`to`).
262      *
263      * Note that `value` may be zero.
264      */
265     event Transfer(address indexed from, address indexed to, uint256 value);
266 
267     /**
268      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
269      * a call to {approve}. `value` is the new allowance.
270      */
271     event Approval(address indexed owner, address indexed spender, uint256 value);
272 }
273 
274 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol
275 
276 
277 pragma solidity >=0.6.0 <0.8.0;
278 
279 
280 
281 
282 /**
283  * @title SafeERC20
284  * @dev Wrappers around ERC20 operations that throw on failure (when the token
285  * contract returns false). Tokens that return no value (and instead revert or
286  * throw on failure) are also supported, non-reverting calls are assumed to be
287  * successful.
288  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
289  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
290  */
291 library SafeERC20 {
292     using SafeMath for uint256;
293     using Address for address;
294 
295     function safeTransfer(IERC20 token, address to, uint256 value) internal {
296         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
297     }
298 
299     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
300         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
301     }
302 
303     /**
304      * @dev Deprecated. This function has issues similar to the ones found in
305      * {IERC20-approve}, and its usage is discouraged.
306      *
307      * Whenever possible, use {safeIncreaseAllowance} and
308      * {safeDecreaseAllowance} instead.
309      */
310     function safeApprove(IERC20 token, address spender, uint256 value) internal {
311         // safeApprove should only be called when setting an initial allowance,
312         // or when resetting it to zero. To increase and decrease it, use
313         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
314         // solhint-disable-next-line max-line-length
315         require((value == 0) || (token.allowance(address(this), spender) == 0),
316             "SafeERC20: approve from non-zero to non-zero allowance"
317         );
318         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
319     }
320 
321     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
322         uint256 newAllowance = token.allowance(address(this), spender).add(value);
323         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
324     }
325 
326     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
327         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
328         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
329     }
330 
331     /**
332      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
333      * on the return value: the return value is optional (but if data is returned, it must not be false).
334      * @param token The token targeted by the call.
335      * @param data The call data (encoded using abi.encode or one of its variants).
336      */
337     function _callOptionalReturn(IERC20 token, bytes memory data) private {
338         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
339         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
340         // the target address contains contract code and also asserts for success in the low-level call.
341 
342         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
343         if (returndata.length > 0) { // Return data is optional
344             // solhint-disable-next-line max-line-length
345             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
346         }
347     }
348 }
349 
350 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
351 
352 
353 pragma solidity >=0.6.0 <0.8.0;
354 
355 /*
356  * @dev Provides information about the current execution context, including the
357  * sender of the transaction and its data. While these are generally available
358  * via msg.sender and msg.data, they should not be accessed in such a direct
359  * manner, since when dealing with GSN meta-transactions the account sending and
360  * paying for execution may not be the actual sender (as far as an application
361  * is concerned).
362  *
363  * This contract is only required for intermediate, library-like contracts.
364  */
365 abstract contract Context {
366     function _msgSender() internal view virtual returns (address payable) {
367         return msg.sender;
368     }
369 
370     function _msgData() internal view virtual returns (bytes memory) {
371         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
372         return msg.data;
373     }
374 }
375 
376 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
377 
378 
379 pragma solidity >=0.6.0 <0.8.0;
380 
381 /**
382  * @dev Contract module which provides a basic access control mechanism, where
383  * there is an account (an owner) that can be granted exclusive access to
384  * specific functions.
385  *
386  * By default, the owner account will be the one that deploys the contract. This
387  * can later be changed with {transferOwnership}.
388  *
389  * This module is used through inheritance. It will make available the modifier
390  * `onlyOwner`, which can be applied to your functions to restrict their use to
391  * the owner.
392  */
393 abstract contract Ownable is Context {
394     address private _owner;
395 
396     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
397 
398     /**
399      * @dev Initializes the contract setting the deployer as the initial owner.
400      */
401     constructor () internal {
402         address msgSender = _msgSender();
403         _owner = msgSender;
404         emit OwnershipTransferred(address(0), msgSender);
405     }
406 
407     /**
408      * @dev Returns the address of the current owner.
409      */
410     function owner() public view returns (address) {
411         return _owner;
412     }
413 
414     /**
415      * @dev Throws if called by any account other than the owner.
416      */
417     modifier onlyOwner() {
418         require(_owner == _msgSender(), "Ownable: caller is not the owner");
419         _;
420     }
421 
422     /**
423      * @dev Leaves the contract without owner. It will not be possible to call
424      * `onlyOwner` functions anymore. Can only be called by the current owner.
425      *
426      * NOTE: Renouncing ownership will leave the contract without an owner,
427      * thereby removing any functionality that is only available to the owner.
428      */
429     function renounceOwnership() public virtual onlyOwner {
430         emit OwnershipTransferred(_owner, address(0));
431         _owner = address(0);
432     }
433 
434     /**
435      * @dev Transfers ownership of the contract to a new account (`newOwner`).
436      * Can only be called by the current owner.
437      */
438     function transferOwnership(address newOwner) public virtual onlyOwner {
439         require(newOwner != address(0), "Ownable: new owner is the zero address");
440         emit OwnershipTransferred(_owner, newOwner);
441         _owner = newOwner;
442     }
443 }
444 
445 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
446 
447 
448 pragma solidity >=0.6.0 <0.8.0;
449 
450 /**
451  * @dev Wrappers over Solidity's arithmetic operations with added overflow
452  * checks.
453  *
454  * Arithmetic operations in Solidity wrap on overflow. This can easily result
455  * in bugs, because programmers usually assume that an overflow raises an
456  * error, which is the standard behavior in high level programming languages.
457  * `SafeMath` restores this intuition by reverting the transaction when an
458  * operation overflows.
459  *
460  * Using this library instead of the unchecked operations eliminates an entire
461  * class of bugs, so it's recommended to use it always.
462  */
463 library SafeMath {
464     /**
465      * @dev Returns the addition of two unsigned integers, reverting on
466      * overflow.
467      *
468      * Counterpart to Solidity's `+` operator.
469      *
470      * Requirements:
471      *
472      * - Addition cannot overflow.
473      */
474     function add(uint256 a, uint256 b) internal pure returns (uint256) {
475         uint256 c = a + b;
476         require(c >= a, "SafeMath: addition overflow");
477 
478         return c;
479     }
480 
481     /**
482      * @dev Returns the subtraction of two unsigned integers, reverting on
483      * overflow (when the result is negative).
484      *
485      * Counterpart to Solidity's `-` operator.
486      *
487      * Requirements:
488      *
489      * - Subtraction cannot overflow.
490      */
491     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
492         return sub(a, b, "SafeMath: subtraction overflow");
493     }
494 
495     /**
496      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
497      * overflow (when the result is negative).
498      *
499      * Counterpart to Solidity's `-` operator.
500      *
501      * Requirements:
502      *
503      * - Subtraction cannot overflow.
504      */
505     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
506         require(b <= a, errorMessage);
507         uint256 c = a - b;
508 
509         return c;
510     }
511 
512     /**
513      * @dev Returns the multiplication of two unsigned integers, reverting on
514      * overflow.
515      *
516      * Counterpart to Solidity's `*` operator.
517      *
518      * Requirements:
519      *
520      * - Multiplication cannot overflow.
521      */
522     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
523         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
524         // benefit is lost if 'b' is also tested.
525         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
526         if (a == 0) {
527             return 0;
528         }
529 
530         uint256 c = a * b;
531         require(c / a == b, "SafeMath: multiplication overflow");
532 
533         return c;
534     }
535 
536     /**
537      * @dev Returns the integer division of two unsigned integers. Reverts on
538      * division by zero. The result is rounded towards zero.
539      *
540      * Counterpart to Solidity's `/` operator. Note: this function uses a
541      * `revert` opcode (which leaves remaining gas untouched) while Solidity
542      * uses an invalid opcode to revert (consuming all remaining gas).
543      *
544      * Requirements:
545      *
546      * - The divisor cannot be zero.
547      */
548     function div(uint256 a, uint256 b) internal pure returns (uint256) {
549         return div(a, b, "SafeMath: division by zero");
550     }
551 
552     /**
553      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
554      * division by zero. The result is rounded towards zero.
555      *
556      * Counterpart to Solidity's `/` operator. Note: this function uses a
557      * `revert` opcode (which leaves remaining gas untouched) while Solidity
558      * uses an invalid opcode to revert (consuming all remaining gas).
559      *
560      * Requirements:
561      *
562      * - The divisor cannot be zero.
563      */
564     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
565         require(b > 0, errorMessage);
566         uint256 c = a / b;
567         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
568 
569         return c;
570     }
571 
572     /**
573      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
574      * Reverts when dividing by zero.
575      *
576      * Counterpart to Solidity's `%` operator. This function uses a `revert`
577      * opcode (which leaves remaining gas untouched) while Solidity uses an
578      * invalid opcode to revert (consuming all remaining gas).
579      *
580      * Requirements:
581      *
582      * - The divisor cannot be zero.
583      */
584     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
585         return mod(a, b, "SafeMath: modulo by zero");
586     }
587 
588     /**
589      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
590      * Reverts with custom message when dividing by zero.
591      *
592      * Counterpart to Solidity's `%` operator. This function uses a `revert`
593      * opcode (which leaves remaining gas untouched) while Solidity uses an
594      * invalid opcode to revert (consuming all remaining gas).
595      *
596      * Requirements:
597      *
598      * - The divisor cannot be zero.
599      */
600     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
601         require(b != 0, errorMessage);
602         return a % b;
603     }
604 }
605 
606 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
607 
608 
609 pragma solidity >=0.6.0 <0.8.0;
610 
611 /**
612  * @dev Standard math utilities missing in the Solidity language.
613  */
614 library Math {
615     /**
616      * @dev Returns the largest of two numbers.
617      */
618     function max(uint256 a, uint256 b) internal pure returns (uint256) {
619         return a >= b ? a : b;
620     }
621 
622     /**
623      * @dev Returns the smallest of two numbers.
624      */
625     function min(uint256 a, uint256 b) internal pure returns (uint256) {
626         return a < b ? a : b;
627     }
628 
629     /**
630      * @dev Returns the average of two numbers. The result is rounded towards
631      * zero.
632      */
633     function average(uint256 a, uint256 b) internal pure returns (uint256) {
634         // (a + b) / 2 can overflow, so we distribute
635         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
636     }
637 }
638 
639 // File: browser/Staking.sol
640 
641 
642 pragma solidity 0.7.4;
643 
644 contract SporesStaking is Ownable {
645     using SafeMath for uint256;
646     using SafeERC20 for IERC20;
647 
648     IERC20 public stakeToken;
649     IERC20 public rewardToken;
650 
651     uint256 public constant DURATION = 30 days;
652     uint256 private _totalSupply;
653     uint256 public periodFinish = 0;
654     uint256 public rewardRate = 0;
655     uint256 public lastUpdateTime;
656     uint256 public rewardPerTokenStored;
657 
658     address public rewardDistribution;
659 
660     mapping(address => uint256) private _balances;
661     mapping(address => uint256) public userRewardPerTokenPaid;
662     mapping(address => uint256) public rewards;
663 
664     event RewardAdded(uint256 reward);
665     event Staked(address indexed user, uint256 amount);
666     event Unstaked(address indexed user, uint256 amount);
667     event RewardPaid(address indexed user, uint256 reward);
668     event RecoverToken(address indexed token, uint256 indexed amount);
669 
670     modifier onlyRewardDistribution() {
671         require(
672             msg.sender == rewardDistribution,
673             "Caller is not reward distribution"
674         );
675         _;
676     }
677 
678     modifier updateReward(address account) {
679         rewardPerTokenStored = rewardPerToken();
680         lastUpdateTime = lastTimeRewardApplicable();
681         if (account != address(0)) {
682             rewards[account] = earned(account);
683             userRewardPerTokenPaid[account] = rewardPerTokenStored;
684         }
685         _;
686     }
687 
688     constructor(IERC20 _stakeToken, IERC20 _rewardToken) {
689         stakeToken = _stakeToken;
690         rewardToken = _rewardToken;
691     }
692 
693     function lastTimeRewardApplicable() public view returns (uint256) {
694         return Math.min(block.timestamp, periodFinish);
695     }
696 
697     function rewardPerToken() public view returns (uint256) {
698         if (totalSupply() == 0) {
699             return rewardPerTokenStored;
700         }
701         return
702             rewardPerTokenStored.add(
703                 lastTimeRewardApplicable()
704                     .sub(lastUpdateTime)
705                     .mul(rewardRate)
706                     .mul(1e18)
707                     .div(totalSupply())
708             );
709     }
710 
711     function earned(address account) public view returns (uint256) {
712         return
713             balanceOf(account)
714                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
715                 .div(1e18)
716                 .add(rewards[account]);
717     }
718 
719     function stake(uint256 amount) public updateReward(msg.sender) {
720         require(amount > 0, "Cannot stake 0");
721         _totalSupply = _totalSupply.add(amount);
722         _balances[msg.sender] = _balances[msg.sender].add(amount);
723         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
724         emit Staked(msg.sender, amount);
725     }
726 
727     function unstake(uint256 amount) public updateReward(msg.sender) {
728         require(amount > 0, "Cannot withdraw 0");
729         _totalSupply = _totalSupply.sub(amount);
730         _balances[msg.sender] = _balances[msg.sender].sub(amount);
731         stakeToken.safeTransfer(msg.sender, amount);
732         emit Unstaked(msg.sender, amount);
733     }
734 
735     function exit() external {
736         unstake(balanceOf(msg.sender));
737         getReward();
738     }
739 
740     function getReward() public updateReward(msg.sender) {
741         uint256 reward = earned(msg.sender);
742         if (reward > 0) {
743             rewards[msg.sender] = 0;
744             rewardToken.safeTransfer(msg.sender, reward);
745             emit RewardPaid(msg.sender, reward);
746         }
747     }
748 
749     function notifyRewardAmount(uint256 reward)
750         external
751         onlyRewardDistribution
752         updateReward(address(0))
753     {
754         if (block.timestamp >= periodFinish) {
755             rewardRate = reward.div(DURATION);
756         } else {
757             uint256 remaining = periodFinish.sub(block.timestamp);
758             uint256 leftover = remaining.mul(rewardRate);
759             rewardRate = reward.add(leftover).div(DURATION);
760         }
761         lastUpdateTime = block.timestamp;
762         periodFinish = block.timestamp.add(DURATION);
763         emit RewardAdded(reward);
764     }
765 
766     function setRewardDistribution(address _rewardDistribution)
767         external
768         onlyOwner
769     {
770         rewardDistribution = _rewardDistribution;
771     }
772 
773     function totalSupply() public view returns (uint256) {
774         return _totalSupply;
775     }
776 
777     function balanceOf(address account) public view returns (uint256) {
778         return _balances[account];
779     }
780 
781     function recoverExcessToken(address token, uint256 amount) external onlyOwner {
782         IERC20(token).safeTransfer(_msgSender(), amount);
783         emit RecoverToken(token, amount);
784     }
785 }