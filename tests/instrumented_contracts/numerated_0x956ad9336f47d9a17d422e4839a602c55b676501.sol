1 // SPDX-License-Identifier: Unlicensed
2 // Inspired by https://reflect.finance/
3 pragma solidity 0.8.13;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(
48         uint256 a,
49         uint256 b,
50         string memory errorMessage
51     ) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54 
55         return c;
56     }
57 
58     /**
59      * @dev Returns the multiplication of two unsigned integers, reverting on
60      * overflow.
61      *
62      * Counterpart to Solidity's `*` operator.
63      *
64      * Requirements:
65      *
66      * - Multiplication cannot overflow.
67      */
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
70         // benefit is lost if 'b' is also tested.
71         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
72         if (a == 0) {
73             return 0;
74         }
75 
76         uint256 c = a * b;
77         require(c / a == b, "SafeMath: multiplication overflow");
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the integer division of two unsigned integers. Reverts on
84      * division by zero. The result is rounded towards zero.
85      *
86      * Counterpart to Solidity's `/` operator. Note: this function uses a
87      * `revert` opcode (which leaves remaining gas untouched) while Solidity
88      * uses an invalid opcode to revert (consuming all remaining gas).
89      *
90      * Requirements:
91      *
92      * - The divisor cannot be zero.
93      */
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     /**
99      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
100      * division by zero. The result is rounded towards zero.
101      *
102      * Counterpart to Solidity's `/` operator. Note: this function uses a
103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
104      * uses an invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      *
108      * - The divisor cannot be zero.
109      */
110     function div(
111         uint256 a,
112         uint256 b,
113         string memory errorMessage
114     ) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135         return mod(a, b, "SafeMath: modulo by zero");
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts with custom message when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(
151         uint256 a,
152         uint256 b,
153         string memory errorMessage
154     ) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 abstract contract Context {
161     function _msgSender() internal view virtual returns (address) {
162         return msg.sender;
163     }
164 
165     function _msgData() internal view virtual returns (bytes calldata) {
166         return msg.data;
167     }
168 }
169 
170 library Address {
171     /**
172      * @dev Returns true if `account` is a contract.
173      *
174      * [IMPORTANT]
175      * ====
176      * It is unsafe to assume that an address for which this function returns
177      * false is an externally-owned account (EOA) and not a contract.
178      *
179      * Among others, `isContract` will return false for the following
180      * types of addresses:
181      *
182      *  - an externally-owned account
183      *  - a contract in construction
184      *  - an address where a contract will be created
185      *  - an address where a contract lived, but was destroyed
186      * ====
187      */
188     function isContract(address account) internal view returns (bool) {
189         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
190         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
191         // for accounts without code, i.e. `keccak256('')`
192         bytes32 codehash;
193         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
194         // solhint-disable-next-line no-inline-assembly
195         assembly {
196             codehash := extcodehash(account)
197         }
198         return (codehash != accountHash && codehash != 0x0);
199     }
200 
201     /**
202      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
203      * `recipient`, forwarding all available gas and reverting on errors.
204      *
205      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
206      * of certain opcodes, possibly making contracts go over the 2300 gas limit
207      * imposed by `transfer`, making them unable to receive funds via
208      * `transfer`. {sendValue} removes this limitation.
209      *
210      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
211      *
212      * IMPORTANT: because control is transferred to `recipient`, care must be
213      * taken to not create reentrancy vulnerabilities. Consider using
214      * {ReentrancyGuard} or the
215      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
216      */
217     function sendValue(address payable recipient, uint256 amount) internal {
218         require(
219             address(this).balance >= amount,
220             "Address: insufficient balance"
221         );
222 
223         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
224         (bool success, ) = recipient.call{value: amount}("");
225         require(
226             success,
227             "Address: unable to send value, recipient may have reverted"
228         );
229     }
230 
231     /**
232      * @dev Performs a Solidity function call using a low level `call`. A
233      * plain`call` is an unsafe replacement for a function call: use this
234      * function instead.
235      *
236      * If `target` reverts with a revert reason, it is bubbled up by this
237      * function (like regular Solidity function calls).
238      *
239      * Returns the raw returned data. To convert to the expected return value,
240      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
241      *
242      * Requirements:
243      *
244      * - `target` must be a contract.
245      * - calling `target` with `data` must not revert.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(address target, bytes memory data)
250         internal
251         returns (bytes memory)
252     {
253         return functionCall(target, data, "Address: low-level call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
258      * `errorMessage` as a fallback revert reason when `target` reverts.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         return _functionCallWithValue(target, data, 0, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but also transferring `value` wei to `target`.
273      *
274      * Requirements:
275      *
276      * - the calling contract must have an ETH balance of at least `value`.
277      * - the called Solidity function must be `payable`.
278      *
279      * _Available since v3.1._
280      */
281     function functionCallWithValue(
282         address target,
283         bytes memory data,
284         uint256 value
285     ) internal returns (bytes memory) {
286         return
287             functionCallWithValue(
288                 target,
289                 data,
290                 value,
291                 "Address: low-level call with value failed"
292             );
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
297      * with `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(
308             address(this).balance >= value,
309             "Address: insufficient balance for call"
310         );
311         return _functionCallWithValue(target, data, value, errorMessage);
312     }
313 
314     function _functionCallWithValue(
315         address target,
316         bytes memory data,
317         uint256 weiValue,
318         string memory errorMessage
319     ) private returns (bytes memory) {
320         require(isContract(target), "Address: call to non-contract");
321 
322         // solhint-disable-next-line avoid-low-level-calls
323         (bool success, bytes memory returndata) = target.call{value: weiValue}(
324             data
325         );
326         if (success) {
327             return returndata;
328         } else {
329             // Look for revert reason and bubble it up if present
330             if (returndata.length > 0) {
331                 // The easiest way to bubble the revert reason is using memory via assembly
332 
333                 // solhint-disable-next-line no-inline-assembly
334                 assembly {
335                     let returndata_size := mload(returndata)
336                     revert(add(32, returndata), returndata_size)
337                 }
338             } else {
339                 revert(errorMessage);
340             }
341         }
342     }
343 }
344 
345 interface IERC20 {
346     function totalSupply() external view returns (uint256);
347 
348     function balanceOf(address account) external view returns (uint256);
349 
350     function transfer(address recipient, uint256 amount)
351         external
352         returns (bool);
353 
354     function allowance(address owner, address spender)
355         external
356         view
357         returns (uint256);
358 
359     function approve(address spender, uint256 amount) external returns (bool);
360 
361     function transferFrom(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) external returns (bool);
366 
367     event Transfer(address indexed from, address indexed to, uint256 value);
368     event Approval(
369         address indexed owner,
370         address indexed spender,
371         uint256 value
372     );
373 }
374 
375 /**
376  * @dev Contract module which provides a basic access control mechanism, where
377  * there is an account (an owner) that can be granted exclusive access to
378  * specific functions.
379  *
380  * By default, the owner account will be the one that deploys the contract. This
381  * can later be changed with {transferOwnership}.
382  *
383  * This module is used through inheritance. It will make available the modifier
384  * `onlyOwner`, which can be applied to your functions to restrict their use to
385  * the owner.
386  */
387 abstract contract Ownable is Context {
388     address private _owner;
389 
390     event OwnershipTransferred(
391         address indexed previousOwner,
392         address indexed newOwner
393     );
394 
395     /**
396      * @dev Initializes the contract setting the deployer as the initial owner.
397      */
398     constructor() {
399         _transferOwnership(_msgSender());
400     }
401 
402     /**
403      * @dev Returns the address of the current owner.
404      */
405     function owner() public view virtual returns (address) {
406         return _owner;
407     }
408 
409     /**
410      * @dev Throws if called by any account other than the owner.
411      */
412     modifier onlyOwner() {
413         require(owner() == _msgSender(), "Ownable: caller is not the owner");
414         _;
415     }
416 
417     /**
418      * @dev Leaves the contract without owner. It will not be possible to call
419      * `onlyOwner` functions anymore. Can only be called by the current owner.
420      *
421      * NOTE: Renouncing ownership will leave the contract without an owner,
422      * thereby removing any functionality that is only available to the owner.
423      */
424     function renounceOwnership() public virtual onlyOwner {
425         _transferOwnership(address(0));
426     }
427 
428     /**
429      * @dev Transfers ownership of the contract to a new account (`newOwner`).
430      * Can only be called by the current owner.
431      */
432     function transferOwnership(address newOwner) public virtual onlyOwner {
433         require(
434             newOwner != address(0),
435             "Ownable: new owner is the zero address"
436         );
437         _transferOwnership(newOwner);
438     }
439 
440     /**
441      * @dev Transfers ownership of the contract to a new account (`newOwner`).
442      * Internal function without access restriction.
443      */
444     function _transferOwnership(address newOwner) internal virtual {
445         address oldOwner = _owner;
446         _owner = newOwner;
447         emit OwnershipTransferred(oldOwner, newOwner);
448     }
449 }
450 
451 /**
452  * @dev Contract module that helps prevent reentrant calls to a function.
453  *
454  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
455  * available, which can be applied to functions to make sure there are no nested
456  * (reentrant) calls to them.
457  *
458  * Note that because there is a single `nonReentrant` guard, functions marked as
459  * `nonReentrant` may not call one another. This can be worked around by making
460  * those functions `private`, and then adding `external` `nonReentrant` entry
461  * points to them.
462  *
463  * TIP: If you would like to learn more about reentrancy and alternative ways
464  * to protect against it, check out our blog post
465  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
466  */
467 abstract contract ReentrancyGuard {
468     // Booleans are more expensive than uint256 or any type that takes up a full
469     // word because each write operation emits an extra SLOAD to first read the
470     // slot's contents, replace the bits taken up by the boolean, and then write
471     // back. This is the compiler's defense against contract upgrades and
472     // pointer aliasing, and it cannot be disabled.
473 
474     // The values being non-zero value makes deployment a bit more expensive,
475     // but in exchange the refund on every call to nonReentrant will be lower in
476     // amount. Since refunds are capped to a percentage of the total
477     // transaction's gas, it is best to keep them low in cases like this one, to
478     // increase the likelihood of the full refund coming into effect.
479     uint256 private constant _NOT_ENTERED = 1;
480     uint256 private constant _ENTERED = 2;
481 
482     uint256 private _status;
483 
484     constructor() {
485         _status = _NOT_ENTERED;
486     }
487 
488     /**
489      * @dev Prevents a contract from calling itself, directly or indirectly.
490      * Calling a `nonReentrant` function from another `nonReentrant`
491      * function is not supported. It is possible to prevent this from happening
492      * by making the `nonReentrant` function external, and making it call a
493      * `private` function that does the actual work.
494      */
495     modifier nonReentrant() {
496         // On the first call to nonReentrant, _notEntered will be true
497         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
498 
499         // Any calls to nonReentrant after this point will fail
500         _status = _ENTERED;
501 
502         _;
503 
504         // By storing the original value once again, a refund is triggered (see
505         // https://eips.ethereum.org/EIPS/eip-2200)
506         _status = _NOT_ENTERED;
507     }
508 }
509 
510 interface IUniswapV2Router01 {
511     function factory() external pure returns (address);
512 
513     function WETH() external pure returns (address);
514 
515     function addLiquidity(
516         address tokenA,
517         address tokenB,
518         uint256 amountADesired,
519         uint256 amountBDesired,
520         uint256 amountAMin,
521         uint256 amountBMin,
522         address to,
523         uint256 deadline
524     )
525         external
526         returns (
527             uint256 amountA,
528             uint256 amountB,
529             uint256 liquidity
530         );
531 
532     function addLiquidityETH(
533         address token,
534         uint256 amountTokenDesired,
535         uint256 amountTokenMin,
536         uint256 amountETHMin,
537         address to,
538         uint256 deadline
539     )
540         external
541         payable
542         returns (
543             uint256 amountToken,
544             uint256 amountETH,
545             uint256 liquidity
546         );
547 
548     function removeLiquidity(
549         address tokenA,
550         address tokenB,
551         uint256 liquidity,
552         uint256 amountAMin,
553         uint256 amountBMin,
554         address to,
555         uint256 deadline
556     ) external returns (uint256 amountA, uint256 amountB);
557 
558     function removeLiquidityETH(
559         address token,
560         uint256 liquidity,
561         uint256 amountTokenMin,
562         uint256 amountETHMin,
563         address to,
564         uint256 deadline
565     ) external returns (uint256 amountToken, uint256 amountETH);
566 
567     function removeLiquidityWithPermit(
568         address tokenA,
569         address tokenB,
570         uint256 liquidity,
571         uint256 amountAMin,
572         uint256 amountBMin,
573         address to,
574         uint256 deadline,
575         bool approveMax,
576         uint8 v,
577         bytes32 r,
578         bytes32 s
579     ) external returns (uint256 amountA, uint256 amountB);
580 
581     function removeLiquidityETHWithPermit(
582         address token,
583         uint256 liquidity,
584         uint256 amountTokenMin,
585         uint256 amountETHMin,
586         address to,
587         uint256 deadline,
588         bool approveMax,
589         uint8 v,
590         bytes32 r,
591         bytes32 s
592     ) external returns (uint256 amountToken, uint256 amountETH);
593 
594     function swapExactTokensForTokens(
595         uint256 amountIn,
596         uint256 amountOutMin,
597         address[] calldata path,
598         address to,
599         uint256 deadline
600     ) external returns (uint256[] memory amounts);
601 
602     function swapTokensForExactTokens(
603         uint256 amountOut,
604         uint256 amountInMax,
605         address[] calldata path,
606         address to,
607         uint256 deadline
608     ) external returns (uint256[] memory amounts);
609 
610     function swapExactETHForTokens(
611         uint256 amountOutMin,
612         address[] calldata path,
613         address to,
614         uint256 deadline
615     ) external payable returns (uint256[] memory amounts);
616 
617     function swapTokensForExactETH(
618         uint256 amountOut,
619         uint256 amountInMax,
620         address[] calldata path,
621         address to,
622         uint256 deadline
623     ) external returns (uint256[] memory amounts);
624 
625     function swapExactTokensForETH(
626         uint256 amountIn,
627         uint256 amountOutMin,
628         address[] calldata path,
629         address to,
630         uint256 deadline
631     ) external returns (uint256[] memory amounts);
632 
633     function swapETHForExactTokens(
634         uint256 amountOut,
635         address[] calldata path,
636         address to,
637         uint256 deadline
638     ) external payable returns (uint256[] memory amounts);
639 
640     function quote(
641         uint256 amountA,
642         uint256 reserveA,
643         uint256 reserveB
644     ) external pure returns (uint256 amountB);
645 
646     function getAmountOut(
647         uint256 amountIn,
648         uint256 reserveIn,
649         uint256 reserveOut
650     ) external pure returns (uint256 amountOut);
651 
652     function getAmountIn(
653         uint256 amountOut,
654         uint256 reserveIn,
655         uint256 reserveOut
656     ) external pure returns (uint256 amountIn);
657 
658     function getAmountsOut(uint256 amountIn, address[] calldata path)
659         external
660         view
661         returns (uint256[] memory amounts);
662 
663     function getAmountsIn(uint256 amountOut, address[] calldata path)
664         external
665         view
666         returns (uint256[] memory amounts);
667 }
668 
669 interface IUniswapV2Router02 is IUniswapV2Router01 {
670     function removeLiquidityETHSupportingFeeOnTransferTokens(
671         address token,
672         uint256 liquidity,
673         uint256 amountTokenMin,
674         uint256 amountETHMin,
675         address to,
676         uint256 deadline
677     ) external returns (uint256 amountETH);
678 
679     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
680         address token,
681         uint256 liquidity,
682         uint256 amountTokenMin,
683         uint256 amountETHMin,
684         address to,
685         uint256 deadline,
686         bool approveMax,
687         uint8 v,
688         bytes32 r,
689         bytes32 s
690     ) external returns (uint256 amountETH);
691 
692     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
693         uint256 amountIn,
694         uint256 amountOutMin,
695         address[] calldata path,
696         address to,
697         uint256 deadline
698     ) external;
699 
700     function swapExactETHForTokensSupportingFeeOnTransferTokens(
701         uint256 amountOutMin,
702         address[] calldata path,
703         address to,
704         uint256 deadline
705     ) external payable;
706 
707     function swapExactTokensForETHSupportingFeeOnTransferTokens(
708         uint256 amountIn,
709         uint256 amountOutMin,
710         address[] calldata path,
711         address to,
712         uint256 deadline
713     ) external;
714 }
715 
716 interface IUniswapV2Factory {
717     event PairCreated(
718         address indexed token0,
719         address indexed token1,
720         address pair,
721         uint256
722     );
723 
724     function feeTo() external view returns (address);
725 
726     function feeToSetter() external view returns (address);
727 
728     function getPair(address tokenA, address tokenB)
729         external
730         view
731         returns (address pair);
732 
733     function allPairs(uint256) external view returns (address pair);
734 
735     function allPairsLength() external view returns (uint256);
736 
737     function createPair(address tokenA, address tokenB)
738         external
739         returns (address pair);
740 
741     function setFeeTo(address) external;
742 
743     function setFeeToSetter(address) external;
744 }
745 
746 interface IUniswapV2Pair {
747     event Approval(
748         address indexed owner,
749         address indexed spender,
750         uint256 value
751     );
752     event Transfer(address indexed from, address indexed to, uint256 value);
753 
754     function name() external pure returns (string memory);
755 
756     function symbol() external pure returns (string memory);
757 
758     function decimals() external pure returns (uint8);
759 
760     function totalSupply() external view returns (uint256);
761 
762     function balanceOf(address owner) external view returns (uint256);
763 
764     function allowance(address owner, address spender)
765         external
766         view
767         returns (uint256);
768 
769     function approve(address spender, uint256 value) external returns (bool);
770 
771     function transfer(address to, uint256 value) external returns (bool);
772 
773     function transferFrom(
774         address from,
775         address to,
776         uint256 value
777     ) external returns (bool);
778 
779     function DOMAIN_SEPARATOR() external view returns (bytes32);
780 
781     function PERMIT_TYPEHASH() external pure returns (bytes32);
782 
783     function nonces(address owner) external view returns (uint256);
784 
785     function permit(
786         address owner,
787         address spender,
788         uint256 value,
789         uint256 deadline,
790         uint8 v,
791         bytes32 r,
792         bytes32 s
793     ) external;
794 
795     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
796     event Burn(
797         address indexed sender,
798         uint256 amount0,
799         uint256 amount1,
800         address indexed to
801     );
802     event Swap(
803         address indexed sender,
804         uint256 amount0In,
805         uint256 amount1In,
806         uint256 amount0Out,
807         uint256 amount1Out,
808         address indexed to
809     );
810     event Sync(uint112 reserve0, uint112 reserve1);
811 
812     function MINIMUM_LIQUIDITY() external pure returns (uint256);
813 
814     function factory() external view returns (address);
815 
816     function token0() external view returns (address);
817 
818     function token1() external view returns (address);
819 
820     function getReserves()
821         external
822         view
823         returns (
824             uint112 reserve0,
825             uint112 reserve1,
826             uint32 blockTimestampLast
827         );
828 
829     function price0CumulativeLast() external view returns (uint256);
830 
831     function price1CumulativeLast() external view returns (uint256);
832 
833     function kLast() external view returns (uint256);
834 
835     function mint(address to) external returns (uint256 liquidity);
836 
837     function burn(address to)
838         external
839         returns (uint256 amount0, uint256 amount1);
840 
841     function swap(
842         uint256 amount0Out,
843         uint256 amount1Out,
844         address to,
845         bytes calldata data
846     ) external;
847 
848     function skim(address to) external;
849 
850     function sync() external;
851 
852     function initialize(address, address) external;
853 }
854 
855 contract Amm0x is Context, IERC20, Ownable, ReentrancyGuard {
856     using SafeMath for uint256;
857     using Address for address;
858 
859     struct Fees {
860         uint256 reflectFee;
861         uint256 liquidityFee;
862         uint256 burnFee;
863         uint256 teamFee;
864        
865     }
866 
867     IUniswapV2Router02 public immutable uniswapV2Router;
868     // Pancake V2 Router 0x10ED43C718714eb63d5aA57B78B54704E256024E;
869     // Uniswap V2 Router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
870 
871     mapping(address => uint256) private _rOwned;
872     mapping(address => uint256) private _tOwned;
873     mapping(address => mapping(address => uint256)) private _allowances;
874     mapping(address => bool) private _isExcludedFromFee;
875     mapping(address => bool) private _isExcluded;
876     
877     address[] private _excluded;
878 
879     address private constant deadWallet =
880         0x000000000000000000000000000000000000dEaD;
881     address public teamWallet;
882     
883     
884 
885     uint256 private constant MAX = ~uint256(0);
886     uint256 private constant _tTotal = 2 * 10**8 * 10**18; //200 million
887     uint256 private _rTotal = (MAX - (MAX % _tTotal));
888     uint256 private _tFeeTotal;
889     uint256 private whaleLimit = _rTotal.div(100);
890 
891     string private constant _name = "Amm0x Token";
892     string private constant _symbol = "Amm0x";
893     uint8 private constant _decimals = 18;
894 
895     uint256 private _reflectionFee = 2;
896     uint256 private _liquidityTax = 2;
897     uint256 private _burningFee = 2;
898     uint256 private _teamTax = 2;
899     
900 
901     event SwapAndLiquify(uint256, uint256, uint256, uint256);
902 
903     event ExcludeAccount(address);
904     event IncludeAccount(address);
905     event ChangeFees(uint256);
906     event ExcludeFromFee(address);
907     event IncludeInFee(address);
908     event EmergencyWithdraw(uint256);
909     
910 
911     constructor(
912         address _router,
913         address _teamWallet
914         
915     ) {
916         uniswapV2Router = IUniswapV2Router02(_router);
917         teamWallet = _teamWallet;
918        
919         _rOwned[owner()] = _rTotal;
920         _isExcludedFromFee[owner()] = true;
921         _isExcludedFromFee[address(this)] = true;
922         _isExcludedFromFee[_router] = true;
923 
924         emit Transfer(address(0), owner(), _tTotal);
925     }
926 
927     function name() external pure returns (string memory) {
928         return _name;
929     }
930 
931     function symbol() external pure returns (string memory) {
932         return _symbol;
933     }
934 
935     function decimals() external pure returns (uint8) {
936         return _decimals;
937     }
938 
939     function totalSupply() external pure override returns (uint256) {
940         return _tTotal;
941     }
942 
943     function balanceOf(address account) public view override returns (uint256) {
944         if (_isExcluded[account]) return _tOwned[account];
945         return tokenFromReflection(_rOwned[account]);
946     }
947 
948     function transfer(address recipient, uint256 amount)
949         external
950         override
951         returns (bool)
952     {
953         _transfer(_msgSender(), recipient, amount);
954         return true;
955     }
956 
957     function allowance(address owner, address spender)
958         external
959         view
960         override
961         returns (uint256)
962     {
963         return _allowances[owner][spender];
964     }
965 
966     function approve(address spender, uint256 amount)
967         external
968         override
969         returns (bool)
970     {
971         _approve(_msgSender(), spender, amount);
972         return true;
973     }
974 
975     function transferFrom(
976         address sender,
977         address recipient,
978         uint256 amount
979     ) external override returns (bool) {
980         _transfer(sender, recipient, amount);
981         _approve(
982             sender,
983             _msgSender(),
984             _allowances[sender][_msgSender()].sub(
985                 amount,
986                 "ERC20: transfer amount exceeds allowance"
987             )
988         );
989         return true;
990     }
991 
992     function increaseAllowance(address spender, uint256 addedValue)
993         external
994         virtual
995         returns (bool)
996     {
997         _approve(
998             _msgSender(),
999             spender,
1000             _allowances[_msgSender()][spender].add(addedValue)
1001         );
1002         return true;
1003     }
1004 
1005     function decreaseAllowance(address spender, uint256 subtractedValue)
1006         external
1007         virtual
1008         returns (bool)
1009     {
1010         _approve(
1011             _msgSender(),
1012             spender,
1013             _allowances[_msgSender()][spender].sub(
1014                 subtractedValue,
1015                 "ERC20: decreased allowance below zero"
1016             )
1017         );
1018         return true;
1019     }
1020 
1021     function isExcluded(address account) external view returns (bool) {
1022         return _isExcluded[account];
1023     }
1024 
1025     function totalFees() external view returns (uint256) {
1026         return _tFeeTotal;
1027     }
1028 
1029     function reflect(uint256 tAmount) external {
1030         address sender = _msgSender();
1031         require(
1032             !_isExcluded[sender],
1033             "Excluded addresses cannot call this function"
1034         );
1035         (uint256 rAmount, , , , ) = _getValues(tAmount);
1036         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1037         _rTotal = _rTotal.sub(rAmount);
1038         _tFeeTotal = _tFeeTotal.add(tAmount);
1039     }
1040 
1041     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1042         external
1043         view
1044         returns (uint256)
1045     {
1046         require(tAmount <= _tTotal, "Amount must be less than supply");
1047         if (!deductTransferFee) {
1048             (uint256 rAmount, , , , ) = _getValues(tAmount);
1049             return rAmount;
1050         } else {
1051             (, uint256 rTransferAmount, , , ) = _getValues(tAmount);
1052             return rTransferAmount;
1053         }
1054     }
1055 
1056     function tokenFromReflection(uint256 rAmount)
1057         public
1058         view
1059         returns (uint256)
1060     {
1061         require(
1062             rAmount <= _rTotal,
1063             "Amount must be less than total reflections"
1064         );
1065         uint256 currentRate = _getRate();
1066         return rAmount.div(currentRate);
1067     }
1068 
1069     function excludeAccount(address account) external onlyOwner {
1070         require(!_isExcluded[account], "Account is already excluded");
1071         if (_rOwned[account] > 0) {
1072             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1073         }
1074         _isExcluded[account] = true;
1075         _excluded.push(account);
1076         emit ExcludeAccount(account);
1077     }
1078 
1079     function includeAccount(address account) external onlyOwner {
1080         require(_isExcluded[account], "Account is not excluded");
1081         for (uint256 i = 0; i < _excluded.length; i++) {
1082             if (_excluded[i] == account) {
1083                 _excluded[i] = _excluded[_excluded.length - 1];
1084                 _tOwned[account] = 0;
1085                 _isExcluded[account] = false;
1086                 _excluded.pop();
1087                 break;
1088             }
1089         }
1090         emit IncludeAccount(account);
1091     }
1092 
1093     function _approve(
1094         address owner,
1095         address spender,
1096         uint256 amount
1097     ) private {
1098         require(owner != address(0), "ERC20: approve from the zero address");
1099         require(spender != address(0), "ERC20: approve to the zero address");
1100 
1101         _allowances[owner][spender] = amount;
1102         emit Approval(owner, spender, amount);
1103     }
1104 
1105     function _transfer(
1106         address sender,
1107         address recipient,
1108         uint256 amount
1109     ) private {
1110         require(sender != address(0), "ERC20: transfer from the zero address");
1111         require(recipient != address(0), "ERC20: transfer to the zero address");
1112         require(amount > 0, "Transfer amount must be greater than zero");
1113         uint256 currentReflectionFee = _reflectionFee;
1114         uint256 currentLiquidityFee = _liquidityTax;
1115         uint256 currentBurnFee = _burningFee;
1116         uint256 currentTeamFee = _teamTax;
1117         
1118 
1119         if (sender != owner()) {
1120             require(
1121                 amount + balanceOf(recipient) <= whaleLimit,
1122                 "Transfer amount exceeds whaleLimit."
1123             );
1124         }
1125 
1126         
1127         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
1128             _reflectionFee = 0;
1129             _liquidityTax = 0;
1130             _burningFee = 0;
1131             _teamTax = 0;
1132             
1133         }
1134 
1135         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1136             _transferFromExcluded(sender, recipient, amount);
1137         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1138             _transferToExcluded(sender, recipient, amount);
1139         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1140             _transferBothExcluded(sender, recipient, amount);
1141         } else {
1142             _transferStandard(sender, recipient, amount);
1143         }
1144 
1145         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
1146             _reflectionFee = currentReflectionFee;
1147             _liquidityTax = currentLiquidityFee;
1148             _burningFee = currentBurnFee;
1149             _teamTax = currentTeamFee;
1150             
1151         }
1152     }
1153 
1154     function _transferStandard(
1155         address sender,
1156         address recipient,
1157         uint256 tAmount
1158     ) private {
1159         (
1160             uint256 rAmount,
1161             uint256 rTransferAmount,
1162             Fees memory rFees,
1163             uint256 tTransferAmount,
1164             Fees memory tFees
1165         ) = _getValues(tAmount);
1166         
1167         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1168         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1169         _reflectFee(rFees.reflectFee, tFees.reflectFee);
1170         _liquidityFee(rFees.liquidityFee, tFees.liquidityFee);
1171         _burnFee(rFees.burnFee, tFees.burnFee);
1172         _teamFee(rFees.teamFee, tFees.teamFee);
1173         emit Transfer(sender, recipient, tTransferAmount);
1174     }
1175 
1176     function _transferToExcluded(
1177         address sender,
1178         address recipient,
1179         uint256 tAmount
1180     ) private {
1181         (
1182             uint256 rAmount,
1183             uint256 rTransferAmount,
1184             Fees memory rFees,
1185             uint256 tTransferAmount,
1186             Fees memory tFees
1187         ) = _getValues(tAmount);
1188         
1189         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1190         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1191         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1192         _reflectFee(rFees.reflectFee, tFees.reflectFee);
1193         _liquidityFee(rFees.liquidityFee, tFees.liquidityFee);
1194         _burnFee(rFees.burnFee, tFees.burnFee);
1195         _teamFee(rFees.teamFee, tFees.teamFee);
1196         emit Transfer(sender, recipient, tTransferAmount);
1197     }
1198 
1199     function _transferFromExcluded(
1200         address sender,
1201         address recipient,
1202         uint256 tAmount
1203     ) private {
1204         (
1205             uint256 rAmount,
1206             uint256 rTransferAmount,
1207             Fees memory rFees,
1208             uint256 tTransferAmount,
1209             Fees memory tFees
1210         ) = _getValues(tAmount);
1211         
1212         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1213         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1214         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1215         _reflectFee(rFees.reflectFee, tFees.reflectFee);
1216         _liquidityFee(rFees.liquidityFee, tFees.liquidityFee);
1217         _burnFee(rFees.burnFee, tFees.burnFee);
1218         _teamFee(rFees.teamFee, tFees.teamFee);
1219         emit Transfer(sender, recipient, tTransferAmount);
1220     }
1221 
1222     function _transferBothExcluded(
1223         address sender,
1224         address recipient,
1225         uint256 tAmount
1226     ) private {
1227         (
1228             uint256 rAmount,
1229             uint256 rTransferAmount,
1230             Fees memory rFees,
1231             uint256 tTransferAmount,
1232             Fees memory tFees
1233         ) = _getValues(tAmount);
1234         
1235         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1236         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1237         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1238         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1239         _reflectFee(rFees.reflectFee, tFees.reflectFee);
1240         _liquidityFee(rFees.liquidityFee, tFees.liquidityFee);
1241         _burnFee(rFees.burnFee, tFees.burnFee);
1242         _teamFee(rFees.teamFee, tFees.teamFee);
1243         emit Transfer(sender, recipient, tTransferAmount);
1244     }
1245 
1246     function _reflectFee(uint256 rReflectFee, uint256 tReflectFee) private {
1247         _rTotal = _rTotal.sub(rReflectFee);
1248         _tFeeTotal = _tFeeTotal.add(tReflectFee);
1249     }
1250 
1251     function _liquidityFee(uint256 rLiquidityFee, uint256 tLiquidityFee)
1252         private
1253     {
1254         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidityFee);
1255         if (_isExcluded[address(this)])
1256             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidityFee);
1257     }
1258 
1259     function _burnFee(uint256 rBurnFee, uint256 tBurnFee) private {
1260         _rOwned[address(this)] = _rOwned[address(this)].add(rBurnFee);
1261         if (_isExcluded[address(this)])
1262             _tOwned[address(this)] = _tOwned[address(this)].add(tBurnFee);
1263     }
1264 
1265     function _teamFee(uint256 rTeamFee, uint256 tTeamFee) private {
1266         _rOwned[address(this)] = _rOwned[address(this)].add(rTeamFee);
1267         if (_isExcluded[address(this)])
1268             _tOwned[address(this)] = _tOwned[address(this)].add(tTeamFee);
1269     }
1270 
1271    
1272 
1273     function _getValues(uint256 tAmount)
1274         private
1275         view
1276         returns (
1277             uint256,
1278             uint256,
1279             Fees memory,
1280             uint256,
1281             Fees memory
1282         )
1283     {
1284         (uint256 tTransferAmount, Fees memory tFees) = _getTValues(tAmount);
1285         uint256 currentRate = _getRate();
1286         (
1287             uint256 rAmount,
1288             uint256 rTransferAmount,
1289             Fees memory rFees
1290         ) = _getRValues(tAmount, tFees, currentRate);
1291         return (rAmount, rTransferAmount, rFees, tTransferAmount, tFees);
1292     }
1293 
1294     function _getTValues(uint256 tAmount)
1295         private
1296         view
1297         returns (uint256, Fees memory)
1298     {
1299         Fees memory tFees;
1300         tFees.reflectFee = tAmount.mul(_reflectionFee).div(100);
1301         tFees.liquidityFee = tAmount.mul(_liquidityTax).div(100);
1302         tFees.burnFee = tAmount.mul(_burningFee).div(100);
1303         tFees.teamFee = tAmount.mul(_teamTax).div(100);
1304     
1305         uint256 tTransferAmount = tAmount
1306             .sub(tFees.reflectFee)
1307             .sub(tFees.liquidityFee)
1308             .sub(tFees.burnFee)
1309             .sub(tFees.teamFee);
1310            
1311         return (tTransferAmount, tFees);
1312     }
1313 
1314     function _getRValues(
1315         uint256 tAmount,
1316         Fees memory tFees,
1317         uint256 currentRate
1318     )
1319         private
1320         pure
1321         returns (
1322             uint256,
1323             uint256,
1324             Fees memory
1325         )
1326     {
1327         Fees memory rFees;
1328         uint256 rAmount = tAmount.mul(currentRate);
1329         rFees.reflectFee = tFees.reflectFee.mul(currentRate);
1330         rFees.liquidityFee = tFees.liquidityFee.mul(currentRate);
1331         rFees.burnFee = tFees.burnFee.mul(currentRate);
1332         rFees.teamFee = tFees.teamFee.mul(currentRate);
1333         
1334         uint256 rTransferAmount = rAmount
1335             .sub(rFees.reflectFee)
1336             .sub(rFees.liquidityFee)
1337             .sub(rFees.burnFee)
1338             .sub(rFees.teamFee);
1339             
1340         return (rAmount, rTransferAmount, rFees);
1341     }
1342 
1343     function _getRate() private view returns (uint256) {
1344         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1345         return rSupply.div(tSupply);
1346     }
1347 
1348     function _getCurrentSupply() private view returns (uint256, uint256) {
1349         uint256 rSupply = _rTotal;
1350         uint256 tSupply = _tTotal;
1351         for (uint256 i = 0; i < _excluded.length; i++) {
1352             if (
1353                 _rOwned[_excluded[i]] > rSupply ||
1354                 _tOwned[_excluded[i]] > tSupply
1355             ) return (_rTotal, _tTotal);
1356             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1357             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1358         }
1359         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1360         return (rSupply, tSupply);
1361     }
1362 
1363     function reflectionFee() external view returns (uint256) {
1364         return _reflectionFee;
1365     }
1366 
1367     function changeFees(
1368         uint256 _newReflectionFee,
1369         uint256 _newLiquidityFee,
1370         uint256 _newBurnFee,
1371         uint256 _newTeamFee
1372         
1373     ) external onlyOwner returns (bool) {
1374         uint256 totalFee = _newReflectionFee
1375             .add(_newLiquidityFee)
1376             .add(_newBurnFee)
1377             .add(_newTeamFee);
1378         require(totalFee <= 15, "max fee limit exceeded");
1379         _reflectionFee = _newReflectionFee;
1380         _liquidityTax = _newLiquidityFee;
1381         _burningFee = _newBurnFee;
1382         _teamTax = _newTeamFee;
1383         
1384         emit ChangeFees(totalFee);
1385         return true;
1386     }
1387 
1388     function liquidityFee() public view returns (uint256) {
1389         return _liquidityTax;
1390     }
1391 
1392     function burningFee() public view returns (uint256) {
1393         return _burningFee;
1394     }
1395 
1396     function teamFee() public view returns (uint256) {
1397         return _teamTax;
1398     }
1399 
1400     
1401 
1402     function excludeFromFee(address account) external onlyOwner returns (bool) {
1403         require(account != address(0), "ERC20: account is the zero address");
1404         _isExcludedFromFee[account] = true;
1405         emit ExcludeFromFee(account);
1406         return true;
1407     }
1408 
1409     function includeInFee(address account) external onlyOwner returns (bool) {
1410         require(account != address(0), "ERC20: account is the zero address");
1411         _isExcludedFromFee[account] = false;
1412         emit IncludeInFee(account);
1413         return true;
1414     }
1415 
1416     function swapAndLiquify() external nonReentrant onlyOwner returns (bool) {
1417         uint256 balanceInContract = balanceOf(address(this));
1418         uint256 half = balanceInContract.div(2);
1419         uint256 otherHalf = balanceInContract.sub(half);
1420         uint256 initialBalance = address(this).balance;
1421         uint256 lf = liquidityFee();
1422         uint256 bf = burningFee();
1423         uint256 tf = teamFee();
1424        
1425 
1426         uint256 denominator = lf + bf + tf;
1427 
1428         uint256 liquidityAmount = half.mul(lf).div(denominator);
1429         uint256 burnAmount = half.mul(bf).div(denominator);
1430         uint256 teamAmount = half.mul(tf).div(denominator);
1431        
1432         emit SwapAndLiquify(
1433             half,
1434             liquidityAmount,
1435             burnAmount,
1436             teamAmount
1437             
1438         );
1439         swapTokensForEth(liquidityAmount);
1440 
1441         uint256 newBalance = address(this).balance.sub(initialBalance);
1442 
1443         addLiquidity(otherHalf, newBalance);
1444 
1445         if (teamAmount > 0) {
1446             _sendTeam(teamAmount);
1447         }
1448 
1449         if (burnAmount > 0) {
1450             _burn(burnAmount);
1451         }
1452 
1453 
1454         return true;
1455     }
1456 
1457     function calculateLiquidity() external view returns (uint256) {
1458         uint256 balanceInContract = balanceOf(address(this));
1459         uint256 lf = liquidityFee();
1460         uint256 bf = burningFee();
1461         uint256 tf = teamFee();
1462 
1463         uint256 denominator = lf + bf + tf;
1464 
1465         return balanceInContract.mul(lf).div(denominator);
1466     }
1467 
1468     function swapTokensForEth(uint256 tokenAmount) private {
1469         address[] memory path = new address[](2);
1470         path[0] = address(this);
1471         path[1] = uniswapV2Router.WETH();
1472         _approve(address(this), address(uniswapV2Router), tokenAmount);
1473         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1474             tokenAmount,
1475             0,
1476             path,
1477             address(this),
1478             block.timestamp
1479         );
1480     }
1481 
1482     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1483         // approve token transfer to cover all possible scenarios
1484         _approve(address(this), address(uniswapV2Router), tokenAmount);
1485 
1486         // add the liquidity
1487         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1488             address(this),
1489             tokenAmount,
1490             0, // slippage is unavoidable
1491             0, // slippage is unavoidable
1492             owner(),
1493             block.timestamp
1494         );
1495     }
1496 
1497     function _burn(uint256 burnAmount) internal {
1498         _transfer(address(this), deadWallet, burnAmount);
1499         emit Transfer(address(this), deadWallet, burnAmount);
1500     }
1501 
1502     function _sendTeam(uint256 teamAmount) internal {
1503         _transfer(address(this), teamWallet, teamAmount);
1504         emit Transfer(address(this), teamWallet, teamAmount);
1505     }
1506 
1507     
1508 
1509     function setTeamWallet(address _newAddress) external onlyOwner {
1510         teamWallet = _newAddress;
1511     }
1512 
1513     
1514 
1515     
1516 
1517     function emergencyWithdraw() external nonReentrant onlyOwner {
1518         uint256 ethBalance = address(this).balance;
1519         (bool success, ) = payable(owner()).call{value: ethBalance}("");
1520         require(success, "Transfer failed!");
1521 
1522         emit EmergencyWithdraw(ethBalance);
1523 
1524 
1525 
1526     }
1527 
1528     receive() external payable {}
1529 }