1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  *
93  * _Available since v4.1._
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 // File: @openzeppelin/contracts/utils/Context.sol
113 
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         return msg.data;
134     }
135 }
136 
137 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
138 
139 
140 pragma solidity ^0.8.0;
141 
142 
143 
144 /**
145  * @dev Implementation of the {IERC20} interface.
146  *
147  * This implementation is agnostic to the way tokens are created. This means
148  * that a supply mechanism has to be added in a derived contract using {_mint}.
149  * For a generic mechanism see {ERC20PresetMinterPauser}.
150  *
151  * TIP: For a detailed writeup see our guide
152  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
153  * to implement supply mechanisms].
154  *
155  * We have followed general OpenZeppelin Contracts guidelines: functions revert
156  * instead returning `false` on failure. This behavior is nonetheless
157  * conventional and does not conflict with the expectations of ERC20
158  * applications.
159  *
160  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
161  * This allows applications to reconstruct the allowance for all accounts just
162  * by listening to said events. Other implementations of the EIP may not emit
163  * these events, as it isn't required by the specification.
164  *
165  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
166  * functions have been added to mitigate the well-known issues around setting
167  * allowances. See {IERC20-approve}.
168  */
169 contract ERC20 is Context, IERC20, IERC20Metadata {
170     mapping(address => uint256) private _balances;
171 
172     mapping(address => mapping(address => uint256)) private _allowances;
173 
174     uint256 private _totalSupply;
175 
176     string private _name;
177     string private _symbol;
178 
179     /**
180      * @dev Sets the values for {name} and {symbol}.
181      *
182      * The default value of {decimals} is 18. To select a different value for
183      * {decimals} you should overload it.
184      *
185      * All two of these values are immutable: they can only be set once during
186      * construction.
187      */
188     constructor(string memory name_, string memory symbol_) {
189         _name = name_;
190         _symbol = symbol_;
191     }
192 
193     /**
194      * @dev Returns the name of the token.
195      */
196     function name() public view virtual override returns (string memory) {
197         return _name;
198     }
199 
200     /**
201      * @dev Returns the symbol of the token, usually a shorter version of the
202      * name.
203      */
204     function symbol() public view virtual override returns (string memory) {
205         return _symbol;
206     }
207 
208     /**
209      * @dev Returns the number of decimals used to get its user representation.
210      * For example, if `decimals` equals `2`, a balance of `505` tokens should
211      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
212      *
213      * Tokens usually opt for a value of 18, imitating the relationship between
214      * Ether and Wei. This is the value {ERC20} uses, unless this function is
215      * overridden;
216      *
217      * NOTE: This information is only used for _display_ purposes: it in
218      * no way affects any of the arithmetic of the contract, including
219      * {IERC20-balanceOf} and {IERC20-transfer}.
220      */
221     function decimals() public view virtual override returns (uint8) {
222         return 18;
223     }
224 
225     /**
226      * @dev See {IERC20-totalSupply}.
227      */
228     function totalSupply() public view virtual override returns (uint256) {
229         return _totalSupply;
230     }
231 
232     /**
233      * @dev See {IERC20-balanceOf}.
234      */
235     function balanceOf(address account) public view virtual override returns (uint256) {
236         return _balances[account];
237     }
238 
239     /**
240      * @dev See {IERC20-transfer}.
241      *
242      * Requirements:
243      *
244      * - `to` cannot be the zero address.
245      * - the caller must have a balance of at least `amount`.
246      */
247     function transfer(address to, uint256 amount) public virtual override returns (bool) {
248         address owner = _msgSender();
249         _transfer(owner, to, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender) public view virtual override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See {IERC20-approve}.
262      *
263      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
264      * `transferFrom`. This is semantically equivalent to an infinite approval.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function approve(address spender, uint256 amount) public virtual override returns (bool) {
271         address owner = _msgSender();
272         _approve(owner, spender, amount);
273         return true;
274     }
275 
276     /**
277      * @dev See {IERC20-transferFrom}.
278      *
279      * Emits an {Approval} event indicating the updated allowance. This is not
280      * required by the EIP. See the note at the beginning of {ERC20}.
281      *
282      * NOTE: Does not update the allowance if the current allowance
283      * is the maximum `uint256`.
284      *
285      * Requirements:
286      *
287      * - `from` and `to` cannot be the zero address.
288      * - `from` must have a balance of at least `amount`.
289      * - the caller must have allowance for ``from``'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(
293         address from,
294         address to,
295         uint256 amount
296     ) public virtual override returns (bool) {
297         address spender = _msgSender();
298         _spendAllowance(from, spender, amount);
299         _transfer(from, to, amount);
300         return true;
301     }
302 
303     /**
304      * @dev Atomically increases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to {approve} that can be used as a mitigation for
307      * problems described in {IERC20-approve}.
308      *
309      * Emits an {Approval} event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
316         address owner = _msgSender();
317         _approve(owner, spender, allowance(owner, spender) + addedValue);
318         return true;
319     }
320 
321     /**
322      * @dev Atomically decreases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      * - `spender` must have allowance for the caller of at least
333      * `subtractedValue`.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         address owner = _msgSender();
337         uint256 currentAllowance = allowance(owner, spender);
338         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
339         unchecked {
340             _approve(owner, spender, currentAllowance - subtractedValue);
341         }
342 
343         return true;
344     }
345 
346     /**
347      * @dev Moves `amount` of tokens from `from` to `to`.
348      *
349      * This internal function is equivalent to {transfer}, and can be used to
350      * e.g. implement automatic token fees, slashing mechanisms, etc.
351      *
352      * Emits a {Transfer} event.
353      *
354      * Requirements:
355      *
356      * - `from` cannot be the zero address.
357      * - `to` cannot be the zero address.
358      * - `from` must have a balance of at least `amount`.
359      */
360     function _transfer(
361         address from,
362         address to,
363         uint256 amount
364     ) internal virtual {
365         require(from != address(0), "ERC20: transfer from the zero address");
366         require(to != address(0), "ERC20: transfer to the zero address");
367 
368         _beforeTokenTransfer(from, to, amount);
369 
370         uint256 fromBalance = _balances[from];
371         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
372         unchecked {
373             _balances[from] = fromBalance - amount;
374         }
375         _balances[to] += amount;
376 
377         emit Transfer(from, to, amount);
378 
379         _afterTokenTransfer(from, to, amount);
380     }
381 
382     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
383      * the total supply.
384      *
385      * Emits a {Transfer} event with `from` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      */
391     function _mint(address account, uint256 amount) internal virtual {
392         require(account != address(0), "ERC20: mint to the zero address");
393 
394         _beforeTokenTransfer(address(0), account, amount);
395 
396         _totalSupply += amount;
397         _balances[account] += amount;
398         emit Transfer(address(0), account, amount);
399 
400         _afterTokenTransfer(address(0), account, amount);
401     }
402 
403     /**
404      * @dev Destroys `amount` tokens from `account`, reducing the
405      * total supply.
406      *
407      * Emits a {Transfer} event with `to` set to the zero address.
408      *
409      * Requirements:
410      *
411      * - `account` cannot be the zero address.
412      * - `account` must have at least `amount` tokens.
413      */
414     function _burn(address account, uint256 amount) internal virtual {
415         require(account != address(0), "ERC20: burn from the zero address");
416 
417         _beforeTokenTransfer(account, address(0), amount);
418 
419         uint256 accountBalance = _balances[account];
420         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
421         unchecked {
422             _balances[account] = accountBalance - amount;
423         }
424         _totalSupply -= amount;
425 
426         emit Transfer(account, address(0), amount);
427 
428         _afterTokenTransfer(account, address(0), amount);
429     }
430 
431     /**
432      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
433      *
434      * This internal function is equivalent to `approve`, and can be used to
435      * e.g. set automatic allowances for certain subsystems, etc.
436      *
437      * Emits an {Approval} event.
438      *
439      * Requirements:
440      *
441      * - `owner` cannot be the zero address.
442      * - `spender` cannot be the zero address.
443      */
444     function _approve(
445         address owner,
446         address spender,
447         uint256 amount
448     ) internal virtual {
449         require(owner != address(0), "ERC20: approve from the zero address");
450         require(spender != address(0), "ERC20: approve to the zero address");
451 
452         _allowances[owner][spender] = amount;
453         emit Approval(owner, spender, amount);
454     }
455 
456     /**
457      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
458      *
459      * Does not update the allowance amount in case of infinite allowance.
460      * Revert if not enough allowance is available.
461      *
462      * Might emit an {Approval} event.
463      */
464     function _spendAllowance(
465         address owner,
466         address spender,
467         uint256 amount
468     ) internal virtual {
469         uint256 currentAllowance = allowance(owner, spender);
470         if (currentAllowance != type(uint256).max) {
471             require(currentAllowance >= amount, "ERC20: insufficient allowance");
472             unchecked {
473                 _approve(owner, spender, currentAllowance - amount);
474             }
475         }
476     }
477 
478     /**
479      * @dev Hook that is called before any transfer of tokens. This includes
480      * minting and burning.
481      *
482      * Calling conditions:
483      *
484      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
485      * will be transferred to `to`.
486      * - when `from` is zero, `amount` tokens will be minted for `to`.
487      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
488      * - `from` and `to` are never both zero.
489      *
490      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
491      */
492     function _beforeTokenTransfer(
493         address from,
494         address to,
495         uint256 amount
496     ) internal virtual {}
497 
498     /**
499      * @dev Hook that is called after any transfer of tokens. This includes
500      * minting and burning.
501      *
502      * Calling conditions:
503      *
504      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
505      * has been transferred to `to`.
506      * - when `from` is zero, `amount` tokens have been minted for `to`.
507      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
508      * - `from` and `to` are never both zero.
509      *
510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
511      */
512     function _afterTokenTransfer(
513         address from,
514         address to,
515         uint256 amount
516     ) internal virtual {}
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
520 
521 
522 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 
527 /**
528  * @dev Extension of {ERC20} that allows token holders to destroy both their own
529  * tokens and those that they have an allowance for, in a way that can be
530  * recognized off-chain (via event analysis).
531  */
532 abstract contract ERC20Burnable is Context, ERC20 {
533     /**
534      * @dev Destroys `amount` tokens from the caller.
535      *
536      * See {ERC20-_burn}.
537      */
538     function burn(uint256 amount) public virtual {
539         _burn(_msgSender(), amount);
540     }
541 
542     /**
543      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
544      * allowance.
545      *
546      * See {ERC20-_burn} and {ERC20-allowance}.
547      *
548      * Requirements:
549      *
550      * - the caller must have allowance for ``accounts``'s tokens of at least
551      * `amount`.
552      */
553     function burnFrom(address account, uint256 amount) public virtual {
554         _spendAllowance(account, _msgSender(), amount);
555         _burn(account, amount);
556     }
557 }
558 
559 // File: @openzeppelin/contracts/utils/math/Math.sol
560 
561 
562 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Standard math utilities missing in the Solidity language.
568  */
569 library Math {
570     enum Rounding {
571         Down, // Toward negative infinity
572         Up, // Toward infinity
573         Zero // Toward zero
574     }
575 
576     /**
577      * @dev Returns the largest of two numbers.
578      */
579     function max(uint256 a, uint256 b) internal pure returns (uint256) {
580         return a >= b ? a : b;
581     }
582 
583     /**
584      * @dev Returns the smallest of two numbers.
585      */
586     function min(uint256 a, uint256 b) internal pure returns (uint256) {
587         return a < b ? a : b;
588     }
589 
590     /**
591      * @dev Returns the average of two numbers. The result is rounded towards
592      * zero.
593      */
594     function average(uint256 a, uint256 b) internal pure returns (uint256) {
595         // (a + b) / 2 can overflow.
596         return (a & b) + (a ^ b) / 2;
597     }
598 
599     /**
600      * @dev Returns the ceiling of the division of two numbers.
601      *
602      * This differs from standard division with `/` in that it rounds up instead
603      * of rounding down.
604      */
605     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
606         // (a + b - 1) / b can overflow on addition, so we distribute.
607         return a == 0 ? 0 : (a - 1) / b + 1;
608     }
609 
610     /**
611      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
612      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
613      * with further edits by Uniswap Labs also under MIT license.
614      */
615     function mulDiv(
616         uint256 x,
617         uint256 y,
618         uint256 denominator
619     ) internal pure returns (uint256 result) {
620         unchecked {
621             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
622             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
623             // variables such that product = prod1 * 2^256 + prod0.
624             uint256 prod0; // Least significant 256 bits of the product
625             uint256 prod1; // Most significant 256 bits of the product
626             assembly {
627                 let mm := mulmod(x, y, not(0))
628                 prod0 := mul(x, y)
629                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
630             }
631 
632             // Handle non-overflow cases, 256 by 256 division.
633             if (prod1 == 0) {
634                 return prod0 / denominator;
635             }
636 
637             // Make sure the result is less than 2^256. Also prevents denominator == 0.
638             require(denominator > prod1);
639 
640             ///////////////////////////////////////////////
641             // 512 by 256 division.
642             ///////////////////////////////////////////////
643 
644             // Make division exact by subtracting the remainder from [prod1 prod0].
645             uint256 remainder;
646             assembly {
647                 // Compute remainder using mulmod.
648                 remainder := mulmod(x, y, denominator)
649 
650                 // Subtract 256 bit number from 512 bit number.
651                 prod1 := sub(prod1, gt(remainder, prod0))
652                 prod0 := sub(prod0, remainder)
653             }
654 
655             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
656             // See https://cs.stackexchange.com/q/138556/92363.
657 
658             // Does not overflow because the denominator cannot be zero at this stage in the function.
659             uint256 twos = denominator & (~denominator + 1);
660             assembly {
661                 // Divide denominator by twos.
662                 denominator := div(denominator, twos)
663 
664                 // Divide [prod1 prod0] by twos.
665                 prod0 := div(prod0, twos)
666 
667                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
668                 twos := add(div(sub(0, twos), twos), 1)
669             }
670 
671             // Shift in bits from prod1 into prod0.
672             prod0 |= prod1 * twos;
673 
674             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
675             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
676             // four bits. That is, denominator * inv = 1 mod 2^4.
677             uint256 inverse = (3 * denominator) ^ 2;
678 
679             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
680             // in modular arithmetic, doubling the correct bits in each step.
681             inverse *= 2 - denominator * inverse; // inverse mod 2^8
682             inverse *= 2 - denominator * inverse; // inverse mod 2^16
683             inverse *= 2 - denominator * inverse; // inverse mod 2^32
684             inverse *= 2 - denominator * inverse; // inverse mod 2^64
685             inverse *= 2 - denominator * inverse; // inverse mod 2^128
686             inverse *= 2 - denominator * inverse; // inverse mod 2^256
687 
688             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
689             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
690             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
691             // is no longer required.
692             result = prod0 * inverse;
693             return result;
694         }
695     }
696 
697     /**
698      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
699      */
700     function mulDiv(
701         uint256 x,
702         uint256 y,
703         uint256 denominator,
704         Rounding rounding
705     ) internal pure returns (uint256) {
706         uint256 result = mulDiv(x, y, denominator);
707         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
708             result += 1;
709         }
710         return result;
711     }
712 
713     /**
714      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
715      *
716      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
717      */
718     function sqrt(uint256 a) internal pure returns (uint256) {
719         if (a == 0) {
720             return 0;
721         }
722 
723         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
724         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
725         // `msb(a) <= a < 2*msb(a)`.
726         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
727         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
728         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
729         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
730         uint256 result = 1;
731         uint256 x = a;
732         if (x >> 128 > 0) {
733             x >>= 128;
734             result <<= 64;
735         }
736         if (x >> 64 > 0) {
737             x >>= 64;
738             result <<= 32;
739         }
740         if (x >> 32 > 0) {
741             x >>= 32;
742             result <<= 16;
743         }
744         if (x >> 16 > 0) {
745             x >>= 16;
746             result <<= 8;
747         }
748         if (x >> 8 > 0) {
749             x >>= 8;
750             result <<= 4;
751         }
752         if (x >> 4 > 0) {
753             x >>= 4;
754             result <<= 2;
755         }
756         if (x >> 2 > 0) {
757             result <<= 1;
758         }
759 
760         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
761         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
762         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
763         // into the expected uint128 result.
764         unchecked {
765             result = (result + a / result) >> 1;
766             result = (result + a / result) >> 1;
767             result = (result + a / result) >> 1;
768             result = (result + a / result) >> 1;
769             result = (result + a / result) >> 1;
770             result = (result + a / result) >> 1;
771             result = (result + a / result) >> 1;
772             return min(result, a / result);
773         }
774     }
775 
776     /**
777      * @notice Calculates sqrt(a), following the selected rounding direction.
778      */
779     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
780         uint256 result = sqrt(a);
781         if (rounding == Rounding.Up && result * result < a) {
782             result += 1;
783         }
784         return result;
785     }
786 }
787 
788 // File: @openzeppelin/contracts/utils/Arrays.sol
789 
790 
791 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
792 
793 pragma solidity ^0.8.0;
794 
795 /**
796  * @dev Collection of functions related to array types.
797  */
798 library Arrays {
799     /**
800      * @dev Searches a sorted `array` and returns the first index that contains
801      * a value greater or equal to `element`. If no such index exists (i.e. all
802      * values in the array are strictly less than `element`), the array length is
803      * returned. Time complexity O(log n).
804      *
805      * `array` is expected to be sorted in ascending order, and to contain no
806      * repeated elements.
807      */
808     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
809         if (array.length == 0) {
810             return 0;
811         }
812 
813         uint256 low = 0;
814         uint256 high = array.length;
815 
816         while (low < high) {
817             uint256 mid = Math.average(low, high);
818 
819             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
820             // because Math.average rounds down (it does integer division with truncation).
821             if (array[mid] > element) {
822                 high = mid;
823             } else {
824                 low = mid + 1;
825             }
826         }
827 
828         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
829         if (low > 0 && array[low - 1] == element) {
830             return low - 1;
831         } else {
832             return low;
833         }
834     }
835 }
836 
837 // File: @openzeppelin/contracts/utils/Counters.sol
838 
839 
840 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
841 
842 pragma solidity ^0.8.0;
843 
844 /**
845  * @title Counters
846  * @author Matt Condon (@shrugs)
847  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
848  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
849  *
850  * Include with `using Counters for Counters.Counter;`
851  */
852 library Counters {
853     struct Counter {
854         // This variable should never be directly accessed by users of the library: interactions must be restricted to
855         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
856         // this feature: see https://github.com/ethereum/solidity/issues/4637
857         uint256 _value; // default: 0
858     }
859 
860     function current(Counter storage counter) internal view returns (uint256) {
861         return counter._value;
862     }
863 
864     function increment(Counter storage counter) internal {
865         unchecked {
866             counter._value += 1;
867         }
868     }
869 
870     function decrement(Counter storage counter) internal {
871         uint256 value = counter._value;
872         require(value > 0, "Counter: decrement overflow");
873         unchecked {
874             counter._value = value - 1;
875         }
876     }
877 
878     function reset(Counter storage counter) internal {
879         counter._value = 0;
880     }
881 }
882 
883 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol
884 
885 
886 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/extensions/ERC20Snapshot.sol)
887 
888 pragma solidity ^0.8.0;
889 
890 
891 
892 /**
893  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
894  * total supply at the time are recorded for later access.
895  *
896  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
897  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
898  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
899  * used to create an efficient ERC20 forking mechanism.
900  *
901  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
902  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
903  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
904  * and the account address.
905  *
906  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
907  * return `block.number` will trigger the creation of snapshot at the beginning of each new block. When overriding this
908  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
909  *
910  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
911  * alternative consider {ERC20Votes}.
912  *
913  * ==== Gas Costs
914  *
915  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
916  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
917  * smaller since identical balances in subsequent snapshots are stored as a single entry.
918  *
919  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
920  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
921  * transfers will have normal cost until the next snapshot, and so on.
922  */
923 
924 abstract contract ERC20Snapshot is ERC20 {
925     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
926     // https://github.com/Giveth/minime/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
927 
928     using Arrays for uint256[];
929     using Counters for Counters.Counter;
930 
931     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
932     // Snapshot struct, but that would impede usage of functions that work on an array.
933     struct Snapshots {
934         uint256[] ids;
935         uint256[] values;
936     }
937 
938     mapping(address => Snapshots) private _accountBalanceSnapshots;
939     Snapshots private _totalSupplySnapshots;
940 
941     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
942     Counters.Counter private _currentSnapshotId;
943 
944     /**
945      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
946      */
947     event Snapshot(uint256 id);
948 
949     /**
950      * @dev Creates a new snapshot and returns its snapshot id.
951      *
952      * Emits a {Snapshot} event that contains the same id.
953      *
954      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
955      * set of accounts, for example using {AccessControl}, or it may be open to the public.
956      *
957      * [WARNING]
958      * ====
959      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
960      * you must consider that it can potentially be used by attackers in two ways.
961      *
962      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
963      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
964      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
965      * section above.
966      *
967      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
968      * ====
969      */
970     function _snapshot() internal virtual returns (uint256) {
971         _currentSnapshotId.increment();
972 
973         uint256 currentId = _getCurrentSnapshotId();
974         emit Snapshot(currentId);
975         return currentId;
976     }
977 
978     /**
979      * @dev Get the current snapshotId
980      */
981     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
982         return _currentSnapshotId.current();
983     }
984 
985     /**
986      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
987      */
988     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
989         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
990 
991         return snapshotted ? value : balanceOf(account);
992     }
993 
994     /**
995      * @dev Retrieves the total supply at the time `snapshotId` was created.
996      */
997     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
998         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
999 
1000         return snapshotted ? value : totalSupply();
1001     }
1002 
1003     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1004     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1005     function _beforeTokenTransfer(
1006         address from,
1007         address to,
1008         uint256 amount
1009     ) internal virtual override {
1010         super._beforeTokenTransfer(from, to, amount);
1011 
1012         if (from == address(0)) {
1013             // mint
1014             _updateAccountSnapshot(to);
1015             _updateTotalSupplySnapshot();
1016         } else if (to == address(0)) {
1017             // burn
1018             _updateAccountSnapshot(from);
1019             _updateTotalSupplySnapshot();
1020         } else {
1021             // transfer
1022             _updateAccountSnapshot(from);
1023             _updateAccountSnapshot(to);
1024         }
1025     }
1026 
1027     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
1028         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1029         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
1030 
1031         // When a valid snapshot is queried, there are three possibilities:
1032         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1033         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1034         //  to this id is the current one.
1035         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1036         //  requested id, and its value is the one to return.
1037         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1038         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1039         //  larger than the requested one.
1040         //
1041         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1042         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1043         // exactly this.
1044 
1045         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1046 
1047         if (index == snapshots.ids.length) {
1048             return (false, 0);
1049         } else {
1050             return (true, snapshots.values[index]);
1051         }
1052     }
1053 
1054     function _updateAccountSnapshot(address account) private {
1055         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1056     }
1057 
1058     function _updateTotalSupplySnapshot() private {
1059         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1060     }
1061 
1062     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1063         uint256 currentId = _getCurrentSnapshotId();
1064         if (_lastSnapshotId(snapshots.ids) < currentId) {
1065             snapshots.ids.push(currentId);
1066             snapshots.values.push(currentValue);
1067         }
1068     }
1069 
1070     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1071         if (ids.length == 0) {
1072             return 0;
1073         } else {
1074             return ids[ids.length - 1];
1075         }
1076     }
1077 }
1078 
1079 // File: @openzeppelin/contracts/access/IAccessControl.sol
1080 
1081 
1082 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1083 
1084 pragma solidity ^0.8.0;
1085 
1086 /**
1087  * @dev External interface of AccessControl declared to support ERC165 detection.
1088  */
1089 interface IAccessControl {
1090     /**
1091      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1092      *
1093      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1094      * {RoleAdminChanged} not being emitted signaling this.
1095      *
1096      * _Available since v3.1._
1097      */
1098     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1099 
1100     /**
1101      * @dev Emitted when `account` is granted `role`.
1102      *
1103      * `sender` is the account that originated the contract call, an admin role
1104      * bearer except when using {AccessControl-_setupRole}.
1105      */
1106     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1107 
1108     /**
1109      * @dev Emitted when `account` is revoked `role`.
1110      *
1111      * `sender` is the account that originated the contract call:
1112      *   - if using `revokeRole`, it is the admin role bearer
1113      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1114      */
1115     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1116 
1117     /**
1118      * @dev Returns `true` if `account` has been granted `role`.
1119      */
1120     function hasRole(bytes32 role, address account) external view returns (bool);
1121 
1122     /**
1123      * @dev Returns the admin role that controls `role`. See {grantRole} and
1124      * {revokeRole}.
1125      *
1126      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1127      */
1128     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1129 
1130     /**
1131      * @dev Grants `role` to `account`.
1132      *
1133      * If `account` had not been already granted `role`, emits a {RoleGranted}
1134      * event.
1135      *
1136      * Requirements:
1137      *
1138      * - the caller must have ``role``'s admin role.
1139      */
1140     function grantRole(bytes32 role, address account) external;
1141 
1142     /**
1143      * @dev Revokes `role` from `account`.
1144      *
1145      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1146      *
1147      * Requirements:
1148      *
1149      * - the caller must have ``role``'s admin role.
1150      */
1151     function revokeRole(bytes32 role, address account) external;
1152 
1153     /**
1154      * @dev Revokes `role` from the calling account.
1155      *
1156      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1157      * purpose is to provide a mechanism for accounts to lose their privileges
1158      * if they are compromised (such as when a trusted device is misplaced).
1159      *
1160      * If the calling account had been granted `role`, emits a {RoleRevoked}
1161      * event.
1162      *
1163      * Requirements:
1164      *
1165      * - the caller must be `account`.
1166      */
1167     function renounceRole(bytes32 role, address account) external;
1168 }
1169 
1170 // File: @openzeppelin/contracts/utils/Strings.sol
1171 
1172 
1173 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 /**
1178  * @dev String operations.
1179  */
1180 library Strings {
1181     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1182     uint8 private constant _ADDRESS_LENGTH = 20;
1183 
1184     /**
1185      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1186      */
1187     function toString(uint256 value) internal pure returns (string memory) {
1188         // Inspired by OraclizeAPI's implementation - MIT licence
1189         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1190 
1191         if (value == 0) {
1192             return "0";
1193         }
1194         uint256 temp = value;
1195         uint256 digits;
1196         while (temp != 0) {
1197             digits++;
1198             temp /= 10;
1199         }
1200         bytes memory buffer = new bytes(digits);
1201         while (value != 0) {
1202             digits -= 1;
1203             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1204             value /= 10;
1205         }
1206         return string(buffer);
1207     }
1208 
1209     /**
1210      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1211      */
1212     function toHexString(uint256 value) internal pure returns (string memory) {
1213         if (value == 0) {
1214             return "0x00";
1215         }
1216         uint256 temp = value;
1217         uint256 length = 0;
1218         while (temp != 0) {
1219             length++;
1220             temp >>= 8;
1221         }
1222         return toHexString(value, length);
1223     }
1224 
1225     /**
1226      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1227      */
1228     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1229         bytes memory buffer = new bytes(2 * length + 2);
1230         buffer[0] = "0";
1231         buffer[1] = "x";
1232         for (uint256 i = 2 * length + 1; i > 1; --i) {
1233             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1234             value >>= 4;
1235         }
1236         require(value == 0, "Strings: hex length insufficient");
1237         return string(buffer);
1238     }
1239 
1240     /**
1241      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1242      */
1243     function toHexString(address addr) internal pure returns (string memory) {
1244         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1245     }
1246 }
1247 
1248 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1249 
1250 
1251 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1252 
1253 pragma solidity ^0.8.0;
1254 
1255 /**
1256  * @dev Interface of the ERC165 standard, as defined in the
1257  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1258  *
1259  * Implementers can declare support of contract interfaces, which can then be
1260  * queried by others ({ERC165Checker}).
1261  *
1262  * For an implementation, see {ERC165}.
1263  */
1264 interface IERC165 {
1265     /**
1266      * @dev Returns true if this contract implements the interface defined by
1267      * `interfaceId`. See the corresponding
1268      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1269      * to learn more about how these ids are created.
1270      *
1271      * This function call must use less than 30 000 gas.
1272      */
1273     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1274 }
1275 
1276 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1277 
1278 
1279 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1280 
1281 pragma solidity ^0.8.0;
1282 
1283 /**
1284  * @dev Implementation of the {IERC165} interface.
1285  *
1286  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1287  * for the additional interface id that will be supported. For example:
1288  *
1289  * ```solidity
1290  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1291  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1292  * }
1293  * ```
1294  *
1295  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1296  */
1297 abstract contract ERC165 is IERC165 {
1298     /**
1299      * @dev See {IERC165-supportsInterface}.
1300      */
1301     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1302         return interfaceId == type(IERC165).interfaceId;
1303     }
1304 }
1305 
1306 // File: @openzeppelin/contracts/access/AccessControl.sol
1307 
1308 
1309 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1310 
1311 pragma solidity ^0.8.0;
1312 
1313 
1314 
1315 
1316 /**
1317  * @dev Contract module that allows children to implement role-based access
1318  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1319  * members except through off-chain means by accessing the contract event logs. Some
1320  * applications may benefit from on-chain enumerability, for those cases see
1321  * {AccessControlEnumerable}.
1322  *
1323  * Roles are referred to by their `bytes32` identifier. These should be exposed
1324  * in the external API and be unique. The best way to achieve this is by
1325  * using `public constant` hash digests:
1326  *
1327  * ```
1328  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1329  * ```
1330  *
1331  * Roles can be used to represent a set of permissions. To restrict access to a
1332  * function call, use {hasRole}:
1333  *
1334  * ```
1335  * function foo() public {
1336  *     require(hasRole(MY_ROLE, msg.sender));
1337  *     ...
1338  * }
1339  * ```
1340  *
1341  * Roles can be granted and revoked dynamically via the {grantRole} and
1342  * {revokeRole} functions. Each role has an associated admin role, and only
1343  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1344  *
1345  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1346  * that only accounts with this role will be able to grant or revoke other
1347  * roles. More complex role relationships can be created by using
1348  * {_setRoleAdmin}.
1349  *
1350  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1351  * grant and revoke this role. Extra precautions should be taken to secure
1352  * accounts that have been granted it.
1353  */
1354 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1355     struct RoleData {
1356         mapping(address => bool) members;
1357         bytes32 adminRole;
1358     }
1359 
1360     mapping(bytes32 => RoleData) private _roles;
1361 
1362     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1363 
1364     /**
1365      * @dev Modifier that checks that an account has a specific role. Reverts
1366      * with a standardized message including the required role.
1367      *
1368      * The format of the revert reason is given by the following regular expression:
1369      *
1370      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1371      *
1372      * _Available since v4.1._
1373      */
1374     modifier onlyRole(bytes32 role) {
1375         _checkRole(role);
1376         _;
1377     }
1378 
1379     /**
1380      * @dev See {IERC165-supportsInterface}.
1381      */
1382     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1383         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1384     }
1385 
1386     /**
1387      * @dev Returns `true` if `account` has been granted `role`.
1388      */
1389     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1390         return _roles[role].members[account];
1391     }
1392 
1393     /**
1394      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1395      * Overriding this function changes the behavior of the {onlyRole} modifier.
1396      *
1397      * Format of the revert message is described in {_checkRole}.
1398      *
1399      * _Available since v4.6._
1400      */
1401     function _checkRole(bytes32 role) internal view virtual {
1402         _checkRole(role, _msgSender());
1403     }
1404 
1405     /**
1406      * @dev Revert with a standard message if `account` is missing `role`.
1407      *
1408      * The format of the revert reason is given by the following regular expression:
1409      *
1410      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1411      */
1412     function _checkRole(bytes32 role, address account) internal view virtual {
1413         if (!hasRole(role, account)) {
1414             revert(
1415                 string(
1416                     abi.encodePacked(
1417                         "AccessControl: account ",
1418                         Strings.toHexString(uint160(account), 20),
1419                         " is missing role ",
1420                         Strings.toHexString(uint256(role), 32)
1421                     )
1422                 )
1423             );
1424         }
1425     }
1426 
1427     /**
1428      * @dev Returns the admin role that controls `role`. See {grantRole} and
1429      * {revokeRole}.
1430      *
1431      * To change a role's admin, use {_setRoleAdmin}.
1432      */
1433     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1434         return _roles[role].adminRole;
1435     }
1436 
1437     /**
1438      * @dev Grants `role` to `account`.
1439      *
1440      * If `account` had not been already granted `role`, emits a {RoleGranted}
1441      * event.
1442      *
1443      * Requirements:
1444      *
1445      * - the caller must have ``role``'s admin role.
1446      *
1447      * May emit a {RoleGranted} event.
1448      */
1449     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1450         _grantRole(role, account);
1451     }
1452 
1453     /**
1454      * @dev Revokes `role` from `account`.
1455      *
1456      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1457      *
1458      * Requirements:
1459      *
1460      * - the caller must have ``role``'s admin role.
1461      *
1462      * May emit a {RoleRevoked} event.
1463      */
1464     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1465         _revokeRole(role, account);
1466     }
1467 
1468     /**
1469      * @dev Revokes `role` from the calling account.
1470      *
1471      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1472      * purpose is to provide a mechanism for accounts to lose their privileges
1473      * if they are compromised (such as when a trusted device is misplaced).
1474      *
1475      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1476      * event.
1477      *
1478      * Requirements:
1479      *
1480      * - the caller must be `account`.
1481      *
1482      * May emit a {RoleRevoked} event.
1483      */
1484     function renounceRole(bytes32 role, address account) public virtual override {
1485         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1486 
1487         _revokeRole(role, account);
1488     }
1489 
1490     /**
1491      * @dev Grants `role` to `account`.
1492      *
1493      * If `account` had not been already granted `role`, emits a {RoleGranted}
1494      * event. Note that unlike {grantRole}, this function doesn't perform any
1495      * checks on the calling account.
1496      *
1497      * May emit a {RoleGranted} event.
1498      *
1499      * [WARNING]
1500      * ====
1501      * This function should only be called from the constructor when setting
1502      * up the initial roles for the system.
1503      *
1504      * Using this function in any other way is effectively circumventing the admin
1505      * system imposed by {AccessControl}.
1506      * ====
1507      *
1508      * NOTE: This function is deprecated in favor of {_grantRole}.
1509      */
1510     function _setupRole(bytes32 role, address account) internal virtual {
1511         _grantRole(role, account);
1512     }
1513 
1514     /**
1515      * @dev Sets `adminRole` as ``role``'s admin role.
1516      *
1517      * Emits a {RoleAdminChanged} event.
1518      */
1519     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1520         bytes32 previousAdminRole = getRoleAdmin(role);
1521         _roles[role].adminRole = adminRole;
1522         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1523     }
1524 
1525     /**
1526      * @dev Grants `role` to `account`.
1527      *
1528      * Internal function without access restriction.
1529      *
1530      * May emit a {RoleGranted} event.
1531      */
1532     function _grantRole(bytes32 role, address account) internal virtual {
1533         if (!hasRole(role, account)) {
1534             _roles[role].members[account] = true;
1535             emit RoleGranted(role, account, _msgSender());
1536         }
1537     }
1538 
1539     /**
1540      * @dev Revokes `role` from `account`.
1541      *
1542      * Internal function without access restriction.
1543      *
1544      * May emit a {RoleRevoked} event.
1545      */
1546     function _revokeRole(bytes32 role, address account) internal virtual {
1547         if (hasRole(role, account)) {
1548             _roles[role].members[account] = false;
1549             emit RoleRevoked(role, account, _msgSender());
1550         }
1551     }
1552 }
1553 
1554 // File: @openzeppelin/contracts/security/Pausable.sol
1555 
1556 
1557 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1558 
1559 pragma solidity ^0.8.0;
1560 
1561 /**
1562  * @dev Contract module which allows children to implement an emergency stop
1563  * mechanism that can be triggered by an authorized account.
1564  *
1565  * This module is used through inheritance. It will make available the
1566  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1567  * the functions of your contract. Note that they will not be pausable by
1568  * simply including this module, only once the modifiers are put in place.
1569  */
1570 abstract contract Pausable is Context {
1571     /**
1572      * @dev Emitted when the pause is triggered by `account`.
1573      */
1574     event Paused(address account);
1575 
1576     /**
1577      * @dev Emitted when the pause is lifted by `account`.
1578      */
1579     event Unpaused(address account);
1580 
1581     bool private _paused;
1582 
1583     /**
1584      * @dev Initializes the contract in unpaused state.
1585      */
1586     constructor() {
1587         _paused = false;
1588     }
1589 
1590     /**
1591      * @dev Modifier to make a function callable only when the contract is not paused.
1592      *
1593      * Requirements:
1594      *
1595      * - The contract must not be paused.
1596      */
1597     modifier whenNotPaused() {
1598         _requireNotPaused();
1599         _;
1600     }
1601 
1602     /**
1603      * @dev Modifier to make a function callable only when the contract is paused.
1604      *
1605      * Requirements:
1606      *
1607      * - The contract must be paused.
1608      */
1609     modifier whenPaused() {
1610         _requirePaused();
1611         _;
1612     }
1613 
1614     /**
1615      * @dev Returns true if the contract is paused, and false otherwise.
1616      */
1617     function paused() public view virtual returns (bool) {
1618         return _paused;
1619     }
1620 
1621     /**
1622      * @dev Throws if the contract is paused.
1623      */
1624     function _requireNotPaused() internal view virtual {
1625         require(!paused(), "Pausable: paused");
1626     }
1627 
1628     /**
1629      * @dev Throws if the contract is not paused.
1630      */
1631     function _requirePaused() internal view virtual {
1632         require(paused(), "Pausable: not paused");
1633     }
1634 
1635     /**
1636      * @dev Triggers stopped state.
1637      *
1638      * Requirements:
1639      *
1640      * - The contract must not be paused.
1641      */
1642     function _pause() internal virtual whenNotPaused {
1643         _paused = true;
1644         emit Paused(_msgSender());
1645     }
1646 
1647     /**
1648      * @dev Returns to normal state.
1649      *
1650      * Requirements:
1651      *
1652      * - The contract must be paused.
1653      */
1654     function _unpause() internal virtual whenPaused {
1655         _paused = false;
1656         emit Unpaused(_msgSender());
1657     }
1658 }
1659 
1660 // File: @openzeppelin/contracts/access/Ownable.sol
1661 
1662 
1663 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1664 
1665 pragma solidity ^0.8.0;
1666 
1667 /**
1668  * @dev Contract module which provides a basic access control mechanism, where
1669  * there is an account (an owner) that can be granted exclusive access to
1670  * specific functions.
1671  *
1672  * By default, the owner account will be the one that deploys the contract. This
1673  * can later be changed with {transferOwnership}.
1674  *
1675  * This module is used through inheritance. It will make available the modifier
1676  * `onlyOwner`, which can be applied to your functions to restrict their use to
1677  * the owner.
1678  */
1679 abstract contract Ownable is Context {
1680     address private _owner;
1681 
1682     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1683 
1684     /**
1685      * @dev Initializes the contract setting the deployer as the initial owner.
1686      */
1687     constructor() {
1688         _transferOwnership(_msgSender());
1689     }
1690 
1691     /**
1692      * @dev Throws if called by any account other than the owner.
1693      */
1694     modifier onlyOwner() {
1695         _checkOwner();
1696         _;
1697     }
1698 
1699     /**
1700      * @dev Returns the address of the current owner.
1701      */
1702     function owner() public view virtual returns (address) {
1703         return _owner;
1704     }
1705 
1706     /**
1707      * @dev Throws if the sender is not the owner.
1708      */
1709     function _checkOwner() internal view virtual {
1710         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1711     }
1712 
1713     /**
1714      * @dev Leaves the contract without owner. It will not be possible to call
1715      * `onlyOwner` functions anymore. Can only be called by the current owner.
1716      *
1717      * NOTE: Renouncing ownership will leave the contract without an owner,
1718      * thereby removing any functionality that is only available to the owner.
1719      */
1720     function renounceOwnership() public virtual onlyOwner {
1721         _transferOwnership(address(0));
1722     }
1723 
1724     /**
1725      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1726      * Can only be called by the current owner.
1727      */
1728     function transferOwnership(address newOwner) public virtual onlyOwner {
1729         require(newOwner != address(0), "Ownable: new owner is the zero address");
1730         _transferOwnership(newOwner);
1731     }
1732 
1733     /**
1734      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1735      * Internal function without access restriction.
1736      */
1737     function _transferOwnership(address newOwner) internal virtual {
1738         address oldOwner = _owner;
1739         _owner = newOwner;
1740         emit OwnershipTransferred(oldOwner, newOwner);
1741     }
1742 }
1743 
1744 // File: contracts/Moa.sol
1745 
1746 
1747 pragma solidity ^0.8.4;
1748 
1749 
1750 
1751 
1752 
1753 
1754 contract Moa is ERC20, ERC20Burnable, ERC20Snapshot, AccessControl, Pausable, Ownable {
1755     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1756     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1757     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1758 
1759     constructor(
1760         string memory _name,
1761         string memory _symbol,
1762         address _owner,
1763         uint256 _supply
1764     )
1765     ERC20(_name, _symbol) {
1766         _grantRole(DEFAULT_ADMIN_ROLE, _owner);
1767         _grantRole(MINTER_ROLE, _owner);
1768         _grantRole(SNAPSHOT_ROLE, _owner);
1769         _grantRole(PAUSER_ROLE, _owner);
1770         
1771 
1772         _mint(_owner, _supply);
1773     }
1774 
1775 
1776     function snapshot() public onlyRole(SNAPSHOT_ROLE) {
1777         _snapshot();
1778     }
1779     function pause() public onlyRole(PAUSER_ROLE) {
1780         _pause();
1781     }
1782     function unpause() public onlyRole(PAUSER_ROLE) {
1783         _unpause();
1784     }
1785     function _beforeTokenTransfer(address from, address to, uint256 amount)
1786         internal
1787         whenNotPaused
1788         override(ERC20, ERC20Snapshot)
1789     {
1790         super._beforeTokenTransfer(from, to, amount);
1791     }
1792 
1793 
1794     // ** onlyOwner **
1795     function grantRoleSnapshot(address user) public onlyOwner {
1796         _grantRole(SNAPSHOT_ROLE, user);
1797     }
1798     function revokeRoleSnapshot(address user) public onlyOwner {
1799         _revokeRole(SNAPSHOT_ROLE, user);
1800     }
1801     function grantRolePauser(address user) public onlyOwner {
1802         _grantRole(PAUSER_ROLE, user);
1803     }
1804     function revokeRolePauser(address user) public onlyOwner {
1805         _revokeRole(PAUSER_ROLE, user);
1806     }
1807 }