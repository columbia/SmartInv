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
78     external
79     payable
80     returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82     external
83     returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85     external
86     returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88     external
89     payable
90     returns (uint[] memory amounts);
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
223 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
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
244     unchecked {
245         uint256 c = a + b;
246         if (c < a) return (false, 0);
247         return (true, c);
248     }
249     }
250 
251     /**
252      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
253      *
254      * _Available since v3.4._
255      */
256     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257     unchecked {
258         if (b > a) return (false, 0);
259         return (true, a - b);
260     }
261     }
262 
263     /**
264      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
265      *
266      * _Available since v3.4._
267      */
268     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269     unchecked {
270         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
271         // benefit is lost if 'b' is also tested.
272         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
273         if (a == 0) return (true, 0);
274         uint256 c = a * b;
275         if (c / a != b) return (false, 0);
276         return (true, c);
277     }
278     }
279 
280     /**
281      * @dev Returns the division of two unsigned integers, with a division by zero flag.
282      *
283      * _Available since v3.4._
284      */
285     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
286     unchecked {
287         if (b == 0) return (false, 0);
288         return (true, a / b);
289     }
290     }
291 
292     /**
293      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
294      *
295      * _Available since v3.4._
296      */
297     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
298     unchecked {
299         if (b == 0) return (false, 0);
300         return (true, a % b);
301     }
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
394     unchecked {
395         require(b <= a, errorMessage);
396         return a - b;
397     }
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
417     unchecked {
418         require(b > 0, errorMessage);
419         return a / b;
420     }
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
443     unchecked {
444         require(b > 0, errorMessage);
445         return a % b;
446     }
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
480 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
510      * @dev Returns the address of the current owner.
511      */
512     function owner() public view virtual returns (address) {
513         return _owner;
514     }
515 
516     /**
517      * @dev Throws if called by any account other than the owner.
518      */
519     modifier onlyOwner() {
520         require(owner() == _msgSender(), "Ownable: caller is not the owner");
521         _;
522     }
523 
524     /**
525      * @dev Leaves the contract without owner. It will not be possible to call
526      * `onlyOwner` functions anymore. Can only be called by the current owner.
527      *
528      * NOTE: Renouncing ownership will leave the contract without an owner,
529      * thereby removing any functionality that is only available to the owner.
530      */
531     function renounceOwnership() public virtual onlyOwner {
532         _transferOwnership(address(0));
533     }
534 
535     /**
536      * @dev Transfers ownership of the contract to a new account (`newOwner`).
537      * Can only be called by the current owner.
538      */
539     function transferOwnership(address newOwner) public virtual onlyOwner {
540         require(newOwner != address(0), "Ownable: new owner is the zero address");
541         _transferOwnership(newOwner);
542     }
543 
544     /**
545      * @dev Transfers ownership of the contract to a new account (`newOwner`).
546      * Internal function without access restriction.
547      */
548     function _transferOwnership(address newOwner) internal virtual {
549         address oldOwner = _owner;
550         _owner = newOwner;
551         emit OwnershipTransferred(oldOwner, newOwner);
552     }
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
556 
557 
558 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Interface of the ERC20 standard as defined in the EIP.
564  */
565 interface IERC20 {
566     /**
567      * @dev Returns the amount of tokens in existence.
568      */
569     function totalSupply() external view returns (uint256);
570 
571     /**
572      * @dev Returns the amount of tokens owned by `account`.
573      */
574     function balanceOf(address account) external view returns (uint256);
575 
576     /**
577      * @dev Moves `amount` tokens from the caller's account to `to`.
578      *
579      * Returns a boolean value indicating whether the operation succeeded.
580      *
581      * Emits a {Transfer} event.
582      */
583     function transfer(address to, uint256 amount) external returns (bool);
584 
585     /**
586      * @dev Returns the remaining number of tokens that `spender` will be
587      * allowed to spend on behalf of `owner` through {transferFrom}. This is
588      * zero by default.
589      *
590      * This value changes when {approve} or {transferFrom} are called.
591      */
592     function allowance(address owner, address spender) external view returns (uint256);
593 
594     /**
595      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
596      *
597      * Returns a boolean value indicating whether the operation succeeded.
598      *
599      * IMPORTANT: Beware that changing an allowance with this method brings the risk
600      * that someone may use both the old and the new allowance by unfortunate
601      * transaction ordering. One possible solution to mitigate this race
602      * condition is to first reduce the spender's allowance to 0 and set the
603      * desired value afterwards:
604      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
605      *
606      * Emits an {Approval} event.
607      */
608     function approve(address spender, uint256 amount) external returns (bool);
609 
610     /**
611      * @dev Moves `amount` tokens from `from` to `to` using the
612      * allowance mechanism. `amount` is then deducted from the caller's
613      * allowance.
614      *
615      * Returns a boolean value indicating whether the operation succeeded.
616      *
617      * Emits a {Transfer} event.
618      */
619     function transferFrom(
620         address from,
621         address to,
622         uint256 amount
623     ) external returns (bool);
624 
625     /**
626      * @dev Emitted when `value` tokens are moved from one account (`from`) to
627      * another (`to`).
628      *
629      * Note that `value` may be zero.
630      */
631     event Transfer(address indexed from, address indexed to, uint256 value);
632 
633     /**
634      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
635      * a call to {approve}. `value` is the new allowance.
636      */
637     event Approval(address indexed owner, address indexed spender, uint256 value);
638 }
639 
640 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
641 
642 
643 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @dev Interface for the optional metadata functions from the ERC20 standard.
650  *
651  * _Available since v4.1._
652  */
653 interface IERC20Metadata is IERC20 {
654     /**
655      * @dev Returns the name of the token.
656      */
657     function name() external view returns (string memory);
658 
659     /**
660      * @dev Returns the symbol of the token.
661      */
662     function symbol() external view returns (string memory);
663 
664     /**
665      * @dev Returns the decimals places of the token.
666      */
667     function decimals() external view returns (uint8);
668 }
669 
670 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
671 
672 
673 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 
678 
679 
680 /**
681  * @dev Implementation of the {IERC20} interface.
682  *
683  * This implementation is agnostic to the way tokens are created. This means
684  * that a supply mechanism has to be added in a derived contract using {_mint}.
685  * For a generic mechanism see {ERC20PresetMinterPauser}.
686  *
687  * TIP: For a detailed writeup see our guide
688  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
689  * to implement supply mechanisms].
690  *
691  * We have followed general OpenZeppelin Contracts guidelines: functions revert
692  * instead returning `false` on failure. This behavior is nonetheless
693  * conventional and does not conflict with the expectations of ERC20
694  * applications.
695  *
696  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
697  * This allows applications to reconstruct the allowance for all accounts just
698  * by listening to said events. Other implementations of the EIP may not emit
699  * these events, as it isn't required by the specification.
700  *
701  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
702  * functions have been added to mitigate the well-known issues around setting
703  * allowances. See {IERC20-approve}.
704  */
705 contract ERC20 is Context, IERC20, IERC20Metadata {
706     mapping(address => uint256) private _balances;
707 
708     mapping(address => mapping(address => uint256)) private _allowances;
709 
710     uint256 private _totalSupply;
711 
712     string private _name;
713     string private _symbol;
714 
715     /**
716      * @dev Sets the values for {name} and {symbol}.
717      *
718      * The default value of {decimals} is 18. To select a different value for
719      * {decimals} you should overload it.
720      *
721      * All two of these values are immutable: they can only be set once during
722      * construction.
723      */
724     constructor(string memory name_, string memory symbol_) {
725         _name = name_;
726         _symbol = symbol_;
727     }
728 
729     /**
730      * @dev Returns the name of the token.
731      */
732     function name() public view virtual override returns (string memory) {
733         return _name;
734     }
735 
736     /**
737      * @dev Returns the symbol of the token, usually a shorter version of the
738      * name.
739      */
740     function symbol() public view virtual override returns (string memory) {
741         return _symbol;
742     }
743 
744     /**
745      * @dev Returns the number of decimals used to get its user representation.
746      * For example, if `decimals` equals `2`, a balance of `505` tokens should
747      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
748      *
749      * Tokens usually opt for a value of 18, imitating the relationship between
750      * Ether and Wei. This is the value {ERC20} uses, unless this function is
751      * overridden;
752      *
753      * NOTE: This information is only used for _display_ purposes: it in
754      * no way affects any of the arithmetic of the contract, including
755      * {IERC20-balanceOf} and {IERC20-transfer}.
756      */
757     function decimals() public view virtual override returns (uint8) {
758         return 18;
759     }
760 
761     /**
762      * @dev See {IERC20-totalSupply}.
763      */
764     function totalSupply() public view virtual override returns (uint256) {
765         return _totalSupply;
766     }
767 
768     /**
769      * @dev See {IERC20-balanceOf}.
770      */
771     function balanceOf(address account) public view virtual override returns (uint256) {
772         return _balances[account];
773     }
774 
775     /**
776      * @dev See {IERC20-transfer}.
777      *
778      * Requirements:
779      *
780      * - `to` cannot be the zero address.
781      * - the caller must have a balance of at least `amount`.
782      */
783     function transfer(address to, uint256 amount) public virtual override returns (bool) {
784         address owner = _msgSender();
785         _transfer(owner, to, amount);
786         return true;
787     }
788 
789     /**
790      * @dev See {IERC20-allowance}.
791      */
792     function allowance(address owner, address spender) public view virtual override returns (uint256) {
793         return _allowances[owner][spender];
794     }
795 
796     /**
797      * @dev See {IERC20-approve}.
798      *
799      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
800      * `transferFrom`. This is semantically equivalent to an infinite approval.
801      *
802      * Requirements:
803      *
804      * - `spender` cannot be the zero address.
805      */
806     function approve(address spender, uint256 amount) public virtual override returns (bool) {
807         address owner = _msgSender();
808         _approve(owner, spender, amount);
809         return true;
810     }
811 
812     /**
813      * @dev See {IERC20-transferFrom}.
814      *
815      * Emits an {Approval} event indicating the updated allowance. This is not
816      * required by the EIP. See the note at the beginning of {ERC20}.
817      *
818      * NOTE: Does not update the allowance if the current allowance
819      * is the maximum `uint256`.
820      *
821      * Requirements:
822      *
823      * - `from` and `to` cannot be the zero address.
824      * - `from` must have a balance of at least `amount`.
825      * - the caller must have allowance for ``from``'s tokens of at least
826      * `amount`.
827      */
828     function transferFrom(
829         address from,
830         address to,
831         uint256 amount
832     ) public virtual override returns (bool) {
833         address spender = _msgSender();
834         _spendAllowance(from, spender, amount);
835         _transfer(from, to, amount);
836         return true;
837     }
838 
839     /**
840      * @dev Atomically increases the allowance granted to `spender` by the caller.
841      *
842      * This is an alternative to {approve} that can be used as a mitigation for
843      * problems described in {IERC20-approve}.
844      *
845      * Emits an {Approval} event indicating the updated allowance.
846      *
847      * Requirements:
848      *
849      * - `spender` cannot be the zero address.
850      */
851     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
852         address owner = _msgSender();
853         _approve(owner, spender, _allowances[owner][spender] + addedValue);
854         return true;
855     }
856 
857     /**
858      * @dev Atomically decreases the allowance granted to `spender` by the caller.
859      *
860      * This is an alternative to {approve} that can be used as a mitigation for
861      * problems described in {IERC20-approve}.
862      *
863      * Emits an {Approval} event indicating the updated allowance.
864      *
865      * Requirements:
866      *
867      * - `spender` cannot be the zero address.
868      * - `spender` must have allowance for the caller of at least
869      * `subtractedValue`.
870      */
871     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
872         address owner = _msgSender();
873         uint256 currentAllowance = _allowances[owner][spender];
874         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
875     unchecked {
876         _approve(owner, spender, currentAllowance - subtractedValue);
877     }
878 
879         return true;
880     }
881 
882     /**
883      * @dev Moves `amount` of tokens from `sender` to `recipient`.
884      *
885      * This internal function is equivalent to {transfer}, and can be used to
886      * e.g. implement automatic token fees, slashing mechanisms, etc.
887      *
888      * Emits a {Transfer} event.
889      *
890      * Requirements:
891      *
892      * - `from` cannot be the zero address.
893      * - `to` cannot be the zero address.
894      * - `from` must have a balance of at least `amount`.
895      */
896     function _transfer(
897         address from,
898         address to,
899         uint256 amount
900     ) internal virtual {
901         require(from != address(0), "ERC20: transfer from the zero address");
902         require(to != address(0), "ERC20: transfer to the zero address");
903 
904         _beforeTokenTransfer(from, to, amount);
905 
906         uint256 fromBalance = _balances[from];
907         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
908     unchecked {
909         _balances[from] = fromBalance - amount;
910     }
911         _balances[to] += amount;
912 
913         emit Transfer(from, to, amount);
914 
915         _afterTokenTransfer(from, to, amount);
916     }
917 
918     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
919      * the total supply.
920      *
921      * Emits a {Transfer} event with `from` set to the zero address.
922      *
923      * Requirements:
924      *
925      * - `account` cannot be the zero address.
926      */
927     function _mint(address account, uint256 amount) internal virtual {
928         require(account != address(0), "ERC20: mint to the zero address");
929 
930         _beforeTokenTransfer(address(0), account, amount);
931 
932         _totalSupply += amount;
933         _balances[account] += amount;
934         emit Transfer(address(0), account, amount);
935 
936         _afterTokenTransfer(address(0), account, amount);
937     }
938 
939     /**
940      * @dev Destroys `amount` tokens from `account`, reducing the
941      * total supply.
942      *
943      * Emits a {Transfer} event with `to` set to the zero address.
944      *
945      * Requirements:
946      *
947      * - `account` cannot be the zero address.
948      * - `account` must have at least `amount` tokens.
949      */
950     function _burn(address account, uint256 amount) internal virtual {
951         require(account != address(0), "ERC20: burn from the zero address");
952 
953         _beforeTokenTransfer(account, address(0), amount);
954 
955         uint256 accountBalance = _balances[account];
956         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
957     unchecked {
958         _balances[account] = accountBalance - amount;
959     }
960         _totalSupply -= amount;
961 
962         emit Transfer(account, address(0), amount);
963 
964         _afterTokenTransfer(account, address(0), amount);
965     }
966 
967     /**
968      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
969      *
970      * This internal function is equivalent to `approve`, and can be used to
971      * e.g. set automatic allowances for certain subsystems, etc.
972      *
973      * Emits an {Approval} event.
974      *
975      * Requirements:
976      *
977      * - `owner` cannot be the zero address.
978      * - `spender` cannot be the zero address.
979      */
980     function _approve(
981         address owner,
982         address spender,
983         uint256 amount
984     ) internal virtual {
985         require(owner != address(0), "ERC20: approve from the zero address");
986         require(spender != address(0), "ERC20: approve to the zero address");
987 
988         _allowances[owner][spender] = amount;
989         emit Approval(owner, spender, amount);
990     }
991 
992     /**
993      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
994      *
995      * Does not update the allowance amount in case of infinite allowance.
996      * Revert if not enough allowance is available.
997      *
998      * Might emit an {Approval} event.
999      */
1000     function _spendAllowance(
1001         address owner,
1002         address spender,
1003         uint256 amount
1004     ) internal virtual {
1005         uint256 currentAllowance = allowance(owner, spender);
1006         if (currentAllowance != type(uint256).max) {
1007             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1008         unchecked {
1009             _approve(owner, spender, currentAllowance - amount);
1010         }
1011         }
1012     }
1013 
1014     /**
1015      * @dev Hook that is called before any transfer of tokens. This includes
1016      * minting and burning.
1017      *
1018      * Calling conditions:
1019      *
1020      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1021      * will be transferred to `to`.
1022      * - when `from` is zero, `amount` tokens will be minted for `to`.
1023      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1024      * - `from` and `to` are never both zero.
1025      *
1026      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1027      */
1028     function _beforeTokenTransfer(
1029         address from,
1030         address to,
1031         uint256 amount
1032     ) internal virtual {}
1033 
1034     /**
1035      * @dev Hook that is called after any transfer of tokens. This includes
1036      * minting and burning.
1037      *
1038      * Calling conditions:
1039      *
1040      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1041      * has been transferred to `to`.
1042      * - when `from` is zero, `amount` tokens have been minted for `to`.
1043      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1044      * - `from` and `to` are never both zero.
1045      *
1046      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1047      */
1048     function _afterTokenTransfer(
1049         address from,
1050         address to,
1051         uint256 amount
1052     ) internal virtual {}
1053 }
1054 
1055 // File: hardhat/console.sol
1056 
1057 
1058 pragma solidity >= 0.4.22 <0.9.0;
1059 
1060 library console {
1061     address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1062 
1063     function _sendLogPayload(bytes memory payload) private view {
1064         uint256 payloadLength = payload.length;
1065         address consoleAddress = CONSOLE_ADDRESS;
1066         assembly {
1067             let payloadStart := add(payload, 32)
1068             let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1069         }
1070     }
1071 
1072     function log() internal view {
1073         _sendLogPayload(abi.encodeWithSignature("log()"));
1074     }
1075 
1076     function logInt(int p0) internal view {
1077         _sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1078     }
1079 
1080     function logUint(uint p0) internal view {
1081         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1082     }
1083 
1084     function logString(string memory p0) internal view {
1085         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1086     }
1087 
1088     function logBool(bool p0) internal view {
1089         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1090     }
1091 
1092     function logAddress(address p0) internal view {
1093         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1094     }
1095 
1096     function logBytes(bytes memory p0) internal view {
1097         _sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1098     }
1099 
1100     function logBytes1(bytes1 p0) internal view {
1101         _sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1102     }
1103 
1104     function logBytes2(bytes2 p0) internal view {
1105         _sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1106     }
1107 
1108     function logBytes3(bytes3 p0) internal view {
1109         _sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1110     }
1111 
1112     function logBytes4(bytes4 p0) internal view {
1113         _sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1114     }
1115 
1116     function logBytes5(bytes5 p0) internal view {
1117         _sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1118     }
1119 
1120     function logBytes6(bytes6 p0) internal view {
1121         _sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1122     }
1123 
1124     function logBytes7(bytes7 p0) internal view {
1125         _sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1126     }
1127 
1128     function logBytes8(bytes8 p0) internal view {
1129         _sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1130     }
1131 
1132     function logBytes9(bytes9 p0) internal view {
1133         _sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1134     }
1135 
1136     function logBytes10(bytes10 p0) internal view {
1137         _sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1138     }
1139 
1140     function logBytes11(bytes11 p0) internal view {
1141         _sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1142     }
1143 
1144     function logBytes12(bytes12 p0) internal view {
1145         _sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1146     }
1147 
1148     function logBytes13(bytes13 p0) internal view {
1149         _sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1150     }
1151 
1152     function logBytes14(bytes14 p0) internal view {
1153         _sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1154     }
1155 
1156     function logBytes15(bytes15 p0) internal view {
1157         _sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1158     }
1159 
1160     function logBytes16(bytes16 p0) internal view {
1161         _sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1162     }
1163 
1164     function logBytes17(bytes17 p0) internal view {
1165         _sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1166     }
1167 
1168     function logBytes18(bytes18 p0) internal view {
1169         _sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1170     }
1171 
1172     function logBytes19(bytes19 p0) internal view {
1173         _sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1174     }
1175 
1176     function logBytes20(bytes20 p0) internal view {
1177         _sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1178     }
1179 
1180     function logBytes21(bytes21 p0) internal view {
1181         _sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1182     }
1183 
1184     function logBytes22(bytes22 p0) internal view {
1185         _sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1186     }
1187 
1188     function logBytes23(bytes23 p0) internal view {
1189         _sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1190     }
1191 
1192     function logBytes24(bytes24 p0) internal view {
1193         _sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1194     }
1195 
1196     function logBytes25(bytes25 p0) internal view {
1197         _sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1198     }
1199 
1200     function logBytes26(bytes26 p0) internal view {
1201         _sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1202     }
1203 
1204     function logBytes27(bytes27 p0) internal view {
1205         _sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1206     }
1207 
1208     function logBytes28(bytes28 p0) internal view {
1209         _sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1210     }
1211 
1212     function logBytes29(bytes29 p0) internal view {
1213         _sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1214     }
1215 
1216     function logBytes30(bytes30 p0) internal view {
1217         _sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1218     }
1219 
1220     function logBytes31(bytes31 p0) internal view {
1221         _sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1222     }
1223 
1224     function logBytes32(bytes32 p0) internal view {
1225         _sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1226     }
1227 
1228     function log(uint p0) internal view {
1229         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1230     }
1231 
1232     function log(string memory p0) internal view {
1233         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1234     }
1235 
1236     function log(bool p0) internal view {
1237         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1238     }
1239 
1240     function log(address p0) internal view {
1241         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1242     }
1243 
1244     function log(uint p0, uint p1) internal view {
1245         _sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1246     }
1247 
1248     function log(uint p0, string memory p1) internal view {
1249         _sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1250     }
1251 
1252     function log(uint p0, bool p1) internal view {
1253         _sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1254     }
1255 
1256     function log(uint p0, address p1) internal view {
1257         _sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1258     }
1259 
1260     function log(string memory p0, uint p1) internal view {
1261         _sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1262     }
1263 
1264     function log(string memory p0, string memory p1) internal view {
1265         _sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1266     }
1267 
1268     function log(string memory p0, bool p1) internal view {
1269         _sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1270     }
1271 
1272     function log(string memory p0, address p1) internal view {
1273         _sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1274     }
1275 
1276     function log(bool p0, uint p1) internal view {
1277         _sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1278     }
1279 
1280     function log(bool p0, string memory p1) internal view {
1281         _sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1282     }
1283 
1284     function log(bool p0, bool p1) internal view {
1285         _sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1286     }
1287 
1288     function log(bool p0, address p1) internal view {
1289         _sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1290     }
1291 
1292     function log(address p0, uint p1) internal view {
1293         _sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1294     }
1295 
1296     function log(address p0, string memory p1) internal view {
1297         _sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1298     }
1299 
1300     function log(address p0, bool p1) internal view {
1301         _sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1302     }
1303 
1304     function log(address p0, address p1) internal view {
1305         _sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1306     }
1307 
1308     function log(uint p0, uint p1, uint p2) internal view {
1309         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1310     }
1311 
1312     function log(uint p0, uint p1, string memory p2) internal view {
1313         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1314     }
1315 
1316     function log(uint p0, uint p1, bool p2) internal view {
1317         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1318     }
1319 
1320     function log(uint p0, uint p1, address p2) internal view {
1321         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1322     }
1323 
1324     function log(uint p0, string memory p1, uint p2) internal view {
1325         _sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1326     }
1327 
1328     function log(uint p0, string memory p1, string memory p2) internal view {
1329         _sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1330     }
1331 
1332     function log(uint p0, string memory p1, bool p2) internal view {
1333         _sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1334     }
1335 
1336     function log(uint p0, string memory p1, address p2) internal view {
1337         _sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1338     }
1339 
1340     function log(uint p0, bool p1, uint p2) internal view {
1341         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1342     }
1343 
1344     function log(uint p0, bool p1, string memory p2) internal view {
1345         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1346     }
1347 
1348     function log(uint p0, bool p1, bool p2) internal view {
1349         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1350     }
1351 
1352     function log(uint p0, bool p1, address p2) internal view {
1353         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1354     }
1355 
1356     function log(uint p0, address p1, uint p2) internal view {
1357         _sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1358     }
1359 
1360     function log(uint p0, address p1, string memory p2) internal view {
1361         _sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1362     }
1363 
1364     function log(uint p0, address p1, bool p2) internal view {
1365         _sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1366     }
1367 
1368     function log(uint p0, address p1, address p2) internal view {
1369         _sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1370     }
1371 
1372     function log(string memory p0, uint p1, uint p2) internal view {
1373         _sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1374     }
1375 
1376     function log(string memory p0, uint p1, string memory p2) internal view {
1377         _sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1378     }
1379 
1380     function log(string memory p0, uint p1, bool p2) internal view {
1381         _sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1382     }
1383 
1384     function log(string memory p0, uint p1, address p2) internal view {
1385         _sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1386     }
1387 
1388     function log(string memory p0, string memory p1, uint p2) internal view {
1389         _sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1390     }
1391 
1392     function log(string memory p0, string memory p1, string memory p2) internal view {
1393         _sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1394     }
1395 
1396     function log(string memory p0, string memory p1, bool p2) internal view {
1397         _sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1398     }
1399 
1400     function log(string memory p0, string memory p1, address p2) internal view {
1401         _sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1402     }
1403 
1404     function log(string memory p0, bool p1, uint p2) internal view {
1405         _sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1406     }
1407 
1408     function log(string memory p0, bool p1, string memory p2) internal view {
1409         _sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1410     }
1411 
1412     function log(string memory p0, bool p1, bool p2) internal view {
1413         _sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1414     }
1415 
1416     function log(string memory p0, bool p1, address p2) internal view {
1417         _sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1418     }
1419 
1420     function log(string memory p0, address p1, uint p2) internal view {
1421         _sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1422     }
1423 
1424     function log(string memory p0, address p1, string memory p2) internal view {
1425         _sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1426     }
1427 
1428     function log(string memory p0, address p1, bool p2) internal view {
1429         _sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1430     }
1431 
1432     function log(string memory p0, address p1, address p2) internal view {
1433         _sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1434     }
1435 
1436     function log(bool p0, uint p1, uint p2) internal view {
1437         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1438     }
1439 
1440     function log(bool p0, uint p1, string memory p2) internal view {
1441         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1442     }
1443 
1444     function log(bool p0, uint p1, bool p2) internal view {
1445         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1446     }
1447 
1448     function log(bool p0, uint p1, address p2) internal view {
1449         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1450     }
1451 
1452     function log(bool p0, string memory p1, uint p2) internal view {
1453         _sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1454     }
1455 
1456     function log(bool p0, string memory p1, string memory p2) internal view {
1457         _sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1458     }
1459 
1460     function log(bool p0, string memory p1, bool p2) internal view {
1461         _sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1462     }
1463 
1464     function log(bool p0, string memory p1, address p2) internal view {
1465         _sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1466     }
1467 
1468     function log(bool p0, bool p1, uint p2) internal view {
1469         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1470     }
1471 
1472     function log(bool p0, bool p1, string memory p2) internal view {
1473         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1474     }
1475 
1476     function log(bool p0, bool p1, bool p2) internal view {
1477         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1478     }
1479 
1480     function log(bool p0, bool p1, address p2) internal view {
1481         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1482     }
1483 
1484     function log(bool p0, address p1, uint p2) internal view {
1485         _sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1486     }
1487 
1488     function log(bool p0, address p1, string memory p2) internal view {
1489         _sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1490     }
1491 
1492     function log(bool p0, address p1, bool p2) internal view {
1493         _sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1494     }
1495 
1496     function log(bool p0, address p1, address p2) internal view {
1497         _sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1498     }
1499 
1500     function log(address p0, uint p1, uint p2) internal view {
1501         _sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1502     }
1503 
1504     function log(address p0, uint p1, string memory p2) internal view {
1505         _sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1506     }
1507 
1508     function log(address p0, uint p1, bool p2) internal view {
1509         _sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1510     }
1511 
1512     function log(address p0, uint p1, address p2) internal view {
1513         _sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1514     }
1515 
1516     function log(address p0, string memory p1, uint p2) internal view {
1517         _sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1518     }
1519 
1520     function log(address p0, string memory p1, string memory p2) internal view {
1521         _sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1522     }
1523 
1524     function log(address p0, string memory p1, bool p2) internal view {
1525         _sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1526     }
1527 
1528     function log(address p0, string memory p1, address p2) internal view {
1529         _sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1530     }
1531 
1532     function log(address p0, bool p1, uint p2) internal view {
1533         _sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1534     }
1535 
1536     function log(address p0, bool p1, string memory p2) internal view {
1537         _sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1538     }
1539 
1540     function log(address p0, bool p1, bool p2) internal view {
1541         _sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1542     }
1543 
1544     function log(address p0, bool p1, address p2) internal view {
1545         _sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1546     }
1547 
1548     function log(address p0, address p1, uint p2) internal view {
1549         _sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1550     }
1551 
1552     function log(address p0, address p1, string memory p2) internal view {
1553         _sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1554     }
1555 
1556     function log(address p0, address p1, bool p2) internal view {
1557         _sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1558     }
1559 
1560     function log(address p0, address p1, address p2) internal view {
1561         _sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1562     }
1563 
1564     function log(uint p0, uint p1, uint p2, uint p3) internal view {
1565         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1566     }
1567 
1568     function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1569         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1570     }
1571 
1572     function log(uint p0, uint p1, uint p2, bool p3) internal view {
1573         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1574     }
1575 
1576     function log(uint p0, uint p1, uint p2, address p3) internal view {
1577         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1578     }
1579 
1580     function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1581         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1582     }
1583 
1584     function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1585         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1586     }
1587 
1588     function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1589         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1590     }
1591 
1592     function log(uint p0, uint p1, string memory p2, address p3) internal view {
1593         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1594     }
1595 
1596     function log(uint p0, uint p1, bool p2, uint p3) internal view {
1597         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1598     }
1599 
1600     function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1601         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1602     }
1603 
1604     function log(uint p0, uint p1, bool p2, bool p3) internal view {
1605         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1606     }
1607 
1608     function log(uint p0, uint p1, bool p2, address p3) internal view {
1609         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1610     }
1611 
1612     function log(uint p0, uint p1, address p2, uint p3) internal view {
1613         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1614     }
1615 
1616     function log(uint p0, uint p1, address p2, string memory p3) internal view {
1617         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1618     }
1619 
1620     function log(uint p0, uint p1, address p2, bool p3) internal view {
1621         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1622     }
1623 
1624     function log(uint p0, uint p1, address p2, address p3) internal view {
1625         _sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1626     }
1627 
1628     function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1629         _sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1630     }
1631 
1632     function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1633         _sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1634     }
1635 
1636     function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1637         _sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1638     }
1639 
1640     function log(uint p0, string memory p1, uint p2, address p3) internal view {
1641         _sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1642     }
1643 
1644     function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1645         _sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1646     }
1647 
1648     function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1649         _sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1650     }
1651 
1652     function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1653         _sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1654     }
1655 
1656     function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1657         _sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1658     }
1659 
1660     function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1661         _sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1662     }
1663 
1664     function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1665         _sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1666     }
1667 
1668     function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1669         _sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1670     }
1671 
1672     function log(uint p0, string memory p1, bool p2, address p3) internal view {
1673         _sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1674     }
1675 
1676     function log(uint p0, string memory p1, address p2, uint p3) internal view {
1677         _sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1678     }
1679 
1680     function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1681         _sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1682     }
1683 
1684     function log(uint p0, string memory p1, address p2, bool p3) internal view {
1685         _sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1686     }
1687 
1688     function log(uint p0, string memory p1, address p2, address p3) internal view {
1689         _sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1690     }
1691 
1692     function log(uint p0, bool p1, uint p2, uint p3) internal view {
1693         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1694     }
1695 
1696     function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1697         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1698     }
1699 
1700     function log(uint p0, bool p1, uint p2, bool p3) internal view {
1701         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1702     }
1703 
1704     function log(uint p0, bool p1, uint p2, address p3) internal view {
1705         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1706     }
1707 
1708     function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1709         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1710     }
1711 
1712     function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1713         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1714     }
1715 
1716     function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1717         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1718     }
1719 
1720     function log(uint p0, bool p1, string memory p2, address p3) internal view {
1721         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1722     }
1723 
1724     function log(uint p0, bool p1, bool p2, uint p3) internal view {
1725         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1726     }
1727 
1728     function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1729         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1730     }
1731 
1732     function log(uint p0, bool p1, bool p2, bool p3) internal view {
1733         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1734     }
1735 
1736     function log(uint p0, bool p1, bool p2, address p3) internal view {
1737         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1738     }
1739 
1740     function log(uint p0, bool p1, address p2, uint p3) internal view {
1741         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1742     }
1743 
1744     function log(uint p0, bool p1, address p2, string memory p3) internal view {
1745         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1746     }
1747 
1748     function log(uint p0, bool p1, address p2, bool p3) internal view {
1749         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1750     }
1751 
1752     function log(uint p0, bool p1, address p2, address p3) internal view {
1753         _sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1754     }
1755 
1756     function log(uint p0, address p1, uint p2, uint p3) internal view {
1757         _sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1758     }
1759 
1760     function log(uint p0, address p1, uint p2, string memory p3) internal view {
1761         _sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1762     }
1763 
1764     function log(uint p0, address p1, uint p2, bool p3) internal view {
1765         _sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1766     }
1767 
1768     function log(uint p0, address p1, uint p2, address p3) internal view {
1769         _sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1770     }
1771 
1772     function log(uint p0, address p1, string memory p2, uint p3) internal view {
1773         _sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1774     }
1775 
1776     function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1777         _sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1778     }
1779 
1780     function log(uint p0, address p1, string memory p2, bool p3) internal view {
1781         _sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1782     }
1783 
1784     function log(uint p0, address p1, string memory p2, address p3) internal view {
1785         _sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1786     }
1787 
1788     function log(uint p0, address p1, bool p2, uint p3) internal view {
1789         _sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1790     }
1791 
1792     function log(uint p0, address p1, bool p2, string memory p3) internal view {
1793         _sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1794     }
1795 
1796     function log(uint p0, address p1, bool p2, bool p3) internal view {
1797         _sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1798     }
1799 
1800     function log(uint p0, address p1, bool p2, address p3) internal view {
1801         _sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1802     }
1803 
1804     function log(uint p0, address p1, address p2, uint p3) internal view {
1805         _sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1806     }
1807 
1808     function log(uint p0, address p1, address p2, string memory p3) internal view {
1809         _sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1810     }
1811 
1812     function log(uint p0, address p1, address p2, bool p3) internal view {
1813         _sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1814     }
1815 
1816     function log(uint p0, address p1, address p2, address p3) internal view {
1817         _sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1818     }
1819 
1820     function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1821         _sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1822     }
1823 
1824     function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1825         _sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1826     }
1827 
1828     function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1829         _sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1830     }
1831 
1832     function log(string memory p0, uint p1, uint p2, address p3) internal view {
1833         _sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1834     }
1835 
1836     function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1837         _sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1838     }
1839 
1840     function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1841         _sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1842     }
1843 
1844     function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1845         _sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1846     }
1847 
1848     function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1849         _sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1850     }
1851 
1852     function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1853         _sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1854     }
1855 
1856     function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1857         _sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1858     }
1859 
1860     function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1861         _sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1862     }
1863 
1864     function log(string memory p0, uint p1, bool p2, address p3) internal view {
1865         _sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1866     }
1867 
1868     function log(string memory p0, uint p1, address p2, uint p3) internal view {
1869         _sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1870     }
1871 
1872     function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1873         _sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1874     }
1875 
1876     function log(string memory p0, uint p1, address p2, bool p3) internal view {
1877         _sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1878     }
1879 
1880     function log(string memory p0, uint p1, address p2, address p3) internal view {
1881         _sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1882     }
1883 
1884     function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1885         _sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1886     }
1887 
1888     function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1889         _sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1890     }
1891 
1892     function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1893         _sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1894     }
1895 
1896     function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1897         _sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1898     }
1899 
1900     function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1901         _sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1902     }
1903 
1904     function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1905         _sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1906     }
1907 
1908     function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1909         _sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1910     }
1911 
1912     function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1913         _sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1914     }
1915 
1916     function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1917         _sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1918     }
1919 
1920     function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1921         _sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1922     }
1923 
1924     function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1925         _sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1926     }
1927 
1928     function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1929         _sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1930     }
1931 
1932     function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1933         _sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1934     }
1935 
1936     function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1937         _sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1938     }
1939 
1940     function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1941         _sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1942     }
1943 
1944     function log(string memory p0, string memory p1, address p2, address p3) internal view {
1945         _sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1946     }
1947 
1948     function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1949         _sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1950     }
1951 
1952     function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1953         _sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1954     }
1955 
1956     function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1957         _sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1958     }
1959 
1960     function log(string memory p0, bool p1, uint p2, address p3) internal view {
1961         _sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1962     }
1963 
1964     function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1965         _sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1966     }
1967 
1968     function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1969         _sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1970     }
1971 
1972     function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1973         _sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1974     }
1975 
1976     function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1977         _sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1978     }
1979 
1980     function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1981         _sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1982     }
1983 
1984     function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1985         _sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1986     }
1987 
1988     function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1989         _sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1990     }
1991 
1992     function log(string memory p0, bool p1, bool p2, address p3) internal view {
1993         _sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1994     }
1995 
1996     function log(string memory p0, bool p1, address p2, uint p3) internal view {
1997         _sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1998     }
1999 
2000     function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2001         _sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2002     }
2003 
2004     function log(string memory p0, bool p1, address p2, bool p3) internal view {
2005         _sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2006     }
2007 
2008     function log(string memory p0, bool p1, address p2, address p3) internal view {
2009         _sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2010     }
2011 
2012     function log(string memory p0, address p1, uint p2, uint p3) internal view {
2013         _sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2014     }
2015 
2016     function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2017         _sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2018     }
2019 
2020     function log(string memory p0, address p1, uint p2, bool p3) internal view {
2021         _sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2022     }
2023 
2024     function log(string memory p0, address p1, uint p2, address p3) internal view {
2025         _sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2026     }
2027 
2028     function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2029         _sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2030     }
2031 
2032     function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2033         _sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2034     }
2035 
2036     function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2037         _sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2038     }
2039 
2040     function log(string memory p0, address p1, string memory p2, address p3) internal view {
2041         _sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2042     }
2043 
2044     function log(string memory p0, address p1, bool p2, uint p3) internal view {
2045         _sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2046     }
2047 
2048     function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2049         _sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2050     }
2051 
2052     function log(string memory p0, address p1, bool p2, bool p3) internal view {
2053         _sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2054     }
2055 
2056     function log(string memory p0, address p1, bool p2, address p3) internal view {
2057         _sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2058     }
2059 
2060     function log(string memory p0, address p1, address p2, uint p3) internal view {
2061         _sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2062     }
2063 
2064     function log(string memory p0, address p1, address p2, string memory p3) internal view {
2065         _sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2066     }
2067 
2068     function log(string memory p0, address p1, address p2, bool p3) internal view {
2069         _sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2070     }
2071 
2072     function log(string memory p0, address p1, address p2, address p3) internal view {
2073         _sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2074     }
2075 
2076     function log(bool p0, uint p1, uint p2, uint p3) internal view {
2077         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2078     }
2079 
2080     function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2081         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2082     }
2083 
2084     function log(bool p0, uint p1, uint p2, bool p3) internal view {
2085         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2086     }
2087 
2088     function log(bool p0, uint p1, uint p2, address p3) internal view {
2089         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2090     }
2091 
2092     function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2093         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2094     }
2095 
2096     function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2097         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2098     }
2099 
2100     function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2101         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2102     }
2103 
2104     function log(bool p0, uint p1, string memory p2, address p3) internal view {
2105         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2106     }
2107 
2108     function log(bool p0, uint p1, bool p2, uint p3) internal view {
2109         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2110     }
2111 
2112     function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2113         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2114     }
2115 
2116     function log(bool p0, uint p1, bool p2, bool p3) internal view {
2117         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2118     }
2119 
2120     function log(bool p0, uint p1, bool p2, address p3) internal view {
2121         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2122     }
2123 
2124     function log(bool p0, uint p1, address p2, uint p3) internal view {
2125         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2126     }
2127 
2128     function log(bool p0, uint p1, address p2, string memory p3) internal view {
2129         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2130     }
2131 
2132     function log(bool p0, uint p1, address p2, bool p3) internal view {
2133         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2134     }
2135 
2136     function log(bool p0, uint p1, address p2, address p3) internal view {
2137         _sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2138     }
2139 
2140     function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2141         _sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2142     }
2143 
2144     function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2145         _sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2146     }
2147 
2148     function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2149         _sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2150     }
2151 
2152     function log(bool p0, string memory p1, uint p2, address p3) internal view {
2153         _sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2154     }
2155 
2156     function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2157         _sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2158     }
2159 
2160     function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2161         _sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2162     }
2163 
2164     function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2165         _sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2166     }
2167 
2168     function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2169         _sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2170     }
2171 
2172     function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2173         _sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2174     }
2175 
2176     function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2177         _sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2178     }
2179 
2180     function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2181         _sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2182     }
2183 
2184     function log(bool p0, string memory p1, bool p2, address p3) internal view {
2185         _sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2186     }
2187 
2188     function log(bool p0, string memory p1, address p2, uint p3) internal view {
2189         _sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2190     }
2191 
2192     function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2193         _sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2194     }
2195 
2196     function log(bool p0, string memory p1, address p2, bool p3) internal view {
2197         _sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2198     }
2199 
2200     function log(bool p0, string memory p1, address p2, address p3) internal view {
2201         _sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2202     }
2203 
2204     function log(bool p0, bool p1, uint p2, uint p3) internal view {
2205         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2206     }
2207 
2208     function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2209         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2210     }
2211 
2212     function log(bool p0, bool p1, uint p2, bool p3) internal view {
2213         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2214     }
2215 
2216     function log(bool p0, bool p1, uint p2, address p3) internal view {
2217         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2218     }
2219 
2220     function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2221         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2222     }
2223 
2224     function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2225         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2226     }
2227 
2228     function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2229         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2230     }
2231 
2232     function log(bool p0, bool p1, string memory p2, address p3) internal view {
2233         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2234     }
2235 
2236     function log(bool p0, bool p1, bool p2, uint p3) internal view {
2237         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2238     }
2239 
2240     function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2241         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2242     }
2243 
2244     function log(bool p0, bool p1, bool p2, bool p3) internal view {
2245         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2246     }
2247 
2248     function log(bool p0, bool p1, bool p2, address p3) internal view {
2249         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2250     }
2251 
2252     function log(bool p0, bool p1, address p2, uint p3) internal view {
2253         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2254     }
2255 
2256     function log(bool p0, bool p1, address p2, string memory p3) internal view {
2257         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2258     }
2259 
2260     function log(bool p0, bool p1, address p2, bool p3) internal view {
2261         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2262     }
2263 
2264     function log(bool p0, bool p1, address p2, address p3) internal view {
2265         _sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2266     }
2267 
2268     function log(bool p0, address p1, uint p2, uint p3) internal view {
2269         _sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2270     }
2271 
2272     function log(bool p0, address p1, uint p2, string memory p3) internal view {
2273         _sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2274     }
2275 
2276     function log(bool p0, address p1, uint p2, bool p3) internal view {
2277         _sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2278     }
2279 
2280     function log(bool p0, address p1, uint p2, address p3) internal view {
2281         _sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2282     }
2283 
2284     function log(bool p0, address p1, string memory p2, uint p3) internal view {
2285         _sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2286     }
2287 
2288     function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2289         _sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2290     }
2291 
2292     function log(bool p0, address p1, string memory p2, bool p3) internal view {
2293         _sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2294     }
2295 
2296     function log(bool p0, address p1, string memory p2, address p3) internal view {
2297         _sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2298     }
2299 
2300     function log(bool p0, address p1, bool p2, uint p3) internal view {
2301         _sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2302     }
2303 
2304     function log(bool p0, address p1, bool p2, string memory p3) internal view {
2305         _sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2306     }
2307 
2308     function log(bool p0, address p1, bool p2, bool p3) internal view {
2309         _sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2310     }
2311 
2312     function log(bool p0, address p1, bool p2, address p3) internal view {
2313         _sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2314     }
2315 
2316     function log(bool p0, address p1, address p2, uint p3) internal view {
2317         _sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2318     }
2319 
2320     function log(bool p0, address p1, address p2, string memory p3) internal view {
2321         _sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2322     }
2323 
2324     function log(bool p0, address p1, address p2, bool p3) internal view {
2325         _sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2326     }
2327 
2328     function log(bool p0, address p1, address p2, address p3) internal view {
2329         _sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2330     }
2331 
2332     function log(address p0, uint p1, uint p2, uint p3) internal view {
2333         _sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2334     }
2335 
2336     function log(address p0, uint p1, uint p2, string memory p3) internal view {
2337         _sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2338     }
2339 
2340     function log(address p0, uint p1, uint p2, bool p3) internal view {
2341         _sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2342     }
2343 
2344     function log(address p0, uint p1, uint p2, address p3) internal view {
2345         _sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2346     }
2347 
2348     function log(address p0, uint p1, string memory p2, uint p3) internal view {
2349         _sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2350     }
2351 
2352     function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2353         _sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2354     }
2355 
2356     function log(address p0, uint p1, string memory p2, bool p3) internal view {
2357         _sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2358     }
2359 
2360     function log(address p0, uint p1, string memory p2, address p3) internal view {
2361         _sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2362     }
2363 
2364     function log(address p0, uint p1, bool p2, uint p3) internal view {
2365         _sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2366     }
2367 
2368     function log(address p0, uint p1, bool p2, string memory p3) internal view {
2369         _sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2370     }
2371 
2372     function log(address p0, uint p1, bool p2, bool p3) internal view {
2373         _sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2374     }
2375 
2376     function log(address p0, uint p1, bool p2, address p3) internal view {
2377         _sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2378     }
2379 
2380     function log(address p0, uint p1, address p2, uint p3) internal view {
2381         _sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2382     }
2383 
2384     function log(address p0, uint p1, address p2, string memory p3) internal view {
2385         _sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2386     }
2387 
2388     function log(address p0, uint p1, address p2, bool p3) internal view {
2389         _sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2390     }
2391 
2392     function log(address p0, uint p1, address p2, address p3) internal view {
2393         _sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2394     }
2395 
2396     function log(address p0, string memory p1, uint p2, uint p3) internal view {
2397         _sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2398     }
2399 
2400     function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2401         _sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2402     }
2403 
2404     function log(address p0, string memory p1, uint p2, bool p3) internal view {
2405         _sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2406     }
2407 
2408     function log(address p0, string memory p1, uint p2, address p3) internal view {
2409         _sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2410     }
2411 
2412     function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2413         _sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2414     }
2415 
2416     function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2417         _sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2418     }
2419 
2420     function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2421         _sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2422     }
2423 
2424     function log(address p0, string memory p1, string memory p2, address p3) internal view {
2425         _sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2426     }
2427 
2428     function log(address p0, string memory p1, bool p2, uint p3) internal view {
2429         _sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2430     }
2431 
2432     function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2433         _sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2434     }
2435 
2436     function log(address p0, string memory p1, bool p2, bool p3) internal view {
2437         _sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2438     }
2439 
2440     function log(address p0, string memory p1, bool p2, address p3) internal view {
2441         _sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2442     }
2443 
2444     function log(address p0, string memory p1, address p2, uint p3) internal view {
2445         _sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2446     }
2447 
2448     function log(address p0, string memory p1, address p2, string memory p3) internal view {
2449         _sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2450     }
2451 
2452     function log(address p0, string memory p1, address p2, bool p3) internal view {
2453         _sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2454     }
2455 
2456     function log(address p0, string memory p1, address p2, address p3) internal view {
2457         _sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2458     }
2459 
2460     function log(address p0, bool p1, uint p2, uint p3) internal view {
2461         _sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2462     }
2463 
2464     function log(address p0, bool p1, uint p2, string memory p3) internal view {
2465         _sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2466     }
2467 
2468     function log(address p0, bool p1, uint p2, bool p3) internal view {
2469         _sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2470     }
2471 
2472     function log(address p0, bool p1, uint p2, address p3) internal view {
2473         _sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2474     }
2475 
2476     function log(address p0, bool p1, string memory p2, uint p3) internal view {
2477         _sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2478     }
2479 
2480     function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2481         _sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2482     }
2483 
2484     function log(address p0, bool p1, string memory p2, bool p3) internal view {
2485         _sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2486     }
2487 
2488     function log(address p0, bool p1, string memory p2, address p3) internal view {
2489         _sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2490     }
2491 
2492     function log(address p0, bool p1, bool p2, uint p3) internal view {
2493         _sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2494     }
2495 
2496     function log(address p0, bool p1, bool p2, string memory p3) internal view {
2497         _sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2498     }
2499 
2500     function log(address p0, bool p1, bool p2, bool p3) internal view {
2501         _sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2502     }
2503 
2504     function log(address p0, bool p1, bool p2, address p3) internal view {
2505         _sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2506     }
2507 
2508     function log(address p0, bool p1, address p2, uint p3) internal view {
2509         _sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2510     }
2511 
2512     function log(address p0, bool p1, address p2, string memory p3) internal view {
2513         _sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2514     }
2515 
2516     function log(address p0, bool p1, address p2, bool p3) internal view {
2517         _sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2518     }
2519 
2520     function log(address p0, bool p1, address p2, address p3) internal view {
2521         _sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2522     }
2523 
2524     function log(address p0, address p1, uint p2, uint p3) internal view {
2525         _sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2526     }
2527 
2528     function log(address p0, address p1, uint p2, string memory p3) internal view {
2529         _sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2530     }
2531 
2532     function log(address p0, address p1, uint p2, bool p3) internal view {
2533         _sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2534     }
2535 
2536     function log(address p0, address p1, uint p2, address p3) internal view {
2537         _sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2538     }
2539 
2540     function log(address p0, address p1, string memory p2, uint p3) internal view {
2541         _sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2542     }
2543 
2544     function log(address p0, address p1, string memory p2, string memory p3) internal view {
2545         _sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2546     }
2547 
2548     function log(address p0, address p1, string memory p2, bool p3) internal view {
2549         _sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2550     }
2551 
2552     function log(address p0, address p1, string memory p2, address p3) internal view {
2553         _sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2554     }
2555 
2556     function log(address p0, address p1, bool p2, uint p3) internal view {
2557         _sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2558     }
2559 
2560     function log(address p0, address p1, bool p2, string memory p3) internal view {
2561         _sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2562     }
2563 
2564     function log(address p0, address p1, bool p2, bool p3) internal view {
2565         _sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2566     }
2567 
2568     function log(address p0, address p1, bool p2, address p3) internal view {
2569         _sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2570     }
2571 
2572     function log(address p0, address p1, address p2, uint p3) internal view {
2573         _sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2574     }
2575 
2576     function log(address p0, address p1, address p2, string memory p3) internal view {
2577         _sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2578     }
2579 
2580     function log(address p0, address p1, address p2, bool p3) internal view {
2581         _sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2582     }
2583 
2584     function log(address p0, address p1, address p2, address p3) internal view {
2585         _sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2586     }
2587 
2588 }
2589 
2590 // File: contracts/SIMP.sol
2591 
2592 
2593 
2594 pragma solidity ^0.8.0;
2595 
2596 
2597 
2598 
2599 
2600 
2601 
2602 
2603 contract SIMP is ERC20, Ownable {
2604     using SafeMath for uint256;
2605 
2606     modifier lockSwap {
2607         _inSwap = true;
2608         _;
2609         _inSwap = false;
2610     }
2611 
2612     modifier liquidityAdd {
2613         _inLiquidityAdd = true;
2614         _;
2615         _inLiquidityAdd = false;
2616     }
2617 
2618     uint256 public constant MAX_SUPPLY = 1_000_000_000 ether;
2619 
2620     uint256 internal _maxTransfer = 5;
2621     uint256 public marketingRate = 5;
2622     uint256 public treasuryRate = 5;
2623     uint256 public reflectRate = 5;
2624     /// @notice Contract SIMP balance threshold before `_swap` is invoked
2625     uint256 public minTokenBalance = 10000000 ether;
2626     bool public swapFees = true;
2627 
2628     // total wei reflected ever
2629     uint256 public ethReflectionBasis;
2630     uint256 public totalReflected;
2631     uint256 public totalMarketing;
2632     uint256 public totalTreasury;
2633 
2634     address payable public marketingWallet;
2635     address payable public treasuryWallet;
2636 
2637     uint256 internal _totalSupply = 0;
2638     IUniswapV2Router02 internal _router = IUniswapV2Router02(address(0));
2639     address internal _pair;
2640     bool internal _inSwap = false;
2641     bool internal _inLiquidityAdd = false;
2642     bool public tradingActive = false;
2643 
2644     mapping(address => uint256) private _balances;
2645     mapping(address => bool) private _taxExcluded;
2646     mapping(address => uint256) public lastReflectionBasis;
2647 
2648     constructor(
2649         address _uniswapFactory,
2650         address _uniswapRouter,
2651         address payable _marketingWallet,
2652         address payable _treasuryWallet
2653     ) ERC20("SIMPTOKEN v2", "SIMP") Ownable() {
2654         addTaxExcluded(owner());
2655         addTaxExcluded(address(0));
2656         addTaxExcluded(_marketingWallet);
2657         addTaxExcluded(_treasuryWallet);
2658         addTaxExcluded(address(this));
2659 
2660         marketingWallet = _marketingWallet;
2661         treasuryWallet = _treasuryWallet;
2662 
2663         _router = IUniswapV2Router02(_uniswapRouter);
2664         IUniswapV2Factory uniswapContract = IUniswapV2Factory(_uniswapFactory);
2665         _pair = uniswapContract.createPair(address(this), _router.WETH());
2666     }
2667 
2668     /// @notice Change the address of the marketing wallet
2669     /// @param _marketingWallet The new address of the marketing wallet
2670     function setMarketingWallet(address payable _marketingWallet) external onlyOwner() {
2671         marketingWallet = _marketingWallet;
2672     }
2673 
2674     /// @notice Change the address of the treasury wallet
2675     /// @param _treasuryWallet The new address of the treasury wallet
2676     function setTreasuryWallet(address payable _treasuryWallet) external onlyOwner() {
2677         treasuryWallet = _treasuryWallet;
2678     }
2679 
2680     /// @notice Change the marketing tax rate
2681     /// @param _marketingRate The new marketing tax rate
2682     function setMarketingRate(uint256 _marketingRate) external onlyOwner() {
2683         require(_marketingRate <= 100, "_marketingRate cannot exceed 100%");
2684         marketingRate = _marketingRate;
2685     }
2686 
2687     /// @notice Change the treasury tax rate
2688     /// @param _treasuryRate The new treasury tax rate
2689     function setTreasuryRate(uint256 _treasuryRate) external onlyOwner() {
2690         require(_treasuryRate <= 100, "_treasuryRate cannot exceed 100%");
2691         treasuryRate = _treasuryRate;
2692     }
2693 
2694     /// @notice Change the reflection tax rate
2695     /// @param _reflectRate The new reflection tax rate
2696     function setReflectRate(uint256 _reflectRate) external onlyOwner() {
2697         require(_reflectRate <= 100, "_reflectRate cannot exceed 100%");
2698         reflectRate = _reflectRate;
2699     }
2700 
2701     /// @notice Change the minimum contract SIMP balance before `_swap` gets invoked
2702     /// @param _minTokenBalance The new minimum balance
2703     function setMinTokenBalance(uint256 _minTokenBalance) external onlyOwner() {
2704         minTokenBalance = _minTokenBalance;
2705     }
2706 
2707     /// @notice Rescue SIMP from the marketing amount
2708     /// @dev Should only be used in an emergency
2709     /// @param _amount The amount of SIMP to rescue
2710     /// @param _recipient The recipient of the rescued SIMP
2711     function rescueMarketingTokens(uint256 _amount, address _recipient) external onlyOwner() {
2712         require(_amount <= totalMarketing, "Amount cannot be greater than totalMarketing");
2713         _rawTransfer(address(this), _recipient, _amount);
2714         totalMarketing -= _amount;
2715     }
2716 
2717     /// @notice Rescue SIMP from the treasury amount
2718     /// @dev Should only be used in an emergency
2719     /// @param _amount The amount of SIMP to rescue
2720     /// @param _recipient The recipient of the rescued SIMP
2721     function rescueTreasuryTokens(uint256 _amount, address _recipient) external onlyOwner() {
2722         require(_amount <= totalTreasury, "Amount cannot be greater than totalTreasury");
2723         _rawTransfer(address(this), _recipient, _amount);
2724         totalTreasury -= _amount;
2725     }
2726 
2727     /// @notice Rescue SIMP from the reflection amount
2728     /// @dev Should only be used in an emergency
2729     /// @param _amount The amount of SIMP to rescue
2730     /// @param _recipient The recipient of the rescued SIMP
2731     function rescueReflectionTokens(uint256 _amount, address _recipient) external onlyOwner() {
2732         require(_amount <= totalReflected, "Amount cannot be greater than totalReflected");
2733         _rawTransfer(address(this), _recipient, _amount);
2734         totalReflected -= _amount;
2735     }
2736 
2737     function addLiquidity(uint256 tokens) external payable onlyOwner() liquidityAdd {
2738         _mint(address(this), tokens);
2739         _approve(address(this), address(_router), tokens);
2740 
2741         _router.addLiquidityETH{value: msg.value}(
2742             address(this),
2743             tokens,
2744             0,
2745             0,
2746             owner(),
2747         // solhint-disable-next-line not-rely-on-time
2748             block.timestamp
2749         );
2750     }
2751 
2752     /// @notice Enables trading on Uniswap
2753     function enableTrading() external onlyOwner {
2754         tradingActive = true;
2755     }
2756 
2757     /// @notice Disables trading on Uniswap
2758     function disableTrading() external onlyOwner {
2759         tradingActive = false;
2760     }
2761 
2762     function addReflection() external payable {
2763         ethReflectionBasis += msg.value;
2764     }
2765 
2766     function isTaxExcluded(address account) public view returns (bool) {
2767         return _taxExcluded[account];
2768     }
2769 
2770     function addTaxExcluded(address account) public onlyOwner() {
2771         require(!isTaxExcluded(account), "Account must not be excluded");
2772 
2773         _taxExcluded[account] = true;
2774     }
2775 
2776     function removeTaxExcluded(address account) external onlyOwner() {
2777         require(isTaxExcluded(account), "Account must not be excluded");
2778 
2779         _taxExcluded[account] = false;
2780     }
2781 
2782     function balanceOf(address account)
2783     public
2784     view
2785     virtual
2786     override
2787     returns (uint256)
2788     {
2789         return _balances[account];
2790     }
2791 
2792     function _addBalance(address account, uint256 amount) internal {
2793         _balances[account] = _balances[account] + amount;
2794     }
2795 
2796     function _subtractBalance(address account, uint256 amount) internal {
2797         _balances[account] = _balances[account] - amount;
2798     }
2799 
2800     function _transfer(
2801         address sender,
2802         address recipient,
2803         uint256 amount
2804     ) internal override {
2805         if (isTaxExcluded(sender) || isTaxExcluded(recipient)) {
2806             _rawTransfer(sender, recipient, amount);
2807             return;
2808         }
2809 
2810         uint256 maxTxAmount = totalSupply() * _maxTransfer / 1000;
2811         require(amount <= maxTxAmount || _inLiquidityAdd || _inSwap || recipient == address(_router), "Exceeds max transaction amount");
2812 
2813         uint256 contractTokenBalance = balanceOf(address(this));
2814         bool overMinTokenBalance = contractTokenBalance >= minTokenBalance;
2815 
2816         if(contractTokenBalance >= maxTxAmount) {
2817             contractTokenBalance = maxTxAmount;
2818         }
2819 
2820         if (
2821             overMinTokenBalance &&
2822             !_inSwap &&
2823             sender != _pair &&
2824             swapFees
2825         ) {
2826             _swap(contractTokenBalance);
2827         }
2828 
2829         _claimReflection(payable(sender));
2830         _claimReflection(payable(recipient));
2831 
2832         uint256 send = amount;
2833         uint256 reflect;
2834         uint256 marketing;
2835         uint256 treasury;
2836         if (sender == _pair || recipient == _pair) {
2837             require(tradingActive, "Trading is not yet active");
2838             (
2839             send,
2840             reflect,
2841             marketing,
2842             treasury
2843             ) = _getTaxAmounts(amount);
2844         }
2845         _rawTransfer(sender, recipient, send);
2846         _takeTaxes(sender, marketing, treasury, reflect);
2847     }
2848 
2849     function unclaimedReflection(address addr) public view returns (uint256) {
2850         if (addr == _pair || addr == address(_router)) return 0;
2851 
2852         uint256 basisDifference = ethReflectionBasis - lastReflectionBasis[addr];
2853         return basisDifference * balanceOf(addr) / _totalSupply;
2854     }
2855 
2856     /// @notice Claims reflection pool ETH
2857     /// @param addr The address to claim the reflection for
2858     function _claimReflection(address payable addr) internal {
2859         uint256 unclaimed = unclaimedReflection(addr);
2860         lastReflectionBasis[addr] = ethReflectionBasis;
2861         if (unclaimed > 0) {
2862             addr.transfer(unclaimed);
2863         }
2864     }
2865 
2866     function claimReflection() external {
2867         _claimReflection(payable(msg.sender));
2868     }
2869 
2870     /// @notice Perform a Uniswap v2 swap from SIMP to ETH and handle tax distribution
2871     /// @param amount The amount of SIMP to swap in wei
2872     /// @dev `amount` is always <= this contract's ETH balance. Calculate and distribute marketing and reflection taxes
2873     function _swap(uint256 amount) internal lockSwap {
2874         address[] memory path = new address[](2);
2875         path[0] = address(this);
2876         path[1] = _router.WETH();
2877 
2878         _approve(address(this), address(_router), amount);
2879 
2880         uint256 contractEthBalance = address(this).balance;
2881 
2882         _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2883             amount,
2884             0,
2885             path,
2886             address(this),
2887             block.timestamp
2888         );
2889 
2890         uint256 tradeValue = address(this).balance - contractEthBalance;
2891 
2892         uint256 totalTaxes = totalMarketing.add(totalTreasury).add(totalReflected);
2893         uint256 marketingAmount = amount.mul(totalMarketing).div(totalTaxes);
2894         uint256 treasuryAmount = amount.mul(totalTreasury).div(totalTaxes);
2895         uint256 reflectedAmount = amount.sub(marketingAmount).sub(treasuryAmount);
2896 
2897         uint256 marketingEth = tradeValue.mul(totalMarketing).div(totalTaxes);
2898         uint256 treasuryEth = tradeValue.mul(totalTreasury).div(totalTaxes);
2899         uint256 reflectedEth = tradeValue.sub(marketingEth).sub(treasuryEth);
2900 
2901         if (marketingEth > 0) {
2902             marketingWallet.transfer(marketingEth);
2903         }
2904         if (treasuryEth > 0) {
2905             treasuryWallet.transfer(treasuryEth);
2906         }
2907         totalMarketing = totalMarketing.sub(marketingAmount);
2908         totalTreasury = totalTreasury.sub(treasuryAmount);
2909         totalReflected = totalReflected.sub(reflectedAmount);
2910         ethReflectionBasis = ethReflectionBasis.add(reflectedEth);
2911     }
2912 
2913     function swapAll() external {
2914         uint256 maxTxAmount = totalSupply() * _maxTransfer / 1000;
2915         uint256 contractTokenBalance = balanceOf(address(this));
2916 
2917         if(contractTokenBalance >= maxTxAmount)
2918         {
2919             contractTokenBalance = maxTxAmount;
2920         }
2921 
2922         if (
2923             !_inSwap
2924         ) {
2925             _swap(contractTokenBalance);
2926         }
2927     }
2928 
2929     function withdrawAll() external onlyOwner() {
2930         payable(owner()).transfer(address(this).balance);
2931     }
2932 
2933     /// @notice Transfers SIMP from an account to this contract for taxes
2934     /// @param _account The account to transfer SIMP from
2935     /// @param _marketingAmount The amount of marketing tax to transfer
2936     /// @param _treasuryAmount The amount of treasury tax to transfer
2937     /// @param _reflectAmount The amount of reflection tax to transfer
2938     function _takeTaxes(
2939         address _account,
2940         uint256 _marketingAmount,
2941         uint256 _treasuryAmount,
2942         uint256 _reflectAmount
2943     ) internal {
2944         require(_account != address(0), "taxation from the zero address");
2945 
2946         uint256 totalAmount = _marketingAmount.add(_treasuryAmount).add(_reflectAmount);
2947         _rawTransfer(_account, address(this), totalAmount);
2948         totalMarketing += _marketingAmount;
2949         totalTreasury += _treasuryAmount;
2950         totalReflected += _reflectAmount;
2951     }
2952 
2953     /// @notice Get a breakdown of send and tax amounts
2954     /// @param amount The amount to tax in wei
2955     /// @return send The raw amount to send
2956     /// @return reflect The raw reflection tax amount
2957     /// @return marketing The raw marketing tax amount
2958     /// @return treasury The raw treasury tax amount
2959     function _getTaxAmounts(uint256 amount)
2960     internal
2961     view
2962     returns (
2963         uint256 send,
2964         uint256 reflect,
2965         uint256 marketing,
2966         uint256 treasury
2967     )
2968     {
2969         reflect = amount.mul(reflectRate).div(100);
2970         marketing = amount.mul(marketingRate).div(100);
2971         treasury = amount.mul(treasuryRate).div(100);
2972         send = amount.sub(reflect).sub(marketing).sub(treasury);
2973     }
2974 
2975     // modified from OpenZeppelin ERC20
2976     function _rawTransfer(
2977         address sender,
2978         address recipient,
2979         uint256 amount
2980     ) internal {
2981         require(sender != address(0), "transfer from the zero address");
2982         require(recipient != address(0), "transfer to the zero address");
2983 
2984         uint256 senderBalance = balanceOf(sender);
2985         require(senderBalance >= amount, "transfer amount exceeds balance");
2986     unchecked {
2987         _subtractBalance(sender, amount);
2988     }
2989         _addBalance(recipient, amount);
2990 
2991         emit Transfer(sender, recipient, amount);
2992     }
2993 
2994     function setMaxTransfer(uint256 maxTransfer) external onlyOwner() {
2995         _maxTransfer = maxTransfer;
2996     }
2997 
2998     /// @notice Enable or disable whether swap occurs during `_transfer`
2999     /// @param _swapFees If true, enables swap during `_transfer`
3000     function setSwapFees(bool _swapFees) external onlyOwner() {
3001         swapFees = _swapFees;
3002     }
3003 
3004     function totalSupply() public view override returns (uint256) {
3005         return _totalSupply;
3006     }
3007 
3008     function _mint(address account, uint256 amount) internal override {
3009         require(_totalSupply.add(amount) <= MAX_SUPPLY, "Max supply exceeded");
3010         _totalSupply += amount;
3011         _addBalance(account, amount);
3012         emit Transfer(address(0), account, amount);
3013     }
3014 
3015     function mint(address account, uint256 amount) external onlyOwner() {
3016         _mint(account, amount);
3017     }
3018 
3019     function airdrop(address[] memory accounts, uint256[] memory amounts) external onlyOwner() {
3020         require(accounts.length == amounts.length, "array lengths must match");
3021 
3022         for (uint256 i = 0; i < accounts.length; i++) {
3023             _mint(accounts[i], amounts[i]);
3024         }
3025     }
3026 
3027     receive() external payable {}
3028 }