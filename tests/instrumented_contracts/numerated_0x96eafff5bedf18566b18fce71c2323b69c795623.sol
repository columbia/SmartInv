1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _transferOwnership(_msgSender());
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         _checkOwner();
56         _;
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if the sender is not the owner.
68      */
69     function _checkOwner() internal view virtual {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(
90             newOwner != address(0),
91             "Ownable: new owner is the zero address"
92         );
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
107 /**
108  * @dev Contract module which allows children to implement an emergency stop
109  * mechanism that can be triggered by an authorized account.
110  *
111  * This module is used through inheritance. It will make available the
112  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
113  * the functions of your contract. Note that they will not be pausable by
114  * simply including this module, only once the modifiers are put in place.
115  */
116 abstract contract Pausable is Context {
117     /**
118      * @dev Emitted when the pause is triggered by `account`.
119      */
120     event Paused(address account);
121 
122     /**
123      * @dev Emitted when the pause is lifted by `account`.
124      */
125     event Unpaused(address account);
126 
127     bool private _paused;
128 
129     /**
130      * @dev Initializes the contract in unpaused state.
131      */
132     constructor() {
133         _paused = false;
134     }
135 
136     /**
137      * @dev Modifier to make a function callable only when the contract is not paused.
138      *
139      * Requirements:
140      *
141      * - The contract must not be paused.
142      */
143     modifier whenNotPaused() {
144         _requireNotPaused();
145         _;
146     }
147 
148     /**
149      * @dev Modifier to make a function callable only when the contract is paused.
150      *
151      * Requirements:
152      *
153      * - The contract must be paused.
154      */
155     modifier whenPaused() {
156         _requirePaused();
157         _;
158     }
159 
160     /**
161      * @dev Returns true if the contract is paused, and false otherwise.
162      */
163     function paused() public view virtual returns (bool) {
164         return _paused;
165     }
166 
167     /**
168      * @dev Throws if the contract is paused.
169      */
170     function _requireNotPaused() internal view virtual {
171         require(!paused(), "Pausable: paused");
172     }
173 
174     /**
175      * @dev Throws if the contract is not paused.
176      */
177     function _requirePaused() internal view virtual {
178         require(paused(), "Pausable: not paused");
179     }
180 
181     /**
182      * @dev Triggers stopped state.
183      *
184      * Requirements:
185      *
186      * - The contract must not be paused.
187      */
188     function _pause() internal virtual whenNotPaused {
189         _paused = true;
190         emit Paused(_msgSender());
191     }
192 
193     /**
194      * @dev Returns to normal state.
195      *
196      * Requirements:
197      *
198      * - The contract must be paused.
199      */
200     function _unpause() internal virtual whenPaused {
201         _paused = false;
202         emit Unpaused(_msgSender());
203     }
204 }
205 
206 /**
207  * @dev Interface of the ERC20 standard as defined in the EIP.
208  */
209 interface IERC20 {
210     /**
211      * @dev Emitted when `value` tokens are moved from one account (`from`) to
212      * another (`to`).
213      *
214      * Note that `value` may be zero.
215      */
216     event Transfer(address indexed from, address indexed to, uint256 value);
217 
218     /**
219      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
220      * a call to {approve}. `value` is the new allowance.
221      */
222     event Approval(
223         address indexed owner,
224         address indexed spender,
225         uint256 value
226     );
227 
228     /**
229      * @dev Returns the amount of tokens in existence.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns the amount of tokens owned by `account`.
235      */
236     function balanceOf(address account) external view returns (uint256);
237 
238     /**
239      * @dev Moves `amount` tokens from the caller's account to `to`.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transfer(address to, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Returns the remaining number of tokens that `spender` will be
249      * allowed to spend on behalf of `owner` through {transferFrom}. This is
250      * zero by default.
251      *
252      * This value changes when {approve} or {transferFrom} are called.
253      */
254     function allowance(
255         address owner,
256         address spender
257     ) external view returns (uint256);
258 
259     /**
260      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * IMPORTANT: Beware that changing an allowance with this method brings the risk
265      * that someone may use both the old and the new allowance by unfortunate
266      * transaction ordering. One possible solution to mitigate this race
267      * condition is to first reduce the spender's allowance to 0 and set the
268      * desired value afterwards:
269      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270      *
271      * Emits an {Approval} event.
272      */
273     function approve(address spender, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Moves `amount` tokens from `from` to `to` using the
277      * allowance mechanism. `amount` is then deducted from the caller's
278      * allowance.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transferFrom(
285         address from,
286         address to,
287         uint256 amount
288     ) external returns (bool);
289 }
290 
291 /**
292  * @dev Interface for the optional metadata functions from the ERC20 standard.
293  *
294  * _Available since v4.1._
295  */
296 interface IERC20Metadata is IERC20 {
297     /**
298      * @dev Returns the name of the token.
299      */
300     function name() external view returns (string memory);
301 
302     /**
303      * @dev Returns the symbol of the token.
304      */
305     function symbol() external view returns (string memory);
306 
307     /**
308      * @dev Returns the decimals places of the token.
309      */
310     function decimals() external view returns (uint8);
311 }
312 
313 /**
314  * @dev Implementation of the {IERC20} interface.
315  *
316  * This implementation is agnostic to the way tokens are created. This means
317  * that a supply mechanism has to be added in a derived contract using {_mint}.
318  * For a generic mechanism see {ERC20PresetMinterPauser}.
319  *
320  * TIP: For a detailed writeup see our guide
321  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
322  * to implement supply mechanisms].
323  *
324  * We have followed general OpenZeppelin Contracts guidelines: functions revert
325  * instead returning `false` on failure. This behavior is nonetheless
326  * conventional and does not conflict with the expectations of ERC20
327  * applications.
328  *
329  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
330  * This allows applications to reconstruct the allowance for all accounts just
331  * by listening to said events. Other implementations of the EIP may not emit
332  * these events, as it isn't required by the specification.
333  *
334  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
335  * functions have been added to mitigate the well-known issues around setting
336  * allowances. See {IERC20-approve}.
337  */
338 contract ERC20 is Context, IERC20, IERC20Metadata {
339     mapping(address => uint256) private _balances;
340 
341     mapping(address => mapping(address => uint256)) private _allowances;
342 
343     uint256 private _totalSupply;
344 
345     string private _name;
346     string private _symbol;
347 
348     /**
349      * @dev Sets the values for {name} and {symbol}.
350      *
351      * The default value of {decimals} is 18. To select a different value for
352      * {decimals} you should overload it.
353      *
354      * All two of these values are immutable: they can only be set once during
355      * construction.
356      */
357     constructor(string memory name_, string memory symbol_) {
358         _name = name_;
359         _symbol = symbol_;
360     }
361 
362     /**
363      * @dev Returns the name of the token.
364      */
365     function name() public view virtual override returns (string memory) {
366         return _name;
367     }
368 
369     /**
370      * @dev Returns the symbol of the token, usually a shorter version of the
371      * name.
372      */
373     function symbol() public view virtual override returns (string memory) {
374         return _symbol;
375     }
376 
377     /**
378      * @dev Returns the number of decimals used to get its user representation.
379      * For example, if `decimals` equals `2`, a balance of `505` tokens should
380      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
381      *
382      * Tokens usually opt for a value of 18, imitating the relationship between
383      * Ether and Wei. This is the value {ERC20} uses, unless this function is
384      * overridden;
385      *
386      * NOTE: This information is only used for _display_ purposes: it in
387      * no way affects any of the arithmetic of the contract, including
388      * {IERC20-balanceOf} and {IERC20-transfer}.
389      */
390     function decimals() public view virtual override returns (uint8) {
391         return 18;
392     }
393 
394     /**
395      * @dev See {IERC20-totalSupply}.
396      */
397     function totalSupply() public view virtual override returns (uint256) {
398         return _totalSupply;
399     }
400 
401     /**
402      * @dev See {IERC20-balanceOf}.
403      */
404     function balanceOf(
405         address account
406     ) public view virtual override returns (uint256) {
407         return _balances[account];
408     }
409 
410     /**
411      * @dev See {IERC20-transfer}.
412      *
413      * Requirements:
414      *
415      * - `to` cannot be the zero address.
416      * - the caller must have a balance of at least `amount`.
417      */
418     function transfer(
419         address to,
420         uint256 amount
421     ) public virtual override returns (bool) {
422         address owner = _msgSender();
423         _transfer(owner, to, amount);
424         return true;
425     }
426 
427     /**
428      * @dev See {IERC20-allowance}.
429      */
430     function allowance(
431         address owner,
432         address spender
433     ) public view virtual override returns (uint256) {
434         return _allowances[owner][spender];
435     }
436 
437     /**
438      * @dev See {IERC20-approve}.
439      *
440      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
441      * `transferFrom`. This is semantically equivalent to an infinite approval.
442      *
443      * Requirements:
444      *
445      * - `spender` cannot be the zero address.
446      */
447     function approve(
448         address spender,
449         uint256 amount
450     ) public virtual override returns (bool) {
451         address owner = _msgSender();
452         _approve(owner, spender, amount);
453         return true;
454     }
455 
456     /**
457      * @dev See {IERC20-transferFrom}.
458      *
459      * Emits an {Approval} event indicating the updated allowance. This is not
460      * required by the EIP. See the note at the beginning of {ERC20}.
461      *
462      * NOTE: Does not update the allowance if the current allowance
463      * is the maximum `uint256`.
464      *
465      * Requirements:
466      *
467      * - `from` and `to` cannot be the zero address.
468      * - `from` must have a balance of at least `amount`.
469      * - the caller must have allowance for ``from``'s tokens of at least
470      * `amount`.
471      */
472     function transferFrom(
473         address from,
474         address to,
475         uint256 amount
476     ) public virtual override returns (bool) {
477         address spender = _msgSender();
478         _spendAllowance(from, spender, amount);
479         _transfer(from, to, amount);
480         return true;
481     }
482 
483     /**
484      * @dev Atomically increases the allowance granted to `spender` by the caller.
485      *
486      * This is an alternative to {approve} that can be used as a mitigation for
487      * problems described in {IERC20-approve}.
488      *
489      * Emits an {Approval} event indicating the updated allowance.
490      *
491      * Requirements:
492      *
493      * - `spender` cannot be the zero address.
494      */
495     function increaseAllowance(
496         address spender,
497         uint256 addedValue
498     ) public virtual returns (bool) {
499         address owner = _msgSender();
500         _approve(owner, spender, allowance(owner, spender) + addedValue);
501         return true;
502     }
503 
504     /**
505      * @dev Atomically decreases the allowance granted to `spender` by the caller.
506      *
507      * This is an alternative to {approve} that can be used as a mitigation for
508      * problems described in {IERC20-approve}.
509      *
510      * Emits an {Approval} event indicating the updated allowance.
511      *
512      * Requirements:
513      *
514      * - `spender` cannot be the zero address.
515      * - `spender` must have allowance for the caller of at least
516      * `subtractedValue`.
517      */
518     function decreaseAllowance(
519         address spender,
520         uint256 subtractedValue
521     ) public virtual returns (bool) {
522         address owner = _msgSender();
523         uint256 currentAllowance = allowance(owner, spender);
524         require(
525             currentAllowance >= subtractedValue,
526             "ERC20: decreased allowance below zero"
527         );
528         unchecked {
529             _approve(owner, spender, currentAllowance - subtractedValue);
530         }
531 
532         return true;
533     }
534 
535     /**
536      * @dev Moves `amount` of tokens from `from` to `to`.
537      *
538      * This internal function is equivalent to {transfer}, and can be used to
539      * e.g. implement automatic token fees, slashing mechanisms, etc.
540      *
541      * Emits a {Transfer} event.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `from` must have a balance of at least `amount`.
548      */
549     function _transfer(
550         address from,
551         address to,
552         uint256 amount
553     ) internal virtual {
554         require(from != address(0), "ERC20: transfer from the zero address");
555         require(to != address(0), "ERC20: transfer to the zero address");
556 
557         _beforeTokenTransfer(from, to, amount);
558 
559         uint256 fromBalance = _balances[from];
560         require(
561             fromBalance >= amount,
562             "ERC20: transfer amount exceeds balance"
563         );
564         unchecked {
565             _balances[from] = fromBalance - amount;
566             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
567             // decrementing then incrementing.
568             _balances[to] += amount;
569         }
570 
571         emit Transfer(from, to, amount);
572 
573         _afterTokenTransfer(from, to, amount);
574     }
575 
576     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
577      * the total supply.
578      *
579      * Emits a {Transfer} event with `from` set to the zero address.
580      *
581      * Requirements:
582      *
583      * - `account` cannot be the zero address.
584      */
585     function _mint(address account, uint256 amount) internal virtual {
586         require(account != address(0), "ERC20: mint to the zero address");
587 
588         _beforeTokenTransfer(address(0), account, amount);
589 
590         _totalSupply += amount;
591         unchecked {
592             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
593             _balances[account] += amount;
594         }
595         emit Transfer(address(0), account, amount);
596 
597         _afterTokenTransfer(address(0), account, amount);
598     }
599 
600     /**
601      * @dev Destroys `amount` tokens from `account`, reducing the
602      * total supply.
603      *
604      * Emits a {Transfer} event with `to` set to the zero address.
605      *
606      * Requirements:
607      *
608      * - `account` cannot be the zero address.
609      * - `account` must have at least `amount` tokens.
610      */
611     function _burn(address account, uint256 amount) internal virtual {
612         require(account != address(0), "ERC20: burn from the zero address");
613 
614         _beforeTokenTransfer(account, address(0), amount);
615 
616         uint256 accountBalance = _balances[account];
617         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
618         unchecked {
619             _balances[account] = accountBalance - amount;
620             // Overflow not possible: amount <= accountBalance <= totalSupply.
621             _totalSupply -= amount;
622         }
623 
624         emit Transfer(account, address(0), amount);
625 
626         _afterTokenTransfer(account, address(0), amount);
627     }
628 
629     /**
630      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
631      *
632      * This internal function is equivalent to `approve`, and can be used to
633      * e.g. set automatic allowances for certain subsystems, etc.
634      *
635      * Emits an {Approval} event.
636      *
637      * Requirements:
638      *
639      * - `owner` cannot be the zero address.
640      * - `spender` cannot be the zero address.
641      */
642     function _approve(
643         address owner,
644         address spender,
645         uint256 amount
646     ) internal virtual {
647         require(owner != address(0), "ERC20: approve from the zero address");
648         require(spender != address(0), "ERC20: approve to the zero address");
649 
650         _allowances[owner][spender] = amount;
651         emit Approval(owner, spender, amount);
652     }
653 
654     /**
655      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
656      *
657      * Does not update the allowance amount in case of infinite allowance.
658      * Revert if not enough allowance is available.
659      *
660      * Might emit an {Approval} event.
661      */
662     function _spendAllowance(
663         address owner,
664         address spender,
665         uint256 amount
666     ) internal virtual {
667         uint256 currentAllowance = allowance(owner, spender);
668         if (currentAllowance != type(uint256).max) {
669             require(
670                 currentAllowance >= amount,
671                 "ERC20: insufficient allowance"
672             );
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
720 /**
721  * @dev Extension of {ERC20} that allows token holders to destroy both their own
722  * tokens and those that they have an allowance for, in a way that can be
723  * recognized off-chain (via event analysis).
724  */
725 abstract contract ERC20Burnable is Context, ERC20 {
726     /**
727      * @dev Destroys `amount` tokens from the caller.
728      *
729      * See {ERC20-_burn}.
730      */
731     function burn(uint256 amount) public virtual {
732         _burn(_msgSender(), amount);
733     }
734 
735     /**
736      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
737      * allowance.
738      *
739      * See {ERC20-_burn} and {ERC20-allowance}.
740      *
741      * Requirements:
742      *
743      * - the caller must have allowance for ``accounts``'s tokens of at least
744      * `amount`.
745      */
746     function burnFrom(address account, uint256 amount) public virtual {
747         _spendAllowance(account, _msgSender(), amount);
748         _burn(account, amount);
749     }
750 }
751 
752 contract AstroPupCoin is ERC20, ERC20Burnable, Pausable, Ownable {
753     uint256 public burnPercentage = 1; // 1% burn rate
754 
755     constructor() ERC20("AstroPup Coin", "ASPC") {
756         uint256 totalSupply = 69_000_000_000 * 10 ** decimals();
757         _mint(msg.sender, totalSupply);
758     }
759 
760     function pause() public onlyOwner {
761         _pause();
762     }
763 
764     function unpause() public onlyOwner {
765         _unpause();
766     }
767 
768     function setBurnPercentage(uint256 newBurnPercentage) public onlyOwner {
769         require(
770             newBurnPercentage <= 10,
771             "Burn percentage must be between 0 and 10."
772         );
773         burnPercentage = newBurnPercentage;
774     }
775 
776     function _beforeTokenTransfer(
777         address from,
778         address to,
779         uint256 amount
780     ) internal override(ERC20) whenNotPaused {
781         super._beforeTokenTransfer(from, to, amount);
782     }
783 
784     function _transfer(
785         address from,
786         address to,
787         uint256 amount
788     ) internal override {
789         uint256 burnAmount = (amount * burnPercentage) / 100;
790         uint256 remainingAmount = amount - burnAmount;
791         super._transfer(from, to, remainingAmount);
792         if (burnAmount > 0) {
793             super._burn(from, burnAmount);
794         }
795     }
796 }