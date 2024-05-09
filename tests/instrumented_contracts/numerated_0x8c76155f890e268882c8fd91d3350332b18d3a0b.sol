1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 /**
22  * @dev Contract module which allows children to implement an emergency stop
23  * mechanism that can be triggered by an authorized account.
24  *
25  * This module is used through inheritance. It will make available the
26  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
27  * the functions of your contract. Note that they will not be pausable by
28  * simply including this module, only once the modifiers are put in place.
29  */
30 abstract contract Pausable is Context {
31     /**
32      * @dev Emitted when the pause is triggered by `account`.
33      */
34     event Paused(address account);
35 
36     /**
37      * @dev Emitted when the pause is lifted by `account`.
38      */
39     event Unpaused(address account);
40 
41     bool private _paused;
42 
43     /**
44      * @dev Initializes the contract in unpaused state.
45      */
46     constructor() {
47         _paused = false;
48     }
49 
50     /**
51      * @dev Returns true if the contract is paused, and false otherwise.
52      */
53     function paused() public view virtual returns (bool) {
54         return _paused;
55     }
56 
57     /**
58      * @dev Modifier to make a function callable only when the contract is not paused.
59      *
60      * Requirements:
61      *
62      * - The contract must not be paused.
63      */
64     modifier whenNotPaused() {
65         require(!paused(), "Pausable: paused");
66         _;
67     }
68 
69     /**
70      * @dev Modifier to make a function callable only when the contract is paused.
71      *
72      * Requirements:
73      *
74      * - The contract must be paused.
75      */
76     modifier whenPaused() {
77         require(paused(), "Pausable: not paused");
78         _;
79     }
80 
81     /**
82      * @dev Triggers stopped state.
83      *
84      * Requirements:
85      *
86      * - The contract must not be paused.
87      */
88     function _pause() internal virtual whenNotPaused {
89         _paused = true;
90         emit Paused(_msgSender());
91     }
92 
93     /**
94      * @dev Returns to normal state.
95      *
96      * Requirements:
97      *
98      * - The contract must be paused.
99      */
100     function _unpause() internal virtual whenPaused {
101         _paused = false;
102         emit Unpaused(_msgSender());
103     }
104 }
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Emitted when `value` tokens are moved from one account (`from`) to
112      * another (`to`).
113      *
114      * Note that `value` may be zero.
115      */
116     event Transfer(address indexed from, address indexed to, uint256 value);
117 
118     /**
119      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
120      * a call to {approve}. `value` is the new allowance.
121      */
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 
124     /**
125      * @dev Returns the amount of tokens in existence.
126      */
127     function totalSupply() external view returns (uint256);
128 
129     /**
130      * @dev Returns the amount of tokens owned by `account`.
131      */
132     function balanceOf(address account) external view returns (uint256);
133 
134     /**
135      * @dev Moves `amount` tokens from the caller's account to `to`.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transfer(address to, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Returns the remaining number of tokens that `spender` will be
145      * allowed to spend on behalf of `owner` through {transferFrom}. This is
146      * zero by default.
147      *
148      * This value changes when {approve} or {transferFrom} are called.
149      */
150     function allowance(address owner, address spender) external view returns (uint256);
151 
152     /**
153      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * IMPORTANT: Beware that changing an allowance with this method brings the risk
158      * that someone may use both the old and the new allowance by unfortunate
159      * transaction ordering. One possible solution to mitigate this race
160      * condition is to first reduce the spender's allowance to 0 and set the
161      * desired value afterwards:
162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      *
164      * Emits an {Approval} event.
165      */
166     function approve(address spender, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Moves `amount` tokens from `from` to `to` using the
170      * allowance mechanism. `amount` is then deducted from the caller's
171      * allowance.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transferFrom(
178         address from,
179         address to,
180         uint256 amount
181     ) external returns (bool);
182 }
183 
184 /**
185  * @dev Interface for the optional metadata functions from the ERC20 standard.
186  *
187  * _Available since v4.1._
188  */
189 interface IERC20Metadata is IERC20 {
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() external view returns (string memory);
194 
195     /**
196      * @dev Returns the symbol of the token.
197      */
198     function symbol() external view returns (string memory);
199 
200     /**
201      * @dev Returns the decimals places of the token.
202      */
203     function decimals() external view returns (uint8);
204 }
205 
206 /**
207  * @dev Implementation of the {IERC20} interface.
208  *
209  * This implementation is agnostic to the way tokens are created. This means
210  * that a supply mechanism has to be added in a derived contract using {_mint}.
211  * For a generic mechanism see {ERC20PresetMinterPauser}.
212  *
213  * TIP: For a detailed writeup see our guide
214  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
215  * to implement supply mechanisms].
216  *
217  * We have followed general OpenZeppelin Contracts guidelines: functions revert
218  * instead returning `false` on failure. This behavior is nonetheless
219  * conventional and does not conflict with the expectations of ERC20
220  * applications.
221  *
222  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
223  * This allows applications to reconstruct the allowance for all accounts just
224  * by listening to said events. Other implementations of the EIP may not emit
225  * these events, as it isn't required by the specification.
226  *
227  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
228  * functions have been added to mitigate the well-known issues around setting
229  * allowances. See {IERC20-approve}.
230  */
231 contract ERC20 is Context, IERC20, IERC20Metadata {
232     mapping(address => uint256) private _balances;
233 
234     mapping(address => mapping(address => uint256)) private _allowances;
235 
236     uint256 private _totalSupply;
237 
238     string private _name;
239     string private _symbol;
240 
241     /**
242      * @dev Sets the values for {name} and {symbol}.
243      *
244      * The default value of {decimals} is 18. To select a different value for
245      * {decimals} you should overload it.
246      *
247      * All two of these values are immutable: they can only be set once during
248      * construction.
249      */
250     constructor(string memory name_, string memory symbol_) {
251         _name = name_;
252         _symbol = symbol_;
253     }
254 
255     /**
256      * @dev Returns the name of the token.
257      */
258     function name() public view virtual override returns (string memory) {
259         return _name;
260     }
261 
262     /**
263      * @dev Returns the symbol of the token, usually a shorter version of the
264      * name.
265      */
266     function symbol() public view virtual override returns (string memory) {
267         return _symbol;
268     }
269 
270     /**
271      * @dev Returns the number of decimals used to get its user representation.
272      * For example, if `decimals` equals `2`, a balance of `505` tokens should
273      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
274      *
275      * Tokens usually opt for a value of 18, imitating the relationship between
276      * Ether and Wei. This is the value {ERC20} uses, unless this function is
277      * overridden;
278      *
279      * NOTE: This information is only used for _display_ purposes: it in
280      * no way affects any of the arithmetic of the contract, including
281      * {IERC20-balanceOf} and {IERC20-transfer}.
282      */
283     function decimals() public view virtual override returns (uint8) {
284         return 18;
285     }
286 
287     /**
288      * @dev See {IERC20-totalSupply}.
289      */
290     function totalSupply() public view virtual override returns (uint256) {
291         return _totalSupply;
292     }
293 
294     /**
295      * @dev See {IERC20-balanceOf}.
296      */
297     function balanceOf(address account) public view virtual override returns (uint256) {
298         return _balances[account];
299     }
300 
301     /**
302      * @dev See {IERC20-transfer}.
303      *
304      * Requirements:
305      *
306      * - `to` cannot be the zero address.
307      * - the caller must have a balance of at least `amount`.
308      */
309     function transfer(address to, uint256 amount) public virtual override returns (bool) {
310         address owner = _msgSender();
311         _transfer(owner, to, amount);
312         return true;
313     }
314 
315     /**
316      * @dev See {IERC20-allowance}.
317      */
318     function allowance(address owner, address spender) public view virtual override returns (uint256) {
319         return _allowances[owner][spender];
320     }
321 
322     /**
323      * @dev See {IERC20-approve}.
324      *
325      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
326      * `transferFrom`. This is semantically equivalent to an infinite approval.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      */
332     function approve(address spender, uint256 amount) public virtual override returns (bool) {
333         address owner = _msgSender();
334         _approve(owner, spender, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-transferFrom}.
340      *
341      * Emits an {Approval} event indicating the updated allowance. This is not
342      * required by the EIP. See the note at the beginning of {ERC20}.
343      *
344      * NOTE: Does not update the allowance if the current allowance
345      * is the maximum `uint256`.
346      *
347      * Requirements:
348      *
349      * - `from` and `to` cannot be the zero address.
350      * - `from` must have a balance of at least `amount`.
351      * - the caller must have allowance for ``from``'s tokens of at least
352      * `amount`.
353      */
354     function transferFrom(
355         address from,
356         address to,
357         uint256 amount
358     ) public virtual override returns (bool) {
359         address spender = _msgSender();
360         _spendAllowance(from, spender, amount);
361         _transfer(from, to, amount);
362         return true;
363     }
364 
365     /**
366      * @dev Atomically increases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to {approve} that can be used as a mitigation for
369      * problems described in {IERC20-approve}.
370      *
371      * Emits an {Approval} event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
378         address owner = _msgSender();
379         _approve(owner, spender, allowance(owner, spender) + addedValue);
380         return true;
381     }
382 
383     /**
384      * @dev Atomically decreases the allowance granted to `spender` by the caller.
385      *
386      * This is an alternative to {approve} that can be used as a mitigation for
387      * problems described in {IERC20-approve}.
388      *
389      * Emits an {Approval} event indicating the updated allowance.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      * - `spender` must have allowance for the caller of at least
395      * `subtractedValue`.
396      */
397     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
398         address owner = _msgSender();
399         uint256 currentAllowance = allowance(owner, spender);
400         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
401         unchecked {
402             _approve(owner, spender, currentAllowance - subtractedValue);
403         }
404 
405         return true;
406     }
407 
408     /**
409      * @dev Moves `amount` of tokens from `from` to `to`.
410      *
411      * This internal function is equivalent to {transfer}, and can be used to
412      * e.g. implement automatic token fees, slashing mechanisms, etc.
413      *
414      * Emits a {Transfer} event.
415      *
416      * Requirements:
417      *
418      * - `from` cannot be the zero address.
419      * - `to` cannot be the zero address.
420      * - `from` must have a balance of at least `amount`.
421      */
422     function _transfer(
423         address from,
424         address to,
425         uint256 amount
426     ) internal virtual {
427         require(from != address(0), "ERC20: transfer from the zero address");
428         require(to != address(0), "ERC20: transfer to the zero address");
429 
430         _beforeTokenTransfer(from, to, amount);
431 
432         uint256 fromBalance = _balances[from];
433         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
434         unchecked {
435             _balances[from] = fromBalance - amount;
436         }
437         _balances[to] += amount;
438 
439         emit Transfer(from, to, amount);
440     }
441 
442     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
443      * the total supply.
444      *
445      * Emits a {Transfer} event with `from` set to the zero address.
446      *
447      * Requirements:
448      *
449      * - `account` cannot be the zero address.
450      */
451     function _mint(address account, uint256 amount) internal virtual {
452         require(account != address(0), "ERC20: mint to the zero address");
453 
454         _totalSupply += amount;
455         _balances[account] += amount;
456         emit Transfer(address(0), account, amount);
457     }
458 
459     /**
460      * @dev Destroys `amount` tokens from `account`, reducing the
461      * total supply.
462      *
463      * Emits a {Transfer} event with `to` set to the zero address.
464      *
465      * Requirements:
466      *
467      * - `account` cannot be the zero address.
468      * - `account` must have at least `amount` tokens.
469      */
470     function _burn(address account, uint256 amount) internal virtual {
471         require(account != address(0), "ERC20: burn from the zero address");
472 
473         uint256 accountBalance = _balances[account];
474         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
475         unchecked {
476             _balances[account] = accountBalance - amount;
477         }
478         _totalSupply -= amount;
479 
480         emit Transfer(account, address(0), amount);
481     }
482 
483     /**
484      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
485      *
486      * This internal function is equivalent to `approve`, and can be used to
487      * e.g. set automatic allowances for certain subsystems, etc.
488      *
489      * Emits an {Approval} event.
490      *
491      * Requirements:
492      *
493      * - `owner` cannot be the zero address.
494      * - `spender` cannot be the zero address.
495      */
496     function _approve(
497         address owner,
498         address spender,
499         uint256 amount
500     ) internal virtual {
501         require(owner != address(0), "ERC20: approve from the zero address");
502         require(spender != address(0), "ERC20: approve to the zero address");
503 
504         _allowances[owner][spender] = amount;
505         emit Approval(owner, spender, amount);
506     }
507 
508     /**
509      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
510      *
511      * Does not update the allowance amount in case of infinite allowance.
512      * Revert if not enough allowance is available.
513      *
514      * Might emit an {Approval} event.
515      */
516     function _spendAllowance(
517         address owner,
518         address spender,
519         uint256 amount
520     ) internal virtual {
521         uint256 currentAllowance = allowance(owner, spender);
522         if (currentAllowance != type(uint256).max) {
523             require(currentAllowance >= amount, "ERC20: insufficient allowance");
524             unchecked {
525                 _approve(owner, spender, currentAllowance - amount);
526             }
527         }
528     }
529 
530     /**
531      * @dev Hook that is called before any transfer of tokens. This includes
532      * minting and burning.
533      *
534      * Calling conditions:
535      *
536      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
537      * will be transferred to `to`.
538      * - when `from` is zero, `amount` tokens will be minted for `to`.
539      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
540      * - `from` and `to` are never both zero.
541      *
542      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
543      */
544     function _beforeTokenTransfer(
545         address from,
546         address to,
547         uint256 amount
548     ) internal virtual {}
549 }
550 
551 /**
552  * @dev Contract module which provides a basic access control mechanism, where
553  * there is an account (an owner) that can be granted exclusive access to
554  * specific functions.
555  *
556  * By default, the owner account will be the one that deploys the contract. This
557  * can later be changed with {transferOwnership}.
558  *
559  * This module is used through inheritance. It will make available the modifier
560  * `onlyOwner`, which can be applied to your functions to restrict their use to
561  * the owner.
562  */
563 abstract contract Ownable is Context {
564     address private _owner;
565 
566     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
567 
568     /**
569      * @dev Initializes the contract setting the deployer as the initial owner.
570      */
571     constructor() {
572         _transferOwnership(_msgSender());
573     }
574 
575     /**
576      * @dev Returns the address of the current owner.
577      */
578     function owner() public view virtual returns (address) {
579         return _owner;
580     }
581 
582     /**
583      * @dev Throws if called by any account other than the owner.
584      */
585     modifier onlyOwner() {
586         require(owner() == _msgSender(), "Ownable: caller is not the owner");
587         _;
588     }
589 
590     /**
591      * @dev Transfers ownership of the contract to a new account (`newOwner`).
592      * Internal function without access restriction.
593      */
594     function _transferOwnership(address newOwner) internal virtual {
595         address oldOwner = _owner;
596         _owner = newOwner;
597         emit OwnershipTransferred(oldOwner, newOwner);
598     }
599 }
600 
601 /**
602  * @dev Contract module which provides a basic access control mechanism, where
603  * there is an account (a supervisor) that can be granted exclusive access to
604  * specific functions.
605  *
606  * By default, the supervisor account will be the one that deploys the contract. This
607  * can later be changed with {transferSupervisorOwnership}.
608  *
609  * This module is used through inheritance. It will make available the modifier
610  * `onlySupervisor`, which can be applied to your functions to restrict their use to
611  * the supervisor.
612  */
613 abstract contract Supervisable is Context {
614     address private _supervisor;
615 
616     event SupervisorOwnershipTransferred(address indexed previouSupervisor, address indexed newSupervisor);
617 
618     /**
619      * @dev Initializes the contract setting the deployer as the initial supervisor.
620      */
621     constructor() {
622         _transferSupervisorOwnership(_msgSender());
623     }
624 
625     /**
626      * @dev Returns the address of the current supervisor.
627      */
628     function supervisor() public view virtual returns (address) {
629         return _supervisor;
630     }
631 
632     /**
633      * @dev Throws if called by any account other than the supervisor.
634      */
635     modifier onlySupervisor() {
636         require(supervisor() == _msgSender(), "Supervisable: caller is not the supervisor");
637         _;
638     }
639 
640     /**
641      * @dev Transfers supervisor ownership of the contract to a new account (`newSupervisor`).
642      * Internal function without access restriction.
643      */
644     function _transferSupervisorOwnership(address newSupervisor) internal virtual {
645         address oldSupervisor = _supervisor;
646         _supervisor = newSupervisor;
647         emit SupervisorOwnershipTransferred(oldSupervisor, newSupervisor);
648     }
649 }
650 
651 /**
652  * @dev Extension of {ERC20} that allows token holders to destroy both their own
653  * tokens and those that they have an allowance for, in a way that can be
654  * recognized off-chain (via event analysis).
655  */
656 abstract contract Burnable is Context {
657     mapping(address => bool) private _burners;
658 
659     event BurnerAdded(address indexed account);
660     event BurnerRemoved(address indexed account);
661 
662     /**
663      * @dev Returns whether the address is burner.
664      */
665     function isBurner(address account) public view returns (bool) {
666         return _burners[account];
667     }
668 
669     /**
670      * @dev Throws if called by any account other than the burner.
671      */
672     modifier onlyBurner() {
673         require(_burners[_msgSender()], "Burnable: caller is not the burner");
674         _;
675     }
676 
677     /**
678      * @dev Add burner, only owner can add burner.
679      */
680     function _addBurner(address account) internal {
681         _burners[account] = true;
682         emit BurnerAdded(account);
683     }
684 
685     /**
686      * @dev Remove operator, only owner can remove operator
687      */
688     function _removeBurner(address account) internal {
689         _burners[account] = false;
690         emit BurnerRemoved(account);
691     }
692 }
693 
694 /**
695  * @dev Contract for freezing mechanism.
696  * Owner can add freezed account.
697  * Supervisor can remove freezed account.
698  */
699 contract Freezable is Context {
700     mapping(address => bool) private _freezes;
701 
702     event Freezed(address indexed account);
703     event Unfreezed(address indexed account);
704 
705     /**
706      * @dev Freeze account, only owner can freeze
707      */
708     function _freeze(address account) internal {
709         _freezes[account] = true;
710         emit Freezed(account);
711     }
712 
713     /**
714      * @dev Unfreeze account, only supervisor can unfreeze
715      */
716     function _unfreeze(address account) internal {
717         _freezes[account] = false;
718         emit Unfreezed(account);
719     }
720 
721     /**
722      * @dev Returns whether the address is freezed.
723      */
724     function isFreezed(address account) public view returns (bool) {
725         return _freezes[account];
726     }
727 }
728 
729 /**
730  * @dev Contract for locking mechanism.
731  * Locker can add locked account.
732  * Supervisor can remove locked account.
733  */
734 contract Lockable is Context {
735     struct TimeLock {
736         uint256 amount;
737         uint256 expiresAt;
738     }
739 
740     struct VestingLock {
741         uint256 amount;
742         uint256 startsAt;
743         uint256 period;
744         uint256 count;
745     }
746 
747     mapping(address => bool) private _lockers;
748     mapping(address => TimeLock[]) private _timeLocks;
749     mapping(address => VestingLock) private _vestingLocks;
750 
751     event LockerAdded(address indexed account);
752     event LockerRemoved(address indexed account);
753     event TimeLocked(address indexed account);
754     event TimeUnlocked(address indexed account);
755     event VestingLocked(address indexed account);
756     event VestingUnlocked(address indexed account);
757 
758     /**
759      * @dev Throws if called by any account other than the locker.
760      */
761     modifier onlyLocker() {
762         require(_lockers[_msgSender()], "Lockable: caller is not the locker");
763         _;
764     }
765 
766     /**
767      * @dev Returns whether the address is locker.
768      */
769     function isLocker(address account) public view returns (bool) {
770         return _lockers[account];
771     }
772 
773     /**
774      * @dev Add locker, only owner can add locker
775      */
776     function _addLocker(address account) internal {
777         _lockers[account] = true;
778         emit LockerAdded(account);
779     }
780 
781     /**
782      * @dev Remove locker, only owner can remove locker
783      */
784     function _removeLocker(address account) internal {
785         _lockers[account] = false;
786         emit LockerRemoved(account);
787     }
788 
789     /**
790      * @dev Add time lock, only locker can add
791      */
792     function _addTimeLock(
793         address account,
794         uint256 amount,
795         uint256 expiresAt
796     ) internal {
797         require(amount > 0, "TimeLock: lock amount is 0");
798         require(expiresAt > block.timestamp, "TimeLock: invalid expire date");
799         _timeLocks[account].push(TimeLock(amount, expiresAt));
800         emit TimeLocked(account);
801     }
802 
803     /**
804      * @dev Remove time lock, only supervisor can remove
805      * @param account The address want to remove time lock
806      * @param index Time lock index
807      */
808     function _removeTimeLock(address account, uint8 index) internal {
809         require(_timeLocks[account].length > index && index >= 0, "TimeLock: invalid index");
810 
811         uint256 len = _timeLocks[account].length;
812         if (len - 1 != index) {
813             // if it is not last item, swap it
814             _timeLocks[account][index] = _timeLocks[account][len - 1];
815         }
816         _timeLocks[account].pop();
817         emit TimeUnlocked(account);
818     }
819 
820     /**
821      * @dev Get time lock array length
822      * @param account The address want to know the time lock length.
823      * @return time lock length
824      */
825     function getTimeLockLength(address account) public view returns (uint256) {
826         return _timeLocks[account].length;
827     }
828 
829     /**
830      * @dev Get time lock info
831      * @param account The address want to know the time lock state.
832      * @param index Time lock index
833      * @return time lock info
834      */
835     function getTimeLock(address account, uint8 index) public view returns (uint256, uint256) {
836         require(_timeLocks[account].length > index && index >= 0, "TimeLock: invalid index");
837         return (_timeLocks[account][index].amount, _timeLocks[account][index].expiresAt);
838     }
839 
840     /**
841      * @dev get total time locked amount of address
842      * @param account The address want to know the time lock amount.
843      * @return time locked amount
844      */
845     function getTimeLockedAmount(address account) public view returns (uint256) {
846         uint256 timeLockedAmount = 0;
847 
848         uint256 len = _timeLocks[account].length;
849         for (uint256 i = 0; i < len; i++) {
850             if (block.timestamp < _timeLocks[account][i].expiresAt) {
851                 timeLockedAmount = timeLockedAmount + _timeLocks[account][i].amount;
852             }
853         }
854         return timeLockedAmount;
855     }
856 
857     /**
858      * @dev Add vesting lock, only locker can add
859      * @param account vesting lock account.
860      * @param amount vesting lock amount.
861      * @param startsAt vesting lock release start date.
862      * @param period vesting lock period. End date is startsAt + (period - 1) * count
863      * @param count vesting lock count. If count is 1, it works like a time lock
864      */
865     function _addVestingLock(
866         address account,
867         uint256 amount,
868         uint256 startsAt,
869         uint256 period,
870         uint256 count
871     ) internal {
872         require(account != address(0), "VestingLock: lock from the zero address");
873         require(startsAt > block.timestamp, "VestingLock: must set after now");
874         require(amount > 0, "VestingLock: amount is 0");
875         require(period > 0, "VestingLock: period is 0");
876         require(count > 0, "VestingLock: count is 0");
877         _vestingLocks[account] = VestingLock(amount, startsAt, period, count);
878         emit VestingLocked(account);
879     }
880 
881     /**
882      * @dev Remove vesting lock, only supervisor can remove
883      * @param account The address want to remove the vesting lock
884      */
885     function _removeVestingLock(address account) internal {
886         _vestingLocks[account] = VestingLock(0, 0, 0, 0);
887         emit VestingUnlocked(account);
888     }
889 
890     /**
891      * @dev Get vesting lock info
892      * @param account The address want to know the vesting lock state.
893      * @return vesting lock info
894      */
895     function getVestingLock(address account)
896         public
897         view
898         returns (
899             uint256,
900             uint256,
901             uint256,
902             uint256
903         )
904     {
905         return (_vestingLocks[account].amount, _vestingLocks[account].startsAt, _vestingLocks[account].period, _vestingLocks[account].count);
906     }
907 
908     /**
909      * @dev Get total vesting locked amount of address, locked amount will be released by 100%/months
910      * If months is 5, locked amount released 20% per 1 month.
911      * @param account The address want to know the vesting lock amount.
912      * @return vesting locked amount
913      */
914     function getVestingLockedAmount(address account) public view returns (uint256) {
915         uint256 vestingLockedAmount = 0;
916         uint256 amount = _vestingLocks[account].amount;
917         if (amount > 0) {
918             uint256 startsAt = _vestingLocks[account].startsAt;
919             uint256 period = _vestingLocks[account].period;
920             uint256 count = _vestingLocks[account].count;
921             uint256 expiresAt = startsAt + period * (count - 1);
922             uint256 timestamp = block.timestamp;
923             if (timestamp < startsAt) {
924                 vestingLockedAmount = amount;
925             } else if (timestamp < expiresAt) {
926                 vestingLockedAmount = (amount * ((expiresAt - timestamp) / period + 1)) / count;
927             }
928         }
929         return vestingLockedAmount;
930     }
931 
932     /**
933      * @dev Get all locked amount
934      * @param account The address want to know the all locked amount
935      * @return all locked amount
936      */
937     function getAllLockedAmount(address account) public view returns (uint256) {
938         return getTimeLockedAmount(account) + getVestingLockedAmount(account);
939     }
940 }
941 
942 /**
943  * @dev Contract for MyOwnItem Coin
944  */
945 contract MOI is Pausable, Ownable, Supervisable, Burnable, Freezable, Lockable, ERC20 {
946     uint256 private constant _initialSupply = 5_000_000_000e18;
947 
948     constructor() ERC20("MyOwnItem", "MOI") {
949         _mint(_msgSender(), _initialSupply);
950     }
951 
952     /**
953      * @dev Recover ERC20 coin in contract address.
954      * @param tokenAddress The token contract address
955      * @param tokenAmount Number of tokens to be sent
956      */
957     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
958         IERC20(tokenAddress).transfer(owner(), tokenAmount);
959     }
960 
961     /**
962      * @dev lock and pause before transfer token
963      */
964     function _beforeTokenTransfer(
965         address from,
966         address to,
967         uint256 amount
968     ) internal override(ERC20) {
969         super._beforeTokenTransfer(from, to, amount);
970 
971         require(!isFreezed(from), "Freezable: token transfer from freezed account");
972         require(!isFreezed(to), "Freezable: token transfer to freezed account");
973         require(!isFreezed(_msgSender()), "Freezable: token transfer called from freezed account");
974         require(!paused(), "Pausable: token transfer while paused");
975         require(balanceOf(from) - getAllLockedAmount(from) >= amount, "Lockable: insufficient transfer amount");
976     }
977 
978     /**
979      * @dev Leaves the contract without owner. It will not be possible to call
980      * `onlyOwner` functions anymore. Can only be called by the current owner.
981      *
982      * NOTE: Renouncing ownership will leave the contract without an owner,
983      * thereby removing any functionality that is only available to the owner.
984      */
985     function renounceOwnership() public onlyOwner whenNotPaused {
986         _transferOwnership(address(0));
987     }
988 
989     /**
990      * @dev only supervisor can renounce supervisor ownership
991      */
992     function renounceSupervisorOwnership() public onlySupervisor whenNotPaused {
993         _transferSupervisorOwnership(address(0));
994     }
995 
996     /**
997      * @dev Transfers ownership of the contract to a new account (`newOwner`).
998      * Can only be called by the current owner.
999      */
1000     function transferOwnership(address newOwner) public onlyOwner whenNotPaused {
1001         require(newOwner != address(0), "Ownable: new owner is the zero address");
1002         _transferOwnership(newOwner);
1003     }
1004 
1005     /**
1006      * @dev only supervisor can transfer supervisor ownership
1007      */
1008     function transferSupervisorOwnership(address newSupervisor) public onlySupervisor whenNotPaused {
1009         require(newSupervisor != address(0), "Supervisable: new supervisor is the zero address");
1010         _transferSupervisorOwnership(newSupervisor);
1011     }
1012 
1013     /**
1014      * @dev pause all coin transfer
1015      */
1016     function pause() public onlyOwner whenNotPaused {
1017         _pause();
1018     }
1019 
1020     /**
1021      * @dev unpause all coin transfer
1022      */
1023     function unpause() public onlyOwner whenPaused {
1024         _unpause();
1025     }
1026 
1027     /**
1028      * @dev only owner can lock account
1029      */
1030     function freeze(address account) public onlyOwner whenNotPaused {
1031         _freeze(account);
1032     }
1033 
1034     /**
1035      * @dev only supervisor can unfreeze account
1036      */
1037     function unfreeze(address account) public onlySupervisor whenNotPaused {
1038         _unfreeze(account);
1039     }
1040 
1041     /**
1042      * @dev only owner can add burner
1043      */
1044     function addBurner(address account) public onlyOwner whenNotPaused {
1045         _addBurner(account);
1046     }
1047 
1048     /**
1049      * @dev only owner can remove burner
1050      */
1051     function removeBurner(address account) public onlyOwner whenNotPaused {
1052         _removeBurner(account);
1053     }
1054 
1055     /**
1056      * @dev burn burner's coin
1057      */
1058     function burn(uint256 amount) public onlyBurner whenNotPaused {
1059         _burn(_msgSender(), amount);
1060     }
1061 
1062     /**
1063      * @dev only owner can add locker
1064      */
1065     function addLocker(address account) public onlyOwner whenNotPaused {
1066         _addLocker(account);
1067     }
1068 
1069     /**
1070      * @dev only owner can remove locker
1071      */
1072     function removeLocker(address account) public onlyOwner whenNotPaused {
1073         _removeLocker(account);
1074     }
1075 
1076     /**
1077      * @dev only locker can add time lock
1078      */
1079     function addTimeLock(
1080         address account,
1081         uint256 amount,
1082         uint256 expiresAt
1083     ) public onlyLocker whenNotPaused {
1084         _addTimeLock(account, amount, expiresAt);
1085     }
1086 
1087     /**
1088      * @dev only supervisor can remove time lock
1089      */
1090     function removeTimeLock(address account, uint8 index) public onlySupervisor whenNotPaused {
1091         _removeTimeLock(account, index);
1092     }
1093 
1094     /**
1095      * @dev only locker can add vesting lock
1096      */
1097     function addVestingLock(
1098         address account,
1099         uint256 startsAt,
1100         uint256 period,
1101         uint256 count
1102     ) public onlyLocker whenNotPaused {
1103         _addVestingLock(account, balanceOf(account), startsAt, period, count);
1104     }
1105 
1106     /**
1107      * @dev only supervisor can remove vesting lock
1108      */
1109     function removeVestingLock(address account) public onlySupervisor whenNotPaused {
1110         _removeVestingLock(account);
1111     }
1112 }