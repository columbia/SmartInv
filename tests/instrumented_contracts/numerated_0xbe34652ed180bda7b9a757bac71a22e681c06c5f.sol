1 // SPDX-License-Identifier: Unlicensed
2 
3 /*
4 www.kizoinu.com
5 www.t.me/kizoinu
6 */
7 
8 pragma solidity 0.8.13;
9 
10 abstract contract Context 
11 {
12     function _msgSender() internal view virtual returns (address) 
13     {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) 
18     {
19         return msg.data;
20     }
21 }
22 
23 /**
24  * @dev Interface of the ERC20 standard as defined in the EIP.
25  */
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address sender,
82         address recipient,
83         uint256 amount
84     ) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 /**
102  * @dev Interface for the optional metadata functions from the ERC20 standard.
103  *
104  * _Available since v4.1._
105  */
106 interface IERC20Metadata is IERC20 {
107     /**
108      * @dev Returns the name of the token.
109      */
110     function name() external view returns (string memory);
111 
112     /**
113      * @dev Returns the symbol of the token.
114      */
115     function symbol() external view returns (string memory);
116 
117     /**
118      * @dev Returns the decimals places of the token.
119      */
120     function decimals() external view returns (uint8);
121 }
122 
123 /**
124  * @dev Implementation of the {IERC20} interface.
125  *
126  * This implementation is agnostic to the way tokens are created. This means
127  * that a supply mechanism has to be added in a derived contract using this function
128  * For a generic mechanism see {ERC20PresetMinterPauser}.
129  *
130  * TIP: For a detailed writeup see our guide
131  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
132  * to implement supply mechanisms].
133  *
134  * We have followed general OpenZeppelin guidelines: functions revert instead
135  * of returning `false` on failure. This behavior is nonetheless conventional
136  * and does not conflict with the expectations of ERC20 applications.
137  *
138  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
139  * This allows applications to reconstruct the allowance for all accounts just
140  * by listening to said events. Other implementations of the EIP may not emit
141  * these events, as it isn't required by the specification.
142  *
143  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
144  * functions have been added to mitigate the well-known issues around setting
145  * allowances. See {IERC20-approve}.
146  */
147 contract ERC20 is Context, IERC20, IERC20Metadata {
148     mapping(address => uint256) private _balances;
149 
150     mapping(address => mapping(address => uint256)) private _allowances;
151 
152     uint256 private _totalSupply;
153 
154     string private _name;
155     string private _symbol;
156 
157     /**
158      * @dev Sets the values for {name} and {symbol}.
159      *
160      * The default value of {decimals} is 18. To select a different value for
161      * {decimals} you should overload it.
162      *
163      * All two of these values are immutable: they can only be set once during
164      * construction.
165      */
166     constructor(string memory name_, string memory symbol_) {
167         _name = name_;
168         _symbol = symbol_;
169     }
170 
171     /**
172      * @dev Returns the name of the token.
173      */
174     function name() public view virtual override returns (string memory) {
175         return _name;
176     }
177 
178     /**
179      * @dev Returns the symbol of the token, usually a shorter version of the
180      * name.
181      */
182     function symbol() public view virtual override returns (string memory) {
183         return _symbol;
184     }
185 
186     /**
187      * @dev Returns the number of decimals used to get its user representation.
188      * For example, if `decimals` equals `2`, a balance of `505` tokens should
189      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
190      *
191      * Tokens usually opt for a value of 18, imitating the relationship between
192      * Ether and Wei. This is the value {ERC20} uses, unless this function is
193      * overridden;
194      *
195      * NOTE: This information is only used for _display_ purposes: it in
196      * no way affects any of the arithmetic of the contract, including
197      * {IERC20-balanceOf} and {IERC20-transfer}.
198      */
199     function decimals() public view virtual override returns (uint8) {
200         return 18;
201     }
202 
203     /**
204      * @dev See {IERC20-totalSupply}.
205      */
206     function totalSupply() public view virtual override returns (uint256) {
207         return _totalSupply;
208     }
209 
210     /**
211      * @dev See {IERC20-balanceOf}.
212      */
213     function balanceOf(address account) public view virtual override returns (uint256) {
214         return _balances[account];
215     }
216 
217     /**
218      * @dev See {IERC20-transfer}.
219      *
220      * Requirements:
221      *
222      * - `recipient` cannot be the zero address.
223      * - the caller must have a balance of at least `amount`.
224      */
225     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
226         _transfer(_msgSender(), recipient, amount);
227         return true;
228     }
229 
230     /**
231      * @dev See {IERC20-allowance}.
232      */
233     function allowance(address owner, address spender) public view virtual override returns (uint256) {
234         return _allowances[owner][spender];
235     }
236 
237     /**
238      * @dev See {IERC20-approve}.
239      *
240      * Requirements:
241      *
242      * - `spender` cannot be the zero address.
243      */
244     function approve(address spender, uint256 amount) public virtual override returns (bool) {
245         _approve(_msgSender(), spender, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See {IERC20-transferFrom}.
251      *
252      * Emits an {Approval} event indicating the updated allowance. This is not
253      * required by the EIP. See the note at the beginning of {ERC20}.
254      *
255      * Requirements:
256      *
257      * - `sender` and `recipient` cannot be the zero address.
258      * - `sender` must have a balance of at least `amount`.
259      * - the caller must have allowance for ``sender``'s tokens of at least
260      * `amount`.
261      */
262     function transferFrom(
263         address sender,
264         address recipient,
265         uint256 amount
266     ) public virtual override returns (bool) {
267         _transfer(sender, recipient, amount);
268 
269         uint256 currentAllowance = _allowances[sender][_msgSender()];
270         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
271         unchecked {
272             _approve(sender, _msgSender(), currentAllowance - amount);
273         }
274 
275         return true;
276     }
277 
278     /**
279      * @dev Atomically increases the allowance granted to `spender` by the caller.
280      *
281      * This is an alternative to {approve} that can be used as a mitigation for
282      * problems described in {IERC20-approve}.
283      *
284      * Emits an {Approval} event indicating the updated allowance.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      */
290     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
291         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
292         return true;
293     }
294 
295     /**
296      * @dev Atomically decreases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to {approve} that can be used as a mitigation for
299      * problems described in {IERC20-approve}.
300      *
301      * Emits an {Approval} event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      * - `spender` must have allowance for the caller of at least
307      * `subtractedValue`.
308      */
309     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
310         uint256 currentAllowance = _allowances[_msgSender()][spender];
311         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
312         unchecked {
313             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
314         }
315 
316         return true;
317     }
318 
319     /**
320      * @dev Moves `amount` of tokens from `sender` to `recipient`.
321      *
322      * This internal function is equivalent to {transfer}, and can be used to
323      * e.g. implement automatic token fees, slashing mechanisms, etc.
324      *
325      * Emits a {Transfer} event.
326      *
327      * Requirements:
328      *
329      * - `sender` cannot be the zero address.
330      * - `recipient` cannot be the zero address.
331      * - `sender` must have a balance of at least `amount`.
332      */
333     function _transfer(
334         address sender,
335         address recipient,
336         uint256 amount
337     ) internal virtual {
338         require(sender != address(0), "ERC20: transfer from the zero address");
339         require(recipient != address(0), "ERC20: transfer to the zero address");
340 
341         _beforeTokenTransfer(sender, recipient, amount);
342 
343         uint256 senderBalance = _balances[sender];
344         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
345         unchecked {
346             _balances[sender] = senderBalance - amount;
347         }
348         _balances[recipient] += amount;
349 
350         emit Transfer(sender, recipient, amount);
351 
352         _afterTokenTransfer(sender, recipient, amount);
353     }
354 
355     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
356      * the total supply.
357      *
358      * Emits a {Transfer} event with `from` set to the zero address.
359      *
360      * Requirements:
361      *
362      * - `account` cannot be the zero address.
363      */
364     function _createInitialSupply(address account, uint256 amount) internal virtual {
365         require(account != address(0), "ERC20: mint to the zero address");
366 
367         _beforeTokenTransfer(address(0), account, amount);
368 
369         _totalSupply += amount;
370         _balances[account] += amount;
371         emit Transfer(address(0), account, amount);
372 
373         _afterTokenTransfer(address(0), account, amount);
374     }
375 
376     /**
377      * @dev Destroys `amount` tokens from `account`, reducing the
378      * total supply.
379      *
380      * Emits a {Transfer} event with `to` set to the zero address.
381      *
382      * Requirements:
383      *
384      * - `account` cannot be the zero address.
385      * - `account` must have at least `amount` tokens.
386      */
387     function _burn(address account, uint256 amount) internal virtual {
388         require(account != address(0), "ERC20: burn from the zero address");
389 
390         _beforeTokenTransfer(account, address(0), amount);
391 
392         uint256 accountBalance = _balances[account];
393         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
394         unchecked {
395             _balances[account] = accountBalance - amount;
396         }
397         _totalSupply -= amount;
398 
399         emit Transfer(account, address(0), amount);
400 
401         _afterTokenTransfer(account, address(0), amount);
402     }
403 
404     /**
405      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
406      *
407      * This internal function is equivalent to `approve`, and can be used to
408      * e.g. set automatic allowances for certain subsystems, etc.
409      *
410      * Emits an {Approval} event.
411      *
412      * Requirements:
413      *
414      * - `owner` cannot be the zero address.
415      * - `spender` cannot be the zero address.
416      */
417     function _approve(
418         address owner,
419         address spender,
420         uint256 amount
421     ) internal virtual {
422         require(owner != address(0), "ERC20: approve from the zero address");
423         require(spender != address(0), "ERC20: approve to the zero address");
424 
425         _allowances[owner][spender] = amount;
426         emit Approval(owner, spender, amount);
427     }
428 
429     /**
430      * @dev Hook that is called before any transfer of tokens. This includes
431      * minting and burning.
432      *
433      * Calling conditions:
434      *
435      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
436      * will be transferred to `to`.
437      * - when `from` is zero, `amount` tokens will be minted for `to`.
438      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
439      * - `from` and `to` are never both zero.
440      *
441      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
442      */
443     function _beforeTokenTransfer(
444         address from,
445         address to,
446         uint256 amount
447     ) internal virtual {}
448 
449     /**
450      * @dev Hook that is called after any transfer of tokens. This includes
451      * minting and burning.
452      *
453      * Calling conditions:
454      *
455      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
456      * has been transferred to `to`.
457      * - when `from` is zero, `amount` tokens have been minted for `to`.
458      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
459      * - `from` and `to` are never both zero.
460      *
461      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
462      */
463     function _afterTokenTransfer(
464         address from,
465         address to,
466         uint256 amount
467     ) internal virtual {}
468 }
469 
470 /**
471  * @dev Contract module which provides a basic access control mechanism, where
472  * there is an account (an owner) that can be granted exclusive access to
473  * specific functions.
474  *
475  * By default, the owner account will be the one that deploys the contract. This
476  * can later be changed with {transferOwnership}.
477  *
478  * This module is used through inheritance. It will make available the modifier
479  * `onlyOwner`, which can be applied to your functions to restrict their use to
480  * the owner.
481  */
482 abstract contract Ownable is Context {
483     address private _owner;
484 
485     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
486 
487     /**
488      * @dev Initializes the contract setting the deployer as the initial owner.
489      */
490     constructor() {
491         _setOwner(_msgSender());
492     }
493 
494     /**
495      * @dev Returns the address of the current owner.
496      */
497     function owner() public view virtual returns (address) {
498         return _owner;
499     }
500 
501     /**
502      * @dev Throws if called by any account other than the owner.
503      */
504     modifier onlyOwner() {
505         require(owner() == _msgSender(), "Ownable: caller is not the owner");
506         _;
507     }
508 
509     /**
510      * @dev Leaves the contract without owner. It will not be possible to call
511      * `onlyOwner` functions anymore. Can only be called by the current owner.
512      *
513      * NOTE: Renouncing ownership will leave the contract without an owner,
514      * thereby removing any functionality that is only available to the owner.
515      */
516     function renounceOwnership() public virtual onlyOwner {
517         _setOwner(address(0));
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Can only be called by the current owner.
523      */
524     function transferOwnership(address newOwner) public virtual onlyOwner {
525         require(newOwner != address(0), "Ownable: new owner is the zero address");
526         _setOwner(newOwner);
527     }
528 
529     function _setOwner(address newOwner) private {
530         address oldOwner = _owner;
531         _owner = newOwner;
532         emit OwnershipTransferred(oldOwner, newOwner);
533     }
534 }
535 
536 
537 interface IUniswapV2Router01 {
538     function factory() external pure returns (address);
539     function WETH() external pure returns (address);
540 
541     function addLiquidity(
542         address tokenA,
543         address tokenB,
544         uint amountADesired,
545         uint amountBDesired,
546         uint amountAMin,
547         uint amountBMin,
548         address to,
549         uint deadline
550     ) external returns (uint amountA, uint amountB, uint liquidity);
551     function addLiquidityETH(
552         address token,
553         uint amountTokenDesired,
554         uint amountTokenMin,
555         uint amountETHMin,
556         address to,
557         uint deadline
558     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
559     function removeLiquidity(
560         address tokenA,
561         address tokenB,
562         uint liquidity,
563         uint amountAMin,
564         uint amountBMin,
565         address to,
566         uint deadline
567     ) external returns (uint amountA, uint amountB);
568     function removeLiquidityETH(
569         address token,
570         uint liquidity,
571         uint amountTokenMin,
572         uint amountETHMin,
573         address to,
574         uint deadline
575     ) external returns (uint amountToken, uint amountETH);
576     function removeLiquidityWithPermit(
577         address tokenA,
578         address tokenB,
579         uint liquidity,
580         uint amountAMin,
581         uint amountBMin,
582         address to,
583         uint deadline,
584         bool approveMax, uint8 v, bytes32 r, bytes32 s
585     ) external returns (uint amountA, uint amountB);
586     function removeLiquidityETHWithPermit(
587         address token,
588         uint liquidity,
589         uint amountTokenMin,
590         uint amountETHMin,
591         address to,
592         uint deadline,
593         bool approveMax, uint8 v, bytes32 r, bytes32 s
594     ) external returns (uint amountToken, uint amountETH);
595     function swapExactTokensForTokens(
596         uint amountIn,
597         uint amountOutMin,
598         address[] calldata path,
599         address to,
600         uint deadline
601     ) external returns (uint[] memory amounts);
602     function swapTokensForExactTokens(
603         uint amountOut,
604         uint amountInMax,
605         address[] calldata path,
606         address to,
607         uint deadline
608     ) external returns (uint[] memory amounts);
609     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
610         external
611         payable
612         returns (uint[] memory amounts);
613     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
614         external
615         returns (uint[] memory amounts);
616     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
617         external
618         returns (uint[] memory amounts);
619     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
620         external
621         payable
622         returns (uint[] memory amounts);
623 
624     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
625     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
626     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
627     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
628     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
629 }
630 
631 interface IUniswapV2Router02 is IUniswapV2Router01 {
632     function removeLiquidityETHSupportingFeeOnTransferTokens(
633         address token,
634         uint liquidity,
635         uint amountTokenMin,
636         uint amountETHMin,
637         address to,
638         uint deadline
639     ) external returns (uint amountETH);
640     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
641         address token,
642         uint liquidity,
643         uint amountTokenMin,
644         uint amountETHMin,
645         address to,
646         uint deadline,
647         bool approveMax, uint8 v, bytes32 r, bytes32 s
648     ) external returns (uint amountETH);
649 
650     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
651         uint amountIn,
652         uint amountOutMin,
653         address[] calldata path,
654         address to,
655         uint deadline
656     ) external;
657     function swapExactETHForTokensSupportingFeeOnTransferTokens(
658         uint amountOutMin,
659         address[] calldata path,
660         address to,
661         uint deadline
662     ) external payable;
663     function swapExactTokensForETHSupportingFeeOnTransferTokens(
664         uint amountIn,
665         uint amountOutMin,
666         address[] calldata path,
667         address to,
668         uint deadline
669     ) external;
670 }
671 
672 interface IUniswapV2Factory {
673     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
674 
675     function feeTo() external view returns (address);
676     function feeToSetter() external view returns (address);
677 
678     function getPair(address tokenA, address tokenB) external view returns (address pair);
679     function allPairs(uint) external view returns (address pair);
680     function allPairsLength() external view returns (uint);
681 
682     function createPair(address tokenA, address tokenB) external returns (address pair);
683 
684     function setFeeTo(address) external;
685     function setFeeToSetter(address) external;
686 }
687 
688 /**
689  * @dev Wrappers over Solidity's arithmetic operations.
690  *
691  * NOTE: `SignedSafeMath` is no longer needed starting with Solidity 0.8. The compiler
692  * now has built in overflow checking.
693  */
694 library SignedSafeMath {
695     /**
696      * @dev Returns the multiplication of two signed integers, reverting on
697      * overflow.
698      *
699      * Counterpart to Solidity's `*` operator.
700      *
701      * Requirements:
702      *
703      * - Multiplication cannot overflow.
704      */
705     function mul(int256 a, int256 b) internal pure returns (int256) {
706         return a * b;
707     }
708 
709     /**
710      * @dev Returns the integer division of two signed integers. Reverts on
711      * division by zero. The result is rounded towards zero.
712      *
713      * Counterpart to Solidity's `/` operator.
714      *
715      * Requirements:
716      *
717      * - The divisor cannot be zero.
718      */
719     function div(int256 a, int256 b) internal pure returns (int256) {
720         return a / b;
721     }
722 
723     /**
724      * @dev Returns the subtraction of two signed integers, reverting on
725      * overflow.
726      *
727      * Counterpart to Solidity's `-` operator.
728      *
729      * Requirements:
730      *
731      * - Subtraction cannot overflow.
732      */
733     function sub(int256 a, int256 b) internal pure returns (int256) {
734         return a - b;
735     }
736 
737     /**
738      * @dev Returns the addition of two signed integers, reverting on
739      * overflow.
740      *
741      * Counterpart to Solidity's `+` operator.
742      *
743      * Requirements:
744      *
745      * - Addition cannot overflow.
746      */
747     function add(int256 a, int256 b) internal pure returns (int256) {
748         return a + b;
749     }
750 }
751 
752 // CAUTION
753 // This version of SafeMath should only be used with Solidity 0.8 or later,
754 // because it relies on the compiler's built in overflow checks.
755 
756 /**
757  * @dev Wrappers over Solidity's arithmetic operations.
758  *
759  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
760  * now has built in overflow checking.
761  */
762 library SafeMath {
763     /**
764      * @dev Returns the addition of two unsigned integers, with an overflow flag.
765      *
766      * _Available since v3.4._
767      */
768     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
769         unchecked {
770             uint256 c = a + b;
771             if (c < a) return (false, 0);
772             return (true, c);
773         }
774     }
775 
776     /**
777      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
778      *
779      * _Available since v3.4._
780      */
781     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
782         unchecked {
783             if (b > a) return (false, 0);
784             return (true, a - b);
785         }
786     }
787 
788     /**
789      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
790      *
791      * _Available since v3.4._
792      */
793     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
794         unchecked {
795             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
796             // benefit is lost if 'b' is also tested.
797             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
798             if (a == 0) return (true, 0);
799             uint256 c = a * b;
800             if (c / a != b) return (false, 0);
801             return (true, c);
802         }
803     }
804 
805     /**
806      * @dev Returns the division of two unsigned integers, with a division by zero flag.
807      *
808      * _Available since v3.4._
809      */
810     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
811         unchecked {
812             if (b == 0) return (false, 0);
813             return (true, a / b);
814         }
815     }
816 
817     /**
818      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
819      *
820      * _Available since v3.4._
821      */
822     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
823         unchecked {
824             if (b == 0) return (false, 0);
825             return (true, a % b);
826         }
827     }
828 
829     /**
830      * @dev Returns the addition of two unsigned integers, reverting on
831      * overflow.
832      *
833      * Counterpart to Solidity's `+` operator.
834      *
835      * Requirements:
836      *
837      * - Addition cannot overflow.
838      */
839     function add(uint256 a, uint256 b) internal pure returns (uint256) {
840         return a + b;
841     }
842 
843     /**
844      * @dev Returns the subtraction of two unsigned integers, reverting on
845      * overflow (when the result is negative).
846      *
847      * Counterpart to Solidity's `-` operator.
848      *
849      * Requirements:
850      *
851      * - Subtraction cannot overflow.
852      */
853     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
854         return a - b;
855     }
856 
857     /**
858      * @dev Returns the multiplication of two unsigned integers, reverting on
859      * overflow.
860      *
861      * Counterpart to Solidity's `*` operator.
862      *
863      * Requirements:
864      *
865      * - Multiplication cannot overflow.
866      */
867     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
868         return a * b;
869     }
870 
871     /**
872      * @dev Returns the integer division of two unsigned integers, reverting on
873      * division by zero. The result is rounded towards zero.
874      *
875      * Counterpart to Solidity's `/` operator.
876      *
877      * Requirements:
878      *
879      * - The divisor cannot be zero.
880      */
881     function div(uint256 a, uint256 b) internal pure returns (uint256) {
882         return a / b;
883     }
884 
885     /**
886      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
887      * reverting when dividing by zero.
888      *
889      * Counterpart to Solidity's `%` operator. This function uses a `revert`
890      * opcode (which leaves remaining gas untouched) while Solidity uses an
891      * invalid opcode to revert (consuming all remaining gas).
892      *
893      * Requirements:
894      *
895      * - The divisor cannot be zero.
896      */
897     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
898         return a % b;
899     }
900 
901     /**
902      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
903      * overflow (when the result is negative).
904      *
905      * CAUTION: This function is deprecated because it requires allocating memory for the error
906      * message unnecessarily. For custom revert reasons use {trySub}.
907      *
908      * Counterpart to Solidity's `-` operator.
909      *
910      * Requirements:
911      *
912      * - Subtraction cannot overflow.
913      */
914     function sub(
915         uint256 a,
916         uint256 b,
917         string memory errorMessage
918     ) internal pure returns (uint256) {
919         unchecked {
920             require(b <= a, errorMessage);
921             return a - b;
922         }
923     }
924 
925     /**
926      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
927      * division by zero. The result is rounded towards zero.
928      *
929      * Counterpart to Solidity's `/` operator. Note: this function uses a
930      * `revert` opcode (which leaves remaining gas untouched) while Solidity
931      * uses an invalid opcode to revert (consuming all remaining gas).
932      *
933      * Requirements:
934      *
935      * - The divisor cannot be zero.
936      */
937     function div(
938         uint256 a,
939         uint256 b,
940         string memory errorMessage
941     ) internal pure returns (uint256) {
942         unchecked {
943             require(b > 0, errorMessage);
944             return a / b;
945         }
946     }
947 
948     /**
949      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
950      * reverting with custom message when dividing by zero.
951      *
952      * CAUTION: This function is deprecated because it requires allocating memory for the error
953      * message unnecessarily. For custom revert reasons use {tryMod}.
954      *
955      * Counterpart to Solidity's `%` operator. This function uses a `revert`
956      * opcode (which leaves remaining gas untouched) while Solidity uses an
957      * invalid opcode to revert (consuming all remaining gas).
958      *
959      * Requirements:
960      *
961      * - The divisor cannot be zero.
962      */
963     function mod(
964         uint256 a,
965         uint256 b,
966         string memory errorMessage
967     ) internal pure returns (uint256) {
968         unchecked {
969             require(b > 0, errorMessage);
970             return a % b;
971         }
972     }
973 }
974 
975 /**
976  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
977  * checks.
978  *
979  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
980  * easily result in undesired exploitation or bugs, since developers usually
981  * assume that overflows raise errors. `SafeCast` restores this intuition by
982  * reverting the transaction when such an operation overflows.
983  *
984  * Using this library instead of the unchecked operations eliminates an entire
985  * class of bugs, so it's recommended to use it always.
986  *
987  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
988  * all math on `uint256` and `int256` and then downcasting.
989  */
990 library SafeCast {
991     /**
992      * @dev Returns the downcasted uint224 from uint256, reverting on
993      * overflow (when the input is greater than largest uint224).
994      *
995      * Counterpart to Solidity's `uint224` operator.
996      *
997      * Requirements:
998      *
999      * - input must fit into 224 bits
1000      */
1001     function toUint224(uint256 value) internal pure returns (uint224) {
1002         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1003         return uint224(value);
1004     }
1005 
1006     /**
1007      * @dev Returns the downcasted uint128 from uint256, reverting on
1008      * overflow (when the input is greater than largest uint128).
1009      *
1010      * Counterpart to Solidity's `uint128` operator.
1011      *
1012      * Requirements:
1013      *
1014      * - input must fit into 128 bits
1015      */
1016     function toUint128(uint256 value) internal pure returns (uint128) {
1017         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1018         return uint128(value);
1019     }
1020 
1021     /**
1022      * @dev Returns the downcasted uint96 from uint256, reverting on
1023      * overflow (when the input is greater than largest uint96).
1024      *
1025      * Counterpart to Solidity's `uint96` operator.
1026      *
1027      * Requirements:
1028      *
1029      * - input must fit into 96 bits
1030      */
1031     function toUint96(uint256 value) internal pure returns (uint96) {
1032         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1033         return uint96(value);
1034     }
1035 
1036     /**
1037      * @dev Returns the downcasted uint64 from uint256, reverting on
1038      * overflow (when the input is greater than largest uint64).
1039      *
1040      * Counterpart to Solidity's `uint64` operator.
1041      *
1042      * Requirements:
1043      *
1044      * - input must fit into 64 bits
1045      */
1046     function toUint64(uint256 value) internal pure returns (uint64) {
1047         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1048         return uint64(value);
1049     }
1050 
1051     /**
1052      * @dev Returns the downcasted uint32 from uint256, reverting on
1053      * overflow (when the input is greater than largest uint32).
1054      *
1055      * Counterpart to Solidity's `uint32` operator.
1056      *
1057      * Requirements:
1058      *
1059      * - input must fit into 32 bits
1060      */
1061     function toUint32(uint256 value) internal pure returns (uint32) {
1062         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1063         return uint32(value);
1064     }
1065 
1066     /**
1067      * @dev Returns the downcasted uint16 from uint256, reverting on
1068      * overflow (when the input is greater than largest uint16).
1069      *
1070      * Counterpart to Solidity's `uint16` operator.
1071      *
1072      * Requirements:
1073      *
1074      * - input must fit into 16 bits
1075      */
1076     function toUint16(uint256 value) internal pure returns (uint16) {
1077         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1078         return uint16(value);
1079     }
1080 
1081     /**
1082      * @dev Returns the downcasted uint8 from uint256, reverting on
1083      * overflow (when the input is greater than largest uint8).
1084      *
1085      * Counterpart to Solidity's `uint8` operator.
1086      *
1087      * Requirements:
1088      *
1089      * - input must fit into 8 bits.
1090      */
1091     function toUint8(uint256 value) internal pure returns (uint8) {
1092         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1093         return uint8(value);
1094     }
1095 
1096     /**
1097      * @dev Converts a signed int256 into an unsigned uint256.
1098      *
1099      * Requirements:
1100      *
1101      * - input must be greater than or equal to 0.
1102      */
1103     function toUint256(int256 value) internal pure returns (uint256) {
1104         require(value >= 0, "SafeCast: value must be positive");
1105         return uint256(value);
1106     }
1107 
1108     /**
1109      * @dev Returns the downcasted int128 from int256, reverting on
1110      * overflow (when the input is less than smallest int128 or
1111      * greater than largest int128).
1112      *
1113      * Counterpart to Solidity's `int128` operator.
1114      *
1115      * Requirements:
1116      *
1117      * - input must fit into 128 bits
1118      *
1119      * _Available since v3.1._
1120      */
1121     function toInt128(int256 value) internal pure returns (int128) {
1122         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1123         return int128(value);
1124     }
1125 
1126     /**
1127      * @dev Returns the downcasted int64 from int256, reverting on
1128      * overflow (when the input is less than smallest int64 or
1129      * greater than largest int64).
1130      *
1131      * Counterpart to Solidity's `int64` operator.
1132      *
1133      * Requirements:
1134      *
1135      * - input must fit into 64 bits
1136      *
1137      * _Available since v3.1._
1138      */
1139     function toInt64(int256 value) internal pure returns (int64) {
1140         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1141         return int64(value);
1142     }
1143 
1144     /**
1145      * @dev Returns the downcasted int32 from int256, reverting on
1146      * overflow (when the input is less than smallest int32 or
1147      * greater than largest int32).
1148      *
1149      * Counterpart to Solidity's `int32` operator.
1150      *
1151      * Requirements:
1152      *
1153      * - input must fit into 32 bits
1154      *
1155      * _Available since v3.1._
1156      */
1157     function toInt32(int256 value) internal pure returns (int32) {
1158         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1159         return int32(value);
1160     }
1161 
1162     /**
1163      * @dev Returns the downcasted int16 from int256, reverting on
1164      * overflow (when the input is less than smallest int16 or
1165      * greater than largest int16).
1166      *
1167      * Counterpart to Solidity's `int16` operator.
1168      *
1169      * Requirements:
1170      *
1171      * - input must fit into 16 bits
1172      *
1173      * _Available since v3.1._
1174      */
1175     function toInt16(int256 value) internal pure returns (int16) {
1176         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1177         return int16(value);
1178     }
1179 
1180     /**
1181      * @dev Returns the downcasted int8 from int256, reverting on
1182      * overflow (when the input is less than smallest int8 or
1183      * greater than largest int8).
1184      *
1185      * Counterpart to Solidity's `int8` operator.
1186      *
1187      * Requirements:
1188      *
1189      * - input must fit into 8 bits.
1190      *
1191      * _Available since v3.1._
1192      */
1193     function toInt8(int256 value) internal pure returns (int8) {
1194         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1195         return int8(value);
1196     }
1197 
1198     /**
1199      * @dev Converts an unsigned uint256 into a signed int256.
1200      *
1201      * Requirements:
1202      *
1203      * - input must be less than or equal to maxInt256.
1204      */
1205     function toInt256(uint256 value) internal pure returns (int256) {
1206         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1207         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1208         return int256(value);
1209     }
1210 }
1211 
1212 contract KIZOINU is ERC20, Ownable {
1213     using SafeMath for uint256;
1214 
1215     IUniswapV2Router02 public uniswapV2Router;
1216     address public immutable uniswapV2Pair;
1217 
1218     bool private inSwapAndLiquify;
1219 
1220     bool public swapAndLiquifyEnabled = true;
1221 
1222     bool public enableEarlySellTax = true;
1223 
1224     uint256 public maxSellTransactionAmount = 1000000 * (10**18);
1225     uint256 public maxBuyTransactionAmount = 10000 * (10**18);
1226     uint256 public swapTokensAtAmount = 1000 * (10**18);
1227     uint256 public maxWalletToken = 10000 * (10**18);
1228 
1229     uint256 private buyTotalFees = 0;
1230     uint256 public sellTotalFees = 0;
1231     uint256 public earlySellTotalFee = 20;
1232 
1233     // auto burn fee
1234     uint256 public burnFee = 0;
1235     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
1236     
1237 
1238     // distribute the collected tax percentage wise
1239     uint256 public liquidityPercent = 75; // 33% of total collected tax
1240     uint256 public marketingPercent = 15; // 34% of total collected tax
1241     uint256 public devPercent = 10; // 33% of total collected tax
1242 
1243 
1244     address payable public marketingWallet = payable(0x24f1d767ec16e8CfF97C46a08b014F6FAF84D503);
1245     address payable public devWallet = payable(0x4761842eB0555df3ADF154D0CB6e3e3C250f5B2f);
1246     
1247     // exlcude from fees and max transaction amount
1248     mapping (address => bool) private _isExcludedFromFees;
1249 
1250     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1251     // could be subject to a maximum transfer amount
1252     mapping (address => bool) public automatedMarketMakerPairs;
1253     mapping (address => uint256) public lastTxTimestamp;
1254 
1255     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1256 
1257     event ExcludeFromFees(address indexed account, bool isExcluded);
1258 
1259     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1260 
1261     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1262 
1263     event SwapAndLiquifyEnabledUpdated(bool enabled);
1264 
1265     event SwapAndLiquify(
1266         uint256 tokensIntoLiqudity,
1267         uint256 ethReceived
1268     );
1269 
1270     modifier lockTheSwap {
1271         inSwapAndLiquify = true;
1272         _;
1273         inSwapAndLiquify = false;
1274     }
1275 
1276     constructor() ERC20("Kizo Inu", "KIZO") {
1277 
1278     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // pancakeswap v2 router address
1279          // Create a uniswap pair for this new token
1280         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1281             .createPair(address(this), _uniswapV2Router.WETH());
1282 
1283         uniswapV2Router = _uniswapV2Router;
1284         uniswapV2Pair = _uniswapV2Pair;
1285 
1286         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1287 
1288         // exclude from paying fees or having max transaction amount
1289         excludeFromFees(owner(), true);
1290         excludeFromFees(marketingWallet, true);
1291         excludeFromFees(devWallet, true);
1292         excludeFromFees(address(this), true);
1293         
1294         /*
1295             an internal function that is only called here,
1296             and CANNOT be called ever again
1297         */
1298         _createInitialSupply(owner(), 1000000 * (10**18));
1299     }
1300 
1301     receive() external payable {
1302 
1303   	}
1304 
1305     function updateUniswapV2Router(address newAddress) public onlyOwner {
1306         require(newAddress != address(uniswapV2Router), "KCoin: The router already has that address");
1307         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1308         uniswapV2Router = IUniswapV2Router02(newAddress);
1309     }
1310 
1311     function excludeFromFees(address account, bool excluded) public onlyOwner {
1312         require(_isExcludedFromFees[account] != excluded, "KCoin: Account is already the value of 'excluded'");
1313         _isExcludedFromFees[account] = excluded;
1314 
1315         emit ExcludeFromFees(account, excluded);
1316     }
1317    
1318     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1319         require(pair != uniswapV2Pair, "KCoin: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1320 
1321         _setAutomatedMarketMakerPair(pair, value);
1322     }
1323 
1324     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1325         require(automatedMarketMakerPairs[pair] != value, "KCoin: Automated market maker pair is already set to that value");
1326         automatedMarketMakerPairs[pair] = value;
1327 
1328         emit SetAutomatedMarketMakerPair(pair, value);
1329     }
1330     
1331     function isExcludedFromFees(address account) public view returns(bool) {
1332         return _isExcludedFromFees[account];
1333     }
1334    
1335     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1336         swapAndLiquifyEnabled = _enabled;
1337         emit SwapAndLiquifyEnabledUpdated(_enabled);
1338     }
1339 
1340     function _transfer(address from, address to, uint256 amount) internal override 
1341     {
1342         require(from != address(0), "ERC20: transfer from the zero address");
1343         require(to != address(0), "ERC20: transfer to the zero address");
1344 
1345         if(amount == 0) { 
1346             super._transfer(from, to, 0);
1347             return;
1348         }
1349         
1350         if(automatedMarketMakerPairs[from] && (!_isExcludedFromFees[from]) && (!_isExcludedFromFees[to])) {
1351             require(amount <= maxBuyTransactionAmount, "amount exceeds the maxBuyTransactionAmount.");
1352             uint256 contractBalanceRecepient = balanceOf(to);
1353             require(contractBalanceRecepient + amount <= maxWalletToken,"Exceeds maximum wallet token amount.");
1354             lastTxTimestamp[to] = block.timestamp;
1355             
1356         }
1357 
1358         if(automatedMarketMakerPairs[to] && (!_isExcludedFromFees[from]) && (!_isExcludedFromFees[to])) {
1359             require(amount <= maxSellTransactionAmount, "amount exceeds the maxSellTransactionAmount.");
1360         }
1361         
1362 
1363     	uint256 contractTokenBalance = balanceOf(address(this));
1364         
1365         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
1366        
1367         if(
1368             overMinTokenBalance &&
1369             !inSwapAndLiquify &&
1370             automatedMarketMakerPairs[to] && 
1371             swapAndLiquifyEnabled
1372         ) {
1373             contractTokenBalance = swapTokensAtAmount;
1374             swapAndLiquify(contractTokenBalance);
1375         }
1376 
1377         uint256 fees = 0;
1378         uint256 burnShare = 0;
1379          // if any account belongs to _isExcludedFromFee account then remove the fee
1380         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
1381             uint256 _totalFees = buyTotalFees;
1382 
1383             if (automatedMarketMakerPairs[to]) {   
1384                 uint256 span = block.timestamp-lastTxTimestamp[from];
1385                 if(enableEarlySellTax && span <= 24 hours) {
1386                     _totalFees = earlySellTotalFee;
1387                 }
1388                 else if(!enableEarlySellTax) {
1389                     _totalFees = sellTotalFees;
1390                 }
1391             }
1392 
1393             fees = amount.mul(_totalFees).div(100);
1394             burnShare = amount.mul(burnFee).div(100);
1395             if(fees > 0) {
1396                 super._transfer(from, address(this), fees);
1397             }
1398 
1399             if(burnShare > 0) {
1400                 super._transfer(from, deadWallet, burnShare);
1401             }
1402 
1403             amount = amount.sub(fees.add(burnShare));
1404         }
1405 
1406         super._transfer(from, to, amount);
1407 
1408     }
1409 
1410      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1411         uint256 tokensForLiquidity = contractTokenBalance.mul(liquidityPercent).div(100);
1412         // split the Liquidity token balance into halves
1413         uint256 half = tokensForLiquidity.div(2);
1414         uint256 otherHalf = tokensForLiquidity.sub(half);
1415         // capture the contract's current ETH balance.
1416         // this is so that we can capture exactly the amount of ETH that the
1417         // swap creates, and not make the liquidity event include any ETH that
1418         // has been manually sent to the contract
1419         uint256 initialBalance = address(this).balance;
1420         // swap tokens for ETH
1421         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1422         // how much ETH did we just swap into?
1423         uint256 newBalance = address(this).balance.sub(initialBalance);
1424         // add liquidity to uniswap
1425         addLiquidity(otherHalf, newBalance);
1426         // swap and Send  Eth to marketing, dev wallets
1427         swapTokensForEth(contractTokenBalance.sub(tokensForLiquidity));
1428         marketingWallet.transfer(address(this).balance.mul(marketingPercent).div(marketingPercent.add(devPercent)));
1429         devWallet.transfer(address(this).balance);
1430         emit SwapAndLiquify(half, newBalance); 
1431     }
1432 
1433     function swapTokensForEth(uint256 tokenAmount) private {
1434 
1435         // generate the uniswap pair path of token -> weth
1436         address[] memory path = new address[](2);
1437         path[0] = address(this);
1438         path[1] = uniswapV2Router.WETH();
1439 
1440         if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) {
1441           _approve(address(this), address(uniswapV2Router), ~uint256(0));
1442         }
1443 
1444         // make the swap
1445         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1446             tokenAmount,
1447             0, // accept any amount of ETH
1448             path,
1449             address(this),
1450             block.timestamp
1451         );
1452         
1453     }
1454 
1455     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1456         
1457         // add the liquidity
1458         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1459             address(this),
1460             tokenAmount,
1461             0, // slippage is unavoidable
1462             0, // slippage is unavoidable
1463             owner(),
1464             block.timestamp
1465         );
1466         
1467     }
1468 
1469     function setMaxSellTransaction(uint256 _maxSellTxAmount) public onlyOwner {
1470         maxSellTransactionAmount = _maxSellTxAmount;
1471         require(maxSellTransactionAmount>totalSupply().div(1000), "value is too low");
1472     }
1473     
1474     function setMaxBuyTransaction(uint256 _maxBuyTxAmount) public onlyOwner {
1475         maxBuyTransactionAmount = _maxBuyTxAmount;
1476         require(maxBuyTransactionAmount>totalSupply().div(1000), "value is too low");
1477     }
1478 
1479     function setSwapTokensAtAmouunt(uint256 _newAmount) public onlyOwner {
1480         swapTokensAtAmount = _newAmount;
1481     }
1482 
1483     function setMarketingWallet(address payable wallet) public onlyOwner {
1484         marketingWallet = wallet;
1485     }
1486 
1487     function setDevWallet(address payable wallet) public onlyOwner {
1488         devWallet = wallet;
1489     }
1490 
1491     function updateBuyTotalTax(uint256 _buyTotalFees) public onlyOwner {
1492         buyTotalFees = _buyTotalFees;
1493         require(buyTotalFees <= 10, "Fee too high");
1494     }
1495 
1496    function updateSellTotalTax(uint256 _sellTotalFees) public onlyOwner {
1497         sellTotalFees = _sellTotalFees;
1498         require(sellTotalFees <= 10, "Fee too high");
1499     }
1500 
1501     function updateEarlySellTotalTax(uint256 _earlySellTotalFee) public onlyOwner {
1502         earlySellTotalFee = _earlySellTotalFee;
1503         require(earlySellTotalFee <= 20, "Fee too high");
1504     }
1505 
1506     function updateTaxDistributionPercentage(uint256 _liquidityPercent, uint256 _marketingPercent, uint256 _devPercent) public onlyOwner {
1507         require(_liquidityPercent.add(_marketingPercent).add(_devPercent) == 100, "total percentage must be equal to 100");
1508         liquidityPercent = _liquidityPercent;
1509         marketingPercent = _marketingPercent;
1510         devPercent = _devPercent;  
1511     }
1512 
1513     function setEarlySellTax(bool onoff) external onlyOwner  {
1514         enableEarlySellTax = onoff;
1515     }
1516 
1517     function setAutoBurn(uint256 _burnFee) external onlyOwner  {
1518         require(_burnFee <= 5, "value too high");
1519         burnFee = _burnFee;
1520     }
1521 
1522     function setMaxWalletToken(uint256 _maxToken) external onlyOwner {
1523         maxWalletToken = _maxToken;
1524         require(maxWalletToken>totalSupply().div(1000), "value is too low");
1525   	}
1526 
1527 }