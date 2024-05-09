1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.9;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 /**
116  * @dev Implementation of the {IERC20} interface.
117  *
118  * This implementation is agnostic to the way tokens are created. This means
119  * that a supply mechanism has to be added in a derived contract using {_mint}.
120  * For a generic mechanism see {ERC20PresetMinterPauser}.
121  *
122  * TIP: For a detailed writeup see our guide
123  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
124  * to implement supply mechanisms].
125  *
126  * We have followed general OpenZeppelin guidelines: functions revert instead
127  * of returning `false` on failure. This behavior is nonetheless conventional
128  * and does not conflict with the expectations of ERC20 applications.
129  *
130  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
131  * This allows applications to reconstruct the allowance for all accounts just
132  * by listening to said events. Other implementations of the EIP may not emit
133  * these events, as it isn't required by the specification.
134  *
135  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
136  * functions have been added to mitigate the well-known issues around setting
137  * allowances. See {IERC20-approve}.
138  */
139 contract ERC20 is Context, IERC20, IERC20Metadata {
140     mapping(address => uint256) private _balances;
141 
142     mapping(address => mapping(address => uint256)) private _allowances;
143 
144     uint256 private _totalSupply;
145 
146     string private _name;
147     string private _symbol;
148 
149     /**
150      * @dev Sets the values for {name} and {symbol}.
151      *
152      * The default value of {decimals} is 18. To select a different value for
153      * {decimals} you should overload it.
154      *
155      * All two of these values are immutable: they can only be set once during
156      * construction.
157      */
158     constructor(string memory name_, string memory symbol_) {
159         _name = name_;
160         _symbol = symbol_;
161     }
162 
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() public view virtual override returns (string memory) {
167         return _name;
168     }
169 
170     /**
171      * @dev Returns the symbol of the token, usually a shorter version of the
172      * name.
173      */
174     function symbol() public view virtual override returns (string memory) {
175         return _symbol;
176     }
177 
178     /**
179      * @dev Returns the number of decimals used to get its user representation.
180      * For example, if `decimals` equals `2`, a balance of `505` tokens should
181      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
182      *
183      * Tokens usually opt for a value of 18, imitating the relationship between
184      * Ether and Wei. This is the value {ERC20} uses, unless this function is
185      * overridden;
186      *
187      * NOTE: This information is only used for _display_ purposes: it in
188      * no way affects any of the arithmetic of the contract, including
189      * {IERC20-balanceOf} and {IERC20-transfer}.
190      */
191     function decimals() public view virtual override returns (uint8) {
192         return 18;
193     }
194 
195     /**
196      * @dev See {IERC20-totalSupply}.
197      */
198     function totalSupply() public view virtual override returns (uint256) {
199         return _totalSupply;
200     }
201 
202     /**
203      * @dev See {IERC20-balanceOf}.
204      */
205     function balanceOf(address account) public view virtual override returns (uint256) {
206         return _balances[account];
207     }
208 
209     /**
210      * @dev See {IERC20-transfer}.
211      *
212      * Requirements:
213      *
214      * - `recipient` cannot be the zero address.
215      * - the caller must have a balance of at least `amount`.
216      */
217     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
218         _transfer(_msgSender(), recipient, amount);
219         return true;
220     }
221 
222     /**
223      * @dev See {IERC20-allowance}.
224      */
225     function allowance(address owner, address spender) public view virtual override returns (uint256) {
226         return _allowances[owner][spender];
227     }
228 
229     /**
230      * @dev See {IERC20-approve}.
231      *
232      * Requirements:
233      *
234      * - `spender` cannot be the zero address.
235      */
236     function approve(address spender, uint256 amount) public virtual override returns (bool) {
237         _approve(_msgSender(), spender, amount);
238         return true;
239     }
240 
241     /**
242      * @dev See {IERC20-transferFrom}.
243      *
244      * Emits an {Approval} event indicating the updated allowance. This is not
245      * required by the EIP. See the note at the beginning of {ERC20}.
246      *
247      * Requirements:
248      *
249      * - `sender` and `recipient` cannot be the zero address.
250      * - `sender` must have a balance of at least `amount`.
251      * - the caller must have allowance for ``sender``'s tokens of at least
252      * `amount`.
253      */
254     function transferFrom(
255         address sender,
256         address recipient,
257         uint256 amount
258     ) public virtual override returns (bool) {
259         _transfer(sender, recipient, amount);
260 
261         uint256 currentAllowance = _allowances[sender][_msgSender()];
262         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
263         unchecked {
264             _approve(sender, _msgSender(), currentAllowance - amount);
265         }
266 
267         return true;
268     }
269 
270     /**
271      * @dev Atomically increases the allowance granted to `spender` by the caller.
272      *
273      * This is an alternative to {approve} that can be used as a mitigation for
274      * problems described in {IERC20-approve}.
275      *
276      * Emits an {Approval} event indicating the updated allowance.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
283         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
284         return true;
285     }
286 
287     /**
288      * @dev Atomically decreases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to {approve} that can be used as a mitigation for
291      * problems described in {IERC20-approve}.
292      *
293      * Emits an {Approval} event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      * - `spender` must have allowance for the caller of at least
299      * `subtractedValue`.
300      */
301     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
302         uint256 currentAllowance = _allowances[_msgSender()][spender];
303         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
304         unchecked {
305             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
306         }
307 
308         return true;
309     }
310 
311     /**
312      * @dev Moves `amount` of tokens from `sender` to `recipient`.
313      *
314      * This internal function is equivalent to {transfer}, and can be used to
315      * e.g. implement automatic token fees, slashing mechanisms, etc.
316      *
317      * Emits a {Transfer} event.
318      *
319      * Requirements:
320      *
321      * - `sender` cannot be the zero address.
322      * - `recipient` cannot be the zero address.
323      * - `sender` must have a balance of at least `amount`.
324      */
325     function _transfer(
326         address sender,
327         address recipient,
328         uint256 amount
329     ) internal virtual {
330         require(sender != address(0), "ERC20: transfer from the zero address");
331         require(recipient != address(0), "ERC20: transfer to the zero address");
332 
333         _beforeTokenTransfer(sender, recipient, amount);
334 
335         uint256 senderBalance = _balances[sender];
336         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
337         unchecked {
338             _balances[sender] = senderBalance - amount;
339         }
340         _balances[recipient] += amount;
341 
342         emit Transfer(sender, recipient, amount);
343 
344         _afterTokenTransfer(sender, recipient, amount);
345     }
346 
347     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
348      * the total supply.
349      *
350      * Emits a {Transfer} event with `from` set to the zero address.
351      *
352      * Requirements:
353      *
354      * - `account` cannot be the zero address.
355      */
356     function _mint(address account, uint256 amount) internal virtual {
357         require(account != address(0), "ERC20: mint to the zero address");
358 
359         _beforeTokenTransfer(address(0), account, amount);
360 
361         _totalSupply += amount;
362         _balances[account] += amount;
363         emit Transfer(address(0), account, amount);
364 
365         _afterTokenTransfer(address(0), account, amount);
366     }
367 
368     /**
369      * @dev Destroys `amount` tokens from `account`, reducing the
370      * total supply.
371      *
372      * Emits a {Transfer} event with `to` set to the zero address.
373      *
374      * Requirements:
375      *
376      * - `account` cannot be the zero address.
377      * - `account` must have at least `amount` tokens.
378      */
379     function _burn(address account, uint256 amount) internal virtual {
380         require(account != address(0), "ERC20: burn from the zero address");
381 
382         _beforeTokenTransfer(account, address(0), amount);
383 
384         uint256 accountBalance = _balances[account];
385         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
386         unchecked {
387             _balances[account] = accountBalance - amount;
388         }
389         _totalSupply -= amount;
390 
391         emit Transfer(account, address(0), amount);
392 
393         _afterTokenTransfer(account, address(0), amount);
394     }
395 
396     /**
397      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
398      *
399      * This internal function is equivalent to `approve`, and can be used to
400      * e.g. set automatic allowances for certain subsystems, etc.
401      *
402      * Emits an {Approval} event.
403      *
404      * Requirements:
405      *
406      * - `owner` cannot be the zero address.
407      * - `spender` cannot be the zero address.
408      */
409     function _approve(
410         address owner,
411         address spender,
412         uint256 amount
413     ) internal virtual {
414         require(owner != address(0), "ERC20: approve from the zero address");
415         require(spender != address(0), "ERC20: approve to the zero address");
416 
417         _allowances[owner][spender] = amount;
418         emit Approval(owner, spender, amount);
419     }
420 
421     /**
422      * @dev Hook that is called before any transfer of tokens. This includes
423      * minting and burning.
424      *
425      * Calling conditions:
426      *
427      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
428      * will be transferred to `to`.
429      * - when `from` is zero, `amount` tokens will be minted for `to`.
430      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
431      * - `from` and `to` are never both zero.
432      *
433      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
434      */
435     function _beforeTokenTransfer(
436         address from,
437         address to,
438         uint256 amount
439     ) internal virtual {}
440 
441     /**
442      * @dev Hook that is called after any transfer of tokens. This includes
443      * minting and burning.
444      *
445      * Calling conditions:
446      *
447      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
448      * has been transferred to `to`.
449      * - when `from` is zero, `amount` tokens have been minted for `to`.
450      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
451      * - `from` and `to` are never both zero.
452      *
453      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
454      */
455     function _afterTokenTransfer(
456         address from,
457         address to,
458         uint256 amount
459     ) internal virtual {}
460 }
461 
462 /**
463  * @dev Contract module which provides a basic access control mechanism, where
464  * there is an account (an owner) that can be granted exclusive access to
465  * specific functions.
466  *
467  * By default, the owner account will be the one that deploys the contract. This
468  * can later be changed with {transferOwnership}.
469  *
470  * This module is used through inheritance. It will make available the modifier
471  * `onlyOwner`, which can be applied to your functions to restrict their use to
472  * the owner.
473  */
474 abstract contract Ownable is Context {
475     address private _owner;
476 
477     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
478 
479     /**
480      * @dev Initializes the contract setting the deployer as the initial owner.
481      */
482     constructor() {
483         _setOwner(_msgSender());
484     }
485 
486     /**
487      * @dev Returns the address of the current owner.
488      */
489     function owner() public view virtual returns (address) {
490         return _owner;
491     }
492 
493     /**
494      * @dev Throws if called by any account other than the owner.
495      */
496     modifier onlyOwner() {
497         require(owner() == _msgSender(), "Ownable: caller is not the owner");
498         _;
499     }
500 
501     /**
502      * @dev Leaves the contract without owner. It will not be possible to call
503      * `onlyOwner` functions anymore. Can only be called by the current owner.
504      *
505      * NOTE: Renouncing ownership will leave the contract without an owner,
506      * thereby removing any functionality that is only available to the owner.
507      */
508     function renounceOwnership() public virtual onlyOwner {
509         _setOwner(address(0));
510     }
511 
512     /**
513      * @dev Transfers ownership of the contract to a new account (`newOwner`).
514      * Can only be called by the current owner.
515      */
516     function transferOwnership(address newOwner) public virtual onlyOwner {
517         require(newOwner != address(0), "Ownable: new owner is the zero address");
518         _setOwner(newOwner);
519     }
520 
521     function _setOwner(address newOwner) private {
522         address oldOwner = _owner;
523         _owner = newOwner;
524         emit OwnershipTransferred(oldOwner, newOwner);
525     }
526 }
527 
528 
529 interface IUniswapV2Router01 {
530     function factory() external pure returns (address);
531     function WETH() external pure returns (address);
532 
533     function addLiquidity(
534         address tokenA,
535         address tokenB,
536         uint amountADesired,
537         uint amountBDesired,
538         uint amountAMin,
539         uint amountBMin,
540         address to,
541         uint deadline
542     ) external returns (uint amountA, uint amountB, uint liquidity);
543     function addLiquidityETH(
544         address token,
545         uint amountTokenDesired,
546         uint amountTokenMin,
547         uint amountETHMin,
548         address to,
549         uint deadline
550     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
551     function removeLiquidity(
552         address tokenA,
553         address tokenB,
554         uint liquidity,
555         uint amountAMin,
556         uint amountBMin,
557         address to,
558         uint deadline
559     ) external returns (uint amountA, uint amountB);
560     function removeLiquidityETH(
561         address token,
562         uint liquidity,
563         uint amountTokenMin,
564         uint amountETHMin,
565         address to,
566         uint deadline
567     ) external returns (uint amountToken, uint amountETH);
568     function removeLiquidityWithPermit(
569         address tokenA,
570         address tokenB,
571         uint liquidity,
572         uint amountAMin,
573         uint amountBMin,
574         address to,
575         uint deadline,
576         bool approveMax, uint8 v, bytes32 r, bytes32 s
577     ) external returns (uint amountA, uint amountB);
578     function removeLiquidityETHWithPermit(
579         address token,
580         uint liquidity,
581         uint amountTokenMin,
582         uint amountETHMin,
583         address to,
584         uint deadline,
585         bool approveMax, uint8 v, bytes32 r, bytes32 s
586     ) external returns (uint amountToken, uint amountETH);
587     function swapExactTokensForTokens(
588         uint amountIn,
589         uint amountOutMin,
590         address[] calldata path,
591         address to,
592         uint deadline
593     ) external returns (uint[] memory amounts);
594     function swapTokensForExactTokens(
595         uint amountOut,
596         uint amountInMax,
597         address[] calldata path,
598         address to,
599         uint deadline
600     ) external returns (uint[] memory amounts);
601     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
602         external
603         payable
604         returns (uint[] memory amounts);
605     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
606         external
607         returns (uint[] memory amounts);
608     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
609         external
610         returns (uint[] memory amounts);
611     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
612         external
613         payable
614         returns (uint[] memory amounts);
615 
616     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
617     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
618     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
619     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
620     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
621 }
622 
623 interface IUniswapV2Router02 is IUniswapV2Router01 {
624     function removeLiquidityETHSupportingFeeOnTransferTokens(
625         address token,
626         uint liquidity,
627         uint amountTokenMin,
628         uint amountETHMin,
629         address to,
630         uint deadline
631     ) external returns (uint amountETH);
632     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
633         address token,
634         uint liquidity,
635         uint amountTokenMin,
636         uint amountETHMin,
637         address to,
638         uint deadline,
639         bool approveMax, uint8 v, bytes32 r, bytes32 s
640     ) external returns (uint amountETH);
641 
642     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
643         uint amountIn,
644         uint amountOutMin,
645         address[] calldata path,
646         address to,
647         uint deadline
648     ) external;
649     function swapExactETHForTokensSupportingFeeOnTransferTokens(
650         uint amountOutMin,
651         address[] calldata path,
652         address to,
653         uint deadline
654     ) external payable;
655     function swapExactTokensForETHSupportingFeeOnTransferTokens(
656         uint amountIn,
657         uint amountOutMin,
658         address[] calldata path,
659         address to,
660         uint deadline
661     ) external;
662 }
663 
664 interface IUniswapV2Factory {
665     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
666 
667     function feeTo() external view returns (address);
668     function feeToSetter() external view returns (address);
669 
670     function getPair(address tokenA, address tokenB) external view returns (address pair);
671     function allPairs(uint) external view returns (address pair);
672     function allPairsLength() external view returns (uint);
673 
674     function createPair(address tokenA, address tokenB) external returns (address pair);
675 
676     function setFeeTo(address) external;
677     function setFeeToSetter(address) external;
678 }
679 
680 /**
681  * @dev Wrappers over Solidity's arithmetic operations.
682  *
683  * NOTE: `SignedSafeMath` is no longer needed starting with Solidity 0.8. The compiler
684  * now has built in overflow checking.
685  */
686 library SignedSafeMath {
687     /**
688      * @dev Returns the multiplication of two signed integers, reverting on
689      * overflow.
690      *
691      * Counterpart to Solidity's `*` operator.
692      *
693      * Requirements:
694      *
695      * - Multiplication cannot overflow.
696      */
697     function mul(int256 a, int256 b) internal pure returns (int256) {
698         return a * b;
699     }
700 
701     /**
702      * @dev Returns the integer division of two signed integers. Reverts on
703      * division by zero. The result is rounded towards zero.
704      *
705      * Counterpart to Solidity's `/` operator.
706      *
707      * Requirements:
708      *
709      * - The divisor cannot be zero.
710      */
711     function div(int256 a, int256 b) internal pure returns (int256) {
712         return a / b;
713     }
714 
715     /**
716      * @dev Returns the subtraction of two signed integers, reverting on
717      * overflow.
718      *
719      * Counterpart to Solidity's `-` operator.
720      *
721      * Requirements:
722      *
723      * - Subtraction cannot overflow.
724      */
725     function sub(int256 a, int256 b) internal pure returns (int256) {
726         return a - b;
727     }
728 
729     /**
730      * @dev Returns the addition of two signed integers, reverting on
731      * overflow.
732      *
733      * Counterpart to Solidity's `+` operator.
734      *
735      * Requirements:
736      *
737      * - Addition cannot overflow.
738      */
739     function add(int256 a, int256 b) internal pure returns (int256) {
740         return a + b;
741     }
742 }
743 
744 // CAUTION
745 // This version of SafeMath should only be used with Solidity 0.8 or later,
746 // because it relies on the compiler's built in overflow checks.
747 
748 /**
749  * @dev Wrappers over Solidity's arithmetic operations.
750  *
751  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
752  * now has built in overflow checking.
753  */
754 library SafeMath {
755     /**
756      * @dev Returns the addition of two unsigned integers, with an overflow flag.
757      *
758      * _Available since v3.4._
759      */
760     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
761         unchecked {
762             uint256 c = a + b;
763             if (c < a) return (false, 0);
764             return (true, c);
765         }
766     }
767 
768     /**
769      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
770      *
771      * _Available since v3.4._
772      */
773     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
774         unchecked {
775             if (b > a) return (false, 0);
776             return (true, a - b);
777         }
778     }
779 
780     /**
781      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
782      *
783      * _Available since v3.4._
784      */
785     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
786         unchecked {
787             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
788             // benefit is lost if 'b' is also tested.
789             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
790             if (a == 0) return (true, 0);
791             uint256 c = a * b;
792             if (c / a != b) return (false, 0);
793             return (true, c);
794         }
795     }
796 
797     /**
798      * @dev Returns the division of two unsigned integers, with a division by zero flag.
799      *
800      * _Available since v3.4._
801      */
802     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
803         unchecked {
804             if (b == 0) return (false, 0);
805             return (true, a / b);
806         }
807     }
808 
809     /**
810      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
811      *
812      * _Available since v3.4._
813      */
814     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
815         unchecked {
816             if (b == 0) return (false, 0);
817             return (true, a % b);
818         }
819     }
820 
821     /**
822      * @dev Returns the addition of two unsigned integers, reverting on
823      * overflow.
824      *
825      * Counterpart to Solidity's `+` operator.
826      *
827      * Requirements:
828      *
829      * - Addition cannot overflow.
830      */
831     function add(uint256 a, uint256 b) internal pure returns (uint256) {
832         return a + b;
833     }
834 
835     /**
836      * @dev Returns the subtraction of two unsigned integers, reverting on
837      * overflow (when the result is negative).
838      *
839      * Counterpart to Solidity's `-` operator.
840      *
841      * Requirements:
842      *
843      * - Subtraction cannot overflow.
844      */
845     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
846         return a - b;
847     }
848 
849     /**
850      * @dev Returns the multiplication of two unsigned integers, reverting on
851      * overflow.
852      *
853      * Counterpart to Solidity's `*` operator.
854      *
855      * Requirements:
856      *
857      * - Multiplication cannot overflow.
858      */
859     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
860         return a * b;
861     }
862 
863     /**
864      * @dev Returns the integer division of two unsigned integers, reverting on
865      * division by zero. The result is rounded towards zero.
866      *
867      * Counterpart to Solidity's `/` operator.
868      *
869      * Requirements:
870      *
871      * - The divisor cannot be zero.
872      */
873     function div(uint256 a, uint256 b) internal pure returns (uint256) {
874         return a / b;
875     }
876 
877     /**
878      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
879      * reverting when dividing by zero.
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
890         return a % b;
891     }
892 
893     /**
894      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
895      * overflow (when the result is negative).
896      *
897      * CAUTION: This function is deprecated because it requires allocating memory for the error
898      * message unnecessarily. For custom revert reasons use {trySub}.
899      *
900      * Counterpart to Solidity's `-` operator.
901      *
902      * Requirements:
903      *
904      * - Subtraction cannot overflow.
905      */
906     function sub(
907         uint256 a,
908         uint256 b,
909         string memory errorMessage
910     ) internal pure returns (uint256) {
911         unchecked {
912             require(b <= a, errorMessage);
913             return a - b;
914         }
915     }
916 
917     /**
918      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
919      * division by zero. The result is rounded towards zero.
920      *
921      * Counterpart to Solidity's `/` operator. Note: this function uses a
922      * `revert` opcode (which leaves remaining gas untouched) while Solidity
923      * uses an invalid opcode to revert (consuming all remaining gas).
924      *
925      * Requirements:
926      *
927      * - The divisor cannot be zero.
928      */
929     function div(
930         uint256 a,
931         uint256 b,
932         string memory errorMessage
933     ) internal pure returns (uint256) {
934         unchecked {
935             require(b > 0, errorMessage);
936             return a / b;
937         }
938     }
939 
940     /**
941      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
942      * reverting with custom message when dividing by zero.
943      *
944      * CAUTION: This function is deprecated because it requires allocating memory for the error
945      * message unnecessarily. For custom revert reasons use {tryMod}.
946      *
947      * Counterpart to Solidity's `%` operator. This function uses a `revert`
948      * opcode (which leaves remaining gas untouched) while Solidity uses an
949      * invalid opcode to revert (consuming all remaining gas).
950      *
951      * Requirements:
952      *
953      * - The divisor cannot be zero.
954      */
955     function mod(
956         uint256 a,
957         uint256 b,
958         string memory errorMessage
959     ) internal pure returns (uint256) {
960         unchecked {
961             require(b > 0, errorMessage);
962             return a % b;
963         }
964     }
965 }
966 
967 /**
968  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
969  * checks.
970  *
971  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
972  * easily result in undesired exploitation or bugs, since developers usually
973  * assume that overflows raise errors. `SafeCast` restores this intuition by
974  * reverting the transaction when such an operation overflows.
975  *
976  * Using this library instead of the unchecked operations eliminates an entire
977  * class of bugs, so it's recommended to use it always.
978  *
979  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
980  * all math on `uint256` and `int256` and then downcasting.
981  */
982 library SafeCast {
983     /**
984      * @dev Returns the downcasted uint224 from uint256, reverting on
985      * overflow (when the input is greater than largest uint224).
986      *
987      * Counterpart to Solidity's `uint224` operator.
988      *
989      * Requirements:
990      *
991      * - input must fit into 224 bits
992      */
993     function toUint224(uint256 value) internal pure returns (uint224) {
994         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
995         return uint224(value);
996     }
997 
998     /**
999      * @dev Returns the downcasted uint128 from uint256, reverting on
1000      * overflow (when the input is greater than largest uint128).
1001      *
1002      * Counterpart to Solidity's `uint128` operator.
1003      *
1004      * Requirements:
1005      *
1006      * - input must fit into 128 bits
1007      */
1008     function toUint128(uint256 value) internal pure returns (uint128) {
1009         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1010         return uint128(value);
1011     }
1012 
1013     /**
1014      * @dev Returns the downcasted uint96 from uint256, reverting on
1015      * overflow (when the input is greater than largest uint96).
1016      *
1017      * Counterpart to Solidity's `uint96` operator.
1018      *
1019      * Requirements:
1020      *
1021      * - input must fit into 96 bits
1022      */
1023     function toUint96(uint256 value) internal pure returns (uint96) {
1024         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1025         return uint96(value);
1026     }
1027 
1028     /**
1029      * @dev Returns the downcasted uint64 from uint256, reverting on
1030      * overflow (when the input is greater than largest uint64).
1031      *
1032      * Counterpart to Solidity's `uint64` operator.
1033      *
1034      * Requirements:
1035      *
1036      * - input must fit into 64 bits
1037      */
1038     function toUint64(uint256 value) internal pure returns (uint64) {
1039         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1040         return uint64(value);
1041     }
1042 
1043     /**
1044      * @dev Returns the downcasted uint32 from uint256, reverting on
1045      * overflow (when the input is greater than largest uint32).
1046      *
1047      * Counterpart to Solidity's `uint32` operator.
1048      *
1049      * Requirements:
1050      *
1051      * - input must fit into 32 bits
1052      */
1053     function toUint32(uint256 value) internal pure returns (uint32) {
1054         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1055         return uint32(value);
1056     }
1057 
1058     /**
1059      * @dev Returns the downcasted uint16 from uint256, reverting on
1060      * overflow (when the input is greater than largest uint16).
1061      *
1062      * Counterpart to Solidity's `uint16` operator.
1063      *
1064      * Requirements:
1065      *
1066      * - input must fit into 16 bits
1067      */
1068     function toUint16(uint256 value) internal pure returns (uint16) {
1069         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1070         return uint16(value);
1071     }
1072 
1073     /**
1074      * @dev Returns the downcasted uint8 from uint256, reverting on
1075      * overflow (when the input is greater than largest uint8).
1076      *
1077      * Counterpart to Solidity's `uint8` operator.
1078      *
1079      * Requirements:
1080      *
1081      * - input must fit into 8 bits.
1082      */
1083     function toUint8(uint256 value) internal pure returns (uint8) {
1084         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1085         return uint8(value);
1086     }
1087 
1088     /**
1089      * @dev Converts a signed int256 into an unsigned uint256.
1090      *
1091      * Requirements:
1092      *
1093      * - input must be greater than or equal to 0.
1094      */
1095     function toUint256(int256 value) internal pure returns (uint256) {
1096         require(value >= 0, "SafeCast: value must be positive");
1097         return uint256(value);
1098     }
1099 
1100     /**
1101      * @dev Returns the downcasted int128 from int256, reverting on
1102      * overflow (when the input is less than smallest int128 or
1103      * greater than largest int128).
1104      *
1105      * Counterpart to Solidity's `int128` operator.
1106      *
1107      * Requirements:
1108      *
1109      * - input must fit into 128 bits
1110      *
1111      * _Available since v3.1._
1112      */
1113     function toInt128(int256 value) internal pure returns (int128) {
1114         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1115         return int128(value);
1116     }
1117 
1118     /**
1119      * @dev Returns the downcasted int64 from int256, reverting on
1120      * overflow (when the input is less than smallest int64 or
1121      * greater than largest int64).
1122      *
1123      * Counterpart to Solidity's `int64` operator.
1124      *
1125      * Requirements:
1126      *
1127      * - input must fit into 64 bits
1128      *
1129      * _Available since v3.1._
1130      */
1131     function toInt64(int256 value) internal pure returns (int64) {
1132         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1133         return int64(value);
1134     }
1135 
1136     /**
1137      * @dev Returns the downcasted int32 from int256, reverting on
1138      * overflow (when the input is less than smallest int32 or
1139      * greater than largest int32).
1140      *
1141      * Counterpart to Solidity's `int32` operator.
1142      *
1143      * Requirements:
1144      *
1145      * - input must fit into 32 bits
1146      *
1147      * _Available since v3.1._
1148      */
1149     function toInt32(int256 value) internal pure returns (int32) {
1150         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1151         return int32(value);
1152     }
1153 
1154     /**
1155      * @dev Returns the downcasted int16 from int256, reverting on
1156      * overflow (when the input is less than smallest int16 or
1157      * greater than largest int16).
1158      *
1159      * Counterpart to Solidity's `int16` operator.
1160      *
1161      * Requirements:
1162      *
1163      * - input must fit into 16 bits
1164      *
1165      * _Available since v3.1._
1166      */
1167     function toInt16(int256 value) internal pure returns (int16) {
1168         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1169         return int16(value);
1170     }
1171 
1172     /**
1173      * @dev Returns the downcasted int8 from int256, reverting on
1174      * overflow (when the input is less than smallest int8 or
1175      * greater than largest int8).
1176      *
1177      * Counterpart to Solidity's `int8` operator.
1178      *
1179      * Requirements:
1180      *
1181      * - input must fit into 8 bits.
1182      *
1183      * _Available since v3.1._
1184      */
1185     function toInt8(int256 value) internal pure returns (int8) {
1186         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1187         return int8(value);
1188     }
1189 
1190     /**
1191      * @dev Converts an unsigned uint256 into a signed int256.
1192      *
1193      * Requirements:
1194      *
1195      * - input must be less than or equal to maxInt256.
1196      */
1197     function toInt256(uint256 value) internal pure returns (int256) {
1198         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1199         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1200         return int256(value);
1201     }
1202 }
1203 
1204 contract PUREBLOOD is ERC20, Ownable {
1205     using SafeMath for uint256;
1206 
1207     IUniswapV2Router02 public uniswapV2Router;
1208     address public immutable uniswapV2Pair;
1209 
1210     bool private inSwapAndLiquify;
1211 
1212     bool public swapAndLiquifyEnabled = true;
1213 
1214     uint256 public maxSellTransactionAmount = 25000000000000 * (10**18);
1215     uint256 public maxBuyTransactionAmount = 25000000000000 * (10**18);
1216     uint256 public swapTokensAtAmount = 100000000000 * (10**18);
1217 
1218     uint256 public liquidityFee = 5;
1219     uint256 public charityFee = 5;
1220     address public  charityWallet = 0xc0195c99bf9Dd9678d20055152E238609d3f57B8;
1221 
1222     // exlcude from fees and max transaction amount
1223     mapping (address => bool) private _isExcludedFromFees;
1224     
1225     mapping(address => bool) private _isExcludedFromMaxTx;
1226 
1227     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1228     // could be subject to a maximum transfer amount
1229     mapping (address => bool) public automatedMarketMakerPairs;
1230 
1231     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1232 
1233     event ExcludeFromFees(address indexed account, bool isExcluded);
1234     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1235 
1236     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1237 
1238     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1239 
1240     event SwapAndLiquifyEnabledUpdated(bool enabled);
1241 
1242     event SwapAndLiquify(
1243         uint256 tokensIntoLiqudity,
1244         uint256 ethReceived
1245     );
1246 
1247     modifier lockTheSwap {
1248         inSwapAndLiquify = true;
1249         _;
1250         inSwapAndLiquify = false;
1251     }
1252 
1253     function setFee(uint256 _liquidityFee, uint256 _charityFee) public onlyOwner {
1254         liquidityFee = _liquidityFee;
1255         charityFee = _charityFee;
1256     }
1257 
1258     function setMaxSellTransaction(uint256 _maxSellTxAmount) public onlyOwner {
1259         maxSellTransactionAmount = _maxSellTxAmount;
1260     }
1261     
1262     function setMaxBuyTransaction(uint256 _maxBuyTxAmount) public onlyOwner {
1263         maxBuyTransactionAmount = _maxBuyTxAmount;
1264     }
1265 
1266     constructor() ERC20("PUREBLOOD", "PUREBLOOD") {
1267 
1268     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1269          // Create a uniswap pair for this new token
1270         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1271             .createPair(address(this), _uniswapV2Router.WETH());
1272 
1273         uniswapV2Router = _uniswapV2Router;
1274         uniswapV2Pair = _uniswapV2Pair;
1275 
1276         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1277 
1278         // exclude from paying fees or having max transaction amount
1279         excludeFromFees(owner(), true);
1280         excludeFromFees(charityWallet, true);
1281         excludeFromFees(address(this), true);
1282         
1283         // exclude from max tx
1284         _isExcludedFromMaxTx[owner()] = true;
1285         _isExcludedFromMaxTx[address(this)] = true;
1286         _isExcludedFromMaxTx[charityWallet] = true;
1287         
1288 
1289         /*
1290             _mint is an internal function in ERC20.sol that is only called here,
1291             and CANNOT be called ever again
1292         */
1293         _mint(owner(), 25000000000000 * (10**18));
1294     }
1295 
1296     receive() external payable {
1297 
1298   	}
1299 
1300     function updateUniswapV2Router(address newAddress) public onlyOwner {
1301         require(newAddress != address(uniswapV2Router), "CJP: The router already has that address");
1302         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1303         uniswapV2Router = IUniswapV2Router02(newAddress);
1304     }
1305 
1306     function excludeFromFees(address account, bool excluded) public onlyOwner {
1307         require(_isExcludedFromFees[account] != excluded, "CJP: Account is already the value of 'excluded'");
1308         _isExcludedFromFees[account] = excluded;
1309 
1310         emit ExcludeFromFees(account, excluded);
1311     }
1312     
1313     function setExcludeFromMaxTx(address _address, bool value) public onlyOwner { 
1314         _isExcludedFromMaxTx[_address] = value;
1315     }
1316 
1317     function setExcludeFromAll(address _address) public onlyOwner {
1318         _isExcludedFromMaxTx[_address] = true;
1319         _isExcludedFromFees[_address] = true;
1320     }
1321 
1322     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1323         for(uint256 i = 0; i < accounts.length; i++) {
1324             _isExcludedFromFees[accounts[i]] = excluded;
1325         }
1326 
1327         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1328     }
1329 
1330     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1331         require(pair != uniswapV2Pair, "CJP: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1332 
1333         _setAutomatedMarketMakerPair(pair, value);
1334     }
1335 
1336     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1337         require(automatedMarketMakerPairs[pair] != value, "CJP: Automated market maker pair is already set to that value");
1338         automatedMarketMakerPairs[pair] = value;
1339 
1340         emit SetAutomatedMarketMakerPair(pair, value);
1341     }
1342     
1343     function isExcludedFromFees(address account) public view returns(bool) {
1344         return _isExcludedFromFees[account];
1345     }
1346     
1347     function isExcludedFromMaxTx(address account) public view returns(bool) {
1348         return _isExcludedFromMaxTx[account];
1349     }
1350 
1351     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1352         swapAndLiquifyEnabled = _enabled;
1353         emit SwapAndLiquifyEnabledUpdated(_enabled);
1354     }
1355 
1356     function _transfer(
1357         address from,
1358         address to,
1359         uint256 amount
1360     ) internal override {
1361         require(from != address(0), "ERC20: transfer from the zero address");
1362         require(to != address(0), "ERC20: transfer to the zero address");
1363 
1364         if(amount == 0) {
1365             super._transfer(from, to, 0);
1366             return;
1367         }
1368         
1369         if(automatedMarketMakerPairs[from] && (!_isExcludedFromMaxTx[from]) && (!_isExcludedFromMaxTx[to])){
1370             require(amount <= maxBuyTransactionAmount, "amount exceeds the maxBuyTransactionAmount.");
1371         }
1372 
1373         if(automatedMarketMakerPairs[to] && (!_isExcludedFromMaxTx[from]) && (!_isExcludedFromMaxTx[to])){
1374             require(amount <= maxSellTransactionAmount, "amount exceeds the maxSellTransactionAmount.");
1375         }
1376         
1377 
1378     	uint256 contractTokenBalance = balanceOf(address(this));
1379         
1380         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
1381        
1382         if(
1383             overMinTokenBalance &&
1384             !inSwapAndLiquify &&
1385             automatedMarketMakerPairs[to] && 
1386             swapAndLiquifyEnabled
1387         ) {
1388             swapAndLiquify(contractTokenBalance);
1389         }
1390 
1391          // if any account belongs to _isExcludedFromFee account then remove the fee
1392         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to] && automatedMarketMakerPairs[to]) {
1393         	uint256 _liquidityfees = amount.mul(liquidityFee).div(100);
1394             uint256 _charityfees = amount.mul(charityFee).div(100);
1395         	amount = amount.sub(_liquidityfees.add(_charityfees));
1396             super._transfer(from, address(this), _liquidityfees); 
1397             super._transfer(from, charityWallet, _charityfees);
1398             
1399         }
1400 
1401         super._transfer(from, to, amount);
1402 
1403     }
1404 
1405      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1406         
1407         // split the Liquidity token balance into halves
1408         uint256 half = contractTokenBalance.div(2);
1409         uint256 otherHalf = contractTokenBalance.sub(half);
1410 
1411         // capture the contract's current ETH balance.
1412         // this is so that we can capture exactly the amount of ETH that the
1413         // swap creates, and not make the liquidity event include any ETH that
1414         // has been manually sent to the contract
1415         uint256 initialBalance = address(this).balance;
1416 
1417         // swap tokens for ETH
1418         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1419 
1420         // how much ETH did we just swap into?
1421         uint256 newBalance = address(this).balance.sub(initialBalance);
1422 
1423         // add liquidity to uniswap
1424         addLiquidity(otherHalf, newBalance);
1425 
1426         emit SwapAndLiquify(half, newBalance);
1427     }
1428 
1429     function swapTokensForEth(uint256 tokenAmount) private {
1430 
1431         
1432         // generate the uniswap pair path of token -> weth
1433         address[] memory path = new address[](2);
1434         path[0] = address(this);
1435         path[1] = uniswapV2Router.WETH();
1436 
1437         if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) {
1438           _approve(address(this), address(uniswapV2Router), ~uint256(0));
1439         }
1440 
1441         // make the swap
1442         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1443             tokenAmount,
1444             0, // accept any amount of ETH
1445             path,
1446             address(this),
1447             block.timestamp
1448         );
1449         
1450     }
1451 
1452     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1453         
1454         // add the liquidity
1455         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1456             address(this),
1457             tokenAmount,
1458             0, // slippage is unavoidable
1459             0, // slippage is unavoidable
1460             owner(),
1461             block.timestamp
1462         );
1463         
1464     }
1465   
1466 }