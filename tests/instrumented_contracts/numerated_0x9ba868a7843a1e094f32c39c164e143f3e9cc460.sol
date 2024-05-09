1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 pragma solidity ^0.6.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 
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
243 
244 pragma solidity ^0.6.2;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // This method relies in extcodesize, which returns 0 for contracts in
269         // construction, since the code is only stored at the end of the
270         // constructor execution.
271 
272         uint256 size;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { size := extcodesize(account) }
275         return size > 0;
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return _functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         return _functionCallWithValue(target, data, value, errorMessage);
358     }
359 
360     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 // solhint-disable-next-line no-inline-assembly
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
385 
386 
387 pragma solidity ^0.6.0;
388 
389 
390 
391 
392 /**
393  * @title SafeERC20
394  * @dev Wrappers around ERC20 operations that throw on failure (when the token
395  * contract returns false). Tokens that return no value (and instead revert or
396  * throw on failure) are also supported, non-reverting calls are assumed to be
397  * successful.
398  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
399  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
400  */
401 library SafeERC20 {
402     using SafeMath for uint256;
403     using Address for address;
404 
405     function safeTransfer(IERC20 token, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
407     }
408 
409     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
411     }
412 
413     /**
414      * @dev Deprecated. This function has issues similar to the ones found in
415      * {IERC20-approve}, and its usage is discouraged.
416      *
417      * Whenever possible, use {safeIncreaseAllowance} and
418      * {safeDecreaseAllowance} instead.
419      */
420     function safeApprove(IERC20 token, address spender, uint256 value) internal {
421         // safeApprove should only be called when setting an initial allowance,
422         // or when resetting it to zero. To increase and decrease it, use
423         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
424         // solhint-disable-next-line max-line-length
425         require((value == 0) || (token.allowance(address(this), spender) == 0),
426             "SafeERC20: approve from non-zero to non-zero allowance"
427         );
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
429     }
430 
431     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
432         uint256 newAllowance = token.allowance(address(this), spender).add(value);
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
434     }
435 
436     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
437         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
439     }
440 
441     /**
442      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
443      * on the return value: the return value is optional (but if data is returned, it must not be false).
444      * @param token The token targeted by the call.
445      * @param data The call data (encoded using abi.encode or one of its variants).
446      */
447     function _callOptionalReturn(IERC20 token, bytes memory data) private {
448         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
449         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
450         // the target address contains contract code and also asserts for success in the low-level call.
451 
452         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
453         if (returndata.length > 0) { // Return data is optional
454             // solhint-disable-next-line max-line-length
455             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
456         }
457     }
458 }
459 
460 // File: contracts/lib/Safe112.sol
461 
462 pragma solidity ^0.6.0;
463 
464 library Safe112 {
465     function add(uint112 a, uint112 b) internal pure returns (uint256) {
466         uint256 c = a + b;
467         require(c >= a, 'Safe112: addition overflow');
468 
469         return c;
470     }
471 
472     function sub(uint112 a, uint112 b) internal pure returns (uint256) {
473         return sub(a, b, 'Safe112: subtraction overflow');
474     }
475 
476     function sub(
477         uint112 a,
478         uint112 b,
479         string memory errorMessage
480     ) internal pure returns (uint112) {
481         require(b <= a, errorMessage);
482         uint112 c = a - b;
483 
484         return c;
485     }
486 
487     function mul(uint112 a, uint112 b) internal pure returns (uint256) {
488         if (a == 0) {
489             return 0;
490         }
491 
492         uint256 c = a * b;
493         require(c / a == b, 'Safe112: multiplication overflow');
494 
495         return c;
496     }
497 
498     function div(uint112 a, uint112 b) internal pure returns (uint256) {
499         return div(a, b, 'Safe112: division by zero');
500     }
501 
502     function div(
503         uint112 a,
504         uint112 b,
505         string memory errorMessage
506     ) internal pure returns (uint112) {
507         // Solidity only automatically asserts when dividing by 0
508         require(b > 0, errorMessage);
509         uint112 c = a / b;
510 
511         return c;
512     }
513 
514     function mod(uint112 a, uint112 b) internal pure returns (uint256) {
515         return mod(a, b, 'Safe112: modulo by zero');
516     }
517 
518     function mod(
519         uint112 a,
520         uint112 b,
521         string memory errorMessage
522     ) internal pure returns (uint112) {
523         require(b != 0, errorMessage);
524         return a % b;
525     }
526 }
527 
528 // File: @openzeppelin/contracts/GSN/Context.sol
529 
530 
531 pragma solidity ^0.6.0;
532 
533 /*
534  * @dev Provides information about the current execution context, including the
535  * sender of the transaction and its data. While these are generally available
536  * via msg.sender and msg.data, they should not be accessed in such a direct
537  * manner, since when dealing with GSN meta-transactions the account sending and
538  * paying for execution may not be the actual sender (as far as an application
539  * is concerned).
540  *
541  * This contract is only required for intermediate, library-like contracts.
542  */
543 abstract contract Context {
544     function _msgSender() internal view virtual returns (address payable) {
545         return msg.sender;
546     }
547 
548     function _msgData() internal view virtual returns (bytes memory) {
549         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
550         return msg.data;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/access/Ownable.sol
555 
556 pragma solidity ^0.6.0;
557 
558 /**
559  * @dev Contract module which provides a basic access control mechanism, where
560  * there is an account (an owner) that can be granted exclusive access to
561  * specific functions.
562  *
563  * By default, the owner account will be the one that deploys the contract. This
564  * can later be changed with {transferOwnership}.
565  *
566  * This module is used through inheritance. It will make available the modifier
567  * `onlyOwner`, which can be applied to your functions to restrict their use to
568  * the owner.
569  */
570 contract Ownable is Context {
571     address private _owner;
572 
573     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
574 
575     /**
576      * @dev Initializes the contract setting the deployer as the initial owner.
577      */
578     constructor () internal {
579         address msgSender = _msgSender();
580         _owner = msgSender;
581         emit OwnershipTransferred(address(0), msgSender);
582     }
583 
584     /**
585      * @dev Returns the address of the current owner.
586      */
587     function owner() public view returns (address) {
588         return _owner;
589     }
590 
591     /**
592      * @dev Throws if called by any account other than the owner.
593      */
594     modifier onlyOwner() {
595         require(_owner == _msgSender(), "Ownable: caller is not the owner");
596         _;
597     }
598 
599     /**
600      * @dev Leaves the contract without owner. It will not be possible to call
601      * `onlyOwner` functions anymore. Can only be called by the current owner.
602      *
603      * NOTE: Renouncing ownership will leave the contract without an owner,
604      * thereby removing any functionality that is only available to the owner.
605      */
606     function renounceOwnership() public virtual onlyOwner {
607         emit OwnershipTransferred(_owner, address(0));
608         _owner = address(0);
609     }
610 
611     /**
612      * @dev Transfers ownership of the contract to a new account (`newOwner`).
613      * Can only be called by the current owner.
614      */
615     function transferOwnership(address newOwner) public virtual onlyOwner {
616         require(newOwner != address(0), "Ownable: new owner is the zero address");
617         emit OwnershipTransferred(_owner, newOwner);
618         _owner = newOwner;
619     }
620 }
621 
622 // File: contracts/owner/Operator.sol
623 
624 pragma solidity ^0.6.0;
625 
626 
627 
628 contract Operator is Context, Ownable {
629     address private _operator;
630 
631     event OperatorTransferred(
632         address indexed previousOperator,
633         address indexed newOperator
634     );
635 
636     constructor() internal {
637         _operator = _msgSender();
638         emit OperatorTransferred(address(0), _operator);
639     }
640 
641     function operator() public view returns (address) {
642         return _operator;
643     }
644 
645     modifier onlyOperator() {
646         require(
647             _operator == msg.sender,
648             'operator: caller is not the operator'
649         );
650         _;
651     }
652 
653     function isOperator() public view returns (bool) {
654         return _msgSender() == _operator;
655     }
656 
657     function transferOperator(address newOperator_) public onlyOwner {
658         _transferOperator(newOperator_);
659     }
660 
661     function _transferOperator(address newOperator_) internal {
662         require(
663             newOperator_ != address(0),
664             'operator: zero address given for new operator'
665         );
666         emit OperatorTransferred(address(0), newOperator_);
667         _operator = newOperator_;
668     }
669 }
670 
671 // File: contracts/utils/ContractGuard.sol
672 
673 pragma solidity ^0.6.12;
674 
675 contract ContractGuard {
676     mapping(uint256 => mapping(address => bool)) private _status;
677 
678     function checkSameOriginReentranted() internal view returns (bool) {
679         return _status[block.number][tx.origin];
680     }
681 
682     function checkSameSenderReentranted() internal view returns (bool) {
683         return _status[block.number][msg.sender];
684     }
685 
686     modifier onlyOneBlock() {
687         require(
688             !checkSameOriginReentranted(),
689             'ContractGuard: one block, one function'
690         );
691         require(
692             !checkSameSenderReentranted(),
693             'ContractGuard: one block, one function'
694         );
695 
696         _;
697 
698         _status[block.number][tx.origin] = true;
699         _status[block.number][msg.sender] = true;
700     }
701 }
702 
703 // File: contracts/interfaces/IBasisAsset.sol
704 
705 pragma solidity ^0.6.0;
706 
707 interface IBasisAsset {
708     function mint(address recipient, uint256 amount) external returns (bool);
709 
710     function burn(uint256 amount) external;
711 
712     function burnFrom(address from, uint256 amount) external;
713 
714     function isOperator() external returns (bool);
715 
716     function operator() external view returns (address);
717 }
718 
719 // File: contracts/interfaces/IFeeDistributorRecipient.sol
720 
721 pragma solidity ^0.6.0;
722 
723 
724 abstract contract IFeeDistributorRecipient is Ownable {
725     address public feeDistributor;
726 
727     modifier onlyFeeDistributor() {
728         require(
729             _msgSender() == feeDistributor,
730             'Caller is not fee distributor'
731         );
732         _;
733     }
734 
735     function setFeeDistributor(address _feeDistributor)
736         external
737         virtual
738         onlyOwner
739     {
740         feeDistributor = _feeDistributor;
741     }
742 }
743 
744 // File: contracts/Boardroomv3.sol
745 
746 pragma solidity ^0.6.0;
747 //pragma experimental ABIEncoderV2;
748 
749 
750 
751 
752 
753 
754 
755 
756 contract ShareWrapper {
757     using SafeMath for uint256;
758     using SafeERC20 for IERC20;
759 
760     IERC20 public share;
761 
762     uint256 private _totalSupply;
763     mapping(address => uint256) private _balances;
764 
765     function totalSupply() public view returns (uint256) {
766         return _totalSupply;
767     }
768 
769     function balanceOf(address account) public view returns (uint256) {
770         return _balances[account];
771     }
772 
773     function stake(uint256 amount) public virtual {
774         _totalSupply = _totalSupply.add(amount);
775         _balances[msg.sender] = _balances[msg.sender].add(amount);
776         share.safeTransferFrom(msg.sender, address(this), amount);
777     }
778 
779     function withdraw(uint256 amount) public virtual {
780         uint256 directorShare = _balances[msg.sender];
781         require(
782             directorShare >= amount,
783             'Boardroom: withdraw request greater than staked amount'
784         );
785         _totalSupply = _totalSupply.sub(amount);
786         _balances[msg.sender] = directorShare.sub(amount);
787         share.safeTransfer(msg.sender, amount);
788     }
789 }
790 
791 contract Boardroomv3 is ShareWrapper, ContractGuard, Operator, IFeeDistributorRecipient {
792     using SafeERC20 for IERC20;
793     using Address for address;
794     using SafeMath for uint256;
795     using Safe112 for uint112;
796 
797     /* ========== DATA STRUCTURES ========== */
798 
799     struct Boardseat {
800         uint256 lastSnapshotIndex;
801         uint256 rewardEarned;
802         uint256 pendingWithdrawalBalance;
803         uint256 pendingWithdrawalTime;
804     }
805 
806     struct BoardSnapshot {
807         uint256 time;
808         uint256 rewardReceived;
809         uint256 rewardPerShare;
810     }
811 
812     /* ========== STATE VARIABLES ========== */
813 
814     IERC20 private cash;
815 
816     mapping(address => Boardseat) private directors;
817     BoardSnapshot[] private boardHistory;
818 
819     /* ========== CONSTRUCTOR ========== */
820 
821     constructor(IERC20 _cash, IERC20 _share) public {
822         cash = _cash;
823         share = _share;
824 
825         BoardSnapshot memory genesisSnapshot = BoardSnapshot({
826             time: block.number,
827             rewardReceived: 0,
828             rewardPerShare: 0
829         });
830         boardHistory.push(genesisSnapshot);
831     }
832 
833     /* ========== Modifiers =============== */
834     modifier directorExists {
835         require(
836             balanceOf(msg.sender) > 0,
837             'Boardroom: The director does not exist'
838         );
839         _;
840     }
841 
842     modifier updateReward(address director) {
843         if (director != address(0)) {
844             Boardseat memory seat = directors[director];
845             seat.rewardEarned = earned(director);
846             seat.lastSnapshotIndex = latestSnapshotIndex();
847             directors[director] = seat;
848         }
849         _;
850     }
851 
852     /* ========== VIEW FUNCTIONS ========== */
853 
854     // =========== Snapshot getters
855 
856     function latestSnapshotIndex() public view returns (uint256) {
857         return boardHistory.length.sub(1);
858     }
859 
860     function getLatestSnapshot() internal view returns (BoardSnapshot memory) {
861         return boardHistory[latestSnapshotIndex()];
862     }
863 
864     function getLastSnapshotIndexOf(address director)
865         public
866         view
867         returns (uint256)
868     {
869         return directors[director].lastSnapshotIndex;
870     }
871 
872     function getLastSnapshotOf(address director)
873         internal
874         view
875         returns (BoardSnapshot memory)
876     {
877         return boardHistory[getLastSnapshotIndexOf(director)];
878     }
879 
880     // =========== Director getters
881 
882     function rewardPerShare() public view returns (uint256) {
883         return getLatestSnapshot().rewardPerShare;
884     }
885 
886     function earned(address director) public view returns (uint256) {
887         uint256 latestRPS = getLatestSnapshot().rewardPerShare;
888         uint256 storedRPS = getLastSnapshotOf(director).rewardPerShare;
889 
890         return
891             balanceOf(director).mul(latestRPS.sub(storedRPS)).div(1e18).add(
892                 directors[director].rewardEarned
893             );
894     }
895 
896     function pendingWithdrawalBalance(address director) public view returns (uint256) {
897         return directors[director].pendingWithdrawalBalance;
898     }
899 
900     function pendingWithdrawalTime(address director) public view returns (uint256) {
901         return directors[director].pendingWithdrawalTime;
902     }
903 
904     /* ========== MUTATIVE FUNCTIONS ========== */
905 
906     function stake(uint256 amount)
907         public
908         override
909         onlyOneBlock
910         updateReward(msg.sender)
911     {
912         require(amount > 0, 'Boardroom: Cannot stake 0');
913         super.stake(amount);
914         emit Staked(msg.sender, amount);
915     }
916 
917     function withdraw(uint256 amount)
918         public
919         override
920         onlyOneBlock
921         directorExists
922         updateReward(msg.sender)
923     {
924         require(amount > 0, 'Boardroom: Cannot withdraw 0');
925         super.withdraw(amount);
926         emit Withdrawn(msg.sender, amount);
927     }
928 
929     function exit() external {
930         withdraw(balanceOf(msg.sender));
931         claimReward();
932     }
933 
934     //Claim rewards after the 5 day delay
935     function claimReward() public {
936         uint256 timeCanWithdraw = directors[msg.sender].pendingWithdrawalTime;
937         require(timeCanWithdraw <= now, 'Boardroom: Need to wait more time before claiming reward');
938 
939         uint256 reward = directors[msg.sender].pendingWithdrawalBalance;
940 
941         if (reward > 0) {
942             directors[msg.sender].pendingWithdrawalBalance = 0;
943             directors[msg.sender].pendingWithdrawalTime = 0;
944 
945             cash.safeTransfer(msg.sender, reward);
946             emit RewardPaid(msg.sender, reward);
947         }
948     }
949 
950     //Initiates a reward claim with a 5 day delay
951     //This will reset the timer for any "mature" rewards the user has 
952     function initiateRewardClaim() public updateReward(msg.sender) {
953         uint256 reward = directors[msg.sender].rewardEarned;
954         if (reward > 0) {
955             uint256 newPendingWithdrawalBalance = directors[msg.sender].pendingWithdrawalBalance.add(reward);
956             directors[msg.sender].rewardEarned = 0;
957             directors[msg.sender].pendingWithdrawalBalance = newPendingWithdrawalBalance;
958             directors[msg.sender].pendingWithdrawalTime = now + 5 days;
959             emit RewardPending(msg.sender, reward);
960         }
961     }
962 
963     function allocateSeigniorage(uint256 amount)
964         external
965         onlyOneBlock
966         onlyOperator
967     {
968         require(amount > 0, 'Boardroom: Cannot allocate 0');
969         require(
970             totalSupply() > 0,
971             'Boardroom: Cannot allocate when totalSupply is 0'
972         );
973 
974         // Create & add new snapshot
975         uint256 prevRPS = getLatestSnapshot().rewardPerShare;
976         uint256 nextRPS = prevRPS.add(amount.mul(1e18).div(totalSupply()));
977 
978         BoardSnapshot memory newSnapshot = BoardSnapshot({
979             time: block.number,
980             rewardReceived: amount,
981             rewardPerShare: nextRPS
982         });
983         boardHistory.push(newSnapshot);
984 
985         cash.safeTransferFrom(msg.sender, address(this), amount);
986         emit RewardAdded(msg.sender, amount);
987     }
988 
989     function allocateTaxes(uint256 amount)
990         external
991         onlyOneBlock
992         onlyFeeDistributor
993     {
994         require(amount > 0, 'Boardroom: Cannot allocate 0');
995         require(
996             totalSupply() > 0,
997             'Boardroom: Cannot allocate when totalSupply is 0'
998         );
999 
1000         // Create & add new snapshot
1001         uint256 prevRPS = getLatestSnapshot().rewardPerShare;
1002         uint256 nextRPS = prevRPS.add(amount.mul(1e18).div(totalSupply()));
1003 
1004         BoardSnapshot memory newSnapshot = BoardSnapshot({
1005             time: block.number,
1006             rewardReceived: amount,
1007             rewardPerShare: nextRPS
1008         });
1009         boardHistory.push(newSnapshot);
1010 
1011         cash.safeTransferFrom(msg.sender, address(this), amount);
1012         emit RewardAdded(msg.sender, amount);
1013     }
1014 
1015     /* ========== EVENTS ========== */
1016 
1017     event Staked(address indexed user, uint256 amount);
1018     event Withdrawn(address indexed user, uint256 amount);
1019     event RewardPaid(address indexed user, uint256 reward);
1020     event RewardAdded(address indexed user, uint256 reward);
1021     event RewardPending(address indexed user, uint256 reward);
1022 }