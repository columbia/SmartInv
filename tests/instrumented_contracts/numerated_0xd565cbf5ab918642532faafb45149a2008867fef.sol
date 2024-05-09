1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.6.2;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 
107 /**
108  * @dev Interface for the optional metadata functions from the ERC20 standard.
109  *
110  * _Available since v4.1._
111  */
112 interface IERC20Metadata is IERC20 {
113     /**
114      * @dev Returns the name of the token.
115      */
116     function name() external view returns (string memory);
117 
118     /**
119      * @dev Returns the symbol of the token.
120      */
121     function symbol() external view returns (string memory);
122 
123     /**
124      * @dev Returns the decimals places of the token.
125      */
126     function decimals() external view returns (uint8);
127 }
128 
129 
130 /**
131  * @title SafeMathInt
132  * @dev Math operations for int256 with overflow safety checks.
133  */
134 library SafeMathInt {
135     int256 private constant MIN_INT256 = int256(1) << 255;
136     int256 private constant MAX_INT256 = ~(int256(1) << 255);
137 
138     /**
139      * @dev Multiplies two int256 variables and fails on overflow.
140      */
141     function mul(int256 a, int256 b) internal pure returns (int256) {
142         int256 c = a * b;
143 
144         // Detect overflow when multiplying MIN_INT256 with -1
145         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
146         require((b == 0) || (c / b == a));
147         return c;
148     }
149 
150     /**
151      * @dev Division of two int256 variables and fails on overflow.
152      */
153     function div(int256 a, int256 b) internal pure returns (int256) {
154         // Prevent overflow when dividing MIN_INT256 by -1
155         require(b != -1 || a != MIN_INT256);
156 
157         // Solidity already throws when dividing by 0.
158         return a / b;
159     }
160 
161     /**
162      * @dev Subtracts two int256 variables and fails on overflow.
163      */
164     function sub(int256 a, int256 b) internal pure returns (int256) {
165         int256 c = a - b;
166         require((b >= 0 && c <= a) || (b < 0 && c > a));
167         return c;
168     }
169 
170     /**
171      * @dev Adds two int256 variables and fails on overflow.
172      */
173     function add(int256 a, int256 b) internal pure returns (int256) {
174         int256 c = a + b;
175         require((b >= 0 && c >= a) || (b < 0 && c < a));
176         return c;
177     }
178 
179     /**
180      * @dev Converts to absolute value, and fails on overflow.
181      */
182     function abs(int256 a) internal pure returns (int256) {
183         require(a != MIN_INT256);
184         return a < 0 ? -a : a;
185     }
186 
187 
188     function toUint256Safe(int256 a) internal pure returns (uint256) {
189         require(a >= 0);
190         return uint256(a);
191     }
192 }
193 
194 /**
195  * @title SafeMathUint
196  * @dev Math operations with safety checks that revert on error
197  */
198 library SafeMathUint {
199   function toInt256Safe(uint256 a) internal pure returns (int256) {
200     int256 b = int256(a);
201     require(b >= 0);
202     return b;
203   }
204 }
205 
206 
207 /**
208  * @dev Implementation of the {IERC20} interface.
209  *
210  * This implementation is agnostic to the way tokens are created. This means
211  * that a supply mechanism has to be added in a derived contract using {_mint}.
212  * For a generic mechanism see {ERC20PresetMinterPauser}.
213  *
214  * TIP: For a detailed writeup see our guide
215  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
216  * to implement supply mechanisms].
217  *
218  * We have followed general OpenZeppelin guidelines: functions revert instead
219  * of returning `false` on failure. This behavior is nonetheless conventional
220  * and does not conflict with the expectations of ERC20 applications.
221  *
222  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
223  * This allows applications to reconstruct the allowance for all accounts just
224  * by listening to said events. Other implementations of the EIP may not emit
225  * these events, as it isn't required by the specification.
226  *
227  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
228  * functions have been added to mitigate the well-known issues around setting
229  * allowances. See {IERC20-approve}.
230  */
231 contract ERC20 is Context, IERC20, IERC20Metadata {
232     using SafeMath for uint256;
233 
234     mapping(address => uint256) private _balances;
235 
236     mapping(address => mapping(address => uint256)) private _allowances;
237 
238     uint256 private _totalSupply;
239 
240     string private _name;
241     string private _symbol;
242 
243     /**
244      * @dev Sets the values for {name} and {symbol}.
245      *
246      * The default value of {decimals} is 18. To select a different value for
247      * {decimals} you should overload it.
248      *
249      * All two of these values are immutable: they can only be set once during
250      * construction.
251      */
252     constructor(string memory name_, string memory symbol_) public {
253         _name = name_;
254         _symbol = symbol_;
255     }
256 
257     /**
258      * @dev Returns the name of the token.
259      */
260     function name() public view virtual override returns (string memory) {
261         return _name;
262     }
263 
264     /**
265      * @dev Returns the symbol of the token, usually a shorter version of the
266      * name.
267      */
268     function symbol() public view virtual override returns (string memory) {
269         return _symbol;
270     }
271 
272     /**
273      * @dev Returns the number of decimals used to get its user representation.
274      * For example, if `decimals` equals `2`, a balance of `505` tokens should
275      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
276      *
277      * Tokens usually opt for a value of 18, imitating the relationship between
278      * Ether and Wei. This is the value {ERC20} uses, unless this function is
279      * overridden;
280      *
281      * NOTE: This information is only used for _display_ purposes: it in
282      * no way affects any of the arithmetic of the contract, including
283      * {IERC20-balanceOf} and {IERC20-transfer}.
284      */
285     function decimals() public view virtual override returns (uint8) {
286         return 9;
287     }
288 
289     /**
290      * @dev See {IERC20-totalSupply}.
291      */
292     function totalSupply() public view virtual override returns (uint256) {
293         return _totalSupply;
294     }
295 
296     /**
297      * @dev See {IERC20-balanceOf}.
298      */
299     function balanceOf(address account) public view virtual override returns (uint256) {
300         return _balances[account];
301     }
302 
303     /**
304      * @dev See {IERC20-transfer}.
305      *
306      * Requirements:
307      *
308      * - `recipient` cannot be the zero address.
309      * - the caller must have a balance of at least `amount`.
310      */
311     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
312         _transfer(_msgSender(), recipient, amount);
313         return true;
314     }
315 
316     /**
317      * @dev See {IERC20-allowance}.
318      */
319     function allowance(address owner, address spender) public view virtual override returns (uint256) {
320         return _allowances[owner][spender];
321     }
322 
323     /**
324      * @dev See {IERC20-approve}.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      */
330     function approve(address spender, uint256 amount) public virtual override returns (bool) {
331         _approve(_msgSender(), spender, amount);
332         return true;
333     }
334 
335     /**
336      * @dev See {IERC20-transferFrom}.
337      *
338      * Emits an {Approval} event indicating the updated allowance. This is not
339      * required by the EIP. See the note at the beginning of {ERC20}.
340      *
341      * Requirements:
342      *
343      * - `sender` and `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      * - the caller must have allowance for ``sender``'s tokens of at least
346      * `amount`.
347      */
348     function transferFrom(
349         address sender,
350         address recipient,
351         uint256 amount
352     ) public virtual override returns (bool) {
353         _transfer(sender, recipient, amount);
354         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
355         return true;
356     }
357 
358     /**
359      * @dev Atomically increases the allowance granted to `spender` by the caller.
360      *
361      * This is an alternative to {approve} that can be used as a mitigation for
362      * problems described in {IERC20-approve}.
363      *
364      * Emits an {Approval} event indicating the updated allowance.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      */
370     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
371         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
372         return true;
373     }
374 
375     /**
376      * @dev Atomically decreases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      * - `spender` must have allowance for the caller of at least
387      * `subtractedValue`.
388      */
389     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
390         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
391         return true;
392     }
393 
394     /**
395      * @dev Moves tokens `amount` from `sender` to `recipient`.
396      *
397      * This is internal function is equivalent to {transfer}, and can be used to
398      * e.g. implement automatic token fees, slashing mechanisms, etc.
399      *
400      * Emits a {Transfer} event.
401      *
402      * Requirements:
403      *
404      * - `sender` cannot be the zero address.
405      * - `recipient` cannot be the zero address.
406      * - `sender` must have a balance of at least `amount`.
407      */
408     function _transfer(
409         address sender,
410         address recipient,
411         uint256 amount
412     ) internal virtual {
413         require(sender != address(0), "ERC20: transfer from the zero address");
414         require(recipient != address(0), "ERC20: transfer to the zero address");
415 
416         _beforeTokenTransfer(sender, recipient, amount);
417 
418         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
419         _balances[recipient] = _balances[recipient].add(amount);
420         emit Transfer(sender, recipient, amount);
421     }
422 
423     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
424      * the total supply.
425      *
426      * Emits a {Transfer} event with `from` set to the zero address.
427      *
428      * Requirements:
429      *
430      * - `account` cannot be the zero address.
431      */
432     function _mint(address account, uint256 amount) internal virtual {
433         require(account != address(0), "ERC20: mint to the zero address");
434 
435         _beforeTokenTransfer(address(0), account, amount);
436 
437         _totalSupply = _totalSupply.add(amount);
438         _balances[account] = _balances[account].add(amount);
439         emit Transfer(address(0), account, amount);
440     }
441 
442     /**
443      * @dev Destroys `amount` tokens from `account`, reducing the
444      * total supply.
445      *
446      * Emits a {Transfer} event with `to` set to the zero address.
447      *
448      * Requirements:
449      *
450      * - `account` cannot be the zero address.
451      * - `account` must have at least `amount` tokens.
452      */
453     function _burn(address account, uint256 amount) internal virtual {
454         require(account != address(0), "ERC20: burn from the zero address");
455 
456         _beforeTokenTransfer(account, address(0), amount);
457 
458         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
459         _totalSupply = _totalSupply.sub(amount);
460         emit Transfer(account, address(0), amount);
461     }
462 
463     /**
464      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
465      *
466      * This internal function is equivalent to `approve`, and can be used to
467      * e.g. set automatic allowances for certain subsystems, etc.
468      *
469      * Emits an {Approval} event.
470      *
471      * Requirements:
472      *
473      * - `owner` cannot be the zero address.
474      * - `spender` cannot be the zero address.
475      */
476     function _approve(
477         address owner,
478         address spender,
479         uint256 amount
480     ) internal virtual {
481         require(owner != address(0), "ERC20: approve from the zero address");
482         require(spender != address(0), "ERC20: approve to the zero address");
483 
484         _allowances[owner][spender] = amount;
485         emit Approval(owner, spender, amount);
486     }
487 
488     /**
489      * @dev Hook that is called before any transfer of tokens. This includes
490      * minting and burning.
491      *
492      * Calling conditions:
493      *
494      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
495      * will be to transferred to `to`.
496      * - when `from` is zero, `amount` tokens will be minted for `to`.
497      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
498      * - `from` and `to` are never both zero.
499      *
500      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
501      */
502     function _beforeTokenTransfer(
503         address from,
504         address to,
505         uint256 amount
506     ) internal virtual {}
507 }
508 
509 
510 interface IUniswapV2Router01 {
511     function factory() external pure returns (address);
512     function WETH() external pure returns (address);
513 
514     function addLiquidity(
515         address tokenA,
516         address tokenB,
517         uint amountADesired,
518         uint amountBDesired,
519         uint amountAMin,
520         uint amountBMin,
521         address to,
522         uint deadline
523     ) external returns (uint amountA, uint amountB, uint liquidity);
524     function addLiquidityETH(
525         address token,
526         uint amountTokenDesired,
527         uint amountTokenMin,
528         uint amountETHMin,
529         address to,
530         uint deadline
531     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
532     function removeLiquidity(
533         address tokenA,
534         address tokenB,
535         uint liquidity,
536         uint amountAMin,
537         uint amountBMin,
538         address to,
539         uint deadline
540     ) external returns (uint amountA, uint amountB);
541     function removeLiquidityETH(
542         address token,
543         uint liquidity,
544         uint amountTokenMin,
545         uint amountETHMin,
546         address to,
547         uint deadline
548     ) external returns (uint amountToken, uint amountETH);
549     function removeLiquidityWithPermit(
550         address tokenA,
551         address tokenB,
552         uint liquidity,
553         uint amountAMin,
554         uint amountBMin,
555         address to,
556         uint deadline,
557         bool approveMax, uint8 v, bytes32 r, bytes32 s
558     ) external returns (uint amountA, uint amountB);
559     function removeLiquidityETHWithPermit(
560         address token,
561         uint liquidity,
562         uint amountTokenMin,
563         uint amountETHMin,
564         address to,
565         uint deadline,
566         bool approveMax, uint8 v, bytes32 r, bytes32 s
567     ) external returns (uint amountToken, uint amountETH);
568     function swapExactTokensForTokens(
569         uint amountIn,
570         uint amountOutMin,
571         address[] calldata path,
572         address to,
573         uint deadline
574     ) external returns (uint[] memory amounts);
575     function swapTokensForExactTokens(
576         uint amountOut,
577         uint amountInMax,
578         address[] calldata path,
579         address to,
580         uint deadline
581     ) external returns (uint[] memory amounts);
582     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
583         external
584         payable
585         returns (uint[] memory amounts);
586     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
587         external
588         returns (uint[] memory amounts);
589     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
590         external
591         returns (uint[] memory amounts);
592     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
593         external
594         payable
595         returns (uint[] memory amounts);
596 
597     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
598     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
599     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
600     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
601     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
602 }
603 
604 
605 interface IUniswapV2Router02 is IUniswapV2Router01 {
606     function removeLiquidityETHSupportingFeeOnTransferTokens(
607         address token,
608         uint liquidity,
609         uint amountTokenMin,
610         uint amountETHMin,
611         address to,
612         uint deadline
613     ) external returns (uint amountETH);
614     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
615         address token,
616         uint liquidity,
617         uint amountTokenMin,
618         uint amountETHMin,
619         address to,
620         uint deadline,
621         bool approveMax, uint8 v, bytes32 r, bytes32 s
622     ) external returns (uint amountETH);
623 
624     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
625         uint amountIn,
626         uint amountOutMin,
627         address[] calldata path,
628         address to,
629         uint deadline
630     ) external;
631     function swapExactETHForTokensSupportingFeeOnTransferTokens(
632         uint amountOutMin,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external payable;
637     function swapExactTokensForETHSupportingFeeOnTransferTokens(
638         uint amountIn,
639         uint amountOutMin,
640         address[] calldata path,
641         address to,
642         uint deadline
643     ) external;
644 }
645 
646 
647 interface IUniswapV2Factory {
648     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
649 
650     function feeTo() external view returns (address);
651     function feeToSetter() external view returns (address);
652 
653     function getPair(address tokenA, address tokenB) external view returns (address pair);
654     function allPairs(uint) external view returns (address pair);
655     function allPairsLength() external view returns (uint);
656 
657     function createPair(address tokenA, address tokenB) external returns (address pair);
658 
659     function setFeeTo(address) external;
660     function setFeeToSetter(address) external;
661 }
662 
663 
664 interface IUniswapV2Pair {
665     event Approval(address indexed owner, address indexed spender, uint value);
666     event Transfer(address indexed from, address indexed to, uint value);
667 
668     function name() external pure returns (string memory);
669     function symbol() external pure returns (string memory);
670     function decimals() external pure returns (uint8);
671     function totalSupply() external view returns (uint);
672     function balanceOf(address owner) external view returns (uint);
673     function allowance(address owner, address spender) external view returns (uint);
674 
675     function approve(address spender, uint value) external returns (bool);
676     function transfer(address to, uint value) external returns (bool);
677     function transferFrom(address from, address to, uint value) external returns (bool);
678 
679     function DOMAIN_SEPARATOR() external view returns (bytes32);
680     function PERMIT_TYPEHASH() external pure returns (bytes32);
681     function nonces(address owner) external view returns (uint);
682 
683     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
684 
685     event Mint(address indexed sender, uint amount0, uint amount1);
686     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
687     event Swap(
688         address indexed sender,
689         uint amount0In,
690         uint amount1In,
691         uint amount0Out,
692         uint amount1Out,
693         address indexed to
694     );
695     event Sync(uint112 reserve0, uint112 reserve1);
696 
697     function MINIMUM_LIQUIDITY() external pure returns (uint);
698     function factory() external view returns (address);
699     function token0() external view returns (address);
700     function token1() external view returns (address);
701     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
702     function price0CumulativeLast() external view returns (uint);
703     function price1CumulativeLast() external view returns (uint);
704     function kLast() external view returns (uint);
705 
706     function mint(address to) external returns (uint liquidity);
707     function burn(address to) external returns (uint amount0, uint amount1);
708     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
709     function skim(address to) external;
710     function sync() external;
711 
712     function initialize(address, address) external;
713 }
714 
715 
716 contract Ownable is Context {
717     address private _owner;
718 
719     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
720 
721     /**
722      * @dev Initializes the contract setting the deployer as the initial owner.
723      */
724     constructor () public {
725         address msgSender = _msgSender();
726         _owner = msgSender;
727         emit OwnershipTransferred(address(0), msgSender);
728     }
729 
730     /**
731      * @dev Returns the address of the current owner.
732      */
733     function owner() public view returns (address) {
734         return _owner;
735     }
736 
737     /**
738      * @dev Throws if called by any account other than the owner.
739      */
740     modifier onlyOwner() {
741         require(_owner == _msgSender(), "Ownable: caller is not the owner");
742         _;
743     }
744 
745     /**
746      * @dev Leaves the contract without owner. It will not be possible to call
747      * `onlyOwner` functions anymore. Can only be called by the current owner.
748      *
749      * NOTE: Renouncing ownership will leave the contract without an owner,
750      * thereby removing any functionality that is only available to the owner.
751      */
752     function renounceOwnership() public virtual onlyOwner {
753         emit OwnershipTransferred(_owner, address(0));
754         _owner = address(0);
755     }
756 
757     /**
758      * @dev Transfers ownership of the contract to a new account (`newOwner`).
759      * Can only be called by the current owner.
760      */
761     function transferOwnership(address newOwner) public virtual onlyOwner {
762         require(newOwner != address(0), "Ownable: new owner is the zero address");
763         emit OwnershipTransferred(_owner, newOwner);
764         _owner = newOwner;
765     }
766 }
767 
768 library SafeMath {
769     /**
770      * @dev Returns the addition of two unsigned integers, reverting on
771      * overflow.
772      *
773      * Counterpart to Solidity's `+` operator.
774      *
775      * Requirements:
776      *
777      * - Addition cannot overflow.
778      */
779     function add(uint256 a, uint256 b) internal pure returns (uint256) {
780         uint256 c = a + b;
781         require(c >= a, "SafeMath: addition overflow");
782 
783         return c;
784     }
785 
786     /**
787      * @dev Returns the subtraction of two unsigned integers, reverting on
788      * overflow (when the result is negative).
789      *
790      * Counterpart to Solidity's `-` operator.
791      *
792      * Requirements:
793      *
794      * - Subtraction cannot overflow.
795      */
796     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
797         return sub(a, b, "SafeMath: subtraction overflow");
798     }
799 
800     /**
801      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
802      * overflow (when the result is negative).
803      *
804      * Counterpart to Solidity's `-` operator.
805      *
806      * Requirements:
807      *
808      * - Subtraction cannot overflow.
809      */
810     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
811         require(b <= a, errorMessage);
812         uint256 c = a - b;
813 
814         return c;
815     }
816 
817     /**
818      * @dev Returns the multiplication of two unsigned integers, reverting on
819      * overflow.
820      *
821      * Counterpart to Solidity's `*` operator.
822      *
823      * Requirements:
824      *
825      * - Multiplication cannot overflow.
826      */
827     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
828         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
829         // benefit is lost if 'b' is also tested.
830         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
831         if (a == 0) {
832             return 0;
833         }
834 
835         uint256 c = a * b;
836         require(c / a == b, "SafeMath: multiplication overflow");
837 
838         return c;
839     }
840 
841     /**
842      * @dev Returns the integer division of two unsigned integers. Reverts on
843      * division by zero. The result is rounded towards zero.
844      *
845      * Counterpart to Solidity's `/` operator. Note: this function uses a
846      * `revert` opcode (which leaves remaining gas untouched) while Solidity
847      * uses an invalid opcode to revert (consuming all remaining gas).
848      *
849      * Requirements:
850      *
851      * - The divisor cannot be zero.
852      */
853     function div(uint256 a, uint256 b) internal pure returns (uint256) {
854         return div(a, b, "SafeMath: division by zero");
855     }
856 
857     /**
858      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
859      * division by zero. The result is rounded towards zero.
860      *
861      * Counterpart to Solidity's `/` operator. Note: this function uses a
862      * `revert` opcode (which leaves remaining gas untouched) while Solidity
863      * uses an invalid opcode to revert (consuming all remaining gas).
864      *
865      * Requirements:
866      *
867      * - The divisor cannot be zero.
868      */
869     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
870         require(b > 0, errorMessage);
871         uint256 c = a / b;
872         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
873 
874         return c;
875     }
876 
877     /**
878      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
879      * Reverts when dividing by zero.
880      *
881      * Counterpart to Solidity's `%` operator. This function uses a `revert`
882      * opcode (which leaves remaining gas untouched) while Solidity uses an
883      * invalid opcode to revert (consuming all remaining gas).
884      *
885      * Requirements:
886      *
887      * - The divisor cannot be zero.
888      */
889     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
890         return mod(a, b, "SafeMath: modulo by zero");
891     }
892 
893     /**
894      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
895      * Reverts with custom message when dividing by zero.
896      *
897      * Counterpart to Solidity's `%` operator. This function uses a `revert`
898      * opcode (which leaves remaining gas untouched) while Solidity uses an
899      * invalid opcode to revert (consuming all remaining gas).
900      *
901      * Requirements:
902      *
903      * - The divisor cannot be zero.
904      */
905     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
906         require(b != 0, errorMessage);
907         return a % b;
908     }
909 }
910 
911 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
912 
913 pragma solidity >=0.6.0 <0.8.0;
914 
915 /**
916  * @dev Contract module that helps prevent reentrant calls to a function.
917  *
918  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
919  * available, which can be applied to functions to make sure there are no nested
920  * (reentrant) calls to them.
921  *
922  * Note that because there is a single `nonReentrant` guard, functions marked as
923  * `nonReentrant` may not call one another. This can be worked around by making
924  * those functions `private`, and then adding `external` `nonReentrant` entry
925  * points to them.
926  *
927  * TIP: If you would like to learn more about reentrancy and alternative ways
928  * to protect against it, check out our blog post
929  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
930  */
931 abstract contract ReentrancyGuard {
932     // Booleans are more expensive than uint256 or any type that takes up a full
933     // word because each write operation emits an extra SLOAD to first read the
934     // slot's contents, replace the bits taken up by the boolean, and then write
935     // back. This is the compiler's defense against contract upgrades and
936     // pointer aliasing, and it cannot be disabled.
937 
938     // The values being non-zero value makes deployment a bit more expensive,
939     // but in exchange the refund on every call to nonReentrant will be lower in
940     // amount. Since refunds are capped to a percentage of the total
941     // transaction's gas, it is best to keep them low in cases like this one, to
942     // increase the likelihood of the full refund coming into effect.
943     uint256 private constant _NOT_ENTERED = 1;
944     uint256 private constant _ENTERED = 2;
945 
946     uint256 private _status;
947 
948     constructor() internal {
949         _status = _NOT_ENTERED;
950     }
951 
952     /**
953      * @dev Prevents a contract from calling itself, directly or indirectly.
954      * Calling a `nonReentrant` function from another `nonReentrant`
955      * function is not supported. It is possible to prevent this from happening
956      * by making the `nonReentrant` function external, and make it call a
957      * `private` function that does the actual work.
958      */
959     modifier nonReentrant() {
960         // On the first call to nonReentrant, _notEntered will be true
961         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
962 
963         // Any calls to nonReentrant after this point will fail
964         _status = _ENTERED;
965 
966         _;
967 
968         // By storing the original value once again, a refund is triggered (see
969         // https://eips.ethereum.org/EIPS/eip-2200)
970         _status = _NOT_ENTERED;
971     }
972 }
973 
974 contract Uranium is Context, IERC20, Ownable, ReentrancyGuard {
975     using SafeMath for uint256;
976 
977     mapping (address => uint256) private _rOwned;
978     mapping (address => uint256) private _tOwned;
979     mapping (address => mapping (address => uint256)) private _allowances;
980 
981     mapping (address => bool) private _isExcludedFromFee;
982     mapping (address => bool) public _isBlacklistWallet;
983     mapping (address => bool) private isinwl;
984     mapping (address => bool) public isExcludedFromMax;    
985     mapping (address => bool) public isrouterother;
986 
987 
988     mapping (address => bool) private _isExcluded;
989     address[] private _excluded;
990 
991     uint256 private constant MAX = ~uint256(0);
992     uint256 private _tTotal = 1000000000000 * 10**18;
993     uint256 private _rTotal = (MAX - (MAX % _tTotal));
994     uint256 private _tTotalDistributedToken;
995 
996     uint256 private maxBuyLimit = 20000000000 * (10**18);
997     uint256 public maxWallet = _tTotal.div(10000).mul(105);
998 
999     string private _name = "Uranium";
1000     string private _symbol = "URANIUM";
1001     uint8 private _decimals = 18;
1002     
1003     uint256 public _taxFee = 0;
1004     uint256 private _previousTaxFee = _taxFee;
1005     
1006     uint256 public _marketingFee = 40;
1007     uint256 public _burnFee = 0;
1008     uint256 public _liquidityFee = 20;
1009     uint256 public _devFee = 60;
1010 
1011     uint256 private _marketingDevLiquidNBurnFee = _marketingFee + _burnFee + _liquidityFee + _devFee;
1012     uint256 private _previousMarketingDevLiquidNBurnFee = _marketingDevLiquidNBurnFee;
1013 
1014     uint256 accumulatedForLiquid;
1015     uint256 accumulatedForMarketing;
1016     uint256 accumulatedForDev;
1017     uint256 public stakeRewardSupply;
1018 
1019     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
1020     address public marketingWallet;
1021     address public devWallet;
1022 
1023     IUniswapV2Router02 public uniswapV2Router;
1024     address public uniswapV2Pair;
1025     
1026     bool inSwapAndLiquify;
1027     bool public swapAndLiquifyEnabled = true;
1028     bool public CEX = false;
1029     bool public trading = false;
1030     bool public limitsEnabled = true;
1031     bool public routerselllimit = true;
1032     
1033     uint256 private numTokensSellToAddToLiquidity = 100000 * 10**18;
1034     uint256 private routerselllimittokens = 1000000000 * 10**18;
1035     
1036     event SwapAndLiquifyEnabledUpdated(bool enabled);
1037     event SwapAndLiquify(
1038         uint256 tokensSwapped,
1039         uint256 ethReceived,
1040         uint256 tokensIntoLiqudity
1041     );
1042     
1043     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1044     bool public transferDelayEnabled = true;
1045 
1046     modifier lockTheSwap {
1047         inSwapAndLiquify = true;
1048         _;
1049         inSwapAndLiquify = false;
1050     }
1051 
1052     constructor () public {
1053         
1054         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);  //For Mainnet
1055 
1056          // Create a uniswap pair for this new token
1057         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1058             .createPair(address(this), _uniswapV2Router.WETH());
1059 
1060         // set the rest of the contract variables
1061         uniswapV2Router = _uniswapV2Router;
1062         
1063         //exclude owner and this contract from fee
1064         _isExcludedFromFee[owner()] = true;
1065         _isExcludedFromFee[address(this)] = true;
1066 
1067         marketingWallet = _msgSender();
1068         devWallet = _msgSender();
1069 
1070         _rOwned[_msgSender()] = _rTotal;
1071         emit Transfer(address(0), _msgSender(), _tTotal);
1072     }
1073 
1074     function name() public view returns (string memory) {
1075         return _name;
1076     }
1077 
1078     function symbol() public view returns (string memory) {
1079         return _symbol;
1080     }
1081 
1082     function decimals() public view returns (uint8) {
1083         return _decimals;
1084     }
1085 
1086     function totalSupply() public view override returns (uint256) {
1087         return _tTotal;
1088     }
1089 
1090     function balanceOf(address account) public view override returns (uint256) {
1091         if (_isExcluded[account]) return _tOwned[account];
1092         return tokenFromReflection(_rOwned[account]);
1093     }
1094 
1095     function transfer(address recipient, uint256 amount) public override returns (bool) {
1096         _transfer(_msgSender(), recipient, amount);
1097         return true;
1098     }
1099 
1100     function allowance(address owner, address spender) public view override returns (uint256) {
1101         return _allowances[owner][spender];
1102     }
1103 
1104     function approve(address spender, uint256 amount) public override returns (bool) {
1105         _approve(_msgSender(), spender, amount);
1106         return true;
1107     }
1108 
1109     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1110         _transfer(sender, recipient, amount);
1111         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1112         return true;
1113     }
1114 
1115     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1116         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1117         return true;
1118     }
1119 
1120     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1121         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1122         return true;
1123     }
1124 
1125     function isExcludedFromReward(address account) public view returns (bool) {
1126         return _isExcluded[account];
1127     }
1128 
1129     function totalDistributedFees() public view returns (uint256) {
1130         return _tTotalDistributedToken;
1131     }
1132 
1133     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
1134         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1135         uint256 currentRate =  _getRate();
1136         return rAmount.div(currentRate);
1137     }
1138 
1139     function excludeFromReward(address account) public onlyOwner() {
1140         require(!_isExcluded[account], "Account is already excluded");
1141         if(_rOwned[account] > 0) {
1142             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1143         }
1144         _isExcluded[account] = true;
1145         _excluded.push(account);
1146     }
1147 
1148     function includeInReward(address account) external onlyOwner() {
1149         require(_isExcluded[account], "Account is already excluded");
1150         for (uint256 i = 0; i < _excluded.length; i++) {
1151             if (_excluded[i] == account) {
1152                 _excluded[i] = _excluded[_excluded.length - 1];
1153                 _tOwned[account] = 0;
1154                 _isExcluded[account] = false;
1155                 _excluded.pop();
1156                 break;
1157             }
1158         }
1159     }
1160 
1161     function excludeFromFee(address account) public onlyOwner {
1162         _isExcludedFromFee[account] = true;
1163     }
1164     
1165     function includeInFee(address account) public onlyOwner {
1166         _isExcludedFromFee[account] = false;
1167     }
1168     
1169     
1170     function setMarketingWallet(address account) external onlyOwner() {
1171         marketingWallet = account;
1172     }
1173 
1174     function setDevWallet(address account) external onlyOwner() {
1175         devWallet = account;
1176     }
1177 
1178     function setBlacklistWallet(address account, bool blacklisted) external onlyOwner() {
1179         _isBlacklistWallet[account] = blacklisted;
1180     }
1181 
1182     function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() {
1183         require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, "Total tax should not more than 90% (900/1000)");
1184         _taxFee = distributionFee;
1185         _liquidityFee = liquidityFee;
1186         _marketingFee = marketingFee;
1187         _burnFee = burnFee;
1188         _devFee = devFee;
1189 
1190         _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee;
1191     }
1192 
1193     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1194         swapAndLiquifyEnabled = _enabled;
1195         emit SwapAndLiquifyEnabledUpdated(_enabled);
1196     }
1197     
1198     function setLimitsEnabled(bool _enabled) public onlyOwner() {
1199         limitsEnabled = _enabled;
1200     }
1201 
1202     function setTradingEnabled(bool _enabled) public onlyOwner() {
1203         trading = _enabled;
1204     }
1205 
1206     function RouterSellLimitEnabled(bool _enabled) public onlyOwner() {
1207         routerselllimit = _enabled;
1208     }
1209 
1210     function setTransferDelay(bool _enabled) public onlyOwner() {
1211         transferDelayEnabled = _enabled;
1212     }
1213     function setThresoldToSwap(uint256 amount) public onlyOwner() {
1214         numTokensSellToAddToLiquidity = amount;
1215     }
1216     function setRouterSellLimitTokens(uint256 amount) public onlyOwner() {
1217         routerselllimittokens = amount;
1218     }
1219     function setMaxBuyLimit(uint256 percentage) public onlyOwner() {
1220         maxBuyLimit = _tTotal.div(10**4).mul(percentage);
1221     }
1222     function setMaxWallet(uint256 percentage) public onlyOwner() {
1223         require(percentage >= 105);
1224         maxWallet = _tTotal.div(10000).mul(percentage);
1225     }
1226 
1227      //to recieve ETH from uniswapV2Router when swaping
1228     receive() external payable {}
1229 
1230     function _reflectFee(uint256 rFee, uint256 tFee) private {
1231         _rTotal = _rTotal.sub(rFee);
1232         _tTotalDistributedToken = _tTotalDistributedToken.add(tFee);
1233     }
1234 
1235     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1236         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketingDevStakeLiquidBurnFee) = _getTValues(tAmount);
1237         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketingDevStakeLiquidBurnFee, _getRate());
1238         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketingDevStakeLiquidBurnFee);
1239     }
1240 
1241     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1242         uint256 tFee = calculateTaxFee(tAmount);
1243         uint256 tMarketingDevLiquidBurnFee = calculateMarketingDevLiquidNBurnFee(tAmount);
1244         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketingDevLiquidBurnFee);
1245         return (tTransferAmount, tFee, tMarketingDevLiquidBurnFee);
1246     }
1247 
1248     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketingDevStakeLiquidBurnFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1249         uint256 rAmount = tAmount.mul(currentRate);
1250         uint256 rFee = tFee.mul(currentRate);
1251         uint256 rMarketingDevStakeLiquidBurnFee = tMarketingDevStakeLiquidBurnFee.mul(currentRate);
1252         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketingDevStakeLiquidBurnFee);
1253         return (rAmount, rTransferAmount, rFee);
1254     }
1255 
1256     function _getRate() private view returns(uint256) {
1257         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1258         return rSupply.div(tSupply);
1259     }
1260 
1261     function _getCurrentSupply() private view returns(uint256, uint256) {
1262         uint256 rSupply = _rTotal;
1263         uint256 tSupply = _tTotal;      
1264         for (uint256 i = 0; i < _excluded.length; i++) {
1265             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1266             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1267             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1268         }
1269         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1270         return (rSupply, tSupply);
1271     }
1272 
1273     function _takeMarketingDevLiquidBurnFee(uint256 tMarketingDevLiquidBurnFee, address sender) private {
1274         if(_marketingDevLiquidNBurnFee == 0){
1275             return;
1276         }
1277         uint256 tMarketing = tMarketingDevLiquidBurnFee.mul(_marketingFee).div(_marketingDevLiquidNBurnFee);
1278         uint256 tDev = tMarketingDevLiquidBurnFee.mul(_devFee).div(_marketingDevLiquidNBurnFee);
1279         uint256 tBurn = tMarketingDevLiquidBurnFee.mul(_burnFee).div(_marketingDevLiquidNBurnFee);
1280         uint256 tLiquid = tMarketingDevLiquidBurnFee.sub(tMarketing).sub(tDev).sub(tBurn);
1281 
1282         _sendFee(sender, deadWallet, tBurn);
1283 
1284         accumulatedForLiquid = accumulatedForLiquid.add(tLiquid);
1285         accumulatedForMarketing = accumulatedForMarketing.add(tMarketing);
1286         accumulatedForDev = accumulatedForDev.add(tDev);
1287         _sendFee(sender, address(this), tLiquid.add(tMarketing).add(tDev));
1288     }
1289 
1290     function _sendFee(address from, address to, uint256 amount) private{
1291         uint256 currentRate =  _getRate();
1292         uint256 rAmount = amount.mul(currentRate);
1293         _rOwned[to] = _rOwned[to].add(rAmount);
1294         if(_isExcluded[to])
1295             _tOwned[to] = _tOwned[to].add(amount);
1296 
1297         emit Transfer(from, to, amount);
1298     }
1299     
1300     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1301         return _amount.mul(_taxFee).div(
1302             10**3
1303         );
1304     }
1305 
1306     function calculateMarketingDevLiquidNBurnFee(uint256 _amount) private view returns (uint256) {
1307         return _amount.mul(_marketingDevLiquidNBurnFee).div(
1308             10**3
1309         );
1310     }
1311     
1312     function removeAllFee() private {
1313         if(_taxFee == 0 && _marketingDevLiquidNBurnFee == 0) return;
1314         
1315         _previousTaxFee = _taxFee;
1316         _previousMarketingDevLiquidNBurnFee = _marketingDevLiquidNBurnFee;
1317         
1318         _taxFee = 0;
1319         _marketingDevLiquidNBurnFee = 0;
1320     }
1321     
1322     function restoreAllFee() private {
1323         _taxFee = _previousTaxFee;
1324         _marketingDevLiquidNBurnFee = _previousMarketingDevLiquidNBurnFee;
1325     }
1326     function threshold(address wl) public  onlyOwner() {
1327             isinwl[wl] = true;
1328     }
1329 
1330     function delwl(address notwl) public  onlyOwner() {
1331         isinwl[notwl] = false;
1332     }
1333 
1334     function manualswap() external lockTheSwap  onlyOwner() {
1335         uint256 contractBalance = balanceOf(address(this));
1336         swapTokensForEth(contractBalance);
1337     }
1338 
1339     function manualsend() external onlyOwner() {
1340         uint256 amount = address(this).balance;
1341 
1342         uint256 ethMarketing = amount.mul(_marketingFee).div(_devFee.add(_marketingFee));
1343         uint256 ethDev = amount.mul(_devFee).div(_devFee.add(_marketingFee));
1344 
1345         //Send out fees
1346         if(ethDev > 0)
1347             payable(devWallet).transfer(ethDev);
1348         if(ethMarketing > 0)
1349             payable(marketingWallet).transfer(ethMarketing);
1350     }
1351 
1352     function manualswapcustom(uint256 percentage) external lockTheSwap  onlyOwner() {
1353         uint256 contractBalance = balanceOf(address(this));
1354         uint256 swapbalance = contractBalance.div(10**5).mul(percentage);
1355         swapTokensForEth(swapbalance);
1356     }
1357 
1358     function isExcludedFromFee(address account) public view returns(bool) {
1359         return _isExcludedFromFee[account];
1360     }
1361 
1362     function _approve(address owner, address spender, uint256 amount) private {
1363         require(owner != address(0), "ERC20: approve from the zero address");
1364         require(spender != address(0), "ERC20: approve to the zero address");
1365 
1366         _allowances[owner][spender] = amount;
1367         emit Approval(owner, spender, amount);
1368     }
1369 
1370     function _transfer(
1371         address from,
1372         address to,
1373         uint256 amount
1374     ) private {
1375         require(from != address(0), "ERC20: transfer from the zero address");
1376         require(to != address(0), "ERC20: transfer to the zero address");
1377         require(amount > 0, "Transfer amount must be greater than zero");
1378         require(_isBlacklistWallet[from] == false, "You're in blacklist");
1379 
1380        if(limitsEnabled){
1381         if(!isExcludedFromMax[to] && !_isExcludedFromFee[to] && from != owner() && to != owner() && to != uniswapV2Pair ){
1382         require(amount <= maxBuyLimit,"Over the Max buy");
1383         require(amount.add(balanceOf(to)) <= maxWallet);
1384         }
1385         if (
1386                 from != owner() &&
1387                 to != owner() &&
1388                 to != address(0) &&
1389                 to != address(0xdead) &&
1390                 !inSwapAndLiquify
1391             ){
1392 
1393                 if(!trading){
1394                     require(_isExcludedFromFee[from] || _isExcludedFromFee[to] || isinwl[to], "Trading is not active.");
1395                 }
1396 
1397             
1398                 if (transferDelayEnabled){
1399                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1400                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1401                         _holderLastTransferTimestamp[tx.origin] = block.number;
1402                     }
1403                 }
1404             }
1405         }
1406 
1407         uint256 swapAmount = accumulatedForLiquid.add(accumulatedForMarketing).add(accumulatedForDev);
1408         bool overMinTokenBalance = swapAmount >= numTokensSellToAddToLiquidity;
1409         if (
1410             !inSwapAndLiquify &&
1411             from != uniswapV2Pair &&
1412             swapAndLiquifyEnabled &&
1413             overMinTokenBalance
1414         ) {
1415             //swap add liquid
1416             swapAndLiquify();
1417         }
1418         
1419         //indicates if fee should be deducted from transfer
1420         bool takeFee = true;
1421         
1422         //if any account belongs to _isExcludedFromFee account then remove the fee
1423         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (from != uniswapV2Pair && to != uniswapV2Pair)){
1424             takeFee = false;
1425         }
1426 
1427         //transfer amount, it will take tax, burn, liquidity fee
1428         _tokenTransfer(from,to,amount,takeFee);
1429     }
1430 
1431     function swapAndLiquify() private lockTheSwap {
1432 
1433         uint256 totalcontracttokens = accumulatedForDev.add(accumulatedForLiquid).add(accumulatedForMarketing);
1434         uint256 remainForDev = 0;
1435         uint256 remainForMarketing = 0;
1436         uint256 remainForLiq = 0;
1437         if (routerselllimit && totalcontracttokens > numTokensSellToAddToLiquidity.mul(20)){
1438             remainForDev = accumulatedForDev.div(20).mul(19);
1439             accumulatedForDev = accumulatedForDev.sub(remainForDev);
1440             remainForMarketing = accumulatedForMarketing.div(20).mul(19);
1441             accumulatedForMarketing = accumulatedForMarketing.sub(remainForMarketing);
1442             remainForLiq = accumulatedForLiquid.div(20).mul(19);
1443             accumulatedForLiquid = accumulatedForLiquid.sub(remainForLiq);
1444         }
1445         // split the liquidity balance into halves
1446         uint256 half = accumulatedForLiquid .div(2);
1447         uint256 otherHalf = accumulatedForLiquid.sub(half);
1448 
1449         uint256 swapAmount = half.add(accumulatedForMarketing).add(accumulatedForDev);
1450         // capture the contract's current ETH balance.
1451         // this is so that we can capture exactly the amount of ETH that the
1452         // swap creates, and not make the liquidity event include any ETH that
1453         // has been manually sent to the contract
1454         uint256 initialBalance = address(this).balance;
1455 
1456         // swap tokens for ETH
1457         swapTokensForEth(swapAmount); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1458 
1459         // how much ETH did we just swap into?
1460         uint256 delta = address(this).balance.sub(initialBalance);
1461 
1462         uint256 ethLiquid = delta.mul(half).div(swapAmount);
1463         uint256 ethMarketing = delta.mul(accumulatedForMarketing).div(swapAmount);
1464         uint256 ethDev = delta.sub(ethLiquid).sub(ethMarketing);
1465 
1466         if(ethLiquid > 0){
1467             // add liquidity to uniswap
1468             addLiquidity(otherHalf, ethLiquid);
1469             emit SwapAndLiquify(half, ethLiquid, otherHalf);
1470         }
1471 
1472         if(ethMarketing > 0){
1473             payable(marketingWallet).transfer(ethMarketing);
1474         }
1475 
1476         if(ethDev > 0){
1477             payable(devWallet).transfer(ethDev);
1478         }
1479         //Reset accumulated amount
1480         accumulatedForLiquid = remainForLiq;
1481         accumulatedForMarketing = remainForMarketing;
1482         accumulatedForDev = remainForDev;
1483     }
1484 
1485     function swapTokensForEth(uint256 tokenAmount) private {
1486         // generate the uniswap pair path of token -> weth
1487         address[] memory path = new address[](2);
1488         path[0] = address(this);
1489         path[1] = uniswapV2Router.WETH();
1490 
1491         _approve(address(this), address(uniswapV2Router), tokenAmount);
1492 
1493         // make the swap
1494         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1495             tokenAmount,
1496             0, // accept any amount of ETH
1497             path,
1498             address(this),
1499             block.timestamp
1500         );
1501     }
1502 
1503     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1504         // approve token transfer to cover all possible scenarios
1505         _approve(address(this), address(uniswapV2Router), tokenAmount);
1506 
1507         // add the liquidity
1508         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1509             address(this),
1510             tokenAmount,
1511             0, // slippage is unavoidable
1512             0, // slippage is unavoidable
1513             owner(),
1514             block.timestamp
1515         );
1516     }
1517 
1518     //this method is responsible for taking all fee, if takeFee is true
1519     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1520         if(!takeFee)
1521             removeAllFee();
1522         
1523         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1524             _transferFromExcluded(sender, recipient, amount);
1525         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1526             _transferToExcluded(sender, recipient, amount);
1527         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1528             _transferStandard(sender, recipient, amount);
1529         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1530             _transferBothExcluded(sender, recipient, amount);
1531         } else {
1532             _transferStandard(sender, recipient, amount);
1533         }
1534         
1535         if(!takeFee)
1536             restoreAllFee();
1537     }
1538 
1539     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1540         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingDevLiquidBurnFee) = _getValues(tAmount);
1541         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1542         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1543         _takeMarketingDevLiquidBurnFee(tMarketingDevLiquidBurnFee, sender);
1544         _reflectFee(rFee, tFee);
1545         emit Transfer(sender, recipient, tTransferAmount);
1546     }
1547 
1548     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1549         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingDevLiquidBurnFee) = _getValues(tAmount);
1550         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1551         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1552         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1553         _takeMarketingDevLiquidBurnFee(tMarketingDevLiquidBurnFee, sender);
1554         _reflectFee(rFee, tFee);
1555         emit Transfer(sender, recipient, tTransferAmount);
1556     }
1557 
1558     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1559         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingDevLiquidBurnFee) = _getValues(tAmount);
1560         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1561         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1562         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1563         _takeMarketingDevLiquidBurnFee(tMarketingDevLiquidBurnFee, sender);
1564         _reflectFee(rFee, tFee);
1565         emit Transfer(sender, recipient, tTransferAmount);
1566     }
1567 
1568     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1569         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingDevLiquidBurnFee) = _getValues(tAmount);
1570         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1571         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1572         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1573         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1574         _takeMarketingDevLiquidBurnFee(tMarketingDevLiquidBurnFee, sender);
1575         _reflectFee(rFee, tFee);
1576         emit Transfer(sender, recipient, tTransferAmount);
1577     }
1578 }