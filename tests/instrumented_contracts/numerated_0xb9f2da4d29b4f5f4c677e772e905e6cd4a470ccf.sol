1 // File: @openzeppelin\contracts\math\Math.sol
2 // SPDX-License-Identifier: MIT
3 pragma solidity 0.6.11;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 // File: @openzeppelin\contracts\math\SafeMath.sol
34 pragma solidity >=0.6.0 <0.8.0;
35 
36 /**
37  * @dev Wrappers over Solidity's arithmetic operations with added overflow
38  * checks.
39  *
40  * Arithmetic operations in Solidity wrap on overflow. This can easily result
41  * in bugs, because programmers usually assume that an overflow raises an
42  * error, which is the standard behavior in high level programming languages.
43  * `SafeMath` restores this intuition by reverting the transaction when an
44  * operation overflows.
45  *
46  * Using this library instead of the unchecked operations eliminates an entire
47  * class of bugs, so it's recommended to use it always.
48  */
49 library SafeMath {
50     /**
51      * @dev Returns the addition of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `+` operator.
55      *
56      * Requirements:
57      *
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      *
75      * - Subtraction cannot overflow.
76      */
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80 
81     /**
82      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
83      * overflow (when the result is negative).
84      *
85      * Counterpart to Solidity's `-` operator.
86      *
87      * Requirements:
88      *
89      * - Subtraction cannot overflow.
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      *
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
117         require(c / a == b, "SafeMath: multiplication overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers. Reverts on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137 
138     /**
139      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
140      * division by zero. The result is rounded towards zero.
141      *
142      * Counterpart to Solidity's `/` operator. Note: this function uses a
143      * `revert` opcode (which leaves remaining gas untouched) while Solidity
144      * uses an invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return mod(a, b, "SafeMath: modulo by zero");
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
176      * Reverts with custom message when dividing by zero.
177      *
178      * Counterpart to Solidity's `%` operator. This function uses a `revert`
179      * opcode (which leaves remaining gas untouched) while Solidity uses an
180      * invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
193 pragma solidity >=0.6.0 <0.8.0;
194 
195 /**
196  * @dev Interface of the ERC20 standard as defined in the EIP.
197  */
198 interface IERC20 {
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the amount of tokens owned by `account`.
206      */
207     function balanceOf(address account) external view returns (uint256);
208 
209     /**
210      * @dev Moves `amount` tokens from the caller's account to `recipient`.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transfer(address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Returns the remaining number of tokens that `spender` will be
220      * allowed to spend on behalf of `owner` through {transferFrom}. This is
221      * zero by default.
222      *
223      * This value changes when {approve} or {transferFrom} are called.
224      */
225     function allowance(address owner, address spender) external view returns (uint256);
226 
227     /**
228      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * IMPORTANT: Beware that changing an allowance with this method brings the risk
233      * that someone may use both the old and the new allowance by unfortunate
234      * transaction ordering. One possible solution to mitigate this race
235      * condition is to first reduce the spender's allowance to 0 and set the
236      * desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address spender, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Moves `amount` tokens from `sender` to `recipient` using the
245      * allowance mechanism. `amount` is then deducted from the caller's
246      * allowance.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Emitted when `value` tokens are moved from one account (`from`) to
256      * another (`to`).
257      *
258      * Note that `value` may be zero.
259      */
260     event Transfer(address indexed from, address indexed to, uint256 value);
261 
262     /**
263      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
264      * a call to {approve}. `value` is the new allowance.
265      */
266     event Approval(address indexed owner, address indexed spender, uint256 value);
267 }
268 
269 /**
270  * @dev Wrappers over Solidity's arithmetic operations with added overflow
271  * checks.
272  *
273  * Arithmetic operations in Solidity wrap on overflow. This can easily result
274  * in bugs, because programmers usually assume that an overflow raises an
275  * error, which is the standard behavior in high level programming languages.
276  * `SafeMath` restores this intuition by reverting the transaction when an
277  * operation overflows.
278  *
279  * Using this library instead of the unchecked operations eliminates an entire
280  * class of bugs, so it's recommended to use it always.
281  */
282 
283 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
284 pragma solidity >=0.6.2 <0.8.0;
285 
286 /**
287  * @dev Collection of functions related to the address type
288  */
289 library Address {
290     /**
291      * @dev Returns true if `account` is a contract.
292      *
293      * [IMPORTANT]
294      * ====
295      * It is unsafe to assume that an address for which this function returns
296      * false is an externally-owned account (EOA) and not a contract.
297      *
298      * Among others, `isContract` will return false for the following
299      * types of addresses:
300      *
301      *  - an externally-owned account
302      *  - a contract in construction
303      *  - an address where a contract will be created
304      *  - an address where a contract lived, but was destroyed
305      * ====
306      */
307     function isContract(address account) internal view returns (bool) {
308         // This method relies on extcodesize, which returns 0 for contracts in
309         // construction, since the code is only stored at the end of the
310         // constructor execution.
311 
312         uint256 size;
313         // solhint-disable-next-line no-inline-assembly
314         assembly { size := extcodesize(account) }
315         return size > 0;
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(address(this).balance >= amount, "Address: insufficient balance");
336 
337         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
338         (bool success, ) = recipient.call{ value: amount }("");
339         require(success, "Address: unable to send value, recipient may have reverted");
340     }
341 
342     /**
343      * @dev Performs a Solidity function call using a low level `call`. A
344      * plain`call` is an unsafe replacement for a function call: use this
345      * function instead.
346      *
347      * If `target` reverts with a revert reason, it is bubbled up by this
348      * function (like regular Solidity function calls).
349      *
350      * Returns the raw returned data. To convert to the expected return value,
351      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
352      *
353      * Requirements:
354      *
355      * - `target` must be a contract.
356      * - calling `target` with `data` must not revert.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
361       return functionCall(target, data, "Address: low-level call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
366      * `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, 0, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but also transferring `value` wei to `target`.
377      *
378      * Requirements:
379      *
380      * - the calling contract must have an ETH balance of at least `value`.
381      * - the called Solidity function must be `payable`.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
391      * with `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
396         require(address(this).balance >= value, "Address: insufficient balance for call");
397         require(isContract(target), "Address: call to non-contract");
398 
399         // solhint-disable-next-line avoid-low-level-calls
400         (bool success, bytes memory returndata) = target.call{ value: value }(data);
401         return _verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but performing a static call.
407      *
408      * _Available since v3.3._
409      */
410     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
411         return functionStaticCall(target, data, "Address: low-level static call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
416      * but performing a static call.
417      *
418      * _Available since v3.3._
419      */
420     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
421         require(isContract(target), "Address: static call to non-contract");
422 
423         // solhint-disable-next-line avoid-low-level-calls
424         (bool success, bytes memory returndata) = target.staticcall(data);
425         return _verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
429         if (success) {
430             return returndata;
431         } else {
432             // Look for revert reason and bubble it up if present
433             if (returndata.length > 0) {
434                 // The easiest way to bubble the revert reason is using memory via assembly
435 
436                 // solhint-disable-next-line no-inline-assembly
437                 assembly {
438                     let returndata_size := mload(returndata)
439                     revert(add(32, returndata), returndata_size)
440                 }
441             } else {
442                 revert(errorMessage);
443             }
444         }
445     }
446 }
447 
448 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
449 pragma solidity >=0.6.0 <0.8.0;
450 
451 /**
452  * @title SafeERC20
453  * @dev Wrappers around ERC20 operations that throw on failure (when the token
454  * contract returns false). Tokens that return no value (and instead revert or
455  * throw on failure) are also supported, non-reverting calls are assumed to be
456  * successful.
457  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
458  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
459  */
460 library SafeERC20 {
461     using SafeMath for uint256;
462     using Address for address;
463 
464     function safeTransfer(IERC20 token, address to, uint256 value) internal {
465         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
466     }
467 
468     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
469         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
470     }
471 
472     /**
473      * @dev Deprecated. This function has issues similar to the ones found in
474      * {IERC20-approve}, and its usage is discouraged.
475      *
476      * Whenever possible, use {safeIncreaseAllowance} and
477      * {safeDecreaseAllowance} instead.
478      */
479     function safeApprove(IERC20 token, address spender, uint256 value) internal {
480         // safeApprove should only be called when setting an initial allowance,
481         // or when resetting it to zero. To increase and decrease it, use
482         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
483         // solhint-disable-next-line max-line-length
484         require((value == 0) || (token.allowance(address(this), spender) == 0),
485             "SafeERC20: approve from non-zero to non-zero allowance"
486         );
487         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
488     }
489 
490     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
491         uint256 newAllowance = token.allowance(address(this), spender).add(value);
492         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
493     }
494 
495     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
496         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
497         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
498     }
499 
500     /**
501      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
502      * on the return value: the return value is optional (but if data is returned, it must not be false).
503      * @param token The token targeted by the call.
504      * @param data The call data (encoded using abi.encode or one of its variants).
505      */
506     function _callOptionalReturn(IERC20 token, bytes memory data) private {
507         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
508         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
509         // the target address contains contract code and also asserts for success in the low-level call.
510 
511         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
512         if (returndata.length > 0) { // Return data is optional
513             // solhint-disable-next-line max-line-length
514             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
515         }
516     }
517 }
518 
519 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
520 pragma solidity >=0.6.0 <0.8.0;
521 
522 /*
523  * @dev Provides information about the current execution context, including the
524  * sender of the transaction and its data. While these are generally available
525  * via msg.sender and msg.data, they should not be accessed in such a direct
526  * manner, since when dealing with GSN meta-transactions the account sending and
527  * paying for execution may not be the actual sender (as far as an application
528  * is concerned).
529  *
530  * This contract is only required for intermediate, library-like contracts.
531  */
532 abstract contract Context {
533     function _msgSender() internal view virtual returns (address payable) {
534         return msg.sender;
535     }
536 
537     function _msgData() internal view virtual returns (bytes memory) {
538         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
539         return msg.data;
540     }
541 }
542 
543 // File: @openzeppelin\contracts\access\Ownable.sol
544 pragma solidity >=0.6.0 <0.8.0;
545 
546 /**
547  * @dev Contract module which provides a basic access control mechanism, where
548  * there is an account (an owner) that can be granted exclusive access to
549  * specific functions.
550  *
551  * By default, the owner account will be the one that deploys the contract. This
552  * can later be changed with {transferOwnership}.
553  *
554  * This module is used through inheritance. It will make available the modifier
555  * `onlyOwner`, which can be applied to your functions to restrict their use to
556  * the owner.
557  */
558 abstract contract Ownable is Context {
559     address private _owner;
560 
561     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
562 
563     /**
564      * @dev Initializes the contract setting the deployer as the initial owner.
565      */
566     constructor () internal {
567         address msgSender = _msgSender();
568         _owner = msgSender;
569         emit OwnershipTransferred(address(0), msgSender);
570     }
571 
572     /**
573      * @dev Returns the address of the current owner.
574      */
575     function owner() public view returns (address) {
576         return _owner;
577     }
578 
579     /**
580      * @dev Throws if called by any account other than the owner.
581      */
582     modifier onlyOwner() {
583         require(_owner == _msgSender(), "Ownable: caller is not the owner");
584         _;
585     }
586 
587     /**
588      * @dev Leaves the contract without owner. It will not be possible to call
589      * `onlyOwner` functions anymore. Can only be called by the current owner.
590      *
591      * NOTE: Renouncing ownership will leave the contract without an owner,
592      * thereby removing any functionality that is only available to the owner.
593      */
594     function renounceOwnership() public virtual onlyOwner {
595         emit OwnershipTransferred(_owner, address(0));
596         _owner = address(0);
597     }
598 
599     /**
600      * @dev Transfers ownership of the contract to a new account (`newOwner`).
601      * Can only be called by the current owner.
602      */
603     function transferOwnership(address newOwner) public virtual onlyOwner {
604         require(newOwner != address(0), "Ownable: new owner is the zero address");
605         emit OwnershipTransferred(_owner, newOwner);
606         _owner = newOwner;
607     }
608 }
609 
610 // File: contracts\StakingDrop.sol
611 pragma solidity 0.6.11;
612 
613 contract StakingDrop is Ownable {
614     using SafeMath for uint256;
615     using SafeERC20 for IERC20;
616 
617     address public immutable hbtcAddress; //hbtc的地址
618     address public immutable bdtAddress; //奖励的token
619     uint256 public immutable bonusStartAt; //活动开始时间
620 
621     /* ========== CONSTANTS ========== */
622 
623     uint256 public constant BONUS_DURATION = 32 days;
624     uint256 public constant MAX_CLAIM_DURATION = 8 days;
625     uint256 public constant TOTAL_BDT_REWARDS = 10000000 ether;
626 
627     mapping(address => uint256) public myDeposit; //存的数量
628     mapping(address => uint256) public myRewards; //领取的奖励
629     mapping(address => uint256) public myLastClaimedAt; //最后领取的时间
630 
631     uint256 public claimedRewards; //发的奖励的总数
632     uint256 public totalDeposit; //总抵押数
633 
634     event Deposit(address indexed sender, uint256 amount);
635     event Withdrawal(address indexed sender, uint256 amount);
636     event Claimed(address indexed sender, uint256 amount, uint256 claimed);
637 
638     constructor(
639         address hbtcAddress_,
640         address bdtAddress_,
641         uint256 bonusStartAt_
642     ) public Ownable() {
643         require(hbtcAddress_ != address(0), "StakingDrop: hbtcAddress_ is zero address");
644         require(bdtAddress_ != address(0), "StakingDrop: bdtAddress_ is zero address");
645 
646         hbtcAddress = hbtcAddress_;
647         bdtAddress = bdtAddress_;
648         bonusStartAt = bonusStartAt_;
649     }
650 
651     function withdraw(uint256 amount) external {
652         if (block.timestamp < bonusStartAt.add(BONUS_DURATION)) return;
653         require(amount > 0, "StakingDrop: amount should greater than zero");
654 
655         claimRewards();
656         myDeposit[msg.sender] = myDeposit[msg.sender].sub(amount);
657         totalDeposit = totalDeposit.sub(amount);
658 
659         require(IERC20(hbtcAddress).transfer(msg.sender, amount), "StakingDrop: withdraw transfer failed");
660 
661         emit Withdrawal(msg.sender, amount);
662     }
663 
664     function deposit(uint256 _value) external {
665         if (block.timestamp < bonusStartAt) return;
666         if (block.timestamp > bonusStartAt.add(BONUS_DURATION)) return;
667         require(_value > 0, "StakingDrop: _value should greater than zero");
668 
669         claimRewards();
670         myDeposit[msg.sender] = myDeposit[msg.sender].add(_value);
671         totalDeposit = totalDeposit.add(_value);
672 
673         require(IERC20(hbtcAddress).transferFrom(msg.sender, address(this), _value), "StakingDrop: deposit transferFrom failed");
674 
675         emit Deposit(msg.sender, _value);
676     }
677 
678     function claimRewards() public {
679         // claim must start from bonusStartAt
680         if (block.timestamp < bonusStartAt) {
681             if (myLastClaimedAt[msg.sender] < bonusStartAt) {
682                 myLastClaimedAt[msg.sender] = bonusStartAt;
683             }
684             return;
685         }
686         if (myLastClaimedAt[msg.sender] >= bonusStartAt) {
687             uint256 rewards = getIncrementalRewards(msg.sender);
688             myRewards[msg.sender] = myRewards[msg.sender].add(rewards);
689             claimedRewards = claimedRewards.add(rewards);
690 
691             require(IERC20(bdtAddress).transfer(msg.sender, rewards), "StakingDrop: claimRewards transfer failed");
692 
693             emit Claimed(msg.sender, myRewards[msg.sender], claimedRewards);
694         }
695         myLastClaimedAt[msg.sender] = block.timestamp >
696             bonusStartAt.add(BONUS_DURATION)
697             ? bonusStartAt.add(BONUS_DURATION)
698             : block.timestamp;
699     }
700 
701     function getTotalRewards() public view returns (uint256) {
702         if (block.timestamp < bonusStartAt) {
703             return 0;
704         }
705         uint256 duration = block.timestamp.sub(bonusStartAt);
706         if (duration > BONUS_DURATION) {
707             return TOTAL_BDT_REWARDS;
708         }
709         return TOTAL_BDT_REWARDS.mul(duration).div(BONUS_DURATION);
710     }
711 
712     function getIncrementalRewards(address target)
713         public
714         view
715         returns (uint256)
716     {
717         uint256 totalRewards = getTotalRewards();
718         if (
719             myLastClaimedAt[target] < bonusStartAt ||
720             totalDeposit == 0 ||
721             totalRewards == 0
722         ) {
723             return 0;
724         }
725         uint256 remainingRewards = totalRewards.sub(claimedRewards);
726         uint256 myDuration = block.timestamp > bonusStartAt.add(BONUS_DURATION)
727             ? bonusStartAt.add(BONUS_DURATION).sub(myLastClaimedAt[target])
728             : block.timestamp.sub(myLastClaimedAt[target]);
729         if (myDuration > MAX_CLAIM_DURATION) {
730             myDuration = MAX_CLAIM_DURATION;
731         }
732         uint256 rewards = remainingRewards
733             .mul(myDeposit[target])
734             .div(totalDeposit)
735             .mul(myDuration)
736             .div(MAX_CLAIM_DURATION);
737         return rewards;
738     }
739 }