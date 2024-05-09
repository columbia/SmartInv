1 // File @openzeppelin/contracts/utils/Context.sol@v4.9.2
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
4 
5 /**
6 Website: https://lizatoken.com
7 Twitter: https://twitter.com/Lizatoken
8 Telegram: https://t.me/Liza_Token
9 Medium: https://medium.com/@Liza_Token
10 */
11 
12 // SPDX-License-Identifier: UNLICENSED
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 
37 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.2
38 
39 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Contract module which provides a basic access control mechanism, where
45  * there is an account (an owner) that can be granted exclusive access to
46  * specific functions.
47  *
48  * By default, the owner account will be the one that deploys the contract. This
49  * can later be changed with {transferOwnership}.
50  *
51  * This module is used through inheritance. It will make available the modifier
52  * `onlyOwner`, which can be applied to your functions to restrict their use to
53  * the owner.
54  */
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         _checkOwner();
72         _;
73     }
74 
75     /**
76      * @dev Returns the address of the current owner.
77      */
78     function owner() public view virtual returns (address) {
79         return _owner;
80     }
81 
82     /**
83      * @dev Throws if the sender is not the owner.
84      */
85     function _checkOwner() internal view virtual {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87     }
88 
89     /**
90      * @dev Leaves the contract without owner. It will not be possible to call
91      * `onlyOwner` functions. Can only be called by the current owner.
92      *
93      * NOTE: Renouncing ownership will leave the contract without an owner,
94      * thereby disabling any functionality that is only available to the owner.
95      */
96     function renounceOwnership() public virtual onlyOwner {
97         _transferOwnership(address(0));
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Internal function without access restriction.
112      */
113     function _transferOwnership(address newOwner) internal virtual {
114         address oldOwner = _owner;
115         _owner = newOwner;
116         emit OwnershipTransferred(oldOwner, newOwner);
117     }
118 }
119 
120 
121 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.2
122 
123 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 /**
128  * @dev Interface of the ERC20 standard as defined in the EIP.
129  */
130 interface IERC20 {
131     /**
132      * @dev Emitted when `value` tokens are moved from one account (`from`) to
133      * another (`to`).
134      *
135      * Note that `value` may be zero.
136      */
137     event Transfer(address indexed from, address indexed to, uint256 value);
138 
139     /**
140      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
141      * a call to {approve}. `value` is the new allowance.
142      */
143     event Approval(address indexed owner, address indexed spender, uint256 value);
144 
145     /**
146      * @dev Returns the amount of tokens in existence.
147      */
148     function totalSupply() external view returns (uint256);
149 
150     /**
151      * @dev Returns the amount of tokens owned by `account`.
152      */
153     function balanceOf(address account) external view returns (uint256);
154 
155     /**
156      * @dev Moves `amount` tokens from the caller's account to `to`.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transfer(address to, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Returns the remaining number of tokens that `spender` will be
166      * allowed to spend on behalf of `owner` through {transferFrom}. This is
167      * zero by default.
168      *
169      * This value changes when {approve} or {transferFrom} are called.
170      */
171     function allowance(address owner, address spender) external view returns (uint256);
172 
173     /**
174      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * IMPORTANT: Beware that changing an allowance with this method brings the risk
179      * that someone may use both the old and the new allowance by unfortunate
180      * transaction ordering. One possible solution to mitigate this race
181      * condition is to first reduce the spender's allowance to 0 and set the
182      * desired value afterwards:
183      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184      *
185      * Emits an {Approval} event.
186      */
187     function approve(address spender, uint256 amount) external returns (bool);
188 
189     /**
190      * @dev Moves `amount` tokens from `from` to `to` using the
191      * allowance mechanism. `amount` is then deducted from the caller's
192      * allowance.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * Emits a {Transfer} event.
197      */
198     function transferFrom(address from, address to, uint256 amount) external returns (bool);
199 }
200 
201 
202 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.2
203 
204 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Interface for the optional metadata functions from the ERC20 standard.
210  *
211  * _Available since v4.1._
212  */
213 interface IERC20Metadata is IERC20 {
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the symbol of the token.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the decimals places of the token.
226      */
227     function decimals() external view returns (uint8);
228 }
229 
230 
231 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.2
232 
233 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 
238 
239 /**
240  * @dev Implementation of the {IERC20} interface.
241  *
242  * This implementation is agnostic to the way tokens are created. This means
243  * that a supply mechanism has to be added in a derived contract using {_mint}.
244  * For a generic mechanism see {ERC20PresetMinterPauser}.
245  *
246  * TIP: For a detailed writeup see our guide
247  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
248  * to implement supply mechanisms].
249  *
250  * The default value of {decimals} is 18. To change this, you should override
251  * this function so it returns a different value.
252  *
253  * We have followed general OpenZeppelin Contracts guidelines: functions revert
254  * instead returning `false` on failure. This behavior is nonetheless
255  * conventional and does not conflict with the expectations of ERC20
256  * applications.
257  *
258  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
259  * This allows applications to reconstruct the allowance for all accounts just
260  * by listening to said events. Other implementations of the EIP may not emit
261  * these events, as it isn't required by the specification.
262  *
263  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
264  * functions have been added to mitigate the well-known issues around setting
265  * allowances. See {IERC20-approve}.
266  */
267 contract ERC20 is Context, IERC20, IERC20Metadata {
268     mapping(address => uint256) private _balances;
269 
270     mapping(address => mapping(address => uint256)) private _allowances;
271 
272     uint256 private _totalSupply;
273 
274     string private _name;
275     string private _symbol;
276 
277     /**
278      * @dev Sets the values for {name} and {symbol}.
279      *
280      * All two of these values are immutable: they can only be set once during
281      * construction.
282      */
283     constructor(string memory name_, string memory symbol_) {
284         _name = name_;
285         _symbol = symbol_;
286     }
287 
288     /**
289      * @dev Returns the name of the token.
290      */
291     function name() public view virtual override returns (string memory) {
292         return _name;
293     }
294 
295     /**
296      * @dev Returns the symbol of the token, usually a shorter version of the
297      * name.
298      */
299     function symbol() public view virtual override returns (string memory) {
300         return _symbol;
301     }
302 
303     /**
304      * @dev Returns the number of decimals used to get its user representation.
305      * For example, if `decimals` equals `2`, a balance of `505` tokens should
306      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
307      *
308      * Tokens usually opt for a value of 18, imitating the relationship between
309      * Ether and Wei. This is the default value returned by this function, unless
310      * it's overridden.
311      *
312      * NOTE: This information is only used for _display_ purposes: it in
313      * no way affects any of the arithmetic of the contract, including
314      * {IERC20-balanceOf} and {IERC20-transfer}.
315      */
316     function decimals() public view virtual override returns (uint8) {
317         return 18;
318     }
319 
320     /**
321      * @dev See {IERC20-totalSupply}.
322      */
323     function totalSupply() public view virtual override returns (uint256) {
324         return _totalSupply;
325     }
326 
327     /**
328      * @dev See {IERC20-balanceOf}.
329      */
330     function balanceOf(address account) public view virtual override returns (uint256) {
331         return _balances[account];
332     }
333 
334     /**
335      * @dev See {IERC20-transfer}.
336      *
337      * Requirements:
338      *
339      * - `to` cannot be the zero address.
340      * - the caller must have a balance of at least `amount`.
341      */
342     function transfer(address to, uint256 amount) public virtual override returns (bool) {
343         address owner = _msgSender();
344         _transfer(owner, to, amount);
345         return true;
346     }
347 
348     /**
349      * @dev See {IERC20-allowance}.
350      */
351     function allowance(address owner, address spender) public view virtual override returns (uint256) {
352         return _allowances[owner][spender];
353     }
354 
355     /**
356      * @dev See {IERC20-approve}.
357      *
358      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
359      * `transferFrom`. This is semantically equivalent to an infinite approval.
360      *
361      * Requirements:
362      *
363      * - `spender` cannot be the zero address.
364      */
365     function approve(address spender, uint256 amount) public virtual override returns (bool) {
366         address owner = _msgSender();
367         _approve(owner, spender, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-transferFrom}.
373      *
374      * Emits an {Approval} event indicating the updated allowance. This is not
375      * required by the EIP. See the note at the beginning of {ERC20}.
376      *
377      * NOTE: Does not update the allowance if the current allowance
378      * is the maximum `uint256`.
379      *
380      * Requirements:
381      *
382      * - `from` and `to` cannot be the zero address.
383      * - `from` must have a balance of at least `amount`.
384      * - the caller must have allowance for ``from``'s tokens of at least
385      * `amount`.
386      */
387     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
388         address spender = _msgSender();
389         _spendAllowance(from, spender, amount);
390         _transfer(from, to, amount);
391         return true;
392     }
393 
394     /**
395      * @dev Atomically increases the allowance granted to `spender` by the caller.
396      *
397      * This is an alternative to {approve} that can be used as a mitigation for
398      * problems described in {IERC20-approve}.
399      *
400      * Emits an {Approval} event indicating the updated allowance.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      */
406     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
407         address owner = _msgSender();
408         _approve(owner, spender, allowance(owner, spender) + addedValue);
409         return true;
410     }
411 
412     /**
413      * @dev Atomically decreases the allowance granted to `spender` by the caller.
414      *
415      * This is an alternative to {approve} that can be used as a mitigation for
416      * problems described in {IERC20-approve}.
417      *
418      * Emits an {Approval} event indicating the updated allowance.
419      *
420      * Requirements:
421      *
422      * - `spender` cannot be the zero address.
423      * - `spender` must have allowance for the caller of at least
424      * `subtractedValue`.
425      */
426     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
427         address owner = _msgSender();
428         uint256 currentAllowance = allowance(owner, spender);
429         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
430         unchecked {
431             _approve(owner, spender, currentAllowance - subtractedValue);
432         }
433 
434         return true;
435     }
436 
437     /**
438      * @dev Moves `amount` of tokens from `from` to `to`.
439      *
440      * This internal function is equivalent to {transfer}, and can be used to
441      * e.g. implement automatic token fees, slashing mechanisms, etc.
442      *
443      * Emits a {Transfer} event.
444      *
445      * Requirements:
446      *
447      * - `from` cannot be the zero address.
448      * - `to` cannot be the zero address.
449      * - `from` must have a balance of at least `amount`.
450      */
451     function _transfer(address from, address to, uint256 amount) internal virtual {
452         require(from != address(0), "ERC20: transfer from the zero address");
453         require(to != address(0), "ERC20: transfer to the zero address");
454 
455         _beforeTokenTransfer(from, to, amount);
456 
457         uint256 fromBalance = _balances[from];
458         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
459         unchecked {
460             _balances[from] = fromBalance - amount;
461             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
462             // decrementing then incrementing.
463             _balances[to] += amount;
464         }
465 
466         emit Transfer(from, to, amount);
467 
468         _afterTokenTransfer(from, to, amount);
469     }
470 
471     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
472      * the total supply.
473      *
474      * Emits a {Transfer} event with `from` set to the zero address.
475      *
476      * Requirements:
477      *
478      * - `account` cannot be the zero address.
479      */
480     function _mint(address account, uint256 amount) internal virtual {
481         require(account != address(0), "ERC20: mint to the zero address");
482 
483         _beforeTokenTransfer(address(0), account, amount);
484 
485         _totalSupply += amount;
486         unchecked {
487             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
488             _balances[account] += amount;
489         }
490         emit Transfer(address(0), account, amount);
491 
492         _afterTokenTransfer(address(0), account, amount);
493     }
494 
495     /**
496      * @dev Destroys `amount` tokens from `account`, reducing the
497      * total supply.
498      *
499      * Emits a {Transfer} event with `to` set to the zero address.
500      *
501      * Requirements:
502      *
503      * - `account` cannot be the zero address.
504      * - `account` must have at least `amount` tokens.
505      */
506     function _burn(address account, uint256 amount) internal virtual {
507         require(account != address(0), "ERC20: burn from the zero address");
508 
509         _beforeTokenTransfer(account, address(0), amount);
510 
511         uint256 accountBalance = _balances[account];
512         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
513         unchecked {
514             _balances[account] = accountBalance - amount;
515             // Overflow not possible: amount <= accountBalance <= totalSupply.
516             _totalSupply -= amount;
517         }
518 
519         emit Transfer(account, address(0), amount);
520 
521         _afterTokenTransfer(account, address(0), amount);
522     }
523 
524     /**
525      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
526      *
527      * This internal function is equivalent to `approve`, and can be used to
528      * e.g. set automatic allowances for certain subsystems, etc.
529      *
530      * Emits an {Approval} event.
531      *
532      * Requirements:
533      *
534      * - `owner` cannot be the zero address.
535      * - `spender` cannot be the zero address.
536      */
537     function _approve(address owner, address spender, uint256 amount) internal virtual {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = amount;
542         emit Approval(owner, spender, amount);
543     }
544 
545     /**
546      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
547      *
548      * Does not update the allowance amount in case of infinite allowance.
549      * Revert if not enough allowance is available.
550      *
551      * Might emit an {Approval} event.
552      */
553     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
554         uint256 currentAllowance = allowance(owner, spender);
555         if (currentAllowance != type(uint256).max) {
556             require(currentAllowance >= amount, "ERC20: insufficient allowance");
557             unchecked {
558                 _approve(owner, spender, currentAllowance - amount);
559             }
560         }
561     }
562 
563     /**
564      * @dev Hook that is called before any transfer of tokens. This includes
565      * minting and burning.
566      *
567      * Calling conditions:
568      *
569      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
570      * will be transferred to `to`.
571      * - when `from` is zero, `amount` tokens will be minted for `to`.
572      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
573      * - `from` and `to` are never both zero.
574      *
575      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
576      */
577     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
578 
579     /**
580      * @dev Hook that is called after any transfer of tokens. This includes
581      * minting and burning.
582      *
583      * Calling conditions:
584      *
585      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
586      * has been transferred to `to`.
587      * - when `from` is zero, `amount` tokens have been minted for `to`.
588      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
589      * - `from` and `to` are never both zero.
590      *
591      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
592      */
593     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
594 }
595 
596 
597 // File contracts/LizaToken.sol
598 
599 pragma solidity 0.8.15;
600 
601 
602 interface IUniswapV2Factory {
603     function createPair(address tokenA, address tokenB)
604     external
605     returns (address pair);
606 }
607 
608 interface IUniswapV2Router {
609     function factory() external pure returns (address);
610     function WETH() external pure returns (address);
611 
612     function swapExactTokensForETHSupportingFeeOnTransferTokens(
613         uint amountIn,
614         uint amountOutMin,
615         address[] calldata path,
616         address to,
617         uint deadline
618     ) external;
619 
620     function swapExactETHForTokensSupportingFeeOnTransferTokens(
621         uint amountOutMin,
622         address[] calldata path,
623         address to,
624         uint deadline
625     ) external payable;
626 
627     function addLiquidityETH(
628         address token,
629         uint256 amountTokenDesired,
630         uint256 amountTokenMin,
631         uint256 amountETHMin,
632         address to,
633         uint256 deadline
634     )
635     external
636     payable
637     returns (
638         uint256 amountToken,
639         uint256 amountETH,
640         uint256 liquidity
641     );
642 }
643 
644 contract LizaToken is ERC20, Ownable {
645     address public devTaxWallet;
646     address public marketingTaxWallet;
647     address public rewardsTaxWallet;
648     address public cexWallet;
649     address public rewardsWallet;
650 
651 
652     uint256 public maxBuyAmount;
653     uint256 public maxSellAmount;
654     uint256 public maxWalletAmount;
655     IUniswapV2Router public uniswapV2Router;
656 
657     address public lpPair;
658 
659     bool public hasLimits = true;
660     bool private swapping;
661     uint256 public swapTokensAtAmount;
662 
663     uint256 public buyTotalFees;
664     uint256 public buyRewardsFee;
665     uint256 public buyMarketingFee;
666     uint256 public buyDevFee;
667     uint256 public buyBurnFee;
668 
669     uint256 public sellTotalFees;
670     uint256 public sellRewardsFee;
671     uint256 public sellMarketingFee;
672     uint256 public sellDevFee;
673     uint256 public sellBurnFee;
674 
675     uint256 public tokensForRewards;
676     uint256 public tokensForMarketing;
677     uint256 public tokensForDev;
678     uint256 public tokensForBurn;
679 
680     mapping (address => bool) private _isExcludedFromFees;
681     mapping (address => bool) public _isExcludedMaxTransactionAmount;
682     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
683     // could be subject to a maximum transfer amount
684     mapping (address => bool) public automatedMarketMakerPairs;
685 
686     //events
687     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
688     event MaxTransactionExclusion(address _address, bool excluded);
689     event ExcludeFromFees(address indexed account, bool isExcluded);
690     event OwnerForcedSwapBack(uint256 timestamp);
691     event UpdatedMaxBuyAmount(uint256 newAmount);
692     event UpdatedMaxSellAmount(uint256 newAmount);
693     event UpdatedMaxWalletAmount(uint256 newAmount);
694     event RemovedLimits();
695     event BuyBackTriggered(uint256 amount);
696 
697     constructor() ERC20("LIZA", "LIZA") {
698 
699         address newOwner = msg.sender; // can leave alone if owner is deployer.
700 
701         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
702         uniswapV2Router = _uniswapV2Router;
703 
704         //create pair
705         lpPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
706         _excludeFromMaxTransaction(address(lpPair), true);
707         _setAutomatedMarketMakerPair(address(lpPair), true);
708 
709         uint256 totalSupply = 777777777 * 1e18;
710 
711         maxBuyAmount = totalSupply * 1 / 100;
712         maxSellAmount = totalSupply * 1 / 100;
713         maxWalletAmount = totalSupply * 1 / 100;
714         swapTokensAtAmount = totalSupply * 1 / 1000;
715 
716         buyDevFee = 3;
717         buyMarketingFee = 1;
718         buyRewardsFee = 1;
719         buyBurnFee = 1;
720         buyTotalFees = buyBurnFee + buyRewardsFee + buyMarketingFee + buyDevFee;
721 
722         sellDevFee = 13;
723         sellMarketingFee = 10;
724         sellRewardsFee = 1;
725         sellBurnFee = 1;
726         sellTotalFees = sellBurnFee + sellRewardsFee + sellMarketingFee + sellDevFee;
727 
728         devTaxWallet = 0xa8bAE2505e986782BCEFD3A20d6DE02AF0f7001c;
729         marketingTaxWallet = 0x9B197F752d3EE4486A078530a0546aCE65fEA41a;
730         rewardsTaxWallet = 0xB31497898903CEF62Ad6CDA5c449B8BDF9C07596;
731         rewardsWallet = 0xfec13df9f85BC3cE66b7113Fe8b8107bf7AeDf3C;
732         cexWallet = 0x454450ee5C7f64632989993820dBA797702B1C0B;
733 
734         _excludeFromMaxTransaction(devTaxWallet, true);
735         _excludeFromMaxTransaction(marketingTaxWallet, true);
736         _excludeFromMaxTransaction(rewardsTaxWallet, true);
737         _excludeFromMaxTransaction(rewardsWallet, true);
738         _excludeFromMaxTransaction(cexWallet, true);
739         _excludeFromMaxTransaction(address(this), true);
740 
741         excludeFromFees(newOwner, true);
742         excludeFromFees(devTaxWallet, true);
743         excludeFromFees(marketingTaxWallet, true);
744         excludeFromFees(rewardsTaxWallet, true);
745         excludeFromFees(rewardsWallet, true);
746         excludeFromFees(cexWallet, true);
747 
748         excludeFromFees(address(this), true);
749         excludeFromFees(address(0xdead), true);
750 
751         _mint(newOwner, totalSupply * 85/100);
752         _mint(rewardsWallet, totalSupply * 10/100); //mint 10% for rewards
753         _mint(cexWallet, totalSupply * 5/100); //mint 5% for cex
754         transferOwnership(newOwner);
755     }
756 
757     function _transfer(address from, address to, uint256 amount) internal override {
758         require(from != address(0), "cannot transfer from the zero address");
759         require(to != address(0), "cannot transfer to the zero address");
760         require(amount > 0, "amount must be greater than 0");
761         //check for max wallet / max transaction
762         if(hasLimits){
763             if(from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
764 
765 
766                 //buy action
767                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
768                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
769                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
770                 }
771                 //sell action
772                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
773                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
774                 }
775                 //other transfers
776                 else if(!_isExcludedMaxTransactionAmount[to]){
777                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max amount");
778                 }
779             }
780         }
781 
782         uint256 contractTokenBalance = balanceOf(address(this));
783 
784         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
785 
786         if(canSwap && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
787             swapping = true;
788 
789             swapBack();
790 
791             swapping = false;
792         }
793 
794         bool takeFee = true;
795 
796         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
797             takeFee = false;
798         }
799 
800         uint256 fees = 0;
801 
802         if(takeFee){
803             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
804                 fees = amount * sellTotalFees / 100;
805                 tokensForRewards += fees * sellRewardsFee / sellTotalFees;
806                 tokensForDev += fees * sellDevFee / sellTotalFees;
807                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
808                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
809             }
810             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
811                 fees = amount * buyTotalFees / 100;
812                 tokensForRewards += fees * buyRewardsFee / buyTotalFees;
813                 tokensForDev += fees * buyDevFee / buyTotalFees;
814                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
815                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
816             }
817 
818             if(fees > 0){
819 
820             super._transfer(from, address(this), fees);
821             }
822 
823             amount -= fees;
824 
825         }
826 
827         super._transfer(from, to, amount);
828 
829     }
830 
831     function swapBack() private {
832 
833         //burn
834         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
835             _burn(address(this), tokensForBurn);
836         }
837         tokensForBurn = 0;
838 
839         uint256 contractBalance = balanceOf(address(this));
840         uint256 totalTokensToSwap = tokensForDev + tokensForMarketing + tokensForRewards;
841 
842         if(contractBalance == 0 || totalTokensToSwap == 0){return;}
843 
844         if(contractBalance > swapTokensAtAmount * 20){
845             contractBalance = swapTokensAtAmount * 20;
846         }
847 
848         bool success;
849 
850         swapTokensForEth(contractBalance);
851 
852         uint256 ethBalance = address(this).balance;
853 
854         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap);
855         uint256 ethForReward = ethBalance * tokensForRewards / (totalTokensToSwap);
856         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap);
857 
858         (success,) = address(devTaxWallet).call{value: ethForDev}("");
859         (success,) = address(rewardsTaxWallet).call{value: ethForReward}("");
860         (success,) = address(marketingTaxWallet).call{value: address(this).balance}("");
861 
862     }
863 
864     receive() external payable {}
865 
866     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
867         if(!isEx){
868             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
869         }
870         _isExcludedMaxTransactionAmount[updAds] = isEx;
871     }
872 
873     function _excludeFromMaxTransaction(address adrs, bool isExcluded) private {
874         _isExcludedMaxTransactionAmount[adrs] = isExcluded;
875         emit MaxTransactionExclusion(adrs, isExcluded);
876     }
877 
878     function swapTokensForEth(uint256 tokenAmount) private {
879 
880         // generate the uniswap pair path of token -> weth
881         address[] memory path = new address[](2);
882         path[0] = address(this);
883         path[1] = uniswapV2Router.WETH();
884 
885         _approve(address(this), address(uniswapV2Router), tokenAmount);
886 
887         // make the swap
888         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
889             tokenAmount,
890             0, // accept any amount of ETH
891             path,
892             address(this),
893             block.timestamp
894         );
895 
896     }
897 
898     // force Swap back if slippage issues.
899     function forceSwapBack() external onlyOwner {
900         require(balanceOf(address(this)) >= swapTokensAtAmount, "Contract should have a token amount that is higher than restriction");
901         swapping = true;
902         swapBack();
903         swapping = false;
904         emit OwnerForcedSwapBack(block.timestamp);
905     }
906 
907     // withdraw ETH from contract address
908     function withdrawStuckETH() external onlyOwner {
909         bool success;
910         (success,) = address(msg.sender).call{value: address(this).balance}("");
911     }
912 
913     function excludeFromFees(address account, bool excluded) public onlyOwner {
914         _isExcludedFromFees[account] = excluded;
915         emit ExcludeFromFees(account, excluded);
916     }
917 
918     function setWalletsAddresses(address _development, address _marketing, address _rewards) external onlyOwner {
919         require(_development != address(0),"address cannot be zero address");
920         require(_marketing != address(0),"address cannot be zero address");
921         require(_rewards != address(0),"address cannot be zero address");
922 
923         devTaxWallet = payable(_development);
924         marketingTaxWallet = payable(_marketing);
925         rewardsTaxWallet = payable(_rewards);
926 
927     }
928 
929     // change the minimum amount of tokens to sell from fees
930     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
931         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
932         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
933         swapTokensAtAmount = newAmount;
934     }
935 
936     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
937         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
938         maxWalletAmount = newNum * (10**18);
939         emit UpdatedMaxWalletAmount(maxWalletAmount);
940     }
941 
942     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
943         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
944         maxBuyAmount = newNum * (10**18);
945         emit UpdatedMaxBuyAmount(maxBuyAmount);
946     }
947 
948     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
949         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
950         maxSellAmount = newNum * (10**18);
951         emit UpdatedMaxSellAmount(maxSellAmount);
952     }
953 
954     function updateBuyFees(uint256 _developmentFee, uint256 _marketingFee, uint256 _rewardsFee, uint256 _burnFee) external onlyOwner {
955         buyDevFee = _developmentFee;
956         buyMarketingFee = _marketingFee;
957         buyRewardsFee = _rewardsFee;
958         buyBurnFee = _burnFee;
959         buyTotalFees = buyDevFee + buyMarketingFee + buyRewardsFee + buyBurnFee;
960         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
961     }
962 
963     function updateSellFees(uint256 _developmentFee, uint256 _marketingFee, uint256 _rewardsFee, uint256 _burnFee) external onlyOwner {
964         sellDevFee = _developmentFee;
965         sellMarketingFee = _marketingFee;
966         sellRewardsFee = _rewardsFee;
967         sellBurnFee = _burnFee;
968         sellTotalFees = sellDevFee + sellMarketingFee + sellRewardsFee + sellBurnFee;
969         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
970     }
971 
972     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
973         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
974 
975         _setAutomatedMarketMakerPair(pair, value);
976         emit SetAutomatedMarketMakerPair(pair, value);
977     }
978 
979     function _setAutomatedMarketMakerPair(address pair, bool value) private {
980         automatedMarketMakerPairs[lpPair] = value;
981 
982         _excludeFromMaxTransaction(lpPair, value);
983 
984         emit SetAutomatedMarketMakerPair(lpPair, value);
985     }
986     //remove limits after token is stable
987     function removeLimits() external onlyOwner {
988         hasLimits = false;
989         emit RemovedLimits();
990     }
991 
992     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
993     function buyBackTokens(uint256 amountInWei) external onlyOwner {
994         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
995 
996         address[] memory path = new address[](2);
997         path[0] = uniswapV2Router.WETH();
998         path[1] = address(this);
999 
1000         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
1001             0, // accept any amount of Ethereum
1002             path,
1003             address(0xdead),
1004             block.timestamp
1005         );
1006         emit BuyBackTriggered(amountInWei);
1007     }
1008 
1009 }