1 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
2 
3 pragma solidity >=0.6.2;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78         external
79         payable
80         returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82         external
83         returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
100 
101 pragma solidity >=0.6.2;
102 
103 
104 interface IUniswapV2Router02 is IUniswapV2Router01 {
105     function removeLiquidityETHSupportingFeeOnTransferTokens(
106         address token,
107         uint liquidity,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountETH);
113     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountETH);
122 
123     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130     function swapExactETHForTokensSupportingFeeOnTransferTokens(
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external payable;
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 }
144 
145 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
146 
147 pragma solidity >=0.5.0;
148 
149 interface IUniswapV2Pair {
150     event Approval(address indexed owner, address indexed spender, uint value);
151     event Transfer(address indexed from, address indexed to, uint value);
152 
153     function name() external pure returns (string memory);
154     function symbol() external pure returns (string memory);
155     function decimals() external pure returns (uint8);
156     function totalSupply() external view returns (uint);
157     function balanceOf(address owner) external view returns (uint);
158     function allowance(address owner, address spender) external view returns (uint);
159 
160     function approve(address spender, uint value) external returns (bool);
161     function transfer(address to, uint value) external returns (bool);
162     function transferFrom(address from, address to, uint value) external returns (bool);
163 
164     function DOMAIN_SEPARATOR() external view returns (bytes32);
165     function PERMIT_TYPEHASH() external pure returns (bytes32);
166     function nonces(address owner) external view returns (uint);
167 
168     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
169 
170     event Mint(address indexed sender, uint amount0, uint amount1);
171     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
172     event Swap(
173         address indexed sender,
174         uint amount0In,
175         uint amount1In,
176         uint amount0Out,
177         uint amount1Out,
178         address indexed to
179     );
180     event Sync(uint112 reserve0, uint112 reserve1);
181 
182     function MINIMUM_LIQUIDITY() external pure returns (uint);
183     function factory() external view returns (address);
184     function token0() external view returns (address);
185     function token1() external view returns (address);
186     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
187     function price0CumulativeLast() external view returns (uint);
188     function price1CumulativeLast() external view returns (uint);
189     function kLast() external view returns (uint);
190 
191     function mint(address to) external returns (uint liquidity);
192     function burn(address to) external returns (uint amount0, uint amount1);
193     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
194     function skim(address to) external;
195     function sync() external;
196 
197     function initialize(address, address) external;
198 }
199 
200 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
201 
202 pragma solidity >=0.5.0;
203 
204 interface IUniswapV2Factory {
205     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
206 
207     function feeTo() external view returns (address);
208     function feeToSetter() external view returns (address);
209 
210     function getPair(address tokenA, address tokenB) external view returns (address pair);
211     function allPairs(uint) external view returns (address pair);
212     function allPairsLength() external view returns (uint);
213 
214     function createPair(address tokenA, address tokenB) external returns (address pair);
215 
216     function setFeeTo(address) external;
217     function setFeeToSetter(address) external;
218 }
219 
220 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
221 
222 
223 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 // CAUTION
228 // This version of SafeMath should only be used with Solidity 0.8 or later,
229 // because it relies on the compiler's built in overflow checks.
230 
231 /**
232  * @dev Wrappers over Solidity's arithmetic operations.
233  *
234  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
235  * now has built in overflow checking.
236  */
237 library SafeMath {
238     /**
239      * @dev Returns the addition of two unsigned integers, with an overflow flag.
240      *
241      * _Available since v3.4._
242      */
243     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
244         unchecked {
245             uint256 c = a + b;
246             if (c < a) return (false, 0);
247             return (true, c);
248         }
249     }
250 
251     /**
252      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
253      *
254      * _Available since v3.4._
255      */
256     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257         unchecked {
258             if (b > a) return (false, 0);
259             return (true, a - b);
260         }
261     }
262 
263     /**
264      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
265      *
266      * _Available since v3.4._
267      */
268     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         unchecked {
270             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
271             // benefit is lost if 'b' is also tested.
272             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
273             if (a == 0) return (true, 0);
274             uint256 c = a * b;
275             if (c / a != b) return (false, 0);
276             return (true, c);
277         }
278     }
279 
280     /**
281      * @dev Returns the division of two unsigned integers, with a division by zero flag.
282      *
283      * _Available since v3.4._
284      */
285     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
286         unchecked {
287             if (b == 0) return (false, 0);
288             return (true, a / b);
289         }
290     }
291 
292     /**
293      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
294      *
295      * _Available since v3.4._
296      */
297     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
298         unchecked {
299             if (b == 0) return (false, 0);
300             return (true, a % b);
301         }
302     }
303 
304     /**
305      * @dev Returns the addition of two unsigned integers, reverting on
306      * overflow.
307      *
308      * Counterpart to Solidity's `+` operator.
309      *
310      * Requirements:
311      *
312      * - Addition cannot overflow.
313      */
314     function add(uint256 a, uint256 b) internal pure returns (uint256) {
315         return a + b;
316     }
317 
318     /**
319      * @dev Returns the subtraction of two unsigned integers, reverting on
320      * overflow (when the result is negative).
321      *
322      * Counterpart to Solidity's `-` operator.
323      *
324      * Requirements:
325      *
326      * - Subtraction cannot overflow.
327      */
328     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
329         return a - b;
330     }
331 
332     /**
333      * @dev Returns the multiplication of two unsigned integers, reverting on
334      * overflow.
335      *
336      * Counterpart to Solidity's `*` operator.
337      *
338      * Requirements:
339      *
340      * - Multiplication cannot overflow.
341      */
342     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
343         return a * b;
344     }
345 
346     /**
347      * @dev Returns the integer division of two unsigned integers, reverting on
348      * division by zero. The result is rounded towards zero.
349      *
350      * Counterpart to Solidity's `/` operator.
351      *
352      * Requirements:
353      *
354      * - The divisor cannot be zero.
355      */
356     function div(uint256 a, uint256 b) internal pure returns (uint256) {
357         return a / b;
358     }
359 
360     /**
361      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
362      * reverting when dividing by zero.
363      *
364      * Counterpart to Solidity's `%` operator. This function uses a `revert`
365      * opcode (which leaves remaining gas untouched) while Solidity uses an
366      * invalid opcode to revert (consuming all remaining gas).
367      *
368      * Requirements:
369      *
370      * - The divisor cannot be zero.
371      */
372     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
373         return a % b;
374     }
375 
376     /**
377      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
378      * overflow (when the result is negative).
379      *
380      * CAUTION: This function is deprecated because it requires allocating memory for the error
381      * message unnecessarily. For custom revert reasons use {trySub}.
382      *
383      * Counterpart to Solidity's `-` operator.
384      *
385      * Requirements:
386      *
387      * - Subtraction cannot overflow.
388      */
389     function sub(
390         uint256 a,
391         uint256 b,
392         string memory errorMessage
393     ) internal pure returns (uint256) {
394         unchecked {
395             require(b <= a, errorMessage);
396             return a - b;
397         }
398     }
399 
400     /**
401      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
402      * division by zero. The result is rounded towards zero.
403      *
404      * Counterpart to Solidity's `/` operator. Note: this function uses a
405      * `revert` opcode (which leaves remaining gas untouched) while Solidity
406      * uses an invalid opcode to revert (consuming all remaining gas).
407      *
408      * Requirements:
409      *
410      * - The divisor cannot be zero.
411      */
412     function div(
413         uint256 a,
414         uint256 b,
415         string memory errorMessage
416     ) internal pure returns (uint256) {
417         unchecked {
418             require(b > 0, errorMessage);
419             return a / b;
420         }
421     }
422 
423     /**
424      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
425      * reverting with custom message when dividing by zero.
426      *
427      * CAUTION: This function is deprecated because it requires allocating memory for the error
428      * message unnecessarily. For custom revert reasons use {tryMod}.
429      *
430      * Counterpart to Solidity's `%` operator. This function uses a `revert`
431      * opcode (which leaves remaining gas untouched) while Solidity uses an
432      * invalid opcode to revert (consuming all remaining gas).
433      *
434      * Requirements:
435      *
436      * - The divisor cannot be zero.
437      */
438     function mod(
439         uint256 a,
440         uint256 b,
441         string memory errorMessage
442     ) internal pure returns (uint256) {
443         unchecked {
444             require(b > 0, errorMessage);
445             return a % b;
446         }
447     }
448 }
449 
450 // File: @openzeppelin/contracts/utils/Context.sol
451 
452 
453 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @dev Provides information about the current execution context, including the
459  * sender of the transaction and its data. While these are generally available
460  * via msg.sender and msg.data, they should not be accessed in such a direct
461  * manner, since when dealing with meta-transactions the account sending and
462  * paying for execution may not be the actual sender (as far as an application
463  * is concerned).
464  *
465  * This contract is only required for intermediate, library-like contracts.
466  */
467 abstract contract Context {
468     function _msgSender() internal view virtual returns (address) {
469         return msg.sender;
470     }
471 
472     function _msgData() internal view virtual returns (bytes calldata) {
473         return msg.data;
474     }
475 }
476 
477 // File: @openzeppelin/contracts/access/Ownable.sol
478 
479 
480 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Contract module which provides a basic access control mechanism, where
487  * there is an account (an owner) that can be granted exclusive access to
488  * specific functions.
489  *
490  * By default, the owner account will be the one that deploys the contract. This
491  * can later be changed with {transferOwnership}.
492  *
493  * This module is used through inheritance. It will make available the modifier
494  * `onlyOwner`, which can be applied to your functions to restrict their use to
495  * the owner.
496  */
497 abstract contract Ownable is Context {
498     address private _owner;
499 
500     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
501 
502     /**
503      * @dev Initializes the contract setting the deployer as the initial owner.
504      */
505     constructor() {
506         _transferOwnership(_msgSender());
507     }
508 
509     /**
510      * @dev Throws if called by any account other than the owner.
511      */
512     modifier onlyOwner() {
513         _checkOwner();
514         _;
515     }
516 
517     /**
518      * @dev Returns the address of the current owner.
519      */
520     function owner() public view virtual returns (address) {
521         return _owner;
522     }
523 
524     /**
525      * @dev Throws if the sender is not the owner.
526      */
527     function _checkOwner() internal view virtual {
528         require(owner() == _msgSender(), "Ownable: caller is not the owner");
529     }
530 
531     /**
532      * @dev Leaves the contract without owner. It will not be possible to call
533      * `onlyOwner` functions anymore. Can only be called by the current owner.
534      *
535      * NOTE: Renouncing ownership will leave the contract without an owner,
536      * thereby removing any functionality that is only available to the owner.
537      */
538     function renounceOwnership() public virtual onlyOwner {
539         _transferOwnership(address(0));
540     }
541 
542     /**
543      * @dev Transfers ownership of the contract to a new account (`newOwner`).
544      * Can only be called by the current owner.
545      */
546     function transferOwnership(address newOwner) public virtual onlyOwner {
547         require(newOwner != address(0), "Ownable: new owner is the zero address");
548         _transferOwnership(newOwner);
549     }
550 
551     /**
552      * @dev Transfers ownership of the contract to a new account (`newOwner`).
553      * Internal function without access restriction.
554      */
555     function _transferOwnership(address newOwner) internal virtual {
556         address oldOwner = _owner;
557         _owner = newOwner;
558         emit OwnershipTransferred(oldOwner, newOwner);
559     }
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
563 
564 
565 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @dev Interface of the ERC20 standard as defined in the EIP.
571  */
572 interface IERC20 {
573     /**
574      * @dev Emitted when `value` tokens are moved from one account (`from`) to
575      * another (`to`).
576      *
577      * Note that `value` may be zero.
578      */
579     event Transfer(address indexed from, address indexed to, uint256 value);
580 
581     /**
582      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
583      * a call to {approve}. `value` is the new allowance.
584      */
585     event Approval(address indexed owner, address indexed spender, uint256 value);
586 
587     /**
588      * @dev Returns the amount of tokens in existence.
589      */
590     function totalSupply() external view returns (uint256);
591 
592     /**
593      * @dev Returns the amount of tokens owned by `account`.
594      */
595     function balanceOf(address account) external view returns (uint256);
596 
597     /**
598      * @dev Moves `amount` tokens from the caller's account to `to`.
599      *
600      * Returns a boolean value indicating whether the operation succeeded.
601      *
602      * Emits a {Transfer} event.
603      */
604     function transfer(address to, uint256 amount) external returns (bool);
605 
606     /**
607      * @dev Returns the remaining number of tokens that `spender` will be
608      * allowed to spend on behalf of `owner` through {transferFrom}. This is
609      * zero by default.
610      *
611      * This value changes when {approve} or {transferFrom} are called.
612      */
613     function allowance(address owner, address spender) external view returns (uint256);
614 
615     /**
616      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
617      *
618      * Returns a boolean value indicating whether the operation succeeded.
619      *
620      * IMPORTANT: Beware that changing an allowance with this method brings the risk
621      * that someone may use both the old and the new allowance by unfortunate
622      * transaction ordering. One possible solution to mitigate this race
623      * condition is to first reduce the spender's allowance to 0 and set the
624      * desired value afterwards:
625      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address spender, uint256 amount) external returns (bool);
630 
631     /**
632      * @dev Moves `amount` tokens from `from` to `to` using the
633      * allowance mechanism. `amount` is then deducted from the caller's
634      * allowance.
635      *
636      * Returns a boolean value indicating whether the operation succeeded.
637      *
638      * Emits a {Transfer} event.
639      */
640     function transferFrom(
641         address from,
642         address to,
643         uint256 amount
644     ) external returns (bool);
645 }
646 
647 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 /**
656  * @dev Interface for the optional metadata functions from the ERC20 standard.
657  *
658  * _Available since v4.1._
659  */
660 interface IERC20Metadata is IERC20 {
661     /**
662      * @dev Returns the name of the token.
663      */
664     function name() external view returns (string memory);
665 
666     /**
667      * @dev Returns the symbol of the token.
668      */
669     function symbol() external view returns (string memory);
670 
671     /**
672      * @dev Returns the decimals places of the token.
673      */
674     function decimals() external view returns (uint8);
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
678 
679 
680 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 
686 
687 /**
688  * @dev Implementation of the {IERC20} interface.
689  *
690  * This implementation is agnostic to the way tokens are created. This means
691  * that a supply mechanism has to be added in a derived contract using {_mint}.
692  * For a generic mechanism see {ERC20PresetMinterPauser}.
693  *
694  * TIP: For a detailed writeup see our guide
695  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
696  * to implement supply mechanisms].
697  *
698  * We have followed general OpenZeppelin Contracts guidelines: functions revert
699  * instead returning `false` on failure. This behavior is nonetheless
700  * conventional and does not conflict with the expectations of ERC20
701  * applications.
702  *
703  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
704  * This allows applications to reconstruct the allowance for all accounts just
705  * by listening to said events. Other implementations of the EIP may not emit
706  * these events, as it isn't required by the specification.
707  *
708  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
709  * functions have been added to mitigate the well-known issues around setting
710  * allowances. See {IERC20-approve}.
711  */
712 contract ERC20 is Context, IERC20, IERC20Metadata {
713     mapping(address => uint256) private _balances;
714 
715     mapping(address => mapping(address => uint256)) private _allowances;
716 
717     uint256 private _totalSupply;
718 
719     string private _name;
720     string private _symbol;
721 
722     /**
723      * @dev Sets the values for {name} and {symbol}.
724      *
725      * The default value of {decimals} is 18. To select a different value for
726      * {decimals} you should overload it.
727      *
728      * All two of these values are immutable: they can only be set once during
729      * construction.
730      */
731     constructor(string memory name_, string memory symbol_) {
732         _name = name_;
733         _symbol = symbol_;
734     }
735 
736     /**
737      * @dev Returns the name of the token.
738      */
739     function name() public view virtual override returns (string memory) {
740         return _name;
741     }
742 
743     /**
744      * @dev Returns the symbol of the token, usually a shorter version of the
745      * name.
746      */
747     function symbol() public view virtual override returns (string memory) {
748         return _symbol;
749     }
750 
751     /**
752      * @dev Returns the number of decimals used to get its user representation.
753      * For example, if `decimals` equals `2`, a balance of `505` tokens should
754      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
755      *
756      * Tokens usually opt for a value of 18, imitating the relationship between
757      * Ether and Wei. This is the value {ERC20} uses, unless this function is
758      * overridden;
759      *
760      * NOTE: This information is only used for _display_ purposes: it in
761      * no way affects any of the arithmetic of the contract, including
762      * {IERC20-balanceOf} and {IERC20-transfer}.
763      */
764     function decimals() public view virtual override returns (uint8) {
765         return 18;
766     }
767 
768     /**
769      * @dev See {IERC20-totalSupply}.
770      */
771     function totalSupply() public view virtual override returns (uint256) {
772         return _totalSupply;
773     }
774 
775     /**
776      * @dev See {IERC20-balanceOf}.
777      */
778     function balanceOf(address account) public view virtual override returns (uint256) {
779         return _balances[account];
780     }
781 
782     /**
783      * @dev See {IERC20-transfer}.
784      *
785      * Requirements:
786      *
787      * - `to` cannot be the zero address.
788      * - the caller must have a balance of at least `amount`.
789      */
790     function transfer(address to, uint256 amount) public virtual override returns (bool) {
791         address owner = _msgSender();
792         _transfer(owner, to, amount);
793         return true;
794     }
795 
796     /**
797      * @dev See {IERC20-allowance}.
798      */
799     function allowance(address owner, address spender) public view virtual override returns (uint256) {
800         return _allowances[owner][spender];
801     }
802 
803     /**
804      * @dev See {IERC20-approve}.
805      *
806      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
807      * `transferFrom`. This is semantically equivalent to an infinite approval.
808      *
809      * Requirements:
810      *
811      * - `spender` cannot be the zero address.
812      */
813     function approve(address spender, uint256 amount) public virtual override returns (bool) {
814         address owner = _msgSender();
815         _approve(owner, spender, amount);
816         return true;
817     }
818 
819     /**
820      * @dev See {IERC20-transferFrom}.
821      *
822      * Emits an {Approval} event indicating the updated allowance. This is not
823      * required by the EIP. See the note at the beginning of {ERC20}.
824      *
825      * NOTE: Does not update the allowance if the current allowance
826      * is the maximum `uint256`.
827      *
828      * Requirements:
829      *
830      * - `from` and `to` cannot be the zero address.
831      * - `from` must have a balance of at least `amount`.
832      * - the caller must have allowance for ``from``'s tokens of at least
833      * `amount`.
834      */
835     function transferFrom(
836         address from,
837         address to,
838         uint256 amount
839     ) public virtual override returns (bool) {
840         address spender = _msgSender();
841         _spendAllowance(from, spender, amount);
842         _transfer(from, to, amount);
843         return true;
844     }
845 
846     /**
847      * @dev Atomically increases the allowance granted to `spender` by the caller.
848      *
849      * This is an alternative to {approve} that can be used as a mitigation for
850      * problems described in {IERC20-approve}.
851      *
852      * Emits an {Approval} event indicating the updated allowance.
853      *
854      * Requirements:
855      *
856      * - `spender` cannot be the zero address.
857      */
858     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
859         address owner = _msgSender();
860         _approve(owner, spender, allowance(owner, spender) + addedValue);
861         return true;
862     }
863 
864     /**
865      * @dev Atomically decreases the allowance granted to `spender` by the caller.
866      *
867      * This is an alternative to {approve} that can be used as a mitigation for
868      * problems described in {IERC20-approve}.
869      *
870      * Emits an {Approval} event indicating the updated allowance.
871      *
872      * Requirements:
873      *
874      * - `spender` cannot be the zero address.
875      * - `spender` must have allowance for the caller of at least
876      * `subtractedValue`.
877      */
878     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
879         address owner = _msgSender();
880         uint256 currentAllowance = allowance(owner, spender);
881         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
882         unchecked {
883             _approve(owner, spender, currentAllowance - subtractedValue);
884         }
885 
886         return true;
887     }
888 
889     /**
890      * @dev Moves `amount` of tokens from `from` to `to`.
891      *
892      * This internal function is equivalent to {transfer}, and can be used to
893      * e.g. implement automatic token fees, slashing mechanisms, etc.
894      *
895      * Emits a {Transfer} event.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `from` must have a balance of at least `amount`.
902      */
903     function _transfer(
904         address from,
905         address to,
906         uint256 amount
907     ) internal virtual {
908         require(from != address(0), "ERC20: transfer from the zero address");
909         require(to != address(0), "ERC20: transfer to the zero address");
910 
911         _beforeTokenTransfer(from, to, amount);
912 
913         uint256 fromBalance = _balances[from];
914         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
915         unchecked {
916             _balances[from] = fromBalance - amount;
917         }
918         _balances[to] += amount;
919 
920         emit Transfer(from, to, amount);
921 
922         _afterTokenTransfer(from, to, amount);
923     }
924 
925     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
926      * the total supply.
927      *
928      * Emits a {Transfer} event with `from` set to the zero address.
929      *
930      * Requirements:
931      *
932      * - `account` cannot be the zero address.
933      */
934     function _mint(address account, uint256 amount) internal virtual {
935         require(account != address(0), "ERC20: mint to the zero address");
936 
937         _beforeTokenTransfer(address(0), account, amount);
938 
939         _totalSupply += amount;
940         _balances[account] += amount;
941         emit Transfer(address(0), account, amount);
942 
943         _afterTokenTransfer(address(0), account, amount);
944     }
945 
946     /**
947      * @dev Destroys `amount` tokens from `account`, reducing the
948      * total supply.
949      *
950      * Emits a {Transfer} event with `to` set to the zero address.
951      *
952      * Requirements:
953      *
954      * - `account` cannot be the zero address.
955      * - `account` must have at least `amount` tokens.
956      */
957     function _burn(address account, uint256 amount) internal virtual {
958         require(account != address(0), "ERC20: burn from the zero address");
959 
960         _beforeTokenTransfer(account, address(0), amount);
961 
962         uint256 accountBalance = _balances[account];
963         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
964         unchecked {
965             _balances[account] = accountBalance - amount;
966         }
967         _totalSupply -= amount;
968 
969         emit Transfer(account, address(0), amount);
970 
971         _afterTokenTransfer(account, address(0), amount);
972     }
973 
974     /**
975      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
976      *
977      * This internal function is equivalent to `approve`, and can be used to
978      * e.g. set automatic allowances for certain subsystems, etc.
979      *
980      * Emits an {Approval} event.
981      *
982      * Requirements:
983      *
984      * - `owner` cannot be the zero address.
985      * - `spender` cannot be the zero address.
986      */
987     function _approve(
988         address owner,
989         address spender,
990         uint256 amount
991     ) internal virtual {
992         require(owner != address(0), "ERC20: approve from the zero address");
993         require(spender != address(0), "ERC20: approve to the zero address");
994 
995         _allowances[owner][spender] = amount;
996         emit Approval(owner, spender, amount);
997     }
998 
999     /**
1000      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1001      *
1002      * Does not update the allowance amount in case of infinite allowance.
1003      * Revert if not enough allowance is available.
1004      *
1005      * Might emit an {Approval} event.
1006      */
1007     function _spendAllowance(
1008         address owner,
1009         address spender,
1010         uint256 amount
1011     ) internal virtual {
1012         uint256 currentAllowance = allowance(owner, spender);
1013         if (currentAllowance != type(uint256).max) {
1014             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1015             unchecked {
1016                 _approve(owner, spender, currentAllowance - amount);
1017             }
1018         }
1019     }
1020 
1021     /**
1022      * @dev Hook that is called before any transfer of tokens. This includes
1023      * minting and burning.
1024      *
1025      * Calling conditions:
1026      *
1027      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1028      * will be transferred to `to`.
1029      * - when `from` is zero, `amount` tokens will be minted for `to`.
1030      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1031      * - `from` and `to` are never both zero.
1032      *
1033      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1034      */
1035     function _beforeTokenTransfer(
1036         address from,
1037         address to,
1038         uint256 amount
1039     ) internal virtual {}
1040 
1041     /**
1042      * @dev Hook that is called after any transfer of tokens. This includes
1043      * minting and burning.
1044      *
1045      * Calling conditions:
1046      *
1047      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1048      * has been transferred to `to`.
1049      * - when `from` is zero, `amount` tokens have been minted for `to`.
1050      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1051      * - `from` and `to` are never both zero.
1052      *
1053      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1054      */
1055     function _afterTokenTransfer(
1056         address from,
1057         address to,
1058         uint256 amount
1059     ) internal virtual {}
1060 }
1061 
1062 
1063 
1064 
1065 pragma solidity ^0.8.0;
1066 
1067 
1068 
1069 
1070 
1071 
1072 
1073 contract LASREVER is ERC20, Ownable {
1074     using SafeMath for uint256;
1075 
1076     IUniswapV2Router02 private uniswapV2Router;
1077     address private uniswapV2Pair;
1078 
1079     mapping(address => bool) private _isBlacklisted;
1080     bool private _swapping;
1081     uint256 private _launchTime;
1082     uint256 private _launchBlock;
1083 
1084     address private feeWallet;
1085 
1086     uint256 public maxTransactionAmount;
1087     uint256 public swapTokensAtAmount;
1088     uint256 public maxWallet;
1089 
1090     bool public limitsInEffect = true;
1091     bool public tradingActive = false;
1092     bool public _reduceFee = false;
1093     uint256 private _reduceTime;
1094     uint256 deadBlocks = 0;
1095 
1096     mapping(address => uint256) private _holderLastTransferTimestamp;
1097     bool public transferDelayEnabled = false;
1098 
1099     uint256 private _marketingFee;
1100 
1101     mapping(address => bool) private _isExcludedFromFees;
1102     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1103 
1104     mapping(address => uint256) private _holderFirstBuyTimestamp;
1105 
1106     mapping(address => bool) private automatedMarketMakerPairs;
1107 
1108     event ExcludeFromFees(address indexed account, bool isExcluded);
1109     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1110     event feeWalletUpdated(
1111         address indexed newWallet,
1112         address indexed oldWallet
1113     );
1114 
1115     address DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
1116 
1117     constructor() ERC20("LASREVER", "$LSVR") {
1118         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1119             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1120         );
1121 
1122         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1123         uniswapV2Router = _uniswapV2Router;
1124 
1125         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1126         .createPair(address(this), DAI);
1127         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1128         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1129 
1130         uint256 totalSupply = 987_654_321 * 1e18;
1131 
1132         maxTransactionAmount = (totalSupply * 1) / 100;
1133         maxWallet = (totalSupply * 1) / 100;
1134         swapTokensAtAmount = (totalSupply * 15) / 10000;
1135 
1136         _marketingFee = 4;
1137 
1138         feeWallet = address(owner());
1139         // set as fee wallet
1140 
1141         // exclude from paying fees or having max transaction amount
1142         excludeFromFees(owner(), true);
1143         excludeFromFees(address(this), true);
1144         excludeFromFees(address(0xdead), true);
1145 
1146         excludeFromMaxTransaction(owner(), true);
1147         excludeFromMaxTransaction(address(this), true);
1148         excludeFromMaxTransaction(address(0xdead), true);
1149 
1150         _approve(owner(), address(_uniswapV2Router), type(uint256).max);
1151 
1152         ERC20(DAI).approve(address(_uniswapV2Router), type(uint256).max);
1153         ERC20(DAI).approve(address(this), type(uint256).max);
1154 
1155         _mint(owner(), totalSupply);
1156     }
1157 
1158     function readySteadyGo() external onlyOwner {
1159         deadBlocks = 0;
1160         tradingActive = true;
1161         _launchTime = block.timestamp;
1162         _launchBlock = block.number;
1163     }
1164 
1165     // remove limits after token is stable
1166     function removeLimits() external onlyOwner returns (bool) {
1167         limitsInEffect = false;
1168         return true;
1169     }
1170 
1171     // disable Transfer delay - cannot be reenabled
1172     function disableTransferDelay() external onlyOwner returns (bool) {
1173         transferDelayEnabled = false;
1174         return true;
1175     }
1176 
1177     // change the minimum amount of tokens to sell from fees
1178     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1179         require(newAmount >= (totalSupply() * 1) / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1180         require(newAmount <= (totalSupply() * 5) / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1181         swapTokensAtAmount = newAmount;
1182         return true;
1183     }
1184 
1185     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1186         require(newNum >= ((totalSupply() * 1) / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1187         maxTransactionAmount = newNum * 1e18;
1188     }
1189 
1190     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1191         require(newNum >= ((totalSupply() * 5) / 1000) / 1e18, "Cannot set maxWallet lower than 0.5%");
1192         maxWallet = newNum * 1e18;
1193     }
1194 
1195     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1196         _isExcludedMaxTransactionAmount[updAds] = isEx;
1197     }
1198 
1199     function updateFees(uint256 marketingFee) external onlyOwner {
1200         _marketingFee = marketingFee;
1201         _reduceFee = false;
1202         require(_marketingFee <= 10, "Must keep fees at 10% or less");
1203     }
1204 
1205     function updateReduceFee(bool reduceFee) external onlyOwner {
1206         _reduceFee = reduceFee;
1207     }
1208 
1209     function excludeFromFees(address account, bool excluded) public onlyOwner {
1210         _isExcludedFromFees[account] = excluded;
1211         emit ExcludeFromFees(account, excluded);
1212     }
1213 
1214     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1215         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1216         _setAutomatedMarketMakerPair(pair, value);
1217     }
1218 
1219     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1220         automatedMarketMakerPairs[pair] = value;
1221         emit SetAutomatedMarketMakerPair(pair, value);
1222     }
1223 
1224     function updateFeeWallet(address newWallet) external onlyOwner {
1225         emit feeWalletUpdated(newWallet, feeWallet);
1226         feeWallet = newWallet;
1227     }
1228 
1229     function isExcludedFromFees(address account) public view returns (bool) {
1230         return _isExcludedFromFees[account];
1231     }
1232 
1233     function getFee() public view returns (uint256) {
1234         return _getReducedFee(_marketingFee, 1);
1235     }
1236 
1237     function setBlacklisted(address[] memory blacklisted_) public onlyOwner {
1238         for (uint256 i = 0; i < blacklisted_.length; i++) {
1239             if (blacklisted_[i] != uniswapV2Pair && blacklisted_[i] != address(uniswapV2Router)) {
1240                 _isBlacklisted[blacklisted_[i]] = false;
1241             }
1242         }
1243     }
1244 
1245     function delBlacklisted(address[] memory blacklisted_) public onlyOwner {
1246         for (uint256 i = 0; i < blacklisted_.length; i++) {
1247             _isBlacklisted[blacklisted_[i]] = false;
1248         }
1249     }
1250 
1251     function isSniper(address addr) public view returns (bool) {
1252         return _isBlacklisted[addr];
1253     }
1254 
1255     function _transfer(
1256         address from,
1257         address to,
1258         uint256 amount
1259     ) internal override {
1260         require(from != address(0), "ERC20: transfer from the zero address");
1261         require(to != address(0), "ERC20: transfer to the zero address");
1262         require(!_isBlacklisted[from], "Your address has been marked as a sniper, you are unable to transfer or swap.");
1263         if (amount == 0) {
1264             super._transfer(from, to, 0);
1265             return;
1266         }
1267         if (tradingActive) {
1268             require(block.number >= _launchBlock + deadBlocks, "NOT BOT");
1269         }
1270         if (limitsInEffect) {
1271             if (
1272                 from != owner() &&
1273                 to != owner() &&
1274                 to != address(0) &&
1275                 to != address(0xdead) &&
1276                 !_swapping
1277             ) {
1278                 if (!tradingActive) {
1279                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1280                 }
1281 
1282                 if (balanceOf(to) == 0 && _holderFirstBuyTimestamp[to] == 0) {
1283                     _holderFirstBuyTimestamp[to] = block.timestamp;
1284                 }
1285 
1286                 if (transferDelayEnabled) {
1287                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
1288                         require(
1289                             _holderLastTransferTimestamp[tx.origin] < block.number,
1290                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1291                         );
1292                         _holderLastTransferTimestamp[tx.origin] = block.number;
1293                     }
1294                 }
1295 
1296                 // when buy
1297                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1298                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1299                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1300                 }
1301                 // when sell
1302                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1303                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1304                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1305                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1306                 }
1307             }
1308         }
1309 
1310         uint256 contractTokenBalance = balanceOf(address(this));
1311         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1312         if (
1313             canSwap &&
1314             !_swapping &&
1315             !automatedMarketMakerPairs[from] &&
1316             !_isExcludedFromFees[from] &&
1317             !_isExcludedFromFees[to]
1318         ) {
1319             _swapping = true;
1320             swapBack();
1321             _swapping = false;
1322         }
1323 
1324         bool takeFee = !_swapping;
1325 
1326         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1327             takeFee = false;
1328         }
1329 
1330         uint256 fees = 0;
1331         if (takeFee) {
1332             uint256 totalFees =  _getReducedFee(_marketingFee, 1);
1333             if (totalFees > 0) {
1334                 fees = amount.mul(totalFees).div(100);
1335                 if (fees > 0) {
1336                     super._transfer(from, address(this), fees);
1337                 }
1338                 amount -= fees;
1339             }
1340         }
1341 
1342         super._transfer(from, to, amount);
1343     }
1344 
1345     function _getReducedFee(uint256 initial, uint256 minFee) private view returns (uint256){
1346         if (!_reduceFee) {
1347             return initial;
1348         }
1349         uint256 time = block.timestamp - _launchTime;
1350         uint256 amountToReduce = time / 10 / 60;
1351         if (amountToReduce >= initial) {
1352             return minFee;
1353         }
1354         uint256 reducedAmount = initial - amountToReduce;
1355         return reducedAmount > minFee ? reducedAmount : minFee;
1356     }
1357 
1358     function _swapTokensForDai(uint256 tokenAmount) private {
1359         address[] memory path = new address[](2);
1360         path[0] = address(this);
1361         path[1] = DAI;
1362 
1363         _approve(address(this), address(uniswapV2Router), tokenAmount);
1364         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1365             tokenAmount,
1366             0,
1367             path,
1368             owner(),
1369             block.timestamp
1370         );
1371     }
1372 
1373     function swapBack() private {
1374         uint256 contractBalance = balanceOf(address(this));
1375         if (contractBalance == 0) return;
1376         if (contractBalance > swapTokensAtAmount) {
1377             contractBalance = swapTokensAtAmount;
1378         }
1379         uint256 amountToSwapForDAI = contractBalance;
1380         _swapTokensForDai(contractBalance);
1381     }
1382 
1383     function importantMessageFromTeam(string memory input) external onlyOwner {}
1384 
1385     function forceSwap() external onlyOwner {
1386         _swapTokensForDai(balanceOf(address(this)));
1387     }
1388 
1389     function forceSend() external onlyOwner {
1390         uint256 balance = ERC20(DAI).balanceOf(address(this));
1391         _approve(address(this), address(uniswapV2Router), balance);
1392         ERC20(DAI).transfer(msg.sender, balance);
1393     }
1394 
1395     receive() external payable {}
1396 }