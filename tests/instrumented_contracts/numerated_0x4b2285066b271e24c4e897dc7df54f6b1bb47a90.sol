1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.13;
3 
4 
5 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
6 
7 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Emitted when `value` tokens are moved from one account (`from`) to
15      * another (`to`).
16      *
17      * Note that `value` may be zero.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
23      * a call to {approve}. `value` is the new allowance.
24      */
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
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
38      * @dev Moves `amount` tokens from the caller's account to `to`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address to, uint256 amount) external returns (bool);
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
72      * @dev Moves `amount` tokens from `from` to `to` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(address from, address to, uint256 amount) external returns (bool);
81 }
82 
83 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
84 
85 /**
86  * @dev Interface for the optional metadata functions from the ERC20 standard.
87  *
88  * _Available since v4.1._
89  */
90 interface IERC20Metadata is IERC20 {
91     /**
92      * @dev Returns the name of the token.
93      */
94     function name() external view returns (string memory);
95 
96     /**
97      * @dev Returns the symbol of the token.
98      */
99     function symbol() external view returns (string memory);
100 
101     /**
102      * @dev Returns the decimals places of the token.
103      */
104     function decimals() external view returns (uint8);
105 }
106 
107 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
108 
109 /**
110  * @dev Provides information about the current execution context, including the
111  * sender of the transaction and its data. While these are generally available
112  * via msg.sender and msg.data, they should not be accessed in such a direct
113  * manner, since when dealing with meta-transactions the account sending and
114  * paying for execution may not be the actual sender (as far as an application
115  * is concerned).
116  *
117  * This contract is only required for intermediate, library-like contracts.
118  */
119 abstract contract Context {
120     function _msgSender() internal view virtual returns (address) {
121         return msg.sender;
122     }
123 
124     function _msgData() internal view virtual returns (bytes calldata) {
125         return msg.data;
126     }
127 }
128 
129 /**
130  * @dev Implementation of the {IERC20} interface.
131  *
132  * This implementation is agnostic to the way tokens are created. This means
133  * that a supply mechanism has to be added in a derived contract using {_mint}.
134  * For a generic mechanism see {ERC20PresetMinterPauser}.
135  *
136  * TIP: For a detailed writeup see our guide
137  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
138  * to implement supply mechanisms].
139  *
140  * The default value of {decimals} is 18. To change this, you should override
141  * this function so it returns a different value.
142  *
143  * We have followed general OpenZeppelin Contracts guidelines: functions revert
144  * instead returning `false` on failure. This behavior is nonetheless
145  * conventional and does not conflict with the expectations of ERC20
146  * applications.
147  *
148  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
149  * This allows applications to reconstruct the allowance for all accounts just
150  * by listening to said events. Other implementations of the EIP may not emit
151  * these events, as it isn't required by the specification.
152  *
153  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
154  * functions have been added to mitigate the well-known issues around setting
155  * allowances. See {IERC20-approve}.
156  */
157 contract ERC20 is Context, IERC20, IERC20Metadata {
158     mapping(address => uint256) private _balances;
159 
160     mapping(address => mapping(address => uint256)) private _allowances;
161 
162     uint256 private _totalSupply;
163 
164     string private _name;
165     string private _symbol;
166 
167     /**
168      * @dev Sets the values for {name} and {symbol}.
169      *
170      * All two of these values are immutable: they can only be set once during
171      * construction.
172      */
173     constructor(string memory name_, string memory symbol_) {
174         _name = name_;
175         _symbol = symbol_;
176     }
177 
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() public view virtual override returns (string memory) {
182         return _name;
183     }
184 
185     /**
186      * @dev Returns the symbol of the token, usually a shorter version of the
187      * name.
188      */
189     function symbol() public view virtual override returns (string memory) {
190         return _symbol;
191     }
192 
193     /**
194      * @dev Returns the number of decimals used to get its user representation.
195      * For example, if `decimals` equals `2`, a balance of `505` tokens should
196      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
197      *
198      * Tokens usually opt for a value of 18, imitating the relationship between
199      * Ether and Wei. This is the default value returned by this function, unless
200      * it's overridden.
201      *
202      * NOTE: This information is only used for _display_ purposes: it in
203      * no way affects any of the arithmetic of the contract, including
204      * {IERC20-balanceOf} and {IERC20-transfer}.
205      */
206     function decimals() public view virtual override returns (uint8) {
207         return 18;
208     }
209 
210     /**
211      * @dev See {IERC20-totalSupply}.
212      */
213     function totalSupply() public view virtual override returns (uint256) {
214         return _totalSupply;
215     }
216 
217     /**
218      * @dev See {IERC20-balanceOf}.
219      */
220     function balanceOf(address account) public view virtual override returns (uint256) {
221         return _balances[account];
222     }
223 
224     /**
225      * @dev See {IERC20-transfer}.
226      *
227      * Requirements:
228      *
229      * - `to` cannot be the zero address.
230      * - the caller must have a balance of at least `amount`.
231      */
232     function transfer(address to, uint256 amount) public virtual override returns (bool) {
233         address owner = _msgSender();
234         _transfer(owner, to, amount);
235         return true;
236     }
237 
238     /**
239      * @dev See {IERC20-allowance}.
240      */
241     function allowance(address owner, address spender) public view virtual override returns (uint256) {
242         return _allowances[owner][spender];
243     }
244 
245     /**
246      * @dev See {IERC20-approve}.
247      *
248      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
249      * `transferFrom`. This is semantically equivalent to an infinite approval.
250      *
251      * Requirements:
252      *
253      * - `spender` cannot be the zero address.
254      */
255     function approve(address spender, uint256 amount) public virtual override returns (bool) {
256         address owner = _msgSender();
257         _approve(owner, spender, amount);
258         return true;
259     }
260 
261     /**
262      * @dev See {IERC20-transferFrom}.
263      *
264      * Emits an {Approval} event indicating the updated allowance. This is not
265      * required by the EIP. See the note at the beginning of {ERC20}.
266      *
267      * NOTE: Does not update the allowance if the current allowance
268      * is the maximum `uint256`.
269      *
270      * Requirements:
271      *
272      * - `from` and `to` cannot be the zero address.
273      * - `from` must have a balance of at least `amount`.
274      * - the caller must have allowance for ``from``'s tokens of at least
275      * `amount`.
276      */
277     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
278         address spender = _msgSender();
279         _spendAllowance(from, spender, amount);
280         _transfer(from, to, amount);
281         return true;
282     }
283 
284     /**
285      * @dev Atomically increases the allowance granted to `spender` by the caller.
286      *
287      * This is an alternative to {approve} that can be used as a mitigation for
288      * problems described in {IERC20-approve}.
289      *
290      * Emits an {Approval} event indicating the updated allowance.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      */
296     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
297         address owner = _msgSender();
298         _approve(owner, spender, allowance(owner, spender) + addedValue);
299         return true;
300     }
301 
302     /**
303      * @dev Atomically decreases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to {approve} that can be used as a mitigation for
306      * problems described in {IERC20-approve}.
307      *
308      * Emits an {Approval} event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      * - `spender` must have allowance for the caller of at least
314      * `subtractedValue`.
315      */
316     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
317         address owner = _msgSender();
318         uint256 currentAllowance = allowance(owner, spender);
319         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
320         unchecked {
321             _approve(owner, spender, currentAllowance - subtractedValue);
322         }
323 
324         return true;
325     }
326 
327     /**
328      * @dev Moves `amount` of tokens from `from` to `to`.
329      *
330      * This internal function is equivalent to {transfer}, and can be used to
331      * e.g. implement automatic token fees, slashing mechanisms, etc.
332      *
333      * Emits a {Transfer} event.
334      *
335      * Requirements:
336      *
337      * - `from` cannot be the zero address.
338      * - `to` cannot be the zero address.
339      * - `from` must have a balance of at least `amount`.
340      */
341     function _transfer(address from, address to, uint256 amount) internal virtual {
342         require(from != address(0), "ERC20: transfer from the zero address");
343         require(to != address(0), "ERC20: transfer to the zero address");
344 
345         _beforeTokenTransfer(from, to, amount);
346 
347         uint256 fromBalance = _balances[from];
348         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
349         unchecked {
350             _balances[from] = fromBalance - amount;
351             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
352             // decrementing then incrementing.
353             _balances[to] += amount;
354         }
355 
356         emit Transfer(from, to, amount);
357 
358         _afterTokenTransfer(from, to, amount);
359     }
360 
361     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
362      * the total supply.
363      *
364      * Emits a {Transfer} event with `from` set to the zero address.
365      *
366      * Requirements:
367      *
368      * - `account` cannot be the zero address.
369      */
370     function _mint(address account, uint256 amount) internal virtual {
371         require(account != address(0), "ERC20: mint to the zero address");
372 
373         _beforeTokenTransfer(address(0), account, amount);
374 
375         _totalSupply += amount;
376         unchecked {
377             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
378             _balances[account] += amount;
379         }
380         emit Transfer(address(0), account, amount);
381 
382         _afterTokenTransfer(address(0), account, amount);
383     }
384 
385     /**
386      * @dev Destroys `amount` tokens from `account`, reducing the
387      * total supply.
388      *
389      * Emits a {Transfer} event with `to` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      * - `account` must have at least `amount` tokens.
395      */
396     function _burn(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: burn from the zero address");
398 
399         _beforeTokenTransfer(account, address(0), amount);
400 
401         uint256 accountBalance = _balances[account];
402         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
403         unchecked {
404             _balances[account] = accountBalance - amount;
405             // Overflow not possible: amount <= accountBalance <= totalSupply.
406             _totalSupply -= amount;
407         }
408 
409         emit Transfer(account, address(0), amount);
410 
411         _afterTokenTransfer(account, address(0), amount);
412     }
413 
414     /**
415      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
416      *
417      * This internal function is equivalent to `approve`, and can be used to
418      * e.g. set automatic allowances for certain subsystems, etc.
419      *
420      * Emits an {Approval} event.
421      *
422      * Requirements:
423      *
424      * - `owner` cannot be the zero address.
425      * - `spender` cannot be the zero address.
426      */
427     function _approve(address owner, address spender, uint256 amount) internal virtual {
428         require(owner != address(0), "ERC20: approve from the zero address");
429         require(spender != address(0), "ERC20: approve to the zero address");
430 
431         _allowances[owner][spender] = amount;
432         emit Approval(owner, spender, amount);
433     }
434 
435     /**
436      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
437      *
438      * Does not update the allowance amount in case of infinite allowance.
439      * Revert if not enough allowance is available.
440      *
441      * Might emit an {Approval} event.
442      */
443     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
444         uint256 currentAllowance = allowance(owner, spender);
445         if (currentAllowance != type(uint256).max) {
446             require(currentAllowance >= amount, "ERC20: insufficient allowance");
447             unchecked {
448                 _approve(owner, spender, currentAllowance - amount);
449             }
450         }
451     }
452 
453     /**
454      * @dev Hook that is called before any transfer of tokens. This includes
455      * minting and burning.
456      *
457      * Calling conditions:
458      *
459      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
460      * will be transferred to `to`.
461      * - when `from` is zero, `amount` tokens will be minted for `to`.
462      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
463      * - `from` and `to` are never both zero.
464      *
465      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
466      */
467     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
468 
469     /**
470      * @dev Hook that is called after any transfer of tokens. This includes
471      * minting and burning.
472      *
473      * Calling conditions:
474      *
475      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
476      * has been transferred to `to`.
477      * - when `from` is zero, `amount` tokens have been minted for `to`.
478      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
479      * - `from` and `to` are never both zero.
480      *
481      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
482      */
483     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
484 }
485 
486 
487 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
488 
489 /**
490  * @dev Contract module which provides a basic access control mechanism, where
491  * there is an account (an owner) that can be granted exclusive access to
492  * specific functions.
493  *
494  * By default, the owner account will be the one that deploys the contract. This
495  * can later be changed with {transferOwnership}.
496  *
497  * This module is used through inheritance. It will make available the modifier
498  * `onlyOwner`, which can be applied to your functions to restrict their use to
499  * the owner.
500  */
501 abstract contract Ownable is Context {
502     address private _owner;
503 
504     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
505 
506     /**
507      * @dev Initializes the contract setting the deployer as the initial owner.
508      */
509     constructor() {
510         _transferOwnership(_msgSender());
511     }
512 
513     /**
514      * @dev Throws if called by any account other than the owner.
515      */
516     modifier onlyOwner() {
517         _checkOwner();
518         _;
519     }
520 
521     /**
522      * @dev Returns the address of the current owner.
523      */
524     function owner() public view virtual returns (address) {
525         return _owner;
526     }
527 
528     /**
529      * @dev Throws if the sender is not the owner.
530      */
531     function _checkOwner() internal view virtual {
532         require(owner() == _msgSender(), "Ownable: caller is not the owner");
533     }
534 
535     /**
536      * @dev Leaves the contract without owner. It will not be possible to call
537      * `onlyOwner` functions. Can only be called by the current owner.
538      *
539      * NOTE: Renouncing ownership will leave the contract without an owner,
540      * thereby disabling any functionality that is only available to the owner.
541      */
542     function renounceOwnership() public virtual onlyOwner {
543         _transferOwnership(address(0));
544     }
545 
546     /**
547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
548      * Can only be called by the current owner.
549      */
550     function transferOwnership(address newOwner) public virtual onlyOwner {
551         require(newOwner != address(0), "Ownable: new owner is the zero address");
552         _transferOwnership(newOwner);
553     }
554 
555     /**
556      * @dev Transfers ownership of the contract to a new account (`newOwner`).
557      * Internal function without access restriction.
558      */
559     function _transferOwnership(address newOwner) internal virtual {
560         address oldOwner = _owner;
561         _owner = newOwner;
562         emit OwnershipTransferred(oldOwner, newOwner);
563     }
564 }
565 
566 
567 
568 
569 
570 interface IUniswapV2Router01 {
571     function factory() external pure returns (address);
572     function WETH() external pure returns (address);
573 
574     function addLiquidity(
575         address tokenA,
576         address tokenB,
577         uint amountADesired,
578         uint amountBDesired,
579         uint amountAMin,
580         uint amountBMin,
581         address to,
582         uint deadline
583     ) external returns (uint amountA, uint amountB, uint liquidity);
584     function addLiquidityETH(
585         address token,
586         uint amountTokenDesired,
587         uint amountTokenMin,
588         uint amountETHMin,
589         address to,
590         uint deadline
591     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
592     function removeLiquidity(
593         address tokenA,
594         address tokenB,
595         uint liquidity,
596         uint amountAMin,
597         uint amountBMin,
598         address to,
599         uint deadline
600     ) external returns (uint amountA, uint amountB);
601     function removeLiquidityETH(
602         address token,
603         uint liquidity,
604         uint amountTokenMin,
605         uint amountETHMin,
606         address to,
607         uint deadline
608     ) external returns (uint amountToken, uint amountETH);
609     function removeLiquidityWithPermit(
610         address tokenA,
611         address tokenB,
612         uint liquidity,
613         uint amountAMin,
614         uint amountBMin,
615         address to,
616         uint deadline,
617         bool approveMax, uint8 v, bytes32 r, bytes32 s
618     ) external returns (uint amountA, uint amountB);
619     function removeLiquidityETHWithPermit(
620         address token,
621         uint liquidity,
622         uint amountTokenMin,
623         uint amountETHMin,
624         address to,
625         uint deadline,
626         bool approveMax, uint8 v, bytes32 r, bytes32 s
627     ) external returns (uint amountToken, uint amountETH);
628     function swapExactTokensForTokens(
629         uint amountIn,
630         uint amountOutMin,
631         address[] calldata path,
632         address to,
633         uint deadline
634     ) external returns (uint[] memory amounts);
635     function swapTokensForExactTokens(
636         uint amountOut,
637         uint amountInMax,
638         address[] calldata path,
639         address to,
640         uint deadline
641     ) external returns (uint[] memory amounts);
642     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
643         external
644         payable
645         returns (uint[] memory amounts);
646     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
647         external
648         returns (uint[] memory amounts);
649     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
650         external
651         returns (uint[] memory amounts);
652     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
653         external
654         payable
655         returns (uint[] memory amounts);
656 
657     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
658     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
659     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
660     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
661     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
662 }
663 
664 
665 interface IUniswapV2Router02 is IUniswapV2Router01 {
666     function removeLiquidityETHSupportingFeeOnTransferTokens(
667         address token,
668         uint liquidity,
669         uint amountTokenMin,
670         uint amountETHMin,
671         address to,
672         uint deadline
673     ) external returns (uint amountETH);
674     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
675         address token,
676         uint liquidity,
677         uint amountTokenMin,
678         uint amountETHMin,
679         address to,
680         uint deadline,
681         bool approveMax, uint8 v, bytes32 r, bytes32 s
682     ) external returns (uint amountETH);
683 
684     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
685         uint amountIn,
686         uint amountOutMin,
687         address[] calldata path,
688         address to,
689         uint deadline
690     ) external;
691     function swapExactETHForTokensSupportingFeeOnTransferTokens(
692         uint amountOutMin,
693         address[] calldata path,
694         address to,
695         uint deadline
696     ) external payable;
697     function swapExactTokensForETHSupportingFeeOnTransferTokens(
698         uint amountIn,
699         uint amountOutMin,
700         address[] calldata path,
701         address to,
702         uint deadline
703     ) external;
704 }
705 
706 
707 
708 interface IUniswapV2Factory {
709     event PairCreated(
710         address indexed token0,
711         address indexed token1,
712         address pair,
713         uint
714     );
715 
716     function feeTo() external view returns (address);
717 
718     function feeToSetter() external view returns (address);
719 
720     function getPair(
721         address tokenA,
722         address tokenB
723     ) external view returns (address pair);
724 
725     function allPairs(uint) external view returns (address pair);
726 
727     function allPairsLength() external view returns (uint);
728 
729     function createPair(
730         address tokenA,
731         address tokenB
732     ) external returns (address pair);
733 
734     function setFeeTo(address) external;
735 
736     function setFeeToSetter(address) external;
737 }
738 
739 
740 pragma solidity >=0.5.0;
741 
742 interface IPinkAntiBot {
743     function setTokenOwner(address owner) external;
744 
745     function onPreTransferCheck(
746         address from,
747         address to,
748         uint256 amount
749     ) external;
750 }
751 
752 contract FomcToken is ERC20, Ownable {
753     event RecoverFunds(address _token);
754     address public vault = address(0);
755     address public lpPair = address(0);
756     address public taxAddress = address(0);
757     uint16 public lpTax = 300;
758     IUniswapV2Router02 public uniV2Router = IUniswapV2Router02(address(0));
759 
760     bool public initialDistribution = false;
761     bool public inSwap = false;
762 
763     IPinkAntiBot public pinkAntiBot;
764     bool public antiBotToggle = false;
765     modifier swapping() {
766         require(inSwap == false, "reentrant call");
767         inSwap = true;
768         _;
769         inSwap = false;
770     }
771 
772     constructor(
773         uint256 totalSupply,
774         address _univ2router,
775         address _antibot,
776         address multisig
777     ) ERC20("FOMC", "FOMC") {
778         _mint(multisig, totalSupply * (1 * 10 ** decimals()));
779         transferOwnership(multisig);
780         pinkAntiBot = IPinkAntiBot(_antibot);
781         pinkAntiBot.setTokenOwner(msg.sender);
782 
783         uniV2Router = IUniswapV2Router02(_univ2router);
784         lpPair = IUniswapV2Factory(uniV2Router.factory()).createPair(
785             address(this),
786             IUniswapV2Router02(uniV2Router).WETH()
787         );
788 
789         _approve(address(this), _univ2router, type(uint256).max);
790         _approve(address(this), lpPair, type(uint256).max);
791         _approve(address(this), address(this), type(uint256).max);
792     }
793 
794     function disableAntibot() public onlyOwner {
795         require(antiBotToggle, "antibot not enabled");
796         antiBotToggle = false;
797     }
798 
799     function setup(
800         address _vault,
801         uint16 _lpTax,
802         bool _antibotToggle
803     ) public onlyOwner {
804         require(vault == address(0), "already setup");
805         vault = _vault;
806         lpTax = _lpTax;
807 
808         antiBotToggle = _antibotToggle;
809         pinkAntiBot.setTokenOwner(owner());
810 
811         initialDistribution = true;
812     }
813 
814     function recoverToken(address _token) external onlyOwner {
815         if (_token == address(0)) {
816             uint256 balance = address(this).balance;
817             (bool success, ) = payable(msg.sender).call{value: balance}("");
818             require(success, "balance failed");
819         } else {
820             IERC20(_token).transfer(
821                 msg.sender,
822                 IERC20(_token).balanceOf(address(this))
823             );
824         }
825 
826         emit RecoverFunds(_token);
827     }
828 
829     function shouldSellTax() internal view returns (bool) {
830         return
831             msg.sender != lpPair &&
832             !inSwap &&
833             (balanceOf(address(this)) > 1 * 10 ** decimals());
834     }
835 
836     function _liquidateToken() internal swapping {
837         address[] memory path = new address[](2);
838         path[0] = address(this);
839         path[1] = uniV2Router.WETH();
840 
841         uniV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
842             balanceOf(address(this)),
843             0,
844             path,
845             vault,
846             block.timestamp
847         );
848     }
849 
850     function _hasRoundEnded() public view returns (bool) {
851         require(vault != address(0), "invalid vault");
852         (bool success, bytes memory returnVal) = address(vault).staticcall(
853             abi.encodeWithSignature("hasEnded()")
854         );
855         require(success, "invalid round end");
856         return abi.decode(returnVal, (bool));
857     }
858 
859     function _doTax(
860         address from,
861         address to,
862         uint256 amount
863     ) internal returns (uint256 taxedAmount) {
864         require(
865             initialDistribution || (from == owner() || to == owner()),
866             "trading not started"
867         );
868 
869         taxedAmount = amount;
870         if (vault == address(0)) {
871             return taxedAmount;
872         }
873 
874         if ((from == address(this) || to == address(this))) return taxedAmount;
875 
876         if ((_hasRoundEnded() == false) && (initialDistribution == true)) {
877             if (shouldSellTax()) {
878                 _liquidateToken();
879             }
880             if ((from == lpPair) || (to == lpPair)) {
881                 uint256 tax = (amount * lpTax) / 100_00;
882                 taxedAmount = (amount - tax);
883                 _transfer(from, address(this), tax);
884             }
885         }
886     }
887 
888     function transfer(
889         address recipient,
890         uint256 amount
891     ) public virtual override returns (bool) {
892         address owner = _msgSender();
893 
894         if (inSwap) {
895             _transfer(owner, recipient, amount);
896         } else {
897             if (antiBotToggle) {
898                 pinkAntiBot.onPreTransferCheck(owner, recipient, amount);
899             }
900 
901             _transfer(owner, recipient, _doTax(owner, recipient, amount));
902         }
903 
904         return true;
905     }
906 
907     function transferFrom(
908         address from,
909         address to,
910         uint256 amount
911     ) public virtual override returns (bool) {
912         address spender = _msgSender();
913         _spendAllowance(from, spender, amount);
914 
915         if (inSwap) {
916             _transfer(from, to, amount);
917         } else {
918             if (antiBotToggle) {
919                 pinkAntiBot.onPreTransferCheck(from, to, amount);
920             }
921 
922             _transfer(from, to, _doTax(from, to, amount));
923         }
924         return true;
925     }
926 
927     receive() external payable {}
928 
929     fallback() external payable {}
930 }