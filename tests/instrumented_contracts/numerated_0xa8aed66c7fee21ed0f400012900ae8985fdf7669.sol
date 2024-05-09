1 // SPDX-License-Identifier: Unlicensed
2 
3 /*
4 Twitter : https://twitter.com/CHUCKINUERC
5 Website : https://www.chuckinu.com/
6 Telegram : https://t.me/CHUCKINUERC
7 */
8 
9 pragma solidity 0.8.13;
10 
11 abstract contract Context 
12 {
13     function _msgSender() internal view virtual returns (address) 
14     {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) 
19     {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @dev Interface for the optional metadata functions from the ERC20 standard.
104  *
105  * _Available since v4.1._
106  */
107 interface IERC20Metadata is IERC20 {
108     /**
109      * @dev Returns the name of the token.
110      */
111     function name() external view returns (string memory);
112 
113     /**
114      * @dev Returns the symbol of the token.
115      */
116     function symbol() external view returns (string memory);
117 
118     /**
119      * @dev Returns the decimals places of the token.
120      */
121     function decimals() external view returns (uint8);
122 }
123 
124 /**
125  * @dev Implementation of the {IERC20} interface.
126  *
127  * This implementation is agnostic to the way tokens are created. This means
128  * that a supply mechanism has to be added in a derived contract using this function
129  * For a generic mechanism see {ERC20PresetMinterPauser}.
130  *
131  * TIP: For a detailed writeup see our guide
132  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
133  * to implement supply mechanisms].
134  *
135  * We have followed general OpenZeppelin guidelines: functions revert instead
136  * of returning `false` on failure. This behavior is nonetheless conventional
137  * and does not conflict with the expectations of ERC20 applications.
138  *
139  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
140  * This allows applications to reconstruct the allowance for all accounts just
141  * by listening to said events. Other implementations of the EIP may not emit
142  * these events, as it isn't required by the specification.
143  *
144  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
145  * functions have been added to mitigate the well-known issues around setting
146  * allowances. See {IERC20-approve}.
147  */
148 contract ERC20 is Context, IERC20, IERC20Metadata {
149     mapping(address => uint256) private _balances;
150 
151     mapping(address => mapping(address => uint256)) private _allowances;
152 
153     uint256 private _totalSupply;
154 
155     string private _name;
156     string private _symbol;
157 
158     /**
159      * @dev Sets the values for {name} and {symbol}.
160      *
161      * The default value of {decimals} is 18. To select a different value for
162      * {decimals} you should overload it.
163      *
164      * All two of these values are immutable: they can only be set once during
165      * construction.
166      */
167     constructor(string memory name_, string memory symbol_) {
168         _name = name_;
169         _symbol = symbol_;
170     }
171 
172     /**
173      * @dev Returns the name of the token.
174      */
175     function name() public view virtual override returns (string memory) {
176         return _name;
177     }
178 
179     /**
180      * @dev Returns the symbol of the token, usually a shorter version of the
181      * name.
182      */
183     function symbol() public view virtual override returns (string memory) {
184         return _symbol;
185     }
186 
187     /**
188      * @dev Returns the number of decimals used to get its user representation.
189      * For example, if `decimals` equals `2`, a balance of `505` tokens should
190      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
191      *
192      * Tokens usually opt for a value of 18, imitating the relationship between
193      * Ether and Wei. This is the value {ERC20} uses, unless this function is
194      * overridden;
195      *
196      * NOTE: This information is only used for _display_ purposes: it in
197      * no way affects any of the arithmetic of the contract, including
198      * {IERC20-balanceOf} and {IERC20-transfer}.
199      */
200     function decimals() public view virtual override returns (uint8) {
201         return 18;
202     }
203 
204     /**
205      * @dev See {IERC20-totalSupply}.
206      */
207     function totalSupply() public view virtual override returns (uint256) {
208         return _totalSupply;
209     }
210 
211     /**
212      * @dev See {IERC20-balanceOf}.
213      */
214     function balanceOf(address account) public view virtual override returns (uint256) {
215         return _balances[account];
216     }
217 
218     /**
219      * @dev See {IERC20-transfer}.
220      *
221      * Requirements:
222      *
223      * - `recipient` cannot be the zero address.
224      * - the caller must have a balance of at least `amount`.
225      */
226     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
227         _transfer(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     /**
232      * @dev See {IERC20-allowance}.
233      */
234     function allowance(address owner, address spender) public view virtual override returns (uint256) {
235         return _allowances[owner][spender];
236     }
237 
238     /**
239      * @dev See {IERC20-approve}.
240      *
241      * Requirements:
242      *
243      * - `spender` cannot be the zero address.
244      */
245     function approve(address spender, uint256 amount) public virtual override returns (bool) {
246         _approve(_msgSender(), spender, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See {IERC20-transferFrom}.
252      *
253      * Emits an {Approval} event indicating the updated allowance. This is not
254      * required by the EIP. See the note at the beginning of {ERC20}.
255      *
256      * Requirements:
257      *
258      * - `sender` and `recipient` cannot be the zero address.
259      * - `sender` must have a balance of at least `amount`.
260      * - the caller must have allowance for ``sender``'s tokens of at least
261      * `amount`.
262      */
263     function transferFrom(
264         address sender,
265         address recipient,
266         uint256 amount
267     ) public virtual override returns (bool) {
268         _transfer(sender, recipient, amount);
269 
270         uint256 currentAllowance = _allowances[sender][_msgSender()];
271         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
272         unchecked {
273             _approve(sender, _msgSender(), currentAllowance - amount);
274         }
275 
276         return true;
277     }
278 
279     /**
280      * @dev Atomically increases the allowance granted to `spender` by the caller.
281      *
282      * This is an alternative to {approve} that can be used as a mitigation for
283      * problems described in {IERC20-approve}.
284      *
285      * Emits an {Approval} event indicating the updated allowance.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      */
291     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
292         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
293         return true;
294     }
295 
296     /**
297      * @dev Atomically decreases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to {approve} that can be used as a mitigation for
300      * problems described in {IERC20-approve}.
301      *
302      * Emits an {Approval} event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      * - `spender` must have allowance for the caller of at least
308      * `subtractedValue`.
309      */
310     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
311         uint256 currentAllowance = _allowances[_msgSender()][spender];
312         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
313         unchecked {
314             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
315         }
316 
317         return true;
318     }
319 
320     /**
321      * @dev Moves `amount` of tokens from `sender` to `recipient`.
322      *
323      * This internal function is equivalent to {transfer}, and can be used to
324      * e.g. implement automatic token fees, slashing mechanisms, etc.
325      *
326      * Emits a {Transfer} event.
327      *
328      * Requirements:
329      *
330      * - `sender` cannot be the zero address.
331      * - `recipient` cannot be the zero address.
332      * - `sender` must have a balance of at least `amount`.
333      */
334     function _transfer(
335         address sender,
336         address recipient,
337         uint256 amount
338     ) internal virtual {
339         require(sender != address(0), "ERC20: transfer from the zero address");
340         require(recipient != address(0), "ERC20: transfer to the zero address");
341 
342         _beforeTokenTransfer(sender, recipient, amount);
343 
344         uint256 senderBalance = _balances[sender];
345         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
346         unchecked {
347             _balances[sender] = senderBalance - amount;
348         }
349         _balances[recipient] += amount;
350 
351         emit Transfer(sender, recipient, amount);
352 
353         _afterTokenTransfer(sender, recipient, amount);
354     }
355 
356     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
357      * the total supply.
358      *
359      * Emits a {Transfer} event with `from` set to the zero address.
360      *
361      * Requirements:
362      *
363      * - `account` cannot be the zero address.
364      */
365     function _createInitialSupply(address account, uint256 amount) internal virtual {
366         require(account != address(0), "ERC20: mint to the zero address");
367 
368         _beforeTokenTransfer(address(0), account, amount);
369 
370         _totalSupply += amount;
371         _balances[account] += amount;
372         emit Transfer(address(0), account, amount);
373 
374         _afterTokenTransfer(address(0), account, amount);
375     }
376 
377     /**
378      * @dev Destroys `amount` tokens from `account`, reducing the
379      * total supply.
380      *
381      * Emits a {Transfer} event with `to` set to the zero address.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      * - `account` must have at least `amount` tokens.
387      */
388     function _burn(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: burn from the zero address");
390 
391         _beforeTokenTransfer(account, address(0), amount);
392 
393         uint256 accountBalance = _balances[account];
394         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
395         unchecked {
396             _balances[account] = accountBalance - amount;
397         }
398         _totalSupply -= amount;
399 
400         emit Transfer(account, address(0), amount);
401 
402         _afterTokenTransfer(account, address(0), amount);
403     }
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
407      *
408      * This internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an {Approval} event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(
419         address owner,
420         address spender,
421         uint256 amount
422     ) internal virtual {
423         require(owner != address(0), "ERC20: approve from the zero address");
424         require(spender != address(0), "ERC20: approve to the zero address");
425 
426         _allowances[owner][spender] = amount;
427         emit Approval(owner, spender, amount);
428     }
429 
430     /**
431      * @dev Hook that is called before any transfer of tokens. This includes
432      * minting and burning.
433      *
434      * Calling conditions:
435      *
436      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
437      * will be transferred to `to`.
438      * - when `from` is zero, `amount` tokens will be minted for `to`.
439      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
440      * - `from` and `to` are never both zero.
441      *
442      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
443      */
444     function _beforeTokenTransfer(
445         address from,
446         address to,
447         uint256 amount
448     ) internal virtual {}
449 
450     /**
451      * @dev Hook that is called after any transfer of tokens. This includes
452      * minting and burning.
453      *
454      * Calling conditions:
455      *
456      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
457      * has been transferred to `to`.
458      * - when `from` is zero, `amount` tokens have been minted for `to`.
459      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
460      * - `from` and `to` are never both zero.
461      *
462      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
463      */
464     function _afterTokenTransfer(
465         address from,
466         address to,
467         uint256 amount
468     ) internal virtual {}
469 }
470 
471 /**
472  * @dev Contract module which provides a basic access control mechanism, where
473  * there is an account (an owner) that can be granted exclusive access to
474  * specific functions.
475  *
476  * By default, the owner account will be the one that deploys the contract. This
477  * can later be changed with {transferOwnership}.
478  *
479  * This module is used through inheritance. It will make available the modifier
480  * `onlyOwner`, which can be applied to your functions to restrict their use to
481  * the owner.
482  */
483 abstract contract Ownable is Context {
484     address private _owner;
485 
486     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
487 
488     /**
489      * @dev Initializes the contract setting the deployer as the initial owner.
490      */
491     constructor() {
492         _setOwner(_msgSender());
493     }
494 
495     /**
496      * @dev Returns the address of the current owner.
497      */
498     function owner() public view virtual returns (address) {
499         return _owner;
500     }
501 
502     /**
503      * @dev Throws if called by any account other than the owner.
504      */
505     modifier onlyOwner() {
506         require(owner() == _msgSender(), "Ownable: caller is not the owner");
507         _;
508     }
509 
510     /**
511      * @dev Leaves the contract without owner. It will not be possible to call
512      * `onlyOwner` functions anymore. Can only be called by the current owner.
513      *
514      * NOTE: Renouncing ownership will leave the contract without an owner,
515      * thereby removing any functionality that is only available to the owner.
516      */
517     function renounceOwnership() public virtual onlyOwner {
518         _setOwner(address(0));
519     }
520 
521     /**
522      * @dev Transfers ownership of the contract to a new account (`newOwner`).
523      * Can only be called by the current owner.
524      */
525     function transferOwnership(address newOwner) public virtual onlyOwner {
526         require(newOwner != address(0), "Ownable: new owner is the zero address");
527         _setOwner(newOwner);
528     }
529 
530     function _setOwner(address newOwner) private {
531         address oldOwner = _owner;
532         _owner = newOwner;
533         emit OwnershipTransferred(oldOwner, newOwner);
534     }
535 }
536 
537 
538 interface IUniswapV2Router01 {
539     function factory() external pure returns (address);
540     function WETH() external pure returns (address);
541 
542     function addLiquidity(
543         address tokenA,
544         address tokenB,
545         uint amountADesired,
546         uint amountBDesired,
547         uint amountAMin,
548         uint amountBMin,
549         address to,
550         uint deadline
551     ) external returns (uint amountA, uint amountB, uint liquidity);
552     function addLiquidityETH(
553         address token,
554         uint amountTokenDesired,
555         uint amountTokenMin,
556         uint amountETHMin,
557         address to,
558         uint deadline
559     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
560     function removeLiquidity(
561         address tokenA,
562         address tokenB,
563         uint liquidity,
564         uint amountAMin,
565         uint amountBMin,
566         address to,
567         uint deadline
568     ) external returns (uint amountA, uint amountB);
569     function removeLiquidityETH(
570         address token,
571         uint liquidity,
572         uint amountTokenMin,
573         uint amountETHMin,
574         address to,
575         uint deadline
576     ) external returns (uint amountToken, uint amountETH);
577     function removeLiquidityWithPermit(
578         address tokenA,
579         address tokenB,
580         uint liquidity,
581         uint amountAMin,
582         uint amountBMin,
583         address to,
584         uint deadline,
585         bool approveMax, uint8 v, bytes32 r, bytes32 s
586     ) external returns (uint amountA, uint amountB);
587     function removeLiquidityETHWithPermit(
588         address token,
589         uint liquidity,
590         uint amountTokenMin,
591         uint amountETHMin,
592         address to,
593         uint deadline,
594         bool approveMax, uint8 v, bytes32 r, bytes32 s
595     ) external returns (uint amountToken, uint amountETH);
596     function swapExactTokensForTokens(
597         uint amountIn,
598         uint amountOutMin,
599         address[] calldata path,
600         address to,
601         uint deadline
602     ) external returns (uint[] memory amounts);
603     function swapTokensForExactTokens(
604         uint amountOut,
605         uint amountInMax,
606         address[] calldata path,
607         address to,
608         uint deadline
609     ) external returns (uint[] memory amounts);
610     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
611         external
612         payable
613         returns (uint[] memory amounts);
614     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
615         external
616         returns (uint[] memory amounts);
617     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
618         external
619         returns (uint[] memory amounts);
620     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
621         external
622         payable
623         returns (uint[] memory amounts);
624 
625     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
626     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
627     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
628     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
629     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
630 }
631 
632 interface IUniswapV2Router02 is IUniswapV2Router01 {
633     function removeLiquidityETHSupportingFeeOnTransferTokens(
634         address token,
635         uint liquidity,
636         uint amountTokenMin,
637         uint amountETHMin,
638         address to,
639         uint deadline
640     ) external returns (uint amountETH);
641     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
642         address token,
643         uint liquidity,
644         uint amountTokenMin,
645         uint amountETHMin,
646         address to,
647         uint deadline,
648         bool approveMax, uint8 v, bytes32 r, bytes32 s
649     ) external returns (uint amountETH);
650 
651     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
652         uint amountIn,
653         uint amountOutMin,
654         address[] calldata path,
655         address to,
656         uint deadline
657     ) external;
658     function swapExactETHForTokensSupportingFeeOnTransferTokens(
659         uint amountOutMin,
660         address[] calldata path,
661         address to,
662         uint deadline
663     ) external payable;
664     function swapExactTokensForETHSupportingFeeOnTransferTokens(
665         uint amountIn,
666         uint amountOutMin,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external;
671 }
672 
673 interface IUniswapV2Factory {
674     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
675 
676     function feeTo() external view returns (address);
677     function feeToSetter() external view returns (address);
678 
679     function getPair(address tokenA, address tokenB) external view returns (address pair);
680     function allPairs(uint) external view returns (address pair);
681     function allPairsLength() external view returns (uint);
682 
683     function createPair(address tokenA, address tokenB) external returns (address pair);
684 
685     function setFeeTo(address) external;
686     function setFeeToSetter(address) external;
687 }
688 
689 /**
690  * @dev Wrappers over Solidity's arithmetic operations.
691  *
692  * NOTE: `SignedSafeMath` is no longer needed starting with Solidity 0.8. The compiler
693  * now has built in overflow checking.
694  */
695 library SignedSafeMath {
696     /**
697      * @dev Returns the multiplication of two signed integers, reverting on
698      * overflow.
699      *
700      * Counterpart to Solidity's `*` operator.
701      *
702      * Requirements:
703      *
704      * - Multiplication cannot overflow.
705      */
706     function mul(int256 a, int256 b) internal pure returns (int256) {
707         return a * b;
708     }
709 
710     /**
711      * @dev Returns the integer division of two signed integers. Reverts on
712      * division by zero. The result is rounded towards zero.
713      *
714      * Counterpart to Solidity's `/` operator.
715      *
716      * Requirements:
717      *
718      * - The divisor cannot be zero.
719      */
720     function div(int256 a, int256 b) internal pure returns (int256) {
721         return a / b;
722     }
723 
724     /**
725      * @dev Returns the subtraction of two signed integers, reverting on
726      * overflow.
727      *
728      * Counterpart to Solidity's `-` operator.
729      *
730      * Requirements:
731      *
732      * - Subtraction cannot overflow.
733      */
734     function sub(int256 a, int256 b) internal pure returns (int256) {
735         return a - b;
736     }
737 
738     /**
739      * @dev Returns the addition of two signed integers, reverting on
740      * overflow.
741      *
742      * Counterpart to Solidity's `+` operator.
743      *
744      * Requirements:
745      *
746      * - Addition cannot overflow.
747      */
748     function add(int256 a, int256 b) internal pure returns (int256) {
749         return a + b;
750     }
751 }
752 
753 // CAUTION
754 // This version of SafeMath should only be used with Solidity 0.8 or later,
755 // because it relies on the compiler's built in overflow checks.
756 
757 /**
758  * @dev Wrappers over Solidity's arithmetic operations.
759  *
760  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
761  * now has built in overflow checking.
762  */
763 library SafeMath {
764     /**
765      * @dev Returns the addition of two unsigned integers, with an overflow flag.
766      *
767      * _Available since v3.4._
768      */
769     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
770         unchecked {
771             uint256 c = a + b;
772             if (c < a) return (false, 0);
773             return (true, c);
774         }
775     }
776 
777     /**
778      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
779      *
780      * _Available since v3.4._
781      */
782     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
783         unchecked {
784             if (b > a) return (false, 0);
785             return (true, a - b);
786         }
787     }
788 
789     /**
790      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
791      *
792      * _Available since v3.4._
793      */
794     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
795         unchecked {
796             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
797             // benefit is lost if 'b' is also tested.
798             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
799             if (a == 0) return (true, 0);
800             uint256 c = a * b;
801             if (c / a != b) return (false, 0);
802             return (true, c);
803         }
804     }
805 
806     /**
807      * @dev Returns the division of two unsigned integers, with a division by zero flag.
808      *
809      * _Available since v3.4._
810      */
811     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
812         unchecked {
813             if (b == 0) return (false, 0);
814             return (true, a / b);
815         }
816     }
817 
818     /**
819      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
820      *
821      * _Available since v3.4._
822      */
823     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
824         unchecked {
825             if (b == 0) return (false, 0);
826             return (true, a % b);
827         }
828     }
829 
830     /**
831      * @dev Returns the addition of two unsigned integers, reverting on
832      * overflow.
833      *
834      * Counterpart to Solidity's `+` operator.
835      *
836      * Requirements:
837      *
838      * - Addition cannot overflow.
839      */
840     function add(uint256 a, uint256 b) internal pure returns (uint256) {
841         return a + b;
842     }
843 
844     /**
845      * @dev Returns the subtraction of two unsigned integers, reverting on
846      * overflow (when the result is negative).
847      *
848      * Counterpart to Solidity's `-` operator.
849      *
850      * Requirements:
851      *
852      * - Subtraction cannot overflow.
853      */
854     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
855         return a - b;
856     }
857 
858     /**
859      * @dev Returns the multiplication of two unsigned integers, reverting on
860      * overflow.
861      *
862      * Counterpart to Solidity's `*` operator.
863      *
864      * Requirements:
865      *
866      * - Multiplication cannot overflow.
867      */
868     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
869         return a * b;
870     }
871 
872     /**
873      * @dev Returns the integer division of two unsigned integers, reverting on
874      * division by zero. The result is rounded towards zero.
875      *
876      * Counterpart to Solidity's `/` operator.
877      *
878      * Requirements:
879      *
880      * - The divisor cannot be zero.
881      */
882     function div(uint256 a, uint256 b) internal pure returns (uint256) {
883         return a / b;
884     }
885 
886     /**
887      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
888      * reverting when dividing by zero.
889      *
890      * Counterpart to Solidity's `%` operator. This function uses a `revert`
891      * opcode (which leaves remaining gas untouched) while Solidity uses an
892      * invalid opcode to revert (consuming all remaining gas).
893      *
894      * Requirements:
895      *
896      * - The divisor cannot be zero.
897      */
898     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
899         return a % b;
900     }
901 
902     /**
903      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
904      * overflow (when the result is negative).
905      *
906      * CAUTION: This function is deprecated because it requires allocating memory for the error
907      * message unnecessarily. For custom revert reasons use {trySub}.
908      *
909      * Counterpart to Solidity's `-` operator.
910      *
911      * Requirements:
912      *
913      * - Subtraction cannot overflow.
914      */
915     function sub(
916         uint256 a,
917         uint256 b,
918         string memory errorMessage
919     ) internal pure returns (uint256) {
920         unchecked {
921             require(b <= a, errorMessage);
922             return a - b;
923         }
924     }
925 
926     /**
927      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
928      * division by zero. The result is rounded towards zero.
929      *
930      * Counterpart to Solidity's `/` operator. Note: this function uses a
931      * `revert` opcode (which leaves remaining gas untouched) while Solidity
932      * uses an invalid opcode to revert (consuming all remaining gas).
933      *
934      * Requirements:
935      *
936      * - The divisor cannot be zero.
937      */
938     function div(
939         uint256 a,
940         uint256 b,
941         string memory errorMessage
942     ) internal pure returns (uint256) {
943         unchecked {
944             require(b > 0, errorMessage);
945             return a / b;
946         }
947     }
948 
949     /**
950      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
951      * reverting with custom message when dividing by zero.
952      *
953      * CAUTION: This function is deprecated because it requires allocating memory for the error
954      * message unnecessarily. For custom revert reasons use {tryMod}.
955      *
956      * Counterpart to Solidity's `%` operator. This function uses a `revert`
957      * opcode (which leaves remaining gas untouched) while Solidity uses an
958      * invalid opcode to revert (consuming all remaining gas).
959      *
960      * Requirements:
961      *
962      * - The divisor cannot be zero.
963      */
964     function mod(
965         uint256 a,
966         uint256 b,
967         string memory errorMessage
968     ) internal pure returns (uint256) {
969         unchecked {
970             require(b > 0, errorMessage);
971             return a % b;
972         }
973     }
974 }
975 
976 /**
977  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
978  * checks.
979  *
980  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
981  * easily result in undesired exploitation or bugs, since developers usually
982  * assume that overflows raise errors. `SafeCast` restores this intuition by
983  * reverting the transaction when such an operation overflows.
984  *
985  * Using this library instead of the unchecked operations eliminates an entire
986  * class of bugs, so it's recommended to use it always.
987  *
988  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
989  * all math on `uint256` and `int256` and then downcasting.
990  */
991 library SafeCast {
992     /**
993      * @dev Returns the downcasted uint224 from uint256, reverting on
994      * overflow (when the input is greater than largest uint224).
995      *
996      * Counterpart to Solidity's `uint224` operator.
997      *
998      * Requirements:
999      *
1000      * - input must fit into 224 bits
1001      */
1002     function toUint224(uint256 value) internal pure returns (uint224) {
1003         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1004         return uint224(value);
1005     }
1006 
1007     /**
1008      * @dev Returns the downcasted uint128 from uint256, reverting on
1009      * overflow (when the input is greater than largest uint128).
1010      *
1011      * Counterpart to Solidity's `uint128` operator.
1012      *
1013      * Requirements:
1014      *
1015      * - input must fit into 128 bits
1016      */
1017     function toUint128(uint256 value) internal pure returns (uint128) {
1018         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1019         return uint128(value);
1020     }
1021 
1022     /**
1023      * @dev Returns the downcasted uint96 from uint256, reverting on
1024      * overflow (when the input is greater than largest uint96).
1025      *
1026      * Counterpart to Solidity's `uint96` operator.
1027      *
1028      * Requirements:
1029      *
1030      * - input must fit into 96 bits
1031      */
1032     function toUint96(uint256 value) internal pure returns (uint96) {
1033         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1034         return uint96(value);
1035     }
1036 
1037     /**
1038      * @dev Returns the downcasted uint64 from uint256, reverting on
1039      * overflow (when the input is greater than largest uint64).
1040      *
1041      * Counterpart to Solidity's `uint64` operator.
1042      *
1043      * Requirements:
1044      *
1045      * - input must fit into 64 bits
1046      */
1047     function toUint64(uint256 value) internal pure returns (uint64) {
1048         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1049         return uint64(value);
1050     }
1051 
1052     /**
1053      * @dev Returns the downcasted uint32 from uint256, reverting on
1054      * overflow (when the input is greater than largest uint32).
1055      *
1056      * Counterpart to Solidity's `uint32` operator.
1057      *
1058      * Requirements:
1059      *
1060      * - input must fit into 32 bits
1061      */
1062     function toUint32(uint256 value) internal pure returns (uint32) {
1063         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1064         return uint32(value);
1065     }
1066 
1067     /**
1068      * @dev Returns the downcasted uint16 from uint256, reverting on
1069      * overflow (when the input is greater than largest uint16).
1070      *
1071      * Counterpart to Solidity's `uint16` operator.
1072      *
1073      * Requirements:
1074      *
1075      * - input must fit into 16 bits
1076      */
1077     function toUint16(uint256 value) internal pure returns (uint16) {
1078         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1079         return uint16(value);
1080     }
1081 
1082     /**
1083      * @dev Returns the downcasted uint8 from uint256, reverting on
1084      * overflow (when the input is greater than largest uint8).
1085      *
1086      * Counterpart to Solidity's `uint8` operator.
1087      *
1088      * Requirements:
1089      *
1090      * - input must fit into 8 bits.
1091      */
1092     function toUint8(uint256 value) internal pure returns (uint8) {
1093         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1094         return uint8(value);
1095     }
1096 
1097     /**
1098      * @dev Converts a signed int256 into an unsigned uint256.
1099      *
1100      * Requirements:
1101      *
1102      * - input must be greater than or equal to 0.
1103      */
1104     function toUint256(int256 value) internal pure returns (uint256) {
1105         require(value >= 0, "SafeCast: value must be positive");
1106         return uint256(value);
1107     }
1108 
1109     /**
1110      * @dev Returns the downcasted int128 from int256, reverting on
1111      * overflow (when the input is less than smallest int128 or
1112      * greater than largest int128).
1113      *
1114      * Counterpart to Solidity's `int128` operator.
1115      *
1116      * Requirements:
1117      *
1118      * - input must fit into 128 bits
1119      *
1120      * _Available since v3.1._
1121      */
1122     function toInt128(int256 value) internal pure returns (int128) {
1123         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1124         return int128(value);
1125     }
1126 
1127     /**
1128      * @dev Returns the downcasted int64 from int256, reverting on
1129      * overflow (when the input is less than smallest int64 or
1130      * greater than largest int64).
1131      *
1132      * Counterpart to Solidity's `int64` operator.
1133      *
1134      * Requirements:
1135      *
1136      * - input must fit into 64 bits
1137      *
1138      * _Available since v3.1._
1139      */
1140     function toInt64(int256 value) internal pure returns (int64) {
1141         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1142         return int64(value);
1143     }
1144 
1145     /**
1146      * @dev Returns the downcasted int32 from int256, reverting on
1147      * overflow (when the input is less than smallest int32 or
1148      * greater than largest int32).
1149      *
1150      * Counterpart to Solidity's `int32` operator.
1151      *
1152      * Requirements:
1153      *
1154      * - input must fit into 32 bits
1155      *
1156      * _Available since v3.1._
1157      */
1158     function toInt32(int256 value) internal pure returns (int32) {
1159         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1160         return int32(value);
1161     }
1162 
1163     /**
1164      * @dev Returns the downcasted int16 from int256, reverting on
1165      * overflow (when the input is less than smallest int16 or
1166      * greater than largest int16).
1167      *
1168      * Counterpart to Solidity's `int16` operator.
1169      *
1170      * Requirements:
1171      *
1172      * - input must fit into 16 bits
1173      *
1174      * _Available since v3.1._
1175      */
1176     function toInt16(int256 value) internal pure returns (int16) {
1177         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1178         return int16(value);
1179     }
1180 
1181     /**
1182      * @dev Returns the downcasted int8 from int256, reverting on
1183      * overflow (when the input is less than smallest int8 or
1184      * greater than largest int8).
1185      *
1186      * Counterpart to Solidity's `int8` operator.
1187      *
1188      * Requirements:
1189      *
1190      * - input must fit into 8 bits.
1191      *
1192      * _Available since v3.1._
1193      */
1194     function toInt8(int256 value) internal pure returns (int8) {
1195         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1196         return int8(value);
1197     }
1198 
1199     /**
1200      * @dev Converts an unsigned uint256 into a signed int256.
1201      *
1202      * Requirements:
1203      *
1204      * - input must be less than or equal to maxInt256.
1205      */
1206     function toInt256(uint256 value) internal pure returns (int256) {
1207         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1208         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1209         return int256(value);
1210     }
1211 }
1212 
1213 contract CHUCKINU is ERC20, Ownable {
1214     using SafeMath for uint256;
1215 
1216     IUniswapV2Router02 public uniswapV2Router;
1217     address public immutable uniswapV2Pair;
1218 
1219     bool private inSwapAndLiquify;
1220 
1221     bool public swapAndLiquifyEnabled = true;
1222 
1223     bool public enableEarlySellTax = true;
1224 
1225     uint256 public maxSellTransactionAmount = 1000000 * (10**18);
1226     uint256 public maxBuyTransactionAmount = 10000 * (10**18);
1227     uint256 public swapTokensAtAmount = 1000 * (10**18);
1228     uint256 public maxWalletToken = 10000 * (10**18);
1229 
1230     uint256 private buyTotalFees = 0;
1231     uint256 public sellTotalFees = 0;
1232     uint256 public earlySellTotalFee = 20;
1233 
1234     // auto burn fee
1235     uint256 public burnFee = 0;
1236     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
1237     
1238 
1239     // distribute the collected tax percentage wise
1240     uint256 public liquidityPercent = 55; // 33% of total collected tax
1241     uint256 public marketingPercent = 25; // 34% of total collected tax
1242     uint256 public devPercent = 20; // 33% of total collected tax
1243 
1244 
1245     address payable public marketingWallet = payable(0xfeCDA83bcE6586d068d2c9c798676bd7f1734619);
1246     address payable public devWallet = payable(0xc6506bEB21518B023f5CeE5f7bd409358D582cfa);
1247     
1248     // exlcude from fees and max transaction amount
1249     mapping (address => bool) private _isExcludedFromFees;
1250 
1251     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1252     // could be subject to a maximum transfer amount
1253     mapping (address => bool) public automatedMarketMakerPairs;
1254     mapping (address => uint256) public lastTxTimestamp;
1255 
1256     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1257 
1258     event ExcludeFromFees(address indexed account, bool isExcluded);
1259 
1260     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1261 
1262     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1263 
1264     event SwapAndLiquifyEnabledUpdated(bool enabled);
1265 
1266     event SwapAndLiquify(
1267         uint256 tokensIntoLiqudity,
1268         uint256 ethReceived
1269     );
1270 
1271     modifier lockTheSwap {
1272         inSwapAndLiquify = true;
1273         _;
1274         inSwapAndLiquify = false;
1275     }
1276 
1277     constructor() ERC20("Chuck Inu", "CHUCK") {
1278 
1279     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // pancakeswap v2 router address
1280          // Create a uniswap pair for this new token
1281         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1282             .createPair(address(this), _uniswapV2Router.WETH());
1283 
1284         uniswapV2Router = _uniswapV2Router;
1285         uniswapV2Pair = _uniswapV2Pair;
1286 
1287         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1288 
1289         // exclude from paying fees or having max transaction amount
1290         excludeFromFees(owner(), true);
1291         excludeFromFees(marketingWallet, true);
1292         excludeFromFees(devWallet, true);
1293         excludeFromFees(address(this), true);
1294         
1295         /*
1296             an internal function that is only called here,
1297             and CANNOT be called ever again
1298         */
1299         _createInitialSupply(owner(), 1000000 * (10**18));
1300     }
1301 
1302     receive() external payable {
1303 
1304   	}
1305 
1306     function updateUniswapV2Router(address newAddress) public onlyOwner {
1307         require(newAddress != address(uniswapV2Router), "KCoin: The router already has that address");
1308         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1309         uniswapV2Router = IUniswapV2Router02(newAddress);
1310     }
1311 
1312     function excludeFromFees(address account, bool excluded) public onlyOwner {
1313         require(_isExcludedFromFees[account] != excluded, "KCoin: Account is already the value of 'excluded'");
1314         _isExcludedFromFees[account] = excluded;
1315 
1316         emit ExcludeFromFees(account, excluded);
1317     }
1318    
1319     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1320         require(pair != uniswapV2Pair, "KCoin: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1321 
1322         _setAutomatedMarketMakerPair(pair, value);
1323     }
1324 
1325     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1326         require(automatedMarketMakerPairs[pair] != value, "KCoin: Automated market maker pair is already set to that value");
1327         automatedMarketMakerPairs[pair] = value;
1328 
1329         emit SetAutomatedMarketMakerPair(pair, value);
1330     }
1331     
1332     function isExcludedFromFees(address account) public view returns(bool) {
1333         return _isExcludedFromFees[account];
1334     }
1335    
1336     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1337         swapAndLiquifyEnabled = _enabled;
1338         emit SwapAndLiquifyEnabledUpdated(_enabled);
1339     }
1340 
1341     function _transfer(address from, address to, uint256 amount) internal override 
1342     {
1343         require(from != address(0), "ERC20: transfer from the zero address");
1344         require(to != address(0), "ERC20: transfer to the zero address");
1345 
1346         if(amount == 0) { 
1347             super._transfer(from, to, 0);
1348             return;
1349         }
1350         
1351         if(automatedMarketMakerPairs[from] && (!_isExcludedFromFees[from]) && (!_isExcludedFromFees[to])) {
1352             require(amount <= maxBuyTransactionAmount, "amount exceeds the maxBuyTransactionAmount.");
1353             uint256 contractBalanceRecepient = balanceOf(to);
1354             require(contractBalanceRecepient + amount <= maxWalletToken,"Exceeds maximum wallet token amount.");
1355             lastTxTimestamp[to] = block.timestamp;
1356             
1357         }
1358 
1359         if(automatedMarketMakerPairs[to] && (!_isExcludedFromFees[from]) && (!_isExcludedFromFees[to])) {
1360             require(amount <= maxSellTransactionAmount, "amount exceeds the maxSellTransactionAmount.");
1361         }
1362         
1363 
1364     	uint256 contractTokenBalance = balanceOf(address(this));
1365         
1366         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
1367        
1368         if(
1369             overMinTokenBalance &&
1370             !inSwapAndLiquify &&
1371             automatedMarketMakerPairs[to] && 
1372             swapAndLiquifyEnabled
1373         ) {
1374             contractTokenBalance = swapTokensAtAmount;
1375             swapAndLiquify(contractTokenBalance);
1376         }
1377 
1378         uint256 fees = 0;
1379         uint256 burnShare = 0;
1380          // if any account belongs to _isExcludedFromFee account then remove the fee
1381         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
1382             uint256 _totalFees = buyTotalFees;
1383 
1384             if (automatedMarketMakerPairs[to]) {   
1385                 uint256 span = block.timestamp-lastTxTimestamp[from];
1386                 if(enableEarlySellTax && span <= 24 hours) {
1387                     _totalFees = earlySellTotalFee;
1388                 }
1389                 else if(!enableEarlySellTax) {
1390                     _totalFees = sellTotalFees;
1391                 }
1392             }
1393 
1394             fees = amount.mul(_totalFees).div(100);
1395             burnShare = amount.mul(burnFee).div(100);
1396             if(fees > 0) {
1397                 super._transfer(from, address(this), fees);
1398             }
1399 
1400             if(burnShare > 0) {
1401                 super._transfer(from, deadWallet, burnShare);
1402             }
1403 
1404             amount = amount.sub(fees.add(burnShare));
1405         }
1406 
1407         super._transfer(from, to, amount);
1408 
1409     }
1410 
1411      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1412         uint256 tokensForLiquidity = contractTokenBalance.mul(liquidityPercent).div(100);
1413         // split the Liquidity token balance into halves
1414         uint256 half = tokensForLiquidity.div(2);
1415         uint256 otherHalf = tokensForLiquidity.sub(half);
1416         // capture the contract's current ETH balance.
1417         // this is so that we can capture exactly the amount of ETH that the
1418         // swap creates, and not make the liquidity event include any ETH that
1419         // has been manually sent to the contract
1420         uint256 initialBalance = address(this).balance;
1421         // swap tokens for ETH
1422         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1423         // how much ETH did we just swap into?
1424         uint256 newBalance = address(this).balance.sub(initialBalance);
1425         // add liquidity to uniswap
1426         addLiquidity(otherHalf, newBalance);
1427         // swap and Send  Eth to marketing, dev wallets
1428         swapTokensForEth(contractTokenBalance.sub(tokensForLiquidity));
1429         marketingWallet.transfer(address(this).balance.mul(marketingPercent).div(marketingPercent.add(devPercent)));
1430         devWallet.transfer(address(this).balance);
1431         emit SwapAndLiquify(half, newBalance); 
1432     }
1433 
1434     function swapTokensForEth(uint256 tokenAmount) private {
1435 
1436         // generate the uniswap pair path of token -> weth
1437         address[] memory path = new address[](2);
1438         path[0] = address(this);
1439         path[1] = uniswapV2Router.WETH();
1440 
1441         if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) {
1442           _approve(address(this), address(uniswapV2Router), ~uint256(0));
1443         }
1444 
1445         // make the swap
1446         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1447             tokenAmount,
1448             0, // accept any amount of ETH
1449             path,
1450             address(this),
1451             block.timestamp
1452         );
1453         
1454     }
1455 
1456     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1457         
1458         // add the liquidity
1459         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1460             address(this),
1461             tokenAmount,
1462             0, // slippage is unavoidable
1463             0, // slippage is unavoidable
1464             owner(),
1465             block.timestamp
1466         );
1467         
1468     }
1469 
1470     function setMaxSellTransaction(uint256 _maxSellTxAmount) public onlyOwner {
1471         maxSellTransactionAmount = _maxSellTxAmount;
1472         require(maxSellTransactionAmount>totalSupply().div(1000), "value is too low");
1473     }
1474     
1475     function setMaxBuyTransaction(uint256 _maxBuyTxAmount) public onlyOwner {
1476         maxBuyTransactionAmount = _maxBuyTxAmount;
1477         require(maxBuyTransactionAmount>totalSupply().div(1000), "value is too low");
1478     }
1479 
1480     function setSwapTokensAtAmouunt(uint256 _newAmount) public onlyOwner {
1481         swapTokensAtAmount = _newAmount;
1482     }
1483 
1484     function setMarketingWallet(address payable wallet) public onlyOwner {
1485         marketingWallet = wallet;
1486     }
1487 
1488     function setDevWallet(address payable wallet) public onlyOwner {
1489         devWallet = wallet;
1490     }
1491 
1492     function updateBuyTotalTax(uint256 _buyTotalFees) public onlyOwner {
1493         buyTotalFees = _buyTotalFees;
1494         require(buyTotalFees <= 10, "Fee too high");
1495     }
1496 
1497    function updateSellTotalTax(uint256 _sellTotalFees) public onlyOwner {
1498         sellTotalFees = _sellTotalFees;
1499         require(sellTotalFees <= 10, "Fee too high");
1500     }
1501 
1502     function updateEarlySellTotalTax(uint256 _earlySellTotalFee) public onlyOwner {
1503         earlySellTotalFee = _earlySellTotalFee;
1504         require(earlySellTotalFee <= 20, "Fee too high");
1505     }
1506 
1507     function updateTaxDistributionPercentage(uint256 _liquidityPercent, uint256 _marketingPercent, uint256 _devPercent) public onlyOwner {
1508         require(_liquidityPercent.add(_marketingPercent).add(_devPercent) == 100, "total percentage must be equal to 100");
1509         liquidityPercent = _liquidityPercent;
1510         marketingPercent = _marketingPercent;
1511         devPercent = _devPercent;  
1512     }
1513 
1514     function setEarlySellTax(bool onoff) external onlyOwner  {
1515         enableEarlySellTax = onoff;
1516     }
1517 
1518     function setAutoBurn(uint256 _burnFee) external onlyOwner  {
1519         require(_burnFee <= 5, "value too high");
1520         burnFee = _burnFee;
1521     }
1522 
1523     function setMaxWalletToken(uint256 _maxToken) external onlyOwner {
1524         maxWalletToken = _maxToken;
1525         require(maxWalletToken>totalSupply().div(1000), "value is too low");
1526   	}
1527 
1528 }