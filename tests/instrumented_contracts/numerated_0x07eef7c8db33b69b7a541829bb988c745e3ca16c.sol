1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
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
26 
27 
28 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
29 
30 
31 
32 
33 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
34 
35 
36 
37 
38 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
39 
40 
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP.
44  */
45 interface IERC20 {
46     /**
47      * @dev Emitted when `value` tokens are moved from one account (`from`) to
48      * another (`to`).
49      *
50      * Note that `value` may be zero.
51      */
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     /**
55      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
56      * a call to {approve}. `value` is the new allowance.
57      */
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 
60     /**
61      * @dev Returns the amount of tokens in existence.
62      */
63     function totalSupply() external view returns (uint256);
64 
65     /**
66      * @dev Returns the amount of tokens owned by `account`.
67      */
68     function balanceOf(address account) external view returns (uint256);
69 
70     /**
71      * @dev Moves `amount` tokens from the caller's account to `to`.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transfer(address to, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Returns the remaining number of tokens that `spender` will be
81      * allowed to spend on behalf of `owner` through {transferFrom}. This is
82      * zero by default.
83      *
84      * This value changes when {approve} or {transferFrom} are called.
85      */
86     function allowance(address owner, address spender) external view returns (uint256);
87 
88     /**
89      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * IMPORTANT: Beware that changing an allowance with this method brings the risk
94      * that someone may use both the old and the new allowance by unfortunate
95      * transaction ordering. One possible solution to mitigate this race
96      * condition is to first reduce the spender's allowance to 0 and set the
97      * desired value afterwards:
98      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
99      *
100      * Emits an {Approval} event.
101      */
102     function approve(address spender, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Moves `amount` tokens from `from` to `to` using the
106      * allowance mechanism. `amount` is then deducted from the caller's
107      * allowance.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transferFrom(
114         address from,
115         address to,
116         uint256 amount
117     ) external returns (bool);
118 }
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
122 
123 
124 
125 
126 
127 /**
128  * @dev Interface for the optional metadata functions from the ERC20 standard.
129  *
130  * _Available since v4.1._
131  */
132 interface IERC20Metadata is IERC20 {
133     /**
134      * @dev Returns the name of the token.
135      */
136     function name() external view returns (string memory);
137 
138     /**
139      * @dev Returns the symbol of the token.
140      */
141     function symbol() external view returns (string memory);
142 
143     /**
144      * @dev Returns the decimals places of the token.
145      */
146     function decimals() external view returns (uint8);
147 }
148 
149 
150 
151 /**
152  * @dev Implementation of the {IERC20} interface.
153  *
154  * This implementation is agnostic to the way tokens are created. This means
155  * that a supply mechanism has to be added in a derived contract using {_mint}.
156  * For a generic mechanism see {ERC20PresetMinterPauser}.
157  *
158  * TIP: For a detailed writeup see our guide
159  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
160  * to implement supply mechanisms].
161  *
162  * We have followed general OpenZeppelin Contracts guidelines: functions revert
163  * instead returning `false` on failure. This behavior is nonetheless
164  * conventional and does not conflict with the expectations of ERC20
165  * applications.
166  *
167  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
168  * This allows applications to reconstruct the allowance for all accounts just
169  * by listening to said events. Other implementations of the EIP may not emit
170  * these events, as it isn't required by the specification.
171  *
172  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
173  * functions have been added to mitigate the well-known issues around setting
174  * allowances. See {IERC20-approve}.
175  */
176 contract ERC20 is Context, IERC20, IERC20Metadata {
177     mapping(address => uint256) private _balances;
178 
179     mapping(address => mapping(address => uint256)) private _allowances;
180 
181     uint256 private _totalSupply;
182 
183     string private _name;
184     string private _symbol;
185 
186     /**
187      * @dev Sets the values for {name} and {symbol}.
188      *
189      * The default value of {decimals} is 18. To select a different value for
190      * {decimals} you should overload it.
191      *
192      * All two of these values are immutable: they can only be set once during
193      * construction.
194      */
195     constructor(string memory name_, string memory symbol_) {
196         _name = name_;
197         _symbol = symbol_;
198     }
199 
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view virtual override returns (string memory) {
204         return _name;
205     }
206 
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214 
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if `decimals` equals `2`, a balance of `505` tokens should
218      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei. This is the value {ERC20} uses, unless this function is
222      * overridden;
223      *
224      * NOTE: This information is only used for _display_ purposes: it in
225      * no way affects any of the arithmetic of the contract, including
226      * {IERC20-balanceOf} and {IERC20-transfer}.
227      */
228     function decimals() public view virtual override returns (uint8) {
229         return 18;
230     }
231 
232     /**
233      * @dev See {IERC20-totalSupply}.
234      */
235     function totalSupply() public view virtual override returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(address account) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See {IERC20-transfer}.
248      *
249      * Requirements:
250      *
251      * - `to` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address to, uint256 amount) public virtual override returns (bool) {
255         address owner = _msgSender();
256         _transfer(owner, to, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
271      * `transferFrom`. This is semantically equivalent to an infinite approval.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 amount) public virtual override returns (bool) {
278         address owner = _msgSender();
279         _approve(owner, spender, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-transferFrom}.
285      *
286      * Emits an {Approval} event indicating the updated allowance. This is not
287      * required by the EIP. See the note at the beginning of {ERC20}.
288      *
289      * NOTE: Does not update the allowance if the current allowance
290      * is the maximum `uint256`.
291      *
292      * Requirements:
293      *
294      * - `from` and `to` cannot be the zero address.
295      * - `from` must have a balance of at least `amount`.
296      * - the caller must have allowance for ``from``'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(
300         address from,
301         address to,
302         uint256 amount
303     ) public virtual override returns (bool) {
304         address spender = _msgSender();
305         _spendAllowance(from, spender, amount);
306         _transfer(from, to, amount);
307         return true;
308     }
309 
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
323         address owner = _msgSender();
324         _approve(owner, spender, allowance(owner, spender) + addedValue);
325         return true;
326     }
327 
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         address owner = _msgSender();
344         uint256 currentAllowance = allowance(owner, spender);
345         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
346         unchecked {
347             _approve(owner, spender, currentAllowance - subtractedValue);
348         }
349 
350         return true;
351     }
352 
353     /**
354      * @dev Moves `amount` of tokens from `sender` to `recipient`.
355      *
356      * This internal function is equivalent to {transfer}, and can be used to
357      * e.g. implement automatic token fees, slashing mechanisms, etc.
358      *
359      * Emits a {Transfer} event.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `from` must have a balance of at least `amount`.
366      */
367     function _transfer(
368         address from,
369         address to,
370         uint256 amount
371     ) internal virtual {
372         require(from != address(0), "ERC20: transfer from the zero address");
373         require(to != address(0), "ERC20: transfer to the zero address");
374 
375         _beforeTokenTransfer(from, to, amount);
376 
377         uint256 fromBalance = _balances[from];
378         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
379         unchecked {
380             _balances[from] = fromBalance - amount;
381         }
382         _balances[to] += amount;
383 
384         emit Transfer(from, to, amount);
385 
386         _afterTokenTransfer(from, to, amount);
387     }
388 
389     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
390      * the total supply.
391      *
392      * Emits a {Transfer} event with `from` set to the zero address.
393      *
394      * Requirements:
395      *
396      * - `account` cannot be the zero address.
397      */
398     function _mint(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: mint to the zero address");
400 
401         _beforeTokenTransfer(address(0), account, amount);
402 
403         _totalSupply += amount;
404         _balances[account] += amount;
405         emit Transfer(address(0), account, amount);
406 
407         _afterTokenTransfer(address(0), account, amount);
408     }
409 
410     /**
411      * @dev Destroys `amount` tokens from `account`, reducing the
412      * total supply.
413      *
414      * Emits a {Transfer} event with `to` set to the zero address.
415      *
416      * Requirements:
417      *
418      * - `account` cannot be the zero address.
419      * - `account` must have at least `amount` tokens.
420      */
421     function _burn(address account, uint256 amount) internal virtual {
422         require(account != address(0), "ERC20: burn from the zero address");
423 
424         _beforeTokenTransfer(account, address(0), amount);
425 
426         uint256 accountBalance = _balances[account];
427         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
428         unchecked {
429             _balances[account] = accountBalance - amount;
430         }
431         _totalSupply -= amount;
432 
433         emit Transfer(account, address(0), amount);
434 
435         _afterTokenTransfer(account, address(0), amount);
436     }
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
440      *
441      * This internal function is equivalent to `approve`, and can be used to
442      * e.g. set automatic allowances for certain subsystems, etc.
443      *
444      * Emits an {Approval} event.
445      *
446      * Requirements:
447      *
448      * - `owner` cannot be the zero address.
449      * - `spender` cannot be the zero address.
450      */
451     function _approve(
452         address owner,
453         address spender,
454         uint256 amount
455     ) internal virtual {
456         require(owner != address(0), "ERC20: approve from the zero address");
457         require(spender != address(0), "ERC20: approve to the zero address");
458 
459         _allowances[owner][spender] = amount;
460         emit Approval(owner, spender, amount);
461     }
462 
463     /**
464      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
465      *
466      * Does not update the allowance amount in case of infinite allowance.
467      * Revert if not enough allowance is available.
468      *
469      * Might emit an {Approval} event.
470      */
471     function _spendAllowance(
472         address owner,
473         address spender,
474         uint256 amount
475     ) internal virtual {
476         uint256 currentAllowance = allowance(owner, spender);
477         if (currentAllowance != type(uint256).max) {
478             require(currentAllowance >= amount, "ERC20: insufficient allowance");
479             unchecked {
480                 _approve(owner, spender, currentAllowance - amount);
481             }
482         }
483     }
484 
485     /**
486      * @dev Hook that is called before any transfer of tokens. This includes
487      * minting and burning.
488      *
489      * Calling conditions:
490      *
491      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
492      * will be transferred to `to`.
493      * - when `from` is zero, `amount` tokens will be minted for `to`.
494      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
495      * - `from` and `to` are never both zero.
496      *
497      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
498      */
499     function _beforeTokenTransfer(
500         address from,
501         address to,
502         uint256 amount
503     ) internal virtual {}
504 
505     /**
506      * @dev Hook that is called after any transfer of tokens. This includes
507      * minting and burning.
508      *
509      * Calling conditions:
510      *
511      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
512      * has been transferred to `to`.
513      * - when `from` is zero, `amount` tokens have been minted for `to`.
514      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
515      * - `from` and `to` are never both zero.
516      *
517      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
518      */
519     function _afterTokenTransfer(
520         address from,
521         address to,
522         uint256 amount
523     ) internal virtual {}
524 }
525 
526 
527 
528 /**
529  * @dev Extension of {ERC20} that allows token holders to destroy both their own
530  * tokens and those that they have an allowance for, in a way that can be
531  * recognized off-chain (via event analysis).
532  */
533 abstract contract ERC20Burnable is Context, ERC20 {
534     /**
535      * @dev Destroys `amount` tokens from the caller.
536      *
537      * See {ERC20-_burn}.
538      */
539     function burn(uint256 amount) public virtual {
540         _burn(_msgSender(), amount);
541     }
542 
543     /**
544      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
545      * allowance.
546      *
547      * See {ERC20-_burn} and {ERC20-allowance}.
548      *
549      * Requirements:
550      *
551      * - the caller must have allowance for ``accounts``'s tokens of at least
552      * `amount`.
553      */
554     function burnFrom(address account, uint256 amount) public virtual {
555         _spendAllowance(account, _msgSender(), amount);
556         _burn(account, amount);
557     }
558 }
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
562 
563 
564 
565 
566 
567 /**
568  * @dev Contract module which allows children to implement an emergency stop
569  * mechanism that can be triggered by an authorized account.
570  *
571  * This module is used through inheritance. It will make available the
572  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
573  * the functions of your contract. Note that they will not be pausable by
574  * simply including this module, only once the modifiers are put in place.
575  */
576 abstract contract Pausable is Context {
577     /**
578      * @dev Emitted when the pause is triggered by `account`.
579      */
580     event Paused(address account);
581 
582     /**
583      * @dev Emitted when the pause is lifted by `account`.
584      */
585     event Unpaused(address account);
586 
587     bool private _paused;
588 
589     /**
590      * @dev Initializes the contract in unpaused state.
591      */
592     constructor() {
593         _paused = false;
594     }
595 
596     /**
597      * @dev Returns true if the contract is paused, and false otherwise.
598      */
599     function paused() public view virtual returns (bool) {
600         return _paused;
601     }
602 
603     /**
604      * @dev Modifier to make a function callable only when the contract is not paused.
605      *
606      * Requirements:
607      *
608      * - The contract must not be paused.
609      */
610     modifier whenNotPaused() {
611         require(!paused(), "Pausable: paused");
612         _;
613     }
614 
615     /**
616      * @dev Modifier to make a function callable only when the contract is paused.
617      *
618      * Requirements:
619      *
620      * - The contract must be paused.
621      */
622     modifier whenPaused() {
623         require(paused(), "Pausable: not paused");
624         _;
625     }
626 
627     /**
628      * @dev Triggers stopped state.
629      *
630      * Requirements:
631      *
632      * - The contract must not be paused.
633      */
634     function _pause() internal virtual whenNotPaused {
635         _paused = true;
636         emit Paused(_msgSender());
637     }
638 
639     /**
640      * @dev Returns to normal state.
641      *
642      * Requirements:
643      *
644      * - The contract must be paused.
645      */
646     function _unpause() internal virtual whenPaused {
647         _paused = false;
648         emit Unpaused(_msgSender());
649     }
650 }
651 
652 
653 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
654 
655 
656 
657 
658 
659 /**
660  * @dev Contract module which provides a basic access control mechanism, where
661  * there is an account (an owner) that can be granted exclusive access to
662  * specific functions.
663  *
664  * By default, the owner account will be the one that deploys the contract. This
665  * can later be changed with {transferOwnership}.
666  *
667  * This module is used through inheritance. It will make available the modifier
668  * `onlyOwner`, which can be applied to your functions to restrict their use to
669  * the owner.
670  */
671 abstract contract Ownable is Context {
672     address private _owner;
673 
674     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
675 
676     /**
677      * @dev Initializes the contract setting the deployer as the initial owner.
678      */
679     constructor() {
680         _transferOwnership(_msgSender());
681     }
682 
683     /**
684      * @dev Returns the address of the current owner.
685      */
686     function owner() public view virtual returns (address) {
687         return _owner;
688     }
689 
690     /**
691      * @dev Throws if called by any account other than the owner.
692      */
693     modifier onlyOwner() {
694         require(owner() == _msgSender(), "Ownable: caller is not the owner");
695         _;
696     }
697 
698     /**
699      * @dev Leaves the contract without owner. It will not be possible to call
700      * `onlyOwner` functions anymore. Can only be called by the current owner.
701      *
702      * NOTE: Renouncing ownership will leave the contract without an owner,
703      * thereby removing any functionality that is only available to the owner.
704      */
705     function renounceOwnership() public virtual onlyOwner {
706         _transferOwnership(address(0));
707     }
708 
709     /**
710      * @dev Transfers ownership of the contract to a new account (`newOwner`).
711      * Can only be called by the current owner.
712      */
713     function transferOwnership(address newOwner) public virtual onlyOwner {
714         require(newOwner != address(0), "Ownable: new owner is the zero address");
715         _transferOwnership(newOwner);
716     }
717 
718     /**
719      * @dev Transfers ownership of the contract to a new account (`newOwner`).
720      * Internal function without access restriction.
721      */
722     function _transferOwnership(address newOwner) internal virtual {
723         address oldOwner = _owner;
724         _owner = newOwner;
725         emit OwnershipTransferred(oldOwner, newOwner);
726     }
727 }
728 
729 
730 
731 
732 
733 
734 
735 contract Freezable is Ownable {
736     mapping(address => bool) blacklist;
737         
738     event FreezeAccount(address indexed who);
739     event UnFreezeAccount(address indexed who);
740 
741     modifier unFreezedAccountOnly(address from) {
742         require(!blacklist[from], "Freezed user");
743         _;
744     }
745     
746     function freezeAccount(address who) public onlyOwner {
747         blacklist[who] = true;
748         
749         emit FreezeAccount(who);
750     }
751 
752     function unFreezeAccount(address who) public onlyOwner {
753         blacklist[who] = false;
754         
755         emit UnFreezeAccount(who);
756     }
757 
758     function isAccountFrozen(address who) view external returns(bool){
759         return blacklist[who];
760     }
761 }
762 
763 
764 
765 
766 
767 
768 contract Lockable is Ownable {
769     mapping(address => uint256) lockedList;
770         
771     event LockAccount(address indexed who);
772     event UnlockAccount(address indexed who);
773 
774     modifier unlockedAccountOnly(address from) {
775         require(lockedList[from] < block.timestamp, "Locked user");
776         _;
777     }
778     
779     function lockAccount(address who, uint256 unlockTime) public onlyOwner {
780         lockedList[who] = unlockTime;
781         
782         emit LockAccount(who);
783     }
784 
785     function unlockAccount(address who) public onlyOwner {
786         lockedList[who] = 0;
787         
788         emit UnlockAccount(who);
789     }
790 
791     function lockedAccount(address who) view external returns(uint256) {
792         return lockedList[who];
793     }
794 
795     function isAccountLocked(address who) view external returns(bool) {
796         if(lockedList[who] >= block.timestamp){
797             return true;
798         }else{
799             return false;
800         }
801     }
802 }
803 
804 
805 contract BananaTok is ERC20Burnable, Pausable, Freezable, Lockable {
806     /* 
807         renounceOwnership, transferOwnership
808         burn, burnFrom
809         pause/unpause 
810         account 별 freeze/unfreeze ? lock/unlock
811     */
812     constructor(address account, uint initialSupply) ERC20("BANANATOK", "BNA"){ // name, symbol
813         _mint(account, initialSupply * 10 ** decimals());
814     }
815 
816     function pause() external onlyOwner{
817         _pause();
818     }
819 
820     function unpause() external onlyOwner{
821         _unpause();
822     }
823 
824     function isOwner() external view returns(bool) {
825         return msg.sender==owner();
826     }
827 
828     function _beforeTokenTransfer(
829         address from,
830         address to,
831         uint256 amount
832     ) internal override unFreezedAccountOnly(from) unlockedAccountOnly(from) {
833         require(!paused(), "Can't transfer while paused!");
834         // check locked
835         // check freezed
836     }
837     
838 }