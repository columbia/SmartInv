1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 // File: @openzeppelin/contracts/utils/Context.sol
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor() {
51         _transferOwnership(_msgSender());
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         _checkOwner();
59         _;
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if the sender is not the owner.
71      */
72     function _checkOwner() internal view virtual {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
108 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
109 
110 /**
111  * @dev Interface of the ERC20 standard as defined in the EIP.
112  */
113 interface IERC20 {
114     /**
115      * @dev Emitted when `value` tokens are moved from one account (`from`) to
116      * another (`to`).
117      *
118      * Note that `value` may be zero.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 
122     /**
123      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124      * a call to {approve}. `value` is the new allowance.
125      */
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 
128     /**
129      * @dev Returns the amount of tokens in existence.
130      */
131     function totalSupply() external view returns (uint256);
132 
133     /**
134      * @dev Returns the amount of tokens owned by `account`.
135      */
136     function balanceOf(address account) external view returns (uint256);
137 
138     /**
139      * @dev Moves `amount` tokens from the caller's account to `to`.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transfer(address to, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Returns the remaining number of tokens that `spender` will be
149      * allowed to spend on behalf of `owner` through {transferFrom}. This is
150      * zero by default.
151      *
152      * This value changes when {approve} or {transferFrom} are called.
153      */
154     function allowance(address owner, address spender) external view returns (uint256);
155 
156     /**
157      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * IMPORTANT: Beware that changing an allowance with this method brings the risk
162      * that someone may use both the old and the new allowance by unfortunate
163      * transaction ordering. One possible solution to mitigate this race
164      * condition is to first reduce the spender's allowance to 0 and set the
165      * desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      *
168      * Emits an {Approval} event.
169      */
170     function approve(address spender, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Moves `amount` tokens from `from` to `to` using the
174      * allowance mechanism. `amount` is then deducted from the caller's
175      * allowance.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(
182         address from,
183         address to,
184         uint256 amount
185     ) external returns (bool);
186 }
187 
188 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
189 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
190 
191 
192 /**
193  * @dev Interface for the optional metadata functions from the ERC20 standard.
194  *
195  * _Available since v4.1._
196  */
197 interface IERC20Metadata is IERC20 {
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() external view returns (string memory);
202 
203     /**
204      * @dev Returns the symbol of the token.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the decimals places of the token.
210      */
211     function decimals() external view returns (uint8);
212 }
213 
214 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
215 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
216 
217 
218 /**
219  * @dev Implementation of the {IERC20} interface.
220  *
221  * This implementation is agnostic to the way tokens are created. This means
222  * that a supply mechanism has to be added in a derived contract using {_mint}.
223  * For a generic mechanism see {ERC20PresetMinterPauser}.
224  *
225  * TIP: For a detailed writeup see our guide
226  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
227  * to implement supply mechanisms].
228  *
229  * We have followed general OpenZeppelin Contracts guidelines: functions revert
230  * instead returning `false` on failure. This behavior is nonetheless
231  * conventional and does not conflict with the expectations of ERC20
232  * applications.
233  *
234  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
235  * This allows applications to reconstruct the allowance for all accounts just
236  * by listening to said events. Other implementations of the EIP may not emit
237  * these events, as it isn't required by the specification.
238  *
239  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
240  * functions have been added to mitigate the well-known issues around setting
241  * allowances. See {IERC20-approve}.
242  */
243 contract ERC20 is Context, IERC20, IERC20Metadata {
244     mapping(address => uint256) private _balances;
245 
246     mapping(address => mapping(address => uint256)) private _allowances;
247 
248     uint256 private _totalSupply;
249 
250     string private _name;
251     string private _symbol;
252 
253     /**
254      * @dev Sets the values for {name} and {symbol}.
255      *
256      * The default value of {decimals} is 18. To select a different value for
257      * {decimals} you should overload it.
258      *
259      * All two of these values are immutable: they can only be set once during
260      * construction.
261      */
262     constructor(string memory name_, string memory symbol_) {
263         _name = name_;
264         _symbol = symbol_;
265     }
266 
267     /**
268      * @dev Returns the name of the token.
269      */
270     function name() public view virtual override returns (string memory) {
271         return _name;
272     }
273 
274     /**
275      * @dev Returns the symbol of the token, usually a shorter version of the
276      * name.
277      */
278     function symbol() public view virtual override returns (string memory) {
279         return _symbol;
280     }
281 
282     /**
283      * @dev Returns the number of decimals used to get its user representation.
284      * For example, if `decimals` equals `2`, a balance of `505` tokens should
285      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
286      *
287      * Tokens usually opt for a value of 18, imitating the relationship between
288      * Ether and Wei. This is the value {ERC20} uses, unless this function is
289      * overridden;
290      *
291      * NOTE: This information is only used for _display_ purposes: it in
292      * no way affects any of the arithmetic of the contract, including
293      * {IERC20-balanceOf} and {IERC20-transfer}.
294      */
295     function decimals() public view virtual override returns (uint8) {
296         return 18;
297     }
298 
299     /**
300      * @dev See {IERC20-totalSupply}.
301      */
302     function totalSupply() public view virtual override returns (uint256) {
303         return _totalSupply;
304     }
305 
306     /**
307      * @dev See {IERC20-balanceOf}.
308      */
309     function balanceOf(address account) public view virtual override returns (uint256) {
310         return _balances[account];
311     }
312 
313     /**
314      * @dev See {IERC20-transfer}.
315      *
316      * Requirements:
317      *
318      * - `to` cannot be the zero address.
319      * - the caller must have a balance of at least `amount`.
320      */
321     function transfer(address to, uint256 amount) public virtual override returns (bool) {
322         address owner = _msgSender();
323         _transfer(owner, to, amount);
324         return true;
325     }
326 
327     /**
328      * @dev See {IERC20-allowance}.
329      */
330     function allowance(address owner, address spender) public view virtual override returns (uint256) {
331         return _allowances[owner][spender];
332     }
333 
334     /**
335      * @dev See {IERC20-approve}.
336      *
337      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
338      * `transferFrom`. This is semantically equivalent to an infinite approval.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      */
344     function approve(address spender, uint256 amount) public virtual override returns (bool) {
345         address owner = _msgSender();
346         _approve(owner, spender, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-transferFrom}.
352      *
353      * Emits an {Approval} event indicating the updated allowance. This is not
354      * required by the EIP. See the note at the beginning of {ERC20}.
355      *
356      * NOTE: Does not update the allowance if the current allowance
357      * is the maximum `uint256`.
358      *
359      * Requirements:
360      *
361      * - `from` and `to` cannot be the zero address.
362      * - `from` must have a balance of at least `amount`.
363      * - the caller must have allowance for ``from``'s tokens of at least
364      * `amount`.
365      */
366     function transferFrom(
367         address from,
368         address to,
369         uint256 amount
370     ) public virtual override returns (bool) {
371         address spender = _msgSender();
372         _spendAllowance(from, spender, amount);
373         _transfer(from, to, amount);
374         return true;
375     }
376 
377     /**
378      * @dev Atomically increases the allowance granted to `spender` by the caller.
379      *
380      * This is an alternative to {approve} that can be used as a mitigation for
381      * problems described in {IERC20-approve}.
382      *
383      * Emits an {Approval} event indicating the updated allowance.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      */
389     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
390         address owner = _msgSender();
391         _approve(owner, spender, allowance(owner, spender) + addedValue);
392         return true;
393     }
394 
395     /**
396      * @dev Atomically decreases the allowance granted to `spender` by the caller.
397      *
398      * This is an alternative to {approve} that can be used as a mitigation for
399      * problems described in {IERC20-approve}.
400      *
401      * Emits an {Approval} event indicating the updated allowance.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      * - `spender` must have allowance for the caller of at least
407      * `subtractedValue`.
408      */
409     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
410         address owner = _msgSender();
411         uint256 currentAllowance = allowance(owner, spender);
412         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
413         unchecked {
414             _approve(owner, spender, currentAllowance - subtractedValue);
415         }
416 
417         return true;
418     }
419 
420     /**
421      * @dev Moves `amount` of tokens from `from` to `to`.
422      *
423      * This internal function is equivalent to {transfer}, and can be used to
424      * e.g. implement automatic token fees, slashing mechanisms, etc.
425      *
426      * Emits a {Transfer} event.
427      *
428      * Requirements:
429      *
430      * - `from` cannot be the zero address.
431      * - `to` cannot be the zero address.
432      * - `from` must have a balance of at least `amount`.
433      */
434     function _transfer(
435         address from,
436         address to,
437         uint256 amount
438     ) internal virtual {
439         require(from != address(0), "ERC20: transfer from the zero address");
440         require(to != address(0), "ERC20: transfer to the zero address");
441 
442         _beforeTokenTransfer(from, to, amount);
443 
444         uint256 fromBalance = _balances[from];
445         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
446         unchecked {
447             _balances[from] = fromBalance - amount;
448             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
449             // decrementing then incrementing.
450             _balances[to] += amount;
451         }
452 
453         emit Transfer(from, to, amount);
454 
455         _afterTokenTransfer(from, to, amount);
456     }
457 
458     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
459      * the total supply.
460      *
461      * Emits a {Transfer} event with `from` set to the zero address.
462      *
463      * Requirements:
464      *
465      * - `account` cannot be the zero address.
466      */
467     function _mint(address account, uint256 amount) internal virtual {
468         require(account != address(0), "ERC20: mint to the zero address");
469 
470         _beforeTokenTransfer(address(0), account, amount);
471 
472         _totalSupply += amount;
473         unchecked {
474             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
475             _balances[account] += amount;
476         }
477         emit Transfer(address(0), account, amount);
478 
479         _afterTokenTransfer(address(0), account, amount);
480     }
481 
482     /**
483      * @dev Destroys `amount` tokens from `account`, reducing the
484      * total supply.
485      *
486      * Emits a {Transfer} event with `to` set to the zero address.
487      *
488      * Requirements:
489      *
490      * - `account` cannot be the zero address.
491      * - `account` must have at least `amount` tokens.
492      */
493     function _burn(address account, uint256 amount) internal virtual {
494         require(account != address(0), "ERC20: burn from the zero address");
495 
496         _beforeTokenTransfer(account, address(0), amount);
497 
498         uint256 accountBalance = _balances[account];
499         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
500         unchecked {
501             _balances[account] = accountBalance - amount;
502             // Overflow not possible: amount <= accountBalance <= totalSupply.
503             _totalSupply -= amount;
504         }
505 
506         emit Transfer(account, address(0), amount);
507 
508         _afterTokenTransfer(account, address(0), amount);
509     }
510 
511     /**
512      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
513      *
514      * This internal function is equivalent to `approve`, and can be used to
515      * e.g. set automatic allowances for certain subsystems, etc.
516      *
517      * Emits an {Approval} event.
518      *
519      * Requirements:
520      *
521      * - `owner` cannot be the zero address.
522      * - `spender` cannot be the zero address.
523      */
524     function _approve(
525         address owner,
526         address spender,
527         uint256 amount
528     ) internal virtual {
529         require(owner != address(0), "ERC20: approve from the zero address");
530         require(spender != address(0), "ERC20: approve to the zero address");
531 
532         _allowances[owner][spender] = amount;
533         emit Approval(owner, spender, amount);
534     }
535 
536     /**
537      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
538      *
539      * Does not update the allowance amount in case of infinite allowance.
540      * Revert if not enough allowance is available.
541      *
542      * Might emit an {Approval} event.
543      */
544     function _spendAllowance(
545         address owner,
546         address spender,
547         uint256 amount
548     ) internal virtual {
549         uint256 currentAllowance = allowance(owner, spender);
550         if (currentAllowance != type(uint256).max) {
551             require(currentAllowance >= amount, "ERC20: insufficient allowance");
552             unchecked {
553                 _approve(owner, spender, currentAllowance - amount);
554             }
555         }
556     }
557 
558     /**
559      * @dev Hook that is called before any transfer of tokens. This includes
560      * minting and burning.
561      *
562      * Calling conditions:
563      *
564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
565      * will be transferred to `to`.
566      * - when `from` is zero, `amount` tokens will be minted for `to`.
567      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
568      * - `from` and `to` are never both zero.
569      *
570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
571      */
572     function _beforeTokenTransfer(
573         address from,
574         address to,
575         uint256 amount
576     ) internal virtual {}
577 
578     /**
579      * @dev Hook that is called after any transfer of tokens. This includes
580      * minting and burning.
581      *
582      * Calling conditions:
583      *
584      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
585      * has been transferred to `to`.
586      * - when `from` is zero, `amount` tokens have been minted for `to`.
587      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
588      * - `from` and `to` are never both zero.
589      *
590      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
591      */
592     function _afterTokenTransfer(
593         address from,
594         address to,
595         uint256 amount
596     ) internal virtual {}
597 }
598 
599 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
600 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
601 
602 /**
603  * @dev Extension of {ERC20} that allows token holders to destroy both their own
604  * tokens and those that they have an allowance for, in a way that can be
605  * recognized off-chain (via event analysis).
606  */
607 abstract contract ERC20Burnable is Context, ERC20 {
608     /**
609      * @dev Destroys `amount` tokens from the caller.
610      *
611      * See {ERC20-_burn}.
612      */
613     function burn(uint256 amount) public virtual {
614         _burn(_msgSender(), amount);
615     }
616 
617     /**
618      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
619      * allowance.
620      *
621      * See {ERC20-_burn} and {ERC20-allowance}.
622      *
623      * Requirements:
624      *
625      * - the caller must have allowance for ``accounts``'s tokens of at least
626      * `amount`.
627      */
628     function burnFrom(address account, uint256 amount) public virtual {
629         _spendAllowance(account, _msgSender(), amount);
630         _burn(account, amount);
631     }
632 }
633 
634 interface IUniswapV2Factory {
635 
636     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
637     function createPair(address tokenA, address tokenB) external returns (address pair);
638 }
639 
640 interface IUniswapV2Router02  {
641   
642     function factory() external pure returns (address);
643     function WETH() external pure returns (address);
644 }
645 
646 
647 contract NAMX is ERC20, ERC20Burnable,  Ownable {
648     IUniswapV2Router02 public uniswapV2Router;
649     address public uniswapV2Pair;
650 
651     mapping (address => bool) public isExcludedFromLimits;
652     mapping (address => bool) public automatedMarketMakerPairs;
653 
654     uint256 public maxTxAmount;
655     uint256 public maxWalletAmount;
656 
657     address public routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
658 
659     event UpdateUniswapV2Router(address indexed newAddress);
660     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
661 
662     constructor() ERC20("Namx", "NAMX") {
663         maxTxAmount = 24_000_000 * 10 ** decimals(); // 1% of total supply
664         maxWalletAmount = 48_000_000 * 10 ** decimals(); // 2% of total supply
665 
666         _updateUniswapV2Router(routerAddress);
667         excludeFromLimits(owner(), true);
668         excludeFromLimits(address(this), true);
669         excludeFromLimits(address(0x0), true);
670         excludeFromLimits(address(0xdead), true);
671 
672         _mint(owner(), 2_400_000_000 * 10 ** decimals());
673     }
674 
675     function _updateUniswapV2Router(address newAddress) internal {
676         uniswapV2Router = IUniswapV2Router02(newAddress);
677         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
678         .createPair(address(this), uniswapV2Router.WETH());
679 
680         excludeFromLimits(newAddress, true);
681 
682         uniswapV2Pair = _uniswapV2Pair;
683         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
684 
685         emit UpdateUniswapV2Router(newAddress);
686     }
687 
688     function setAutomatedMarketMakerPair(address pair, bool value)
689         public
690         onlyOwner
691     {
692         require(
693             pair != uniswapV2Pair,
694             "NameX: The uniswapV2pair cannot be removed from automatedMarketMakerPairs"
695         );
696 
697         _setAutomatedMarketMakerPair(pair, value);
698     }
699 
700     function _setAutomatedMarketMakerPair(address pair, bool value) private {
701         require(
702             automatedMarketMakerPairs[pair] != value,
703             "NameX: Automated market maker pair is already set to that value"
704         );
705         automatedMarketMakerPairs[pair] = value;
706 
707         if (value) {
708             excludeFromLimits(pair, true);
709         }
710 
711         emit SetAutomatedMarketMakerPair(pair, value);
712     }
713 
714     
715     function changeMaxTxAmount(uint256 amount) public onlyOwner {
716         require (amount >= totalSupply() / 200,"max tx amount can't be lower than 0.5% of the supply");
717         maxTxAmount = amount;
718     }
719 
720     function changeMaxWalletAmount(uint256 amount) public onlyOwner {
721         require (amount >= totalSupply() / 100, "max Wallet amount must be greator than 1% of the supply");
722         maxWalletAmount = amount;
723     }
724 
725     function excludeFromLimits(address account, bool excluded) public onlyOwner {
726         isExcludedFromLimits[account] = excluded;
727     }
728 
729     function claimStuckedERC20 (address token, uint256 amount) external onlyOwner {
730         IERC20(token).transfer(owner(), amount);
731     }
732 
733     function _beforeTokenTransfer(address from, address to, uint256 amount)
734         internal
735         override
736     {
737 
738        /// maxTx applicable to transfers only, not buy/sell
739         if (!isExcludedFromLimits[from] || (automatedMarketMakerPairs[from] && !isExcludedFromLimits[to])) {
740             require(amount <= maxTxAmount, "Anti-whale: Transfer amount exceeds max limit");
741         }
742 
743         /// maxWallet applicable to all user except who are not excluded from limits
744         if (!isExcludedFromLimits[to]) {
745             require(balanceOf(to) + amount <= maxWalletAmount, "Anti-whale: Wallet exceeds maxWallet limit");
746         }
747 
748         super._beforeTokenTransfer(from, to, amount);
749     }
750 
751 }