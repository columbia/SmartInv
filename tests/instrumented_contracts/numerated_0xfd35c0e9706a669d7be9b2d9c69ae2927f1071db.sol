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
83 
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
245 
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
389 
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
464 // File: contracts/lib/Safe112.sol
465 
466 pragma solidity ^0.6.0;
467 
468 library Safe112 {
469     function add(uint112 a, uint112 b) internal pure returns (uint256) {
470         uint256 c = a + b;
471         require(c >= a, 'Safe112: addition overflow');
472 
473         return c;
474     }
475 
476     function sub(uint112 a, uint112 b) internal pure returns (uint256) {
477         return sub(a, b, 'Safe112: subtraction overflow');
478     }
479 
480     function sub(
481         uint112 a,
482         uint112 b,
483         string memory errorMessage
484     ) internal pure returns (uint112) {
485         require(b <= a, errorMessage);
486         uint112 c = a - b;
487 
488         return c;
489     }
490 
491     function mul(uint112 a, uint112 b) internal pure returns (uint256) {
492         if (a == 0) {
493             return 0;
494         }
495 
496         uint256 c = a * b;
497         require(c / a == b, 'Safe112: multiplication overflow');
498 
499         return c;
500     }
501 
502     function div(uint112 a, uint112 b) internal pure returns (uint256) {
503         return div(a, b, 'Safe112: division by zero');
504     }
505 
506     function div(
507         uint112 a,
508         uint112 b,
509         string memory errorMessage
510     ) internal pure returns (uint112) {
511         // Solidity only automatically asserts when dividing by 0
512         require(b > 0, errorMessage);
513         uint112 c = a / b;
514 
515         return c;
516     }
517 
518     function mod(uint112 a, uint112 b) internal pure returns (uint256) {
519         return mod(a, b, 'Safe112: modulo by zero');
520     }
521 
522     function mod(
523         uint112 a,
524         uint112 b,
525         string memory errorMessage
526     ) internal pure returns (uint112) {
527         require(b != 0, errorMessage);
528         return a % b;
529     }
530 }
531 
532 // File: @openzeppelin/contracts/GSN/Context.sol
533 
534 
535 
536 pragma solidity ^0.6.0;
537 
538 /*
539  * @dev Provides information about the current execution context, including the
540  * sender of the transaction and its data. While these are generally available
541  * via msg.sender and msg.data, they should not be accessed in such a direct
542  * manner, since when dealing with GSN meta-transactions the account sending and
543  * paying for execution may not be the actual sender (as far as an application
544  * is concerned).
545  *
546  * This contract is only required for intermediate, library-like contracts.
547  */
548 abstract contract Context {
549     function _msgSender() internal view virtual returns (address payable) {
550         return msg.sender;
551     }
552 
553     function _msgData() internal view virtual returns (bytes memory) {
554         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
555         return msg.data;
556     }
557 }
558 
559 // File: @openzeppelin/contracts/access/Ownable.sol
560 
561 
562 
563 pragma solidity ^0.6.0;
564 
565 /**
566  * @dev Contract module which provides a basic access control mechanism, where
567  * there is an account (an owner) that can be granted exclusive access to
568  * specific functions.
569  *
570  * By default, the owner account will be the one that deploys the contract. This
571  * can later be changed with {transferOwnership}.
572  *
573  * This module is used through inheritance. It will make available the modifier
574  * `onlyOwner`, which can be applied to your functions to restrict their use to
575  * the owner.
576  */
577 contract Ownable is Context {
578     address private _owner;
579 
580     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
581 
582     /**
583      * @dev Initializes the contract setting the deployer as the initial owner.
584      */
585     constructor () internal {
586         address msgSender = _msgSender();
587         _owner = msgSender;
588         emit OwnershipTransferred(address(0), msgSender);
589     }
590 
591     /**
592      * @dev Returns the address of the current owner.
593      */
594     function owner() public view returns (address) {
595         return _owner;
596     }
597 
598     /**
599      * @dev Throws if called by any account other than the owner.
600      */
601     modifier onlyOwner() {
602         require(_owner == _msgSender(), "Ownable: caller is not the owner");
603         _;
604     }
605 
606     /**
607      * @dev Leaves the contract without owner. It will not be possible to call
608      * `onlyOwner` functions anymore. Can only be called by the current owner.
609      *
610      * NOTE: Renouncing ownership will leave the contract without an owner,
611      * thereby removing any functionality that is only available to the owner.
612      */
613     function renounceOwnership() public virtual onlyOwner {
614         emit OwnershipTransferred(_owner, address(0));
615         _owner = address(0);
616     }
617 
618     /**
619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
620      * Can only be called by the current owner.
621      */
622     function transferOwnership(address newOwner) public virtual onlyOwner {
623         require(newOwner != address(0), "Ownable: new owner is the zero address");
624         emit OwnershipTransferred(_owner, newOwner);
625         _owner = newOwner;
626     }
627 }
628 
629 // File: contracts/owner/Operator.sol
630 
631 pragma solidity ^0.6.0;
632 
633 
634 
635 contract Operator is Context, Ownable {
636     address private _operator;
637 
638     event OperatorTransferred(
639         address indexed previousOperator,
640         address indexed newOperator
641     );
642 
643     constructor() internal {
644         _operator = _msgSender();
645         emit OperatorTransferred(address(0), _operator);
646     }
647 
648     function operator() public view returns (address) {
649         return _operator;
650     }
651 
652     modifier onlyOperator() {
653         require(
654             _operator == msg.sender,
655             'operator: caller is not the operator'
656         );
657         _;
658     }
659 
660     function isOperator() public view returns (bool) {
661         return _msgSender() == _operator;
662     }
663 
664     function transferOperator(address newOperator_) public onlyOwner {
665         _transferOperator(newOperator_);
666     }
667 
668     function _transferOperator(address newOperator_) internal {
669         require(
670             newOperator_ != address(0),
671             'operator: zero address given for new operator'
672         );
673         emit OperatorTransferred(address(0), newOperator_);
674         _operator = newOperator_;
675     }
676 }
677 
678 // File: contracts/utils/ContractGuard.sol
679 
680 pragma solidity ^0.6.12;
681 
682 contract ContractGuard {
683     mapping(uint256 => mapping(address => bool)) private _status;
684 
685     function checkSameOriginReentranted() internal view returns (bool) {
686         return _status[block.number][tx.origin];
687     }
688 
689     function checkSameSenderReentranted() internal view returns (bool) {
690         return _status[block.number][msg.sender];
691     }
692 
693     modifier onlyOneBlock() {
694         require(
695             !checkSameOriginReentranted(),
696             'ContractGuard: one block, one function'
697         );
698         require(
699             !checkSameSenderReentranted(),
700             'ContractGuard: one block, one function'
701         );
702 
703         _;
704 
705         _status[block.number][tx.origin] = true;
706         _status[block.number][msg.sender] = true;
707     }
708 }
709 
710 // File: contracts/interfaces/IBasisAsset.sol
711 
712 pragma solidity ^0.6.0;
713 
714 interface IBasisAsset {
715     function mint(address recipient, uint256 amount) external returns (bool);
716 
717     function burn(uint256 amount) external;
718 
719     function burnFrom(address from, uint256 amount) external;
720 
721     function isOperator() external returns (bool);
722 
723     function operator() external view returns (address);
724 }
725 
726 // File: contracts/Boardroom.sol
727 
728 pragma solidity ^0.6.0;
729 //pragma experimental ABIEncoderV2;
730 
731 
732 
733 
734 
735 
736 
737 contract ShareWrapper {
738     using SafeMath for uint256;
739     using SafeERC20 for IERC20;
740 
741     IERC20 public share;
742 
743     uint256 private _totalSupply;
744     mapping(address => uint256) private _balances;
745 
746     function totalSupply() public view returns (uint256) {
747         return _totalSupply;
748     }
749 
750     function balanceOf(address account) public view returns (uint256) {
751         return _balances[account];
752     }
753 
754     function stake(uint256 amount) public virtual {
755         _totalSupply = _totalSupply.add(amount);
756         _balances[msg.sender] = _balances[msg.sender].add(amount);
757         share.safeTransferFrom(msg.sender, address(this), amount);
758     }
759 
760     function withdraw(uint256 amount) public virtual {
761         uint256 directorShare = _balances[msg.sender];
762         require(
763             directorShare >= amount,
764             'Boardroom: withdraw request greater than staked amount'
765         );
766         _totalSupply = _totalSupply.sub(amount);
767         _balances[msg.sender] = directorShare.sub(amount);
768         share.safeTransfer(msg.sender, amount);
769     }
770 }
771 
772 contract Boardroom is ShareWrapper, ContractGuard, Operator {
773     using SafeERC20 for IERC20;
774     using Address for address;
775     using SafeMath for uint256;
776     using Safe112 for uint112;
777 
778     /* ========== DATA STRUCTURES ========== */
779 
780     struct Boardseat {
781         uint256 lastSnapshotIndex;
782         uint256 rewardEarned;
783     }
784 
785     struct BoardSnapshot {
786         uint256 time;
787         uint256 rewardReceived;
788         uint256 rewardPerShare;
789     }
790 
791     /* ========== STATE VARIABLES ========== */
792 
793     IERC20 private cash;
794 
795     mapping(address => Boardseat) private directors;
796     BoardSnapshot[] private boardHistory;
797 
798     /* ========== CONSTRUCTOR ========== */
799 
800     constructor(IERC20 _cash, IERC20 _share) public {
801         cash = _cash;
802         share = _share;
803 
804         BoardSnapshot memory genesisSnapshot = BoardSnapshot({
805             time: block.number,
806             rewardReceived: 0,
807             rewardPerShare: 0
808         });
809         boardHistory.push(genesisSnapshot);
810     }
811 
812     /* ========== Modifiers =============== */
813     modifier directorExists {
814         require(
815             balanceOf(msg.sender) > 0,
816             'Boardroom: The director does not exist'
817         );
818         _;
819     }
820 
821     modifier updateReward(address director) {
822         if (director != address(0)) {
823             Boardseat memory seat = directors[director];
824             seat.rewardEarned = earned(director);
825             seat.lastSnapshotIndex = latestSnapshotIndex();
826             directors[director] = seat;
827         }
828         _;
829     }
830 
831     /* ========== VIEW FUNCTIONS ========== */
832 
833     // =========== Snapshot getters
834 
835     function latestSnapshotIndex() public view returns (uint256) {
836         return boardHistory.length.sub(1);
837     }
838 
839     function getLatestSnapshot() internal view returns (BoardSnapshot memory) {
840         return boardHistory[latestSnapshotIndex()];
841     }
842 
843     function getLastSnapshotIndexOf(address director)
844         public
845         view
846         returns (uint256)
847     {
848         return directors[director].lastSnapshotIndex;
849     }
850 
851     function getLastSnapshotOf(address director)
852         internal
853         view
854         returns (BoardSnapshot memory)
855     {
856         return boardHistory[getLastSnapshotIndexOf(director)];
857     }
858 
859     // =========== Director getters
860 
861     function rewardPerShare() public view returns (uint256) {
862         return getLatestSnapshot().rewardPerShare;
863     }
864 
865     function earned(address director) public view returns (uint256) {
866         uint256 latestRPS = getLatestSnapshot().rewardPerShare;
867         uint256 storedRPS = getLastSnapshotOf(director).rewardPerShare;
868 
869         return
870             balanceOf(director).mul(latestRPS.sub(storedRPS)).div(1e18).add(
871                 directors[director].rewardEarned
872             );
873     }
874 
875     /* ========== MUTATIVE FUNCTIONS ========== */
876 
877     function stake(uint256 amount)
878         public
879         override
880         onlyOneBlock
881         updateReward(msg.sender)
882     {
883         require(amount > 0, 'Boardroom: Cannot stake 0');
884         super.stake(amount);
885         emit Staked(msg.sender, amount);
886     }
887 
888     function withdraw(uint256 amount)
889         public
890         override
891         onlyOneBlock
892         directorExists
893         updateReward(msg.sender)
894     {
895         require(amount > 0, 'Boardroom: Cannot withdraw 0');
896         super.withdraw(amount);
897         emit Withdrawn(msg.sender, amount);
898     }
899 
900     function exit() external {
901         withdraw(balanceOf(msg.sender));
902         claimReward();
903     }
904 
905     function claimReward() public updateReward(msg.sender) {
906         uint256 reward = directors[msg.sender].rewardEarned;
907         if (reward > 0) {
908             directors[msg.sender].rewardEarned = 0;
909             cash.safeTransfer(msg.sender, reward);
910             emit RewardPaid(msg.sender, reward);
911         }
912     }
913 
914     function allocateSeigniorage(uint256 amount)
915         external
916         onlyOneBlock
917         onlyOperator
918     {
919         require(amount > 0, 'Boardroom: Cannot allocate 0');
920         require(
921             totalSupply() > 0,
922             'Boardroom: Cannot allocate when totalSupply is 0'
923         );
924 
925         // Create & add new snapshot
926         uint256 prevRPS = getLatestSnapshot().rewardPerShare;
927         uint256 nextRPS = prevRPS.add(amount.mul(1e18).div(totalSupply()));
928 
929         BoardSnapshot memory newSnapshot = BoardSnapshot({
930             time: block.number,
931             rewardReceived: amount,
932             rewardPerShare: nextRPS
933         });
934         boardHistory.push(newSnapshot);
935 
936         cash.safeTransferFrom(msg.sender, address(this), amount);
937         emit RewardAdded(msg.sender, amount);
938     }
939 
940     /* ========== EVENTS ========== */
941 
942     event Staked(address indexed user, uint256 amount);
943     event Withdrawn(address indexed user, uint256 amount);
944     event RewardPaid(address indexed user, uint256 reward);
945     event RewardAdded(address indexed user, uint256 reward);
946 }