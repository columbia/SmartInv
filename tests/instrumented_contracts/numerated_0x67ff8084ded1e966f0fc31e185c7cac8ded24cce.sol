1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.20;
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 /**
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
22         return msg.data;
23     }
24 }
25 
26 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
105 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
106 
107 /**
108  * @dev Interface of the ERC20 standard as defined in the EIP.
109  */
110 interface IERC20 {
111     /**
112      * @dev Emitted when `value` tokens are moved from one account (`from`) to
113      * another (`to`).
114      *
115      * Note that `value` may be zero.
116      */
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     /**
120      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
121      * a call to {approve}. `value` is the new allowance.
122      */
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 
125     /**
126      * @dev Returns the amount of tokens in existence.
127      */
128     function totalSupply() external view returns (uint256);
129 
130     /**
131      * @dev Returns the amount of tokens owned by `account`.
132      */
133     function balanceOf(address account) external view returns (uint256);
134 
135     /**
136      * @dev Moves `amount` tokens from the caller's account to `to`.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transfer(address to, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Returns the remaining number of tokens that `spender` will be
146      * allowed to spend on behalf of `owner` through {transferFrom}. This is
147      * zero by default.
148      *
149      * This value changes when {approve} or {transferFrom} are called.
150      */
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     /**
154      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * IMPORTANT: Beware that changing an allowance with this method brings the risk
159      * that someone may use both the old and the new allowance by unfortunate
160      * transaction ordering. One possible solution to mitigate this race
161      * condition is to first reduce the spender's allowance to 0 and set the
162      * desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      *
165      * Emits an {Approval} event.
166      */
167     function approve(address spender, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Moves `amount` tokens from `from` to `to` using the
171      * allowance mechanism. `amount` is then deducted from the caller's
172      * allowance.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transferFrom(address from, address to, uint256 amount) external returns (bool);
179 }
180 
181 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
182 
183 /**
184  * @dev Interface for the optional metadata functions from the ERC20 standard.
185  *
186  * _Available since v4.1._
187  */
188 interface IERC20Metadata is IERC20 {
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the symbol of the token.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the decimals places of the token.
201      */
202     function decimals() external view returns (uint8);
203 }
204 
205 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
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
564 interface IUniswapV2Router02 {
565     function factory() external pure returns (address);
566 
567     function WETH() external pure returns (address);
568 
569     function addLiquidityETH(
570         address token,
571         uint256 amountTokenDesired,
572         uint256 amountTokenMin,
573         uint256 amountETHMin,
574         address to,
575         uint256 deadline
576     )
577         external
578         payable
579         returns (
580             uint256 amountToken,
581             uint256 amountETH,
582             uint256 liquidity
583         );
584 
585     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
586         uint256 amountIn,
587         uint256 amountOutMin,
588         address[] calldata path,
589         address to,
590         uint256 deadline
591     ) external;
592 
593     function swapExactTokensForETHSupportingFeeOnTransferTokens(
594         uint256 amountIn,
595         uint256 amountOutMin,
596         address[] calldata path,
597         address to,
598         uint256 deadline
599     ) external;
600 }
601 
602 interface IUniswapV2Factory {
603     function createPair(address tokenA, address tokenB)
604         external
605         returns (address pair);
606 }
607 
608 contract Dogepows is ERC20, Ownable {
609     address public doge;
610     ///////////////////////////////////////////////////////////////////////////
611     bool private inSwapAndLiquify;
612     uint16 public sellLiquidityFee;
613     uint16 public buyLiquidityFee;
614 
615     uint16 public sellMarketingFee;
616     uint16 public buyMarketingFee;
617 
618     uint16 public sellBurnFee;
619     uint16 public buyBurnFee;
620 
621     uint16 public sellBurnDogeFee;
622     uint16 public buyBurnDogeFee;
623 
624     address public marketingWallet;
625 
626     uint256 public minAmountToTakeFee;
627     uint256 public maxWallet;
628     uint256 public maxTransactionAmount;
629 
630     IUniswapV2Router02 public mainRouter;
631     address public mainPair;
632 
633     mapping(address => bool) public isExcludedFromMaxTransactionAmount;
634     mapping(address => bool) public isExcludedFromFee;
635     mapping(address => bool) public automatedMarketMakerPairs;
636 
637     uint256 private _liquidityFeeTokens;
638     uint256 private _marketingFeeTokens;
639     uint256 private _burnFeeTokens;
640     uint256 private _burnDogeFeeTokens;
641     event UpdateLiquidityFee(
642         uint16 newSellLiquidityFee,
643         uint16 newBuyLiquidityFee,
644         uint16 oldSellLiquidityFee,
645         uint16 oldBuyLiquidityFee
646     );
647     event UpdateMarketingFee(
648         uint16 newSellMarketingFee,
649         uint16 newBuyMarketingFee,
650         uint16 oldSellMarketingFee,
651         uint16 oldBuyMarketingFee
652     );
653     event UpdateBurnFee(
654         uint16 newSellBurnFee,
655         uint16 newBuyBurnFee,
656         uint16 oldSellBurnFee,
657         uint16 oldBuyBurnFee
658     );
659     event UpdateBurnDogeFee(
660         uint16 newSellBurnDogeFee,
661         uint16 newBuyBurnDogeFee,
662         uint16 oldSellBurnDogeFee,
663         uint16 oldBuyBurnDogeFee
664     );
665     event UpdateMarketingWallet(
666         address indexed newMarketingWallet,
667         address indexed oldMarketingWallet
668     );
669     event ExcludedFromMaxTransactionAmount(
670         address indexed account,
671         bool isExcluded
672     );
673     event UpdateMinAmountToTakeFee(
674         uint256 newMinAmountToTakeFee,
675         uint256 oldMinAmountToTakeFee
676     );
677     event SetAutomatedMarketMakerPair(address indexed pair, bool value);
678     event ExcludedFromFee(address indexed account, bool isEx);
679     event SwapAndLiquify(uint256 tokensForLiquidity, uint256 ETHForLiquidity);
680     event MarketingFeeTaken(uint256 marketingFeeTokens);
681     event DogeBurnt(uint256 amount);
682     event DogepowsBurnt(uint256 amount);
683     event UpdateUniswapV2Router(
684         address indexed newAddress,
685         address indexed oldRouter
686     );
687     event UpdateMaxWallet(uint256 newMaxWallet, uint256 oldMaxWallet);
688     event UpdateMaxTransactionAmount(
689         uint256 newMaxTransactionAmount,
690         uint256 oldMaxTransactionAmount
691     );
692 
693     ///////////////////////////////////////////////////////////////////////////////
694 
695     constructor() ERC20("Dogepows", "POW") {
696         uint256 _totalSupply = 1_000_000_000 ether;
697         maxWallet = (_totalSupply * 1) / 100; // 1%
698         
699         maxTransactionAmount = (_totalSupply * 1) / 100; // 1%
700         
701         doge = 0x35a532d376FFd9a705d0Bb319532837337A398E7;
702         marketingWallet = 0xAEfed5611dc6b1ad2b9969D2BecF50358092fF08;
703         
704         mainRouter = IUniswapV2Router02(
705             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
706         );
707         
708         mainPair = IUniswapV2Factory(mainRouter.factory()).createPair(
709             address(this),
710             mainRouter.WETH()
711         );
712 
713         sellLiquidityFee = 1;
714         buyLiquidityFee = 1;
715         
716         sellMarketingFee = 7;
717         buyMarketingFee = 3;
718         
719         sellBurnFee = 1;
720         buyBurnFee = 1;
721         
722         sellBurnDogeFee = 1;
723         buyBurnDogeFee = 1;
724         
725         minAmountToTakeFee = _totalSupply / 10000;
726         
727         isExcludedFromFee[address(this)] = true;
728         isExcludedFromFee[marketingWallet] = true;
729         isExcludedFromFee[_msgSender()] = true;
730         isExcludedFromFee[address(0xdead)] = true;
731         isExcludedFromFee[0x460736a29b08A6E8113B30c35d621cb6042765EA] = true;
732         isExcludedFromMaxTransactionAmount[0x460736a29b08A6E8113B30c35d621cb6042765EA] = true;
733         isExcludedFromMaxTransactionAmount[address(0xdead)] = true;
734         isExcludedFromMaxTransactionAmount[address(this)] = true;
735         isExcludedFromMaxTransactionAmount[marketingWallet] = true;
736         isExcludedFromMaxTransactionAmount[_msgSender()] = true;
737         _setAutomatedMarketMakerPair(mainPair, true);
738 
739         _mint(msg.sender, _totalSupply);
740     }
741 
742     function updateUniswapV2Router(address newAddress) public onlyOwner {
743         require(
744             newAddress != address(mainRouter),
745             "The router already has that address"
746         );
747         emit UpdateUniswapV2Router(newAddress, address(mainRouter));
748         mainRouter = IUniswapV2Router02(newAddress);
749         address _mainPair = IUniswapV2Factory(mainRouter.factory()).createPair(
750             address(this),
751             mainRouter.WETH()
752         );
753         mainPair = _mainPair;
754         _setAutomatedMarketMakerPair(mainPair, true);
755     }
756 
757     /////////////////////////////////////////////////////////////////////////////////
758     modifier lockTheSwap() {
759         inSwapAndLiquify = true;
760         _;
761         inSwapAndLiquify = false;
762     }
763 
764     function updateLiquidityFee(
765         uint16 _sellLiquidityFee,
766         uint16 _buyLiquidityFee
767     ) external onlyOwner {
768         require(
769             _sellLiquidityFee +
770                 sellMarketingFee +
771                 sellBurnFee +
772                 sellBurnDogeFee <=
773                 200,
774             "sell fee <= 20%"
775         );
776         require(
777             _buyLiquidityFee + buyMarketingFee + buyBurnFee + buyBurnDogeFee <=
778                 200,
779             "buy fee <= 20%"
780         );
781         emit UpdateLiquidityFee(
782             _sellLiquidityFee,
783             _buyLiquidityFee,
784             sellLiquidityFee,
785             buyLiquidityFee
786         );
787         sellLiquidityFee = _sellLiquidityFee;
788         buyLiquidityFee = _buyLiquidityFee;
789     }
790 
791     function updateMaxWallet(uint256 _maxWallet) external onlyOwner {
792         require(_maxWallet > 0, "maxWallet > 0");
793         emit UpdateMaxWallet(_maxWallet, maxWallet);
794         maxWallet = _maxWallet;
795     }
796 
797     function updateMaxTransactionAmount(uint256 _maxTransactionAmount)
798         external
799         onlyOwner
800     {
801         require(_maxTransactionAmount > 0, "maxTransactionAmount > 0");
802         emit UpdateMaxTransactionAmount(
803             _maxTransactionAmount,
804             maxTransactionAmount
805         );
806         maxTransactionAmount = _maxTransactionAmount;
807     }
808 
809     function updateMarketingFee(
810         uint16 _sellMarketingFee,
811         uint16 _buyMarketingFee
812     ) external onlyOwner {
813         require(
814             _sellMarketingFee +
815                 sellLiquidityFee +
816                 sellBurnFee +
817                 sellBurnDogeFee <=
818                 200,
819             "sell fee <= 20%"
820         );
821         require(
822             _buyMarketingFee + buyLiquidityFee + buyBurnFee + buyBurnDogeFee <=
823                 200,
824             "buy fee <= 20%"
825         );
826         emit UpdateMarketingFee(
827             _sellMarketingFee,
828             _buyMarketingFee,
829             sellMarketingFee,
830             buyMarketingFee
831         );
832         sellMarketingFee = _sellMarketingFee;
833         buyMarketingFee = _buyMarketingFee;
834     }
835 
836     function updateMarketingWallet(address _marketingWallet)
837         external
838         onlyOwner
839     {
840         require(_marketingWallet != address(0), "marketing wallet can't be 0");
841         emit UpdateMarketingWallet(_marketingWallet, marketingWallet);
842         marketingWallet = _marketingWallet;
843         isExcludedFromFee[_marketingWallet] = true;
844         isExcludedFromMaxTransactionAmount[_marketingWallet] = true;
845     }
846 
847     function updateBurnFee(uint16 _sellBurnFee, uint16 _buyBurnFee)
848         external
849         onlyOwner
850     {
851         require(
852             _sellBurnFee +
853                 sellMarketingFee +
854                 sellLiquidityFee +
855                 sellBurnDogeFee <=
856                 200,
857             "sell fee <= 20%"
858         );
859         require(
860             _buyBurnFee + buyMarketingFee + buyLiquidityFee + buyBurnDogeFee <=
861                 200,
862             "buy fee <= 20%"
863         );
864         emit UpdateBurnFee(_sellBurnFee, _buyBurnFee, sellBurnFee, buyBurnFee);
865         sellBurnFee = _sellBurnFee;
866         buyBurnFee = _buyBurnFee;
867     }
868 
869     function updateBurnDogeFee(uint16 _sellBurnDogeFee, uint16 _buyBurnDogeFee)
870         external
871         onlyOwner
872     {
873         require(
874             _sellBurnDogeFee +
875                 sellMarketingFee +
876                 sellBurnFee +
877                 sellLiquidityFee <=
878                 200,
879             "sell fee <= 20%"
880         );
881         require(
882             _buyBurnDogeFee + buyMarketingFee + buyBurnFee + buyLiquidityFee <=
883                 200,
884             "buy fee <= 20%"
885         );
886         emit UpdateBurnDogeFee(
887             _sellBurnDogeFee,
888             _buyBurnDogeFee,
889             sellBurnDogeFee,
890             buyBurnDogeFee
891         );
892         sellBurnDogeFee = _sellBurnDogeFee;
893         buyBurnDogeFee = _buyBurnDogeFee;
894     }
895 
896     function updateMinAmountToTakeFee(uint256 _minAmountToTakeFee)
897         external
898         onlyOwner
899     {
900         require(_minAmountToTakeFee > 0, "minAmountToTakeFee > 0");
901         emit UpdateMinAmountToTakeFee(_minAmountToTakeFee, minAmountToTakeFee);
902         minAmountToTakeFee = _minAmountToTakeFee;
903     }
904 
905     function setAutomatedMarketMakerPair(address pair, bool value)
906         public
907         onlyOwner
908     {
909         _setAutomatedMarketMakerPair(pair, value);
910     }
911 
912     function _setAutomatedMarketMakerPair(address pair, bool value) private {
913         require(
914             automatedMarketMakerPairs[pair] != value,
915             "Automated market maker pair is already set to that value"
916         );
917         automatedMarketMakerPairs[pair] = value;
918         isExcludedFromMaxTransactionAmount[pair] = value;
919         emit SetAutomatedMarketMakerPair(pair, value);
920     }
921 
922     function excludeFromFee(address account, bool isEx) external onlyOwner {
923         require(isExcludedFromFee[account] != isEx, "already");
924         isExcludedFromFee[account] = isEx;
925         emit ExcludedFromFee(account, isEx);
926     }
927 
928     function excludeFromMaxTransactionAmount(address account, bool isEx)
929         external
930         onlyOwner
931     {
932         require(isExcludedFromMaxTransactionAmount[account] != isEx, "already");
933         isExcludedFromMaxTransactionAmount[account] = isEx;
934         emit ExcludedFromMaxTransactionAmount(account, isEx);
935     }
936 
937     function withdrawStuckTokens(address tkn) external onlyOwner {
938         require(tkn != address(this), "Cannot withdraw own token");
939         bool success;
940         if (tkn == address(0))
941             (success, ) = address(msg.sender).call{
942                 value: address(this).balance
943             }("");
944         else {
945             require(IERC20(tkn).balanceOf(address(this)) > 0);
946             uint256 amount = IERC20(tkn).balanceOf(address(this));
947             IERC20(tkn).transfer(msg.sender, amount);
948         }
949     }
950 
951     function _transfer(
952         address from,
953         address to,
954         uint256 amount
955     ) internal override {
956         require(from != address(0), "ERC20: transfer from the zero address");
957         require(to != address(0), "ERC20: transfer to the zero address");
958         uint256 contractTokenBalance = balanceOf(address(this));
959         bool overMinimumTokenBalance = contractTokenBalance >=
960             minAmountToTakeFee;
961 
962         // Take Fee
963         if (
964             !inSwapAndLiquify &&
965             balanceOf(mainPair) > 0 &&
966             overMinimumTokenBalance &&
967             automatedMarketMakerPairs[to]
968         ) {
969             takeFee();
970         }
971 
972         uint256 _liquidityFee;
973         uint256 _marketingFee;
974         uint256 _burnFee;
975         uint256 _burnDogeFee;
976         // If any account belongs to isExcludedFromFee account then remove the fee
977 
978         if (
979             !inSwapAndLiquify &&
980             !isExcludedFromFee[from] &&
981             !isExcludedFromFee[to]
982         ) {
983             // Buy
984             if (automatedMarketMakerPairs[from]) {
985                 _liquidityFee = (amount * (buyLiquidityFee)) / 1000;
986                 _marketingFee = (amount * (buyMarketingFee)) / 1000;
987                 _burnFee = (amount * (buyBurnFee)) / 1000;
988                 _burnDogeFee = (amount * (buyBurnDogeFee)) / 1000;
989             }
990             // Sell
991             else if (automatedMarketMakerPairs[to]) {
992                 _liquidityFee = (amount * (sellLiquidityFee)) / 1000;
993                 _marketingFee = (amount * (sellMarketingFee)) / 1000;
994                 _burnFee = (amount * (sellBurnFee)) / 1000;
995                 _burnDogeFee = (amount * (sellBurnDogeFee)) / 1000;
996             }
997             uint256 _feeTotal = _liquidityFee +
998                 _marketingFee +
999                 _burnFee +
1000                 _burnDogeFee;
1001             if (_feeTotal > 0) super._transfer(from, address(this), _feeTotal);
1002             amount = amount - _feeTotal;
1003             _liquidityFeeTokens = _liquidityFeeTokens + _liquidityFee;
1004             _marketingFeeTokens = _marketingFeeTokens + _marketingFee;
1005             _burnFeeTokens = _burnFeeTokens + _burnFee;
1006             _burnDogeFeeTokens = _burnDogeFeeTokens + _burnDogeFee;
1007         }
1008         super._transfer(from, to, amount);
1009         if (!inSwapAndLiquify) {
1010             if (!isExcludedFromMaxTransactionAmount[from]) {
1011                 require(
1012                     amount < maxTransactionAmount,
1013                     "ERC20: exceeds transfer limit"
1014                 );
1015             }
1016             if (!isExcludedFromMaxTransactionAmount[to]) {
1017                 require(
1018                     balanceOf(to) < maxWallet,
1019                     "ERC20: exceeds max wallet limit"
1020                 );
1021             }
1022         }
1023     }
1024 
1025     function takeFee() private lockTheSwap {
1026         uint256 contractBalance = balanceOf(address(this));
1027         uint256 totalTokensTaken = _liquidityFeeTokens +
1028             _marketingFeeTokens +
1029             _burnFeeTokens +
1030             _burnDogeFeeTokens;
1031         if (totalTokensTaken == 0 || contractBalance < totalTokensTaken) {
1032             return;
1033         }
1034         if (_burnFeeTokens > 0) {
1035             super._transfer(address(this), address(0xdead), _burnFeeTokens);
1036             emit DogepowsBurnt(_burnFeeTokens);
1037             _burnFeeTokens = 0;
1038         }
1039         // Halve the amount of liquidity tokens
1040         uint256 tokensForLiquidity = _liquidityFeeTokens / 2;
1041         uint256 initialETHBalance = address(this).balance;
1042         uint256 ETHForLiquidity;
1043         uint256 tokensForSwap = tokensForLiquidity + _marketingFeeTokens;
1044         if (tokensForSwap > 0) swapTokensForETH(tokensForSwap);
1045         uint256 ETHBalance = address(this).balance - initialETHBalance;
1046         uint256 ETHForMarketing = (ETHBalance * _marketingFeeTokens) /
1047             tokensForSwap;
1048         ETHForLiquidity = ETHBalance - ETHForMarketing;
1049         if (ETHForMarketing > 0) {
1050             (bool success, ) = address(marketingWallet).call{
1051                 value: ETHForMarketing
1052             }("");
1053             if (success) {
1054                 emit MarketingFeeTaken(ETHForMarketing);
1055             }
1056         }
1057         if (_burnDogeFeeTokens > 0) {
1058             buyBackAndBurnDoge(_burnDogeFeeTokens);
1059             emit DogeBurnt(_burnDogeFeeTokens);
1060             _burnDogeFeeTokens = 0;
1061         }
1062 
1063         if (tokensForLiquidity > 0 && ETHForLiquidity > 0) {
1064             addLiquidity(tokensForLiquidity, ETHForLiquidity);
1065             emit SwapAndLiquify(tokensForLiquidity, ETHForLiquidity);
1066         }
1067         _marketingFeeTokens = 0;
1068         _liquidityFeeTokens = 0;
1069     }
1070 
1071     function swapTokensForETH(uint256 tokenAmount) private {
1072         address[] memory path = new address[](2);
1073         path[0] = address(this);
1074         path[1] = mainRouter.WETH();
1075         _approve(address(this), address(mainRouter), tokenAmount);
1076         mainRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1077             tokenAmount,
1078             0, // accept any amount of ETH
1079             path,
1080             address(this),
1081             block.timestamp
1082         );
1083     }
1084 
1085     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
1086         _approve(address(this), address(mainRouter), tokenAmount);
1087         mainRouter.addLiquidityETH{value: ETHAmount}(
1088             address(this),
1089             tokenAmount,
1090             0, // slippage is unavoidable
1091             0, // slippage is unavoidable
1092             address(0xdead),
1093             block.timestamp
1094         );
1095     }
1096 
1097     function buyBackAndBurnDoge(uint256 amount) private {
1098         address[] memory path = new address[](3);
1099         path[0] = address(this);
1100         path[1] = mainRouter.WETH();
1101         path[2] = doge;
1102         _approve(address(this), address(mainRouter), amount);
1103         mainRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1104             amount,
1105             0, // accept any amount of ETH
1106             path,
1107             address(0xdead),
1108             block.timestamp
1109         );
1110     }
1111 
1112     receive() external payable {}
1113 }