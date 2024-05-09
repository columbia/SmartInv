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
456         (bool success, bytes memory returndata) = target.call{value: weiValue}(
457             data
458         );
459         if (success) {
460             return returndata;
461         } else {
462             // Look for revert reason and bubble it up if present
463             if (returndata.length > 0) {
464                 // The easiest way to bubble the revert reason is using memory via assembly
465 
466                 // solhint-disable-next-line no-inline-assembly
467                 assembly {
468                     let returndata_size := mload(returndata)
469                     revert(add(32, returndata), returndata_size)
470                 }
471             } else {
472                 revert(errorMessage);
473             }
474         }
475     }
476 }
477 
478 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
479 
480 pragma solidity ^0.6.0;
481 
482 /**
483  * @title SafeERC20
484  * @dev Wrappers around ERC20 operations that throw on failure (when the token
485  * contract returns false). Tokens that return no value (and instead revert or
486  * throw on failure) are also supported, non-reverting calls are assumed to be
487  * successful.
488  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
489  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
490  */
491 library SafeERC20 {
492     using SafeMath for uint256;
493     using Address for address;
494 
495     function safeTransfer(
496         IERC20 token,
497         address to,
498         uint256 value
499     ) internal {
500         _callOptionalReturn(
501             token,
502             abi.encodeWithSelector(token.transfer.selector, to, value)
503         );
504     }
505 
506     function safeTransferFrom(
507         IERC20 token,
508         address from,
509         address to,
510         uint256 value
511     ) internal {
512         _callOptionalReturn(
513             token,
514             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
515         );
516     }
517 
518     /**
519      * @dev Deprecated. This function has issues similar to the ones found in
520      * {IERC20-approve}, and its usage is discouraged.
521      *
522      * Whenever possible, use {safeIncreaseAllowance} and
523      * {safeDecreaseAllowance} instead.
524      */
525     function safeApprove(
526         IERC20 token,
527         address spender,
528         uint256 value
529     ) internal {
530         // safeApprove should only be called when setting an initial allowance,
531         // or when resetting it to zero. To increase and decrease it, use
532         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
533         // solhint-disable-next-line max-line-length
534         require(
535             (value == 0) || (token.allowance(address(this), spender) == 0),
536             'SafeERC20: approve from non-zero to non-zero allowance'
537         );
538         _callOptionalReturn(
539             token,
540             abi.encodeWithSelector(token.approve.selector, spender, value)
541         );
542     }
543 
544     function safeIncreaseAllowance(
545         IERC20 token,
546         address spender,
547         uint256 value
548     ) internal {
549         uint256 newAllowance = token.allowance(address(this), spender).add(
550             value
551         );
552         _callOptionalReturn(
553             token,
554             abi.encodeWithSelector(
555                 token.approve.selector,
556                 spender,
557                 newAllowance
558             )
559         );
560     }
561 
562     function safeDecreaseAllowance(
563         IERC20 token,
564         address spender,
565         uint256 value
566     ) internal {
567         uint256 newAllowance = token.allowance(address(this), spender).sub(
568             value,
569             'SafeERC20: decreased allowance below zero'
570         );
571         _callOptionalReturn(
572             token,
573             abi.encodeWithSelector(
574                 token.approve.selector,
575                 spender,
576                 newAllowance
577             )
578         );
579     }
580 
581     /**
582      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
583      * on the return value: the return value is optional (but if data is returned, it must not be false).
584      * @param token The token targeted by the call.
585      * @param data The call data (encoded using abi.encode or one of its variants).
586      */
587     function _callOptionalReturn(IERC20 token, bytes memory data) private {
588         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
589         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
590         // the target address contains contract code and also asserts for success in the low-level call.
591 
592         bytes memory returndata = address(token).functionCall(
593             data,
594             'SafeERC20: low-level call failed'
595         );
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
670 // File: contracts/interfaces/IOracle.sol
671 
672 pragma solidity ^0.6.0;
673 
674 interface IOracle {
675     function update() external;
676 
677     function consult(address token, uint256 amountIn)
678         external
679         view
680         returns (uint256 amountOut);
681     // function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestamp);
682 }
683 
684 // File: contracts/interfaces/IBoardroom.sol
685 
686 pragma solidity ^0.6.0;
687 
688 interface IBoardroom {
689     function allocateSeigniorage(uint256 amount) external;
690 }
691 
692 // File: contracts/interfaces/IBasisAsset.sol
693 
694 pragma solidity ^0.6.0;
695 
696 interface IBasisAsset {
697     function mint(address recipient, uint256 amount) external returns (bool);
698 
699     function burn(uint256 amount) external;
700 
701     function burnFrom(address from, uint256 amount) external;
702 
703     function isOperator() external returns (bool);
704 
705     function operator() external view returns (address);
706 }
707 
708 // File: contracts/interfaces/ISimpleERCFund.sol
709 
710 pragma solidity ^0.6.0;
711 
712 interface ISimpleERCFund {
713     function deposit(
714         address token,
715         uint256 amount,
716         string memory reason
717     ) external;
718 
719     function withdraw(
720         address token,
721         uint256 amount,
722         address to,
723         string memory reason
724     ) external;
725 }
726 
727 // File: contracts/lib/Babylonian.sol
728 
729 pragma solidity ^0.6.0;
730 
731 library Babylonian {
732     function sqrt(uint256 y) internal pure returns (uint256 z) {
733         if (y > 3) {
734             z = y;
735             uint256 x = y / 2 + 1;
736             while (x < z) {
737                 z = x;
738                 x = (y / x + x) / 2;
739             }
740         } else if (y != 0) {
741             z = 1;
742         }
743         // else z = 0
744     }
745 }
746 
747 // File: contracts/lib/FixedPoint.sol
748 
749 pragma solidity ^0.6.0;
750 
751 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
752 library FixedPoint {
753     // range: [0, 2**112 - 1]
754     // resolution: 1 / 2**112
755     struct uq112x112 {
756         uint224 _x;
757     }
758 
759     // range: [0, 2**144 - 1]
760     // resolution: 1 / 2**112
761     struct uq144x112 {
762         uint256 _x;
763     }
764 
765     uint8 private constant RESOLUTION = 112;
766     uint256 private constant Q112 = uint256(1) << RESOLUTION;
767     uint256 private constant Q224 = Q112 << RESOLUTION;
768 
769     // encode a uint112 as a UQ112x112
770     function encode(uint112 x) internal pure returns (uq112x112 memory) {
771         return uq112x112(uint224(x) << RESOLUTION);
772     }
773 
774     // encodes a uint144 as a UQ144x112
775     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
776         return uq144x112(uint256(x) << RESOLUTION);
777     }
778 
779     // divide a UQ112x112 by a uint112, returning a UQ112x112
780     function div(uq112x112 memory self, uint112 x)
781         internal
782         pure
783         returns (uq112x112 memory)
784     {
785         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
786         return uq112x112(self._x / uint224(x));
787     }
788 
789     // multiply a UQ112x112 by a uint, returning a UQ144x112
790     // reverts on overflow
791     function mul(uq112x112 memory self, uint256 y)
792         internal
793         pure
794         returns (uq144x112 memory)
795     {
796         uint256 z;
797         require(
798             y == 0 || (z = uint256(self._x) * y) / y == uint256(self._x),
799             'FixedPoint: MULTIPLICATION_OVERFLOW'
800         );
801         return uq144x112(z);
802     }
803 
804     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
805     // equivalent to encode(numerator).div(denominator)
806     function fraction(uint112 numerator, uint112 denominator)
807         internal
808         pure
809         returns (uq112x112 memory)
810     {
811         require(denominator > 0, 'FixedPoint: DIV_BY_ZERO');
812         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
813     }
814 
815     // decode a UQ112x112 into a uint112 by truncating after the radix point
816     function decode(uq112x112 memory self) internal pure returns (uint112) {
817         return uint112(self._x >> RESOLUTION);
818     }
819 
820     // decode a UQ144x112 into a uint144 by truncating after the radix point
821     function decode144(uq144x112 memory self) internal pure returns (uint144) {
822         return uint144(self._x >> RESOLUTION);
823     }
824 
825     // take the reciprocal of a UQ112x112
826     function reciprocal(uq112x112 memory self)
827         internal
828         pure
829         returns (uq112x112 memory)
830     {
831         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
832         return uq112x112(uint224(Q224 / self._x));
833     }
834 
835     // square root of a UQ112x112
836     function sqrt(uq112x112 memory self)
837         internal
838         pure
839         returns (uq112x112 memory)
840     {
841         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));
842     }
843 }
844 
845 // File: contracts/lib/Safe112.sol
846 
847 pragma solidity ^0.6.0;
848 
849 library Safe112 {
850     function add(uint112 a, uint112 b) internal pure returns (uint256) {
851         uint256 c = a + b;
852         require(c >= a, 'Safe112: addition overflow');
853 
854         return c;
855     }
856 
857     function sub(uint112 a, uint112 b) internal pure returns (uint256) {
858         return sub(a, b, 'Safe112: subtraction overflow');
859     }
860 
861     function sub(
862         uint112 a,
863         uint112 b,
864         string memory errorMessage
865     ) internal pure returns (uint112) {
866         require(b <= a, errorMessage);
867         uint112 c = a - b;
868 
869         return c;
870     }
871 
872     function mul(uint112 a, uint112 b) internal pure returns (uint256) {
873         if (a == 0) {
874             return 0;
875         }
876 
877         uint256 c = a * b;
878         require(c / a == b, 'Safe112: multiplication overflow');
879 
880         return c;
881     }
882 
883     function div(uint112 a, uint112 b) internal pure returns (uint256) {
884         return div(a, b, 'Safe112: division by zero');
885     }
886 
887     function div(
888         uint112 a,
889         uint112 b,
890         string memory errorMessage
891     ) internal pure returns (uint112) {
892         // Solidity only automatically asserts when dividing by 0
893         require(b > 0, errorMessage);
894         uint112 c = a / b;
895 
896         return c;
897     }
898 
899     function mod(uint112 a, uint112 b) internal pure returns (uint256) {
900         return mod(a, b, 'Safe112: modulo by zero');
901     }
902 
903     function mod(
904         uint112 a,
905         uint112 b,
906         string memory errorMessage
907     ) internal pure returns (uint112) {
908         require(b != 0, errorMessage);
909         return a % b;
910     }
911 }
912 
913 // File: @openzeppelin/contracts/GSN/Context.sol
914 
915 pragma solidity ^0.6.0;
916 
917 /*
918  * @dev Provides information about the current execution context, including the
919  * sender of the transaction and its data. While these are generally available
920  * via msg.sender and msg.data, they should not be accessed in such a direct
921  * manner, since when dealing with GSN meta-transactions the account sending and
922  * paying for execution may not be the actual sender (as far as an application
923  * is concerned).
924  *
925  * This contract is only required for intermediate, library-like contracts.
926  */
927 abstract contract Context {
928     function _msgSender() internal virtual view returns (address payable) {
929         return msg.sender;
930     }
931 
932     function _msgData() internal virtual view returns (bytes memory) {
933         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
934         return msg.data;
935     }
936 }
937 
938 // File: @openzeppelin/contracts/access/Ownable.sol
939 
940 pragma solidity ^0.6.0;
941 
942 /**
943  * @dev Contract module which provides a basic access control mechanism, where
944  * there is an account (an owner) that can be granted exclusive access to
945  * specific functions.
946  *
947  * By default, the owner account will be the one that deploys the contract. This
948  * can later be changed with {transferOwnership}.
949  *
950  * This module is used through inheritance. It will make available the modifier
951  * `onlyOwner`, which can be applied to your functions to restrict their use to
952  * the owner.
953  */
954 contract Ownable is Context {
955     address private _owner;
956 
957     event OwnershipTransferred(
958         address indexed previousOwner,
959         address indexed newOwner
960     );
961 
962     /**
963      * @dev Initializes the contract setting the deployer as the initial owner.
964      */
965     constructor() internal {
966         address msgSender = _msgSender();
967         _owner = msgSender;
968         emit OwnershipTransferred(address(0), msgSender);
969     }
970 
971     /**
972      * @dev Returns the address of the current owner.
973      */
974     function owner() public view returns (address) {
975         return _owner;
976     }
977 
978     /**
979      * @dev Throws if called by any account other than the owner.
980      */
981     modifier onlyOwner() {
982         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
983         _;
984     }
985 
986     /**
987      * @dev Leaves the contract without owner. It will not be possible to call
988      * `onlyOwner` functions anymore. Can only be called by the current owner.
989      *
990      * NOTE: Renouncing ownership will leave the contract without an owner,
991      * thereby removing any functionality that is only available to the owner.
992      */
993     function renounceOwnership() public virtual onlyOwner {
994         emit OwnershipTransferred(_owner, address(0));
995         _owner = address(0);
996     }
997 
998     /**
999      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1000      * Can only be called by the current owner.
1001      */
1002     function transferOwnership(address newOwner) public virtual onlyOwner {
1003         require(
1004             newOwner != address(0),
1005             'Ownable: new owner is the zero address'
1006         );
1007         emit OwnershipTransferred(_owner, newOwner);
1008         _owner = newOwner;
1009     }
1010 }
1011 
1012 // File: contracts/owner/Operator.sol
1013 
1014 pragma solidity ^0.6.0;
1015 
1016 contract Operator is Context, Ownable {
1017     address private _operator;
1018 
1019     event OperatorTransferred(
1020         address indexed previousOperator,
1021         address indexed newOperator
1022     );
1023 
1024     constructor() internal {
1025         _operator = _msgSender();
1026         emit OperatorTransferred(address(0), _operator);
1027     }
1028 
1029     function operator() public view returns (address) {
1030         return _operator;
1031     }
1032 
1033     modifier onlyOperator() {
1034         require(
1035             _operator == msg.sender,
1036             'operator: caller is not the operator'
1037         );
1038         _;
1039     }
1040 
1041     function isOperator() public view returns (bool) {
1042         return _msgSender() == _operator;
1043     }
1044 
1045     function transferOperator(address newOperator_) public onlyOwner {
1046         _transferOperator(newOperator_);
1047     }
1048 
1049     function _transferOperator(address newOperator_) internal {
1050         require(
1051             newOperator_ != address(0),
1052             'operator: zero address given for new operator'
1053         );
1054         emit OperatorTransferred(address(0), newOperator_);
1055         _operator = newOperator_;
1056     }
1057 }
1058 
1059 // File: contracts/utils/Epoch.sol
1060 
1061 pragma solidity ^0.6.0;
1062 
1063 contract Epoch is Operator {
1064     using SafeMath for uint256;
1065 
1066     uint256 private period;
1067     uint256 private startTime;
1068     uint256 private epoch;
1069 
1070     /* ========== CONSTRUCTOR ========== */
1071 
1072     constructor(
1073         uint256 _period,
1074         uint256 _startTime,
1075         uint256 _startEpoch
1076     ) public {
1077         period = _period;
1078         startTime = _startTime;
1079         epoch = _startEpoch;
1080     }
1081 
1082     /* ========== Modifier ========== */
1083 
1084     modifier checkStartTime {
1085         require(now >= startTime, 'Epoch: not started yet');
1086 
1087         _;
1088     }
1089 
1090     modifier checkEpoch {
1091         require(now >= nextEpochPoint(), 'Epoch: not allowed');
1092 
1093         _;
1094 
1095         epoch = epoch.add(1);
1096     }
1097 
1098     /* ========== VIEW FUNCTIONS ========== */
1099 
1100     function getCurrentEpoch() public view returns (uint256) {
1101         return epoch;
1102     }
1103 
1104     function getPeriod() public view returns (uint256) {
1105         return period;
1106     }
1107 
1108     function getStartTime() public view returns (uint256) {
1109         return startTime;
1110     }
1111 
1112     function nextEpochPoint() public view returns (uint256) {
1113         return startTime.add(epoch.mul(period));
1114     }
1115 
1116     /* ========== GOVERNANCE ========== */
1117 
1118     function setPeriod(uint256 _period) external onlyOperator {
1119         period = _period;
1120     }
1121 }
1122 
1123 // File: contracts/utils/ContractGuard.sol
1124 
1125 pragma solidity ^0.6.12;
1126 
1127 contract ContractGuard {
1128     mapping(uint256 => mapping(address => bool)) private _status;
1129 
1130     function checkSameOriginReentranted() internal view returns (bool) {
1131         return _status[block.number][tx.origin];
1132     }
1133 
1134     function checkSameSenderReentranted() internal view returns (bool) {
1135         return _status[block.number][msg.sender];
1136     }
1137 
1138     modifier onlyOneBlock() {
1139         require(
1140             !checkSameOriginReentranted(),
1141             'ContractGuard: one block, one function'
1142         );
1143         require(
1144             !checkSameSenderReentranted(),
1145             'ContractGuard: one block, one function'
1146         );
1147 
1148         _;
1149 
1150         _status[block.number][tx.origin] = true;
1151         _status[block.number][msg.sender] = true;
1152     }
1153 }
1154 
1155 // File: contracts/Treasury.sol
1156 
1157 pragma solidity ^0.6.0;
1158 
1159 /**
1160  * @title Basis Cash Treasury contract
1161  * @notice Monetary policy logic to adjust supplies of basis cash assets
1162  * @author Summer Smith & Rick Sanchez
1163  */
1164 contract Treasury is ContractGuard, Epoch {
1165     using FixedPoint for *;
1166     using SafeERC20 for IERC20;
1167     using Address for address;
1168     using SafeMath for uint256;
1169     using Safe112 for uint112;
1170 
1171     /* ========== STATE VARIABLES ========== */
1172 
1173     // ========== FLAGS
1174     bool public migrated = false;
1175     bool public initialized = false;
1176 
1177     // ========== CORE
1178     address public fund;
1179     address public cash;
1180     address public bond;
1181     address public share;
1182     address public boardroom;
1183 
1184     address public bondOracle;
1185     address public seigniorageOracle;
1186 
1187     // ========== PARAMS
1188     uint256 public cashPriceOne;
1189     uint256 public cashPriceCeiling;
1190     uint256 public bondDepletionFloor;
1191     uint256 private accumulatedSeigniorage = 0;
1192     uint256 public fundAllocationRate = 2; // %
1193 
1194     /* ========== CONSTRUCTOR ========== */
1195 
1196     constructor(
1197         address _cash,
1198         address _bond,
1199         address _share,
1200         address _bondOracle,
1201         address _seigniorageOracle,
1202         address _boardroom,
1203         address _fund,
1204         uint256 _startTime
1205     ) public Epoch(1 days, _startTime, 0) {
1206         cash = _cash;
1207         bond = _bond;
1208         share = _share;
1209         bondOracle = _bondOracle;
1210         seigniorageOracle = _seigniorageOracle;
1211 
1212         boardroom = _boardroom;
1213         fund = _fund;
1214 
1215         cashPriceOne = 10**18;
1216         cashPriceCeiling = uint256(105).mul(cashPriceOne).div(10**2);
1217 
1218         bondDepletionFloor = uint256(1000).mul(cashPriceOne);
1219     }
1220 
1221     /* =================== Modifier =================== */
1222 
1223     modifier checkMigration {
1224         require(!migrated, 'Treasury: migrated');
1225 
1226         _;
1227     }
1228 
1229     modifier checkOperator {
1230         require(
1231             IBasisAsset(cash).operator() == address(this) &&
1232                 IBasisAsset(bond).operator() == address(this) &&
1233                 IBasisAsset(share).operator() == address(this) &&
1234                 Operator(boardroom).operator() == address(this),
1235             'Treasury: need more permission'
1236         );
1237 
1238         _;
1239     }
1240 
1241     /* ========== VIEW FUNCTIONS ========== */
1242 
1243     // budget
1244     function getReserve() public view returns (uint256) {
1245         return accumulatedSeigniorage;
1246     }
1247 
1248     // oracle
1249     function getBondOraclePrice() public view returns (uint256) {
1250         return _getCashPrice(bondOracle);
1251     }
1252 
1253     function getSeigniorageOraclePrice() public view returns (uint256) {
1254         return _getCashPrice(seigniorageOracle);
1255     }
1256 
1257     function _getCashPrice(address oracle) internal view returns (uint256) {
1258         try IOracle(oracle).consult(cash, 1e18) returns (uint256 price) {
1259             return price;
1260         } catch {
1261             revert('Treasury: failed to consult cash price from the oracle');
1262         }
1263     }
1264 
1265     /* ========== GOVERNANCE ========== */
1266 
1267     function initialize() public checkOperator {
1268         require(!initialized, 'Treasury: initialized');
1269 
1270         // burn all of it's balance
1271         IBasisAsset(cash).burn(IERC20(cash).balanceOf(address(this)));
1272 
1273         // set accumulatedSeigniorage to it's balance
1274         accumulatedSeigniorage = IERC20(cash).balanceOf(address(this));
1275 
1276         initialized = true;
1277         emit Initialized(msg.sender, block.number);
1278     }
1279 
1280     function migrate(address target) public onlyOperator checkOperator {
1281         require(!migrated, 'Treasury: migrated');
1282 
1283         // cash
1284         Operator(cash).transferOperator(target);
1285         Operator(cash).transferOwnership(target);
1286         IERC20(cash).transfer(target, IERC20(cash).balanceOf(address(this)));
1287 
1288         // bond
1289         Operator(bond).transferOperator(target);
1290         Operator(bond).transferOwnership(target);
1291         IERC20(bond).transfer(target, IERC20(bond).balanceOf(address(this)));
1292 
1293         // share
1294         Operator(share).transferOperator(target);
1295         Operator(share).transferOwnership(target);
1296         IERC20(share).transfer(target, IERC20(share).balanceOf(address(this)));
1297 
1298         migrated = true;
1299         emit Migration(target);
1300     }
1301 
1302     function setFund(address newFund) public onlyOperator {
1303         fund = newFund;
1304         emit ContributionPoolChanged(msg.sender, newFund);
1305     }
1306 
1307     function setFundAllocationRate(uint256 rate) public onlyOperator {
1308         fundAllocationRate = rate;
1309         emit ContributionPoolRateChanged(msg.sender, rate);
1310     }
1311 
1312     /* ========== MUTABLE FUNCTIONS ========== */
1313 
1314     function _updateCashPrice() internal {
1315         try IOracle(bondOracle).update()  {} catch {}
1316         try IOracle(seigniorageOracle).update()  {} catch {}
1317     }
1318 
1319     function buyBonds(uint256 amount, uint256 targetPrice)
1320         external
1321         onlyOneBlock
1322         checkMigration
1323         checkStartTime
1324         checkOperator
1325     {
1326         require(amount > 0, 'Treasury: cannot purchase bonds with zero amount');
1327 
1328         uint256 cashPrice = _getCashPrice(bondOracle);
1329         require(cashPrice == targetPrice, 'Treasury: cash price moved');
1330         require(
1331             cashPrice < cashPriceOne, // price < $1
1332             'Treasury: cashPrice not eligible for bond purchase'
1333         );
1334 
1335         uint256 bondPrice = cashPrice;
1336 
1337         IBasisAsset(cash).burnFrom(msg.sender, amount);
1338         IBasisAsset(bond).mint(msg.sender, amount.mul(1e18).div(bondPrice));
1339         _updateCashPrice();
1340 
1341         emit BoughtBonds(msg.sender, amount);
1342     }
1343 
1344     function redeemBonds(uint256 amount, uint256 targetPrice)
1345         external
1346         onlyOneBlock
1347         checkMigration
1348         checkStartTime
1349         checkOperator
1350     {
1351         require(amount > 0, 'Treasury: cannot redeem bonds with zero amount');
1352 
1353         uint256 cashPrice = _getCashPrice(bondOracle);
1354         require(cashPrice == targetPrice, 'Treasury: cash price moved');
1355         require(
1356             cashPrice > cashPriceCeiling, // price > $1.05
1357             'Treasury: cashPrice not eligible for bond purchase'
1358         );
1359         require(
1360             IERC20(cash).balanceOf(address(this)) >= amount,
1361             'Treasury: treasury has no more budget'
1362         );
1363 
1364         accumulatedSeigniorage = accumulatedSeigniorage.sub(
1365             Math.min(accumulatedSeigniorage, amount)
1366         );
1367 
1368         IBasisAsset(bond).burnFrom(msg.sender, amount);
1369         IERC20(cash).safeTransfer(msg.sender, amount);
1370         _updateCashPrice();
1371 
1372         emit RedeemedBonds(msg.sender, amount);
1373     }
1374 
1375     function allocateSeigniorage()
1376         external
1377         onlyOneBlock
1378         checkMigration
1379         checkStartTime
1380         checkEpoch
1381         checkOperator
1382     {
1383         _updateCashPrice();
1384         uint256 cashPrice = _getCashPrice(seigniorageOracle);
1385         if (cashPrice <= cashPriceCeiling) {
1386             return; // just advance epoch instead revert
1387         }
1388 
1389         // circulating supply
1390         uint256 cashSupply = IERC20(cash).totalSupply().sub(
1391             accumulatedSeigniorage
1392         );
1393         uint256 percentage = cashPrice.sub(cashPriceOne);
1394         uint256 seigniorage = cashSupply.mul(percentage).div(1e18);
1395         IBasisAsset(cash).mint(address(this), seigniorage);
1396 
1397         // ======================== BIP-3
1398         uint256 fundReserve = seigniorage.mul(fundAllocationRate).div(100);
1399         if (fundReserve > 0) {
1400             IERC20(cash).safeApprove(fund, fundReserve);
1401             ISimpleERCFund(fund).deposit(
1402                 cash,
1403                 fundReserve,
1404                 'Treasury: Seigniorage Allocation'
1405             );
1406             emit ContributionPoolFunded(now, fundReserve);
1407         }
1408 
1409         seigniorage = seigniorage.sub(fundReserve);
1410 
1411         // ======================== BIP-4
1412         uint256 treasuryReserve = Math.min(
1413             seigniorage,
1414             IERC20(bond).totalSupply().sub(accumulatedSeigniorage)
1415         );
1416         if (treasuryReserve > 0) {
1417             accumulatedSeigniorage = accumulatedSeigniorage.add(
1418                 treasuryReserve
1419             );
1420             emit TreasuryFunded(now, treasuryReserve);
1421         }
1422 
1423         // boardroom
1424         uint256 boardroomReserve = seigniorage.sub(treasuryReserve);
1425         if (boardroomReserve > 0) {
1426             IERC20(cash).safeApprove(boardroom, boardroomReserve);
1427             IBoardroom(boardroom).allocateSeigniorage(boardroomReserve);
1428             emit BoardroomFunded(now, boardroomReserve);
1429         }
1430     }
1431 
1432     // GOV
1433     event Initialized(address indexed executor, uint256 at);
1434     event Migration(address indexed target);
1435     event ContributionPoolChanged(address indexed operator, address newFund);
1436     event ContributionPoolRateChanged(
1437         address indexed operator,
1438         uint256 newRate
1439     );
1440 
1441     // CORE
1442     event RedeemedBonds(address indexed from, uint256 amount);
1443     event BoughtBonds(address indexed from, uint256 amount);
1444     event TreasuryFunded(uint256 timestamp, uint256 seigniorage);
1445     event BoardroomFunded(uint256 timestamp, uint256 seigniorage);
1446     event ContributionPoolFunded(uint256 timestamp, uint256 seigniorage);
1447 }