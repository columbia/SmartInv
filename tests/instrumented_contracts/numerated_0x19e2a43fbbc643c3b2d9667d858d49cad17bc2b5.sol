1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.2
85 
86 
87 
88 pragma solidity ^0.8.4;
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
113 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
114 
115 
116 
117 pragma solidity ^0.8.4;
118 
119 /**
120  * @dev Provides information about the current execution context, including the
121  * sender of the transaction and its data. While these are generally available
122  * via msg.sender and msg.data, they should not be accessed in such a direct
123  * manner, since when dealing with meta-transactions the account sending and
124  * paying for execution may not be the actual sender (as far as an application
125  * is concerned).
126  *
127  * This contract is only required for intermediate, library-like contracts.
128  */
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view virtual returns (bytes calldata) {
135         return msg.data;
136     }
137 }
138 
139 
140 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.2
141 
142 
143 
144 pragma solidity ^0.8.4;
145 
146 
147 
148 /**
149  * @dev Implementation of the {IERC20} interface.
150  *
151  * This implementation is agnostic to the way tokens are created. This means
152  * that a supply mechanism has to be added in a derived contract using {_mint}.
153  * For a generic mechanism see {ERC20PresetMinterPauser}.
154  *
155  * TIP: For a detailed writeup see our guide
156  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
157  * to implement supply mechanisms].
158  *
159  * We have followed general OpenZeppelin Contracts guidelines: functions revert
160  * instead returning `false` on failure. This behavior is nonetheless
161  * conventional and does not conflict with the expectations of ERC20
162  * applications.
163  *
164  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
165  * This allows applications to reconstruct the allowance for all accounts just
166  * by listening to said events. Other implementations of the EIP may not emit
167  * these events, as it isn't required by the specification.
168  *
169  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
170  * functions have been added to mitigate the well-known issues around setting
171  * allowances. See {IERC20-approve}.
172  */
173 contract ERC20 is Context, IERC20, IERC20Metadata {
174     mapping(address => uint256) private _balances;
175 
176     mapping(address => mapping(address => uint256)) private _allowances;
177 
178     uint256 private _totalSupply;
179 
180     string private _name;
181     string private _symbol;
182 
183     /**
184      * @dev Sets the values for {name} and {symbol}.
185      *
186      * The default value of {decimals} is 18. To select a different value for
187      * {decimals} you should overload it.
188      *
189      * All two of these values are immutable: they can only be set once during
190      * construction.
191      */
192     constructor(string memory name_, string memory symbol_) {
193         _name = name_;
194         _symbol = symbol_;
195     }
196 
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() public view virtual override returns (string memory) {
201         return _name;
202     }
203 
204     /**
205      * @dev Returns the symbol of the token, usually a shorter version of the
206      * name.
207      */
208     function symbol() public view virtual override returns (string memory) {
209         return _symbol;
210     }
211 
212     /**
213      * @dev Returns the number of decimals used to get its user representation.
214      * For example, if `decimals` equals `2`, a balance of `505` tokens should
215      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
216      *
217      * Tokens usually opt for a value of 18, imitating the relationship between
218      * Ether and Wei. This is the value {ERC20} uses, unless this function is
219      * overridden;
220      *
221      * NOTE: This information is only used for _display_ purposes: it in
222      * no way affects any of the arithmetic of the contract, including
223      * {IERC20-balanceOf} and {IERC20-transfer}.
224      */
225     function decimals() public view virtual override returns (uint8) {
226         return 8;
227     }
228 
229     /**
230      * @dev See {IERC20-totalSupply}.
231      */
232     function totalSupply() public view virtual override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev See {IERC20-balanceOf}.
238      */
239     function balanceOf(address account) public view virtual override returns (uint256) {
240         return _balances[account];
241     }
242 
243     /**
244      * @dev See {IERC20-transfer}.
245      *
246      * Requirements:
247      *
248      * - `recipient` cannot be the zero address.
249      * - the caller must have a balance of at least `amount`.
250      */
251     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See {IERC20-allowance}.
258      */
259     function allowance(address owner, address spender) public view virtual override returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     /**
264      * @dev See {IERC20-approve}.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function approve(address spender, uint256 amount) public virtual override returns (bool) {
271         _approve(_msgSender(), spender, amount);
272         return true;
273     }
274 
275     /**
276      * @dev See {IERC20-transferFrom}.
277      *
278      * Emits an {Approval} event indicating the updated allowance. This is not
279      * required by the EIP. See the note at the beginning of {ERC20}.
280      *
281      * Requirements:
282      *
283      * - `sender` and `recipient` cannot be the zero address.
284      * - `sender` must have a balance of at least `amount`.
285      * - the caller must have allowance for ``sender``'s tokens of at least
286      * `amount`.
287      */
288     function transferFrom(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) public virtual override returns (bool) {
293         _transfer(sender, recipient, amount);
294 
295         uint256 currentAllowance = _allowances[sender][_msgSender()];
296         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
297         unchecked {
298             _approve(sender, _msgSender(), currentAllowance - amount);
299         }
300 
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
317         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
318         return true;
319     }
320 
321     /**
322      * @dev Atomically decreases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      * - `spender` must have allowance for the caller of at least
333      * `subtractedValue`.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         uint256 currentAllowance = _allowances[_msgSender()][spender];
337         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
338         unchecked {
339             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
340         }
341 
342         return true;
343     }
344 
345     /**
346      * @dev Moves `amount` of tokens from `sender` to `recipient`.
347      *
348      * This internal function is equivalent to {transfer}, and can be used to
349      * e.g. implement automatic token fees, slashing mechanisms, etc.
350      *
351      * Emits a {Transfer} event.
352      *
353      * Requirements:
354      *
355      * - `sender` cannot be the zero address.
356      * - `recipient` cannot be the zero address.
357      * - `sender` must have a balance of at least `amount`.
358      */
359     function _transfer(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) internal virtual {
364         require(sender != address(0), "ERC20: transfer from the zero address");
365         require(recipient != address(0), "ERC20: transfer to the zero address");
366 
367         _beforeTokenTransfer(sender, recipient, amount);
368 
369         uint256 senderBalance = _balances[sender];
370         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
371         unchecked {
372             _balances[sender] = senderBalance - amount;
373         }
374         _balances[recipient] += amount;
375 
376         emit Transfer(sender, recipient, amount);
377 
378         _afterTokenTransfer(sender, recipient, amount);
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
396         _balances[account] += amount;
397         emit Transfer(address(0), account, amount);
398 
399         _afterTokenTransfer(address(0), account, amount);
400     }
401 
402     /**
403      * @dev Destroys `amount` tokens from `account`, reducing the
404      * total supply.
405      *
406      * Emits a {Transfer} event with `to` set to the zero address.
407      *
408      * Requirements:
409      *
410      * - `account` cannot be the zero address.
411      * - `account` must have at least `amount` tokens.
412      */
413     function _burn(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: burn from the zero address");
415 
416         _beforeTokenTransfer(account, address(0), amount);
417 
418         uint256 accountBalance = _balances[account];
419         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
420         unchecked {
421             _balances[account] = accountBalance - amount;
422         }
423         _totalSupply -= amount;
424 
425         emit Transfer(account, address(0), amount);
426 
427         _afterTokenTransfer(account, address(0), amount);
428     }
429 
430     /**
431      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
432      *
433      * This internal function is equivalent to `approve`, and can be used to
434      * e.g. set automatic allowances for certain subsystems, etc.
435      *
436      * Emits an {Approval} event.
437      *
438      * Requirements:
439      *
440      * - `owner` cannot be the zero address.
441      * - `spender` cannot be the zero address.
442      */
443     function _approve(
444         address owner,
445         address spender,
446         uint256 amount
447     ) internal virtual {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450 
451         _allowances[owner][spender] = amount;
452         emit Approval(owner, spender, amount);
453     }
454 
455     /**
456      * @dev Hook that is called before any transfer of tokens. This includes
457      * minting and burning.
458      *
459      * Calling conditions:
460      *
461      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
462      * will be transferred to `to`.
463      * - when `from` is zero, `amount` tokens will be minted for `to`.
464      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
465      * - `from` and `to` are never both zero.
466      *
467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
468      */
469     function _beforeTokenTransfer(
470         address from,
471         address to,
472         uint256 amount
473     ) internal virtual {}
474 
475     /**
476      * @dev Hook that is called after any transfer of tokens. This includes
477      * minting and burning.
478      *
479      * Calling conditions:
480      *
481      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
482      * has been transferred to `to`.
483      * - when `from` is zero, `amount` tokens have been minted for `to`.
484      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
485      * - `from` and `to` are never both zero.
486      *
487      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
488      */
489     function _afterTokenTransfer(
490         address from,
491         address to,
492         uint256 amount
493     ) internal virtual {}
494 }
495 
496 
497 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.3.2
498 
499 
500 
501 pragma solidity ^0.8.4;
502 
503 
504 /**
505  * @dev Extension of {ERC20} that allows token holders to destroy both their own
506  * tokens and those that they have an allowance for, in a way that can be
507  * recognized off-chain (via event analysis).
508  */
509 abstract contract ERC20Burnable is Context, ERC20 {
510     /**
511      * @dev Destroys `amount` tokens from the caller.
512      *
513      * See {ERC20-_burn}.
514      */
515     function burn(uint256 amount) public virtual {
516         _burn(_msgSender(), amount);
517     }
518 
519     /**
520      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
521      * allowance.
522      *
523      * See {ERC20-_burn} and {ERC20-allowance}.
524      *
525      * Requirements:
526      *
527      * - the caller must have allowance for ``accounts``'s tokens of at least
528      * `amount`.
529      */
530     function burnFrom(address account, uint256 amount) public virtual {
531         uint256 currentAllowance = allowance(account, _msgSender());
532         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
533         unchecked {
534             _approve(account, _msgSender(), currentAllowance - amount);
535         }
536         _burn(account, amount);
537     }
538 }
539 
540 
541 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol@v4.3.2
542 
543 
544 
545 pragma solidity ^0.8.4;
546 
547 /**
548  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
549  */
550 abstract contract ERC20Capped is ERC20 {
551     uint256 private immutable _cap;
552 
553     /**
554      * @dev Sets the value of the `cap`. This value is immutable, it can only be
555      * set once during construction.
556      */
557     constructor(uint256 cap_) {
558         require(cap_ > 0, "ERC20Capped: cap is 0");
559         _cap = cap_;
560     }
561 
562     /**
563      * @dev Returns the cap on the token's total supply.
564      */
565     function cap() public view virtual returns (uint256) {
566         return _cap;
567     }
568 
569     /**
570      * @dev See {ERC20-_mint}.
571      */
572     function _mint(address account, uint256 amount) internal virtual override {
573         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
574         super._mint(account, amount);
575     }
576 }
577 
578 
579 // File @openzeppelin/contracts/security/Pausable.sol@v4.3.2
580 
581 
582 
583 pragma solidity ^0.8.4;
584 
585 /**
586  * @dev Contract module which allows children to implement an emergency stop
587  * mechanism that can be triggered by an authorized account.
588  *
589  * This module is used through inheritance. It will make available the
590  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
591  * the functions of your contract. Note that they will not be pausable by
592  * simply including this module, only once the modifiers are put in place.
593  */
594 abstract contract Pausable is Context {
595     /**
596      * @dev Emitted when the pause is triggered by `account`.
597      */
598     event Paused(address account);
599 
600     /**
601      * @dev Emitted when the pause is lifted by `account`.
602      */
603     event Unpaused(address account);
604 
605     bool private _paused;
606 
607     /**
608      * @dev Initializes the contract in unpaused state.
609      */
610     constructor() {
611         _paused = false;
612     }
613 
614     /**
615      * @dev Returns true if the contract is paused, and false otherwise.
616      */
617     function paused() public view virtual returns (bool) {
618         return _paused;
619     }
620 
621     /**
622      * @dev Modifier to make a function callable only when the contract is not paused.
623      *
624      * Requirements:
625      *
626      * - The contract must not be paused.
627      */
628     modifier whenNotPaused() {
629         require(!paused(), "Pausable: paused");
630         _;
631     }
632 
633     /**
634      * @dev Modifier to make a function callable only when the contract is paused.
635      *
636      * Requirements:
637      *
638      * - The contract must be paused.
639      */
640     modifier whenPaused() {
641         require(paused(), "Pausable: not paused");
642         _;
643     }
644 
645     /**
646      * @dev Triggers stopped state.
647      *
648      * Requirements:
649      *
650      * - The contract must not be paused.
651      */
652     function _pause() internal virtual whenNotPaused {
653         _paused = true;
654         emit Paused(_msgSender());
655     }
656 
657     /**
658      * @dev Returns to normal state.
659      *
660      * Requirements:
661      *
662      * - The contract must be paused.
663      */
664     function _unpause() internal virtual whenPaused {
665         _paused = false;
666         emit Unpaused(_msgSender());
667     }
668 }
669 
670 
671 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
672 
673 
674 
675 pragma solidity ^0.8.4;
676 
677 /**
678  * @dev Contract module which provides a basic access control mechanism, where
679  * there is an account (an owner) that can be granted exclusive access to
680  * specific functions.
681  *
682  * By default, the owner account will be the one that deploys the contract. This
683  * can later be changed with {transferOwnership}.
684  *
685  * This module is used through inheritance. It will make available the modifier
686  * `onlyOwner`, which can be applied to your functions to restrict their use to
687  * the owner.
688  */
689 abstract contract Ownable is Context {
690     address private _owner;
691 
692     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
693 
694     /**
695      * @dev Initializes the contract setting the deployer as the initial owner.
696      */
697     constructor() {
698         _setOwner(_msgSender());
699     }
700 
701     /**
702      * @dev Returns the address of the current owner.
703      */
704     function owner() public view virtual returns (address) {
705         return _owner;
706     }
707 
708     /**
709      * @dev Throws if called by any account other than the owner.
710      */
711     modifier onlyOwner() {
712         require(owner() == _msgSender(), "Ownable: caller is not the owner");
713         _;
714     }
715 
716     /**
717      * @dev Leaves the contract without owner. It will not be possible to call
718      * `onlyOwner` functions anymore. Can only be called by the current owner.
719      *
720      * NOTE: Renouncing ownership will leave the contract without an owner,
721      * thereby removing any functionality that is only available to the owner.
722      */
723     function renounceOwnership() public virtual onlyOwner {
724         _setOwner(address(0));
725     }
726 
727     /**
728      * @dev Transfers ownership of the contract to a new account (`newOwner`).
729      * Can only be called by the current owner.
730      */
731     function transferOwnership(address newOwner) public virtual onlyOwner {
732         require(newOwner != address(0), "Ownable: new owner is the zero address");
733         _setOwner(newOwner);
734     }
735 
736     function _setOwner(address newOwner) private {
737         address oldOwner = _owner;
738         _owner = newOwner;
739         emit OwnershipTransferred(oldOwner, newOwner);
740     }
741 }
742 
743 
744 // File contracts/BNSERC.sol
745 
746 
747 pragma solidity ^0.8.4;
748 
749 
750 
751 
752 
753 contract BNSERC is ERC20, ERC20Capped, ERC20Burnable, Pausable, Ownable {
754     constructor()
755     ERC20("Bitbns Token", "BNS")
756     ERC20Capped(250000000000*10**decimals()) {
757 
758     }
759 
760     function decimals() public view virtual override returns (uint8) {
761         return 8;
762     }
763 
764     function pause() public onlyOwner {
765         _pause();
766     }
767 
768     function unpause() public onlyOwner {
769         _unpause();
770     }
771 
772     function mint(address to, uint256 amount) public onlyOwner {
773         _mint(to, amount);
774     }
775 
776     function _beforeTokenTransfer(address from, address to, uint256 amount)
777         internal
778         whenNotPaused
779         override
780     {
781         super._beforeTokenTransfer(from, to, amount);
782     }
783 
784     // The following functions are overrides required by Solidity.
785 
786     function _afterTokenTransfer(address from, address to, uint256 amount)
787         internal
788         override(ERC20)
789     {
790         super._afterTokenTransfer(from, to, amount);
791     }
792 
793     function _mint(address to, uint256 amount)
794         internal
795         override(ERC20, ERC20Capped)
796     {
797         super._mint(to, amount);
798     }
799 
800     function _burn(address account, uint256 amount)
801         internal
802         override(ERC20)
803     {
804         super._burn(account, amount);
805     }
806 }