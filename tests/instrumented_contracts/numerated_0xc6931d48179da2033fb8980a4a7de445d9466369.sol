1 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity >=0.6.2;
5 
6 interface IUniswapV2Router01 {
7     function factory() external pure returns (address);
8     function WETH() external pure returns (address);
9 
10     function addLiquidity(
11         address tokenA,
12         address tokenB,
13         uint amountADesired,
14         uint amountBDesired,
15         uint amountAMin,
16         uint amountBMin,
17         address to,
18         uint deadline
19     ) external returns (uint amountA, uint amountB, uint liquidity);
20     function addLiquidityETH(
21         address token,
22         uint amountTokenDesired,
23         uint amountTokenMin,
24         uint amountETHMin,
25         address to,
26         uint deadline
27     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
28     function removeLiquidity(
29         address tokenA,
30         address tokenB,
31         uint liquidity,
32         uint amountAMin,
33         uint amountBMin,
34         address to,
35         uint deadline
36     ) external returns (uint amountA, uint amountB);
37     function removeLiquidityETH(
38         address token,
39         uint liquidity,
40         uint amountTokenMin,
41         uint amountETHMin,
42         address to,
43         uint deadline
44     ) external returns (uint amountToken, uint amountETH);
45     function removeLiquidityWithPermit(
46         address tokenA,
47         address tokenB,
48         uint liquidity,
49         uint amountAMin,
50         uint amountBMin,
51         address to,
52         uint deadline,
53         bool approveMax, uint8 v, bytes32 r, bytes32 s
54     ) external returns (uint amountA, uint amountB);
55     function removeLiquidityETHWithPermit(
56         address token,
57         uint liquidity,
58         uint amountTokenMin,
59         uint amountETHMin,
60         address to,
61         uint deadline,
62         bool approveMax, uint8 v, bytes32 r, bytes32 s
63     ) external returns (uint amountToken, uint amountETH);
64     function swapExactTokensForTokens(
65         uint amountIn,
66         uint amountOutMin,
67         address[] calldata path,
68         address to,
69         uint deadline
70     ) external returns (uint[] memory amounts);
71     function swapTokensForExactTokens(
72         uint amountOut,
73         uint amountInMax,
74         address[] calldata path,
75         address to,
76         uint deadline
77     ) external returns (uint[] memory amounts);
78     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
79         external
80         payable
81         returns (uint[] memory amounts);
82     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
83         external
84         returns (uint[] memory amounts);
85     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
86         external
87         returns (uint[] memory amounts);
88     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
89         external
90         payable
91         returns (uint[] memory amounts);
92 
93     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
94     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
95     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
96     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
97     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
98 }
99 
100 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
101 
102 pragma solidity >=0.6.2;
103 
104 
105 interface IUniswapV2Router02 is IUniswapV2Router01 {
106     function removeLiquidityETHSupportingFeeOnTransferTokens(
107         address token,
108         uint liquidity,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external returns (uint amountETH);
114     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
115         address token,
116         uint liquidity,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline,
121         bool approveMax, uint8 v, bytes32 r, bytes32 s
122     ) external returns (uint amountETH);
123 
124     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
125         uint amountIn,
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external;
131     function swapExactETHForTokensSupportingFeeOnTransferTokens(
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external payable;
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint amountIn,
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external;
144 }
145 
146 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
147 
148 pragma solidity >=0.5.0;
149 
150 interface IUniswapV2Pair {
151     event Approval(address indexed owner, address indexed spender, uint value);
152     event Transfer(address indexed from, address indexed to, uint value);
153 
154     function name() external pure returns (string memory);
155     function symbol() external pure returns (string memory);
156     function decimals() external pure returns (uint8);
157     function totalSupply() external view returns (uint);
158     function balanceOf(address owner) external view returns (uint);
159     function allowance(address owner, address spender) external view returns (uint);
160 
161     function approve(address spender, uint value) external returns (bool);
162     function transfer(address to, uint value) external returns (bool);
163     function transferFrom(address from, address to, uint value) external returns (bool);
164 
165     function DOMAIN_SEPARATOR() external view returns (bytes32);
166     function PERMIT_TYPEHASH() external pure returns (bytes32);
167     function nonces(address owner) external view returns (uint);
168 
169     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
170 
171     event Mint(address indexed sender, uint amount0, uint amount1);
172     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
173     event Swap(
174         address indexed sender,
175         uint amount0In,
176         uint amount1In,
177         uint amount0Out,
178         uint amount1Out,
179         address indexed to
180     );
181     event Sync(uint112 reserve0, uint112 reserve1);
182 
183     function MINIMUM_LIQUIDITY() external pure returns (uint);
184     function factory() external view returns (address);
185     function token0() external view returns (address);
186     function token1() external view returns (address);
187     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
188     function price0CumulativeLast() external view returns (uint);
189     function price1CumulativeLast() external view returns (uint);
190     function kLast() external view returns (uint);
191 
192     function mint(address to) external returns (uint liquidity);
193     function burn(address to) external returns (uint amount0, uint amount1);
194     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
195     function skim(address to) external;
196     function sync() external;
197 
198     function initialize(address, address) external;
199 }
200 
201 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
202 
203 pragma solidity >=0.5.0;
204 
205 interface IUniswapV2Factory {
206     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
207 
208     function feeTo() external view returns (address);
209     function feeToSetter() external view returns (address);
210 
211     function getPair(address tokenA, address tokenB) external view returns (address pair);
212     function allPairs(uint) external view returns (address pair);
213     function allPairsLength() external view returns (uint);
214 
215     function createPair(address tokenA, address tokenB) external returns (address pair);
216 
217     function setFeeTo(address) external;
218     function setFeeToSetter(address) external;
219 }
220 
221 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
222 
223 
224 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 // CAUTION
229 // This version of SafeMath should only be used with Solidity 0.8 or later,
230 // because it relies on the compiler's built in overflow checks.
231 
232 /**
233  * @dev Wrappers over Solidity's arithmetic operations.
234  *
235  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
236  * now has built in overflow checking.
237  */
238 library SafeMath {
239     /**
240      * @dev Returns the addition of two unsigned integers, with an overflow flag.
241      *
242      * _Available since v3.4._
243      */
244     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
245         unchecked {
246             uint256 c = a + b;
247             if (c < a) return (false, 0);
248             return (true, c);
249         }
250     }
251 
252     /**
253      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
254      *
255      * _Available since v3.4._
256      */
257     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
258         unchecked {
259             if (b > a) return (false, 0);
260             return (true, a - b);
261         }
262     }
263 
264     /**
265      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
266      *
267      * _Available since v3.4._
268      */
269     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
270         unchecked {
271             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
272             // benefit is lost if 'b' is also tested.
273             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
274             if (a == 0) return (true, 0);
275             uint256 c = a * b;
276             if (c / a != b) return (false, 0);
277             return (true, c);
278         }
279     }
280 
281     /**
282      * @dev Returns the division of two unsigned integers, with a division by zero flag.
283      *
284      * _Available since v3.4._
285      */
286     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
287         unchecked {
288             if (b == 0) return (false, 0);
289             return (true, a / b);
290         }
291     }
292 
293     /**
294      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
295      *
296      * _Available since v3.4._
297      */
298     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
299         unchecked {
300             if (b == 0) return (false, 0);
301             return (true, a % b);
302         }
303     }
304 
305     /**
306      * @dev Returns the addition of two unsigned integers, reverting on
307      * overflow.
308      *
309      * Counterpart to Solidity's `+` operator.
310      *
311      * Requirements:
312      *
313      * - Addition cannot overflow.
314      */
315     function add(uint256 a, uint256 b) internal pure returns (uint256) {
316         return a + b;
317     }
318 
319     /**
320      * @dev Returns the subtraction of two unsigned integers, reverting on
321      * overflow (when the result is negative).
322      *
323      * Counterpart to Solidity's `-` operator.
324      *
325      * Requirements:
326      *
327      * - Subtraction cannot overflow.
328      */
329     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
330         return a - b;
331     }
332 
333     /**
334      * @dev Returns the multiplication of two unsigned integers, reverting on
335      * overflow.
336      *
337      * Counterpart to Solidity's `*` operator.
338      *
339      * Requirements:
340      *
341      * - Multiplication cannot overflow.
342      */
343     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
344         return a * b;
345     }
346 
347     /**
348      * @dev Returns the integer division of two unsigned integers, reverting on
349      * division by zero. The result is rounded towards zero.
350      *
351      * Counterpart to Solidity's `/` operator.
352      *
353      * Requirements:
354      *
355      * - The divisor cannot be zero.
356      */
357     function div(uint256 a, uint256 b) internal pure returns (uint256) {
358         return a / b;
359     }
360 
361     /**
362      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
363      * reverting when dividing by zero.
364      *
365      * Counterpart to Solidity's `%` operator. This function uses a `revert`
366      * opcode (which leaves remaining gas untouched) while Solidity uses an
367      * invalid opcode to revert (consuming all remaining gas).
368      *
369      * Requirements:
370      *
371      * - The divisor cannot be zero.
372      */
373     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
374         return a % b;
375     }
376 
377     /**
378      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
379      * overflow (when the result is negative).
380      *
381      * CAUTION: This function is deprecated because it requires allocating memory for the error
382      * message unnecessarily. For custom revert reasons use {trySub}.
383      *
384      * Counterpart to Solidity's `-` operator.
385      *
386      * Requirements:
387      *
388      * - Subtraction cannot overflow.
389      */
390     function sub(
391         uint256 a,
392         uint256 b,
393         string memory errorMessage
394     ) internal pure returns (uint256) {
395         unchecked {
396             require(b <= a, errorMessage);
397             return a - b;
398         }
399     }
400 
401     /**
402      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
403      * division by zero. The result is rounded towards zero.
404      *
405      * Counterpart to Solidity's `/` operator. Note: this function uses a
406      * `revert` opcode (which leaves remaining gas untouched) while Solidity
407      * uses an invalid opcode to revert (consuming all remaining gas).
408      *
409      * Requirements:
410      *
411      * - The divisor cannot be zero.
412      */
413     function div(
414         uint256 a,
415         uint256 b,
416         string memory errorMessage
417     ) internal pure returns (uint256) {
418         unchecked {
419             require(b > 0, errorMessage);
420             return a / b;
421         }
422     }
423 
424     /**
425      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
426      * reverting with custom message when dividing by zero.
427      *
428      * CAUTION: This function is deprecated because it requires allocating memory for the error
429      * message unnecessarily. For custom revert reasons use {tryMod}.
430      *
431      * Counterpart to Solidity's `%` operator. This function uses a `revert`
432      * opcode (which leaves remaining gas untouched) while Solidity uses an
433      * invalid opcode to revert (consuming all remaining gas).
434      *
435      * Requirements:
436      *
437      * - The divisor cannot be zero.
438      */
439     function mod(
440         uint256 a,
441         uint256 b,
442         string memory errorMessage
443     ) internal pure returns (uint256) {
444         unchecked {
445             require(b > 0, errorMessage);
446             return a % b;
447         }
448     }
449 }
450 
451 // File: @openzeppelin/contracts/utils/Context.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev Provides information about the current execution context, including the
460  * sender of the transaction and its data. While these are generally available
461  * via msg.sender and msg.data, they should not be accessed in such a direct
462  * manner, since when dealing with meta-transactions the account sending and
463  * paying for execution may not be the actual sender (as far as an application
464  * is concerned).
465  *
466  * This contract is only required for intermediate, library-like contracts.
467  */
468 abstract contract Context {
469     function _msgSender() internal view virtual returns (address) {
470         return msg.sender;
471     }
472 
473     function _msgData() internal view virtual returns (bytes calldata) {
474         return msg.data;
475     }
476 }
477 
478 // File: @openzeppelin/contracts/access/Ownable.sol
479 
480 
481 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 
486 /**
487  * @dev Contract module which provides a basic access control mechanism, where
488  * there is an account (an owner) that can be granted exclusive access to
489  * specific functions.
490  *
491  * By default, the owner account will be the one that deploys the contract. This
492  * can later be changed with {transferOwnership}.
493  *
494  * This module is used through inheritance. It will make available the modifier
495  * `onlyOwner`, which can be applied to your functions to restrict their use to
496  * the owner.
497  */
498 abstract contract Ownable is Context {
499     address private _owner;
500 
501     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
502 
503     /**
504      * @dev Initializes the contract setting the deployer as the initial owner.
505      */
506     constructor() {
507         _transferOwnership(_msgSender());
508     }
509 
510     /**
511      * @dev Throws if called by any account other than the owner.
512      */
513     modifier onlyOwner() {
514         _checkOwner();
515         _;
516     }
517 
518     /**
519      * @dev Returns the address of the current owner.
520      */
521     function owner() public view virtual returns (address) {
522         return _owner;
523     }
524 
525     /**
526      * @dev Throws if the sender is not the owner.
527      */
528     function _checkOwner() internal view virtual {
529         require(owner() == _msgSender(), "Ownable: caller is not the owner");
530     }
531 
532     /**
533      * @dev Leaves the contract without owner. It will not be possible to call
534      * `onlyOwner` functions anymore. Can only be called by the current owner.
535      *
536      * NOTE: Renouncing ownership will leave the contract without an owner,
537      * thereby removing any functionality that is only available to the owner.
538      */
539     function renounceOwnership() public virtual onlyOwner {
540         _transferOwnership(address(0));
541     }
542 
543     /**
544      * @dev Transfers ownership of the contract to a new account (`newOwner`).
545      * Can only be called by the current owner.
546      */
547     function transferOwnership(address newOwner) public virtual onlyOwner {
548         require(newOwner != address(0), "Ownable: new owner is the zero address");
549         _transferOwnership(newOwner);
550     }
551 
552     /**
553      * @dev Transfers ownership of the contract to a new account (`newOwner`).
554      * Internal function without access restriction.
555      */
556     function _transferOwnership(address newOwner) internal virtual {
557         address oldOwner = _owner;
558         _owner = newOwner;
559         emit OwnershipTransferred(oldOwner, newOwner);
560     }
561 }
562 
563 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
564 
565 
566 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 /**
571  * @dev Interface of the ERC20 standard as defined in the EIP.
572  */
573 interface IERC20 {
574     /**
575      * @dev Emitted when `value` tokens are moved from one account (`from`) to
576      * another (`to`).
577      *
578      * Note that `value` may be zero.
579      */
580     event Transfer(address indexed from, address indexed to, uint256 value);
581 
582     /**
583      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
584      * a call to {approve}. `value` is the new allowance.
585      */
586     event Approval(address indexed owner, address indexed spender, uint256 value);
587 
588     /**
589      * @dev Returns the amount of tokens in existence.
590      */
591     function totalSupply() external view returns (uint256);
592 
593     /**
594      * @dev Returns the amount of tokens owned by `account`.
595      */
596     function balanceOf(address account) external view returns (uint256);
597 
598     /**
599      * @dev Moves `amount` tokens from the caller's account to `to`.
600      *
601      * Returns a boolean value indicating whether the operation succeeded.
602      *
603      * Emits a {Transfer} event.
604      */
605     function transfer(address to, uint256 amount) external returns (bool);
606 
607     /**
608      * @dev Returns the remaining number of tokens that `spender` will be
609      * allowed to spend on behalf of `owner` through {transferFrom}. This is
610      * zero by default.
611      *
612      * This value changes when {approve} or {transferFrom} are called.
613      */
614     function allowance(address owner, address spender) external view returns (uint256);
615 
616     /**
617      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
618      *
619      * Returns a boolean value indicating whether the operation succeeded.
620      *
621      * IMPORTANT: Beware that changing an allowance with this method brings the risk
622      * that someone may use both the old and the new allowance by unfortunate
623      * transaction ordering. One possible solution to mitigate this race
624      * condition is to first reduce the spender's allowance to 0 and set the
625      * desired value afterwards:
626      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
627      *
628      * Emits an {Approval} event.
629      */
630     function approve(address spender, uint256 amount) external returns (bool);
631 
632     /**
633      * @dev Moves `amount` tokens from `from` to `to` using the
634      * allowance mechanism. `amount` is then deducted from the caller's
635      * allowance.
636      *
637      * Returns a boolean value indicating whether the operation succeeded.
638      *
639      * Emits a {Transfer} event.
640      */
641     function transferFrom(
642         address from,
643         address to,
644         uint256 amount
645     ) external returns (bool);
646 }
647 
648 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
649 
650 
651 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 
656 /**
657  * @dev Interface for the optional metadata functions from the ERC20 standard.
658  *
659  * _Available since v4.1._
660  */
661 interface IERC20Metadata is IERC20 {
662     /**
663      * @dev Returns the name of the token.
664      */
665     function name() external view returns (string memory);
666 
667     /**
668      * @dev Returns the symbol of the token.
669      */
670     function symbol() external view returns (string memory);
671 
672     /**
673      * @dev Returns the decimals places of the token.
674      */
675     function decimals() external view returns (uint8);
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
679 
680 
681 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 
687 
688 /**
689  * @dev Implementation of the {IERC20} interface.
690  *
691  * This implementation is agnostic to the way tokens are created. This means
692  * that a supply mechanism has to be added in a derived contract using {_mint}.
693  * For a generic mechanism see {ERC20PresetMinterPauser}.
694  *
695  * TIP: For a detailed writeup see our guide
696  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
697  * to implement supply mechanisms].
698  *
699  * We have followed general OpenZeppelin Contracts guidelines: functions revert
700  * instead returning `false` on failure. This behavior is nonetheless
701  * conventional and does not conflict with the expectations of ERC20
702  * applications.
703  *
704  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
705  * This allows applications to reconstruct the allowance for all accounts just
706  * by listening to said events. Other implementations of the EIP may not emit
707  * these events, as it isn't required by the specification.
708  *
709  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
710  * functions have been added to mitigate the well-known issues around setting
711  * allowances. See {IERC20-approve}.
712  */
713 contract ERC20 is Context, IERC20, IERC20Metadata {
714     mapping(address => uint256) private _balances;
715 
716     mapping(address => mapping(address => uint256)) private _allowances;
717 
718     uint256 private _totalSupply;
719 
720     string private _name;
721     string private _symbol;
722 
723     /**
724      * @dev Sets the values for {name} and {symbol}.
725      *
726      * The default value of {decimals} is 18. To select a different value for
727      * {decimals} you should overload it.
728      *
729      * All two of these values are immutable: they can only be set once during
730      * construction.
731      */
732     constructor(string memory name_, string memory symbol_) {
733         _name = name_;
734         _symbol = symbol_;
735     }
736 
737     /**
738      * @dev Returns the name of the token.
739      */
740     function name() public view virtual override returns (string memory) {
741         return _name;
742     }
743 
744     /**
745      * @dev Returns the symbol of the token, usually a shorter version of the
746      * name.
747      */
748     function symbol() public view virtual override returns (string memory) {
749         return _symbol;
750     }
751 
752     /**
753      * @dev Returns the number of decimals used to get its user representation.
754      * For example, if `decimals` equals `2`, a balance of `505` tokens should
755      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
756      *
757      * Tokens usually opt for a value of 18, imitating the relationship between
758      * Ether and Wei. This is the value {ERC20} uses, unless this function is
759      * overridden;
760      *
761      * NOTE: This information is only used for _display_ purposes: it in
762      * no way affects any of the arithmetic of the contract, including
763      * {IERC20-balanceOf} and {IERC20-transfer}.
764      */
765     function decimals() public view virtual override returns (uint8) {
766         return 18;
767     }
768 
769     /**
770      * @dev See {IERC20-totalSupply}.
771      */
772     function totalSupply() public view virtual override returns (uint256) {
773         return _totalSupply;
774     }
775 
776     /**
777      * @dev See {IERC20-balanceOf}.
778      */
779     function balanceOf(address account) public view virtual override returns (uint256) {
780         return _balances[account];
781     }
782 
783     /**
784      * @dev See {IERC20-transfer}.
785      *
786      * Requirements:
787      *
788      * - `to` cannot be the zero address.
789      * - the caller must have a balance of at least `amount`.
790      */
791     function transfer(address to, uint256 amount) public virtual override returns (bool) {
792         address owner = _msgSender();
793         _transfer(owner, to, amount);
794         return true;
795     }
796 
797     /**
798      * @dev See {IERC20-allowance}.
799      */
800     function allowance(address owner, address spender) public view virtual override returns (uint256) {
801         return _allowances[owner][spender];
802     }
803 
804     /**
805      * @dev See {IERC20-approve}.
806      *
807      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
808      * `transferFrom`. This is semantically equivalent to an infinite approval.
809      *
810      * Requirements:
811      *
812      * - `spender` cannot be the zero address.
813      */
814     function approve(address spender, uint256 amount) public virtual override returns (bool) {
815         address owner = _msgSender();
816         _approve(owner, spender, amount);
817         return true;
818     }
819 
820     /**
821      * @dev See {IERC20-transferFrom}.
822      *
823      * Emits an {Approval} event indicating the updated allowance. This is not
824      * required by the EIP. See the note at the beginning of {ERC20}.
825      *
826      * NOTE: Does not update the allowance if the current allowance
827      * is the maximum `uint256`.
828      *
829      * Requirements:
830      *
831      * - `from` and `to` cannot be the zero address.
832      * - `from` must have a balance of at least `amount`.
833      * - the caller must have allowance for ``from``'s tokens of at least
834      * `amount`.
835      */
836     function transferFrom(
837         address from,
838         address to,
839         uint256 amount
840     ) public virtual override returns (bool) {
841         address spender = _msgSender();
842         _spendAllowance(from, spender, amount);
843         _transfer(from, to, amount);
844         return true;
845     }
846 
847     /**
848      * @dev Atomically increases the allowance granted to `spender` by the caller.
849      *
850      * This is an alternative to {approve} that can be used as a mitigation for
851      * problems described in {IERC20-approve}.
852      *
853      * Emits an {Approval} event indicating the updated allowance.
854      *
855      * Requirements:
856      *
857      * - `spender` cannot be the zero address.
858      */
859     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
860         address owner = _msgSender();
861         _approve(owner, spender, allowance(owner, spender) + addedValue);
862         return true;
863     }
864 
865     /**
866      * @dev Atomically decreases the allowance granted to `spender` by the caller.
867      *
868      * This is an alternative to {approve} that can be used as a mitigation for
869      * problems described in {IERC20-approve}.
870      *
871      * Emits an {Approval} event indicating the updated allowance.
872      *
873      * Requirements:
874      *
875      * - `spender` cannot be the zero address.
876      * - `spender` must have allowance for the caller of at least
877      * `subtractedValue`.
878      */
879     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
880         address owner = _msgSender();
881         uint256 currentAllowance = allowance(owner, spender);
882         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
883         unchecked {
884             _approve(owner, spender, currentAllowance - subtractedValue);
885         }
886 
887         return true;
888     }
889 
890     /**
891      * @dev Moves `amount` of tokens from `from` to `to`.
892      *
893      * This internal function is equivalent to {transfer}, and can be used to
894      * e.g. implement automatic token fees, slashing mechanisms, etc.
895      *
896      * Emits a {Transfer} event.
897      *
898      * Requirements:
899      *
900      * - `from` cannot be the zero address.
901      * - `to` cannot be the zero address.
902      * - `from` must have a balance of at least `amount`.
903      */
904     function _transfer(
905         address from,
906         address to,
907         uint256 amount
908     ) internal virtual {
909         require(from != address(0), "ERC20: transfer from the zero address");
910         require(to != address(0), "ERC20: transfer to the zero address");
911 
912         _beforeTokenTransfer(from, to, amount);
913 
914         uint256 fromBalance = _balances[from];
915         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
916         unchecked {
917             _balances[from] = fromBalance - amount;
918         }
919         _balances[to] += amount;
920 
921         emit Transfer(from, to, amount);
922 
923         _afterTokenTransfer(from, to, amount);
924     }
925 
926     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
927      * the total supply.
928      *
929      * Emits a {Transfer} event with `from` set to the zero address.
930      *
931      * Requirements:
932      *
933      * - `account` cannot be the zero address.
934      */
935     function _mint(address account, uint256 amount) internal virtual {
936         require(account != address(0), "ERC20: mint to the zero address");
937 
938         _beforeTokenTransfer(address(0), account, amount);
939 
940         _totalSupply += amount;
941         _balances[account] += amount;
942         emit Transfer(address(0), account, amount);
943 
944         _afterTokenTransfer(address(0), account, amount);
945     }
946 
947     /**
948      * @dev Destroys `amount` tokens from `account`, reducing the
949      * total supply.
950      *
951      * Emits a {Transfer} event with `to` set to the zero address.
952      *
953      * Requirements:
954      *
955      * - `account` cannot be the zero address.
956      * - `account` must have at least `amount` tokens.
957      */
958     function _burn(address account, uint256 amount) internal virtual {
959         require(account != address(0), "ERC20: burn from the zero address");
960 
961         _beforeTokenTransfer(account, address(0), amount);
962 
963         uint256 accountBalance = _balances[account];
964         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
965         unchecked {
966             _balances[account] = accountBalance - amount;
967         }
968         _totalSupply -= amount;
969 
970         emit Transfer(account, address(0), amount);
971 
972         _afterTokenTransfer(account, address(0), amount);
973     }
974 
975     /**
976      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
977      *
978      * This internal function is equivalent to `approve`, and can be used to
979      * e.g. set automatic allowances for certain subsystems, etc.
980      *
981      * Emits an {Approval} event.
982      *
983      * Requirements:
984      *
985      * - `owner` cannot be the zero address.
986      * - `spender` cannot be the zero address.
987      */
988     function _approve(
989         address owner,
990         address spender,
991         uint256 amount
992     ) internal virtual {
993         require(owner != address(0), "ERC20: approve from the zero address");
994         require(spender != address(0), "ERC20: approve to the zero address");
995 
996         _allowances[owner][spender] = amount;
997         emit Approval(owner, spender, amount);
998     }
999 
1000     /**
1001      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1002      *
1003      * Does not update the allowance amount in case of infinite allowance.
1004      * Revert if not enough allowance is available.
1005      *
1006      * Might emit an {Approval} event.
1007      */
1008     function _spendAllowance(
1009         address owner,
1010         address spender,
1011         uint256 amount
1012     ) internal virtual {
1013         uint256 currentAllowance = allowance(owner, spender);
1014         if (currentAllowance != type(uint256).max) {
1015             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1016             unchecked {
1017                 _approve(owner, spender, currentAllowance - amount);
1018             }
1019         }
1020     }
1021 
1022     /**
1023      * @dev Hook that is called before any transfer of tokens. This includes
1024      * minting and burning.
1025      *
1026      * Calling conditions:
1027      *
1028      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1029      * will be transferred to `to`.
1030      * - when `from` is zero, `amount` tokens will be minted for `to`.
1031      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1032      * - `from` and `to` are never both zero.
1033      *
1034      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1035      */
1036     function _beforeTokenTransfer(
1037         address from,
1038         address to,
1039         uint256 amount
1040     ) internal virtual {}
1041 
1042     /**
1043      * @dev Hook that is called after any transfer of tokens. This includes
1044      * minting and burning.
1045      *
1046      * Calling conditions:
1047      *
1048      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1049      * has been transferred to `to`.
1050      * - when `from` is zero, `amount` tokens have been minted for `to`.
1051      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1052      * - `from` and `to` are never both zero.
1053      *
1054      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1055      */
1056     function _afterTokenTransfer(
1057         address from,
1058         address to,
1059         uint256 amount
1060     ) internal virtual {}
1061 }
1062 
1063 
1064 
1065 
1066 pragma solidity ^0.8.0;
1067 
1068 
1069 
1070 
1071 
1072 
1073 
1074 contract Lucid is ERC20, Ownable {
1075     using SafeMath for uint256;
1076 
1077     IUniswapV2Router02 private uniswapV2Router;
1078     address private uniswapV2Pair;
1079 
1080     mapping(address => bool) private _isBlacklisted;
1081     bool private _swapping;
1082     uint256 private _launchTime;
1083     uint256 private _launchBlock;
1084 
1085     address private feeWallet;
1086 
1087     uint256 public maxTransactionAmount;
1088     uint256 public swapTokensAtAmount;
1089     uint256 public maxWallet;
1090 
1091     bool public limitsInEffect = true;
1092     bool public tradingActive = false;
1093     bool public _reduceFee = false;
1094     uint256 private _reduceTime;
1095     uint256 deadBlocks = 0;
1096 
1097     mapping(address => uint256) private _holderLastTransferTimestamp;
1098     bool public transferDelayEnabled = false;
1099 
1100     uint256 private _marketingFee;
1101 
1102     mapping(address => bool) private _isExcludedFromFees;
1103     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1104 
1105     mapping(address => uint256) private _holderFirstBuyTimestamp;
1106 
1107     mapping(address => bool) private automatedMarketMakerPairs;
1108 
1109     event ExcludeFromFees(address indexed account, bool isExcluded);
1110     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1111     event feeWalletUpdated(
1112         address indexed newWallet,
1113         address indexed oldWallet
1114     );
1115 
1116     address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
1117 
1118     constructor() ERC20("Lucid Tech", "LUCID") {
1119         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1120             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1121         );
1122 
1123         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1124         uniswapV2Router = _uniswapV2Router;
1125 
1126         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1127         .createPair(address(this), USDC);
1128         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1129         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1130 
1131         uint256 totalSupply = 100_000_000 * 1e18;
1132 
1133         maxTransactionAmount = (totalSupply * 15) / 1000;
1134         maxWallet = (totalSupply * 15) / 1000;
1135         swapTokensAtAmount = (totalSupply * 15) / 10000;
1136 
1137         _marketingFee = 5;
1138 
1139         feeWallet = address(owner());
1140         // set as fee wallet
1141 
1142         // exclude from paying fees or having max transaction amount
1143         excludeFromFees(owner(), true);
1144         excludeFromFees(address(this), true);
1145         excludeFromFees(address(0xdead), true);
1146 
1147         excludeFromMaxTransaction(owner(), true);
1148         excludeFromMaxTransaction(address(this), true);
1149         excludeFromMaxTransaction(address(0xdead), true);
1150 
1151         _approve(owner(), address(_uniswapV2Router), type(uint256).max);
1152 
1153         ERC20(USDC).approve(address(_uniswapV2Router), type(uint256).max);
1154         ERC20(USDC).approve(address(this), type(uint256).max);
1155 
1156         _mint(owner(), totalSupply);
1157     }
1158 
1159     function readySteadyGo() external onlyOwner {
1160         deadBlocks = 0;
1161         tradingActive = true;
1162         _launchTime = block.timestamp;
1163         _launchBlock = block.number;
1164     }
1165 
1166     // remove limits after token is stable
1167     function removeLimits() external onlyOwner returns (bool) {
1168         limitsInEffect = false;
1169         return true;
1170     }
1171 
1172     // disable Transfer delay - cannot be reenabled
1173     function disableTransferDelay() external onlyOwner returns (bool) {
1174         transferDelayEnabled = false;
1175         return true;
1176     }
1177 
1178     // change the minimum amount of tokens to sell from fees
1179     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1180         require(newAmount >= (totalSupply() * 1) / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1181         require(newAmount <= (totalSupply() * 5) / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1182         swapTokensAtAmount = newAmount;
1183         return true;
1184     }
1185 
1186     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1187         require(newNum >= ((totalSupply() * 1) / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1188         maxTransactionAmount = newNum * 1e18;
1189     }
1190 
1191     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1192         require(newNum >= ((totalSupply() * 5) / 1000) / 1e18, "Cannot set maxWallet lower than 0.5%");
1193         maxWallet = newNum * 1e18;
1194     }
1195 
1196     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1197         _isExcludedMaxTransactionAmount[updAds] = isEx;
1198     }
1199 
1200     function updateFees(uint256 marketingFee) external onlyOwner {
1201         _marketingFee = marketingFee;
1202         _reduceFee = false;
1203         require(_marketingFee <= 10, "Must keep fees at 10% or less");
1204     }
1205 
1206     function updateReduceFee(bool reduceFee) external onlyOwner {
1207         _reduceFee = reduceFee;
1208     }
1209 
1210     function excludeFromFees(address account, bool excluded) public onlyOwner {
1211         _isExcludedFromFees[account] = excluded;
1212         emit ExcludeFromFees(account, excluded);
1213     }
1214 
1215     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1216         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1217         _setAutomatedMarketMakerPair(pair, value);
1218     }
1219 
1220     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1221         automatedMarketMakerPairs[pair] = value;
1222         emit SetAutomatedMarketMakerPair(pair, value);
1223     }
1224 
1225     function updateFeeWallet(address newWallet) external onlyOwner {
1226         emit feeWalletUpdated(newWallet, feeWallet);
1227         feeWallet = newWallet;
1228     }
1229 
1230     function isExcludedFromFees(address account) public view returns (bool) {
1231         return _isExcludedFromFees[account];
1232     }
1233 
1234     function getFee() public view returns (uint256) {
1235         return _getReducedFee(_marketingFee, 1);
1236     }
1237 
1238     function setBlacklisted(address[] memory blacklisted_) public onlyOwner {
1239         for (uint256 i = 0; i < blacklisted_.length; i++) {
1240             if (blacklisted_[i] != uniswapV2Pair && blacklisted_[i] != address(uniswapV2Router)) {
1241                 _isBlacklisted[blacklisted_[i]] = false;
1242             }
1243         }
1244     }
1245 
1246     function delBlacklisted(address[] memory blacklisted_) public onlyOwner {
1247         for (uint256 i = 0; i < blacklisted_.length; i++) {
1248             _isBlacklisted[blacklisted_[i]] = false;
1249         }
1250     }
1251 
1252     function isSniper(address addr) public view returns (bool) {
1253         return _isBlacklisted[addr];
1254     }
1255 
1256     function _transfer(
1257         address from,
1258         address to,
1259         uint256 amount
1260     ) internal override {
1261         require(from != address(0), "ERC20: transfer from the zero address");
1262         require(to != address(0), "ERC20: transfer to the zero address");
1263         require(!_isBlacklisted[from], "Your address has been marked as a sniper, you are unable to transfer or swap.");
1264         if (amount == 0) {
1265             super._transfer(from, to, 0);
1266             return;
1267         }
1268         if (tradingActive) {
1269             require(block.number >= _launchBlock + deadBlocks, "NOT BOT");
1270         }
1271         if (limitsInEffect) {
1272             if (
1273                 from != owner() &&
1274                 to != owner() &&
1275                 to != address(0) &&
1276                 to != address(0xdead) &&
1277                 !_swapping
1278             ) {
1279                 if (!tradingActive) {
1280                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1281                 }
1282 
1283                 if (balanceOf(to) == 0 && _holderFirstBuyTimestamp[to] == 0) {
1284                     _holderFirstBuyTimestamp[to] = block.timestamp;
1285                 }
1286 
1287                 if (transferDelayEnabled) {
1288                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
1289                         require(
1290                             _holderLastTransferTimestamp[tx.origin] < block.number,
1291                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1292                         );
1293                         _holderLastTransferTimestamp[tx.origin] = block.number;
1294                     }
1295                 }
1296 
1297                 // when buy
1298                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1299                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1300                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1301                 }
1302                 // when sell
1303                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1304                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1305                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1306                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1307                 }
1308             }
1309         }
1310 
1311         uint256 contractTokenBalance = balanceOf(address(this));
1312         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1313         if (
1314             canSwap &&
1315             !_swapping &&
1316             !automatedMarketMakerPairs[from] &&
1317             !_isExcludedFromFees[from] &&
1318             !_isExcludedFromFees[to]
1319         ) {
1320             _swapping = true;
1321             swapBack();
1322             _swapping = false;
1323         }
1324 
1325         bool takeFee = !_swapping;
1326 
1327         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1328             takeFee = false;
1329         }
1330 
1331         uint256 fees = 0;
1332         if (takeFee) {
1333             uint256 totalFees =  _getReducedFee(_marketingFee, 1);
1334             if (totalFees > 0) {
1335                 fees = amount.mul(totalFees).div(100);
1336                 if (fees > 0) {
1337                     super._transfer(from, address(this), fees);
1338                 }
1339                 amount -= fees;
1340             }
1341         }
1342 
1343         super._transfer(from, to, amount);
1344     }
1345 
1346     function _getReducedFee(uint256 initial, uint256 minFee) private view returns (uint256){
1347         if (!_reduceFee) {
1348             return initial;
1349         }
1350         uint256 time = block.timestamp - _launchTime;
1351         uint256 amountToReduce = time / 10 / 60;
1352         if (amountToReduce >= initial) {
1353             return minFee;
1354         }
1355         uint256 reducedAmount = initial - amountToReduce;
1356         return reducedAmount > minFee ? reducedAmount : minFee;
1357     }
1358 
1359     function _swapTokensForUSDC(uint256 tokenAmount) private {
1360         address[] memory path = new address[](2);
1361         path[0] = address(this);
1362         path[1] = USDC;
1363 
1364         _approve(address(this), address(uniswapV2Router), tokenAmount);
1365         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1366             tokenAmount,
1367             0,
1368             path,
1369             owner(),
1370             block.timestamp
1371         );
1372     }
1373 
1374     function swapBack() private {
1375         uint256 contractBalance = balanceOf(address(this));
1376         if (contractBalance == 0) return;
1377         if (contractBalance > swapTokensAtAmount) {
1378             contractBalance = swapTokensAtAmount;
1379         }
1380         uint256 amountToSwapForUSDC = contractBalance;
1381         _swapTokensForUSDC(contractBalance);
1382     }
1383 
1384     function importantMessageFromTeam(string memory input) external onlyOwner {}
1385 
1386     function forceSwap() external onlyOwner {
1387         _swapTokensForUSDC(balanceOf(address(this)));
1388     }
1389 
1390     function forceSend() external onlyOwner {
1391         uint256 balance = ERC20(USDC).balanceOf(address(this));
1392         _approve(address(this), address(uniswapV2Router), balance);
1393         ERC20(USDC).transfer(msg.sender, balance);
1394     }
1395 
1396     receive() external payable {}
1397 }