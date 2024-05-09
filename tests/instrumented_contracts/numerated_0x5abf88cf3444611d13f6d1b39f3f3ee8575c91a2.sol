1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
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
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/security/Pausable.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 
121 /**
122  * @dev Contract module which allows children to implement an emergency stop
123  * mechanism that can be triggered by an authorized account.
124  *
125  * This module is used through inheritance. It will make available the
126  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
127  * the functions of your contract. Note that they will not be pausable by
128  * simply including this module, only once the modifiers are put in place.
129  */
130 abstract contract Pausable is Context {
131     /**
132      * @dev Emitted when the pause is triggered by `account`.
133      */
134     event Paused(address account);
135 
136     /**
137      * @dev Emitted when the pause is lifted by `account`.
138      */
139     event Unpaused(address account);
140 
141     bool private _paused;
142 
143     /**
144      * @dev Initializes the contract in unpaused state.
145      */
146     constructor() {
147         _paused = false;
148     }
149 
150     /**
151      * @dev Modifier to make a function callable only when the contract is not paused.
152      *
153      * Requirements:
154      *
155      * - The contract must not be paused.
156      */
157     modifier whenNotPaused() {
158         _requireNotPaused();
159         _;
160     }
161 
162     /**
163      * @dev Modifier to make a function callable only when the contract is paused.
164      *
165      * Requirements:
166      *
167      * - The contract must be paused.
168      */
169     modifier whenPaused() {
170         _requirePaused();
171         _;
172     }
173 
174     /**
175      * @dev Returns true if the contract is paused, and false otherwise.
176      */
177     function paused() public view virtual returns (bool) {
178         return _paused;
179     }
180 
181     /**
182      * @dev Throws if the contract is paused.
183      */
184     function _requireNotPaused() internal view virtual {
185         require(!paused(), "Pausable: paused");
186     }
187 
188     /**
189      * @dev Throws if the contract is not paused.
190      */
191     function _requirePaused() internal view virtual {
192         require(paused(), "Pausable: not paused");
193     }
194 
195     /**
196      * @dev Triggers stopped state.
197      *
198      * Requirements:
199      *
200      * - The contract must not be paused.
201      */
202     function _pause() internal virtual whenNotPaused {
203         _paused = true;
204         emit Paused(_msgSender());
205     }
206 
207     /**
208      * @dev Returns to normal state.
209      *
210      * Requirements:
211      *
212      * - The contract must be paused.
213      */
214     function _unpause() internal virtual whenPaused {
215         _paused = false;
216         emit Unpaused(_msgSender());
217     }
218 }
219 
220 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
221 
222 
223 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev Interface of the ERC20 standard as defined in the EIP.
229  */
230 interface IERC20 {
231     /**
232      * @dev Emitted when `value` tokens are moved from one account (`from`) to
233      * another (`to`).
234      *
235      * Note that `value` may be zero.
236      */
237     event Transfer(address indexed from, address indexed to, uint256 value);
238 
239     /**
240      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
241      * a call to {approve}. `value` is the new allowance.
242      */
243     event Approval(address indexed owner, address indexed spender, uint256 value);
244 
245     /**
246      * @dev Returns the amount of tokens in existence.
247      */
248     function totalSupply() external view returns (uint256);
249 
250     /**
251      * @dev Returns the amount of tokens owned by `account`.
252      */
253     function balanceOf(address account) external view returns (uint256);
254 
255     /**
256      * @dev Moves `amount` tokens from the caller's account to `to`.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * Emits a {Transfer} event.
261      */
262     function transfer(address to, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Returns the remaining number of tokens that `spender` will be
266      * allowed to spend on behalf of `owner` through {transferFrom}. This is
267      * zero by default.
268      *
269      * This value changes when {approve} or {transferFrom} are called.
270      */
271     function allowance(address owner, address spender) external view returns (uint256);
272 
273     /**
274      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * IMPORTANT: Beware that changing an allowance with this method brings the risk
279      * that someone may use both the old and the new allowance by unfortunate
280      * transaction ordering. One possible solution to mitigate this race
281      * condition is to first reduce the spender's allowance to 0 and set the
282      * desired value afterwards:
283      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284      *
285      * Emits an {Approval} event.
286      */
287     function approve(address spender, uint256 amount) external returns (bool);
288 
289     /**
290      * @dev Moves `amount` tokens from `from` to `to` using the
291      * allowance mechanism. `amount` is then deducted from the caller's
292      * allowance.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * Emits a {Transfer} event.
297      */
298     function transferFrom(
299         address from,
300         address to,
301         uint256 amount
302     ) external returns (bool);
303 }
304 
305 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 
313 /**
314  * @dev Interface for the optional metadata functions from the ERC20 standard.
315  *
316  * _Available since v4.1._
317  */
318 interface IERC20Metadata is IERC20 {
319     /**
320      * @dev Returns the name of the token.
321      */
322     function name() external view returns (string memory);
323 
324     /**
325      * @dev Returns the symbol of the token.
326      */
327     function symbol() external view returns (string memory);
328 
329     /**
330      * @dev Returns the decimals places of the token.
331      */
332     function decimals() external view returns (uint8);
333 }
334 
335 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
336 
337 
338 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 
343 
344 
345 /**
346  * @dev Implementation of the {IERC20} interface.
347  *
348  * This implementation is agnostic to the way tokens are created. This means
349  * that a supply mechanism has to be added in a derived contract using {_mint}.
350  * For a generic mechanism see {ERC20PresetMinterPauser}.
351  *
352  * TIP: For a detailed writeup see our guide
353  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
354  * to implement supply mechanisms].
355  *
356  * We have followed general OpenZeppelin Contracts guidelines: functions revert
357  * instead returning `false` on failure. This behavior is nonetheless
358  * conventional and does not conflict with the expectations of ERC20
359  * applications.
360  *
361  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
362  * This allows applications to reconstruct the allowance for all accounts just
363  * by listening to said events. Other implementations of the EIP may not emit
364  * these events, as it isn't required by the specification.
365  *
366  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
367  * functions have been added to mitigate the well-known issues around setting
368  * allowances. See {IERC20-approve}.
369  */
370 contract ERC20 is Context, IERC20, IERC20Metadata {
371     mapping(address => uint256) private _balances;
372 
373     mapping(address => mapping(address => uint256)) private _allowances;
374 
375     uint256 private _totalSupply;
376 
377     string private _name;
378     string private _symbol;
379 
380     /**
381      * @dev Sets the values for {name} and {symbol}.
382      *
383      * The default value of {decimals} is 18. To select a different value for
384      * {decimals} you should overload it.
385      *
386      * All two of these values are immutable: they can only be set once during
387      * construction.
388      */
389     constructor(string memory name_, string memory symbol_) {
390         _name = name_;
391         _symbol = symbol_;
392     }
393 
394     /**
395      * @dev Returns the name of the token.
396      */
397     function name() public view virtual override returns (string memory) {
398         return _name;
399     }
400 
401     /**
402      * @dev Returns the symbol of the token, usually a shorter version of the
403      * name.
404      */
405     function symbol() public view virtual override returns (string memory) {
406         return _symbol;
407     }
408 
409     /**
410      * @dev Returns the number of decimals used to get its user representation.
411      * For example, if `decimals` equals `2`, a balance of `505` tokens should
412      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
413      *
414      * Tokens usually opt for a value of 18, imitating the relationship between
415      * Ether and Wei. This is the value {ERC20} uses, unless this function is
416      * overridden;
417      *
418      * NOTE: This information is only used for _display_ purposes: it in
419      * no way affects any of the arithmetic of the contract, including
420      * {IERC20-balanceOf} and {IERC20-transfer}.
421      */
422     function decimals() public view virtual override returns (uint8) {
423         return 18;
424     }
425 
426     /**
427      * @dev See {IERC20-totalSupply}.
428      */
429     function totalSupply() public view virtual override returns (uint256) {
430         return _totalSupply;
431     }
432 
433     /**
434      * @dev See {IERC20-balanceOf}.
435      */
436     function balanceOf(address account) public view virtual override returns (uint256) {
437         return _balances[account];
438     }
439 
440     /**
441      * @dev See {IERC20-transfer}.
442      *
443      * Requirements:
444      *
445      * - `to` cannot be the zero address.
446      * - the caller must have a balance of at least `amount`.
447      */
448     function transfer(address to, uint256 amount) public virtual override returns (bool) {
449         address owner = _msgSender();
450         _transfer(owner, to, amount);
451         return true;
452     }
453 
454     /**
455      * @dev See {IERC20-allowance}.
456      */
457     function allowance(address owner, address spender) public view virtual override returns (uint256) {
458         return _allowances[owner][spender];
459     }
460 
461     /**
462      * @dev See {IERC20-approve}.
463      *
464      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
465      * `transferFrom`. This is semantically equivalent to an infinite approval.
466      *
467      * Requirements:
468      *
469      * - `spender` cannot be the zero address.
470      */
471     function approve(address spender, uint256 amount) public virtual override returns (bool) {
472         address owner = _msgSender();
473         _approve(owner, spender, amount);
474         return true;
475     }
476 
477     /**
478      * @dev See {IERC20-transferFrom}.
479      *
480      * Emits an {Approval} event indicating the updated allowance. This is not
481      * required by the EIP. See the note at the beginning of {ERC20}.
482      *
483      * NOTE: Does not update the allowance if the current allowance
484      * is the maximum `uint256`.
485      *
486      * Requirements:
487      *
488      * - `from` and `to` cannot be the zero address.
489      * - `from` must have a balance of at least `amount`.
490      * - the caller must have allowance for ``from``'s tokens of at least
491      * `amount`.
492      */
493     function transferFrom(
494         address from,
495         address to,
496         uint256 amount
497     ) public virtual override returns (bool) {
498         address spender = _msgSender();
499         _spendAllowance(from, spender, amount);
500         _transfer(from, to, amount);
501         return true;
502     }
503 
504     /**
505      * @dev Atomically increases the allowance granted to `spender` by the caller.
506      *
507      * This is an alternative to {approve} that can be used as a mitigation for
508      * problems described in {IERC20-approve}.
509      *
510      * Emits an {Approval} event indicating the updated allowance.
511      *
512      * Requirements:
513      *
514      * - `spender` cannot be the zero address.
515      */
516     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
517         address owner = _msgSender();
518         _approve(owner, spender, allowance(owner, spender) + addedValue);
519         return true;
520     }
521 
522     /**
523      * @dev Atomically decreases the allowance granted to `spender` by the caller.
524      *
525      * This is an alternative to {approve} that can be used as a mitigation for
526      * problems described in {IERC20-approve}.
527      *
528      * Emits an {Approval} event indicating the updated allowance.
529      *
530      * Requirements:
531      *
532      * - `spender` cannot be the zero address.
533      * - `spender` must have allowance for the caller of at least
534      * `subtractedValue`.
535      */
536     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
537         address owner = _msgSender();
538         uint256 currentAllowance = allowance(owner, spender);
539         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
540         unchecked {
541             _approve(owner, spender, currentAllowance - subtractedValue);
542         }
543 
544         return true;
545     }
546 
547     /**
548      * @dev Moves `amount` of tokens from `from` to `to`.
549      *
550      * This internal function is equivalent to {transfer}, and can be used to
551      * e.g. implement automatic token fees, slashing mechanisms, etc.
552      *
553      * Emits a {Transfer} event.
554      *
555      * Requirements:
556      *
557      * - `from` cannot be the zero address.
558      * - `to` cannot be the zero address.
559      * - `from` must have a balance of at least `amount`.
560      */
561     function _transfer(
562         address from,
563         address to,
564         uint256 amount
565     ) internal virtual {
566         require(from != address(0), "ERC20: transfer from the zero address");
567         require(to != address(0), "ERC20: transfer to the zero address");
568 
569         _beforeTokenTransfer(from, to, amount);
570 
571         uint256 fromBalance = _balances[from];
572         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
573         unchecked {
574             _balances[from] = fromBalance - amount;
575         }
576         _balances[to] += amount;
577 
578         emit Transfer(from, to, amount);
579 
580         _afterTokenTransfer(from, to, amount);
581     }
582 
583     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
584      * the total supply.
585      *
586      * Emits a {Transfer} event with `from` set to the zero address.
587      *
588      * Requirements:
589      *
590      * - `account` cannot be the zero address.
591      */
592     function _mint(address account, uint256 amount) internal virtual {
593         require(account != address(0), "ERC20: mint to the zero address");
594 
595         _beforeTokenTransfer(address(0), account, amount);
596 
597         _totalSupply += amount;
598         _balances[account] += amount;
599         emit Transfer(address(0), account, amount);
600 
601         _afterTokenTransfer(address(0), account, amount);
602     }
603 
604     /**
605      * @dev Destroys `amount` tokens from `account`, reducing the
606      * total supply.
607      *
608      * Emits a {Transfer} event with `to` set to the zero address.
609      *
610      * Requirements:
611      *
612      * - `account` cannot be the zero address.
613      * - `account` must have at least `amount` tokens.
614      */
615     function _burn(address account, uint256 amount) internal virtual {
616         require(account != address(0), "ERC20: burn from the zero address");
617 
618         _beforeTokenTransfer(account, address(0), amount);
619 
620         uint256 accountBalance = _balances[account];
621         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
622         unchecked {
623             _balances[account] = accountBalance - amount;
624         }
625         _totalSupply -= amount;
626 
627         emit Transfer(account, address(0), amount);
628 
629         _afterTokenTransfer(account, address(0), amount);
630     }
631 
632     /**
633      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
634      *
635      * This internal function is equivalent to `approve`, and can be used to
636      * e.g. set automatic allowances for certain subsystems, etc.
637      *
638      * Emits an {Approval} event.
639      *
640      * Requirements:
641      *
642      * - `owner` cannot be the zero address.
643      * - `spender` cannot be the zero address.
644      */
645     function _approve(
646         address owner,
647         address spender,
648         uint256 amount
649     ) internal virtual {
650         require(owner != address(0), "ERC20: approve from the zero address");
651         require(spender != address(0), "ERC20: approve to the zero address");
652 
653         _allowances[owner][spender] = amount;
654         emit Approval(owner, spender, amount);
655     }
656 
657     /**
658      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
659      *
660      * Does not update the allowance amount in case of infinite allowance.
661      * Revert if not enough allowance is available.
662      *
663      * Might emit an {Approval} event.
664      */
665     function _spendAllowance(
666         address owner,
667         address spender,
668         uint256 amount
669     ) internal virtual {
670         uint256 currentAllowance = allowance(owner, spender);
671         if (currentAllowance != type(uint256).max) {
672             require(currentAllowance >= amount, "ERC20: insufficient allowance");
673             unchecked {
674                 _approve(owner, spender, currentAllowance - amount);
675             }
676         }
677     }
678 
679     /**
680      * @dev Hook that is called before any transfer of tokens. This includes
681      * minting and burning.
682      *
683      * Calling conditions:
684      *
685      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
686      * will be transferred to `to`.
687      * - when `from` is zero, `amount` tokens will be minted for `to`.
688      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
689      * - `from` and `to` are never both zero.
690      *
691      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
692      */
693     function _beforeTokenTransfer(
694         address from,
695         address to,
696         uint256 amount
697     ) internal virtual {}
698 
699     /**
700      * @dev Hook that is called after any transfer of tokens. This includes
701      * minting and burning.
702      *
703      * Calling conditions:
704      *
705      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
706      * has been transferred to `to`.
707      * - when `from` is zero, `amount` tokens have been minted for `to`.
708      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
709      * - `from` and `to` are never both zero.
710      *
711      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
712      */
713     function _afterTokenTransfer(
714         address from,
715         address to,
716         uint256 amount
717     ) internal virtual {}
718 }
719 
720 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
721 
722 
723 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 
728 
729 /**
730  * @dev Extension of {ERC20} that allows token holders to destroy both their own
731  * tokens and those that they have an allowance for, in a way that can be
732  * recognized off-chain (via event analysis).
733  */
734 abstract contract ERC20Burnable is Context, ERC20 {
735     /**
736      * @dev Destroys `amount` tokens from the caller.
737      *
738      * See {ERC20-_burn}.
739      */
740     function burn(uint256 amount) public virtual {
741         _burn(_msgSender(), amount);
742     }
743 
744     /**
745      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
746      * allowance.
747      *
748      * See {ERC20-_burn} and {ERC20-allowance}.
749      *
750      * Requirements:
751      *
752      * - the caller must have allowance for ``accounts``'s tokens of at least
753      * `amount`.
754      */
755     function burnFrom(address account, uint256 amount) public virtual {
756         _spendAllowance(account, _msgSender(), amount);
757         _burn(account, amount);
758     }
759 }
760 
761 // File: contracts/MyToken.sol
762 
763 
764 pragma solidity ^0.8.4;
765 
766 
767 
768 
769 
770 contract SAT is ERC20, ERC20Burnable, Pausable, Ownable {
771     constructor() ERC20("Super Athletes Token", "SAT") {
772         _mint(msg.sender, 5000000000*10**uint(decimals()));
773     }
774 
775     function pause() public onlyOwner {
776         _pause();
777     }
778 
779     function unpause() public onlyOwner {
780         _unpause();
781     }
782 
783     function mint(address to, uint256 amount) public onlyOwner {
784         _mint(to, amount);
785     }
786 
787     function _beforeTokenTransfer(address from, address to, uint256 amount)
788         internal
789         whenNotPaused
790         override
791     {
792         super._beforeTokenTransfer(from, to, amount);
793     }
794 }