1 // SPDX-License-Identifier: MIT
2 //  
3 //     ___                     _                 _                   
4 //    / _ \_ __ __ _ _ __   __| |_ __   __ _    /_\  _ __   ___  ___ 
5 //   / /_\/ '__/ _` | '_ \ / _` | '_ \ / _` |  //_\\| '_ \ / _ \/ __|
6 //  / /_\\| | | (_| | | | | (_| | |_) | (_| | /  _  \ |_) |  __/\__ \
7 //  \____/|_|  \__,_|_| |_|\__,_| .__/ \__,_| \_/ \_/ .__/ \___||___/
8 //                              |_|                 |_|              
9 //              __,__
10 //     .--.  .-"     "-.  .--.
11 //    / .. \/  .-. .-.  \/ .. \
12 //   | |  '|  /   Y   \  |'  | |
13 //   | \   \  \ 0 | 0 /  /   / |
14 //    \ '- ,\.-"`` ``"-./, -' /
15 //     `'-' /_   ^ ^   _\ '-'`
16 //         |  \._   _./  |
17 //         \   \ `~` /   /
18 //          '._ '-=-' _.'
19 //             '~---~'
20 //  
21 // File: @openzeppelin/contracts/utils/Context.sol
22 
23 
24 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes calldata) {
44         return msg.data;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/access/Ownable.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 
56 /**
57  * @dev Contract module which provides a basic access control mechanism, where
58  * there is an account (an owner) that can be granted exclusive access to
59  * specific functions.
60  *
61  * By default, the owner account will be the one that deploys the contract. This
62  * can later be changed with {transferOwnership}.
63  *
64  * This module is used through inheritance. It will make available the modifier
65  * `onlyOwner`, which can be applied to your functions to restrict their use to
66  * the owner.
67  */
68 abstract contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     /**
74      * @dev Initializes the contract setting the deployer as the initial owner.
75      */
76     constructor() {
77         _transferOwnership(_msgSender());
78     }
79 
80     /**
81      * @dev Returns the address of the current owner.
82      */
83     function owner() public view virtual returns (address) {
84         return _owner;
85     }
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(owner() == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     /**
96      * @dev Leaves the contract without owner. It will not be possible to call
97      * `onlyOwner` functions anymore. Can only be called by the current owner.
98      *
99      * NOTE: Renouncing ownership will leave the contract without an owner,
100      * thereby removing any functionality that is only available to the owner.
101      */
102     function renounceOwnership() public virtual onlyOwner {
103         _transferOwnership(address(0));
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Can only be called by the current owner.
109      */
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         _transferOwnership(newOwner);
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Internal function without access restriction.
118      */
119     function _transferOwnership(address newOwner) internal virtual {
120         address oldOwner = _owner;
121         _owner = newOwner;
122         emit OwnershipTransferred(oldOwner, newOwner);
123     }
124 }
125 
126 // File: @openzeppelin/contracts/security/Pausable.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 
134 /**
135  * @dev Contract module which allows children to implement an emergency stop
136  * mechanism that can be triggered by an authorized account.
137  *
138  * This module is used through inheritance. It will make available the
139  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
140  * the functions of your contract. Note that they will not be pausable by
141  * simply including this module, only once the modifiers are put in place.
142  */
143 abstract contract Pausable is Context {
144     /**
145      * @dev Emitted when the pause is triggered by `account`.
146      */
147     event Paused(address account);
148 
149     /**
150      * @dev Emitted when the pause is lifted by `account`.
151      */
152     event Unpaused(address account);
153 
154     bool private _paused;
155 
156     /**
157      * @dev Initializes the contract in unpaused state.
158      */
159     constructor() {
160         _paused = false;
161     }
162 
163     /**
164      * @dev Returns true if the contract is paused, and false otherwise.
165      */
166     function paused() public view virtual returns (bool) {
167         return _paused;
168     }
169 
170     /**
171      * @dev Modifier to make a function callable only when the contract is not paused.
172      *
173      * Requirements:
174      *
175      * - The contract must not be paused.
176      */
177     modifier whenNotPaused() {
178         require(!paused(), "Pausable: paused");
179         _;
180     }
181 
182     /**
183      * @dev Modifier to make a function callable only when the contract is paused.
184      *
185      * Requirements:
186      *
187      * - The contract must be paused.
188      */
189     modifier whenPaused() {
190         require(paused(), "Pausable: not paused");
191         _;
192     }
193 
194     /**
195      * @dev Triggers stopped state.
196      *
197      * Requirements:
198      *
199      * - The contract must not be paused.
200      */
201     function _pause() internal virtual whenNotPaused {
202         _paused = true;
203         emit Paused(_msgSender());
204     }
205 
206     /**
207      * @dev Returns to normal state.
208      *
209      * Requirements:
210      *
211      * - The contract must be paused.
212      */
213     function _unpause() internal virtual whenPaused {
214         _paused = false;
215         emit Unpaused(_msgSender());
216     }
217 }
218 
219 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
220 
221 
222 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @dev Interface of the ERC20 standard as defined in the EIP.
228  */
229 interface IERC20 {
230     /**
231      * @dev Returns the amount of tokens in existence.
232      */
233     function totalSupply() external view returns (uint256);
234 
235     /**
236      * @dev Returns the amount of tokens owned by `account`.
237      */
238     function balanceOf(address account) external view returns (uint256);
239 
240     /**
241      * @dev Moves `amount` tokens from the caller's account to `to`.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transfer(address to, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Returns the remaining number of tokens that `spender` will be
251      * allowed to spend on behalf of `owner` through {transferFrom}. This is
252      * zero by default.
253      *
254      * This value changes when {approve} or {transferFrom} are called.
255      */
256     function allowance(address owner, address spender) external view returns (uint256);
257 
258     /**
259      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * IMPORTANT: Beware that changing an allowance with this method brings the risk
264      * that someone may use both the old and the new allowance by unfortunate
265      * transaction ordering. One possible solution to mitigate this race
266      * condition is to first reduce the spender's allowance to 0 and set the
267      * desired value afterwards:
268      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269      *
270      * Emits an {Approval} event.
271      */
272     function approve(address spender, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Moves `amount` tokens from `from` to `to` using the
276      * allowance mechanism. `amount` is then deducted from the caller's
277      * allowance.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transferFrom(
284         address from,
285         address to,
286         uint256 amount
287     ) external returns (bool);
288 
289     /**
290      * @dev Emitted when `value` tokens are moved from one account (`from`) to
291      * another (`to`).
292      *
293      * Note that `value` may be zero.
294      */
295     event Transfer(address indexed from, address indexed to, uint256 value);
296 
297     /**
298      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
299      * a call to {approve}. `value` is the new allowance.
300      */
301     event Approval(address indexed owner, address indexed spender, uint256 value);
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 
312 /**
313  * @dev Interface for the optional metadata functions from the ERC20 standard.
314  *
315  * _Available since v4.1._
316  */
317 interface IERC20Metadata is IERC20 {
318     /**
319      * @dev Returns the name of the token.
320      */
321     function name() external view returns (string memory);
322 
323     /**
324      * @dev Returns the symbol of the token.
325      */
326     function symbol() external view returns (string memory);
327 
328     /**
329      * @dev Returns the decimals places of the token.
330      */
331     function decimals() external view returns (uint8);
332 }
333 
334 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
335 
336 
337 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 
342 
343 
344 /**
345  * @dev Implementation of the {IERC20} interface.
346  *
347  * This implementation is agnostic to the way tokens are created. This means
348  * that a supply mechanism has to be added in a derived contract using {_mint}.
349  * For a generic mechanism see {ERC20PresetMinterPauser}.
350  *
351  * TIP: For a detailed writeup see our guide
352  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
353  * to implement supply mechanisms].
354  *
355  * We have followed general OpenZeppelin Contracts guidelines: functions revert
356  * instead returning `false` on failure. This behavior is nonetheless
357  * conventional and does not conflict with the expectations of ERC20
358  * applications.
359  *
360  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
361  * This allows applications to reconstruct the allowance for all accounts just
362  * by listening to said events. Other implementations of the EIP may not emit
363  * these events, as it isn't required by the specification.
364  *
365  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
366  * functions have been added to mitigate the well-known issues around setting
367  * allowances. See {IERC20-approve}.
368  */
369 contract ERC20 is Context, IERC20, IERC20Metadata {
370     mapping(address => uint256) private _balances;
371 
372     mapping(address => mapping(address => uint256)) private _allowances;
373 
374     uint256 private _totalSupply;
375 
376     string private _name;
377     string private _symbol;
378 
379     /**
380      * @dev Sets the values for {name} and {symbol}.
381      *
382      * The default value of {decimals} is 18. To select a different value for
383      * {decimals} you should overload it.
384      *
385      * All two of these values are immutable: they can only be set once during
386      * construction.
387      */
388     constructor(string memory name_, string memory symbol_) {
389         _name = name_;
390         _symbol = symbol_;
391     }
392 
393     /**
394      * @dev Returns the name of the token.
395      */
396     function name() public view virtual override returns (string memory) {
397         return _name;
398     }
399 
400     /**
401      * @dev Returns the symbol of the token, usually a shorter version of the
402      * name.
403      */
404     function symbol() public view virtual override returns (string memory) {
405         return _symbol;
406     }
407 
408     /**
409      * @dev Returns the number of decimals used to get its user representation.
410      * For example, if `decimals` equals `2`, a balance of `505` tokens should
411      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
412      *
413      * Tokens usually opt for a value of 18, imitating the relationship between
414      * Ether and Wei. This is the value {ERC20} uses, unless this function is
415      * overridden;
416      *
417      * NOTE: This information is only used for _display_ purposes: it in
418      * no way affects any of the arithmetic of the contract, including
419      * {IERC20-balanceOf} and {IERC20-transfer}.
420      */
421     function decimals() public view virtual override returns (uint8) {
422         return 18;
423     }
424 
425     /**
426      * @dev See {IERC20-totalSupply}.
427      */
428     function totalSupply() public view virtual override returns (uint256) {
429         return _totalSupply;
430     }
431 
432     /**
433      * @dev See {IERC20-balanceOf}.
434      */
435     function balanceOf(address account) public view virtual override returns (uint256) {
436         return _balances[account];
437     }
438 
439     /**
440      * @dev See {IERC20-transfer}.
441      *
442      * Requirements:
443      *
444      * - `to` cannot be the zero address.
445      * - the caller must have a balance of at least `amount`.
446      */
447     function transfer(address to, uint256 amount) public virtual override returns (bool) {
448         address owner = _msgSender();
449         _transfer(owner, to, amount);
450         return true;
451     }
452 
453     /**
454      * @dev See {IERC20-allowance}.
455      */
456     function allowance(address owner, address spender) public view virtual override returns (uint256) {
457         return _allowances[owner][spender];
458     }
459 
460     /**
461      * @dev See {IERC20-approve}.
462      *
463      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
464      * `transferFrom`. This is semantically equivalent to an infinite approval.
465      *
466      * Requirements:
467      *
468      * - `spender` cannot be the zero address.
469      */
470     function approve(address spender, uint256 amount) public virtual override returns (bool) {
471         address owner = _msgSender();
472         _approve(owner, spender, amount);
473         return true;
474     }
475 
476     /**
477      * @dev See {IERC20-transferFrom}.
478      *
479      * Emits an {Approval} event indicating the updated allowance. This is not
480      * required by the EIP. See the note at the beginning of {ERC20}.
481      *
482      * NOTE: Does not update the allowance if the current allowance
483      * is the maximum `uint256`.
484      *
485      * Requirements:
486      *
487      * - `from` and `to` cannot be the zero address.
488      * - `from` must have a balance of at least `amount`.
489      * - the caller must have allowance for ``from``'s tokens of at least
490      * `amount`.
491      */
492     function transferFrom(
493         address from,
494         address to,
495         uint256 amount
496     ) public virtual override returns (bool) {
497         address spender = _msgSender();
498         _spendAllowance(from, spender, amount);
499         _transfer(from, to, amount);
500         return true;
501     }
502 
503     /**
504      * @dev Atomically increases the allowance granted to `spender` by the caller.
505      *
506      * This is an alternative to {approve} that can be used as a mitigation for
507      * problems described in {IERC20-approve}.
508      *
509      * Emits an {Approval} event indicating the updated allowance.
510      *
511      * Requirements:
512      *
513      * - `spender` cannot be the zero address.
514      */
515     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
516         address owner = _msgSender();
517         _approve(owner, spender, _allowances[owner][spender] + addedValue);
518         return true;
519     }
520 
521     /**
522      * @dev Atomically decreases the allowance granted to `spender` by the caller.
523      *
524      * This is an alternative to {approve} that can be used as a mitigation for
525      * problems described in {IERC20-approve}.
526      *
527      * Emits an {Approval} event indicating the updated allowance.
528      *
529      * Requirements:
530      *
531      * - `spender` cannot be the zero address.
532      * - `spender` must have allowance for the caller of at least
533      * `subtractedValue`.
534      */
535     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
536         address owner = _msgSender();
537         uint256 currentAllowance = _allowances[owner][spender];
538         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
539         unchecked {
540             _approve(owner, spender, currentAllowance - subtractedValue);
541         }
542 
543         return true;
544     }
545 
546     /**
547      * @dev Moves `amount` of tokens from `sender` to `recipient`.
548      *
549      * This internal function is equivalent to {transfer}, and can be used to
550      * e.g. implement automatic token fees, slashing mechanisms, etc.
551      *
552      * Emits a {Transfer} event.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `from` must have a balance of at least `amount`.
559      */
560     function _transfer(
561         address from,
562         address to,
563         uint256 amount
564     ) internal virtual {
565         require(from != address(0), "ERC20: transfer from the zero address");
566         require(to != address(0), "ERC20: transfer to the zero address");
567 
568         _beforeTokenTransfer(from, to, amount);
569 
570         uint256 fromBalance = _balances[from];
571         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
572         unchecked {
573             _balances[from] = fromBalance - amount;
574         }
575         _balances[to] += amount;
576 
577         emit Transfer(from, to, amount);
578 
579         _afterTokenTransfer(from, to, amount);
580     }
581 
582     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
583      * the total supply.
584      *
585      * Emits a {Transfer} event with `from` set to the zero address.
586      *
587      * Requirements:
588      *
589      * - `account` cannot be the zero address.
590      */
591     function _mint(address account, uint256 amount) internal virtual {
592         require(account != address(0), "ERC20: mint to the zero address");
593 
594         _beforeTokenTransfer(address(0), account, amount);
595 
596         _totalSupply += amount;
597         _balances[account] += amount;
598         emit Transfer(address(0), account, amount);
599 
600         _afterTokenTransfer(address(0), account, amount);
601     }
602 
603     /**
604      * @dev Destroys `amount` tokens from `account`, reducing the
605      * total supply.
606      *
607      * Emits a {Transfer} event with `to` set to the zero address.
608      *
609      * Requirements:
610      *
611      * - `account` cannot be the zero address.
612      * - `account` must have at least `amount` tokens.
613      */
614     function _burn(address account, uint256 amount) internal virtual {
615         require(account != address(0), "ERC20: burn from the zero address");
616 
617         _beforeTokenTransfer(account, address(0), amount);
618 
619         uint256 accountBalance = _balances[account];
620         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
621         unchecked {
622             _balances[account] = accountBalance - amount;
623         }
624         _totalSupply -= amount;
625 
626         emit Transfer(account, address(0), amount);
627 
628         _afterTokenTransfer(account, address(0), amount);
629     }
630 
631     /**
632      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
633      *
634      * This internal function is equivalent to `approve`, and can be used to
635      * e.g. set automatic allowances for certain subsystems, etc.
636      *
637      * Emits an {Approval} event.
638      *
639      * Requirements:
640      *
641      * - `owner` cannot be the zero address.
642      * - `spender` cannot be the zero address.
643      */
644     function _approve(
645         address owner,
646         address spender,
647         uint256 amount
648     ) internal virtual {
649         require(owner != address(0), "ERC20: approve from the zero address");
650         require(spender != address(0), "ERC20: approve to the zero address");
651 
652         _allowances[owner][spender] = amount;
653         emit Approval(owner, spender, amount);
654     }
655 
656     /**
657      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
658      *
659      * Does not update the allowance amount in case of infinite allowance.
660      * Revert if not enough allowance is available.
661      *
662      * Might emit an {Approval} event.
663      */
664     function _spendAllowance(
665         address owner,
666         address spender,
667         uint256 amount
668     ) internal virtual {
669         uint256 currentAllowance = allowance(owner, spender);
670         if (currentAllowance != type(uint256).max) {
671             require(currentAllowance >= amount, "ERC20: insufficient allowance");
672             unchecked {
673                 _approve(owner, spender, currentAllowance - amount);
674             }
675         }
676     }
677 
678     /**
679      * @dev Hook that is called before any transfer of tokens. This includes
680      * minting and burning.
681      *
682      * Calling conditions:
683      *
684      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
685      * will be transferred to `to`.
686      * - when `from` is zero, `amount` tokens will be minted for `to`.
687      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
688      * - `from` and `to` are never both zero.
689      *
690      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
691      */
692     function _beforeTokenTransfer(
693         address from,
694         address to,
695         uint256 amount
696     ) internal virtual {}
697 
698     /**
699      * @dev Hook that is called after any transfer of tokens. This includes
700      * minting and burning.
701      *
702      * Calling conditions:
703      *
704      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
705      * has been transferred to `to`.
706      * - when `from` is zero, `amount` tokens have been minted for `to`.
707      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
708      * - `from` and `to` are never both zero.
709      *
710      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
711      */
712     function _afterTokenTransfer(
713         address from,
714         address to,
715         uint256 amount
716     ) internal virtual {}
717 }
718 
719 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
720 
721 
722 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 
727 
728 /**
729  * @dev Extension of {ERC20} that allows token holders to destroy both their own
730  * tokens and those that they have an allowance for, in a way that can be
731  * recognized off-chain (via event analysis).
732  */
733 abstract contract ERC20Burnable is Context, ERC20 {
734     /**
735      * @dev Destroys `amount` tokens from the caller.
736      *
737      * See {ERC20-_burn}.
738      */
739     function burn(uint256 amount) public virtual {
740         _burn(_msgSender(), amount);
741     }
742 
743     /**
744      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
745      * allowance.
746      *
747      * See {ERC20-_burn} and {ERC20-allowance}.
748      *
749      * Requirements:
750      *
751      * - the caller must have allowance for ``accounts``'s tokens of at least
752      * `amount`.
753      */
754     function burnFrom(address account, uint256 amount) public virtual {
755         _spendAllowance(account, _msgSender(), amount);
756         _burn(account, amount);
757     }
758 }
759 
760 // File: contracts/Gramps.sol
761 
762 
763 pragma solidity ^0.8.4;
764 //  
765 //     ___                     _                 _                   
766 //    / _ \_ __ __ _ _ __   __| |_ __   __ _    /_\  _ __   ___  ___ 
767 //   / /_\/ '__/ _` | '_ \ / _` | '_ \ / _` |  //_\\| '_ \ / _ \/ __|
768 //  / /_\\| | | (_| | | | | (_| | |_) | (_| | /  _  \ |_) |  __/\__ \
769 //  \____/|_|  \__,_|_| |_|\__,_| .__/ \__,_| \_/ \_/ .__/ \___||___/
770 //                              |_|                 |_|              
771 //              __,__
772 //     .--.  .-"     "-.  .--.
773 //    / .. \/  .-. .-.  \/ .. \
774 //   | |  '|  /   Y   \  |'  | |
775 //   | \   \  \ 0 | 0 /  /   / |
776 //    \ '- ,\.-"`` ``"-./, -' /
777 //     `'-' /_   ^ ^   _\ '-'`
778 //         |  \._   _./  |
779 //         \   \ `~` /   /
780 //          '._ '-=-' _.'
781 //             '~---~'
782 //  
783 
784 
785 
786 
787 
788 contract Gramps is ERC20, ERC20Burnable, Pausable, Ownable {
789 
790   uint256 public costToBuy = 1000000000000 wei;
791   uint256 public tokenSellValue = 900000000000 wei;
792   uint256 public reserveAmount = 100000;
793   uint256 public reserveEth = 1000000000000000000 wei;
794   bool public mintStatus = false;
795   bool public claimTokensStatus = false;
796   bool public buyTokensStatus = false;
797   bool public sellTokensStatus = false;
798   bool public sendTokensBackStatus = false;
799   mapping(string => bytes32) public signatures;
800   event tokensClaimed(address indexed _by, string indexed nftTokenId, uint _amount);
801   event tokensBought(address indexed _by, uint256 _eth, uint256 _amount);
802   event tokensSold(address indexed _by, uint256 _amount, uint256 amountOfETHToTransfer);
803 
804     constructor(uint256 initialSupply) ERC20("Gramps", "GRAMPS") {
805 	 _mint(address(this), initialSupply);
806 	}
807 
808 	// Pause
809     function pause() public onlyOwner {
810         _pause();
811     }
812 
813 	// Unpause
814     function unpause() public onlyOwner {
815         _unpause();
816     }
817 
818 	// Owner Mint
819     function mint(address to, uint256 amount) public onlyOwner {
820      require(mintStatus, "Minting is not allowed at the moment.");
821      _mint(to, amount);
822     }
823 
824 	// Before Token Transfer
825     function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override
826     {
827 	 super._beforeTokenTransfer(from, to, amount);
828     }
829 	
830     // Auth
831 	//
832 	// DEVELOPED BY gallaghersean.eth
833 	// ATTENTION: If you would like to use this function in your contract, send 1 eth to gallaghersean.eth and you'll receive the rights to use the function AND 2 hours of development time to help implementing it.
834 	// (c) Copyright 2022 gallaghersean.eth All Rights Reserved
835 	//
836     function auth(string memory nftTokenId, string memory privateKey, bytes32 newSignature) internal {
837      require(signatures[nftTokenId] != "","Authentication failed!");
838 	 bytes32 signature = keccak256(abi.encodePacked(nftTokenId,privateKey));
839      require(signatures[nftTokenId] == signature,"Authentication failed!");
840 	 signatures[nftTokenId] = newSignature;
841     }
842 	
843 	// Update Signatures
844 	function updateSignatures(string[] calldata nftTokenIds, bytes32[] calldata _signatures) public onlyOwner {
845      for (uint256 i=0; i < nftTokenIds.length; i++) {
846 	  string memory nftTokenId = nftTokenIds[i];
847 	  bytes32 signature = _signatures[i];
848 	  signatures[nftTokenId] = signature;
849 	 }
850 	}
851 	
852 	// Claim Tokens
853 	function claimTokens(uint _amount, string memory nftTokenId, string memory privateKey, bytes32 newSignature) public {
854      require(claimTokensStatus, "Claiming tokens is not active at the moment.");
855 	 auth(nftTokenId,privateKey,newSignature);
856      require(_amount > 0, "You have to claim at least 1 token.");
857      uint256 contractBalance = ERC20(address(this)).balanceOf(address(this));
858      require(contractBalance >= _amount, "Contract does not have enough tokens for you to claim right now.");
859      require((contractBalance - _amount) >= reserveAmount, "Contract does not have enough tokens for you to claim right now.");
860      (bool sent) = ERC20(address(this)).transfer(msg.sender, _amount);
861      require(sent, "Failed to transfer tokens.");
862      emit tokensClaimed(msg.sender, nftTokenId, _amount);
863 	}
864 	
865 	// Buy Tokens
866 	function buyTokens(uint256 _amount) public payable returns (uint256 _amountBought) {
867      require(buyTokensStatus, "Buying tokens is not active at the moment.");
868 	 if (msg.sender != owner()) {
869       require(msg.value > 0, "Send ETH to buy some tokens.");
870       uint256 ethCost = costToBuy * _amount;
871       require(msg.value >= ethCost, "Not enough ETH to buy tokens.");
872       uint256 contractBalance = ERC20(address(this)).balanceOf(address(this));
873       require(contractBalance >= _amount, "Contract does not have enough tokens for your purchase.");
874       require((contractBalance - _amount) >= reserveAmount, "Contract does not have enough tokens for your purchase.");
875 	 }
876      (bool sent) = ERC20(address(this)).transfer(msg.sender, _amount);
877      require(sent, "Failed to transfer tokens.");
878      emit tokensBought(msg.sender, msg.value, _amount);
879      return _amount;
880 	}
881 
882 	// Sell Tokens
883     function sellTokens(uint256 _amount) public {
884      require(sellTokensStatus, "Selling tokens is not active at the moment.");
885      require(_amount > 0, "Specify an amount of tokens greater than zero.");
886      uint256 userBalance = ERC20(address(this)).balanceOf(msg.sender);
887      require(userBalance >= _amount, "Your balance is lower than the amount of tokens you want to sell.");
888      uint256 amountOfETHToTransfer = _amount * tokenSellValue;
889      uint256 contractETHBalance = address(this).balance;
890      require(contractETHBalance >= amountOfETHToTransfer, "Contract does not have enough funds to accept the sell request.");
891      require((contractETHBalance - reserveEth) >= amountOfETHToTransfer, "Contract does not have enough funds to accept the sell request.");
892 	 approve(address(this), _amount);
893      (bool sent) = ERC20(address(this)).transferFrom(msg.sender, address(this), _amount);
894      require(sent, "Failed to transfer tokens.");
895      (sent,) = msg.sender.call{value: amountOfETHToTransfer}("");
896      require(sent, "Failed to send ETH.");
897      emit tokensSold(msg.sender, _amount, amountOfETHToTransfer);
898     }
899 	
900 	// Send Tokens Back to Contract
901 	function sendTokensBack(uint256 _amount) public {
902      require(sendTokensBackStatus, "Sending tokens back is not active at the moment.");
903      require(_amount > 0, "Specify an amount of tokens greater than zero.");
904      uint256 userBalance = ERC20(address(this)).balanceOf(msg.sender);
905      require(userBalance >= _amount, "Your balance is lower than the amount of tokens needed.");
906 	 approve(address(this), _amount);
907      (bool sent) = ERC20(address(this)).transferFrom(msg.sender, address(this), _amount);
908      require(sent, "Failed to transfer tokens.");
909 	}
910 	
911 	// Get Status
912     function getStatus(string memory _type) public view returns (bool _status) {
913 	 if(compare(_type,"claimTokens")) { _status = claimTokensStatus; }
914 	 else if(compare(_type,"buyTokens")) { _status = buyTokensStatus; }
915 	 else if(compare(_type,"sellTokens")) { _status = sellTokensStatus; }
916 	 else if(compare(_type,"sendTokensBack")) { _status = sendTokensBackStatus; }
917      return _status;
918 	}
919 	
920 	// Set Status
921     function setStatus(string[] calldata _type, bool[] calldata _status) public onlyOwner {
922      for (uint i=0; i < _type.length; i++) {
923 	  if(compare(_type[i],"mint")) { mintStatus = _status[i]; }
924 	  else if(compare(_type[i],"claimTokens")) { claimTokensStatus = _status[i]; }
925 	  else if(compare(_type[i],"buyTokens")) { buyTokensStatus = _status[i]; }
926 	  else if(compare(_type[i],"sellTokens")) { sellTokensStatus = _status[i]; }
927 	  else if(compare(_type[i],"sendTokensBack")) { sendTokensBackStatus = _status[i]; }
928      }
929 	}
930 	
931 	// Change Values for costToBuy and tokenSellValue and reserveAmount
932 	function changeVars(string[] calldata _vars,uint256[] calldata _amounts) public onlyOwner {
933      for (uint i=0; i < _vars.length; i++) {
934 	  if(compare(_vars[i],"costToBuy")) { costToBuy = _amounts[i]; }
935 	  else if(compare(_vars[i],"tokenSellValue")) { tokenSellValue = _amounts[i]; }
936 	  else if(compare(_vars[i],"reserveAmount")) { reserveAmount = _amounts[i]; }
937       else if(compare(_vars[i],"reserveEth")) { reserveEth = _amounts[i]; }
938 	 }
939 	}
940 	
941 	// Withdraw Exact Amount
942 	function withdrawAmount(uint256 _amount) public onlyOwner {
943      uint256 ownerBalance = address(this).balance;
944      require(ownerBalance >= _amount, "The contract does not have enough of a balance to withdraw.");
945      (bool sent,) = msg.sender.call{value: _amount}("");
946      require(sent, "Failed to send withdraw.");
947     }
948 	
949 	// Withdraw
950 	function withdraw() public onlyOwner {
951      uint256 ownerBalance = address(this).balance;
952      require(ownerBalance > 0, "The contract does not have a balance to withdraw.");
953      (bool sent,) = msg.sender.call{value: address(this).balance}("");
954      require(sent, "Failed to send withdraw.");
955     }
956    
957     // Compare Strings
958     function compare(string memory a, string memory b) public pure returns(bool) {
959      return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
960     }
961 }