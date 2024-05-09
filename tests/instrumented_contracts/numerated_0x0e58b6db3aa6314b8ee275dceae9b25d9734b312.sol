1 /*
2 Website - https://www.smash-cryptocoin.com
3 Telegram - https://t.me/smashcryptocoin
4 Twitter - https://twitter.com/smashcryptocoin
5 
6 */
7 // SPDX-License-Identifier: Unlicensed
8 pragma solidity ^0.8.10;
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount)
26         external
27         returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender)
37         external
38         view
39         returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(
60         address sender,
61         address recipient,
62         uint256 amount
63     ) external returns (bool);
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
77     event Approval(
78         address indexed owner,
79         address indexed spender,
80         uint256 value
81     );
82 }
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 
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
140     function sub(
141         uint256 a,
142         uint256 b,
143         string memory errorMessage
144     ) internal pure returns (uint256) {
145         require(b <= a, errorMessage);
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `*` operator.
156      *
157      * Requirements:
158      *
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162 
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
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(
198         uint256 a,
199         uint256 b,
200         string memory errorMessage
201     ) internal pure returns (uint256) {
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
237     function mod(
238         uint256 a,
239         uint256 b,
240         string memory errorMessage
241     ) internal pure returns (uint256) {
242         require(b != 0, errorMessage);
243         return a % b;
244     }
245 }
246 
247 abstract contract Context {
248     function _msgSender() internal view virtual returns (address payable) {
249         return payable(msg.sender);
250     }
251 
252     function _msgData() internal view virtual returns (bytes memory) {
253         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
254         return msg.data;
255     }
256 }
257 
258 /**
259  * @dev Collection of functions related to the address type
260  */
261 library Address {
262     /**
263      * @dev Returns true if `account` is a contract.
264      *
265      * [IMPORTANT]
266      * ====
267      * It is unsafe to assume that an address for which this function returns
268      * false is an externally-owned account (EOA) and not a contract.
269      *
270      * Among others, `isContract` will return false for the following
271      * types of addresses:
272      *
273      *  - an externally-owned account
274      *  - a contract in construction
275      *  - an address where a contract will be created
276      *  - an address where a contract lived, but was destroyed
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
281         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
282         // for accounts without code, i.e. `keccak256('')`
283         bytes32 codehash;
284         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
285         // solhint-disable-next-line no-inline-assembly
286         assembly {
287             codehash := extcodehash(account)
288         }
289         return (codehash != accountHash && codehash != 0x0);
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(
298             address(this).balance >= amount,
299             "Address: insufficient balance"
300         );
301 
302         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
303         (bool success, ) = recipient.call{value: amount}("");
304         require(
305             success,
306             "Address: unable to send value, recipient may have reverted"
307         );
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain`call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data)
329         internal
330         returns (bytes memory)
331     {
332         return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337      * `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(
342         address target,
343         bytes memory data,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         return _functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(
361         address target,
362         bytes memory data,
363         uint256 value
364     ) internal returns (bytes memory) {
365         return
366             functionCallWithValue(
367                 target,
368                 data,
369                 value,
370                 "Address: low-level call with value failed"
371             );
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
376      * with `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 value,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         require(
387             address(this).balance >= value,
388             "Address: insufficient balance for call"
389         );
390         return _functionCallWithValue(target, data, value, errorMessage);
391     }
392 
393     function _functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 weiValue,
397         string memory errorMessage
398     ) private returns (bytes memory) {
399         require(isContract(target), "Address: call to non-contract");
400 
401         // solhint-disable-next-line avoid-low-level-calls
402         (bool success, bytes memory returndata) = target.call{value: weiValue}(
403             data
404         );
405         if (success) {
406             return returndata;
407         } else {
408             // Look for revert reason and bubble it up if present
409             if (returndata.length > 0) {
410                 // The easiest way to bubble the revert reason is using memory via assembly
411 
412                 // solhint-disable-next-line no-inline-assembly
413                 assembly {
414                     let returndata_size := mload(returndata)
415                     revert(add(32, returndata), returndata_size)
416                 }
417             } else {
418                 revert(errorMessage);
419             }
420         }
421     }
422 }
423 
424 /**
425  * @dev Contract module which provides a basic access control mechanism, where
426  * there is an account (an owner) that can be granted exclusive access to
427  * specific functions.
428  *
429  * By default, the owner account will be the one that deploys the contract. This
430  * can later be changed with {transferOwnership}.
431  *
432  * This module is used through inheritance. It will make available the modifier
433  * `onlyOwner`, which can be applied to your functions to restrict their use to
434  * the owner.
435  */
436 contract Ownable is Context {
437     address private _owner;
438     address private _previousOwner;
439 
440 
441     event OwnershipTransferred(
442         address indexed previousOwner,
443         address indexed newOwner
444     );
445 
446     /**
447      * @dev Initializes the contract setting the deployer as the initial owner.
448      */
449     constructor() {
450         address msgSender = _msgSender();
451         _owner = msgSender;
452         emit OwnershipTransferred(address(0), msgSender);
453     }
454 
455     /**
456      * @dev Returns the address of the current owner.
457      */
458     function owner() public view returns (address) {
459         return _owner;
460     }
461 
462     /**
463      * @dev Throws if called by any account other than the owner.
464      */
465     modifier onlyOwner() {
466         require(_owner == _msgSender(), "Ownable: caller is not the owner");
467         _;
468     }
469 
470     /**
471      * @dev Leaves the contract without owner. It will not be possible to call
472      * `onlyOwner` functions anymore. Can only be called by the current owner.
473      *
474      * NOTE: Renouncing ownership will leave the contract without an owner,
475      * thereby removing any functionality that is only available to the owner.
476      */
477     function renounceOwnership() public virtual onlyOwner {
478         emit OwnershipTransferred(_owner, address(0));
479         _owner = address(0);
480     }
481 
482     /**
483      * @dev Transfers ownership of the contract to a new account (`newOwner`).
484      * Can only be called by the current owner.
485      */
486     function transferOwnership(address newOwner) public virtual onlyOwner {
487         require(
488             newOwner != address(0),
489             "Ownable: new owner is the zero address"
490         );
491         emit OwnershipTransferred(_owner, newOwner);
492         _owner = newOwner;
493     }
494 
495 }
496 
497 interface IUniswapV2Factory {
498     event PairCreated(
499         address indexed token0,
500         address indexed token1,
501         address pair,
502         uint256
503     );
504 
505     function feeTo() external view returns (address);
506 
507     function feeToSetter() external view returns (address);
508 
509     function getPair(address tokenA, address tokenB)
510         external
511         view
512         returns (address pair);
513 
514     function allPairs(uint256) external view returns (address pair);
515 
516     function allPairsLength() external view returns (uint256);
517 
518     function createPair(address tokenA, address tokenB)
519         external
520         returns (address pair);
521 
522     function setFeeTo(address) external;
523 
524     function setFeeToSetter(address) external;
525 }
526 
527 interface IUniswapV2Pair {
528     event Approval(
529         address indexed owner,
530         address indexed spender,
531         uint256 value
532     );
533     event Transfer(address indexed from, address indexed to, uint256 value);
534 
535     function name() external pure returns (string memory);
536 
537     function symbol() external pure returns (string memory);
538 
539     function decimals() external pure returns (uint8);
540 
541     function totalSupply() external view returns (uint256);
542 
543     function balanceOf(address owner) external view returns (uint256);
544 
545     function allowance(address owner, address spender)
546         external
547         view
548         returns (uint256);
549 
550     function approve(address spender, uint256 value) external returns (bool);
551 
552     function transfer(address to, uint256 value) external returns (bool);
553 
554     function transferFrom(
555         address from,
556         address to,
557         uint256 value
558     ) external returns (bool);
559 
560     function DOMAIN_SEPARATOR() external view returns (bytes32);
561 
562     function PERMIT_TYPEHASH() external pure returns (bytes32);
563 
564     function nonces(address owner) external view returns (uint256);
565 
566     function permit(
567         address owner,
568         address spender,
569         uint256 value,
570         uint256 deadline,
571         uint8 v,
572         bytes32 r,
573         bytes32 s
574     ) external;
575 
576     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
577     event Burn(
578         address indexed sender,
579         uint256 amount0,
580         uint256 amount1,
581         address indexed to
582     );
583     event Swap(
584         address indexed sender,
585         uint256 amount0In,
586         uint256 amount1In,
587         uint256 amount0Out,
588         uint256 amount1Out,
589         address indexed to
590     );
591     event Sync(uint112 reserve0, uint112 reserve1);
592 
593     function MINIMUM_LIQUIDITY() external pure returns (uint256);
594 
595     function factory() external view returns (address);
596 
597     function token0() external view returns (address);
598 
599     function token1() external view returns (address);
600 
601     function getReserves()
602         external
603         view
604         returns (
605             uint112 reserve0,
606             uint112 reserve1,
607             uint32 blockTimestampLast
608         );
609 
610     function price0CumulativeLast() external view returns (uint256);
611 
612     function price1CumulativeLast() external view returns (uint256);
613 
614     function kLast() external view returns (uint256);
615 
616     function mint(address to) external returns (uint256 liquidity);
617 
618     function burn(address to)
619         external
620         returns (uint256 amount0, uint256 amount1);
621 
622     function swap(
623         uint256 amount0Out,
624         uint256 amount1Out,
625         address to,
626         bytes calldata data
627     ) external;
628 
629     function skim(address to) external;
630 
631     function sync() external;
632 
633     function initialize(address, address) external;
634 }
635 
636 interface IUniswapV2Router01 {
637     function factory() external pure returns (address);
638 
639     function WETH() external pure returns (address);
640 
641     function addLiquidity(
642         address tokenA,
643         address tokenB,
644         uint256 amountADesired,
645         uint256 amountBDesired,
646         uint256 amountAMin,
647         uint256 amountBMin,
648         address to,
649         uint256 deadline
650     )
651         external
652         returns (
653             uint256 amountA,
654             uint256 amountB,
655             uint256 liquidity
656         );
657 
658     function addLiquidityETH(
659         address token,
660         uint256 amountTokenDesired,
661         uint256 amountTokenMin,
662         uint256 amountETHMin,
663         address to,
664         uint256 deadline
665     )
666         external
667         payable
668         returns (
669             uint256 amountToken,
670             uint256 amountETH,
671             uint256 liquidity
672         );
673 
674     function removeLiquidity(
675         address tokenA,
676         address tokenB,
677         uint256 liquidity,
678         uint256 amountAMin,
679         uint256 amountBMin,
680         address to,
681         uint256 deadline
682     ) external returns (uint256 amountA, uint256 amountB);
683 
684     function removeLiquidityETH(
685         address token,
686         uint256 liquidity,
687         uint256 amountTokenMin,
688         uint256 amountETHMin,
689         address to,
690         uint256 deadline
691     ) external returns (uint256 amountToken, uint256 amountETH);
692 
693     function removeLiquidityWithPermit(
694         address tokenA,
695         address tokenB,
696         uint256 liquidity,
697         uint256 amountAMin,
698         uint256 amountBMin,
699         address to,
700         uint256 deadline,
701         bool approveMax,
702         uint8 v,
703         bytes32 r,
704         bytes32 s
705     ) external returns (uint256 amountA, uint256 amountB);
706 
707     function removeLiquidityETHWithPermit(
708         address token,
709         uint256 liquidity,
710         uint256 amountTokenMin,
711         uint256 amountETHMin,
712         address to,
713         uint256 deadline,
714         bool approveMax,
715         uint8 v,
716         bytes32 r,
717         bytes32 s
718     ) external returns (uint256 amountToken, uint256 amountETH);
719 
720     function swapExactTokensForTokens(
721         uint256 amountIn,
722         uint256 amountOutMin,
723         address[] calldata path,
724         address to,
725         uint256 deadline
726     ) external returns (uint256[] memory amounts);
727 
728     function swapTokensForExactTokens(
729         uint256 amountOut,
730         uint256 amountInMax,
731         address[] calldata path,
732         address to,
733         uint256 deadline
734     ) external returns (uint256[] memory amounts);
735 
736     function swapExactETHForTokens(
737         uint256 amountOutMin,
738         address[] calldata path,
739         address to,
740         uint256 deadline
741     ) external payable returns (uint256[] memory amounts);
742 
743     function swapTokensForExactETH(
744         uint256 amountOut,
745         uint256 amountInMax,
746         address[] calldata path,
747         address to,
748         uint256 deadline
749     ) external returns (uint256[] memory amounts);
750 
751     function swapExactTokensForETH(
752         uint256 amountIn,
753         uint256 amountOutMin,
754         address[] calldata path,
755         address to,
756         uint256 deadline
757     ) external returns (uint256[] memory amounts);
758 
759     function swapETHForExactTokens(
760         uint256 amountOut,
761         address[] calldata path,
762         address to,
763         uint256 deadline
764     ) external payable returns (uint256[] memory amounts);
765 
766     function quote(
767         uint256 amountA,
768         uint256 reserveA,
769         uint256 reserveB
770     ) external pure returns (uint256 amountB);
771 
772     function getAmountOut(
773         uint256 amountIn,
774         uint256 reserveIn,
775         uint256 reserveOut
776     ) external pure returns (uint256 amountOut);
777 
778     function getAmountIn(
779         uint256 amountOut,
780         uint256 reserveIn,
781         uint256 reserveOut
782     ) external pure returns (uint256 amountIn);
783 
784     function getAmountsOut(uint256 amountIn, address[] calldata path)
785         external
786         view
787         returns (uint256[] memory amounts);
788 
789     function getAmountsIn(uint256 amountOut, address[] calldata path)
790         external
791         view
792         returns (uint256[] memory amounts);
793 }
794 
795 interface IUniswapV2Router02 is IUniswapV2Router01 {
796     function removeLiquidityETHSupportingFeeOnTransferTokens(
797         address token,
798         uint256 liquidity,
799         uint256 amountTokenMin,
800         uint256 amountETHMin,
801         address to,
802         uint256 deadline
803     ) external returns (uint256 amountETH);
804 
805     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
806         address token,
807         uint256 liquidity,
808         uint256 amountTokenMin,
809         uint256 amountETHMin,
810         address to,
811         uint256 deadline,
812         bool approveMax,
813         uint8 v,
814         bytes32 r,
815         bytes32 s
816     ) external returns (uint256 amountETH);
817 
818     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
819         uint256 amountIn,
820         uint256 amountOutMin,
821         address[] calldata path,
822         address to,
823         uint256 deadline
824     ) external;
825 
826     function swapExactETHForTokensSupportingFeeOnTransferTokens(
827         uint256 amountOutMin,
828         address[] calldata path,
829         address to,
830         uint256 deadline
831     ) external payable;
832 
833     function swapExactTokensForETHSupportingFeeOnTransferTokens(
834         uint256 amountIn,
835         uint256 amountOutMin,
836         address[] calldata path,
837         address to,
838         uint256 deadline
839     ) external;
840 }
841 
842 contract SMASHCOIN is Context, IERC20, Ownable {
843     using SafeMath for uint256;
844     using Address for address;
845 
846     mapping(address => uint256) private _rOwned;
847     mapping(address => uint256) private _tOwned;
848     mapping(address => mapping(address => uint256)) private _allowances;
849 
850     mapping(address => bool) private _isExcludedFromFee;
851 
852     mapping(address => bool) private _isExcluded;
853     address[] private _excluded;
854 
855     mapping(address => bool) private _isExcludedFromLimit;
856 
857     uint256 private constant MAX = ~uint256(0);
858     uint256 private _tTotal = 500000000 * 10**9;
859     uint256 private _rTotal = (MAX - (MAX % _tTotal));
860     uint256 private _tFeeTotal;
861 
862     address payable public _marketingAddress = payable(address(0x678B0621Cfa5BC2087f0c6A6a69BaBa51D8ff22d));
863     address private _burnAddress = 0x000000000000000000000000000000000000dEaD;
864 
865     string private _name = "SMASHCOIN";
866     string private _symbol = "$SMASH";
867     uint8 private _decimals = 9;
868 
869     struct BuyFee {
870         uint8 reflection;
871         uint8 liquidity;
872         uint8 marketing;
873         uint8 burn;
874     }
875 
876     struct SellFee {
877         uint8 reflection;
878         uint8 liquidity;
879         uint8 marketing;
880         uint8 burn;
881     }
882 
883     BuyFee public buyFee;
884     SellFee public sellFee;
885 
886     uint8 private _reflectionFee;
887     uint8 private _liquidityFee;
888     uint8 private _marketingFee;
889     uint8 private _burnFee;
890 
891     IUniswapV2Router02 public immutable uniswapV2Router;
892     address public immutable uniswapV2Pair;
893 
894     bool inSwapAndLiquify;
895     bool public swapAndLiquifyEnabled = true;
896 
897     uint256 public _maxTxAmount = _tTotal.div(1000).mul(1); //0.1%
898     uint256 private numTokensSellToAddToLiquidity = _tTotal.div(1000).mul(1); //0.1%
899     uint256 public _maxWalletSize = _tTotal.div(1000).mul(3); // 1.5%
900 
901     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
902     event SwapAndLiquifyEnabledUpdated(bool enabled);
903     event SwapAndLiquify(
904         uint256 tokensSwapped,
905         uint256 ethReceived,
906         uint256 tokensIntoLiqudity
907     );
908 
909     modifier lockTheSwap() {
910         inSwapAndLiquify = true;
911         _;
912         inSwapAndLiquify = false;
913     }
914 
915     uint256 public deadBlocks = 2;
916     uint256 public launchedAt = 0;
917     bool tradingOpen = false;
918 
919     mapping (address => uint256) public _lastTrade;
920 
921     constructor() {
922         _rOwned[_msgSender()] = _rTotal;
923 
924         buyFee.reflection = 1;
925         buyFee.liquidity = 2;
926         buyFee.marketing = 6;
927         buyFee.burn = 1;
928 
929         sellFee.reflection = 1;
930         sellFee.liquidity = 6;
931         sellFee.marketing = 92;
932         sellFee.burn = 1;
933 
934         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02( 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D  );
935         // Create a uniswap pair for this new token
936         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
937 
938         // set the rest of the contract variables
939         uniswapV2Router = _uniswapV2Router;
940 
941         // exclude owner, and this contract from fee
942         _isExcludedFromFee[owner()] = true;
943         _isExcludedFromFee[address(this)] = true;
944         _isExcludedFromFee[_marketingAddress] = true;
945 
946         _isExcludedFromLimit[_marketingAddress] = true;
947         _isExcludedFromLimit[owner()] = true;
948         _isExcludedFromLimit[address(this)] = true;
949 
950         emit Transfer(address(0), _msgSender(), _tTotal);
951     }
952 
953     function name() public view returns (string memory) {
954         return _name;
955     }
956 
957     function symbol() public view returns (string memory) {
958         return _symbol;
959     }
960 
961     function decimals() public view returns (uint8) {
962         return _decimals;
963     }
964 
965     function totalSupply() public view override returns (uint256) {
966         return _tTotal;
967     }
968 
969     function balanceOf(address account) public view override returns (uint256) {
970         if (_isExcluded[account]) return _tOwned[account];
971         return tokenFromReflection(_rOwned[account]);
972     }
973 
974     function transfer(address recipient, uint256 amount)
975         public
976         override
977         returns (bool)
978     {
979         _transfer(_msgSender(), recipient, amount);
980         return true;
981     }
982 
983     function allowance(address owner, address spender)
984         public
985         view
986         override
987         returns (uint256)
988     {
989         return _allowances[owner][spender];
990     }
991 
992     function approve(address spender, uint256 amount)
993         public
994         override
995         returns (bool)
996     {
997         _approve(_msgSender(), spender, amount);
998         return true;
999     }
1000 
1001     function transferFrom(
1002         address sender,
1003         address recipient,
1004         uint256 amount
1005     ) public override returns (bool) {
1006         _transfer(sender, recipient, amount);
1007         _approve(
1008             sender,
1009             _msgSender(),
1010             _allowances[sender][_msgSender()].sub(
1011                 amount,
1012                 "ERC20: transfer amount exceeds allowance"
1013             )
1014         );
1015         return true;
1016     }
1017 
1018     function increaseAllowance(address spender, uint256 addedValue)
1019         public
1020         virtual
1021         returns (bool)
1022     {
1023         _approve(
1024             _msgSender(),
1025             spender,
1026             _allowances[_msgSender()][spender].add(addedValue)
1027         );
1028         return true;
1029     }
1030 
1031     function decreaseAllowance(address spender, uint256 subtractedValue)
1032         public
1033         virtual
1034         returns (bool)
1035     {
1036         _approve(
1037             _msgSender(),
1038             spender,
1039             _allowances[_msgSender()][spender].sub(
1040                 subtractedValue,
1041                 "ERC20: decreased allowance below zero"
1042             )
1043         );
1044         return true;
1045     }
1046 
1047     function isExcludedFromReward(address account) public view returns (bool) {
1048         return _isExcluded[account];
1049     }
1050 
1051     function totalFees() public view returns (uint256) {
1052         return _tFeeTotal;
1053     }
1054 
1055     function burnAddress() public view returns (address) {
1056         return _burnAddress;
1057     }
1058 
1059     function deliver(uint256 tAmount) public {
1060         address sender = _msgSender();
1061         require(
1062             !_isExcluded[sender],
1063             "Excluded addresses cannot call this function"
1064         );
1065 
1066         (
1067             ,
1068             uint256 tFee,
1069             uint256 tLiquidity,
1070             uint256 tWallet,
1071             uint256 tBurn
1072         ) = _getTValues(tAmount);
1073         (uint256 rAmount, , ) = _getRValues(
1074             tAmount,
1075             tFee,
1076             tLiquidity,
1077             tWallet,
1078             tBurn,
1079             _getRate()
1080         );
1081 
1082         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1083         _rTotal = _rTotal.sub(rAmount);
1084         _tFeeTotal = _tFeeTotal.add(tAmount);
1085     }
1086 
1087     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1088         public
1089         view
1090         returns (uint256)
1091     {
1092         require(tAmount <= _tTotal, "Amount must be less than supply");
1093 
1094         (
1095             ,
1096             uint256 tFee,
1097             uint256 tLiquidity,
1098             uint256 tWallet,
1099             uint256 tBurn
1100         ) = _getTValues(tAmount);
1101         (uint256 rAmount, uint256 rTransferAmount, ) = _getRValues(
1102             tAmount,
1103             tFee,
1104             tLiquidity,
1105             tWallet,
1106             tBurn,
1107             _getRate()
1108         );
1109 
1110         if (!deductTransferFee) {
1111             return rAmount;
1112         } else {
1113             return rTransferAmount;
1114         }
1115     }
1116 
1117     function tokenFromReflection(uint256 rAmount)
1118         public
1119         view
1120         returns (uint256)
1121     {
1122         require(
1123             rAmount <= _rTotal,
1124             "Amount must be less than total reflections"
1125         );
1126         uint256 currentRate = _getRate();
1127         return rAmount.div(currentRate);
1128     }
1129 
1130 
1131     function updateMarketingWallet(address payable newAddress) external onlyOwner {
1132         _marketingAddress = newAddress;
1133     }
1134 
1135     function excludeFromReward(address account) public onlyOwner {
1136         require(!_isExcluded[account], "Account is already excluded");
1137         if (_rOwned[account] > 0) {
1138             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1139         }
1140         _isExcluded[account] = true;
1141         _excluded.push(account);
1142     }
1143 
1144     function includeInReward(address account) external onlyOwner {
1145         require(_isExcluded[account], "Account is not excluded");
1146         for (uint256 i = 0; i < _excluded.length; i++) {
1147             if (_excluded[i] == account) {
1148                 _excluded[i] = _excluded[_excluded.length - 1];
1149                 _tOwned[account] = 0;
1150                 _isExcluded[account] = false;
1151                 _excluded.pop();
1152                 break;
1153             }
1154         }
1155     }
1156 
1157     function excludeFromFee(address account) public onlyOwner {
1158         _isExcludedFromFee[account] = true;
1159     }
1160 
1161     function includeInFee(address account) public onlyOwner {
1162         _isExcludedFromFee[account] = false;
1163     }
1164 
1165     function excludeFromLimit(address account) public onlyOwner {
1166         _isExcludedFromLimit[account] = true;
1167     }
1168 
1169     function includeInLimit(address account) public onlyOwner {
1170         _isExcludedFromLimit[account] = false;
1171     }
1172 
1173     function setSellFee(
1174         uint8 reflection,
1175         uint8 liquidity,
1176         uint8 marketing,
1177         uint8 burn
1178     ) external onlyOwner {
1179         sellFee.reflection = reflection;
1180         sellFee.marketing = marketing;
1181         sellFee.liquidity = liquidity;
1182         sellFee.burn = burn;
1183     }
1184 
1185     function setBuyFee(
1186         uint8 reflection,
1187         uint8 liquidity,
1188         uint8 marketing,
1189         uint8 burn
1190     ) external onlyOwner {
1191         buyFee.reflection = reflection;
1192         buyFee.marketing = marketing;
1193         buyFee.liquidity = liquidity;
1194         buyFee.burn = burn;
1195     }
1196 
1197     function setBothFees(
1198         uint8 buy_reflection,
1199         uint8 buy_liquidity,
1200         uint8 buy_marketing,
1201         uint8 buy_burn,
1202         uint8 sell_reflection,
1203         uint8 sell_liquidity,
1204         uint8 sell_marketing,
1205         uint8 sell_burn
1206 
1207     ) external onlyOwner {
1208         buyFee.reflection = buy_reflection;
1209         buyFee.marketing = buy_marketing;
1210         buyFee.liquidity = buy_liquidity;
1211         
1212         buyFee.burn = buy_burn;
1213 
1214         sellFee.reflection = sell_reflection;
1215         sellFee.marketing = sell_marketing;
1216         sellFee.liquidity = sell_liquidity;
1217   
1218         sellFee.burn = sell_burn;
1219     }
1220 
1221     function setNumTokensSellToAddToLiquidity(uint256 numTokens) external onlyOwner {
1222         numTokensSellToAddToLiquidity = numTokens;
1223     }
1224 
1225     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
1226         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**3);
1227     }
1228 
1229     function _setMaxWalletSizePercent(uint256 maxWalletSize)
1230         external
1231         onlyOwner
1232     {
1233         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
1234     }
1235 
1236     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1237         swapAndLiquifyEnabled = _enabled;
1238         emit SwapAndLiquifyEnabledUpdated(_enabled);
1239     }
1240 
1241     //to recieve ETH from uniswapV2Router when swapping
1242     receive() external payable {}
1243 
1244     function _reflectFee(uint256 rFee, uint256 tFee) private {
1245         _rTotal = _rTotal.sub(rFee);
1246         _tFeeTotal = _tFeeTotal.add(tFee);
1247     }
1248 
1249     function _getTValues(uint256 tAmount)
1250         private
1251         view
1252         returns (
1253             uint256,
1254             uint256,
1255             uint256,
1256             uint256,
1257             uint256
1258         )
1259     {
1260         uint256 tFee = calculateReflectionFee(tAmount);
1261         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1262         uint256 tWallet = calculateMarketingFee(tAmount);
1263         uint256 tBurn = calculateBurnFee(tAmount);
1264         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1265         tTransferAmount = tTransferAmount.sub(tWallet);
1266         tTransferAmount = tTransferAmount.sub(tBurn);
1267 
1268         return (tTransferAmount, tFee, tLiquidity, tWallet, tBurn);
1269     }
1270 
1271     function _getRValues(
1272         uint256 tAmount,
1273         uint256 tFee,
1274         uint256 tLiquidity,
1275         uint256 tWallet,
1276         uint256 tBurn,
1277         uint256 currentRate
1278     )
1279         private
1280         pure
1281         returns (
1282             uint256,
1283             uint256,
1284             uint256
1285         )
1286     {
1287         uint256 rAmount = tAmount.mul(currentRate);
1288         uint256 rFee = tFee.mul(currentRate);
1289         uint256 rLiquidity = tLiquidity.mul(currentRate);
1290         uint256 rWallet = tWallet.mul(currentRate);
1291         uint256 rBurn = tBurn.mul(currentRate);
1292         uint256 rTransferAmount = rAmount
1293             .sub(rFee)
1294             .sub(rLiquidity)
1295             .sub(rWallet)
1296             .sub(rBurn);
1297         return (rAmount, rTransferAmount, rFee);
1298     }
1299 
1300     function _getRate() private view returns (uint256) {
1301         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1302         return rSupply.div(tSupply);
1303     }
1304 
1305     function _getCurrentSupply() private view returns (uint256, uint256) {
1306         uint256 rSupply = _rTotal;
1307         uint256 tSupply = _tTotal;
1308         for (uint256 i = 0; i < _excluded.length; i++) {
1309             if (
1310                 _rOwned[_excluded[i]] > rSupply ||
1311                 _tOwned[_excluded[i]] > tSupply
1312             ) return (_rTotal, _tTotal);
1313             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1314             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1315         }
1316         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1317         return (rSupply, tSupply);
1318     }
1319 
1320     function _takeLiquidity(uint256 tLiquidity) private {
1321         uint256 currentRate = _getRate();
1322         uint256 rLiquidity = tLiquidity.mul(currentRate);
1323         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1324         if (_isExcluded[address(this)])
1325             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1326     }
1327 
1328     function _takeWalletFee(uint256 tWallet) private {
1329         uint256 currentRate = _getRate();
1330         uint256 rWallet = tWallet.mul(currentRate);
1331         _rOwned[address(this)] = _rOwned[address(this)].add(rWallet);
1332         if (_isExcluded[address(this)])
1333             _tOwned[address(this)] = _tOwned[address(this)].add(tWallet);
1334     }
1335 
1336     function _takeBurnFee(uint256 tBurn) private {
1337         uint256 currentRate = _getRate();
1338         uint256 rBurn = tBurn.mul(currentRate);
1339         _rOwned[_burnAddress] = _rOwned[_burnAddress].add(rBurn);
1340         if (_isExcluded[_burnAddress])
1341             _tOwned[_burnAddress] = _tOwned[_burnAddress].add(
1342                 tBurn
1343             );
1344     }
1345 
1346     function calculateReflectionFee(uint256 _amount) private view returns (uint256) {
1347         return _amount.mul(_reflectionFee).div(10**2);
1348     }
1349 
1350     function calculateLiquidityFee(uint256 _amount)
1351         private
1352         view
1353         returns (uint256)
1354     {
1355         return _amount.mul(_liquidityFee).div(10**2);
1356     }
1357 
1358     function calculateMarketingFee(uint256 _amount)
1359         private
1360         view
1361         returns (uint256)
1362     {
1363         return _amount.mul(_marketingFee).div(10**2);
1364     }
1365 
1366     function calculateBurnFee(uint256 _amount)
1367         private
1368         view
1369         returns (uint256)
1370     {
1371         return _amount.mul(_burnFee).div(10**2);
1372     }
1373 
1374    
1375     function removeAllFee() private {
1376         _reflectionFee = 0;
1377         _liquidityFee = 0;
1378         _marketingFee = 0;
1379         _burnFee = 0;
1380      
1381     }
1382 
1383     function setBuy() private {
1384         _reflectionFee = buyFee.reflection;
1385         _liquidityFee = buyFee.liquidity;
1386         _marketingFee = buyFee.marketing;
1387         _burnFee = buyFee.burn;
1388       
1389     }
1390 
1391     function setSell() private {
1392         _reflectionFee = sellFee.reflection;
1393         _liquidityFee = sellFee.liquidity;
1394         _marketingFee = sellFee.marketing;
1395         _burnFee = sellFee.burn;
1396       
1397     }
1398 
1399     function isExcludedFromFee(address account) public view returns (bool) {
1400         return _isExcludedFromFee[account];
1401     }
1402 
1403     function isExcludedFromLimit(address account) public view returns (bool) {
1404         return _isExcludedFromLimit[account];
1405     }
1406 
1407     function _approve(
1408         address owner,
1409         address spender,
1410         uint256 amount
1411     ) private {
1412         require(owner != address(0), "ERC20: approve from the zero address");
1413         require(spender != address(0), "ERC20: approve to the zero address");
1414 
1415         _allowances[owner][spender] = amount;
1416         emit Approval(owner, spender, amount);
1417     }
1418 
1419     function _transfer(
1420         address from,
1421         address to,
1422         uint256 amount
1423     ) private {
1424         require(from != address(0), "ERC20: transfer from the zero address");
1425         require(to != address(0), "ERC20: transfer to the zero address");
1426         require(amount > 0, "Transfer amount must be greater than zero");
1427         
1428         if ( from != owner() && to != owner() ) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
1429 
1430         // is the token balance of this contract address over the min number of
1431         // tokens that we need to initiate a swap + liquidity lock?
1432         // also, don't get caught in a circular liquidity event.
1433         // also, don't swap & liquify if sender is uniswap pair.
1434         uint256 contractTokenBalance = balanceOf(address(this));
1435 
1436         if (contractTokenBalance >= _maxTxAmount) {
1437             contractTokenBalance = _maxTxAmount;
1438         }
1439 
1440         bool overMinTokenBalance = contractTokenBalance >=
1441             numTokensSellToAddToLiquidity;
1442         if (
1443             overMinTokenBalance &&
1444             !inSwapAndLiquify &&
1445             from != uniswapV2Pair &&
1446             swapAndLiquifyEnabled
1447         ) {
1448             contractTokenBalance = numTokensSellToAddToLiquidity;
1449             //add liquidity
1450             swapAndLiquify(contractTokenBalance);
1451         }
1452 
1453         //indicates if fee should be deducted from transfer
1454         bool takeFee = true;
1455 
1456         //if any account belongs to _isExcludedFromFee account then remove the fee
1457         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1458             takeFee = false;
1459         }
1460         if (takeFee) {
1461             if (!_isExcludedFromLimit[from] && !_isExcludedFromLimit[to]) {
1462                 require(
1463                     amount <= _maxTxAmount,
1464                     "Transfer amount exceeds the maxTxAmount."
1465                 );
1466                 if (to != uniswapV2Pair) {
1467                     require(
1468                         amount + balanceOf(to) <= _maxWalletSize,
1469                         "Recipient exceeds max wallet size."
1470                     );
1471                 }
1472 
1473               
1474             }
1475         }
1476 
1477         //transfer amount, it will take reflection, burn, liquidity fee
1478         _tokenTransfer(from, to, amount, takeFee);
1479     }
1480 
1481     function swapAndLiquify(uint256 tokens) private lockTheSwap {
1482         // Split the contract balance into halves
1483         uint256 denominator = (buyFee.liquidity + sellFee.liquidity + buyFee.marketing + sellFee.marketing) * 2;
1484         uint256 tokensToAddLiquidityWith = (tokens * (buyFee.liquidity + sellFee.liquidity)) / denominator;
1485         uint256 toSwap = tokens - tokensToAddLiquidityWith;
1486 
1487         uint256 initialBalance = address(this).balance;
1488 
1489         swapTokensForEth(toSwap);
1490 
1491         uint256 deltaBalance = address(this).balance - initialBalance;
1492         uint256 unitBalance = deltaBalance / (denominator - (buyFee.liquidity + sellFee.liquidity));
1493         uint256 ethToAddLiquidityWith = unitBalance * (buyFee.liquidity + sellFee.liquidity);
1494 
1495         if (ethToAddLiquidityWith > 0) {
1496             // Add liquidity to uniswap
1497             addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
1498         }
1499 
1500         // Send ETH to marketing
1501         uint256 marketingAmt = unitBalance * 2 * (buyFee.marketing + sellFee.marketing);
1502        
1503 
1504         if (marketingAmt > 0) {
1505             payable(_marketingAddress).transfer(marketingAmt);
1506         }
1507 
1508     
1509     }
1510 
1511     function swapTokensForEth(uint256 tokenAmount) private {
1512         // generate the uniswap pair path of token -> weth
1513         address[] memory path = new address[](2);
1514         path[0] = address(this);
1515         path[1] = uniswapV2Router.WETH();
1516 
1517         _approve(address(this), address(uniswapV2Router), tokenAmount);
1518 
1519         // make the swap
1520         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1521             tokenAmount,
1522             0, // accept any amount of ETH
1523             path,
1524             address(this),
1525             block.timestamp
1526         );
1527     }
1528 
1529     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1530         // approve token transfer to cover all possible scenarios
1531         _approve(address(this), address(uniswapV2Router), tokenAmount);
1532 
1533         // add the liquidity
1534         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1535             address(this),
1536             tokenAmount,
1537             0, // slippage is unavoidable
1538             0, // slippage is unavoidable
1539             address(this),
1540             block.timestamp
1541         );
1542     }
1543 
1544     //this method is responsible for taking all fee, if takeFee is true
1545     function _tokenTransfer(
1546         address sender,
1547         address recipient,
1548         uint256 amount,
1549         bool takeFee
1550     ) private {
1551         if (takeFee) {
1552             removeAllFee();
1553             if (sender == uniswapV2Pair) {
1554                 setBuy();
1555             }
1556             if (recipient == uniswapV2Pair) {
1557                 setSell();
1558             }
1559         }
1560 
1561         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1562             _transferFromExcluded(sender, recipient, amount);
1563         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1564             _transferToExcluded(sender, recipient, amount);
1565         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1566             _transferStandard(sender, recipient, amount);
1567         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1568             _transferBothExcluded(sender, recipient, amount);
1569         } else {
1570             _transferStandard(sender, recipient, amount);
1571         }
1572         removeAllFee();
1573     }
1574 
1575     function _transferStandard(
1576         address sender,
1577         address recipient,
1578         uint256 tAmount
1579     ) private {
1580         (
1581             uint256 tTransferAmount,
1582             uint256 tFee,
1583             uint256 tLiquidity,
1584             uint256 tWallet,
1585             uint256 tBurn
1586         ) = _getTValues(tAmount);
1587         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1588             tAmount,
1589             tFee,
1590             tLiquidity,
1591             tWallet,
1592             tBurn,
1593             _getRate()
1594         );
1595 
1596         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1597         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1598         _takeLiquidity(tLiquidity);
1599         _takeWalletFee(tWallet);
1600         _takeBurnFee(tBurn);
1601         _reflectFee(rFee, tFee);
1602         emit Transfer(sender, recipient, tTransferAmount);
1603     }
1604 
1605 
1606     function _transferToExcluded(
1607         address sender,
1608         address recipient,
1609         uint256 tAmount
1610     ) private {
1611         (
1612             uint256 tTransferAmount,
1613             uint256 tFee,
1614             uint256 tLiquidity,
1615             uint256 tWallet,
1616             uint256 tBurn
1617         ) = _getTValues(tAmount);
1618         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1619             tAmount,
1620             tFee,
1621             tLiquidity,
1622             tWallet,
1623             tBurn,
1624             _getRate()
1625         );
1626 
1627         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1628         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1629         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1630         _takeLiquidity(tLiquidity);
1631         _takeWalletFee(tWallet);
1632         _takeBurnFee(tBurn);
1633         _reflectFee(rFee, tFee);
1634         emit Transfer(sender, recipient, tTransferAmount);
1635     }
1636 
1637     function _transferFromExcluded(
1638         address sender,
1639         address recipient,
1640         uint256 tAmount
1641     ) private {
1642         (
1643             uint256 tTransferAmount,
1644             uint256 tFee,
1645             uint256 tLiquidity,
1646             uint256 tWallet,
1647             uint256 tBurn
1648         ) = _getTValues(tAmount);
1649         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1650             tAmount,
1651             tFee,
1652             tLiquidity,
1653             tWallet,
1654             tBurn,
1655             _getRate()
1656         );
1657 
1658         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1659         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1660         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1661         _takeLiquidity(tLiquidity);
1662         _takeWalletFee(tWallet);
1663         _takeBurnFee(tBurn);
1664         _reflectFee(rFee, tFee);
1665         emit Transfer(sender, recipient, tTransferAmount);
1666     }
1667 
1668     function _transferBothExcluded(
1669         address sender,
1670         address recipient,
1671         uint256 tAmount
1672     ) private {
1673         (
1674             uint256 tTransferAmount,
1675             uint256 tFee,
1676             uint256 tLiquidity,
1677             uint256 tWallet,
1678             uint256 tBurn
1679         ) = _getTValues(tAmount);
1680         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1681             tAmount,
1682             tFee,
1683             tLiquidity,
1684             tWallet,
1685             tBurn,
1686             _getRate()
1687         );
1688 
1689         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1690         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1691         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1692         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1693         _takeLiquidity(tLiquidity);
1694         _takeWalletFee(tWallet);
1695         _takeBurnFee(tBurn);
1696         _reflectFee(rFee, tFee);
1697         emit Transfer(sender, recipient, tTransferAmount);
1698     }
1699 
1700     function openTrading(bool _status,uint256 _deadBlocks) external onlyOwner() {
1701         tradingOpen = _status;
1702         excludeFromReward(address(this));
1703         excludeFromReward(uniswapV2Pair);
1704         if(tradingOpen && launchedAt == 0){
1705             launchedAt = block.number;
1706             deadBlocks = _deadBlocks;
1707         }
1708     }
1709 }