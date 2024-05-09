1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.2 <0.8.0;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
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
27         // This method relies on extcodesize, which returns 0 for contracts in
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
48      * IMPORTANT: because control is transferred to `recipient`, care must be
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
90         return functionCallWithValue(target, data, 0, errorMessage);
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
116         require(isContract(target), "Address: call to non-contract");
117 
118         // solhint-disable-next-line avoid-low-level-calls
119         (bool success, bytes memory returndata) = target.call{ value: value }(data);
120         return _verifyCallResult(success, returndata, errorMessage);
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
125      * but performing a static call.
126      *
127      * _Available since v3.3._
128      */
129     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
130         return functionStaticCall(target, data, "Address: low-level static call failed");
131     }
132 
133     /**
134      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
135      * but performing a static call.
136      *
137      * _Available since v3.3._
138      */
139     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
140         require(isContract(target), "Address: static call to non-contract");
141 
142         // solhint-disable-next-line avoid-low-level-calls
143         (bool success, bytes memory returndata) = target.staticcall(data);
144         return _verifyCallResult(success, returndata, errorMessage);
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
149      * but performing a delegate call.
150      *
151      * _Available since v3.3._
152      */
153     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
154         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
159      * but performing a delegate call.
160      *
161      * _Available since v3.3._
162      */
163     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
164         require(isContract(target), "Address: delegate call to non-contract");
165 
166         // solhint-disable-next-line avoid-low-level-calls
167         (bool success, bytes memory returndata) = target.delegatecall(data);
168         return _verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
172         if (success) {
173             return returndata;
174         } else {
175             // Look for revert reason and bubble it up if present
176             if (returndata.length > 0) {
177                 // The easiest way to bubble the revert reason is using memory via assembly
178 
179                 // solhint-disable-next-line no-inline-assembly
180                 assembly {
181                     let returndata_size := mload(returndata)
182                     revert(add(32, returndata), returndata_size)
183                 }
184             } else {
185                 revert(errorMessage);
186             }
187         }
188     }
189 }
190 
191 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
192 
193 
194 pragma solidity >=0.6.0 <0.8.0;
195 
196 /**
197  * @dev Interface of the ERC20 standard as defined in the EIP.
198  */
199 interface IERC20 {
200     /**
201      * @dev Returns the amount of tokens in existence.
202      */
203     function totalSupply() external view returns (uint256);
204 
205     /**
206      * @dev Returns the amount of tokens owned by `account`.
207      */
208     function balanceOf(address account) external view returns (uint256);
209 
210     /**
211      * @dev Moves `amount` tokens from the caller's account to `recipient`.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transfer(address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Returns the remaining number of tokens that `spender` will be
221      * allowed to spend on behalf of `owner` through {transferFrom}. This is
222      * zero by default.
223      *
224      * This value changes when {approve} or {transferFrom} are called.
225      */
226     function allowance(address owner, address spender) external view returns (uint256);
227 
228     /**
229      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * IMPORTANT: Beware that changing an allowance with this method brings the risk
234      * that someone may use both the old and the new allowance by unfortunate
235      * transaction ordering. One possible solution to mitigate this race
236      * condition is to first reduce the spender's allowance to 0 and set the
237      * desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address spender, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Moves `amount` tokens from `sender` to `recipient` using the
246      * allowance mechanism. `amount` is then deducted from the caller's
247      * allowance.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Emitted when `value` tokens are moved from one account (`from`) to
257      * another (`to`).
258      *
259      * Note that `value` may be zero.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 value);
262 
263     /**
264      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
265      * a call to {approve}. `value` is the new allowance.
266      */
267     event Approval(address indexed owner, address indexed spender, uint256 value);
268 }
269 
270 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol
271 
272 
273 pragma solidity >=0.6.0 <0.8.0;
274 
275 
276 
277 
278 /**
279  * @title SafeERC20
280  * @dev Wrappers around ERC20 operations that throw on failure (when the token
281  * contract returns false). Tokens that return no value (and instead revert or
282  * throw on failure) are also supported, non-reverting calls are assumed to be
283  * successful.
284  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
285  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
286  */
287 library SafeERC20 {
288     using SafeMath for uint256;
289     using Address for address;
290 
291     function safeTransfer(IERC20 token, address to, uint256 value) internal {
292         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
293     }
294 
295     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
296         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
297     }
298 
299     /**
300      * @dev Deprecated. This function has issues similar to the ones found in
301      * {IERC20-approve}, and its usage is discouraged.
302      *
303      * Whenever possible, use {safeIncreaseAllowance} and
304      * {safeDecreaseAllowance} instead.
305      */
306     function safeApprove(IERC20 token, address spender, uint256 value) internal {
307         // safeApprove should only be called when setting an initial allowance,
308         // or when resetting it to zero. To increase and decrease it, use
309         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
310         // solhint-disable-next-line max-line-length
311         require((value == 0) || (token.allowance(address(this), spender) == 0),
312             "SafeERC20: approve from non-zero to non-zero allowance"
313         );
314         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
315     }
316 
317     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
318         uint256 newAllowance = token.allowance(address(this), spender).add(value);
319         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
320     }
321 
322     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
323         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
324         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
325     }
326 
327     /**
328      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
329      * on the return value: the return value is optional (but if data is returned, it must not be false).
330      * @param token The token targeted by the call.
331      * @param data The call data (encoded using abi.encode or one of its variants).
332      */
333     function _callOptionalReturn(IERC20 token, bytes memory data) private {
334         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
335         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
336         // the target address contains contract code and also asserts for success in the low-level call.
337 
338         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
339         if (returndata.length > 0) { // Return data is optional
340             // solhint-disable-next-line max-line-length
341             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
342         }
343     }
344 }
345 
346 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
347 
348 
349 pragma solidity >=0.6.0 <0.8.0;
350 
351 /*
352  * @dev Provides information about the current execution context, including the
353  * sender of the transaction and its data. While these are generally available
354  * via msg.sender and msg.data, they should not be accessed in such a direct
355  * manner, since when dealing with GSN meta-transactions the account sending and
356  * paying for execution may not be the actual sender (as far as an application
357  * is concerned).
358  *
359  * This contract is only required for intermediate, library-like contracts.
360  */
361 abstract contract Context {
362     function _msgSender() internal view virtual returns (address payable) {
363         return msg.sender;
364     }
365 
366     function _msgData() internal view virtual returns (bytes memory) {
367         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
368         return msg.data;
369     }
370 }
371 
372 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
373 
374 
375 pragma solidity >=0.6.0 <0.8.0;
376 
377 /**
378  * @dev Contract module which provides a basic access control mechanism, where
379  * there is an account (an owner) that can be granted exclusive access to
380  * specific functions.
381  *
382  * By default, the owner account will be the one that deploys the contract. This
383  * can later be changed with {transferOwnership}.
384  *
385  * This module is used through inheritance. It will make available the modifier
386  * `onlyOwner`, which can be applied to your functions to restrict their use to
387  * the owner.
388  */
389 abstract contract Ownable is Context {
390     address private _owner;
391 
392     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
393 
394     /**
395      * @dev Initializes the contract setting the deployer as the initial owner.
396      */
397     constructor () internal {
398         address msgSender = _msgSender();
399         _owner = msgSender;
400         emit OwnershipTransferred(address(0), msgSender);
401     }
402 
403     /**
404      * @dev Returns the address of the current owner.
405      */
406     function owner() public view returns (address) {
407         return _owner;
408     }
409 
410     /**
411      * @dev Throws if called by any account other than the owner.
412      */
413     modifier onlyOwner() {
414         require(_owner == _msgSender(), "Ownable: caller is not the owner");
415         _;
416     }
417 
418     /**
419      * @dev Leaves the contract without owner. It will not be possible to call
420      * `onlyOwner` functions anymore. Can only be called by the current owner.
421      *
422      * NOTE: Renouncing ownership will leave the contract without an owner,
423      * thereby removing any functionality that is only available to the owner.
424      */
425     function renounceOwnership() public virtual onlyOwner {
426         emit OwnershipTransferred(_owner, address(0));
427         _owner = address(0);
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Can only be called by the current owner.
433      */
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         emit OwnershipTransferred(_owner, newOwner);
437         _owner = newOwner;
438     }
439 }
440 
441 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
442 
443 
444 pragma solidity >=0.6.0 <0.8.0;
445 
446 /**
447  * @dev Wrappers over Solidity's arithmetic operations with added overflow
448  * checks.
449  *
450  * Arithmetic operations in Solidity wrap on overflow. This can easily result
451  * in bugs, because programmers usually assume that an overflow raises an
452  * error, which is the standard behavior in high level programming languages.
453  * `SafeMath` restores this intuition by reverting the transaction when an
454  * operation overflows.
455  *
456  * Using this library instead of the unchecked operations eliminates an entire
457  * class of bugs, so it's recommended to use it always.
458  */
459 library SafeMath {
460     /**
461      * @dev Returns the addition of two unsigned integers, reverting on
462      * overflow.
463      *
464      * Counterpart to Solidity's `+` operator.
465      *
466      * Requirements:
467      *
468      * - Addition cannot overflow.
469      */
470     function add(uint256 a, uint256 b) internal pure returns (uint256) {
471         uint256 c = a + b;
472         require(c >= a, "SafeMath: addition overflow");
473 
474         return c;
475     }
476 
477     /**
478      * @dev Returns the subtraction of two unsigned integers, reverting on
479      * overflow (when the result is negative).
480      *
481      * Counterpart to Solidity's `-` operator.
482      *
483      * Requirements:
484      *
485      * - Subtraction cannot overflow.
486      */
487     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
488         return sub(a, b, "SafeMath: subtraction overflow");
489     }
490 
491     /**
492      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
493      * overflow (when the result is negative).
494      *
495      * Counterpart to Solidity's `-` operator.
496      *
497      * Requirements:
498      *
499      * - Subtraction cannot overflow.
500      */
501     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
502         require(b <= a, errorMessage);
503         uint256 c = a - b;
504 
505         return c;
506     }
507 
508     /**
509      * @dev Returns the multiplication of two unsigned integers, reverting on
510      * overflow.
511      *
512      * Counterpart to Solidity's `*` operator.
513      *
514      * Requirements:
515      *
516      * - Multiplication cannot overflow.
517      */
518     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
519         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
520         // benefit is lost if 'b' is also tested.
521         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
522         if (a == 0) {
523             return 0;
524         }
525 
526         uint256 c = a * b;
527         require(c / a == b, "SafeMath: multiplication overflow");
528 
529         return c;
530     }
531 
532     /**
533      * @dev Returns the integer division of two unsigned integers. Reverts on
534      * division by zero. The result is rounded towards zero.
535      *
536      * Counterpart to Solidity's `/` operator. Note: this function uses a
537      * `revert` opcode (which leaves remaining gas untouched) while Solidity
538      * uses an invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function div(uint256 a, uint256 b) internal pure returns (uint256) {
545         return div(a, b, "SafeMath: division by zero");
546     }
547 
548     /**
549      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
550      * division by zero. The result is rounded towards zero.
551      *
552      * Counterpart to Solidity's `/` operator. Note: this function uses a
553      * `revert` opcode (which leaves remaining gas untouched) while Solidity
554      * uses an invalid opcode to revert (consuming all remaining gas).
555      *
556      * Requirements:
557      *
558      * - The divisor cannot be zero.
559      */
560     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
561         require(b > 0, errorMessage);
562         uint256 c = a / b;
563         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
564 
565         return c;
566     }
567 
568     /**
569      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
570      * Reverts when dividing by zero.
571      *
572      * Counterpart to Solidity's `%` operator. This function uses a `revert`
573      * opcode (which leaves remaining gas untouched) while Solidity uses an
574      * invalid opcode to revert (consuming all remaining gas).
575      *
576      * Requirements:
577      *
578      * - The divisor cannot be zero.
579      */
580     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
581         return mod(a, b, "SafeMath: modulo by zero");
582     }
583 
584     /**
585      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
586      * Reverts with custom message when dividing by zero.
587      *
588      * Counterpart to Solidity's `%` operator. This function uses a `revert`
589      * opcode (which leaves remaining gas untouched) while Solidity uses an
590      * invalid opcode to revert (consuming all remaining gas).
591      *
592      * Requirements:
593      *
594      * - The divisor cannot be zero.
595      */
596     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
597         require(b != 0, errorMessage);
598         return a % b;
599     }
600 }
601 
602 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
603 
604 
605 pragma solidity >=0.6.0 <0.8.0;
606 
607 /**
608  * @dev Standard math utilities missing in the Solidity language.
609  */
610 library Math {
611     /**
612      * @dev Returns the largest of two numbers.
613      */
614     function max(uint256 a, uint256 b) internal pure returns (uint256) {
615         return a >= b ? a : b;
616     }
617 
618     /**
619      * @dev Returns the smallest of two numbers.
620      */
621     function min(uint256 a, uint256 b) internal pure returns (uint256) {
622         return a < b ? a : b;
623     }
624 
625     /**
626      * @dev Returns the average of two numbers. The result is rounded towards
627      * zero.
628      */
629     function average(uint256 a, uint256 b) internal pure returns (uint256) {
630         // (a + b) / 2 can overflow, so we distribute
631         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
632     }
633 }
634 
635 // File: browser/Staking.sol
636 
637 
638 pragma solidity 0.7.4;
639 
640 contract UnoreStaking is Ownable {
641     using SafeMath for uint256;
642     using SafeERC20 for IERC20;
643 
644     IERC20 public stakeToken;
645     IERC20 public rewardToken;
646 
647     uint256 public constant DURATION = 30 days;
648     uint256 private _totalSupply;
649     uint256 public periodFinish = 0;
650     uint256 public rewardRate = 0;
651     uint256 public lastUpdateTime;
652     uint256 public rewardPerTokenStored;
653 
654     address public rewardDistribution;
655 
656     mapping(address => uint256) private _balances;
657     mapping(address => uint256) public userRewardPerTokenPaid;
658     mapping(address => uint256) public rewards;
659 
660     event RewardAdded(uint256 reward);
661     event Staked(address indexed user, uint256 amount);
662     event Unstaked(address indexed user, uint256 amount);
663     event RewardPaid(address indexed user, uint256 reward);
664     event RecoverToken(address indexed token, uint256 indexed amount);
665 
666     modifier onlyRewardDistribution() {
667         require(
668             msg.sender == rewardDistribution,
669             "Caller is not reward distribution"
670         );
671         _;
672     }
673 
674     modifier updateReward(address account) {
675         rewardPerTokenStored = rewardPerToken();
676         lastUpdateTime = lastTimeRewardApplicable();
677         if (account != address(0)) {
678             rewards[account] = earned(account);
679             userRewardPerTokenPaid[account] = rewardPerTokenStored;
680         }
681         _;
682     }
683 
684     constructor(IERC20 _stakeToken, IERC20 _rewardToken) {
685         stakeToken = _stakeToken;
686         rewardToken = _rewardToken;
687     }
688 
689     function lastTimeRewardApplicable() public view returns (uint256) {
690         return Math.min(block.timestamp, periodFinish);
691     }
692 
693     function rewardPerToken() public view returns (uint256) {
694         if (totalSupply() == 0) {
695             return rewardPerTokenStored;
696         }
697         return
698             rewardPerTokenStored.add(
699                 lastTimeRewardApplicable()
700                     .sub(lastUpdateTime)
701                     .mul(rewardRate)
702                     .mul(1e18)
703                     .div(totalSupply())
704             );
705     }
706 
707     function earned(address account) public view returns (uint256) {
708         return
709             balanceOf(account)
710                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
711                 .div(1e18)
712                 .add(rewards[account]);
713     }
714 
715     function stake(uint256 amount) public updateReward(msg.sender) {
716         require(amount > 0, "Cannot stake 0");
717         _totalSupply = _totalSupply.add(amount);
718         _balances[msg.sender] = _balances[msg.sender].add(amount);
719         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
720         emit Staked(msg.sender, amount);
721     }
722 
723     function unstake(uint256 amount) public updateReward(msg.sender) {
724         require(amount > 0, "Cannot withdraw 0");
725         _totalSupply = _totalSupply.sub(amount);
726         _balances[msg.sender] = _balances[msg.sender].sub(amount);
727         stakeToken.safeTransfer(msg.sender, amount);
728         emit Unstaked(msg.sender, amount);
729     }
730 
731     function exit() external {
732         unstake(balanceOf(msg.sender));
733         getReward();
734     }
735 
736     function getReward() public updateReward(msg.sender) {
737         uint256 reward = earned(msg.sender);
738         if (reward > 0) {
739             rewards[msg.sender] = 0;
740             rewardToken.safeTransfer(msg.sender, reward);
741             emit RewardPaid(msg.sender, reward);
742         }
743     }
744 
745     function notifyRewardAmount(uint256 reward)
746         external
747         onlyRewardDistribution
748         updateReward(address(0))
749     {
750         if (block.timestamp >= periodFinish) {
751             rewardRate = reward.div(DURATION);
752         } else {
753             uint256 remaining = periodFinish.sub(block.timestamp);
754             uint256 leftover = remaining.mul(rewardRate);
755             rewardRate = reward.add(leftover).div(DURATION);
756         }
757         lastUpdateTime = block.timestamp;
758         periodFinish = block.timestamp.add(DURATION);
759         emit RewardAdded(reward);
760     }
761 
762     function setRewardDistribution(address _rewardDistribution)
763         external
764         onlyOwner
765     {
766         rewardDistribution = _rewardDistribution;
767     }
768 
769     function totalSupply() public view returns (uint256) {
770         return _totalSupply;
771     }
772 
773     function balanceOf(address account) public view returns (uint256) {
774         return _balances[account];
775     }
776 
777     function recoverExcessToken(address token, uint256 amount) external onlyOwner {
778         IERC20(token).safeTransfer(_msgSender(), amount);
779         emit RecoverToken(token, amount);
780     }
781 }