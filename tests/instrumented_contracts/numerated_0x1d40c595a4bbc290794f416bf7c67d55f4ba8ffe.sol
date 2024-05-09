1 // Sources flattened with hardhat v2.12.6 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.8.1
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.1
32 
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
115 
116 // File @openzeppelin/contracts/security/Pausable.sol@v4.8.1
117 
118 
119 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Contract module which allows children to implement an emergency stop
125  * mechanism that can be triggered by an authorized account.
126  *
127  * This module is used through inheritance. It will make available the
128  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
129  * the functions of your contract. Note that they will not be pausable by
130  * simply including this module, only once the modifiers are put in place.
131  */
132 abstract contract Pausable is Context {
133     /**
134      * @dev Emitted when the pause is triggered by `account`.
135      */
136     event Paused(address account);
137 
138     /**
139      * @dev Emitted when the pause is lifted by `account`.
140      */
141     event Unpaused(address account);
142 
143     bool private _paused;
144 
145     /**
146      * @dev Initializes the contract in unpaused state.
147      */
148     constructor() {
149         _paused = false;
150     }
151 
152     /**
153      * @dev Modifier to make a function callable only when the contract is not paused.
154      *
155      * Requirements:
156      *
157      * - The contract must not be paused.
158      */
159     modifier whenNotPaused() {
160         _requireNotPaused();
161         _;
162     }
163 
164     /**
165      * @dev Modifier to make a function callable only when the contract is paused.
166      *
167      * Requirements:
168      *
169      * - The contract must be paused.
170      */
171     modifier whenPaused() {
172         _requirePaused();
173         _;
174     }
175 
176     /**
177      * @dev Returns true if the contract is paused, and false otherwise.
178      */
179     function paused() public view virtual returns (bool) {
180         return _paused;
181     }
182 
183     /**
184      * @dev Throws if the contract is paused.
185      */
186     function _requireNotPaused() internal view virtual {
187         require(!paused(), "Pausable: paused");
188     }
189 
190     /**
191      * @dev Throws if the contract is not paused.
192      */
193     function _requirePaused() internal view virtual {
194         require(paused(), "Pausable: not paused");
195     }
196 
197     /**
198      * @dev Triggers stopped state.
199      *
200      * Requirements:
201      *
202      * - The contract must not be paused.
203      */
204     function _pause() internal virtual whenNotPaused {
205         _paused = true;
206         emit Paused(_msgSender());
207     }
208 
209     /**
210      * @dev Returns to normal state.
211      *
212      * Requirements:
213      *
214      * - The contract must be paused.
215      */
216     function _unpause() internal virtual whenPaused {
217         _paused = false;
218         emit Unpaused(_msgSender());
219     }
220 }
221 
222 
223 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.1
224 
225 
226 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Interface of the ERC20 standard as defined in the EIP.
232  */
233 interface IERC20 {
234     /**
235      * @dev Emitted when `value` tokens are moved from one account (`from`) to
236      * another (`to`).
237      *
238      * Note that `value` may be zero.
239      */
240     event Transfer(address indexed from, address indexed to, uint256 value);
241 
242     /**
243      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
244      * a call to {approve}. `value` is the new allowance.
245      */
246     event Approval(address indexed owner, address indexed spender, uint256 value);
247 
248     /**
249      * @dev Returns the amount of tokens in existence.
250      */
251     function totalSupply() external view returns (uint256);
252 
253     /**
254      * @dev Returns the amount of tokens owned by `account`.
255      */
256     function balanceOf(address account) external view returns (uint256);
257 
258     /**
259      * @dev Moves `amount` tokens from the caller's account to `to`.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * Emits a {Transfer} event.
264      */
265     function transfer(address to, uint256 amount) external returns (bool);
266 
267     /**
268      * @dev Returns the remaining number of tokens that `spender` will be
269      * allowed to spend on behalf of `owner` through {transferFrom}. This is
270      * zero by default.
271      *
272      * This value changes when {approve} or {transferFrom} are called.
273      */
274     function allowance(address owner, address spender) external view returns (uint256);
275 
276     /**
277      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * IMPORTANT: Beware that changing an allowance with this method brings the risk
282      * that someone may use both the old and the new allowance by unfortunate
283      * transaction ordering. One possible solution to mitigate this race
284      * condition is to first reduce the spender's allowance to 0 and set the
285      * desired value afterwards:
286      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287      *
288      * Emits an {Approval} event.
289      */
290     function approve(address spender, uint256 amount) external returns (bool);
291 
292     /**
293      * @dev Moves `amount` tokens from `from` to `to` using the
294      * allowance mechanism. `amount` is then deducted from the caller's
295      * allowance.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transferFrom(
302         address from,
303         address to,
304         uint256 amount
305     ) external returns (bool);
306 }
307 
308 
309 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.1
310 
311 
312 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @dev Interface for the optional metadata functions from the ERC20 standard.
318  *
319  * _Available since v4.1._
320  */
321 interface IERC20Metadata is IERC20 {
322     /**
323      * @dev Returns the name of the token.
324      */
325     function name() external view returns (string memory);
326 
327     /**
328      * @dev Returns the symbol of the token.
329      */
330     function symbol() external view returns (string memory);
331 
332     /**
333      * @dev Returns the decimals places of the token.
334      */
335     function decimals() external view returns (uint8);
336 }
337 
338 
339 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.1
340 
341 
342 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 
347 
348 /**
349  * @dev Implementation of the {IERC20} interface.
350  *
351  * This implementation is agnostic to the way tokens are created. This means
352  * that a supply mechanism has to be added in a derived contract using {_mint}.
353  * For a generic mechanism see {ERC20PresetMinterPauser}.
354  *
355  * TIP: For a detailed writeup see our guide
356  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
357  * to implement supply mechanisms].
358  *
359  * We have followed general OpenZeppelin Contracts guidelines: functions revert
360  * instead returning `false` on failure. This behavior is nonetheless
361  * conventional and does not conflict with the expectations of ERC20
362  * applications.
363  *
364  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
365  * This allows applications to reconstruct the allowance for all accounts just
366  * by listening to said events. Other implementations of the EIP may not emit
367  * these events, as it isn't required by the specification.
368  *
369  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
370  * functions have been added to mitigate the well-known issues around setting
371  * allowances. See {IERC20-approve}.
372  */
373 contract ERC20 is Context, IERC20, IERC20Metadata {
374     mapping(address => uint256) private _balances;
375 
376     mapping(address => mapping(address => uint256)) private _allowances;
377 
378     uint256 private _totalSupply;
379 
380     string private _name;
381     string private _symbol;
382 
383     /**
384      * @dev Sets the values for {name} and {symbol}.
385      *
386      * The default value of {decimals} is 18. To select a different value for
387      * {decimals} you should overload it.
388      *
389      * All two of these values are immutable: they can only be set once during
390      * construction.
391      */
392     constructor(string memory name_, string memory symbol_) {
393         _name = name_;
394         _symbol = symbol_;
395     }
396 
397     /**
398      * @dev Returns the name of the token.
399      */
400     function name() public view virtual override returns (string memory) {
401         return _name;
402     }
403 
404     /**
405      * @dev Returns the symbol of the token, usually a shorter version of the
406      * name.
407      */
408     function symbol() public view virtual override returns (string memory) {
409         return _symbol;
410     }
411 
412     /**
413      * @dev Returns the number of decimals used to get its user representation.
414      * For example, if `decimals` equals `2`, a balance of `505` tokens should
415      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
416      *
417      * Tokens usually opt for a value of 18, imitating the relationship between
418      * Ether and Wei. This is the value {ERC20} uses, unless this function is
419      * overridden;
420      *
421      * NOTE: This information is only used for _display_ purposes: it in
422      * no way affects any of the arithmetic of the contract, including
423      * {IERC20-balanceOf} and {IERC20-transfer}.
424      */
425     function decimals() public view virtual override returns (uint8) {
426         return 18;
427     }
428 
429     /**
430      * @dev See {IERC20-totalSupply}.
431      */
432     function totalSupply() public view virtual override returns (uint256) {
433         return _totalSupply;
434     }
435 
436     /**
437      * @dev See {IERC20-balanceOf}.
438      */
439     function balanceOf(address account) public view virtual override returns (uint256) {
440         return _balances[account];
441     }
442 
443     /**
444      * @dev See {IERC20-transfer}.
445      *
446      * Requirements:
447      *
448      * - `to` cannot be the zero address.
449      * - the caller must have a balance of at least `amount`.
450      */
451     function transfer(address to, uint256 amount) public virtual override returns (bool) {
452         address owner = _msgSender();
453         _transfer(owner, to, amount);
454         return true;
455     }
456 
457     /**
458      * @dev See {IERC20-allowance}.
459      */
460     function allowance(address owner, address spender) public view virtual override returns (uint256) {
461         return _allowances[owner][spender];
462     }
463 
464     /**
465      * @dev See {IERC20-approve}.
466      *
467      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
468      * `transferFrom`. This is semantically equivalent to an infinite approval.
469      *
470      * Requirements:
471      *
472      * - `spender` cannot be the zero address.
473      */
474     function approve(address spender, uint256 amount) public virtual override returns (bool) {
475         address owner = _msgSender();
476         _approve(owner, spender, amount);
477         return true;
478     }
479 
480     /**
481      * @dev See {IERC20-transferFrom}.
482      *
483      * Emits an {Approval} event indicating the updated allowance. This is not
484      * required by the EIP. See the note at the beginning of {ERC20}.
485      *
486      * NOTE: Does not update the allowance if the current allowance
487      * is the maximum `uint256`.
488      *
489      * Requirements:
490      *
491      * - `from` and `to` cannot be the zero address.
492      * - `from` must have a balance of at least `amount`.
493      * - the caller must have allowance for ``from``'s tokens of at least
494      * `amount`.
495      */
496     function transferFrom(
497         address from,
498         address to,
499         uint256 amount
500     ) public virtual override returns (bool) {
501         address spender = _msgSender();
502         _spendAllowance(from, spender, amount);
503         _transfer(from, to, amount);
504         return true;
505     }
506 
507     /**
508      * @dev Atomically increases the allowance granted to `spender` by the caller.
509      *
510      * This is an alternative to {approve} that can be used as a mitigation for
511      * problems described in {IERC20-approve}.
512      *
513      * Emits an {Approval} event indicating the updated allowance.
514      *
515      * Requirements:
516      *
517      * - `spender` cannot be the zero address.
518      */
519     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
520         address owner = _msgSender();
521         _approve(owner, spender, allowance(owner, spender) + addedValue);
522         return true;
523     }
524 
525     /**
526      * @dev Atomically decreases the allowance granted to `spender` by the caller.
527      *
528      * This is an alternative to {approve} that can be used as a mitigation for
529      * problems described in {IERC20-approve}.
530      *
531      * Emits an {Approval} event indicating the updated allowance.
532      *
533      * Requirements:
534      *
535      * - `spender` cannot be the zero address.
536      * - `spender` must have allowance for the caller of at least
537      * `subtractedValue`.
538      */
539     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
540         address owner = _msgSender();
541         uint256 currentAllowance = allowance(owner, spender);
542         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
543         unchecked {
544             _approve(owner, spender, currentAllowance - subtractedValue);
545         }
546 
547         return true;
548     }
549 
550     /**
551      * @dev Moves `amount` of tokens from `from` to `to`.
552      *
553      * This internal function is equivalent to {transfer}, and can be used to
554      * e.g. implement automatic token fees, slashing mechanisms, etc.
555      *
556      * Emits a {Transfer} event.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `from` must have a balance of at least `amount`.
563      */
564     function _transfer(
565         address from,
566         address to,
567         uint256 amount
568     ) internal virtual {
569         require(from != address(0), "ERC20: transfer from the zero address");
570         require(to != address(0), "ERC20: transfer to the zero address");
571 
572         _beforeTokenTransfer(from, to, amount);
573 
574         uint256 fromBalance = _balances[from];
575         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
576         unchecked {
577             _balances[from] = fromBalance - amount;
578             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
579             // decrementing then incrementing.
580             _balances[to] += amount;
581         }
582 
583         emit Transfer(from, to, amount);
584 
585         _afterTokenTransfer(from, to, amount);
586     }
587 
588     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
589      * the total supply.
590      *
591      * Emits a {Transfer} event with `from` set to the zero address.
592      *
593      * Requirements:
594      *
595      * - `account` cannot be the zero address.
596      */
597     function _mint(address account, uint256 amount) internal virtual {
598         require(account != address(0), "ERC20: mint to the zero address");
599 
600         _beforeTokenTransfer(address(0), account, amount);
601 
602         _totalSupply += amount;
603         unchecked {
604             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
605             _balances[account] += amount;
606         }
607         emit Transfer(address(0), account, amount);
608 
609         _afterTokenTransfer(address(0), account, amount);
610     }
611 
612     /**
613      * @dev Destroys `amount` tokens from `account`, reducing the
614      * total supply.
615      *
616      * Emits a {Transfer} event with `to` set to the zero address.
617      *
618      * Requirements:
619      *
620      * - `account` cannot be the zero address.
621      * - `account` must have at least `amount` tokens.
622      */
623     function _burn(address account, uint256 amount) internal virtual {
624         require(account != address(0), "ERC20: burn from the zero address");
625 
626         _beforeTokenTransfer(account, address(0), amount);
627 
628         uint256 accountBalance = _balances[account];
629         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
630         unchecked {
631             _balances[account] = accountBalance - amount;
632             // Overflow not possible: amount <= accountBalance <= totalSupply.
633             _totalSupply -= amount;
634         }
635 
636         emit Transfer(account, address(0), amount);
637 
638         _afterTokenTransfer(account, address(0), amount);
639     }
640 
641     /**
642      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
643      *
644      * This internal function is equivalent to `approve`, and can be used to
645      * e.g. set automatic allowances for certain subsystems, etc.
646      *
647      * Emits an {Approval} event.
648      *
649      * Requirements:
650      *
651      * - `owner` cannot be the zero address.
652      * - `spender` cannot be the zero address.
653      */
654     function _approve(
655         address owner,
656         address spender,
657         uint256 amount
658     ) internal virtual {
659         require(owner != address(0), "ERC20: approve from the zero address");
660         require(spender != address(0), "ERC20: approve to the zero address");
661 
662         _allowances[owner][spender] = amount;
663         emit Approval(owner, spender, amount);
664     }
665 
666     /**
667      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
668      *
669      * Does not update the allowance amount in case of infinite allowance.
670      * Revert if not enough allowance is available.
671      *
672      * Might emit an {Approval} event.
673      */
674     function _spendAllowance(
675         address owner,
676         address spender,
677         uint256 amount
678     ) internal virtual {
679         uint256 currentAllowance = allowance(owner, spender);
680         if (currentAllowance != type(uint256).max) {
681             require(currentAllowance >= amount, "ERC20: insufficient allowance");
682             unchecked {
683                 _approve(owner, spender, currentAllowance - amount);
684             }
685         }
686     }
687 
688     /**
689      * @dev Hook that is called before any transfer of tokens. This includes
690      * minting and burning.
691      *
692      * Calling conditions:
693      *
694      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
695      * will be transferred to `to`.
696      * - when `from` is zero, `amount` tokens will be minted for `to`.
697      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
698      * - `from` and `to` are never both zero.
699      *
700      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
701      */
702     function _beforeTokenTransfer(
703         address from,
704         address to,
705         uint256 amount
706     ) internal virtual {}
707 
708     /**
709      * @dev Hook that is called after any transfer of tokens. This includes
710      * minting and burning.
711      *
712      * Calling conditions:
713      *
714      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
715      * has been transferred to `to`.
716      * - when `from` is zero, `amount` tokens have been minted for `to`.
717      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
718      * - `from` and `to` are never both zero.
719      *
720      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
721      */
722     function _afterTokenTransfer(
723         address from,
724         address to,
725         uint256 amount
726     ) internal virtual {}
727 }
728 
729 
730 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.8.1
731 
732 
733 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 
738 /**
739  * @dev Extension of {ERC20} that allows token holders to destroy both their own
740  * tokens and those that they have an allowance for, in a way that can be
741  * recognized off-chain (via event analysis).
742  */
743 abstract contract ERC20Burnable is Context, ERC20 {
744     /**
745      * @dev Destroys `amount` tokens from the caller.
746      *
747      * See {ERC20-_burn}.
748      */
749     function burn(uint256 amount) public virtual {
750         _burn(_msgSender(), amount);
751     }
752 
753     /**
754      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
755      * allowance.
756      *
757      * See {ERC20-_burn} and {ERC20-allowance}.
758      *
759      * Requirements:
760      *
761      * - the caller must have allowance for ``accounts``'s tokens of at least
762      * `amount`.
763      */
764     function burnFrom(address account, uint256 amount) public virtual {
765         _spendAllowance(account, _msgSender(), amount);
766         _burn(account, amount);
767     }
768 }
769 
770 
771 // File contracts/frp.sol
772 
773 
774 pragma solidity 0.8.18;
775 /** Amount must be greater than zero */
776 error NoZeroTransfers();
777 /** Amount exceeds max transaction */
778 error LimitExceeded();
779 /** Not allowed */
780 error NotAllowed();
781 /** Paused */
782 error ContractPaused();
783 /** Reserve + Distribution must equal Total Supply (sanity check) */
784 error IncorrectSum();
785 
786 
787 contract BoringCoin is Ownable,Pausable, ERC20Burnable {
788 
789     bool public tradingStarted;
790 
791     uint256 private constant  TOTAL_SUPPLY    = 690_000_000_000 ether;
792     uint256 private constant  RESERVE         = 69_000_000_000 ether;
793     uint256 private constant  ALLOCATION      = 621_000_000_000 ether;
794     uint256 public constant   MAX_BUY         = 10_350_000_000 ether;
795 
796     uint256 public constant blockCount = 3;
797     uint256 public deadblockStart;
798 
799     uint256 public maxHoldingAmount;
800     uint256 public minHoldingAmount;
801 
802     address public uniswapV2Pair;
803 
804     mapping(address => bool) private whitelist;
805     mapping(address => uint) private lastBlockTransfer;
806     mapping(address => bool) private poolList;
807 
808     constructor(address _vault) ERC20("Boring Coin", "BORING") 
809     {
810         if (RESERVE + ALLOCATION != TOTAL_SUPPLY) { revert IncorrectSum(); }
811 
812         whitelist[msg.sender] = true;
813 
814         _mint(_vault, RESERVE);
815         _mint(msg.sender, ALLOCATION);
816 
817         _pause();
818     }
819 
820     function setPools(address[] calldata _val) external onlyOwner {
821         for (uint256 i = 0; i < _val.length; i++) {
822             address _pool = _val[i];
823             poolList[_pool] = true;
824         }
825     }
826 
827     function _isContract(address _address) internal view returns (bool) {
828         uint32 size;
829         assembly {
830             size := extcodesize(_address)
831         }
832         return (size > 0);
833     }
834 
835     function pause() external onlyOwner {
836         _pause();
837     }
838 
839     function unpause() external onlyOwner {
840         deadblockStart = block.number;
841         _unpause();
842     }
843 
844     function _checkIfBot(address _address) internal view returns (bool) {
845         return (block.number < blockCount + deadblockStart || _isContract(_address)) && !whitelist[_address];
846     }
847 
848     function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal override {
849         if (amount == 0) { revert NoZeroTransfers(); }
850         super._beforeTokenTransfer(sender, recipient, amount);
851 
852         if (paused() && !whitelist[sender]) { revert ContractPaused(); }
853 
854         if (block.number == lastBlockTransfer[sender] || block.number == lastBlockTransfer[recipient]) {
855             revert NotAllowed();
856         }
857 
858         bool buyer = poolList[sender];
859         bool seller = poolList[recipient];
860 
861         if (buyer) {
862             if (_checkIfBot(recipient)) { revert NotAllowed(); }
863             if (amount > MAX_BUY) { revert LimitExceeded(); }
864                 lastBlockTransfer[recipient] = block.number;
865             } else if (seller) {
866                 lastBlockTransfer[sender] = block.number;
867         }
868     }
869 
870 }