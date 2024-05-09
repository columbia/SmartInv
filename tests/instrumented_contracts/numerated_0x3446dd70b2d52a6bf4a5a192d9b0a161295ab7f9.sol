1 // SPDX-License-Identifier: AGPL-3.0
2 pragma solidity ^0.8.13;
3 
4 /// @notice Simple single owner authorization mixin.
5 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
6 abstract contract Owned {
7     /*//////////////////////////////////////////////////////////////
8                                  EVENTS
9     //////////////////////////////////////////////////////////////*/
10 
11     event OwnershipTransferred(address indexed user, address indexed newOwner);
12 
13     /*//////////////////////////////////////////////////////////////
14                             OWNERSHIP STORAGE
15     //////////////////////////////////////////////////////////////*/
16 
17     address public owner;
18 
19     modifier onlyOwner() virtual {
20         require(msg.sender == owner, "UNAUTHORIZED");
21 
22         _;
23     }
24 
25     /*//////////////////////////////////////////////////////////////
26                                CONSTRUCTOR
27     //////////////////////////////////////////////////////////////*/
28 
29     constructor(address _owner) {
30         owner = _owner;
31 
32         emit OwnershipTransferred(address(0), _owner);
33     }
34 
35     /*//////////////////////////////////////////////////////////////
36                              OWNERSHIP LOGIC
37     //////////////////////////////////////////////////////////////*/
38 
39     function transferOwnership(address newOwner) public virtual onlyOwner {
40         owner = newOwner;
41 
42         emit OwnershipTransferred(msg.sender, newOwner);
43     }
44 }
45 
46 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20VotesComp.sol)
47 
48 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Votes.sol)
49 
50 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/extensions/ERC20Permit.sol)
51 
52 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Permit.sol)
53 
54 /**
55  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
56  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
57  *
58  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
59  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
60  * need to send a transaction, and thus is not required to hold Ether at all.
61  */
62 interface IERC20Permit {
63     /**
64      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
65      * given ``owner``'s signed approval.
66      *
67      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
68      * ordering also apply here.
69      *
70      * Emits an {Approval} event.
71      *
72      * Requirements:
73      *
74      * - `spender` cannot be the zero address.
75      * - `deadline` must be a timestamp in the future.
76      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
77      * over the EIP712-formatted function arguments.
78      * - the signature must use ``owner``'s current nonce (see {nonces}).
79      *
80      * For more information on the signature format, see the
81      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
82      * section].
83      */
84     function permit(
85         address owner,
86         address spender,
87         uint256 value,
88         uint256 deadline,
89         uint8 v,
90         bytes32 r,
91         bytes32 s
92     ) external;
93 
94     /**
95      * @dev Returns the current nonce for `owner`. This value must be
96      * included whenever a signature is generated for {permit}.
97      *
98      * Every successful call to {permit} increases ``owner``'s nonce by one. This
99      * prevents a signature from being used multiple times.
100      */
101     function nonces(address owner) external view returns (uint256);
102 
103     /**
104      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
105      */
106     // solhint-disable-next-line func-name-mixedcase
107     function DOMAIN_SEPARATOR() external view returns (bytes32);
108 }
109 
110 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
111 
112 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP.
116  */
117 interface IERC20 {
118     /**
119      * @dev Emitted when `value` tokens are moved from one account (`from`) to
120      * another (`to`).
121      *
122      * Note that `value` may be zero.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 
126     /**
127      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
128      * a call to {approve}. `value` is the new allowance.
129      */
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 
132     /**
133      * @dev Returns the amount of tokens in existence.
134      */
135     function totalSupply() external view returns (uint256);
136 
137     /**
138      * @dev Returns the amount of tokens owned by `account`.
139      */
140     function balanceOf(address account) external view returns (uint256);
141 
142     /**
143      * @dev Moves `amount` tokens from the caller's account to `to`.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transfer(address to, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Returns the remaining number of tokens that `spender` will be
153      * allowed to spend on behalf of `owner` through {transferFrom}. This is
154      * zero by default.
155      *
156      * This value changes when {approve} or {transferFrom} are called.
157      */
158     function allowance(address owner, address spender) external view returns (uint256);
159 
160     /**
161      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * IMPORTANT: Beware that changing an allowance with this method brings the risk
166      * that someone may use both the old and the new allowance by unfortunate
167      * transaction ordering. One possible solution to mitigate this race
168      * condition is to first reduce the spender's allowance to 0 and set the
169      * desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      *
172      * Emits an {Approval} event.
173      */
174     function approve(address spender, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Moves `amount` tokens from `from` to `to` using the
178      * allowance mechanism. `amount` is then deducted from the caller's
179      * allowance.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transferFrom(
186         address from,
187         address to,
188         uint256 amount
189     ) external returns (bool);
190 }
191 
192 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
193 
194 /**
195  * @dev Interface for the optional metadata functions from the ERC20 standard.
196  *
197  * _Available since v4.1._
198  */
199 interface IERC20Metadata is IERC20 {
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() external view returns (string memory);
204 
205     /**
206      * @dev Returns the symbol of the token.
207      */
208     function symbol() external view returns (string memory);
209 
210     /**
211      * @dev Returns the decimals places of the token.
212      */
213     function decimals() external view returns (uint8);
214 }
215 
216 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
217 
218 /**
219  * @dev Provides information about the current execution context, including the
220  * sender of the transaction and its data. While these are generally available
221  * via msg.sender and msg.data, they should not be accessed in such a direct
222  * manner, since when dealing with meta-transactions the account sending and
223  * paying for execution may not be the actual sender (as far as an application
224  * is concerned).
225  *
226  * This contract is only required for intermediate, library-like contracts.
227  */
228 abstract contract Context {
229     function _msgSender() internal view virtual returns (address) {
230         return msg.sender;
231     }
232 
233     function _msgData() internal view virtual returns (bytes calldata) {
234         return msg.data;
235     }
236 }
237 
238 /**
239  * @dev Implementation of the {IERC20} interface.
240  *
241  * This implementation is agnostic to the way tokens are created. This means
242  * that a supply mechanism has to be added in a derived contract using {_mint}.
243  * For a generic mechanism see {ERC20PresetMinterPauser}.
244  *
245  * TIP: For a detailed writeup see our guide
246  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
247  * to implement supply mechanisms].
248  *
249  * We have followed general OpenZeppelin Contracts guidelines: functions revert
250  * instead returning `false` on failure. This behavior is nonetheless
251  * conventional and does not conflict with the expectations of ERC20
252  * applications.
253  *
254  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
255  * This allows applications to reconstruct the allowance for all accounts just
256  * by listening to said events. Other implementations of the EIP may not emit
257  * these events, as it isn't required by the specification.
258  *
259  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
260  * functions have been added to mitigate the well-known issues around setting
261  * allowances. See {IERC20-approve}.
262  */
263 contract ERC20 is Context, IERC20, IERC20Metadata {
264     mapping(address => uint256) private _balances;
265 
266     mapping(address => mapping(address => uint256)) private _allowances;
267 
268     uint256 private _totalSupply;
269 
270     string private _name;
271     string private _symbol;
272 
273     /**
274      * @dev Sets the values for {name} and {symbol}.
275      *
276      * The default value of {decimals} is 18. To select a different value for
277      * {decimals} you should overload it.
278      *
279      * All two of these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor(string memory name_, string memory symbol_) {
283         _name = name_;
284         _symbol = symbol_;
285     }
286 
287     /**
288      * @dev Returns the name of the token.
289      */
290     function name() public view virtual override returns (string memory) {
291         return _name;
292     }
293 
294     /**
295      * @dev Returns the symbol of the token, usually a shorter version of the
296      * name.
297      */
298     function symbol() public view virtual override returns (string memory) {
299         return _symbol;
300     }
301 
302     /**
303      * @dev Returns the number of decimals used to get its user representation.
304      * For example, if `decimals` equals `2`, a balance of `505` tokens should
305      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
306      *
307      * Tokens usually opt for a value of 18, imitating the relationship between
308      * Ether and Wei. This is the value {ERC20} uses, unless this function is
309      * overridden;
310      *
311      * NOTE: This information is only used for _display_ purposes: it in
312      * no way affects any of the arithmetic of the contract, including
313      * {IERC20-balanceOf} and {IERC20-transfer}.
314      */
315     function decimals() public view virtual override returns (uint8) {
316         return 18;
317     }
318 
319     /**
320      * @dev See {IERC20-totalSupply}.
321      */
322     function totalSupply() public view virtual override returns (uint256) {
323         return _totalSupply;
324     }
325 
326     /**
327      * @dev See {IERC20-balanceOf}.
328      */
329     function balanceOf(address account) public view virtual override returns (uint256) {
330         return _balances[account];
331     }
332 
333     /**
334      * @dev See {IERC20-transfer}.
335      *
336      * Requirements:
337      *
338      * - `to` cannot be the zero address.
339      * - the caller must have a balance of at least `amount`.
340      */
341     function transfer(address to, uint256 amount) public virtual override returns (bool) {
342         address owner = _msgSender();
343         _transfer(owner, to, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {IERC20-allowance}.
349      */
350     function allowance(address owner, address spender) public view virtual override returns (uint256) {
351         return _allowances[owner][spender];
352     }
353 
354     /**
355      * @dev See {IERC20-approve}.
356      *
357      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
358      * `transferFrom`. This is semantically equivalent to an infinite approval.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function approve(address spender, uint256 amount) public virtual override returns (bool) {
365         address owner = _msgSender();
366         _approve(owner, spender, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-transferFrom}.
372      *
373      * Emits an {Approval} event indicating the updated allowance. This is not
374      * required by the EIP. See the note at the beginning of {ERC20}.
375      *
376      * NOTE: Does not update the allowance if the current allowance
377      * is the maximum `uint256`.
378      *
379      * Requirements:
380      *
381      * - `from` and `to` cannot be the zero address.
382      * - `from` must have a balance of at least `amount`.
383      * - the caller must have allowance for ``from``'s tokens of at least
384      * `amount`.
385      */
386     function transferFrom(
387         address from,
388         address to,
389         uint256 amount
390     ) public virtual override returns (bool) {
391         address spender = _msgSender();
392         _spendAllowance(from, spender, amount);
393         _transfer(from, to, amount);
394         return true;
395     }
396 
397     /**
398      * @dev Atomically increases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
410         address owner = _msgSender();
411         _approve(owner, spender, allowance(owner, spender) + addedValue);
412         return true;
413     }
414 
415     /**
416      * @dev Atomically decreases the allowance granted to `spender` by the caller.
417      *
418      * This is an alternative to {approve} that can be used as a mitigation for
419      * problems described in {IERC20-approve}.
420      *
421      * Emits an {Approval} event indicating the updated allowance.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      * - `spender` must have allowance for the caller of at least
427      * `subtractedValue`.
428      */
429     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
430         address owner = _msgSender();
431         uint256 currentAllowance = allowance(owner, spender);
432         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
433         unchecked {
434             _approve(owner, spender, currentAllowance - subtractedValue);
435         }
436 
437         return true;
438     }
439 
440     /**
441      * @dev Moves `amount` of tokens from `from` to `to`.
442      *
443      * This internal function is equivalent to {transfer}, and can be used to
444      * e.g. implement automatic token fees, slashing mechanisms, etc.
445      *
446      * Emits a {Transfer} event.
447      *
448      * Requirements:
449      *
450      * - `from` cannot be the zero address.
451      * - `to` cannot be the zero address.
452      * - `from` must have a balance of at least `amount`.
453      */
454     function _transfer(
455         address from,
456         address to,
457         uint256 amount
458     ) internal virtual {
459         require(from != address(0), "ERC20: transfer from the zero address");
460         require(to != address(0), "ERC20: transfer to the zero address");
461 
462         _beforeTokenTransfer(from, to, amount);
463 
464         uint256 fromBalance = _balances[from];
465         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
466         unchecked {
467             _balances[from] = fromBalance - amount;
468             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
469             // decrementing then incrementing.
470             _balances[to] += amount;
471         }
472 
473         emit Transfer(from, to, amount);
474 
475         _afterTokenTransfer(from, to, amount);
476     }
477 
478     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
479      * the total supply.
480      *
481      * Emits a {Transfer} event with `from` set to the zero address.
482      *
483      * Requirements:
484      *
485      * - `account` cannot be the zero address.
486      */
487     function _mint(address account, uint256 amount) internal virtual {
488         require(account != address(0), "ERC20: mint to the zero address");
489 
490         _beforeTokenTransfer(address(0), account, amount);
491 
492         _totalSupply += amount;
493         unchecked {
494             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
495             _balances[account] += amount;
496         }
497         emit Transfer(address(0), account, amount);
498 
499         _afterTokenTransfer(address(0), account, amount);
500     }
501 
502     /**
503      * @dev Destroys `amount` tokens from `account`, reducing the
504      * total supply.
505      *
506      * Emits a {Transfer} event with `to` set to the zero address.
507      *
508      * Requirements:
509      *
510      * - `account` cannot be the zero address.
511      * - `account` must have at least `amount` tokens.
512      */
513     function _burn(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: burn from the zero address");
515 
516         _beforeTokenTransfer(account, address(0), amount);
517 
518         uint256 accountBalance = _balances[account];
519         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
520         unchecked {
521             _balances[account] = accountBalance - amount;
522             // Overflow not possible: amount <= accountBalance <= totalSupply.
523             _totalSupply -= amount;
524         }
525 
526         emit Transfer(account, address(0), amount);
527 
528         _afterTokenTransfer(account, address(0), amount);
529     }
530 
531     /**
532      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
533      *
534      * This internal function is equivalent to `approve`, and can be used to
535      * e.g. set automatic allowances for certain subsystems, etc.
536      *
537      * Emits an {Approval} event.
538      *
539      * Requirements:
540      *
541      * - `owner` cannot be the zero address.
542      * - `spender` cannot be the zero address.
543      */
544     function _approve(
545         address owner,
546         address spender,
547         uint256 amount
548     ) internal virtual {
549         require(owner != address(0), "ERC20: approve from the zero address");
550         require(spender != address(0), "ERC20: approve to the zero address");
551 
552         _allowances[owner][spender] = amount;
553         emit Approval(owner, spender, amount);
554     }
555 
556     /**
557      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
558      *
559      * Does not update the allowance amount in case of infinite allowance.
560      * Revert if not enough allowance is available.
561      *
562      * Might emit an {Approval} event.
563      */
564     function _spendAllowance(
565         address owner,
566         address spender,
567         uint256 amount
568     ) internal virtual {
569         uint256 currentAllowance = allowance(owner, spender);
570         if (currentAllowance != type(uint256).max) {
571             require(currentAllowance >= amount, "ERC20: insufficient allowance");
572             unchecked {
573                 _approve(owner, spender, currentAllowance - amount);
574             }
575         }
576     }
577 
578     /**
579      * @dev Hook that is called before any transfer of tokens. This includes
580      * minting and burning.
581      *
582      * Calling conditions:
583      *
584      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
585      * will be transferred to `to`.
586      * - when `from` is zero, `amount` tokens will be minted for `to`.
587      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
588      * - `from` and `to` are never both zero.
589      *
590      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
591      */
592     function _beforeTokenTransfer(
593         address from,
594         address to,
595         uint256 amount
596     ) internal virtual {}
597 
598     /**
599      * @dev Hook that is called after any transfer of tokens. This includes
600      * minting and burning.
601      *
602      * Calling conditions:
603      *
604      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
605      * has been transferred to `to`.
606      * - when `from` is zero, `amount` tokens have been minted for `to`.
607      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
608      * - `from` and `to` are never both zero.
609      *
610      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
611      */
612     function _afterTokenTransfer(
613         address from,
614         address to,
615         uint256 amount
616     ) internal virtual {}
617 }
618 
619 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
620 
621 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
622 
623 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
624 
625 /**
626  * @dev Standard math utilities missing in the Solidity language.
627  */
628 library Math {
629     enum Rounding {
630         Down, // Toward negative infinity
631         Up, // Toward infinity
632         Zero // Toward zero
633     }
634 
635     /**
636      * @dev Returns the largest of two numbers.
637      */
638     function max(uint256 a, uint256 b) internal pure returns (uint256) {
639         return a > b ? a : b;
640     }
641 
642     /**
643      * @dev Returns the smallest of two numbers.
644      */
645     function min(uint256 a, uint256 b) internal pure returns (uint256) {
646         return a < b ? a : b;
647     }
648 
649     /**
650      * @dev Returns the average of two numbers. The result is rounded towards
651      * zero.
652      */
653     function average(uint256 a, uint256 b) internal pure returns (uint256) {
654         // (a + b) / 2 can overflow.
655         return (a & b) + (a ^ b) / 2;
656     }
657 
658     /**
659      * @dev Returns the ceiling of the division of two numbers.
660      *
661      * This differs from standard division with `/` in that it rounds up instead
662      * of rounding down.
663      */
664     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
665         // (a + b - 1) / b can overflow on addition, so we distribute.
666         return a == 0 ? 0 : (a - 1) / b + 1;
667     }
668 
669     /**
670      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
671      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
672      * with further edits by Uniswap Labs also under MIT license.
673      */
674     function mulDiv(
675         uint256 x,
676         uint256 y,
677         uint256 denominator
678     ) internal pure returns (uint256 result) {
679         unchecked {
680             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
681             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
682             // variables such that product = prod1 * 2^256 + prod0.
683             uint256 prod0; // Least significant 256 bits of the product
684             uint256 prod1; // Most significant 256 bits of the product
685             assembly {
686                 let mm := mulmod(x, y, not(0))
687                 prod0 := mul(x, y)
688                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
689             }
690 
691             // Handle non-overflow cases, 256 by 256 division.
692             if (prod1 == 0) {
693                 return prod0 / denominator;
694             }
695 
696             // Make sure the result is less than 2^256. Also prevents denominator == 0.
697             require(denominator > prod1);
698 
699             ///////////////////////////////////////////////
700             // 512 by 256 division.
701             ///////////////////////////////////////////////
702 
703             // Make division exact by subtracting the remainder from [prod1 prod0].
704             uint256 remainder;
705             assembly {
706                 // Compute remainder using mulmod.
707                 remainder := mulmod(x, y, denominator)
708 
709                 // Subtract 256 bit number from 512 bit number.
710                 prod1 := sub(prod1, gt(remainder, prod0))
711                 prod0 := sub(prod0, remainder)
712             }
713 
714             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
715             // See https://cs.stackexchange.com/q/138556/92363.
716 
717             // Does not overflow because the denominator cannot be zero at this stage in the function.
718             uint256 twos = denominator & (~denominator + 1);
719             assembly {
720                 // Divide denominator by twos.
721                 denominator := div(denominator, twos)
722 
723                 // Divide [prod1 prod0] by twos.
724                 prod0 := div(prod0, twos)
725 
726                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
727                 twos := add(div(sub(0, twos), twos), 1)
728             }
729 
730             // Shift in bits from prod1 into prod0.
731             prod0 |= prod1 * twos;
732 
733             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
734             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
735             // four bits. That is, denominator * inv = 1 mod 2^4.
736             uint256 inverse = (3 * denominator) ^ 2;
737 
738             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
739             // in modular arithmetic, doubling the correct bits in each step.
740             inverse *= 2 - denominator * inverse; // inverse mod 2^8
741             inverse *= 2 - denominator * inverse; // inverse mod 2^16
742             inverse *= 2 - denominator * inverse; // inverse mod 2^32
743             inverse *= 2 - denominator * inverse; // inverse mod 2^64
744             inverse *= 2 - denominator * inverse; // inverse mod 2^128
745             inverse *= 2 - denominator * inverse; // inverse mod 2^256
746 
747             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
748             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
749             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
750             // is no longer required.
751             result = prod0 * inverse;
752             return result;
753         }
754     }
755 
756     /**
757      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
758      */
759     function mulDiv(
760         uint256 x,
761         uint256 y,
762         uint256 denominator,
763         Rounding rounding
764     ) internal pure returns (uint256) {
765         uint256 result = mulDiv(x, y, denominator);
766         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
767             result += 1;
768         }
769         return result;
770     }
771 
772     /**
773      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
774      *
775      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
776      */
777     function sqrt(uint256 a) internal pure returns (uint256) {
778         if (a == 0) {
779             return 0;
780         }
781 
782         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
783         //
784         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
785         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
786         //
787         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
788         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
789         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
790         //
791         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
792         uint256 result = 1 << (log2(a) >> 1);
793 
794         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
795         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
796         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
797         // into the expected uint128 result.
798         unchecked {
799             result = (result + a / result) >> 1;
800             result = (result + a / result) >> 1;
801             result = (result + a / result) >> 1;
802             result = (result + a / result) >> 1;
803             result = (result + a / result) >> 1;
804             result = (result + a / result) >> 1;
805             result = (result + a / result) >> 1;
806             return min(result, a / result);
807         }
808     }
809 
810     /**
811      * @notice Calculates sqrt(a), following the selected rounding direction.
812      */
813     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
814         unchecked {
815             uint256 result = sqrt(a);
816             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
817         }
818     }
819 
820     /**
821      * @dev Return the log in base 2, rounded down, of a positive value.
822      * Returns 0 if given 0.
823      */
824     function log2(uint256 value) internal pure returns (uint256) {
825         uint256 result = 0;
826         unchecked {
827             if (value >> 128 > 0) {
828                 value >>= 128;
829                 result += 128;
830             }
831             if (value >> 64 > 0) {
832                 value >>= 64;
833                 result += 64;
834             }
835             if (value >> 32 > 0) {
836                 value >>= 32;
837                 result += 32;
838             }
839             if (value >> 16 > 0) {
840                 value >>= 16;
841                 result += 16;
842             }
843             if (value >> 8 > 0) {
844                 value >>= 8;
845                 result += 8;
846             }
847             if (value >> 4 > 0) {
848                 value >>= 4;
849                 result += 4;
850             }
851             if (value >> 2 > 0) {
852                 value >>= 2;
853                 result += 2;
854             }
855             if (value >> 1 > 0) {
856                 result += 1;
857             }
858         }
859         return result;
860     }
861 
862     /**
863      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
864      * Returns 0 if given 0.
865      */
866     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
867         unchecked {
868             uint256 result = log2(value);
869             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
870         }
871     }
872 
873     /**
874      * @dev Return the log in base 10, rounded down, of a positive value.
875      * Returns 0 if given 0.
876      */
877     function log10(uint256 value) internal pure returns (uint256) {
878         uint256 result = 0;
879         unchecked {
880             if (value >= 10**64) {
881                 value /= 10**64;
882                 result += 64;
883             }
884             if (value >= 10**32) {
885                 value /= 10**32;
886                 result += 32;
887             }
888             if (value >= 10**16) {
889                 value /= 10**16;
890                 result += 16;
891             }
892             if (value >= 10**8) {
893                 value /= 10**8;
894                 result += 8;
895             }
896             if (value >= 10**4) {
897                 value /= 10**4;
898                 result += 4;
899             }
900             if (value >= 10**2) {
901                 value /= 10**2;
902                 result += 2;
903             }
904             if (value >= 10**1) {
905                 result += 1;
906             }
907         }
908         return result;
909     }
910 
911     /**
912      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
913      * Returns 0 if given 0.
914      */
915     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
916         unchecked {
917             uint256 result = log10(value);
918             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
919         }
920     }
921 
922     /**
923      * @dev Return the log in base 256, rounded down, of a positive value.
924      * Returns 0 if given 0.
925      *
926      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
927      */
928     function log256(uint256 value) internal pure returns (uint256) {
929         uint256 result = 0;
930         unchecked {
931             if (value >> 128 > 0) {
932                 value >>= 128;
933                 result += 16;
934             }
935             if (value >> 64 > 0) {
936                 value >>= 64;
937                 result += 8;
938             }
939             if (value >> 32 > 0) {
940                 value >>= 32;
941                 result += 4;
942             }
943             if (value >> 16 > 0) {
944                 value >>= 16;
945                 result += 2;
946             }
947             if (value >> 8 > 0) {
948                 result += 1;
949             }
950         }
951         return result;
952     }
953 
954     /**
955      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
956      * Returns 0 if given 0.
957      */
958     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
959         unchecked {
960             uint256 result = log256(value);
961             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
962         }
963     }
964 }
965 
966 /**
967  * @dev String operations.
968  */
969 library Strings {
970     bytes16 private constant _SYMBOLS = "0123456789abcdef";
971     uint8 private constant _ADDRESS_LENGTH = 20;
972 
973     /**
974      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
975      */
976     function toString(uint256 value) internal pure returns (string memory) {
977         unchecked {
978             uint256 length = Math.log10(value) + 1;
979             string memory buffer = new string(length);
980             uint256 ptr;
981             /// @solidity memory-safe-assembly
982             assembly {
983                 ptr := add(buffer, add(32, length))
984             }
985             while (true) {
986                 ptr--;
987                 /// @solidity memory-safe-assembly
988                 assembly {
989                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
990                 }
991                 value /= 10;
992                 if (value == 0) break;
993             }
994             return buffer;
995         }
996     }
997 
998     /**
999      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1000      */
1001     function toHexString(uint256 value) internal pure returns (string memory) {
1002         unchecked {
1003             return toHexString(value, Math.log256(value) + 1);
1004         }
1005     }
1006 
1007     /**
1008      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1009      */
1010     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1011         bytes memory buffer = new bytes(2 * length + 2);
1012         buffer[0] = "0";
1013         buffer[1] = "x";
1014         for (uint256 i = 2 * length + 1; i > 1; --i) {
1015             buffer[i] = _SYMBOLS[value & 0xf];
1016             value >>= 4;
1017         }
1018         require(value == 0, "Strings: hex length insufficient");
1019         return string(buffer);
1020     }
1021 
1022     /**
1023      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1024      */
1025     function toHexString(address addr) internal pure returns (string memory) {
1026         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1027     }
1028 }
1029 
1030 /**
1031  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1032  *
1033  * These functions can be used to verify that a message was signed by the holder
1034  * of the private keys of a given address.
1035  */
1036 library ECDSA {
1037     enum RecoverError {
1038         NoError,
1039         InvalidSignature,
1040         InvalidSignatureLength,
1041         InvalidSignatureS,
1042         InvalidSignatureV // Deprecated in v4.8
1043     }
1044 
1045     function _throwError(RecoverError error) private pure {
1046         if (error == RecoverError.NoError) {
1047             return; // no error: do nothing
1048         } else if (error == RecoverError.InvalidSignature) {
1049             revert("ECDSA: invalid signature");
1050         } else if (error == RecoverError.InvalidSignatureLength) {
1051             revert("ECDSA: invalid signature length");
1052         } else if (error == RecoverError.InvalidSignatureS) {
1053             revert("ECDSA: invalid signature 's' value");
1054         }
1055     }
1056 
1057     /**
1058      * @dev Returns the address that signed a hashed message (`hash`) with
1059      * `signature` or error string. This address can then be used for verification purposes.
1060      *
1061      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1062      * this function rejects them by requiring the `s` value to be in the lower
1063      * half order, and the `v` value to be either 27 or 28.
1064      *
1065      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1066      * verification to be secure: it is possible to craft signatures that
1067      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1068      * this is by receiving a hash of the original message (which may otherwise
1069      * be too long), and then calling {toEthSignedMessageHash} on it.
1070      *
1071      * Documentation for signature generation:
1072      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1073      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1074      *
1075      * _Available since v4.3._
1076      */
1077     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1078         if (signature.length == 65) {
1079             bytes32 r;
1080             bytes32 s;
1081             uint8 v;
1082             // ecrecover takes the signature parameters, and the only way to get them
1083             // currently is to use assembly.
1084             /// @solidity memory-safe-assembly
1085             assembly {
1086                 r := mload(add(signature, 0x20))
1087                 s := mload(add(signature, 0x40))
1088                 v := byte(0, mload(add(signature, 0x60)))
1089             }
1090             return tryRecover(hash, v, r, s);
1091         } else {
1092             return (address(0), RecoverError.InvalidSignatureLength);
1093         }
1094     }
1095 
1096     /**
1097      * @dev Returns the address that signed a hashed message (`hash`) with
1098      * `signature`. This address can then be used for verification purposes.
1099      *
1100      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1101      * this function rejects them by requiring the `s` value to be in the lower
1102      * half order, and the `v` value to be either 27 or 28.
1103      *
1104      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1105      * verification to be secure: it is possible to craft signatures that
1106      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1107      * this is by receiving a hash of the original message (which may otherwise
1108      * be too long), and then calling {toEthSignedMessageHash} on it.
1109      */
1110     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1111         (address recovered, RecoverError error) = tryRecover(hash, signature);
1112         _throwError(error);
1113         return recovered;
1114     }
1115 
1116     /**
1117      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1118      *
1119      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1120      *
1121      * _Available since v4.3._
1122      */
1123     function tryRecover(
1124         bytes32 hash,
1125         bytes32 r,
1126         bytes32 vs
1127     ) internal pure returns (address, RecoverError) {
1128         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1129         uint8 v = uint8((uint256(vs) >> 255) + 27);
1130         return tryRecover(hash, v, r, s);
1131     }
1132 
1133     /**
1134      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1135      *
1136      * _Available since v4.2._
1137      */
1138     function recover(
1139         bytes32 hash,
1140         bytes32 r,
1141         bytes32 vs
1142     ) internal pure returns (address) {
1143         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1144         _throwError(error);
1145         return recovered;
1146     }
1147 
1148     /**
1149      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1150      * `r` and `s` signature fields separately.
1151      *
1152      * _Available since v4.3._
1153      */
1154     function tryRecover(
1155         bytes32 hash,
1156         uint8 v,
1157         bytes32 r,
1158         bytes32 s
1159     ) internal pure returns (address, RecoverError) {
1160         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1161         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1162         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1163         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1164         //
1165         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1166         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1167         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1168         // these malleable signatures as well.
1169         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1170             return (address(0), RecoverError.InvalidSignatureS);
1171         }
1172 
1173         // If the signature is valid (and not malleable), return the signer address
1174         address signer = ecrecover(hash, v, r, s);
1175         if (signer == address(0)) {
1176             return (address(0), RecoverError.InvalidSignature);
1177         }
1178 
1179         return (signer, RecoverError.NoError);
1180     }
1181 
1182     /**
1183      * @dev Overload of {ECDSA-recover} that receives the `v`,
1184      * `r` and `s` signature fields separately.
1185      */
1186     function recover(
1187         bytes32 hash,
1188         uint8 v,
1189         bytes32 r,
1190         bytes32 s
1191     ) internal pure returns (address) {
1192         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1193         _throwError(error);
1194         return recovered;
1195     }
1196 
1197     /**
1198      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1199      * produces hash corresponding to the one signed with the
1200      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1201      * JSON-RPC method as part of EIP-191.
1202      *
1203      * See {recover}.
1204      */
1205     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1206         // 32 is the length in bytes of hash,
1207         // enforced by the type signature above
1208         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1209     }
1210 
1211     /**
1212      * @dev Returns an Ethereum Signed Message, created from `s`. This
1213      * produces hash corresponding to the one signed with the
1214      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1215      * JSON-RPC method as part of EIP-191.
1216      *
1217      * See {recover}.
1218      */
1219     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1220         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1221     }
1222 
1223     /**
1224      * @dev Returns an Ethereum Signed Typed Data, created from a
1225      * `domainSeparator` and a `structHash`. This produces hash corresponding
1226      * to the one signed with the
1227      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1228      * JSON-RPC method as part of EIP-712.
1229      *
1230      * See {recover}.
1231      */
1232     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1233         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1234     }
1235 }
1236 
1237 /**
1238  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1239  *
1240  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1241  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1242  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1243  *
1244  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1245  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1246  * ({_hashTypedDataV4}).
1247  *
1248  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1249  * the chain id to protect against replay attacks on an eventual fork of the chain.
1250  *
1251  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1252  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1253  *
1254  * _Available since v3.4._
1255  */
1256 abstract contract EIP712 {
1257     /* solhint-disable var-name-mixedcase */
1258     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1259     // invalidate the cached domain separator if the chain id changes.
1260     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1261     uint256 private immutable _CACHED_CHAIN_ID;
1262     address private immutable _CACHED_THIS;
1263 
1264     bytes32 private immutable _HASHED_NAME;
1265     bytes32 private immutable _HASHED_VERSION;
1266     bytes32 private immutable _TYPE_HASH;
1267 
1268     /* solhint-enable var-name-mixedcase */
1269 
1270     /**
1271      * @dev Initializes the domain separator and parameter caches.
1272      *
1273      * The meaning of `name` and `version` is specified in
1274      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1275      *
1276      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1277      * - `version`: the current major version of the signing domain.
1278      *
1279      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1280      * contract upgrade].
1281      */
1282     constructor(string memory name, string memory version) {
1283         bytes32 hashedName = keccak256(bytes(name));
1284         bytes32 hashedVersion = keccak256(bytes(version));
1285         bytes32 typeHash = keccak256(
1286             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1287         );
1288         _HASHED_NAME = hashedName;
1289         _HASHED_VERSION = hashedVersion;
1290         _CACHED_CHAIN_ID = block.chainid;
1291         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1292         _CACHED_THIS = address(this);
1293         _TYPE_HASH = typeHash;
1294     }
1295 
1296     /**
1297      * @dev Returns the domain separator for the current chain.
1298      */
1299     function _domainSeparatorV4() internal view returns (bytes32) {
1300         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1301             return _CACHED_DOMAIN_SEPARATOR;
1302         } else {
1303             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1304         }
1305     }
1306 
1307     function _buildDomainSeparator(
1308         bytes32 typeHash,
1309         bytes32 nameHash,
1310         bytes32 versionHash
1311     ) private view returns (bytes32) {
1312         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1313     }
1314 
1315     /**
1316      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1317      * function returns the hash of the fully encoded EIP712 message for this domain.
1318      *
1319      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1320      *
1321      * ```solidity
1322      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1323      *     keccak256("Mail(address to,string contents)"),
1324      *     mailTo,
1325      *     keccak256(bytes(mailContents))
1326      * )));
1327      * address signer = ECDSA.recover(digest, signature);
1328      * ```
1329      */
1330     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1331         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1332     }
1333 }
1334 
1335 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1336 
1337 /**
1338  * @title Counters
1339  * @author Matt Condon (@shrugs)
1340  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1341  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1342  *
1343  * Include with `using Counters for Counters.Counter;`
1344  */
1345 library Counters {
1346     struct Counter {
1347         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1348         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1349         // this feature: see https://github.com/ethereum/solidity/issues/4637
1350         uint256 _value; // default: 0
1351     }
1352 
1353     function current(Counter storage counter) internal view returns (uint256) {
1354         return counter._value;
1355     }
1356 
1357     function increment(Counter storage counter) internal {
1358         unchecked {
1359             counter._value += 1;
1360         }
1361     }
1362 
1363     function decrement(Counter storage counter) internal {
1364         uint256 value = counter._value;
1365         require(value > 0, "Counter: decrement overflow");
1366         unchecked {
1367             counter._value = value - 1;
1368         }
1369     }
1370 
1371     function reset(Counter storage counter) internal {
1372         counter._value = 0;
1373     }
1374 }
1375 
1376 /**
1377  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1378  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1379  *
1380  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1381  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1382  * need to send a transaction, and thus is not required to hold Ether at all.
1383  *
1384  * _Available since v3.4._
1385  */
1386 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1387     using Counters for Counters.Counter;
1388 
1389     mapping(address => Counters.Counter) private _nonces;
1390 
1391     // solhint-disable-next-line var-name-mixedcase
1392     bytes32 private constant _PERMIT_TYPEHASH =
1393         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1394     /**
1395      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
1396      * However, to ensure consistency with the upgradeable transpiler, we will continue
1397      * to reserve a slot.
1398      * @custom:oz-renamed-from _PERMIT_TYPEHASH
1399      */
1400     // solhint-disable-next-line var-name-mixedcase
1401     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
1402 
1403     /**
1404      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1405      *
1406      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1407      */
1408     constructor(string memory name) EIP712(name, "1") {}
1409 
1410     /**
1411      * @dev See {IERC20Permit-permit}.
1412      */
1413     function permit(
1414         address owner,
1415         address spender,
1416         uint256 value,
1417         uint256 deadline,
1418         uint8 v,
1419         bytes32 r,
1420         bytes32 s
1421     ) public virtual override {
1422         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1423 
1424         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1425 
1426         bytes32 hash = _hashTypedDataV4(structHash);
1427 
1428         address signer = ECDSA.recover(hash, v, r, s);
1429         require(signer == owner, "ERC20Permit: invalid signature");
1430 
1431         _approve(owner, spender, value);
1432     }
1433 
1434     /**
1435      * @dev See {IERC20Permit-nonces}.
1436      */
1437     function nonces(address owner) public view virtual override returns (uint256) {
1438         return _nonces[owner].current();
1439     }
1440 
1441     /**
1442      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1443      */
1444     // solhint-disable-next-line func-name-mixedcase
1445     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1446         return _domainSeparatorV4();
1447     }
1448 
1449     /**
1450      * @dev "Consume a nonce": return the current value and increment.
1451      *
1452      * _Available since v4.1._
1453      */
1454     function _useNonce(address owner) internal virtual returns (uint256 current) {
1455         Counters.Counter storage nonce = _nonces[owner];
1456         current = nonce.current();
1457         nonce.increment();
1458     }
1459 }
1460 
1461 // OpenZeppelin Contracts (last updated v4.5.0) (governance/utils/IVotes.sol)
1462 
1463 /**
1464  * @dev Common interface for {ERC20Votes}, {ERC721Votes}, and other {Votes}-enabled contracts.
1465  *
1466  * _Available since v4.5._
1467  */
1468 interface IVotes {
1469     /**
1470      * @dev Emitted when an account changes their delegate.
1471      */
1472     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1473 
1474     /**
1475      * @dev Emitted when a token transfer or delegate change results in changes to a delegate's number of votes.
1476      */
1477     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1478 
1479     /**
1480      * @dev Returns the current amount of votes that `account` has.
1481      */
1482     function getVotes(address account) external view returns (uint256);
1483 
1484     /**
1485      * @dev Returns the amount of votes that `account` had at the end of a past block (`blockNumber`).
1486      */
1487     function getPastVotes(address account, uint256 blockNumber) external view returns (uint256);
1488 
1489     /**
1490      * @dev Returns the total supply of votes available at the end of a past block (`blockNumber`).
1491      *
1492      * NOTE: This value is the sum of all available votes, which is not necessarily the sum of all delegated votes.
1493      * Votes that have not been delegated are still part of total supply, even though they would not participate in a
1494      * vote.
1495      */
1496     function getPastTotalSupply(uint256 blockNumber) external view returns (uint256);
1497 
1498     /**
1499      * @dev Returns the delegate that `account` has chosen.
1500      */
1501     function delegates(address account) external view returns (address);
1502 
1503     /**
1504      * @dev Delegates votes from the sender to `delegatee`.
1505      */
1506     function delegate(address delegatee) external;
1507 
1508     /**
1509      * @dev Delegates votes from signer to `delegatee`.
1510      */
1511     function delegateBySig(
1512         address delegatee,
1513         uint256 nonce,
1514         uint256 expiry,
1515         uint8 v,
1516         bytes32 r,
1517         bytes32 s
1518     ) external;
1519 }
1520 
1521 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/SafeCast.sol)
1522 // This file was procedurally generated from scripts/generate/templates/SafeCast.js.
1523 
1524 /**
1525  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1526  * checks.
1527  *
1528  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1529  * easily result in undesired exploitation or bugs, since developers usually
1530  * assume that overflows raise errors. `SafeCast` restores this intuition by
1531  * reverting the transaction when such an operation overflows.
1532  *
1533  * Using this library instead of the unchecked operations eliminates an entire
1534  * class of bugs, so it's recommended to use it always.
1535  *
1536  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1537  * all math on `uint256` and `int256` and then downcasting.
1538  */
1539 library SafeCast {
1540     /**
1541      * @dev Returns the downcasted uint248 from uint256, reverting on
1542      * overflow (when the input is greater than largest uint248).
1543      *
1544      * Counterpart to Solidity's `uint248` operator.
1545      *
1546      * Requirements:
1547      *
1548      * - input must fit into 248 bits
1549      *
1550      * _Available since v4.7._
1551      */
1552     function toUint248(uint256 value) internal pure returns (uint248) {
1553         require(value <= type(uint248).max, "SafeCast: value doesn't fit in 248 bits");
1554         return uint248(value);
1555     }
1556 
1557     /**
1558      * @dev Returns the downcasted uint240 from uint256, reverting on
1559      * overflow (when the input is greater than largest uint240).
1560      *
1561      * Counterpart to Solidity's `uint240` operator.
1562      *
1563      * Requirements:
1564      *
1565      * - input must fit into 240 bits
1566      *
1567      * _Available since v4.7._
1568      */
1569     function toUint240(uint256 value) internal pure returns (uint240) {
1570         require(value <= type(uint240).max, "SafeCast: value doesn't fit in 240 bits");
1571         return uint240(value);
1572     }
1573 
1574     /**
1575      * @dev Returns the downcasted uint232 from uint256, reverting on
1576      * overflow (when the input is greater than largest uint232).
1577      *
1578      * Counterpart to Solidity's `uint232` operator.
1579      *
1580      * Requirements:
1581      *
1582      * - input must fit into 232 bits
1583      *
1584      * _Available since v4.7._
1585      */
1586     function toUint232(uint256 value) internal pure returns (uint232) {
1587         require(value <= type(uint232).max, "SafeCast: value doesn't fit in 232 bits");
1588         return uint232(value);
1589     }
1590 
1591     /**
1592      * @dev Returns the downcasted uint224 from uint256, reverting on
1593      * overflow (when the input is greater than largest uint224).
1594      *
1595      * Counterpart to Solidity's `uint224` operator.
1596      *
1597      * Requirements:
1598      *
1599      * - input must fit into 224 bits
1600      *
1601      * _Available since v4.2._
1602      */
1603     function toUint224(uint256 value) internal pure returns (uint224) {
1604         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1605         return uint224(value);
1606     }
1607 
1608     /**
1609      * @dev Returns the downcasted uint216 from uint256, reverting on
1610      * overflow (when the input is greater than largest uint216).
1611      *
1612      * Counterpart to Solidity's `uint216` operator.
1613      *
1614      * Requirements:
1615      *
1616      * - input must fit into 216 bits
1617      *
1618      * _Available since v4.7._
1619      */
1620     function toUint216(uint256 value) internal pure returns (uint216) {
1621         require(value <= type(uint216).max, "SafeCast: value doesn't fit in 216 bits");
1622         return uint216(value);
1623     }
1624 
1625     /**
1626      * @dev Returns the downcasted uint208 from uint256, reverting on
1627      * overflow (when the input is greater than largest uint208).
1628      *
1629      * Counterpart to Solidity's `uint208` operator.
1630      *
1631      * Requirements:
1632      *
1633      * - input must fit into 208 bits
1634      *
1635      * _Available since v4.7._
1636      */
1637     function toUint208(uint256 value) internal pure returns (uint208) {
1638         require(value <= type(uint208).max, "SafeCast: value doesn't fit in 208 bits");
1639         return uint208(value);
1640     }
1641 
1642     /**
1643      * @dev Returns the downcasted uint200 from uint256, reverting on
1644      * overflow (when the input is greater than largest uint200).
1645      *
1646      * Counterpart to Solidity's `uint200` operator.
1647      *
1648      * Requirements:
1649      *
1650      * - input must fit into 200 bits
1651      *
1652      * _Available since v4.7._
1653      */
1654     function toUint200(uint256 value) internal pure returns (uint200) {
1655         require(value <= type(uint200).max, "SafeCast: value doesn't fit in 200 bits");
1656         return uint200(value);
1657     }
1658 
1659     /**
1660      * @dev Returns the downcasted uint192 from uint256, reverting on
1661      * overflow (when the input is greater than largest uint192).
1662      *
1663      * Counterpart to Solidity's `uint192` operator.
1664      *
1665      * Requirements:
1666      *
1667      * - input must fit into 192 bits
1668      *
1669      * _Available since v4.7._
1670      */
1671     function toUint192(uint256 value) internal pure returns (uint192) {
1672         require(value <= type(uint192).max, "SafeCast: value doesn't fit in 192 bits");
1673         return uint192(value);
1674     }
1675 
1676     /**
1677      * @dev Returns the downcasted uint184 from uint256, reverting on
1678      * overflow (when the input is greater than largest uint184).
1679      *
1680      * Counterpart to Solidity's `uint184` operator.
1681      *
1682      * Requirements:
1683      *
1684      * - input must fit into 184 bits
1685      *
1686      * _Available since v4.7._
1687      */
1688     function toUint184(uint256 value) internal pure returns (uint184) {
1689         require(value <= type(uint184).max, "SafeCast: value doesn't fit in 184 bits");
1690         return uint184(value);
1691     }
1692 
1693     /**
1694      * @dev Returns the downcasted uint176 from uint256, reverting on
1695      * overflow (when the input is greater than largest uint176).
1696      *
1697      * Counterpart to Solidity's `uint176` operator.
1698      *
1699      * Requirements:
1700      *
1701      * - input must fit into 176 bits
1702      *
1703      * _Available since v4.7._
1704      */
1705     function toUint176(uint256 value) internal pure returns (uint176) {
1706         require(value <= type(uint176).max, "SafeCast: value doesn't fit in 176 bits");
1707         return uint176(value);
1708     }
1709 
1710     /**
1711      * @dev Returns the downcasted uint168 from uint256, reverting on
1712      * overflow (when the input is greater than largest uint168).
1713      *
1714      * Counterpart to Solidity's `uint168` operator.
1715      *
1716      * Requirements:
1717      *
1718      * - input must fit into 168 bits
1719      *
1720      * _Available since v4.7._
1721      */
1722     function toUint168(uint256 value) internal pure returns (uint168) {
1723         require(value <= type(uint168).max, "SafeCast: value doesn't fit in 168 bits");
1724         return uint168(value);
1725     }
1726 
1727     /**
1728      * @dev Returns the downcasted uint160 from uint256, reverting on
1729      * overflow (when the input is greater than largest uint160).
1730      *
1731      * Counterpart to Solidity's `uint160` operator.
1732      *
1733      * Requirements:
1734      *
1735      * - input must fit into 160 bits
1736      *
1737      * _Available since v4.7._
1738      */
1739     function toUint160(uint256 value) internal pure returns (uint160) {
1740         require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
1741         return uint160(value);
1742     }
1743 
1744     /**
1745      * @dev Returns the downcasted uint152 from uint256, reverting on
1746      * overflow (when the input is greater than largest uint152).
1747      *
1748      * Counterpart to Solidity's `uint152` operator.
1749      *
1750      * Requirements:
1751      *
1752      * - input must fit into 152 bits
1753      *
1754      * _Available since v4.7._
1755      */
1756     function toUint152(uint256 value) internal pure returns (uint152) {
1757         require(value <= type(uint152).max, "SafeCast: value doesn't fit in 152 bits");
1758         return uint152(value);
1759     }
1760 
1761     /**
1762      * @dev Returns the downcasted uint144 from uint256, reverting on
1763      * overflow (when the input is greater than largest uint144).
1764      *
1765      * Counterpart to Solidity's `uint144` operator.
1766      *
1767      * Requirements:
1768      *
1769      * - input must fit into 144 bits
1770      *
1771      * _Available since v4.7._
1772      */
1773     function toUint144(uint256 value) internal pure returns (uint144) {
1774         require(value <= type(uint144).max, "SafeCast: value doesn't fit in 144 bits");
1775         return uint144(value);
1776     }
1777 
1778     /**
1779      * @dev Returns the downcasted uint136 from uint256, reverting on
1780      * overflow (when the input is greater than largest uint136).
1781      *
1782      * Counterpart to Solidity's `uint136` operator.
1783      *
1784      * Requirements:
1785      *
1786      * - input must fit into 136 bits
1787      *
1788      * _Available since v4.7._
1789      */
1790     function toUint136(uint256 value) internal pure returns (uint136) {
1791         require(value <= type(uint136).max, "SafeCast: value doesn't fit in 136 bits");
1792         return uint136(value);
1793     }
1794 
1795     /**
1796      * @dev Returns the downcasted uint128 from uint256, reverting on
1797      * overflow (when the input is greater than largest uint128).
1798      *
1799      * Counterpart to Solidity's `uint128` operator.
1800      *
1801      * Requirements:
1802      *
1803      * - input must fit into 128 bits
1804      *
1805      * _Available since v2.5._
1806      */
1807     function toUint128(uint256 value) internal pure returns (uint128) {
1808         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1809         return uint128(value);
1810     }
1811 
1812     /**
1813      * @dev Returns the downcasted uint120 from uint256, reverting on
1814      * overflow (when the input is greater than largest uint120).
1815      *
1816      * Counterpart to Solidity's `uint120` operator.
1817      *
1818      * Requirements:
1819      *
1820      * - input must fit into 120 bits
1821      *
1822      * _Available since v4.7._
1823      */
1824     function toUint120(uint256 value) internal pure returns (uint120) {
1825         require(value <= type(uint120).max, "SafeCast: value doesn't fit in 120 bits");
1826         return uint120(value);
1827     }
1828 
1829     /**
1830      * @dev Returns the downcasted uint112 from uint256, reverting on
1831      * overflow (when the input is greater than largest uint112).
1832      *
1833      * Counterpart to Solidity's `uint112` operator.
1834      *
1835      * Requirements:
1836      *
1837      * - input must fit into 112 bits
1838      *
1839      * _Available since v4.7._
1840      */
1841     function toUint112(uint256 value) internal pure returns (uint112) {
1842         require(value <= type(uint112).max, "SafeCast: value doesn't fit in 112 bits");
1843         return uint112(value);
1844     }
1845 
1846     /**
1847      * @dev Returns the downcasted uint104 from uint256, reverting on
1848      * overflow (when the input is greater than largest uint104).
1849      *
1850      * Counterpart to Solidity's `uint104` operator.
1851      *
1852      * Requirements:
1853      *
1854      * - input must fit into 104 bits
1855      *
1856      * _Available since v4.7._
1857      */
1858     function toUint104(uint256 value) internal pure returns (uint104) {
1859         require(value <= type(uint104).max, "SafeCast: value doesn't fit in 104 bits");
1860         return uint104(value);
1861     }
1862 
1863     /**
1864      * @dev Returns the downcasted uint96 from uint256, reverting on
1865      * overflow (when the input is greater than largest uint96).
1866      *
1867      * Counterpart to Solidity's `uint96` operator.
1868      *
1869      * Requirements:
1870      *
1871      * - input must fit into 96 bits
1872      *
1873      * _Available since v4.2._
1874      */
1875     function toUint96(uint256 value) internal pure returns (uint96) {
1876         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1877         return uint96(value);
1878     }
1879 
1880     /**
1881      * @dev Returns the downcasted uint88 from uint256, reverting on
1882      * overflow (when the input is greater than largest uint88).
1883      *
1884      * Counterpart to Solidity's `uint88` operator.
1885      *
1886      * Requirements:
1887      *
1888      * - input must fit into 88 bits
1889      *
1890      * _Available since v4.7._
1891      */
1892     function toUint88(uint256 value) internal pure returns (uint88) {
1893         require(value <= type(uint88).max, "SafeCast: value doesn't fit in 88 bits");
1894         return uint88(value);
1895     }
1896 
1897     /**
1898      * @dev Returns the downcasted uint80 from uint256, reverting on
1899      * overflow (when the input is greater than largest uint80).
1900      *
1901      * Counterpart to Solidity's `uint80` operator.
1902      *
1903      * Requirements:
1904      *
1905      * - input must fit into 80 bits
1906      *
1907      * _Available since v4.7._
1908      */
1909     function toUint80(uint256 value) internal pure returns (uint80) {
1910         require(value <= type(uint80).max, "SafeCast: value doesn't fit in 80 bits");
1911         return uint80(value);
1912     }
1913 
1914     /**
1915      * @dev Returns the downcasted uint72 from uint256, reverting on
1916      * overflow (when the input is greater than largest uint72).
1917      *
1918      * Counterpart to Solidity's `uint72` operator.
1919      *
1920      * Requirements:
1921      *
1922      * - input must fit into 72 bits
1923      *
1924      * _Available since v4.7._
1925      */
1926     function toUint72(uint256 value) internal pure returns (uint72) {
1927         require(value <= type(uint72).max, "SafeCast: value doesn't fit in 72 bits");
1928         return uint72(value);
1929     }
1930 
1931     /**
1932      * @dev Returns the downcasted uint64 from uint256, reverting on
1933      * overflow (when the input is greater than largest uint64).
1934      *
1935      * Counterpart to Solidity's `uint64` operator.
1936      *
1937      * Requirements:
1938      *
1939      * - input must fit into 64 bits
1940      *
1941      * _Available since v2.5._
1942      */
1943     function toUint64(uint256 value) internal pure returns (uint64) {
1944         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1945         return uint64(value);
1946     }
1947 
1948     /**
1949      * @dev Returns the downcasted uint56 from uint256, reverting on
1950      * overflow (when the input is greater than largest uint56).
1951      *
1952      * Counterpart to Solidity's `uint56` operator.
1953      *
1954      * Requirements:
1955      *
1956      * - input must fit into 56 bits
1957      *
1958      * _Available since v4.7._
1959      */
1960     function toUint56(uint256 value) internal pure returns (uint56) {
1961         require(value <= type(uint56).max, "SafeCast: value doesn't fit in 56 bits");
1962         return uint56(value);
1963     }
1964 
1965     /**
1966      * @dev Returns the downcasted uint48 from uint256, reverting on
1967      * overflow (when the input is greater than largest uint48).
1968      *
1969      * Counterpart to Solidity's `uint48` operator.
1970      *
1971      * Requirements:
1972      *
1973      * - input must fit into 48 bits
1974      *
1975      * _Available since v4.7._
1976      */
1977     function toUint48(uint256 value) internal pure returns (uint48) {
1978         require(value <= type(uint48).max, "SafeCast: value doesn't fit in 48 bits");
1979         return uint48(value);
1980     }
1981 
1982     /**
1983      * @dev Returns the downcasted uint40 from uint256, reverting on
1984      * overflow (when the input is greater than largest uint40).
1985      *
1986      * Counterpart to Solidity's `uint40` operator.
1987      *
1988      * Requirements:
1989      *
1990      * - input must fit into 40 bits
1991      *
1992      * _Available since v4.7._
1993      */
1994     function toUint40(uint256 value) internal pure returns (uint40) {
1995         require(value <= type(uint40).max, "SafeCast: value doesn't fit in 40 bits");
1996         return uint40(value);
1997     }
1998 
1999     /**
2000      * @dev Returns the downcasted uint32 from uint256, reverting on
2001      * overflow (when the input is greater than largest uint32).
2002      *
2003      * Counterpart to Solidity's `uint32` operator.
2004      *
2005      * Requirements:
2006      *
2007      * - input must fit into 32 bits
2008      *
2009      * _Available since v2.5._
2010      */
2011     function toUint32(uint256 value) internal pure returns (uint32) {
2012         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
2013         return uint32(value);
2014     }
2015 
2016     /**
2017      * @dev Returns the downcasted uint24 from uint256, reverting on
2018      * overflow (when the input is greater than largest uint24).
2019      *
2020      * Counterpart to Solidity's `uint24` operator.
2021      *
2022      * Requirements:
2023      *
2024      * - input must fit into 24 bits
2025      *
2026      * _Available since v4.7._
2027      */
2028     function toUint24(uint256 value) internal pure returns (uint24) {
2029         require(value <= type(uint24).max, "SafeCast: value doesn't fit in 24 bits");
2030         return uint24(value);
2031     }
2032 
2033     /**
2034      * @dev Returns the downcasted uint16 from uint256, reverting on
2035      * overflow (when the input is greater than largest uint16).
2036      *
2037      * Counterpart to Solidity's `uint16` operator.
2038      *
2039      * Requirements:
2040      *
2041      * - input must fit into 16 bits
2042      *
2043      * _Available since v2.5._
2044      */
2045     function toUint16(uint256 value) internal pure returns (uint16) {
2046         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
2047         return uint16(value);
2048     }
2049 
2050     /**
2051      * @dev Returns the downcasted uint8 from uint256, reverting on
2052      * overflow (when the input is greater than largest uint8).
2053      *
2054      * Counterpart to Solidity's `uint8` operator.
2055      *
2056      * Requirements:
2057      *
2058      * - input must fit into 8 bits
2059      *
2060      * _Available since v2.5._
2061      */
2062     function toUint8(uint256 value) internal pure returns (uint8) {
2063         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
2064         return uint8(value);
2065     }
2066 
2067     /**
2068      * @dev Converts a signed int256 into an unsigned uint256.
2069      *
2070      * Requirements:
2071      *
2072      * - input must be greater than or equal to 0.
2073      *
2074      * _Available since v3.0._
2075      */
2076     function toUint256(int256 value) internal pure returns (uint256) {
2077         require(value >= 0, "SafeCast: value must be positive");
2078         return uint256(value);
2079     }
2080 
2081     /**
2082      * @dev Returns the downcasted int248 from int256, reverting on
2083      * overflow (when the input is less than smallest int248 or
2084      * greater than largest int248).
2085      *
2086      * Counterpart to Solidity's `int248` operator.
2087      *
2088      * Requirements:
2089      *
2090      * - input must fit into 248 bits
2091      *
2092      * _Available since v4.7._
2093      */
2094     function toInt248(int256 value) internal pure returns (int248 downcasted) {
2095         downcasted = int248(value);
2096         require(downcasted == value, "SafeCast: value doesn't fit in 248 bits");
2097     }
2098 
2099     /**
2100      * @dev Returns the downcasted int240 from int256, reverting on
2101      * overflow (when the input is less than smallest int240 or
2102      * greater than largest int240).
2103      *
2104      * Counterpart to Solidity's `int240` operator.
2105      *
2106      * Requirements:
2107      *
2108      * - input must fit into 240 bits
2109      *
2110      * _Available since v4.7._
2111      */
2112     function toInt240(int256 value) internal pure returns (int240 downcasted) {
2113         downcasted = int240(value);
2114         require(downcasted == value, "SafeCast: value doesn't fit in 240 bits");
2115     }
2116 
2117     /**
2118      * @dev Returns the downcasted int232 from int256, reverting on
2119      * overflow (when the input is less than smallest int232 or
2120      * greater than largest int232).
2121      *
2122      * Counterpart to Solidity's `int232` operator.
2123      *
2124      * Requirements:
2125      *
2126      * - input must fit into 232 bits
2127      *
2128      * _Available since v4.7._
2129      */
2130     function toInt232(int256 value) internal pure returns (int232 downcasted) {
2131         downcasted = int232(value);
2132         require(downcasted == value, "SafeCast: value doesn't fit in 232 bits");
2133     }
2134 
2135     /**
2136      * @dev Returns the downcasted int224 from int256, reverting on
2137      * overflow (when the input is less than smallest int224 or
2138      * greater than largest int224).
2139      *
2140      * Counterpart to Solidity's `int224` operator.
2141      *
2142      * Requirements:
2143      *
2144      * - input must fit into 224 bits
2145      *
2146      * _Available since v4.7._
2147      */
2148     function toInt224(int256 value) internal pure returns (int224 downcasted) {
2149         downcasted = int224(value);
2150         require(downcasted == value, "SafeCast: value doesn't fit in 224 bits");
2151     }
2152 
2153     /**
2154      * @dev Returns the downcasted int216 from int256, reverting on
2155      * overflow (when the input is less than smallest int216 or
2156      * greater than largest int216).
2157      *
2158      * Counterpart to Solidity's `int216` operator.
2159      *
2160      * Requirements:
2161      *
2162      * - input must fit into 216 bits
2163      *
2164      * _Available since v4.7._
2165      */
2166     function toInt216(int256 value) internal pure returns (int216 downcasted) {
2167         downcasted = int216(value);
2168         require(downcasted == value, "SafeCast: value doesn't fit in 216 bits");
2169     }
2170 
2171     /**
2172      * @dev Returns the downcasted int208 from int256, reverting on
2173      * overflow (when the input is less than smallest int208 or
2174      * greater than largest int208).
2175      *
2176      * Counterpart to Solidity's `int208` operator.
2177      *
2178      * Requirements:
2179      *
2180      * - input must fit into 208 bits
2181      *
2182      * _Available since v4.7._
2183      */
2184     function toInt208(int256 value) internal pure returns (int208 downcasted) {
2185         downcasted = int208(value);
2186         require(downcasted == value, "SafeCast: value doesn't fit in 208 bits");
2187     }
2188 
2189     /**
2190      * @dev Returns the downcasted int200 from int256, reverting on
2191      * overflow (when the input is less than smallest int200 or
2192      * greater than largest int200).
2193      *
2194      * Counterpart to Solidity's `int200` operator.
2195      *
2196      * Requirements:
2197      *
2198      * - input must fit into 200 bits
2199      *
2200      * _Available since v4.7._
2201      */
2202     function toInt200(int256 value) internal pure returns (int200 downcasted) {
2203         downcasted = int200(value);
2204         require(downcasted == value, "SafeCast: value doesn't fit in 200 bits");
2205     }
2206 
2207     /**
2208      * @dev Returns the downcasted int192 from int256, reverting on
2209      * overflow (when the input is less than smallest int192 or
2210      * greater than largest int192).
2211      *
2212      * Counterpart to Solidity's `int192` operator.
2213      *
2214      * Requirements:
2215      *
2216      * - input must fit into 192 bits
2217      *
2218      * _Available since v4.7._
2219      */
2220     function toInt192(int256 value) internal pure returns (int192 downcasted) {
2221         downcasted = int192(value);
2222         require(downcasted == value, "SafeCast: value doesn't fit in 192 bits");
2223     }
2224 
2225     /**
2226      * @dev Returns the downcasted int184 from int256, reverting on
2227      * overflow (when the input is less than smallest int184 or
2228      * greater than largest int184).
2229      *
2230      * Counterpart to Solidity's `int184` operator.
2231      *
2232      * Requirements:
2233      *
2234      * - input must fit into 184 bits
2235      *
2236      * _Available since v4.7._
2237      */
2238     function toInt184(int256 value) internal pure returns (int184 downcasted) {
2239         downcasted = int184(value);
2240         require(downcasted == value, "SafeCast: value doesn't fit in 184 bits");
2241     }
2242 
2243     /**
2244      * @dev Returns the downcasted int176 from int256, reverting on
2245      * overflow (when the input is less than smallest int176 or
2246      * greater than largest int176).
2247      *
2248      * Counterpart to Solidity's `int176` operator.
2249      *
2250      * Requirements:
2251      *
2252      * - input must fit into 176 bits
2253      *
2254      * _Available since v4.7._
2255      */
2256     function toInt176(int256 value) internal pure returns (int176 downcasted) {
2257         downcasted = int176(value);
2258         require(downcasted == value, "SafeCast: value doesn't fit in 176 bits");
2259     }
2260 
2261     /**
2262      * @dev Returns the downcasted int168 from int256, reverting on
2263      * overflow (when the input is less than smallest int168 or
2264      * greater than largest int168).
2265      *
2266      * Counterpart to Solidity's `int168` operator.
2267      *
2268      * Requirements:
2269      *
2270      * - input must fit into 168 bits
2271      *
2272      * _Available since v4.7._
2273      */
2274     function toInt168(int256 value) internal pure returns (int168 downcasted) {
2275         downcasted = int168(value);
2276         require(downcasted == value, "SafeCast: value doesn't fit in 168 bits");
2277     }
2278 
2279     /**
2280      * @dev Returns the downcasted int160 from int256, reverting on
2281      * overflow (when the input is less than smallest int160 or
2282      * greater than largest int160).
2283      *
2284      * Counterpart to Solidity's `int160` operator.
2285      *
2286      * Requirements:
2287      *
2288      * - input must fit into 160 bits
2289      *
2290      * _Available since v4.7._
2291      */
2292     function toInt160(int256 value) internal pure returns (int160 downcasted) {
2293         downcasted = int160(value);
2294         require(downcasted == value, "SafeCast: value doesn't fit in 160 bits");
2295     }
2296 
2297     /**
2298      * @dev Returns the downcasted int152 from int256, reverting on
2299      * overflow (when the input is less than smallest int152 or
2300      * greater than largest int152).
2301      *
2302      * Counterpart to Solidity's `int152` operator.
2303      *
2304      * Requirements:
2305      *
2306      * - input must fit into 152 bits
2307      *
2308      * _Available since v4.7._
2309      */
2310     function toInt152(int256 value) internal pure returns (int152 downcasted) {
2311         downcasted = int152(value);
2312         require(downcasted == value, "SafeCast: value doesn't fit in 152 bits");
2313     }
2314 
2315     /**
2316      * @dev Returns the downcasted int144 from int256, reverting on
2317      * overflow (when the input is less than smallest int144 or
2318      * greater than largest int144).
2319      *
2320      * Counterpart to Solidity's `int144` operator.
2321      *
2322      * Requirements:
2323      *
2324      * - input must fit into 144 bits
2325      *
2326      * _Available since v4.7._
2327      */
2328     function toInt144(int256 value) internal pure returns (int144 downcasted) {
2329         downcasted = int144(value);
2330         require(downcasted == value, "SafeCast: value doesn't fit in 144 bits");
2331     }
2332 
2333     /**
2334      * @dev Returns the downcasted int136 from int256, reverting on
2335      * overflow (when the input is less than smallest int136 or
2336      * greater than largest int136).
2337      *
2338      * Counterpart to Solidity's `int136` operator.
2339      *
2340      * Requirements:
2341      *
2342      * - input must fit into 136 bits
2343      *
2344      * _Available since v4.7._
2345      */
2346     function toInt136(int256 value) internal pure returns (int136 downcasted) {
2347         downcasted = int136(value);
2348         require(downcasted == value, "SafeCast: value doesn't fit in 136 bits");
2349     }
2350 
2351     /**
2352      * @dev Returns the downcasted int128 from int256, reverting on
2353      * overflow (when the input is less than smallest int128 or
2354      * greater than largest int128).
2355      *
2356      * Counterpart to Solidity's `int128` operator.
2357      *
2358      * Requirements:
2359      *
2360      * - input must fit into 128 bits
2361      *
2362      * _Available since v3.1._
2363      */
2364     function toInt128(int256 value) internal pure returns (int128 downcasted) {
2365         downcasted = int128(value);
2366         require(downcasted == value, "SafeCast: value doesn't fit in 128 bits");
2367     }
2368 
2369     /**
2370      * @dev Returns the downcasted int120 from int256, reverting on
2371      * overflow (when the input is less than smallest int120 or
2372      * greater than largest int120).
2373      *
2374      * Counterpart to Solidity's `int120` operator.
2375      *
2376      * Requirements:
2377      *
2378      * - input must fit into 120 bits
2379      *
2380      * _Available since v4.7._
2381      */
2382     function toInt120(int256 value) internal pure returns (int120 downcasted) {
2383         downcasted = int120(value);
2384         require(downcasted == value, "SafeCast: value doesn't fit in 120 bits");
2385     }
2386 
2387     /**
2388      * @dev Returns the downcasted int112 from int256, reverting on
2389      * overflow (when the input is less than smallest int112 or
2390      * greater than largest int112).
2391      *
2392      * Counterpart to Solidity's `int112` operator.
2393      *
2394      * Requirements:
2395      *
2396      * - input must fit into 112 bits
2397      *
2398      * _Available since v4.7._
2399      */
2400     function toInt112(int256 value) internal pure returns (int112 downcasted) {
2401         downcasted = int112(value);
2402         require(downcasted == value, "SafeCast: value doesn't fit in 112 bits");
2403     }
2404 
2405     /**
2406      * @dev Returns the downcasted int104 from int256, reverting on
2407      * overflow (when the input is less than smallest int104 or
2408      * greater than largest int104).
2409      *
2410      * Counterpart to Solidity's `int104` operator.
2411      *
2412      * Requirements:
2413      *
2414      * - input must fit into 104 bits
2415      *
2416      * _Available since v4.7._
2417      */
2418     function toInt104(int256 value) internal pure returns (int104 downcasted) {
2419         downcasted = int104(value);
2420         require(downcasted == value, "SafeCast: value doesn't fit in 104 bits");
2421     }
2422 
2423     /**
2424      * @dev Returns the downcasted int96 from int256, reverting on
2425      * overflow (when the input is less than smallest int96 or
2426      * greater than largest int96).
2427      *
2428      * Counterpart to Solidity's `int96` operator.
2429      *
2430      * Requirements:
2431      *
2432      * - input must fit into 96 bits
2433      *
2434      * _Available since v4.7._
2435      */
2436     function toInt96(int256 value) internal pure returns (int96 downcasted) {
2437         downcasted = int96(value);
2438         require(downcasted == value, "SafeCast: value doesn't fit in 96 bits");
2439     }
2440 
2441     /**
2442      * @dev Returns the downcasted int88 from int256, reverting on
2443      * overflow (when the input is less than smallest int88 or
2444      * greater than largest int88).
2445      *
2446      * Counterpart to Solidity's `int88` operator.
2447      *
2448      * Requirements:
2449      *
2450      * - input must fit into 88 bits
2451      *
2452      * _Available since v4.7._
2453      */
2454     function toInt88(int256 value) internal pure returns (int88 downcasted) {
2455         downcasted = int88(value);
2456         require(downcasted == value, "SafeCast: value doesn't fit in 88 bits");
2457     }
2458 
2459     /**
2460      * @dev Returns the downcasted int80 from int256, reverting on
2461      * overflow (when the input is less than smallest int80 or
2462      * greater than largest int80).
2463      *
2464      * Counterpart to Solidity's `int80` operator.
2465      *
2466      * Requirements:
2467      *
2468      * - input must fit into 80 bits
2469      *
2470      * _Available since v4.7._
2471      */
2472     function toInt80(int256 value) internal pure returns (int80 downcasted) {
2473         downcasted = int80(value);
2474         require(downcasted == value, "SafeCast: value doesn't fit in 80 bits");
2475     }
2476 
2477     /**
2478      * @dev Returns the downcasted int72 from int256, reverting on
2479      * overflow (when the input is less than smallest int72 or
2480      * greater than largest int72).
2481      *
2482      * Counterpart to Solidity's `int72` operator.
2483      *
2484      * Requirements:
2485      *
2486      * - input must fit into 72 bits
2487      *
2488      * _Available since v4.7._
2489      */
2490     function toInt72(int256 value) internal pure returns (int72 downcasted) {
2491         downcasted = int72(value);
2492         require(downcasted == value, "SafeCast: value doesn't fit in 72 bits");
2493     }
2494 
2495     /**
2496      * @dev Returns the downcasted int64 from int256, reverting on
2497      * overflow (when the input is less than smallest int64 or
2498      * greater than largest int64).
2499      *
2500      * Counterpart to Solidity's `int64` operator.
2501      *
2502      * Requirements:
2503      *
2504      * - input must fit into 64 bits
2505      *
2506      * _Available since v3.1._
2507      */
2508     function toInt64(int256 value) internal pure returns (int64 downcasted) {
2509         downcasted = int64(value);
2510         require(downcasted == value, "SafeCast: value doesn't fit in 64 bits");
2511     }
2512 
2513     /**
2514      * @dev Returns the downcasted int56 from int256, reverting on
2515      * overflow (when the input is less than smallest int56 or
2516      * greater than largest int56).
2517      *
2518      * Counterpart to Solidity's `int56` operator.
2519      *
2520      * Requirements:
2521      *
2522      * - input must fit into 56 bits
2523      *
2524      * _Available since v4.7._
2525      */
2526     function toInt56(int256 value) internal pure returns (int56 downcasted) {
2527         downcasted = int56(value);
2528         require(downcasted == value, "SafeCast: value doesn't fit in 56 bits");
2529     }
2530 
2531     /**
2532      * @dev Returns the downcasted int48 from int256, reverting on
2533      * overflow (when the input is less than smallest int48 or
2534      * greater than largest int48).
2535      *
2536      * Counterpart to Solidity's `int48` operator.
2537      *
2538      * Requirements:
2539      *
2540      * - input must fit into 48 bits
2541      *
2542      * _Available since v4.7._
2543      */
2544     function toInt48(int256 value) internal pure returns (int48 downcasted) {
2545         downcasted = int48(value);
2546         require(downcasted == value, "SafeCast: value doesn't fit in 48 bits");
2547     }
2548 
2549     /**
2550      * @dev Returns the downcasted int40 from int256, reverting on
2551      * overflow (when the input is less than smallest int40 or
2552      * greater than largest int40).
2553      *
2554      * Counterpart to Solidity's `int40` operator.
2555      *
2556      * Requirements:
2557      *
2558      * - input must fit into 40 bits
2559      *
2560      * _Available since v4.7._
2561      */
2562     function toInt40(int256 value) internal pure returns (int40 downcasted) {
2563         downcasted = int40(value);
2564         require(downcasted == value, "SafeCast: value doesn't fit in 40 bits");
2565     }
2566 
2567     /**
2568      * @dev Returns the downcasted int32 from int256, reverting on
2569      * overflow (when the input is less than smallest int32 or
2570      * greater than largest int32).
2571      *
2572      * Counterpart to Solidity's `int32` operator.
2573      *
2574      * Requirements:
2575      *
2576      * - input must fit into 32 bits
2577      *
2578      * _Available since v3.1._
2579      */
2580     function toInt32(int256 value) internal pure returns (int32 downcasted) {
2581         downcasted = int32(value);
2582         require(downcasted == value, "SafeCast: value doesn't fit in 32 bits");
2583     }
2584 
2585     /**
2586      * @dev Returns the downcasted int24 from int256, reverting on
2587      * overflow (when the input is less than smallest int24 or
2588      * greater than largest int24).
2589      *
2590      * Counterpart to Solidity's `int24` operator.
2591      *
2592      * Requirements:
2593      *
2594      * - input must fit into 24 bits
2595      *
2596      * _Available since v4.7._
2597      */
2598     function toInt24(int256 value) internal pure returns (int24 downcasted) {
2599         downcasted = int24(value);
2600         require(downcasted == value, "SafeCast: value doesn't fit in 24 bits");
2601     }
2602 
2603     /**
2604      * @dev Returns the downcasted int16 from int256, reverting on
2605      * overflow (when the input is less than smallest int16 or
2606      * greater than largest int16).
2607      *
2608      * Counterpart to Solidity's `int16` operator.
2609      *
2610      * Requirements:
2611      *
2612      * - input must fit into 16 bits
2613      *
2614      * _Available since v3.1._
2615      */
2616     function toInt16(int256 value) internal pure returns (int16 downcasted) {
2617         downcasted = int16(value);
2618         require(downcasted == value, "SafeCast: value doesn't fit in 16 bits");
2619     }
2620 
2621     /**
2622      * @dev Returns the downcasted int8 from int256, reverting on
2623      * overflow (when the input is less than smallest int8 or
2624      * greater than largest int8).
2625      *
2626      * Counterpart to Solidity's `int8` operator.
2627      *
2628      * Requirements:
2629      *
2630      * - input must fit into 8 bits
2631      *
2632      * _Available since v3.1._
2633      */
2634     function toInt8(int256 value) internal pure returns (int8 downcasted) {
2635         downcasted = int8(value);
2636         require(downcasted == value, "SafeCast: value doesn't fit in 8 bits");
2637     }
2638 
2639     /**
2640      * @dev Converts an unsigned uint256 into a signed int256.
2641      *
2642      * Requirements:
2643      *
2644      * - input must be less than or equal to maxInt256.
2645      *
2646      * _Available since v3.0._
2647      */
2648     function toInt256(uint256 value) internal pure returns (int256) {
2649         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
2650         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
2651         return int256(value);
2652     }
2653 }
2654 
2655 /**
2656  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
2657  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
2658  *
2659  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
2660  *
2661  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
2662  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
2663  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
2664  *
2665  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
2666  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
2667  *
2668  * _Available since v4.2._
2669  */
2670 abstract contract ERC20Votes is IVotes, ERC20Permit {
2671     struct Checkpoint {
2672         uint32 fromBlock;
2673         uint224 votes;
2674     }
2675 
2676     bytes32 private constant _DELEGATION_TYPEHASH =
2677         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
2678 
2679     mapping(address => address) private _delegates;
2680     mapping(address => Checkpoint[]) private _checkpoints;
2681     Checkpoint[] private _totalSupplyCheckpoints;
2682 
2683     /**
2684      * @dev Get the `pos`-th checkpoint for `account`.
2685      */
2686     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
2687         return _checkpoints[account][pos];
2688     }
2689 
2690     /**
2691      * @dev Get number of checkpoints for `account`.
2692      */
2693     function numCheckpoints(address account) public view virtual returns (uint32) {
2694         return SafeCast.toUint32(_checkpoints[account].length);
2695     }
2696 
2697     /**
2698      * @dev Get the address `account` is currently delegating to.
2699      */
2700     function delegates(address account) public view virtual override returns (address) {
2701         return _delegates[account];
2702     }
2703 
2704     /**
2705      * @dev Gets the current votes balance for `account`
2706      */
2707     function getVotes(address account) public view virtual override returns (uint256) {
2708         uint256 pos = _checkpoints[account].length;
2709         unchecked {
2710             return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
2711         }
2712     }
2713 
2714     /**
2715      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
2716      *
2717      * Requirements:
2718      *
2719      * - `blockNumber` must have been already mined
2720      */
2721     function getPastVotes(address account, uint256 blockNumber) public view virtual override returns (uint256) {
2722         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
2723         return _checkpointsLookup(_checkpoints[account], blockNumber);
2724     }
2725 
2726     /**
2727      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
2728      * It is NOT the sum of all the delegated votes!
2729      *
2730      * Requirements:
2731      *
2732      * - `blockNumber` must have been already mined
2733      */
2734     function getPastTotalSupply(uint256 blockNumber) public view virtual override returns (uint256) {
2735         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
2736         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
2737     }
2738 
2739     /**
2740      * @dev Lookup a value in a list of (sorted) checkpoints.
2741      */
2742     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
2743         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
2744         //
2745         // Initially we check if the block is recent to narrow the search range.
2746         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
2747         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
2748         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
2749         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
2750         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
2751         // out of bounds (in which case we're looking too far in the past and the result is 0).
2752         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
2753         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
2754         // the same.
2755         uint256 length = ckpts.length;
2756 
2757         uint256 low = 0;
2758         uint256 high = length;
2759 
2760         if (length > 5) {
2761             uint256 mid = length - Math.sqrt(length);
2762             if (_unsafeAccess(ckpts, mid).fromBlock > blockNumber) {
2763                 high = mid;
2764             } else {
2765                 low = mid + 1;
2766             }
2767         }
2768 
2769         while (low < high) {
2770             uint256 mid = Math.average(low, high);
2771             if (_unsafeAccess(ckpts, mid).fromBlock > blockNumber) {
2772                 high = mid;
2773             } else {
2774                 low = mid + 1;
2775             }
2776         }
2777 
2778         unchecked {
2779             return high == 0 ? 0 : _unsafeAccess(ckpts, high - 1).votes;
2780         }
2781     }
2782 
2783     /**
2784      * @dev Delegate votes from the sender to `delegatee`.
2785      */
2786     function delegate(address delegatee) public virtual override {
2787         _delegate(_msgSender(), delegatee);
2788     }
2789 
2790     /**
2791      * @dev Delegates votes from signer to `delegatee`
2792      */
2793     function delegateBySig(
2794         address delegatee,
2795         uint256 nonce,
2796         uint256 expiry,
2797         uint8 v,
2798         bytes32 r,
2799         bytes32 s
2800     ) public virtual override {
2801         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
2802         address signer = ECDSA.recover(
2803             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
2804             v,
2805             r,
2806             s
2807         );
2808         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
2809         _delegate(signer, delegatee);
2810     }
2811 
2812     /**
2813      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
2814      */
2815     function _maxSupply() internal view virtual returns (uint224) {
2816         return type(uint224).max;
2817     }
2818 
2819     /**
2820      * @dev Snapshots the totalSupply after it has been increased.
2821      */
2822     function _mint(address account, uint256 amount) internal virtual override {
2823         super._mint(account, amount);
2824         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
2825 
2826         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
2827     }
2828 
2829     /**
2830      * @dev Snapshots the totalSupply after it has been decreased.
2831      */
2832     function _burn(address account, uint256 amount) internal virtual override {
2833         super._burn(account, amount);
2834 
2835         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
2836     }
2837 
2838     /**
2839      * @dev Move voting power when tokens are transferred.
2840      *
2841      * Emits a {IVotes-DelegateVotesChanged} event.
2842      */
2843     function _afterTokenTransfer(
2844         address from,
2845         address to,
2846         uint256 amount
2847     ) internal virtual override {
2848         super._afterTokenTransfer(from, to, amount);
2849 
2850         _moveVotingPower(delegates(from), delegates(to), amount);
2851     }
2852 
2853     /**
2854      * @dev Change delegation for `delegator` to `delegatee`.
2855      *
2856      * Emits events {IVotes-DelegateChanged} and {IVotes-DelegateVotesChanged}.
2857      */
2858     function _delegate(address delegator, address delegatee) internal virtual {
2859         address currentDelegate = delegates(delegator);
2860         uint256 delegatorBalance = balanceOf(delegator);
2861         _delegates[delegator] = delegatee;
2862 
2863         emit DelegateChanged(delegator, currentDelegate, delegatee);
2864 
2865         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
2866     }
2867 
2868     function _moveVotingPower(
2869         address src,
2870         address dst,
2871         uint256 amount
2872     ) private {
2873         if (src != dst && amount > 0) {
2874             if (src != address(0)) {
2875                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
2876                 emit DelegateVotesChanged(src, oldWeight, newWeight);
2877             }
2878 
2879             if (dst != address(0)) {
2880                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
2881                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
2882             }
2883         }
2884     }
2885 
2886     function _writeCheckpoint(
2887         Checkpoint[] storage ckpts,
2888         function(uint256, uint256) view returns (uint256) op,
2889         uint256 delta
2890     ) private returns (uint256 oldWeight, uint256 newWeight) {
2891         uint256 pos = ckpts.length;
2892 
2893         unchecked {
2894             Checkpoint memory oldCkpt = pos == 0 ? Checkpoint(0, 0) : _unsafeAccess(ckpts, pos - 1);
2895 
2896             oldWeight = oldCkpt.votes;
2897             newWeight = op(oldWeight, delta);
2898 
2899             if (pos > 0 && oldCkpt.fromBlock == block.number) {
2900                 _unsafeAccess(ckpts, pos - 1).votes = SafeCast.toUint224(newWeight);
2901             } else {
2902                 ckpts.push(
2903                     Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)})
2904                 );
2905             }
2906         }
2907     }
2908 
2909     function _add(uint256 a, uint256 b) private pure returns (uint256) {
2910         return a + b;
2911     }
2912 
2913     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
2914         return a - b;
2915     }
2916 
2917     function _unsafeAccess(Checkpoint[] storage ckpts, uint256 pos) private pure returns (Checkpoint storage result) {
2918         assembly {
2919             mstore(0, ckpts.slot)
2920             result.slot := add(keccak256(0, 0x20), pos)
2921         }
2922     }
2923 }
2924 
2925 /**
2926  * @dev Extension of ERC20 to support Compound's voting and delegation. This version exactly matches Compound's
2927  * interface, with the drawback of only supporting supply up to (2^96^ - 1).
2928  *
2929  * NOTE: You should use this contract if you need exact compatibility with COMP (for example in order to use your token
2930  * with Governor Alpha or Bravo) and if you are sure the supply cap of 2^96^ is enough for you. Otherwise, use the
2931  * {ERC20Votes} variant of this module.
2932  *
2933  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
2934  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
2935  * power can be queried through the public accessors {getCurrentVotes} and {getPriorVotes}.
2936  *
2937  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
2938  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
2939  *
2940  * _Available since v4.2._
2941  */
2942 abstract contract ERC20VotesComp is ERC20Votes {
2943     /**
2944      * @dev Comp version of the {getVotes} accessor, with `uint96` return type.
2945      */
2946     function getCurrentVotes(address account) external view virtual returns (uint96) {
2947         return SafeCast.toUint96(getVotes(account));
2948     }
2949 
2950     /**
2951      * @dev Comp version of the {getPastVotes} accessor, with `uint96` return type.
2952      */
2953     function getPriorVotes(address account, uint256 blockNumber) external view virtual returns (uint96) {
2954         return SafeCast.toUint96(getPastVotes(account, blockNumber));
2955     }
2956 
2957     /**
2958      * @dev Maximum token supply. Reduced to `type(uint96).max` (2^96^ - 1) to fit COMP interface.
2959      */
2960     function _maxSupply() internal view virtual override returns (uint224) {
2961         return type(uint96).max;
2962     }
2963 }
2964 
2965 interface IERC20Droppable {
2966     /// @notice When called, the token must mint some amount of new tokens
2967     /// to `recipient` based on `oldTokenAmount`, and return the amount of
2968     /// new tokens minted as `newTokenAmount`.
2969     /// It does not need to make checks about whether old tokens have been locked.
2970     /// It MUST check that the caller is indeed the Lockdrop contract.
2971     function drop(uint256 oldTokenAmount, address recipient) external returns (uint256 newTokenAmount);
2972 }
2973 
2974 /// @title Sudoswap governance token contract
2975 /// @author zefram.eth
2976 /// @notice Governance token that's compatible with Compound governor contracts.
2977 /// Supports the SUDO lockdrop.
2978 contract SudoToken is ERC20VotesComp, IERC20Droppable, Owned {
2979     /// -----------------------------------------------------------------------
2980     /// Errors
2981     /// -----------------------------------------------------------------------
2982 
2983     error SudoToken__InvalidInput();
2984     error SudoToken__TransferDisabled();
2985     error SudoToken__CallerNotLockdrop();
2986     error SudoToken__LockdropAlreadyActive();
2987 
2988     /// -----------------------------------------------------------------------
2989     /// Storage variables
2990     /// -----------------------------------------------------------------------
2991 
2992     /// @notice The lockdrop contract that can call drop()
2993     /// @dev Can only be set once
2994     address public lockdrop;
2995 
2996     /// @notice Flag for whether transfers are enabled
2997     bool public transferEnabled;
2998 
2999     /// @notice Specific addresses where transfers are enabled
3000     mapping(address => bool) public allowedFrom;
3001 
3002     /// -----------------------------------------------------------------------
3003     /// Immutable parameters
3004     /// -----------------------------------------------------------------------
3005 
3006     /// @notice Multiplier for computing how many tokens to mint in drop() based
3007     /// on the amount of oldTokens locked. Not scaled.
3008     uint256 public immutable dropMultiplier;
3009 
3010     constructor(string memory name_, string memory symbol_, address owner_, uint256 dropMultiplier_)
3011         ERC20(name_, symbol_)
3012         ERC20Permit(name_)
3013         Owned(owner_)
3014     {
3015         dropMultiplier = dropMultiplier_;
3016     }
3017 
3018     /// -----------------------------------------------------------------------
3019     /// Mint
3020     /// -----------------------------------------------------------------------
3021 
3022     /// @notice Mint the specified amount of tokens to the recipient. Only callable
3023     /// by the owner.
3024     /// @param to The token recipient
3025     /// @param amount The amount of tokens to mint
3026     function mint(address to, uint256 amount) external onlyOwner {
3027         _mint(to, amount);
3028     }
3029 
3030     /// -----------------------------------------------------------------------
3031     /// Transfer
3032     /// -----------------------------------------------------------------------
3033 
3034     /// @notice Permanently enable token transferring. Only callable by the owner.
3035     function enableTransfer() external onlyOwner {
3036         transferEnabled = true;
3037     }
3038 
3039     /// @notice Add an address to enable token transferring. Only callable by the owner.
3040     function addAllowedFrom(address a, bool isAllowed) external onlyOwner {
3041         allowedFrom[a] = isAllowed;
3042     }
3043 
3044     /// @inheritdoc ERC20
3045     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
3046         super._beforeTokenTransfer(from, to, amount);
3047 
3048         if (from != address(0) && !transferEnabled && !allowedFrom[from]) revert SudoToken__TransferDisabled();
3049     }
3050 
3051     /// -----------------------------------------------------------------------
3052     /// Lockdrop
3053     /// -----------------------------------------------------------------------
3054 
3055     /// @notice Sets the lockdrop contract address and activates it. Only callable by the owner.
3056     /// Can only be called once.
3057     /// @param lockdrop_ The lockdrop contract
3058     function activateLockdrop(address lockdrop_) external onlyOwner {
3059         /// -----------------------------------------------------------------------
3060         /// Verification
3061         /// -----------------------------------------------------------------------
3062 
3063         if (lockdrop_ == address(0)) revert SudoToken__InvalidInput();
3064         if (lockdrop != address(0)) revert SudoToken__LockdropAlreadyActive();
3065 
3066         /// -----------------------------------------------------------------------
3067         /// State updates
3068         /// -----------------------------------------------------------------------
3069 
3070         lockdrop = lockdrop_;
3071     }
3072 
3073     /// @inheritdoc IERC20Droppable
3074     function drop(uint256 oldTokenAmount, address recipient) external override returns (uint256 newTokenAmount) {
3075         /// -----------------------------------------------------------------------
3076         /// Verification
3077         /// -----------------------------------------------------------------------
3078 
3079         if (msg.sender != lockdrop) revert SudoToken__CallerNotLockdrop();
3080 
3081         /// -----------------------------------------------------------------------
3082         /// State updates
3083         /// -----------------------------------------------------------------------
3084 
3085         // mint tokens
3086         newTokenAmount = oldTokenAmount * dropMultiplier;
3087         _mint(recipient, newTokenAmount);
3088     }
3089 }