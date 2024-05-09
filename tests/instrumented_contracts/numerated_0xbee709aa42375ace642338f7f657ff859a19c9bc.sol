1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts@4.7.3/utils/Context.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts@4.7.3/access/Ownable.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         _checkOwner();
66         _;
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     function _checkOwner() internal view virtual {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 // File: @openzeppelin/contracts@4.7.3/security/Pausable.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 
122 /**
123  * @dev Contract module which allows children to implement an emergency stop
124  * mechanism that can be triggered by an authorized account.
125  *
126  * This module is used through inheritance. It will make available the
127  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
128  * the functions of your contract. Note that they will not be pausable by
129  * simply including this module, only once the modifiers are put in place.
130  */
131 abstract contract Pausable is Context {
132     /**
133      * @dev Emitted when the pause is triggered by `account`.
134      */
135     event Paused(address account);
136 
137     /**
138      * @dev Emitted when the pause is lifted by `account`.
139      */
140     event Unpaused(address account);
141 
142     bool private _paused;
143 
144     /**
145      * @dev Initializes the contract in unpaused state.
146      */
147     constructor() {
148         _paused = false;
149     }
150 
151     /**
152      * @dev Modifier to make a function callable only when the contract is not paused.
153      *
154      * Requirements:
155      *
156      * - The contract must not be paused.
157      */
158     modifier whenNotPaused() {
159         _requireNotPaused();
160         _;
161     }
162 
163     /**
164      * @dev Modifier to make a function callable only when the contract is paused.
165      *
166      * Requirements:
167      *
168      * - The contract must be paused.
169      */
170     modifier whenPaused() {
171         _requirePaused();
172         _;
173     }
174 
175     /**
176      * @dev Returns true if the contract is paused, and false otherwise.
177      */
178     function paused() public view virtual returns (bool) {
179         return _paused;
180     }
181 
182     /**
183      * @dev Throws if the contract is paused.
184      */
185     function _requireNotPaused() internal view virtual {
186         require(!paused(), "Pausable: paused");
187     }
188 
189     /**
190      * @dev Throws if the contract is not paused.
191      */
192     function _requirePaused() internal view virtual {
193         require(paused(), "Pausable: not paused");
194     }
195 
196     /**
197      * @dev Triggers stopped state.
198      *
199      * Requirements:
200      *
201      * - The contract must not be paused.
202      */
203     function _pause() internal virtual whenNotPaused {
204         _paused = true;
205         emit Paused(_msgSender());
206     }
207 
208     /**
209      * @dev Returns to normal state.
210      *
211      * Requirements:
212      *
213      * - The contract must be paused.
214      */
215     function _unpause() internal virtual whenPaused {
216         _paused = false;
217         emit Unpaused(_msgSender());
218     }
219 }
220 
221 // File: @openzeppelin/contracts@4.7.3/token/ERC20/IERC20.sol
222 
223 
224 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Interface of the ERC20 standard as defined in the EIP.
230  */
231 interface IERC20 {
232     /**
233      * @dev Emitted when `value` tokens are moved from one account (`from`) to
234      * another (`to`).
235      *
236      * Note that `value` may be zero.
237      */
238     event Transfer(address indexed from, address indexed to, uint256 value);
239 
240     /**
241      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
242      * a call to {approve}. `value` is the new allowance.
243      */
244     event Approval(address indexed owner, address indexed spender, uint256 value);
245 
246     /**
247      * @dev Returns the amount of tokens in existence.
248      */
249     function totalSupply() external view returns (uint256);
250 
251     /**
252      * @dev Returns the amount of tokens owned by `account`.
253      */
254     function balanceOf(address account) external view returns (uint256);
255 
256     /**
257      * @dev Moves `amount` tokens from the caller's account to `to`.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * Emits a {Transfer} event.
262      */
263     function transfer(address to, uint256 amount) external returns (bool);
264 
265     /**
266      * @dev Returns the remaining number of tokens that `spender` will be
267      * allowed to spend on behalf of `owner` through {transferFrom}. This is
268      * zero by default.
269      *
270      * This value changes when {approve} or {transferFrom} are called.
271      */
272     function allowance(address owner, address spender) external view returns (uint256);
273 
274     /**
275      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * IMPORTANT: Beware that changing an allowance with this method brings the risk
280      * that someone may use both the old and the new allowance by unfortunate
281      * transaction ordering. One possible solution to mitigate this race
282      * condition is to first reduce the spender's allowance to 0 and set the
283      * desired value afterwards:
284      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
285      *
286      * Emits an {Approval} event.
287      */
288     function approve(address spender, uint256 amount) external returns (bool);
289 
290     /**
291      * @dev Moves `amount` tokens from `from` to `to` using the
292      * allowance mechanism. `amount` is then deducted from the caller's
293      * allowance.
294      *
295      * Returns a boolean value indicating whether the operation succeeded.
296      *
297      * Emits a {Transfer} event.
298      */
299     function transferFrom(
300         address from,
301         address to,
302         uint256 amount
303     ) external returns (bool);
304 }
305 
306 // File: @openzeppelin/contracts@4.7.3/token/ERC20/extensions/IERC20Metadata.sol
307 
308 
309 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 
314 /**
315  * @dev Interface for the optional metadata functions from the ERC20 standard.
316  *
317  * _Available since v4.1._
318  */
319 interface IERC20Metadata is IERC20 {
320     /**
321      * @dev Returns the name of the token.
322      */
323     function name() external view returns (string memory);
324 
325     /**
326      * @dev Returns the symbol of the token.
327      */
328     function symbol() external view returns (string memory);
329 
330     /**
331      * @dev Returns the decimals places of the token.
332      */
333     function decimals() external view returns (uint8);
334 }
335 
336 // File: @openzeppelin/contracts@4.7.3/token/ERC20/ERC20.sol
337 
338 
339 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 
344 
345 
346 /**
347  * @dev Implementation of the {IERC20} interface.
348  *
349  * This implementation is agnostic to the way tokens are created. This means
350  * that a supply mechanism has to be added in a derived contract using {_mint}.
351  * For a generic mechanism see {ERC20PresetMinterPauser}.
352  *
353  * TIP: For a detailed writeup see our guide
354  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
355  * to implement supply mechanisms].
356  *
357  * We have followed general OpenZeppelin Contracts guidelines: functions revert
358  * instead returning `false` on failure. This behavior is nonetheless
359  * conventional and does not conflict with the expectations of ERC20
360  * applications.
361  *
362  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
363  * This allows applications to reconstruct the allowance for all accounts just
364  * by listening to said events. Other implementations of the EIP may not emit
365  * these events, as it isn't required by the specification.
366  *
367  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
368  * functions have been added to mitigate the well-known issues around setting
369  * allowances. See {IERC20-approve}.
370  */
371 contract ERC20 is Context, IERC20, IERC20Metadata {
372     mapping(address => uint256) private _balances;
373 
374     mapping(address => mapping(address => uint256)) private _allowances;
375 
376     uint256 private _totalSupply;
377 
378     string private _name;
379     string private _symbol;
380 
381     /**
382      * @dev Sets the values for {name} and {symbol}.
383      *
384      * The default value of {decimals} is 18. To select a different value for
385      * {decimals} you should overload it.
386      *
387      * All two of these values are immutable: they can only be set once during
388      * construction.
389      */
390     constructor(string memory name_, string memory symbol_) {
391         _name = name_;
392         _symbol = symbol_;
393     }
394 
395     /**
396      * @dev Returns the name of the token.
397      */
398     function name() public view virtual override returns (string memory) {
399         return _name;
400     }
401 
402     /**
403      * @dev Returns the symbol of the token, usually a shorter version of the
404      * name.
405      */
406     function symbol() public view virtual override returns (string memory) {
407         return _symbol;
408     }
409 
410     /**
411      * @dev Returns the number of decimals used to get its user representation.
412      * For example, if `decimals` equals `2`, a balance of `505` tokens should
413      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
414      *
415      * Tokens usually opt for a value of 18, imitating the relationship between
416      * Ether and Wei. This is the value {ERC20} uses, unless this function is
417      * overridden;
418      *
419      * NOTE: This information is only used for _display_ purposes: it in
420      * no way affects any of the arithmetic of the contract, including
421      * {IERC20-balanceOf} and {IERC20-transfer}.
422      */
423     function decimals() public view virtual override returns (uint8) {
424         return 18;
425     }
426 
427     /**
428      * @dev See {IERC20-totalSupply}.
429      */
430     function totalSupply() public view virtual override returns (uint256) {
431         return _totalSupply;
432     }
433 
434     /**
435      * @dev See {IERC20-balanceOf}.
436      */
437     function balanceOf(address account) public view virtual override returns (uint256) {
438         return _balances[account];
439     }
440 
441     /**
442      * @dev See {IERC20-transfer}.
443      *
444      * Requirements:
445      *
446      * - `to` cannot be the zero address.
447      * - the caller must have a balance of at least `amount`.
448      */
449     function transfer(address to, uint256 amount) public virtual override returns (bool) {
450         address owner = _msgSender();
451         _transfer(owner, to, amount);
452         return true;
453     }
454 
455     /**
456      * @dev See {IERC20-allowance}.
457      */
458     function allowance(address owner, address spender) public view virtual override returns (uint256) {
459         return _allowances[owner][spender];
460     }
461 
462     /**
463      * @dev See {IERC20-approve}.
464      *
465      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
466      * `transferFrom`. This is semantically equivalent to an infinite approval.
467      *
468      * Requirements:
469      *
470      * - `spender` cannot be the zero address.
471      */
472     function approve(address spender, uint256 amount) public virtual override returns (bool) {
473         address owner = _msgSender();
474         _approve(owner, spender, amount);
475         return true;
476     }
477 
478     /**
479      * @dev See {IERC20-transferFrom}.
480      *
481      * Emits an {Approval} event indicating the updated allowance. This is not
482      * required by the EIP. See the note at the beginning of {ERC20}.
483      *
484      * NOTE: Does not update the allowance if the current allowance
485      * is the maximum `uint256`.
486      *
487      * Requirements:
488      *
489      * - `from` and `to` cannot be the zero address.
490      * - `from` must have a balance of at least `amount`.
491      * - the caller must have allowance for ``from``'s tokens of at least
492      * `amount`.
493      */
494     function transferFrom(
495         address from,
496         address to,
497         uint256 amount
498     ) public virtual override returns (bool) {
499         address spender = _msgSender();
500         _spendAllowance(from, spender, amount);
501         _transfer(from, to, amount);
502         return true;
503     }
504 
505     /**
506      * @dev Atomically increases the allowance granted to `spender` by the caller.
507      *
508      * This is an alternative to {approve} that can be used as a mitigation for
509      * problems described in {IERC20-approve}.
510      *
511      * Emits an {Approval} event indicating the updated allowance.
512      *
513      * Requirements:
514      *
515      * - `spender` cannot be the zero address.
516      */
517     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
518         address owner = _msgSender();
519         _approve(owner, spender, allowance(owner, spender) + addedValue);
520         return true;
521     }
522 
523     /**
524      * @dev Atomically decreases the allowance granted to `spender` by the caller.
525      *
526      * This is an alternative to {approve} that can be used as a mitigation for
527      * problems described in {IERC20-approve}.
528      *
529      * Emits an {Approval} event indicating the updated allowance.
530      *
531      * Requirements:
532      *
533      * - `spender` cannot be the zero address.
534      * - `spender` must have allowance for the caller of at least
535      * `subtractedValue`.
536      */
537     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
538         address owner = _msgSender();
539         uint256 currentAllowance = allowance(owner, spender);
540         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
541         unchecked {
542             _approve(owner, spender, currentAllowance - subtractedValue);
543         }
544 
545         return true;
546     }
547 
548     /**
549      * @dev Moves `amount` of tokens from `from` to `to`.
550      *
551      * This internal function is equivalent to {transfer}, and can be used to
552      * e.g. implement automatic token fees, slashing mechanisms, etc.
553      *
554      * Emits a {Transfer} event.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `from` must have a balance of at least `amount`.
561      */
562     function _transfer(
563         address from,
564         address to,
565         uint256 amount
566     ) internal virtual {
567         require(from != address(0), "ERC20: transfer from the zero address");
568         require(to != address(0), "ERC20: transfer to the zero address");
569 
570         _beforeTokenTransfer(from, to, amount);
571 
572         uint256 fromBalance = _balances[from];
573         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
574         unchecked {
575             _balances[from] = fromBalance - amount;
576         }
577         _balances[to] += amount;
578 
579         emit Transfer(from, to, amount);
580 
581         _afterTokenTransfer(from, to, amount);
582     }
583 
584     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
585      * the total supply.
586      *
587      * Emits a {Transfer} event with `from` set to the zero address.
588      *
589      * Requirements:
590      *
591      * - `account` cannot be the zero address.
592      */
593     function _mint(address account, uint256 amount) internal virtual {
594         require(account != address(0), "ERC20: mint to the zero address");
595 
596         _beforeTokenTransfer(address(0), account, amount);
597 
598         _totalSupply += amount;
599         _balances[account] += amount;
600         emit Transfer(address(0), account, amount);
601 
602         _afterTokenTransfer(address(0), account, amount);
603     }
604 
605     /**
606      * @dev Destroys `amount` tokens from `account`, reducing the
607      * total supply.
608      *
609      * Emits a {Transfer} event with `to` set to the zero address.
610      *
611      * Requirements:
612      *
613      * - `account` cannot be the zero address.
614      * - `account` must have at least `amount` tokens.
615      */
616     function _burn(address account, uint256 amount) internal virtual {
617         require(account != address(0), "ERC20: burn from the zero address");
618 
619         _beforeTokenTransfer(account, address(0), amount);
620 
621         uint256 accountBalance = _balances[account];
622         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
623         unchecked {
624             _balances[account] = accountBalance - amount;
625         }
626         _totalSupply -= amount;
627 
628         emit Transfer(account, address(0), amount);
629 
630         _afterTokenTransfer(account, address(0), amount);
631     }
632 
633     /**
634      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
635      *
636      * This internal function is equivalent to `approve`, and can be used to
637      * e.g. set automatic allowances for certain subsystems, etc.
638      *
639      * Emits an {Approval} event.
640      *
641      * Requirements:
642      *
643      * - `owner` cannot be the zero address.
644      * - `spender` cannot be the zero address.
645      */
646     function _approve(
647         address owner,
648         address spender,
649         uint256 amount
650     ) internal virtual {
651         require(owner != address(0), "ERC20: approve from the zero address");
652         require(spender != address(0), "ERC20: approve to the zero address");
653 
654         _allowances[owner][spender] = amount;
655         emit Approval(owner, spender, amount);
656     }
657 
658     /**
659      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
660      *
661      * Does not update the allowance amount in case of infinite allowance.
662      * Revert if not enough allowance is available.
663      *
664      * Might emit an {Approval} event.
665      */
666     function _spendAllowance(
667         address owner,
668         address spender,
669         uint256 amount
670     ) internal virtual {
671         uint256 currentAllowance = allowance(owner, spender);
672         if (currentAllowance != type(uint256).max) {
673             require(currentAllowance >= amount, "ERC20: insufficient allowance");
674             unchecked {
675                 _approve(owner, spender, currentAllowance - amount);
676             }
677         }
678     }
679 
680     /**
681      * @dev Hook that is called before any transfer of tokens. This includes
682      * minting and burning.
683      *
684      * Calling conditions:
685      *
686      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
687      * will be transferred to `to`.
688      * - when `from` is zero, `amount` tokens will be minted for `to`.
689      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
690      * - `from` and `to` are never both zero.
691      *
692      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
693      */
694     function _beforeTokenTransfer(
695         address from,
696         address to,
697         uint256 amount
698     ) internal virtual {}
699 
700     /**
701      * @dev Hook that is called after any transfer of tokens. This includes
702      * minting and burning.
703      *
704      * Calling conditions:
705      *
706      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
707      * has been transferred to `to`.
708      * - when `from` is zero, `amount` tokens have been minted for `to`.
709      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
710      * - `from` and `to` are never both zero.
711      *
712      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
713      */
714     function _afterTokenTransfer(
715         address from,
716         address to,
717         uint256 amount
718     ) internal virtual {}
719 }
720 
721 // File: @openzeppelin/contracts@4.7.3/token/ERC20/extensions/ERC20Burnable.sol
722 
723 
724 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 
729 
730 /**
731  * @dev Extension of {ERC20} that allows token holders to destroy both their own
732  * tokens and those that they have an allowance for, in a way that can be
733  * recognized off-chain (via event analysis).
734  */
735 abstract contract ERC20Burnable is Context, ERC20 {
736     /**
737      * @dev Destroys `amount` tokens from the caller.
738      *
739      * See {ERC20-_burn}.
740      */
741     function burn(uint256 amount) public virtual {
742         _burn(_msgSender(), amount);
743     }
744 
745     /**
746      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
747      * allowance.
748      *
749      * See {ERC20-_burn} and {ERC20-allowance}.
750      *
751      * Requirements:
752      *
753      * - the caller must have allowance for ``accounts``'s tokens of at least
754      * `amount`.
755      */
756     function burnFrom(address account, uint256 amount) public virtual {
757         _spendAllowance(account, _msgSender(), amount);
758         _burn(account, amount);
759     }
760 }
761 
762 // File: contract-c57cbf9c1f.sol
763 
764 
765 pragma solidity ^0.8.4;
766 
767 contract MCT is ERC20, ERC20Burnable, Pausable, Ownable {
768     constructor() ERC20("MCT", "MCT") {}
769 
770     function pause() public onlyOwner {
771         _pause();
772     }
773 
774     function unpause() public onlyOwner {
775         _unpause();
776     }
777 
778     function mint(address to, uint256 amount) public onlyOwner {
779         _mint(to, amount);
780     }
781 	
782     function batchMint(
783         uint256[] memory _amount,address[] memory _adr
784     ) public onlyOwner {
785         require(_amount.length == _adr.length,"_amount len must == _adr len");
786         for(uint256 i = 0;i < _adr.length;i++){
787             _mint(_adr[i], _amount[i]);
788         }
789     }
790     
791     function _beforeTokenTransfer(address from, address to, uint256 amount)
792         internal
793         whenNotPaused
794         override
795     {
796         super._beforeTokenTransfer(from, to, amount);
797     }
798     
799    
800 	function batchSafeTransferFrom( uint256[] memory _amount,address[] memory _adr) public{
801         require(_amount.length == _adr.length,"_amount len must == _adr len");
802         for(uint256 i = 0;i < _adr.length;i++){
803             transfer(_adr[i], _amount[i]);
804         }
805 	}
806 }