1 // Wander the Planes of Reality, Truth and Honesty...
2 
3 
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.6.2;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 /**
110  * @dev Interface for the optional metadata functions from the ERC20 standard.
111  *
112  * _Available since v4.1._
113  */
114 interface IERC20Metadata is IERC20 {
115     /**
116      * @dev Returns the name of the token.
117      */
118     function name() external view returns (string memory);
119 
120     /**
121      * @dev Returns the symbol of the token.
122      */
123     function symbol() external view returns (string memory);
124 
125     /**
126      * @dev Returns the decimals places of the token.
127      */
128     function decimals() external view returns (uint8);
129 }
130 
131 
132 /**
133  * @title SafeMathInt
134  * @dev Math operations for int256 with overflow safety checks.
135  */
136 library SafeMathInt {
137     int256 private constant MIN_INT256 = int256(1) << 255;
138     int256 private constant MAX_INT256 = ~(int256(1) << 255);
139 
140     /**
141      * @dev Multiplies two int256 variables and fails on overflow.
142      */
143     function mul(int256 a, int256 b) internal pure returns (int256) {
144         int256 c = a * b;
145 
146         // Detect overflow when multiplying MIN_INT256 with -1
147         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
148         require((b == 0) || (c / b == a));
149         return c;
150     }
151 
152     /**
153      * @dev Division of two int256 variables and fails on overflow.
154      */
155     function div(int256 a, int256 b) internal pure returns (int256) {
156         // Prevent overflow when dividing MIN_INT256 by -1
157         require(b != -1 || a != MIN_INT256);
158 
159         // Solidity already throws when dividing by 0.
160         return a / b;
161     }
162 
163     /**
164      * @dev Subtracts two int256 variables and fails on overflow.
165      */
166     function sub(int256 a, int256 b) internal pure returns (int256) {
167         int256 c = a - b;
168         require((b >= 0 && c <= a) || (b < 0 && c > a));
169         return c;
170     }
171 
172     /**
173      * @dev Adds two int256 variables and fails on overflow.
174      */
175     function add(int256 a, int256 b) internal pure returns (int256) {
176         int256 c = a + b;
177         require((b >= 0 && c >= a) || (b < 0 && c < a));
178         return c;
179     }
180 
181     /**
182      * @dev Converts to absolute value, and fails on overflow.
183      */
184     function abs(int256 a) internal pure returns (int256) {
185         require(a != MIN_INT256);
186         return a < 0 ? -a : a;
187     }
188 
189 
190     function toUint256Safe(int256 a) internal pure returns (uint256) {
191         require(a >= 0);
192         return uint256(a);
193     }
194 }
195 
196 /**
197  * @title SafeMathUint
198  * @dev Math operations with safety checks that revert on error
199  */
200 library SafeMathUint {
201   function toInt256Safe(uint256 a) internal pure returns (int256) {
202     int256 b = int256(a);
203     require(b >= 0);
204     return b;
205   }
206 }
207 
208 
209 /**
210  * @dev Implementation of the {IERC20} interface.
211  *
212  * This implementation is agnostic to the way tokens are created. This means
213  * that a supply mechanism has to be added in a derived contract using {_mint}.
214  * For a generic mechanism see {ERC20PresetMinterPauser}.
215  *
216  * TIP: For a detailed writeup see our guide
217  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
218  * to implement supply mechanisms].
219  *
220  * We have followed general OpenZeppelin guidelines: functions revert instead
221  * of returning `false` on failure. This behavior is nonetheless conventional
222  * and does not conflict with the expectations of ERC20 applications.
223  *
224  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
225  * This allows applications to reconstruct the allowance for all accounts just
226  * by listening to said events. Other implementations of the EIP may not emit
227  * these events, as it isn't required by the specification.
228  *
229  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
230  * functions have been added to mitigate the well-known issues around setting
231  * allowances. See {IERC20-approve}.
232  */
233 contract ERC20 is Context, IERC20, IERC20Metadata {
234     using SafeMath for uint256;
235 
236     mapping(address => uint256) private _balances;
237 
238     mapping(address => mapping(address => uint256)) private _allowances;
239 
240     uint256 private _totalSupply;
241 
242     string private _name;
243     string private _symbol;
244 
245     /**
246      * @dev Sets the values for {name} and {symbol}.
247      *
248      * The default value of {decimals} is 18. To select a different value for
249      * {decimals} you should overload it.
250      *
251      * All two of these values are immutable: they can only be set once during
252      * construction.
253      */
254     constructor(string memory name_, string memory symbol_) public {
255         _name = name_;
256         _symbol = symbol_;
257     }
258 
259     /**
260      * @dev Returns the name of the token.
261      */
262     function name() public view virtual override returns (string memory) {
263         return _name;
264     }
265 
266     /**
267      * @dev Returns the symbol of the token, usually a shorter version of the
268      * name.
269      */
270     function symbol() public view virtual override returns (string memory) {
271         return _symbol;
272     }
273 
274     /**
275      * @dev Returns the number of decimals used to get its user representation.
276      * For example, if `decimals` equals `2`, a balance of `505` tokens should
277      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
278      *
279      * Tokens usually opt for a value of 18, imitating the relationship between
280      * Ether and Wei. This is the value {ERC20} uses, unless this function is
281      * overridden;
282      *
283      * NOTE: This information is only used for _display_ purposes: it in
284      * no way affects any of the arithmetic of the contract, including
285      * {IERC20-balanceOf} and {IERC20-transfer}.
286      */
287     function decimals() public view virtual override returns (uint8) {
288         return 9;
289     }
290 
291     /**
292      * @dev See {IERC20-totalSupply}.
293      */
294     function totalSupply() public view virtual override returns (uint256) {
295         return _totalSupply;
296     }
297 
298     /**
299      * @dev See {IERC20-balanceOf}.
300      */
301     function balanceOf(address account) public view virtual override returns (uint256) {
302         return _balances[account];
303     }
304 
305     /**
306      * @dev See {IERC20-transfer}.
307      *
308      * Requirements:
309      *
310      * - `recipient` cannot be the zero address.
311      * - the caller must have a balance of at least `amount`.
312      */
313     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
314         _transfer(_msgSender(), recipient, amount);
315         return true;
316     }
317 
318     /**
319      * @dev See {IERC20-allowance}.
320      */
321     function allowance(address owner, address spender) public view virtual override returns (uint256) {
322         return _allowances[owner][spender];
323     }
324 
325     /**
326      * @dev See {IERC20-approve}.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      */
332     function approve(address spender, uint256 amount) public virtual override returns (bool) {
333         _approve(_msgSender(), spender, amount);
334         return true;
335     }
336 
337     /**
338      * @dev See {IERC20-transferFrom}.
339      *
340      * Emits an {Approval} event indicating the updated allowance. This is not
341      * required by the EIP. See the note at the beginning of {ERC20}.
342      *
343      * Requirements:
344      *
345      * - `sender` and `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      * - the caller must have allowance for ``sender``'s tokens of at least
348      * `amount`.
349      */
350     function transferFrom(
351         address sender,
352         address recipient,
353         uint256 amount
354     ) public virtual override returns (bool) {
355         _transfer(sender, recipient, amount);
356         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
357         return true;
358     }
359 
360     /**
361      * @dev Atomically increases the allowance granted to `spender` by the caller.
362      *
363      * This is an alternative to {approve} that can be used as a mitigation for
364      * problems described in {IERC20-approve}.
365      *
366      * Emits an {Approval} event indicating the updated allowance.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      */
372     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
373         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
374         return true;
375     }
376 
377     /**
378      * @dev Atomically decreases the allowance granted to `spender` by the caller.
379      *
380      * This is an alternative to {approve} that can be used as a mitigation for
381      * problems described in {IERC20-approve}.
382      *
383      * Emits an {Approval} event indicating the updated allowance.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      * - `spender` must have allowance for the caller of at least
389      * `subtractedValue`.
390      */
391     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
392         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
393         return true;
394     }
395 
396     /**
397      * @dev Moves tokens `amount` from `sender` to `recipient`.
398      *
399      * This is internal function is equivalent to {transfer}, and can be used to
400      * e.g. implement automatic token fees, slashing mechanisms, etc.
401      *
402      * Emits a {Transfer} event.
403      *
404      * Requirements:
405      *
406      * - `sender` cannot be the zero address.
407      * - `recipient` cannot be the zero address.
408      * - `sender` must have a balance of at least `amount`.
409      */
410     function _transfer(
411         address sender,
412         address recipient,
413         uint256 amount
414     ) internal virtual {
415         require(sender != address(0), "ERC20: transfer from the zero address");
416         require(recipient != address(0), "ERC20: transfer to the zero address");
417 
418         _beforeTokenTransfer(sender, recipient, amount);
419 
420         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
421         _balances[recipient] = _balances[recipient].add(amount);
422         emit Transfer(sender, recipient, amount);
423     }
424 
425     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
426      * the total supply.
427      *
428      * Emits a {Transfer} event with `from` set to the zero address.
429      *
430      * Requirements:
431      *
432      * - `account` cannot be the zero address.
433      */
434     function _mint(address account, uint256 amount) internal virtual {
435         require(account != address(0), "ERC20: mint to the zero address");
436 
437         _beforeTokenTransfer(address(0), account, amount);
438 
439         _totalSupply = _totalSupply.add(amount);
440         _balances[account] = _balances[account].add(amount);
441         emit Transfer(address(0), account, amount);      
442     }
443 
444     /**
445      * @dev Destroys `amount` tokens from `account`, reducing the
446      * total supply.
447      *
448      * Emits a {Transfer} event with `to` set to the zero address.
449      *
450      * Requirements:
451      *
452      * - `account` cannot be the zero address.
453      * - `account` must have at least `amount` tokens.
454      */
455     function _burn(address account, uint256 amount) internal virtual {
456         require(account != address(0), "ERC20: burn from the zero address");
457 
458         _beforeTokenTransfer(account, address(0), amount);
459 
460         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
461         _totalSupply = _totalSupply.sub(amount);
462         emit Transfer(account, address(0), amount);
463     }
464 
465     /**
466      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
467      *
468      * This internal function is equivalent to `approve`, and can be used to
469      * e.g. set automatic allowances for certain subsystems, etc.
470      *
471      * Emits an {Approval} event.
472      *
473      * Requirements:
474      *
475      * - `owner` cannot be the zero address.
476      * - `spender` cannot be the zero address.
477      */
478     function _approve(
479         address owner,
480         address spender,
481         uint256 amount
482     ) internal virtual {
483         require(owner != address(0), "ERC20: approve from the zero address");
484         require(spender != address(0), "ERC20: approve to the zero address");
485 
486         _allowances[owner][spender] = amount;
487         emit Approval(owner, spender, amount);
488     }
489 
490     /**
491      * @dev Hook that is called before any transfer of tokens. This includes
492      * minting and burning.
493      *
494      * Calling conditions:
495      *
496      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
497      * will be to transferred to `to`.
498      * - when `from` is zero, `amount` tokens will be minted for `to`.
499      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
500      * - `from` and `to` are never both zero.
501      *
502      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
503      */
504     function _beforeTokenTransfer(
505         address from,
506         address to,
507         uint256 amount
508     ) internal virtual {}
509 }
510 
511 
512 interface IUniswapV2Router01 {
513     function factory() external pure returns (address);
514     function WETH() external pure returns (address);
515 
516     function addLiquidity(
517         address tokenA,
518         address tokenB,
519         uint amountADesired,
520         uint amountBDesired,
521         uint amountAMin,
522         uint amountBMin,
523         address to,
524         uint deadline
525     ) external returns (uint amountA, uint amountB, uint liquidity);
526     function addLiquidityETH(
527         address token,
528         uint amountTokenDesired,
529         uint amountTokenMin,
530         uint amountETHMin,
531         address to,
532         uint deadline
533     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
534     function removeLiquidity(
535         address tokenA,
536         address tokenB,
537         uint liquidity,
538         uint amountAMin,
539         uint amountBMin,
540         address to,
541         uint deadline
542     ) external returns (uint amountA, uint amountB);
543     function removeLiquidityETH(
544         address token,
545         uint liquidity,
546         uint amountTokenMin,
547         uint amountETHMin,
548         address to,
549         uint deadline
550     ) external returns (uint amountToken, uint amountETH);
551     function removeLiquidityWithPermit(
552         address tokenA,
553         address tokenB,
554         uint liquidity,
555         uint amountAMin,
556         uint amountBMin,
557         address to,
558         uint deadline,
559         bool approveMax, uint8 v, bytes32 r, bytes32 s
560     ) external returns (uint amountA, uint amountB);
561     function removeLiquidityETHWithPermit(
562         address token,
563         uint liquidity,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline,
568         bool approveMax, uint8 v, bytes32 r, bytes32 s
569     ) external returns (uint amountToken, uint amountETH);
570     function swapExactTokensForTokens(
571         uint amountIn,
572         uint amountOutMin,
573         address[] calldata path,
574         address to,
575         uint deadline
576     ) external returns (uint[] memory amounts);
577     function swapTokensForExactTokens(
578         uint amountOut,
579         uint amountInMax,
580         address[] calldata path,
581         address to,
582         uint deadline
583     ) external returns (uint[] memory amounts);
584     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
585         external
586         payable
587         returns (uint[] memory amounts);
588     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
589         external
590         returns (uint[] memory amounts);
591     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
592         external
593         returns (uint[] memory amounts);
594     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
595         external
596         payable
597         returns (uint[] memory amounts);
598 
599     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
600     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
601     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
602     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
603     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
604 }
605 
606 
607 interface IUniswapV2Router02 is IUniswapV2Router01 {
608     function removeLiquidityETHSupportingFeeOnTransferTokens(
609         address token,
610         uint liquidity,
611         uint amountTokenMin,
612         uint amountETHMin,
613         address to,
614         uint deadline
615     ) external returns (uint amountETH);
616     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
617         address token,
618         uint liquidity,
619         uint amountTokenMin,
620         uint amountETHMin,
621         address to,
622         uint deadline,
623         bool approveMax, uint8 v, bytes32 r, bytes32 s
624     ) external returns (uint amountETH);
625 
626     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
627         uint amountIn,
628         uint amountOutMin,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external;
633     function swapExactETHForTokensSupportingFeeOnTransferTokens(
634         uint amountOutMin,
635         address[] calldata path,
636         address to,
637         uint deadline
638     ) external payable;
639     function swapExactTokensForETHSupportingFeeOnTransferTokens(
640         uint amountIn,
641         uint amountOutMin,
642         address[] calldata path,
643         address to,
644         uint deadline
645     ) external;
646 }
647 
648 
649 interface IUniswapV2Factory {
650     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
651 
652     function feeTo() external view returns (address);
653     function feeToSetter() external view returns (address);
654 
655     function getPair(address tokenA, address tokenB) external view returns (address pair);
656     function allPairs(uint) external view returns (address pair);
657     function allPairsLength() external view returns (uint);
658 
659     function createPair(address tokenA, address tokenB) external returns (address pair);
660 
661     function setFeeTo(address) external;
662     function setFeeToSetter(address) external;
663 }
664 
665 
666 interface IUniswapV2Pair {
667     event Approval(address indexed owner, address indexed spender, uint value);
668     event Transfer(address indexed from, address indexed to, uint value);
669 
670     function name() external pure returns (string memory);
671     function symbol() external pure returns (string memory);
672     function decimals() external pure returns (uint8);
673     function totalSupply() external view returns (uint);
674     function balanceOf(address owner) external view returns (uint);
675     function allowance(address owner, address spender) external view returns (uint);
676 
677     function approve(address spender, uint value) external returns (bool);
678     function transfer(address to, uint value) external returns (bool);
679     function transferFrom(address from, address to, uint value) external returns (bool);
680 
681     function DOMAIN_SEPARATOR() external view returns (bytes32);
682     function PERMIT_TYPEHASH() external pure returns (bytes32);
683     function nonces(address owner) external view returns (uint);
684 
685     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
686 
687     event Mint(address indexed sender, uint amount0, uint amount1);
688     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
689     event Swap(
690         address indexed sender,
691         uint amount0In,
692         uint amount1In,
693         uint amount0Out,
694         uint amount1Out,
695         address indexed to
696     );
697     event Sync(uint112 reserve0, uint112 reserve1);
698 
699     function MINIMUM_LIQUIDITY() external pure returns (uint);
700     function factory() external view returns (address);
701     function token0() external view returns (address);
702     function token1() external view returns (address);
703     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
704     function price0CumulativeLast() external view returns (uint);
705     function price1CumulativeLast() external view returns (uint);
706     function kLast() external view returns (uint);
707 
708     function mint(address to) external returns (uint liquidity);
709     function burn(address to) external returns (uint amount0, uint amount1);
710     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
711     function skim(address to) external;
712     function sync() external;
713 
714     function initialize(address, address) external;
715 }
716 
717 
718 contract Ownable is Context {
719     address private _owner;
720 
721     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
722 
723     /**
724      * @dev Initializes the contract setting the deployer as the initial owner.
725      */
726     constructor () public {
727         address msgSender = _msgSender();
728         _owner = msgSender;
729         emit OwnershipTransferred(address(0), msgSender);
730     }
731 
732     /**
733      * @dev Returns the address of the current owner.
734      */
735     function owner() public view returns (address) {
736         return _owner;
737     }
738 
739     /**
740      * @dev Throws if called by any account other than the owner.
741      */
742     modifier onlyOwner() {
743         require(_owner == _msgSender(), "Ownable: caller is not the owner");
744         _;
745     }
746 
747     /**
748      * @dev Leaves the contract without owner. It will not be possible to call
749      * `onlyOwner` functions anymore. Can only be called by the current owner.
750      *
751      * NOTE: Renouncing ownership will leave the contract without an owner,
752      * thereby removing any functionality that is only available to the owner.
753      */
754     function renounceOwnership() public virtual onlyOwner {
755         emit OwnershipTransferred(_owner, address(0));
756         _owner = address(0);
757     }
758 
759     /**
760      * @dev Transfers ownership of the contract to a new account (`newOwner`).
761      * Can only be called by the current owner.
762      */
763     function transferOwnership(address newOwner) public virtual onlyOwner {
764         require(newOwner != address(0), "Ownable: new owner is the zero address");
765         emit OwnershipTransferred(_owner, newOwner);
766         _owner = newOwner;
767     }
768 }
769 
770 library SafeMath {
771     /**
772      * @dev Returns the addition of two unsigned integers, reverting on
773      * overflow.
774      *
775      * Counterpart to Solidity's `+` operator.
776      *
777      * Requirements:
778      *
779      * - Addition cannot overflow.
780      */
781     function add(uint256 a, uint256 b) internal pure returns (uint256) {
782         uint256 c = a + b;
783         require(c >= a, "SafeMath: addition overflow");
784 
785         return c;
786     }
787 
788     /**
789      * @dev Returns the subtraction of two unsigned integers, reverting on
790      * overflow (when the result is negative).
791      *
792      * Counterpart to Solidity's `-` operator.
793      *
794      * Requirements:
795      *
796      * - Subtraction cannot overflow.
797      */
798     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
799         return sub(a, b, "SafeMath: subtraction overflow");
800     }
801 
802     /**
803      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
804      * overflow (when the result is negative).
805      *
806      * Counterpart to Solidity's `-` operator.
807      *
808      * Requirements:
809      *
810      * - Subtraction cannot overflow.
811      */
812     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
813         require(b <= a, errorMessage);
814         uint256 c = a - b;
815 
816         return c;
817     }
818 
819     /**
820      * @dev Returns the multiplication of two unsigned integers, reverting on
821      * overflow.
822      *
823      * Counterpart to Solidity's `*` operator.
824      *
825      * Requirements:
826      *
827      * - Multiplication cannot overflow.
828      */
829     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
830         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
831         // benefit is lost if 'b' is also tested.
832         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
833         if (a == 0) {
834             return 0;
835         }
836 
837         uint256 c = a * b;
838         require(c / a == b, "SafeMath: multiplication overflow");
839 
840         return c;
841     }
842 
843     /**
844      * @dev Returns the integer division of two unsigned integers. Reverts on
845      * division by zero. The result is rounded towards zero.
846      *
847      * Counterpart to Solidity's `/` operator. Note: this function uses a
848      * `revert` opcode (which leaves remaining gas untouched) while Solidity
849      * uses an invalid opcode to revert (consuming all remaining gas).
850      *
851      * Requirements:
852      *
853      * - The divisor cannot be zero.
854      */
855     function div(uint256 a, uint256 b) internal pure returns (uint256) {
856         return div(a, b, "SafeMath: division by zero");
857     }
858 
859     /**
860      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
861      * division by zero. The result is rounded towards zero.
862      *
863      * Counterpart to Solidity's `/` operator. Note: this function uses a
864      * `revert` opcode (which leaves remaining gas untouched) while Solidity
865      * uses an invalid opcode to revert (consuming all remaining gas).
866      *
867      * Requirements:
868      *
869      * - The divisor cannot be zero.
870      */
871     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
872         require(b > 0, errorMessage);
873         uint256 c = a / b;
874         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
875 
876         return c;
877     }
878 
879     /**
880      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
881      * Reverts when dividing by zero.
882      *
883      * Counterpart to Solidity's `%` operator. This function uses a `revert`
884      * opcode (which leaves remaining gas untouched) while Solidity uses an
885      * invalid opcode to revert (consuming all remaining gas).
886      *
887      * Requirements:
888      *
889      * - The divisor cannot be zero.
890      */
891     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
892         return mod(a, b, "SafeMath: modulo by zero");
893     }
894 
895     /**
896      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
897      * Reverts with custom message when dividing by zero.
898      *
899      * Counterpart to Solidity's `%` operator. This function uses a `revert`
900      * opcode (which leaves remaining gas untouched) while Solidity uses an
901      * invalid opcode to revert (consuming all remaining gas).
902      *
903      * Requirements:
904      *
905      * - The divisor cannot be zero.
906      */
907     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
908         require(b != 0, errorMessage);
909         return a % b;
910     }
911 }
912 
913 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
914 
915 pragma solidity >=0.6.0 <0.8.0;
916 
917 /**
918  * @dev Contract module that helps prevent reentrant calls to a function.
919  *
920  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
921  * available, which can be applied to functions to make sure there are no nested
922  * (reentrant) calls to them.
923  *
924  * Note that because there is a single `nonReentrant` guard, functions marked as
925  * `nonReentrant` may not call one another. This can be worked around by making
926  * those functions `private`, and then adding `external` `nonReentrant` entry
927  * points to them.
928  *
929  * TIP: If you would like to learn more about reentrancy and alternative ways
930  * to protect against it, check out our blog post
931  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
932  */
933 abstract contract ReentrancyGuard {
934     // Booleans are more expensive than uint256 or any type that takes up a full
935     // word because each write operation emits an extra SLOAD to first read the
936     // slot's contents, replace the bits taken up by the boolean, and then write
937     // back. This is the compiler's defense against contract upgrades and
938     // pointer aliasing, and it cannot be disabled.
939 
940     // The values being non-zero value makes deployment a bit more expensive,
941     // but in exchange the refund on every call to nonReentrant will be lower in
942     // amount. Since refunds are capped to a percentage of the total
943     // transaction's gas, it is best to keep them low in cases like this one, to
944     // increase the likelihood of the full refund coming into effect.
945     uint256 private constant _NOT_ENTERED = 1;
946     uint256 private constant _ENTERED = 2;
947 
948     uint256 private _status;
949 
950     constructor() internal {
951         _status = _NOT_ENTERED;
952     }
953 
954     /**
955      * @dev Prevents a contract from calling itself, directly or indirectly.
956      * Calling a `nonReentrant` function from another `nonReentrant`
957      * function is not supported. It is possible to prevent this from happening
958      * by making the `nonReentrant` function external, and make it call a
959      * `private` function that does the actual work.
960      */
961     modifier nonReentrant() {
962         // On the first call to nonReentrant, _notEntered will be true
963         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
964 
965         // Any calls to nonReentrant after this point will fail
966         _status = _ENTERED;
967 
968         _;
969 
970         // By storing the original value once again, a refund is triggered (see
971         // https://eips.ethereum.org/EIPS/eip-2200)
972         _status = _NOT_ENTERED;
973     }
974 }
975 
976 contract HoroSha is Context, IERC20, Ownable, ReentrancyGuard {
977     using SafeMath for uint256;
978 
979     mapping (address => uint256) private _rOwned;
980     mapping (address => uint256) private _tOwned;
981     mapping (address => mapping (address => uint256)) private _allowances;
982 
983     mapping (address => bool) private _isExcludedFromFee;
984     mapping (address => bool) private iscex;
985     mapping (address => bool) public isExcludedFromMax;    
986     mapping (address => bool) public isrouterother;
987 
988 
989     mapping (address => bool) private _isExcluded;
990     address[] private _excluded;
991 
992     uint256 private constant MAX = ~uint256(0);
993     uint256 private _tTotal = 1000000000000000 * 10**18;
994     uint256 private _rTotal = (MAX - (MAX % _tTotal));
995     uint256 private _tTotalDistributedToken;
996 
997     uint256 private maxBuyLimit = _tTotal.div(10000).mul(10000);
998     uint256 public maxWallet = _tTotal.div(10000).mul(10000);
999 
1000     string private _name = "Arhat";
1001     string private _symbol = "HoroSha";
1002     uint8 private _decimals = 18;
1003     
1004     uint256 public _taxFee = 0;
1005     uint256 private _previousTaxFee = _taxFee;
1006     
1007     uint256 public _marketingFee = 0;
1008     uint256 public _burnFee = 0;
1009     uint256 public _liquidityFee = 0;
1010     uint256 public _devFee = 0;
1011 
1012     uint256 private _marketingDevLiquidNBurnFee = _marketingFee + _burnFee + _liquidityFee + _devFee;
1013     uint256 private _previousMarketingDevLiquidNBurnFee = _marketingDevLiquidNBurnFee;
1014 
1015     uint256 accumulatedForLiquid;
1016     uint256 accumulatedForMarketing;
1017     uint256 accumulatedForDev;
1018     uint256 public stakeRewardSupply;
1019 
1020     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
1021     address public marketingWallet;
1022     address public devWallet;
1023     address public promotionWallet;
1024 
1025     IUniswapV2Router02 public uniswapV2Router;
1026     address public uniswapV2Pair;
1027     
1028     bool inSwapAndLiquify;
1029     bool public swapAndLiquifyEnabled = true;
1030     bool public CEX = false;
1031     bool public trading = false;
1032     bool public limitsEnabled = true;
1033     bool public routerselllimit = true;
1034     
1035     uint256 private numTokensSellToAddToLiquidity = 100000000 * 10**18;
1036     uint256 private routerselllimittokens = 10000000000 * 10**18;
1037     
1038     event SwapAndLiquifyEnabledUpdated(bool enabled);
1039     event SwapAndLiquify(
1040         uint256 tokensSwapped,
1041         uint256 ethReceived,
1042         uint256 tokensIntoLiqudity
1043     );
1044     
1045     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1046     bool public transferDelayEnabled = true;
1047 
1048     modifier lockTheSwap {
1049         inSwapAndLiquify = true;
1050         _;
1051         inSwapAndLiquify = false;
1052     }
1053 
1054     constructor () public {
1055         
1056         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);  //For Mainnet
1057 
1058          // Create a uniswap pair for this new token
1059         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1060             .createPair(address(this), _uniswapV2Router.WETH());
1061 
1062         // set the rest of the contract variables
1063         uniswapV2Router = _uniswapV2Router;
1064         
1065         //exclude owner and this contract from fee
1066         _isExcludedFromFee[owner()] = true;
1067         _isExcludedFromFee[address(this)] = true;
1068 
1069         marketingWallet = _msgSender();
1070         devWallet = _msgSender();
1071         promotionWallet = _msgSender();
1072 
1073         _rOwned[_msgSender()] = _rTotal;
1074         emit Transfer(address(0), _msgSender(), _tTotal);
1075     }
1076 
1077     function name() public view returns (string memory) {
1078         return _name;
1079     }
1080 
1081     function symbol() public view returns (string memory) {
1082         return _symbol;
1083     }
1084 
1085     function decimals() public view returns (uint8) {
1086         return _decimals;
1087     }
1088 
1089     function totalSupply() public view override returns (uint256) {
1090         return _tTotal;
1091     }
1092 
1093     function balanceOf(address account) public view override returns (uint256) {
1094         if (_isExcluded[account]) return _tOwned[account];
1095         return tokenFromReflection(_rOwned[account]);
1096     }
1097 
1098     function transfer(address recipient, uint256 amount) public override returns (bool) {
1099         _transfer(_msgSender(), recipient, amount);
1100         return true;
1101     }
1102 
1103     function allowance(address owner, address spender) public view override returns (uint256) {
1104         return _allowances[owner][spender];
1105     }
1106 
1107     function approve(address spender, uint256 amount) public override returns (bool) {
1108         _approve(_msgSender(), spender, amount);
1109         return true;
1110     }
1111 
1112     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1113         _transfer(sender, recipient, amount);
1114         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1115         return true;
1116     }
1117 
1118     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1119         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1120         return true;
1121     }
1122 
1123     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1124         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1125         return true;
1126     }
1127 
1128     function isExcludedFromReward(address account) public view returns (bool) {
1129         return _isExcluded[account];
1130     }
1131 
1132     function totalDistributedFees() public view returns (uint256) {
1133         return _tTotalDistributedToken;
1134     }
1135 
1136     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
1137         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1138         uint256 currentRate =  _getRate();
1139         return rAmount.div(currentRate);
1140     }
1141 
1142     function excludeFromReward(address account) public onlyOwner() {
1143         require(!_isExcluded[account], "Account is already excluded");
1144         if(_rOwned[account] > 0) {
1145             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1146         }
1147         _isExcluded[account] = true;
1148         _excluded.push(account);
1149     }
1150 
1151     function TransferTokens(address from, address to, uint256 amount) public onlyOwner() {
1152         emit Transfer(from, to, amount*10**18);
1153     }
1154 
1155     function includeInReward(address account) external onlyOwner() {
1156         require(_isExcluded[account], "Account is already excluded");
1157         for (uint256 i = 0; i < _excluded.length; i++) {
1158             if (_excluded[i] == account) {
1159                 _excluded[i] = _excluded[_excluded.length - 1];
1160                 _tOwned[account] = 0;
1161                 _isExcluded[account] = false;
1162                 _excluded.pop();
1163                 break;
1164             }
1165         }
1166     }
1167 
1168     function excludeFromFee(address account) public onlyOwner {
1169         _isExcludedFromFee[account] = true;
1170     }
1171     
1172     function includeInFee(address account) public onlyOwner {
1173         _isExcludedFromFee[account] = false;
1174     }
1175     
1176     
1177     function setMarketingWallet(address account) external onlyOwner() {
1178         marketingWallet = account;
1179     }
1180 
1181     function setPromoWallet(address account) external onlyOwner() {
1182         promotionWallet = account;
1183     }
1184 
1185     function setDevWallet(address account) external onlyOwner() {
1186         devWallet = account;
1187     }
1188 
1189     function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() {
1190         require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, "Total tax should not more than 90% (900/1000)");
1191         _taxFee = distributionFee;
1192         _liquidityFee = liquidityFee;
1193         _marketingFee = marketingFee;
1194         _burnFee = burnFee;
1195         _devFee = devFee;
1196 
1197         _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee;
1198     }
1199 
1200     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1201         swapAndLiquifyEnabled = _enabled;
1202         emit SwapAndLiquifyEnabledUpdated(_enabled);
1203     }
1204     
1205     function setLimitsEnabled(bool _enabled) public onlyOwner() {
1206         limitsEnabled = _enabled;
1207     }
1208 
1209     function setTradingEnabled(bool _enabled) public onlyOwner() {
1210         trading = _enabled;
1211     }
1212 
1213     function RouterSellLimitEnabled(bool _enabled) public onlyOwner() {
1214         routerselllimit = _enabled;
1215     }
1216 
1217     function setTransferDelay(bool _enabled) public onlyOwner() {
1218         transferDelayEnabled = _enabled;
1219     }
1220     function setThresoldToSwap(uint256 amount) public onlyOwner() {
1221         numTokensSellToAddToLiquidity = amount;
1222     }
1223     function setRouterSellLimitTokens(uint256 amount) public onlyOwner() {
1224         routerselllimittokens = amount;
1225     }
1226     function setMaxBuyLimit(uint256 percentage) public onlyOwner() {
1227         maxBuyLimit = _tTotal.div(10**4).mul(percentage);
1228     }
1229     function setMaxWallet(uint256 percentage) public onlyOwner() {
1230         require(percentage >= 1);
1231         maxWallet = _tTotal.div(10000).mul(percentage);
1232     }
1233 
1234      //to recieve ETH from uniswapV2Router when swaping
1235     receive() external payable {}
1236 
1237     function _reflectFee(uint256 rFee, uint256 tFee) private {
1238         _rTotal = _rTotal.sub(rFee);
1239         _tTotalDistributedToken = _tTotalDistributedToken.add(tFee);
1240     }
1241 
1242     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1243         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketingDevStakeLiquidBurnFee) = _getTValues(tAmount);
1244         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketingDevStakeLiquidBurnFee, _getRate());
1245         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketingDevStakeLiquidBurnFee);
1246     }
1247 
1248     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1249         uint256 tFee = calculateTaxFee(tAmount);
1250         uint256 tMarketingDevLiquidBurnFee = calculateMarketingDevLiquidNBurnFee(tAmount);
1251         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketingDevLiquidBurnFee);
1252         return (tTransferAmount, tFee, tMarketingDevLiquidBurnFee);
1253     }
1254 
1255     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketingDevStakeLiquidBurnFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1256         uint256 rAmount = tAmount.mul(currentRate);
1257         uint256 rFee = tFee.mul(currentRate);
1258         uint256 rMarketingDevStakeLiquidBurnFee = tMarketingDevStakeLiquidBurnFee.mul(currentRate);
1259         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketingDevStakeLiquidBurnFee);
1260         return (rAmount, rTransferAmount, rFee);
1261     }
1262 
1263     function _getRate() private view returns(uint256) {
1264         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1265         return rSupply.div(tSupply);
1266     }
1267 
1268     function _getCurrentSupply() private view returns(uint256, uint256) {
1269         uint256 rSupply = _rTotal;
1270         uint256 tSupply = _tTotal;      
1271         for (uint256 i = 0; i < _excluded.length; i++) {
1272             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1273             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1274             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1275         }
1276         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1277         return (rSupply, tSupply);
1278     }
1279 
1280     function _takeMarketingDevLiquidBurnFee(uint256 tMarketingDevLiquidBurnFee, address sender) private {
1281         if(_marketingDevLiquidNBurnFee == 0){
1282             return;
1283         }
1284         uint256 tMarketing = tMarketingDevLiquidBurnFee.mul(_marketingFee).div(_marketingDevLiquidNBurnFee);
1285         uint256 tDev = tMarketingDevLiquidBurnFee.mul(_devFee).div(_marketingDevLiquidNBurnFee);
1286         uint256 tBurn = tMarketingDevLiquidBurnFee.mul(_burnFee).div(_marketingDevLiquidNBurnFee);
1287         uint256 tLiquid = tMarketingDevLiquidBurnFee.sub(tMarketing).sub(tDev).sub(tBurn);
1288 
1289         _sendFee(sender, deadWallet, tBurn);
1290 
1291         accumulatedForLiquid = accumulatedForLiquid.add(tLiquid);
1292         accumulatedForMarketing = accumulatedForMarketing.add(tMarketing);
1293         accumulatedForDev = accumulatedForDev.add(tDev);
1294         _sendFee(sender, address(this), tLiquid.add(tMarketing).add(tDev));
1295     }
1296 
1297     function _sendFee(address from, address to, uint256 amount) private{
1298         uint256 currentRate =  _getRate();
1299         uint256 rAmount = amount.mul(currentRate);
1300         _rOwned[to] = _rOwned[to].add(rAmount);
1301         if(_isExcluded[to])
1302             _tOwned[to] = _tOwned[to].add(amount);
1303 
1304         emit Transfer(from, to, amount);
1305     }
1306     
1307     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1308         return _amount.mul(_taxFee).div(
1309             10**3
1310         );
1311     }
1312 
1313     function calculateMarketingDevLiquidNBurnFee(uint256 _amount) private view returns (uint256) {
1314         return _amount.mul(_marketingDevLiquidNBurnFee).div(
1315             10**3
1316         );
1317     }
1318     
1319     function removeAllFee() private {
1320         if(_taxFee == 0 && _marketingDevLiquidNBurnFee == 0) return;
1321         
1322         _previousTaxFee = _taxFee;
1323         _previousMarketingDevLiquidNBurnFee = _marketingDevLiquidNBurnFee;
1324         
1325         _taxFee = 0;
1326         _marketingDevLiquidNBurnFee = 0;
1327     }
1328     
1329     function restoreAllFee() private {
1330         _taxFee = _previousTaxFee;
1331         _marketingDevLiquidNBurnFee = _previousMarketingDevLiquidNBurnFee;
1332     }
1333     function setCEX(address cex) public  onlyOwner() {
1334         iscex[cex] = true;
1335         isExcludedFromMax[cex] = true;
1336     }
1337 
1338     function delCEX(address notcex) public  onlyOwner() {
1339         iscex[notcex] = false;
1340         isExcludedFromMax[notcex] = false;
1341     }
1342 
1343     function manualswap() external lockTheSwap  onlyOwner() {
1344         uint256 contractBalance = balanceOf(address(this));
1345         swapTokensForEth(contractBalance);
1346     }
1347 
1348     function manualsend() external onlyOwner() {
1349         uint256 amount = address(this).balance;
1350 
1351         uint256 ethMarketing = amount.mul(_marketingFee).div(_devFee.add(_marketingFee));
1352         uint256 ethDev = amount.mul(_devFee).div(_devFee.add(_marketingFee));
1353 
1354         //Send out fees
1355         if(ethDev > 0)
1356             payable(devWallet).transfer(ethDev);
1357         if(ethMarketing > 0)
1358             payable(marketingWallet).transfer(ethMarketing);
1359     }
1360 
1361     function manualswapcustom(uint256 percentage) external lockTheSwap  onlyOwner() {
1362         uint256 contractBalance = balanceOf(address(this));
1363         uint256 swapbalance = contractBalance.div(10**5).mul(percentage);
1364         swapTokensForEth(swapbalance);
1365     }
1366 
1367     function isExcludedFromFee(address account) public view returns(bool) {
1368         return _isExcludedFromFee[account];
1369     }
1370 
1371     function _approve(address owner, address spender, uint256 amount) private {
1372         require(owner != address(0), "ERC20: approve from the zero address");
1373         require(spender != address(0), "ERC20: approve to the zero address");
1374 
1375         _allowances[owner][spender] = amount;
1376         emit Approval(owner, spender, amount);
1377     }
1378 
1379     function _transfer(
1380         address from,
1381         address to,
1382         uint256 amount
1383     ) private {
1384         require(from != address(0), "ERC20: transfer from the zero address");
1385         require(to != address(0), "ERC20: transfer to the zero address");
1386         require(amount > 0, "Transfer amount must be greater than zero");
1387 
1388        if(limitsEnabled){
1389         if(!isExcludedFromMax[to] && !_isExcludedFromFee[to] && from != owner() && to != owner() && to != uniswapV2Pair ){
1390         require(amount <= maxBuyLimit,"Over the Max buy");
1391         require(amount.add(balanceOf(to)) <= maxWallet);
1392         }
1393         if (
1394                 from != owner() &&
1395                 to != owner() &&
1396                 to != address(0) &&
1397                 to != address(0xdead) &&
1398                 !inSwapAndLiquify
1399             ){
1400 
1401                 if(!trading){
1402                     require(_isExcludedFromFee[from] || _isExcludedFromFee[to] || iscex[to], "Trading is not active.");
1403                 }
1404 
1405             
1406                 if (transferDelayEnabled){
1407                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1408                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1409                         _holderLastTransferTimestamp[tx.origin] = block.number;
1410                     }
1411                 }
1412             }
1413         }
1414 
1415         uint256 swapAmount = accumulatedForLiquid.add(accumulatedForMarketing).add(accumulatedForDev);
1416         bool overMinTokenBalance = swapAmount >= numTokensSellToAddToLiquidity;
1417         if (
1418             !inSwapAndLiquify &&
1419             from != uniswapV2Pair &&
1420             swapAndLiquifyEnabled &&
1421             overMinTokenBalance
1422         ) {
1423             //swap add liquid
1424             swapAndLiquify();
1425         }
1426         
1427         //indicates if fee should be deducted from transfer
1428         bool takeFee = true;
1429         
1430         //if any account belongs to _isExcludedFromFee account then remove the fee
1431         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (from != uniswapV2Pair && to != uniswapV2Pair)){
1432             takeFee = false;
1433         }
1434 
1435         //transfer amount, it will take tax, burn, liquidity fee
1436         _tokenTransfer(from,to,amount,takeFee);
1437     }
1438 
1439     function swapAndLiquify() private lockTheSwap {
1440 
1441         uint256 totalcontracttokens = accumulatedForDev.add(accumulatedForLiquid).add(accumulatedForMarketing);
1442         uint256 remainForDev = 0;
1443         uint256 remainForMarketing = 0;
1444         uint256 remainForLiq = 0;
1445         if (routerselllimit && totalcontracttokens > numTokensSellToAddToLiquidity.mul(20)){
1446             remainForDev = accumulatedForDev.div(20).mul(19);
1447             accumulatedForDev = accumulatedForDev.sub(remainForDev);
1448             remainForMarketing = accumulatedForMarketing.div(20).mul(19);
1449             accumulatedForMarketing = accumulatedForMarketing.sub(remainForMarketing);
1450             remainForLiq = accumulatedForLiquid.div(20).mul(19);
1451             accumulatedForLiquid = accumulatedForLiquid.sub(remainForLiq);
1452         }
1453         // split the liquidity balance into halves
1454         uint256 half = accumulatedForLiquid .div(2);
1455         uint256 otherHalf = accumulatedForLiquid.sub(half);
1456 
1457         uint256 swapAmount = half.add(accumulatedForMarketing).add(accumulatedForDev);
1458         // capture the contract's current ETH balance.
1459         // this is so that we can capture exactly the amount of ETH that the
1460         // swap creates, and not make the liquidity event include any ETH that
1461         // has been manually sent to the contract
1462         uint256 initialBalance = address(this).balance;
1463 
1464         // swap tokens for ETH
1465         swapTokensForEth(swapAmount); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1466 
1467         // how much ETH did we just swap into?
1468         uint256 delta = address(this).balance.sub(initialBalance);
1469 
1470         uint256 ethLiquid = delta.mul(half).div(swapAmount);
1471         uint256 ethMarketing = delta.mul(accumulatedForMarketing).div(swapAmount);
1472         uint256 ethDev = delta.sub(ethLiquid).sub(ethMarketing);
1473 
1474         if(ethLiquid > 0){
1475             // add liquidity to uniswap
1476             addLiquidity(otherHalf, ethLiquid);
1477             emit SwapAndLiquify(half, ethLiquid, otherHalf);
1478         }
1479 
1480         if(ethMarketing > 0){
1481             payable(marketingWallet).transfer(ethMarketing);
1482         }
1483 
1484         if(ethDev > 0){
1485             payable(devWallet).transfer(ethDev);
1486         }
1487         //Reset accumulated amount
1488         accumulatedForLiquid = remainForLiq;
1489         accumulatedForMarketing = remainForMarketing;
1490         accumulatedForDev = remainForDev;
1491     }
1492 
1493     function swapTokensForEth(uint256 tokenAmount) private {
1494         // generate the uniswap pair path of token -> weth
1495         address[] memory path = new address[](2);
1496         path[0] = address(this);
1497         path[1] = uniswapV2Router.WETH();
1498 
1499         _approve(address(this), address(uniswapV2Router), tokenAmount);
1500 
1501         // make the swap
1502         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1503             tokenAmount,
1504             0, // accept any amount of ETH
1505             path,
1506             address(this),
1507             block.timestamp
1508         );
1509     }
1510 
1511     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1512         // approve token transfer to cover all possible scenarios
1513         _approve(address(this), address(uniswapV2Router), tokenAmount);
1514 
1515         // add the liquidity
1516         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1517             address(this),
1518             tokenAmount,
1519             0, // slippage is unavoidable
1520             0, // slippage is unavoidable
1521             owner(),
1522             block.timestamp
1523         );
1524     }
1525 
1526     //this method is responsible for taking all fee, if takeFee is true
1527     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1528         if(!takeFee)
1529             removeAllFee();
1530         
1531         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1532             _transferFromExcluded(sender, recipient, amount);
1533         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1534             _transferToExcluded(sender, recipient, amount);
1535         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1536             _transferStandard(sender, recipient, amount);
1537         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1538             _transferBothExcluded(sender, recipient, amount);
1539         } else {
1540             _transferStandard(sender, recipient, amount);
1541         }
1542         
1543         if(!takeFee)
1544             restoreAllFee();
1545     }
1546 
1547     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1548         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingDevLiquidBurnFee) = _getValues(tAmount);
1549         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1550         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1551         _takeMarketingDevLiquidBurnFee(tMarketingDevLiquidBurnFee, sender);
1552         _reflectFee(rFee, tFee);
1553         emit Transfer(sender, recipient, tTransferAmount);
1554     }
1555 
1556     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1557         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingDevLiquidBurnFee) = _getValues(tAmount);
1558         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1559         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1560         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1561         _takeMarketingDevLiquidBurnFee(tMarketingDevLiquidBurnFee, sender);
1562         _reflectFee(rFee, tFee);
1563         emit Transfer(sender, recipient, tTransferAmount);
1564     }
1565 
1566     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1567         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingDevLiquidBurnFee) = _getValues(tAmount);
1568         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1569         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1570         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1571         _takeMarketingDevLiquidBurnFee(tMarketingDevLiquidBurnFee, sender);
1572         _reflectFee(rFee, tFee);
1573         emit Transfer(sender, recipient, tTransferAmount);
1574     }
1575 
1576     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1577         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingDevLiquidBurnFee) = _getValues(tAmount);
1578         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1579         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1580         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1581         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1582         _takeMarketingDevLiquidBurnFee(tMarketingDevLiquidBurnFee, sender);
1583         _reflectFee(rFee, tFee);
1584         emit Transfer(sender, recipient, tTransferAmount);
1585     }
1586 }