1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Emitted when `value` tokens are moved from one account (`from`) to
13      * another (`to`).
14      *
15      * Note that `value` may be zero.
16      */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /**
20      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
21      * a call to {approve}. `value` is the new allowance.
22      */
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `to`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address to, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `from` to `to` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(address from, address to, uint256 amount) external returns (bool);
79 }
80 
81 
82 
83 
84 
85 
86 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  *
93  * _Available since v4.1._
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 
113 
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Provides information about the current execution context, including the
122  * sender of the transaction and its data. While these are generally available
123  * via msg.sender and msg.data, they should not be accessed in such a direct
124  * manner, since when dealing with meta-transactions the account sending and
125  * paying for execution may not be the actual sender (as far as an application
126  * is concerned).
127  *
128  * This contract is only required for intermediate, library-like contracts.
129  */
130 abstract contract Context {
131     function _msgSender() internal view virtual returns (address) {
132         return msg.sender;
133     }
134 
135     function _msgData() internal view virtual returns (bytes calldata) {
136         return msg.data;
137     }
138 }
139 
140 
141 
142 
143 
144 
145 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 /**
150  * @dev Implementation of the {IERC20} interface.
151  *
152  * This implementation is agnostic to the way tokens are created. This means
153  * that a supply mechanism has to be added in a derived contract using {_mint}.
154  * For a generic mechanism see {ERC20PresetMinterPauser}.
155  *
156  * TIP: For a detailed writeup see our guide
157  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
158  * to implement supply mechanisms].
159  *
160  * The default value of {decimals} is 18. To change this, you should override
161  * this function so it returns a different value.
162  *
163  * We have followed general OpenZeppelin Contracts guidelines: functions revert
164  * instead returning `false` on failure. This behavior is nonetheless
165  * conventional and does not conflict with the expectations of ERC20
166  * applications.
167  *
168  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
169  * This allows applications to reconstruct the allowance for all accounts just
170  * by listening to said events. Other implementations of the EIP may not emit
171  * these events, as it isn't required by the specification.
172  *
173  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
174  * functions have been added to mitigate the well-known issues around setting
175  * allowances. See {IERC20-approve}.
176  */
177 contract ERC20 is Context, IERC20, IERC20Metadata {
178     mapping(address => uint256) private _balances;
179 
180     mapping(address => mapping(address => uint256)) private _allowances;
181 
182     uint256 private _totalSupply;
183 
184     string private _name;
185     string private _symbol;
186 
187     /**
188      * @dev Sets the values for {name} and {symbol}.
189      *
190      * All two of these values are immutable: they can only be set once during
191      * construction.
192      */
193     constructor(string memory name_, string memory symbol_) {
194         _name = name_;
195         _symbol = symbol_;
196     }
197 
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() public view virtual override returns (string memory) {
202         return _name;
203     }
204 
205     /**
206      * @dev Returns the symbol of the token, usually a shorter version of the
207      * name.
208      */
209     function symbol() public view virtual override returns (string memory) {
210         return _symbol;
211     }
212 
213     /**
214      * @dev Returns the number of decimals used to get its user representation.
215      * For example, if `decimals` equals `2`, a balance of `505` tokens should
216      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
217      *
218      * Tokens usually opt for a value of 18, imitating the relationship between
219      * Ether and Wei. This is the default value returned by this function, unless
220      * it's overridden.
221      *
222      * NOTE: This information is only used for _display_ purposes: it in
223      * no way affects any of the arithmetic of the contract, including
224      * {IERC20-balanceOf} and {IERC20-transfer}.
225      */
226     function decimals() public view virtual override returns (uint8) {
227         return 18;
228     }
229 
230     /**
231      * @dev See {IERC20-totalSupply}.
232      */
233     function totalSupply() public view virtual override returns (uint256) {
234         return _totalSupply;
235     }
236 
237     /**
238      * @dev See {IERC20-balanceOf}.
239      */
240     function balanceOf(address account) public view virtual override returns (uint256) {
241         return _balances[account];
242     }
243 
244     /**
245      * @dev See {IERC20-transfer}.
246      *
247      * Requirements:
248      *
249      * - `to` cannot be the zero address.
250      * - the caller must have a balance of at least `amount`.
251      */
252     function transfer(address to, uint256 amount) public virtual override returns (bool) {
253         address owner = _msgSender();
254         _transfer(owner, to, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-allowance}.
260      */
261     function allowance(address owner, address spender) public view virtual override returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     /**
266      * @dev See {IERC20-approve}.
267      *
268      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
269      * `transferFrom`. This is semantically equivalent to an infinite approval.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function approve(address spender, uint256 amount) public virtual override returns (bool) {
276         address owner = _msgSender();
277         _approve(owner, spender, amount);
278         return true;
279     }
280 
281     /**
282      * @dev See {IERC20-transferFrom}.
283      *
284      * Emits an {Approval} event indicating the updated allowance. This is not
285      * required by the EIP. See the note at the beginning of {ERC20}.
286      *
287      * NOTE: Does not update the allowance if the current allowance
288      * is the maximum `uint256`.
289      *
290      * Requirements:
291      *
292      * - `from` and `to` cannot be the zero address.
293      * - `from` must have a balance of at least `amount`.
294      * - the caller must have allowance for ``from``'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
298         address spender = _msgSender();
299         _spendAllowance(from, spender, amount);
300         _transfer(from, to, amount);
301         return true;
302     }
303 
304     /**
305      * @dev Atomically increases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
317         address owner = _msgSender();
318         _approve(owner, spender, allowance(owner, spender) + addedValue);
319         return true;
320     }
321 
322     /**
323      * @dev Atomically decreases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      * - `spender` must have allowance for the caller of at least
334      * `subtractedValue`.
335      */
336     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
337         address owner = _msgSender();
338         uint256 currentAllowance = allowance(owner, spender);
339         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
340         unchecked {
341             _approve(owner, spender, currentAllowance - subtractedValue);
342         }
343 
344         return true;
345     }
346 
347     /**
348      * @dev Moves `amount` of tokens from `from` to `to`.
349      *
350      * This internal function is equivalent to {transfer}, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a {Transfer} event.
354      *
355      * Requirements:
356      *
357      * - `from` cannot be the zero address.
358      * - `to` cannot be the zero address.
359      * - `from` must have a balance of at least `amount`.
360      */
361     function _transfer(address from, address to, uint256 amount) internal virtual {
362         require(from != address(0), "ERC20: transfer from the zero address");
363         require(to != address(0), "ERC20: transfer to the zero address");
364 
365         _beforeTokenTransfer(from, to, amount);
366 
367         uint256 fromBalance = _balances[from];
368         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
369         unchecked {
370             _balances[from] = fromBalance - amount;
371             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
372             // decrementing then incrementing.
373             _balances[to] += amount;
374         }
375 
376         emit Transfer(from, to, amount);
377 
378         _afterTokenTransfer(from, to, amount);
379     }
380 
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a {Transfer} event with `from` set to the zero address.
385      *
386      * Requirements:
387      *
388      * - `account` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: mint to the zero address");
392 
393         _beforeTokenTransfer(address(0), account, amount);
394 
395         _totalSupply += amount;
396         unchecked {
397             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
398             _balances[account] += amount;
399         }
400         emit Transfer(address(0), account, amount);
401 
402         _afterTokenTransfer(address(0), account, amount);
403     }
404 
405     /**
406      * @dev Destroys `amount` tokens from `account`, reducing the
407      * total supply.
408      *
409      * Emits a {Transfer} event with `to` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      * - `account` must have at least `amount` tokens.
415      */
416     function _burn(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: burn from the zero address");
418 
419         _beforeTokenTransfer(account, address(0), amount);
420 
421         uint256 accountBalance = _balances[account];
422         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
423         unchecked {
424             _balances[account] = accountBalance - amount;
425             // Overflow not possible: amount <= accountBalance <= totalSupply.
426             _totalSupply -= amount;
427         }
428 
429         emit Transfer(account, address(0), amount);
430 
431         _afterTokenTransfer(account, address(0), amount);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(address owner, address spender, uint256 amount) internal virtual {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450 
451         _allowances[owner][spender] = amount;
452         emit Approval(owner, spender, amount);
453     }
454 
455     /**
456      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
457      *
458      * Does not update the allowance amount in case of infinite allowance.
459      * Revert if not enough allowance is available.
460      *
461      * Might emit an {Approval} event.
462      */
463     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
464         uint256 currentAllowance = allowance(owner, spender);
465         if (currentAllowance != type(uint256).max) {
466             require(currentAllowance >= amount, "ERC20: insufficient allowance");
467             unchecked {
468                 _approve(owner, spender, currentAllowance - amount);
469             }
470         }
471     }
472 
473     /**
474      * @dev Hook that is called before any transfer of tokens. This includes
475      * minting and burning.
476      *
477      * Calling conditions:
478      *
479      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
480      * will be transferred to `to`.
481      * - when `from` is zero, `amount` tokens will be minted for `to`.
482      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
483      * - `from` and `to` are never both zero.
484      *
485      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
486      */
487     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
488 
489     /**
490      * @dev Hook that is called after any transfer of tokens. This includes
491      * minting and burning.
492      *
493      * Calling conditions:
494      *
495      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
496      * has been transferred to `to`.
497      * - when `from` is zero, `amount` tokens have been minted for `to`.
498      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
499      * - `from` and `to` are never both zero.
500      *
501      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
502      */
503     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
504 }
505 
506 
507 
508 
509 
510 
511 
512 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Extension of {ERC20} that allows token holders to destroy both their own
518  * tokens and those that they have an allowance for, in a way that can be
519  * recognized off-chain (via event analysis).
520  */
521 abstract contract ERC20Burnable is Context, ERC20 {
522     /**
523      * @dev Destroys `amount` tokens from the caller.
524      *
525      * See {ERC20-_burn}.
526      */
527     function burn(uint256 amount) public virtual {
528         _burn(_msgSender(), amount);
529     }
530 
531     /**
532      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
533      * allowance.
534      *
535      * See {ERC20-_burn} and {ERC20-allowance}.
536      *
537      * Requirements:
538      *
539      * - the caller must have allowance for ``accounts``'s tokens of at least
540      * `amount`.
541      */
542     function burnFrom(address account, uint256 amount) public virtual {
543         _spendAllowance(account, _msgSender(), amount);
544         _burn(account, amount);
545     }
546 }
547 
548 
549 
550 
551 
552 
553 
554 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @dev Contract module which provides a basic access control mechanism, where
560  * there is an account (an owner) that can be granted exclusive access to
561  * specific functions.
562  *
563  * By default, the owner account will be the one that deploys the contract. This
564  * can later be changed with {transferOwnership}.
565  *
566  * This module is used through inheritance. It will make available the modifier
567  * `onlyOwner`, which can be applied to your functions to restrict their use to
568  * the owner.
569  */
570 abstract contract Ownable is Context {
571     address private _owner;
572 
573     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
574 
575     /**
576      * @dev Initializes the contract setting the deployer as the initial owner.
577      */
578     constructor() {
579         _transferOwnership(_msgSender());
580     }
581 
582     /**
583      * @dev Throws if called by any account other than the owner.
584      */
585     modifier onlyOwner() {
586         _checkOwner();
587         _;
588     }
589 
590     /**
591      * @dev Returns the address of the current owner.
592      */
593     function owner() public view virtual returns (address) {
594         return _owner;
595     }
596 
597     /**
598      * @dev Throws if the sender is not the owner.
599      */
600     function _checkOwner() internal view virtual {
601         require(owner() == _msgSender(), "Ownable: caller is not the owner");
602     }
603 
604     /**
605      * @dev Leaves the contract without owner. It will not be possible to call
606      * `onlyOwner` functions. Can only be called by the current owner.
607      *
608      * NOTE: Renouncing ownership will leave the contract without an owner,
609      * thereby disabling any functionality that is only available to the owner.
610      */
611     function renounceOwnership() public virtual onlyOwner {
612         _transferOwnership(address(0));
613     }
614 
615     /**
616      * @dev Transfers ownership of the contract to a new account (`newOwner`).
617      * Can only be called by the current owner.
618      */
619     function transferOwnership(address newOwner) public virtual onlyOwner {
620         require(newOwner != address(0), "Ownable: new owner is the zero address");
621         _transferOwnership(newOwner);
622     }
623 
624     /**
625      * @dev Transfers ownership of the contract to a new account (`newOwner`).
626      * Internal function without access restriction.
627      */
628     function _transferOwnership(address newOwner) internal virtual {
629         address oldOwner = _owner;
630         _owner = newOwner;
631         emit OwnershipTransferred(oldOwner, newOwner);
632     }
633 }
634 
635 
636 
637 
638 
639 
640 
641 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 /**
646  * @dev Contract module which allows children to implement an emergency stop
647  * mechanism that can be triggered by an authorized account.
648  *
649  * This module is used through inheritance. It will make available the
650  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
651  * the functions of your contract. Note that they will not be pausable by
652  * simply including this module, only once the modifiers are put in place.
653  */
654 abstract contract Pausable is Context {
655     /**
656      * @dev Emitted when the pause is triggered by `account`.
657      */
658     event Paused(address account);
659 
660     /**
661      * @dev Emitted when the pause is lifted by `account`.
662      */
663     event Unpaused(address account);
664 
665     bool private _paused;
666 
667     /**
668      * @dev Initializes the contract in unpaused state.
669      */
670     constructor() {
671         _paused = false;
672     }
673 
674     /**
675      * @dev Modifier to make a function callable only when the contract is not paused.
676      *
677      * Requirements:
678      *
679      * - The contract must not be paused.
680      */
681     modifier whenNotPaused() {
682         _requireNotPaused();
683         _;
684     }
685 
686     /**
687      * @dev Modifier to make a function callable only when the contract is paused.
688      *
689      * Requirements:
690      *
691      * - The contract must be paused.
692      */
693     modifier whenPaused() {
694         _requirePaused();
695         _;
696     }
697 
698     /**
699      * @dev Returns true if the contract is paused, and false otherwise.
700      */
701     function paused() public view virtual returns (bool) {
702         return _paused;
703     }
704 
705     /**
706      * @dev Throws if the contract is paused.
707      */
708     function _requireNotPaused() internal view virtual {
709         require(!paused(), "Pausable: paused");
710     }
711 
712     /**
713      * @dev Throws if the contract is not paused.
714      */
715     function _requirePaused() internal view virtual {
716         require(paused(), "Pausable: not paused");
717     }
718 
719     /**
720      * @dev Triggers stopped state.
721      *
722      * Requirements:
723      *
724      * - The contract must not be paused.
725      */
726     function _pause() internal virtual whenNotPaused {
727         _paused = true;
728         emit Paused(_msgSender());
729     }
730 
731     /**
732      * @dev Returns to normal state.
733      *
734      * Requirements:
735      *
736      * - The contract must be paused.
737      */
738     function _unpause() internal virtual whenPaused {
739         _paused = false;
740         emit Unpaused(_msgSender());
741     }
742 }
743 
744 
745 
746 
747 pragma solidity ^0.8.20;
748 
749 //-------------------------------------------------------------------------------------------------------------------------------------
750 // CONTRACT
751 contract Icarus is ERC20, ERC20Burnable, Pausable, Ownable {
752     uint256 public immutable initialSupply;
753     uint256 public immutable dexSupply;
754     uint256 public immutable cexSupply;
755     uint256 public immutable creatorSupply;
756     
757     address public immutable mainWallet;
758     address public immutable cexWallet;
759     address public immutable creatorWallet;
760     
761     mapping(address => bool) public blacklists;
762     
763     bool public limitTrading;
764     uint256 public maxHoldingAmount;
765     uint256 public minHoldingAmount;
766     address public uniswapPool;
767         
768     uint256 public immutable creationBlock;
769     uint256 public immutable blockLimit;
770     uint256 public immutable minTransactions;
771     uint256 public transactionCounter;
772 
773     //--------------------------------------------------------------
774     // CONSTRUCTOR
775     constructor() ERC20("Icarus", "ICARUS") {
776         initialSupply = 149597870700 * 10 ** decimals();
777         dexSupply = initialSupply / 10 * 8;
778         cexSupply = initialSupply / 10;
779         creatorSupply = initialSupply - dexSupply - cexSupply;
780                 
781         mainWallet = msg.sender;
782         cexWallet = 0x042DAe440FD05cd84d84EB1a2F6e3811a9D57800;
783         creatorWallet = 0x9622e79e6a0D138d60a36aa5cB7c063462277fe5;
784         
785         limitTrading = true;
786         maxHoldingAmount = 1000000;
787         minHoldingAmount = 0;
788         
789         creationBlock = block.number;
790         blockLimit = 2600000;
791         minTransactions = 1000000;
792         transactionCounter = 0;
793            
794         _mint(mainWallet, dexSupply);
795         _mint(cexWallet, cexSupply);
796         _mint(creatorWallet, creatorSupply);
797     }
798     
799     //--------------------------------------------------------------
800     // BLACKLIST
801     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
802         blacklists[_address] = _isBlacklisting;
803     }   
804     
805     //--------------------------------------------------------------
806     // SET TRADING RULES
807     function setRule(bool _limitTrading, address _uniswapPool, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
808         limitTrading = _limitTrading;
809         uniswapPool = _uniswapPool;
810         maxHoldingAmount = _maxHoldingAmount;
811         minHoldingAmount = _minHoldingAmount;
812     }
813     
814     //--------------------------------------------------------------
815     // TRANSACTION CONTROL
816     function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override {
817         require(!blacklists[to] && !blacklists[from], "Address Blacklisted");
818         if (uniswapPool == address(0)) {
819             require(from == mainWallet || to == mainWallet || to == cexWallet || to == creatorWallet, "Token transfer not available");
820             return;
821         }
822         if (limitTrading && from == uniswapPool) {
823             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Trading limited");
824         }
825         super._beforeTokenTransfer(from, to, amount);
826     }
827 
828     //--------------------------------------------------------------
829     // TRANSACTION COUNTER    
830     function _afterTokenTransfer(address from, address to, uint256 amount) internal override {
831         transactionCounter += 1;
832         super._afterTokenTransfer(from, to, amount);
833     }
834        
835     //--------------------------------------------------------------
836     // PAUSE FOREVER
837     function pauseForever() external whenNotPaused {
838         require(block.number >= creationBlock + blockLimit, "The Doomsday Block hasn't been reached.");
839         require(transactionCounter < minTransactions, "Hurray, self-destruction has been avoided!");
840         payable(msg.sender).transfer (address(this).balance);
841         _pause();
842     }
843     
844     //--------------------------------------------------------------
845     // UNPAUSE
846     function unpauseContract() external whenPaused onlyOwner {
847         _unpause();
848     }
849    
850 }