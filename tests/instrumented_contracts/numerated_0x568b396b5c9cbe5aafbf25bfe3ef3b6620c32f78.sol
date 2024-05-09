1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-07
3 */
4 
5 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 
10 pragma solidity >=0.6.2 <0.8.0;
11 
12 /**
13  * @dev Collection of functions related to the address type
14  */
15 library Address {
16     /**
17      * @dev Returns true if `account` is a contract.
18      *
19      * [IMPORTANT]
20      * ====
21      * It is unsafe to assume that an address for which this function returns
22      * false is an externally-owned account (EOA) and not a contract.
23      *
24      * Among others, `isContract` will return false for the following
25      * types of addresses:
26      *
27      *  - an externally-owned account
28      *  - a contract in construction
29      *  - an address where a contract will be created
30      *  - an address where a contract lived, but was destroyed
31      * ====
32      */
33     function isContract(address account) internal view returns (bool) {
34         // This method relies on extcodesize, which returns 0 for contracts in
35         // construction, since the code is only stored at the end of the
36         // constructor execution.
37 
38         uint256 size;
39         // solhint-disable-next-line no-inline-assembly
40         assembly { size := extcodesize(account) }
41         return size > 0;
42     }
43 
44     /**
45      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
46      * `recipient`, forwarding all available gas and reverting on errors.
47      *
48      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
49      * of certain opcodes, possibly making contracts go over the 2300 gas limit
50      * imposed by `transfer`, making them unable to receive funds via
51      * `transfer`. {sendValue} removes this limitation.
52      *
53      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
54      *
55      * IMPORTANT: because control is transferred to `recipient`, care must be
56      * taken to not create reentrancy vulnerabilities. Consider using
57      * {ReentrancyGuard} or the
58      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
59      */
60     function sendValue(address payable recipient, uint256 amount) internal {
61         require(address(this).balance >= amount, "Address: insufficient balance");
62 
63         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
64         (bool success, ) = recipient.call{ value: amount }("");
65         require(success, "Address: unable to send value, recipient may have reverted");
66     }
67 
68     /**
69      * @dev Performs a Solidity function call using a low level `call`. A
70      * plain`call` is an unsafe replacement for a function call: use this
71      * function instead.
72      *
73      * If `target` reverts with a revert reason, it is bubbled up by this
74      * function (like regular Solidity function calls).
75      *
76      * Returns the raw returned data. To convert to the expected return value,
77      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
78      *
79      * Requirements:
80      *
81      * - `target` must be a contract.
82      * - calling `target` with `data` must not revert.
83      *
84      * _Available since v3.1._
85      */
86     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
87       return functionCall(target, data, "Address: low-level call failed");
88     }
89 
90     /**
91      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
92      * `errorMessage` as a fallback revert reason when `target` reverts.
93      *
94      * _Available since v3.1._
95      */
96     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
97         return functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
102      * but also transferring `value` wei to `target`.
103      *
104      * Requirements:
105      *
106      * - the calling contract must have an ETH balance of at least `value`.
107      * - the called Solidity function must be `payable`.
108      *
109      * _Available since v3.1._
110      */
111     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
113     }
114 
115     /**
116      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
117      * with `errorMessage` as a fallback revert reason when `target` reverts.
118      *
119      * _Available since v3.1._
120      */
121     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
122         require(address(this).balance >= value, "Address: insufficient balance for call");
123         require(isContract(target), "Address: call to non-contract");
124 
125         // solhint-disable-next-line avoid-low-level-calls
126         (bool success, bytes memory returndata) = target.call{ value: value }(data);
127         return _verifyCallResult(success, returndata, errorMessage);
128     }
129 
130     /**
131      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
132      * but performing a static call.
133      *
134      * _Available since v3.3._
135      */
136     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
137         return functionStaticCall(target, data, "Address: low-level static call failed");
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
142      * but performing a static call.
143      *
144      * _Available since v3.3._
145      */
146     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
147         require(isContract(target), "Address: static call to non-contract");
148 
149         // solhint-disable-next-line avoid-low-level-calls
150         (bool success, bytes memory returndata) = target.staticcall(data);
151         return _verifyCallResult(success, returndata, errorMessage);
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
156      * but performing a delegate call.
157      *
158      * _Available since v3.3._
159      */
160     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
161         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
166      * but performing a delegate call.
167      *
168      * _Available since v3.3._
169      */
170     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
171         require(isContract(target), "Address: delegate call to non-contract");
172 
173         // solhint-disable-next-line avoid-low-level-calls
174         (bool success, bytes memory returndata) = target.delegatecall(data);
175         return _verifyCallResult(success, returndata, errorMessage);
176     }
177 
178     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
179         if (success) {
180             return returndata;
181         } else {
182             // Look for revert reason and bubble it up if present
183             if (returndata.length > 0) {
184                 // The easiest way to bubble the revert reason is using memory via assembly
185 
186                 // solhint-disable-next-line no-inline-assembly
187                 assembly {
188                     let returndata_size := mload(returndata)
189                     revert(add(32, returndata), returndata_size)
190                 }
191             } else {
192                 revert(errorMessage);
193             }
194         }
195     }
196 }
197 
198 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
199 
200 
201 pragma solidity >=0.6.0 <0.8.0;
202 
203 /**
204  * @dev Interface of the ERC20 standard as defined in the EIP.
205  */
206 interface IERC20 {
207     /**
208      * @dev Returns the amount of tokens in existence.
209      */
210     function totalSupply() external view returns (uint256);
211 
212     /**
213      * @dev Returns the amount of tokens owned by `account`.
214      */
215     function balanceOf(address account) external view returns (uint256);
216 
217     /**
218      * @dev Moves `amount` tokens from the caller's account to `recipient`.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transfer(address recipient, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Returns the remaining number of tokens that `spender` will be
228      * allowed to spend on behalf of `owner` through {transferFrom}. This is
229      * zero by default.
230      *
231      * This value changes when {approve} or {transferFrom} are called.
232      */
233     function allowance(address owner, address spender) external view returns (uint256);
234 
235     /**
236      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * IMPORTANT: Beware that changing an allowance with this method brings the risk
241      * that someone may use both the old and the new allowance by unfortunate
242      * transaction ordering. One possible solution to mitigate this race
243      * condition is to first reduce the spender's allowance to 0 and set the
244      * desired value afterwards:
245      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246      *
247      * Emits an {Approval} event.
248      */
249     function approve(address spender, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Moves `amount` tokens from `sender` to `recipient` using the
253      * allowance mechanism. `amount` is then deducted from the caller's
254      * allowance.
255      *
256      * Returns a boolean value indicating whether the operation succeeded.
257      *
258      * Emits a {Transfer} event.
259      */
260     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
261 
262     /**
263      * @dev Emitted when `value` tokens are moved from one account (`from`) to
264      * another (`to`).
265      *
266      * Note that `value` may be zero.
267      */
268     event Transfer(address indexed from, address indexed to, uint256 value);
269 
270     /**
271      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
272      * a call to {approve}. `value` is the new allowance.
273      */
274     event Approval(address indexed owner, address indexed spender, uint256 value);
275 }
276 
277 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol
278 
279 
280 pragma solidity >=0.6.0 <0.8.0;
281 
282 
283 
284 
285 /**
286  * @title SafeERC20
287  * @dev Wrappers around ERC20 operations that throw on failure (when the token
288  * contract returns false). Tokens that return no value (and instead revert or
289  * throw on failure) are also supported, non-reverting calls are assumed to be
290  * successful.
291  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
292  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
293  */
294 library SafeERC20 {
295     using SafeMath for uint256;
296     using Address for address;
297 
298     function safeTransfer(IERC20 token, address to, uint256 value) internal {
299         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
300     }
301 
302     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
303         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
304     }
305 
306     /**
307      * @dev Deprecated. This function has issues similar to the ones found in
308      * {IERC20-approve}, and its usage is discouraged.
309      *
310      * Whenever possible, use {safeIncreaseAllowance} and
311      * {safeDecreaseAllowance} instead.
312      */
313     function safeApprove(IERC20 token, address spender, uint256 value) internal {
314         // safeApprove should only be called when setting an initial allowance,
315         // or when resetting it to zero. To increase and decrease it, use
316         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
317         // solhint-disable-next-line max-line-length
318         require((value == 0) || (token.allowance(address(this), spender) == 0),
319             "SafeERC20: approve from non-zero to non-zero allowance"
320         );
321         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
322     }
323 
324     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
325         uint256 newAllowance = token.allowance(address(this), spender).add(value);
326         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
327     }
328 
329     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
330         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
331         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
332     }
333 
334     /**
335      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
336      * on the return value: the return value is optional (but if data is returned, it must not be false).
337      * @param token The token targeted by the call.
338      * @param data The call data (encoded using abi.encode or one of its variants).
339      */
340     function _callOptionalReturn(IERC20 token, bytes memory data) private {
341         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
342         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
343         // the target address contains contract code and also asserts for success in the low-level call.
344 
345         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
346         if (returndata.length > 0) { // Return data is optional
347             // solhint-disable-next-line max-line-length
348             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
349         }
350     }
351 }
352 
353 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
354 
355 
356 pragma solidity >=0.6.0 <0.8.0;
357 
358 /*
359  * @dev Provides information about the current execution context, including the
360  * sender of the transaction and its data. While these are generally available
361  * via msg.sender and msg.data, they should not be accessed in such a direct
362  * manner, since when dealing with GSN meta-transactions the account sending and
363  * paying for execution may not be the actual sender (as far as an application
364  * is concerned).
365  *
366  * This contract is only required for intermediate, library-like contracts.
367  */
368 abstract contract Context {
369     function _msgSender() internal view virtual returns (address payable) {
370         return msg.sender;
371     }
372 
373     function _msgData() internal view virtual returns (bytes memory) {
374         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
375         return msg.data;
376     }
377 }
378 
379 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
380 
381 
382 pragma solidity >=0.6.0 <0.8.0;
383 
384 /**
385  * @dev Contract module which provides a basic access control mechanism, where
386  * there is an account (an owner) that can be granted exclusive access to
387  * specific functions.
388  *
389  * By default, the owner account will be the one that deploys the contract. This
390  * can later be changed with {transferOwnership}.
391  *
392  * This module is used through inheritance. It will make available the modifier
393  * `onlyOwner`, which can be applied to your functions to restrict their use to
394  * the owner.
395  */
396 abstract contract Ownable is Context {
397     address private _owner;
398 
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     /**
402      * @dev Initializes the contract setting the deployer as the initial owner.
403      */
404     constructor () internal {
405         address msgSender = _msgSender();
406         _owner = msgSender;
407         emit OwnershipTransferred(address(0), msgSender);
408     }
409 
410     /**
411      * @dev Returns the address of the current owner.
412      */
413     function owner() public view returns (address) {
414         return _owner;
415     }
416 
417     /**
418      * @dev Throws if called by any account other than the owner.
419      */
420     modifier onlyOwner() {
421         require(_owner == _msgSender(), "Ownable: caller is not the owner");
422         _;
423     }
424 
425     /**
426      * @dev Leaves the contract without owner. It will not be possible to call
427      * `onlyOwner` functions anymore. Can only be called by the current owner.
428      *
429      * NOTE: Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public virtual onlyOwner {
433         emit OwnershipTransferred(_owner, address(0));
434         _owner = address(0);
435     }
436 
437     /**
438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
439      * Can only be called by the current owner.
440      */
441     function transferOwnership(address newOwner) public virtual onlyOwner {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         emit OwnershipTransferred(_owner, newOwner);
444         _owner = newOwner;
445     }
446 }
447 
448 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
449 
450 
451 pragma solidity >=0.6.0 <0.8.0;
452 
453 /**
454  * @dev Wrappers over Solidity's arithmetic operations with added overflow
455  * checks.
456  *
457  * Arithmetic operations in Solidity wrap on overflow. This can easily result
458  * in bugs, because programmers usually assume that an overflow raises an
459  * error, which is the standard behavior in high level programming languages.
460  * `SafeMath` restores this intuition by reverting the transaction when an
461  * operation overflows.
462  *
463  * Using this library instead of the unchecked operations eliminates an entire
464  * class of bugs, so it's recommended to use it always.
465  */
466 library SafeMath {
467     /**
468      * @dev Returns the addition of two unsigned integers, reverting on
469      * overflow.
470      *
471      * Counterpart to Solidity's `+` operator.
472      *
473      * Requirements:
474      *
475      * - Addition cannot overflow.
476      */
477     function add(uint256 a, uint256 b) internal pure returns (uint256) {
478         uint256 c = a + b;
479         require(c >= a, "SafeMath: addition overflow");
480 
481         return c;
482     }
483 
484     /**
485      * @dev Returns the subtraction of two unsigned integers, reverting on
486      * overflow (when the result is negative).
487      *
488      * Counterpart to Solidity's `-` operator.
489      *
490      * Requirements:
491      *
492      * - Subtraction cannot overflow.
493      */
494     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
495         return sub(a, b, "SafeMath: subtraction overflow");
496     }
497 
498     /**
499      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
500      * overflow (when the result is negative).
501      *
502      * Counterpart to Solidity's `-` operator.
503      *
504      * Requirements:
505      *
506      * - Subtraction cannot overflow.
507      */
508     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
509         require(b <= a, errorMessage);
510         uint256 c = a - b;
511 
512         return c;
513     }
514 
515     /**
516      * @dev Returns the multiplication of two unsigned integers, reverting on
517      * overflow.
518      *
519      * Counterpart to Solidity's `*` operator.
520      *
521      * Requirements:
522      *
523      * - Multiplication cannot overflow.
524      */
525     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
526         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
527         // benefit is lost if 'b' is also tested.
528         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
529         if (a == 0) {
530             return 0;
531         }
532 
533         uint256 c = a * b;
534         require(c / a == b, "SafeMath: multiplication overflow");
535 
536         return c;
537     }
538 
539     /**
540      * @dev Returns the integer division of two unsigned integers. Reverts on
541      * division by zero. The result is rounded towards zero.
542      *
543      * Counterpart to Solidity's `/` operator. Note: this function uses a
544      * `revert` opcode (which leaves remaining gas untouched) while Solidity
545      * uses an invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function div(uint256 a, uint256 b) internal pure returns (uint256) {
552         return div(a, b, "SafeMath: division by zero");
553     }
554 
555     /**
556      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
557      * division by zero. The result is rounded towards zero.
558      *
559      * Counterpart to Solidity's `/` operator. Note: this function uses a
560      * `revert` opcode (which leaves remaining gas untouched) while Solidity
561      * uses an invalid opcode to revert (consuming all remaining gas).
562      *
563      * Requirements:
564      *
565      * - The divisor cannot be zero.
566      */
567     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
568         require(b > 0, errorMessage);
569         uint256 c = a / b;
570         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
571 
572         return c;
573     }
574 
575     /**
576      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
577      * Reverts when dividing by zero.
578      *
579      * Counterpart to Solidity's `%` operator. This function uses a `revert`
580      * opcode (which leaves remaining gas untouched) while Solidity uses an
581      * invalid opcode to revert (consuming all remaining gas).
582      *
583      * Requirements:
584      *
585      * - The divisor cannot be zero.
586      */
587     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
588         return mod(a, b, "SafeMath: modulo by zero");
589     }
590 
591     /**
592      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
593      * Reverts with custom message when dividing by zero.
594      *
595      * Counterpart to Solidity's `%` operator. This function uses a `revert`
596      * opcode (which leaves remaining gas untouched) while Solidity uses an
597      * invalid opcode to revert (consuming all remaining gas).
598      *
599      * Requirements:
600      *
601      * - The divisor cannot be zero.
602      */
603     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
604         require(b != 0, errorMessage);
605         return a % b;
606     }
607 }
608 
609 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
610 
611 
612 pragma solidity >=0.6.0 <0.8.0;
613 
614 /**
615  * @dev Standard math utilities missing in the Solidity language.
616  */
617 library Math {
618     /**
619      * @dev Returns the largest of two numbers.
620      */
621     function max(uint256 a, uint256 b) internal pure returns (uint256) {
622         return a >= b ? a : b;
623     }
624 
625     /**
626      * @dev Returns the smallest of two numbers.
627      */
628     function min(uint256 a, uint256 b) internal pure returns (uint256) {
629         return a < b ? a : b;
630     }
631 
632     /**
633      * @dev Returns the average of two numbers. The result is rounded towards
634      * zero.
635      */
636     function average(uint256 a, uint256 b) internal pure returns (uint256) {
637         // (a + b) / 2 can overflow, so we distribute
638         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
639     }
640 }
641 
642 // File: browser/Staking.sol
643 
644 
645 pragma solidity 0.7.4;
646 
647 // import "@openzeppelin/contracts/math/Math.sol";
648 // import "@openzeppelin/contracts/math/SafeMath.sol";
649 // import "@openzeppelin/contracts/access/Ownable.sol";
650 // import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
651 
652 
653 contract DeFiWizardStaking is Ownable {
654     using SafeMath for uint256;
655     using SafeERC20 for IERC20;
656 
657     IERC20 public stakeToken;
658     IERC20 public rewardToken;
659 
660     uint256 public constant DURATION = 150 days;
661     uint256 private _totalSupply;
662     uint256 public periodFinish = 0;
663     uint256 public rewardRate = 0;
664     uint256 public lastUpdateTime;
665     uint256 public rewardPerTokenStored;
666 
667     address public rewardDistribution;
668 
669     mapping(address => uint256) private _balances;
670     mapping(address => uint256) public userRewardPerTokenPaid;
671     mapping(address => uint256) public rewards;
672 
673     event RewardAdded(uint256 reward);
674     event Staked(address indexed user, uint256 amount);
675     event Unstaked(address indexed user, uint256 amount);
676     event RewardPaid(address indexed user, uint256 reward);
677     event RecoverToken(address indexed token, uint256 indexed amount);
678 
679     modifier onlyRewardDistribution() {
680         require(
681             msg.sender == rewardDistribution,
682             "Caller is not reward distribution"
683         );
684         _;
685     }
686 
687     modifier updateReward(address account) {
688         rewardPerTokenStored = rewardPerToken();
689         lastUpdateTime = lastTimeRewardApplicable();
690         if (account != address(0)) {
691             rewards[account] = earned(account);
692             userRewardPerTokenPaid[account] = rewardPerTokenStored;
693         }
694         _;
695     }
696 
697     constructor(IERC20 _stakeToken, IERC20 _rewardToken) {
698         stakeToken = _stakeToken;
699         rewardToken = _rewardToken;
700     }
701 
702     function lastTimeRewardApplicable() public view returns (uint256) {
703         return Math.min(block.timestamp, periodFinish);
704     }
705 
706     function rewardPerToken() public view returns (uint256) {
707         if (totalSupply() == 0) {
708             return rewardPerTokenStored;
709         }
710         return
711             rewardPerTokenStored.add(
712                 lastTimeRewardApplicable()
713                     .sub(lastUpdateTime)
714                     .mul(rewardRate)
715                     .mul(1e18)
716                     .div(totalSupply())
717             );
718     }
719 
720     function earned(address account) public view returns (uint256) {
721         return
722             balanceOf(account)
723                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
724                 .div(1e18)
725                 .add(rewards[account]);
726     }
727 
728     function stake(uint256 amount) public updateReward(msg.sender) {
729         require(amount > 0, "Cannot stake 0");
730         _totalSupply = _totalSupply.add(amount);
731         _balances[msg.sender] = _balances[msg.sender].add(amount);
732         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
733         emit Staked(msg.sender, amount);
734     }
735 
736     function unstake(uint256 amount) public updateReward(msg.sender) {
737         require(amount > 0, "Cannot withdraw 0");
738         _totalSupply = _totalSupply.sub(amount);
739         _balances[msg.sender] = _balances[msg.sender].sub(amount);
740         stakeToken.safeTransfer(msg.sender, amount);
741         emit Unstaked(msg.sender, amount);
742     }
743 
744     function exit() external {
745         unstake(balanceOf(msg.sender));
746         getReward();
747     }
748 
749     function getReward() public updateReward(msg.sender) {
750         uint256 reward = earned(msg.sender);
751         if (reward > 0) {
752             rewards[msg.sender] = 0;
753             rewardToken.safeTransfer(msg.sender, reward);
754             emit RewardPaid(msg.sender, reward);
755         }
756     }
757 
758     function notifyRewardAmount(uint256 reward)
759         external
760         onlyRewardDistribution
761         updateReward(address(0))
762     {
763         if (block.timestamp >= periodFinish) {
764             rewardRate = reward.div(DURATION);
765         } else {
766             uint256 remaining = periodFinish.sub(block.timestamp);
767             uint256 leftover = remaining.mul(rewardRate);
768             rewardRate = reward.add(leftover).div(DURATION);
769         }
770         lastUpdateTime = block.timestamp;
771         periodFinish = block.timestamp.add(DURATION);
772         emit RewardAdded(reward);
773     }
774 
775     function setRewardDistribution(address _rewardDistribution)
776         external
777         onlyOwner
778     {
779         rewardDistribution = _rewardDistribution;
780     }
781 
782     function totalSupply() public view returns (uint256) {
783         return _totalSupply;
784     }
785 
786     function balanceOf(address account) public view returns (uint256) {
787         return _balances[account];
788     }
789 
790     function recoverExcessToken(address token, uint256 amount) external onlyOwner {
791         IERC20(token).safeTransfer(_msgSender(), amount);
792         emit RecoverToken(token, amount);
793     }
794 }