1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 
5 // ====================================================================
6 // |     ______                   _______                             |
7 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
8 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
9 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
10 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
11 // |                                                                  |
12 // ====================================================================
13 // ============================== frxETH ==============================
14 // ====================================================================
15 // Frax Finance: https://github.com/FraxFinance
16 
17 // Primary Author(s)
18 // Jack Corddry: https://github.com/corddry
19 // Nader Ghazvini: https://github.com/amirnader-ghazvini 
20 
21 // Reviewer(s) / Contributor(s)
22 // Sam Kazemian: https://github.com/samkazemian
23 // Dennis: https://github.com/denett
24 // Travis Moore: https://github.com/FortisFortuna
25 // Jamie Turley: https://github.com/jyturley
26 
27 /// @title Stablecoin pegged to Ether for use within the Frax ecosystem
28 /** @notice Does not accrue ETH 2.0 staking yield: it must be staked at the sfrxETH contract first.
29     ETH -> frxETH conversion is permanent, so a market will develop for the latter.
30     Withdraws are not live (as of deploy time) so loosely pegged to eth but is possible will float */
31 /// @dev frxETH adheres to EIP-712/EIP-2612 and can use permits
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
34 
35 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Emitted when `value` tokens are moved from one account (`from`) to
43      * another (`to`).
44      *
45      * Note that `value` may be zero.
46      */
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     /**
50      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
51      * a call to {approve}. `value` is the new allowance.
52      */
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 
55     /**
56      * @dev Returns the amount of tokens in existence.
57      */
58     function totalSupply() external view returns (uint256);
59 
60     /**
61      * @dev Returns the amount of tokens owned by `account`.
62      */
63     function balanceOf(address account) external view returns (uint256);
64 
65     /**
66      * @dev Moves `amount` tokens from the caller's account to `to`.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transfer(address to, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Returns the remaining number of tokens that `spender` will be
76      * allowed to spend on behalf of `owner` through {transferFrom}. This is
77      * zero by default.
78      *
79      * This value changes when {approve} or {transferFrom} are called.
80      */
81     function allowance(address owner, address spender) external view returns (uint256);
82 
83     /**
84      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * IMPORTANT: Beware that changing an allowance with this method brings the risk
89      * that someone may use both the old and the new allowance by unfortunate
90      * transaction ordering. One possible solution to mitigate this race
91      * condition is to first reduce the spender's allowance to 0 and set the
92      * desired value afterwards:
93      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
94      *
95      * Emits an {Approval} event.
96      */
97     function approve(address spender, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Moves `amount` tokens from `from` to `to` using the
101      * allowance mechanism. `amount` is then deducted from the caller's
102      * allowance.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transferFrom(
109         address from,
110         address to,
111         uint256 amount
112     ) external returns (bool);
113 }
114 
115 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
116 
117 /**
118  * @dev Interface for the optional metadata functions from the ERC20 standard.
119  *
120  * _Available since v4.1._
121  */
122 interface IERC20Metadata is IERC20 {
123     /**
124      * @dev Returns the name of the token.
125      */
126     function name() external view returns (string memory);
127 
128     /**
129      * @dev Returns the symbol of the token.
130      */
131     function symbol() external view returns (string memory);
132 
133     /**
134      * @dev Returns the decimals places of the token.
135      */
136     function decimals() external view returns (uint8);
137 }
138 
139 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
140 
141 /**
142  * @dev Provides information about the current execution context, including the
143  * sender of the transaction and its data. While these are generally available
144  * via msg.sender and msg.data, they should not be accessed in such a direct
145  * manner, since when dealing with meta-transactions the account sending and
146  * paying for execution may not be the actual sender (as far as an application
147  * is concerned).
148  *
149  * This contract is only required for intermediate, library-like contracts.
150  */
151 abstract contract Context {
152     function _msgSender() internal view virtual returns (address) {
153         return msg.sender;
154     }
155 
156     function _msgData() internal view virtual returns (bytes calldata) {
157         return msg.data;
158     }
159 }
160 
161 /**
162  * @dev Implementation of the {IERC20} interface.
163  *
164  * This implementation is agnostic to the way tokens are created. This means
165  * that a supply mechanism has to be added in a derived contract using {_mint}.
166  * For a generic mechanism see {ERC20PresetMinterPauser}.
167  *
168  * TIP: For a detailed writeup see our guide
169  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
170  * to implement supply mechanisms].
171  *
172  * We have followed general OpenZeppelin Contracts guidelines: functions revert
173  * instead returning `false` on failure. This behavior is nonetheless
174  * conventional and does not conflict with the expectations of ERC20
175  * applications.
176  *
177  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
178  * This allows applications to reconstruct the allowance for all accounts just
179  * by listening to said events. Other implementations of the EIP may not emit
180  * these events, as it isn't required by the specification.
181  *
182  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
183  * functions have been added to mitigate the well-known issues around setting
184  * allowances. See {IERC20-approve}.
185  */
186 contract ERC20 is Context, IERC20, IERC20Metadata {
187     mapping(address => uint256) private _balances;
188 
189     mapping(address => mapping(address => uint256)) private _allowances;
190 
191     uint256 private _totalSupply;
192 
193     string private _name;
194     string private _symbol;
195 
196     /**
197      * @dev Sets the values for {name} and {symbol}.
198      *
199      * The default value of {decimals} is 18. To select a different value for
200      * {decimals} you should overload it.
201      *
202      * All two of these values are immutable: they can only be set once during
203      * construction.
204      */
205     constructor(string memory name_, string memory symbol_) {
206         _name = name_;
207         _symbol = symbol_;
208     }
209 
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() public view virtual override returns (string memory) {
214         return _name;
215     }
216 
217     /**
218      * @dev Returns the symbol of the token, usually a shorter version of the
219      * name.
220      */
221     function symbol() public view virtual override returns (string memory) {
222         return _symbol;
223     }
224 
225     /**
226      * @dev Returns the number of decimals used to get its user representation.
227      * For example, if `decimals` equals `2`, a balance of `505` tokens should
228      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
229      *
230      * Tokens usually opt for a value of 18, imitating the relationship between
231      * Ether and Wei. This is the value {ERC20} uses, unless this function is
232      * overridden;
233      *
234      * NOTE: This information is only used for _display_ purposes: it in
235      * no way affects any of the arithmetic of the contract, including
236      * {IERC20-balanceOf} and {IERC20-transfer}.
237      */
238     function decimals() public view virtual override returns (uint8) {
239         return 18;
240     }
241 
242     /**
243      * @dev See {IERC20-totalSupply}.
244      */
245     function totalSupply() public view virtual override returns (uint256) {
246         return _totalSupply;
247     }
248 
249     /**
250      * @dev See {IERC20-balanceOf}.
251      */
252     function balanceOf(address account) public view virtual override returns (uint256) {
253         return _balances[account];
254     }
255 
256     /**
257      * @dev See {IERC20-transfer}.
258      *
259      * Requirements:
260      *
261      * - `to` cannot be the zero address.
262      * - the caller must have a balance of at least `amount`.
263      */
264     function transfer(address to, uint256 amount) public virtual override returns (bool) {
265         address owner = _msgSender();
266         _transfer(owner, to, amount);
267         return true;
268     }
269 
270     /**
271      * @dev See {IERC20-allowance}.
272      */
273     function allowance(address owner, address spender) public view virtual override returns (uint256) {
274         return _allowances[owner][spender];
275     }
276 
277     /**
278      * @dev See {IERC20-approve}.
279      *
280      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
281      * `transferFrom`. This is semantically equivalent to an infinite approval.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      */
287     function approve(address spender, uint256 amount) public virtual override returns (bool) {
288         address owner = _msgSender();
289         _approve(owner, spender, amount);
290         return true;
291     }
292 
293     /**
294      * @dev See {IERC20-transferFrom}.
295      *
296      * Emits an {Approval} event indicating the updated allowance. This is not
297      * required by the EIP. See the note at the beginning of {ERC20}.
298      *
299      * NOTE: Does not update the allowance if the current allowance
300      * is the maximum `uint256`.
301      *
302      * Requirements:
303      *
304      * - `from` and `to` cannot be the zero address.
305      * - `from` must have a balance of at least `amount`.
306      * - the caller must have allowance for ``from``'s tokens of at least
307      * `amount`.
308      */
309     function transferFrom(
310         address from,
311         address to,
312         uint256 amount
313     ) public virtual override returns (bool) {
314         address spender = _msgSender();
315         _spendAllowance(from, spender, amount);
316         _transfer(from, to, amount);
317         return true;
318     }
319 
320     /**
321      * @dev Atomically increases the allowance granted to `spender` by the caller.
322      *
323      * This is an alternative to {approve} that can be used as a mitigation for
324      * problems described in {IERC20-approve}.
325      *
326      * Emits an {Approval} event indicating the updated allowance.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      */
332     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
333         address owner = _msgSender();
334         _approve(owner, spender, allowance(owner, spender) + addedValue);
335         return true;
336     }
337 
338     /**
339      * @dev Atomically decreases the allowance granted to `spender` by the caller.
340      *
341      * This is an alternative to {approve} that can be used as a mitigation for
342      * problems described in {IERC20-approve}.
343      *
344      * Emits an {Approval} event indicating the updated allowance.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      * - `spender` must have allowance for the caller of at least
350      * `subtractedValue`.
351      */
352     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
353         address owner = _msgSender();
354         uint256 currentAllowance = allowance(owner, spender);
355         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
356         unchecked {
357             _approve(owner, spender, currentAllowance - subtractedValue);
358         }
359 
360         return true;
361     }
362 
363     /**
364      * @dev Moves `amount` of tokens from `from` to `to`.
365      *
366      * This internal function is equivalent to {transfer}, and can be used to
367      * e.g. implement automatic token fees, slashing mechanisms, etc.
368      *
369      * Emits a {Transfer} event.
370      *
371      * Requirements:
372      *
373      * - `from` cannot be the zero address.
374      * - `to` cannot be the zero address.
375      * - `from` must have a balance of at least `amount`.
376      */
377     function _transfer(
378         address from,
379         address to,
380         uint256 amount
381     ) internal virtual {
382         require(from != address(0), "ERC20: transfer from the zero address");
383         require(to != address(0), "ERC20: transfer to the zero address");
384 
385         _beforeTokenTransfer(from, to, amount);
386 
387         uint256 fromBalance = _balances[from];
388         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
389         unchecked {
390             _balances[from] = fromBalance - amount;
391             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
392             // decrementing then incrementing.
393             _balances[to] += amount;
394         }
395 
396         emit Transfer(from, to, amount);
397 
398         _afterTokenTransfer(from, to, amount);
399     }
400 
401     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
402      * the total supply.
403      *
404      * Emits a {Transfer} event with `from` set to the zero address.
405      *
406      * Requirements:
407      *
408      * - `account` cannot be the zero address.
409      */
410     function _mint(address account, uint256 amount) internal virtual {
411         require(account != address(0), "ERC20: mint to the zero address");
412 
413         _beforeTokenTransfer(address(0), account, amount);
414 
415         _totalSupply += amount;
416         unchecked {
417             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
418             _balances[account] += amount;
419         }
420         emit Transfer(address(0), account, amount);
421 
422         _afterTokenTransfer(address(0), account, amount);
423     }
424 
425     /**
426      * @dev Destroys `amount` tokens from `account`, reducing the
427      * total supply.
428      *
429      * Emits a {Transfer} event with `to` set to the zero address.
430      *
431      * Requirements:
432      *
433      * - `account` cannot be the zero address.
434      * - `account` must have at least `amount` tokens.
435      */
436     function _burn(address account, uint256 amount) internal virtual {
437         require(account != address(0), "ERC20: burn from the zero address");
438 
439         _beforeTokenTransfer(account, address(0), amount);
440 
441         uint256 accountBalance = _balances[account];
442         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
443         unchecked {
444             _balances[account] = accountBalance - amount;
445             // Overflow not possible: amount <= accountBalance <= totalSupply.
446             _totalSupply -= amount;
447         }
448 
449         emit Transfer(account, address(0), amount);
450 
451         _afterTokenTransfer(account, address(0), amount);
452     }
453 
454     /**
455      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
456      *
457      * This internal function is equivalent to `approve`, and can be used to
458      * e.g. set automatic allowances for certain subsystems, etc.
459      *
460      * Emits an {Approval} event.
461      *
462      * Requirements:
463      *
464      * - `owner` cannot be the zero address.
465      * - `spender` cannot be the zero address.
466      */
467     function _approve(
468         address owner,
469         address spender,
470         uint256 amount
471     ) internal virtual {
472         require(owner != address(0), "ERC20: approve from the zero address");
473         require(spender != address(0), "ERC20: approve to the zero address");
474 
475         _allowances[owner][spender] = amount;
476         emit Approval(owner, spender, amount);
477     }
478 
479     /**
480      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
481      *
482      * Does not update the allowance amount in case of infinite allowance.
483      * Revert if not enough allowance is available.
484      *
485      * Might emit an {Approval} event.
486      */
487     function _spendAllowance(
488         address owner,
489         address spender,
490         uint256 amount
491     ) internal virtual {
492         uint256 currentAllowance = allowance(owner, spender);
493         if (currentAllowance != type(uint256).max) {
494             require(currentAllowance >= amount, "ERC20: insufficient allowance");
495             unchecked {
496                 _approve(owner, spender, currentAllowance - amount);
497             }
498         }
499     }
500 
501     /**
502      * @dev Hook that is called before any transfer of tokens. This includes
503      * minting and burning.
504      *
505      * Calling conditions:
506      *
507      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
508      * will be transferred to `to`.
509      * - when `from` is zero, `amount` tokens will be minted for `to`.
510      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
511      * - `from` and `to` are never both zero.
512      *
513      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
514      */
515     function _beforeTokenTransfer(
516         address from,
517         address to,
518         uint256 amount
519     ) internal virtual {}
520 
521     /**
522      * @dev Hook that is called after any transfer of tokens. This includes
523      * minting and burning.
524      *
525      * Calling conditions:
526      *
527      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
528      * has been transferred to `to`.
529      * - when `from` is zero, `amount` tokens have been minted for `to`.
530      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
531      * - `from` and `to` are never both zero.
532      *
533      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
534      */
535     function _afterTokenTransfer(
536         address from,
537         address to,
538         uint256 amount
539     ) internal virtual {}
540 }
541 
542 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/extensions/draft-ERC20Permit.sol)
543 
544 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
545 
546 /**
547  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
548  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
549  *
550  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
551  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
552  * need to send a transaction, and thus is not required to hold Ether at all.
553  */
554 interface IERC20Permit {
555     /**
556      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
557      * given ``owner``'s signed approval.
558      *
559      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
560      * ordering also apply here.
561      *
562      * Emits an {Approval} event.
563      *
564      * Requirements:
565      *
566      * - `spender` cannot be the zero address.
567      * - `deadline` must be a timestamp in the future.
568      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
569      * over the EIP712-formatted function arguments.
570      * - the signature must use ``owner``'s current nonce (see {nonces}).
571      *
572      * For more information on the signature format, see the
573      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
574      * section].
575      */
576     function permit(
577         address owner,
578         address spender,
579         uint256 value,
580         uint256 deadline,
581         uint8 v,
582         bytes32 r,
583         bytes32 s
584     ) external;
585 
586     /**
587      * @dev Returns the current nonce for `owner`. This value must be
588      * included whenever a signature is generated for {permit}.
589      *
590      * Every successful call to {permit} increases ``owner``'s nonce by one. This
591      * prevents a signature from being used multiple times.
592      */
593     function nonces(address owner) external view returns (uint256);
594 
595     /**
596      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
597      */
598     // solhint-disable-next-line func-name-mixedcase
599     function DOMAIN_SEPARATOR() external view returns (bytes32);
600 }
601 
602 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
603 
604 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
605 
606 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
607 
608 /**
609  * @dev Standard math utilities missing in the Solidity language.
610  */
611 library Math {
612     enum Rounding {
613         Down, // Toward negative infinity
614         Up, // Toward infinity
615         Zero // Toward zero
616     }
617 
618     /**
619      * @dev Returns the largest of two numbers.
620      */
621     function max(uint256 a, uint256 b) internal pure returns (uint256) {
622         return a > b ? a : b;
623     }
624 
625     /**
626      * @dev Returns the smallest of two numbers.
627      */
628     function min(uint256 a, uint256 b) internal pure returns (uint256) {
629         return a < b ? a : b;
630     }
631 
632     /**
633      * @dev Returns the average of two numbers. The result is rounded towards
634      * zero.
635      */
636     function average(uint256 a, uint256 b) internal pure returns (uint256) {
637         // (a + b) / 2 can overflow.
638         return (a & b) + (a ^ b) / 2;
639     }
640 
641     /**
642      * @dev Returns the ceiling of the division of two numbers.
643      *
644      * This differs from standard division with `/` in that it rounds up instead
645      * of rounding down.
646      */
647     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
648         // (a + b - 1) / b can overflow on addition, so we distribute.
649         return a == 0 ? 0 : (a - 1) / b + 1;
650     }
651 
652     /**
653      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
654      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
655      * with further edits by Uniswap Labs also under MIT license.
656      */
657     function mulDiv(
658         uint256 x,
659         uint256 y,
660         uint256 denominator
661     ) internal pure returns (uint256 result) {
662         unchecked {
663             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
664             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
665             // variables such that product = prod1 * 2^256 + prod0.
666             uint256 prod0; // Least significant 256 bits of the product
667             uint256 prod1; // Most significant 256 bits of the product
668             assembly {
669                 let mm := mulmod(x, y, not(0))
670                 prod0 := mul(x, y)
671                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
672             }
673 
674             // Handle non-overflow cases, 256 by 256 division.
675             if (prod1 == 0) {
676                 return prod0 / denominator;
677             }
678 
679             // Make sure the result is less than 2^256. Also prevents denominator == 0.
680             require(denominator > prod1);
681 
682             ///////////////////////////////////////////////
683             // 512 by 256 division.
684             ///////////////////////////////////////////////
685 
686             // Make division exact by subtracting the remainder from [prod1 prod0].
687             uint256 remainder;
688             assembly {
689                 // Compute remainder using mulmod.
690                 remainder := mulmod(x, y, denominator)
691 
692                 // Subtract 256 bit number from 512 bit number.
693                 prod1 := sub(prod1, gt(remainder, prod0))
694                 prod0 := sub(prod0, remainder)
695             }
696 
697             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
698             // See https://cs.stackexchange.com/q/138556/92363.
699 
700             // Does not overflow because the denominator cannot be zero at this stage in the function.
701             uint256 twos = denominator & (~denominator + 1);
702             assembly {
703                 // Divide denominator by twos.
704                 denominator := div(denominator, twos)
705 
706                 // Divide [prod1 prod0] by twos.
707                 prod0 := div(prod0, twos)
708 
709                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
710                 twos := add(div(sub(0, twos), twos), 1)
711             }
712 
713             // Shift in bits from prod1 into prod0.
714             prod0 |= prod1 * twos;
715 
716             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
717             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
718             // four bits. That is, denominator * inv = 1 mod 2^4.
719             uint256 inverse = (3 * denominator) ^ 2;
720 
721             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
722             // in modular arithmetic, doubling the correct bits in each step.
723             inverse *= 2 - denominator * inverse; // inverse mod 2^8
724             inverse *= 2 - denominator * inverse; // inverse mod 2^16
725             inverse *= 2 - denominator * inverse; // inverse mod 2^32
726             inverse *= 2 - denominator * inverse; // inverse mod 2^64
727             inverse *= 2 - denominator * inverse; // inverse mod 2^128
728             inverse *= 2 - denominator * inverse; // inverse mod 2^256
729 
730             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
731             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
732             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
733             // is no longer required.
734             result = prod0 * inverse;
735             return result;
736         }
737     }
738 
739     /**
740      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
741      */
742     function mulDiv(
743         uint256 x,
744         uint256 y,
745         uint256 denominator,
746         Rounding rounding
747     ) internal pure returns (uint256) {
748         uint256 result = mulDiv(x, y, denominator);
749         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
750             result += 1;
751         }
752         return result;
753     }
754 
755     /**
756      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
757      *
758      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
759      */
760     function sqrt(uint256 a) internal pure returns (uint256) {
761         if (a == 0) {
762             return 0;
763         }
764 
765         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
766         //
767         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
768         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
769         //
770         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
771         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
772         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
773         //
774         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
775         uint256 result = 1 << (log2(a) >> 1);
776 
777         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
778         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
779         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
780         // into the expected uint128 result.
781         unchecked {
782             result = (result + a / result) >> 1;
783             result = (result + a / result) >> 1;
784             result = (result + a / result) >> 1;
785             result = (result + a / result) >> 1;
786             result = (result + a / result) >> 1;
787             result = (result + a / result) >> 1;
788             result = (result + a / result) >> 1;
789             return min(result, a / result);
790         }
791     }
792 
793     /**
794      * @notice Calculates sqrt(a), following the selected rounding direction.
795      */
796     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
797         unchecked {
798             uint256 result = sqrt(a);
799             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
800         }
801     }
802 
803     /**
804      * @dev Return the log in base 2, rounded down, of a positive value.
805      * Returns 0 if given 0.
806      */
807     function log2(uint256 value) internal pure returns (uint256) {
808         uint256 result = 0;
809         unchecked {
810             if (value >> 128 > 0) {
811                 value >>= 128;
812                 result += 128;
813             }
814             if (value >> 64 > 0) {
815                 value >>= 64;
816                 result += 64;
817             }
818             if (value >> 32 > 0) {
819                 value >>= 32;
820                 result += 32;
821             }
822             if (value >> 16 > 0) {
823                 value >>= 16;
824                 result += 16;
825             }
826             if (value >> 8 > 0) {
827                 value >>= 8;
828                 result += 8;
829             }
830             if (value >> 4 > 0) {
831                 value >>= 4;
832                 result += 4;
833             }
834             if (value >> 2 > 0) {
835                 value >>= 2;
836                 result += 2;
837             }
838             if (value >> 1 > 0) {
839                 result += 1;
840             }
841         }
842         return result;
843     }
844 
845     /**
846      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
847      * Returns 0 if given 0.
848      */
849     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
850         unchecked {
851             uint256 result = log2(value);
852             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
853         }
854     }
855 
856     /**
857      * @dev Return the log in base 10, rounded down, of a positive value.
858      * Returns 0 if given 0.
859      */
860     function log10(uint256 value) internal pure returns (uint256) {
861         uint256 result = 0;
862         unchecked {
863             if (value >= 10**64) {
864                 value /= 10**64;
865                 result += 64;
866             }
867             if (value >= 10**32) {
868                 value /= 10**32;
869                 result += 32;
870             }
871             if (value >= 10**16) {
872                 value /= 10**16;
873                 result += 16;
874             }
875             if (value >= 10**8) {
876                 value /= 10**8;
877                 result += 8;
878             }
879             if (value >= 10**4) {
880                 value /= 10**4;
881                 result += 4;
882             }
883             if (value >= 10**2) {
884                 value /= 10**2;
885                 result += 2;
886             }
887             if (value >= 10**1) {
888                 result += 1;
889             }
890         }
891         return result;
892     }
893 
894     /**
895      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
896      * Returns 0 if given 0.
897      */
898     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
899         unchecked {
900             uint256 result = log10(value);
901             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
902         }
903     }
904 
905     /**
906      * @dev Return the log in base 256, rounded down, of a positive value.
907      * Returns 0 if given 0.
908      *
909      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
910      */
911     function log256(uint256 value) internal pure returns (uint256) {
912         uint256 result = 0;
913         unchecked {
914             if (value >> 128 > 0) {
915                 value >>= 128;
916                 result += 16;
917             }
918             if (value >> 64 > 0) {
919                 value >>= 64;
920                 result += 8;
921             }
922             if (value >> 32 > 0) {
923                 value >>= 32;
924                 result += 4;
925             }
926             if (value >> 16 > 0) {
927                 value >>= 16;
928                 result += 2;
929             }
930             if (value >> 8 > 0) {
931                 result += 1;
932             }
933         }
934         return result;
935     }
936 
937     /**
938      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
939      * Returns 0 if given 0.
940      */
941     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
942         unchecked {
943             uint256 result = log256(value);
944             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
945         }
946     }
947 }
948 
949 /**
950  * @dev String operations.
951  */
952 library Strings {
953     bytes16 private constant _SYMBOLS = "0123456789abcdef";
954     uint8 private constant _ADDRESS_LENGTH = 20;
955 
956     /**
957      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
958      */
959     function toString(uint256 value) internal pure returns (string memory) {
960         unchecked {
961             uint256 length = Math.log10(value) + 1;
962             string memory buffer = new string(length);
963             uint256 ptr;
964             /// @solidity memory-safe-assembly
965             assembly {
966                 ptr := add(buffer, add(32, length))
967             }
968             while (true) {
969                 ptr--;
970                 /// @solidity memory-safe-assembly
971                 assembly {
972                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
973                 }
974                 value /= 10;
975                 if (value == 0) break;
976             }
977             return buffer;
978         }
979     }
980 
981     /**
982      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
983      */
984     function toHexString(uint256 value) internal pure returns (string memory) {
985         unchecked {
986             return toHexString(value, Math.log256(value) + 1);
987         }
988     }
989 
990     /**
991      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
992      */
993     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
994         bytes memory buffer = new bytes(2 * length + 2);
995         buffer[0] = "0";
996         buffer[1] = "x";
997         for (uint256 i = 2 * length + 1; i > 1; --i) {
998             buffer[i] = _SYMBOLS[value & 0xf];
999             value >>= 4;
1000         }
1001         require(value == 0, "Strings: hex length insufficient");
1002         return string(buffer);
1003     }
1004 
1005     /**
1006      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1007      */
1008     function toHexString(address addr) internal pure returns (string memory) {
1009         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1010     }
1011 }
1012 
1013 /**
1014  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1015  *
1016  * These functions can be used to verify that a message was signed by the holder
1017  * of the private keys of a given address.
1018  */
1019 library ECDSA {
1020     enum RecoverError {
1021         NoError,
1022         InvalidSignature,
1023         InvalidSignatureLength,
1024         InvalidSignatureS,
1025         InvalidSignatureV // Deprecated in v4.8
1026     }
1027 
1028     function _throwError(RecoverError error) private pure {
1029         if (error == RecoverError.NoError) {
1030             return; // no error: do nothing
1031         } else if (error == RecoverError.InvalidSignature) {
1032             revert("ECDSA: invalid signature");
1033         } else if (error == RecoverError.InvalidSignatureLength) {
1034             revert("ECDSA: invalid signature length");
1035         } else if (error == RecoverError.InvalidSignatureS) {
1036             revert("ECDSA: invalid signature 's' value");
1037         }
1038     }
1039 
1040     /**
1041      * @dev Returns the address that signed a hashed message (`hash`) with
1042      * `signature` or error string. This address can then be used for verification purposes.
1043      *
1044      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1045      * this function rejects them by requiring the `s` value to be in the lower
1046      * half order, and the `v` value to be either 27 or 28.
1047      *
1048      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1049      * verification to be secure: it is possible to craft signatures that
1050      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1051      * this is by receiving a hash of the original message (which may otherwise
1052      * be too long), and then calling {toEthSignedMessageHash} on it.
1053      *
1054      * Documentation for signature generation:
1055      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1056      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1057      *
1058      * _Available since v4.3._
1059      */
1060     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1061         if (signature.length == 65) {
1062             bytes32 r;
1063             bytes32 s;
1064             uint8 v;
1065             // ecrecover takes the signature parameters, and the only way to get them
1066             // currently is to use assembly.
1067             /// @solidity memory-safe-assembly
1068             assembly {
1069                 r := mload(add(signature, 0x20))
1070                 s := mload(add(signature, 0x40))
1071                 v := byte(0, mload(add(signature, 0x60)))
1072             }
1073             return tryRecover(hash, v, r, s);
1074         } else {
1075             return (address(0), RecoverError.InvalidSignatureLength);
1076         }
1077     }
1078 
1079     /**
1080      * @dev Returns the address that signed a hashed message (`hash`) with
1081      * `signature`. This address can then be used for verification purposes.
1082      *
1083      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1084      * this function rejects them by requiring the `s` value to be in the lower
1085      * half order, and the `v` value to be either 27 or 28.
1086      *
1087      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1088      * verification to be secure: it is possible to craft signatures that
1089      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1090      * this is by receiving a hash of the original message (which may otherwise
1091      * be too long), and then calling {toEthSignedMessageHash} on it.
1092      */
1093     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1094         (address recovered, RecoverError error) = tryRecover(hash, signature);
1095         _throwError(error);
1096         return recovered;
1097     }
1098 
1099     /**
1100      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1101      *
1102      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1103      *
1104      * _Available since v4.3._
1105      */
1106     function tryRecover(
1107         bytes32 hash,
1108         bytes32 r,
1109         bytes32 vs
1110     ) internal pure returns (address, RecoverError) {
1111         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1112         uint8 v = uint8((uint256(vs) >> 255) + 27);
1113         return tryRecover(hash, v, r, s);
1114     }
1115 
1116     /**
1117      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1118      *
1119      * _Available since v4.2._
1120      */
1121     function recover(
1122         bytes32 hash,
1123         bytes32 r,
1124         bytes32 vs
1125     ) internal pure returns (address) {
1126         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1127         _throwError(error);
1128         return recovered;
1129     }
1130 
1131     /**
1132      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1133      * `r` and `s` signature fields separately.
1134      *
1135      * _Available since v4.3._
1136      */
1137     function tryRecover(
1138         bytes32 hash,
1139         uint8 v,
1140         bytes32 r,
1141         bytes32 s
1142     ) internal pure returns (address, RecoverError) {
1143         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1144         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1145         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1146         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1147         //
1148         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1149         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1150         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1151         // these malleable signatures as well.
1152         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1153             return (address(0), RecoverError.InvalidSignatureS);
1154         }
1155 
1156         // If the signature is valid (and not malleable), return the signer address
1157         address signer = ecrecover(hash, v, r, s);
1158         if (signer == address(0)) {
1159             return (address(0), RecoverError.InvalidSignature);
1160         }
1161 
1162         return (signer, RecoverError.NoError);
1163     }
1164 
1165     /**
1166      * @dev Overload of {ECDSA-recover} that receives the `v`,
1167      * `r` and `s` signature fields separately.
1168      */
1169     function recover(
1170         bytes32 hash,
1171         uint8 v,
1172         bytes32 r,
1173         bytes32 s
1174     ) internal pure returns (address) {
1175         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1176         _throwError(error);
1177         return recovered;
1178     }
1179 
1180     /**
1181      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1182      * produces hash corresponding to the one signed with the
1183      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1184      * JSON-RPC method as part of EIP-191.
1185      *
1186      * See {recover}.
1187      */
1188     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1189         // 32 is the length in bytes of hash,
1190         // enforced by the type signature above
1191         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1192     }
1193 
1194     /**
1195      * @dev Returns an Ethereum Signed Message, created from `s`. This
1196      * produces hash corresponding to the one signed with the
1197      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1198      * JSON-RPC method as part of EIP-191.
1199      *
1200      * See {recover}.
1201      */
1202     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1203         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1204     }
1205 
1206     /**
1207      * @dev Returns an Ethereum Signed Typed Data, created from a
1208      * `domainSeparator` and a `structHash`. This produces hash corresponding
1209      * to the one signed with the
1210      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1211      * JSON-RPC method as part of EIP-712.
1212      *
1213      * See {recover}.
1214      */
1215     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1216         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1217     }
1218 }
1219 
1220 /**
1221  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1222  *
1223  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1224  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1225  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1226  *
1227  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1228  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1229  * ({_hashTypedDataV4}).
1230  *
1231  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1232  * the chain id to protect against replay attacks on an eventual fork of the chain.
1233  *
1234  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1235  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1236  *
1237  * _Available since v3.4._
1238  */
1239 abstract contract EIP712 {
1240     /* solhint-disable var-name-mixedcase */
1241     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1242     // invalidate the cached domain separator if the chain id changes.
1243     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1244     uint256 private immutable _CACHED_CHAIN_ID;
1245     address private immutable _CACHED_THIS;
1246 
1247     bytes32 private immutable _HASHED_NAME;
1248     bytes32 private immutable _HASHED_VERSION;
1249     bytes32 private immutable _TYPE_HASH;
1250 
1251     /* solhint-enable var-name-mixedcase */
1252 
1253     /**
1254      * @dev Initializes the domain separator and parameter caches.
1255      *
1256      * The meaning of `name` and `version` is specified in
1257      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1258      *
1259      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1260      * - `version`: the current major version of the signing domain.
1261      *
1262      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1263      * contract upgrade].
1264      */
1265     constructor(string memory name, string memory version) {
1266         bytes32 hashedName = keccak256(bytes(name));
1267         bytes32 hashedVersion = keccak256(bytes(version));
1268         bytes32 typeHash = keccak256(
1269             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1270         );
1271         _HASHED_NAME = hashedName;
1272         _HASHED_VERSION = hashedVersion;
1273         _CACHED_CHAIN_ID = block.chainid;
1274         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1275         _CACHED_THIS = address(this);
1276         _TYPE_HASH = typeHash;
1277     }
1278 
1279     /**
1280      * @dev Returns the domain separator for the current chain.
1281      */
1282     function _domainSeparatorV4() internal view returns (bytes32) {
1283         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1284             return _CACHED_DOMAIN_SEPARATOR;
1285         } else {
1286             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1287         }
1288     }
1289 
1290     function _buildDomainSeparator(
1291         bytes32 typeHash,
1292         bytes32 nameHash,
1293         bytes32 versionHash
1294     ) private view returns (bytes32) {
1295         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1296     }
1297 
1298     /**
1299      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1300      * function returns the hash of the fully encoded EIP712 message for this domain.
1301      *
1302      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1303      *
1304      * ```solidity
1305      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1306      *     keccak256("Mail(address to,string contents)"),
1307      *     mailTo,
1308      *     keccak256(bytes(mailContents))
1309      * )));
1310      * address signer = ECDSA.recover(digest, signature);
1311      * ```
1312      */
1313     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1314         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1315     }
1316 }
1317 
1318 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1319 
1320 /**
1321  * @title Counters
1322  * @author Matt Condon (@shrugs)
1323  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1324  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1325  *
1326  * Include with `using Counters for Counters.Counter;`
1327  */
1328 library Counters {
1329     struct Counter {
1330         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1331         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1332         // this feature: see https://github.com/ethereum/solidity/issues/4637
1333         uint256 _value; // default: 0
1334     }
1335 
1336     function current(Counter storage counter) internal view returns (uint256) {
1337         return counter._value;
1338     }
1339 
1340     function increment(Counter storage counter) internal {
1341         unchecked {
1342             counter._value += 1;
1343         }
1344     }
1345 
1346     function decrement(Counter storage counter) internal {
1347         uint256 value = counter._value;
1348         require(value > 0, "Counter: decrement overflow");
1349         unchecked {
1350             counter._value = value - 1;
1351         }
1352     }
1353 
1354     function reset(Counter storage counter) internal {
1355         counter._value = 0;
1356     }
1357 }
1358 
1359 /**
1360  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1361  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1362  *
1363  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1364  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1365  * need to send a transaction, and thus is not required to hold Ether at all.
1366  *
1367  * _Available since v3.4._
1368  */
1369 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1370     using Counters for Counters.Counter;
1371 
1372     mapping(address => Counters.Counter) private _nonces;
1373 
1374     // solhint-disable-next-line var-name-mixedcase
1375     bytes32 private constant _PERMIT_TYPEHASH =
1376         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1377     /**
1378      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
1379      * However, to ensure consistency with the upgradeable transpiler, we will continue
1380      * to reserve a slot.
1381      * @custom:oz-renamed-from _PERMIT_TYPEHASH
1382      */
1383     // solhint-disable-next-line var-name-mixedcase
1384     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
1385 
1386     /**
1387      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1388      *
1389      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1390      */
1391     constructor(string memory name) EIP712(name, "1") {}
1392 
1393     /**
1394      * @dev See {IERC20Permit-permit}.
1395      */
1396     function permit(
1397         address owner,
1398         address spender,
1399         uint256 value,
1400         uint256 deadline,
1401         uint8 v,
1402         bytes32 r,
1403         bytes32 s
1404     ) public virtual override {
1405         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1406 
1407         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1408 
1409         bytes32 hash = _hashTypedDataV4(structHash);
1410 
1411         address signer = ECDSA.recover(hash, v, r, s);
1412         require(signer == owner, "ERC20Permit: invalid signature");
1413 
1414         _approve(owner, spender, value);
1415     }
1416 
1417     /**
1418      * @dev See {IERC20Permit-nonces}.
1419      */
1420     function nonces(address owner) public view virtual override returns (uint256) {
1421         return _nonces[owner].current();
1422     }
1423 
1424     /**
1425      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1426      */
1427     // solhint-disable-next-line func-name-mixedcase
1428     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1429         return _domainSeparatorV4();
1430     }
1431 
1432     /**
1433      * @dev "Consume a nonce": return the current value and increment.
1434      *
1435      * _Available since v4.1._
1436      */
1437     function _useNonce(address owner) internal virtual returns (uint256 current) {
1438         Counters.Counter storage nonce = _nonces[owner];
1439         current = nonce.current();
1440         nonce.increment();
1441     }
1442 }
1443 
1444 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1445 
1446 /**
1447  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1448  * tokens and those that they have an allowance for, in a way that can be
1449  * recognized off-chain (via event analysis).
1450  */
1451 abstract contract ERC20Burnable is Context, ERC20 {
1452     /**
1453      * @dev Destroys `amount` tokens from the caller.
1454      *
1455      * See {ERC20-_burn}.
1456      */
1457     function burn(uint256 amount) public virtual {
1458         _burn(_msgSender(), amount);
1459     }
1460 
1461     /**
1462      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1463      * allowance.
1464      *
1465      * See {ERC20-_burn} and {ERC20-allowance}.
1466      *
1467      * Requirements:
1468      *
1469      * - the caller must have allowance for ``accounts``'s tokens of at least
1470      * `amount`.
1471      */
1472     function burnFrom(address account, uint256 amount) public virtual {
1473         _spendAllowance(account, _msgSender(), amount);
1474         _burn(account, amount);
1475     }
1476 }
1477 
1478 // https://docs.synthetix.io/contracts/Owned
1479 // NO NEED TO AUDIT
1480 contract Owned {
1481     address public owner;
1482     address public nominatedOwner;
1483 
1484     constructor (address _owner) {
1485         require(_owner != address(0), "Owner address cannot be 0");
1486         owner = _owner;
1487         emit OwnerChanged(address(0), _owner);
1488     }
1489 
1490     function nominateNewOwner(address _owner) external onlyOwner {
1491         nominatedOwner = _owner;
1492         emit OwnerNominated(_owner);
1493     }
1494 
1495     function acceptOwnership() external {
1496         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
1497         emit OwnerChanged(owner, nominatedOwner);
1498         owner = nominatedOwner;
1499         nominatedOwner = address(0);
1500     }
1501 
1502     modifier onlyOwner {
1503         require(msg.sender == owner, "Only the contract owner may perform this action");
1504         _;
1505     }
1506 
1507     event OwnerNominated(address newOwner);
1508     event OwnerChanged(address oldOwner, address newOwner);
1509 }
1510 
1511 /// @title Parent contract for frxETH.sol
1512 /** @notice Combines Openzeppelin's ERC20Permit and ERC20Burnable with Synthetix's Owned. 
1513     Also includes a list of authorized minters */
1514 /// @dev frxETH adheres to EIP-712/EIP-2612 and can use permits
1515 contract ERC20PermitPermissionedMint is ERC20Permit, ERC20Burnable, Owned {
1516     // Core
1517     address public timelock_address;
1518 
1519     // Minters
1520     address[] public minters_array; // Allowed to mint
1521     mapping(address => bool) public minters; // Mapping is also used for faster verification
1522 
1523     /* ========== CONSTRUCTOR ========== */
1524 
1525     constructor(
1526         address _creator_address,
1527         address _timelock_address,
1528         string memory _name,
1529         string memory _symbol
1530     ) 
1531     ERC20(_name, _symbol)
1532     ERC20Permit(_name) 
1533     Owned(_creator_address)
1534     {
1535       timelock_address = _timelock_address;
1536     }
1537 
1538     /* ========== MODIFIERS ========== */
1539 
1540     modifier onlyByOwnGov() {
1541         require(msg.sender == timelock_address || msg.sender == owner, "Not owner or timelock");
1542         _;
1543     }
1544 
1545     modifier onlyMinters() {
1546        require(minters[msg.sender] == true, "Only minters");
1547         _;
1548     } 
1549 
1550     /* ========== RESTRICTED FUNCTIONS ========== */
1551 
1552     // Used by minters when user redeems
1553     function minter_burn_from(address b_address, uint256 b_amount) public onlyMinters {
1554         super.burnFrom(b_address, b_amount);
1555         emit TokenMinterBurned(b_address, msg.sender, b_amount);
1556     }
1557 
1558     // This function is what other minters will call to mint new tokens 
1559     function minter_mint(address m_address, uint256 m_amount) public onlyMinters {
1560         super._mint(m_address, m_amount);
1561         emit TokenMinterMinted(msg.sender, m_address, m_amount);
1562     }
1563 
1564     // Adds whitelisted minters 
1565     function addMinter(address minter_address) public onlyByOwnGov {
1566         require(minter_address != address(0), "Zero address detected");
1567 
1568         require(minters[minter_address] == false, "Address already exists");
1569         minters[minter_address] = true; 
1570         minters_array.push(minter_address);
1571 
1572         emit MinterAdded(minter_address);
1573     }
1574 
1575     // Remove a minter 
1576     function removeMinter(address minter_address) public onlyByOwnGov {
1577         require(minter_address != address(0), "Zero address detected");
1578         require(minters[minter_address] == true, "Address nonexistant");
1579         
1580         // Delete from the mapping
1581         delete minters[minter_address];
1582 
1583         // 'Delete' from the array by setting the address to 0x0
1584         for (uint i = 0; i < minters_array.length; i++){ 
1585             if (minters_array[i] == minter_address) {
1586                 minters_array[i] = address(0); // This will leave a null in the array and keep the indices the same
1587                 break;
1588             }
1589         }
1590 
1591         emit MinterRemoved(minter_address);
1592     }
1593 
1594     function setTimelock(address _timelock_address) public onlyByOwnGov {
1595         require(_timelock_address != address(0), "Zero address detected"); 
1596         timelock_address = _timelock_address;
1597         emit TimelockChanged(_timelock_address);
1598     }
1599 
1600     /* ========== EVENTS ========== */
1601     
1602     event TokenMinterBurned(address indexed from, address indexed to, uint256 amount);
1603     event TokenMinterMinted(address indexed from, address indexed to, uint256 amount);
1604     event MinterAdded(address minter_address);
1605     event MinterRemoved(address minter_address);
1606     event TimelockChanged(address timelock_address);
1607 }
1608 
1609 contract frxETH is ERC20PermitPermissionedMint {
1610 
1611     /* ========== CONSTRUCTOR ========== */
1612     constructor(
1613       address _creator_address,
1614       address _timelock_address
1615     ) 
1616     ERC20PermitPermissionedMint(_creator_address, _timelock_address, "Frax Ether", "frxETH") 
1617     {}
1618 
1619 }