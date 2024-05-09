1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 pragma solidity ^0.6.0;
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
29         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
30     }
31 }
32 
33 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
34 
35 pragma solidity ^0.6.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount)
59         external
60         returns (bool);
61 
62     /**
63      * @dev Returns the remaining number of tokens that `spender` will be
64      * allowed to spend on behalf of `owner` through {transferFrom}. This is
65      * zero by default.
66      *
67      * This value changes when {approve} or {transferFrom} are called.
68      */
69     function allowance(address owner, address spender)
70         external
71         view
72         returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address sender,
101         address recipient,
102         uint256 amount
103     ) external returns (bool);
104 
105     /**
106      * @dev Emitted when `value` tokens are moved from one account (`from`) to
107      * another (`to`).
108      *
109      * Note that `value` may be zero.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 value);
112 
113     /**
114      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
115      * a call to {approve}. `value` is the new allowance.
116      */
117     event Approval(
118         address indexed owner,
119         address indexed spender,
120         uint256 value
121     );
122 }
123 
124 // File: @openzeppelin/contracts/math/SafeMath.sol
125 
126 pragma solidity ^0.6.0;
127 
128 /**
129  * @dev Wrappers over Solidity's arithmetic operations with added overflow
130  * checks.
131  *
132  * Arithmetic operations in Solidity wrap on overflow. This can easily result
133  * in bugs, because programmers usually assume that an overflow raises an
134  * error, which is the standard behavior in high level programming languages.
135  * `SafeMath` restores this intuition by reverting the transaction when an
136  * operation overflows.
137  *
138  * Using this library instead of the unchecked operations eliminates an entire
139  * class of bugs, so it's recommended to use it always.
140  */
141 library SafeMath {
142     /**
143      * @dev Returns the addition of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `+` operator.
147      *
148      * Requirements:
149      *
150      * - Addition cannot overflow.
151      */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a, 'SafeMath: addition overflow');
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170         return sub(a, b, 'SafeMath: subtraction overflow');
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(
184         uint256 a,
185         uint256 b,
186         string memory errorMessage
187     ) internal pure returns (uint256) {
188         require(b <= a, errorMessage);
189         uint256 c = a - b;
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the multiplication of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `*` operator.
199      *
200      * Requirements:
201      *
202      * - Multiplication cannot overflow.
203      */
204     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
205         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
206         // benefit is lost if 'b' is also tested.
207         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
208         if (a == 0) {
209             return 0;
210         }
211 
212         uint256 c = a * b;
213         require(c / a == b, 'SafeMath: multiplication overflow');
214 
215         return c;
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b) internal pure returns (uint256) {
231         return div(a, b, 'SafeMath: division by zero');
232     }
233 
234     /**
235      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
236      * division by zero. The result is rounded towards zero.
237      *
238      * Counterpart to Solidity's `/` operator. Note: this function uses a
239      * `revert` opcode (which leaves remaining gas untouched) while Solidity
240      * uses an invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function div(
247         uint256 a,
248         uint256 b,
249         string memory errorMessage
250     ) internal pure returns (uint256) {
251         require(b > 0, errorMessage);
252         uint256 c = a / b;
253         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
254 
255         return c;
256     }
257 
258     /**
259      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
260      * Reverts when dividing by zero.
261      *
262      * Counterpart to Solidity's `%` operator. This function uses a `revert`
263      * opcode (which leaves remaining gas untouched) while Solidity uses an
264      * invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      *
268      * - The divisor cannot be zero.
269      */
270     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
271         return mod(a, b, 'SafeMath: modulo by zero');
272     }
273 
274     /**
275      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
276      * Reverts with custom message when dividing by zero.
277      *
278      * Counterpart to Solidity's `%` operator. This function uses a `revert`
279      * opcode (which leaves remaining gas untouched) while Solidity uses an
280      * invalid opcode to revert (consuming all remaining gas).
281      *
282      * Requirements:
283      *
284      * - The divisor cannot be zero.
285      */
286     function mod(
287         uint256 a,
288         uint256 b,
289         string memory errorMessage
290     ) internal pure returns (uint256) {
291         require(b != 0, errorMessage);
292         return a % b;
293     }
294 }
295 
296 // File: @openzeppelin/contracts/utils/Address.sol
297 
298 pragma solidity ^0.6.2;
299 
300 /**
301  * @dev Collection of functions related to the address type
302  */
303 library Address {
304     /**
305      * @dev Returns true if `account` is a contract.
306      *
307      * [IMPORTANT]
308      * ====
309      * It is unsafe to assume that an address for which this function returns
310      * false is an externally-owned account (EOA) and not a contract.
311      *
312      * Among others, `isContract` will return false for the following
313      * types of addresses:
314      *
315      *  - an externally-owned account
316      *  - a contract in construction
317      *  - an address where a contract will be created
318      *  - an address where a contract lived, but was destroyed
319      * ====
320      */
321     function isContract(address account) internal view returns (bool) {
322         // This method relies in extcodesize, which returns 0 for contracts in
323         // construction, since the code is only stored at the end of the
324         // constructor execution.
325 
326         uint256 size;
327         // solhint-disable-next-line no-inline-assembly
328         assembly {
329             size := extcodesize(account)
330         }
331         return size > 0;
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(
352             address(this).balance >= amount,
353             'Address: insufficient balance'
354         );
355 
356         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
357         (bool success, ) = recipient.call{value: amount}('');
358         require(
359             success,
360             'Address: unable to send value, recipient may have reverted'
361         );
362     }
363 
364     /**
365      * @dev Performs a Solidity function call using a low level `call`. A
366      * plain`call` is an unsafe replacement for a function call: use this
367      * function instead.
368      *
369      * If `target` reverts with a revert reason, it is bubbled up by this
370      * function (like regular Solidity function calls).
371      *
372      * Returns the raw returned data. To convert to the expected return value,
373      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
374      *
375      * Requirements:
376      *
377      * - `target` must be a contract.
378      * - calling `target` with `data` must not revert.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(address target, bytes memory data)
383         internal
384         returns (bytes memory)
385     {
386         return functionCall(target, data, 'Address: low-level call failed');
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
391      * `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         return _functionCallWithValue(target, data, 0, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but also transferring `value` wei to `target`.
406      *
407      * Requirements:
408      *
409      * - the calling contract must have an ETH balance of at least `value`.
410      * - the called Solidity function must be `payable`.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value
418     ) internal returns (bytes memory) {
419         return
420             functionCallWithValue(
421                 target,
422                 data,
423                 value,
424                 'Address: low-level call with value failed'
425             );
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
430      * with `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(
435         address target,
436         bytes memory data,
437         uint256 value,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(
441             address(this).balance >= value,
442             'Address: insufficient balance for call'
443         );
444         return _functionCallWithValue(target, data, value, errorMessage);
445     }
446 
447     function _functionCallWithValue(
448         address target,
449         bytes memory data,
450         uint256 weiValue,
451         string memory errorMessage
452     ) private returns (bytes memory) {
453         require(isContract(target), 'Address: call to non-contract');
454 
455         // solhint-disable-next-line avoid-low-level-calls
456         (bool success, bytes memory returndata) =
457             target.call{value: weiValue}(data);
458         if (success) {
459             return returndata;
460         } else {
461             // Look for revert reason and bubble it up if present
462             if (returndata.length > 0) {
463                 // The easiest way to bubble the revert reason is using memory via assembly
464 
465                 // solhint-disable-next-line no-inline-assembly
466                 assembly {
467                     let returndata_size := mload(returndata)
468                     revert(add(32, returndata), returndata_size)
469                 }
470             } else {
471                 revert(errorMessage);
472             }
473         }
474     }
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
478 
479 pragma solidity ^0.6.0;
480 
481 /**
482  * @title SafeERC20
483  * @dev Wrappers around ERC20 operations that throw on failure (when the token
484  * contract returns false). Tokens that return no value (and instead revert or
485  * throw on failure) are also supported, non-reverting calls are assumed to be
486  * successful.
487  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
488  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
489  */
490 library SafeERC20 {
491     using SafeMath for uint256;
492     using Address for address;
493 
494     function safeTransfer(
495         IERC20 token,
496         address to,
497         uint256 value
498     ) internal {
499         _callOptionalReturn(
500             token,
501             abi.encodeWithSelector(token.transfer.selector, to, value)
502         );
503     }
504 
505     function safeTransferFrom(
506         IERC20 token,
507         address from,
508         address to,
509         uint256 value
510     ) internal {
511         _callOptionalReturn(
512             token,
513             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
514         );
515     }
516 
517     /**
518      * @dev Deprecated. This function has issues similar to the ones found in
519      * {IERC20-approve}, and its usage is discouraged.
520      *
521      * Whenever possible, use {safeIncreaseAllowance} and
522      * {safeDecreaseAllowance} instead.
523      */
524     function safeApprove(
525         IERC20 token,
526         address spender,
527         uint256 value
528     ) internal {
529         // safeApprove should only be called when setting an initial allowance,
530         // or when resetting it to zero. To increase and decrease it, use
531         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
532         // solhint-disable-next-line max-line-length
533         require(
534             (value == 0) || (token.allowance(address(this), spender) == 0),
535             'SafeERC20: approve from non-zero to non-zero allowance'
536         );
537         _callOptionalReturn(
538             token,
539             abi.encodeWithSelector(token.approve.selector, spender, value)
540         );
541     }
542 
543     function safeIncreaseAllowance(
544         IERC20 token,
545         address spender,
546         uint256 value
547     ) internal {
548         uint256 newAllowance =
549             token.allowance(address(this), spender).add(value);
550         _callOptionalReturn(
551             token,
552             abi.encodeWithSelector(
553                 token.approve.selector,
554                 spender,
555                 newAllowance
556             )
557         );
558     }
559 
560     function safeDecreaseAllowance(
561         IERC20 token,
562         address spender,
563         uint256 value
564     ) internal {
565         uint256 newAllowance =
566             token.allowance(address(this), spender).sub(
567                 value,
568                 'SafeERC20: decreased allowance below zero'
569             );
570         _callOptionalReturn(
571             token,
572             abi.encodeWithSelector(
573                 token.approve.selector,
574                 spender,
575                 newAllowance
576             )
577         );
578     }
579 
580     /**
581      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
582      * on the return value: the return value is optional (but if data is returned, it must not be false).
583      * @param token The token targeted by the call.
584      * @param data The call data (encoded using abi.encode or one of its variants).
585      */
586     function _callOptionalReturn(IERC20 token, bytes memory data) private {
587         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
588         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
589         // the target address contains contract code and also asserts for success in the low-level call.
590 
591         bytes memory returndata =
592             address(token).functionCall(
593                 data,
594                 'SafeERC20: low-level call failed'
595             );
596         if (returndata.length > 0) {
597             // Return data is optional
598             // solhint-disable-next-line max-line-length
599             require(
600                 abi.decode(returndata, (bool)),
601                 'SafeERC20: ERC20 operation did not succeed'
602             );
603         }
604     }
605 }
606 
607 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
608 
609 pragma solidity ^0.6.0;
610 
611 /**
612  * @dev Contract module that helps prevent reentrant calls to a function.
613  *
614  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
615  * available, which can be applied to functions to make sure there are no nested
616  * (reentrant) calls to them.
617  *
618  * Note that because there is a single `nonReentrant` guard, functions marked as
619  * `nonReentrant` may not call one another. This can be worked around by making
620  * those functions `private`, and then adding `external` `nonReentrant` entry
621  * points to them.
622  *
623  * TIP: If you would like to learn more about reentrancy and alternative ways
624  * to protect against it, check out our blog post
625  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
626  */
627 contract ReentrancyGuard {
628     // Booleans are more expensive than uint256 or any type that takes up a full
629     // word because each write operation emits an extra SLOAD to first read the
630     // slot's contents, replace the bits taken up by the boolean, and then write
631     // back. This is the compiler's defense against contract upgrades and
632     // pointer aliasing, and it cannot be disabled.
633 
634     // The values being non-zero value makes deployment a bit more expensive,
635     // but in exchange the refund on every call to nonReentrant will be lower in
636     // amount. Since refunds are capped to a percentage of the total
637     // transaction's gas, it is best to keep them low in cases like this one, to
638     // increase the likelihood of the full refund coming into effect.
639     uint256 private constant _NOT_ENTERED = 1;
640     uint256 private constant _ENTERED = 2;
641 
642     uint256 private _status;
643 
644     constructor() internal {
645         _status = _NOT_ENTERED;
646     }
647 
648     /**
649      * @dev Prevents a contract from calling itself, directly or indirectly.
650      * Calling a `nonReentrant` function from another `nonReentrant`
651      * function is not supported. It is possible to prevent this from happening
652      * by making the `nonReentrant` function external, and make it call a
653      * `private` function that does the actual work.
654      */
655     modifier nonReentrant() {
656         // On the first call to nonReentrant, _notEntered will be true
657         require(_status != _ENTERED, 'ReentrancyGuard: reentrant call');
658 
659         // Any calls to nonReentrant after this point will fail
660         _status = _ENTERED;
661 
662         _;
663 
664         // By storing the original value once again, a refund is triggered (see
665         // https://eips.ethereum.org/EIPS/eip-2200)
666         _status = _NOT_ENTERED;
667     }
668 }
669 
670 // File: contracts/curve/Curve.sol
671 
672 pragma solidity ^0.6.0;
673 
674 interface ICurve {
675     function minSupply() external view returns (uint256);
676 
677     function maxSupply() external view returns (uint256);
678 
679     function minCeiling() external view returns (uint256);
680 
681     function maxCeiling() external view returns (uint256);
682 
683     function calcCeiling(uint256 _supply) external view returns (uint256);
684 }
685 
686 abstract contract Curve is ICurve {
687     /* ========== EVENTS ========== */
688 
689     event MinSupplyChanged(
690         address indexed operator,
691         uint256 _old,
692         uint256 _new
693     );
694 
695     event MaxSupplyChanged(
696         address indexed operator,
697         uint256 _old,
698         uint256 _new
699     );
700 
701     event MinCeilingChanged(
702         address indexed operator,
703         uint256 _old,
704         uint256 _new
705     );
706 
707     event MaxCeilingChanged(
708         address indexed operator,
709         uint256 _old,
710         uint256 _new
711     );
712 
713     /* ========== STATE VARIABLES ========== */
714 
715     uint256 public override minSupply;
716     uint256 public override maxSupply;
717 
718     uint256 public override minCeiling;
719     uint256 public override maxCeiling;
720 
721     /* ========== GOVERNANCE ========== */
722 
723     function setMinSupply(uint256 _newMinSupply) public virtual {
724         uint256 oldMinSupply = minSupply;
725         minSupply = _newMinSupply;
726         emit MinSupplyChanged(msg.sender, oldMinSupply, _newMinSupply);
727     }
728 
729     function setMaxSupply(uint256 _newMaxSupply) public virtual {
730         uint256 oldMaxSupply = maxSupply;
731         maxSupply = _newMaxSupply;
732         emit MaxSupplyChanged(msg.sender, oldMaxSupply, _newMaxSupply);
733     }
734 
735     function setMinCeiling(uint256 _newMinCeiling) public virtual {
736         uint256 oldMinCeiling = _newMinCeiling;
737         minCeiling = _newMinCeiling;
738         emit MinCeilingChanged(msg.sender, oldMinCeiling, _newMinCeiling);
739     }
740 
741     function setMaxCeiling(uint256 _newMaxCeiling) public virtual {
742         uint256 oldMaxCeiling = _newMaxCeiling;
743         maxCeiling = _newMaxCeiling;
744         emit MaxCeilingChanged(msg.sender, oldMaxCeiling, _newMaxCeiling);
745     }
746 
747     function calcCeiling(uint256 _supply)
748         external
749         view
750         virtual
751         override
752         returns (uint256);
753 }
754 
755 // File: contracts/interfaces/IOracle.sol
756 
757 pragma solidity ^0.6.0;
758 
759 interface IOracle {
760     function update() external;
761 
762     function consult(address token, uint256 amountIn)
763         external
764         view
765         returns (uint256 amountOut);
766     // function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestamp);
767 }
768 
769 // File: contracts/interfaces/IBoardroom.sol
770 
771 pragma solidity ^0.6.0;
772 
773 interface IBoardroom {
774     function allocateSeigniorage(uint256 amount) external;
775 }
776 
777 // File: contracts/interfaces/IBasisAsset.sol
778 
779 pragma solidity ^0.6.0;
780 
781 interface IBasisAsset {
782     function mint(address recipient, uint256 amount) external returns (bool);
783 
784     function burn(uint256 amount) external;
785 
786     function burnFrom(address from, uint256 amount) external;
787 
788     function isOperator() external returns (bool);
789 
790     function operator() external view returns (address);
791 }
792 
793 // File: contracts/interfaces/ISimpleERCFund.sol
794 
795 pragma solidity ^0.6.0;
796 
797 interface ISimpleERCFund {
798     function deposit(
799         address token,
800         uint256 amount,
801         string memory reason
802     ) external;
803 
804     function withdraw(
805         address token,
806         uint256 amount,
807         address to,
808         string memory reason
809     ) external;
810 }
811 
812 // File: contracts/lib/Babylonian.sol
813 
814 pragma solidity ^0.6.0;
815 
816 library Babylonian {
817     function sqrt(uint256 y) internal pure returns (uint256 z) {
818         if (y > 3) {
819             z = y;
820             uint256 x = y / 2 + 1;
821             while (x < z) {
822                 z = x;
823                 x = (y / x + x) / 2;
824             }
825         } else if (y != 0) {
826             z = 1;
827         }
828         // else z = 0
829     }
830 }
831 
832 // File: contracts/lib/FixedPoint.sol
833 
834 pragma solidity ^0.6.0;
835 
836 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
837 library FixedPoint {
838     // range: [0, 2**112 - 1]
839     // resolution: 1 / 2**112
840     struct uq112x112 {
841         uint224 _x;
842     }
843 
844     // range: [0, 2**144 - 1]
845     // resolution: 1 / 2**112
846     struct uq144x112 {
847         uint256 _x;
848     }
849 
850     uint8 private constant RESOLUTION = 112;
851     uint256 private constant Q112 = uint256(1) << RESOLUTION;
852     uint256 private constant Q224 = Q112 << RESOLUTION;
853 
854     // encode a uint112 as a UQ112x112
855     function encode(uint112 x) internal pure returns (uq112x112 memory) {
856         return uq112x112(uint224(x) << RESOLUTION);
857     }
858 
859     // encodes a uint144 as a UQ144x112
860     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
861         return uq144x112(uint256(x) << RESOLUTION);
862     }
863 
864     // divide a UQ112x112 by a uint112, returning a UQ112x112
865     function div(uq112x112 memory self, uint112 x)
866         internal
867         pure
868         returns (uq112x112 memory)
869     {
870         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
871         return uq112x112(self._x / uint224(x));
872     }
873 
874     // multiply a UQ112x112 by a uint, returning a UQ144x112
875     // reverts on overflow
876     function mul(uq112x112 memory self, uint256 y)
877         internal
878         pure
879         returns (uq144x112 memory)
880     {
881         uint256 z;
882         require(
883             y == 0 || (z = uint256(self._x) * y) / y == uint256(self._x),
884             'FixedPoint: MULTIPLICATION_OVERFLOW'
885         );
886         return uq144x112(z);
887     }
888 
889     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
890     // equivalent to encode(numerator).div(denominator)
891     function fraction(uint112 numerator, uint112 denominator)
892         internal
893         pure
894         returns (uq112x112 memory)
895     {
896         require(denominator > 0, 'FixedPoint: DIV_BY_ZERO');
897         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
898     }
899 
900     // decode a UQ112x112 into a uint112 by truncating after the radix point
901     function decode(uq112x112 memory self) internal pure returns (uint112) {
902         return uint112(self._x >> RESOLUTION);
903     }
904 
905     // decode a UQ144x112 into a uint144 by truncating after the radix point
906     function decode144(uq144x112 memory self) internal pure returns (uint144) {
907         return uint144(self._x >> RESOLUTION);
908     }
909 
910     // take the reciprocal of a UQ112x112
911     function reciprocal(uq112x112 memory self)
912         internal
913         pure
914         returns (uq112x112 memory)
915     {
916         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
917         return uq112x112(uint224(Q224 / self._x));
918     }
919 
920     // square root of a UQ112x112
921     function sqrt(uq112x112 memory self)
922         internal
923         pure
924         returns (uq112x112 memory)
925     {
926         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));
927     }
928 }
929 
930 // File: contracts/lib/Safe112.sol
931 
932 pragma solidity ^0.6.0;
933 
934 library Safe112 {
935     function add(uint112 a, uint112 b) internal pure returns (uint256) {
936         uint256 c = a + b;
937         require(c >= a, 'Safe112: addition overflow');
938 
939         return c;
940     }
941 
942     function sub(uint112 a, uint112 b) internal pure returns (uint256) {
943         return sub(a, b, 'Safe112: subtraction overflow');
944     }
945 
946     function sub(
947         uint112 a,
948         uint112 b,
949         string memory errorMessage
950     ) internal pure returns (uint112) {
951         require(b <= a, errorMessage);
952         uint112 c = a - b;
953 
954         return c;
955     }
956 
957     function mul(uint112 a, uint112 b) internal pure returns (uint256) {
958         if (a == 0) {
959             return 0;
960         }
961 
962         uint256 c = a * b;
963         require(c / a == b, 'Safe112: multiplication overflow');
964 
965         return c;
966     }
967 
968     function div(uint112 a, uint112 b) internal pure returns (uint256) {
969         return div(a, b, 'Safe112: division by zero');
970     }
971 
972     function div(
973         uint112 a,
974         uint112 b,
975         string memory errorMessage
976     ) internal pure returns (uint112) {
977         // Solidity only automatically asserts when dividing by 0
978         require(b > 0, errorMessage);
979         uint112 c = a / b;
980 
981         return c;
982     }
983 
984     function mod(uint112 a, uint112 b) internal pure returns (uint256) {
985         return mod(a, b, 'Safe112: modulo by zero');
986     }
987 
988     function mod(
989         uint112 a,
990         uint112 b,
991         string memory errorMessage
992     ) internal pure returns (uint112) {
993         require(b != 0, errorMessage);
994         return a % b;
995     }
996 }
997 
998 // File: @openzeppelin/contracts/GSN/Context.sol
999 
1000 pragma solidity ^0.6.0;
1001 
1002 /*
1003  * @dev Provides information about the current execution context, including the
1004  * sender of the transaction and its data. While these are generally available
1005  * via msg.sender and msg.data, they should not be accessed in such a direct
1006  * manner, since when dealing with GSN meta-transactions the account sending and
1007  * paying for execution may not be the actual sender (as far as an application
1008  * is concerned).
1009  *
1010  * This contract is only required for intermediate, library-like contracts.
1011  */
1012 abstract contract Context {
1013     function _msgSender() internal view virtual returns (address payable) {
1014         return msg.sender;
1015     }
1016 
1017     function _msgData() internal view virtual returns (bytes memory) {
1018         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1019         return msg.data;
1020     }
1021 }
1022 
1023 // File: @openzeppelin/contracts/access/Ownable.sol
1024 
1025 pragma solidity ^0.6.0;
1026 
1027 /**
1028  * @dev Contract module which provides a basic access control mechanism, where
1029  * there is an account (an owner) that can be granted exclusive access to
1030  * specific functions.
1031  *
1032  * By default, the owner account will be the one that deploys the contract. This
1033  * can later be changed with {transferOwnership}.
1034  *
1035  * This module is used through inheritance. It will make available the modifier
1036  * `onlyOwner`, which can be applied to your functions to restrict their use to
1037  * the owner.
1038  */
1039 contract Ownable is Context {
1040     address private _owner;
1041 
1042     event OwnershipTransferred(
1043         address indexed previousOwner,
1044         address indexed newOwner
1045     );
1046 
1047     /**
1048      * @dev Initializes the contract setting the deployer as the initial owner.
1049      */
1050     constructor() internal {
1051         address msgSender = _msgSender();
1052         _owner = msgSender;
1053         emit OwnershipTransferred(address(0), msgSender);
1054     }
1055 
1056     /**
1057      * @dev Returns the address of the current owner.
1058      */
1059     function owner() public view returns (address) {
1060         return _owner;
1061     }
1062 
1063     /**
1064      * @dev Throws if called by any account other than the owner.
1065      */
1066     modifier onlyOwner() {
1067         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
1068         _;
1069     }
1070 
1071     /**
1072      * @dev Leaves the contract without owner. It will not be possible to call
1073      * `onlyOwner` functions anymore. Can only be called by the current owner.
1074      *
1075      * NOTE: Renouncing ownership will leave the contract without an owner,
1076      * thereby removing any functionality that is only available to the owner.
1077      */
1078     function renounceOwnership() public virtual onlyOwner {
1079         emit OwnershipTransferred(_owner, address(0));
1080         _owner = address(0);
1081     }
1082 
1083     /**
1084      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1085      * Can only be called by the current owner.
1086      */
1087     function transferOwnership(address newOwner) public virtual onlyOwner {
1088         require(
1089             newOwner != address(0),
1090             'Ownable: new owner is the zero address'
1091         );
1092         emit OwnershipTransferred(_owner, newOwner);
1093         _owner = newOwner;
1094     }
1095 }
1096 
1097 // File: contracts/owner/Operator.sol
1098 
1099 pragma solidity ^0.6.0;
1100 
1101 contract Operator is Context, Ownable {
1102     address private _operator;
1103 
1104     event OperatorTransferred(
1105         address indexed previousOperator,
1106         address indexed newOperator
1107     );
1108 
1109     constructor() internal {
1110         _operator = _msgSender();
1111         emit OperatorTransferred(address(0), _operator);
1112     }
1113 
1114     function operator() public view returns (address) {
1115         return _operator;
1116     }
1117 
1118     modifier onlyOperator() {
1119         require(
1120             _operator == msg.sender,
1121             'operator: caller is not the operator'
1122         );
1123         _;
1124     }
1125 
1126     function isOperator() public view returns (bool) {
1127         return _msgSender() == _operator;
1128     }
1129 
1130     function transferOperator(address newOperator_) public onlyOwner {
1131         _transferOperator(newOperator_);
1132     }
1133 
1134     function _transferOperator(address newOperator_) internal {
1135         require(
1136             newOperator_ != address(0),
1137             'operator: zero address given for new operator'
1138         );
1139         emit OperatorTransferred(address(0), newOperator_);
1140         _operator = newOperator_;
1141     }
1142 }
1143 
1144 // File: contracts/utils/Epoch.sol
1145 
1146 pragma solidity ^0.6.0;
1147 
1148 contract Epoch is Operator {
1149     using SafeMath for uint256;
1150 
1151     uint256 private period;
1152     uint256 private startTime;
1153     uint256 private lastExecutedAt;
1154 
1155     /* ========== CONSTRUCTOR ========== */
1156 
1157     constructor(
1158         uint256 _period,
1159         uint256 _startTime,
1160         uint256 _startEpoch
1161     ) public {
1162         require(_startTime > block.timestamp, 'Epoch: invalid start time');
1163         period = _period;
1164         startTime = _startTime;
1165         lastExecutedAt = startTime.add(_startEpoch.mul(period));
1166     }
1167 
1168     /* ========== Modifier ========== */
1169 
1170     modifier checkStartTime {
1171         require(now >= startTime, 'Epoch: not started yet');
1172 
1173         _;
1174     }
1175 
1176     modifier checkEpoch {
1177         require(now > startTime, 'Epoch: not started yet');
1178         require(callable(), 'Epoch: not allowed');
1179 
1180         _;
1181 
1182         lastExecutedAt = block.timestamp;
1183     }
1184 
1185     /* ========== VIEW FUNCTIONS ========== */
1186 
1187     function callable() public view returns (bool) {
1188         return getCurrentEpoch() >= getNextEpoch();
1189     }
1190 
1191     // epoch
1192     function getLastEpoch() public view returns (uint256) {
1193         return lastExecutedAt.sub(startTime).div(period);
1194     }
1195 
1196     function getCurrentEpoch() public view returns (uint256) {
1197         return Math.max(startTime, block.timestamp).sub(startTime).div(period);
1198     }
1199 
1200     function getNextEpoch() public view returns (uint256) {
1201         if (startTime == lastExecutedAt) {
1202             return getLastEpoch();
1203         }
1204         return getLastEpoch().add(1);
1205     }
1206 
1207     function nextEpochPoint() public view returns (uint256) {
1208         return startTime.add(getNextEpoch().mul(period));
1209     }
1210 
1211     // params
1212     function getPeriod() public view returns (uint256) {
1213         return period;
1214     }
1215 
1216     function getStartTime() public view returns (uint256) {
1217         return startTime;
1218     }
1219 
1220     /* ========== GOVERNANCE ========== */
1221 
1222     function setPeriod(uint256 _period) external onlyOperator {
1223         period = _period;
1224     }
1225 }
1226 
1227 // File: contracts/utils/ContractGuard.sol
1228 
1229 pragma solidity ^0.6.12;
1230 
1231 contract ContractGuard {
1232     mapping(uint256 => mapping(address => bool)) private _status;
1233 
1234     function checkSameOriginReentranted() internal view returns (bool) {
1235         return _status[block.number][tx.origin];
1236     }
1237 
1238     function checkSameSenderReentranted() internal view returns (bool) {
1239         return _status[block.number][msg.sender];
1240     }
1241 
1242     modifier onlyOneBlock() {
1243         require(
1244             !checkSameOriginReentranted(),
1245             'ContractGuard: one block, one function'
1246         );
1247         require(
1248             !checkSameSenderReentranted(),
1249             'ContractGuard: one block, one function'
1250         );
1251 
1252         _;
1253 
1254         _status[block.number][tx.origin] = true;
1255         _status[block.number][msg.sender] = true;
1256     }
1257 }
1258 
1259 // File: contracts/Treasury.sol
1260 
1261 pragma solidity ^0.6.0;
1262 
1263 /**
1264  * @title Basis Cash Treasury contract
1265  * @notice Monetary policy logic to adjust supplies of basis cash assets
1266  * @author Summer Smith & Rick Sanchez
1267  */
1268 contract Treasury is ContractGuard, Epoch {
1269     using FixedPoint for *;
1270     using SafeERC20 for IERC20;
1271     using Address for address;
1272     using SafeMath for uint256;
1273     using Safe112 for uint112;
1274 
1275     /* ========== STATE VARIABLES ========== */
1276 
1277     // ========== FLAGS
1278     bool public migrated = false;
1279     bool public initialized = false;
1280 
1281     // ========== CORE
1282     address public fund;
1283     address public cash;
1284     address public bond;
1285     address public share;
1286     address public curve;
1287     address public boardroom;
1288 
1289     address public bondOracle;
1290     address public seigniorageOracle;
1291 
1292     // ========== PARAMS
1293     uint256 public cashPriceOne;
1294 
1295     uint256 public lastBondOracleEpoch = 0;
1296     uint256 public cashConversionLimit = 0;
1297     uint256 public accumulatedSeigniorage = 0;
1298     uint256 public accumulatedCashConversion = 0;
1299     uint256 public fundAllocationRate = 2; // %
1300 
1301     /* ========== CONSTRUCTOR ========== */
1302 
1303     constructor(
1304         address _cash,
1305         address _bond,
1306         address _share,
1307         address _bondOracle,
1308         address _seigniorageOracle,
1309         address _boardroom,
1310         address _fund,
1311         address _curve,
1312         uint256 _startTime
1313     ) public Epoch(1 days, _startTime, 0) {
1314         cash = _cash;
1315         bond = _bond;
1316         share = _share;
1317         curve = _curve;
1318         bondOracle = _bondOracle;
1319         seigniorageOracle = _seigniorageOracle;
1320 
1321         boardroom = _boardroom;
1322         fund = _fund;
1323 
1324         cashPriceOne = 10**18;
1325     }
1326 
1327     /* =================== Modifier =================== */
1328 
1329     modifier checkMigration {
1330         require(!migrated, 'Treasury: migrated');
1331 
1332         _;
1333     }
1334 
1335     modifier checkOperator {
1336         require(
1337             IBasisAsset(cash).operator() == address(this) &&
1338                 IBasisAsset(bond).operator() == address(this) &&
1339                 IBasisAsset(share).operator() == address(this) &&
1340                 Operator(boardroom).operator() == address(this),
1341             'Treasury: need more permission'
1342         );
1343 
1344         _;
1345     }
1346 
1347     modifier updatePrice {
1348         _;
1349 
1350         _updateCashPrice();
1351     }
1352 
1353     /* ========== VIEW FUNCTIONS ========== */
1354 
1355     // budget
1356     function getReserve() public view returns (uint256) {
1357         return accumulatedSeigniorage;
1358     }
1359 
1360     function circulatingSupply() public view returns (uint256) {
1361         return IERC20(cash).totalSupply().sub(accumulatedSeigniorage);
1362     }
1363 
1364     function getCeilingPrice() public view returns (uint256) {
1365         return ICurve(curve).calcCeiling(circulatingSupply());
1366     }
1367 
1368     // oracle
1369     function getBondOraclePrice() public view returns (uint256) {
1370         return _getCashPrice(bondOracle);
1371     }
1372 
1373     function getSeigniorageOraclePrice() public view returns (uint256) {
1374         return _getCashPrice(seigniorageOracle);
1375     }
1376 
1377     function _getCashPrice(address oracle) internal view returns (uint256) {
1378         try IOracle(oracle).consult(cash, 1e18) returns (uint256 price) {
1379             return price;
1380         } catch {
1381             revert('Treasury: failed to consult cash price from the oracle');
1382         }
1383     }
1384 
1385     /* ========== GOVERNANCE ========== */
1386 
1387     // MIGRATION
1388     function initialize() public checkOperator {
1389         require(!initialized, 'Treasury: initialized');
1390 
1391         // set accumulatedSeigniorage to it's balance
1392         accumulatedSeigniorage = IERC20(cash).balanceOf(address(this));
1393 
1394         initialized = true;
1395         emit Initialized(msg.sender, block.number);
1396     }
1397 
1398     function migrate(address target) public onlyOperator checkOperator {
1399         require(!migrated, 'Treasury: migrated');
1400 
1401         // cash
1402         Operator(cash).transferOperator(target);
1403         Operator(cash).transferOwnership(target);
1404         IERC20(cash).transfer(target, IERC20(cash).balanceOf(address(this)));
1405 
1406         // bond
1407         Operator(bond).transferOperator(target);
1408         Operator(bond).transferOwnership(target);
1409         IERC20(bond).transfer(target, IERC20(bond).balanceOf(address(this)));
1410 
1411         // share
1412         Operator(share).transferOperator(target);
1413         Operator(share).transferOwnership(target);
1414         IERC20(share).transfer(target, IERC20(share).balanceOf(address(this)));
1415 
1416         migrated = true;
1417         emit Migration(target);
1418     }
1419 
1420     // FUND
1421     function setFund(address newFund) public onlyOperator {
1422         address oldFund = fund;
1423         fund = newFund;
1424         emit ContributionPoolChanged(msg.sender, oldFund, newFund);
1425     }
1426 
1427     function setFundAllocationRate(uint256 newRate) public onlyOperator {
1428         uint256 oldRate = fundAllocationRate;
1429         fundAllocationRate = newRate;
1430         emit ContributionPoolRateChanged(msg.sender, oldRate, newRate);
1431     }
1432 
1433     // ORACLE
1434     function setBondOracle(address newOracle) public onlyOperator {
1435         address oldOracle = bondOracle;
1436         bondOracle = newOracle;
1437         emit BondOracleChanged(msg.sender, oldOracle, newOracle);
1438     }
1439 
1440     function setSeigniorageOracle(address newOracle) public onlyOperator {
1441         address oldOracle = seigniorageOracle;
1442         seigniorageOracle = newOracle;
1443         emit SeigniorageOracleChanged(msg.sender, oldOracle, newOracle);
1444     }
1445 
1446     // TWEAK
1447     function setCeilingCurve(address newCurve) public onlyOperator {
1448         address oldCurve = newCurve;
1449         curve = newCurve;
1450         emit CeilingCurveChanged(msg.sender, oldCurve, newCurve);
1451     }
1452 
1453     /* ========== MUTABLE FUNCTIONS ========== */
1454 
1455     function _updateConversionLimit(uint256 cashPrice) internal {
1456         uint256 currentEpoch = Epoch(bondOracle).getLastEpoch(); // lastest update time
1457         if (lastBondOracleEpoch != currentEpoch) {
1458             uint256 percentage = cashPriceOne.sub(cashPrice);
1459             cashConversionLimit = circulatingSupply().mul(percentage).div(1e18);
1460             accumulatedCashConversion = 0;
1461 
1462             lastBondOracleEpoch = currentEpoch;
1463         }
1464     }
1465 
1466     function _updateCashPrice() internal {
1467         if (Epoch(bondOracle).callable()) {
1468             try IOracle(bondOracle).update() {} catch {}
1469         }
1470         if (Epoch(seigniorageOracle).callable()) {
1471             try IOracle(seigniorageOracle).update() {} catch {}
1472         }
1473     }
1474 
1475     function buyBonds(uint256 amount, uint256 targetPrice)
1476         external
1477         onlyOneBlock
1478         checkMigration
1479         checkStartTime
1480         checkOperator
1481         updatePrice
1482     {
1483         require(amount > 0, 'Treasury: cannot purchase bonds with zero amount');
1484 
1485         uint256 cashPrice = _getCashPrice(bondOracle);
1486         require(cashPrice <= targetPrice, 'Treasury: cash price moved');
1487         require(
1488             cashPrice < cashPriceOne, // price < $1
1489             'Treasury: cashPrice not eligible for bond purchase'
1490         );
1491         _updateConversionLimit(cashPrice);
1492 
1493         // swap exact limit
1494         amount = Math.min(
1495             amount,
1496             cashConversionLimit.sub(accumulatedCashConversion)
1497         );
1498         accumulatedCashConversion = accumulatedCashConversion.add(amount);
1499 
1500         if (amount == 0) {
1501             return;
1502         }
1503 
1504         uint256 bondPrice = cashPrice;
1505 
1506         IBasisAsset(cash).burnFrom(msg.sender, amount);
1507         IBasisAsset(bond).mint(msg.sender, amount.mul(1e18).div(bondPrice));
1508 
1509         emit BoughtBonds(msg.sender, amount);
1510     }
1511 
1512     function redeemBonds(uint256 amount)
1513         external
1514         onlyOneBlock
1515         checkMigration
1516         checkStartTime
1517         checkOperator
1518         updatePrice
1519     {
1520         require(amount > 0, 'Treasury: cannot redeem bonds with zero amount');
1521 
1522         uint256 cashPrice = _getCashPrice(bondOracle);
1523         require(
1524             cashPrice > getCeilingPrice(), // price > $1.05
1525             'Treasury: cashPrice not eligible for bond purchase'
1526         );
1527         require(
1528             IERC20(cash).balanceOf(address(this)) >= amount,
1529             'Treasury: treasury has no more budget'
1530         );
1531 
1532         accumulatedSeigniorage = accumulatedSeigniorage.sub(
1533             Math.min(accumulatedSeigniorage, amount)
1534         );
1535 
1536         IBasisAsset(bond).burnFrom(msg.sender, amount);
1537         IERC20(cash).safeTransfer(msg.sender, amount);
1538 
1539         emit RedeemedBonds(msg.sender, amount);
1540     }
1541 
1542     function allocateSeigniorage()
1543         external
1544         onlyOneBlock
1545         checkMigration
1546         checkStartTime
1547         checkEpoch
1548         checkOperator
1549     {
1550         _updateCashPrice();
1551         uint256 cashPrice = _getCashPrice(seigniorageOracle);
1552         if (cashPrice <= getCeilingPrice()) {
1553             return; // just advance epoch instead revert
1554         }
1555 
1556         // circulating supply
1557         uint256 percentage = cashPrice.sub(cashPriceOne);
1558         uint256 seigniorage = circulatingSupply().mul(percentage).div(1e18);
1559         IBasisAsset(cash).mint(address(this), seigniorage);
1560 
1561         // ======================== BIP-3
1562         uint256 fundReserve = seigniorage.mul(fundAllocationRate).div(100);
1563         if (fundReserve > 0) {
1564             IERC20(cash).safeApprove(fund, fundReserve);
1565             ISimpleERCFund(fund).deposit(
1566                 cash,
1567                 fundReserve,
1568                 'Treasury: Seigniorage Allocation'
1569             );
1570             emit ContributionPoolFunded(now, fundReserve);
1571         }
1572 
1573         seigniorage = seigniorage.sub(fundReserve);
1574 
1575         // ======================== BIP-4
1576         uint256 treasuryReserve =
1577             Math.min(
1578                 seigniorage,
1579                 IERC20(bond).totalSupply().sub(accumulatedSeigniorage)
1580             );
1581         if (treasuryReserve > 0) {
1582             if (treasuryReserve == seigniorage) {
1583                 treasuryReserve = treasuryReserve.mul(80).div(100);
1584             }
1585             accumulatedSeigniorage = accumulatedSeigniorage.add(
1586                 treasuryReserve
1587             );
1588             emit TreasuryFunded(now, treasuryReserve);
1589         }
1590 
1591         // boardroom
1592         uint256 boardroomReserve = seigniorage.sub(treasuryReserve);
1593         if (boardroomReserve > 0) {
1594             IERC20(cash).safeApprove(boardroom, boardroomReserve);
1595             IBoardroom(boardroom).allocateSeigniorage(boardroomReserve);
1596             emit BoardroomFunded(now, boardroomReserve);
1597         }
1598     }
1599 
1600     /* ========== EVENTS ========== */
1601 
1602     // GOV
1603     event Initialized(address indexed executor, uint256 at);
1604     event Migration(address indexed target);
1605     event ContributionPoolChanged(
1606         address indexed operator,
1607         address oldFund,
1608         address newFund
1609     );
1610     event ContributionPoolRateChanged(
1611         address indexed operator,
1612         uint256 oldRate,
1613         uint256 newRate
1614     );
1615     event BondOracleChanged(
1616         address indexed operator,
1617         address oldOracle,
1618         address newOracle
1619     );
1620     event SeigniorageOracleChanged(
1621         address indexed operator,
1622         address oldOracle,
1623         address newOracle
1624     );
1625     event CeilingCurveChanged(
1626         address indexed operator,
1627         address oldCurve,
1628         address newCurve
1629     );
1630 
1631     // CORE
1632     event RedeemedBonds(address indexed from, uint256 amount);
1633     event BoughtBonds(address indexed from, uint256 amount);
1634     event TreasuryFunded(uint256 timestamp, uint256 seigniorage);
1635     event BoardroomFunded(uint256 timestamp, uint256 seigniorage);
1636     event ContributionPoolFunded(uint256 timestamp, uint256 seigniorage);
1637 }