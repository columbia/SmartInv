1 // File: @openzeppelin/contracts@4.6.0/utils/Context.sol
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
28 // File: @openzeppelin/contracts@4.6.0/security/Pausable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
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
66      * @dev Returns true if the contract is paused, and false otherwise.
67      */
68     function paused() public view virtual returns (bool) {
69         return _paused;
70     }
71 
72     /**
73      * @dev Modifier to make a function callable only when the contract is not paused.
74      *
75      * Requirements:
76      *
77      * - The contract must not be paused.
78      */
79     modifier whenNotPaused() {
80         require(!paused(), "Pausable: paused");
81         _;
82     }
83 
84     /**
85      * @dev Modifier to make a function callable only when the contract is paused.
86      *
87      * Requirements:
88      *
89      * - The contract must be paused.
90      */
91     modifier whenPaused() {
92         require(paused(), "Pausable: not paused");
93         _;
94     }
95 
96     /**
97      * @dev Triggers stopped state.
98      *
99      * Requirements:
100      *
101      * - The contract must not be paused.
102      */
103     function _pause() internal virtual whenNotPaused {
104         _paused = true;
105         emit Paused(_msgSender());
106     }
107 
108     /**
109      * @dev Returns to normal state.
110      *
111      * Requirements:
112      *
113      * - The contract must be paused.
114      */
115     function _unpause() internal virtual whenPaused {
116         _paused = false;
117         emit Unpaused(_msgSender());
118     }
119 }
120 
121 // File: @openzeppelin/contracts@4.6.0/access/Ownable.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 
129 /**
130  * @dev Contract module which provides a basic access control mechanism, where
131  * there is an account (an owner) that can be granted exclusive access to
132  * specific functions.
133  *
134  * By default, the owner account will be the one that deploys the contract. This
135  * can later be changed with {transferOwnership}.
136  *
137  * This module is used through inheritance. It will make available the modifier
138  * `onlyOwner`, which can be applied to your functions to restrict their use to
139  * the owner.
140  */
141 abstract contract Ownable is Context {
142     address private _owner;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145 
146     /**
147      * @dev Initializes the contract setting the deployer as the initial owner.
148      */
149     constructor() {
150         _transferOwnership(_msgSender());
151     }
152 
153     /**
154      * @dev Returns the address of the current owner.
155      */
156     function owner() public view virtual returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         require(owner() == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions anymore. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby removing any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public virtual onlyOwner {
176         _transferOwnership(address(0));
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Can only be called by the current owner.
182      */
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         _transferOwnership(newOwner);
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Internal function without access restriction.
191      */
192     function _transferOwnership(address newOwner) internal virtual {
193         address oldOwner = _owner;
194         _owner = newOwner;
195         emit OwnershipTransferred(oldOwner, newOwner);
196     }
197 }
198 
199 // File: Blacklist.sol
200 
201 
202 pragma solidity ^0.8.10;
203 
204 
205 /**
206  * @title Blacklist
207  * @dev The Blacklist contract has a blacklist of addresses, and provides basic authorization control functions.
208  * @dev This simplifies the implementation of "user permissions".
209  */
210 contract Blacklist is Ownable {
211   mapping(address => bool) blacklist;
212   address[] public blacklistAddresses;
213 
214   event BlacklistedAddressAdded(address addr);
215   event BlacklistedAddressRemoved(address addr);
216 
217   /**
218    * @dev Throws if called by any account that's whitelist (a.k.a not blacklist)
219    */
220   modifier isBlacklisted() {
221     require(blacklist[msg.sender]);
222     _;
223   }
224 
225   /**
226    * @dev Throws if called by any account that's blacklist.
227    */
228   modifier isNotBlacklisted() {
229     require(!blacklist[msg.sender]);
230     _;
231   }
232 
233   /**
234    * @dev Add an address to the blacklist
235    * @param addr address
236    * @return success true if the address was added to the blacklist, false if the address was already in the blacklist
237    */
238   function addAddressToBlacklist(address addr) public onlyOwner returns (bool success) {
239     if (!blacklist[addr]) {
240       blacklistAddresses.push(addr);
241       blacklist[addr] = true;
242       emit BlacklistedAddressAdded(addr);
243       success = true;
244     }
245   }
246 
247   /**
248    * @dev Add addresses to the blacklist
249    * @param addrs addresses
250    * @return success true if at least one address was added to the blacklist,
251    * false if all addresses were already in the blacklist
252    */
253   function addAddressesToBlacklist(address[] memory addrs) public onlyOwner returns (bool success) {
254     for (uint256 i = 0; i < addrs.length; i++) {
255       if (addAddressToBlacklist(addrs[i])) {
256         success = true;
257       }
258     }
259   }
260 
261   /**
262    * @dev Remove an address from the blacklist
263    * @param addr address
264    * @return success true if the address was removed from the blacklist,
265    * false if the address wasn't in the blacklist in the first place
266    */
267   function removeAddressFromBlacklist(address addr) public onlyOwner returns (bool success) {
268     if (blacklist[addr]) {
269       blacklist[addr] = false;
270       for (uint256 i = 0; i < blacklistAddresses.length; i++) {
271         if (addr == blacklistAddresses[i]) {
272           delete blacklistAddresses[i];
273         }
274       }
275       emit BlacklistedAddressRemoved(addr);
276       success = true;
277     }
278   }
279 
280   /**
281    * @dev Remove addresses from the blacklist
282    * @param addrs addresses
283    * @return success true if at least one address was removed from the blacklist,
284    * false if all addresses weren't in the blacklist in the first place
285    */
286   function removeAddressesFromBlacklist(address[] memory addrs)
287     public
288     onlyOwner
289     returns (bool success)
290   {
291     for (uint256 i = 0; i < addrs.length; i++) {
292       if (removeAddressFromBlacklist(addrs[i])) {
293         success = true;
294       }
295     }
296   }
297 
298   /**
299    * @dev Get all blacklist wallet addresses
300    */
301   function getBlacklist() public view returns (address[] memory) {
302     return blacklistAddresses;
303   }
304 }
305 
306 // File: @openzeppelin/contracts@4.6.0/token/ERC20/IERC20.sol
307 
308 
309 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Interface of the ERC20 standard as defined in the EIP.
315  */
316 interface IERC20 {
317     /**
318      * @dev Emitted when `value` tokens are moved from one account (`from`) to
319      * another (`to`).
320      *
321      * Note that `value` may be zero.
322      */
323     event Transfer(address indexed from, address indexed to, uint256 value);
324 
325     /**
326      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
327      * a call to {approve}. `value` is the new allowance.
328      */
329     event Approval(address indexed owner, address indexed spender, uint256 value);
330 
331     /**
332      * @dev Returns the amount of tokens in existence.
333      */
334     function totalSupply() external view returns (uint256);
335 
336     /**
337      * @dev Returns the amount of tokens owned by `account`.
338      */
339     function balanceOf(address account) external view returns (uint256);
340 
341     /**
342      * @dev Moves `amount` tokens from the caller's account to `to`.
343      *
344      * Returns a boolean value indicating whether the operation succeeded.
345      *
346      * Emits a {Transfer} event.
347      */
348     function transfer(address to, uint256 amount) external returns (bool);
349 
350     /**
351      * @dev Returns the remaining number of tokens that `spender` will be
352      * allowed to spend on behalf of `owner` through {transferFrom}. This is
353      * zero by default.
354      *
355      * This value changes when {approve} or {transferFrom} are called.
356      */
357     function allowance(address owner, address spender) external view returns (uint256);
358 
359     /**
360      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * IMPORTANT: Beware that changing an allowance with this method brings the risk
365      * that someone may use both the old and the new allowance by unfortunate
366      * transaction ordering. One possible solution to mitigate this race
367      * condition is to first reduce the spender's allowance to 0 and set the
368      * desired value afterwards:
369      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
370      *
371      * Emits an {Approval} event.
372      */
373     function approve(address spender, uint256 amount) external returns (bool);
374 
375     /**
376      * @dev Moves `amount` tokens from `from` to `to` using the
377      * allowance mechanism. `amount` is then deducted from the caller's
378      * allowance.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * Emits a {Transfer} event.
383      */
384     function transferFrom(
385         address from,
386         address to,
387         uint256 amount
388     ) external returns (bool);
389 }
390 
391 // File: @openzeppelin/contracts@4.6.0/token/ERC20/extensions/IERC20Metadata.sol
392 
393 
394 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 
399 /**
400  * @dev Interface for the optional metadata functions from the ERC20 standard.
401  *
402  * _Available since v4.1._
403  */
404 interface IERC20Metadata is IERC20 {
405     /**
406      * @dev Returns the name of the token.
407      */
408     function name() external view returns (string memory);
409 
410     /**
411      * @dev Returns the symbol of the token.
412      */
413     function symbol() external view returns (string memory);
414 
415     /**
416      * @dev Returns the decimals places of the token.
417      */
418     function decimals() external view returns (uint8);
419 }
420 
421 // File: @openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol
422 
423 
424 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 
429 
430 
431 /**
432  * @dev Implementation of the {IERC20} interface.
433  *
434  * This implementation is agnostic to the way tokens are created. This means
435  * that a supply mechanism has to be added in a derived contract using {_mint}.
436  * For a generic mechanism see {ERC20PresetMinterPauser}.
437  *
438  * TIP: For a detailed writeup see our guide
439  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
440  * to implement supply mechanisms].
441  *
442  * We have followed general OpenZeppelin Contracts guidelines: functions revert
443  * instead returning `false` on failure. This behavior is nonetheless
444  * conventional and does not conflict with the expectations of ERC20
445  * applications.
446  *
447  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
448  * This allows applications to reconstruct the allowance for all accounts just
449  * by listening to said events. Other implementations of the EIP may not emit
450  * these events, as it isn't required by the specification.
451  *
452  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
453  * functions have been added to mitigate the well-known issues around setting
454  * allowances. See {IERC20-approve}.
455  */
456 contract ERC20 is Context, IERC20, IERC20Metadata {
457     mapping(address => uint256) private _balances;
458 
459     mapping(address => mapping(address => uint256)) private _allowances;
460 
461     uint256 private _totalSupply;
462 
463     string private _name;
464     string private _symbol;
465 
466     /**
467      * @dev Sets the values for {name} and {symbol}.
468      *
469      * The default value of {decimals} is 18. To select a different value for
470      * {decimals} you should overload it.
471      *
472      * All two of these values are immutable: they can only be set once during
473      * construction.
474      */
475     constructor(string memory name_, string memory symbol_) {
476         _name = name_;
477         _symbol = symbol_;
478     }
479 
480     /**
481      * @dev Returns the name of the token.
482      */
483     function name() public view virtual override returns (string memory) {
484         return _name;
485     }
486 
487     /**
488      * @dev Returns the symbol of the token, usually a shorter version of the
489      * name.
490      */
491     function symbol() public view virtual override returns (string memory) {
492         return _symbol;
493     }
494 
495     /**
496      * @dev Returns the number of decimals used to get its user representation.
497      * For example, if `decimals` equals `2`, a balance of `505` tokens should
498      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
499      *
500      * Tokens usually opt for a value of 18, imitating the relationship between
501      * Ether and Wei. This is the value {ERC20} uses, unless this function is
502      * overridden;
503      *
504      * NOTE: This information is only used for _display_ purposes: it in
505      * no way affects any of the arithmetic of the contract, including
506      * {IERC20-balanceOf} and {IERC20-transfer}.
507      */
508     function decimals() public view virtual override returns (uint8) {
509         return 18;
510     }
511 
512     /**
513      * @dev See {IERC20-totalSupply}.
514      */
515     function totalSupply() public view virtual override returns (uint256) {
516         return _totalSupply;
517     }
518 
519     /**
520      * @dev See {IERC20-balanceOf}.
521      */
522     function balanceOf(address account) public view virtual override returns (uint256) {
523         return _balances[account];
524     }
525 
526     /**
527      * @dev See {IERC20-transfer}.
528      *
529      * Requirements:
530      *
531      * - `to` cannot be the zero address.
532      * - the caller must have a balance of at least `amount`.
533      */
534     function transfer(address to, uint256 amount) public virtual override returns (bool) {
535         address owner = _msgSender();
536         _transfer(owner, to, amount);
537         return true;
538     }
539 
540     /**
541      * @dev See {IERC20-allowance}.
542      */
543     function allowance(address owner, address spender) public view virtual override returns (uint256) {
544         return _allowances[owner][spender];
545     }
546 
547     /**
548      * @dev See {IERC20-approve}.
549      *
550      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
551      * `transferFrom`. This is semantically equivalent to an infinite approval.
552      *
553      * Requirements:
554      *
555      * - `spender` cannot be the zero address.
556      */
557     function approve(address spender, uint256 amount) public virtual override returns (bool) {
558         address owner = _msgSender();
559         _approve(owner, spender, amount);
560         return true;
561     }
562 
563     /**
564      * @dev See {IERC20-transferFrom}.
565      *
566      * Emits an {Approval} event indicating the updated allowance. This is not
567      * required by the EIP. See the note at the beginning of {ERC20}.
568      *
569      * NOTE: Does not update the allowance if the current allowance
570      * is the maximum `uint256`.
571      *
572      * Requirements:
573      *
574      * - `from` and `to` cannot be the zero address.
575      * - `from` must have a balance of at least `amount`.
576      * - the caller must have allowance for ``from``'s tokens of at least
577      * `amount`.
578      */
579     function transferFrom(
580         address from,
581         address to,
582         uint256 amount
583     ) public virtual override returns (bool) {
584         address spender = _msgSender();
585         _spendAllowance(from, spender, amount);
586         _transfer(from, to, amount);
587         return true;
588     }
589 
590     /**
591      * @dev Atomically increases the allowance granted to `spender` by the caller.
592      *
593      * This is an alternative to {approve} that can be used as a mitigation for
594      * problems described in {IERC20-approve}.
595      *
596      * Emits an {Approval} event indicating the updated allowance.
597      *
598      * Requirements:
599      *
600      * - `spender` cannot be the zero address.
601      */
602     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
603         address owner = _msgSender();
604         _approve(owner, spender, allowance(owner, spender) + addedValue);
605         return true;
606     }
607 
608     /**
609      * @dev Atomically decreases the allowance granted to `spender` by the caller.
610      *
611      * This is an alternative to {approve} that can be used as a mitigation for
612      * problems described in {IERC20-approve}.
613      *
614      * Emits an {Approval} event indicating the updated allowance.
615      *
616      * Requirements:
617      *
618      * - `spender` cannot be the zero address.
619      * - `spender` must have allowance for the caller of at least
620      * `subtractedValue`.
621      */
622     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
623         address owner = _msgSender();
624         uint256 currentAllowance = allowance(owner, spender);
625         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
626         unchecked {
627             _approve(owner, spender, currentAllowance - subtractedValue);
628         }
629 
630         return true;
631     }
632 
633     /**
634      * @dev Moves `amount` of tokens from `sender` to `recipient`.
635      *
636      * This internal function is equivalent to {transfer}, and can be used to
637      * e.g. implement automatic token fees, slashing mechanisms, etc.
638      *
639      * Emits a {Transfer} event.
640      *
641      * Requirements:
642      *
643      * - `from` cannot be the zero address.
644      * - `to` cannot be the zero address.
645      * - `from` must have a balance of at least `amount`.
646      */
647     function _transfer(
648         address from,
649         address to,
650         uint256 amount
651     ) internal virtual {
652         require(from != address(0), "ERC20: transfer from the zero address");
653         require(to != address(0), "ERC20: transfer to the zero address");
654 
655         _beforeTokenTransfer(from, to, amount);
656 
657         uint256 fromBalance = _balances[from];
658         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
659         unchecked {
660             _balances[from] = fromBalance - amount;
661         }
662         _balances[to] += amount;
663 
664         emit Transfer(from, to, amount);
665 
666         _afterTokenTransfer(from, to, amount);
667     }
668 
669     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
670      * the total supply.
671      *
672      * Emits a {Transfer} event with `from` set to the zero address.
673      *
674      * Requirements:
675      *
676      * - `account` cannot be the zero address.
677      */
678     function _mint(address account, uint256 amount) internal virtual {
679         require(account != address(0), "ERC20: mint to the zero address");
680 
681         _beforeTokenTransfer(address(0), account, amount);
682 
683         _totalSupply += amount;
684         _balances[account] += amount;
685         emit Transfer(address(0), account, amount);
686 
687         _afterTokenTransfer(address(0), account, amount);
688     }
689 
690     /**
691      * @dev Destroys `amount` tokens from `account`, reducing the
692      * total supply.
693      *
694      * Emits a {Transfer} event with `to` set to the zero address.
695      *
696      * Requirements:
697      *
698      * - `account` cannot be the zero address.
699      * - `account` must have at least `amount` tokens.
700      */
701     function _burn(address account, uint256 amount) internal virtual {
702         require(account != address(0), "ERC20: burn from the zero address");
703 
704         _beforeTokenTransfer(account, address(0), amount);
705 
706         uint256 accountBalance = _balances[account];
707         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
708         unchecked {
709             _balances[account] = accountBalance - amount;
710         }
711         _totalSupply -= amount;
712 
713         emit Transfer(account, address(0), amount);
714 
715         _afterTokenTransfer(account, address(0), amount);
716     }
717 
718     /**
719      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
720      *
721      * This internal function is equivalent to `approve`, and can be used to
722      * e.g. set automatic allowances for certain subsystems, etc.
723      *
724      * Emits an {Approval} event.
725      *
726      * Requirements:
727      *
728      * - `owner` cannot be the zero address.
729      * - `spender` cannot be the zero address.
730      */
731     function _approve(
732         address owner,
733         address spender,
734         uint256 amount
735     ) internal virtual {
736         require(owner != address(0), "ERC20: approve from the zero address");
737         require(spender != address(0), "ERC20: approve to the zero address");
738 
739         _allowances[owner][spender] = amount;
740         emit Approval(owner, spender, amount);
741     }
742 
743     /**
744      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
745      *
746      * Does not update the allowance amount in case of infinite allowance.
747      * Revert if not enough allowance is available.
748      *
749      * Might emit an {Approval} event.
750      */
751     function _spendAllowance(
752         address owner,
753         address spender,
754         uint256 amount
755     ) internal virtual {
756         uint256 currentAllowance = allowance(owner, spender);
757         if (currentAllowance != type(uint256).max) {
758             require(currentAllowance >= amount, "ERC20: insufficient allowance");
759             unchecked {
760                 _approve(owner, spender, currentAllowance - amount);
761             }
762         }
763     }
764 
765     /**
766      * @dev Hook that is called before any transfer of tokens. This includes
767      * minting and burning.
768      *
769      * Calling conditions:
770      *
771      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
772      * will be transferred to `to`.
773      * - when `from` is zero, `amount` tokens will be minted for `to`.
774      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
775      * - `from` and `to` are never both zero.
776      *
777      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
778      */
779     function _beforeTokenTransfer(
780         address from,
781         address to,
782         uint256 amount
783     ) internal virtual {}
784 
785     /**
786      * @dev Hook that is called after any transfer of tokens. This includes
787      * minting and burning.
788      *
789      * Calling conditions:
790      *
791      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
792      * has been transferred to `to`.
793      * - when `from` is zero, `amount` tokens have been minted for `to`.
794      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
795      * - `from` and `to` are never both zero.
796      *
797      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
798      */
799     function _afterTokenTransfer(
800         address from,
801         address to,
802         uint256 amount
803     ) internal virtual {}
804 }
805 
806 // File: Mancium.sol
807 
808 
809 pragma solidity ^0.8.0;
810 
811 
812 
813 
814 
815 uint8 constant NUM_DECIMALS = 2;
816 
817 //Total Supply 100000000, 100 million tokens
818 uint256 constant TOTAL_AMOUNT = 100000000 * 1e2;
819 
820 contract Mancium is ERC20, Pausable, Ownable, Blacklist {
821     constructor() ERC20("Mancium", "MANC") {
822         _mint(owner(), TOTAL_AMOUNT);
823     }
824 
825     function pause() public onlyOwner {
826         _pause();
827     }
828 
829     function unpause() public onlyOwner {
830         _unpause();
831     }
832 
833     function _beforeTokenTransfer(address from, address to, uint256 amount)
834         internal
835         whenNotPaused
836         override
837     {
838         // This blocks transfer, transferFrom, burn and burnFrom calls from and
839         // to blacklisted addresses
840         require(!blacklist[from], "From address is blacklisted");
841         require(!blacklist[to], "To address is blacklisted");
842 
843         super._beforeTokenTransfer(from, to, amount);
844     }
845 
846     function decimals() public view virtual override returns (uint8) {
847         return NUM_DECIMALS;
848     }
849 }