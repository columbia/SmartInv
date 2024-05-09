1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 // -License-Identifier: MIT
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 // -License-Identifier: MIT
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 // -License-Identifier: MIT
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: contracts/utils/ContractGuard.sol
465 
466 pragma solidity ^0.6.12;
467 
468 contract ContractGuard {
469     mapping(uint256 => mapping(address => bool)) private _status;
470 
471     function checkSameOriginReentranted() internal view returns (bool) {
472         return _status[block.number][tx.origin];
473     }
474 
475     function checkSameSenderReentranted() internal view returns (bool) {
476         return _status[block.number][msg.sender];
477     }
478 
479     modifier onlyOneBlock() {
480         require(
481             !checkSameOriginReentranted(),
482             'ContractGuard: one block, one function'
483         );
484         require(
485             !checkSameSenderReentranted(),
486             'ContractGuard: one block, one function'
487         );
488 
489         _;
490 
491         _status[block.number][tx.origin] = true;
492         _status[block.number][msg.sender] = true;
493     }
494 }
495 
496 // File: @openzeppelin/contracts/math/Math.sol
497 
498 // -License-Identifier: MIT
499 
500 pragma solidity ^0.6.0;
501 
502 /**
503  * @dev Standard math utilities missing in the Solidity language.
504  */
505 library Math {
506     /**
507      * @dev Returns the largest of two numbers.
508      */
509     function max(uint256 a, uint256 b) internal pure returns (uint256) {
510         return a >= b ? a : b;
511     }
512 
513     /**
514      * @dev Returns the smallest of two numbers.
515      */
516     function min(uint256 a, uint256 b) internal pure returns (uint256) {
517         return a < b ? a : b;
518     }
519 
520     /**
521      * @dev Returns the average of two numbers. The result is rounded towards
522      * zero.
523      */
524     function average(uint256 a, uint256 b) internal pure returns (uint256) {
525         // (a + b) / 2 can overflow, so we distribute
526         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
527     }
528 }
529 
530 // File: @openzeppelin/contracts/GSN/Context.sol
531 
532 // -License-Identifier: MIT
533 
534 pragma solidity ^0.6.0;
535 
536 /*
537  * @dev Provides information about the current execution context, including the
538  * sender of the transaction and its data. While these are generally available
539  * via msg.sender and msg.data, they should not be accessed in such a direct
540  * manner, since when dealing with GSN meta-transactions the account sending and
541  * paying for execution may not be the actual sender (as far as an application
542  * is concerned).
543  *
544  * This contract is only required for intermediate, library-like contracts.
545  */
546 abstract contract Context {
547     function _msgSender() internal view virtual returns (address payable) {
548         return msg.sender;
549     }
550 
551     function _msgData() internal view virtual returns (bytes memory) {
552         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
553         return msg.data;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/access/Ownable.sol
558 
559 // -License-Identifier: MIT
560 
561 pragma solidity ^0.6.0;
562 
563 /**
564  * @dev Contract module which provides a basic access control mechanism, where
565  * there is an account (an owner) that can be granted exclusive access to
566  * specific functions.
567  *
568  * By default, the owner account will be the one that deploys the contract. This
569  * can later be changed with {transferOwnership}.
570  *
571  * This module is used through inheritance. It will make available the modifier
572  * `onlyOwner`, which can be applied to your functions to restrict their use to
573  * the owner.
574  */
575 contract Ownable is Context {
576     address private _owner;
577 
578     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
579 
580     /**
581      * @dev Initializes the contract setting the deployer as the initial owner.
582      */
583     constructor () internal {
584         address msgSender = _msgSender();
585         _owner = msgSender;
586         emit OwnershipTransferred(address(0), msgSender);
587     }
588 
589     /**
590      * @dev Returns the address of the current owner.
591      */
592     function owner() public view returns (address) {
593         return _owner;
594     }
595 
596     /**
597      * @dev Throws if called by any account other than the owner.
598      */
599     modifier onlyOwner() {
600         require(_owner == _msgSender(), "Ownable: caller is not the owner");
601         _;
602     }
603 
604     /**
605      * @dev Leaves the contract without owner. It will not be possible to call
606      * `onlyOwner` functions anymore. Can only be called by the current owner.
607      *
608      * NOTE: Renouncing ownership will leave the contract without an owner,
609      * thereby removing any functionality that is only available to the owner.
610      */
611     function renounceOwnership() public virtual onlyOwner {
612         emit OwnershipTransferred(_owner, address(0));
613         _owner = address(0);
614     }
615 
616     /**
617      * @dev Transfers ownership of the contract to a new account (`newOwner`).
618      * Can only be called by the current owner.
619      */
620     function transferOwnership(address newOwner) public virtual onlyOwner {
621         require(newOwner != address(0), "Ownable: new owner is the zero address");
622         emit OwnershipTransferred(_owner, newOwner);
623         _owner = newOwner;
624     }
625 }
626 
627 // File: contracts/owner/Operator.sol
628 
629 pragma solidity ^0.6.0;
630 
631 
632 
633 contract Operator is Context, Ownable {
634     address private _operator;
635 
636     event OperatorTransferred(
637         address indexed previousOperator,
638         address indexed newOperator
639     );
640 
641     constructor() internal {
642         _operator = _msgSender();
643         emit OperatorTransferred(address(0), _operator);
644     }
645 
646     function operator() public view returns (address) {
647         return _operator;
648     }
649 
650     modifier onlyOperator() {
651         require(
652             _operator == msg.sender,
653             'operator: caller is not the operator'
654         );
655         _;
656     }
657 
658     function isOperator() public view returns (bool) {
659         return _msgSender() == _operator;
660     }
661 
662     function transferOperator(address newOperator_) public onlyOwner {
663         _transferOperator(newOperator_);
664     }
665 
666     function _transferOperator(address newOperator_) internal {
667         require(
668             newOperator_ != address(0),
669             'operator: zero address given for new operator'
670         );
671         emit OperatorTransferred(address(0), newOperator_);
672         _operator = newOperator_;
673     }
674 }
675 
676 // File: contracts/utils/Epoch.sol
677 
678 pragma solidity ^0.6.0;
679 
680 
681 
682 
683 contract Epoch is Operator {
684     using SafeMath for uint256;
685 
686     uint256 private period;
687     uint256 private startTime;
688     uint256 private lastExecutedAt;
689 
690     /* ========== CONSTRUCTOR ========== */
691 
692     constructor(
693         uint256 _period,
694         uint256 _startTime,
695         uint256 _startEpoch
696     ) public {
697         require(_startTime > block.timestamp, 'Epoch: invalid start time');
698         period = _period;
699         startTime = _startTime;
700         lastExecutedAt = startTime.add(_startEpoch.mul(period));
701     }
702 
703     /* ========== Modifier ========== */
704 
705     modifier checkStartTime {
706         require(now >= startTime, 'Epoch: not started yet');
707 
708         _;
709     }
710 
711     modifier checkEpoch {
712         require(now > startTime, 'Epoch: not started yet');
713         require(getCurrentEpoch() >= getNextEpoch(), 'Epoch: not allowed');
714 
715         _;
716 
717         lastExecutedAt = block.timestamp;
718     }
719 
720     /* ========== VIEW FUNCTIONS ========== */
721 
722     // epoch
723     function getLastEpoch() public view returns (uint256) {
724         return lastExecutedAt.sub(startTime).div(period);
725     }
726 
727     function getCurrentEpoch() public view returns (uint256) {
728         return Math.max(startTime, block.timestamp).sub(startTime).div(period);
729     }
730 
731     function getNextEpoch() public view returns (uint256) {
732         if (startTime == lastExecutedAt) {
733             return getLastEpoch();
734         }
735         return getLastEpoch().add(1);
736     }
737 
738     function nextEpochPoint() public view returns (uint256) {
739         return startTime.add(getNextEpoch().mul(period));
740     }
741 
742     // params
743     function getPeriod() public view returns (uint256) {
744         return period;
745     }
746 
747     function getStartTime() public view returns (uint256) {
748         return startTime;
749     }
750 
751     /* ========== GOVERNANCE ========== */
752 
753     function setPeriod(uint256 _period) external onlyOperator {
754         period = _period;
755     }
756 }
757 
758 // File: contracts/ProRataRewardCheckpoint.sol
759 
760 pragma solidity ^0.6.0;
761 
762 
763 // This is forked and modified from https://github.com/BarnBridge/BarnBridge-YieldFarming/blob/master/contracts/Staking.sol
764 contract ProRataRewardCheckpoint {
765     using SafeMath for uint256;
766     uint256 internal epochDuration;
767     uint256 internal epoch1Start;
768     uint128 constant private BASE_MULTIPLIER = uint128(1 * 10 ** 18);
769     address private stakeToken;
770 
771     struct Pool {
772         uint256 size;
773         bool set;
774     }
775 
776     // for each token, we store the total pool size
777     mapping(uint256 => Pool) private poolSize;
778 
779 
780     // a checkpoint of the valid balance of a user for an epoch
781     struct Checkpoint {
782         uint128 epochId;
783         uint128 multiplier;
784         uint256 startBalance;
785         uint256 newDeposits;
786     }
787 
788     // balanceCheckpoints[user][token][]
789     mapping(address => Checkpoint[]) private balanceCheckpoints;
790     uint128 private lastWithdrawEpochId;
791 
792     constructor (uint256 _epochDuration, uint256 _epoch1Start, address _stakeToken) public {
793         epoch1Start = _epoch1Start;
794         epochDuration = _epochDuration;
795         stakeToken = _stakeToken;
796     }
797 
798     // this is the fork from deposit
799     function depositCheckpoint(address user, uint256 amount, uint256 previousAmount, uint128 currentEpoch) internal {
800         IERC20 token = IERC20(stakeToken);
801 
802         // epoch logic
803         uint128 currentMultiplier = currentEpochMultiplier(currentEpoch);
804 
805         if (!epochIsInitialized(currentEpoch)) {
806             manualEpochInit(currentEpoch, currentEpoch);
807         }
808 
809         // update the next epoch pool size
810         Pool storage pNextEpoch = poolSize[currentEpoch + 1];
811         pNextEpoch.size = token.balanceOf(address(this));
812         pNextEpoch.set = true;
813 
814         Checkpoint[] storage checkpoints = balanceCheckpoints[user];
815 
816         uint256 balanceBefore = getEpochUserBalance(user, currentEpoch);
817 
818         // if there's no checkpoint yet, it means the user didn't have any activity
819         // we want to store checkpoints both for the current epoch and next epoch because
820         // if a user does a withdraw, the current epoch can also be modified and
821         // we don't want to insert another checkpoint in the middle of the array as that could be expensive
822         if (checkpoints.length == 0) {
823             checkpoints.push(Checkpoint(currentEpoch, currentMultiplier, 0, amount));
824 
825             // next epoch => multiplier is 1, epoch deposits is 0
826             checkpoints.push(Checkpoint(currentEpoch + 1, BASE_MULTIPLIER, amount, 0));
827         } else {
828             uint256 last = checkpoints.length - 1;
829 
830             // the last action happened in an older epoch (e.g. a deposit in epoch 3, current epoch is >=5)
831             if (checkpoints[last].epochId < currentEpoch) {
832                 uint128 multiplier = computeNewMultiplier(
833                     getCheckpointBalance(checkpoints[last]),
834                     BASE_MULTIPLIER,
835                     amount,
836                     currentMultiplier
837                 );
838                 checkpoints.push(Checkpoint(currentEpoch, multiplier, getCheckpointBalance(checkpoints[last]), amount));
839                 checkpoints.push(Checkpoint(currentEpoch + 1, BASE_MULTIPLIER, previousAmount.add(amount), 0));
840             }
841             // the last action happened in the previous epoch
842             else if (checkpoints[last].epochId == currentEpoch) {
843                 checkpoints[last].multiplier = computeNewMultiplier(
844                     getCheckpointBalance(checkpoints[last]),
845                     checkpoints[last].multiplier,
846                     amount,
847                     currentMultiplier
848                 );
849                 checkpoints[last].newDeposits = checkpoints[last].newDeposits.add(amount);
850 
851                 checkpoints.push(Checkpoint(currentEpoch + 1, BASE_MULTIPLIER, previousAmount.add(amount), 0));
852             }
853             // the last action happened in the current epoch
854             else {
855                 if (last >= 1 && checkpoints[last - 1].epochId == currentEpoch) {
856                     checkpoints[last - 1].multiplier = computeNewMultiplier(
857                         getCheckpointBalance(checkpoints[last - 1]),
858                         checkpoints[last - 1].multiplier,
859                         amount,
860                         currentMultiplier
861                     );
862                     checkpoints[last - 1].newDeposits = checkpoints[last - 1].newDeposits.add(amount);
863                 }
864 
865                 checkpoints[last].startBalance = previousAmount.add(amount);
866             }
867         }
868 
869         uint256 balanceAfter = getEpochUserBalance(user, currentEpoch);
870 
871         poolSize[currentEpoch].size = poolSize[currentEpoch].size.add(balanceAfter.sub(balanceBefore));
872     }
873 
874     // this is the fork from withdraw
875    function withdrawCheckpoint(address user, uint256 amount, uint256 previousAmount, uint128 currentEpoch) internal {
876         IERC20 token = IERC20(stakeToken);
877         lastWithdrawEpochId = currentEpoch;
878 
879         if (!epochIsInitialized(currentEpoch)) {
880             manualEpochInit(currentEpoch, currentEpoch);
881         }
882 
883         // update the pool size of the next epoch to its current balance
884         Pool storage pNextEpoch = poolSize[currentEpoch + 1];
885         pNextEpoch.size = token.balanceOf(address(this));
886         pNextEpoch.set = true;
887 
888         Checkpoint[] storage checkpoints = balanceCheckpoints[user];
889         uint256 last = checkpoints.length - 1;
890 
891         // note: it's impossible to have a withdraw and no checkpoints because the balance would be 0 and revert
892 
893         // there was a deposit in an older epoch (more than 1 behind [eg: previous 0, now 5]) but no other action since then
894         if (checkpoints[last].epochId < currentEpoch) {
895             checkpoints.push(Checkpoint(currentEpoch, BASE_MULTIPLIER, previousAmount.sub(amount), 0));
896 
897             poolSize[currentEpoch].size = poolSize[currentEpoch].size.sub(amount);
898         }
899         // there was a deposit in the `epochId - 1` epoch => we have a checkpoint for the current epoch
900         else if (checkpoints[last].epochId == currentEpoch) {
901             checkpoints[last].startBalance = previousAmount.sub(amount);
902             checkpoints[last].newDeposits = 0;
903             checkpoints[last].multiplier = BASE_MULTIPLIER;
904 
905             poolSize[currentEpoch].size = poolSize[currentEpoch].size.sub(amount);
906         }
907         // there was a deposit in the current epoch
908         else {
909             Checkpoint storage currentEpochCheckpoint = checkpoints[last - 1];
910 
911             uint256 balanceBefore = getCheckpointEffectiveBalance(currentEpochCheckpoint);
912 
913             // in case of withdraw, we have 2 branches:
914             // 1. the user withdraws less than he added in the current epoch
915             // 2. the user withdraws more than he added in the current epoch (including 0)
916             if (amount < currentEpochCheckpoint.newDeposits) {
917                 uint128 avgDepositMultiplier = uint128(
918                     balanceBefore.sub(currentEpochCheckpoint.startBalance).mul(BASE_MULTIPLIER).div(currentEpochCheckpoint.newDeposits)
919                 );
920 
921                 currentEpochCheckpoint.newDeposits = currentEpochCheckpoint.newDeposits.sub(amount);
922 
923                 currentEpochCheckpoint.multiplier = computeNewMultiplier(
924                     currentEpochCheckpoint.startBalance,
925                     BASE_MULTIPLIER,
926                     currentEpochCheckpoint.newDeposits,
927                     avgDepositMultiplier
928                 );
929             } else {
930                 currentEpochCheckpoint.startBalance = currentEpochCheckpoint.startBalance.sub(
931                     amount.sub(currentEpochCheckpoint.newDeposits)
932                 );
933                 currentEpochCheckpoint.newDeposits = 0;
934                 currentEpochCheckpoint.multiplier = BASE_MULTIPLIER;
935             }
936 
937             uint256 balanceAfter = getCheckpointEffectiveBalance(currentEpochCheckpoint);
938 
939             poolSize[currentEpoch].size = poolSize[currentEpoch].size.sub(balanceBefore.sub(balanceAfter));
940 
941             checkpoints[last].startBalance = previousAmount.sub(amount);
942         }
943     }
944 
945     /*
946      * Returns the valid balance of a user that was taken into consideration in the total pool size for the epoch
947      * A deposit will only change the next epoch balance.
948      * A withdraw will decrease the current epoch (and subsequent) balance.
949      */
950     function getEpochUserBalance(address user, uint128 epochId) public view returns (uint256) {
951         Checkpoint[] storage checkpoints = balanceCheckpoints[user];
952 
953         // if there are no checkpoints, it means the user never deposited any tokens, so the balance is 0
954         if (checkpoints.length == 0 || epochId < checkpoints[0].epochId) {
955             return 0;
956         }
957 
958         uint min = 0;
959         uint max = checkpoints.length - 1;
960 
961         // shortcut for blocks newer than the latest checkpoint == current balance
962         if (epochId >= checkpoints[max].epochId) {
963             return getCheckpointEffectiveBalance(checkpoints[max]);
964         }
965 
966         // binary search of the value in the array
967         while (max > min) {
968             uint mid = (max + min + 1) / 2;
969             if (checkpoints[mid].epochId <= epochId) {
970                 min = mid;
971             } else {
972                 max = mid - 1;
973             }
974         }
975 
976         return getCheckpointEffectiveBalance(checkpoints[min]);
977     }
978 
979 
980     /*
981      * manualEpochInit can be used by anyone to initialize an epoch based on the previous one
982      * This is only applicable if there was no action (deposit/withdraw) in the current epoch.
983      * Any deposit and withdraw will automatically initialize the current and next epoch.
984      */
985     function manualEpochInit(uint128 epochId, uint128 currentEpoch) internal {
986         require(epochId <= currentEpoch, "can't init a future epoch");
987 
988         Pool storage p = poolSize[epochId];
989 
990         if (epochId == 0) {
991             p.size = uint256(0);
992             p.set = true;
993         } else {
994             require(!epochIsInitialized(epochId), "Staking: epoch already initialized");
995             require(epochIsInitialized(epochId - 1), "Staking: previous epoch not initialized");
996 
997             p.size = poolSize[epochId - 1].size;
998             p.set = true;
999         }
1000 
1001 
1002         // emit ManualEpochInit(msg.sender, epochId, tokens);
1003     }
1004 
1005     function computeNewMultiplier(uint256 prevBalance, uint128 prevMultiplier, uint256 amount, uint128 currentMultiplier) public pure returns (uint128) {
1006         uint256 prevAmount = prevBalance.mul(prevMultiplier).div(BASE_MULTIPLIER);
1007         uint256 addAmount = amount.mul(currentMultiplier).div(BASE_MULTIPLIER);
1008         uint128 newMultiplier = uint128(prevAmount.add(addAmount).mul(BASE_MULTIPLIER).div(prevBalance.add(amount)));
1009 
1010         return newMultiplier;
1011     }
1012 
1013     /*
1014      * Returns the percentage of time left in the current epoch
1015      */
1016     function currentEpochMultiplier(uint128 currentEpoch) public view returns (uint128) {
1017         uint256 currentEpochEnd = epoch1Start + currentEpoch * epochDuration;
1018         uint256 timeLeft = currentEpochEnd - block.timestamp;
1019         uint128 multiplier = uint128(timeLeft * BASE_MULTIPLIER / epochDuration);
1020 
1021         return multiplier;
1022     }
1023 
1024     /*
1025      * Returns the total amount of `tokenAddress` that was locked from beginning to end of epoch identified by `epochId`
1026     */
1027     function getEpochPoolSize(uint128 epochId) public view returns (uint256) {
1028         // Premises:
1029         // 1. it's impossible to have gaps of uninitialized epochs
1030         // - any deposit or withdraw initialize the current epoch which requires the previous one to be initialized
1031         if (epochIsInitialized(epochId)) {
1032             return poolSize[epochId].size;
1033         }
1034 
1035         // epochId not initialized and epoch 0 not initialized => there was never any action on this pool
1036         if (!epochIsInitialized(0)) {
1037             return 0;
1038         }
1039 
1040         // epoch 0 is initialized => there was an action at some point but none that initialized the epochId
1041         // which means the current pool size is equal to the current balance of token held by the staking contract
1042         IERC20 token = IERC20(stakeToken);
1043         return token.balanceOf(address(this));
1044     }
1045 
1046     /*
1047      * Checks if an epoch is initialized, meaning we have a pool size set for it
1048      */
1049     function epochIsInitialized(uint128 epochId) public view returns (bool) {
1050         return poolSize[epochId].set;
1051     }
1052 
1053     function getCheckpointBalance(Checkpoint memory c) internal pure returns (uint256) {
1054         return c.startBalance.add(c.newDeposits);
1055     }
1056 
1057     function getCheckpointEffectiveBalance(Checkpoint memory c) internal pure returns (uint256) {
1058         return getCheckpointBalance(c).mul(c.multiplier).div(BASE_MULTIPLIER);
1059     }
1060 }
1061 
1062 // File: contracts/interfaces/IFeeDistributorRecipient.sol
1063 
1064 pragma solidity ^0.6.0;
1065 
1066 
1067 abstract contract IFeeDistributorRecipient is Ownable {
1068     address public feeDistributor;
1069 
1070     modifier onlyFeeDistributor() {
1071         require(
1072             _msgSender() == feeDistributor,
1073             'Caller is not fee distributor'
1074         );
1075         _;
1076     }
1077 
1078     function setFeeDistributor(address _feeDistributor)
1079         external
1080         virtual
1081         onlyOwner
1082     {
1083         feeDistributor = _feeDistributor;
1084     }
1085 }
1086 
1087 // File: contracts/Boardroomv2.sol
1088 
1089 pragma solidity ^0.6.0;
1090 //pragma experimental ABIEncoderV2;
1091 
1092 
1093 
1094 
1095 
1096 
1097 
1098 contract ShareWrapper {
1099     using SafeMath for uint256;
1100     using SafeERC20 for IERC20;
1101 
1102     IERC20 public share;
1103 
1104     uint256 private _totalSupply;
1105     mapping(address => uint256) private _balances;
1106 
1107     function totalSupply() public view returns (uint256) {
1108         return _totalSupply;
1109     }
1110 
1111     function balanceOf(address account) public view returns (uint256) {
1112         return _balances[account];
1113     }
1114 
1115     function stake(uint256 amount) public virtual {
1116         _totalSupply = _totalSupply.add(amount);
1117         _balances[msg.sender] = _balances[msg.sender].add(amount);
1118         share.safeTransferFrom(msg.sender, address(this), amount);
1119     }
1120 
1121     function withdraw(uint256 amount) public virtual {
1122         uint256 directorShare = _balances[msg.sender];
1123         require(
1124             directorShare >= amount,
1125             'Boardroom: withdraw request greater than staked amount'
1126         );
1127         _totalSupply = _totalSupply.sub(amount);
1128         _balances[msg.sender] = directorShare.sub(amount);
1129         share.safeTransfer(msg.sender, amount);
1130     }
1131 }
1132 
1133 contract Boardroomv2 is ShareWrapper, ContractGuard, Epoch, ProRataRewardCheckpoint, IFeeDistributorRecipient{
1134     using SafeERC20 for IERC20;
1135     using Address for address;
1136     using SafeMath for uint256;
1137 
1138     /* ========== DATA STRUCTURES ========== */
1139 
1140     struct Boardseat {
1141         uint256 lastSnapshotIndex;
1142         uint256 startEpoch;
1143         uint256 lastEpoch;
1144         mapping(uint256 => uint256) rewardEarned;
1145     }
1146 
1147     struct BoardSnapshot {
1148         uint256 time;
1149         uint256 rewardReceived;
1150         uint256 rewardPerShare;
1151     }
1152 
1153     /* ========== STATE VARIABLES ========== */
1154 
1155     IERC20 private cash;
1156 
1157     mapping(address => Boardseat) private directors;
1158     BoardSnapshot[] private boardHistory;
1159 
1160     /* ========== CONSTRUCTOR ========== */
1161 
1162     constructor(IERC20 _cash, IERC20 _share, uint256 _startTime)
1163         public Epoch(24 hours, _startTime, 0)
1164         ProRataRewardCheckpoint(6 hours, _startTime, address(_share))
1165     {
1166         cash = _cash;
1167         share = _share;
1168 
1169         BoardSnapshot memory genesisSnapshot = BoardSnapshot({
1170             time: block.number,
1171             rewardReceived: 0,
1172             rewardPerShare: 0
1173         });
1174         boardHistory.push(genesisSnapshot);
1175     }
1176 
1177     /* ========== Modifiers =============== */
1178     modifier directorExists {
1179         require(
1180             balanceOf(msg.sender) > 0,
1181             'Boardroom: The director does not exist'
1182         );
1183         _;
1184     }
1185 
1186     modifier updateReward(address director) {
1187         if (director != address(0)) {
1188             Boardseat storage seat = directors[director];
1189             uint256 currentEpoch = getCurrentEpoch();
1190 
1191             seat.rewardEarned[currentEpoch] = seat.rewardEarned[currentEpoch].add(earnedNew(director));
1192             seat.lastEpoch = currentEpoch;
1193             seat.lastSnapshotIndex = latestSnapshotIndex();
1194         }
1195         _;
1196     }
1197 
1198     /* ========== VIEW FUNCTIONS ========== */
1199 
1200     function calculateClaimableRewardsForEpoch(address wallet, uint256 epoch) view public returns (uint256) {
1201         return calculateClaimable(directors[wallet].rewardEarned[epoch], epoch);
1202     }
1203 
1204     function calculateClaimable(uint256 earned, uint256 epoch) view public returns (uint256) {
1205         uint256 epoch_delta = getCurrentEpoch() - epoch;
1206 
1207         uint256 ten = 10;
1208         uint256 five = 5;
1209         uint256 tax_percentage = (epoch_delta > 4) ? 0 : ten.mul(five.sub(epoch_delta));
1210 
1211         uint256 hundred = 100;
1212         return earned.mul(hundred.sub(tax_percentage)).div(hundred);
1213     }
1214 
1215     // staking before start time regards as staking at epoch 0.
1216     function getCheckpointEpoch() view public returns(uint128) {
1217         if (block.timestamp < epoch1Start) {
1218             return 0;
1219         }
1220         return uint128((block.timestamp - epoch1Start) / epochDuration + 1);
1221     }
1222 
1223     // =========== Snapshot getters
1224 
1225     function latestSnapshotIndex() public view returns (uint256) {
1226         return boardHistory.length.sub(1);
1227     }
1228 
1229     function getLatestSnapshot() internal view returns (BoardSnapshot memory) {
1230         return boardHistory[latestSnapshotIndex()];
1231     }
1232 
1233     function getLastSnapshotIndexOf(address director)
1234         public
1235         view
1236         returns (uint256)
1237     {
1238         return directors[director].lastSnapshotIndex;
1239     }
1240 
1241     function getLastSnapshotOf(address director)
1242         internal
1243         view
1244         returns (BoardSnapshot memory)
1245     {
1246         return boardHistory[getLastSnapshotIndexOf(director)];
1247     }
1248 
1249     // =========== Director getters
1250 
1251     function rewardPerShare() public view returns (uint256) {
1252         return getLatestSnapshot().rewardPerShare;
1253     }
1254 
1255     function earned(address director) public view returns (uint256) {
1256         uint256 totalRewards = 0;
1257 
1258         for (uint i = directors[director].startEpoch; i <= directors[director].lastEpoch; i++) {
1259             totalRewards = totalRewards.add(calculateClaimableRewardsForEpoch(director, i));
1260         }
1261 
1262         return totalRewards;
1263     }
1264 
1265     /* ========== MUTATIVE FUNCTIONS ========== */
1266 
1267     function stake(uint256 amount)
1268         public
1269         override
1270         onlyOneBlock
1271         updateReward(msg.sender)
1272     {
1273         require(amount > 0, 'Boardroom: Cannot stake 0');
1274         uint256 previousBalance = balanceOf(msg.sender);
1275         super.stake(amount);
1276         depositCheckpoint(msg.sender, amount, previousBalance, getCheckpointEpoch());
1277 
1278         emit Staked(msg.sender, amount);
1279     }
1280 
1281     function withdraw(uint256 amount)
1282         public
1283         override
1284         onlyOneBlock
1285         directorExists
1286         updateReward(msg.sender)
1287     {
1288         require(amount > 0, 'Boardroom: Cannot withdraw 0');
1289         uint256 previousBalance = balanceOf(msg.sender);
1290         super.withdraw(amount);
1291         withdrawCheckpoint(msg.sender, amount, previousBalance, getCheckpointEpoch());
1292         emit Withdrawn(msg.sender, amount);
1293     }
1294 
1295     function exit() external {
1296         withdraw(balanceOf(msg.sender));
1297 
1298         claimReward(earned(msg.sender));
1299     }
1300 
1301     function claimReward(uint256 amount)
1302         public
1303         updateReward(msg.sender)
1304     {
1305         require(amount > 0, 'Amount cannot be zero');
1306         uint256 totalClaimAmount = amount;
1307         uint256 totalEarned = earned(msg.sender);
1308         require(amount <= totalEarned, 'Amount cannot be larger than total claimable rewards');
1309 
1310         cash.safeTransfer(msg.sender, amount);
1311 
1312         for (uint i = directors[msg.sender].startEpoch; amount > 0; i++) {
1313             uint256 claimable = calculateClaimableRewardsForEpoch(msg.sender, i);
1314 
1315             if (amount > claimable) {
1316                 directors[msg.sender].rewardEarned[i] = 0;
1317                 directors[msg.sender].startEpoch = i.add(1);
1318                 amount = amount.sub(claimable);
1319             } else {
1320                 removeRewardsForEpoch(msg.sender, amount, i);
1321                 amount = 0;
1322             }
1323         }
1324 
1325         // In this case, startEpoch will be calculated again for the next stake
1326         if (amount == totalEarned) {
1327             directors[msg.sender].startEpoch = 0;
1328         }
1329 
1330         emit RewardPaid(msg.sender, totalClaimAmount);
1331     }
1332 
1333     // Claim rewards for specific epoch
1334     function claimRewardsForEpoch(uint256 amount, uint256 epoch)
1335         public
1336         updateReward(msg.sender)
1337     {
1338         require(amount > 0, 'Amount cannot be zero');
1339 
1340         uint256 claimable = calculateClaimableRewardsForEpoch(msg.sender, epoch);
1341 
1342         if (claimable > 0) {
1343             require(
1344                 amount <= claimable,
1345                 'Amount cannot be larger than the claimable rewards for the epoch'
1346             );
1347 
1348             cash.safeTransfer(msg.sender, amount);
1349 
1350             removeRewardsForEpoch(msg.sender, amount, epoch);
1351         }
1352     }
1353 
1354     function allocateSeigniorage(uint256 amount)
1355         external
1356         onlyOneBlock
1357         onlyOperator
1358     {
1359         require(amount > 0, 'Boardroom: Cannot allocate 0');
1360         require(
1361             totalSupply() > 0,
1362             'Boardroom: Cannot allocate when totalSupply is 0'
1363         );
1364 
1365         // Create & add new snapshot
1366         BoardSnapshot memory latestSnapshot = getLatestSnapshot();
1367         uint256 prevRPS = latestSnapshot.rewardPerShare;
1368         uint256 poolSize = getEpochPoolSize(getCheckpointEpoch());
1369         uint256 nextRPS = prevRPS.add(amount.mul(1e18).div(poolSize));
1370 
1371         BoardSnapshot memory newSnapshot = BoardSnapshot({
1372             time: block.number,
1373             rewardReceived: amount,
1374             rewardPerShare: nextRPS
1375         });
1376         boardHistory.push(newSnapshot);
1377 
1378         cash.safeTransferFrom(msg.sender, address(this), amount);
1379         emit RewardAdded(msg.sender, amount);
1380     }
1381 
1382     /*
1383      * manualEpochInit can be used by anyone to initialize an epoch based on the previous one
1384      * This is only applicable if there was no action (deposit/withdraw) in the current epoch.
1385      * Any deposit and withdraw will automatically initialize the current and next epoch.
1386      */
1387     function manualCheckpointEpochInit(uint128 checkpointEpochId) public {
1388         manualEpochInit(checkpointEpochId, getCheckpointEpoch());
1389     }
1390 
1391     function allocateTaxes(uint256 amount)
1392         external
1393         onlyOneBlock
1394         onlyFeeDistributor
1395     {
1396         require(amount > 0, 'Boardroom: Cannot allocate 0');
1397         require(
1398             totalSupply() > 0,
1399             'Boardroom: Cannot allocate when totalSupply is 0'
1400         );
1401         // Create & add new snapshot
1402         BoardSnapshot memory latestSnapshot = getLatestSnapshot();
1403         uint256 prevRPS = latestSnapshot.rewardPerShare;
1404         uint256 poolSize = getEpochPoolSize(getCheckpointEpoch());
1405         uint256 nextRPS = prevRPS.add(amount.mul(1e18).div(poolSize));
1406 
1407         BoardSnapshot memory newSnapshot = BoardSnapshot({
1408             time: block.number,
1409             rewardReceived: amount,
1410             rewardPerShare: nextRPS
1411         });
1412         boardHistory.push(newSnapshot);
1413 
1414         cash.safeTransferFrom(msg.sender, address(this), amount);
1415         emit RewardAdded(msg.sender, amount);
1416 
1417     }
1418 
1419     function earnedNew(address director) private view returns (uint256) {
1420         uint256 latestRPS = getLatestSnapshot().rewardPerShare;
1421         uint256 storedRPS = getLastSnapshotOf(director).rewardPerShare;
1422         uint256 directorEffectiveBalance = getEpochUserBalance(director, getCheckpointEpoch());
1423 
1424         return
1425             directorEffectiveBalance.mul(latestRPS.sub(storedRPS)).div(1e18);
1426     }
1427 
1428     function removeRewardsForEpoch(address wallet, uint256 amount, uint256 epoch) private
1429         onlyOneBlock
1430     {
1431         uint256 claimable = calculateClaimableRewardsForEpoch(wallet, epoch);
1432 
1433         if (claimable > 0) {
1434             require(
1435                 amount <= claimable,
1436                 'Amount cannot be larger than the claimable rewards for the epoch'
1437             );
1438 
1439             directors[wallet].rewardEarned[epoch] =
1440                 claimable.sub(amount).mul(directors[wallet].rewardEarned[epoch]).div(claimable);
1441         }
1442     }
1443 
1444     /* ========== EVENTS ========== */
1445 
1446     event Staked(address indexed user, uint256 amount);
1447     event Withdrawn(address indexed user, uint256 amount);
1448     event RewardPaid(address indexed user, uint256 reward);
1449     event RewardAdded(address indexed user, uint256 reward);
1450 }