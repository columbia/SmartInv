1 // Sources flattened with hardhat v2.14.0 https://hardhat.org
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 // File @openzeppelin/contracts/utils/Context.sol@v4.8.3
7 
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
32 
33 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.3
34 
35 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         _checkOwner();
68         _;
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if the sender is not the owner.
80      */
81     function _checkOwner() internal view virtual {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 
117 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.3
118 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Interface of the ERC20 standard as defined in the EIP.
124  */
125 interface IERC20 {
126     /**
127      * @dev Emitted when `value` tokens are moved from one account (`from`) to
128      * another (`to`).
129      *
130      * Note that `value` may be zero.
131      */
132     event Transfer(address indexed from, address indexed to, uint256 value);
133 
134     /**
135      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
136      * a call to {approve}. `value` is the new allowance.
137      */
138     event Approval(address indexed owner, address indexed spender, uint256 value);
139 
140     /**
141      * @dev Returns the amount of tokens in existence.
142      */
143     function totalSupply() external view returns (uint256);
144 
145     /**
146      * @dev Returns the amount of tokens owned by `account`.
147      */
148     function balanceOf(address account) external view returns (uint256);
149 
150     /**
151      * @dev Moves `amount` tokens from the caller's account to `to`.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transfer(address to, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Returns the remaining number of tokens that `spender` will be
161      * allowed to spend on behalf of `owner` through {transferFrom}. This is
162      * zero by default.
163      *
164      * This value changes when {approve} or {transferFrom} are called.
165      */
166     function allowance(address owner, address spender) external view returns (uint256);
167 
168     /**
169      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * IMPORTANT: Beware that changing an allowance with this method brings the risk
174      * that someone may use both the old and the new allowance by unfortunate
175      * transaction ordering. One possible solution to mitigate this race
176      * condition is to first reduce the spender's allowance to 0 and set the
177      * desired value afterwards:
178      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179      *
180      * Emits an {Approval} event.
181      */
182     function approve(address spender, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Moves `amount` tokens from `from` to `to` using the
186      * allowance mechanism. `amount` is then deducted from the caller's
187      * allowance.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transferFrom(
194         address from,
195         address to,
196         uint256 amount
197     ) external returns (bool);
198 }
199 
200 
201 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.3
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Interface for the optional metadata functions from the ERC20 standard.
210  *
211  * _Available since v4.1._
212  */
213 interface IERC20Metadata is IERC20 {
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the symbol of the token.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the decimals places of the token.
226      */
227     function decimals() external view returns (uint8);
228 }
229 
230 
231 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.3
232 
233 
234 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 
239 
240 /**
241  * @dev Implementation of the {IERC20} interface.
242  *
243  * This implementation is agnostic to the way tokens are created. This means
244  * that a supply mechanism has to be added in a derived contract using {_mint}.
245  * For a generic mechanism see {ERC20PresetMinterPauser}.
246  *
247  * TIP: For a detailed writeup see our guide
248  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
249  * to implement supply mechanisms].
250  *
251  * We have followed general OpenZeppelin Contracts guidelines: functions revert
252  * instead returning `false` on failure. This behavior is nonetheless
253  * conventional and does not conflict with the expectations of ERC20
254  * applications.
255  *
256  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
257  * This allows applications to reconstruct the allowance for all accounts just
258  * by listening to said events. Other implementations of the EIP may not emit
259  * these events, as it isn't required by the specification.
260  *
261  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
262  * functions have been added to mitigate the well-known issues around setting
263  * allowances. See {IERC20-approve}.
264  */
265 contract ERC20 is Context, IERC20, IERC20Metadata {
266     mapping(address => uint256) private _balances;
267 
268     mapping(address => mapping(address => uint256)) private _allowances;
269 
270     uint256 private _totalSupply;
271 
272     string private _name;
273     string private _symbol;
274 
275     /**
276      * @dev Sets the values for {name} and {symbol}.
277      *
278      * The default value of {decimals} is 18. To select a different value for
279      * {decimals} you should overload it.
280      *
281      * All two of these values are immutable: they can only be set once during
282      * construction.
283      */
284     constructor(string memory name_, string memory symbol_) {
285         _name = name_;
286         _symbol = symbol_;
287     }
288 
289     /**
290      * @dev Returns the name of the token.
291      */
292     function name() public view virtual override returns (string memory) {
293         return _name;
294     }
295 
296     /**
297      * @dev Returns the symbol of the token, usually a shorter version of the
298      * name.
299      */
300     function symbol() public view virtual override returns (string memory) {
301         return _symbol;
302     }
303 
304     /**
305      * @dev Returns the number of decimals used to get its user representation.
306      * For example, if `decimals` equals `2`, a balance of `505` tokens should
307      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
308      *
309      * Tokens usually opt for a value of 18, imitating the relationship between
310      * Ether and Wei. This is the value {ERC20} uses, unless this function is
311      * overridden;
312      *
313      * NOTE: This information is only used for _display_ purposes: it in
314      * no way affects any of the arithmetic of the contract, including
315      * {IERC20-balanceOf} and {IERC20-transfer}.
316      */
317     function decimals() public view virtual override returns (uint8) {
318         return 18;
319     }
320 
321     /**
322      * @dev See {IERC20-totalSupply}.
323      */
324     function totalSupply() public view virtual override returns (uint256) {
325         return _totalSupply;
326     }
327 
328     /**
329      * @dev See {IERC20-balanceOf}.
330      */
331     function balanceOf(address account) public view virtual override returns (uint256) {
332         return _balances[account];
333     }
334 
335     /**
336      * @dev See {IERC20-transfer}.
337      *
338      * Requirements:
339      *
340      * - `to` cannot be the zero address.
341      * - the caller must have a balance of at least `amount`.
342      */
343     function transfer(address to, uint256 amount) public virtual override returns (bool) {
344         address owner = _msgSender();
345         _transfer(owner, to, amount);
346         return true;
347     }
348 
349     /**
350      * @dev See {IERC20-allowance}.
351      */
352     function allowance(address owner, address spender) public view virtual override returns (uint256) {
353         return _allowances[owner][spender];
354     }
355 
356     /**
357      * @dev See {IERC20-approve}.
358      *
359      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
360      * `transferFrom`. This is semantically equivalent to an infinite approval.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function approve(address spender, uint256 amount) public virtual override returns (bool) {
367         address owner = _msgSender();
368         _approve(owner, spender, amount);
369         return true;
370     }
371 
372     /**
373      * @dev See {IERC20-transferFrom}.
374      *
375      * Emits an {Approval} event indicating the updated allowance. This is not
376      * required by the EIP. See the note at the beginning of {ERC20}.
377      *
378      * NOTE: Does not update the allowance if the current allowance
379      * is the maximum `uint256`.
380      *
381      * Requirements:
382      *
383      * - `from` and `to` cannot be the zero address.
384      * - `from` must have a balance of at least `amount`.
385      * - the caller must have allowance for ``from``'s tokens of at least
386      * `amount`.
387      */
388     function transferFrom(
389         address from,
390         address to,
391         uint256 amount
392     ) public virtual override returns (bool) {
393         address spender = _msgSender();
394         _spendAllowance(from, spender, amount);
395         _transfer(from, to, amount);
396         return true;
397     }
398 
399     /**
400      * @dev Atomically increases the allowance granted to `spender` by the caller.
401      *
402      * This is an alternative to {approve} that can be used as a mitigation for
403      * problems described in {IERC20-approve}.
404      *
405      * Emits an {Approval} event indicating the updated allowance.
406      *
407      * Requirements:
408      *
409      * - `spender` cannot be the zero address.
410      */
411     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
412         address owner = _msgSender();
413         _approve(owner, spender, allowance(owner, spender) + addedValue);
414         return true;
415     }
416 
417     /**
418      * @dev Atomically decreases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      * - `spender` must have allowance for the caller of at least
429      * `subtractedValue`.
430      */
431     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
432         address owner = _msgSender();
433         uint256 currentAllowance = allowance(owner, spender);
434         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
435         unchecked {
436             _approve(owner, spender, currentAllowance - subtractedValue);
437         }
438 
439         return true;
440     }
441 
442     /**
443      * @dev Moves `amount` of tokens from `from` to `to`.
444      *
445      * This internal function is equivalent to {transfer}, and can be used to
446      * e.g. implement automatic token fees, slashing mechanisms, etc.
447      *
448      * Emits a {Transfer} event.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `from` must have a balance of at least `amount`.
455      */
456     function _transfer(
457         address from,
458         address to,
459         uint256 amount
460     ) internal virtual {
461         require(from != address(0), "ERC20: transfer from the zero address");
462         require(to != address(0), "ERC20: transfer to the zero address");
463 
464         _beforeTokenTransfer(from, to, amount);
465 
466         uint256 fromBalance = _balances[from];
467         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
468         unchecked {
469             _balances[from] = fromBalance - amount;
470             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
471             // decrementing then incrementing.
472             _balances[to] += amount;
473         }
474 
475         emit Transfer(from, to, amount);
476 
477         _afterTokenTransfer(from, to, amount);
478     }
479 
480     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
481      * the total supply.
482      *
483      * Emits a {Transfer} event with `from` set to the zero address.
484      *
485      * Requirements:
486      *
487      * - `account` cannot be the zero address.
488      */
489     function _mint(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: mint to the zero address");
491 
492         _beforeTokenTransfer(address(0), account, amount);
493 
494         _totalSupply += amount;
495         unchecked {
496             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
497             _balances[account] += amount;
498         }
499         emit Transfer(address(0), account, amount);
500 
501         _afterTokenTransfer(address(0), account, amount);
502     }
503 
504     /**
505      * @dev Destroys `amount` tokens from `account`, reducing the
506      * total supply.
507      *
508      * Emits a {Transfer} event with `to` set to the zero address.
509      *
510      * Requirements:
511      *
512      * - `account` cannot be the zero address.
513      * - `account` must have at least `amount` tokens.
514      */
515     function _burn(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: burn from the zero address");
517 
518         _beforeTokenTransfer(account, address(0), amount);
519 
520         uint256 accountBalance = _balances[account];
521         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
522         unchecked {
523             _balances[account] = accountBalance - amount;
524             // Overflow not possible: amount <= accountBalance <= totalSupply.
525             _totalSupply -= amount;
526         }
527 
528         emit Transfer(account, address(0), amount);
529 
530         _afterTokenTransfer(account, address(0), amount);
531     }
532 
533     /**
534      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
535      *
536      * This internal function is equivalent to `approve`, and can be used to
537      * e.g. set automatic allowances for certain subsystems, etc.
538      *
539      * Emits an {Approval} event.
540      *
541      * Requirements:
542      *
543      * - `owner` cannot be the zero address.
544      * - `spender` cannot be the zero address.
545      */
546     function _approve(
547         address owner,
548         address spender,
549         uint256 amount
550     ) internal virtual {
551         require(owner != address(0), "ERC20: approve from the zero address");
552         require(spender != address(0), "ERC20: approve to the zero address");
553 
554         _allowances[owner][spender] = amount;
555         emit Approval(owner, spender, amount);
556     }
557 
558     /**
559      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
560      *
561      * Does not update the allowance amount in case of infinite allowance.
562      * Revert if not enough allowance is available.
563      *
564      * Might emit an {Approval} event.
565      */
566     function _spendAllowance(
567         address owner,
568         address spender,
569         uint256 amount
570     ) internal virtual {
571         uint256 currentAllowance = allowance(owner, spender);
572         if (currentAllowance != type(uint256).max) {
573             require(currentAllowance >= amount, "ERC20: insufficient allowance");
574             unchecked {
575                 _approve(owner, spender, currentAllowance - amount);
576             }
577         }
578     }
579 
580     /**
581      * @dev Hook that is called before any transfer of tokens. This includes
582      * minting and burning.
583      *
584      * Calling conditions:
585      *
586      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
587      * will be transferred to `to`.
588      * - when `from` is zero, `amount` tokens will be minted for `to`.
589      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
590      * - `from` and `to` are never both zero.
591      *
592      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
593      */
594     function _beforeTokenTransfer(
595         address from,
596         address to,
597         uint256 amount
598     ) internal virtual {}
599 
600     /**
601      * @dev Hook that is called after any transfer of tokens. This includes
602      * minting and burning.
603      *
604      * Calling conditions:
605      *
606      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
607      * has been transferred to `to`.
608      * - when `from` is zero, `amount` tokens have been minted for `to`.
609      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
610      * - `from` and `to` are never both zero.
611      *
612      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
613      */
614     function _afterTokenTransfer(
615         address from,
616         address to,
617         uint256 amount
618     ) internal virtual {}
619 }
620 
621 
622 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.8.3
623 
624 
625 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 
630 /**
631  * @dev Extension of {ERC20} that allows token holders to destroy both their own
632  * tokens and those that they have an allowance for, in a way that can be
633  * recognized off-chain (via event analysis).
634  */
635 abstract contract ERC20Burnable is Context, ERC20 {
636     /**
637      * @dev Destroys `amount` tokens from the caller.
638      *
639      * See {ERC20-_burn}.
640      */
641     function burn(uint256 amount) public virtual {
642         _burn(_msgSender(), amount);
643     }
644 
645     /**
646      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
647      * allowance.
648      *
649      * See {ERC20-_burn} and {ERC20-allowance}.
650      *
651      * Requirements:
652      *
653      * - the caller must have allowance for ``accounts``'s tokens of at least
654      * `amount`.
655      */
656     function burnFrom(address account, uint256 amount) public virtual {
657         _spendAllowance(account, _msgSender(), amount);
658         _burn(account, amount);
659     }
660 }
661 
662 
663 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.8.3
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 /**
671  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
672  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
673  *
674  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
675  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
676  * need to send a transaction, and thus is not required to hold Ether at all.
677  */
678 interface IERC20Permit {
679     /**
680      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
681      * given ``owner``'s signed approval.
682      *
683      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
684      * ordering also apply here.
685      *
686      * Emits an {Approval} event.
687      *
688      * Requirements:
689      *
690      * - `spender` cannot be the zero address.
691      * - `deadline` must be a timestamp in the future.
692      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
693      * over the EIP712-formatted function arguments.
694      * - the signature must use ``owner``'s current nonce (see {nonces}).
695      *
696      * For more information on the signature format, see the
697      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
698      * section].
699      */
700     function permit(
701         address owner,
702         address spender,
703         uint256 value,
704         uint256 deadline,
705         uint8 v,
706         bytes32 r,
707         bytes32 s
708     ) external;
709 
710     /**
711      * @dev Returns the current nonce for `owner`. This value must be
712      * included whenever a signature is generated for {permit}.
713      *
714      * Every successful call to {permit} increases ``owner``'s nonce by one. This
715      * prevents a signature from being used multiple times.
716      */
717     function nonces(address owner) external view returns (uint256);
718 
719     /**
720      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
721      */
722     // solhint-disable-next-line func-name-mixedcase
723     function DOMAIN_SEPARATOR() external view returns (bytes32);
724 }
725 
726 
727 // File @openzeppelin/contracts/utils/Counters.sol@v4.8.3
728 
729 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 /**
734  * @title Counters
735  * @author Matt Condon (@shrugs)
736  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
737  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
738  *
739  * Include with `using Counters for Counters.Counter;`
740  */
741 library Counters {
742     struct Counter {
743         // This variable should never be directly accessed by users of the library: interactions must be restricted to
744         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
745         // this feature: see https://github.com/ethereum/solidity/issues/4637
746         uint256 _value; // default: 0
747     }
748 
749     function current(Counter storage counter) internal view returns (uint256) {
750         return counter._value;
751     }
752 
753     function increment(Counter storage counter) internal {
754         unchecked {
755             counter._value += 1;
756         }
757     }
758 
759     function decrement(Counter storage counter) internal {
760         uint256 value = counter._value;
761         require(value > 0, "Counter: decrement overflow");
762         unchecked {
763             counter._value = value - 1;
764         }
765     }
766 
767     function reset(Counter storage counter) internal {
768         counter._value = 0;
769     }
770 }
771 
772 
773 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.3
774 
775 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
776 
777 pragma solidity ^0.8.0;
778 
779 /**
780  * @dev Standard math utilities missing in the Solidity language.
781  */
782 library Math {
783     enum Rounding {
784         Down, // Toward negative infinity
785         Up, // Toward infinity
786         Zero // Toward zero
787     }
788 
789     /**
790      * @dev Returns the largest of two numbers.
791      */
792     function max(uint256 a, uint256 b) internal pure returns (uint256) {
793         return a > b ? a : b;
794     }
795 
796     /**
797      * @dev Returns the smallest of two numbers.
798      */
799     function min(uint256 a, uint256 b) internal pure returns (uint256) {
800         return a < b ? a : b;
801     }
802 
803     /**
804      * @dev Returns the average of two numbers. The result is rounded towards
805      * zero.
806      */
807     function average(uint256 a, uint256 b) internal pure returns (uint256) {
808         // (a + b) / 2 can overflow.
809         return (a & b) + (a ^ b) / 2;
810     }
811 
812     /**
813      * @dev Returns the ceiling of the division of two numbers.
814      *
815      * This differs from standard division with `/` in that it rounds up instead
816      * of rounding down.
817      */
818     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
819         // (a + b - 1) / b can overflow on addition, so we distribute.
820         return a == 0 ? 0 : (a - 1) / b + 1;
821     }
822 
823     /**
824      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
825      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
826      * with further edits by Uniswap Labs also under MIT license.
827      */
828     function mulDiv(
829         uint256 x,
830         uint256 y,
831         uint256 denominator
832     ) internal pure returns (uint256 result) {
833         unchecked {
834             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
835             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
836             // variables such that product = prod1 * 2^256 + prod0.
837             uint256 prod0; // Least significant 256 bits of the product
838             uint256 prod1; // Most significant 256 bits of the product
839             assembly {
840                 let mm := mulmod(x, y, not(0))
841                 prod0 := mul(x, y)
842                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
843             }
844 
845             // Handle non-overflow cases, 256 by 256 division.
846             if (prod1 == 0) {
847                 return prod0 / denominator;
848             }
849 
850             // Make sure the result is less than 2^256. Also prevents denominator == 0.
851             require(denominator > prod1);
852 
853             ///////////////////////////////////////////////
854             // 512 by 256 division.
855             ///////////////////////////////////////////////
856 
857             // Make division exact by subtracting the remainder from [prod1 prod0].
858             uint256 remainder;
859             assembly {
860                 // Compute remainder using mulmod.
861                 remainder := mulmod(x, y, denominator)
862 
863                 // Subtract 256 bit number from 512 bit number.
864                 prod1 := sub(prod1, gt(remainder, prod0))
865                 prod0 := sub(prod0, remainder)
866             }
867 
868             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
869             // See https://cs.stackexchange.com/q/138556/92363.
870 
871             // Does not overflow because the denominator cannot be zero at this stage in the function.
872             uint256 twos = denominator & (~denominator + 1);
873             assembly {
874                 // Divide denominator by twos.
875                 denominator := div(denominator, twos)
876 
877                 // Divide [prod1 prod0] by twos.
878                 prod0 := div(prod0, twos)
879 
880                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
881                 twos := add(div(sub(0, twos), twos), 1)
882             }
883 
884             // Shift in bits from prod1 into prod0.
885             prod0 |= prod1 * twos;
886 
887             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
888             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
889             // four bits. That is, denominator * inv = 1 mod 2^4.
890             uint256 inverse = (3 * denominator) ^ 2;
891 
892             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
893             // in modular arithmetic, doubling the correct bits in each step.
894             inverse *= 2 - denominator * inverse; // inverse mod 2^8
895             inverse *= 2 - denominator * inverse; // inverse mod 2^16
896             inverse *= 2 - denominator * inverse; // inverse mod 2^32
897             inverse *= 2 - denominator * inverse; // inverse mod 2^64
898             inverse *= 2 - denominator * inverse; // inverse mod 2^128
899             inverse *= 2 - denominator * inverse; // inverse mod 2^256
900 
901             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
902             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
903             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
904             // is no longer required.
905             result = prod0 * inverse;
906             return result;
907         }
908     }
909 
910     /**
911      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
912      */
913     function mulDiv(
914         uint256 x,
915         uint256 y,
916         uint256 denominator,
917         Rounding rounding
918     ) internal pure returns (uint256) {
919         uint256 result = mulDiv(x, y, denominator);
920         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
921             result += 1;
922         }
923         return result;
924     }
925 
926     /**
927      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
928      *
929      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
930      */
931     function sqrt(uint256 a) internal pure returns (uint256) {
932         if (a == 0) {
933             return 0;
934         }
935 
936         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
937         //
938         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
939         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
940         //
941         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
942         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
943         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
944         //
945         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
946         uint256 result = 1 << (log2(a) >> 1);
947 
948         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
949         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
950         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
951         // into the expected uint128 result.
952         unchecked {
953             result = (result + a / result) >> 1;
954             result = (result + a / result) >> 1;
955             result = (result + a / result) >> 1;
956             result = (result + a / result) >> 1;
957             result = (result + a / result) >> 1;
958             result = (result + a / result) >> 1;
959             result = (result + a / result) >> 1;
960             return min(result, a / result);
961         }
962     }
963 
964     /**
965      * @notice Calculates sqrt(a), following the selected rounding direction.
966      */
967     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
968         unchecked {
969             uint256 result = sqrt(a);
970             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
971         }
972     }
973 
974     /**
975      * @dev Return the log in base 2, rounded down, of a positive value.
976      * Returns 0 if given 0.
977      */
978     function log2(uint256 value) internal pure returns (uint256) {
979         uint256 result = 0;
980         unchecked {
981             if (value >> 128 > 0) {
982                 value >>= 128;
983                 result += 128;
984             }
985             if (value >> 64 > 0) {
986                 value >>= 64;
987                 result += 64;
988             }
989             if (value >> 32 > 0) {
990                 value >>= 32;
991                 result += 32;
992             }
993             if (value >> 16 > 0) {
994                 value >>= 16;
995                 result += 16;
996             }
997             if (value >> 8 > 0) {
998                 value >>= 8;
999                 result += 8;
1000             }
1001             if (value >> 4 > 0) {
1002                 value >>= 4;
1003                 result += 4;
1004             }
1005             if (value >> 2 > 0) {
1006                 value >>= 2;
1007                 result += 2;
1008             }
1009             if (value >> 1 > 0) {
1010                 result += 1;
1011             }
1012         }
1013         return result;
1014     }
1015 
1016     /**
1017      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1018      * Returns 0 if given 0.
1019      */
1020     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1021         unchecked {
1022             uint256 result = log2(value);
1023             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1024         }
1025     }
1026 
1027     /**
1028      * @dev Return the log in base 10, rounded down, of a positive value.
1029      * Returns 0 if given 0.
1030      */
1031     function log10(uint256 value) internal pure returns (uint256) {
1032         uint256 result = 0;
1033         unchecked {
1034             if (value >= 10**64) {
1035                 value /= 10**64;
1036                 result += 64;
1037             }
1038             if (value >= 10**32) {
1039                 value /= 10**32;
1040                 result += 32;
1041             }
1042             if (value >= 10**16) {
1043                 value /= 10**16;
1044                 result += 16;
1045             }
1046             if (value >= 10**8) {
1047                 value /= 10**8;
1048                 result += 8;
1049             }
1050             if (value >= 10**4) {
1051                 value /= 10**4;
1052                 result += 4;
1053             }
1054             if (value >= 10**2) {
1055                 value /= 10**2;
1056                 result += 2;
1057             }
1058             if (value >= 10**1) {
1059                 result += 1;
1060             }
1061         }
1062         return result;
1063     }
1064 
1065     /**
1066      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1067      * Returns 0 if given 0.
1068      */
1069     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1070         unchecked {
1071             uint256 result = log10(value);
1072             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1073         }
1074     }
1075 
1076     /**
1077      * @dev Return the log in base 256, rounded down, of a positive value.
1078      * Returns 0 if given 0.
1079      *
1080      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1081      */
1082     function log256(uint256 value) internal pure returns (uint256) {
1083         uint256 result = 0;
1084         unchecked {
1085             if (value >> 128 > 0) {
1086                 value >>= 128;
1087                 result += 16;
1088             }
1089             if (value >> 64 > 0) {
1090                 value >>= 64;
1091                 result += 8;
1092             }
1093             if (value >> 32 > 0) {
1094                 value >>= 32;
1095                 result += 4;
1096             }
1097             if (value >> 16 > 0) {
1098                 value >>= 16;
1099                 result += 2;
1100             }
1101             if (value >> 8 > 0) {
1102                 result += 1;
1103             }
1104         }
1105         return result;
1106     }
1107 
1108     /**
1109      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1110      * Returns 0 if given 0.
1111      */
1112     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1113         unchecked {
1114             uint256 result = log256(value);
1115             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1116         }
1117     }
1118 }
1119 
1120 
1121 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.3
1122 
1123 
1124 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1125 
1126 pragma solidity ^0.8.0;
1127 
1128 /**
1129  * @dev String operations.
1130  */
1131 library Strings {
1132     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1133     uint8 private constant _ADDRESS_LENGTH = 20;
1134 
1135     /**
1136      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1137      */
1138     function toString(uint256 value) internal pure returns (string memory) {
1139         unchecked {
1140             uint256 length = Math.log10(value) + 1;
1141             string memory buffer = new string(length);
1142             uint256 ptr;
1143             /// @solidity memory-safe-assembly
1144             assembly {
1145                 ptr := add(buffer, add(32, length))
1146             }
1147             while (true) {
1148                 ptr--;
1149                 /// @solidity memory-safe-assembly
1150                 assembly {
1151                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1152                 }
1153                 value /= 10;
1154                 if (value == 0) break;
1155             }
1156             return buffer;
1157         }
1158     }
1159 
1160     /**
1161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1162      */
1163     function toHexString(uint256 value) internal pure returns (string memory) {
1164         unchecked {
1165             return toHexString(value, Math.log256(value) + 1);
1166         }
1167     }
1168 
1169     /**
1170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1171      */
1172     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1173         bytes memory buffer = new bytes(2 * length + 2);
1174         buffer[0] = "0";
1175         buffer[1] = "x";
1176         for (uint256 i = 2 * length + 1; i > 1; --i) {
1177             buffer[i] = _SYMBOLS[value & 0xf];
1178             value >>= 4;
1179         }
1180         require(value == 0, "Strings: hex length insufficient");
1181         return string(buffer);
1182     }
1183 
1184     /**
1185      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1186      */
1187     function toHexString(address addr) internal pure returns (string memory) {
1188         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1189     }
1190 }
1191 
1192 
1193 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.8.3
1194 
1195 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1196 
1197 pragma solidity ^0.8.0;
1198 
1199 /**
1200  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1201  *
1202  * These functions can be used to verify that a message was signed by the holder
1203  * of the private keys of a given address.
1204  */
1205 library ECDSA {
1206     enum RecoverError {
1207         NoError,
1208         InvalidSignature,
1209         InvalidSignatureLength,
1210         InvalidSignatureS,
1211         InvalidSignatureV // Deprecated in v4.8
1212     }
1213 
1214     function _throwError(RecoverError error) private pure {
1215         if (error == RecoverError.NoError) {
1216             return; // no error: do nothing
1217         } else if (error == RecoverError.InvalidSignature) {
1218             revert("ECDSA: invalid signature");
1219         } else if (error == RecoverError.InvalidSignatureLength) {
1220             revert("ECDSA: invalid signature length");
1221         } else if (error == RecoverError.InvalidSignatureS) {
1222             revert("ECDSA: invalid signature 's' value");
1223         }
1224     }
1225 
1226     /**
1227      * @dev Returns the address that signed a hashed message (`hash`) with
1228      * `signature` or error string. This address can then be used for verification purposes.
1229      *
1230      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1231      * this function rejects them by requiring the `s` value to be in the lower
1232      * half order, and the `v` value to be either 27 or 28.
1233      *
1234      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1235      * verification to be secure: it is possible to craft signatures that
1236      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1237      * this is by receiving a hash of the original message (which may otherwise
1238      * be too long), and then calling {toEthSignedMessageHash} on it.
1239      *
1240      * Documentation for signature generation:
1241      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1242      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1243      *
1244      * _Available since v4.3._
1245      */
1246     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1247         if (signature.length == 65) {
1248             bytes32 r;
1249             bytes32 s;
1250             uint8 v;
1251             // ecrecover takes the signature parameters, and the only way to get them
1252             // currently is to use assembly.
1253             /// @solidity memory-safe-assembly
1254             assembly {
1255                 r := mload(add(signature, 0x20))
1256                 s := mload(add(signature, 0x40))
1257                 v := byte(0, mload(add(signature, 0x60)))
1258             }
1259             return tryRecover(hash, v, r, s);
1260         } else {
1261             return (address(0), RecoverError.InvalidSignatureLength);
1262         }
1263     }
1264 
1265     /**
1266      * @dev Returns the address that signed a hashed message (`hash`) with
1267      * `signature`. This address can then be used for verification purposes.
1268      *
1269      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1270      * this function rejects them by requiring the `s` value to be in the lower
1271      * half order, and the `v` value to be either 27 or 28.
1272      *
1273      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1274      * verification to be secure: it is possible to craft signatures that
1275      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1276      * this is by receiving a hash of the original message (which may otherwise
1277      * be too long), and then calling {toEthSignedMessageHash} on it.
1278      */
1279     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1280         (address recovered, RecoverError error) = tryRecover(hash, signature);
1281         _throwError(error);
1282         return recovered;
1283     }
1284 
1285     /**
1286      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1287      *
1288      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1289      *
1290      * _Available since v4.3._
1291      */
1292     function tryRecover(
1293         bytes32 hash,
1294         bytes32 r,
1295         bytes32 vs
1296     ) internal pure returns (address, RecoverError) {
1297         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1298         uint8 v = uint8((uint256(vs) >> 255) + 27);
1299         return tryRecover(hash, v, r, s);
1300     }
1301 
1302     /**
1303      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1304      *
1305      * _Available since v4.2._
1306      */
1307     function recover(
1308         bytes32 hash,
1309         bytes32 r,
1310         bytes32 vs
1311     ) internal pure returns (address) {
1312         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1313         _throwError(error);
1314         return recovered;
1315     }
1316 
1317     /**
1318      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1319      * `r` and `s` signature fields separately.
1320      *
1321      * _Available since v4.3._
1322      */
1323     function tryRecover(
1324         bytes32 hash,
1325         uint8 v,
1326         bytes32 r,
1327         bytes32 s
1328     ) internal pure returns (address, RecoverError) {
1329         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1330         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1331         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1332         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1333         //
1334         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1335         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1336         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1337         // these malleable signatures as well.
1338         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1339             return (address(0), RecoverError.InvalidSignatureS);
1340         }
1341 
1342         // If the signature is valid (and not malleable), return the signer address
1343         address signer = ecrecover(hash, v, r, s);
1344         if (signer == address(0)) {
1345             return (address(0), RecoverError.InvalidSignature);
1346         }
1347 
1348         return (signer, RecoverError.NoError);
1349     }
1350 
1351     /**
1352      * @dev Overload of {ECDSA-recover} that receives the `v`,
1353      * `r` and `s` signature fields separately.
1354      */
1355     function recover(
1356         bytes32 hash,
1357         uint8 v,
1358         bytes32 r,
1359         bytes32 s
1360     ) internal pure returns (address) {
1361         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1362         _throwError(error);
1363         return recovered;
1364     }
1365 
1366     /**
1367      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1368      * produces hash corresponding to the one signed with the
1369      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1370      * JSON-RPC method as part of EIP-191.
1371      *
1372      * See {recover}.
1373      */
1374     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1375         // 32 is the length in bytes of hash,
1376         // enforced by the type signature above
1377         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1378     }
1379 
1380     /**
1381      * @dev Returns an Ethereum Signed Message, created from `s`. This
1382      * produces hash corresponding to the one signed with the
1383      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1384      * JSON-RPC method as part of EIP-191.
1385      *
1386      * See {recover}.
1387      */
1388     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1389         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1390     }
1391 
1392     /**
1393      * @dev Returns an Ethereum Signed Typed Data, created from a
1394      * `domainSeparator` and a `structHash`. This produces hash corresponding
1395      * to the one signed with the
1396      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1397      * JSON-RPC method as part of EIP-712.
1398      *
1399      * See {recover}.
1400      */
1401     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1402         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1403     }
1404 }
1405 
1406 
1407 // File @openzeppelin/contracts/utils/cryptography/EIP712.sol@v4.8.3
1408 
1409 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
1410 
1411 pragma solidity ^0.8.0;
1412 
1413 /**
1414  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1415  *
1416  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1417  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1418  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1419  *
1420  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1421  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1422  * ({_hashTypedDataV4}).
1423  *
1424  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1425  * the chain id to protect against replay attacks on an eventual fork of the chain.
1426  *
1427  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1428  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1429  *
1430  * _Available since v3.4._
1431  */
1432 abstract contract EIP712 {
1433     /* solhint-disable var-name-mixedcase */
1434     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1435     // invalidate the cached domain separator if the chain id changes.
1436     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1437     uint256 private immutable _CACHED_CHAIN_ID;
1438     address private immutable _CACHED_THIS;
1439 
1440     bytes32 private immutable _HASHED_NAME;
1441     bytes32 private immutable _HASHED_VERSION;
1442     bytes32 private immutable _TYPE_HASH;
1443 
1444     /* solhint-enable var-name-mixedcase */
1445 
1446     /**
1447      * @dev Initializes the domain separator and parameter caches.
1448      *
1449      * The meaning of `name` and `version` is specified in
1450      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1451      *
1452      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1453      * - `version`: the current major version of the signing domain.
1454      *
1455      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1456      * contract upgrade].
1457      */
1458     constructor(string memory name, string memory version) {
1459         bytes32 hashedName = keccak256(bytes(name));
1460         bytes32 hashedVersion = keccak256(bytes(version));
1461         bytes32 typeHash = keccak256(
1462             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1463         );
1464         _HASHED_NAME = hashedName;
1465         _HASHED_VERSION = hashedVersion;
1466         _CACHED_CHAIN_ID = block.chainid;
1467         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1468         _CACHED_THIS = address(this);
1469         _TYPE_HASH = typeHash;
1470     }
1471 
1472     /**
1473      * @dev Returns the domain separator for the current chain.
1474      */
1475     function _domainSeparatorV4() internal view returns (bytes32) {
1476         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1477             return _CACHED_DOMAIN_SEPARATOR;
1478         } else {
1479             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1480         }
1481     }
1482 
1483     function _buildDomainSeparator(
1484         bytes32 typeHash,
1485         bytes32 nameHash,
1486         bytes32 versionHash
1487     ) private view returns (bytes32) {
1488         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1489     }
1490 
1491     /**
1492      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1493      * function returns the hash of the fully encoded EIP712 message for this domain.
1494      *
1495      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1496      *
1497      * ```solidity
1498      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1499      *     keccak256("Mail(address to,string contents)"),
1500      *     mailTo,
1501      *     keccak256(bytes(mailContents))
1502      * )));
1503      * address signer = ECDSA.recover(digest, signature);
1504      * ```
1505      */
1506     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1507         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1508     }
1509 }
1510 
1511 
1512 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol@v4.8.3
1513 
1514 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/extensions/ERC20Permit.sol)
1515 
1516 pragma solidity ^0.8.0;
1517 
1518 
1519 
1520 
1521 
1522 /**
1523  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1524  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1525  *
1526  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1527  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1528  * need to send a transaction, and thus is not required to hold Ether at all.
1529  *
1530  * _Available since v3.4._
1531  */
1532 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1533     using Counters for Counters.Counter;
1534 
1535     mapping(address => Counters.Counter) private _nonces;
1536 
1537     // solhint-disable-next-line var-name-mixedcase
1538     bytes32 private constant _PERMIT_TYPEHASH =
1539         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1540     /**
1541      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
1542      * However, to ensure consistency with the upgradeable transpiler, we will continue
1543      * to reserve a slot.
1544      * @custom:oz-renamed-from _PERMIT_TYPEHASH
1545      */
1546     // solhint-disable-next-line var-name-mixedcase
1547     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
1548 
1549     /**
1550      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1551      *
1552      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1553      */
1554     constructor(string memory name) EIP712(name, "1") {}
1555 
1556     /**
1557      * @dev See {IERC20Permit-permit}.
1558      */
1559     function permit(
1560         address owner,
1561         address spender,
1562         uint256 value,
1563         uint256 deadline,
1564         uint8 v,
1565         bytes32 r,
1566         bytes32 s
1567     ) public virtual override {
1568         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1569 
1570         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1571 
1572         bytes32 hash = _hashTypedDataV4(structHash);
1573 
1574         address signer = ECDSA.recover(hash, v, r, s);
1575         require(signer == owner, "ERC20Permit: invalid signature");
1576 
1577         _approve(owner, spender, value);
1578     }
1579 
1580     /**
1581      * @dev See {IERC20Permit-nonces}.
1582      */
1583     function nonces(address owner) public view virtual override returns (uint256) {
1584         return _nonces[owner].current();
1585     }
1586 
1587     /**
1588      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1589      */
1590     // solhint-disable-next-line func-name-mixedcase
1591     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1592         return _domainSeparatorV4();
1593     }
1594 
1595     /**
1596      * @dev "Consume a nonce": return the current value and increment.
1597      *
1598      * _Available since v4.1._
1599      */
1600     function _useNonce(address owner) internal virtual returns (uint256 current) {
1601         Counters.Counter storage nonce = _nonces[owner];
1602         current = nonce.current();
1603         nonce.increment();
1604     }
1605 }
1606 
1607 // File contracts/GoodMeme.sol
1608 
1609 /*$$$$$\                            $$\       $$\      $$\
1610 $$  __$$\                           $$ |      $$$\    $$$ |
1611 $$ /  \__| $$$$$$\   $$$$$$\   $$$$$$$ |      $$$$\  $$$$ | $$$$$$\  $$$$$$\$$$$\   $$$$$$\
1612 $$ |$$$$\ $$  __$$\ $$  __$$\ $$  __$$ |      $$\$$\$$ $$ |$$  __$$\ $$  _$$  _$$\ $$  __$$\
1613 $$ |\_$$ |$$ /  $$ |$$ /  $$ |$$ /  $$ |      $$ \$$$  $$ |$$$$$$$$ |$$ / $$ / $$ |$$$$$$$$ |
1614 $$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |      $$ |\$  /$$ |$$   ____|$$ | $$ | $$ |$$   ____|
1615 \$$$$$$  |\$$$$$$  |\$$$$$$  |\$$$$$$$ |      $$ | \_/ $$ |\$$$$$$$\ $$ | $$ | $$ |\$$$$$$$\
1616 \______/  \______/  \______/  \_______|      \__|     \__| \_______|\__| \__| \__| \_______|*/
1617 
1618 pragma solidity 0.8.19;
1619 
1620 
1621 
1622 contract GoodMeme is Ownable, ERC20Burnable, ERC20Permit {
1623 
1624     uint public maxTransferAmount = 2100000000 * 1 ether;
1625 
1626     constructor() ERC20("GoodMeme", "GMEME")  ERC20Permit("GoodMeme") {
1627         _mint(msg.sender, 420000000069 * 1 ether);
1628     }
1629 
1630     function setMaxTransferAmount(uint amount) external onlyOwner {
1631         maxTransferAmount = amount;
1632     }
1633 
1634     function _afterTokenTransfer(address from, address to, uint256 amount) internal override {
1635         if(maxTransferAmount != 0 && from != owner() && to != owner() && amount > maxTransferAmount)
1636             revert("Currently can't transfer this many tokens at once");
1637     }
1638 }