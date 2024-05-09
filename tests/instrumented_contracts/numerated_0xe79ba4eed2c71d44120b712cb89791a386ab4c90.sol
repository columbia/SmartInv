1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _transferOwnership(_msgSender());
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         _checkOwner();
56         _;
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if the sender is not the owner.
68      */
69     function _checkOwner() internal view virtual {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Emitted when `value` tokens are moved from one account (`from`) to
112      * another (`to`).
113      *
114      * Note that `value` may be zero.
115      */
116     event Transfer(address indexed from, address indexed to, uint256 value);
117 
118     /**
119      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
120      * a call to {approve}. `value` is the new allowance.
121      */
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 
124     /**
125      * @dev Returns the amount of tokens in existence.
126      */
127     function totalSupply() external view returns (uint256);
128 
129     /**
130      * @dev Returns the amount of tokens owned by `account`.
131      */
132     function balanceOf(address account) external view returns (uint256);
133 
134     /**
135      * @dev Moves `amount` tokens from the caller's account to `to`.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transfer(address to, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Returns the remaining number of tokens that `spender` will be
145      * allowed to spend on behalf of `owner` through {transferFrom}. This is
146      * zero by default.
147      *
148      * This value changes when {approve} or {transferFrom} are called.
149      */
150     function allowance(address owner, address spender) external view returns (uint256);
151 
152     /**
153      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * IMPORTANT: Beware that changing an allowance with this method brings the risk
158      * that someone may use both the old and the new allowance by unfortunate
159      * transaction ordering. One possible solution to mitigate this race
160      * condition is to first reduce the spender's allowance to 0 and set the
161      * desired value afterwards:
162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      *
164      * Emits an {Approval} event.
165      */
166     function approve(address spender, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Moves `amount` tokens from `from` to `to` using the
170      * allowance mechanism. `amount` is then deducted from the caller's
171      * allowance.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transferFrom(
178         address from,
179         address to,
180         uint256 amount
181     ) external returns (bool);
182 }
183 
184 
185 
186 pragma solidity ^0.8.0;
187 
188 // CAUTION
189 // This version of SafeMath should only be used with Solidity 0.8 or later,
190 // because it relies on the compiler's built in overflow checks.
191 
192 /**
193  * @dev Wrappers over Solidity's arithmetic operations.
194  *
195  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
196  * now has built in overflow checking.
197  */
198 library SafeMath {
199     /**
200      * @dev Returns the addition of two unsigned integers, with an overflow flag.
201      *
202      * _Available since v3.4._
203      */
204     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
205         unchecked {
206             uint256 c = a + b;
207             if (c < a) return (false, 0);
208             return (true, c);
209         }
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
214      *
215      * _Available since v3.4._
216      */
217     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
218         unchecked {
219             if (b > a) return (false, 0);
220             return (true, a - b);
221         }
222     }
223 
224     /**
225      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
226      *
227      * _Available since v3.4._
228      */
229     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
230         unchecked {
231             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
232             // benefit is lost if 'b' is also tested.
233             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
234             if (a == 0) return (true, 0);
235             uint256 c = a * b;
236             if (c / a != b) return (false, 0);
237             return (true, c);
238         }
239     }
240 
241     /**
242      * @dev Returns the division of two unsigned integers, with a division by zero flag.
243      *
244      * _Available since v3.4._
245      */
246     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
247         unchecked {
248             if (b == 0) return (false, 0);
249             return (true, a / b);
250         }
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
255      *
256      * _Available since v3.4._
257      */
258     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
259         unchecked {
260             if (b == 0) return (false, 0);
261             return (true, a % b);
262         }
263     }
264 
265     /**
266      * @dev Returns the addition of two unsigned integers, reverting on
267      * overflow.
268      *
269      * Counterpart to Solidity's `+` operator.
270      *
271      * Requirements:
272      *
273      * - Addition cannot overflow.
274      */
275     function add(uint256 a, uint256 b) internal pure returns (uint256) {
276         return a + b;
277     }
278 
279     /**
280      * @dev Returns the subtraction of two unsigned integers, reverting on
281      * overflow (when the result is negative).
282      *
283      * Counterpart to Solidity's `-` operator.
284      *
285      * Requirements:
286      *
287      * - Subtraction cannot overflow.
288      */
289     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a - b;
291     }
292 
293     /**
294      * @dev Returns the multiplication of two unsigned integers, reverting on
295      * overflow.
296      *
297      * Counterpart to Solidity's `*` operator.
298      *
299      * Requirements:
300      *
301      * - Multiplication cannot overflow.
302      */
303     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a * b;
305     }
306 
307     /**
308      * @dev Returns the integer division of two unsigned integers, reverting on
309      * division by zero. The result is rounded towards zero.
310      *
311      * Counterpart to Solidity's `/` operator.
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function div(uint256 a, uint256 b) internal pure returns (uint256) {
318         return a / b;
319     }
320 
321     /**
322      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
323      * reverting when dividing by zero.
324      *
325      * Counterpart to Solidity's `%` operator. This function uses a `revert`
326      * opcode (which leaves remaining gas untouched) while Solidity uses an
327      * invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      *
331      * - The divisor cannot be zero.
332      */
333     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
334         return a % b;
335     }
336 
337     /**
338      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
339      * overflow (when the result is negative).
340      *
341      * CAUTION: This function is deprecated because it requires allocating memory for the error
342      * message unnecessarily. For custom revert reasons use {trySub}.
343      *
344      * Counterpart to Solidity's `-` operator.
345      *
346      * Requirements:
347      *
348      * - Subtraction cannot overflow.
349      */
350     function sub(
351         uint256 a,
352         uint256 b,
353         string memory errorMessage
354     ) internal pure returns (uint256) {
355         unchecked {
356             require(b <= a, errorMessage);
357             return a - b;
358         }
359     }
360 
361     /**
362      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
363      * division by zero. The result is rounded towards zero.
364      *
365      * Counterpart to Solidity's `/` operator. Note: this function uses a
366      * `revert` opcode (which leaves remaining gas untouched) while Solidity
367      * uses an invalid opcode to revert (consuming all remaining gas).
368      *
369      * Requirements:
370      *
371      * - The divisor cannot be zero.
372      */
373     function div(
374         uint256 a,
375         uint256 b,
376         string memory errorMessage
377     ) internal pure returns (uint256) {
378         unchecked {
379             require(b > 0, errorMessage);
380             return a / b;
381         }
382     }
383 
384     /**
385      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
386      * reverting with custom message when dividing by zero.
387      *
388      * CAUTION: This function is deprecated because it requires allocating memory for the error
389      * message unnecessarily. For custom revert reasons use {tryMod}.
390      *
391      * Counterpart to Solidity's `%` operator. This function uses a `revert`
392      * opcode (which leaves remaining gas untouched) while Solidity uses an
393      * invalid opcode to revert (consuming all remaining gas).
394      *
395      * Requirements:
396      *
397      * - The divisor cannot be zero.
398      */
399     function mod(
400         uint256 a,
401         uint256 b,
402         string memory errorMessage
403     ) internal pure returns (uint256) {
404         unchecked {
405             require(b > 0, errorMessage);
406             return a % b;
407         }
408     }
409 }
410 
411 
412 pragma solidity >=0.5.0;
413 
414 interface IUniswapV2Factory {
415     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
416 
417     function feeTo() external view returns (address);
418     function feeToSetter() external view returns (address);
419 
420     function getPair(address tokenA, address tokenB) external view returns (address pair);
421     function allPairs(uint) external view returns (address pair);
422     function allPairsLength() external view returns (uint);
423 
424     function createPair(address tokenA, address tokenB) external returns (address pair);
425 
426     function setFeeTo(address) external;
427     function setFeeToSetter(address) external;
428 }
429 
430 
431 pragma solidity >=0.5.0;
432 
433 interface IUniswapV2Pair {
434     event Approval(address indexed owner, address indexed spender, uint value);
435     event Transfer(address indexed from, address indexed to, uint value);
436 
437     function name() external pure returns (string memory);
438     function symbol() external pure returns (string memory);
439     function decimals() external pure returns (uint8);
440     function totalSupply() external view returns (uint);
441     function balanceOf(address owner) external view returns (uint);
442     function allowance(address owner, address spender) external view returns (uint);
443 
444     function approve(address spender, uint value) external returns (bool);
445     function transfer(address to, uint value) external returns (bool);
446     function transferFrom(address from, address to, uint value) external returns (bool);
447 
448     function DOMAIN_SEPARATOR() external view returns (bytes32);
449     function PERMIT_TYPEHASH() external pure returns (bytes32);
450     function nonces(address owner) external view returns (uint);
451 
452     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
453 
454     event Mint(address indexed sender, uint amount0, uint amount1);
455     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
456     event Swap(
457         address indexed sender,
458         uint amount0In,
459         uint amount1In,
460         uint amount0Out,
461         uint amount1Out,
462         address indexed to
463     );
464     event Sync(uint112 reserve0, uint112 reserve1);
465 
466     function MINIMUM_LIQUIDITY() external pure returns (uint);
467     function factory() external view returns (address);
468     function token0() external view returns (address);
469     function token1() external view returns (address);
470     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
471     function price0CumulativeLast() external view returns (uint);
472     function price1CumulativeLast() external view returns (uint);
473     function kLast() external view returns (uint);
474 
475     function mint(address to) external returns (uint liquidity);
476     function burn(address to) external returns (uint amount0, uint amount1);
477     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
478     function skim(address to) external;
479     function sync() external;
480 
481     function initialize(address, address) external;
482 }
483 
484 
485 pragma solidity >=0.6.2;
486 
487 interface IUniswapV2Router01 {
488     function factory() external pure returns (address);
489     function WETH() external pure returns (address);
490 
491     function addLiquidity(
492         address tokenA,
493         address tokenB,
494         uint amountADesired,
495         uint amountBDesired,
496         uint amountAMin,
497         uint amountBMin,
498         address to,
499         uint deadline
500     ) external returns (uint amountA, uint amountB, uint liquidity);
501     function addLiquidityETH(
502         address token,
503         uint amountTokenDesired,
504         uint amountTokenMin,
505         uint amountETHMin,
506         address to,
507         uint deadline
508     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
509     function removeLiquidity(
510         address tokenA,
511         address tokenB,
512         uint liquidity,
513         uint amountAMin,
514         uint amountBMin,
515         address to,
516         uint deadline
517     ) external returns (uint amountA, uint amountB);
518     function removeLiquidityETH(
519         address token,
520         uint liquidity,
521         uint amountTokenMin,
522         uint amountETHMin,
523         address to,
524         uint deadline
525     ) external returns (uint amountToken, uint amountETH);
526     function removeLiquidityWithPermit(
527         address tokenA,
528         address tokenB,
529         uint liquidity,
530         uint amountAMin,
531         uint amountBMin,
532         address to,
533         uint deadline,
534         bool approveMax, uint8 v, bytes32 r, bytes32 s
535     ) external returns (uint amountA, uint amountB);
536     function removeLiquidityETHWithPermit(
537         address token,
538         uint liquidity,
539         uint amountTokenMin,
540         uint amountETHMin,
541         address to,
542         uint deadline,
543         bool approveMax, uint8 v, bytes32 r, bytes32 s
544     ) external returns (uint amountToken, uint amountETH);
545     function swapExactTokensForTokens(
546         uint amountIn,
547         uint amountOutMin,
548         address[] calldata path,
549         address to,
550         uint deadline
551     ) external returns (uint[] memory amounts);
552     function swapTokensForExactTokens(
553         uint amountOut,
554         uint amountInMax,
555         address[] calldata path,
556         address to,
557         uint deadline
558     ) external returns (uint[] memory amounts);
559     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
560         external
561         payable
562         returns (uint[] memory amounts);
563     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
564         external
565         returns (uint[] memory amounts);
566     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
567         external
568         returns (uint[] memory amounts);
569     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
570         external
571         payable
572         returns (uint[] memory amounts);
573 
574     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
575     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
576     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
577     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
578     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
579 }
580 
581 
582 pragma solidity >=0.6.2;
583 
584 interface IUniswapV2Router02 is IUniswapV2Router01 {
585     function removeLiquidityETHSupportingFeeOnTransferTokens(
586         address token,
587         uint liquidity,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline
592     ) external returns (uint amountETH);
593     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
594         address token,
595         uint liquidity,
596         uint amountTokenMin,
597         uint amountETHMin,
598         address to,
599         uint deadline,
600         bool approveMax, uint8 v, bytes32 r, bytes32 s
601     ) external returns (uint amountETH);
602 
603     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
604         uint amountIn,
605         uint amountOutMin,
606         address[] calldata path,
607         address to,
608         uint deadline
609     ) external;
610     function swapExactETHForTokensSupportingFeeOnTransferTokens(
611         uint amountOutMin,
612         address[] calldata path,
613         address to,
614         uint deadline
615     ) external payable;
616     function swapExactTokensForETHSupportingFeeOnTransferTokens(
617         uint amountIn,
618         uint amountOutMin,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external;
623 }
624 
625 
626 pragma solidity ^0.8.0;
627 
628 /**
629  * @dev Interface for the optional metadata functions from the ERC20 standard.
630  *
631  * _Available since v4.1._
632  */
633 interface IERC20Metadata is IERC20 {
634     /**
635      * @dev Returns the name of the token.
636      */
637     function name() external view returns (string memory);
638 
639     /**
640      * @dev Returns the symbol of the token.
641      */
642     function symbol() external view returns (string memory);
643 
644     /**
645      * @dev Returns the decimals places of the token.
646      */
647     function decimals() external view returns (uint8);
648 }
649 
650 
651 pragma solidity ^0.8.0;
652 
653 
654 
655 /**
656  * @dev Implementation of the {IERC20} interface.
657  *
658  * This implementation is agnostic to the way tokens are created. This means
659  * that a supply mechanism has to be added in a derived contract using {_mint}.
660  * For a generic mechanism see {ERC20PresetMinterPauser}.
661  *
662  * TIP: For a detailed writeup see our guide
663  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
664  * to implement supply mechanisms].
665  *
666  * We have followed general OpenZeppelin Contracts guidelines: functions revert
667  * instead returning `false` on failure. This behavior is nonetheless
668  * conventional and does not conflict with the expectations of ERC20
669  * applications.
670  *
671  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
672  * This allows applications to reconstruct the allowance for all accounts just
673  * by listening to said events. Other implementations of the EIP may not emit
674  * these events, as it isn't required by the specification.
675  *
676  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
677  * functions have been added to mitigate the well-known issues around setting
678  * allowances. See {IERC20-approve}.
679  */
680 contract ERC20 is Context, IERC20, IERC20Metadata {
681     mapping(address => uint256) private _balances;
682 
683     mapping(address => mapping(address => uint256)) private _allowances;
684 
685     uint256 private _totalSupply;
686 
687     string private _name;
688     string private _symbol;
689 
690     /**
691      * @dev Sets the values for {name} and {symbol}.
692      *
693      * The default value of {decimals} is 18. To select a different value for
694      * {decimals} you should overload it.
695      *
696      * All two of these values are immutable: they can only be set once during
697      * construction.
698      */
699     constructor(string memory name_, string memory symbol_) {
700         _name = name_;
701         _symbol = symbol_;
702     }
703 
704     /**
705      * @dev Returns the name of the token.
706      */
707     function name() public view virtual override returns (string memory) {
708         return _name;
709     }
710 
711     /**
712      * @dev Returns the symbol of the token, usually a shorter version of the
713      * name.
714      */
715     function symbol() public view virtual override returns (string memory) {
716         return _symbol;
717     }
718 
719     /**
720      * @dev Returns the number of decimals used to get its user representation.
721      * For example, if `decimals` equals `2`, a balance of `505` tokens should
722      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
723      *
724      * Tokens usually opt for a value of 18, imitating the relationship between
725      * Ether and Wei. This is the value {ERC20} uses, unless this function is
726      * overridden;
727      *
728      * NOTE: This information is only used for _display_ purposes: it in
729      * no way affects any of the arithmetic of the contract, including
730      * {IERC20-balanceOf} and {IERC20-transfer}.
731      */
732     function decimals() public view virtual override returns (uint8) {
733         return 18;
734     }
735 
736     /**
737      * @dev See {IERC20-totalSupply}.
738      */
739     function totalSupply() public view virtual override returns (uint256) {
740         return _totalSupply;
741     }
742 
743     /**
744      * @dev See {IERC20-balanceOf}.
745      */
746     function balanceOf(address account) public view virtual override returns (uint256) {
747         return _balances[account];
748     }
749 
750     /**
751      * @dev See {IERC20-transfer}.
752      *
753      * Requirements:
754      *
755      * - `to` cannot be the zero address.
756      * - the caller must have a balance of at least `amount`.
757      */
758     function transfer(address to, uint256 amount) public virtual override returns (bool) {
759         address owner = _msgSender();
760         _transfer(owner, to, amount);
761         return true;
762     }
763 
764     /**
765      * @dev See {IERC20-allowance}.
766      */
767     function allowance(address owner, address spender) public view virtual override returns (uint256) {
768         return _allowances[owner][spender];
769     }
770 
771     /**
772      * @dev See {IERC20-approve}.
773      *
774      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
775      * `transferFrom`. This is semantically equivalent to an infinite approval.
776      *
777      * Requirements:
778      *
779      * - `spender` cannot be the zero address.
780      */
781     function approve(address spender, uint256 amount) public virtual override returns (bool) {
782         address owner = _msgSender();
783         _approve(owner, spender, amount);
784         return true;
785     }
786 
787     /**
788      * @dev See {IERC20-transferFrom}.
789      *
790      * Emits an {Approval} event indicating the updated allowance. This is not
791      * required by the EIP. See the note at the beginning of {ERC20}.
792      *
793      * NOTE: Does not update the allowance if the current allowance
794      * is the maximum `uint256`.
795      *
796      * Requirements:
797      *
798      * - `from` and `to` cannot be the zero address.
799      * - `from` must have a balance of at least `amount`.
800      * - the caller must have allowance for ``from``'s tokens of at least
801      * `amount`.
802      */
803     function transferFrom(
804         address from,
805         address to,
806         uint256 amount
807     ) public virtual override returns (bool) {
808         address spender = _msgSender();
809         _spendAllowance(from, spender, amount);
810         _transfer(from, to, amount);
811         return true;
812     }
813 
814     /**
815      * @dev Atomically increases the allowance granted to `spender` by the caller.
816      *
817      * This is an alternative to {approve} that can be used as a mitigation for
818      * problems described in {IERC20-approve}.
819      *
820      * Emits an {Approval} event indicating the updated allowance.
821      *
822      * Requirements:
823      *
824      * - `spender` cannot be the zero address.
825      */
826     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
827         address owner = _msgSender();
828         _approve(owner, spender, allowance(owner, spender) + addedValue);
829         return true;
830     }
831 
832     /**
833      * @dev Atomically decreases the allowance granted to `spender` by the caller.
834      *
835      * This is an alternative to {approve} that can be used as a mitigation for
836      * problems described in {IERC20-approve}.
837      *
838      * Emits an {Approval} event indicating the updated allowance.
839      *
840      * Requirements:
841      *
842      * - `spender` cannot be the zero address.
843      * - `spender` must have allowance for the caller of at least
844      * `subtractedValue`.
845      */
846     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
847         address owner = _msgSender();
848         uint256 currentAllowance = allowance(owner, spender);
849         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
850         unchecked {
851             _approve(owner, spender, currentAllowance - subtractedValue);
852         }
853 
854         return true;
855     }
856 
857     /**
858      * @dev Moves `amount` of tokens from `from` to `to`.
859      *
860      * This internal function is equivalent to {transfer}, and can be used to
861      * e.g. implement automatic token fees, slashing mechanisms, etc.
862      *
863      * Emits a {Transfer} event.
864      *
865      * Requirements:
866      *
867      * - `from` cannot be the zero address.
868      * - `to` cannot be the zero address.
869      * - `from` must have a balance of at least `amount`.
870      */
871     function _transfer(
872         address from,
873         address to,
874         uint256 amount
875     ) internal virtual {
876         require(from != address(0), "ERC20: transfer from the zero address");
877         require(to != address(0), "ERC20: transfer to the zero address");
878 
879         _beforeTokenTransfer(from, to, amount);
880 
881         uint256 fromBalance = _balances[from];
882         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
883         unchecked {
884             _balances[from] = fromBalance - amount;
885             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
886             // decrementing then incrementing.
887             _balances[to] += amount;
888         }
889 
890         emit Transfer(from, to, amount);
891 
892         _afterTokenTransfer(from, to, amount);
893     }
894 
895     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
896      * the total supply.
897      *
898      * Emits a {Transfer} event with `from` set to the zero address.
899      *
900      * Requirements:
901      *
902      * - `account` cannot be the zero address.
903      */
904     function _mint(address account, uint256 amount) internal virtual {
905         require(account != address(0), "ERC20: mint to the zero address");
906 
907         _beforeTokenTransfer(address(0), account, amount);
908 
909         _totalSupply += amount;
910         unchecked {
911             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
912             _balances[account] += amount;
913         }
914         emit Transfer(address(0), account, amount);
915 
916         _afterTokenTransfer(address(0), account, amount);
917     }
918 
919     /**
920      * @dev Destroys `amount` tokens from `account`, reducing the
921      * total supply.
922      *
923      * Emits a {Transfer} event with `to` set to the zero address.
924      *
925      * Requirements:
926      *
927      * - `account` cannot be the zero address.
928      * - `account` must have at least `amount` tokens.
929      */
930     function _burn(address account, uint256 amount) internal virtual {
931         require(account != address(0), "ERC20: burn from the zero address");
932 
933         _beforeTokenTransfer(account, address(0), amount);
934 
935         uint256 accountBalance = _balances[account];
936         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
937         unchecked {
938             _balances[account] = accountBalance - amount;
939             // Overflow not possible: amount <= accountBalance <= totalSupply.
940             _totalSupply -= amount;
941         }
942 
943         emit Transfer(account, address(0), amount);
944 
945         _afterTokenTransfer(account, address(0), amount);
946     }
947 
948     /**
949      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
950      *
951      * This internal function is equivalent to `approve`, and can be used to
952      * e.g. set automatic allowances for certain subsystems, etc.
953      *
954      * Emits an {Approval} event.
955      *
956      * Requirements:
957      *
958      * - `owner` cannot be the zero address.
959      * - `spender` cannot be the zero address.
960      */
961     function _approve(
962         address owner,
963         address spender,
964         uint256 amount
965     ) internal virtual {
966         require(owner != address(0), "ERC20: approve from the zero address");
967         require(spender != address(0), "ERC20: approve to the zero address");
968 
969         _allowances[owner][spender] = amount;
970         emit Approval(owner, spender, amount);
971     }
972 
973     /**
974      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
975      *
976      * Does not update the allowance amount in case of infinite allowance.
977      * Revert if not enough allowance is available.
978      *
979      * Might emit an {Approval} event.
980      */
981     function _spendAllowance(
982         address owner,
983         address spender,
984         uint256 amount
985     ) internal virtual {
986         uint256 currentAllowance = allowance(owner, spender);
987         if (currentAllowance != type(uint256).max) {
988             require(currentAllowance >= amount, "ERC20: insufficient allowance");
989             unchecked {
990                 _approve(owner, spender, currentAllowance - amount);
991             }
992         }
993     }
994 
995     /**
996      * @dev Hook that is called before any transfer of tokens. This includes
997      * minting and burning.
998      *
999      * Calling conditions:
1000      *
1001      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1002      * will be transferred to `to`.
1003      * - when `from` is zero, `amount` tokens will be minted for `to`.
1004      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1005      * - `from` and `to` are never both zero.
1006      *
1007      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1008      */
1009     function _beforeTokenTransfer(
1010         address from,
1011         address to,
1012         uint256 amount
1013     ) internal virtual {}
1014 
1015     /**
1016      * @dev Hook that is called after any transfer of tokens. This includes
1017      * minting and burning.
1018      *
1019      * Calling conditions:
1020      *
1021      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1022      * has been transferred to `to`.
1023      * - when `from` is zero, `amount` tokens have been minted for `to`.
1024      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1025      * - `from` and `to` are never both zero.
1026      *
1027      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1028      */
1029     function _afterTokenTransfer(
1030         address from,
1031         address to,
1032         uint256 amount
1033     ) internal virtual {}
1034 }
1035 
1036 
1037 pragma solidity >=0.8.10;
1038 
1039 contract SHIBVISION is ERC20, Ownable {
1040     using SafeMath for uint256;
1041 
1042     IUniswapV2Router02 public immutable uniswapV2Router;
1043     address public immutable uniswapV2Pair;
1044     address public constant deadAddress = address(0xdead);
1045 
1046     bool private swapping;
1047 
1048     address public marketingWallet;
1049     address public devWallet;
1050 
1051     uint256 public maxTransactionAmount;
1052     uint256 public swapTokensAtAmount;
1053     uint256 public maxWallet;
1054 
1055     uint256 public percentForLPBurn = 25;
1056     bool public lpBurnEnabled = false;
1057     uint256 public lpBurnFrequency = 3600 seconds;
1058     uint256 public lastLpBurnTime;
1059 
1060     uint256 public manualBurnFrequency = 30 minutes;
1061     uint256 public lastManualLpBurnTime;
1062 
1063     bool public limitsInEffect = true;
1064     bool public tradingActive = false;
1065     bool public swapEnabled = true;
1066 
1067     mapping(address => uint256) private _holderLastTransferTimestamp;
1068     bool public transferDelayEnabled = false;
1069 
1070     uint256 public buyTotalFees;
1071     uint256 public buyMarketingFee;
1072     uint256 public buyLiquidityFee;
1073     uint256 public buyDevFee;
1074 
1075     uint256 public sellTotalFees;
1076     uint256 public sellMarketingFee;
1077     uint256 public sellLiquidityFee;
1078     uint256 public sellDevFee;
1079 
1080     uint256 public tokensForMarketing;
1081     uint256 public tokensForLiquidity;
1082     uint256 public tokensForDev;
1083 
1084     mapping(address => bool) private _isExcludedFromFees;
1085     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1086 
1087     mapping(address => bool) public automatedMarketMakerPairs;
1088 
1089     event UpdateUniswapV2Router(
1090         address indexed newAddress,
1091         address indexed oldAddress
1092     );
1093 
1094     event ExcludeFromFees(address indexed account, bool isExcluded);
1095 
1096     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1097 
1098     event marketingWalletUpdated(
1099         address indexed newWallet,
1100         address indexed oldWallet
1101     );
1102 
1103     event devWalletUpdated(
1104         address indexed newWallet,
1105         address indexed oldWallet
1106     );
1107 
1108     event SwapAndLiquify(
1109         uint256 tokensSwapped,
1110         uint256 ethReceived,
1111         uint256 tokensIntoLiquidity
1112     );
1113 
1114     event AutoNukeLP();
1115 
1116     event ManualNukeLP();
1117 
1118     constructor() ERC20("SHIBVISION", "SHION") {
1119         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1120             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1121         );
1122 
1123         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1124         uniswapV2Router = _uniswapV2Router;
1125 
1126         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1127         .createPair(address(this), _uniswapV2Router.WETH());
1128         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1129         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1130 
1131         uint256 _buyMarketingFee = 10;
1132         uint256 _buyLiquidityFee = 0;
1133         uint256 _buyDevFee = 0;
1134 
1135         uint256 _sellMarketingFee = 40;
1136         uint256 _sellLiquidityFee = 0;
1137         uint256 _sellDevFee = 0;
1138 
1139         uint256 totalSupply = 1_000_000_000 * 1e18;
1140 
1141         maxTransactionAmount = 20_000_000  * 1e18;
1142         maxWallet = 20_000_000 * 1e18;
1143         swapTokensAtAmount = (totalSupply * 10) / 10000;
1144 
1145         buyMarketingFee = _buyMarketingFee;
1146         buyLiquidityFee = _buyLiquidityFee;
1147         buyDevFee = _buyDevFee;
1148         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1149 
1150         sellMarketingFee = _sellMarketingFee;
1151         sellLiquidityFee = _sellLiquidityFee;
1152         sellDevFee = _sellDevFee;
1153         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1154 
1155         marketingWallet = owner();
1156         devWallet = owner();
1157 
1158         excludeFromFees(owner(), true);
1159         excludeFromFees(address(this), true);
1160         excludeFromFees(address(0xdead), true);
1161 
1162         excludeFromMaxTransaction(owner(), true);
1163         excludeFromMaxTransaction(address(this), true);
1164         excludeFromMaxTransaction(address(0xdead), true);
1165 
1166         /*
1167             _mint is an internal function in ERC20.sol that is only called here,
1168             and CANNOT be called ever again
1169         */
1170         _mint(msg.sender, totalSupply);
1171         enableTrading();
1172     }
1173 
1174     receive() external payable {}
1175 
1176     function enableTrading() public onlyOwner {
1177         tradingActive = true;
1178         swapEnabled = true;
1179         lastLpBurnTime = block.timestamp;
1180     }
1181 
1182     function removeLimits() external onlyOwner returns (bool) {
1183         limitsInEffect = false;
1184         return true;
1185     }
1186 
1187     function disableTransferDelay() external onlyOwner returns (bool) {
1188         transferDelayEnabled = false;
1189         return true;
1190     }
1191 
1192     function updateSwapTokensAtAmount(uint256 newAmount)
1193     external
1194     onlyOwner
1195     returns (bool)
1196     {
1197         require(
1198             newAmount >= (totalSupply() * 1) / 100000,
1199             "Swap amount cannot be lower than 0.001% total supply."
1200         );
1201         require(
1202             newAmount <= (totalSupply() * 5) / 1000,
1203             "Swap amount cannot be higher than 0.5% total supply."
1204         );
1205         swapTokensAtAmount = newAmount;
1206         return true;
1207     }
1208 
1209     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1210         require(
1211             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1212             "Cannot set maxTransactionAmount lower than 0.1%"
1213         );
1214         maxTransactionAmount = newNum * (10 ** 18);
1215     }
1216 
1217     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1218         require(
1219             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1220             "Cannot set maxWallet lower than 0.1%"
1221         );
1222         maxWallet = newNum * (10 ** 18);
1223     }
1224 
1225     function excludeFromMaxTransaction(address updAds, bool isEx)
1226     public
1227     onlyOwner
1228     {
1229         _isExcludedMaxTransactionAmount[updAds] = isEx;
1230     }
1231 
1232     function updateSwapEnabled(bool enabled) external onlyOwner {
1233         swapEnabled = enabled;
1234     }
1235 
1236     function updateBuyFees(
1237         uint256 _marketingFee,
1238         uint256 _liquidityFee,
1239         uint256 _devFee
1240     ) external onlyOwner {
1241         buyMarketingFee = _marketingFee;
1242         buyLiquidityFee = _liquidityFee;
1243         buyDevFee = _devFee;
1244         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1245         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1246     }
1247 
1248     function updateSellFees(
1249         uint256 _marketingFee,
1250         uint256 _liquidityFee,
1251         uint256 _devFee
1252     ) external onlyOwner {
1253         sellMarketingFee = _marketingFee;
1254         sellLiquidityFee = _liquidityFee;
1255         sellDevFee = _devFee;
1256         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1257         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
1258     }
1259 
1260     function excludeFromFees(address account, bool excluded) public onlyOwner {
1261         _isExcludedFromFees[account] = excluded;
1262         emit ExcludeFromFees(account, excluded);
1263     }
1264 
1265     function setAutomatedMarketMakerPair(address pair, bool value)
1266     public
1267     onlyOwner
1268     {
1269         require(
1270             pair != uniswapV2Pair,
1271             "The pair cannot be removed from automatedMarketMakerPairs"
1272         );
1273 
1274         _setAutomatedMarketMakerPair(pair, value);
1275     }
1276 
1277     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1278         automatedMarketMakerPairs[pair] = value;
1279 
1280         emit SetAutomatedMarketMakerPair(pair, value);
1281     }
1282 
1283     function updateMarketingWallet(address newMarketingWallet)
1284     external
1285     onlyOwner
1286     {
1287         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1288         marketingWallet = newMarketingWallet;
1289     }
1290 
1291     function updateDevWallet(address newWallet) external onlyOwner {
1292         emit devWalletUpdated(newWallet, devWallet);
1293         devWallet = newWallet;
1294     }
1295 
1296     function isExcludedFromFees(address account) public view returns (bool) {
1297         return _isExcludedFromFees[account];
1298     }
1299 
1300     event BoughtEarly(address indexed sniper);
1301 
1302     function _transfer(
1303         address from,
1304         address to,
1305         uint256 amount
1306     ) internal override {
1307         require(from != address(0), "ERC20: transfer from the zero address");
1308         require(to != address(0), "ERC20: transfer to the zero address");
1309 
1310         if (amount == 0) {
1311             super._transfer(from, to, 0);
1312             return;
1313         }
1314 
1315         if (limitsInEffect) {
1316             if (
1317                 from != owner() &&
1318                 to != owner() &&
1319                 to != address(0) &&
1320                 to != address(0xdead) &&
1321                 !swapping
1322             ) {
1323                 if (!tradingActive) {
1324                     require(
1325                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1326                         "Trading is not active."
1327                     );
1328                 }
1329 
1330                 if (transferDelayEnabled) {
1331                     if (
1332                         to != owner() &&
1333                         to != address(uniswapV2Router) &&
1334                         to != address(uniswapV2Pair)
1335                     ) {
1336                         require(
1337                             _holderLastTransferTimestamp[tx.origin] <
1338                             block.number,
1339                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1340                         );
1341                         _holderLastTransferTimestamp[tx.origin] = block.number;
1342                     }
1343                 }
1344 
1345                 if (
1346                     automatedMarketMakerPairs[from] &&
1347                     !_isExcludedMaxTransactionAmount[to]
1348                 ) {
1349                     require(
1350                         amount <= maxTransactionAmount,
1351                         "Buy transfer amount exceeds the maxTransactionAmount."
1352                     );
1353                     require(
1354                         amount + balanceOf(to) <= maxWallet,
1355                         "Max wallet exceeded"
1356                     );
1357                 }
1358 
1359                 else if (
1360                     automatedMarketMakerPairs[to] &&
1361                     !_isExcludedMaxTransactionAmount[from]
1362                 ) {
1363                     require(
1364                         amount <= maxTransactionAmount,
1365                         "Sell transfer amount exceeds the maxTransactionAmount."
1366                     );
1367                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1368                     require(
1369                         amount + balanceOf(to) <= maxWallet,
1370                         "Max wallet exceeded"
1371                     );
1372                 }
1373             }
1374         }
1375 
1376         uint256 contractTokenBalance = balanceOf(address(this));
1377 
1378         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1379 
1380         if (
1381             canSwap &&
1382             swapEnabled &&
1383             !swapping &&
1384             !automatedMarketMakerPairs[from] &&
1385             !_isExcludedFromFees[from] &&
1386             !_isExcludedFromFees[to]
1387         ) {
1388             swapping = true;
1389 
1390             swapBack();
1391 
1392             swapping = false;
1393         }
1394 
1395         if (
1396             !swapping &&
1397         automatedMarketMakerPairs[to] &&
1398         lpBurnEnabled &&
1399         block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1400         !_isExcludedFromFees[from]
1401         ) {
1402             autoBurnLiquidityPairTokens();
1403         }
1404 
1405         bool takeFee = !swapping;
1406 
1407         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1408             takeFee = false;
1409         }
1410 
1411         uint256 fees = 0;
1412         if (takeFee) {
1413             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1414                 fees = amount.mul(sellTotalFees).div(100);
1415                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1416                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1417                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1418             }
1419             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1420                 fees = amount.mul(buyTotalFees).div(100);
1421                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1422                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1423                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1424             }
1425 
1426             if (fees > 0) {
1427                 super._transfer(from, address(this), fees);
1428             }
1429 
1430             amount -= fees;
1431         }
1432 
1433         super._transfer(from, to, amount);
1434     }
1435 
1436     function swapTokensForEth(uint256 tokenAmount) private {
1437         address[] memory path = new address[](2);
1438         path[0] = address(this);
1439         path[1] = uniswapV2Router.WETH();
1440 
1441         _approve(address(this), address(uniswapV2Router), tokenAmount);
1442 
1443         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1444             tokenAmount,
1445             0,
1446             path,
1447             address(this),
1448             block.timestamp
1449         );
1450     }
1451 
1452     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1453         _approve(address(this), address(uniswapV2Router), tokenAmount);
1454 
1455         uniswapV2Router.addLiquidityETH{value : ethAmount}(
1456             address(this),
1457             tokenAmount,
1458             0,
1459             0,
1460             deadAddress,
1461             block.timestamp
1462         );
1463     }
1464 
1465     function swapBack() private {
1466         uint256 contractBalance = balanceOf(address(this));
1467         uint256 totalTokensToSwap = tokensForLiquidity +
1468         tokensForMarketing +
1469         tokensForDev;
1470         bool success;
1471 
1472         if (contractBalance == 0 || totalTokensToSwap == 0) {
1473             return;
1474         }
1475 
1476         if (contractBalance > swapTokensAtAmount * 20) {
1477             contractBalance = swapTokensAtAmount * 20;
1478         }
1479 
1480         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1481         totalTokensToSwap /
1482         2;
1483         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1484 
1485         uint256 initialETHBalance = address(this).balance;
1486 
1487         swapTokensForEth(amountToSwapForETH);
1488 
1489         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1490 
1491         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1492             totalTokensToSwap
1493         );
1494         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1495 
1496         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1497 
1498         tokensForLiquidity = 0;
1499         tokensForMarketing = 0;
1500         tokensForDev = 0;
1501 
1502         (success,) = address(devWallet).call{value : ethForDev}("");
1503 
1504         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1505             addLiquidity(liquidityTokens, ethForLiquidity);
1506             emit SwapAndLiquify(
1507                 amountToSwapForETH,
1508                 ethForLiquidity,
1509                 tokensForLiquidity
1510             );
1511         }
1512 
1513         (success,) = address(marketingWallet).call{
1514         value : address(this).balance
1515         }("");
1516     }
1517 
1518     function setAutoLPBurnSettings(
1519         uint256 _frequencyInSeconds,
1520         uint256 _percent,
1521         bool _Enabled
1522     ) external onlyOwner {
1523         require(
1524             _frequencyInSeconds >= 600,
1525             "cannot set buyback more often than every 10 minutes"
1526         );
1527         require(
1528             _percent <= 1000 && _percent >= 0,
1529             "Must set auto LP burn percent between 0% and 10%"
1530         );
1531         lpBurnFrequency = _frequencyInSeconds;
1532         percentForLPBurn = _percent;
1533         lpBurnEnabled = _Enabled;
1534     }
1535 
1536     function autoBurnLiquidityPairTokens() internal returns (bool) {
1537         lastLpBurnTime = block.timestamp;
1538 
1539         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1540 
1541         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1542             10000
1543         );
1544 
1545         if (amountToBurn > 0) {
1546             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1547         }
1548 
1549         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1550         pair.sync();
1551         emit AutoNukeLP();
1552         return true;
1553     }
1554 
1555     function manualBurnLiquidityPairTokens(uint256 percent)
1556     external
1557     onlyOwner
1558     returns (bool)
1559     {
1560         require(
1561             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1562             "Must wait for cooldown to finish"
1563         );
1564         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1565         lastManualLpBurnTime = block.timestamp;
1566 
1567         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1568 
1569         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1570 
1571         if (amountToBurn > 0) {
1572             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1573         }
1574 
1575         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1576         pair.sync();
1577         emit ManualNukeLP();
1578         return true;
1579     }
1580 }