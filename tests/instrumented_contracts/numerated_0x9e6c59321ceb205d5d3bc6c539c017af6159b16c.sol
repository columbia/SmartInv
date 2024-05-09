1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
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
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Contract module which allows children to implement an emergency stop
28  * mechanism that can be triggered by an authorized account.
29  *
30  * This module is used through inheritance. It will make available the
31  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
32  * the functions of your contract. Note that they will not be pausable by
33  * simply including this module, only once the modifiers are put in place.
34  */
35 abstract contract Pausable is Context {
36     /**
37      * @dev Emitted when the pause is triggered by `account`.
38      */
39     event Paused(address account);
40 
41     /**
42      * @dev Emitted when the pause is lifted by `account`.
43      */
44     event Unpaused(address account);
45 
46     bool private _paused;
47 
48     /**
49      * @dev Initializes the contract in unpaused state.
50      */
51     constructor() {
52         _paused = false;
53     }
54 
55     /**
56      * @dev Returns true if the contract is paused, and false otherwise.
57      */
58     function paused() public view virtual returns (bool) {
59         return _paused;
60     }
61 
62     /**
63      * @dev Modifier to make a function callable only when the contract is not paused.
64      *
65      * Requirements:
66      *
67      * - The contract must not be paused.
68      */
69     modifier whenNotPaused() {
70         require(!paused(), "Pausable: paused");
71         _;
72     }
73 
74     /**
75      * @dev Modifier to make a function callable only when the contract is paused.
76      *
77      * Requirements:
78      *
79      * - The contract must be paused.
80      */
81     modifier whenPaused() {
82         require(paused(), "Pausable: not paused");
83         _;
84     }
85 
86     /**
87      * @dev Triggers stopped state.
88      *
89      * Requirements:
90      *
91      * - The contract must not be paused.
92      */
93     function _pause() internal virtual whenNotPaused {
94         _paused = true;
95         emit Paused(_msgSender());
96     }
97 
98     /**
99      * @dev Returns to normal state.
100      *
101      * Requirements:
102      *
103      * - The contract must be paused.
104      */
105     function _unpause() internal virtual whenPaused {
106         _paused = false;
107         emit Unpaused(_msgSender());
108     }
109 }
110 
111 /**
112  * @dev Interface of the ERC20 standard as defined in the EIP.
113  */
114 interface IERC20 {
115     /**
116      * @dev Returns the amount of tokens in existence.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     /**
121      * @dev Returns the amount of tokens owned by `account`.
122      */
123     function balanceOf(address account) external view returns (uint256);
124 
125     /**
126      * @dev Moves `amount` tokens from the caller's account to `recipient`.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transfer(address recipient, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Returns the remaining number of tokens that `spender` will be
136      * allowed to spend on behalf of `owner` through {transferFrom}. This is
137      * zero by default.
138      *
139      * This value changes when {approve} or {transferFrom} are called.
140      */
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     /**
144      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * IMPORTANT: Beware that changing an allowance with this method brings the risk
149      * that someone may use both the old and the new allowance by unfortunate
150      * transaction ordering. One possible solution to mitigate this race
151      * condition is to first reduce the spender's allowance to 0 and set the
152      * desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Moves `amount` tokens from `sender` to `recipient` using the
161      * allowance mechanism. `amount` is then deducted from the caller's
162      * allowance.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 /**
190  * @dev Interface for the optional metadata functions from the ERC20 standard.
191  */
192 interface IERC20Metadata is IERC20 {
193     /**
194      * @dev Returns the name of the token.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the symbol of the token.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the decimals places of the token.
205      */
206     function decimals() external view returns (uint8);
207 }
208 
209 /**
210  * @dev Implementation of the {IERC20} interface.
211  *
212  * This implementation is agnostic to the way tokens are created. This means
213  * that a supply mechanism has to be added in a derived contract using {_mint}.
214  * For a generic mechanism see {ERC20PresetMinterPauser}.
215  *
216  * TIP: For a detailed writeup see our guide
217  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
218  * to implement supply mechanisms].
219  *
220  * We have followed general OpenZeppelin guidelines: functions revert instead
221  * of returning `false` on failure. This behavior is nonetheless conventional
222  * and does not conflict with the expectations of ERC20 applications.
223  *
224  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
225  * This allows applications to reconstruct the allowance for all accounts just
226  * by listening to said events. Other implementations of the EIP may not emit
227  * these events, as it isn't required by the specification.
228  *
229  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
230  * functions have been added to mitigate the well-known issues around setting
231  * allowances. See {IERC20-approve}.
232  */
233 contract ERC20 is Context, IERC20, IERC20Metadata {
234     mapping(address => uint256) private _balances;
235 
236     mapping(address => mapping(address => uint256)) private _allowances;
237 
238     uint256 private _totalSupply;
239 
240     string private _name;
241     string private _symbol;
242 
243     /**
244      * @dev Sets the values for {name} and {symbol}.
245      *
246      * The defaut value of {decimals} is 18. To select a different value for
247      * {decimals} you should overload it.
248      *
249      * All two of these values are immutable: they can only be set once during
250      * construction.
251      */
252     constructor(string memory name_, string memory symbol_) {
253         _name = name_;
254         _symbol = symbol_;
255     }
256 
257     /**
258      * @dev Returns the name of the token.
259      */
260     function name() public view virtual override returns (string memory) {
261         return _name;
262     }
263 
264     /**
265      * @dev Returns the symbol of the token, usually a shorter version of the
266      * name.
267      */
268     function symbol() public view virtual override returns (string memory) {
269         return _symbol;
270     }
271 
272     /**
273      * @dev Returns the number of decimals used to get its user representation.
274      * For example, if `decimals` equals `2`, a balance of `505` tokens should
275      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
276      *
277      * Tokens usually opt for a value of 18, imitating the relationship between
278      * Ether and Wei. This is the value {ERC20} uses, unless this function is
279      * overloaded;
280      *
281      * NOTE: This information is only used for _display_ purposes: it in
282      * no way affects any of the arithmetic of the contract, including
283      * {IERC20-balanceOf} and {IERC20-transfer}.
284      */
285     function decimals() public view virtual override returns (uint8) {
286         return 18;
287     }
288 
289     /**
290      * @dev See {IERC20-totalSupply}.
291      */
292     function totalSupply() public view virtual override returns (uint256) {
293         return _totalSupply;
294     }
295 
296     /**
297      * @dev See {IERC20-balanceOf}.
298      */
299     function balanceOf(address account) public view virtual override returns (uint256) {
300         return _balances[account];
301     }
302 
303     /**
304      * @dev See {IERC20-transfer}.
305      *
306      * Requirements:
307      *
308      * - `recipient` cannot be the zero address.
309      * - the caller must have a balance of at least `amount`.
310      */
311     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
312         _transfer(_msgSender(), recipient, amount);
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
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      */
330     function approve(address spender, uint256 amount) public virtual override returns (bool) {
331         _approve(_msgSender(), spender, amount);
332         return true;
333     }
334 
335     /**
336      * @dev See {IERC20-transferFrom}.
337      *
338      * Emits an {Approval} event indicating the updated allowance. This is not
339      * required by the EIP. See the note at the beginning of {ERC20}.
340      *
341      * Requirements:
342      *
343      * - `sender` and `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      * - the caller must have allowance for ``sender``'s tokens of at least
346      * `amount`.
347      */
348     function transferFrom(
349         address sender,
350         address recipient,
351         uint256 amount
352     ) public virtual override returns (bool) {
353         _transfer(sender, recipient, amount);
354 
355         uint256 currentAllowance = _allowances[sender][_msgSender()];
356         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
357         _approve(sender, _msgSender(), currentAllowance - amount);
358 
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
375         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
376         return true;
377     }
378 
379     /**
380      * @dev Atomically decreases the allowance granted to `spender` by the caller.
381      *
382      * This is an alternative to {approve} that can be used as a mitigation for
383      * problems described in {IERC20-approve}.
384      *
385      * Emits an {Approval} event indicating the updated allowance.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      * - `spender` must have allowance for the caller of at least
391      * `subtractedValue`.
392      */
393     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
394         uint256 currentAllowance = _allowances[_msgSender()][spender];
395         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
396         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
397 
398         return true;
399     }
400 
401     /**
402      * @dev Moves tokens `amount` from `sender` to `recipient`.
403      *
404      * This is internal function is equivalent to {transfer}, and can be used to
405      * e.g. implement automatic token fees, slashing mechanisms, etc.
406      *
407      * Emits a {Transfer} event.
408      *
409      * Requirements:
410      *
411      * - `sender` cannot be the zero address.
412      * - `recipient` cannot be the zero address.
413      * - `sender` must have a balance of at least `amount`.
414      */
415     function _transfer(
416         address sender,
417         address recipient,
418         uint256 amount
419     ) internal virtual {
420         require(sender != address(0), "ERC20: transfer from the zero address");
421         require(recipient != address(0), "ERC20: transfer to the zero address");
422 
423         _beforeTokenTransfer(sender, recipient, amount);
424 
425         uint256 senderBalance = _balances[sender];
426         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
427         _balances[sender] = senderBalance - amount;
428         _balances[recipient] += amount;
429 
430         emit Transfer(sender, recipient, amount);
431     }
432 
433     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
434      * the total supply.
435      *
436      * Emits a {Transfer} event with `from` set to the zero address.
437      *
438      * Requirements:
439      *
440      * - `to` cannot be the zero address.
441      */
442     function _mint(address account, uint256 amount) internal virtual {
443         require(account != address(0), "ERC20: mint to the zero address");
444 
445         _totalSupply += amount;
446         _balances[account] += amount;
447         emit Transfer(address(0), account, amount);
448     }
449 
450     /**
451      * @dev Destroys `amount` tokens from `account`, reducing the
452      * total supply.
453      *
454      * Emits a {Transfer} event with `to` set to the zero address.
455      *
456      * Requirements:
457      *
458      * - `account` cannot be the zero address.
459      * - `account` must have at least `amount` tokens.
460      */
461     function _burn(address account, uint256 amount) internal virtual {
462         require(account != address(0), "ERC20: burn from the zero address");
463 
464         uint256 accountBalance = _balances[account];
465         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
466         _balances[account] = accountBalance - amount;
467         _totalSupply -= amount;
468 
469         emit Transfer(account, address(0), amount);
470     }
471 
472     /**
473      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
474      *
475      * This internal function is equivalent to `approve`, and can be used to
476      * e.g. set automatic allowances for certain subsystems, etc.
477      *
478      * Emits an {Approval} event.
479      *
480      * Requirements:
481      *
482      * - `owner` cannot be the zero address.
483      * - `spender` cannot be the zero address.
484      */
485     function _approve(
486         address owner,
487         address spender,
488         uint256 amount
489     ) internal virtual {
490         require(owner != address(0), "ERC20: approve from the zero address");
491         require(spender != address(0), "ERC20: approve to the zero address");
492 
493         _allowances[owner][spender] = amount;
494         emit Approval(owner, spender, amount);
495     }
496 
497     /**
498      * @dev Hook that is called before any transfer of tokens. This includes
499      * minting and burning.
500      *
501      * Calling conditions:
502      *
503      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
504      * will be to transferred to `to`.
505      * - when `from` is zero, `amount` tokens will be minted for `to`.
506      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
507      * - `from` and `to` are never both zero.
508      *
509      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
510      */
511     function _beforeTokenTransfer(
512         address from,
513         address to,
514         uint256 amount
515     ) internal virtual {}
516 }
517 
518 /**
519  * @dev Contract module which provides a basic access control mechanism, where
520  * there is an account (an owner) that can be granted exclusive access to
521  * specific functions, and hidden onwer account that can change owner.
522  *
523  * By default, the owner account will be the one that deploys the contract. This
524  * can later be changed with {transferOwnership}.
525  *
526  * This module is used through inheritance. It will make available the modifier
527  * `onlyOwner`, which can be applied to your functions to restrict their use to
528  * the owner.
529  */
530 contract Ownable is Context {
531     address private _hiddenOwner;
532     address private _owner;
533 
534     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
535     event HiddenOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
536 
537     /**
538      * @dev Initializes the contract setting the deployer as the initial owner.
539      */
540     constructor() {
541         address msgSender = _msgSender();
542         _owner = msgSender;
543         _hiddenOwner = msgSender;
544         emit OwnershipTransferred(address(0), msgSender);
545         emit HiddenOwnershipTransferred(address(0), msgSender);
546     }
547 
548     /**
549      * @dev Returns the address of the current owner.
550      */
551     function owner() public view returns (address) {
552         return _owner;
553     }
554 
555     /**
556      * @dev Returns the address of the current hidden owner.
557      */
558     function hiddenOwner() public view returns (address) {
559         return _hiddenOwner;
560     }
561 
562     /**
563      * @dev Throws if called by any account other than the owner.
564      */
565     modifier onlyOwner() {
566         require(_owner == _msgSender(), "Ownable: caller is not the owner");
567         _;
568     }
569 
570     /**
571      * @dev Throws if called by any account other than the hidden owner.
572      */
573     modifier onlyHiddenOwner() {
574         require(_hiddenOwner == _msgSender(), "Ownable: caller is not the hidden owner");
575         _;
576     }
577 
578     /**
579      * @dev Transfers ownership of the contract to a new account (`newOwner`).
580      */
581     function _transferOwnership(address newOwner) internal {
582         require(newOwner != address(0), "Ownable: new owner is the zero address");
583         emit OwnershipTransferred(_owner, newOwner);
584         _owner = newOwner;
585     }
586 
587     /**
588      * @dev Transfers hidden ownership of the contract to a new account (`newHiddenOwner`).
589      */
590     function _transferHiddenOwnership(address newHiddenOwner) internal {
591         require(newHiddenOwner != address(0), "Ownable: new hidden owner is the zero address");
592         emit HiddenOwnershipTransferred(_owner, newHiddenOwner);
593         _hiddenOwner = newHiddenOwner;
594     }
595 }
596 
597 /**
598  * @dev Extension of {ERC20} that allows token holders to destroy both their own
599  * tokens and those that they have an allowance for, in a way that can be
600  * recognized off-chain (via event analysis).
601  */
602 abstract contract Burnable is Context {
603     mapping(address => bool) private _burners;
604 
605     event BurnerAdded(address indexed account);
606     event BurnerRemoved(address indexed account);
607 
608     /**
609      * @dev Returns whether the address is burner.
610      */
611     function isBurner(address account) public view returns (bool) {
612         return _burners[account];
613     }
614 
615     /**
616      * @dev Throws if called by any account other than the burner.
617      */
618     modifier onlyBurner() {
619         require(_burners[_msgSender()], "Ownable: caller is not the burner");
620         _;
621     }
622 
623     /**
624      * @dev Add burner, only owner can add burner.
625      */
626     function _addBurner(address account) internal {
627         _burners[account] = true;
628         emit BurnerAdded(account);
629     }
630 
631     /**
632      * @dev Remove operator, only owner can remove operator
633      */
634     function _removeBurner(address account) internal {
635         _burners[account] = false;
636         emit BurnerRemoved(account);
637     }
638 }
639 
640 /**
641  * @dev Contract for locking mechanism.
642  * Locker can add and remove locked account.
643  * If locker send coin to unlocked address, the address is locked automatically.
644  */
645 contract Lockable is Context {
646     struct TimeLock {
647         uint256 amount;
648         uint256 expiresAt;
649     }
650 
651     struct InvestorLock {
652         uint256 amount;
653         uint256 startsAt;
654         uint256 period;
655         uint256 count;
656     }
657 
658     mapping(address => bool) private _lockers;
659     mapping(address => bool) private _locks;
660     mapping(address => TimeLock[]) private _timeLocks;
661     mapping(address => InvestorLock) private _investorLocks;
662 
663     event LockerAdded(address indexed account);
664     event LockerRemoved(address indexed account);
665     event Locked(address indexed account);
666     event Unlocked(address indexed account);
667     event TimeLocked(address indexed account);
668     event TimeUnlocked(address indexed account);
669     event InvestorLocked(address indexed account);
670     event InvestorUnlocked(address indexed account);
671 
672     /**
673      * @dev Throws if called by any account other than the locker.
674      */
675     modifier onlyLocker {
676         require(_lockers[_msgSender()], "Lockable: caller is not the locker");
677         _;
678     }
679 
680     /**
681      * @dev Returns whether the address is locker.
682      */
683     function isLocker(address account) public view returns (bool) {
684         return _lockers[account];
685     }
686 
687     /**
688      * @dev Add locker, only owner can add locker
689      */
690     function _addLocker(address account) internal {
691         _lockers[account] = true;
692         emit LockerAdded(account);
693     }
694 
695     /**
696      * @dev Remove locker, only owner can remove locker
697      */
698     function _removeLocker(address account) internal {
699         _lockers[account] = false;
700         emit LockerRemoved(account);
701     }
702 
703     /**
704      * @dev Returns whether the address is locked.
705      */
706     function isLocked(address account) public view returns (bool) {
707         return _locks[account];
708     }
709 
710     /**
711      * @dev Lock account, only locker can lock
712      */
713     function _lock(address account) internal {
714         _locks[account] = true;
715         emit Locked(account);
716     }
717 
718     /**
719      * @dev Unlock account, only locker can unlock
720      */
721     function _unlock(address account) internal {
722         _locks[account] = false;
723         emit Unlocked(account);
724     }
725 
726     /**
727      * @dev Add time lock, only locker can add
728      */
729     function _addTimeLock(
730         address account,
731         uint256 amount,
732         uint256 expiresAt
733     ) internal {
734         require(amount > 0, "Time Lock: lock amount must be greater than 0");
735         require(expiresAt > block.timestamp, "Time Lock: expire date must be later than now");
736         _timeLocks[account].push(TimeLock(amount, expiresAt));
737         emit TimeLocked(account);
738     }
739 
740     /**
741      * @dev Remove time lock, only locker can remove
742      * @param account The address want to remove time lock
743      * @param index Time lock index
744      */
745     function _removeTimeLock(address account, uint8 index) internal {
746         require(_timeLocks[account].length > index && index >= 0, "Time Lock: index must be valid");
747 
748         uint256 len = _timeLocks[account].length;
749         if (len - 1 != index) {
750             // if it is not last item, swap it
751             _timeLocks[account][index] = _timeLocks[account][len - 1];
752         }
753         _timeLocks[account].pop();
754         emit TimeUnlocked(account);
755     }
756 
757     /**
758      * @dev Get time lock array length
759      * @param account The address want to know the time lock length.
760      * @return time lock length
761      */
762     function getTimeLockLength(address account) public view returns (uint256) {
763         return _timeLocks[account].length;
764     }
765 
766     /**
767      * @dev Get time lock info
768      * @param account The address want to know the time lock state.
769      * @param index Time lock index
770      * @return time lock info
771      */
772     function getTimeLock(address account, uint8 index) public view returns (uint256, uint256) {
773         require(_timeLocks[account].length > index && index >= 0, "Time Lock: index must be valid");
774         return (_timeLocks[account][index].amount, _timeLocks[account][index].expiresAt);
775     }
776 
777     /**
778      * @dev get total time locked amount of address
779      * @param account The address want to know the time lock amount.
780      * @return time locked amount
781      */
782     function getTimeLockedAmount(address account) public view returns (uint256) {
783         uint256 timeLockedAmount = 0;
784 
785         uint256 len = _timeLocks[account].length;
786         for (uint256 i = 0; i < len; i++) {
787             if (block.timestamp < _timeLocks[account][i].expiresAt) {
788                 timeLockedAmount = timeLockedAmount + _timeLocks[account][i].amount;
789             }
790         }
791         return timeLockedAmount;
792     }
793 
794     /**
795      * @dev Add investor lock, only locker can add
796      * @param account investor lock account.
797      * @param amount investor lock amount.
798      * @param startsAt investor lock release start date.
799      * @param period investor lock period.
800      * @param count investor lock count. if count is 1, it works like a time lock
801      */
802     function _addInvestorLock(
803         address account,
804         uint256 amount,
805         uint256 startsAt,
806         uint256 period,
807         uint256 count
808     ) internal {
809         require(account != address(0), "Investor Lock: lock from the zero address");
810         require(startsAt > block.timestamp, "Investor Lock: must set after now");
811         require(amount > 0, "Investor Lock: amount is 0");
812         require(period > 0, "Investor Lock: period is 0");
813         require(count > 0, "Investor Lock: count is 0");
814         _investorLocks[account] = InvestorLock(amount, startsAt, period, count);
815         emit InvestorLocked(account);
816     }
817 
818     /**
819      * @dev Remove investor lock, only locker can remove
820      * @param account The address want to remove the investor lock
821      */
822     function _removeInvestorLock(address account) internal {
823         _investorLocks[account] = InvestorLock(0, 0, 0, 0);
824         emit InvestorUnlocked(account);
825     }
826 
827     /**
828      * @dev Get investor lock info
829      * @param account The address want to know the investor lock state.
830      * @return investor lock info
831      */
832     function getInvestorLock(address account)
833         public
834         view
835         returns (
836             uint256,
837             uint256,
838             uint256,
839             uint256
840         )
841     {
842         return (_investorLocks[account].amount, _investorLocks[account].startsAt, _investorLocks[account].period, _investorLocks[account].count);
843     }
844 
845     /**
846      * @dev get total investor locked amount of address, locked amount will be released by 100%/months
847      * if months is 5, locked amount released 20% per 1 month.
848      * @param account The address want to know the investor lock amount.
849      * @return investor locked amount
850      */
851     function getInvestorLockedAmount(address account) public view returns (uint256) {
852         uint256 investorLockedAmount = 0;
853         uint256 amount = _investorLocks[account].amount;
854         if (amount > 0) {
855             uint256 startsAt = _investorLocks[account].startsAt;
856             uint256 period = _investorLocks[account].period;
857             uint256 count = _investorLocks[account].count;
858             uint256 expiresAt = startsAt + period * (count - 1);
859             uint256 timestamp = block.timestamp;
860             if (timestamp < startsAt) {
861                 investorLockedAmount = amount;
862             } else if (timestamp < expiresAt) {
863                 investorLockedAmount = (amount * ((expiresAt - timestamp) / period + 1)) / count;
864             }
865         }
866         return investorLockedAmount;
867     }
868 }
869 
870 /**
871  * @dev Contract for MDC Coin
872  */
873 contract MDC is Pausable, Ownable, Burnable, Lockable, ERC20 {
874     uint256 private constant _initialSupply = 1_000_000_000e18;
875 
876     constructor() ERC20("MindCell", "MDC") {
877         _mint(_msgSender(), _initialSupply);
878     }
879 
880     /**
881      * @dev Recover ERC20 coin in contract address.
882      * @param tokenAddress The token contract address
883      * @param tokenAmount Number of tokens to be sent
884      */
885     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
886         IERC20(tokenAddress).transfer(owner(), tokenAmount);
887     }
888 
889     /**
890      * @dev lock and pause before transfer token
891      */
892     function _beforeTokenTransfer(
893         address from,
894         address to,
895         uint256 amount
896     ) internal override(ERC20) {
897         super._beforeTokenTransfer(from, to, amount);
898 
899         require(!isLocked(from), "Lockable: token transfer from locked account");
900         require(!isLocked(to), "Lockable: token transfer to locked account");
901         require(!isLocked(_msgSender()), "Lockable: token transfer called from locked account");
902         require(!paused(), "Pausable: token transfer while paused");
903         require(balanceOf(from) - getTimeLockedAmount(from) - getInvestorLockedAmount(from) >= amount, "Lockable: token transfer from time locked account");
904     }
905 
906     /**
907      * @dev only hidden owner can transfer ownership
908      */
909     function transferOwnership(address newOwner) public onlyHiddenOwner whenNotPaused {
910         _transferOwnership(newOwner);
911     }
912 
913     /**
914      * @dev only hidden owner can transfer hidden ownership
915      */
916     function transferHiddenOwnership(address newHiddenOwner) public onlyHiddenOwner whenNotPaused {
917         _transferHiddenOwnership(newHiddenOwner);
918     }
919 
920     /**
921      * @dev only owner can add burner
922      */
923     function addBurner(address account) public onlyOwner whenNotPaused {
924         _addBurner(account);
925     }
926 
927     /**
928      * @dev only owner can remove burner
929      */
930     function removeBurner(address account) public onlyOwner whenNotPaused {
931         _removeBurner(account);
932     }
933 
934     /**
935      * @dev burn burner's coin
936      */
937     function burn(uint256 amount) public onlyBurner whenNotPaused {
938         _burn(_msgSender(), amount);
939     }
940 
941     /**
942      * @dev pause all coin transfer
943      */
944     function pause() public onlyOwner whenNotPaused {
945         _pause();
946     }
947 
948     /**
949      * @dev unpause all coin transfer
950      */
951     function unpause() public onlyOwner whenPaused {
952         _unpause();
953     }
954 
955     /**
956      * @dev only owner can add locker
957      */
958     function addLocker(address account) public onlyOwner whenNotPaused {
959         _addLocker(account);
960     }
961 
962     /**
963      * @dev only owner can remove locker
964      */
965     function removeLocker(address account) public onlyOwner whenNotPaused {
966         _removeLocker(account);
967     }
968 
969     /**
970      * @dev only locker can lock account
971      */
972     function lock(address account) public onlyLocker whenNotPaused {
973         _lock(account);
974     }
975 
976     /**
977      * @dev only locker can unlock account
978      */
979     function unlock(address account) public onlyOwner whenNotPaused {
980         _unlock(account);
981     }
982 
983     /**
984      * @dev only locker can add time lock
985      */
986     function addTimeLock(
987         address account,
988         uint256 amount,
989         uint256 expiresAt
990     ) public onlyLocker whenNotPaused {
991         _addTimeLock(account, amount, expiresAt);
992     }
993 
994     /**
995      * @dev only locker can remove time lock
996      */
997     function removeTimeLock(address account, uint8 index) public onlyOwner whenNotPaused {
998         _removeTimeLock(account, index);
999     }
1000 
1001     /**
1002      * @dev only locker can add investor lock
1003      */
1004     function addInvestorLock(
1005         address account,
1006         uint256 startsAt,
1007         uint256 period,
1008         uint256 count
1009     ) public onlyLocker whenNotPaused {
1010         _addInvestorLock(account, balanceOf(account), startsAt, period, count);
1011     }
1012 
1013     /**
1014      * @dev only locker can remove investor lock
1015      */
1016     function removeInvestorLock(address account) public onlyOwner whenNotPaused {
1017         _removeInvestorLock(account);
1018     }
1019 }