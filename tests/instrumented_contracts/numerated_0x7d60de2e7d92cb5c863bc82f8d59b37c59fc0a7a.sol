1 // File: https://github.com/aifeelit/pink-antibot-guide-binance-solidity/blob/main/IPinkAntiBot.sol
2 
3 
4 pragma solidity >=0.5.0;
5 
6 interface IPinkAntiBot {
7   function setTokenOwner(address owner) external;
8 
9   function onPreTransferCheck(
10     address from,
11     address to,
12     uint256 amount
13   ) external;
14 }
15 
16 // File: https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol
17 
18 pragma solidity >=0.5.0;
19 
20 interface IUniswapV2Pair {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23 
24     function name() external pure returns (string memory);
25     function symbol() external pure returns (string memory);
26     function decimals() external pure returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30 
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34 
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38 
39     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
40 
41     event Mint(address indexed sender, uint amount0, uint amount1);
42     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
43     event Swap(
44         address indexed sender,
45         uint amount0In,
46         uint amount1In,
47         uint amount0Out,
48         uint amount1Out,
49         address indexed to
50     );
51     event Sync(uint112 reserve0, uint112 reserve1);
52 
53     function MINIMUM_LIQUIDITY() external pure returns (uint);
54     function factory() external view returns (address);
55     function token0() external view returns (address);
56     function token1() external view returns (address);
57     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
58     function price0CumulativeLast() external view returns (uint);
59     function price1CumulativeLast() external view returns (uint);
60     function kLast() external view returns (uint);
61 
62     function mint(address to) external returns (uint liquidity);
63     function burn(address to) external returns (uint amount0, uint amount1);
64     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
65     function skim(address to) external;
66     function sync() external;
67 
68     function initialize(address, address) external;
69 }
70 
71 // File: https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Factory.sol
72 
73 pragma solidity >=0.5.0;
74 
75 interface IUniswapV2Factory {
76     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
77 
78     function feeTo() external view returns (address);
79     function feeToSetter() external view returns (address);
80 
81     function getPair(address tokenA, address tokenB) external view returns (address pair);
82     function allPairs(uint) external view returns (address pair);
83     function allPairsLength() external view returns (uint);
84 
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86 
87     function setFeeTo(address) external;
88     function setFeeToSetter(address) external;
89 }
90 
91 // File: https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router01.sol
92 
93 pragma solidity >=0.6.2;
94 
95 interface IUniswapV2Router01 {
96     function factory() external pure returns (address);
97     function WETH() external pure returns (address);
98 
99     function addLiquidity(
100         address tokenA,
101         address tokenB,
102         uint amountADesired,
103         uint amountBDesired,
104         uint amountAMin,
105         uint amountBMin,
106         address to,
107         uint deadline
108     ) external returns (uint amountA, uint amountB, uint liquidity);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117     function removeLiquidity(
118         address tokenA,
119         address tokenB,
120         uint liquidity,
121         uint amountAMin,
122         uint amountBMin,
123         address to,
124         uint deadline
125     ) external returns (uint amountA, uint amountB);
126     function removeLiquidityETH(
127         address token,
128         uint liquidity,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline
133     ) external returns (uint amountToken, uint amountETH);
134     function removeLiquidityWithPermit(
135         address tokenA,
136         address tokenB,
137         uint liquidity,
138         uint amountAMin,
139         uint amountBMin,
140         address to,
141         uint deadline,
142         bool approveMax, uint8 v, bytes32 r, bytes32 s
143     ) external returns (uint amountA, uint amountB);
144     function removeLiquidityETHWithPermit(
145         address token,
146         uint liquidity,
147         uint amountTokenMin,
148         uint amountETHMin,
149         address to,
150         uint deadline,
151         bool approveMax, uint8 v, bytes32 r, bytes32 s
152     ) external returns (uint amountToken, uint amountETH);
153     function swapExactTokensForTokens(
154         uint amountIn,
155         uint amountOutMin,
156         address[] calldata path,
157         address to,
158         uint deadline
159     ) external returns (uint[] memory amounts);
160     function swapTokensForExactTokens(
161         uint amountOut,
162         uint amountInMax,
163         address[] calldata path,
164         address to,
165         uint deadline
166     ) external returns (uint[] memory amounts);
167     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
168         external
169         payable
170         returns (uint[] memory amounts);
171     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
172         external
173         returns (uint[] memory amounts);
174     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
175         external
176         returns (uint[] memory amounts);
177     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
178         external
179         payable
180         returns (uint[] memory amounts);
181 
182     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
183     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
184     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
185     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
186     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
187 }
188 
189 // File: https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol
190 
191 pragma solidity >=0.6.2;
192 
193 
194 interface IUniswapV2Router02 is IUniswapV2Router01 {
195     function removeLiquidityETHSupportingFeeOnTransferTokens(
196         address token,
197         uint liquidity,
198         uint amountTokenMin,
199         uint amountETHMin,
200         address to,
201         uint deadline
202     ) external returns (uint amountETH);
203     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
204         address token,
205         uint liquidity,
206         uint amountTokenMin,
207         uint amountETHMin,
208         address to,
209         uint deadline,
210         bool approveMax, uint8 v, bytes32 r, bytes32 s
211     ) external returns (uint amountETH);
212 
213     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
214         uint amountIn,
215         uint amountOutMin,
216         address[] calldata path,
217         address to,
218         uint deadline
219     ) external;
220     function swapExactETHForTokensSupportingFeeOnTransferTokens(
221         uint amountOutMin,
222         address[] calldata path,
223         address to,
224         uint deadline
225     ) external payable;
226     function swapExactTokensForETHSupportingFeeOnTransferTokens(
227         uint amountIn,
228         uint amountOutMin,
229         address[] calldata path,
230         address to,
231         uint deadline
232     ) external;
233 }
234 
235 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
236 
237 
238 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 // CAUTION
243 // This version of SafeMath should only be used with Solidity 0.8 or later,
244 // because it relies on the compiler's built in overflow checks.
245 
246 /**
247  * @dev Wrappers over Solidity's arithmetic operations.
248  *
249  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
250  * now has built in overflow checking.
251  */
252 library SafeMath {
253     /**
254      * @dev Returns the addition of two unsigned integers, with an overflow flag.
255      *
256      * _Available since v3.4._
257      */
258     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
259         unchecked {
260             uint256 c = a + b;
261             if (c < a) return (false, 0);
262             return (true, c);
263         }
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
268      *
269      * _Available since v3.4._
270      */
271     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
272         unchecked {
273             if (b > a) return (false, 0);
274             return (true, a - b);
275         }
276     }
277 
278     /**
279      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
280      *
281      * _Available since v3.4._
282      */
283     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
284         unchecked {
285             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
286             // benefit is lost if 'b' is also tested.
287             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
288             if (a == 0) return (true, 0);
289             uint256 c = a * b;
290             if (c / a != b) return (false, 0);
291             return (true, c);
292         }
293     }
294 
295     /**
296      * @dev Returns the division of two unsigned integers, with a division by zero flag.
297      *
298      * _Available since v3.4._
299      */
300     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
301         unchecked {
302             if (b == 0) return (false, 0);
303             return (true, a / b);
304         }
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
309      *
310      * _Available since v3.4._
311      */
312     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
313         unchecked {
314             if (b == 0) return (false, 0);
315             return (true, a % b);
316         }
317     }
318 
319     /**
320      * @dev Returns the addition of two unsigned integers, reverting on
321      * overflow.
322      *
323      * Counterpart to Solidity's `+` operator.
324      *
325      * Requirements:
326      *
327      * - Addition cannot overflow.
328      */
329     function add(uint256 a, uint256 b) internal pure returns (uint256) {
330         return a + b;
331     }
332 
333     /**
334      * @dev Returns the subtraction of two unsigned integers, reverting on
335      * overflow (when the result is negative).
336      *
337      * Counterpart to Solidity's `-` operator.
338      *
339      * Requirements:
340      *
341      * - Subtraction cannot overflow.
342      */
343     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
344         return a - b;
345     }
346 
347     /**
348      * @dev Returns the multiplication of two unsigned integers, reverting on
349      * overflow.
350      *
351      * Counterpart to Solidity's `*` operator.
352      *
353      * Requirements:
354      *
355      * - Multiplication cannot overflow.
356      */
357     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
358         return a * b;
359     }
360 
361     /**
362      * @dev Returns the integer division of two unsigned integers, reverting on
363      * division by zero. The result is rounded towards zero.
364      *
365      * Counterpart to Solidity's `/` operator.
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function div(uint256 a, uint256 b) internal pure returns (uint256) {
372         return a / b;
373     }
374 
375     /**
376      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
377      * reverting when dividing by zero.
378      *
379      * Counterpart to Solidity's `%` operator. This function uses a `revert`
380      * opcode (which leaves remaining gas untouched) while Solidity uses an
381      * invalid opcode to revert (consuming all remaining gas).
382      *
383      * Requirements:
384      *
385      * - The divisor cannot be zero.
386      */
387     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
388         return a % b;
389     }
390 
391     /**
392      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
393      * overflow (when the result is negative).
394      *
395      * CAUTION: This function is deprecated because it requires allocating memory for the error
396      * message unnecessarily. For custom revert reasons use {trySub}.
397      *
398      * Counterpart to Solidity's `-` operator.
399      *
400      * Requirements:
401      *
402      * - Subtraction cannot overflow.
403      */
404     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
405         unchecked {
406             require(b <= a, errorMessage);
407             return a - b;
408         }
409     }
410 
411     /**
412      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
413      * division by zero. The result is rounded towards zero.
414      *
415      * Counterpart to Solidity's `/` operator. Note: this function uses a
416      * `revert` opcode (which leaves remaining gas untouched) while Solidity
417      * uses an invalid opcode to revert (consuming all remaining gas).
418      *
419      * Requirements:
420      *
421      * - The divisor cannot be zero.
422      */
423     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
424         unchecked {
425             require(b > 0, errorMessage);
426             return a / b;
427         }
428     }
429 
430     /**
431      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
432      * reverting with custom message when dividing by zero.
433      *
434      * CAUTION: This function is deprecated because it requires allocating memory for the error
435      * message unnecessarily. For custom revert reasons use {tryMod}.
436      *
437      * Counterpart to Solidity's `%` operator. This function uses a `revert`
438      * opcode (which leaves remaining gas untouched) while Solidity uses an
439      * invalid opcode to revert (consuming all remaining gas).
440      *
441      * Requirements:
442      *
443      * - The divisor cannot be zero.
444      */
445     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
446         unchecked {
447             require(b > 0, errorMessage);
448             return a % b;
449         }
450     }
451 }
452 
453 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @dev Provides information about the current execution context, including the
462  * sender of the transaction and its data. While these are generally available
463  * via msg.sender and msg.data, they should not be accessed in such a direct
464  * manner, since when dealing with meta-transactions the account sending and
465  * paying for execution may not be the actual sender (as far as an application
466  * is concerned).
467  *
468  * This contract is only required for intermediate, library-like contracts.
469  */
470 abstract contract Context {
471     function _msgSender() internal view virtual returns (address) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view virtual returns (bytes calldata) {
476         return msg.data;
477     }
478 }
479 
480 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
481 
482 
483 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 
488 /**
489  * @dev Contract module which provides a basic access control mechanism, where
490  * there is an account (an owner) that can be granted exclusive access to
491  * specific functions.
492  *
493  * By default, the owner account will be the one that deploys the contract. This
494  * can later be changed with {transferOwnership}.
495  *
496  * This module is used through inheritance. It will make available the modifier
497  * `onlyOwner`, which can be applied to your functions to restrict their use to
498  * the owner.
499  */
500 abstract contract Ownable is Context {
501     address private _owner;
502 
503     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
504 
505     /**
506      * @dev Initializes the contract setting the deployer as the initial owner.
507      */
508     constructor() {
509         _transferOwnership(_msgSender());
510     }
511 
512     /**
513      * @dev Throws if called by any account other than the owner.
514      */
515     modifier onlyOwner() {
516         _checkOwner();
517         _;
518     }
519 
520     /**
521      * @dev Returns the address of the current owner.
522      */
523     function owner() public view virtual returns (address) {
524         return _owner;
525     }
526 
527     /**
528      * @dev Throws if the sender is not the owner.
529      */
530     function _checkOwner() internal view virtual {
531         require(owner() == _msgSender(), "Ownable: caller is not the owner");
532     }
533 
534     /**
535      * @dev Leaves the contract without owner. It will not be possible to call
536      * `onlyOwner` functions anymore. Can only be called by the current owner.
537      *
538      * NOTE: Renouncing ownership will leave the contract without an owner,
539      * thereby removing any functionality that is only available to the owner.
540      */
541     function renounceOwnership() public virtual onlyOwner {
542         _transferOwnership(address(0));
543     }
544 
545     /**
546      * @dev Transfers ownership of the contract to a new account (`newOwner`).
547      * Can only be called by the current owner.
548      */
549     function transferOwnership(address newOwner) public virtual onlyOwner {
550         require(newOwner != address(0), "Ownable: new owner is the zero address");
551         _transferOwnership(newOwner);
552     }
553 
554     /**
555      * @dev Transfers ownership of the contract to a new account (`newOwner`).
556      * Internal function without access restriction.
557      */
558     function _transferOwnership(address newOwner) internal virtual {
559         address oldOwner = _owner;
560         _owner = newOwner;
561         emit OwnershipTransferred(oldOwner, newOwner);
562     }
563 }
564 
565 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
566 
567 
568 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 /**
573  * @dev Interface of the ERC20 standard as defined in the EIP.
574  */
575 interface IERC20 {
576     /**
577      * @dev Emitted when `value` tokens are moved from one account (`from`) to
578      * another (`to`).
579      *
580      * Note that `value` may be zero.
581      */
582     event Transfer(address indexed from, address indexed to, uint256 value);
583 
584     /**
585      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
586      * a call to {approve}. `value` is the new allowance.
587      */
588     event Approval(address indexed owner, address indexed spender, uint256 value);
589 
590     /**
591      * @dev Returns the amount of tokens in existence.
592      */
593     function totalSupply() external view returns (uint256);
594 
595     /**
596      * @dev Returns the amount of tokens owned by `account`.
597      */
598     function balanceOf(address account) external view returns (uint256);
599 
600     /**
601      * @dev Moves `amount` tokens from the caller's account to `to`.
602      *
603      * Returns a boolean value indicating whether the operation succeeded.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transfer(address to, uint256 amount) external returns (bool);
608 
609     /**
610      * @dev Returns the remaining number of tokens that `spender` will be
611      * allowed to spend on behalf of `owner` through {transferFrom}. This is
612      * zero by default.
613      *
614      * This value changes when {approve} or {transferFrom} are called.
615      */
616     function allowance(address owner, address spender) external view returns (uint256);
617 
618     /**
619      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
620      *
621      * Returns a boolean value indicating whether the operation succeeded.
622      *
623      * IMPORTANT: Beware that changing an allowance with this method brings the risk
624      * that someone may use both the old and the new allowance by unfortunate
625      * transaction ordering. One possible solution to mitigate this race
626      * condition is to first reduce the spender's allowance to 0 and set the
627      * desired value afterwards:
628      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
629      *
630      * Emits an {Approval} event.
631      */
632     function approve(address spender, uint256 amount) external returns (bool);
633 
634     /**
635      * @dev Moves `amount` tokens from `from` to `to` using the
636      * allowance mechanism. `amount` is then deducted from the caller's
637      * allowance.
638      *
639      * Returns a boolean value indicating whether the operation succeeded.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transferFrom(address from, address to, uint256 amount) external returns (bool);
644 }
645 
646 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
647 
648 
649 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
650 
651 pragma solidity ^0.8.0;
652 
653 
654 /**
655  * @dev Interface for the optional metadata functions from the ERC20 standard.
656  *
657  * _Available since v4.1._
658  */
659 interface IERC20Metadata is IERC20 {
660     /**
661      * @dev Returns the name of the token.
662      */
663     function name() external view returns (string memory);
664 
665     /**
666      * @dev Returns the symbol of the token.
667      */
668     function symbol() external view returns (string memory);
669 
670     /**
671      * @dev Returns the decimals places of the token.
672      */
673     function decimals() external view returns (uint8);
674 }
675 
676 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
677 
678 
679 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 
684 
685 
686 /**
687  * @dev Implementation of the {IERC20} interface.
688  *
689  * This implementation is agnostic to the way tokens are created. This means
690  * that a supply mechanism has to be added in a derived contract using {_mint}.
691  * For a generic mechanism see {ERC20PresetMinterPauser}.
692  *
693  * TIP: For a detailed writeup see our guide
694  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
695  * to implement supply mechanisms].
696  *
697  * The default value of {decimals} is 18. To change this, you should override
698  * this function so it returns a different value.
699  *
700  * We have followed general OpenZeppelin Contracts guidelines: functions revert
701  * instead returning `false` on failure. This behavior is nonetheless
702  * conventional and does not conflict with the expectations of ERC20
703  * applications.
704  *
705  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
706  * This allows applications to reconstruct the allowance for all accounts just
707  * by listening to said events. Other implementations of the EIP may not emit
708  * these events, as it isn't required by the specification.
709  *
710  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
711  * functions have been added to mitigate the well-known issues around setting
712  * allowances. See {IERC20-approve}.
713  */
714 contract ERC20 is Context, IERC20, IERC20Metadata {
715     mapping(address => uint256) private _balances;
716 
717     mapping(address => mapping(address => uint256)) private _allowances;
718 
719     uint256 private _totalSupply;
720 
721     string private _name;
722     string private _symbol;
723 
724     /**
725      * @dev Sets the values for {name} and {symbol}.
726      *
727      * All two of these values are immutable: they can only be set once during
728      * construction.
729      */
730     constructor(string memory name_, string memory symbol_) {
731         _name = name_;
732         _symbol = symbol_;
733     }
734 
735     /**
736      * @dev Returns the name of the token.
737      */
738     function name() public view virtual override returns (string memory) {
739         return _name;
740     }
741 
742     /**
743      * @dev Returns the symbol of the token, usually a shorter version of the
744      * name.
745      */
746     function symbol() public view virtual override returns (string memory) {
747         return _symbol;
748     }
749 
750     /**
751      * @dev Returns the number of decimals used to get its user representation.
752      * For example, if `decimals` equals `2`, a balance of `505` tokens should
753      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
754      *
755      * Tokens usually opt for a value of 18, imitating the relationship between
756      * Ether and Wei. This is the default value returned by this function, unless
757      * it's overridden.
758      *
759      * NOTE: This information is only used for _display_ purposes: it in
760      * no way affects any of the arithmetic of the contract, including
761      * {IERC20-balanceOf} and {IERC20-transfer}.
762      */
763     function decimals() public view virtual override returns (uint8) {
764         return 18;
765     }
766 
767     /**
768      * @dev See {IERC20-totalSupply}.
769      */
770     function totalSupply() public view virtual override returns (uint256) {
771         return _totalSupply;
772     }
773 
774     /**
775      * @dev See {IERC20-balanceOf}.
776      */
777     function balanceOf(address account) public view virtual override returns (uint256) {
778         return _balances[account];
779     }
780 
781     /**
782      * @dev See {IERC20-transfer}.
783      *
784      * Requirements:
785      *
786      * - `to` cannot be the zero address.
787      * - the caller must have a balance of at least `amount`.
788      */
789     function transfer(address to, uint256 amount) public virtual override returns (bool) {
790         address owner = _msgSender();
791         _transfer(owner, to, amount);
792         return true;
793     }
794 
795     /**
796      * @dev See {IERC20-allowance}.
797      */
798     function allowance(address owner, address spender) public view virtual override returns (uint256) {
799         return _allowances[owner][spender];
800     }
801 
802     /**
803      * @dev See {IERC20-approve}.
804      *
805      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
806      * `transferFrom`. This is semantically equivalent to an infinite approval.
807      *
808      * Requirements:
809      *
810      * - `spender` cannot be the zero address.
811      */
812     function approve(address spender, uint256 amount) public virtual override returns (bool) {
813         address owner = _msgSender();
814         _approve(owner, spender, amount);
815         return true;
816     }
817 
818     /**
819      * @dev See {IERC20-transferFrom}.
820      *
821      * Emits an {Approval} event indicating the updated allowance. This is not
822      * required by the EIP. See the note at the beginning of {ERC20}.
823      *
824      * NOTE: Does not update the allowance if the current allowance
825      * is the maximum `uint256`.
826      *
827      * Requirements:
828      *
829      * - `from` and `to` cannot be the zero address.
830      * - `from` must have a balance of at least `amount`.
831      * - the caller must have allowance for ``from``'s tokens of at least
832      * `amount`.
833      */
834     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
835         address spender = _msgSender();
836         _spendAllowance(from, spender, amount);
837         _transfer(from, to, amount);
838         return true;
839     }
840 
841     /**
842      * @dev Atomically increases the allowance granted to `spender` by the caller.
843      *
844      * This is an alternative to {approve} that can be used as a mitigation for
845      * problems described in {IERC20-approve}.
846      *
847      * Emits an {Approval} event indicating the updated allowance.
848      *
849      * Requirements:
850      *
851      * - `spender` cannot be the zero address.
852      */
853     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
854         address owner = _msgSender();
855         _approve(owner, spender, allowance(owner, spender) + addedValue);
856         return true;
857     }
858 
859     /**
860      * @dev Atomically decreases the allowance granted to `spender` by the caller.
861      *
862      * This is an alternative to {approve} that can be used as a mitigation for
863      * problems described in {IERC20-approve}.
864      *
865      * Emits an {Approval} event indicating the updated allowance.
866      *
867      * Requirements:
868      *
869      * - `spender` cannot be the zero address.
870      * - `spender` must have allowance for the caller of at least
871      * `subtractedValue`.
872      */
873     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
874         address owner = _msgSender();
875         uint256 currentAllowance = allowance(owner, spender);
876         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
877         unchecked {
878             _approve(owner, spender, currentAllowance - subtractedValue);
879         }
880 
881         return true;
882     }
883 
884     /**
885      * @dev Moves `amount` of tokens from `from` to `to`.
886      *
887      * This internal function is equivalent to {transfer}, and can be used to
888      * e.g. implement automatic token fees, slashing mechanisms, etc.
889      *
890      * Emits a {Transfer} event.
891      *
892      * Requirements:
893      *
894      * - `from` cannot be the zero address.
895      * - `to` cannot be the zero address.
896      * - `from` must have a balance of at least `amount`.
897      */
898     function _transfer(address from, address to, uint256 amount) internal virtual {
899         require(from != address(0), "ERC20: transfer from the zero address");
900         require(to != address(0), "ERC20: transfer to the zero address");
901 
902         _beforeTokenTransfer(from, to, amount);
903 
904         uint256 fromBalance = _balances[from];
905         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
906         unchecked {
907             _balances[from] = fromBalance - amount;
908             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
909             // decrementing then incrementing.
910             _balances[to] += amount;
911         }
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
933         unchecked {
934             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
935             _balances[account] += amount;
936         }
937         emit Transfer(address(0), account, amount);
938 
939         _afterTokenTransfer(address(0), account, amount);
940     }
941 
942     /**
943      * @dev Destroys `amount` tokens from `account`, reducing the
944      * total supply.
945      *
946      * Emits a {Transfer} event with `to` set to the zero address.
947      *
948      * Requirements:
949      *
950      * - `account` cannot be the zero address.
951      * - `account` must have at least `amount` tokens.
952      */
953     function _burn(address account, uint256 amount) internal virtual {
954         require(account != address(0), "ERC20: burn from the zero address");
955 
956         _beforeTokenTransfer(account, address(0), amount);
957 
958         uint256 accountBalance = _balances[account];
959         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
960         unchecked {
961             _balances[account] = accountBalance - amount;
962             // Overflow not possible: amount <= accountBalance <= totalSupply.
963             _totalSupply -= amount;
964         }
965 
966         emit Transfer(account, address(0), amount);
967 
968         _afterTokenTransfer(account, address(0), amount);
969     }
970 
971     /**
972      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
973      *
974      * This internal function is equivalent to `approve`, and can be used to
975      * e.g. set automatic allowances for certain subsystems, etc.
976      *
977      * Emits an {Approval} event.
978      *
979      * Requirements:
980      *
981      * - `owner` cannot be the zero address.
982      * - `spender` cannot be the zero address.
983      */
984     function _approve(address owner, address spender, uint256 amount) internal virtual {
985         require(owner != address(0), "ERC20: approve from the zero address");
986         require(spender != address(0), "ERC20: approve to the zero address");
987 
988         _allowances[owner][spender] = amount;
989         emit Approval(owner, spender, amount);
990     }
991 
992     /**
993      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
994      *
995      * Does not update the allowance amount in case of infinite allowance.
996      * Revert if not enough allowance is available.
997      *
998      * Might emit an {Approval} event.
999      */
1000     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1001         uint256 currentAllowance = allowance(owner, spender);
1002         if (currentAllowance != type(uint256).max) {
1003             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1004             unchecked {
1005                 _approve(owner, spender, currentAllowance - amount);
1006             }
1007         }
1008     }
1009 
1010     /**
1011      * @dev Hook that is called before any transfer of tokens. This includes
1012      * minting and burning.
1013      *
1014      * Calling conditions:
1015      *
1016      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1017      * will be transferred to `to`.
1018      * - when `from` is zero, `amount` tokens will be minted for `to`.
1019      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1020      * - `from` and `to` are never both zero.
1021      *
1022      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1023      */
1024     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1025 
1026     /**
1027      * @dev Hook that is called after any transfer of tokens. This includes
1028      * minting and burning.
1029      *
1030      * Calling conditions:
1031      *
1032      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1033      * has been transferred to `to`.
1034      * - when `from` is zero, `amount` tokens have been minted for `to`.
1035      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1036      * - `from` and `to` are never both zero.
1037      *
1038      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1039      */
1040     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1041 }
1042 
1043 // File: aaa.sol
1044 
1045 //SPDX-License-Identifier: MIT
1046 
1047 pragma solidity =0.8.17;
1048 
1049 
1050 
1051 
1052 
1053 
1054 
1055 
1056 
1057 
1058 
1059 
1060 
1061 contract DeeLance is ERC20, Ownable {
1062     using SafeMath for uint256;
1063 
1064     IUniswapV2Router02 public uniswapV2Router;
1065     address public  uniswapV2Pair;
1066 
1067     bool private feeActive = true;
1068     bool public tradingEnabled;
1069     uint256 public launchTime;
1070 
1071     uint256 internal totaltokensupply =  1000000000 * (10**18);
1072 
1073 
1074     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
1075 
1076     IPinkAntiBot public pinkAntiBot;
1077 
1078     uint256 public buyFee = 0;
1079     uint256 public sellFee = 0;
1080     uint256 public maxtranscation = 5000000000000000;
1081     
1082     bool public antiBotEnabled;
1083     bool public antiDumpEnabled = false;
1084 
1085 
1086     bool public verifierOne = false;
1087     bool public verifierOwner = false;
1088 
1089     address public feeWallet     = 0x91130ca7111A5333051dB4b4c8aC553Bf25041E8; 
1090     address public pinkAntiBot_  = 0xf4f071EB637b64fC78C9eA87DaCE4445D119CA35;
1091     address public firstVerifier = 0x3de72566bA2917D96a90500bd8B165863EE4c900; 
1092 
1093     modifier onlyfirstVerifier() {
1094         require(_msgSender() == firstVerifier, "Ownable: caller is not the first voter");
1095         _;
1096     }
1097 
1098      // exclude from fees and max transaction amount
1099     mapping (address => bool) private _isExcludedFromFees;
1100 
1101     mapping (address => uint256) public antiDump;
1102     mapping (address => uint256) public sellingTotal;
1103     mapping (address => uint256) public lastSellstamp;
1104     uint256 public antiDumpTime = 10 minutes;
1105     uint256 public antiDumpAmount = totaltokensupply.mul(5).div(10000);
1106 
1107 
1108 
1109     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1110     // could be subject to a maximum transfer amount
1111     mapping (address => bool) public automatedMarketMakerPairs;
1112 
1113 
1114     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1115 
1116     event ExcludeFromFees(address indexed account, bool isExcluded);
1117     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1118 
1119     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1120 
1121     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1122 
1123 
1124     constructor() ERC20("DeeLance", "$dlance") {
1125 
1126     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1127          // Create a uniswap pair for this new token
1128         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1129             .createPair(address(this), _uniswapV2Router.WETH());
1130 
1131         uniswapV2Router = _uniswapV2Router;
1132         uniswapV2Pair = _uniswapV2Pair;
1133 
1134         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1135         pinkAntiBot = IPinkAntiBot(pinkAntiBot_);
1136         pinkAntiBot.setTokenOwner(msg.sender);
1137         antiBotEnabled = true;
1138 
1139         // exclude from paying fees or having max transaction amount
1140         excludeFromFees(owner(), true);
1141         excludeFromFees(address(this), true);
1142 
1143         /*
1144             _mint is an internal function in ERC20.sol that is only called here,
1145             and CANNOT be called ever again
1146         */
1147         _mint(owner(), totaltokensupply);
1148     }
1149 
1150     receive() external payable {
1151 
1152   	}
1153 
1154     function setEnableAntiBot(bool _enable) external onlyOwner {
1155         antiBotEnabled = _enable;
1156     }
1157 
1158     function setantiDumpEnabled(bool nodumpamount) external onlyOwner {
1159         antiDumpEnabled = nodumpamount;
1160     }
1161 
1162     function setantiDump(uint256 interval, uint256 amount) external onlyOwner {
1163         antiDumpTime = interval;
1164         antiDumpAmount = amount;
1165     }
1166 
1167     function updateUniswapV2Router(address newAddress) public onlyOwner {
1168         require(newAddress != address(uniswapV2Router), "DeeLance: The router already has that address");
1169         require(newAddress != address(0), "new address is zero address");
1170         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1171         uniswapV2Router = IUniswapV2Router02(newAddress);
1172         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1173             .createPair(address(this), uniswapV2Router.WETH());
1174         uniswapV2Pair = _uniswapV2Pair;
1175     }
1176 
1177     function excludeFromFees(address account, bool excluded) public onlyOwner {
1178         require(_isExcludedFromFees[account] != excluded, "Deelance: Account is already the value of 'excluded'");
1179         _isExcludedFromFees[account] = excluded;
1180 
1181         emit ExcludeFromFees(account, excluded);
1182     }
1183 
1184     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1185         for(uint256 i = 0; i < accounts.length; i++) {
1186             _isExcludedFromFees[accounts[i]] = excluded;
1187         }
1188 
1189         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1190     }
1191 
1192     function setbuyFee(uint256 value) external onlyOwner{
1193         require(value <= 15, "Max 15%");
1194         buyFee = value;
1195     }
1196 
1197     function setsellFee(uint256 value) external onlyOwner{
1198         require(value <= 15, "Max 15%");
1199         sellFee = value;
1200     }
1201 
1202     function setmaxtranscation(uint256 value) external onlyOwner{
1203         maxtranscation = value;
1204     }
1205 
1206     function setfeeWallet(address feaddress) public onlyOwner {
1207         feeWallet = feaddress;
1208     }
1209 
1210     function setFirstverifier(address faddress) public onlyOwner {
1211         require(faddress != address(0), "Ownable: new voter is the zero address");
1212         require(verifierOne == true && verifierOwner == true ,'not active');
1213         firstVerifier = faddress;
1214         verifierOne = false;
1215     }
1216 
1217 
1218     function setfeeActive(bool value) external onlyOwner {
1219         feeActive = value;
1220     }
1221 
1222     function voteVerifierOne(bool voteverifier) public onlyfirstVerifier() {
1223         verifierOne = voteverifier;
1224     }
1225 
1226     function voteVerifierOwner(bool voteverifier) public onlyOwner {
1227         verifierOwner = voteverifier;
1228     }
1229 
1230 
1231     function startTrading() external onlyOwner{
1232         require(launchTime == 0, "Already Listed!");
1233         launchTime = block.timestamp;
1234         tradingEnabled = true;
1235     }
1236 
1237     function pauseTrading() external onlyOwner{
1238         launchTime = 0 ;
1239         tradingEnabled = false;
1240 
1241     }
1242 
1243 
1244     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1245         require(pair != uniswapV2Pair, "DeeLance: The UniSwap pair cannot be removed from automatedMarketMakerPairs");
1246 
1247         _setAutomatedMarketMakerPair(pair, value);
1248     }
1249 
1250 
1251     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1252         require(automatedMarketMakerPairs[pair] != value, "DeeLance: Automated market maker pair is already set to that value");
1253         automatedMarketMakerPairs[pair] = value;
1254 
1255         emit SetAutomatedMarketMakerPair(pair, value);
1256     }
1257 
1258     function isExcludedFromFees(address account) public view returns(bool) {
1259         return _isExcludedFromFees[account];
1260     }
1261 
1262     function _transfer(
1263         address from,
1264         address to,
1265         uint256 amount
1266     ) internal override {
1267         require(from != address(0), "ERC20: transfer from the zero address");
1268         require(to != address(0), "ERC20: transfer to the zero address");
1269         require( _isExcludedFromFees[from] || _isExcludedFromFees[to]  || amount <= maxtranscation,"Max transaction Limit Exceeds!");
1270         if (antiBotEnabled) {
1271       pinkAntiBot.onPreTransferCheck(from, to, amount);
1272     }
1273 
1274         if(!_isExcludedFromFees[from]) { require(tradingEnabled == true, "Trading not enabled yet"); }
1275 
1276         if(from == owner()) { require(verifierOne == true && verifierOwner == true ,"not active"); }
1277 
1278 
1279 
1280         if(amount == 0) {
1281             super._transfer(from, to, 0);
1282             return;
1283         }
1284 
1285 
1286         if (
1287             !_isExcludedFromFees[from] &&
1288             !_isExcludedFromFees[to] &&
1289             launchTime + 3 minutes >= block.timestamp
1290         ) {
1291             // don't allow to buy more than 0.01% of total supply for 3 minutes after launch
1292             require(
1293                 automatedMarketMakerPairs[from] ||
1294                     balanceOf(to).add(amount) <= totaltokensupply.div(10000),
1295                 "AntiBot: Buy Banned!"
1296             );
1297             if (launchTime + 180 seconds >= block.timestamp)
1298                 // don't allow sell for 180 seconds after launch
1299                 require(
1300                     automatedMarketMakerPairs[to],
1301                     "AntiBot: Sell Banned!"
1302                 );
1303         }
1304 
1305 
1306         if (
1307             antiDumpEnabled &&
1308             automatedMarketMakerPairs[to] &&
1309             !_isExcludedFromFees[from]
1310         ) {
1311             require(
1312                 antiDump[from] < block.timestamp,
1313                 "Err: antiDump active"
1314             );
1315             if (
1316                 lastSellstamp[from] + antiDumpTime < block.timestamp
1317             ) {
1318                 lastSellstamp[from] = block.timestamp;
1319                 sellingTotal[from] = 0;
1320             }
1321             sellingTotal[from] = sellingTotal[from].add(amount);
1322             if (sellingTotal[from] >= antiDumpAmount) {
1323                 antiDump[from] = block.timestamp + antiDumpTime;
1324             }
1325         }
1326 
1327         bool takeFee = feeActive;
1328 
1329         // if any account belongs to _isExcludedFromFee account then remove the fee
1330         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1331             takeFee = false;
1332         }
1333 
1334         if(takeFee) {
1335 
1336             uint256 fees = 0;
1337             if(automatedMarketMakerPairs[from])
1338             {
1339         	    fees += amount.mul(buyFee).div(100);
1340         	}
1341         	if(automatedMarketMakerPairs[to]){
1342         	    fees += amount.mul(sellFee).div(100);
1343         	}
1344         	amount = amount.sub(fees);
1345 
1346 
1347 
1348             super._transfer(from, feeWallet, fees);
1349         }
1350 
1351         super._transfer(from, to, amount);
1352     }
1353 
1354     function recoverothertokens(address tokenAddress, uint256 tokenAmount) public  onlyOwner {
1355         require(tokenAddress != address(this), "cannot be same contract address");
1356         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1357     }
1358 
1359 
1360     function recovertoken(address payable destination) public onlyOwner {
1361         require(destination != address(0), "destination is zero address");
1362         destination.transfer(address(this).balance);
1363     }
1364 
1365     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1366 
1367         // approve token transfer to cover all possible scenarios
1368         _approve(address(this), address(uniswapV2Router), tokenAmount);
1369 
1370         // add the liquidity
1371         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1372             address(this),
1373             tokenAmount,
1374             0, // slippage is unavoidable
1375             0, // slippage is unavoidable
1376             address(0),
1377             block.timestamp
1378         );
1379 
1380     }
1381 }