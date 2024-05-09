1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.13;
4 
5 
6 /**
7  WOM https://linktr.ee/wiseoldman
8  *
9  * This contract is only required for intermediate, library-like contracts.
10  */
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 /**
23  * @dev Interface of the ERC20 standard as defined in the EIP.
24  */
25 interface IERC20 {
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `recipient`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `sender` to `recipient` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address sender,
81         address recipient,
82         uint256 amount
83     ) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /**
101  * @dev Interface for the optional metadata functions from the ERC20 standard.
102  *
103  * _Available since v4.1._
104  */
105 interface IERC20Metadata is IERC20 {
106     /**
107      * @dev Returns the name of the token.
108      */
109     function name() external view returns (string memory);
110 
111     /**
112      * @dev Returns the symbol of the token.
113      */
114     function symbol() external view returns (string memory);
115 
116     /**
117      * @dev Returns the decimals places of the token.
118      */
119     function decimals() external view returns (uint8);
120 }
121 
122 /**
123  * @dev Implementation of the {IERC20} interface.
124  *
125  * This implementation is agnostic to the way tokens are created. This means
126  * that a supply mechanism has to be added in a derived contract using this function
127  * For a generic mechanism see {ERC20PresetMinterPauser}.
128  *
129  * TIP: For a detailed writeup see our guide
130  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
131  * to implement supply mechanisms].
132  *
133  * We have followed general OpenZeppelin guidelines: functions revert instead
134  * of returning `false` on failure. This behavior is nonetheless conventional
135  * and does not conflict with the expectations of ERC20 applications.
136  *
137  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
138  * This allows applications to reconstruct the allowance for all accounts just
139  * by listening to said events. Other implementations of the EIP may not emit
140  * these events, as it isn't required by the specification.
141  *
142  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
143  * functions have been added to mitigate the well-known issues around setting
144  * allowances. See {IERC20-approve}.
145  */
146 contract ERC20 is Context, IERC20, IERC20Metadata {
147     mapping(address => uint256) private _balances;
148 
149     mapping(address => mapping(address => uint256)) private _allowances;
150 
151     uint256 private _totalSupply;
152 
153     string private _name;
154     string private _symbol;
155 
156     /**
157      * @dev Sets the values for {name} and {symbol}.
158      *
159      * The default value of {decimals} is 18. To select a different value for
160      * {decimals} you should overload it.
161      *
162      * All two of these values are immutable: they can only be set once during
163      * construction.
164      */
165     constructor(string memory name_, string memory symbol_) {
166         _name = name_;
167         _symbol = symbol_;
168     }
169 
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() public view virtual override returns (string memory) {
174         return _name;
175     }
176 
177     /**
178      * @dev Returns the symbol of the token, usually a shorter version of the
179      * name.
180      */
181     function symbol() public view virtual override returns (string memory) {
182         return _symbol;
183     }
184 
185     /**
186      * @dev Returns the number of decimals used to get its user representation.
187      * For example, if `decimals` equals `2`, a balance of `505` tokens should
188      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
189      *
190      * Tokens usually opt for a value of 18, imitating the relationship between
191      * Ether and Wei. This is the value {ERC20} uses, unless this function is
192      * overridden;
193      *
194      * NOTE: This information is only used for _display_ purposes: it in
195      * no way affects any of the arithmetic of the contract, including
196      * {IERC20-balanceOf} and {IERC20-transfer}.
197      */
198     function decimals() public view virtual override returns (uint8) {
199         return 18;
200     }
201 
202     /**
203      * @dev See {IERC20-totalSupply}.
204      */
205     function totalSupply() public view virtual override returns (uint256) {
206         return _totalSupply;
207     }
208 
209     /**
210      * @dev See {IERC20-balanceOf}.
211      */
212     function balanceOf(address account) public view virtual override returns (uint256) {
213         return _balances[account];
214     }
215 
216     /**
217      * @dev See {IERC20-transfer}.
218      *
219      * Requirements:
220      *
221      * - `recipient` cannot be the zero address.
222      * - the caller must have a balance of at least `amount`.
223      */
224     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
225         _transfer(_msgSender(), recipient, amount);
226         return true;
227     }
228 
229     /**
230      * @dev See {IERC20-allowance}.
231      */
232     function allowance(address owner, address spender) public view virtual override returns (uint256) {
233         return _allowances[owner][spender];
234     }
235 
236     /**
237      * @dev See {IERC20-approve}.
238      *
239      * Requirements:
240      *
241      * - `spender` cannot be the zero address.
242      */
243     function approve(address spender, uint256 amount) public virtual override returns (bool) {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     /**
249      * @dev See {IERC20-transferFrom}.
250      *
251      * Emits an {Approval} event indicating the updated allowance. This is not
252      * required by the EIP. See the note at the beginning of {ERC20}.
253      *
254      * Requirements:
255      *
256      * - `sender` and `recipient` cannot be the zero address.
257      * - `sender` must have a balance of at least `amount`.
258      * - the caller must have allowance for ``sender``'s tokens of at least
259      * `amount`.
260      */
261     function transferFrom(
262         address sender,
263         address recipient,
264         uint256 amount
265     ) public virtual override returns (bool) {
266         _transfer(sender, recipient, amount);
267 
268         uint256 currentAllowance = _allowances[sender][_msgSender()];
269         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
270         unchecked {
271             _approve(sender, _msgSender(), currentAllowance - amount);
272         }
273 
274         return true;
275     }
276 
277     /**
278      * @dev Atomically increases the allowance granted to `spender` by the caller.
279      *
280      * This is an alternative to {approve} that can be used as a mitigation for
281      * problems described in {IERC20-approve}.
282      *
283      * Emits an {Approval} event indicating the updated allowance.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
290         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
291         return true;
292     }
293 
294     /**
295      * @dev Atomically decreases the allowance granted to `spender` by the caller.
296      *
297      * This is an alternative to {approve} that can be used as a mitigation for
298      * problems described in {IERC20-approve}.
299      *
300      * Emits an {Approval} event indicating the updated allowance.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      * - `spender` must have allowance for the caller of at least
306      * `subtractedValue`.
307      */
308     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
309         uint256 currentAllowance = _allowances[_msgSender()][spender];
310         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
311         unchecked {
312             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
313         }
314 
315         return true;
316     }
317 
318     /**
319      * @dev Moves `amount` of tokens from `sender` to `recipient`.
320      *
321      * This internal function is equivalent to {transfer}, and can be used to
322      * e.g. implement automatic token fees, slashing mechanisms, etc.
323      *
324      * Emits a {Transfer} event.
325      *
326      * Requirements:
327      *
328      * - `sender` cannot be the zero address.
329      * - `recipient` cannot be the zero address.
330      * - `sender` must have a balance of at least `amount`.
331      */
332     function _transfer(
333         address sender,
334         address recipient,
335         uint256 amount
336     ) internal virtual {
337         require(sender != address(0), "ERC20: transfer from the zero address");
338         require(recipient != address(0), "ERC20: transfer to the zero address");
339 
340         _beforeTokenTransfer(sender, recipient, amount);
341 
342         uint256 senderBalance = _balances[sender];
343         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
344         unchecked {
345             _balances[sender] = senderBalance - amount;
346         }
347         _balances[recipient] += amount;
348 
349         emit Transfer(sender, recipient, amount);
350 
351         _afterTokenTransfer(sender, recipient, amount);
352     }
353 
354     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
355      * the total supply.
356      *
357      * Emits a {Transfer} event with `from` set to the zero address.
358      *
359      * Requirements:
360      *
361      * - `account` cannot be the zero address.
362      */
363     function _createInitialSupply(address account, uint256 amount) internal virtual {
364         require(account != address(0), "ERC20: mint to the zero address");
365 
366         _beforeTokenTransfer(address(0), account, amount);
367 
368         _totalSupply += amount;
369         _balances[account] += amount;
370         emit Transfer(address(0), account, amount);
371 
372         _afterTokenTransfer(address(0), account, amount);
373     }
374 
375     /**
376      * @dev Destroys `amount` tokens from `account`, reducing the
377      * total supply.
378      *
379      * Emits a {Transfer} event with `to` set to the zero address.
380      *
381      * Requirements:
382      *
383      * - `account` cannot be the zero address.
384      * - `account` must have at least `amount` tokens.
385      */
386     function _burn(address account, uint256 amount) internal virtual {
387         require(account != address(0), "ERC20: burn from the zero address");
388 
389         _beforeTokenTransfer(account, address(0), amount);
390 
391         uint256 accountBalance = _balances[account];
392         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
393         unchecked {
394             _balances[account] = accountBalance - amount;
395         }
396         _totalSupply -= amount;
397 
398         emit Transfer(account, address(0), amount);
399 
400         _afterTokenTransfer(account, address(0), amount);
401     }
402 
403     /**
404      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
405      *
406      * This internal function is equivalent to `approve`, and can be used to
407      * e.g. set automatic allowances for certain subsystems, etc.
408      *
409      * Emits an {Approval} event.
410      *
411      * Requirements:
412      *
413      * - `owner` cannot be the zero address.
414      * - `spender` cannot be the zero address.
415      */
416     function _approve(
417         address owner,
418         address spender,
419         uint256 amount
420     ) internal virtual {
421         require(owner != address(0), "ERC20: approve from the zero address");
422         require(spender != address(0), "ERC20: approve to the zero address");
423 
424         _allowances[owner][spender] = amount;
425         emit Approval(owner, spender, amount);
426     }
427 
428     /**
429      * @dev Hook that is called before any transfer of tokens. This includes
430      * minting and burning.
431      *
432      * Calling conditions:
433      *
434      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
435      * will be transferred to `to`.
436      * - when `from` is zero, `amount` tokens will be minted for `to`.
437      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
438      * - `from` and `to` are never both zero.
439      *
440      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
441      */
442     function _beforeTokenTransfer(
443         address from,
444         address to,
445         uint256 amount
446     ) internal virtual {}
447 
448     /**
449      * @dev Hook that is called after any transfer of tokens. This includes
450      * minting and burning.
451      *
452      * Calling conditions:
453      *
454      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
455      * has been transferred to `to`.
456      * - when `from` is zero, `amount` tokens have been minted for `to`.
457      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
458      * - `from` and `to` are never both zero.
459      *
460      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
461      */
462     function _afterTokenTransfer(
463         address from,
464         address to,
465         uint256 amount
466     ) internal virtual {}
467 }
468 
469 /**
470  * @dev Contract module which provides a basic access control mechanism, where
471  * there is an account (an owner) that can be granted exclusive access to
472  * specific functions.
473  *
474  * By default, the owner account will be the one that deploys the contract. This
475  * can later be changed with {transferOwnership}.
476  *
477  * This module is used through inheritance. It will make available the modifier
478  * `onlyOwner`, which can be applied to your functions to restrict their use to
479  * the owner.
480  */
481 abstract contract Ownable is Context {
482     address private _owner;
483 
484     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
485 
486     /**
487      * @dev Initializes the contract setting the deployer as the initial owner.
488      */
489     constructor() {
490         _setOwner(_msgSender());
491     }
492 
493     /**
494      * @dev Returns the address of the current owner.
495      */
496     function owner() public view virtual returns (address) {
497         return _owner;
498     }
499 
500     /**
501      * @dev Throws if called by any account other than the owner.
502      */
503     modifier onlyOwner() {
504         require(owner() == _msgSender(), "Ownable: caller is not the owner");
505         _;
506     }
507 
508     /**
509      * @dev Leaves the contract without owner. It will not be possible to call
510      * `onlyOwner` functions anymore. Can only be called by the current owner.
511      *
512      * NOTE: Renouncing ownership will leave the contract without an owner,
513      * thereby removing any functionality that is only available to the owner.
514      */
515     function renounceOwnership() public virtual onlyOwner {
516         _setOwner(address(0));
517     }
518 
519     /**
520      * @dev Transfers ownership of the contract to a new account (`newOwner`).
521      * Can only be called by the current owner.
522      */
523     function transferOwnership(address newOwner) public virtual onlyOwner {
524         require(newOwner != address(0), "Ownable: new owner is the zero address");
525         _setOwner(newOwner);
526     }
527 
528     function _setOwner(address newOwner) private {
529         address oldOwner = _owner;
530         _owner = newOwner;
531         emit OwnershipTransferred(oldOwner, newOwner);
532     }
533 }
534 
535 
536 interface IUniswapV2Router01 {
537     function factory() external pure returns (address);
538     function WETH() external pure returns (address);
539 
540     function addLiquidity(
541         address tokenA,
542         address tokenB,
543         uint amountADesired,
544         uint amountBDesired,
545         uint amountAMin,
546         uint amountBMin,
547         address to,
548         uint deadline
549     ) external returns (uint amountA, uint amountB, uint liquidity);
550     function addLiquidityETH(
551         address token,
552         uint amountTokenDesired,
553         uint amountTokenMin,
554         uint amountETHMin,
555         address to,
556         uint deadline
557     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
558     function removeLiquidity(
559         address tokenA,
560         address tokenB,
561         uint liquidity,
562         uint amountAMin,
563         uint amountBMin,
564         address to,
565         uint deadline
566     ) external returns (uint amountA, uint amountB);
567     function removeLiquidityETH(
568         address token,
569         uint liquidity,
570         uint amountTokenMin,
571         uint amountETHMin,
572         address to,
573         uint deadline
574     ) external returns (uint amountToken, uint amountETH);
575     function removeLiquidityWithPermit(
576         address tokenA,
577         address tokenB,
578         uint liquidity,
579         uint amountAMin,
580         uint amountBMin,
581         address to,
582         uint deadline,
583         bool approveMax, uint8 v, bytes32 r, bytes32 s
584     ) external returns (uint amountA, uint amountB);
585     function removeLiquidityETHWithPermit(
586         address token,
587         uint liquidity,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline,
592         bool approveMax, uint8 v, bytes32 r, bytes32 s
593     ) external returns (uint amountToken, uint amountETH);
594     function swapExactTokensForTokens(
595         uint amountIn,
596         uint amountOutMin,
597         address[] calldata path,
598         address to,
599         uint deadline
600     ) external returns (uint[] memory amounts);
601     function swapTokensForExactTokens(
602         uint amountOut,
603         uint amountInMax,
604         address[] calldata path,
605         address to,
606         uint deadline
607     ) external returns (uint[] memory amounts);
608     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
609         external
610         payable
611         returns (uint[] memory amounts);
612     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
613         external
614         returns (uint[] memory amounts);
615     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
616         external
617         returns (uint[] memory amounts);
618     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
619         external
620         payable
621         returns (uint[] memory amounts);
622 
623     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
624     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
625     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
626     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
627     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
628 }
629 
630 interface IUniswapV2Router02 is IUniswapV2Router01 {
631     function removeLiquidityETHSupportingFeeOnTransferTokens(
632         address token,
633         uint liquidity,
634         uint amountTokenMin,
635         uint amountETHMin,
636         address to,
637         uint deadline
638     ) external returns (uint amountETH);
639     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
640         address token,
641         uint liquidity,
642         uint amountTokenMin,
643         uint amountETHMin,
644         address to,
645         uint deadline,
646         bool approveMax, uint8 v, bytes32 r, bytes32 s
647     ) external returns (uint amountETH);
648 
649     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
650         uint amountIn,
651         uint amountOutMin,
652         address[] calldata path,
653         address to,
654         uint deadline
655     ) external;
656     function swapExactETHForTokensSupportingFeeOnTransferTokens(
657         uint amountOutMin,
658         address[] calldata path,
659         address to,
660         uint deadline
661     ) external payable;
662     function swapExactTokensForETHSupportingFeeOnTransferTokens(
663         uint amountIn,
664         uint amountOutMin,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external;
669 }
670 
671 interface IUniswapV2Factory {
672     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
673 
674     function feeTo() external view returns (address);
675     function feeToSetter() external view returns (address);
676 
677     function getPair(address tokenA, address tokenB) external view returns (address pair);
678     function allPairs(uint) external view returns (address pair);
679     function allPairsLength() external view returns (uint);
680 
681     function createPair(address tokenA, address tokenB) external returns (address pair);
682 
683     function setFeeTo(address) external;
684     function setFeeToSetter(address) external;
685 }
686 
687 /**
688  * @dev Wrappers over Solidity's arithmetic operations.
689  *
690  * NOTE: `SignedSafeMath` is no longer needed starting with Solidity 0.8. The compiler
691  * now has built in overflow checking.
692  */
693 library SignedSafeMath {
694     /**
695      * @dev Returns the multiplication of two signed integers, reverting on
696      * overflow.
697      *
698      * Counterpart to Solidity's `*` operator.
699      *
700      * Requirements:
701      *
702      * - Multiplication cannot overflow.
703      */
704     function mul(int256 a, int256 b) internal pure returns (int256) {
705         return a * b;
706     }
707 
708     /**
709      * @dev Returns the integer division of two signed integers. Reverts on
710      * division by zero. The result is rounded towards zero.
711      *
712      * Counterpart to Solidity's `/` operator.
713      *
714      * Requirements:
715      *
716      * - The divisor cannot be zero.
717      */
718     function div(int256 a, int256 b) internal pure returns (int256) {
719         return a / b;
720     }
721 
722     /**
723      * @dev Returns the subtraction of two signed integers, reverting on
724      * overflow.
725      *
726      * Counterpart to Solidity's `-` operator.
727      *
728      * Requirements:
729      *
730      * - Subtraction cannot overflow.
731      */
732     function sub(int256 a, int256 b) internal pure returns (int256) {
733         return a - b;
734     }
735 
736     /**
737      * @dev Returns the addition of two signed integers, reverting on
738      * overflow.
739      *
740      * Counterpart to Solidity's `+` operator.
741      *
742      * Requirements:
743      *
744      * - Addition cannot overflow.
745      */
746     function add(int256 a, int256 b) internal pure returns (int256) {
747         return a + b;
748     }
749 }
750 
751 // CAUTION
752 // This version of SafeMath should only be used with Solidity 0.8 or later,
753 // because it relies on the compiler's built in overflow checks.
754 
755 /**
756  * @dev Wrappers over Solidity's arithmetic operations.
757  *
758  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
759  * now has built in overflow checking.
760  */
761 library SafeMath {
762     /**
763      * @dev Returns the addition of two unsigned integers, with an overflow flag.
764      *
765      * _Available since v3.4._
766      */
767     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
768         unchecked {
769             uint256 c = a + b;
770             if (c < a) return (false, 0);
771             return (true, c);
772         }
773     }
774 
775     /**
776      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
777      *
778      * _Available since v3.4._
779      */
780     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
781         unchecked {
782             if (b > a) return (false, 0);
783             return (true, a - b);
784         }
785     }
786 
787     /**
788      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
789      *
790      * _Available since v3.4._
791      */
792     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
793         unchecked {
794             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
795             // benefit is lost if 'b' is also tested.
796             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
797             if (a == 0) return (true, 0);
798             uint256 c = a * b;
799             if (c / a != b) return (false, 0);
800             return (true, c);
801         }
802     }
803 
804     /**
805      * @dev Returns the division of two unsigned integers, with a division by zero flag.
806      *
807      * _Available since v3.4._
808      */
809     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
810         unchecked {
811             if (b == 0) return (false, 0);
812             return (true, a / b);
813         }
814     }
815 
816     /**
817      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
818      *
819      * _Available since v3.4._
820      */
821     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
822         unchecked {
823             if (b == 0) return (false, 0);
824             return (true, a % b);
825         }
826     }
827 
828     /**
829      * @dev Returns the addition of two unsigned integers, reverting on
830      * overflow.
831      *
832      * Counterpart to Solidity's `+` operator.
833      *
834      * Requirements:
835      *
836      * - Addition cannot overflow.
837      */
838     function add(uint256 a, uint256 b) internal pure returns (uint256) {
839         return a + b;
840     }
841 
842     /**
843      * @dev Returns the subtraction of two unsigned integers, reverting on
844      * overflow (when the result is negative).
845      *
846      * Counterpart to Solidity's `-` operator.
847      *
848      * Requirements:
849      *
850      * - Subtraction cannot overflow.
851      */
852     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
853         return a - b;
854     }
855 
856     /**
857      * @dev Returns the multiplication of two unsigned integers, reverting on
858      * overflow.
859      *
860      * Counterpart to Solidity's `*` operator.
861      *
862      * Requirements:
863      *
864      * - Multiplication cannot overflow.
865      */
866     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
867         return a * b;
868     }
869 
870     /**
871      * @dev Returns the integer division of two unsigned integers, reverting on
872      * division by zero. The result is rounded towards zero.
873      *
874      * Counterpart to Solidity's `/` operator.
875      *
876      * Requirements:
877      *
878      * - The divisor cannot be zero.
879      */
880     function div(uint256 a, uint256 b) internal pure returns (uint256) {
881         return a / b;
882     }
883 
884     /**
885      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
886      * reverting when dividing by zero.
887      *
888      * Counterpart to Solidity's `%` operator. This function uses a `revert`
889      * opcode (which leaves remaining gas untouched) while Solidity uses an
890      * invalid opcode to revert (consuming all remaining gas).
891      *
892      * Requirements:
893      *
894      * - The divisor cannot be zero.
895      */
896     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
897         return a % b;
898     }
899 
900     /**
901      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
902      * overflow (when the result is negative).
903      *
904      * CAUTION: This function is deprecated because it requires allocating memory for the error
905      * message unnecessarily. For custom revert reasons use {trySub}.
906      *
907      * Counterpart to Solidity's `-` operator.
908      *
909      * Requirements:
910      *
911      * - Subtraction cannot overflow.
912      */
913     function sub(
914         uint256 a,
915         uint256 b,
916         string memory errorMessage
917     ) internal pure returns (uint256) {
918         unchecked {
919             require(b <= a, errorMessage);
920             return a - b;
921         }
922     }
923 
924     /**
925      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
926      * division by zero. The result is rounded towards zero.
927      *
928      * Counterpart to Solidity's `/` operator. Note: this function uses a
929      * `revert` opcode (which leaves remaining gas untouched) while Solidity
930      * uses an invalid opcode to revert (consuming all remaining gas).
931      *
932      * Requirements:
933      *
934      * - The divisor cannot be zero.
935      */
936     function div(
937         uint256 a,
938         uint256 b,
939         string memory errorMessage
940     ) internal pure returns (uint256) {
941         unchecked {
942             require(b > 0, errorMessage);
943             return a / b;
944         }
945     }
946 
947     /**
948      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
949      * reverting with custom message when dividing by zero.
950      *
951      * CAUTION: This function is deprecated because it requires allocating memory for the error
952      * message unnecessarily. For custom revert reasons use {tryMod}.
953      *
954      * Counterpart to Solidity's `%` operator. This function uses a `revert`
955      * opcode (which leaves remaining gas untouched) while Solidity uses an
956      * invalid opcode to revert (consuming all remaining gas).
957      *
958      * Requirements:
959      *
960      * - The divisor cannot be zero.
961      */
962     function mod(
963         uint256 a,
964         uint256 b,
965         string memory errorMessage
966     ) internal pure returns (uint256) {
967         unchecked {
968             require(b > 0, errorMessage);
969             return a % b;
970         }
971     }
972 }
973 
974 /**
975  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
976  * checks.
977  *
978  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
979  * easily result in undesired exploitation or bugs, since developers usually
980  * assume that overflows raise errors. `SafeCast` restores this intuition by
981  * reverting the transaction when such an operation overflows.
982  *
983  * Using this library instead of the unchecked operations eliminates an entire
984  * class of bugs, so it's recommended to use it always.
985  *
986  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
987  * all math on `uint256` and `int256` and then downcasting.
988  */
989 library SafeCast {
990     /**
991      * @dev Returns the downcasted uint224 from uint256, reverting on
992      * overflow (when the input is greater than largest uint224).
993      *
994      * Counterpart to Solidity's `uint224` operator.
995      *
996      * Requirements:
997      *
998      * - input must fit into 224 bits
999      */
1000     function toUint224(uint256 value) internal pure returns (uint224) {
1001         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1002         return uint224(value);
1003     }
1004 
1005     /**
1006      * @dev Returns the downcasted uint128 from uint256, reverting on
1007      * overflow (when the input is greater than largest uint128).
1008      *
1009      * Counterpart to Solidity's `uint128` operator.
1010      *
1011      * Requirements:
1012      *
1013      * - input must fit into 128 bits
1014      */
1015     function toUint128(uint256 value) internal pure returns (uint128) {
1016         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1017         return uint128(value);
1018     }
1019 
1020     /**
1021      * @dev Returns the downcasted uint96 from uint256, reverting on
1022      * overflow (when the input is greater than largest uint96).
1023      *
1024      * Counterpart to Solidity's `uint96` operator.
1025      *
1026      * Requirements:
1027      *
1028      * - input must fit into 96 bits
1029      */
1030     function toUint96(uint256 value) internal pure returns (uint96) {
1031         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1032         return uint96(value);
1033     }
1034 
1035     /**
1036      * @dev Returns the downcasted uint64 from uint256, reverting on
1037      * overflow (when the input is greater than largest uint64).
1038      *
1039      * Counterpart to Solidity's `uint64` operator.
1040      *
1041      * Requirements:
1042      *
1043      * - input must fit into 64 bits
1044      */
1045     function toUint64(uint256 value) internal pure returns (uint64) {
1046         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1047         return uint64(value);
1048     }
1049 
1050     /**
1051      * @dev Returns the downcasted uint32 from uint256, reverting on
1052      * overflow (when the input is greater than largest uint32).
1053      *
1054      * Counterpart to Solidity's `uint32` operator.
1055      *
1056      * Requirements:
1057      *
1058      * - input must fit into 32 bits
1059      */
1060     function toUint32(uint256 value) internal pure returns (uint32) {
1061         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1062         return uint32(value);
1063     }
1064 
1065     /**
1066      * @dev Returns the downcasted uint16 from uint256, reverting on
1067      * overflow (when the input is greater than largest uint16).
1068      *
1069      * Counterpart to Solidity's `uint16` operator.
1070      *
1071      * Requirements:
1072      *
1073      * - input must fit into 16 bits
1074      */
1075     function toUint16(uint256 value) internal pure returns (uint16) {
1076         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1077         return uint16(value);
1078     }
1079 
1080     /**
1081      * @dev Returns the downcasted uint8 from uint256, reverting on
1082      * overflow (when the input is greater than largest uint8).
1083      *
1084      * Counterpart to Solidity's `uint8` operator.
1085      *
1086      * Requirements:
1087      *
1088      * - input must fit into 8 bits.
1089      */
1090     function toUint8(uint256 value) internal pure returns (uint8) {
1091         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1092         return uint8(value);
1093     }
1094 
1095     /**
1096      * @dev Converts a signed int256 into an unsigned uint256.
1097      *
1098      * Requirements:
1099      *
1100      * - input must be greater than or equal to 0.
1101      */
1102     function toUint256(int256 value) internal pure returns (uint256) {
1103         require(value >= 0, "SafeCast: value must be positive");
1104         return uint256(value);
1105     }
1106 
1107     /**
1108      * @dev Returns the downcasted int128 from int256, reverting on
1109      * overflow (when the input is less than smallest int128 or
1110      * greater than largest int128).
1111      *
1112      * Counterpart to Solidity's `int128` operator.
1113      *
1114      * Requirements:
1115      *
1116      * - input must fit into 128 bits
1117      *
1118      * _Available since v3.1._
1119      */
1120     function toInt128(int256 value) internal pure returns (int128) {
1121         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1122         return int128(value);
1123     }
1124 
1125     /**
1126      * @dev Returns the downcasted int64 from int256, reverting on
1127      * overflow (when the input is less than smallest int64 or
1128      * greater than largest int64).
1129      *
1130      * Counterpart to Solidity's `int64` operator.
1131      *
1132      * Requirements:
1133      *
1134      * - input must fit into 64 bits
1135      *
1136      * _Available since v3.1._
1137      */
1138     function toInt64(int256 value) internal pure returns (int64) {
1139         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1140         return int64(value);
1141     }
1142 
1143     /**
1144      * @dev Returns the downcasted int32 from int256, reverting on
1145      * overflow (when the input is less than smallest int32 or
1146      * greater than largest int32).
1147      *
1148      * Counterpart to Solidity's `int32` operator.
1149      *
1150      * Requirements:
1151      *
1152      * - input must fit into 32 bits
1153      *
1154      * _Available since v3.1._
1155      */
1156     function toInt32(int256 value) internal pure returns (int32) {
1157         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1158         return int32(value);
1159     }
1160 
1161     /**
1162      * @dev Returns the downcasted int16 from int256, reverting on
1163      * overflow (when the input is less than smallest int16 or
1164      * greater than largest int16).
1165      *
1166      * Counterpart to Solidity's `int16` operator.
1167      *
1168      * Requirements:
1169      *
1170      * - input must fit into 16 bits
1171      *
1172      * _Available since v3.1._
1173      */
1174     function toInt16(int256 value) internal pure returns (int16) {
1175         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1176         return int16(value);
1177     }
1178 
1179     /**
1180      * @dev Returns the downcasted int8 from int256, reverting on
1181      * overflow (when the input is less than smallest int8 or
1182      * greater than largest int8).
1183      *
1184      * Counterpart to Solidity's `int8` operator.
1185      *
1186      * Requirements:
1187      *
1188      * - input must fit into 8 bits.
1189      *
1190      * _Available since v3.1._
1191      */
1192     function toInt8(int256 value) internal pure returns (int8) {
1193         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1194         return int8(value);
1195     }
1196 
1197     /**
1198      * @dev Converts an unsigned uint256 into a signed int256.
1199      *
1200      * Requirements:
1201      *
1202      * - input must be less than or equal to maxInt256.
1203      */
1204     function toInt256(uint256 value) internal pure returns (int256) {
1205         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1206         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1207         return int256(value);
1208     }
1209 }
1210 
1211 contract WOM is ERC20, Ownable {
1212     using SafeMath for uint256;
1213 
1214     bool public swapAndLiquifyEnabled = true;
1215     bool private inSwapAndLiquify;
1216 
1217     uint256 public maxTransactionAmount = 21470 * (10**18);
1218     uint256 public swapTokensAtAmount = 1000 * (10**18);
1219     uint256 public maxWalletToken = 53675 * (10**18); 
1220 
1221     uint256 public liquidityFee = 1;
1222     uint256 public marketingFee = 3;
1223     uint256 public devFee = 1;
1224     uint256 private totalFees = liquidityFee.add(devFee).add(marketingFee);
1225 
1226     IUniswapV2Router02 public uniswapV2Router;
1227     address public immutable uniswapV2Pair;
1228 
1229     address payable public devWallet = payable(0x4052a3e9B436252297149f3d5E6f4Dc40Fa33888); 
1230     address payable public marketingWallet = payable(0x1ac1479bA7C763c069AdF5AE83882263184f1407);
1231     
1232     // exlcude from fees and max transaction amount
1233     mapping (address => bool) private _isExcludedFromFees;
1234 
1235      modifier lockTheSwap {
1236         inSwapAndLiquify = true;
1237         _;
1238         inSwapAndLiquify = false;
1239     }
1240 
1241     event SwapAndLiquify(uint256 tokensIntoLiqudity, uint256 ethReceived);
1242     event SwapAndLiquifyEnabledUpdated(bool enabled);
1243 
1244     event SwapETHForTokens(uint256 amountIn, address[] path);
1245 
1246     event ExcludeFromFees(address indexed account, bool isExcluded);
1247 
1248     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1249 
1250     constructor() ERC20("Wise Old Man", "WOM") {
1251     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // uniswap v2 router address
1252          // Create a uniswap pair for this new token
1253         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1254             .createPair(address(this), _uniswapV2Router.WETH());
1255 
1256         uniswapV2Router = _uniswapV2Router;
1257         uniswapV2Pair = _uniswapV2Pair;
1258 
1259         // exclude from paying fees and max transaction amount
1260         excludeFromFees(owner(), true);
1261         excludeFromFees(marketingWallet, true);
1262         excludeFromFees(devWallet, true);
1263         excludeFromFees(address(this), true);
1264         
1265         /*
1266           an internal function that is only called here, and CANNOT be called ever again
1267         */
1268         _createInitialSupply(owner(), 2147000 * (10**18));
1269     }
1270 
1271     receive() external payable {
1272 
1273     }
1274 
1275     function excludeFromFees(address account, bool excluded) public onlyOwner {
1276         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
1277         _isExcludedFromFees[account] = excluded;
1278         emit ExcludeFromFees(account, excluded);
1279     }
1280     
1281     function isExcludedFromFees(address account) public view returns(bool) {
1282         return _isExcludedFromFees[account];
1283     }
1284    
1285     function _transfer(
1286         address from,
1287         address to,
1288         uint256 amount
1289     ) internal override {
1290         require(from != address(0), "ERC20: transfer from the zero address");
1291         require(to != address(0), "ERC20: transfer to the zero address");
1292 
1293         if(amount == 0) {
1294             super._transfer(from, to, 0);
1295             return;
1296         }
1297 
1298         bool excludedAccount = _isExcludedFromFees[from] || _isExcludedFromFees[to];
1299         
1300         if (from == uniswapV2Pair && !excludedAccount) {
1301             
1302             uint256 contractBalanceRecepient = balanceOf(to);
1303             require(contractBalanceRecepient + amount <= maxWalletToken, "Exceeds maximum wallet token amount.");
1304         }
1305         
1306         if(to == uniswapV2Pair && (!_isExcludedFromFees[from]) && (!_isExcludedFromFees[to])){
1307             require(amount <= maxTransactionAmount, "amount exceeds the maxTransactionAmount.");
1308         }
1309         
1310     	uint256 contractTokenBalance = balanceOf(address(this));
1311         
1312         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
1313        
1314         if(overMinTokenBalance && !inSwapAndLiquify && to == uniswapV2Pair && swapAndLiquifyEnabled) {
1315 
1316             contractTokenBalance = swapTokensAtAmount;
1317             swapAndLiquify(contractTokenBalance);
1318 
1319         }
1320 
1321          // if any account belongs to _isExcludedFromFee account then remove the fee
1322         if(!excludedAccount) {
1323             uint256 fees;
1324             if(from == uniswapV2Pair || to == uniswapV2Pair) {
1325               fees  = amount.mul(totalFees).div(100);
1326             }
1327 
1328         	amount = amount.sub(fees);
1329 
1330             super._transfer(from, address(this), fees); 
1331             
1332         }
1333 
1334         super._transfer(from, to, amount);
1335 
1336     }
1337 
1338      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1339         uint256 tokensForLiquidity = contractTokenBalance.mul(liquidityFee).div(totalFees);
1340         // split the Liquidity token balance into halves
1341         uint256 half = tokensForLiquidity.div(2);
1342         uint256 otherHalf = tokensForLiquidity.sub(half);
1343 
1344         // capture the contract's current ETH balance.
1345         // this is so that we can capture exactly the amount of ETH that the
1346         // swap creates, and not make the liquidity event include any ETH that
1347         // has been manually sent to the contract
1348         uint256 initialBalance = address(this).balance;
1349 
1350         // swap tokens for ETH
1351         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1352 
1353         // how much ETH did we just swap into?
1354         uint256 newBalance = address(this).balance.sub(initialBalance);
1355 
1356         // add liquidity to uniswap
1357         addLiquidity(otherHalf, newBalance);
1358 
1359         // swap and Send eth to team wallet
1360         swapTokensForEth(contractTokenBalance.sub(tokensForLiquidity));
1361         devWallet.transfer(address(this).balance.mul(devFee).div(marketingFee.add(devFee)));
1362         marketingWallet.transfer(address(this).balance);
1363         
1364         emit SwapAndLiquify(half, newBalance); 
1365     }
1366 
1367     function swapTokensForEth(uint256 tokenAmount) private {
1368 
1369         // generate the uniswap pair path of token -> weth
1370         address[] memory path = new address[](2);
1371         path[0] = address(this);
1372         path[1] = uniswapV2Router.WETH();
1373 
1374         if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) {
1375           _approve(address(this), address(uniswapV2Router), ~uint256(0));
1376         }
1377 
1378         // make the swap
1379         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1380             tokenAmount,
1381             0, // accept any amount of ETH
1382             path,
1383             address(this),
1384             block.timestamp
1385         );
1386         
1387     }
1388 
1389     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1390         
1391         // add the liquidity
1392         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1393             address(this),
1394             tokenAmount,
1395             0, // slippage is unavoidable
1396             0, // slippage is unavoidable
1397             owner(),
1398             block.timestamp
1399         );
1400         
1401     }
1402 
1403     function setMaxWalletToken(uint256 _maxToken) external onlyOwner {
1404   	    maxWalletToken = _maxToken;
1405         require(maxWalletToken >= totalSupply().div(200), "value is too low");
1406   	}
1407 
1408     function setMaxTxAmount(uint256 _maxTx) public onlyOwner {
1409         maxTransactionAmount = _maxTx;
1410         require(maxTransactionAmount >= totalSupply().div(2000), "value is too low");
1411     }
1412 
1413     function setSwapTokensAtAmouunt(uint256 _newAmount) public onlyOwner {
1414         swapTokensAtAmount = _newAmount;
1415     }
1416 
1417     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1418         swapAndLiquifyEnabled = _enabled;
1419         emit SwapAndLiquifyEnabledUpdated(_enabled);
1420     }
1421   
1422 }