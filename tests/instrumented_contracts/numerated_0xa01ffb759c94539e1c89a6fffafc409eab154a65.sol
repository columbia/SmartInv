1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(
86         address indexed owner,
87         address indexed spender,
88         uint256 value
89     );
90 }
91 
92 // File: @openzeppelin/contracts/math/SafeMath.sol
93 
94 pragma solidity ^0.6.0;
95 
96 /**
97  * @dev Wrappers over Solidity's arithmetic operations with added overflow
98  * checks.
99  *
100  * Arithmetic operations in Solidity wrap on overflow. This can easily result
101  * in bugs, because programmers usually assume that an overflow raises an
102  * error, which is the standard behavior in high level programming languages.
103  * `SafeMath` restores this intuition by reverting the transaction when an
104  * operation overflows.
105  *
106  * Using this library instead of the unchecked operations eliminates an entire
107  * class of bugs, so it's recommended to use it always.
108  */
109 library SafeMath {
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
117      *
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, 'SafeMath: addition overflow');
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         return sub(a, b, 'SafeMath: subtraction overflow');
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(
152         uint256 a,
153         uint256 b,
154         string memory errorMessage
155     ) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the multiplication of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `*` operator.
167      *
168      * Requirements:
169      *
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, 'SafeMath: multiplication overflow');
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         return div(a, b, 'SafeMath: division by zero');
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(
215         uint256 a,
216         uint256 b,
217         string memory errorMessage
218     ) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, 'SafeMath: modulo by zero');
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(
255         uint256 a,
256         uint256 b,
257         string memory errorMessage
258     ) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 // File: @openzeppelin/contracts/utils/Address.sol
265 
266 pragma solidity ^0.6.2;
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // This method relies in extcodesize, which returns 0 for contracts in
291         // construction, since the code is only stored at the end of the
292         // constructor execution.
293 
294         uint256 size;
295         // solhint-disable-next-line no-inline-assembly
296         assembly {
297             size := extcodesize(account)
298         }
299         return size > 0;
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(
320             address(this).balance >= amount,
321             'Address: insufficient balance'
322         );
323 
324         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
325         (bool success, ) = recipient.call{value: amount}('');
326         require(
327             success,
328             'Address: unable to send value, recipient may have reverted'
329         );
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain`call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data)
351         internal
352         returns (bytes memory)
353     {
354         return functionCall(target, data, 'Address: low-level call failed');
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         return _functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but also transferring `value` wei to `target`.
374      *
375      * Requirements:
376      *
377      * - the calling contract must have an ETH balance of at least `value`.
378      * - the called Solidity function must be `payable`.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(
383         address target,
384         bytes memory data,
385         uint256 value
386     ) internal returns (bytes memory) {
387         return
388             functionCallWithValue(
389                 target,
390                 data,
391                 value,
392                 'Address: low-level call with value failed'
393             );
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(
409             address(this).balance >= value,
410             'Address: insufficient balance for call'
411         );
412         return _functionCallWithValue(target, data, value, errorMessage);
413     }
414 
415     function _functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 weiValue,
419         string memory errorMessage
420     ) private returns (bytes memory) {
421         require(isContract(target), 'Address: call to non-contract');
422 
423         // solhint-disable-next-line avoid-low-level-calls
424         (bool success, bytes memory returndata) = target.call{value: weiValue}(
425             data
426         );
427         if (success) {
428             return returndata;
429         } else {
430             // Look for revert reason and bubble it up if present
431             if (returndata.length > 0) {
432                 // The easiest way to bubble the revert reason is using memory via assembly
433 
434                 // solhint-disable-next-line no-inline-assembly
435                 assembly {
436                     let returndata_size := mload(returndata)
437                     revert(add(32, returndata), returndata_size)
438                 }
439             } else {
440                 revert(errorMessage);
441             }
442         }
443     }
444 }
445 
446 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
447 
448 pragma solidity ^0.6.0;
449 
450 /**
451  * @title SafeERC20
452  * @dev Wrappers around ERC20 operations that throw on failure (when the token
453  * contract returns false). Tokens that return no value (and instead revert or
454  * throw on failure) are also supported, non-reverting calls are assumed to be
455  * successful.
456  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
457  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
458  */
459 library SafeERC20 {
460     using SafeMath for uint256;
461     using Address for address;
462 
463     function safeTransfer(
464         IERC20 token,
465         address to,
466         uint256 value
467     ) internal {
468         _callOptionalReturn(
469             token,
470             abi.encodeWithSelector(token.transfer.selector, to, value)
471         );
472     }
473 
474     function safeTransferFrom(
475         IERC20 token,
476         address from,
477         address to,
478         uint256 value
479     ) internal {
480         _callOptionalReturn(
481             token,
482             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
483         );
484     }
485 
486     /**
487      * @dev Deprecated. This function has issues similar to the ones found in
488      * {IERC20-approve}, and its usage is discouraged.
489      *
490      * Whenever possible, use {safeIncreaseAllowance} and
491      * {safeDecreaseAllowance} instead.
492      */
493     function safeApprove(
494         IERC20 token,
495         address spender,
496         uint256 value
497     ) internal {
498         // safeApprove should only be called when setting an initial allowance,
499         // or when resetting it to zero. To increase and decrease it, use
500         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
501         // solhint-disable-next-line max-line-length
502         require(
503             (value == 0) || (token.allowance(address(this), spender) == 0),
504             'SafeERC20: approve from non-zero to non-zero allowance'
505         );
506         _callOptionalReturn(
507             token,
508             abi.encodeWithSelector(token.approve.selector, spender, value)
509         );
510     }
511 
512     function safeIncreaseAllowance(
513         IERC20 token,
514         address spender,
515         uint256 value
516     ) internal {
517         uint256 newAllowance = token.allowance(address(this), spender).add(
518             value
519         );
520         _callOptionalReturn(
521             token,
522             abi.encodeWithSelector(
523                 token.approve.selector,
524                 spender,
525                 newAllowance
526             )
527         );
528     }
529 
530     function safeDecreaseAllowance(
531         IERC20 token,
532         address spender,
533         uint256 value
534     ) internal {
535         uint256 newAllowance = token.allowance(address(this), spender).sub(
536             value,
537             'SafeERC20: decreased allowance below zero'
538         );
539         _callOptionalReturn(
540             token,
541             abi.encodeWithSelector(
542                 token.approve.selector,
543                 spender,
544                 newAllowance
545             )
546         );
547     }
548 
549     /**
550      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
551      * on the return value: the return value is optional (but if data is returned, it must not be false).
552      * @param token The token targeted by the call.
553      * @param data The call data (encoded using abi.encode or one of its variants).
554      */
555     function _callOptionalReturn(IERC20 token, bytes memory data) private {
556         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
557         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
558         // the target address contains contract code and also asserts for success in the low-level call.
559 
560         bytes memory returndata = address(token).functionCall(
561             data,
562             'SafeERC20: low-level call failed'
563         );
564         if (returndata.length > 0) {
565             // Return data is optional
566             // solhint-disable-next-line max-line-length
567             require(
568                 abi.decode(returndata, (bool)),
569                 'SafeERC20: ERC20 operation did not succeed'
570             );
571         }
572     }
573 }
574 
575 // File: contracts/lib/Safe112.sol
576 
577 pragma solidity ^0.6.0;
578 
579 library Safe112 {
580     function add(uint112 a, uint112 b) internal pure returns (uint256) {
581         uint256 c = a + b;
582         require(c >= a, 'Safe112: addition overflow');
583 
584         return c;
585     }
586 
587     function sub(uint112 a, uint112 b) internal pure returns (uint256) {
588         return sub(a, b, 'Safe112: subtraction overflow');
589     }
590 
591     function sub(
592         uint112 a,
593         uint112 b,
594         string memory errorMessage
595     ) internal pure returns (uint112) {
596         require(b <= a, errorMessage);
597         uint112 c = a - b;
598 
599         return c;
600     }
601 
602     function mul(uint112 a, uint112 b) internal pure returns (uint256) {
603         if (a == 0) {
604             return 0;
605         }
606 
607         uint256 c = a * b;
608         require(c / a == b, 'Safe112: multiplication overflow');
609 
610         return c;
611     }
612 
613     function div(uint112 a, uint112 b) internal pure returns (uint256) {
614         return div(a, b, 'Safe112: division by zero');
615     }
616 
617     function div(
618         uint112 a,
619         uint112 b,
620         string memory errorMessage
621     ) internal pure returns (uint112) {
622         // Solidity only automatically asserts when dividing by 0
623         require(b > 0, errorMessage);
624         uint112 c = a / b;
625 
626         return c;
627     }
628 
629     function mod(uint112 a, uint112 b) internal pure returns (uint256) {
630         return mod(a, b, 'Safe112: modulo by zero');
631     }
632 
633     function mod(
634         uint112 a,
635         uint112 b,
636         string memory errorMessage
637     ) internal pure returns (uint112) {
638         require(b != 0, errorMessage);
639         return a % b;
640     }
641 }
642 
643 // File: @openzeppelin/contracts/GSN/Context.sol
644 
645 pragma solidity ^0.6.0;
646 
647 /*
648  * @dev Provides information about the current execution context, including the
649  * sender of the transaction and its data. While these are generally available
650  * via msg.sender and msg.data, they should not be accessed in such a direct
651  * manner, since when dealing with GSN meta-transactions the account sending and
652  * paying for execution may not be the actual sender (as far as an application
653  * is concerned).
654  *
655  * This contract is only required for intermediate, library-like contracts.
656  */
657 abstract contract Context {
658     function _msgSender() internal virtual view returns (address payable) {
659         return msg.sender;
660     }
661 
662     function _msgData() internal virtual view returns (bytes memory) {
663         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
664         return msg.data;
665     }
666 }
667 
668 // File: @openzeppelin/contracts/access/Ownable.sol
669 
670 pragma solidity ^0.6.0;
671 
672 /**
673  * @dev Contract module which provides a basic access control mechanism, where
674  * there is an account (an owner) that can be granted exclusive access to
675  * specific functions.
676  *
677  * By default, the owner account will be the one that deploys the contract. This
678  * can later be changed with {transferOwnership}.
679  *
680  * This module is used through inheritance. It will make available the modifier
681  * `onlyOwner`, which can be applied to your functions to restrict their use to
682  * the owner.
683  */
684 contract Ownable is Context {
685     address private _owner;
686 
687     event OwnershipTransferred(
688         address indexed previousOwner,
689         address indexed newOwner
690     );
691 
692     /**
693      * @dev Initializes the contract setting the deployer as the initial owner.
694      */
695     constructor() internal {
696         address msgSender = _msgSender();
697         _owner = msgSender;
698         emit OwnershipTransferred(address(0), msgSender);
699     }
700 
701     /**
702      * @dev Returns the address of the current owner.
703      */
704     function owner() public view returns (address) {
705         return _owner;
706     }
707 
708     /**
709      * @dev Throws if called by any account other than the owner.
710      */
711     modifier onlyOwner() {
712         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
713         _;
714     }
715 
716     /**
717      * @dev Leaves the contract without owner. It will not be possible to call
718      * `onlyOwner` functions anymore. Can only be called by the current owner.
719      *
720      * NOTE: Renouncing ownership will leave the contract without an owner,
721      * thereby removing any functionality that is only available to the owner.
722      */
723     function renounceOwnership() public virtual onlyOwner {
724         emit OwnershipTransferred(_owner, address(0));
725         _owner = address(0);
726     }
727 
728     /**
729      * @dev Transfers ownership of the contract to a new account (`newOwner`).
730      * Can only be called by the current owner.
731      */
732     function transferOwnership(address newOwner) public virtual onlyOwner {
733         require(
734             newOwner != address(0),
735             'Ownable: new owner is the zero address'
736         );
737         emit OwnershipTransferred(_owner, newOwner);
738         _owner = newOwner;
739     }
740 }
741 
742 // File: contracts/owner/Operator.sol
743 
744 pragma solidity ^0.6.0;
745 
746 contract Operator is Context, Ownable {
747     address private _operator;
748 
749     event OperatorTransferred(
750         address indexed previousOperator,
751         address indexed newOperator
752     );
753 
754     constructor() internal {
755         _operator = _msgSender();
756         emit OperatorTransferred(address(0), _operator);
757     }
758 
759     function operator() public view returns (address) {
760         return _operator;
761     }
762 
763     modifier onlyOperator() {
764         require(
765             _operator == msg.sender,
766             'operator: caller is not the operator'
767         );
768         _;
769     }
770 
771     function isOperator() public view returns (bool) {
772         return _msgSender() == _operator;
773     }
774 
775     function transferOperator(address newOperator_) public onlyOwner {
776         _transferOperator(newOperator_);
777     }
778 
779     function _transferOperator(address newOperator_) internal {
780         require(
781             newOperator_ != address(0),
782             'operator: zero address given for new operator'
783         );
784         emit OperatorTransferred(address(0), newOperator_);
785         _operator = newOperator_;
786     }
787 }
788 
789 // File: contracts/utils/ContractGuard.sol
790 
791 pragma solidity ^0.6.12;
792 
793 contract ContractGuard {
794     mapping(uint256 => mapping(address => bool)) private _status;
795 
796     function checkSameOriginReentranted() internal view returns (bool) {
797         return _status[block.number][tx.origin];
798     }
799 
800     function checkSameSenderReentranted() internal view returns (bool) {
801         return _status[block.number][msg.sender];
802     }
803 
804     modifier onlyOneBlock() {
805         require(
806             !checkSameOriginReentranted(),
807             'ContractGuard: one block, one function'
808         );
809         require(
810             !checkSameSenderReentranted(),
811             'ContractGuard: one block, one function'
812         );
813 
814         _;
815 
816         _status[block.number][tx.origin] = true;
817         _status[block.number][msg.sender] = true;
818     }
819 }
820 
821 // File: contracts/interfaces/IBasisAsset.sol
822 
823 pragma solidity ^0.6.0;
824 
825 interface IBasisAsset {
826     function mint(address recipient, uint256 amount) external returns (bool);
827 
828     function burn(uint256 amount) external;
829 
830     function burnFrom(address from, uint256 amount) external;
831 
832     function isOperator() external returns (bool);
833 
834     function operator() external view returns (address);
835 }
836 
837 // File: contracts/Boardroom.sol
838 
839 pragma solidity ^0.6.0;
840 
841 //pragma experimental ABIEncoderV2;
842 
843 contract ShareWrapper {
844     using SafeMath for uint256;
845     using SafeERC20 for IERC20;
846 
847     IERC20 public share;
848 
849     uint256 private _totalSupply;
850     mapping(address => uint256) private _balances;
851 
852     function totalSupply() public view returns (uint256) {
853         return _totalSupply;
854     }
855 
856     function balanceOf(address account) public view returns (uint256) {
857         return _balances[account];
858     }
859 
860     function stake(uint256 amount) public virtual {
861         _totalSupply = _totalSupply.add(amount);
862         _balances[msg.sender] = _balances[msg.sender].add(amount);
863         share.safeTransferFrom(msg.sender, address(this), amount);
864     }
865 
866     function withdraw(uint256 amount) public virtual {
867         uint256 directorShare = _balances[msg.sender];
868         require(
869             directorShare >= amount,
870             'Boardroom: withdraw request greater than staked amount'
871         );
872         _totalSupply = _totalSupply.sub(amount);
873         _balances[msg.sender] = directorShare.sub(amount);
874         share.safeTransfer(msg.sender, amount);
875     }
876 }
877 
878 contract Boardroom is ShareWrapper, ContractGuard, Operator {
879     using SafeERC20 for IERC20;
880     using Address for address;
881     using SafeMath for uint256;
882     using Safe112 for uint112;
883 
884     /* ========== DATA STRUCTURES ========== */
885 
886     struct Boardseat {
887         uint256 lastSnapshotIndex;
888         uint256 rewardEarned;
889     }
890 
891     struct BoardSnapshot {
892         uint256 timestamp;
893         uint256 rewardReceived;
894         uint256 rewardPerShare;
895     }
896 
897     /* ========== STATE VARIABLES ========== */
898 
899     IERC20 private cash;
900 
901     mapping(address => Boardseat) private directors;
902     BoardSnapshot[] private boardHistory;
903 
904     /* ========== CONSTRUCTOR ========== */
905 
906     constructor(IERC20 _cash, IERC20 _share) public {
907         cash = _cash;
908         share = _share;
909 
910         BoardSnapshot memory genesisSnapshot = BoardSnapshot(now, 0, 0);
911         boardHistory.push(genesisSnapshot);
912     }
913 
914     /* ========== Modifiers =============== */
915     modifier directorExists {
916         require(
917             balanceOf(msg.sender) > 0,
918             'Boardroom: The director does not exist'
919         );
920         _;
921     }
922 
923     modifier updateReward(address director) {
924         uint256 currentIndex = latestSnapshotIndex();
925         if (director != address(0)) {
926             Boardseat memory seat = directors[director];
927             seat.rewardEarned = earned(director);
928             seat.lastSnapshotIndex = currentIndex;
929             directors[director] = seat;
930         }
931         _;
932     }
933 
934     /* ========== VIEW FUNCTIONS ========== */
935 
936     // =========== Snapshot getters
937 
938     function latestSnapshotIndex() public view returns (uint256) {
939         return boardHistory.length.sub(1);
940     }
941 
942     function getLatestSnapshot() internal view returns (BoardSnapshot memory) {
943         return boardHistory[latestSnapshotIndex()];
944     }
945 
946     function getLastSnapshotIndexOf(address director)
947         public
948         view
949         returns (uint256)
950     {
951         return directors[director].lastSnapshotIndex;
952     }
953 
954     function getLastSnapshotOf(address director)
955         internal
956         view
957         returns (BoardSnapshot memory)
958     {
959         return boardHistory[getLastSnapshotIndexOf(director)];
960     }
961 
962     // =========== Director getters
963 
964     function rewardPerShare() public view returns (uint256) {
965         return getLatestSnapshot().rewardPerShare;
966     }
967 
968     function earned(address director) public view returns (uint256) {
969         uint256 latestRPS = getLatestSnapshot().rewardPerShare;
970         uint256 storedRPS = getLastSnapshotOf(director).rewardPerShare;
971 
972         return
973             balanceOf(director).mul(latestRPS.sub(storedRPS)).add(
974                 directors[director].rewardEarned
975             );
976     }
977 
978     /* ========== MUTATIVE FUNCTIONS ========== */
979 
980     function stake(uint256 amount)
981         public
982         override
983         onlyOneBlock
984         updateReward(msg.sender)
985     {
986         require(amount > 0, 'Boardroom: Cannot stake 0');
987         super.stake(amount);
988         emit Staked(msg.sender, amount);
989     }
990 
991     function withdraw(uint256 amount)
992         public
993         override
994         onlyOneBlock
995         directorExists
996         updateReward(msg.sender)
997     {
998         require(amount > 0, 'Boardroom: Cannot withdraw 0');
999         super.withdraw(amount);
1000         emit Withdrawn(msg.sender, amount);
1001     }
1002 
1003     function exit() external {
1004         withdraw(balanceOf(msg.sender));
1005         claimReward();
1006     }
1007 
1008     function claimReward() public updateReward(msg.sender) {
1009         uint256 reward = directors[msg.sender].rewardEarned;
1010         if (reward > 0) {
1011             directors[msg.sender].rewardEarned = 0;
1012             cash.safeTransfer(msg.sender, reward);
1013             emit RewardPaid(msg.sender, reward);
1014         }
1015     }
1016 
1017     function allocateSeigniorage(uint256 amount)
1018         external
1019         onlyOneBlock
1020         onlyOperator
1021     {
1022         require(amount > 0, 'Boardroom: Cannot allocate 0');
1023         require(
1024             totalSupply() > 0,
1025             'Boardroom: Cannot allocate when totalSupply is 0'
1026         );
1027 
1028         // Create & add new snapshot
1029         uint256 prevRPS = getLatestSnapshot().rewardPerShare;
1030         uint256 nextRPS = prevRPS.add(amount.div(totalSupply()));
1031 
1032         BoardSnapshot memory newSnapshot = BoardSnapshot({
1033             timestamp: now,
1034             rewardReceived: amount,
1035             rewardPerShare: nextRPS
1036         });
1037         boardHistory.push(newSnapshot);
1038 
1039         cash.safeTransferFrom(msg.sender, address(this), amount);
1040         emit RewardAdded(msg.sender, amount);
1041     }
1042 
1043     /* ========== EVENTS ========== */
1044 
1045     event Staked(address indexed user, uint256 amount);
1046     event Withdrawn(address indexed user, uint256 amount);
1047     event RewardPaid(address indexed user, uint256 reward);
1048     event RewardAdded(address indexed user, uint256 reward);
1049 }