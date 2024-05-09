1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.13;
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 /**
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
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         _checkOwner();
57         _;
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if the sender is not the owner.
69      */
70     function _checkOwner() internal view virtual {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby disabling any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
106 
107 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP.
111  */
112 interface IERC20 {
113     /**
114      * @dev Emitted when `value` tokens are moved from one account (`from`) to
115      * another (`to`).
116      *
117      * Note that `value` may be zero.
118      */
119     event Transfer(address indexed from, address indexed to, uint256 value);
120 
121     /**
122      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
123      * a call to {approve}. `value` is the new allowance.
124      */
125     event Approval(address indexed owner, address indexed spender, uint256 value);
126 
127     /**
128      * @dev Returns the amount of tokens in existence.
129      */
130     function totalSupply() external view returns (uint256);
131 
132     /**
133      * @dev Returns the amount of tokens owned by `account`.
134      */
135     function balanceOf(address account) external view returns (uint256);
136 
137     /**
138      * @dev Moves `amount` tokens from the caller's account to `to`.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transfer(address to, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Returns the remaining number of tokens that `spender` will be
148      * allowed to spend on behalf of `owner` through {transferFrom}. This is
149      * zero by default.
150      *
151      * This value changes when {approve} or {transferFrom} are called.
152      */
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     /**
156      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * IMPORTANT: Beware that changing an allowance with this method brings the risk
161      * that someone may use both the old and the new allowance by unfortunate
162      * transaction ordering. One possible solution to mitigate this race
163      * condition is to first reduce the spender's allowance to 0 and set the
164      * desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      *
167      * Emits an {Approval} event.
168      */
169     function approve(address spender, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Moves `amount` tokens from `from` to `to` using the
173      * allowance mechanism. `amount` is then deducted from the caller's
174      * allowance.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transferFrom(address from, address to, uint256 amount) external returns (bool);
181 }
182 
183 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
184 
185 /**
186  * @dev Interface for the optional metadata functions from the ERC20 standard.
187  *
188  * _Available since v4.1._
189  */
190 interface IERC20Metadata is IERC20 {
191     /**
192      * @dev Returns the name of the token.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the symbol of the token.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the decimals places of the token.
203      */
204     function decimals() external view returns (uint8);
205 }
206 
207 /**
208  * @dev Implementation of the {IERC20} interface.
209  *
210  * This implementation is agnostic to the way tokens are created. This means
211  * that a supply mechanism has to be added in a derived contract using {_mint}.
212  * For a generic mechanism see {ERC20PresetMinterPauser}.
213  *
214  * TIP: For a detailed writeup see our guide
215  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
216  * to implement supply mechanisms].
217  *
218  * The default value of {decimals} is 18. To change this, you should override
219  * this function so it returns a different value.
220  *
221  * We have followed general OpenZeppelin Contracts guidelines: functions revert
222  * instead returning `false` on failure. This behavior is nonetheless
223  * conventional and does not conflict with the expectations of ERC20
224  * applications.
225  *
226  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
227  * This allows applications to reconstruct the allowance for all accounts just
228  * by listening to said events. Other implementations of the EIP may not emit
229  * these events, as it isn't required by the specification.
230  *
231  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
232  * functions have been added to mitigate the well-known issues around setting
233  * allowances. See {IERC20-approve}.
234  */
235 contract ERC20 is Context, IERC20, IERC20Metadata {
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
248      * All two of these values are immutable: they can only be set once during
249      * construction.
250      */
251     constructor(string memory name_, string memory symbol_) {
252         _name = name_;
253         _symbol = symbol_;
254     }
255 
256     /**
257      * @dev Returns the name of the token.
258      */
259     function name() public view virtual override returns (string memory) {
260         return _name;
261     }
262 
263     /**
264      * @dev Returns the symbol of the token, usually a shorter version of the
265      * name.
266      */
267     function symbol() public view virtual override returns (string memory) {
268         return _symbol;
269     }
270 
271     /**
272      * @dev Returns the number of decimals used to get its user representation.
273      * For example, if `decimals` equals `2`, a balance of `505` tokens should
274      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
275      *
276      * Tokens usually opt for a value of 18, imitating the relationship between
277      * Ether and Wei. This is the default value returned by this function, unless
278      * it's overridden.
279      *
280      * NOTE: This information is only used for _display_ purposes: it in
281      * no way affects any of the arithmetic of the contract, including
282      * {IERC20-balanceOf} and {IERC20-transfer}.
283      */
284     function decimals() public view virtual override returns (uint8) {
285         return 18;
286     }
287 
288     /**
289      * @dev See {IERC20-totalSupply}.
290      */
291     function totalSupply() public view virtual override returns (uint256) {
292         return _totalSupply;
293     }
294 
295     /**
296      * @dev See {IERC20-balanceOf}.
297      */
298     function balanceOf(address account) public view virtual override returns (uint256) {
299         return _balances[account];
300     }
301 
302     /**
303      * @dev See {IERC20-transfer}.
304      *
305      * Requirements:
306      *
307      * - `to` cannot be the zero address.
308      * - the caller must have a balance of at least `amount`.
309      */
310     function transfer(address to, uint256 amount) public virtual override returns (bool) {
311         address owner = _msgSender();
312         _transfer(owner, to, amount);
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
326      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
327      * `transferFrom`. This is semantically equivalent to an infinite approval.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function approve(address spender, uint256 amount) public virtual override returns (bool) {
334         address owner = _msgSender();
335         _approve(owner, spender, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-transferFrom}.
341      *
342      * Emits an {Approval} event indicating the updated allowance. This is not
343      * required by the EIP. See the note at the beginning of {ERC20}.
344      *
345      * NOTE: Does not update the allowance if the current allowance
346      * is the maximum `uint256`.
347      *
348      * Requirements:
349      *
350      * - `from` and `to` cannot be the zero address.
351      * - `from` must have a balance of at least `amount`.
352      * - the caller must have allowance for ``from``'s tokens of at least
353      * `amount`.
354      */
355     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
356         address spender = _msgSender();
357         _spendAllowance(from, spender, amount);
358         _transfer(from, to, amount);
359         return true;
360     }
361 
362     /**
363      * @dev Atomically increases the allowance granted to `spender` by the caller.
364      *
365      * This is an alternative to {approve} that can be used as a mitigation for
366      * problems described in {IERC20-approve}.
367      *
368      * Emits an {Approval} event indicating the updated allowance.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
375         address owner = _msgSender();
376         _approve(owner, spender, allowance(owner, spender) + addedValue);
377         return true;
378     }
379 
380     /**
381      * @dev Atomically decreases the allowance granted to `spender` by the caller.
382      *
383      * This is an alternative to {approve} that can be used as a mitigation for
384      * problems described in {IERC20-approve}.
385      *
386      * Emits an {Approval} event indicating the updated allowance.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      * - `spender` must have allowance for the caller of at least
392      * `subtractedValue`.
393      */
394     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
395         address owner = _msgSender();
396         uint256 currentAllowance = allowance(owner, spender);
397         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
398         unchecked {
399             _approve(owner, spender, currentAllowance - subtractedValue);
400         }
401 
402         return true;
403     }
404 
405     /**
406      * @dev Moves `amount` of tokens from `from` to `to`.
407      *
408      * This internal function is equivalent to {transfer}, and can be used to
409      * e.g. implement automatic token fees, slashing mechanisms, etc.
410      *
411      * Emits a {Transfer} event.
412      *
413      * Requirements:
414      *
415      * - `from` cannot be the zero address.
416      * - `to` cannot be the zero address.
417      * - `from` must have a balance of at least `amount`.
418      */
419     function _transfer(address from, address to, uint256 amount) internal virtual {
420         require(from != address(0), "ERC20: transfer from the zero address");
421         require(to != address(0), "ERC20: transfer to the zero address");
422 
423         _beforeTokenTransfer(from, to, amount);
424 
425         uint256 fromBalance = _balances[from];
426         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
427         unchecked {
428             _balances[from] = fromBalance - amount;
429             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
430             // decrementing then incrementing.
431             _balances[to] += amount;
432         }
433 
434         emit Transfer(from, to, amount);
435 
436         _afterTokenTransfer(from, to, amount);
437     }
438 
439     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
440      * the total supply.
441      *
442      * Emits a {Transfer} event with `from` set to the zero address.
443      *
444      * Requirements:
445      *
446      * - `account` cannot be the zero address.
447      */
448     function _mint(address account, uint256 amount) internal virtual {
449         require(account != address(0), "ERC20: mint to the zero address");
450 
451         _beforeTokenTransfer(address(0), account, amount);
452 
453         _totalSupply += amount;
454         unchecked {
455             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
456             _balances[account] += amount;
457         }
458         emit Transfer(address(0), account, amount);
459 
460         _afterTokenTransfer(address(0), account, amount);
461     }
462 
463     /**
464      * @dev Destroys `amount` tokens from `account`, reducing the
465      * total supply.
466      *
467      * Emits a {Transfer} event with `to` set to the zero address.
468      *
469      * Requirements:
470      *
471      * - `account` cannot be the zero address.
472      * - `account` must have at least `amount` tokens.
473      */
474     function _burn(address account, uint256 amount) internal virtual {
475         require(account != address(0), "ERC20: burn from the zero address");
476 
477         _beforeTokenTransfer(account, address(0), amount);
478 
479         uint256 accountBalance = _balances[account];
480         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
481         unchecked {
482             _balances[account] = accountBalance - amount;
483             // Overflow not possible: amount <= accountBalance <= totalSupply.
484             _totalSupply -= amount;
485         }
486 
487         emit Transfer(account, address(0), amount);
488 
489         _afterTokenTransfer(account, address(0), amount);
490     }
491 
492     /**
493      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
494      *
495      * This internal function is equivalent to `approve`, and can be used to
496      * e.g. set automatic allowances for certain subsystems, etc.
497      *
498      * Emits an {Approval} event.
499      *
500      * Requirements:
501      *
502      * - `owner` cannot be the zero address.
503      * - `spender` cannot be the zero address.
504      */
505     function _approve(address owner, address spender, uint256 amount) internal virtual {
506         require(owner != address(0), "ERC20: approve from the zero address");
507         require(spender != address(0), "ERC20: approve to the zero address");
508 
509         _allowances[owner][spender] = amount;
510         emit Approval(owner, spender, amount);
511     }
512 
513     /**
514      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
515      *
516      * Does not update the allowance amount in case of infinite allowance.
517      * Revert if not enough allowance is available.
518      *
519      * Might emit an {Approval} event.
520      */
521     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
522         uint256 currentAllowance = allowance(owner, spender);
523         if (currentAllowance != type(uint256).max) {
524             require(currentAllowance >= amount, "ERC20: insufficient allowance");
525             unchecked {
526                 _approve(owner, spender, currentAllowance - amount);
527             }
528         }
529     }
530 
531     /**
532      * @dev Hook that is called before any transfer of tokens. This includes
533      * minting and burning.
534      *
535      * Calling conditions:
536      *
537      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
538      * will be transferred to `to`.
539      * - when `from` is zero, `amount` tokens will be minted for `to`.
540      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
541      * - `from` and `to` are never both zero.
542      *
543      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
544      */
545     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
546 
547     /**
548      * @dev Hook that is called after any transfer of tokens. This includes
549      * minting and burning.
550      *
551      * Calling conditions:
552      *
553      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
554      * has been transferred to `to`.
555      * - when `from` is zero, `amount` tokens have been minted for `to`.
556      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
557      * - `from` and `to` are never both zero.
558      *
559      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
560      */
561     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
562 }
563 
564 
565 
566 
567 
568 interface IUniswapV2Router01 {
569     function factory() external pure returns (address);
570     function WETH() external pure returns (address);
571 
572     function addLiquidity(
573         address tokenA,
574         address tokenB,
575         uint amountADesired,
576         uint amountBDesired,
577         uint amountAMin,
578         uint amountBMin,
579         address to,
580         uint deadline
581     ) external returns (uint amountA, uint amountB, uint liquidity);
582     function addLiquidityETH(
583         address token,
584         uint amountTokenDesired,
585         uint amountTokenMin,
586         uint amountETHMin,
587         address to,
588         uint deadline
589     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
590     function removeLiquidity(
591         address tokenA,
592         address tokenB,
593         uint liquidity,
594         uint amountAMin,
595         uint amountBMin,
596         address to,
597         uint deadline
598     ) external returns (uint amountA, uint amountB);
599     function removeLiquidityETH(
600         address token,
601         uint liquidity,
602         uint amountTokenMin,
603         uint amountETHMin,
604         address to,
605         uint deadline
606     ) external returns (uint amountToken, uint amountETH);
607     function removeLiquidityWithPermit(
608         address tokenA,
609         address tokenB,
610         uint liquidity,
611         uint amountAMin,
612         uint amountBMin,
613         address to,
614         uint deadline,
615         bool approveMax, uint8 v, bytes32 r, bytes32 s
616     ) external returns (uint amountA, uint amountB);
617     function removeLiquidityETHWithPermit(
618         address token,
619         uint liquidity,
620         uint amountTokenMin,
621         uint amountETHMin,
622         address to,
623         uint deadline,
624         bool approveMax, uint8 v, bytes32 r, bytes32 s
625     ) external returns (uint amountToken, uint amountETH);
626     function swapExactTokensForTokens(
627         uint amountIn,
628         uint amountOutMin,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external returns (uint[] memory amounts);
633     function swapTokensForExactTokens(
634         uint amountOut,
635         uint amountInMax,
636         address[] calldata path,
637         address to,
638         uint deadline
639     ) external returns (uint[] memory amounts);
640     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
641         external
642         payable
643         returns (uint[] memory amounts);
644     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
645         external
646         returns (uint[] memory amounts);
647     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
648         external
649         returns (uint[] memory amounts);
650     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
651         external
652         payable
653         returns (uint[] memory amounts);
654 
655     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
656     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
657     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
658     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
659     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
660 }
661 
662 
663 interface IUniswapV2Router02 is IUniswapV2Router01 {
664     function removeLiquidityETHSupportingFeeOnTransferTokens(
665         address token,
666         uint liquidity,
667         uint amountTokenMin,
668         uint amountETHMin,
669         address to,
670         uint deadline
671     ) external returns (uint amountETH);
672     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
673         address token,
674         uint liquidity,
675         uint amountTokenMin,
676         uint amountETHMin,
677         address to,
678         uint deadline,
679         bool approveMax, uint8 v, bytes32 r, bytes32 s
680     ) external returns (uint amountETH);
681 
682     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
683         uint amountIn,
684         uint amountOutMin,
685         address[] calldata path,
686         address to,
687         uint deadline
688     ) external;
689     function swapExactETHForTokensSupportingFeeOnTransferTokens(
690         uint amountOutMin,
691         address[] calldata path,
692         address to,
693         uint deadline
694     ) external payable;
695     function swapExactTokensForETHSupportingFeeOnTransferTokens(
696         uint amountIn,
697         uint amountOutMin,
698         address[] calldata path,
699         address to,
700         uint deadline
701     ) external;
702 }
703 
704 contract FIB is ERC20, Ownable {
705     bool public lpAdded = false;
706     uint256 lpBlock = 0;
707     uint24[] taxBrackets = [
708         8000,
709         2250,
710         2000,
711         1750,
712         1500,
713         1450,
714         1400,
715         1350,
716         1300,
717         1250,
718         1200,
719         1150,
720         1100,
721         1050,
722         1000,
723         950,
724         900,
725         850,
726         800,
727         750,
728         700,
729         650,
730         600,
731         550,
732         500
733     ];
734 
735     address router = address(0);
736     mapping(address => bool) public lpPairs;
737 
738     bool public isSwap = false;
739 
740     modifier swapping() {
741         require(isSwap == false, "re");
742         isSwap = true;
743         _;
744         isSwap = false;
745     }
746 
747     constructor(address multisig, address _lpRouter) ERC20("$FIB", "$FIB") {
748         _mint(multisig, 618 * 10 ** decimals());
749         transferOwnership(multisig);
750 
751         router = _lpRouter;
752 
753         _approve(address(this), router, type(uint256).max);
754     }
755 
756     /* Tax */
757     function _liquidateToken() internal swapping {
758         address[] memory path = new address[](2);
759         path[0] = address(this);
760         path[1] = IUniswapV2Router02(router).WETH();
761 
762         IUniswapV2Router02(router)
763             .swapExactTokensForTokensSupportingFeeOnTransferTokens(
764                 balanceOf(address(this)),
765                 0,
766                 path,
767                 owner(),
768                 block.timestamp
769             );
770     }
771 
772     function calcTax() public view returns (uint256) {
773         uint256 bd = block.number - lpBlock;
774         return
775             (bd > taxBrackets.length - 1)
776                 ? taxBrackets[taxBrackets.length - 1]
777                 : taxBrackets[bd];
778     }
779 
780     function takeTax(
781         address from,
782         address to,
783         uint256 amount
784     ) internal returns (uint256 afterTax) {
785         require(
786             lpAdded || (from == owner() || to == owner()),
787             "trading not started"
788         );
789         afterTax = amount;
790         if (lpAdded == true) {
791             if ((lpPairs[from] == true) || (lpPairs[to] == true)) {
792                 require(amount >= 10000, "min transfer 10000");
793                 uint256 tax = (amount * calcTax()) / 10000;
794 
795                 afterTax = (amount - tax);
796                 _transfer(from, address(this), tax);
797 
798                 if ((lpPairs[from] == true)) {
799                     if (
800                         ((block.number - lpBlock) < 24) &&
801                         (amount > ((totalSupply() * 50) / 10000))
802                     ) revert("Max Buy exceeded"); //0.5% max buy
803                 }
804             }
805             if (
806                 !lpPairs[msg.sender] &&
807                 !isSwap &&
808                 (balanceOf(address(this)) > 1 * 10 ** decimals())
809             ) {
810                 _liquidateToken();
811             }
812         }
813     }
814 
815     /* Transfer */
816     function __transfer(address from, address to, uint256 amount) internal {
817         if (isSwap) {
818             _transfer(from, to, amount);
819         } else {
820             _transfer(from, to, takeTax(from, to, amount));
821         }
822     }
823 
824     function transfer(
825         address recipient,
826         uint256 amount
827     ) public virtual override returns (bool) {
828         __transfer(_msgSender(), recipient, amount);
829         return true;
830     }
831 
832     function transferFrom(
833         address from,
834         address to,
835         uint256 amount
836     ) public virtual override returns (bool) {
837         _spendAllowance(from, _msgSender(), amount);
838         __transfer(from, to, amount);
839         return true;
840     }
841 
842     /* Admin */
843     function setLPPair(
844         address[] calldata pairs,
845         bool[] calldata toggles
846     ) public onlyOwner {
847         require(pairs.length == toggles.length, "array unfit");
848         for (uint i = 0; i < pairs.length; i++) {
849             lpPairs[pairs[i]] = toggles[i];
850         }
851     }
852 
853     function enableTrading() public onlyOwner {
854         require(lpAdded == false, "already enabled");
855         lpAdded = true;
856         lpBlock = block.number;
857     }
858 
859     function rescueETH() external onlyOwner {
860         uint256 balance = address(this).balance;
861         (bool success, ) = payable(msg.sender).call{value: balance}("");
862         require(success, "!rescueETH");
863     }
864 
865     function rescueToken(address token) external onlyOwner {
866         IERC20(token).transfer(
867             msg.sender,
868             IERC20(token).balanceOf(address(this))
869         );
870     }
871 
872     receive() external payable {}
873 
874     fallback() external payable {}
875 }