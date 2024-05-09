1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `to`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address to, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `from` to `to` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address from,
67         address to,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 // File: @openzeppelin/contracts/utils/Context.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
144 
145 
146 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 
151 
152 
153 /**
154  * @dev Implementation of the {IERC20} interface.
155  *
156  * This implementation is agnostic to the way tokens are created. This means
157  * that a supply mechanism has to be added in a derived contract using {_mint}.
158  * For a generic mechanism see {ERC20PresetMinterPauser}.
159  *
160  * TIP: For a detailed writeup see our guide
161  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
162  * to implement supply mechanisms].
163  *
164  * We have followed general OpenZeppelin Contracts guidelines: functions revert
165  * instead returning `false` on failure. This behavior is nonetheless
166  * conventional and does not conflict with the expectations of ERC20
167  * applications.
168  *
169  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
170  * This allows applications to reconstruct the allowance for all accounts just
171  * by listening to said events. Other implementations of the EIP may not emit
172  * these events, as it isn't required by the specification.
173  *
174  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
175  * functions have been added to mitigate the well-known issues around setting
176  * allowances. See {IERC20-approve}.
177  */
178 contract ERC20 is Context, IERC20, IERC20Metadata {
179     mapping(address => uint256) private _balances;
180 
181     mapping(address => mapping(address => uint256)) private _allowances;
182 
183     uint256 private _totalSupply;
184 
185     string private _name;
186     string private _symbol;
187 
188     /**
189      * @dev Sets the values for {name} and {symbol}.
190      *
191      * The default value of {decimals} is 18. To select a different value for
192      * {decimals} you should overload it.
193      *
194      * All two of these values are immutable: they can only be set once during
195      * construction.
196      */
197     constructor(string memory name_, string memory symbol_) {
198         _name = name_;
199         _symbol = symbol_;
200     }
201 
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() public view virtual override returns (string memory) {
206         return _name;
207     }
208 
209     /**
210      * @dev Returns the symbol of the token, usually a shorter version of the
211      * name.
212      */
213     function symbol() public view virtual override returns (string memory) {
214         return _symbol;
215     }
216 
217     /**
218      * @dev Returns the number of decimals used to get its user representation.
219      * For example, if `decimals` equals `2`, a balance of `505` tokens should
220      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
221      *
222      * Tokens usually opt for a value of 18, imitating the relationship between
223      * Ether and Wei. This is the value {ERC20} uses, unless this function is
224      * overridden;
225      *
226      * NOTE: This information is only used for _display_ purposes: it in
227      * no way affects any of the arithmetic of the contract, including
228      * {IERC20-balanceOf} and {IERC20-transfer}.
229      */
230     function decimals() public view virtual override returns (uint8) {
231         return 18;
232     }
233 
234     /**
235      * @dev See {IERC20-totalSupply}.
236      */
237     function totalSupply() public view virtual override returns (uint256) {
238         return _totalSupply;
239     }
240 
241     /**
242      * @dev See {IERC20-balanceOf}.
243      */
244     function balanceOf(address account) public view virtual override returns (uint256) {
245         return _balances[account];
246     }
247 
248     /**
249      * @dev See {IERC20-transfer}.
250      *
251      * Requirements:
252      *
253      * - `to` cannot be the zero address.
254      * - the caller must have a balance of at least `amount`.
255      */
256     function transfer(address to, uint256 amount) public virtual override returns (bool) {
257         address owner = _msgSender();
258         _transfer(owner, to, amount);
259         return true;
260     }
261 
262     /**
263      * @dev See {IERC20-allowance}.
264      */
265     function allowance(address owner, address spender) public view virtual override returns (uint256) {
266         return _allowances[owner][spender];
267     }
268 
269     /**
270      * @dev See {IERC20-approve}.
271      *
272      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
273      * `transferFrom`. This is semantically equivalent to an infinite approval.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 amount) public virtual override returns (bool) {
280         address owner = _msgSender();
281         _approve(owner, spender, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See {IERC20-transferFrom}.
287      *
288      * Emits an {Approval} event indicating the updated allowance. This is not
289      * required by the EIP. See the note at the beginning of {ERC20}.
290      *
291      * NOTE: Does not update the allowance if the current allowance
292      * is the maximum `uint256`.
293      *
294      * Requirements:
295      *
296      * - `from` and `to` cannot be the zero address.
297      * - `from` must have a balance of at least `amount`.
298      * - the caller must have allowance for ``from``'s tokens of at least
299      * `amount`.
300      */
301     function transferFrom(
302         address from,
303         address to,
304         uint256 amount
305     ) public virtual override returns (bool) {
306         address spender = _msgSender();
307         _spendAllowance(from, spender, amount);
308         _transfer(from, to, amount);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically increases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
325         address owner = _msgSender();
326         _approve(owner, spender, _allowances[owner][spender] + addedValue);
327         return true;
328     }
329 
330     /**
331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to {approve} that can be used as a mitigation for
334      * problems described in {IERC20-approve}.
335      *
336      * Emits an {Approval} event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      * - `spender` must have allowance for the caller of at least
342      * `subtractedValue`.
343      */
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         address owner = _msgSender();
346         uint256 currentAllowance = _allowances[owner][spender];
347         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
348         unchecked {
349             _approve(owner, spender, currentAllowance - subtractedValue);
350         }
351 
352         return true;
353     }
354 
355     /**
356      * @dev Moves `amount` of tokens from `sender` to `recipient`.
357      *
358      * This internal function is equivalent to {transfer}, and can be used to
359      * e.g. implement automatic token fees, slashing mechanisms, etc.
360      *
361      * Emits a {Transfer} event.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `from` must have a balance of at least `amount`.
368      */
369     function _transfer(
370         address from,
371         address to,
372         uint256 amount
373     ) internal virtual {
374         require(from != address(0), "ERC20: transfer from the zero address");
375         require(to != address(0), "ERC20: transfer to the zero address");
376 
377         _beforeTokenTransfer(from, to, amount);
378 
379         uint256 fromBalance = _balances[from];
380         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
381         unchecked {
382             _balances[from] = fromBalance - amount;
383         }
384         _balances[to] += amount;
385 
386         emit Transfer(from, to, amount);
387 
388         _afterTokenTransfer(from, to, amount);
389     }
390 
391     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
392      * the total supply.
393      *
394      * Emits a {Transfer} event with `from` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      */
400     function _mint(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: mint to the zero address");
402 
403         _beforeTokenTransfer(address(0), account, amount);
404 
405         _totalSupply += amount;
406         _balances[account] += amount;
407         emit Transfer(address(0), account, amount);
408 
409         _afterTokenTransfer(address(0), account, amount);
410     }
411 
412     /**
413      * @dev Destroys `amount` tokens from `account`, reducing the
414      * total supply.
415      *
416      * Emits a {Transfer} event with `to` set to the zero address.
417      *
418      * Requirements:
419      *
420      * - `account` cannot be the zero address.
421      * - `account` must have at least `amount` tokens.
422      */
423     function _burn(address account, uint256 amount) internal virtual {
424         require(account != address(0), "ERC20: burn from the zero address");
425 
426         _beforeTokenTransfer(account, address(0), amount);
427 
428         uint256 accountBalance = _balances[account];
429         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
430         unchecked {
431             _balances[account] = accountBalance - amount;
432         }
433         _totalSupply -= amount;
434 
435         emit Transfer(account, address(0), amount);
436 
437         _afterTokenTransfer(account, address(0), amount);
438     }
439 
440     /**
441      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
442      *
443      * This internal function is equivalent to `approve`, and can be used to
444      * e.g. set automatic allowances for certain subsystems, etc.
445      *
446      * Emits an {Approval} event.
447      *
448      * Requirements:
449      *
450      * - `owner` cannot be the zero address.
451      * - `spender` cannot be the zero address.
452      */
453     function _approve(
454         address owner,
455         address spender,
456         uint256 amount
457     ) internal virtual {
458         require(owner != address(0), "ERC20: approve from the zero address");
459         require(spender != address(0), "ERC20: approve to the zero address");
460 
461         _allowances[owner][spender] = amount;
462         emit Approval(owner, spender, amount);
463     }
464 
465     /**
466      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
467      *
468      * Does not update the allowance amount in case of infinite allowance.
469      * Revert if not enough allowance is available.
470      *
471      * Might emit an {Approval} event.
472      */
473     function _spendAllowance(
474         address owner,
475         address spender,
476         uint256 amount
477     ) internal virtual {
478         uint256 currentAllowance = allowance(owner, spender);
479         if (currentAllowance != type(uint256).max) {
480             require(currentAllowance >= amount, "ERC20: insufficient allowance");
481             unchecked {
482                 _approve(owner, spender, currentAllowance - amount);
483             }
484         }
485     }
486 
487     /**
488      * @dev Hook that is called before any transfer of tokens. This includes
489      * minting and burning.
490      *
491      * Calling conditions:
492      *
493      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
494      * will be transferred to `to`.
495      * - when `from` is zero, `amount` tokens will be minted for `to`.
496      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
497      * - `from` and `to` are never both zero.
498      *
499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
500      */
501     function _beforeTokenTransfer(
502         address from,
503         address to,
504         uint256 amount
505     ) internal virtual {}
506 
507     /**
508      * @dev Hook that is called after any transfer of tokens. This includes
509      * minting and burning.
510      *
511      * Calling conditions:
512      *
513      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
514      * has been transferred to `to`.
515      * - when `from` is zero, `amount` tokens have been minted for `to`.
516      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
517      * - `from` and `to` are never both zero.
518      *
519      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
520      */
521     function _afterTokenTransfer(
522         address from,
523         address to,
524         uint256 amount
525     ) internal virtual {}
526 }
527 
528 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
529 
530 
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @title ERC20Mintable
537  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
538  */
539 abstract contract ERC20Mintable is ERC20 {
540 
541   // indicates if minting is finished
542   bool private _mintingFinished = false;
543 
544   /**
545    * @dev Emitted during finish minting
546    */
547   event MintFinished();
548 
549   /**
550    * @dev Tokens can be minted only before minting finished.
551    */
552   modifier canMint() {
553     require(!_mintingFinished, "ERC20Mintable: minting is finished");
554     _;
555   }
556 
557   /**
558    * @return if minting is finished or not.
559    */
560   function mintingFinished() public view returns (bool) {
561     return _mintingFinished;
562   }
563 
564   /**
565    * @dev Function to mint tokens.
566    *
567    * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
568    *
569    * @param account The address that will receive the minted tokens
570    * @param amount The amount of tokens to mint
571    */
572   function mint(address account, uint256 amount) public canMint {
573     _mint(account, amount);
574   }
575 
576   /**
577    * @dev Function to stop minting new tokens.
578    *
579    * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
580    */
581   function finishMinting() public canMint {
582     _finishMinting();
583   }
584 
585   /**
586    * @dev Function to stop minting new tokens.
587    */
588   function _finishMinting() internal virtual {
589     _mintingFinished = true;
590 
591     emit MintFinished();
592   }
593 }
594 
595 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
596 
597 
598 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
599 
600 pragma solidity ^0.8.0;
601 
602 
603 
604 /**
605  * @dev Extension of {ERC20} that allows token holders to destroy both their own
606  * tokens and those that they have an allowance for, in a way that can be
607  * recognized off-chain (via event analysis).
608  */
609 abstract contract ERC20Burnable is Context, ERC20 {
610     /**
611      * @dev Destroys `amount` tokens from the caller.
612      *
613      * See {ERC20-_burn}.
614      */
615     function burn(uint256 amount) public virtual {
616         _burn(_msgSender(), amount);
617     }
618 
619     /**
620      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
621      * allowance.
622      *
623      * See {ERC20-_burn} and {ERC20-allowance}.
624      *
625      * Requirements:
626      *
627      * - the caller must have allowance for ``accounts``'s tokens of at least
628      * `amount`.
629      */
630     function burnFrom(address account, uint256 amount) public virtual {
631         _spendAllowance(account, _msgSender(), amount);
632         _burn(account, amount);
633     }
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Capped.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 
644 /**
645  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
646  */
647 abstract contract ERC20Capped is ERC20 {
648     uint256 private immutable _cap;
649 
650     /**
651      * @dev Sets the value of the `cap`. This value is immutable, it can only be
652      * set once during construction.
653      */
654     constructor(uint256 cap_) {
655         require(cap_ > 0, "ERC20Capped: cap is 0");
656         _cap = cap_;
657     }
658 
659     /**
660      * @dev Returns the cap on the token's total supply.
661      */
662     function cap() public view virtual returns (uint256) {
663         return _cap;
664     }
665 
666     /**
667      * @dev See {ERC20-_mint}.
668      */
669     function _mint(address account, uint256 amount) internal virtual override {
670         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
671         super._mint(account, amount);
672     }
673 }
674 
675 // File: @openzeppelin/contracts/security/Pausable.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 
683 /**
684  * @dev Contract module which allows children to implement an emergency stop
685  * mechanism that can be triggered by an authorized account.
686  *
687  * This module is used through inheritance. It will make available the
688  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
689  * the functions of your contract. Note that they will not be pausable by
690  * simply including this module, only once the modifiers are put in place.
691  */
692 abstract contract Pausable is Context {
693     /**
694      * @dev Emitted when the pause is triggered by `account`.
695      */
696     event Paused(address account);
697 
698     /**
699      * @dev Emitted when the pause is lifted by `account`.
700      */
701     event Unpaused(address account);
702 
703     bool private _paused;
704 
705     /**
706      * @dev Initializes the contract in unpaused state.
707      */
708     constructor() {
709         _paused = false;
710     }
711 
712     /**
713      * @dev Returns true if the contract is paused, and false otherwise.
714      */
715     function paused() public view virtual returns (bool) {
716         return _paused;
717     }
718 
719     /**
720      * @dev Modifier to make a function callable only when the contract is not paused.
721      *
722      * Requirements:
723      *
724      * - The contract must not be paused.
725      */
726     modifier whenNotPaused() {
727         require(!paused(), "Pausable: paused");
728         _;
729     }
730 
731     /**
732      * @dev Modifier to make a function callable only when the contract is paused.
733      *
734      * Requirements:
735      *
736      * - The contract must be paused.
737      */
738     modifier whenPaused() {
739         require(paused(), "Pausable: not paused");
740         _;
741     }
742 
743     /**
744      * @dev Triggers stopped state.
745      *
746      * Requirements:
747      *
748      * - The contract must not be paused.
749      */
750     function _pause() internal virtual whenNotPaused {
751         _paused = true;
752         emit Paused(_msgSender());
753     }
754 
755     /**
756      * @dev Returns to normal state.
757      *
758      * Requirements:
759      *
760      * - The contract must be paused.
761      */
762     function _unpause() internal virtual whenPaused {
763         _paused = false;
764         emit Unpaused(_msgSender());
765     }
766 }
767 
768 // File: @openzeppelin/contracts/access/Ownable.sol
769 
770 
771 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
772 
773 pragma solidity ^0.8.0;
774 
775 
776 /**
777  * @dev Contract module which provides a basic access control mechanism, where
778  * there is an account (an owner) that can be granted exclusive access to
779  * specific functions.
780  *
781  * By default, the owner account will be the one that deploys the contract. This
782  * can later be changed with {transferOwnership}.
783  *
784  * This module is used through inheritance. It will make available the modifier
785  * `onlyOwner`, which can be applied to your functions to restrict their use to
786  * the owner.
787  */
788 abstract contract Ownable is Context {
789     address private _owner;
790 
791     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
792 
793     /**
794      * @dev Initializes the contract setting the deployer as the initial owner.
795      */
796     constructor() {
797         _transferOwnership(_msgSender());
798     }
799 
800     /**
801      * @dev Returns the address of the current owner.
802      */
803     function owner() public view virtual returns (address) {
804         return _owner;
805     }
806 
807     /**
808      * @dev Throws if called by any account other than the owner.
809      */
810     modifier onlyOwner() {
811         require(owner() == _msgSender(), "Ownable: caller is not the owner");
812         _;
813     }
814 
815     /**
816      * @dev Leaves the contract without owner. It will not be possible to call
817      * `onlyOwner` functions anymore. Can only be called by the current owner.
818      *
819      * NOTE: Renouncing ownership will leave the contract without an owner,
820      * thereby removing any functionality that is only available to the owner.
821      */
822     function renounceOwnership() public virtual onlyOwner {
823         _transferOwnership(address(0));
824     }
825 
826     /**
827      * @dev Transfers ownership of the contract to a new account (`newOwner`).
828      * Can only be called by the current owner.
829      */
830     function transferOwnership(address newOwner) public virtual onlyOwner {
831         require(newOwner != address(0), "Ownable: new owner is the zero address");
832         _transferOwnership(newOwner);
833     }
834 
835     /**
836      * @dev Transfers ownership of the contract to a new account (`newOwner`).
837      * Internal function without access restriction.
838      */
839     function _transferOwnership(address newOwner) internal virtual {
840         address oldOwner = _owner;
841         _owner = newOwner;
842         emit OwnershipTransferred(oldOwner, newOwner);
843     }
844 }
845 
846 // File: contracts/token/ERC20/CommonPausableERC20.sol
847 
848 
849 
850 pragma solidity 0.8.13;
851 
852 
853 
854 
855 
856 
857 
858 /**
859  * @title Aktio
860  * @dev Implementation of the Aktio
861  */
862 contract Aktio is ERC20Capped, ERC20Mintable, ERC20Burnable, Pausable, Ownable {
863   uint8 private _decimals;
864 
865   function _setupDecimals(uint8 __decimals) internal {
866     _decimals = __decimals;
867   }
868 
869   function decimals() public view virtual override(ERC20) returns (uint8) {
870     return _decimals;
871   }
872 
873   constructor (
874     string memory name,
875     string memory symbol,
876     uint8 __decimals,
877     uint256 cap,
878     uint256 initialBalance
879   )
880   ERC20(name, symbol)
881   ERC20Capped(cap)
882   {
883     _setupDecimals(__decimals);
884     require(initialBalance <= cap, "ERC20Capped: cap exceeded");
885     ERC20._mint(_msgSender(), initialBalance);
886   }
887 
888   function pause() external onlyOwner {
889     _pause();
890   }
891 
892   function unpause() external onlyOwner {
893     _unpause();
894   }
895 
896   /**
897    * @dev Function to mint tokens.
898    *
899    * NOTE: restricting access to owner only. See {ERC20Mintable-mint}.
900    *
901    * @param account The address that will receive the minted tokens
902    * @param amount The amount of tokens to mint
903    */
904   function _mint(address account, uint256 amount) internal override(ERC20Capped, ERC20) onlyOwner {
905     ERC20Capped._mint(account, amount);
906   }
907 
908   /**
909    * @dev Function to stop minting new tokens.
910    *
911    * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
912    */
913   function _finishMinting() internal override onlyOwner {
914     super._finishMinting();
915   }
916 
917   /**
918      * @dev See {ERC20-_beforeTokenTransfer}. See {ERC20Capped-_beforeTokenTransfer}.
919      *
920      * Requirements:
921      *
922      * - the contract must not be paused.
923      */
924   function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20) whenNotPaused {
925     super._beforeTokenTransfer(from, to, amount);
926   }
927 }