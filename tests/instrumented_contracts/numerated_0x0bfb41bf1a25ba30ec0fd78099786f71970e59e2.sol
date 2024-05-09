1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.2 <0.8.0;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
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
29         // This method relies on extcodesize, which returns 0 for contracts in
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
50      * IMPORTANT: because control is transferred to `recipient`, care must be
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
92         return functionCallWithValue(target, data, 0, errorMessage);
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
118         require(isContract(target), "Address: call to non-contract");
119 
120         // solhint-disable-next-line avoid-low-level-calls
121         (bool success, bytes memory returndata) = target.call{ value: value }(data);
122         return _verifyCallResult(success, returndata, errorMessage);
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
127      * but performing a static call.
128      *
129      * _Available since v3.3._
130      */
131     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
132         return functionStaticCall(target, data, "Address: low-level static call failed");
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
137      * but performing a static call.
138      *
139      * _Available since v3.3._
140      */
141     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
142         require(isContract(target), "Address: static call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.staticcall(data);
146         return _verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
151      * but performing a delegate call.
152      *
153      * _Available since v3.3._
154      */
155     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
156         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
161      * but performing a delegate call.
162      *
163      * _Available since v3.3._
164      */
165     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
166         require(isContract(target), "Address: delegate call to non-contract");
167 
168         // solhint-disable-next-line avoid-low-level-calls
169         (bool success, bytes memory returndata) = target.delegatecall(data);
170         return _verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
174         if (success) {
175             return returndata;
176         } else {
177             // Look for revert reason and bubble it up if present
178             if (returndata.length > 0) {
179                 // The easiest way to bubble the revert reason is using memory via assembly
180 
181                 // solhint-disable-next-line no-inline-assembly
182                 assembly {
183                     let returndata_size := mload(returndata)
184                     revert(add(32, returndata), returndata_size)
185                 }
186             } else {
187                 revert(errorMessage);
188             }
189         }
190     }
191 }
192 
193 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
194 
195 
196 pragma solidity >=0.6.0 <0.8.0;
197 
198 /**
199  * @dev Interface of the ERC20 standard as defined in the EIP.
200  */
201 interface IERC20 {
202     /**
203      * @dev Returns the amount of tokens in existence.
204      */
205     function totalSupply() external view returns (uint256);
206 
207     /**
208      * @dev Returns the amount of tokens owned by `account`.
209      */
210     function balanceOf(address account) external view returns (uint256);
211 
212     /**
213      * @dev Moves `amount` tokens from the caller's account to `recipient`.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transfer(address recipient, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Returns the remaining number of tokens that `spender` will be
223      * allowed to spend on behalf of `owner` through {transferFrom}. This is
224      * zero by default.
225      *
226      * This value changes when {approve} or {transferFrom} are called.
227      */
228     function allowance(address owner, address spender) external view returns (uint256);
229 
230     /**
231      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * IMPORTANT: Beware that changing an allowance with this method brings the risk
236      * that someone may use both the old and the new allowance by unfortunate
237      * transaction ordering. One possible solution to mitigate this race
238      * condition is to first reduce the spender's allowance to 0 and set the
239      * desired value afterwards:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      *
242      * Emits an {Approval} event.
243      */
244     function approve(address spender, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Moves `amount` tokens from `sender` to `recipient` using the
248      * allowance mechanism. `amount` is then deducted from the caller's
249      * allowance.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Emitted when `value` tokens are moved from one account (`from`) to
259      * another (`to`).
260      *
261      * Note that `value` may be zero.
262      */
263     event Transfer(address indexed from, address indexed to, uint256 value);
264 
265     /**
266      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
267      * a call to {approve}. `value` is the new allowance.
268      */
269     event Approval(address indexed owner, address indexed spender, uint256 value);
270 }
271 
272 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol
273 
274 
275 pragma solidity >=0.6.0 <0.8.0;
276 
277 
278 
279 
280 /**
281  * @title SafeERC20
282  * @dev Wrappers around ERC20 operations that throw on failure (when the token
283  * contract returns false). Tokens that return no value (and instead revert or
284  * throw on failure) are also supported, non-reverting calls are assumed to be
285  * successful.
286  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
287  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
288  */
289 library SafeERC20 {
290     using SafeMath for uint256;
291     using Address for address;
292 
293     function safeTransfer(IERC20 token, address to, uint256 value) internal {
294         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
295     }
296 
297     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
298         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
299     }
300 
301     /**
302      * @dev Deprecated. This function has issues similar to the ones found in
303      * {IERC20-approve}, and its usage is discouraged.
304      *
305      * Whenever possible, use {safeIncreaseAllowance} and
306      * {safeDecreaseAllowance} instead.
307      */
308     function safeApprove(IERC20 token, address spender, uint256 value) internal {
309         // safeApprove should only be called when setting an initial allowance,
310         // or when resetting it to zero. To increase and decrease it, use
311         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
312         // solhint-disable-next-line max-line-length
313         require((value == 0) || (token.allowance(address(this), spender) == 0),
314             "SafeERC20: approve from non-zero to non-zero allowance"
315         );
316         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
317     }
318 
319     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
320         uint256 newAllowance = token.allowance(address(this), spender).add(value);
321         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
322     }
323 
324     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
325         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
326         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
327     }
328 
329     /**
330      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
331      * on the return value: the return value is optional (but if data is returned, it must not be false).
332      * @param token The token targeted by the call.
333      * @param data The call data (encoded using abi.encode or one of its variants).
334      */
335     function _callOptionalReturn(IERC20 token, bytes memory data) private {
336         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
337         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
338         // the target address contains contract code and also asserts for success in the low-level call.
339 
340         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
341         if (returndata.length > 0) { // Return data is optional
342             // solhint-disable-next-line max-line-length
343             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
344         }
345     }
346 }
347 
348 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
349 
350 
351 pragma solidity >=0.6.0 <0.8.0;
352 
353 /*
354  * @dev Provides information about the current execution context, including the
355  * sender of the transaction and its data. While these are generally available
356  * via msg.sender and msg.data, they should not be accessed in such a direct
357  * manner, since when dealing with GSN meta-transactions the account sending and
358  * paying for execution may not be the actual sender (as far as an application
359  * is concerned).
360  *
361  * This contract is only required for intermediate, library-like contracts.
362  */
363 abstract contract Context {
364     function _msgSender() internal view virtual returns (address payable) {
365         return msg.sender;
366     }
367 
368     function _msgData() internal view virtual returns (bytes memory) {
369         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
370         return msg.data;
371     }
372 }
373 
374 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
375 
376 
377 pragma solidity >=0.6.0 <0.8.0;
378 
379 /**
380  * @dev Contract module which provides a basic access control mechanism, where
381  * there is an account (an owner) that can be granted exclusive access to
382  * specific functions.
383  *
384  * By default, the owner account will be the one that deploys the contract. This
385  * can later be changed with {transferOwnership}.
386  *
387  * This module is used through inheritance. It will make available the modifier
388  * `onlyOwner`, which can be applied to your functions to restrict their use to
389  * the owner.
390  */
391 abstract contract Ownable is Context {
392     address private _owner;
393 
394     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
395 
396     /**
397      * @dev Initializes the contract setting the deployer as the initial owner.
398      */
399     constructor () internal {
400         address msgSender = _msgSender();
401         _owner = msgSender;
402         emit OwnershipTransferred(address(0), msgSender);
403     }
404 
405     /**
406      * @dev Returns the address of the current owner.
407      */
408     function owner() public view returns (address) {
409         return _owner;
410     }
411 
412     /**
413      * @dev Throws if called by any account other than the owner.
414      */
415     modifier onlyOwner() {
416         require(_owner == _msgSender(), "Ownable: caller is not the owner");
417         _;
418     }
419 
420     /**
421      * @dev Leaves the contract without owner. It will not be possible to call
422      * `onlyOwner` functions anymore. Can only be called by the current owner.
423      *
424      * NOTE: Renouncing ownership will leave the contract without an owner,
425      * thereby removing any functionality that is only available to the owner.
426      */
427     function renounceOwnership() public virtual onlyOwner {
428         emit OwnershipTransferred(_owner, address(0));
429         _owner = address(0);
430     }
431 
432     /**
433      * @dev Transfers ownership of the contract to a new account (`newOwner`).
434      * Can only be called by the current owner.
435      */
436     function transferOwnership(address newOwner) public virtual onlyOwner {
437         require(newOwner != address(0), "Ownable: new owner is the zero address");
438         emit OwnershipTransferred(_owner, newOwner);
439         _owner = newOwner;
440     }
441 }
442 
443 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
444 
445 
446 pragma solidity >=0.6.0 <0.8.0;
447 
448 /**
449  * @dev Wrappers over Solidity's arithmetic operations with added overflow
450  * checks.
451  *
452  * Arithmetic operations in Solidity wrap on overflow. This can easily result
453  * in bugs, because programmers usually assume that an overflow raises an
454  * error, which is the standard behavior in high level programming languages.
455  * `SafeMath` restores this intuition by reverting the transaction when an
456  * operation overflows.
457  *
458  * Using this library instead of the unchecked operations eliminates an entire
459  * class of bugs, so it's recommended to use it always.
460  */
461 library SafeMath {
462     /**
463      * @dev Returns the addition of two unsigned integers, reverting on
464      * overflow.
465      *
466      * Counterpart to Solidity's `+` operator.
467      *
468      * Requirements:
469      *
470      * - Addition cannot overflow.
471      */
472     function add(uint256 a, uint256 b) internal pure returns (uint256) {
473         uint256 c = a + b;
474         require(c >= a, "SafeMath: addition overflow");
475 
476         return c;
477     }
478 
479     /**
480      * @dev Returns the subtraction of two unsigned integers, reverting on
481      * overflow (when the result is negative).
482      *
483      * Counterpart to Solidity's `-` operator.
484      *
485      * Requirements:
486      *
487      * - Subtraction cannot overflow.
488      */
489     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
490         return sub(a, b, "SafeMath: subtraction overflow");
491     }
492 
493     /**
494      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
495      * overflow (when the result is negative).
496      *
497      * Counterpart to Solidity's `-` operator.
498      *
499      * Requirements:
500      *
501      * - Subtraction cannot overflow.
502      */
503     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
504         require(b <= a, errorMessage);
505         uint256 c = a - b;
506 
507         return c;
508     }
509 
510     /**
511      * @dev Returns the multiplication of two unsigned integers, reverting on
512      * overflow.
513      *
514      * Counterpart to Solidity's `*` operator.
515      *
516      * Requirements:
517      *
518      * - Multiplication cannot overflow.
519      */
520     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
521         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
522         // benefit is lost if 'b' is also tested.
523         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
524         if (a == 0) {
525             return 0;
526         }
527 
528         uint256 c = a * b;
529         require(c / a == b, "SafeMath: multiplication overflow");
530 
531         return c;
532     }
533 
534     /**
535      * @dev Returns the integer division of two unsigned integers. Reverts on
536      * division by zero. The result is rounded towards zero.
537      *
538      * Counterpart to Solidity's `/` operator. Note: this function uses a
539      * `revert` opcode (which leaves remaining gas untouched) while Solidity
540      * uses an invalid opcode to revert (consuming all remaining gas).
541      *
542      * Requirements:
543      *
544      * - The divisor cannot be zero.
545      */
546     function div(uint256 a, uint256 b) internal pure returns (uint256) {
547         return div(a, b, "SafeMath: division by zero");
548     }
549 
550     /**
551      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
552      * division by zero. The result is rounded towards zero.
553      *
554      * Counterpart to Solidity's `/` operator. Note: this function uses a
555      * `revert` opcode (which leaves remaining gas untouched) while Solidity
556      * uses an invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
563         require(b > 0, errorMessage);
564         uint256 c = a / b;
565         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
566 
567         return c;
568     }
569 
570     /**
571      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
572      * Reverts when dividing by zero.
573      *
574      * Counterpart to Solidity's `%` operator. This function uses a `revert`
575      * opcode (which leaves remaining gas untouched) while Solidity uses an
576      * invalid opcode to revert (consuming all remaining gas).
577      *
578      * Requirements:
579      *
580      * - The divisor cannot be zero.
581      */
582     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
583         return mod(a, b, "SafeMath: modulo by zero");
584     }
585 
586     /**
587      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
588      * Reverts with custom message when dividing by zero.
589      *
590      * Counterpart to Solidity's `%` operator. This function uses a `revert`
591      * opcode (which leaves remaining gas untouched) while Solidity uses an
592      * invalid opcode to revert (consuming all remaining gas).
593      *
594      * Requirements:
595      *
596      * - The divisor cannot be zero.
597      */
598     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
599         require(b != 0, errorMessage);
600         return a % b;
601     }
602 }
603 
604 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
605 
606 
607 pragma solidity >=0.6.0 <0.8.0;
608 
609 /**
610  * @dev Standard math utilities missing in the Solidity language.
611  */
612 library Math {
613     /**
614      * @dev Returns the largest of two numbers.
615      */
616     function max(uint256 a, uint256 b) internal pure returns (uint256) {
617         return a >= b ? a : b;
618     }
619 
620     /**
621      * @dev Returns the smallest of two numbers.
622      */
623     function min(uint256 a, uint256 b) internal pure returns (uint256) {
624         return a < b ? a : b;
625     }
626 
627     /**
628      * @dev Returns the average of two numbers. The result is rounded towards
629      * zero.
630      */
631     function average(uint256 a, uint256 b) internal pure returns (uint256) {
632         // (a + b) / 2 can overflow, so we distribute
633         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
634     }
635 }
636 
637 // File: browser/Staking.sol
638 
639 
640 pragma solidity 0.7.4;
641 
642 contract WorkQuestStaking is Ownable {
643     using SafeMath for uint256;
644     using SafeERC20 for IERC20;
645 
646     IERC20 public stakeToken;
647     IERC20 public rewardToken;
648 
649     uint256 public constant DURATION = 14 days;
650     uint256 private _totalSupply;
651     uint256 public periodFinish = 0;
652     uint256 public rewardRate = 0;
653     uint256 public lastUpdateTime;
654     uint256 public rewardPerTokenStored;
655 
656     address public rewardDistribution;
657 
658     mapping(address => uint256) private _balances;
659     mapping(address => uint256) public userRewardPerTokenPaid;
660     mapping(address => uint256) public rewards;
661 
662     event RewardAdded(uint256 reward);
663     event Staked(address indexed user, uint256 amount);
664     event Unstaked(address indexed user, uint256 amount);
665     event RewardPaid(address indexed user, uint256 reward);
666     event RecoverToken(address indexed token, uint256 indexed amount);
667 
668     modifier onlyRewardDistribution() {
669         require(
670             msg.sender == rewardDistribution,
671             "Caller is not reward distribution"
672         );
673         _;
674     }
675 
676     modifier updateReward(address account) {
677         rewardPerTokenStored = rewardPerToken();
678         lastUpdateTime = lastTimeRewardApplicable();
679         if (account != address(0)) {
680             rewards[account] = earned(account);
681             userRewardPerTokenPaid[account] = rewardPerTokenStored;
682         }
683         _;
684     }
685 
686     constructor(IERC20 _stakeToken, IERC20 _rewardToken) {
687         stakeToken = _stakeToken;
688         rewardToken = _rewardToken;
689     }
690 
691     function lastTimeRewardApplicable() public view returns (uint256) {
692         return Math.min(block.timestamp, periodFinish);
693     }
694 
695     function rewardPerToken() public view returns (uint256) {
696         if (totalSupply() == 0) {
697             return rewardPerTokenStored;
698         }
699         return
700             rewardPerTokenStored.add(
701                 lastTimeRewardApplicable()
702                     .sub(lastUpdateTime)
703                     .mul(rewardRate)
704                     .mul(1e18)
705                     .div(totalSupply())
706             );
707     }
708 
709     function earned(address account) public view returns (uint256) {
710         return
711             balanceOf(account)
712                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
713                 .div(1e18)
714                 .add(rewards[account]);
715     }
716 
717     function stake(uint256 amount) public updateReward(msg.sender) {
718         require(amount > 0, "Cannot stake 0");
719         _totalSupply = _totalSupply.add(amount);
720         _balances[msg.sender] = _balances[msg.sender].add(amount);
721         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
722         emit Staked(msg.sender, amount);
723     }
724 
725     function unstake(uint256 amount) public updateReward(msg.sender) {
726         require(amount > 0, "Cannot withdraw 0");
727         _totalSupply = _totalSupply.sub(amount);
728         _balances[msg.sender] = _balances[msg.sender].sub(amount);
729         stakeToken.safeTransfer(msg.sender, amount);
730         emit Unstaked(msg.sender, amount);
731     }
732 
733     function exit() external {
734         unstake(balanceOf(msg.sender));
735         getReward();
736     }
737 
738     function getReward() public updateReward(msg.sender) {
739         uint256 reward = earned(msg.sender);
740         if (reward > 0) {
741             rewards[msg.sender] = 0;
742             rewardToken.safeTransfer(msg.sender, reward);
743             emit RewardPaid(msg.sender, reward);
744         }
745     }
746 
747     function notifyRewardAmount(uint256 reward)
748         external
749         onlyRewardDistribution
750         updateReward(address(0))
751     {
752         if (block.timestamp >= periodFinish) {
753             rewardRate = reward.div(DURATION);
754         } else {
755             uint256 remaining = periodFinish.sub(block.timestamp);
756             uint256 leftover = remaining.mul(rewardRate);
757             rewardRate = reward.add(leftover).div(DURATION);
758         }
759         lastUpdateTime = block.timestamp;
760         periodFinish = block.timestamp.add(DURATION);
761         emit RewardAdded(reward);
762     }
763 
764     function setRewardDistribution(address _rewardDistribution)
765         external
766         onlyOwner
767     {
768         rewardDistribution = _rewardDistribution;
769     }
770 
771     function totalSupply() public view returns (uint256) {
772         return _totalSupply;
773     }
774 
775     function balanceOf(address account) public view returns (uint256) {
776         return _balances[account];
777     }
778 
779     function recoverExcessToken(address token, uint256 amount) external onlyOwner {
780         IERC20(token).safeTransfer(_msgSender(), amount);
781         emit RecoverToken(token, amount);
782     }
783 }