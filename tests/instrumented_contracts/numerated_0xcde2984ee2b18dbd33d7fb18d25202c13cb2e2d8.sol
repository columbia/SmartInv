1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 pragma solidity >=0.6.2 <0.8.0;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      */
29     function isContract(address account) internal view returns (bool) {
30         // This method relies on extcodesize, which returns 0 for contracts in
31         // construction, since the code is only stored at the end of the
32         // constructor execution.
33 
34         uint256 size;
35         // solhint-disable-next-line no-inline-assembly
36         assembly { size := extcodesize(account) }
37         return size > 0;
38     }
39 
40     /**
41      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
42      * `recipient`, forwarding all available gas and reverting on errors.
43      *
44      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
45      * of certain opcodes, possibly making contracts go over the 2300 gas limit
46      * imposed by `transfer`, making them unable to receive funds via
47      * `transfer`. {sendValue} removes this limitation.
48      *
49      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
50      *
51      * IMPORTANT: because control is transferred to `recipient`, care must be
52      * taken to not create reentrancy vulnerabilities. Consider using
53      * {ReentrancyGuard} or the
54      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
55      */
56     function sendValue(address payable recipient, uint256 amount) internal {
57         require(address(this).balance >= amount, "Address: insufficient balance");
58 
59         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
60         (bool success, ) = recipient.call{ value: amount }("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain`call` is an unsafe replacement for a function call: use this
67      * function instead.
68      *
69      * If `target` reverts with a revert reason, it is bubbled up by this
70      * function (like regular Solidity function calls).
71      *
72      * Returns the raw returned data. To convert to the expected return value,
73      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
74      *
75      * Requirements:
76      *
77      * - `target` must be a contract.
78      * - calling `target` with `data` must not revert.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83       return functionCall(target, data, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
93         return functionCallWithValue(target, data, 0, errorMessage);
94     }
95 
96     /**
97      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
98      * but also transferring `value` wei to `target`.
99      *
100      * Requirements:
101      *
102      * - the calling contract must have an ETH balance of at least `value`.
103      * - the called Solidity function must be `payable`.
104      *
105      * _Available since v3.1._
106      */
107     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
113      * with `errorMessage` as a fallback revert reason when `target` reverts.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
118         require(address(this).balance >= value, "Address: insufficient balance for call");
119         require(isContract(target), "Address: call to non-contract");
120 
121         // solhint-disable-next-line avoid-low-level-calls
122         (bool success, bytes memory returndata) = target.call{ value: value }(data);
123         return _verifyCallResult(success, returndata, errorMessage);
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
128      * but performing a static call.
129      *
130      * _Available since v3.3._
131      */
132     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
133         return functionStaticCall(target, data, "Address: low-level static call failed");
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
138      * but performing a static call.
139      *
140      * _Available since v3.3._
141      */
142     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
143         require(isContract(target), "Address: static call to non-contract");
144 
145         // solhint-disable-next-line avoid-low-level-calls
146         (bool success, bytes memory returndata) = target.staticcall(data);
147         return _verifyCallResult(success, returndata, errorMessage);
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
152      * but performing a delegate call.
153      *
154      * _Available since v3.3._
155      */
156     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
162      * but performing a delegate call.
163      *
164      * _Available since v3.3._
165      */
166     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
167         require(isContract(target), "Address: delegate call to non-contract");
168 
169         // solhint-disable-next-line avoid-low-level-calls
170         (bool success, bytes memory returndata) = target.delegatecall(data);
171         return _verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
175         if (success) {
176             return returndata;
177         } else {
178             // Look for revert reason and bubble it up if present
179             if (returndata.length > 0) {
180                 // The easiest way to bubble the revert reason is using memory via assembly
181 
182                 // solhint-disable-next-line no-inline-assembly
183                 assembly {
184                     let returndata_size := mload(returndata)
185                     revert(add(32, returndata), returndata_size)
186                 }
187             } else {
188                 revert(errorMessage);
189             }
190         }
191     }
192 }
193 
194 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
195 
196 
197 pragma solidity >=0.6.0 <0.8.0;
198 
199 /**
200  * @dev Interface of the ERC20 standard as defined in the EIP.
201  */
202 interface IERC20 {
203     /**
204      * @dev Returns the amount of tokens in existence.
205      */
206     function totalSupply() external view returns (uint256);
207 
208     /**
209      * @dev Returns the amount of tokens owned by `account`.
210      */
211     function balanceOf(address account) external view returns (uint256);
212 
213     /**
214      * @dev Moves `amount` tokens from the caller's account to `recipient`.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transfer(address recipient, uint256 amount) external returns (bool);
221 
222     /**
223      * @dev Returns the remaining number of tokens that `spender` will be
224      * allowed to spend on behalf of `owner` through {transferFrom}. This is
225      * zero by default.
226      *
227      * This value changes when {approve} or {transferFrom} are called.
228      */
229     function allowance(address owner, address spender) external view returns (uint256);
230 
231     /**
232      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * IMPORTANT: Beware that changing an allowance with this method brings the risk
237      * that someone may use both the old and the new allowance by unfortunate
238      * transaction ordering. One possible solution to mitigate this race
239      * condition is to first reduce the spender's allowance to 0 and set the
240      * desired value afterwards:
241      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242      *
243      * Emits an {Approval} event.
244      */
245     function approve(address spender, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Moves `amount` tokens from `sender` to `recipient` using the
249      * allowance mechanism. `amount` is then deducted from the caller's
250      * allowance.
251      *
252      * Returns a boolean value indicating whether the operation succeeded.
253      *
254      * Emits a {Transfer} event.
255      */
256     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
257 
258     /**
259      * @dev Emitted when `value` tokens are moved from one account (`from`) to
260      * another (`to`).
261      *
262      * Note that `value` may be zero.
263      */
264     event Transfer(address indexed from, address indexed to, uint256 value);
265 
266     /**
267      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
268      * a call to {approve}. `value` is the new allowance.
269      */
270     event Approval(address indexed owner, address indexed spender, uint256 value);
271 }
272 
273 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol
274 
275 
276 pragma solidity >=0.6.0 <0.8.0;
277 
278 
279 
280 
281 /**
282  * @title SafeERC20
283  * @dev Wrappers around ERC20 operations that throw on failure (when the token
284  * contract returns false). Tokens that return no value (and instead revert or
285  * throw on failure) are also supported, non-reverting calls are assumed to be
286  * successful.
287  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
288  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
289  */
290 library SafeERC20 {
291     using SafeMath for uint256;
292     using Address for address;
293 
294     function safeTransfer(IERC20 token, address to, uint256 value) internal {
295         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
296     }
297 
298     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
299         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
300     }
301 
302     /**
303      * @dev Deprecated. This function has issues similar to the ones found in
304      * {IERC20-approve}, and its usage is discouraged.
305      *
306      * Whenever possible, use {safeIncreaseAllowance} and
307      * {safeDecreaseAllowance} instead.
308      */
309     function safeApprove(IERC20 token, address spender, uint256 value) internal {
310         // safeApprove should only be called when setting an initial allowance,
311         // or when resetting it to zero. To increase and decrease it, use
312         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
313         // solhint-disable-next-line max-line-length
314         require((value == 0) || (token.allowance(address(this), spender) == 0),
315             "SafeERC20: approve from non-zero to non-zero allowance"
316         );
317         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
318     }
319 
320     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
321         uint256 newAllowance = token.allowance(address(this), spender).add(value);
322         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
323     }
324 
325     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
326         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
327         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
328     }
329 
330     /**
331      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
332      * on the return value: the return value is optional (but if data is returned, it must not be false).
333      * @param token The token targeted by the call.
334      * @param data The call data (encoded using abi.encode or one of its variants).
335      */
336     function _callOptionalReturn(IERC20 token, bytes memory data) private {
337         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
338         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
339         // the target address contains contract code and also asserts for success in the low-level call.
340 
341         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
342         if (returndata.length > 0) { // Return data is optional
343             // solhint-disable-next-line max-line-length
344             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
345         }
346     }
347 }
348 
349 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
350 
351 
352 pragma solidity >=0.6.0 <0.8.0;
353 
354 /*
355  * @dev Provides information about the current execution context, including the
356  * sender of the transaction and its data. While these are generally available
357  * via msg.sender and msg.data, they should not be accessed in such a direct
358  * manner, since when dealing with GSN meta-transactions the account sending and
359  * paying for execution may not be the actual sender (as far as an application
360  * is concerned).
361  *
362  * This contract is only required for intermediate, library-like contracts.
363  */
364 abstract contract Context {
365     function _msgSender() internal view virtual returns (address payable) {
366         return msg.sender;
367     }
368 
369     function _msgData() internal view virtual returns (bytes memory) {
370         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
371         return msg.data;
372     }
373 }
374 
375 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
376 
377 
378 pragma solidity >=0.6.0 <0.8.0;
379 
380 /**
381  * @dev Contract module which provides a basic access control mechanism, where
382  * there is an account (an owner) that can be granted exclusive access to
383  * specific functions.
384  *
385  * By default, the owner account will be the one that deploys the contract. This
386  * can later be changed with {transferOwnership}.
387  *
388  * This module is used through inheritance. It will make available the modifier
389  * `onlyOwner`, which can be applied to your functions to restrict their use to
390  * the owner.
391  */
392 abstract contract Ownable is Context {
393     address private _owner;
394 
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397     /**
398      * @dev Initializes the contract setting the deployer as the initial owner.
399      */
400     constructor () internal {
401         address msgSender = _msgSender();
402         _owner = msgSender;
403         emit OwnershipTransferred(address(0), msgSender);
404     }
405 
406     /**
407      * @dev Returns the address of the current owner.
408      */
409     function owner() public view returns (address) {
410         return _owner;
411     }
412 
413     /**
414      * @dev Throws if called by any account other than the owner.
415      */
416     modifier onlyOwner() {
417         require(_owner == _msgSender(), "Ownable: caller is not the owner");
418         _;
419     }
420 
421     /**
422      * @dev Leaves the contract without owner. It will not be possible to call
423      * `onlyOwner` functions anymore. Can only be called by the current owner.
424      *
425      * NOTE: Renouncing ownership will leave the contract without an owner,
426      * thereby removing any functionality that is only available to the owner.
427      */
428     function renounceOwnership() public virtual onlyOwner {
429         emit OwnershipTransferred(_owner, address(0));
430         _owner = address(0);
431     }
432 
433     /**
434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
435      * Can only be called by the current owner.
436      */
437     function transferOwnership(address newOwner) public virtual onlyOwner {
438         require(newOwner != address(0), "Ownable: new owner is the zero address");
439         emit OwnershipTransferred(_owner, newOwner);
440         _owner = newOwner;
441     }
442 }
443 
444 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
445 
446 
447 pragma solidity >=0.6.0 <0.8.0;
448 
449 /**
450  * @dev Wrappers over Solidity's arithmetic operations with added overflow
451  * checks.
452  *
453  * Arithmetic operations in Solidity wrap on overflow. This can easily result
454  * in bugs, because programmers usually assume that an overflow raises an
455  * error, which is the standard behavior in high level programming languages.
456  * `SafeMath` restores this intuition by reverting the transaction when an
457  * operation overflows.
458  *
459  * Using this library instead of the unchecked operations eliminates an entire
460  * class of bugs, so it's recommended to use it always.
461  */
462 library SafeMath {
463     /**
464      * @dev Returns the addition of two unsigned integers, reverting on
465      * overflow.
466      *
467      * Counterpart to Solidity's `+` operator.
468      *
469      * Requirements:
470      *
471      * - Addition cannot overflow.
472      */
473     function add(uint256 a, uint256 b) internal pure returns (uint256) {
474         uint256 c = a + b;
475         require(c >= a, "SafeMath: addition overflow");
476 
477         return c;
478     }
479 
480     /**
481      * @dev Returns the subtraction of two unsigned integers, reverting on
482      * overflow (when the result is negative).
483      *
484      * Counterpart to Solidity's `-` operator.
485      *
486      * Requirements:
487      *
488      * - Subtraction cannot overflow.
489      */
490     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
491         return sub(a, b, "SafeMath: subtraction overflow");
492     }
493 
494     /**
495      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
496      * overflow (when the result is negative).
497      *
498      * Counterpart to Solidity's `-` operator.
499      *
500      * Requirements:
501      *
502      * - Subtraction cannot overflow.
503      */
504     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
505         require(b <= a, errorMessage);
506         uint256 c = a - b;
507 
508         return c;
509     }
510 
511     /**
512      * @dev Returns the multiplication of two unsigned integers, reverting on
513      * overflow.
514      *
515      * Counterpart to Solidity's `*` operator.
516      *
517      * Requirements:
518      *
519      * - Multiplication cannot overflow.
520      */
521     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
522         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
523         // benefit is lost if 'b' is also tested.
524         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
525         if (a == 0) {
526             return 0;
527         }
528 
529         uint256 c = a * b;
530         require(c / a == b, "SafeMath: multiplication overflow");
531 
532         return c;
533     }
534 
535     /**
536      * @dev Returns the integer division of two unsigned integers. Reverts on
537      * division by zero. The result is rounded towards zero.
538      *
539      * Counterpart to Solidity's `/` operator. Note: this function uses a
540      * `revert` opcode (which leaves remaining gas untouched) while Solidity
541      * uses an invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function div(uint256 a, uint256 b) internal pure returns (uint256) {
548         return div(a, b, "SafeMath: division by zero");
549     }
550 
551     /**
552      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
553      * division by zero. The result is rounded towards zero.
554      *
555      * Counterpart to Solidity's `/` operator. Note: this function uses a
556      * `revert` opcode (which leaves remaining gas untouched) while Solidity
557      * uses an invalid opcode to revert (consuming all remaining gas).
558      *
559      * Requirements:
560      *
561      * - The divisor cannot be zero.
562      */
563     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
564         require(b > 0, errorMessage);
565         uint256 c = a / b;
566         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
567 
568         return c;
569     }
570 
571     /**
572      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
573      * Reverts when dividing by zero.
574      *
575      * Counterpart to Solidity's `%` operator. This function uses a `revert`
576      * opcode (which leaves remaining gas untouched) while Solidity uses an
577      * invalid opcode to revert (consuming all remaining gas).
578      *
579      * Requirements:
580      *
581      * - The divisor cannot be zero.
582      */
583     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
584         return mod(a, b, "SafeMath: modulo by zero");
585     }
586 
587     /**
588      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
589      * Reverts with custom message when dividing by zero.
590      *
591      * Counterpart to Solidity's `%` operator. This function uses a `revert`
592      * opcode (which leaves remaining gas untouched) while Solidity uses an
593      * invalid opcode to revert (consuming all remaining gas).
594      *
595      * Requirements:
596      *
597      * - The divisor cannot be zero.
598      */
599     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
600         require(b != 0, errorMessage);
601         return a % b;
602     }
603 }
604 
605 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
606 
607 
608 pragma solidity >=0.6.0 <0.8.0;
609 
610 /**
611  * @dev Standard math utilities missing in the Solidity language.
612  */
613 library Math {
614     /**
615      * @dev Returns the largest of two numbers.
616      */
617     function max(uint256 a, uint256 b) internal pure returns (uint256) {
618         return a >= b ? a : b;
619     }
620 
621     /**
622      * @dev Returns the smallest of two numbers.
623      */
624     function min(uint256 a, uint256 b) internal pure returns (uint256) {
625         return a < b ? a : b;
626     }
627 
628     /**
629      * @dev Returns the average of two numbers. The result is rounded towards
630      * zero.
631      */
632     function average(uint256 a, uint256 b) internal pure returns (uint256) {
633         // (a + b) / 2 can overflow, so we distribute
634         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
635     }
636 }
637 
638 // File: browser/Staking.sol
639 
640 
641 pragma solidity 0.7.4;
642 
643 // import "@openzeppelin/contracts/math/Math.sol";
644 // import "@openzeppelin/contracts/math/SafeMath.sol";
645 // import "@openzeppelin/contracts/access/Ownable.sol";
646 // import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
647 
648 
649 
650 
651 
652 
653 
654 contract DAOVenturesStaking is Ownable {
655     using SafeMath for uint256;
656     using SafeERC20 for IERC20;
657 
658     IERC20 public stakeToken;
659     IERC20 public rewardToken;
660 
661     uint256 public constant DURATION = 14 days;
662     uint256 private _totalSupply;
663     uint256 public periodFinish = 0;
664     uint256 public rewardRate = 0;
665     uint256 public lastUpdateTime;
666     uint256 public rewardPerTokenStored;
667 
668     address public rewardDistribution;
669 
670     mapping(address => uint256) private _balances;
671     mapping(address => uint256) public userRewardPerTokenPaid;
672     mapping(address => uint256) public rewards;
673 
674     event RewardAdded(uint256 reward);
675     event Staked(address indexed user, uint256 amount);
676     event Unstaked(address indexed user, uint256 amount);
677     event RewardPaid(address indexed user, uint256 reward);
678     event RecoverToken(address indexed token, uint256 indexed amount);
679 
680     modifier onlyRewardDistribution() {
681         require(
682             msg.sender == rewardDistribution,
683             "Caller is not reward distribution"
684         );
685         _;
686     }
687 
688     modifier updateReward(address account) {
689         rewardPerTokenStored = rewardPerToken();
690         lastUpdateTime = lastTimeRewardApplicable();
691         if (account != address(0)) {
692             rewards[account] = earned(account);
693             userRewardPerTokenPaid[account] = rewardPerTokenStored;
694         }
695         _;
696     }
697 
698     constructor(IERC20 _stakeToken, IERC20 _rewardToken) {
699         stakeToken = _stakeToken;
700         rewardToken = _rewardToken;
701     }
702 
703     function lastTimeRewardApplicable() public view returns (uint256) {
704         return Math.min(block.timestamp, periodFinish);
705     }
706 
707     function rewardPerToken() public view returns (uint256) {
708         if (totalSupply() == 0) {
709             return rewardPerTokenStored;
710         }
711         return
712             rewardPerTokenStored.add(
713                 lastTimeRewardApplicable()
714                     .sub(lastUpdateTime)
715                     .mul(rewardRate)
716                     .mul(1e18)
717                     .div(totalSupply())
718             );
719     }
720 
721     function earned(address account) public view returns (uint256) {
722         return
723             balanceOf(account)
724                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
725                 .div(1e18)
726                 .add(rewards[account]);
727     }
728 
729     function stake(uint256 amount) public updateReward(msg.sender) {
730         require(amount > 0, "Cannot stake 0");
731         _totalSupply = _totalSupply.add(amount);
732         _balances[msg.sender] = _balances[msg.sender].add(amount);
733         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
734         emit Staked(msg.sender, amount);
735     }
736 
737     function unstake(uint256 amount) public updateReward(msg.sender) {
738         require(amount > 0, "Cannot withdraw 0");
739         _totalSupply = _totalSupply.sub(amount);
740         _balances[msg.sender] = _balances[msg.sender].sub(amount);
741         stakeToken.safeTransfer(msg.sender, amount);
742         emit Unstaked(msg.sender, amount);
743     }
744 
745     function exit() external {
746         unstake(balanceOf(msg.sender));
747         getReward();
748     }
749 
750     function getReward() public updateReward(msg.sender) {
751         uint256 reward = earned(msg.sender);
752         if (reward > 0) {
753             rewards[msg.sender] = 0;
754             rewardToken.safeTransfer(msg.sender, reward);
755             emit RewardPaid(msg.sender, reward);
756         }
757     }
758 
759     function notifyRewardAmount(uint256 reward)
760         external
761         onlyRewardDistribution
762         updateReward(address(0))
763     {
764         if (block.timestamp >= periodFinish) {
765             rewardRate = reward.div(DURATION);
766         } else {
767             uint256 remaining = periodFinish.sub(block.timestamp);
768             uint256 leftover = remaining.mul(rewardRate);
769             rewardRate = reward.add(leftover).div(DURATION);
770         }
771         lastUpdateTime = block.timestamp;
772         periodFinish = block.timestamp.add(DURATION);
773         emit RewardAdded(reward);
774     }
775 
776     function setRewardDistribution(address _rewardDistribution)
777         external
778         onlyOwner
779     {
780         rewardDistribution = _rewardDistribution;
781     }
782 
783     function totalSupply() public view returns (uint256) {
784         return _totalSupply;
785     }
786 
787     function balanceOf(address account) public view returns (uint256) {
788         return _balances[account];
789     }
790 
791     function recoverExcessToken(address token, uint256 amount) external onlyOwner {
792         IERC20(token).safeTransfer(_msgSender(), amount);
793         emit RecoverToken(token, amount);
794     }
795 }