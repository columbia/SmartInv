1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-23
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-03-07
7 */
8 
9 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
10 
11 // SPDX-License-Identifier: MIT
12 
13 
14 pragma solidity >=0.6.2 <0.8.0;
15 
16 /**
17  * @dev Collection of functions related to the address type
18  */
19 library Address {
20     /**
21      * @dev Returns true if `account` is a contract.
22      *
23      * [IMPORTANT]
24      * ====
25      * It is unsafe to assume that an address for which this function returns
26      * false is an externally-owned account (EOA) and not a contract.
27      *
28      * Among others, `isContract` will return false for the following
29      * types of addresses:
30      *
31      *  - an externally-owned account
32      *  - a contract in construction
33      *  - an address where a contract will be created
34      *  - an address where a contract lived, but was destroyed
35      * ====
36      */
37     function isContract(address account) internal view returns (bool) {
38         // This method relies on extcodesize, which returns 0 for contracts in
39         // construction, since the code is only stored at the end of the
40         // constructor execution.
41 
42         uint256 size;
43         // solhint-disable-next-line no-inline-assembly
44         assembly { size := extcodesize(account) }
45         return size > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
68         (bool success, ) = recipient.call{ value: amount }("");
69         require(success, "Address: unable to send value, recipient may have reverted");
70     }
71 
72     /**
73      * @dev Performs a Solidity function call using a low level `call`. A
74      * plain`call` is an unsafe replacement for a function call: use this
75      * function instead.
76      *
77      * If `target` reverts with a revert reason, it is bubbled up by this
78      * function (like regular Solidity function calls).
79      *
80      * Returns the raw returned data. To convert to the expected return value,
81      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
82      *
83      * Requirements:
84      *
85      * - `target` must be a contract.
86      * - calling `target` with `data` must not revert.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
91       return functionCall(target, data, "Address: low-level call failed");
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
96      * `errorMessage` as a fallback revert reason when `target` reverts.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
101         return functionCallWithValue(target, data, 0, errorMessage);
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
106      * but also transferring `value` wei to `target`.
107      *
108      * Requirements:
109      *
110      * - the calling contract must have an ETH balance of at least `value`.
111      * - the called Solidity function must be `payable`.
112      *
113      * _Available since v3.1._
114      */
115     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
121      * with `errorMessage` as a fallback revert reason when `target` reverts.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
126         require(address(this).balance >= value, "Address: insufficient balance for call");
127         require(isContract(target), "Address: call to non-contract");
128 
129         // solhint-disable-next-line avoid-low-level-calls
130         (bool success, bytes memory returndata) = target.call{ value: value }(data);
131         return _verifyCallResult(success, returndata, errorMessage);
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
136      * but performing a static call.
137      *
138      * _Available since v3.3._
139      */
140     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
141         return functionStaticCall(target, data, "Address: low-level static call failed");
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
151         require(isContract(target), "Address: static call to non-contract");
152 
153         // solhint-disable-next-line avoid-low-level-calls
154         (bool success, bytes memory returndata) = target.staticcall(data);
155         return _verifyCallResult(success, returndata, errorMessage);
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
160      * but performing a delegate call.
161      *
162      * _Available since v3.3._
163      */
164     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
170      * but performing a delegate call.
171      *
172      * _Available since v3.3._
173      */
174     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
175         require(isContract(target), "Address: delegate call to non-contract");
176 
177         // solhint-disable-next-line avoid-low-level-calls
178         (bool success, bytes memory returndata) = target.delegatecall(data);
179         return _verifyCallResult(success, returndata, errorMessage);
180     }
181 
182     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
183         if (success) {
184             return returndata;
185         } else {
186             // Look for revert reason and bubble it up if present
187             if (returndata.length > 0) {
188                 // The easiest way to bubble the revert reason is using memory via assembly
189 
190                 // solhint-disable-next-line no-inline-assembly
191                 assembly {
192                     let returndata_size := mload(returndata)
193                     revert(add(32, returndata), returndata_size)
194                 }
195             } else {
196                 revert(errorMessage);
197             }
198         }
199     }
200 }
201 
202 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
203 
204 
205 pragma solidity >=0.6.0 <0.8.0;
206 
207 /**
208  * @dev Interface of the ERC20 standard as defined in the EIP.
209  */
210 interface IERC20 {
211     /**
212      * @dev Returns the amount of tokens in existence.
213      */
214     function totalSupply() external view returns (uint256);
215 
216     /**
217      * @dev Returns the amount of tokens owned by `account`.
218      */
219     function balanceOf(address account) external view returns (uint256);
220 
221     /**
222      * @dev Moves `amount` tokens from the caller's account to `recipient`.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transfer(address recipient, uint256 amount) external returns (bool);
229 
230     /**
231      * @dev Returns the remaining number of tokens that `spender` will be
232      * allowed to spend on behalf of `owner` through {transferFrom}. This is
233      * zero by default.
234      *
235      * This value changes when {approve} or {transferFrom} are called.
236      */
237     function allowance(address owner, address spender) external view returns (uint256);
238 
239     /**
240      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
241      *
242      * Returns a boolean value indicating whether the operation succeeded.
243      *
244      * IMPORTANT: Beware that changing an allowance with this method brings the risk
245      * that someone may use both the old and the new allowance by unfortunate
246      * transaction ordering. One possible solution to mitigate this race
247      * condition is to first reduce the spender's allowance to 0 and set the
248      * desired value afterwards:
249      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250      *
251      * Emits an {Approval} event.
252      */
253     function approve(address spender, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Moves `amount` tokens from `sender` to `recipient` using the
257      * allowance mechanism. `amount` is then deducted from the caller's
258      * allowance.
259      *
260      * Returns a boolean value indicating whether the operation succeeded.
261      *
262      * Emits a {Transfer} event.
263      */
264     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
265 
266     /**
267      * @dev Emitted when `value` tokens are moved from one account (`from`) to
268      * another (`to`).
269      *
270      * Note that `value` may be zero.
271      */
272     event Transfer(address indexed from, address indexed to, uint256 value);
273 
274     /**
275      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
276      * a call to {approve}. `value` is the new allowance.
277      */
278     event Approval(address indexed owner, address indexed spender, uint256 value);
279 }
280 
281 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol
282 
283 
284 pragma solidity >=0.6.0 <0.8.0;
285 
286 
287 
288 
289 /**
290  * @title SafeERC20
291  * @dev Wrappers around ERC20 operations that throw on failure (when the token
292  * contract returns false). Tokens that return no value (and instead revert or
293  * throw on failure) are also supported, non-reverting calls are assumed to be
294  * successful.
295  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
296  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
297  */
298 library SafeERC20 {
299     using SafeMath for uint256;
300     using Address for address;
301 
302     function safeTransfer(IERC20 token, address to, uint256 value) internal {
303         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
304     }
305 
306     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
307         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
308     }
309 
310     /**
311      * @dev Deprecated. This function has issues similar to the ones found in
312      * {IERC20-approve}, and its usage is discouraged.
313      *
314      * Whenever possible, use {safeIncreaseAllowance} and
315      * {safeDecreaseAllowance} instead.
316      */
317     function safeApprove(IERC20 token, address spender, uint256 value) internal {
318         // safeApprove should only be called when setting an initial allowance,
319         // or when resetting it to zero. To increase and decrease it, use
320         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
321         // solhint-disable-next-line max-line-length
322         require((value == 0) || (token.allowance(address(this), spender) == 0),
323             "SafeERC20: approve from non-zero to non-zero allowance"
324         );
325         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
326     }
327 
328     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
329         uint256 newAllowance = token.allowance(address(this), spender).add(value);
330         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
331     }
332 
333     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
334         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
335         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
336     }
337 
338     /**
339      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
340      * on the return value: the return value is optional (but if data is returned, it must not be false).
341      * @param token The token targeted by the call.
342      * @param data The call data (encoded using abi.encode or one of its variants).
343      */
344     function _callOptionalReturn(IERC20 token, bytes memory data) private {
345         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
346         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
347         // the target address contains contract code and also asserts for success in the low-level call.
348 
349         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
350         if (returndata.length > 0) { // Return data is optional
351             // solhint-disable-next-line max-line-length
352             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
353         }
354     }
355 }
356 
357 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
358 
359 
360 pragma solidity >=0.6.0 <0.8.0;
361 
362 /*
363  * @dev Provides information about the current execution context, including the
364  * sender of the transaction and its data. While these are generally available
365  * via msg.sender and msg.data, they should not be accessed in such a direct
366  * manner, since when dealing with GSN meta-transactions the account sending and
367  * paying for execution may not be the actual sender (as far as an application
368  * is concerned).
369  *
370  * This contract is only required for intermediate, library-like contracts.
371  */
372 abstract contract Context {
373     function _msgSender() internal view virtual returns (address payable) {
374         return msg.sender;
375     }
376 
377     function _msgData() internal view virtual returns (bytes memory) {
378         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
379         return msg.data;
380     }
381 }
382 
383 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
384 
385 
386 pragma solidity >=0.6.0 <0.8.0;
387 
388 /**
389  * @dev Contract module which provides a basic access control mechanism, where
390  * there is an account (an owner) that can be granted exclusive access to
391  * specific functions.
392  *
393  * By default, the owner account will be the one that deploys the contract. This
394  * can later be changed with {transferOwnership}.
395  *
396  * This module is used through inheritance. It will make available the modifier
397  * `onlyOwner`, which can be applied to your functions to restrict their use to
398  * the owner.
399  */
400 abstract contract Ownable is Context {
401     address private _owner;
402 
403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
404 
405     /**
406      * @dev Initializes the contract setting the deployer as the initial owner.
407      */
408     constructor () internal {
409         address msgSender = _msgSender();
410         _owner = msgSender;
411         emit OwnershipTransferred(address(0), msgSender);
412     }
413 
414     /**
415      * @dev Returns the address of the current owner.
416      */
417     function owner() public view returns (address) {
418         return _owner;
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         require(_owner == _msgSender(), "Ownable: caller is not the owner");
426         _;
427     }
428 
429     /**
430      * @dev Leaves the contract without owner. It will not be possible to call
431      * `onlyOwner` functions anymore. Can only be called by the current owner.
432      *
433      * NOTE: Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public virtual onlyOwner {
437         emit OwnershipTransferred(_owner, address(0));
438         _owner = address(0);
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Can only be called by the current owner.
444      */
445     function transferOwnership(address newOwner) public virtual onlyOwner {
446         require(newOwner != address(0), "Ownable: new owner is the zero address");
447         emit OwnershipTransferred(_owner, newOwner);
448         _owner = newOwner;
449     }
450 }
451 
452 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
453 
454 
455 pragma solidity >=0.6.0 <0.8.0;
456 
457 /**
458  * @dev Wrappers over Solidity's arithmetic operations with added overflow
459  * checks.
460  *
461  * Arithmetic operations in Solidity wrap on overflow. This can easily result
462  * in bugs, because programmers usually assume that an overflow raises an
463  * error, which is the standard behavior in high level programming languages.
464  * `SafeMath` restores this intuition by reverting the transaction when an
465  * operation overflows.
466  *
467  * Using this library instead of the unchecked operations eliminates an entire
468  * class of bugs, so it's recommended to use it always.
469  */
470 library SafeMath {
471     /**
472      * @dev Returns the addition of two unsigned integers, reverting on
473      * overflow.
474      *
475      * Counterpart to Solidity's `+` operator.
476      *
477      * Requirements:
478      *
479      * - Addition cannot overflow.
480      */
481     function add(uint256 a, uint256 b) internal pure returns (uint256) {
482         uint256 c = a + b;
483         require(c >= a, "SafeMath: addition overflow");
484 
485         return c;
486     }
487 
488     /**
489      * @dev Returns the subtraction of two unsigned integers, reverting on
490      * overflow (when the result is negative).
491      *
492      * Counterpart to Solidity's `-` operator.
493      *
494      * Requirements:
495      *
496      * - Subtraction cannot overflow.
497      */
498     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
499         return sub(a, b, "SafeMath: subtraction overflow");
500     }
501 
502     /**
503      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
504      * overflow (when the result is negative).
505      *
506      * Counterpart to Solidity's `-` operator.
507      *
508      * Requirements:
509      *
510      * - Subtraction cannot overflow.
511      */
512     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
513         require(b <= a, errorMessage);
514         uint256 c = a - b;
515 
516         return c;
517     }
518 
519     /**
520      * @dev Returns the multiplication of two unsigned integers, reverting on
521      * overflow.
522      *
523      * Counterpart to Solidity's `*` operator.
524      *
525      * Requirements:
526      *
527      * - Multiplication cannot overflow.
528      */
529     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
530         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
531         // benefit is lost if 'b' is also tested.
532         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
533         if (a == 0) {
534             return 0;
535         }
536 
537         uint256 c = a * b;
538         require(c / a == b, "SafeMath: multiplication overflow");
539 
540         return c;
541     }
542 
543     /**
544      * @dev Returns the integer division of two unsigned integers. Reverts on
545      * division by zero. The result is rounded towards zero.
546      *
547      * Counterpart to Solidity's `/` operator. Note: this function uses a
548      * `revert` opcode (which leaves remaining gas untouched) while Solidity
549      * uses an invalid opcode to revert (consuming all remaining gas).
550      *
551      * Requirements:
552      *
553      * - The divisor cannot be zero.
554      */
555     function div(uint256 a, uint256 b) internal pure returns (uint256) {
556         return div(a, b, "SafeMath: division by zero");
557     }
558 
559     /**
560      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
561      * division by zero. The result is rounded towards zero.
562      *
563      * Counterpart to Solidity's `/` operator. Note: this function uses a
564      * `revert` opcode (which leaves remaining gas untouched) while Solidity
565      * uses an invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
572         require(b > 0, errorMessage);
573         uint256 c = a / b;
574         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
575 
576         return c;
577     }
578 
579     /**
580      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
581      * Reverts when dividing by zero.
582      *
583      * Counterpart to Solidity's `%` operator. This function uses a `revert`
584      * opcode (which leaves remaining gas untouched) while Solidity uses an
585      * invalid opcode to revert (consuming all remaining gas).
586      *
587      * Requirements:
588      *
589      * - The divisor cannot be zero.
590      */
591     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
592         return mod(a, b, "SafeMath: modulo by zero");
593     }
594 
595     /**
596      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
597      * Reverts with custom message when dividing by zero.
598      *
599      * Counterpart to Solidity's `%` operator. This function uses a `revert`
600      * opcode (which leaves remaining gas untouched) while Solidity uses an
601      * invalid opcode to revert (consuming all remaining gas).
602      *
603      * Requirements:
604      *
605      * - The divisor cannot be zero.
606      */
607     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
608         require(b != 0, errorMessage);
609         return a % b;
610     }
611 }
612 
613 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
614 
615 
616 pragma solidity >=0.6.0 <0.8.0;
617 
618 /**
619  * @dev Standard math utilities missing in the Solidity language.
620  */
621 library Math {
622     /**
623      * @dev Returns the largest of two numbers.
624      */
625     function max(uint256 a, uint256 b) internal pure returns (uint256) {
626         return a >= b ? a : b;
627     }
628 
629     /**
630      * @dev Returns the smallest of two numbers.
631      */
632     function min(uint256 a, uint256 b) internal pure returns (uint256) {
633         return a < b ? a : b;
634     }
635 
636     /**
637      * @dev Returns the average of two numbers. The result is rounded towards
638      * zero.
639      */
640     function average(uint256 a, uint256 b) internal pure returns (uint256) {
641         // (a + b) / 2 can overflow, so we distribute
642         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
643     }
644 }
645 
646 // File: browser/Staking.sol
647 
648 
649 pragma solidity 0.7.4;
650 
651 contract UnmarshalStaking is Ownable {
652     using SafeMath for uint256;
653     using SafeERC20 for IERC20;
654 
655     IERC20 public stakeToken;
656     IERC20 public rewardToken;
657 
658     uint256 public constant DURATION = 180 days;
659     uint256 private _totalSupply;
660     uint256 public periodFinish = 0;
661     uint256 public rewardRate = 0;
662     uint256 public lastUpdateTime;
663     uint256 public rewardPerTokenStored;
664 
665     address public rewardDistribution;
666 
667     mapping(address => uint256) private _balances;
668     mapping(address => uint256) public userRewardPerTokenPaid;
669     mapping(address => uint256) public rewards;
670 
671     event RewardAdded(uint256 reward);
672     event Staked(address indexed user, uint256 amount);
673     event Unstaked(address indexed user, uint256 amount);
674     event RewardPaid(address indexed user, uint256 reward);
675     event RecoverToken(address indexed token, uint256 indexed amount);
676 
677     modifier onlyRewardDistribution() {
678         require(
679             msg.sender == rewardDistribution,
680             "Caller is not reward distribution"
681         );
682         _;
683     }
684 
685     modifier updateReward(address account) {
686         rewardPerTokenStored = rewardPerToken();
687         lastUpdateTime = lastTimeRewardApplicable();
688         if (account != address(0)) {
689             rewards[account] = earned(account);
690             userRewardPerTokenPaid[account] = rewardPerTokenStored;
691         }
692         _;
693     }
694 
695     constructor(IERC20 _stakeToken, IERC20 _rewardToken) {
696         stakeToken = _stakeToken;
697         rewardToken = _rewardToken;
698     }
699 
700     function lastTimeRewardApplicable() public view returns (uint256) {
701         return Math.min(block.timestamp, periodFinish);
702     }
703 
704     function rewardPerToken() public view returns (uint256) {
705         if (totalSupply() == 0) {
706             return rewardPerTokenStored;
707         }
708         return
709             rewardPerTokenStored.add(
710                 lastTimeRewardApplicable()
711                     .sub(lastUpdateTime)
712                     .mul(rewardRate)
713                     .mul(1e18)
714                     .div(totalSupply())
715             );
716     }
717 
718     function earned(address account) public view returns (uint256) {
719         return
720             balanceOf(account)
721                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
722                 .div(1e18)
723                 .add(rewards[account]);
724     }
725 
726     function stake(uint256 amount) public updateReward(msg.sender) {
727         require(amount > 0, "Cannot stake 0");
728         _totalSupply = _totalSupply.add(amount);
729         _balances[msg.sender] = _balances[msg.sender].add(amount);
730         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
731         emit Staked(msg.sender, amount);
732     }
733 
734     function unstake(uint256 amount) public updateReward(msg.sender) {
735         require(amount > 0, "Cannot withdraw 0");
736         _totalSupply = _totalSupply.sub(amount);
737         _balances[msg.sender] = _balances[msg.sender].sub(amount);
738         stakeToken.safeTransfer(msg.sender, amount);
739         emit Unstaked(msg.sender, amount);
740     }
741 
742     function exit() external {
743         unstake(balanceOf(msg.sender));
744         getReward();
745     }
746 
747     function getReward() public updateReward(msg.sender) {
748         uint256 reward = earned(msg.sender);
749         if (reward > 0) {
750             rewards[msg.sender] = 0;
751             rewardToken.safeTransfer(msg.sender, reward);
752             emit RewardPaid(msg.sender, reward);
753         }
754     }
755 
756     function notifyRewardAmount(uint256 reward)
757         external
758         onlyRewardDistribution
759         updateReward(address(0))
760     {
761         if (block.timestamp >= periodFinish) {
762             rewardRate = reward.div(DURATION);
763         } else {
764             uint256 remaining = periodFinish.sub(block.timestamp);
765             uint256 leftover = remaining.mul(rewardRate);
766             rewardRate = reward.add(leftover).div(DURATION);
767         }
768         lastUpdateTime = block.timestamp;
769         periodFinish = block.timestamp.add(DURATION);
770         emit RewardAdded(reward);
771     }
772 
773     function setRewardDistribution(address _rewardDistribution)
774         external
775         onlyOwner
776     {
777         rewardDistribution = _rewardDistribution;
778     }
779 
780     function totalSupply() public view returns (uint256) {
781         return _totalSupply;
782     }
783 
784     function balanceOf(address account) public view returns (uint256) {
785         return _balances[account];
786     }
787 
788     function recoverExcessToken(address token, uint256 amount) external onlyOwner {
789         IERC20(token).safeTransfer(_msgSender(), amount);
790         emit RecoverToken(token, amount);
791     }
792 }