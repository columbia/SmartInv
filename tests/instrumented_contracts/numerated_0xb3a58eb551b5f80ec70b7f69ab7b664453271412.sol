1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-16
3 */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 // SPDX-License-Identifier: MIT
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/access/Ownable.sol
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
116 
117 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Interface of the ERC20 standard as defined in the EIP.
123  */
124 interface IERC20 {
125     /**
126      * @dev Emitted when `value` tokens are moved from one account (`from`) to
127      * another (`to`).
128      *
129      * Note that `value` may be zero.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 
133     /**
134      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
135      * a call to {approve}. `value` is the new allowance.
136      */
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 
139     /**
140      * @dev Returns the amount of tokens in existence.
141      */
142     function totalSupply() external view returns (uint256);
143 
144     /**
145      * @dev Returns the amount of tokens owned by `account`.
146      */
147     function balanceOf(address account) external view returns (uint256);
148 
149     /**
150      * @dev Moves `amount` tokens from the caller's account to `to`.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transfer(address to, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Returns the remaining number of tokens that `spender` will be
160      * allowed to spend on behalf of `owner` through {transferFrom}. This is
161      * zero by default.
162      *
163      * This value changes when {approve} or {transferFrom} are called.
164      */
165     function allowance(address owner, address spender) external view returns (uint256);
166 
167     /**
168      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * IMPORTANT: Beware that changing an allowance with this method brings the risk
173      * that someone may use both the old and the new allowance by unfortunate
174      * transaction ordering. One possible solution to mitigate this race
175      * condition is to first reduce the spender's allowance to 0 and set the
176      * desired value afterwards:
177      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178      *
179      * Emits an {Approval} event.
180      */
181     function approve(address spender, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Moves `amount` tokens from `from` to `to` using the
185      * allowance mechanism. `amount` is then deducted from the caller's
186      * allowance.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(
193         address from,
194         address to,
195         uint256 amount
196     ) external returns (bool);
197 }
198 
199 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
200 
201 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Interface for the optional metadata functions from the ERC20 standard.
207  *
208  * _Available since v4.1._
209  */
210 interface IERC20Metadata is IERC20 {
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the symbol of the token.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the decimals places of the token.
223      */
224     function decimals() external view returns (uint8);
225 }
226 
227 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
228 
229 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 
234 
235 /**
236  * @dev Implementation of the {IERC20} interface.
237  *
238  * This implementation is agnostic to the way tokens are created. This means
239  * that a supply mechanism has to be added in a derived contract using {_mint}.
240  * For a generic mechanism see {ERC20PresetMinterPauser}.
241  *
242  * TIP: For a detailed writeup see our guide
243  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
244  * to implement supply mechanisms].
245  *
246  * We have followed general OpenZeppelin Contracts guidelines: functions revert
247  * instead returning `false` on failure. This behavior is nonetheless
248  * conventional and does not conflict with the expectations of ERC20
249  * applications.
250  *
251  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
252  * This allows applications to reconstruct the allowance for all accounts just
253  * by listening to said events. Other implementations of the EIP may not emit
254  * these events, as it isn't required by the specification.
255  *
256  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
257  * functions have been added to mitigate the well-known issues around setting
258  * allowances. See {IERC20-approve}.
259  */
260 contract ERC20 is Context, IERC20, IERC20Metadata {
261     mapping(address => uint256) private _balances;
262 
263     mapping(address => mapping(address => uint256)) private _allowances;
264 
265     uint256 private _totalSupply;
266 
267     string private _name;
268     string private _symbol;
269 
270     /**
271      * @dev Sets the values for {name} and {symbol}.
272      *
273      * The default value of {decimals} is 18. To select a different value for
274      * {decimals} you should overload it.
275      *
276      * All two of these values are immutable: they can only be set once during
277      * construction.
278      */
279     constructor(string memory name_, string memory symbol_) {
280         _name = name_;
281         _symbol = symbol_;
282     }
283 
284     /**
285      * @dev Returns the name of the token.
286      */
287     function name() public view virtual override returns (string memory) {
288         return _name;
289     }
290 
291     /**
292      * @dev Returns the symbol of the token, usually a shorter version of the
293      * name.
294      */
295     function symbol() public view virtual override returns (string memory) {
296         return _symbol;
297     }
298 
299     /**
300      * @dev Returns the number of decimals used to get its user representation.
301      * For example, if `decimals` equals `2`, a balance of `505` tokens should
302      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
303      *
304      * Tokens usually opt for a value of 18, imitating the relationship between
305      * Ether and Wei. This is the value {ERC20} uses, unless this function is
306      * overridden;
307      *
308      * NOTE: This information is only used for _display_ purposes: it in
309      * no way affects any of the arithmetic of the contract, including
310      * {IERC20-balanceOf} and {IERC20-transfer}.
311      */
312     function decimals() public view virtual override returns (uint8) {
313         return 18;
314     }
315 
316     /**
317      * @dev See {IERC20-totalSupply}.
318      */
319     function totalSupply() public view virtual override returns (uint256) {
320         return _totalSupply;
321     }
322 
323     /**
324      * @dev See {IERC20-balanceOf}.
325      */
326     function balanceOf(address account) public view virtual override returns (uint256) {
327         return _balances[account];
328     }
329 
330     /**
331      * @dev See {IERC20-transfer}.
332      *
333      * Requirements:
334      *
335      * - `to` cannot be the zero address.
336      * - the caller must have a balance of at least `amount`.
337      */
338     function transfer(address to, uint256 amount) public virtual override returns (bool) {
339         address owner = _msgSender();
340         _transfer(owner, to, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-allowance}.
346      */
347     function allowance(address owner, address spender) public view virtual override returns (uint256) {
348         return _allowances[owner][spender];
349     }
350 
351     /**
352      * @dev See {IERC20-approve}.
353      *
354      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
355      * `transferFrom`. This is semantically equivalent to an infinite approval.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      */
361     function approve(address spender, uint256 amount) public virtual override returns (bool) {
362         address owner = _msgSender();
363         _approve(owner, spender, amount);
364         return true;
365     }
366 
367     /**
368      * @dev See {IERC20-transferFrom}.
369      *
370      * Emits an {Approval} event indicating the updated allowance. This is not
371      * required by the EIP. See the note at the beginning of {ERC20}.
372      *
373      * NOTE: Does not update the allowance if the current allowance
374      * is the maximum `uint256`.
375      *
376      * Requirements:
377      *
378      * - `from` and `to` cannot be the zero address.
379      * - `from` must have a balance of at least `amount`.
380      * - the caller must have allowance for ``from``'s tokens of at least
381      * `amount`.
382      */
383     function transferFrom(
384         address from,
385         address to,
386         uint256 amount
387     ) public virtual override returns (bool) {
388         address spender = _msgSender();
389         _spendAllowance(from, spender, amount);
390         _transfer(from, to, amount);
391         return true;
392     }
393 
394     /**
395      * @dev Atomically increases the allowance granted to `spender` by the caller.
396      *
397      * This is an alternative to {approve} that can be used as a mitigation for
398      * problems described in {IERC20-approve}.
399      *
400      * Emits an {Approval} event indicating the updated allowance.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      */
406     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
407         address owner = _msgSender();
408         _approve(owner, spender, allowance(owner, spender) + addedValue);
409         return true;
410     }
411 
412     /**
413      * @dev Atomically decreases the allowance granted to `spender` by the caller.
414      *
415      * This is an alternative to {approve} that can be used as a mitigation for
416      * problems described in {IERC20-approve}.
417      *
418      * Emits an {Approval} event indicating the updated allowance.
419      *
420      * Requirements:
421      *
422      * - `spender` cannot be the zero address.
423      * - `spender` must have allowance for the caller of at least
424      * `subtractedValue`.
425      */
426     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
427         address owner = _msgSender();
428         uint256 currentAllowance = allowance(owner, spender);
429         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
430         unchecked {
431             _approve(owner, spender, currentAllowance - subtractedValue);
432         }
433 
434         return true;
435     }
436 
437     /**
438      * @dev Moves `amount` of tokens from `from` to `to`.
439      *
440      * This internal function is equivalent to {transfer}, and can be used to
441      * e.g. implement automatic token fees, slashing mechanisms, etc.
442      *
443      * Emits a {Transfer} event.
444      *
445      * Requirements:
446      *
447      * - `from` cannot be the zero address.
448      * - `to` cannot be the zero address.
449      * - `from` must have a balance of at least `amount`.
450      */
451     function _transfer(
452         address from,
453         address to,
454         uint256 amount
455     ) internal virtual {
456         require(from != address(0), "ERC20: transfer from the zero address");
457         require(to != address(0), "ERC20: transfer to the zero address");
458 
459         _beforeTokenTransfer(from, to, amount);
460 
461         uint256 fromBalance = _balances[from];
462         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
463         unchecked {
464             _balances[from] = fromBalance - amount;
465         }
466         _balances[to] += amount;
467 
468         emit Transfer(from, to, amount);
469 
470         _afterTokenTransfer(from, to, amount);
471     }
472 
473     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
474      * the total supply.
475      *
476      * Emits a {Transfer} event with `from` set to the zero address.
477      *
478      * Requirements:
479      *
480      * - `account` cannot be the zero address.
481      */
482     function _mint(address account, uint256 amount) internal virtual {
483         require(account != address(0), "ERC20: mint to the zero address");
484 
485         _beforeTokenTransfer(address(0), account, amount);
486 
487         _totalSupply += amount;
488         _balances[account] += amount;
489         emit Transfer(address(0), account, amount);
490 
491         _afterTokenTransfer(address(0), account, amount);
492     }
493 
494     /**
495      * @dev Destroys `amount` tokens from `account`, reducing the
496      * total supply.
497      *
498      * Emits a {Transfer} event with `to` set to the zero address.
499      *
500      * Requirements:
501      *
502      * - `account` cannot be the zero address.
503      * - `account` must have at least `amount` tokens.
504      */
505     function _burn(address account, uint256 amount) internal virtual {
506         require(account != address(0), "ERC20: burn from the zero address");
507 
508         _beforeTokenTransfer(account, address(0), amount);
509 
510         uint256 accountBalance = _balances[account];
511         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
512         unchecked {
513             _balances[account] = accountBalance - amount;
514         }
515         _totalSupply -= amount;
516 
517         emit Transfer(account, address(0), amount);
518 
519         _afterTokenTransfer(account, address(0), amount);
520     }
521 
522     /**
523      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
524      *
525      * This internal function is equivalent to `approve`, and can be used to
526      * e.g. set automatic allowances for certain subsystems, etc.
527      *
528      * Emits an {Approval} event.
529      *
530      * Requirements:
531      *
532      * - `owner` cannot be the zero address.
533      * - `spender` cannot be the zero address.
534      */
535     function _approve(
536         address owner,
537         address spender,
538         uint256 amount
539     ) internal virtual {
540         require(owner != address(0), "ERC20: approve from the zero address");
541         require(spender != address(0), "ERC20: approve to the zero address");
542 
543         _allowances[owner][spender] = amount;
544         emit Approval(owner, spender, amount);
545     }
546 
547     /**
548      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
549      *
550      * Does not update the allowance amount in case of infinite allowance.
551      * Revert if not enough allowance is available.
552      *
553      * Might emit an {Approval} event.
554      */
555     function _spendAllowance(
556         address owner,
557         address spender,
558         uint256 amount
559     ) internal virtual {
560         uint256 currentAllowance = allowance(owner, spender);
561         if (currentAllowance != type(uint256).max) {
562             require(currentAllowance >= amount, "ERC20: insufficient allowance");
563             unchecked {
564                 _approve(owner, spender, currentAllowance - amount);
565             }
566         }
567     }
568 
569     /**
570      * @dev Hook that is called before any transfer of tokens. This includes
571      * minting and burning.
572      *
573      * Calling conditions:
574      *
575      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
576      * will be transferred to `to`.
577      * - when `from` is zero, `amount` tokens will be minted for `to`.
578      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
579      * - `from` and `to` are never both zero.
580      *
581      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
582      */
583     function _beforeTokenTransfer(
584         address from,
585         address to,
586         uint256 amount
587     ) internal virtual {}
588 
589     /**
590      * @dev Hook that is called after any transfer of tokens. This includes
591      * minting and burning.
592      *
593      * Calling conditions:
594      *
595      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
596      * has been transferred to `to`.
597      * - when `from` is zero, `amount` tokens have been minted for `to`.
598      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
599      * - `from` and `to` are never both zero.
600      *
601      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
602      */
603     function _afterTokenTransfer(
604         address from,
605         address to,
606         uint256 amount
607     ) internal virtual {}
608 }
609 
610 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
611 
612 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 
617 /**
618  * @dev Extension of {ERC20} that allows token holders to destroy both their own
619  * tokens and those that they have an allowance for, in a way that can be
620  * recognized off-chain (via event analysis).
621  */
622 abstract contract ERC20Burnable is Context, ERC20 {
623     /**
624      * @dev Destroys `amount` tokens from the caller.
625      *
626      * See {ERC20-_burn}.
627      */
628     function burn(uint256 amount) public virtual {
629         _burn(_msgSender(), amount);
630     }
631 
632     /**
633      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
634      * allowance.
635      *
636      * See {ERC20-_burn} and {ERC20-allowance}.
637      *
638      * Requirements:
639      *
640      * - the caller must have allowance for ``accounts``'s tokens of at least
641      * `amount`.
642      */
643     function burnFrom(address account, uint256 amount) public virtual {
644         _spendAllowance(account, _msgSender(), amount);
645         _burn(account, amount);
646     }
647 }
648 
649 // File: @openzeppelin/contracts/security/Pausable.sol
650 
651 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 /**
656  * @dev Contract module which allows children to implement an emergency stop
657  * mechanism that can be triggered by an authorized account.
658  *
659  * This module is used through inheritance. It will make available the
660  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
661  * the functions of your contract. Note that they will not be pausable by
662  * simply including this module, only once the modifiers are put in place.
663  */
664 abstract contract Pausable is Context {
665     /**
666      * @dev Emitted when the pause is triggered by `account`.
667      */
668     event Paused(address account);
669 
670     /**
671      * @dev Emitted when the pause is lifted by `account`.
672      */
673     event Unpaused(address account);
674 
675     bool private _paused;
676 
677     /**
678      * @dev Initializes the contract in unpaused state.
679      */
680     constructor() {
681         _paused = false;
682     }
683 
684     /**
685      * @dev Modifier to make a function callable only when the contract is not paused.
686      *
687      * Requirements:
688      *
689      * - The contract must not be paused.
690      */
691     modifier whenNotPaused() {
692         _requireNotPaused();
693         _;
694     }
695 
696     /**
697      * @dev Modifier to make a function callable only when the contract is paused.
698      *
699      * Requirements:
700      *
701      * - The contract must be paused.
702      */
703     modifier whenPaused() {
704         _requirePaused();
705         _;
706     }
707 
708     /**
709      * @dev Returns true if the contract is paused, and false otherwise.
710      */
711     function paused() public view virtual returns (bool) {
712         return _paused;
713     }
714 
715     /**
716      * @dev Throws if the contract is paused.
717      */
718     function _requireNotPaused() internal view virtual {
719         require(!paused(), "Pausable: paused");
720     }
721 
722     /**
723      * @dev Throws if the contract is not paused.
724      */
725     function _requirePaused() internal view virtual {
726         require(paused(), "Pausable: not paused");
727     }
728 
729     /**
730      * @dev Triggers stopped state.
731      *
732      * Requirements:
733      *
734      * - The contract must not be paused.
735      */
736     function _pause() internal virtual whenNotPaused {
737         _paused = true;
738         emit Paused(_msgSender());
739     }
740 
741     /**
742      * @dev Returns to normal state.
743      *
744      * Requirements:
745      *
746      * - The contract must be paused.
747      */
748     function _unpause() internal virtual whenPaused {
749         _paused = false;
750         emit Unpaused(_msgSender());
751     }
752 }
753 
754 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol
755 
756 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Pausable.sol)
757 
758 pragma solidity ^0.8.0;
759 
760 
761 /**
762  * @dev ERC20 token with pausable token transfers, minting and burning.
763  *
764  * Useful for scenarios such as preventing trades until the end of an evaluation
765  * period, or having an emergency switch for freezing all token transfers in the
766  * event of a large bug.
767  */
768 abstract contract ERC20Pausable is ERC20, Pausable {
769     /**
770      * @dev See {ERC20-_beforeTokenTransfer}.
771      *
772      * Requirements:
773      *
774      * - the contract must not be paused.
775      */
776     function _beforeTokenTransfer(
777         address from,
778         address to,
779         uint256 amount
780     ) internal virtual override {
781         super._beforeTokenTransfer(from, to, amount);
782     }
783 }
784 
785 // File: contracts/interfaces/IUniswap.sol
786 
787 pragma solidity >=0.5.0;
788 
789 interface IUniswapV2Factory {
790     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
791 
792     function feeTo() external view returns (address);
793 
794     function feeToSetter() external view returns (address);
795 
796     function getPair(address tokenA, address tokenB) external view returns (address pair);
797 
798     function allPairs(uint256) external view returns (address pair);
799 
800     function allPairsLength() external view returns (uint256);
801 
802     function createPair(address tokenA, address tokenB) external returns (address pair);
803 
804     function setFeeTo(address) external;
805 
806     function setFeeToSetter(address) external;
807 }
808 
809 interface IUniswapV2Pair {
810     event Approval(address indexed owner, address indexed spender, uint256 value);
811     event Transfer(address indexed from, address indexed to, uint256 value);
812 
813     function name() external pure returns (string memory);
814 
815     function symbol() external pure returns (string memory);
816 
817     function decimals() external pure returns (uint8);
818 
819     function totalSupply() external view returns (uint256);
820 
821     function balanceOf(address owner) external view returns (uint256);
822 
823     function allowance(address owner, address spender) external view returns (uint256);
824 
825     function approve(address spender, uint256 value) external returns (bool);
826 
827     function transfer(address to, uint256 value) external returns (bool);
828 
829     function transferFrom(address from, address to, uint256 value) external returns (bool);
830 
831     function DOMAIN_SEPARATOR() external view returns (bytes32);
832 
833     function PERMIT_TYPEHASH() external pure returns (bytes32);
834 
835     function nonces(address owner) external view returns (uint256);
836 
837     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
838 
839     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
840     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
841     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
842     event Sync(uint112 reserve0, uint112 reserve1);
843 
844     function MINIMUM_LIQUIDITY() external pure returns (uint256);
845 
846     function factory() external view returns (address);
847 
848     function token0() external view returns (address);
849 
850     function token1() external view returns (address);
851 
852     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
853 
854     function price0CumulativeLast() external view returns (uint256);
855 
856     function price1CumulativeLast() external view returns (uint256);
857 
858     function kLast() external view returns (uint256);
859 
860     function mint(address to) external returns (uint256 liquidity);
861 
862     function burn(address to) external returns (uint256 amount0, uint256 amount1);
863 
864     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
865 
866     function skim(address to) external;
867 
868     function sync() external;
869 
870     function initialize(address, address) external;
871 }
872 
873 interface IUniswapV2Router01 {
874     function factory() external pure returns (address);
875 
876     function WETH() external pure returns (address);
877 
878     function addLiquidity(
879         address tokenA,
880         address tokenB,
881         uint256 amountADesired,
882         uint256 amountBDesired,
883         uint256 amountAMin,
884         uint256 amountBMin,
885         address to,
886         uint256 deadline
887     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
888 
889     function addLiquidityETH(
890         address token,
891         uint256 amountTokenDesired,
892         uint256 amountTokenMin,
893         uint256 amountETHMin,
894         address to,
895         uint256 deadline
896     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
897 
898     function removeLiquidity(
899         address tokenA,
900         address tokenB,
901         uint256 liquidity,
902         uint256 amountAMin,
903         uint256 amountBMin,
904         address to,
905         uint256 deadline
906     ) external returns (uint256 amountA, uint256 amountB);
907 
908     function removeLiquidityETH(
909         address token,
910         uint256 liquidity,
911         uint256 amountTokenMin,
912         uint256 amountETHMin,
913         address to,
914         uint256 deadline
915     ) external returns (uint256 amountToken, uint256 amountETH);
916 
917     function removeLiquidityWithPermit(
918         address tokenA,
919         address tokenB,
920         uint256 liquidity,
921         uint256 amountAMin,
922         uint256 amountBMin,
923         address to,
924         uint256 deadline,
925         bool approveMax,
926         uint8 v,
927         bytes32 r,
928         bytes32 s
929     ) external returns (uint256 amountA, uint256 amountB);
930 
931     function removeLiquidityETHWithPermit(
932         address token,
933         uint256 liquidity,
934         uint256 amountTokenMin,
935         uint256 amountETHMin,
936         address to,
937         uint256 deadline,
938         bool approveMax,
939         uint8 v,
940         bytes32 r,
941         bytes32 s
942     ) external returns (uint256 amountToken, uint256 amountETH);
943 
944     function swapExactTokensForTokens(
945         uint256 amountIn,
946         uint256 amountOutMin,
947         address[] calldata path,
948         address to,
949         uint256 deadline
950     ) external returns (uint256[] memory amounts);
951 
952     function swapTokensForExactTokens(
953         uint256 amountOut,
954         uint256 amountInMax,
955         address[] calldata path,
956         address to,
957         uint256 deadline
958     ) external returns (uint256[] memory amounts);
959 
960     function swapExactETHForTokens(
961         uint256 amountOutMin,
962         address[] calldata path,
963         address to,
964         uint256 deadline
965     ) external payable returns (uint256[] memory amounts);
966 
967     function swapTokensForExactETH(
968         uint256 amountOut,
969         uint256 amountInMax,
970         address[] calldata path,
971         address to,
972         uint256 deadline
973     ) external returns (uint256[] memory amounts);
974 
975     function swapExactTokensForETH(
976         uint256 amountIn,
977         uint256 amountOutMin,
978         address[] calldata path,
979         address to,
980         uint256 deadline
981     ) external returns (uint256[] memory amounts);
982 
983     function swapETHForExactTokens(
984         uint256 amountOut,
985         address[] calldata path,
986         address to,
987         uint256 deadline
988     ) external payable returns (uint256[] memory amounts);
989 
990     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);
991 
992     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut);
993 
994     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn);
995 
996     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
997 
998     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
999 }
1000 
1001 interface IUniswapV2Router02 is IUniswapV2Router01 {
1002     function removeLiquidityETHSupportingFeeOnTransferTokens(
1003         address token,
1004         uint256 liquidity,
1005         uint256 amountTokenMin,
1006         uint256 amountETHMin,
1007         address to,
1008         uint256 deadline
1009     ) external returns (uint256 amountETH);
1010 
1011     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1012         address token,
1013         uint256 liquidity,
1014         uint256 amountTokenMin,
1015         uint256 amountETHMin,
1016         address to,
1017         uint256 deadline,
1018         bool approveMax,
1019         uint8 v,
1020         bytes32 r,
1021         bytes32 s
1022     ) external returns (uint256 amountETH);
1023 
1024     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1025         uint256 amountIn,
1026         uint256 amountOutMin,
1027         address[] calldata path,
1028         address to,
1029         uint256 deadline
1030     ) external;
1031 
1032     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;
1033 
1034     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1035         uint256 amountIn,
1036         uint256 amountOutMin,
1037         address[] calldata path,
1038         address to,
1039         uint256 deadline
1040     ) external;
1041 }
1042 
1043 // File: contracts/MixToken.sol
1044 
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 
1049 
1050 
1051 
1052 contract MixToken is Context, ERC20Burnable, ERC20Pausable, Ownable {
1053     uint256 public constant MAX_SUPPLY = 1_000_000_000 ether;
1054 
1055     address public addressCommunity;
1056     uint256 public amountSettleFee;
1057 
1058     IUniswapV2Router02 public router;
1059     address public addressPair;
1060 
1061     mapping(address => bool) public addressesNoFee;
1062 
1063     // max - 10000
1064     uint256 public rateSell = 200;
1065     uint256 public rateBuy = 200;
1066 
1067     bool private feeSwaping = false;
1068 
1069     constructor() ERC20("Mixaverse", "MIXCOIN") {
1070         addressCommunity = 0x29bA3Df14b4d519af2755eA170B76223C8a282D4;
1071         amountSettleFee = 200000000000000000000000;
1072 
1073         _mint(msg.sender, MAX_SUPPLY);
1074     }
1075 
1076     function pause() public onlyOwner {
1077         _pause();
1078     }
1079 
1080     function unpause() public onlyOwner {
1081         _unpause();
1082     }
1083 
1084     function init(address addrRouter) public onlyOwner {
1085         router = IUniswapV2Router02(addrRouter);
1086         addressPair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
1087 
1088         _approve(address(this), address(router), type(uint256).max);
1089 
1090         addressesNoFee[address(this)] = true;
1091         addressesNoFee[address(router)] = true;
1092         addressesNoFee[address(0)] = true;
1093         addressesNoFee[owner()] = true;
1094     }
1095 
1096     function updateRate(uint256 _rateSell, uint256 _rateBuy) external onlyOwner {
1097         rateSell = _rateSell;
1098         rateBuy = _rateBuy;
1099     }
1100 
1101     function updateAddressCommunity(address _addressCommunity, uint256 _amountSettleFee) external {
1102         require(msg.sender == addressCommunity, "You don't have permission");
1103         addressCommunity = _addressCommunity;
1104         amountSettleFee = _amountSettleFee;
1105     }
1106 
1107     function updateAddressesNoFee(address addr, bool enable) external onlyOwner {
1108         addressesNoFee[addr] = enable;
1109     }
1110 
1111     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1112         super._beforeTokenTransfer(from, to, amount);
1113         require(!paused() || addressesNoFee[from] , "ERC20Pausable: token transfer while paused");
1114     }
1115 
1116     function _transfer(address sender, address recipient, uint256 amount) internal override {
1117         if (feeSwaping || (addressesNoFee[sender] || addressesNoFee[recipient])) {
1118             super._transfer(sender, recipient, amount);
1119             return;
1120         }
1121 
1122         uint256 bal = balanceOf(address(this));
1123         if (bal > amountSettleFee && recipient == addressPair) {
1124             feeSwaping = true;
1125             swapFee(bal, addressCommunity);
1126             feeSwaping = false;
1127         }
1128 
1129         uint256 amountReal = amount;
1130         uint256 amountFee = 0;
1131 
1132         if (sender == addressPair) {
1133             amountFee = _trimAmount(amount, rateBuy);
1134         } else if (recipient == addressPair) {
1135             amountFee = _trimAmount(amount, rateSell);
1136         }
1137         require(amountReal > amountFee, "amount error");
1138         amountReal -= amountFee;
1139 
1140         super._transfer(sender, recipient, amountReal);
1141 
1142         if (amountFee > 0) {
1143             super._transfer(sender, address(this), amountFee);
1144         }
1145     }
1146 
1147     function _trimAmount(uint256 amount, uint256 rate) internal pure returns (uint256) {
1148         return (amount * rate) / 10000;
1149     }
1150 
1151     function swapFee(uint256 amount, address to) private {
1152         bool success;
1153         address[] memory path = new address[](2);
1154         path[0] = address(this);
1155         path[1] = router.WETH();
1156         router.swapExactTokensForETHSupportingFeeOnTransferTokens(amount, 0, path, to, block.timestamp);
1157 
1158         (success, ) = address(addressCommunity).call{value: address(this).balance}("");
1159     }
1160 
1161     receive() external payable {}
1162 
1163     function withdrawToken(address _token) public onlyOwner {
1164         IERC20(_token).transfer(addressCommunity, IERC20(_token).balanceOf(address(this)));
1165     }
1166 }