1 pragma solidity ^0.8.9;
2 
3 
4 // SPDX-License-Identifier: NONE
5 // 
6 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `to`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address to, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `from` to `to` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address from,
66         address to,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // 
86 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 // 
108 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender(), "Ownable: caller is not the owner");
145         _;
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // 
180 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
181 /**
182  * @dev Contract module that helps prevent reentrant calls to a function.
183  *
184  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
185  * available, which can be applied to functions to make sure there are no nested
186  * (reentrant) calls to them.
187  *
188  * Note that because there is a single `nonReentrant` guard, functions marked as
189  * `nonReentrant` may not call one another. This can be worked around by making
190  * those functions `private`, and then adding `external` `nonReentrant` entry
191  * points to them.
192  *
193  * TIP: If you would like to learn more about reentrancy and alternative ways
194  * to protect against it, check out our blog post
195  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
196  */
197 abstract contract ReentrancyGuard {
198     // Booleans are more expensive than uint256 or any type that takes up a full
199     // word because each write operation emits an extra SLOAD to first read the
200     // slot's contents, replace the bits taken up by the boolean, and then write
201     // back. This is the compiler's defense against contract upgrades and
202     // pointer aliasing, and it cannot be disabled.
203 
204     // The values being non-zero value makes deployment a bit more expensive,
205     // but in exchange the refund on every call to nonReentrant will be lower in
206     // amount. Since refunds are capped to a percentage of the total
207     // transaction's gas, it is best to keep them low in cases like this one, to
208     // increase the likelihood of the full refund coming into effect.
209     uint256 private constant _NOT_ENTERED = 1;
210     uint256 private constant _ENTERED = 2;
211 
212     uint256 private _status;
213 
214     constructor() {
215         _status = _NOT_ENTERED;
216     }
217 
218     /**
219      * @dev Prevents a contract from calling itself, directly or indirectly.
220      * Calling a `nonReentrant` function from another `nonReentrant`
221      * function is not supported. It is possible to prevent this from happening
222      * by making the `nonReentrant` function external, and making it call a
223      * `private` function that does the actual work.
224      */
225     modifier nonReentrant() {
226         // On the first call to nonReentrant, _notEntered will be true
227         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
228 
229         // Any calls to nonReentrant after this point will fail
230         _status = _ENTERED;
231 
232         _;
233 
234         // By storing the original value once again, a refund is triggered (see
235         // https://eips.ethereum.org/EIPS/eip-2200)
236         _status = _NOT_ENTERED;
237     }
238 }
239 
240 // 
241 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
242 /**
243  * @dev Interface for the optional metadata functions from the ERC20 standard.
244  *
245  * _Available since v4.1._
246  */
247 interface IERC20Metadata is IERC20 {
248     /**
249      * @dev Returns the name of the token.
250      */
251     function name() external view returns (string memory);
252 
253     /**
254      * @dev Returns the symbol of the token.
255      */
256     function symbol() external view returns (string memory);
257 
258     /**
259      * @dev Returns the decimals places of the token.
260      */
261     function decimals() external view returns (uint8);
262 }
263 
264 // 
265 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
266 /**
267  * @dev Implementation of the {IERC20} interface.
268  *
269  * This implementation is agnostic to the way tokens are created. This means
270  * that a supply mechanism has to be added in a derived contract using {_mint}.
271  * For a generic mechanism see {ERC20PresetMinterPauser}.
272  *
273  * TIP: For a detailed writeup see our guide
274  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
275  * to implement supply mechanisms].
276  *
277  * We have followed general OpenZeppelin Contracts guidelines: functions revert
278  * instead returning `false` on failure. This behavior is nonetheless
279  * conventional and does not conflict with the expectations of ERC20
280  * applications.
281  *
282  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
283  * This allows applications to reconstruct the allowance for all accounts just
284  * by listening to said events. Other implementations of the EIP may not emit
285  * these events, as it isn't required by the specification.
286  *
287  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
288  * functions have been added to mitigate the well-known issues around setting
289  * allowances. See {IERC20-approve}.
290  */
291 contract ERC20 is Context, IERC20, IERC20Metadata {
292     mapping(address => uint256) private _balances;
293 
294     mapping(address => mapping(address => uint256)) private _allowances;
295 
296     uint256 private _totalSupply;
297 
298     string private _name;
299     string private _symbol;
300 
301     /**
302      * @dev Sets the values for {name} and {symbol}.
303      *
304      * The default value of {decimals} is 18. To select a different value for
305      * {decimals} you should overload it.
306      *
307      * All two of these values are immutable: they can only be set once during
308      * construction.
309      */
310     constructor(string memory name_, string memory symbol_) {
311         _name = name_;
312         _symbol = symbol_;
313     }
314 
315     /**
316      * @dev Returns the name of the token.
317      */
318     function name() public view virtual override returns (string memory) {
319         return _name;
320     }
321 
322     /**
323      * @dev Returns the symbol of the token, usually a shorter version of the
324      * name.
325      */
326     function symbol() public view virtual override returns (string memory) {
327         return _symbol;
328     }
329 
330     /**
331      * @dev Returns the number of decimals used to get its user representation.
332      * For example, if `decimals` equals `2`, a balance of `505` tokens should
333      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
334      *
335      * Tokens usually opt for a value of 18, imitating the relationship between
336      * Ether and Wei. This is the value {ERC20} uses, unless this function is
337      * overridden;
338      *
339      * NOTE: This information is only used for _display_ purposes: it in
340      * no way affects any of the arithmetic of the contract, including
341      * {IERC20-balanceOf} and {IERC20-transfer}.
342      */
343     function decimals() public view virtual override returns (uint8) {
344         return 18;
345     }
346 
347     /**
348      * @dev See {IERC20-totalSupply}.
349      */
350     function totalSupply() public view virtual override returns (uint256) {
351         return _totalSupply;
352     }
353 
354     /**
355      * @dev See {IERC20-balanceOf}.
356      */
357     function balanceOf(address account) public view virtual override returns (uint256) {
358         return _balances[account];
359     }
360 
361     /**
362      * @dev See {IERC20-transfer}.
363      *
364      * Requirements:
365      *
366      * - `to` cannot be the zero address.
367      * - the caller must have a balance of at least `amount`.
368      */
369     function transfer(address to, uint256 amount) public virtual override returns (bool) {
370         address owner = _msgSender();
371         _transfer(owner, to, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-allowance}.
377      */
378     function allowance(address owner, address spender) public view virtual override returns (uint256) {
379         return _allowances[owner][spender];
380     }
381 
382     /**
383      * @dev See {IERC20-approve}.
384      *
385      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
386      * `transferFrom`. This is semantically equivalent to an infinite approval.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      */
392     function approve(address spender, uint256 amount) public virtual override returns (bool) {
393         address owner = _msgSender();
394         _approve(owner, spender, amount);
395         return true;
396     }
397 
398     /**
399      * @dev See {IERC20-transferFrom}.
400      *
401      * Emits an {Approval} event indicating the updated allowance. This is not
402      * required by the EIP. See the note at the beginning of {ERC20}.
403      *
404      * NOTE: Does not update the allowance if the current allowance
405      * is the maximum `uint256`.
406      *
407      * Requirements:
408      *
409      * - `from` and `to` cannot be the zero address.
410      * - `from` must have a balance of at least `amount`.
411      * - the caller must have allowance for ``from``'s tokens of at least
412      * `amount`.
413      */
414     function transferFrom(
415         address from,
416         address to,
417         uint256 amount
418     ) public virtual override returns (bool) {
419         address spender = _msgSender();
420         _spendAllowance(from, spender, amount);
421         _transfer(from, to, amount);
422         return true;
423     }
424 
425     /**
426      * @dev Atomically increases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      */
437     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
438         address owner = _msgSender();
439         _approve(owner, spender, _allowances[owner][spender] + addedValue);
440         return true;
441     }
442 
443     /**
444      * @dev Atomically decreases the allowance granted to `spender` by the caller.
445      *
446      * This is an alternative to {approve} that can be used as a mitigation for
447      * problems described in {IERC20-approve}.
448      *
449      * Emits an {Approval} event indicating the updated allowance.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      * - `spender` must have allowance for the caller of at least
455      * `subtractedValue`.
456      */
457     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
458         address owner = _msgSender();
459         uint256 currentAllowance = _allowances[owner][spender];
460         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
461         unchecked {
462             _approve(owner, spender, currentAllowance - subtractedValue);
463         }
464 
465         return true;
466     }
467 
468     /**
469      * @dev Moves `amount` of tokens from `sender` to `recipient`.
470      *
471      * This internal function is equivalent to {transfer}, and can be used to
472      * e.g. implement automatic token fees, slashing mechanisms, etc.
473      *
474      * Emits a {Transfer} event.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `from` must have a balance of at least `amount`.
481      */
482     function _transfer(
483         address from,
484         address to,
485         uint256 amount
486     ) internal virtual {
487         require(from != address(0), "ERC20: transfer from the zero address");
488         require(to != address(0), "ERC20: transfer to the zero address");
489 
490         _beforeTokenTransfer(from, to, amount);
491 
492         uint256 fromBalance = _balances[from];
493         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
494         unchecked {
495             _balances[from] = fromBalance - amount;
496         }
497         _balances[to] += amount;
498 
499         emit Transfer(from, to, amount);
500 
501         _afterTokenTransfer(from, to, amount);
502     }
503 
504     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
505      * the total supply.
506      *
507      * Emits a {Transfer} event with `from` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      */
513     function _mint(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: mint to the zero address");
515 
516         _beforeTokenTransfer(address(0), account, amount);
517 
518         _totalSupply += amount;
519         _balances[account] += amount;
520         emit Transfer(address(0), account, amount);
521 
522         _afterTokenTransfer(address(0), account, amount);
523     }
524 
525     /**
526      * @dev Destroys `amount` tokens from `account`, reducing the
527      * total supply.
528      *
529      * Emits a {Transfer} event with `to` set to the zero address.
530      *
531      * Requirements:
532      *
533      * - `account` cannot be the zero address.
534      * - `account` must have at least `amount` tokens.
535      */
536     function _burn(address account, uint256 amount) internal virtual {
537         require(account != address(0), "ERC20: burn from the zero address");
538 
539         _beforeTokenTransfer(account, address(0), amount);
540 
541         uint256 accountBalance = _balances[account];
542         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
543         unchecked {
544             _balances[account] = accountBalance - amount;
545         }
546         _totalSupply -= amount;
547 
548         emit Transfer(account, address(0), amount);
549 
550         _afterTokenTransfer(account, address(0), amount);
551     }
552 
553     /**
554      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
555      *
556      * This internal function is equivalent to `approve`, and can be used to
557      * e.g. set automatic allowances for certain subsystems, etc.
558      *
559      * Emits an {Approval} event.
560      *
561      * Requirements:
562      *
563      * - `owner` cannot be the zero address.
564      * - `spender` cannot be the zero address.
565      */
566     function _approve(
567         address owner,
568         address spender,
569         uint256 amount
570     ) internal virtual {
571         require(owner != address(0), "ERC20: approve from the zero address");
572         require(spender != address(0), "ERC20: approve to the zero address");
573 
574         _allowances[owner][spender] = amount;
575         emit Approval(owner, spender, amount);
576     }
577 
578     /**
579      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
580      *
581      * Does not update the allowance amount in case of infinite allowance.
582      * Revert if not enough allowance is available.
583      *
584      * Might emit an {Approval} event.
585      */
586     function _spendAllowance(
587         address owner,
588         address spender,
589         uint256 amount
590     ) internal virtual {
591         uint256 currentAllowance = allowance(owner, spender);
592         if (currentAllowance != type(uint256).max) {
593             require(currentAllowance >= amount, "ERC20: insufficient allowance");
594             unchecked {
595                 _approve(owner, spender, currentAllowance - amount);
596             }
597         }
598     }
599 
600     /**
601      * @dev Hook that is called before any transfer of tokens. This includes
602      * minting and burning.
603      *
604      * Calling conditions:
605      *
606      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
607      * will be transferred to `to`.
608      * - when `from` is zero, `amount` tokens will be minted for `to`.
609      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
610      * - `from` and `to` are never both zero.
611      *
612      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
613      */
614     function _beforeTokenTransfer(
615         address from,
616         address to,
617         uint256 amount
618     ) internal virtual {}
619 
620     /**
621      * @dev Hook that is called after any transfer of tokens. This includes
622      * minting and burning.
623      *
624      * Calling conditions:
625      *
626      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
627      * has been transferred to `to`.
628      * - when `from` is zero, `amount` tokens have been minted for `to`.
629      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
630      * - `from` and `to` are never both zero.
631      *
632      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
633      */
634     function _afterTokenTransfer(
635         address from,
636         address to,
637         uint256 amount
638     ) internal virtual {}
639 }
640 
641 // 
642 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
643 /**
644  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
645  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
646  *
647  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
648  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
649  * need to send a transaction, and thus is not required to hold Ether at all.
650  */
651 interface IERC20Permit {
652     /**
653      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
654      * given ``owner``'s signed approval.
655      *
656      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
657      * ordering also apply here.
658      *
659      * Emits an {Approval} event.
660      *
661      * Requirements:
662      *
663      * - `spender` cannot be the zero address.
664      * - `deadline` must be a timestamp in the future.
665      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
666      * over the EIP712-formatted function arguments.
667      * - the signature must use ``owner``'s current nonce (see {nonces}).
668      *
669      * For more information on the signature format, see the
670      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
671      * section].
672      */
673     function permit(
674         address owner,
675         address spender,
676         uint256 value,
677         uint256 deadline,
678         uint8 v,
679         bytes32 r,
680         bytes32 s
681     ) external;
682 
683     /**
684      * @dev Returns the current nonce for `owner`. This value must be
685      * included whenever a signature is generated for {permit}.
686      *
687      * Every successful call to {permit} increases ``owner``'s nonce by one. This
688      * prevents a signature from being used multiple times.
689      */
690     function nonces(address owner) external view returns (uint256);
691 
692     /**
693      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
694      */
695     // solhint-disable-next-line func-name-mixedcase
696     function DOMAIN_SEPARATOR() external view returns (bytes32);
697 }
698 
699 // 
700 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
701 /**
702  * @dev String operations.
703  */
704 library Strings {
705     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
706 
707     /**
708      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
709      */
710     function toString(uint256 value) internal pure returns (string memory) {
711         // Inspired by OraclizeAPI's implementation - MIT licence
712         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
713 
714         if (value == 0) {
715             return "0";
716         }
717         uint256 temp = value;
718         uint256 digits;
719         while (temp != 0) {
720             digits++;
721             temp /= 10;
722         }
723         bytes memory buffer = new bytes(digits);
724         while (value != 0) {
725             digits -= 1;
726             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
727             value /= 10;
728         }
729         return string(buffer);
730     }
731 
732     /**
733      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
734      */
735     function toHexString(uint256 value) internal pure returns (string memory) {
736         if (value == 0) {
737             return "0x00";
738         }
739         uint256 temp = value;
740         uint256 length = 0;
741         while (temp != 0) {
742             length++;
743             temp >>= 8;
744         }
745         return toHexString(value, length);
746     }
747 
748     /**
749      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
750      */
751     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
752         bytes memory buffer = new bytes(2 * length + 2);
753         buffer[0] = "0";
754         buffer[1] = "x";
755         for (uint256 i = 2 * length + 1; i > 1; --i) {
756             buffer[i] = _HEX_SYMBOLS[value & 0xf];
757             value >>= 4;
758         }
759         require(value == 0, "Strings: hex length insufficient");
760         return string(buffer);
761     }
762 }
763 
764 // 
765 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
766 /**
767  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
768  *
769  * These functions can be used to verify that a message was signed by the holder
770  * of the private keys of a given address.
771  */
772 library ECDSA {
773     enum RecoverError {
774         NoError,
775         InvalidSignature,
776         InvalidSignatureLength,
777         InvalidSignatureS,
778         InvalidSignatureV
779     }
780 
781     function _throwError(RecoverError error) private pure {
782         if (error == RecoverError.NoError) {
783             return; // no error: do nothing
784         } else if (error == RecoverError.InvalidSignature) {
785             revert("ECDSA: invalid signature");
786         } else if (error == RecoverError.InvalidSignatureLength) {
787             revert("ECDSA: invalid signature length");
788         } else if (error == RecoverError.InvalidSignatureS) {
789             revert("ECDSA: invalid signature 's' value");
790         } else if (error == RecoverError.InvalidSignatureV) {
791             revert("ECDSA: invalid signature 'v' value");
792         }
793     }
794 
795     /**
796      * @dev Returns the address that signed a hashed message (`hash`) with
797      * `signature` or error string. This address can then be used for verification purposes.
798      *
799      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
800      * this function rejects them by requiring the `s` value to be in the lower
801      * half order, and the `v` value to be either 27 or 28.
802      *
803      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
804      * verification to be secure: it is possible to craft signatures that
805      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
806      * this is by receiving a hash of the original message (which may otherwise
807      * be too long), and then calling {toEthSignedMessageHash} on it.
808      *
809      * Documentation for signature generation:
810      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
811      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
812      *
813      * _Available since v4.3._
814      */
815     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
816         // Check the signature length
817         // - case 65: r,s,v signature (standard)
818         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
819         if (signature.length == 65) {
820             bytes32 r;
821             bytes32 s;
822             uint8 v;
823             // ecrecover takes the signature parameters, and the only way to get them
824             // currently is to use assembly.
825             assembly {
826                 r := mload(add(signature, 0x20))
827                 s := mload(add(signature, 0x40))
828                 v := byte(0, mload(add(signature, 0x60)))
829             }
830             return tryRecover(hash, v, r, s);
831         } else if (signature.length == 64) {
832             bytes32 r;
833             bytes32 vs;
834             // ecrecover takes the signature parameters, and the only way to get them
835             // currently is to use assembly.
836             assembly {
837                 r := mload(add(signature, 0x20))
838                 vs := mload(add(signature, 0x40))
839             }
840             return tryRecover(hash, r, vs);
841         } else {
842             return (address(0), RecoverError.InvalidSignatureLength);
843         }
844     }
845 
846     /**
847      * @dev Returns the address that signed a hashed message (`hash`) with
848      * `signature`. This address can then be used for verification purposes.
849      *
850      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
851      * this function rejects them by requiring the `s` value to be in the lower
852      * half order, and the `v` value to be either 27 or 28.
853      *
854      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
855      * verification to be secure: it is possible to craft signatures that
856      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
857      * this is by receiving a hash of the original message (which may otherwise
858      * be too long), and then calling {toEthSignedMessageHash} on it.
859      */
860     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
861         (address recovered, RecoverError error) = tryRecover(hash, signature);
862         _throwError(error);
863         return recovered;
864     }
865 
866     /**
867      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
868      *
869      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
870      *
871      * _Available since v4.3._
872      */
873     function tryRecover(
874         bytes32 hash,
875         bytes32 r,
876         bytes32 vs
877     ) internal pure returns (address, RecoverError) {
878         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
879         uint8 v = uint8((uint256(vs) >> 255) + 27);
880         return tryRecover(hash, v, r, s);
881     }
882 
883     /**
884      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
885      *
886      * _Available since v4.2._
887      */
888     function recover(
889         bytes32 hash,
890         bytes32 r,
891         bytes32 vs
892     ) internal pure returns (address) {
893         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
894         _throwError(error);
895         return recovered;
896     }
897 
898     /**
899      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
900      * `r` and `s` signature fields separately.
901      *
902      * _Available since v4.3._
903      */
904     function tryRecover(
905         bytes32 hash,
906         uint8 v,
907         bytes32 r,
908         bytes32 s
909     ) internal pure returns (address, RecoverError) {
910         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
911         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
912         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
913         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
914         //
915         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
916         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
917         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
918         // these malleable signatures as well.
919         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
920             return (address(0), RecoverError.InvalidSignatureS);
921         }
922         if (v != 27 && v != 28) {
923             return (address(0), RecoverError.InvalidSignatureV);
924         }
925 
926         // If the signature is valid (and not malleable), return the signer address
927         address signer = ecrecover(hash, v, r, s);
928         if (signer == address(0)) {
929             return (address(0), RecoverError.InvalidSignature);
930         }
931 
932         return (signer, RecoverError.NoError);
933     }
934 
935     /**
936      * @dev Overload of {ECDSA-recover} that receives the `v`,
937      * `r` and `s` signature fields separately.
938      */
939     function recover(
940         bytes32 hash,
941         uint8 v,
942         bytes32 r,
943         bytes32 s
944     ) internal pure returns (address) {
945         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
946         _throwError(error);
947         return recovered;
948     }
949 
950     /**
951      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
952      * produces hash corresponding to the one signed with the
953      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
954      * JSON-RPC method as part of EIP-191.
955      *
956      * See {recover}.
957      */
958     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
959         // 32 is the length in bytes of hash,
960         // enforced by the type signature above
961         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
962     }
963 
964     /**
965      * @dev Returns an Ethereum Signed Message, created from `s`. This
966      * produces hash corresponding to the one signed with the
967      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
968      * JSON-RPC method as part of EIP-191.
969      *
970      * See {recover}.
971      */
972     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
973         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
974     }
975 
976     /**
977      * @dev Returns an Ethereum Signed Typed Data, created from a
978      * `domainSeparator` and a `structHash`. This produces hash corresponding
979      * to the one signed with the
980      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
981      * JSON-RPC method as part of EIP-712.
982      *
983      * See {recover}.
984      */
985     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
986         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
987     }
988 }
989 
990 // 
991 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
992 /**
993  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
994  *
995  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
996  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
997  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
998  *
999  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1000  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1001  * ({_hashTypedDataV4}).
1002  *
1003  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1004  * the chain id to protect against replay attacks on an eventual fork of the chain.
1005  *
1006  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1007  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1008  *
1009  * _Available since v3.4._
1010  */
1011 abstract contract EIP712 {
1012     /* solhint-disable var-name-mixedcase */
1013     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1014     // invalidate the cached domain separator if the chain id changes.
1015     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1016     uint256 private immutable _CACHED_CHAIN_ID;
1017     address private immutable _CACHED_THIS;
1018 
1019     bytes32 private immutable _HASHED_NAME;
1020     bytes32 private immutable _HASHED_VERSION;
1021     bytes32 private immutable _TYPE_HASH;
1022 
1023     /* solhint-enable var-name-mixedcase */
1024 
1025     /**
1026      * @dev Initializes the domain separator and parameter caches.
1027      *
1028      * The meaning of `name` and `version` is specified in
1029      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1030      *
1031      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1032      * - `version`: the current major version of the signing domain.
1033      *
1034      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1035      * contract upgrade].
1036      */
1037     constructor(string memory name, string memory version) {
1038         bytes32 hashedName = keccak256(bytes(name));
1039         bytes32 hashedVersion = keccak256(bytes(version));
1040         bytes32 typeHash = keccak256(
1041             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1042         );
1043         _HASHED_NAME = hashedName;
1044         _HASHED_VERSION = hashedVersion;
1045         _CACHED_CHAIN_ID = block.chainid;
1046         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1047         _CACHED_THIS = address(this);
1048         _TYPE_HASH = typeHash;
1049     }
1050 
1051     /**
1052      * @dev Returns the domain separator for the current chain.
1053      */
1054     function _domainSeparatorV4() internal view returns (bytes32) {
1055         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1056             return _CACHED_DOMAIN_SEPARATOR;
1057         } else {
1058             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1059         }
1060     }
1061 
1062     function _buildDomainSeparator(
1063         bytes32 typeHash,
1064         bytes32 nameHash,
1065         bytes32 versionHash
1066     ) private view returns (bytes32) {
1067         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1068     }
1069 
1070     /**
1071      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1072      * function returns the hash of the fully encoded EIP712 message for this domain.
1073      *
1074      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1075      *
1076      * ```solidity
1077      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1078      *     keccak256("Mail(address to,string contents)"),
1079      *     mailTo,
1080      *     keccak256(bytes(mailContents))
1081      * )));
1082      * address signer = ECDSA.recover(digest, signature);
1083      * ```
1084      */
1085     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1086         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1087     }
1088 }
1089 
1090 // 
1091 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1092 /**
1093  * @title Counters
1094  * @author Matt Condon (@shrugs)
1095  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1096  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1097  *
1098  * Include with `using Counters for Counters.Counter;`
1099  */
1100 library Counters {
1101     struct Counter {
1102         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1103         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1104         // this feature: see https://github.com/ethereum/solidity/issues/4637
1105         uint256 _value; // default: 0
1106     }
1107 
1108     function current(Counter storage counter) internal view returns (uint256) {
1109         return counter._value;
1110     }
1111 
1112     function increment(Counter storage counter) internal {
1113         unchecked {
1114             counter._value += 1;
1115         }
1116     }
1117 
1118     function decrement(Counter storage counter) internal {
1119         uint256 value = counter._value;
1120         require(value > 0, "Counter: decrement overflow");
1121         unchecked {
1122             counter._value = value - 1;
1123         }
1124     }
1125 
1126     function reset(Counter storage counter) internal {
1127         counter._value = 0;
1128     }
1129 }
1130 
1131 // 
1132 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-ERC20Permit.sol)
1133 /**
1134  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1135  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1136  *
1137  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1138  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1139  * need to send a transaction, and thus is not required to hold Ether at all.
1140  *
1141  * _Available since v3.4._
1142  */
1143 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1144     using Counters for Counters.Counter;
1145 
1146     mapping(address => Counters.Counter) private _nonces;
1147 
1148     // solhint-disable-next-line var-name-mixedcase
1149     bytes32 private immutable _PERMIT_TYPEHASH =
1150         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1151 
1152     /**
1153      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1154      *
1155      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1156      */
1157     constructor(string memory name) EIP712(name, "1") {}
1158 
1159     /**
1160      * @dev See {IERC20Permit-permit}.
1161      */
1162     function permit(
1163         address owner,
1164         address spender,
1165         uint256 value,
1166         uint256 deadline,
1167         uint8 v,
1168         bytes32 r,
1169         bytes32 s
1170     ) public virtual override {
1171         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1172 
1173         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1174 
1175         bytes32 hash = _hashTypedDataV4(structHash);
1176 
1177         address signer = ECDSA.recover(hash, v, r, s);
1178         require(signer == owner, "ERC20Permit: invalid signature");
1179 
1180         _approve(owner, spender, value);
1181     }
1182 
1183     /**
1184      * @dev See {IERC20Permit-nonces}.
1185      */
1186     function nonces(address owner) public view virtual override returns (uint256) {
1187         return _nonces[owner].current();
1188     }
1189 
1190     /**
1191      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1192      */
1193     // solhint-disable-next-line func-name-mixedcase
1194     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1195         return _domainSeparatorV4();
1196     }
1197 
1198     /**
1199      * @dev "Consume a nonce": return the current value and increment.
1200      *
1201      * _Available since v4.1._
1202      */
1203     function _useNonce(address owner) internal virtual returns (uint256 current) {
1204         Counters.Counter storage nonce = _nonces[owner];
1205         current = nonce.current();
1206         nonce.increment();
1207     }
1208 }
1209 
1210 // 
1211 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
1212 /**
1213  * @dev Standard math utilities missing in the Solidity language.
1214  */
1215 library Math {
1216     /**
1217      * @dev Returns the largest of two numbers.
1218      */
1219     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1220         return a >= b ? a : b;
1221     }
1222 
1223     /**
1224      * @dev Returns the smallest of two numbers.
1225      */
1226     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1227         return a < b ? a : b;
1228     }
1229 
1230     /**
1231      * @dev Returns the average of two numbers. The result is rounded towards
1232      * zero.
1233      */
1234     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1235         // (a + b) / 2 can overflow.
1236         return (a & b) + (a ^ b) / 2;
1237     }
1238 
1239     /**
1240      * @dev Returns the ceiling of the division of two numbers.
1241      *
1242      * This differs from standard division with `/` in that it rounds up instead
1243      * of rounding down.
1244      */
1245     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1246         // (a + b - 1) / b can overflow on addition, so we distribute.
1247         return a / b + (a % b == 0 ? 0 : 1);
1248     }
1249 }
1250 
1251 // 
1252 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
1253 /**
1254  * @dev Collection of functions related to array types.
1255  */
1256 library Arrays {
1257     /**
1258      * @dev Searches a sorted `array` and returns the first index that contains
1259      * a value greater or equal to `element`. If no such index exists (i.e. all
1260      * values in the array are strictly less than `element`), the array length is
1261      * returned. Time complexity O(log n).
1262      *
1263      * `array` is expected to be sorted in ascending order, and to contain no
1264      * repeated elements.
1265      */
1266     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
1267         if (array.length == 0) {
1268             return 0;
1269         }
1270 
1271         uint256 low = 0;
1272         uint256 high = array.length;
1273 
1274         while (low < high) {
1275             uint256 mid = Math.average(low, high);
1276 
1277             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1278             // because Math.average rounds down (it does integer division with truncation).
1279             if (array[mid] > element) {
1280                 high = mid;
1281             } else {
1282                 low = mid + 1;
1283             }
1284         }
1285 
1286         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1287         if (low > 0 && array[low - 1] == element) {
1288             return low - 1;
1289         } else {
1290             return low;
1291         }
1292     }
1293 }
1294 
1295 // 
1296 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Snapshot.sol)
1297 /**
1298  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1299  * total supply at the time are recorded for later access.
1300  *
1301  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1302  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1303  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1304  * used to create an efficient ERC20 forking mechanism.
1305  *
1306  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1307  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1308  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1309  * and the account address.
1310  *
1311  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
1312  * return `block.number` will trigger the creation of snapshot at the begining of each new block. When overridding this
1313  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
1314  *
1315  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
1316  * alternative consider {ERC20Votes}.
1317  *
1318  * ==== Gas Costs
1319  *
1320  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1321  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1322  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1323  *
1324  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1325  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1326  * transfers will have normal cost until the next snapshot, and so on.
1327  */
1328 abstract contract ERC20Snapshot is ERC20 {
1329     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1330     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1331 
1332     using Arrays for uint256[];
1333     using Counters for Counters.Counter;
1334 
1335     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1336     // Snapshot struct, but that would impede usage of functions that work on an array.
1337     struct Snapshots {
1338         uint256[] ids;
1339         uint256[] values;
1340     }
1341 
1342     mapping(address => Snapshots) private _accountBalanceSnapshots;
1343     Snapshots private _totalSupplySnapshots;
1344 
1345     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1346     Counters.Counter private _currentSnapshotId;
1347 
1348     /**
1349      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1350      */
1351     event Snapshot(uint256 id);
1352 
1353     /**
1354      * @dev Creates a new snapshot and returns its snapshot id.
1355      *
1356      * Emits a {Snapshot} event that contains the same id.
1357      *
1358      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1359      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1360      *
1361      * [WARNING]
1362      * ====
1363      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1364      * you must consider that it can potentially be used by attackers in two ways.
1365      *
1366      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1367      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1368      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1369      * section above.
1370      *
1371      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1372      * ====
1373      */
1374     function _snapshot() internal virtual returns (uint256) {
1375         _currentSnapshotId.increment();
1376 
1377         uint256 currentId = _getCurrentSnapshotId();
1378         emit Snapshot(currentId);
1379         return currentId;
1380     }
1381 
1382     /**
1383      * @dev Get the current snapshotId
1384      */
1385     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
1386         return _currentSnapshotId.current();
1387     }
1388 
1389     /**
1390      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1391      */
1392     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
1393         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1394 
1395         return snapshotted ? value : balanceOf(account);
1396     }
1397 
1398     /**
1399      * @dev Retrieves the total supply at the time `snapshotId` was created.
1400      */
1401     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
1402         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1403 
1404         return snapshotted ? value : totalSupply();
1405     }
1406 
1407     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1408     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1409     function _beforeTokenTransfer(
1410         address from,
1411         address to,
1412         uint256 amount
1413     ) internal virtual override {
1414         super._beforeTokenTransfer(from, to, amount);
1415 
1416         if (from == address(0)) {
1417             // mint
1418             _updateAccountSnapshot(to);
1419             _updateTotalSupplySnapshot();
1420         } else if (to == address(0)) {
1421             // burn
1422             _updateAccountSnapshot(from);
1423             _updateTotalSupplySnapshot();
1424         } else {
1425             // transfer
1426             _updateAccountSnapshot(from);
1427             _updateAccountSnapshot(to);
1428         }
1429     }
1430 
1431     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
1432         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1433         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
1434 
1435         // When a valid snapshot is queried, there are three possibilities:
1436         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1437         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1438         //  to this id is the current one.
1439         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1440         //  requested id, and its value is the one to return.
1441         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1442         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1443         //  larger than the requested one.
1444         //
1445         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1446         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1447         // exactly this.
1448 
1449         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1450 
1451         if (index == snapshots.ids.length) {
1452             return (false, 0);
1453         } else {
1454             return (true, snapshots.values[index]);
1455         }
1456     }
1457 
1458     function _updateAccountSnapshot(address account) private {
1459         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1460     }
1461 
1462     function _updateTotalSupplySnapshot() private {
1463         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1464     }
1465 
1466     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1467         uint256 currentId = _getCurrentSnapshotId();
1468         if (_lastSnapshotId(snapshots.ids) < currentId) {
1469             snapshots.ids.push(currentId);
1470             snapshots.values.push(currentValue);
1471         }
1472     }
1473 
1474     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1475         if (ids.length == 0) {
1476             return 0;
1477         } else {
1478             return ids[ids.length - 1];
1479         }
1480     }
1481 }
1482 
1483 // 
1484 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1485 // CAUTION
1486 // This version of SafeMath should only be used with Solidity 0.8 or later,
1487 // because it relies on the compiler's built in overflow checks.
1488 /**
1489  * @dev Wrappers over Solidity's arithmetic operations.
1490  *
1491  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1492  * now has built in overflow checking.
1493  */
1494 library SafeMath {
1495     /**
1496      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1497      *
1498      * _Available since v3.4._
1499      */
1500     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1501         unchecked {
1502             uint256 c = a + b;
1503             if (c < a) return (false, 0);
1504             return (true, c);
1505         }
1506     }
1507 
1508     /**
1509      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1510      *
1511      * _Available since v3.4._
1512      */
1513     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1514         unchecked {
1515             if (b > a) return (false, 0);
1516             return (true, a - b);
1517         }
1518     }
1519 
1520     /**
1521      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1522      *
1523      * _Available since v3.4._
1524      */
1525     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1526         unchecked {
1527             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1528             // benefit is lost if 'b' is also tested.
1529             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1530             if (a == 0) return (true, 0);
1531             uint256 c = a * b;
1532             if (c / a != b) return (false, 0);
1533             return (true, c);
1534         }
1535     }
1536 
1537     /**
1538      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1539      *
1540      * _Available since v3.4._
1541      */
1542     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1543         unchecked {
1544             if (b == 0) return (false, 0);
1545             return (true, a / b);
1546         }
1547     }
1548 
1549     /**
1550      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1551      *
1552      * _Available since v3.4._
1553      */
1554     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1555         unchecked {
1556             if (b == 0) return (false, 0);
1557             return (true, a % b);
1558         }
1559     }
1560 
1561     /**
1562      * @dev Returns the addition of two unsigned integers, reverting on
1563      * overflow.
1564      *
1565      * Counterpart to Solidity's `+` operator.
1566      *
1567      * Requirements:
1568      *
1569      * - Addition cannot overflow.
1570      */
1571     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1572         return a + b;
1573     }
1574 
1575     /**
1576      * @dev Returns the subtraction of two unsigned integers, reverting on
1577      * overflow (when the result is negative).
1578      *
1579      * Counterpart to Solidity's `-` operator.
1580      *
1581      * Requirements:
1582      *
1583      * - Subtraction cannot overflow.
1584      */
1585     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1586         return a - b;
1587     }
1588 
1589     /**
1590      * @dev Returns the multiplication of two unsigned integers, reverting on
1591      * overflow.
1592      *
1593      * Counterpart to Solidity's `*` operator.
1594      *
1595      * Requirements:
1596      *
1597      * - Multiplication cannot overflow.
1598      */
1599     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1600         return a * b;
1601     }
1602 
1603     /**
1604      * @dev Returns the integer division of two unsigned integers, reverting on
1605      * division by zero. The result is rounded towards zero.
1606      *
1607      * Counterpart to Solidity's `/` operator.
1608      *
1609      * Requirements:
1610      *
1611      * - The divisor cannot be zero.
1612      */
1613     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1614         return a / b;
1615     }
1616 
1617     /**
1618      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1619      * reverting when dividing by zero.
1620      *
1621      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1622      * opcode (which leaves remaining gas untouched) while Solidity uses an
1623      * invalid opcode to revert (consuming all remaining gas).
1624      *
1625      * Requirements:
1626      *
1627      * - The divisor cannot be zero.
1628      */
1629     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1630         return a % b;
1631     }
1632 
1633     /**
1634      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1635      * overflow (when the result is negative).
1636      *
1637      * CAUTION: This function is deprecated because it requires allocating memory for the error
1638      * message unnecessarily. For custom revert reasons use {trySub}.
1639      *
1640      * Counterpart to Solidity's `-` operator.
1641      *
1642      * Requirements:
1643      *
1644      * - Subtraction cannot overflow.
1645      */
1646     function sub(
1647         uint256 a,
1648         uint256 b,
1649         string memory errorMessage
1650     ) internal pure returns (uint256) {
1651         unchecked {
1652             require(b <= a, errorMessage);
1653             return a - b;
1654         }
1655     }
1656 
1657     /**
1658      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1659      * division by zero. The result is rounded towards zero.
1660      *
1661      * Counterpart to Solidity's `/` operator. Note: this function uses a
1662      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1663      * uses an invalid opcode to revert (consuming all remaining gas).
1664      *
1665      * Requirements:
1666      *
1667      * - The divisor cannot be zero.
1668      */
1669     function div(
1670         uint256 a,
1671         uint256 b,
1672         string memory errorMessage
1673     ) internal pure returns (uint256) {
1674         unchecked {
1675             require(b > 0, errorMessage);
1676             return a / b;
1677         }
1678     }
1679 
1680     /**
1681      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1682      * reverting with custom message when dividing by zero.
1683      *
1684      * CAUTION: This function is deprecated because it requires allocating memory for the error
1685      * message unnecessarily. For custom revert reasons use {tryMod}.
1686      *
1687      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1688      * opcode (which leaves remaining gas untouched) while Solidity uses an
1689      * invalid opcode to revert (consuming all remaining gas).
1690      *
1691      * Requirements:
1692      *
1693      * - The divisor cannot be zero.
1694      */
1695     function mod(
1696         uint256 a,
1697         uint256 b,
1698         string memory errorMessage
1699     ) internal pure returns (uint256) {
1700         unchecked {
1701             require(b > 0, errorMessage);
1702             return a % b;
1703         }
1704     }
1705 }
1706 
1707 // 
1708 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1709 /**
1710  * @dev Collection of functions related to the address type
1711  */
1712 library Address {
1713     /**
1714      * @dev Returns true if `account` is a contract.
1715      *
1716      * [IMPORTANT]
1717      * ====
1718      * It is unsafe to assume that an address for which this function returns
1719      * false is an externally-owned account (EOA) and not a contract.
1720      *
1721      * Among others, `isContract` will return false for the following
1722      * types of addresses:
1723      *
1724      *  - an externally-owned account
1725      *  - a contract in construction
1726      *  - an address where a contract will be created
1727      *  - an address where a contract lived, but was destroyed
1728      * ====
1729      *
1730      * [IMPORTANT]
1731      * ====
1732      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1733      *
1734      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1735      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1736      * constructor.
1737      * ====
1738      */
1739     function isContract(address account) internal view returns (bool) {
1740         // This method relies on extcodesize/address.code.length, which returns 0
1741         // for contracts in construction, since the code is only stored at the end
1742         // of the constructor execution.
1743 
1744         return account.code.length > 0;
1745     }
1746 
1747     /**
1748      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1749      * `recipient`, forwarding all available gas and reverting on errors.
1750      *
1751      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1752      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1753      * imposed by `transfer`, making them unable to receive funds via
1754      * `transfer`. {sendValue} removes this limitation.
1755      *
1756      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1757      *
1758      * IMPORTANT: because control is transferred to `recipient`, care must be
1759      * taken to not create reentrancy vulnerabilities. Consider using
1760      * {ReentrancyGuard} or the
1761      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1762      */
1763     function sendValue(address payable recipient, uint256 amount) internal {
1764         require(address(this).balance >= amount, "Address: insufficient balance");
1765 
1766         (bool success, ) = recipient.call{value: amount}("");
1767         require(success, "Address: unable to send value, recipient may have reverted");
1768     }
1769 
1770     /**
1771      * @dev Performs a Solidity function call using a low level `call`. A
1772      * plain `call` is an unsafe replacement for a function call: use this
1773      * function instead.
1774      *
1775      * If `target` reverts with a revert reason, it is bubbled up by this
1776      * function (like regular Solidity function calls).
1777      *
1778      * Returns the raw returned data. To convert to the expected return value,
1779      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1780      *
1781      * Requirements:
1782      *
1783      * - `target` must be a contract.
1784      * - calling `target` with `data` must not revert.
1785      *
1786      * _Available since v3.1._
1787      */
1788     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1789         return functionCall(target, data, "Address: low-level call failed");
1790     }
1791 
1792     /**
1793      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1794      * `errorMessage` as a fallback revert reason when `target` reverts.
1795      *
1796      * _Available since v3.1._
1797      */
1798     function functionCall(
1799         address target,
1800         bytes memory data,
1801         string memory errorMessage
1802     ) internal returns (bytes memory) {
1803         return functionCallWithValue(target, data, 0, errorMessage);
1804     }
1805 
1806     /**
1807      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1808      * but also transferring `value` wei to `target`.
1809      *
1810      * Requirements:
1811      *
1812      * - the calling contract must have an ETH balance of at least `value`.
1813      * - the called Solidity function must be `payable`.
1814      *
1815      * _Available since v3.1._
1816      */
1817     function functionCallWithValue(
1818         address target,
1819         bytes memory data,
1820         uint256 value
1821     ) internal returns (bytes memory) {
1822         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1823     }
1824 
1825     /**
1826      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1827      * with `errorMessage` as a fallback revert reason when `target` reverts.
1828      *
1829      * _Available since v3.1._
1830      */
1831     function functionCallWithValue(
1832         address target,
1833         bytes memory data,
1834         uint256 value,
1835         string memory errorMessage
1836     ) internal returns (bytes memory) {
1837         require(address(this).balance >= value, "Address: insufficient balance for call");
1838         require(isContract(target), "Address: call to non-contract");
1839 
1840         (bool success, bytes memory returndata) = target.call{value: value}(data);
1841         return verifyCallResult(success, returndata, errorMessage);
1842     }
1843 
1844     /**
1845      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1846      * but performing a static call.
1847      *
1848      * _Available since v3.3._
1849      */
1850     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1851         return functionStaticCall(target, data, "Address: low-level static call failed");
1852     }
1853 
1854     /**
1855      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1856      * but performing a static call.
1857      *
1858      * _Available since v3.3._
1859      */
1860     function functionStaticCall(
1861         address target,
1862         bytes memory data,
1863         string memory errorMessage
1864     ) internal view returns (bytes memory) {
1865         require(isContract(target), "Address: static call to non-contract");
1866 
1867         (bool success, bytes memory returndata) = target.staticcall(data);
1868         return verifyCallResult(success, returndata, errorMessage);
1869     }
1870 
1871     /**
1872      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1873      * but performing a delegate call.
1874      *
1875      * _Available since v3.4._
1876      */
1877     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1878         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1879     }
1880 
1881     /**
1882      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1883      * but performing a delegate call.
1884      *
1885      * _Available since v3.4._
1886      */
1887     function functionDelegateCall(
1888         address target,
1889         bytes memory data,
1890         string memory errorMessage
1891     ) internal returns (bytes memory) {
1892         require(isContract(target), "Address: delegate call to non-contract");
1893 
1894         (bool success, bytes memory returndata) = target.delegatecall(data);
1895         return verifyCallResult(success, returndata, errorMessage);
1896     }
1897 
1898     /**
1899      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1900      * revert reason using the provided one.
1901      *
1902      * _Available since v4.3._
1903      */
1904     function verifyCallResult(
1905         bool success,
1906         bytes memory returndata,
1907         string memory errorMessage
1908     ) internal pure returns (bytes memory) {
1909         if (success) {
1910             return returndata;
1911         } else {
1912             // Look for revert reason and bubble it up if present
1913             if (returndata.length > 0) {
1914                 // The easiest way to bubble the revert reason is using memory via assembly
1915 
1916                 assembly {
1917                     let returndata_size := mload(returndata)
1918                     revert(add(32, returndata), returndata_size)
1919                 }
1920             } else {
1921                 revert(errorMessage);
1922             }
1923         }
1924     }
1925 }
1926 
1927 // 
1928 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
1929 /**
1930  * @title SafeERC20
1931  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1932  * contract returns false). Tokens that return no value (and instead revert or
1933  * throw on failure) are also supported, non-reverting calls are assumed to be
1934  * successful.
1935  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1936  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1937  */
1938 library SafeERC20 {
1939     using Address for address;
1940 
1941     function safeTransfer(
1942         IERC20 token,
1943         address to,
1944         uint256 value
1945     ) internal {
1946         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1947     }
1948 
1949     function safeTransferFrom(
1950         IERC20 token,
1951         address from,
1952         address to,
1953         uint256 value
1954     ) internal {
1955         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1956     }
1957 
1958     /**
1959      * @dev Deprecated. This function has issues similar to the ones found in
1960      * {IERC20-approve}, and its usage is discouraged.
1961      *
1962      * Whenever possible, use {safeIncreaseAllowance} and
1963      * {safeDecreaseAllowance} instead.
1964      */
1965     function safeApprove(
1966         IERC20 token,
1967         address spender,
1968         uint256 value
1969     ) internal {
1970         // safeApprove should only be called when setting an initial allowance,
1971         // or when resetting it to zero. To increase and decrease it, use
1972         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1973         require(
1974             (value == 0) || (token.allowance(address(this), spender) == 0),
1975             "SafeERC20: approve from non-zero to non-zero allowance"
1976         );
1977         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1978     }
1979 
1980     function safeIncreaseAllowance(
1981         IERC20 token,
1982         address spender,
1983         uint256 value
1984     ) internal {
1985         uint256 newAllowance = token.allowance(address(this), spender) + value;
1986         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1987     }
1988 
1989     function safeDecreaseAllowance(
1990         IERC20 token,
1991         address spender,
1992         uint256 value
1993     ) internal {
1994         unchecked {
1995             uint256 oldAllowance = token.allowance(address(this), spender);
1996             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1997             uint256 newAllowance = oldAllowance - value;
1998             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1999         }
2000     }
2001 
2002     /**
2003      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2004      * on the return value: the return value is optional (but if data is returned, it must not be false).
2005      * @param token The token targeted by the call.
2006      * @param data The call data (encoded using abi.encode or one of its variants).
2007      */
2008     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2009         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2010         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2011         // the target address contains contract code and also asserts for success in the low-level call.
2012 
2013         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2014         if (returndata.length > 0) {
2015             // Return data is optional
2016             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2017         }
2018     }
2019 }
2020 
2021 interface IUniswapV2Pair {
2022     event Approval(address indexed owner, address indexed spender, uint value);
2023     event Transfer(address indexed from, address indexed to, uint value);
2024 
2025     function name() external pure returns (string memory);
2026     function symbol() external pure returns (string memory);
2027     function decimals() external pure returns (uint8);
2028     function totalSupply() external view returns (uint);
2029     function balanceOf(address owner) external view returns (uint);
2030     function allowance(address owner, address spender) external view returns (uint);
2031 
2032     function approve(address spender, uint value) external returns (bool);
2033     function transfer(address to, uint value) external returns (bool);
2034     function transferFrom(address from, address to, uint value) external returns (bool);
2035 
2036     function DOMAIN_SEPARATOR() external view returns (bytes32);
2037     function PERMIT_TYPEHASH() external pure returns (bytes32);
2038     function nonces(address owner) external view returns (uint);
2039 
2040     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
2041 
2042     event Mint(address indexed sender, uint amount0, uint amount1);
2043     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
2044     event Swap(
2045         address indexed sender,
2046         uint amount0In,
2047         uint amount1In,
2048         uint amount0Out,
2049         uint amount1Out,
2050         address indexed to
2051     );
2052     event Sync(uint112 reserve0, uint112 reserve1);
2053 
2054     function MINIMUM_LIQUIDITY() external pure returns (uint);
2055     function factory() external view returns (address);
2056     function token0() external view returns (address);
2057     function token1() external view returns (address);
2058     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
2059     function price0CumulativeLast() external view returns (uint);
2060     function price1CumulativeLast() external view returns (uint);
2061     function kLast() external view returns (uint);
2062 
2063     function mint(address to) external returns (uint liquidity);
2064     function burn(address to) external returns (uint amount0, uint amount1);
2065     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
2066     function skim(address to) external;
2067     function sync() external;
2068 
2069     function initialize(address, address) external;
2070 }
2071 
2072 // 
2073 // QuickFarm V1
2074 // CREATED FOR MUSK GOLD BY QUICKFARM
2075 contract MuskGoldFarmV1 is Ownable, ReentrancyGuard {
2076     using SafeMath for uint256;
2077     using SafeERC20 for IERC20;
2078 
2079     //////////////////////////////////////////
2080     // USER DEPOSIT DEFINITION
2081     //////////////////////////////////////////
2082     struct UserDeposit {
2083         uint256 balance; // THE DEPOSITED NUMBER OF TOKENS BY THE USER
2084         uint256 unlockTime; // TIME WHEN THE USER CAN WITHDRAW FUNDS (BASED ON EPOCH)
2085         uint256 lastPayout; // BLOCK NUMBER OF THE LAST PAYOUT FOR THIS USER IN THIS POOL
2086         uint256 totalEarned; // TOTAL NUMBER OF TOKENS THIS USER HAS EARNED
2087     }
2088 
2089     //////////////////////////////////////////
2090     // REWARD POOL DEFINITION
2091     //////////////////////////////////////////
2092     struct RewardPool {
2093         IERC20 depositToken; // ADDRESS OF DEPOSITED TOKEN CONTRACT
2094         bool active; // DETERMINES WHETHER OR NOT THIS POOL IS USABLE
2095         bool hidden; // FLAG FOR WHETHER UI SHOULD RENDER THIS
2096         bool uniV2Lp; // SIGNIFIES A IUNISWAPV2PAIR
2097         bool selfStake; // SIGNIFIES IF THIS IS A 'SINGLE SIDED' SELF STAKE
2098         bytes32 lpOrigin; // ORIGIN OF LP TOKEN BEING DEPOSITED E.G. SUSHI, UNISWAP, PANCAKE - NULL IF NOT N LP TOKEN
2099         uint256 lockSeconds; // HOW LONG UNTIL AN LP DEPOSIT CAN BE REMOVED IN SECONDS
2100         bool lockEnforced; // DETERMINES WHETER TIME LOCKS ARE ENFORCED
2101         uint256 rewardPerBlock; // HOW MANY TOKENS TO REWARD PER BLOCK FOR THIS POOL
2102         bytes32 label; // TEXT LABEL STRICTLY FOR READABILITY AND RENDERING
2103         bytes32 order; // DISPLAY/PRESENTATION ORDER OF THE POOL
2104         uint256 depositSum; // SUM OF ALL DEPOSITED TOKENS IN THIS POOL
2105     }
2106 
2107     //////////////////////////////////////////
2108     // USER FARM STATE DEFINITION
2109     //////////////////////////////////////////
2110     struct UserFarmState {
2111         RewardPool[] pools; // REWARD POOLS
2112         uint256[] balance; // DEPOSITS BY POOL
2113         uint256[] unlockTime; // UNLOCK TIME FOR EACH POOL DEPOSIT
2114         uint256[] pending; // PENDING REWARDS BY POOL
2115         uint256[] earnings; // EARNINGS BY POOL
2116         uint256[] depTknBal; // USER BALANCE OF DEPOSIT TOKEN
2117         uint256[] depTknSupply; // TOTAL SUPPLY OF DEPOSIT TOKEN
2118         uint256[] reserve0; // RESERVE0 AMOUNT FOR LP TKN0
2119         uint256[] reserve1; // RESERVE1 AMOUNT FOR LP TKN1
2120         address[] token0; // ADDRESS OF LP TOKEN 0
2121         address[] token1; // ADDRESS OF LP TOKEN 1
2122         uint256 rewardTknBal; // CURRENT USER HOLDINGS OF THE REWARD TOKEN
2123         uint256 pendingAllPools; // REWARDS PENDING FOR ALL POOLS
2124         uint256 earningsAllPools; // REWARDS EARNED FOR ALL POOLS
2125     }
2126 
2127     //////////////////////////////////////////
2128     // INIT CLASS VARIABLES
2129     //////////////////////////////////////////
2130     bytes32 public name; // POOL NAME, FOR DISPLAY ON BLOCK EXPLORER
2131     IERC20 public rewardToken; // ADDRESS OF THE ERC20 REWARD TOKEN
2132     address public rewardWallet; // WALLE THAT REWARD TOKENS ARE DRAWN FROM
2133     uint256 public earliestRewards; // EARLIEST BLOCK REWARDS CAN BE GENERATED FROM (FOR FAIR LAUNCH)
2134     uint256 public paidOut = 0; // TOTAL AMOUNT OF REWARDS THAT HAVE BEEN PAID OUT
2135 
2136     RewardPool[] public rewardPools; // INFO OF EACH POOL
2137     address[] public depositAddresses; // LIST OF ADDRESSES THAT CURRENTLY HAVE FUNDS DEPOSITED
2138     mapping(uint256 => mapping(address => UserDeposit)) public userDeposits; // INFO OF EACH USER THAT STAKES LP TOKENS
2139 
2140     //////////////////////////////////////////
2141     // EVENTS
2142     //////////////////////////////////////////
2143     event Deposit(
2144         address indexed from,
2145         address indexed user,
2146         uint256 indexed pid,
2147         uint256 amount
2148     );
2149     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
2150     event Reward(address indexed user, uint256 indexed pid, uint256 amount);
2151     event Restake(address indexed user, uint256 indexed pid, uint256 amount);
2152     event EmergencyWithdraw(
2153         address indexed user,
2154         uint256 indexed pid,
2155         uint256 amount
2156     );
2157 
2158     //////////////////////////////////////////
2159     // CONSTRUCTOR
2160     //////////////////////////////////////////
2161     constructor(
2162         IERC20 _rewardToken,
2163         address _rewardWallet,
2164         uint256 _earliestRewards
2165     ) {
2166         name = "Musk Gold Farm";
2167         rewardToken = _rewardToken;
2168         rewardWallet = _rewardWallet;
2169         earliestRewards = _earliestRewards;
2170     }
2171 
2172     //////////////////////////////////////////
2173     // FARM FUNDING CONTROLS
2174     //////////////////////////////////////////
2175 
2176     // SETS ADDRESS THAT REWARDS ARE TO BE PAID FROM
2177     function setRewardWallet(address _source) external onlyOwner {
2178         rewardWallet = _source;
2179     }
2180 
2181     // FUND THE FARM (JUST DEPOSITS FUNDS INTO THE REWARD WALLET)
2182     function fund(uint256 _amount) external {
2183         require(msg.sender != rewardWallet, "Sender is reward wallet");
2184         rewardToken.safeTransferFrom(
2185             address(msg.sender),
2186             rewardWallet,
2187             _amount
2188         );
2189     }
2190 
2191     //////////////////////////////////////////
2192     // POOL CONTROLS
2193     //////////////////////////////////////////
2194 
2195     // ADD LP TOKEN REWARD POOL
2196     function addPool(
2197         IERC20 _depositToken,
2198         bool _active,
2199         bool _hidden,
2200         bool _uniV2Lp,
2201         bytes32 _lpOrigin,
2202         uint256 _lockSeconds,
2203         bool _lockEnforced,
2204         uint256 _rewardPerBlock,
2205         bytes32 _label,
2206         bytes32 _order
2207     ) external onlyOwner {
2208         // MAKE SURE THIS REWARD POOL FOR TOKEN + LOCK DOESN'T ALREADY EXIST
2209         require(
2210             poolExists(_depositToken, _lockSeconds) == false,
2211             "Reward pool for token already exists"
2212         );
2213 
2214         // IF TOKEN BEING DEPOSITED IS THE SAME AS THE REWARD TOKEN MARK IT AS A SELF STAKE (SINGLE SIDED)
2215         bool selfStake = false;
2216         if (_depositToken == rewardToken) {
2217             selfStake = true;
2218             _uniV2Lp = false;
2219         }
2220 
2221         rewardPools.push(
2222             RewardPool({
2223                 depositToken: _depositToken,
2224                 active: _active,
2225                 hidden: _hidden,
2226                 uniV2Lp: _uniV2Lp,
2227                 selfStake: selfStake, // MARKS IF A "SINGLED SIDED" STAKE OF THE REWARD TOKEN
2228                 lpOrigin: _lpOrigin,
2229                 lockSeconds: _lockSeconds,
2230                 lockEnforced: _lockEnforced,
2231                 rewardPerBlock: _rewardPerBlock,
2232                 label: _label,
2233                 order: _order,
2234                 depositSum: 0
2235             })
2236         );
2237     }
2238 
2239     function setPool(
2240         // MODIFY AN EXISTING POOL
2241         uint256 _pid,
2242         bool _active,
2243         bool _hidden,
2244         bool _uniV2Lp,
2245         bytes32 _lpOrigin,
2246         uint256 _lockSeconds,
2247         bool _lockEnforced,
2248         uint256 _rewardPerBlock,
2249         bytes32 _label,
2250         bytes32 _order
2251     ) external onlyOwner {
2252         rewardPools[_pid].active = _active;
2253         rewardPools[_pid].hidden = _hidden;
2254         rewardPools[_pid].uniV2Lp = _uniV2Lp;
2255         rewardPools[_pid].lpOrigin = _lpOrigin;
2256         rewardPools[_pid].lockSeconds = _lockSeconds;
2257         rewardPools[_pid].lockEnforced = _lockEnforced;
2258         rewardPools[_pid].rewardPerBlock = _rewardPerBlock;
2259         rewardPools[_pid].label = _label;
2260         rewardPools[_pid].order = _order;
2261     }
2262 
2263     // PAUSES/RESUMES DEPOSITS FOR ALL POOLS
2264     function setFarmActive(bool _value) public onlyOwner {
2265         for (uint256 pid = 0; pid < rewardPools.length; ++pid) {
2266             RewardPool storage pool = rewardPools[pid];
2267             pool.active = _value;
2268         }
2269     }
2270 
2271     // SETS THE EARLIEST BLOCK FROM WHICH TO CALCULATE REWARDS
2272     function setEarliestRewards(uint256 _value) external onlyOwner {
2273         require(
2274             _value >= block.number,
2275             "Earliest reward block must be greater than the current block"
2276         );
2277         earliestRewards = _value;
2278     }
2279 
2280     //////////////////////////////////////////
2281     // DEPOSIT/WITHDRAW METHODS
2282     //////////////////////////////////////////
2283 
2284     // SETS THE "LAST PAYOUT" FOR A USER TO ULTIMATELY DETERMINE HOW MANY REWARDS THEY ARE OWED
2285     function setLastPayout(UserDeposit storage _deposit) private {
2286         _deposit.lastPayout = block.number;
2287         if (_deposit.lastPayout < earliestRewards)
2288             _deposit.lastPayout = earliestRewards; // FAIR LAUNCH ACCOMODATION
2289     }
2290 
2291     // DEPOSIT TOKENS (LP OR SIMPLE ERC20) FOR A GIVEN TARGET (USER) WALLET
2292     function deposit(
2293         uint256 _pid,
2294         address _user,
2295         uint256 _amount
2296     ) public nonReentrant {
2297         RewardPool storage pool = rewardPools[_pid];
2298         require(_amount > 0, "Amount must be greater than zero");
2299         require(pool.active == true, "This reward pool is inactive");
2300 
2301         UserDeposit storage userDeposit = userDeposits[_pid][_user];
2302 
2303 		// SET INITIAL LAST PAYOUT
2304         if (userDeposit.lastPayout == 0) {
2305             userDeposit.lastPayout = block.number;
2306             if (userDeposit.lastPayout < earliestRewards)
2307                 userDeposit.lastPayout = earliestRewards; // FAIR LAUNCH ACCOMODATION
2308         }
2309 
2310         // COLLECT REWARD ONLY IF ADDRESS DEPOSITING IS THE OWNER OF THE DEPOSIT
2311         if (userDeposit.balance > 0 && msg.sender == _user) {
2312             payReward(_pid, _user);
2313         }
2314 
2315         pool.depositToken.safeTransferFrom(
2316             address(msg.sender),
2317             address(this),
2318             _amount
2319         ); // DO THE ACTUAL DEPOSIT
2320         userDeposit.balance = userDeposit.balance.add(_amount); // ADD THE TRANSFERRED AMOUNT TO THE DEPOSIT VALUE
2321         userDeposit.unlockTime = block.timestamp.add(pool.lockSeconds); // UPDATE THE UNLOCK TIME
2322         pool.depositSum = pool.depositSum.add(_amount); // KEEP TRACK OF TOTAL DEPOSITS IN THE POOL
2323 
2324         recordAddress(_user); // RECORD THE USER ADDRESS IN THE LIST
2325         emit Deposit(msg.sender, _user, _pid, _amount);
2326     }
2327 
2328     // PRIVATE METHOD TO PAY OUT USER REWARDS
2329     function payReward(uint256 _pid, address _user) private {
2330         UserDeposit storage userDeposit = userDeposits[_pid][_user]; // FETCH THE DEPOSIT
2331         uint256 rewardsDue = userPendingPool(_pid, _user); // GET PENDING REWARDS
2332 
2333         if (rewardsDue <= 0) return; // BAIL OUT IF NO REWARD IS DUE
2334 
2335         rewardToken.transferFrom(rewardWallet, _user, rewardsDue);
2336         emit Reward(_user, _pid, rewardsDue);
2337 
2338         userDeposit.totalEarned = userDeposit.totalEarned.add(rewardsDue); // ADD THE PAYOUT AMOUNT TO TOTAL EARNINGS
2339         paidOut = paidOut.add(rewardsDue); // ADD AMOUNT TO TOTAL PAIDOUT FOR THE WHOLE FARM
2340 
2341         setLastPayout(userDeposit); // UPDATE THE LAST PAYOUT
2342     }
2343 
2344     // EXTERNAL METHOD FOR USER'S TO COLLECT REWARDS
2345     function collectReward(uint256 _pid) external nonReentrant {
2346         payReward(_pid, msg.sender);
2347     }
2348 
2349     // RESTAKE REWARDS INTO SINGLE-SIDED POOLS
2350     function restake(uint256 _pid) external nonReentrant {
2351         RewardPool storage pool = rewardPools[_pid]; // GET THE POOL
2352         UserDeposit storage userDeposit = userDeposits[_pid][msg.sender]; // FETCH THE DEPOSIT
2353 
2354         require(
2355             pool.depositToken == rewardToken,
2356             "Restake is only available on single-sided staking"
2357         );
2358 
2359         uint256 rewardsDue = userPendingPool(_pid, msg.sender); // GET PENDING REWARD AMOUNT
2360         if (rewardsDue <= 0) return; // BAIL OUT IF NO REWARDS ARE TO BE PAID
2361 
2362         pool.depositToken.safeTransferFrom(
2363             rewardWallet,
2364             address(this),
2365             rewardsDue
2366         ); // MOVE FUNDS FROM THE REWARDS TO THIS CONTRACT
2367         pool.depositSum = pool.depositSum.add(rewardsDue);
2368 
2369         userDeposit.balance = userDeposit.balance.add(rewardsDue); // ADD THE FUNDS MOVED TO THE USER'S BALANCE
2370         userDeposit.totalEarned = userDeposit.totalEarned.add(rewardsDue); // ADD FUNDS MOVED TO USER'S TOTAL EARNINGS FOR POOL
2371 
2372         setLastPayout(userDeposit); // UPDATE THE LAST PAYOUT
2373 
2374         paidOut = paidOut.add(rewardsDue); // ADD TO THE TOTAL PAID OUT FOR THE FARM
2375         emit Restake(msg.sender, _pid, rewardsDue);
2376     }
2377 
2378     // WITHDRAW LP TOKENS FROM FARM.
2379     function withdraw(uint256 _pid, uint256 _amount) external nonReentrant {
2380         RewardPool storage pool = rewardPools[_pid];
2381         UserDeposit storage userDeposit = userDeposits[_pid][msg.sender];
2382 
2383         if (pool.lockEnforced)
2384             require(
2385                 userDeposit.unlockTime <= block.timestamp,
2386                 "withdraw: time lock has not passed"
2387             );
2388         require(
2389             userDeposit.balance >= _amount,
2390             "withdraw: can't withdraw more than deposit"
2391         );
2392 
2393         payReward(_pid, msg.sender); // PAY OUT ANY REWARDS ACCUMULATED UP TO THIS POINT
2394         setLastPayout(userDeposit); // UPDATE THE LAST PAYOUT
2395 
2396         userDeposit.unlockTime = block.timestamp.add(pool.lockSeconds); // RESET THE UNLOCK TIME
2397         userDeposit.balance = userDeposit.balance.sub(_amount); // SUBTRACT THE AMOUNT DEBITED FROM THE BALANCE
2398         pool.depositToken.safeTransfer(address(msg.sender), _amount); // TRANSFER THE WITHDRAWN AMOUNT BACK TO THE USER
2399         emit Withdraw(msg.sender, _pid, _amount);
2400 
2401         pool.depositSum = pool.depositSum.sub(_amount); // SUBTRACT THE WITHDRAWN AMOUNT FROM THE POOL DEPOSIT TOTAL
2402         cleanupAddress(msg.sender);
2403     }
2404 
2405     // APPEND ADDRESSES THAT HAVE FUNDS DEPOSITED FOR EASY RETRIEVAL
2406     function recordAddress(address _address) private {
2407         for (uint256 i = 0; i < depositAddresses.length; i++) {
2408             address curAddress = depositAddresses[i];
2409             if (_address == curAddress) return;
2410         }
2411         depositAddresses.push(_address);
2412     }
2413 
2414     // CLEAN ANY ADDRESSES THAT DON'T HAVE ACTIVE DEPOSITS
2415     function cleanupAddress(address _address) private {
2416         // CHECK TO SEE IF THE ADDRESS HAS ANY DEPOSITS
2417         uint256 deposits = 0;
2418         for (uint256 pid = 0; pid < rewardPools.length; pid++) {
2419             deposits = deposits.add(userDeposits[pid][_address].balance);
2420         }
2421 
2422         if (deposits > 0) return; // BAIL OUT IF USER STILL HAS DEPOSITS
2423 
2424         for (uint256 i = 0; i < depositAddresses.length; i++) {
2425             address curAddress = depositAddresses[i];
2426             if (_address == curAddress) delete depositAddresses[i]; // REMOVE ADDRESS FROM ARRAY
2427         }
2428     }
2429 
2430     //////////////////////////////////////////
2431     // INFORMATION METHODS
2432     //////////////////////////////////////////
2433 
2434     // RETURNS THE ARRAY OF POOLS
2435     function getPools() public view returns (RewardPool[] memory) {
2436         return rewardPools;
2437     }
2438 
2439     // RETURNS REWARD TOKENS REMAINING
2440     function rewardsRemaining() public view returns (uint256) {
2441         return rewardToken.balanceOf(rewardWallet);
2442     }
2443 
2444     // RETURNS COUNT OF ADDRESSES WITH DEPOSITS
2445     function addressCount() external view returns (uint256) {
2446         return depositAddresses.length;
2447     }
2448 
2449     // CHECK IF A GIVEN DEPOSIT TOKEN + TIMELOCK COMBINATION ALREADY EXISTS
2450     function poolExists(IERC20 _depositToken, uint256 _lockSeconds)
2451         private
2452         view
2453         returns (bool)
2454     {
2455         for (uint256 pid = 0; pid < rewardPools.length; ++pid) {
2456             RewardPool storage pool = rewardPools[pid];
2457             if (
2458                 pool.depositToken == _depositToken &&
2459                 pool.lockSeconds == _lockSeconds
2460             ) return true;
2461         }
2462         return false;
2463     }
2464 
2465     // RETURNS COUNT OF LP POOLS
2466     function poolLength() external view returns (uint256) {
2467         return rewardPools.length;
2468     }
2469 
2470     // RETURNS SUM OF DEPOSITS IN X POOL
2471     function poolDepositSum(uint256 _pid) external view returns (uint256) {
2472         return rewardPools[_pid].depositSum;
2473     }
2474 
2475     // VIEW FUNCTION TO SEE PENDING REWARDS FOR A USER
2476     function userPendingPool(uint256 _pid, address _user)
2477         public
2478         view
2479         returns (uint256)
2480     {
2481         RewardPool storage pool = rewardPools[_pid];
2482         UserDeposit storage userDeposit = userDeposits[_pid][_user];
2483 
2484         if (userDeposit.balance == 0) return 0;
2485         if (earliestRewards > block.number) return 0;
2486 
2487         uint256 precision = 1e36;
2488 
2489         uint256 blocksElapsed = 0;
2490         if (block.number > userDeposit.lastPayout)
2491             blocksElapsed = block.number.sub(userDeposit.lastPayout);
2492 
2493         uint256 poolOwnership = userDeposit.balance.mul(precision).div(
2494             pool.depositSum
2495         );
2496         uint256 rewardsDue = blocksElapsed
2497             .mul(pool.rewardPerBlock)
2498             .mul(poolOwnership)
2499             .div(precision);
2500         return rewardsDue;
2501     }
2502 
2503     // GETS PENDING REWARDS FOR A GIVEN USER IN ALL POOLS
2504     function userPendingAll(address _user) public view returns (uint256) {
2505         uint256 totalReward = 0;
2506         for (uint256 pid = 0; pid < rewardPools.length; ++pid) {
2507             uint256 pending = userPendingPool(pid, _user);
2508             totalReward = totalReward.add(pending);
2509         }
2510         return totalReward;
2511     }
2512 
2513     // RETURNS TOTAL PAID OUT TO A USER FOR A GIVEN POOL
2514     function userEarnedPool(uint256 _pid, address _user)
2515         public
2516         view
2517         returns (uint256)
2518     {
2519         return userDeposits[_pid][_user].totalEarned;
2520     }
2521 
2522     // RETURNS USER EARNINGS FOR ALL POOLS
2523     function userEarnedAll(address _user) public view returns (uint256) {
2524         uint256 totalEarned = 0;
2525         for (uint256 pid = 0; pid < rewardPools.length; ++pid) {
2526             totalEarned = totalEarned.add(userDeposits[pid][_user].totalEarned);
2527         }
2528         return totalEarned;
2529     }
2530 
2531     // VIEW FUNCTION FOR TOTAL REWARDS THE FARM HAS YET TO PAY OUT
2532     function farmTotalPending() external view returns (uint256) {
2533         uint256 pending = 0;
2534 
2535         for (uint256 i = 0; i < depositAddresses.length; ++i) {
2536             uint256 userPending = userPendingAll(depositAddresses[i]);
2537             pending = pending.add(userPending);
2538         }
2539         return pending;
2540     }
2541 
2542     // RETURNS A GIVEN USER'S STATE IN THE FARM IN A SINGLE CALL
2543     function getUserState(address _user)
2544         external
2545         view
2546         returns (UserFarmState memory)
2547     {
2548         uint256[] memory balance = new uint256[](rewardPools.length);
2549         uint256[] memory pending = new uint256[](rewardPools.length);
2550         uint256[] memory earned = new uint256[](rewardPools.length);
2551         uint256[] memory depTknBal = new uint256[](rewardPools.length);
2552         uint256[] memory depTknSupply = new uint256[](rewardPools.length);
2553         uint256[] memory depTknReserve0 = new uint256[](rewardPools.length);
2554         uint256[] memory depTknReserve1 = new uint256[](rewardPools.length);
2555         address[] memory depTknResTkn0 = new address[](rewardPools.length);
2556         address[] memory depTknResTkn1 = new address[](rewardPools.length);
2557         uint256[] memory unlockTime = new uint256[](rewardPools.length);
2558 
2559         for (uint256 pid = 0; pid < rewardPools.length; ++pid) {
2560             balance[pid] = userDeposits[pid][_user].balance;
2561             pending[pid] = userPendingPool(pid, _user);
2562             earned[pid] = userEarnedPool(pid, _user);
2563             depTknBal[pid] = rewardPools[pid].depositToken.balanceOf(_user);
2564             depTknSupply[pid] = rewardPools[pid].depositToken.totalSupply();
2565             unlockTime[pid] = userDeposits[pid][_user].unlockTime;
2566 
2567             if (
2568                 rewardPools[pid].uniV2Lp == true &&
2569                 rewardPools[pid].selfStake == false
2570             ) {
2571                 IUniswapV2Pair pair = IUniswapV2Pair(
2572                     address(rewardPools[pid].depositToken)
2573                 );
2574                 (uint256 res0, uint256 res1, uint256 timestamp) = pair
2575                     .getReserves();
2576                 depTknReserve0[pid] = res0;
2577                 depTknReserve1[pid] = res1;
2578                 depTknResTkn0[pid] = pair.token0();
2579                 depTknResTkn1[pid] = pair.token1();
2580             }
2581         }
2582 
2583         return
2584             UserFarmState(
2585                 rewardPools, // POOLS
2586                 balance, // DEPOSITS BY POOL
2587                 unlockTime, // UNLOCK TIME FOR EACH DEPOSITED POOL
2588                 pending, // PENDING REWARDS BY POOL
2589                 earned, // EARNINGS BY POOL
2590                 depTknBal, // USER BALANCE OF DEPOSIT TOKEN
2591                 depTknSupply, // TOTAL SUPPLY OF DEPOSIT TOKEN
2592                 depTknReserve0, // RESERVE0 AMOUNT FOR LP TKN0
2593                 depTknReserve1, // RESERVE1 AMOUNT FOR LP TKN1
2594                 depTknResTkn0, // ADDRESS OF LP TOKEN 0
2595                 depTknResTkn1, // ADDRESS OF LP TOKEN 1
2596                 rewardToken.balanceOf(_user), // CURRENT USER HOLDINGS OF THE REWARD TOKEN
2597                 userPendingAll(_user), // REWARDS PENDING FOR ALL POOLS
2598                 userEarnedAll(_user) // REWARDS EARNED FOR ALL POOLS
2599             );
2600     }
2601 
2602     //////////////////////////////////////////
2603     // EMERGENCY CONTROLS
2604     //////////////////////////////////////////
2605 
2606     // WITHDRAW WITHOUT CARING ABOUT REWARDS. EMERGENCY ONLY.
2607     // THIS WILL WIPE OUT ANY PENDING REWARDS FOR A USER
2608     function emergencyWithdraw(uint256 _pid) external nonReentrant {
2609         RewardPool storage pool = rewardPools[_pid]; // GET THE POOL
2610         UserDeposit storage userDeposit = userDeposits[_pid][msg.sender]; //GET THE DEPOSIT
2611 
2612         pool.depositToken.safeTransfer(
2613             address(msg.sender),
2614             userDeposit.balance
2615         ); // TRANSFER THE DEPOSIT BACK TO THE USER
2616         pool.depositSum = pool.depositSum.sub(userDeposit.balance); // DECREMENT THE POOL'S OVERALL DEPOSIT SUM
2617         userDeposit.unlockTime = block.timestamp.add(pool.lockSeconds); // RESET THE UNLOCK TIME
2618         userDeposit.balance = 0; // SET THE BALANCE TO ZERO AFTER WIRTHDRAWAL
2619         setLastPayout(userDeposit); // UPDATE THE LAST PAYOUT
2620 
2621         emit EmergencyWithdraw(msg.sender, _pid, userDeposit.balance);
2622     }
2623 }