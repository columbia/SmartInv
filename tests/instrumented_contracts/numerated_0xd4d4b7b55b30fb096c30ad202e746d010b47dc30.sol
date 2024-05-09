1 // https://twitter.com/AlphaBotCalls
2 
3 // https://t.me/AlphaBotCalls
4 
5 // https://alphabotcalls.com/
6 
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity ^ 0.8.7;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Emitted when `value` tokens are moved from one account (`from`) to
18      * another (`to`).
19      *
20      * Note that `value` may be zero.
21      */
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     /**
25      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
26      * a call to {approve}. `value` is the new allowance.
27      */
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `to`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address to, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `from` to `to` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address from,
85         address to,
86         uint256 amount
87     ) external returns (bool);
88 }
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations.
92  *
93  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
94  * now has built in overflow checking.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, with an overflow flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         unchecked {
104             uint256 c = a + b;
105             if (c < a) return (false, 0);
106             return (true, c);
107         }
108     }
109 
110     /**
111      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
112      *
113      * _Available since v3.4._
114      */
115     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
116         unchecked {
117             if (b > a) return (false, 0);
118             return (true, a - b);
119         }
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
124      *
125      * _Available since v3.4._
126      */
127     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
128         unchecked {
129             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130             // benefit is lost if 'b' is also tested.
131             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
132             if (a == 0) return (true, 0);
133             uint256 c = a * b;
134             if (c / a != b) return (false, 0);
135             return (true, c);
136         }
137     }
138 
139     /**
140      * @dev Returns the division of two unsigned integers, with a division by zero flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         unchecked {
146             if (b == 0) return (false, 0);
147             return (true, a / b);
148         }
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
153      *
154      * _Available since v3.4._
155      */
156     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
157         unchecked {
158             if (b == 0) return (false, 0);
159             return (true, a % b);
160         }
161     }
162 
163     /**
164      * @dev Returns the addition of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `+` operator.
168      *
169      * Requirements:
170      *
171      * - Addition cannot overflow.
172      */
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a + b;
175     }
176 
177     /**
178      * @dev Returns the subtraction of two unsigned integers, reverting on
179      * overflow (when the result is negative).
180      *
181      * Counterpart to Solidity's `-` operator.
182      *
183      * Requirements:
184      *
185      * - Subtraction cannot overflow.
186      */
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         return a - b;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         return a * b;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers, reverting on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator.
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return a / b;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * reverting when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a % b;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237      * overflow (when the result is negative).
238      *
239      * CAUTION: This function is deprecated because it requires allocating memory for the error
240      * message unnecessarily. For custom revert reasons use {trySub}.
241      *
242      * Counterpart to Solidity's `-` operator.
243      *
244      * Requirements:
245      *
246      * - Subtraction cannot overflow.
247      */
248     function sub(
249         uint256 a,
250         uint256 b,
251         string memory errorMessage
252     ) internal pure returns (uint256) {
253         unchecked {
254             require(b <= a, errorMessage);
255             return a - b;
256         }
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         unchecked {
277             require(b > 0, errorMessage);
278             return a / b;
279         }
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * reverting with custom message when dividing by zero.
285      *
286      * CAUTION: This function is deprecated because it requires allocating memory for the error
287      * message unnecessarily. For custom revert reasons use {tryMod}.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function mod(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         unchecked {
303             require(b > 0, errorMessage);
304             return a % b;
305         }
306     }
307 }
308 
309 /**
310  * @dev Interface for the optional metadata functions from the ERC20 standard.
311  *
312  * _Available since v4.1._
313  */
314 interface IERC20Metadata is IERC20 {
315     /**
316      * @dev Returns the name of the token.
317      */
318     function name() external view returns (string memory);
319 
320     /**
321      * @dev Returns the symbol of the token.
322      */
323     function symbol() external view returns (string memory);
324 
325     /**
326      * @dev Returns the decimals places of the token.
327      */
328     function decimals() external view returns (uint8);
329 }
330 
331 /**
332  * @dev Provides information about the current execution context, including the
333  * sender of the transaction and its data. While these are generally available
334  * via msg.sender and msg.data, they should not be accessed in such a direct
335  * manner, since when dealing with meta-transactions the account sending and
336  * paying for execution may not be the actual sender (as far as an application
337  * is concerned).
338  *
339  * This contract is only required for intermediate, library-like contracts.
340  */
341 abstract contract Context {
342     function _msgSender() internal view virtual returns (address) {
343         return msg.sender;
344     }
345 
346     function _msgData() internal view virtual returns (bytes calldata) {
347         return msg.data;
348     }
349 }
350 
351 /**
352  * @dev Contract module which provides a basic access control mechanism, where
353  * there is an account (an owner) that can be granted exclusive access to
354  * specific functions.
355  *
356  * By default, the owner account will be the one that deploys the contract. This
357  * can later be changed with {transferOwnership}.
358  *
359  * This module is used through inheritance. It will make available the modifier
360  * `onlyOwner`, which can be applied to your functions to restrict their use to
361  * the owner.
362  */
363 abstract contract Ownable is Context {
364     address private _owner;
365 
366     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
367 
368     /**
369      * @dev Initializes the contract setting the deployer as the initial owner.
370      */
371     constructor() {
372         _transferOwnership(_msgSender());
373     }
374 
375     /**
376      * @dev Returns the address of the current owner.
377      */
378     function owner() public view virtual returns (address) {
379         return _owner;
380     }
381 
382     /**
383      * @dev Throws if called by any account other than the owner.
384      */
385     modifier onlyOwner() {
386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
387         _;
388     }
389 
390     /**
391      * @dev Leaves the contract without owner. It will not be possible to call
392      * `onlyOwner` functions anymore. Can only be called by the current owner.
393      *
394      * NOTE: Renouncing ownership will leave the contract without an owner,
395      * thereby removing any functionality that is only available to the owner.
396      */
397     function renounceOwnership() public virtual onlyOwner {
398         _transferOwnership(address(0));
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Can only be called by the current owner.
404      */
405     function transferOwnership(address newOwner) public virtual onlyOwner {
406         require(newOwner != address(0), "Ownable: new owner is the zero address");
407         _transferOwnership(newOwner);
408     }
409 
410     /**
411      * @dev Transfers ownership of the contract to a new account (`newOwner`).
412      * Internal function without access restriction.
413      */
414     function _transferOwnership(address newOwner) internal virtual {
415         address oldOwner = _owner;
416         _owner = newOwner;
417         emit OwnershipTransferred(oldOwner, newOwner);
418     }
419 }
420 
421 interface IUniswapV2Factory {
422     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
423 
424     function feeTo() external view returns (address);
425     function feeToSetter() external view returns (address);
426 
427     function getPair(address tokenA, address tokenB) external view returns (address pair);
428     function allPairs(uint) external view returns (address pair);
429     function allPairsLength() external view returns (uint);
430 
431     function createPair(address tokenA, address tokenB) external returns (address pair);
432 
433     function setFeeTo(address) external;
434     function setFeeToSetter(address) external;
435 }
436 
437 
438 interface IUniswapV2Router01 {
439     function factory() external pure returns (address);
440     function WETH() external pure returns (address);
441 
442     function addLiquidity(
443         address tokenA,
444         address tokenB,
445         uint amountADesired,
446         uint amountBDesired,
447         uint amountAMin,
448         uint amountBMin,
449         address to,
450         uint deadline
451     ) external returns (uint amountA, uint amountB, uint liquidity);
452     function addLiquidityETH(
453         address token,
454         uint amountTokenDesired,
455         uint amountTokenMin,
456         uint amountETHMin,
457         address to,
458         uint deadline
459     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
460     function removeLiquidity(
461         address tokenA,
462         address tokenB,
463         uint liquidity,
464         uint amountAMin,
465         uint amountBMin,
466         address to,
467         uint deadline
468     ) external returns (uint amountA, uint amountB);
469     function removeLiquidityETH(
470         address token,
471         uint liquidity,
472         uint amountTokenMin,
473         uint amountETHMin,
474         address to,
475         uint deadline
476     ) external returns (uint amountToken, uint amountETH);
477     function removeLiquidityWithPermit(
478         address tokenA,
479         address tokenB,
480         uint liquidity,
481         uint amountAMin,
482         uint amountBMin,
483         address to,
484         uint deadline,
485         bool approveMax, uint8 v, bytes32 r, bytes32 s
486     ) external returns (uint amountA, uint amountB);
487     function removeLiquidityETHWithPermit(
488         address token,
489         uint liquidity,
490         uint amountTokenMin,
491         uint amountETHMin,
492         address to,
493         uint deadline,
494         bool approveMax, uint8 v, bytes32 r, bytes32 s
495     ) external returns (uint amountToken, uint amountETH);
496     function swapExactTokensForTokens(
497         uint amountIn,
498         uint amountOutMin,
499         address[] calldata path,
500         address to,
501         uint deadline
502     ) external returns (uint[] memory amounts);
503     function swapTokensForExactTokens(
504         uint amountOut,
505         uint amountInMax,
506         address[] calldata path,
507         address to,
508         uint deadline
509     ) external returns (uint[] memory amounts);
510     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
511         external
512         payable
513         returns (uint[] memory amounts);
514     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
515         external
516         returns (uint[] memory amounts);
517     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
518         external
519         returns (uint[] memory amounts);
520     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
521         external
522         payable
523         returns (uint[] memory amounts);
524 
525     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
526     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
527     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
528     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
529     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
530 }
531 
532 interface IUniswapV2Router02 is IUniswapV2Router01 {
533     function removeLiquidityETHSupportingFeeOnTransferTokens(
534         address token,
535         uint liquidity,
536         uint amountTokenMin,
537         uint amountETHMin,
538         address to,
539         uint deadline
540     ) external returns (uint amountETH);
541     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
542         address token,
543         uint liquidity,
544         uint amountTokenMin,
545         uint amountETHMin,
546         address to,
547         uint deadline,
548         bool approveMax, uint8 v, bytes32 r, bytes32 s
549     ) external returns (uint amountETH);
550 
551     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
552         uint amountIn,
553         uint amountOutMin,
554         address[] calldata path,
555         address to,
556         uint deadline
557     ) external;
558     function swapExactETHForTokensSupportingFeeOnTransferTokens(
559         uint amountOutMin,
560         address[] calldata path,
561         address to,
562         uint deadline
563     ) external payable;
564     function swapExactTokensForETHSupportingFeeOnTransferTokens(
565         uint amountIn,
566         uint amountOutMin,
567         address[] calldata path,
568         address to,
569         uint deadline
570     ) external;
571 }
572 
573 /**
574  * @dev Implementation of the {IERC20} interface.
575  *
576  * This implementation is agnostic to the way tokens are created. This means
577  * that a supply mechanism has to be added in a derived contract using {_mint}.
578  * For a generic mechanism see {ERC20PresetMinterPauser}.
579  *
580  * TIP: For a detailed writeup see our guide
581  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
582  * to implement supply mechanisms].
583  *
584  * We have followed general OpenZeppelin Contracts guidelines: functions revert
585  * instead returning `false` on failure. This behavior is nonetheless
586  * conventional and does not conflict with the expectations of ERC20
587  * applications.
588  *
589  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
590  * This allows applications to reconstruct the allowance for all accounts just
591  * by listening to said events. Other implementations of the EIP may not emit
592  * these events, as it isn't required by the specification.
593  *
594  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
595  * functions have been added to mitigate the well-known issues around setting
596  * allowances. See {IERC20-approve}.
597  */
598 contract AlphaBotCalls is Context, Ownable, IERC20, IERC20Metadata {
599     using SafeMath for uint256;
600     mapping(address => uint256) private _balances;
601     mapping(address => mapping(address => uint256)) private _allowances;
602     uint256 private _totalSupply;
603     string private _name = "Alpha Bot Calls";
604     string private _symbol = "ABC";
605     address public devWallet = 0x664e2531f5c1AeCA86b7C65935431AbB06F29f71;
606     address public marketingWallet = 0x2aA830a48Cd78d5360139E790F808e46B9aAdC2b;
607     uint256 public devFee = 2;
608     uint256 public marketingFee = 1;
609     uint256 public liquidityFee = 1;
610     uint256 public totalFee;
611     mapping(address => bool) public exemptFromFee;
612     mapping(address => bool) public exemptFromMax;
613     address public uniswapPair;
614     IUniswapV2Router02 public uniswapRouter;
615     uint256 public swapThreshold;
616     uint256 public maxWalletAmount;
617     bool public enableAntiwhale = true;
618 
619     bool inSwap;
620     modifier swapping() {
621         inSwap = true;
622         _;
623         inSwap = false;
624     }
625 
626     /**
627      * @dev Sets the values for {name} and {symbol}.
628      *
629      * The default value of {decimals} is 18. To select a different value for
630      * {decimals} you should overload it.
631      *
632      * All two of these values are immutable: they can only be set once during
633      * construction.
634      */
635     constructor() {
636         uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
637         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(
638             uniswapRouter.WETH(),
639             address(this)
640         );
641         exemptFromFee[_msgSender()] = true;
642         exemptFromFee[devWallet] = true;
643         exemptFromFee[marketingWallet] = true;
644         exemptFromFee[address(this)] = true;
645 
646         exemptFromMax[_msgSender()] = true;
647         exemptFromMax[devWallet] = true;
648         exemptFromMax[marketingWallet] = true;
649         exemptFromMax[uniswapPair] = true;
650         exemptFromMax[address(this)] = true;
651 
652         _mint(_msgSender(), 1 * 10 ** 6 * 10 ** decimals());
653         swapThreshold = _totalSupply.mul(5).div(10000);
654         maxWalletAmount = _totalSupply.mul(1).div(100);
655         totalFee = devFee.add(marketingFee).add(liquidityFee);
656     }
657 
658     receive() external payable {}
659 
660     /**
661      * @dev Returns the name of the token.
662      */
663     function name() external view virtual override returns (string memory) {
664         return _name;
665     }
666 
667     /**
668      * @dev Returns the symbol of the token, usually a shorter version of the
669      * name.
670      */
671     function symbol() external view virtual override returns (string memory) {
672         return _symbol;
673     }
674 
675     /**
676      * @dev Returns the number of decimals used to get its user representation.
677      * For example, if `decimals` equals `2`, a balance of `505` tokens should
678      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
679      *
680      * Tokens usually opt for a value of 18, imitating the relationship between
681      * Ether and Wei. This is the value {ERC20} uses, unless this function is
682      * overridden;
683      *
684      * NOTE: This information is only used for _display_ purposes: it in
685      * no way affects any of the arithmetic of the contract, including
686      * {IERC20-balanceOf} and {IERC20-transfer}.
687      */
688     function decimals() public view virtual override returns (uint8) {
689         return 18;
690     }
691 
692     /**
693      * @dev See {IERC20-totalSupply}.
694      */
695     function totalSupply() external view virtual override returns (uint256) {
696         return _totalSupply;
697     }
698 
699     /**
700      * @dev See {IERC20-balanceOf}.
701      */
702     function balanceOf(address account) external view virtual override returns (uint256) {
703         return _balances[account];
704     }
705 
706     /**
707      * @dev See {IERC20-transfer}.
708      *
709      * Requirements:
710      *
711      * - `to` cannot be the zero address.
712      * - the caller must have a balance of at least `amount`.
713      */
714     function transfer(address to, uint256 amount) external virtual override returns (bool) {
715         address _owner = _msgSender();
716         _transfer(_owner, to, amount);
717         return true;
718     }
719 
720     /**
721      * @dev See {IERC20-allowance}.
722      */
723     function allowance(address _owner, address spender) public view virtual override returns (uint256) {
724         return _allowances[_owner][spender];
725     }
726 
727     /**
728      * @dev See {IERC20-approve}.
729      *
730      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
731      * `transferFrom`. This is semantically equivalent to an infinite approval.
732      *
733      * Requirements:
734      *
735      * - `spender` cannot be the zero address.
736      */
737     function approve(address spender, uint256 amount) external virtual override returns (bool) {
738         address _owner = _msgSender();
739         _approve(_owner, spender, amount);
740         return true;
741     }
742 
743     /**
744      * @dev See {IERC20-transferFrom}.
745      *
746      * Emits an {Approval} event indicating the updated allowance. This is not
747      * required by the EIP. See the note at the beginning of {ERC20}.
748      *
749      * NOTE: Does not update the allowance if the current allowance
750      * is the maximum `uint256`.
751      *
752      * Requirements:
753      *
754      * - `from` and `to` cannot be the zero address.
755      * - `from` must have a balance of at least `amount`.
756      * - the caller must have allowance for ``from``'s tokens of at least
757      * `amount`.
758      */
759     function transferFrom(
760         address from,
761         address to,
762         uint256 amount
763     ) external virtual override returns (bool) {
764         address spender = _msgSender();
765         _spendAllowance(from, spender, amount);
766         _transfer(from, to, amount);
767         return true;
768     }
769 
770     /**
771      * @dev Atomically increases the allowance granted to `spender` by the caller.
772      *
773      * This is an alternative to {approve} that can be used as a mitigation for
774      * problems described in {IERC20-approve}.
775      *
776      * Emits an {Approval} event indicating the updated allowance.
777      *
778      * Requirements:
779      *
780      * - `spender` cannot be the zero address.
781      */
782     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
783         address _owner = _msgSender();
784         _approve(_owner, spender, allowance(_owner, spender) + addedValue);
785         return true;
786     }
787 
788     /**
789      * @dev Atomically decreases the allowance granted to `spender` by the caller.
790      *
791      * This is an alternative to {approve} that can be used as a mitigation for
792      * problems described in {IERC20-approve}.
793      *
794      * Emits an {Approval} event indicating the updated allowance.
795      *
796      * Requirements:
797      *
798      * - `spender` cannot be the zero address.
799      * - `spender` must have allowance for the caller of at least
800      * `subtractedValue`.
801      */
802     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
803         address _owner = _msgSender();
804         uint256 currentAllowance = allowance(_owner, spender);
805         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
806         unchecked {
807             _approve(_owner, spender, currentAllowance - subtractedValue);
808         }
809 
810         return true;
811     }
812 
813     /**
814      * @dev Moves `amount` of tokens from `from` to `to`.
815      *
816      * This internal function is equivalent to {transfer}, and can be used to
817      * e.g. implement automatic token fees, slashing mechanisms, etc.
818      *
819      * Emits a {Transfer} event.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `from` must have a balance of at least `amount`.
826      */
827     function _transfer(
828         address from,
829         address to,
830         uint256 amount
831     ) internal virtual {
832         require(from != address(0), "ERC20: transfer from the zero address");
833         require(to != address(0), "ERC20: transfer to the zero address");
834 
835         if(
836             from != uniswapPair &&
837             _balances[address(this)] >= swapThreshold &&
838             !inSwap
839         ) {
840             processSwap(_balances[address(this)]);
841         }
842 
843 
844 
845         uint256 fromBalance = _balances[from];
846         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
847         uint256 amountAfterFee = takeFee(from, to, amount);
848         unchecked {
849             _balances[from] = fromBalance - amount;
850             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
851             // decrementing then incrementing.
852             _balances[to] += amountAfterFee;
853         }
854 
855         if(
856             !exemptFromMax[to] &&
857             enableAntiwhale
858         ) {
859             require(_balances[to] <= maxWalletAmount, "Anthiwhale: can not hold more than max wallet amount");
860         }
861 
862         emit Transfer(from, to, amountAfterFee);
863     }
864 
865     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
866      * the total supply.
867      *
868      * Emits a {Transfer} event with `from` set to the zero address.
869      *
870      * Requirements:
871      *
872      * - `account` cannot be the zero address.
873      */
874     function _mint(address account, uint256 amount) internal virtual {
875         require(account != address(0), "ERC20: mint to the zero address");
876         _totalSupply += amount;
877         unchecked {
878             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
879             _balances[account] += amount;
880         }
881         emit Transfer(address(0), account, amount);
882     }
883 
884     /**
885      * @dev Destroys `amount` tokens from `account`, reducing the
886      * total supply.
887      *
888      * Emits a {Transfer} event with `to` set to the zero address.
889      *
890      * Requirements:
891      *
892      * - `account` cannot be the zero address.
893      * - `account` must have at least `amount` tokens.
894      */
895     function _burn(address account, uint256 amount) internal virtual {
896         require(account != address(0), "ERC20: burn from the zero address");
897         uint256 accountBalance = _balances[account];
898         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
899         unchecked {
900             _balances[account] = accountBalance - amount;
901             // Overflow not possible: amount <= accountBalance <= totalSupply.
902             _totalSupply -= amount;
903         }
904 
905         emit Transfer(account, address(0), amount);
906     }
907 
908     /**
909      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
910      *
911      * This internal function is equivalent to `approve`, and can be used to
912      * e.g. set automatic allowances for certain subsystems, etc.
913      *
914      * Emits an {Approval} event.
915      *
916      * Requirements:
917      *
918      * - `owner` cannot be the zero address.
919      * - `spender` cannot be the zero address.
920      */
921     function _approve(
922         address _owner,
923         address spender,
924         uint256 amount
925     ) internal virtual {
926         require(_owner != address(0), "ERC20: approve from the zero address");
927         require(spender != address(0), "ERC20: approve to the zero address");
928 
929         _allowances[_owner][spender] = amount;
930         emit Approval(_owner, spender, amount);
931     }
932 
933     /**
934      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
935      *
936      * Does not update the allowance amount in case of infinite allowance.
937      * Revert if not enough allowance is available.
938      *
939      * Might emit an {Approval} event.
940      */
941     function _spendAllowance(
942         address _owner,
943         address spender,
944         uint256 amount
945     ) internal virtual {
946         uint256 currentAllowance = allowance(_owner, spender);
947         if (currentAllowance != type(uint256).max) {
948             require(currentAllowance >= amount, "ERC20: insufficient allowance");
949             unchecked {
950                 _approve(_owner, spender, currentAllowance - amount);
951             }
952         }
953     }
954 
955     event UpdateExemptFromFee(address indexed wallet, bool _exempt);
956     function updateExemptFromFee(
957         address wallet, 
958         bool _exempt
959     ) external onlyOwner {
960         exemptFromFee[wallet] = _exempt;
961         emit UpdateExemptFromFee(wallet, _exempt);
962     }
963 
964     event FeeUpdated(uint256 _devFee, uint256 _marketingFee, uint256 _liquidityFee);
965     function updateFees(
966         uint256 _devFee,
967         uint256 _marketingFee,
968         uint256 _liquidityFee
969     ) external onlyOwner {
970         devFee = _devFee;
971         marketingFee = _marketingFee;
972         liquidityFee = _liquidityFee;
973         totalFee = _devFee.add(_marketingFee).add(_liquidityFee);
974         require(totalFee <= 4, "Total fee can not exceeds 4");
975         emit FeeUpdated(_devFee, _marketingFee, _liquidityFee);
976     }
977 
978     event ThresholdUpdated(uint256 _newThreshold);
979     function updateSwapThreshold(
980         uint256 _newThreshold
981     ) external onlyOwner {
982         swapThreshold = _newThreshold;
983         emit ThresholdUpdated(_newThreshold);
984     }
985 
986     function takeFee(
987         address from,
988         address to,
989         uint256 amount
990     ) internal returns(uint256) {
991         if(!exemptFromFee[from] && !exemptFromFee[to]){
992             //taxable only during buy and sell and not during w2w tranfer
993             if(from == uniswapPair || to == uniswapPair) {
994                 uint256 _totalFee = amount.mul(totalFee).div(10**2);
995                 amount = amount.sub(_totalFee);
996 
997                 if(_totalFee != 0) {
998                     _balances[address(this)] = _balances[address(this)].add(_totalFee);
999                     emit Transfer(from, address(this), _totalFee);
1000                 }
1001             }
1002 
1003         }
1004 
1005         return amount;
1006     }
1007 
1008 
1009     event AutoLiquify(uint256 newBalance, uint256 otherHalf);
1010     function processSwap(uint256 tokenToSell) private swapping {
1011         uint256 _teamTokens = tokenToSell.mul(devFee.add(marketingFee)).div(totalFee);
1012         uint256 _tLiquidity = tokenToSell.mul(liquidityFee).div(totalFee);
1013         uint256 _tokenForLiquidity = _tLiquidity.div(2);
1014         uint256 _tTokenToSell = _teamTokens.add(_tokenForLiquidity);
1015 
1016         swapTokensForEth(_tTokenToSell);
1017 
1018         uint256 totalEth = address(this).balance;
1019 
1020         uint256 ethForDev = totalEth.mul(devFee).div(totalFee);
1021         uint256 ethForMarketing = totalEth.mul(marketingFee).div(totalFee);
1022         uint256 ethForLiquidity = totalEth.mul(liquidityFee).div(totalFee);
1023 
1024 
1025         if(ethForDev != 0) {
1026             (bool success, ) = payable(devWallet).call{value: ethForDev}("");
1027             require(success, "can not send fee to the dev wallet");
1028         } 
1029 
1030         if(ethForMarketing != 0) {
1031             (bool success, ) = payable(marketingWallet).call{value: ethForMarketing}("");
1032             require(success, "can not send fee to the marketing wallet");
1033         }
1034 
1035         addLiquidity(_tokenForLiquidity, ethForLiquidity);
1036 
1037         emit AutoLiquify(_tokenForLiquidity, ethForLiquidity);
1038 
1039     }
1040 
1041 
1042     function swapTokensForEth(uint256 tokenAmount) private {
1043         // generate the uniswap pair path of token -> weth
1044         address[] memory path = new address[](2);
1045         path[0] = address(this);
1046         path[1] = uniswapRouter.WETH();
1047         _approve(address(this), address(uniswapRouter), tokenAmount);
1048         // make the swap
1049         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1050             tokenAmount,
1051             0, // accept any amount of ETH
1052             path,
1053             address(this),
1054             block.timestamp
1055         );
1056     }
1057 
1058     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1059         if(ethAmount != 0) {
1060             _approve(address(this), address(uniswapRouter), tokenAmount);
1061 
1062             // add the liquidity
1063             uniswapRouter.addLiquidityETH{value: ethAmount}(
1064                 address(this),
1065                 tokenAmount,
1066                 0, // slippage is unavoidable
1067                 0, // slippage is unavoidable
1068                 devWallet,
1069                 block.timestamp
1070             );
1071         } 
1072     }
1073 
1074     event WalletsUpdated(address indexed _devWallet, address indexed _marketingWallet);
1075     function updateWallets(
1076         address _devWallet,
1077         address _marketingWallet
1078     ) external onlyOwner {
1079         require(_devWallet != address(0), "dev wallet can not be zero address");
1080         require(_marketingWallet != address(0), "marketing wallet can not be zero address");
1081         devWallet = _devWallet;
1082         marketingWallet = _marketingWallet;
1083         emit WalletsUpdated(_devWallet, _marketingWallet);
1084     }
1085 
1086     event MaxWalletAmount(uint256 _maxWalletAmount);
1087     function updateMaxWalletAmount(
1088         uint256 _maxWalletAmount
1089     ) external onlyOwner {
1090         maxWalletAmount = _maxWalletAmount;
1091         emit MaxWalletAmount(_maxWalletAmount);
1092     }
1093 
1094     event ExemptFromMax(address indexed _wallet, bool _exempt);
1095     function exemptFromMaxWallet(
1096         address _wallet,
1097         bool _exempt
1098     ) external onlyOwner {
1099         exemptFromMax[_wallet] = _exempt;
1100         emit ExemptFromMax(_wallet, _exempt);
1101     }
1102 
1103     event EnableAntiwhale(bool _enable);
1104     function enableAntiwhaleSystem(
1105         bool _enable 
1106     ) external onlyOwner {
1107         enableAntiwhale = _enable;
1108         emit EnableAntiwhale(_enable);
1109     }
1110 
1111 }