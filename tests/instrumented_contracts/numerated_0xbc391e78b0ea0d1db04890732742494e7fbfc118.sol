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
28 // File: @openzeppelin/contracts/security/Pausable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which allows children to implement an emergency stop
38  * mechanism that can be triggered by an authorized account.
39  *
40  * This module is used through inheritance. It will make available the
41  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
42  * the functions of your contract. Note that they will not be pausable by
43  * simply including this module, only once the modifiers are put in place.
44  */
45 abstract contract Pausable is Context {
46     /**
47      * @dev Emitted when the pause is triggered by `account`.
48      */
49     event Paused(address account);
50 
51     /**
52      * @dev Emitted when the pause is lifted by `account`.
53      */
54     event Unpaused(address account);
55 
56     bool private _paused;
57 
58     /**
59      * @dev Initializes the contract in unpaused state.
60      */
61     constructor() {
62         _paused = false;
63     }
64 
65     /**
66      * @dev Modifier to make a function callable only when the contract is not paused.
67      *
68      * Requirements:
69      *
70      * - The contract must not be paused.
71      */
72     modifier whenNotPaused() {
73         _requireNotPaused();
74         _;
75     }
76 
77     /**
78      * @dev Modifier to make a function callable only when the contract is paused.
79      *
80      * Requirements:
81      *
82      * - The contract must be paused.
83      */
84     modifier whenPaused() {
85         _requirePaused();
86         _;
87     }
88 
89     /**
90      * @dev Returns true if the contract is paused, and false otherwise.
91      */
92     function paused() public view virtual returns (bool) {
93         return _paused;
94     }
95 
96     /**
97      * @dev Throws if the contract is paused.
98      */
99     function _requireNotPaused() internal view virtual {
100         require(!paused(), "Pausable: paused");
101     }
102 
103     /**
104      * @dev Throws if the contract is not paused.
105      */
106     function _requirePaused() internal view virtual {
107         require(paused(), "Pausable: not paused");
108     }
109 
110     /**
111      * @dev Triggers stopped state.
112      *
113      * Requirements:
114      *
115      * - The contract must not be paused.
116      */
117     function _pause() internal virtual whenNotPaused {
118         _paused = true;
119         emit Paused(_msgSender());
120     }
121 
122     /**
123      * @dev Returns to normal state.
124      *
125      * Requirements:
126      *
127      * - The contract must be paused.
128      */
129     function _unpause() internal virtual whenPaused {
130         _paused = false;
131         emit Unpaused(_msgSender());
132     }
133 }
134 
135 // File: @openzeppelin/contracts/access/Ownable.sol
136 
137 
138 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 
143 /**
144  * @dev Contract module which provides a basic access control mechanism, where
145  * there is an account (an owner) that can be granted exclusive access to
146  * specific functions.
147  *
148  * By default, the owner account will be the one that deploys the contract. This
149  * can later be changed with {transferOwnership}.
150  *
151  * This module is used through inheritance. It will make available the modifier
152  * `onlyOwner`, which can be applied to your functions to restrict their use to
153  * the owner.
154  */
155 abstract contract Ownable is Context {
156     address private _owner;
157 
158     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159 
160     /**
161      * @dev Initializes the contract setting the deployer as the initial owner.
162      */
163     constructor() {
164         _transferOwnership(_msgSender());
165     }
166 
167     /**
168      * @dev Throws if called by any account other than the owner.
169      */
170     modifier onlyOwner() {
171         _checkOwner();
172         _;
173     }
174 
175     /**
176      * @dev Returns the address of the current owner.
177      */
178     function owner() public view virtual returns (address) {
179         return _owner;
180     }
181 
182     /**
183      * @dev Throws if the sender is not the owner.
184      */
185     function _checkOwner() internal view virtual {
186         require(owner() == _msgSender(), "Ownable: caller is not the owner");
187     }
188 
189     /**
190      * @dev Leaves the contract without owner. It will not be possible to call
191      * `onlyOwner` functions anymore. Can only be called by the current owner.
192      *
193      * NOTE: Renouncing ownership will leave the contract without an owner,
194      * thereby removing any functionality that is only available to the owner.
195      */
196     function renounceOwnership() public virtual onlyOwner {
197         _transferOwnership(address(0));
198     }
199 
200     /**
201      * @dev Transfers ownership of the contract to a new account (`newOwner`).
202      * Can only be called by the current owner.
203      */
204     function transferOwnership(address newOwner) public virtual onlyOwner {
205         require(newOwner != address(0), "Ownable: new owner is the zero address");
206         _transferOwnership(newOwner);
207     }
208 
209     /**
210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
211      * Internal function without access restriction.
212      */
213     function _transferOwnership(address newOwner) internal virtual {
214         address oldOwner = _owner;
215         _owner = newOwner;
216         emit OwnershipTransferred(oldOwner, newOwner);
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
338 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
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
353  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
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
575             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
576             // decrementing then incrementing.
577             _balances[to] += amount;
578         }
579 
580         emit Transfer(from, to, amount);
581 
582         _afterTokenTransfer(from, to, amount);
583     }
584 
585     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
586      * the total supply.
587      *
588      * Emits a {Transfer} event with `from` set to the zero address.
589      *
590      * Requirements:
591      *
592      * - `account` cannot be the zero address.
593      */
594     function _mint(address account, uint256 amount) internal virtual {
595         require(account != address(0), "ERC20: mint to the zero address");
596 
597         _beforeTokenTransfer(address(0), account, amount);
598 
599         _totalSupply += amount;
600         unchecked {
601             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
602             _balances[account] += amount;
603         }
604         emit Transfer(address(0), account, amount);
605 
606         _afterTokenTransfer(address(0), account, amount);
607     }
608 
609     /**
610      * @dev Destroys `amount` tokens from `account`, reducing the
611      * total supply.
612      *
613      * Emits a {Transfer} event with `to` set to the zero address.
614      *
615      * Requirements:
616      *
617      * - `account` cannot be the zero address.
618      * - `account` must have at least `amount` tokens.
619      */
620     function _burn(address account, uint256 amount) internal virtual {
621         require(account != address(0), "ERC20: burn from the zero address");
622 
623         _beforeTokenTransfer(account, address(0), amount);
624 
625         uint256 accountBalance = _balances[account];
626         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
627         unchecked {
628             _balances[account] = accountBalance - amount;
629             // Overflow not possible: amount <= accountBalance <= totalSupply.
630             _totalSupply -= amount;
631         }
632 
633         emit Transfer(account, address(0), amount);
634 
635         _afterTokenTransfer(account, address(0), amount);
636     }
637 
638     /**
639      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
640      *
641      * This internal function is equivalent to `approve`, and can be used to
642      * e.g. set automatic allowances for certain subsystems, etc.
643      *
644      * Emits an {Approval} event.
645      *
646      * Requirements:
647      *
648      * - `owner` cannot be the zero address.
649      * - `spender` cannot be the zero address.
650      */
651     function _approve(
652         address owner,
653         address spender,
654         uint256 amount
655     ) internal virtual {
656         require(owner != address(0), "ERC20: approve from the zero address");
657         require(spender != address(0), "ERC20: approve to the zero address");
658 
659         _allowances[owner][spender] = amount;
660         emit Approval(owner, spender, amount);
661     }
662 
663     /**
664      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
665      *
666      * Does not update the allowance amount in case of infinite allowance.
667      * Revert if not enough allowance is available.
668      *
669      * Might emit an {Approval} event.
670      */
671     function _spendAllowance(
672         address owner,
673         address spender,
674         uint256 amount
675     ) internal virtual {
676         uint256 currentAllowance = allowance(owner, spender);
677         if (currentAllowance != type(uint256).max) {
678             require(currentAllowance >= amount, "ERC20: insufficient allowance");
679             unchecked {
680                 _approve(owner, spender, currentAllowance - amount);
681             }
682         }
683     }
684 
685     /**
686      * @dev Hook that is called before any transfer of tokens. This includes
687      * minting and burning.
688      *
689      * Calling conditions:
690      *
691      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
692      * will be transferred to `to`.
693      * - when `from` is zero, `amount` tokens will be minted for `to`.
694      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
695      * - `from` and `to` are never both zero.
696      *
697      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
698      */
699     function _beforeTokenTransfer(
700         address from,
701         address to,
702         uint256 amount
703     ) internal virtual {}
704 
705     /**
706      * @dev Hook that is called after any transfer of tokens. This includes
707      * minting and burning.
708      *
709      * Calling conditions:
710      *
711      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
712      * has been transferred to `to`.
713      * - when `from` is zero, `amount` tokens have been minted for `to`.
714      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
715      * - `from` and `to` are never both zero.
716      *
717      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
718      */
719     function _afterTokenTransfer(
720         address from,
721         address to,
722         uint256 amount
723     ) internal virtual {}
724 }
725 
726 // File: VanaToken.sol
727 
728 
729 pragma solidity ^0.8.0;
730 
731 
732 
733 
734 contract HasMinters is Ownable {
735     event MinterAdded(address indexed _minter);
736     event MinterRemoved(address indexed _minter);
737 
738     address[] public minters;
739     mapping(address => bool) public minter;
740 
741     modifier onlyMinter() {
742         require(minter[msg.sender], "invalid minter");
743         _;
744     }
745 
746     function addMinters(address[] memory _addedMinters) public onlyOwner {
747         address _minter;
748 
749         for (uint256 i = 0; i < _addedMinters.length; i++) {
750             _minter = _addedMinters[i];
751 
752             if (!minter[_minter]) {
753                 minters.push(_minter);
754                 minter[_minter] = true;
755                 emit MinterAdded(_minter);
756             }
757         }
758     }
759 
760     function removeMinters(address[] memory _removedMinters) public onlyOwner {
761         address _minter;
762 
763         for (uint256 it = 0; it < _removedMinters.length; it++) {
764             _minter = _removedMinters[it];
765 
766             if (minter[_minter]) {
767                 minter[_minter] = false;
768                 emit MinterRemoved(_minter);
769             }
770         }
771 
772         uint256 i = 0;
773 
774         while (i < minters.length) {
775             _minter = minters[i];
776 
777             if (!minter[_minter]) {
778                 minters[i] = minters[minters.length - 1];
779                 delete minters[minters.length - 1];
780                 // minters.length--;
781             } else {
782                 i++;
783             }
784         }
785     }
786 
787     function isMinter(address _addr) public view returns (bool) {
788         return minter[_addr];
789     }
790 }
791 
792 contract VanaToken is ERC20, Pausable, Ownable, HasMinters {
793      
794     // @pram
795     // _name coin Vana
796     // _symbol coin VANA
797     // _amount 1,000,000,000
798     
799     constructor(
800         string memory _name,
801         string memory _symbol,
802         uint256 _amount
803     ) ERC20(_name, _symbol) {
804         setMaxSupply(_amount * 10**decimals());
805         _mint(_msgSender(), maxSupply());
806     }
807 
808     function maxSupply() public view returns (uint256) {
809         return _maxSupply;
810     }
811 
812     uint256 private _maxSupply;
813 
814     function setMaxSupply(uint256 amount) internal onlyOwner {
815         _maxSupply = amount;
816     }
817 
818     function burn(uint256 amount) public virtual {
819         _burn(_msgSender(), amount);
820     }
821 
822     function mint(address to, uint256 amount) public virtual onlyMinter {
823         require(totalSupply() + amount <= _maxSupply, "over maxSupply");
824         _mint(to, amount);
825     }
826 
827     function burnFrom(address account, uint256 amount) public virtual {
828         uint256 currentAllowance = allowance(account, _msgSender());
829         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
830         unchecked {
831             _approve(account, _msgSender(), currentAllowance - amount);
832         }
833         _burn(account, amount);
834     }
835 
836     function _beforeTokenTransfer(
837         address from,
838         address to,
839         uint256 amount
840     ) internal virtual override {
841         super._beforeTokenTransfer(from, to, amount);
842 
843         require(!paused(), "ERC20Pausable: token transfer while paused");
844     }
845 
846     function stop() public onlyOwner {
847         _pause();
848     }
849 
850     function start() public onlyOwner {
851         _unpause();
852     }
853     
854 }