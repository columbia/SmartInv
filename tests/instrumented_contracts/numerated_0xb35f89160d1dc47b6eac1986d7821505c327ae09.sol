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
83 pragma solidity ^0.6.0;
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 pragma solidity ^0.6.2;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // This method relies in extcodesize, which returns 0 for contracts in
268         // construction, since the code is only stored at the end of the
269         // constructor execution.
270 
271         uint256 size;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { size := extcodesize(account) }
274         return size > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
384 
385 pragma solidity ^0.6.0;
386 
387 
388 
389 
390 /**
391  * @title SafeERC20
392  * @dev Wrappers around ERC20 operations that throw on failure (when the token
393  * contract returns false). Tokens that return no value (and instead revert or
394  * throw on failure) are also supported, non-reverting calls are assumed to be
395  * successful.
396  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
397  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
398  */
399 library SafeERC20 {
400     using SafeMath for uint256;
401     using Address for address;
402 
403     function safeTransfer(IERC20 token, address to, uint256 value) internal {
404         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
405     }
406 
407     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
408         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
409     }
410 
411     /**
412      * @dev Deprecated. This function has issues similar to the ones found in
413      * {IERC20-approve}, and its usage is discouraged.
414      *
415      * Whenever possible, use {safeIncreaseAllowance} and
416      * {safeDecreaseAllowance} instead.
417      */
418     function safeApprove(IERC20 token, address spender, uint256 value) internal {
419         // safeApprove should only be called when setting an initial allowance,
420         // or when resetting it to zero. To increase and decrease it, use
421         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
422         // solhint-disable-next-line max-line-length
423         require((value == 0) || (token.allowance(address(this), spender) == 0),
424             "SafeERC20: approve from non-zero to non-zero allowance"
425         );
426         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
427     }
428 
429     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
430         uint256 newAllowance = token.allowance(address(this), spender).add(value);
431         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
432     }
433 
434     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     /**
440      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
441      * on the return value: the return value is optional (but if data is returned, it must not be false).
442      * @param token The token targeted by the call.
443      * @param data The call data (encoded using abi.encode or one of its variants).
444      */
445     function _callOptionalReturn(IERC20 token, bytes memory data) private {
446         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
447         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
448         // the target address contains contract code and also asserts for success in the low-level call.
449 
450         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
451         if (returndata.length > 0) { // Return data is optional
452             // solhint-disable-next-line max-line-length
453             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
454         }
455     }
456 }
457 
458 // File: contracts/lib/Safe112.sol
459 
460 pragma solidity ^0.6.0;
461 
462 library Safe112 {
463     function add(uint112 a, uint112 b) internal pure returns (uint256) {
464         uint256 c = a + b;
465         require(c >= a, 'Safe112: addition overflow');
466 
467         return c;
468     }
469 
470     function sub(uint112 a, uint112 b) internal pure returns (uint256) {
471         return sub(a, b, 'Safe112: subtraction overflow');
472     }
473 
474     function sub(
475         uint112 a,
476         uint112 b,
477         string memory errorMessage
478     ) internal pure returns (uint112) {
479         require(b <= a, errorMessage);
480         uint112 c = a - b;
481 
482         return c;
483     }
484 
485     function mul(uint112 a, uint112 b) internal pure returns (uint256) {
486         if (a == 0) {
487             return 0;
488         }
489 
490         uint256 c = a * b;
491         require(c / a == b, 'Safe112: multiplication overflow');
492 
493         return c;
494     }
495 
496     function div(uint112 a, uint112 b) internal pure returns (uint256) {
497         return div(a, b, 'Safe112: division by zero');
498     }
499 
500     function div(
501         uint112 a,
502         uint112 b,
503         string memory errorMessage
504     ) internal pure returns (uint112) {
505         // Solidity only automatically asserts when dividing by 0
506         require(b > 0, errorMessage);
507         uint112 c = a / b;
508 
509         return c;
510     }
511 
512     function mod(uint112 a, uint112 b) internal pure returns (uint256) {
513         return mod(a, b, 'Safe112: modulo by zero');
514     }
515 
516     function mod(
517         uint112 a,
518         uint112 b,
519         string memory errorMessage
520     ) internal pure returns (uint112) {
521         require(b != 0, errorMessage);
522         return a % b;
523     }
524 }
525 
526 // File: @openzeppelin/contracts/GSN/Context.sol
527 
528 pragma solidity ^0.6.0;
529 
530 /*
531  * @dev Provides information about the current execution context, including the
532  * sender of the transaction and its data. While these are generally available
533  * via msg.sender and msg.data, they should not be accessed in such a direct
534  * manner, since when dealing with GSN meta-transactions the account sending and
535  * paying for execution may not be the actual sender (as far as an application
536  * is concerned).
537  *
538  * This contract is only required for intermediate, library-like contracts.
539  */
540 abstract contract Context {
541     function _msgSender() internal view virtual returns (address payable) {
542         return msg.sender;
543     }
544 
545     function _msgData() internal view virtual returns (bytes memory) {
546         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
547         return msg.data;
548     }
549 }
550 
551 // File: @openzeppelin/contracts/access/Ownable.sol
552 
553 pragma solidity ^0.6.0;
554 
555 /**
556  * @dev Contract module which provides a basic access control mechanism, where
557  * there is an account (an owner) that can be granted exclusive access to
558  * specific functions.
559  *
560  * By default, the owner account will be the one that deploys the contract. This
561  * can later be changed with {transferOwnership}.
562  *
563  * This module is used through inheritance. It will make available the modifier
564  * `onlyOwner`, which can be applied to your functions to restrict their use to
565  * the owner.
566  */
567 contract Ownable is Context {
568     address private _owner;
569 
570     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
571 
572     /**
573      * @dev Initializes the contract setting the deployer as the initial owner.
574      */
575     constructor () internal {
576         address msgSender = _msgSender();
577         _owner = msgSender;
578         emit OwnershipTransferred(address(0), msgSender);
579     }
580 
581     /**
582      * @dev Returns the address of the current owner.
583      */
584     function owner() public view returns (address) {
585         return _owner;
586     }
587 
588     /**
589      * @dev Throws if called by any account other than the owner.
590      */
591     modifier onlyOwner() {
592         require(_owner == _msgSender(), "Ownable: caller is not the owner");
593         _;
594     }
595 
596     /**
597      * @dev Leaves the contract without owner. It will not be possible to call
598      * `onlyOwner` functions anymore. Can only be called by the current owner.
599      *
600      * NOTE: Renouncing ownership will leave the contract without an owner,
601      * thereby removing any functionality that is only available to the owner.
602      */
603     function renounceOwnership() public virtual onlyOwner {
604         emit OwnershipTransferred(_owner, address(0));
605         _owner = address(0);
606     }
607 
608     /**
609      * @dev Transfers ownership of the contract to a new account (`newOwner`).
610      * Can only be called by the current owner.
611      */
612     function transferOwnership(address newOwner) public virtual onlyOwner {
613         require(newOwner != address(0), "Ownable: new owner is the zero address");
614         emit OwnershipTransferred(_owner, newOwner);
615         _owner = newOwner;
616     }
617 }
618 
619 // File: contracts/owner/Operator.sol
620 
621 pragma solidity ^0.6.0;
622 
623 
624 
625 contract Operator is Context, Ownable {
626     address private _operator;
627 
628     event OperatorTransferred(
629         address indexed previousOperator,
630         address indexed newOperator
631     );
632 
633     constructor() internal {
634         _operator = _msgSender();
635         emit OperatorTransferred(address(0), _operator);
636     }
637 
638     function operator() public view returns (address) {
639         return _operator;
640     }
641 
642     modifier onlyOperator() {
643         require(
644             _operator == msg.sender,
645             'operator: caller is not the operator'
646         );
647         _;
648     }
649 
650     function isOperator() public view returns (bool) {
651         return _msgSender() == _operator;
652     }
653 
654     function transferOperator(address newOperator_) public onlyOwner {
655         _transferOperator(newOperator_);
656     }
657 
658     function _transferOperator(address newOperator_) internal {
659         require(
660             newOperator_ != address(0),
661             'operator: zero address given for new operator'
662         );
663         emit OperatorTransferred(address(0), newOperator_);
664         _operator = newOperator_;
665     }
666 }
667 
668 // File: contracts/utils/ContractGuard.sol
669 
670 pragma solidity ^0.6.12;
671 
672 contract ContractGuard {
673     mapping(uint256 => mapping(address => bool)) private _status;
674 
675     function checkSameOriginReentranted() internal view returns (bool) {
676         return _status[block.number][tx.origin];
677     }
678 
679     function checkSameSenderReentranted() internal view returns (bool) {
680         return _status[block.number][msg.sender];
681     }
682 
683     modifier onlyOneBlock() {
684         require(
685             !checkSameOriginReentranted(),
686             'ContractGuard: one block, one function'
687         );
688         require(
689             !checkSameSenderReentranted(),
690             'ContractGuard: one block, one function'
691         );
692 
693         _;
694 
695         _status[block.number][tx.origin] = true;
696         _status[block.number][msg.sender] = true;
697     }
698 }
699 
700 // File: contracts/interfaces/IBasisAsset.sol
701 
702 pragma solidity ^0.6.0;
703 
704 interface IBasisAsset {
705     function mint(address recipient, uint256 amount) external returns (bool);
706 
707     function burn(uint256 amount) external;
708 
709     function burnFrom(address from, uint256 amount) external;
710 
711     function isOperator() external returns (bool);
712 
713     function operator() external view returns (address);
714 }
715 
716 // File: contracts/Boardroom.sol
717 
718 pragma solidity ^0.6.0;
719 //pragma experimental ABIEncoderV2;
720 
721 
722 
723 
724 
725 
726 
727 contract ShareWrapper {
728     using SafeMath for uint256;
729     using SafeERC20 for IERC20;
730 
731     IERC20 public share;
732 
733     uint256 private _totalSupply;
734     mapping(address => uint256) private _balances;
735 
736     function totalSupply() public view returns (uint256) {
737         return _totalSupply;
738     }
739 
740     function balanceOf(address account) public view returns (uint256) {
741         return _balances[account];
742     }
743 
744     function stake(uint256 amount) public virtual {
745         _totalSupply = _totalSupply.add(amount);
746         _balances[msg.sender] = _balances[msg.sender].add(amount);
747         share.safeTransferFrom(msg.sender, address(this), amount);
748     }
749 
750     function withdraw(uint256 amount) public virtual {
751         uint256 directorShare = _balances[msg.sender];
752         require(
753             directorShare >= amount,
754             'Boardroom: withdraw request greater than staked amount'
755         );
756         _totalSupply = _totalSupply.sub(amount);
757         _balances[msg.sender] = directorShare.sub(amount);
758         share.safeTransfer(msg.sender, amount);
759     }
760 }
761 
762 contract Boardroom is ShareWrapper, ContractGuard, Operator {
763     using SafeERC20 for IERC20;
764     using Address for address;
765     using SafeMath for uint256;
766     using Safe112 for uint112;
767 
768     /* ========== DATA STRUCTURES ========== */
769 
770     struct Boardseat {
771         uint256 lastSnapshotIndex;
772         uint256 rewardEarned;
773     }
774 
775     struct BoardSnapshot {
776         uint256 time;
777         uint256 rewardReceived;
778         uint256 rewardPerShare;
779     }
780 
781     /* ========== STATE VARIABLES ========== */
782 
783     IERC20 private cash;
784 
785     mapping(address => Boardseat) private directors;
786     BoardSnapshot[] private boardHistory;
787 
788     /* ========== CONSTRUCTOR ========== */
789 
790     constructor(IERC20 _cash, IERC20 _share) public {
791         cash = _cash;
792         share = _share;
793 
794         BoardSnapshot memory genesisSnapshot = BoardSnapshot({
795             time: block.number,
796             rewardReceived: 0,
797             rewardPerShare: 0
798         });
799         boardHistory.push(genesisSnapshot);
800     }
801 
802     /* ========== Modifiers =============== */
803     modifier directorExists {
804         require(
805             balanceOf(msg.sender) > 0,
806             'Boardroom: The director does not exist'
807         );
808         _;
809     }
810 
811     modifier updateReward(address director) {
812         if (director != address(0)) {
813             Boardseat memory seat = directors[director];
814             seat.rewardEarned = earned(director);
815             seat.lastSnapshotIndex = latestSnapshotIndex();
816             directors[director] = seat;
817         }
818         _;
819     }
820 
821     /* ========== VIEW FUNCTIONS ========== */
822 
823     // =========== Snapshot getters
824 
825     function latestSnapshotIndex() public view returns (uint256) {
826         return boardHistory.length.sub(1);
827     }
828 
829     function getLatestSnapshot() internal view returns (BoardSnapshot memory) {
830         return boardHistory[latestSnapshotIndex()];
831     }
832 
833     function getLastSnapshotIndexOf(address director)
834         public
835         view
836         returns (uint256)
837     {
838         return directors[director].lastSnapshotIndex;
839     }
840 
841     function getLastSnapshotOf(address director)
842         internal
843         view
844         returns (BoardSnapshot memory)
845     {
846         return boardHistory[getLastSnapshotIndexOf(director)];
847     }
848 
849     // =========== Director getters
850 
851     function rewardPerShare() public view returns (uint256) {
852         return getLatestSnapshot().rewardPerShare;
853     }
854 
855     function earned(address director) public view returns (uint256) {
856         uint256 latestRPS = getLatestSnapshot().rewardPerShare;
857         uint256 storedRPS = getLastSnapshotOf(director).rewardPerShare;
858 
859         return
860             balanceOf(director).mul(latestRPS.sub(storedRPS)).div(1e18).add(
861                 directors[director].rewardEarned
862             );
863     }
864 
865     /* ========== MUTATIVE FUNCTIONS ========== */
866 
867     function stake(uint256 amount)
868         public
869         override
870         onlyOneBlock
871         updateReward(msg.sender)
872     {
873         require(amount > 0, 'Boardroom: Cannot stake 0');
874         super.stake(amount);
875         emit Staked(msg.sender, amount);
876     }
877 
878     function withdraw(uint256 amount)
879         public
880         override
881         onlyOneBlock
882         directorExists
883         updateReward(msg.sender)
884     {
885         require(amount > 0, 'Boardroom: Cannot withdraw 0');
886         super.withdraw(amount);
887         emit Withdrawn(msg.sender, amount);
888     }
889 
890     function exit() external {
891         withdraw(balanceOf(msg.sender));
892         claimReward();
893     }
894 
895     function claimReward() public updateReward(msg.sender) {
896         uint256 reward = directors[msg.sender].rewardEarned;
897         if (reward > 0) {
898             directors[msg.sender].rewardEarned = 0;
899             cash.safeTransfer(msg.sender, reward);
900             emit RewardPaid(msg.sender, reward);
901         }
902     }
903 
904     function allocateSeigniorage(uint256 amount)
905         external
906         onlyOneBlock
907         onlyOperator
908     {
909         require(amount > 0, 'Boardroom: Cannot allocate 0');
910         require(
911             totalSupply() > 0,
912             'Boardroom: Cannot allocate when totalSupply is 0'
913         );
914 
915         // Create & add new snapshot
916         uint256 prevRPS = getLatestSnapshot().rewardPerShare;
917         uint256 nextRPS = prevRPS.add(amount.mul(1e18).div(totalSupply()));
918 
919         BoardSnapshot memory newSnapshot = BoardSnapshot({
920             time: block.number,
921             rewardReceived: amount,
922             rewardPerShare: nextRPS
923         });
924         boardHistory.push(newSnapshot);
925 
926         cash.safeTransferFrom(msg.sender, address(this), amount);
927         emit RewardAdded(msg.sender, amount);
928     }
929 
930     /* ========== EVENTS ========== */
931 
932     event Staked(address indexed user, uint256 amount);
933     event Withdrawn(address indexed user, uint256 amount);
934     event RewardPaid(address indexed user, uint256 reward);
935     event RewardAdded(address indexed user, uint256 reward);
936 }