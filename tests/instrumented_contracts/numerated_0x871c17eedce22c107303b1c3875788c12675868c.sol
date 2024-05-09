1 /**
2 
3 Website : https://jacked.vip
4 Twitter : https://twitter.com/clarifythisJack
5 Telegram : https://t.me/JackPortalErc
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // File: @openzeppelin/contracts/utils/Context.sol
12 
13 
14 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 // File: @openzeppelin/contracts/access/Ownable.sol
39 
40 
41 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         _checkOwner();
75         _;
76     }
77 
78     /**
79      * @dev Returns the address of the current owner.
80      */
81     function owner() public view virtual returns (address) {
82         return _owner;
83     }
84 
85     /**
86      * @dev Throws if the sender is not the owner.
87      */
88     function _checkOwner() internal view virtual {
89         require(owner() == _msgSender(), "Ownable: caller is not the owner");
90     }
91 
92     /**
93      * @dev Leaves the contract without owner. It will not be possible to call
94      * `onlyOwner` functions anymore. Can only be called by the current owner.
95      *
96      * NOTE: Renouncing ownership will leave the contract without an owner,
97      * thereby removing any functionality that is only available to the owner.
98      */
99     function renounceOwnership() public virtual onlyOwner {
100         _transferOwnership(address(0));
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Can only be called by the current owner.
106      */
107     function transferOwnership(address newOwner) public virtual onlyOwner {
108         require(newOwner != address(0), "Ownable: new owner is the zero address");
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Internal function without access restriction.
115      */
116     function _transferOwnership(address newOwner) internal virtual {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
124 
125 
126 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Interface of the ERC20 standard as defined in the EIP.
132  */
133 interface IERC20 {
134     /**
135      * @dev Emitted when `value` tokens are moved from one account (`from`) to
136      * another (`to`).
137      *
138      * Note that `value` may be zero.
139      */
140     event Transfer(address indexed from, address indexed to, uint256 value);
141 
142     /**
143      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
144      * a call to {approve}. `value` is the new allowance.
145      */
146     event Approval(address indexed owner, address indexed spender, uint256 value);
147 
148     /**
149      * @dev Returns the amount of tokens in existence.
150      */
151     function totalSupply() external view returns (uint256);
152 
153     /**
154      * @dev Returns the amount of tokens owned by `account`.
155      */
156     function balanceOf(address account) external view returns (uint256);
157 
158     /**
159      * @dev Moves `amount` tokens from the caller's account to `to`.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transfer(address to, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Returns the remaining number of tokens that `spender` will be
169      * allowed to spend on behalf of `owner` through {transferFrom}. This is
170      * zero by default.
171      *
172      * This value changes when {approve} or {transferFrom} are called.
173      */
174     function allowance(address owner, address spender) external view returns (uint256);
175 
176     /**
177      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * IMPORTANT: Beware that changing an allowance with this method brings the risk
182      * that someone may use both the old and the new allowance by unfortunate
183      * transaction ordering. One possible solution to mitigate this race
184      * condition is to first reduce the spender's allowance to 0 and set the
185      * desired value afterwards:
186      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187      *
188      * Emits an {Approval} event.
189      */
190     function approve(address spender, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Moves `amount` tokens from `from` to `to` using the
194      * allowance mechanism. `amount` is then deducted from the caller's
195      * allowance.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transferFrom(
202         address from,
203         address to,
204         uint256 amount
205     ) external returns (bool);
206 }
207 
208 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 
216 /**
217  * @dev Interface for the optional metadata functions from the ERC20 standard.
218  *
219  * _Available since v4.1._
220  */
221 interface IERC20Metadata is IERC20 {
222     /**
223      * @dev Returns the name of the token.
224      */
225     function name() external view returns (string memory);
226 
227     /**
228      * @dev Returns the symbol of the token.
229      */
230     function symbol() external view returns (string memory);
231 
232     /**
233      * @dev Returns the decimals places of the token.
234      */
235     function decimals() external view returns (uint8);
236 }
237 
238 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
239 
240 
241 // OpenZeppelin Contracts (last updated v4.8.) (token/ERC20/ERC20.sol)
242 
243 pragma solidity ^0.8.0;
244 
245 
246 
247 
248 /**
249  * @dev Implementation of the {IERC20} interface.
250  *
251  * This implementation is agnostic to the way tokens are created. This means
252  * that a supply mechanism has to be added in a derived contract using {_mint}.
253  * For a generic mechanism see {ERC20PresetMinterPauser}.
254  *
255  * TIP: For a detailed writeup see our guide
256  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
257  * to implement supply mechanisms].
258  *
259  * We have followed general OpenZeppelin Contracts guidelines: functions revert
260  * instead returning `false` on failure. This behavior is nonetheless
261  * conventional and does not conflict with the expectations of ERC20
262  * applications.
263  *
264  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
265  * This allows applications to reconstruct the allowance for all accounts just
266  * by listening to said events. Other implementations of the EIP may not emit
267  * these events, as it isn't required by the specification.
268  *
269  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
270  * functions have been added to mitigate the well-known issues around setting
271  * allowances. See {IERC20-approve}.
272  */
273 contract ERC20 is Context, IERC20, IERC20Metadata {
274     mapping(address => uint256) private _balances;
275 
276     mapping(address => mapping(address => uint256)) private _allowances;
277 
278     uint256 private _totalSupply;
279 
280     string private _name;
281     string private _symbol;
282 
283     /**
284      * @dev Sets the values for {name} and {symbol}.
285      *
286      * The default value of {decimals} is 18. To select a different value for
287      * {decimals} you should overload it.
288      *
289      * All two of these values are immutable: they can only be set once during
290      * construction.
291      */
292     constructor(string memory name_, string memory symbol_) {
293         _name = name_;
294         _symbol = symbol_;
295     }
296 
297     /**
298      * @dev Returns the name of the token.
299      */
300     function name() public view virtual override returns (string memory) {
301         return _name;
302     }
303 
304     /**
305      * @dev Returns the symbol of the token, usually a shorter version of the
306      * name.
307      */
308     function symbol() public view virtual override returns (string memory) {
309         return _symbol;
310     }
311 
312     /**
313      * @dev Returns the number of decimals used to get its user representation.
314      * For example, if `decimals` equals `2`, a balance of `505` tokens should
315      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
316      *
317      * Tokens usually opt for a value of 18, imitating the relationship between
318      * Ether and Wei. This is the value {ERC20} uses, unless this function is
319      * overridden;
320      *
321      * NOTE: This information is only used for _display_ purposes: it in
322      * no way affects any of the arithmetic of the contract, including
323      * {IERC20-balanceOf} and {IERC20-transfer}.
324      */
325     function decimals() public view virtual override returns (uint8) {
326         return 18;
327     }
328 
329     /**
330      * @dev See {IERC20-totalSupply}.
331      */
332     function totalSupply() public view virtual override returns (uint256) {
333         return _totalSupply;
334     }
335 
336     /**
337      * @dev See {IERC20-balanceOf}.
338      */
339     function balanceOf(address account) public view virtual override returns (uint256) {
340         return _balances[account];
341     }
342 
343     /**
344      * @dev See {IERC20-transfer}.
345      *
346      * Requirements:
347      *
348      * - `to` cannot be the zero address.
349      * - the caller must have a balance of at least `amount`.
350      */
351     function transfer(address to, uint256 amount) public virtual override returns (bool) {
352         address owner = _msgSender();
353         _transfer(owner, to, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-allowance}.
359      */
360     function allowance(address owner, address spender) public view virtual override returns (uint256) {
361         return _allowances[owner][spender];
362     }
363 
364     /**
365      * @dev See {IERC20-approve}.
366      *
367      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
368      * `transferFrom`. This is semantically equivalent to an infinite approval.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function approve(address spender, uint256 amount) public virtual override returns (bool) {
375         address owner = _msgSender();
376         _approve(owner, spender, amount);
377         return true;
378     }
379 
380     /**
381      * @dev See {IERC20-transferFrom}.
382      *
383      * Emits an {Approval} event indicating the updated allowance. This is not
384      * required by the EIP. See the note at the beginning of {ERC20}.
385      *
386      * NOTE: Does not update the allowance if the current allowance
387      * is the maximum `uint256`.
388      *
389      * Requirements:
390      *
391      * - `from` and `to` cannot be the zero address.
392      * - `from` must have a balance of at least `amount`.
393      * - the caller must have allowance for ``from``'s tokens of at least
394      * `amount`.
395      */
396     function transferFrom(
397         address from,
398         address to,
399         uint256 amount
400     ) public virtual override returns (bool) {
401         address spender = _msgSender();
402         _spendAllowance(from, spender, amount);
403         _transfer(from, to, amount);
404         return true;
405     }
406 
407     /**
408      * @dev Atomically increases the allowance granted to `spender` by the caller.
409      *
410      * This is an alternative to {approve} that can be used as a mitigation for
411      * problems described in {IERC20-approve}.
412      *
413      * Emits an {Approval} event indicating the updated allowance.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
420         address owner = _msgSender();
421         _approve(owner, spender, allowance(owner, spender) + addedValue);
422         return true;
423     }
424 
425     /**
426      * @dev Atomically decreases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      * - `spender` must have allowance for the caller of at least
437      * `subtractedValue`.
438      */
439     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
440         address owner = _msgSender();
441         uint256 currentAllowance = allowance(owner, spender);
442         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
443         unchecked {
444             _approve(owner, spender, currentAllowance - subtractedValue);
445         }
446 
447         return true;
448     }
449 
450     /**
451      * @dev Moves `amount` of tokens from `from` to `to`.
452      *
453      * This internal function is equivalent to {transfer}, and can be used to
454      * e.g. implement automatic token fees, slashing mechanisms, etc.
455      *
456      * Emits a {Transfer} event.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `from` must have a balance of at least `amount`.
463      */
464     function _transfer(
465         address from,
466         address to,
467         uint256 amount
468     ) internal virtual {
469         require(from != address(0), "ERC20: transfer from the zero address");
470         require(to != address(0), "ERC20: transfer to the zero address");
471 
472         _beforeTokenTransfer(from, to, amount);
473 
474         uint256 fromBalance = _balances[from];
475         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
476         unchecked {
477             _balances[from] = fromBalance - amount;
478             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
479             // decrementing then incrementing.
480             _balances[to] += amount;
481         }
482 
483         emit Transfer(from, to, amount);
484 
485         _afterTokenTransfer(from, to, amount);
486     }
487 
488     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
489      * the total supply.
490      *
491      * Emits a {Transfer} event with `from` set to the zero address.
492      *
493      * Requirements:
494      *
495      * - `account` cannot be the zero address.
496      */
497     function _mint(address account, uint256 amount) internal virtual {
498         require(account != address(0), "ERC20: mint to the zero address");
499 
500         _beforeTokenTransfer(address(0), account, amount);
501 
502         _totalSupply += amount;
503         unchecked {
504             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
505             _balances[account] += amount;
506         }
507         emit Transfer(address(0), account, amount);
508 
509         _afterTokenTransfer(address(0), account, amount);
510     }
511 
512     /**
513      * @dev Destroys `amount` tokens from `account`, reducing the
514      * total supply.
515      *
516      * Emits a {Transfer} event with `to` set to the zero address.
517      *
518      * Requirements:
519      *
520      * - `account` cannot be the zero address.
521      * - `account` must have at least `amount` tokens.
522      */
523     function _burn(address account, uint256 amount) internal virtual {
524         require(account != address(0), "ERC20: burn from the zero address");
525 
526         _beforeTokenTransfer(account, address(0), amount);
527 
528         uint256 accountBalance = _balances[account];
529         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
530         unchecked {
531             _balances[account] = accountBalance - amount;
532             // Overflow not possible: amount <= accountBalance <= totalSupply.
533             _totalSupply -= amount;
534         }
535 
536         emit Transfer(account, address(0), amount);
537 
538         _afterTokenTransfer(account, address(0), amount);
539     }
540 
541     /**
542      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
543      *
544      * This internal function is equivalent to `approve`, and can be used to
545      * e.g. set automatic allowances for certain subsystems, etc.
546      *
547      * Emits an {Approval} event.
548      *
549      * Requirements:
550      *
551      * - `owner` cannot be the zero address.
552      * - `spender` cannot be the zero address.
553      */
554     function _approve(
555         address owner,
556         address spender,
557         uint256 amount
558     ) internal virtual {
559         require(owner != address(0), "ERC20: approve from the zero address");
560         require(spender != address(0), "ERC20: approve to the zero address");
561 
562         _allowances[owner][spender] = amount;
563         emit Approval(owner, spender, amount);
564     }
565 
566     /**
567      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
568      *
569      * Does not update the allowance amount in case of infinite allowance.
570      * Revert if not enough allowance is available.
571      *
572      * Might emit an {Approval} event.
573      */
574     function _spendAllowance(
575         address owner,
576         address spender,
577         uint256 amount
578     ) internal virtual {
579         uint256 currentAllowance = allowance(owner, spender);
580         if (currentAllowance != type(uint256).max) {
581             require(currentAllowance >= amount, "ERC20: insufficient allowance");
582             unchecked {
583                 _approve(owner, spender, currentAllowance - amount);
584             }
585         }
586     }
587 
588     /**
589      * @dev Hook that is called before any transfer of tokens. This includes
590      * minting and burning.
591      *
592      * Calling conditions:
593      *
594      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
595      * will be transferred to `to`.
596      * - when `from` is zero, `amount` tokens will be minted for `to`.
597      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
598      * - `from` and `to` are never both zero.
599      *
600      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
601      */
602     function _beforeTokenTransfer(
603         address from,
604         address to,
605         uint256 amount
606     ) internal virtual {}
607 
608     /**
609      * @dev Hook that is called after any transfer of tokens. This includes
610      * minting and burning.
611      *
612      * Calling conditions:
613      *
614      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
615      * has been transferred to `to`.
616      * - when `from` is zero, `amount` tokens have been minted for `to`.
617      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
618      * - `from` and `to` are never both zero.
619      *
620      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
621      */
622     function _afterTokenTransfer(
623         address from,
624         address to,
625         uint256 amount
626     ) internal virtual {}
627 }
628 
629 // File: jack.sol
630 
631 
632 
633 pragma solidity ^0.8.17;
634 
635 
636 
637 contract JackCoin is ERC20, Ownable {
638 
639     uint256 public buyTaxPercentage;
640     uint256 public sellTaxPercentage;
641     uint256 public maxBuy;
642     bool public tradingEnabled;
643     address public uniswapPair;
644     address public marketingWallet;
645     address public cexWallet;
646     address public partnershipWallet;
647     address public taxWallet;
648     bool private liquidityAdded;
649 
650 
651     constructor(
652         address _marketingWallet,
653         address _cexWallet,
654         address _taxWallet,
655         address _partnershipWallet
656     ) ERC20("Jack AI", "JACK") {
657         uint256 initialSupply = 69696969 * 10**18;
658         uint256 marketingAmount = (initialSupply * 8) / 100;
659         uint256 cexAmount = (initialSupply * 3) / 100;
660         uint256 partnershipAmount = (initialSupply * 4) / 100;
661         uint256 remainingAmount = initialSupply - marketingAmount - cexAmount - partnershipAmount;
662 
663         marketingWallet = _marketingWallet;
664         cexWallet = _cexWallet;
665         taxWallet = _taxWallet;
666         partnershipWallet = _partnershipWallet;
667 
668         _mint(marketingWallet, marketingAmount);
669         _mint(cexWallet, cexAmount);
670         _mint(partnershipWallet, partnershipAmount);
671         _mint(msg.sender, remainingAmount);
672     }
673 
674     function addLiquidity() public onlyOwner {
675         require(!liquidityAdded, "Liquidity already added");
676         liquidityAdded = true;
677     }
678 
679     function setMaxBuy(uint256 _maxBuy) public onlyOwner {
680         require(_maxBuy >= 0 && _maxBuy <= 100, "Invalid buy max buy");
681         maxBuy = _maxBuy;
682     }
683 
684     function setBuyTaxPercentage(uint256 _buyTaxPercentage) public onlyOwner {
685         require(_buyTaxPercentage >= 0 && _buyTaxPercentage <= 100, "Invalid buy tax percentage");
686         buyTaxPercentage = _buyTaxPercentage;
687     }
688 
689     function setSellTaxPercentage(uint256 _sellTaxPercentage) public onlyOwner {
690         require(_sellTaxPercentage >= 0 && _sellTaxPercentage <= 100, "Invalid sell tax percentage");
691         sellTaxPercentage = _sellTaxPercentage;
692     }
693 
694         function setUniswapPair(address _uniswapPair) public onlyOwner {
695         uniswapPair = _uniswapPair;
696     }
697 
698         function enableTrading() public onlyOwner {
699         tradingEnabled = true;
700     }
701 
702     // Override the _transfer function to apply taxes on transfers
703     function _transfer(
704         address sender,
705         address recipient,
706         uint256 amount
707     ) internal virtual override {
708         require(tradingEnabled || sender == owner() || recipient == owner(), "Trading is not enabled");
709 
710         uint256 taxPercentage;
711         if (sender == owner() || recipient == owner() || recipient == taxWallet || sender == taxWallet ) {
712             taxPercentage = 0;
713         } else if (recipient == uniswapPair) {
714             taxPercentage = sellTaxPercentage;
715         } else if (sender == uniswapPair) {
716             taxPercentage = buyTaxPercentage;
717         } else {
718             taxPercentage = 0;
719         }
720 
721         uint256 taxAmount = (amount * taxPercentage) / 100;
722         uint256 netAmount = amount - taxAmount;
723 
724         uint256 maxWalletAmount = totalSupply() * maxBuy / 100;
725         bool isExcludedWallet = (recipient == owner() || recipient == taxWallet || recipient == marketingWallet || recipient == cexWallet || recipient == partnershipWallet || recipient == uniswapPair);
726         
727         if ((tradingEnabled && sender == uniswapPair) && !isExcludedWallet) {
728             require(balanceOf(recipient) + netAmount <= maxWalletAmount, "Forbid");
729         }
730         // Apply tax
731         super._transfer(sender, taxWallet, taxAmount);
732         // Transfer net amount to recipient
733         super._transfer(sender, recipient, netAmount);
734     }
735 }