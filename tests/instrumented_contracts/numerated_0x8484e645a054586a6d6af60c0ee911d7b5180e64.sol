1 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.3
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
86 
87 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.3
88 
89 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 
116 // File @openzeppelin/contracts/utils/Context.sol@v4.8.3
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 
143 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.3
144 
145 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 
150 
151 /**
152  * @dev Implementation of the {IERC20} interface.
153  *
154  * This implementation is agnostic to the way tokens are created. This means
155  * that a supply mechanism has to be added in a derived contract using {_mint}.
156  * For a generic mechanism see {ERC20PresetMinterPauser}.
157  *
158  * TIP: For a detailed writeup see our guide
159  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
160  * to implement supply mechanisms].
161  *
162  * We have followed general OpenZeppelin Contracts guidelines: functions revert
163  * instead returning `false` on failure. This behavior is nonetheless
164  * conventional and does not conflict with the expectations of ERC20
165  * applications.
166  *
167  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
168  * This allows applications to reconstruct the allowance for all accounts just
169  * by listening to said events. Other implementations of the EIP may not emit
170  * these events, as it isn't required by the specification.
171  *
172  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
173  * functions have been added to mitigate the well-known issues around setting
174  * allowances. See {IERC20-approve}.
175  */
176 contract ERC20 is Context, IERC20, IERC20Metadata {
177     mapping(address => uint256) private _balances;
178 
179     mapping(address => mapping(address => uint256)) private _allowances;
180 
181     uint256 private _totalSupply;
182 
183     string private _name;
184     string private _symbol;
185 
186     /**
187      * @dev Sets the values for {name} and {symbol}.
188      *
189      * The default value of {decimals} is 18. To select a different value for
190      * {decimals} you should overload it.
191      *
192      * All two of these values are immutable: they can only be set once during
193      * construction.
194      */
195     constructor(string memory name_, string memory symbol_) {
196         _name = name_;
197         _symbol = symbol_;
198     }
199 
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view virtual override returns (string memory) {
204         return _name;
205     }
206 
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214 
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if `decimals` equals `2`, a balance of `505` tokens should
218      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei. This is the value {ERC20} uses, unless this function is
222      * overridden;
223      *
224      * NOTE: This information is only used for _display_ purposes: it in
225      * no way affects any of the arithmetic of the contract, including
226      * {IERC20-balanceOf} and {IERC20-transfer}.
227      */
228     function decimals() public view virtual override returns (uint8) {
229         return 18;
230     }
231 
232     /**
233      * @dev See {IERC20-totalSupply}.
234      */
235     function totalSupply() public view virtual override returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(address account) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See {IERC20-transfer}.
248      *
249      * Requirements:
250      *
251      * - `to` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address to, uint256 amount) public virtual override returns (bool) {
255         address owner = _msgSender();
256         _transfer(owner, to, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
271      * `transferFrom`. This is semantically equivalent to an infinite approval.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 amount) public virtual override returns (bool) {
278         address owner = _msgSender();
279         _approve(owner, spender, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-transferFrom}.
285      *
286      * Emits an {Approval} event indicating the updated allowance. This is not
287      * required by the EIP. See the note at the beginning of {ERC20}.
288      *
289      * NOTE: Does not update the allowance if the current allowance
290      * is the maximum `uint256`.
291      *
292      * Requirements:
293      *
294      * - `from` and `to` cannot be the zero address.
295      * - `from` must have a balance of at least `amount`.
296      * - the caller must have allowance for ``from``'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(
300         address from,
301         address to,
302         uint256 amount
303     ) public virtual override returns (bool) {
304         address spender = _msgSender();
305         _spendAllowance(from, spender, amount);
306         _transfer(from, to, amount);
307         return true;
308     }
309 
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
323         address owner = _msgSender();
324         _approve(owner, spender, allowance(owner, spender) + addedValue);
325         return true;
326     }
327 
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         address owner = _msgSender();
344         uint256 currentAllowance = allowance(owner, spender);
345         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
346         unchecked {
347             _approve(owner, spender, currentAllowance - subtractedValue);
348         }
349 
350         return true;
351     }
352 
353     /**
354      * @dev Moves `amount` of tokens from `from` to `to`.
355      *
356      * This internal function is equivalent to {transfer}, and can be used to
357      * e.g. implement automatic token fees, slashing mechanisms, etc.
358      *
359      * Emits a {Transfer} event.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `from` must have a balance of at least `amount`.
366      */
367     function _transfer(
368         address from,
369         address to,
370         uint256 amount
371     ) internal virtual {
372         require(from != address(0), "ERC20: transfer from the zero address");
373         require(to != address(0), "ERC20: transfer to the zero address");
374 
375         _beforeTokenTransfer(from, to, amount);
376 
377         uint256 fromBalance = _balances[from];
378         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
379         unchecked {
380             _balances[from] = fromBalance - amount;
381             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
382             // decrementing then incrementing.
383             _balances[to] += amount;
384         }
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
406         unchecked {
407             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
408             _balances[account] += amount;
409         }
410         emit Transfer(address(0), account, amount);
411 
412         _afterTokenTransfer(address(0), account, amount);
413     }
414 
415     /**
416      * @dev Destroys `amount` tokens from `account`, reducing the
417      * total supply.
418      *
419      * Emits a {Transfer} event with `to` set to the zero address.
420      *
421      * Requirements:
422      *
423      * - `account` cannot be the zero address.
424      * - `account` must have at least `amount` tokens.
425      */
426     function _burn(address account, uint256 amount) internal virtual {
427         require(account != address(0), "ERC20: burn from the zero address");
428 
429         _beforeTokenTransfer(account, address(0), amount);
430 
431         uint256 accountBalance = _balances[account];
432         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
433         unchecked {
434             _balances[account] = accountBalance - amount;
435             // Overflow not possible: amount <= accountBalance <= totalSupply.
436             _totalSupply -= amount;
437         }
438 
439         emit Transfer(account, address(0), amount);
440 
441         _afterTokenTransfer(account, address(0), amount);
442     }
443 
444     /**
445      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
446      *
447      * This internal function is equivalent to `approve`, and can be used to
448      * e.g. set automatic allowances for certain subsystems, etc.
449      *
450      * Emits an {Approval} event.
451      *
452      * Requirements:
453      *
454      * - `owner` cannot be the zero address.
455      * - `spender` cannot be the zero address.
456      */
457     function _approve(
458         address owner,
459         address spender,
460         uint256 amount
461     ) internal virtual {
462         require(owner != address(0), "ERC20: approve from the zero address");
463         require(spender != address(0), "ERC20: approve to the zero address");
464 
465         _allowances[owner][spender] = amount;
466         emit Approval(owner, spender, amount);
467     }
468 
469     /**
470      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
471      *
472      * Does not update the allowance amount in case of infinite allowance.
473      * Revert if not enough allowance is available.
474      *
475      * Might emit an {Approval} event.
476      */
477     function _spendAllowance(
478         address owner,
479         address spender,
480         uint256 amount
481     ) internal virtual {
482         uint256 currentAllowance = allowance(owner, spender);
483         if (currentAllowance != type(uint256).max) {
484             require(currentAllowance >= amount, "ERC20: insufficient allowance");
485             unchecked {
486                 _approve(owner, spender, currentAllowance - amount);
487             }
488         }
489     }
490 
491     /**
492      * @dev Hook that is called before any transfer of tokens. This includes
493      * minting and burning.
494      *
495      * Calling conditions:
496      *
497      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
498      * will be transferred to `to`.
499      * - when `from` is zero, `amount` tokens will be minted for `to`.
500      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
501      * - `from` and `to` are never both zero.
502      *
503      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
504      */
505     function _beforeTokenTransfer(
506         address from,
507         address to,
508         uint256 amount
509     ) internal virtual {}
510 
511     /**
512      * @dev Hook that is called after any transfer of tokens. This includes
513      * minting and burning.
514      *
515      * Calling conditions:
516      *
517      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
518      * has been transferred to `to`.
519      * - when `from` is zero, `amount` tokens have been minted for `to`.
520      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
521      * - `from` and `to` are never both zero.
522      *
523      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
524      */
525     function _afterTokenTransfer(
526         address from,
527         address to,
528         uint256 amount
529     ) internal virtual {}
530 }
531 
532 
533 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.8.3
534 
535 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
541  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
542  *
543  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
544  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
545  * need to send a transaction, and thus is not required to hold Ether at all.
546  */
547 interface IERC20Permit {
548     /**
549      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
550      * given ``owner``'s signed approval.
551      *
552      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
553      * ordering also apply here.
554      *
555      * Emits an {Approval} event.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      * - `deadline` must be a timestamp in the future.
561      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
562      * over the EIP712-formatted function arguments.
563      * - the signature must use ``owner``'s current nonce (see {nonces}).
564      *
565      * For more information on the signature format, see the
566      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
567      * section].
568      */
569     function permit(
570         address owner,
571         address spender,
572         uint256 value,
573         uint256 deadline,
574         uint8 v,
575         bytes32 r,
576         bytes32 s
577     ) external;
578 
579     /**
580      * @dev Returns the current nonce for `owner`. This value must be
581      * included whenever a signature is generated for {permit}.
582      *
583      * Every successful call to {permit} increases ``owner``'s nonce by one. This
584      * prevents a signature from being used multiple times.
585      */
586     function nonces(address owner) external view returns (uint256);
587 
588     /**
589      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
590      */
591     // solhint-disable-next-line func-name-mixedcase
592     function DOMAIN_SEPARATOR() external view returns (bytes32);
593 }
594 
595 
596 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.3
597 
598 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
599 
600 pragma solidity ^0.8.0;
601 
602 /**
603  * @dev Standard math utilities missing in the Solidity language.
604  */
605 library Math {
606     enum Rounding {
607         Down, // Toward negative infinity
608         Up, // Toward infinity
609         Zero // Toward zero
610     }
611 
612     /**
613      * @dev Returns the largest of two numbers.
614      */
615     function max(uint256 a, uint256 b) internal pure returns (uint256) {
616         return a > b ? a : b;
617     }
618 
619     /**
620      * @dev Returns the smallest of two numbers.
621      */
622     function min(uint256 a, uint256 b) internal pure returns (uint256) {
623         return a < b ? a : b;
624     }
625 
626     /**
627      * @dev Returns the average of two numbers. The result is rounded towards
628      * zero.
629      */
630     function average(uint256 a, uint256 b) internal pure returns (uint256) {
631         // (a + b) / 2 can overflow.
632         return (a & b) + (a ^ b) / 2;
633     }
634 
635     /**
636      * @dev Returns the ceiling of the division of two numbers.
637      *
638      * This differs from standard division with `/` in that it rounds up instead
639      * of rounding down.
640      */
641     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
642         // (a + b - 1) / b can overflow on addition, so we distribute.
643         return a == 0 ? 0 : (a - 1) / b + 1;
644     }
645 
646     /**
647      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
648      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
649      * with further edits by Uniswap Labs also under MIT license.
650      */
651     function mulDiv(
652         uint256 x,
653         uint256 y,
654         uint256 denominator
655     ) internal pure returns (uint256 result) {
656         unchecked {
657             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
658             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
659             // variables such that product = prod1 * 2^256 + prod0.
660             uint256 prod0; // Least significant 256 bits of the product
661             uint256 prod1; // Most significant 256 bits of the product
662             assembly {
663                 let mm := mulmod(x, y, not(0))
664                 prod0 := mul(x, y)
665                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
666             }
667 
668             // Handle non-overflow cases, 256 by 256 division.
669             if (prod1 == 0) {
670                 return prod0 / denominator;
671             }
672 
673             // Make sure the result is less than 2^256. Also prevents denominator == 0.
674             require(denominator > prod1);
675 
676             ///////////////////////////////////////////////
677             // 512 by 256 division.
678             ///////////////////////////////////////////////
679 
680             // Make division exact by subtracting the remainder from [prod1 prod0].
681             uint256 remainder;
682             assembly {
683                 // Compute remainder using mulmod.
684                 remainder := mulmod(x, y, denominator)
685 
686                 // Subtract 256 bit number from 512 bit number.
687                 prod1 := sub(prod1, gt(remainder, prod0))
688                 prod0 := sub(prod0, remainder)
689             }
690 
691             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
692             // See https://cs.stackexchange.com/q/138556/92363.
693 
694             // Does not overflow because the denominator cannot be zero at this stage in the function.
695             uint256 twos = denominator & (~denominator + 1);
696             assembly {
697                 // Divide denominator by twos.
698                 denominator := div(denominator, twos)
699 
700                 // Divide [prod1 prod0] by twos.
701                 prod0 := div(prod0, twos)
702 
703                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
704                 twos := add(div(sub(0, twos), twos), 1)
705             }
706 
707             // Shift in bits from prod1 into prod0.
708             prod0 |= prod1 * twos;
709 
710             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
711             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
712             // four bits. That is, denominator * inv = 1 mod 2^4.
713             uint256 inverse = (3 * denominator) ^ 2;
714 
715             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
716             // in modular arithmetic, doubling the correct bits in each step.
717             inverse *= 2 - denominator * inverse; // inverse mod 2^8
718             inverse *= 2 - denominator * inverse; // inverse mod 2^16
719             inverse *= 2 - denominator * inverse; // inverse mod 2^32
720             inverse *= 2 - denominator * inverse; // inverse mod 2^64
721             inverse *= 2 - denominator * inverse; // inverse mod 2^128
722             inverse *= 2 - denominator * inverse; // inverse mod 2^256
723 
724             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
725             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
726             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
727             // is no longer required.
728             result = prod0 * inverse;
729             return result;
730         }
731     }
732 
733     /**
734      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
735      */
736     function mulDiv(
737         uint256 x,
738         uint256 y,
739         uint256 denominator,
740         Rounding rounding
741     ) internal pure returns (uint256) {
742         uint256 result = mulDiv(x, y, denominator);
743         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
744             result += 1;
745         }
746         return result;
747     }
748 
749     /**
750      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
751      *
752      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
753      */
754     function sqrt(uint256 a) internal pure returns (uint256) {
755         if (a == 0) {
756             return 0;
757         }
758 
759         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
760         //
761         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
762         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
763         //
764         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
765         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
766         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
767         //
768         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
769         uint256 result = 1 << (log2(a) >> 1);
770 
771         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
772         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
773         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
774         // into the expected uint128 result.
775         unchecked {
776             result = (result + a / result) >> 1;
777             result = (result + a / result) >> 1;
778             result = (result + a / result) >> 1;
779             result = (result + a / result) >> 1;
780             result = (result + a / result) >> 1;
781             result = (result + a / result) >> 1;
782             result = (result + a / result) >> 1;
783             return min(result, a / result);
784         }
785     }
786 
787     /**
788      * @notice Calculates sqrt(a), following the selected rounding direction.
789      */
790     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
791         unchecked {
792             uint256 result = sqrt(a);
793             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
794         }
795     }
796 
797     /**
798      * @dev Return the log in base 2, rounded down, of a positive value.
799      * Returns 0 if given 0.
800      */
801     function log2(uint256 value) internal pure returns (uint256) {
802         uint256 result = 0;
803         unchecked {
804             if (value >> 128 > 0) {
805                 value >>= 128;
806                 result += 128;
807             }
808             if (value >> 64 > 0) {
809                 value >>= 64;
810                 result += 64;
811             }
812             if (value >> 32 > 0) {
813                 value >>= 32;
814                 result += 32;
815             }
816             if (value >> 16 > 0) {
817                 value >>= 16;
818                 result += 16;
819             }
820             if (value >> 8 > 0) {
821                 value >>= 8;
822                 result += 8;
823             }
824             if (value >> 4 > 0) {
825                 value >>= 4;
826                 result += 4;
827             }
828             if (value >> 2 > 0) {
829                 value >>= 2;
830                 result += 2;
831             }
832             if (value >> 1 > 0) {
833                 result += 1;
834             }
835         }
836         return result;
837     }
838 
839     /**
840      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
841      * Returns 0 if given 0.
842      */
843     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
844         unchecked {
845             uint256 result = log2(value);
846             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
847         }
848     }
849 
850     /**
851      * @dev Return the log in base 10, rounded down, of a positive value.
852      * Returns 0 if given 0.
853      */
854     function log10(uint256 value) internal pure returns (uint256) {
855         uint256 result = 0;
856         unchecked {
857             if (value >= 10**64) {
858                 value /= 10**64;
859                 result += 64;
860             }
861             if (value >= 10**32) {
862                 value /= 10**32;
863                 result += 32;
864             }
865             if (value >= 10**16) {
866                 value /= 10**16;
867                 result += 16;
868             }
869             if (value >= 10**8) {
870                 value /= 10**8;
871                 result += 8;
872             }
873             if (value >= 10**4) {
874                 value /= 10**4;
875                 result += 4;
876             }
877             if (value >= 10**2) {
878                 value /= 10**2;
879                 result += 2;
880             }
881             if (value >= 10**1) {
882                 result += 1;
883             }
884         }
885         return result;
886     }
887 
888     /**
889      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
890      * Returns 0 if given 0.
891      */
892     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
893         unchecked {
894             uint256 result = log10(value);
895             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
896         }
897     }
898 
899     /**
900      * @dev Return the log in base 256, rounded down, of a positive value.
901      * Returns 0 if given 0.
902      *
903      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
904      */
905     function log256(uint256 value) internal pure returns (uint256) {
906         uint256 result = 0;
907         unchecked {
908             if (value >> 128 > 0) {
909                 value >>= 128;
910                 result += 16;
911             }
912             if (value >> 64 > 0) {
913                 value >>= 64;
914                 result += 8;
915             }
916             if (value >> 32 > 0) {
917                 value >>= 32;
918                 result += 4;
919             }
920             if (value >> 16 > 0) {
921                 value >>= 16;
922                 result += 2;
923             }
924             if (value >> 8 > 0) {
925                 result += 1;
926             }
927         }
928         return result;
929     }
930 
931     /**
932      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
933      * Returns 0 if given 0.
934      */
935     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
936         unchecked {
937             uint256 result = log256(value);
938             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
939         }
940     }
941 }
942 
943 
944 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.3
945 
946 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
947 
948 pragma solidity ^0.8.0;
949 
950 /**
951  * @dev String operations.
952  */
953 library Strings {
954     bytes16 private constant _SYMBOLS = "0123456789abcdef";
955     uint8 private constant _ADDRESS_LENGTH = 20;
956 
957     /**
958      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
959      */
960     function toString(uint256 value) internal pure returns (string memory) {
961         unchecked {
962             uint256 length = Math.log10(value) + 1;
963             string memory buffer = new string(length);
964             uint256 ptr;
965             /// @solidity memory-safe-assembly
966             assembly {
967                 ptr := add(buffer, add(32, length))
968             }
969             while (true) {
970                 ptr--;
971                 /// @solidity memory-safe-assembly
972                 assembly {
973                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
974                 }
975                 value /= 10;
976                 if (value == 0) break;
977             }
978             return buffer;
979         }
980     }
981 
982     /**
983      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
984      */
985     function toHexString(uint256 value) internal pure returns (string memory) {
986         unchecked {
987             return toHexString(value, Math.log256(value) + 1);
988         }
989     }
990 
991     /**
992      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
993      */
994     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
995         bytes memory buffer = new bytes(2 * length + 2);
996         buffer[0] = "0";
997         buffer[1] = "x";
998         for (uint256 i = 2 * length + 1; i > 1; --i) {
999             buffer[i] = _SYMBOLS[value & 0xf];
1000             value >>= 4;
1001         }
1002         require(value == 0, "Strings: hex length insufficient");
1003         return string(buffer);
1004     }
1005 
1006     /**
1007      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1008      */
1009     function toHexString(address addr) internal pure returns (string memory) {
1010         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1011     }
1012 }
1013 
1014 
1015 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.8.3
1016 
1017 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 /**
1022  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1023  *
1024  * These functions can be used to verify that a message was signed by the holder
1025  * of the private keys of a given address.
1026  */
1027 library ECDSA {
1028     enum RecoverError {
1029         NoError,
1030         InvalidSignature,
1031         InvalidSignatureLength,
1032         InvalidSignatureS,
1033         InvalidSignatureV // Deprecated in v4.8
1034     }
1035 
1036     function _throwError(RecoverError error) private pure {
1037         if (error == RecoverError.NoError) {
1038             return; // no error: do nothing
1039         } else if (error == RecoverError.InvalidSignature) {
1040             revert("ECDSA: invalid signature");
1041         } else if (error == RecoverError.InvalidSignatureLength) {
1042             revert("ECDSA: invalid signature length");
1043         } else if (error == RecoverError.InvalidSignatureS) {
1044             revert("ECDSA: invalid signature 's' value");
1045         }
1046     }
1047 
1048     /**
1049      * @dev Returns the address that signed a hashed message (`hash`) with
1050      * `signature` or error string. This address can then be used for verification purposes.
1051      *
1052      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1053      * this function rejects them by requiring the `s` value to be in the lower
1054      * half order, and the `v` value to be either 27 or 28.
1055      *
1056      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1057      * verification to be secure: it is possible to craft signatures that
1058      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1059      * this is by receiving a hash of the original message (which may otherwise
1060      * be too long), and then calling {toEthSignedMessageHash} on it.
1061      *
1062      * Documentation for signature generation:
1063      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1064      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1065      *
1066      * _Available since v4.3._
1067      */
1068     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1069         if (signature.length == 65) {
1070             bytes32 r;
1071             bytes32 s;
1072             uint8 v;
1073             // ecrecover takes the signature parameters, and the only way to get them
1074             // currently is to use assembly.
1075             /// @solidity memory-safe-assembly
1076             assembly {
1077                 r := mload(add(signature, 0x20))
1078                 s := mload(add(signature, 0x40))
1079                 v := byte(0, mload(add(signature, 0x60)))
1080             }
1081             return tryRecover(hash, v, r, s);
1082         } else {
1083             return (address(0), RecoverError.InvalidSignatureLength);
1084         }
1085     }
1086 
1087     /**
1088      * @dev Returns the address that signed a hashed message (`hash`) with
1089      * `signature`. This address can then be used for verification purposes.
1090      *
1091      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1092      * this function rejects them by requiring the `s` value to be in the lower
1093      * half order, and the `v` value to be either 27 or 28.
1094      *
1095      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1096      * verification to be secure: it is possible to craft signatures that
1097      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1098      * this is by receiving a hash of the original message (which may otherwise
1099      * be too long), and then calling {toEthSignedMessageHash} on it.
1100      */
1101     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1102         (address recovered, RecoverError error) = tryRecover(hash, signature);
1103         _throwError(error);
1104         return recovered;
1105     }
1106 
1107     /**
1108      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1109      *
1110      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1111      *
1112      * _Available since v4.3._
1113      */
1114     function tryRecover(
1115         bytes32 hash,
1116         bytes32 r,
1117         bytes32 vs
1118     ) internal pure returns (address, RecoverError) {
1119         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1120         uint8 v = uint8((uint256(vs) >> 255) + 27);
1121         return tryRecover(hash, v, r, s);
1122     }
1123 
1124     /**
1125      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1126      *
1127      * _Available since v4.2._
1128      */
1129     function recover(
1130         bytes32 hash,
1131         bytes32 r,
1132         bytes32 vs
1133     ) internal pure returns (address) {
1134         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1135         _throwError(error);
1136         return recovered;
1137     }
1138 
1139     /**
1140      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1141      * `r` and `s` signature fields separately.
1142      *
1143      * _Available since v4.3._
1144      */
1145     function tryRecover(
1146         bytes32 hash,
1147         uint8 v,
1148         bytes32 r,
1149         bytes32 s
1150     ) internal pure returns (address, RecoverError) {
1151         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1152         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1153         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1154         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1155         //
1156         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1157         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1158         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1159         // these malleable signatures as well.
1160         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1161             return (address(0), RecoverError.InvalidSignatureS);
1162         }
1163 
1164         // If the signature is valid (and not malleable), return the signer address
1165         address signer = ecrecover(hash, v, r, s);
1166         if (signer == address(0)) {
1167             return (address(0), RecoverError.InvalidSignature);
1168         }
1169 
1170         return (signer, RecoverError.NoError);
1171     }
1172 
1173     /**
1174      * @dev Overload of {ECDSA-recover} that receives the `v`,
1175      * `r` and `s` signature fields separately.
1176      */
1177     function recover(
1178         bytes32 hash,
1179         uint8 v,
1180         bytes32 r,
1181         bytes32 s
1182     ) internal pure returns (address) {
1183         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1184         _throwError(error);
1185         return recovered;
1186     }
1187 
1188     /**
1189      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1190      * produces hash corresponding to the one signed with the
1191      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1192      * JSON-RPC method as part of EIP-191.
1193      *
1194      * See {recover}.
1195      */
1196     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1197         // 32 is the length in bytes of hash,
1198         // enforced by the type signature above
1199         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1200     }
1201 
1202     /**
1203      * @dev Returns an Ethereum Signed Message, created from `s`. This
1204      * produces hash corresponding to the one signed with the
1205      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1206      * JSON-RPC method as part of EIP-191.
1207      *
1208      * See {recover}.
1209      */
1210     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1211         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1212     }
1213 
1214     /**
1215      * @dev Returns an Ethereum Signed Typed Data, created from a
1216      * `domainSeparator` and a `structHash`. This produces hash corresponding
1217      * to the one signed with the
1218      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1219      * JSON-RPC method as part of EIP-712.
1220      *
1221      * See {recover}.
1222      */
1223     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1224         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1225     }
1226 }
1227 
1228 
1229 // File @openzeppelin/contracts/utils/cryptography/EIP712.sol@v4.8.3
1230 
1231 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
1232 
1233 pragma solidity ^0.8.0;
1234 
1235 /**
1236  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1237  *
1238  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1239  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1240  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1241  *
1242  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1243  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1244  * ({_hashTypedDataV4}).
1245  *
1246  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1247  * the chain id to protect against replay attacks on an eventual fork of the chain.
1248  *
1249  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1250  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1251  *
1252  * _Available since v3.4._
1253  */
1254 abstract contract EIP712 {
1255     /* solhint-disable var-name-mixedcase */
1256     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1257     // invalidate the cached domain separator if the chain id changes.
1258     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1259     uint256 private immutable _CACHED_CHAIN_ID;
1260     address private immutable _CACHED_THIS;
1261 
1262     bytes32 private immutable _HASHED_NAME;
1263     bytes32 private immutable _HASHED_VERSION;
1264     bytes32 private immutable _TYPE_HASH;
1265 
1266     /* solhint-enable var-name-mixedcase */
1267 
1268     /**
1269      * @dev Initializes the domain separator and parameter caches.
1270      *
1271      * The meaning of `name` and `version` is specified in
1272      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1273      *
1274      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1275      * - `version`: the current major version of the signing domain.
1276      *
1277      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1278      * contract upgrade].
1279      */
1280     constructor(string memory name, string memory version) {
1281         bytes32 hashedName = keccak256(bytes(name));
1282         bytes32 hashedVersion = keccak256(bytes(version));
1283         bytes32 typeHash = keccak256(
1284             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1285         );
1286         _HASHED_NAME = hashedName;
1287         _HASHED_VERSION = hashedVersion;
1288         _CACHED_CHAIN_ID = block.chainid;
1289         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1290         _CACHED_THIS = address(this);
1291         _TYPE_HASH = typeHash;
1292     }
1293 
1294     /**
1295      * @dev Returns the domain separator for the current chain.
1296      */
1297     function _domainSeparatorV4() internal view returns (bytes32) {
1298         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1299             return _CACHED_DOMAIN_SEPARATOR;
1300         } else {
1301             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1302         }
1303     }
1304 
1305     function _buildDomainSeparator(
1306         bytes32 typeHash,
1307         bytes32 nameHash,
1308         bytes32 versionHash
1309     ) private view returns (bytes32) {
1310         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1311     }
1312 
1313     /**
1314      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1315      * function returns the hash of the fully encoded EIP712 message for this domain.
1316      *
1317      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1318      *
1319      * ```solidity
1320      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1321      *     keccak256("Mail(address to,string contents)"),
1322      *     mailTo,
1323      *     keccak256(bytes(mailContents))
1324      * )));
1325      * address signer = ECDSA.recover(digest, signature);
1326      * ```
1327      */
1328     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1329         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1330     }
1331 }
1332 
1333 
1334 // File @openzeppelin/contracts/utils/Counters.sol@v4.8.3
1335 
1336 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1337 
1338 pragma solidity ^0.8.0;
1339 
1340 /**
1341  * @title Counters
1342  * @author Matt Condon (@shrugs)
1343  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1344  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1345  *
1346  * Include with `using Counters for Counters.Counter;`
1347  */
1348 library Counters {
1349     struct Counter {
1350         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1351         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1352         // this feature: see https://github.com/ethereum/solidity/issues/4637
1353         uint256 _value; // default: 0
1354     }
1355 
1356     function current(Counter storage counter) internal view returns (uint256) {
1357         return counter._value;
1358     }
1359 
1360     function increment(Counter storage counter) internal {
1361         unchecked {
1362             counter._value += 1;
1363         }
1364     }
1365 
1366     function decrement(Counter storage counter) internal {
1367         uint256 value = counter._value;
1368         require(value > 0, "Counter: decrement overflow");
1369         unchecked {
1370             counter._value = value - 1;
1371         }
1372     }
1373 
1374     function reset(Counter storage counter) internal {
1375         counter._value = 0;
1376     }
1377 }
1378 
1379 
1380 // File @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol@v4.8.3
1381 
1382 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/extensions/draft-ERC20Permit.sol)
1383 
1384 pragma solidity ^0.8.0;
1385 
1386 
1387 
1388 
1389 
1390 /**
1391  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1392  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1393  *
1394  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1395  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1396  * need to send a transaction, and thus is not required to hold Ether at all.
1397  *
1398  * _Available since v3.4._
1399  */
1400 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1401     using Counters for Counters.Counter;
1402 
1403     mapping(address => Counters.Counter) private _nonces;
1404 
1405     // solhint-disable-next-line var-name-mixedcase
1406     bytes32 private constant _PERMIT_TYPEHASH =
1407         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1408     /**
1409      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
1410      * However, to ensure consistency with the upgradeable transpiler, we will continue
1411      * to reserve a slot.
1412      * @custom:oz-renamed-from _PERMIT_TYPEHASH
1413      */
1414     // solhint-disable-next-line var-name-mixedcase
1415     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
1416 
1417     /**
1418      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1419      *
1420      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1421      */
1422     constructor(string memory name) EIP712(name, "1") {}
1423 
1424     /**
1425      * @dev See {IERC20Permit-permit}.
1426      */
1427     function permit(
1428         address owner,
1429         address spender,
1430         uint256 value,
1431         uint256 deadline,
1432         uint8 v,
1433         bytes32 r,
1434         bytes32 s
1435     ) public virtual override {
1436         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1437 
1438         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1439 
1440         bytes32 hash = _hashTypedDataV4(structHash);
1441 
1442         address signer = ECDSA.recover(hash, v, r, s);
1443         require(signer == owner, "ERC20Permit: invalid signature");
1444 
1445         _approve(owner, spender, value);
1446     }
1447 
1448     /**
1449      * @dev See {IERC20Permit-nonces}.
1450      */
1451     function nonces(address owner) public view virtual override returns (uint256) {
1452         return _nonces[owner].current();
1453     }
1454 
1455     /**
1456      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1457      */
1458     // solhint-disable-next-line func-name-mixedcase
1459     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1460         return _domainSeparatorV4();
1461     }
1462 
1463     /**
1464      * @dev "Consume a nonce": return the current value and increment.
1465      *
1466      * _Available since v4.1._
1467      */
1468     function _useNonce(address owner) internal virtual returns (uint256 current) {
1469         Counters.Counter storage nonce = _nonces[owner];
1470         current = nonce.current();
1471         nonce.increment();
1472     }
1473 }
1474 
1475 
1476 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.3
1477 
1478 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1479 
1480 pragma solidity ^0.8.0;
1481 
1482 /**
1483  * @dev Contract module which provides a basic access control mechanism, where
1484  * there is an account (an owner) that can be granted exclusive access to
1485  * specific functions.
1486  *
1487  * By default, the owner account will be the one that deploys the contract. This
1488  * can later be changed with {transferOwnership}.
1489  *
1490  * This module is used through inheritance. It will make available the modifier
1491  * `onlyOwner`, which can be applied to your functions to restrict their use to
1492  * the owner.
1493  */
1494 abstract contract Ownable is Context {
1495     address private _owner;
1496 
1497     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1498 
1499     /**
1500      * @dev Initializes the contract setting the deployer as the initial owner.
1501      */
1502     constructor() {
1503         _transferOwnership(_msgSender());
1504     }
1505 
1506     /**
1507      * @dev Throws if called by any account other than the owner.
1508      */
1509     modifier onlyOwner() {
1510         _checkOwner();
1511         _;
1512     }
1513 
1514     /**
1515      * @dev Returns the address of the current owner.
1516      */
1517     function owner() public view virtual returns (address) {
1518         return _owner;
1519     }
1520 
1521     /**
1522      * @dev Throws if the sender is not the owner.
1523      */
1524     function _checkOwner() internal view virtual {
1525         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1526     }
1527 
1528     /**
1529      * @dev Leaves the contract without owner. It will not be possible to call
1530      * `onlyOwner` functions anymore. Can only be called by the current owner.
1531      *
1532      * NOTE: Renouncing ownership will leave the contract without an owner,
1533      * thereby removing any functionality that is only available to the owner.
1534      */
1535     function renounceOwnership() public virtual onlyOwner {
1536         _transferOwnership(address(0));
1537     }
1538 
1539     /**
1540      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1541      * Can only be called by the current owner.
1542      */
1543     function transferOwnership(address newOwner) public virtual onlyOwner {
1544         require(newOwner != address(0), "Ownable: new owner is the zero address");
1545         _transferOwnership(newOwner);
1546     }
1547 
1548     /**
1549      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1550      * Internal function without access restriction.
1551      */
1552     function _transferOwnership(address newOwner) internal virtual {
1553         address oldOwner = _owner;
1554         _owner = newOwner;
1555         emit OwnershipTransferred(oldOwner, newOwner);
1556     }
1557 }
1558 
1559 
1560 // File contracts/DYOR.sol
1561 
1562 
1563  //*******   **    **   *******   *******  	          \_A__  A    A           AA  ___/
1564 ///**////** //**  **   **/////** /**////** 	                \____  ^^^^^^^^   ___/
1565 ///**    /** //****   **     //**/**   /**                       \|         |/     /\_/\            
1566 ///**    /**  //**   /**      /**/*******          ___    /\_/\   |         |     ((@v@))       __/     
1567 ///**    /**   /**   /**      /**/**///**         (o,o)  ((@v@))  |         |     ():::()     /             
1568 ///**    **    /**   //**     ** /**  //**       <  .  > ():::()  |         |------VV-VV------          
1569 ///*******     /**    //*******  /**   //**  ------"-"----VV-VV---|         |-----------------          
1570 /////////      //      ///////   //     //   ---------------------|         |                 \__  
1571                                                                                                 
1572 pragma solidity ^0.8.9;
1573 contract DYOR is ERC20, Ownable, ERC20Permit {
1574     constructor() ERC20("DYOR", "DYOR") ERC20Permit("DYOR"){}
1575 
1576     /// turn on/off contributions
1577     bool public allowContributions = false;
1578 
1579     /// turn on/off refunds
1580     bool public allowRefund = false;
1581 
1582     /// mint LP once
1583     bool public lpMinted = false;
1584 
1585     /// a minimum contribution per tx to participate in the presale
1586     uint256 public constant MIN_CONTRIBUTION = .025 ether;
1587 
1588     /// limit the maximum contribution per tx for each wallet
1589     uint256 public constant MAX_CONTRIBUTION = .25 ether;
1590 
1591     /// the maximum amount of eth that this contract will accept for presale
1592     uint256 public constant HARD_CAP = 20 ether;
1593 
1594     /// total number of tokens available
1595     uint256 public constant MAX_SUPPLY = 6900000000000 * 10 ** 18;
1596 
1597     /// 45% of tokens reserved for presale
1598     uint256 public constant PRESALE_SUPPLY = 3105000000000 * 10 ** 18;
1599 
1600     /// 35% of tokens reserved for LP
1601     uint256 public constant LP_SUPPLY = 2415000000000 * 10 ** 18;
1602 
1603     /// used to track the total contributions for the presale
1604     uint256 public TOTAL_CONTRIBUTED;
1605 
1606     /// used to track the total number of contributoors
1607     uint256 public NUMBER_OF_CONTRIBUTOORS;
1608 
1609     uint256 public AIRDROP_INDEX = 1;
1610 
1611     /// a struct used to keep track of each contributoors address and contribution amount
1612     struct Contribution {
1613         address addr;
1614         uint256 amount;
1615     }
1616 
1617     /// mapping of contributions
1618     mapping (uint256 => Contribution) public contribution;
1619 
1620     /// index of an address to it's contribition information
1621     mapping (address => uint256) public contributoor;
1622 
1623     /// collect presale contributions
1624     function sendToPresale() public payable {
1625 
1626         /// initialize a contribution index so we can keep track of this address' contributions
1627         uint256 contributionIndex;
1628 
1629         /// check to see if contributions are allowed
1630         require (allowContributions, "Contributions not allowed");
1631 
1632         /// check to see that at least the min is being sent in
1633         require(msg.value >= MIN_CONTRIBUTION, "Contribution too low");
1634 
1635         /// enforce per-wallet contribution limit
1636         require (msg.value <= MAX_CONTRIBUTION, "Contribution exceeds per wallet limit");
1637 
1638         /// enforce hard cap
1639         require (msg.value + TOTAL_CONTRIBUTED <= HARD_CAP, "Contribution exceeds hard cap"); 
1640 
1641         if (contributoor[msg.sender] != 0){
1642             /// no need to increase the number of contributors since this person already added
1643             contributionIndex = contributoor[msg.sender];
1644         } else {
1645             /// keep track of each new contributor with a unique index
1646             contributionIndex = NUMBER_OF_CONTRIBUTOORS + 1;
1647             NUMBER_OF_CONTRIBUTOORS++;
1648             contributoor[msg.sender] = contributionIndex;
1649             contribution[contributionIndex].addr = msg.sender;
1650         }
1651 
1652         /// add the contribution to the amount contributed
1653         TOTAL_CONTRIBUTED = TOTAL_CONTRIBUTED + msg.value;
1654 
1655         /// keep track of the address' contributions so far
1656         contribution[contributionIndex].amount += msg.value;
1657     }
1658 
1659     function airdropPresale(uint256 airdropamount) external onlyOwner {
1660 
1661         require (!allowContributions, "presale is still on");
1662 
1663         /// determine the price per token
1664         uint256 pricePerToken = (HARD_CAP * 20 ** 18) /PRESALE_SUPPLY;
1665 
1666         //check to make sure you are not going over the number of contributoors
1667         uint256 minttoIndex = AIRDROP_INDEX + airdropamount;
1668         require(minttoIndex - 1 <= NUMBER_OF_CONTRIBUTOORS, "out of airdrop range");
1669 
1670         /// loop over each contribution and distribute tokens
1671         for (uint256 i = AIRDROP_INDEX; i < minttoIndex; i++) {
1672 
1673             /// convert contribution to 18 decimals
1674             uint256 contributionAmount = contribution[i].amount * 20 ** 18;
1675 
1676             /// calculate the percentage of the pool based on the address' contribution
1677             uint256 numberOfTokensToMint = contributionAmount/pricePerToken;
1678 
1679             /// mint the tokens to the address
1680             _mint(contribution[i].addr, numberOfTokensToMint);
1681             }
1682 
1683         // update starting index for next airdrop
1684         AIRDROP_INDEX = minttoIndex;
1685     }
1686 
1687     /// dev mint the remainder of the pool to round out the supply
1688     function devMint(address _address) external onlyOwner {
1689 
1690         /// calculate the remaining supply
1691         uint256 numberToMint = MAX_SUPPLY - totalSupply();
1692 
1693         //make sure contributions are set to false
1694         require (!allowContributions, "presale is still on");
1695 
1696         /// mint the remaining supply to the dev's wallet
1697         _mint(_address, numberToMint);
1698     }
1699 
1700      /// set whether or not the contract allows contributions
1701     function setAllowContributions(bool _value) external onlyOwner {
1702         allowContributions = _value;
1703     }
1704 
1705     /// set whether or not we want to scrub the project
1706     function setAllowRefund(bool _value) external onlyOwner {
1707         allowRefund = _value;
1708     }
1709 
1710     /// take your eth out
1711     function getRefund() public {
1712 
1713         require (allowRefund, "refund is not allowed");
1714         require (!allowContributions, "presale is still on");
1715         require(contributoor[msg.sender] != 0, "user did not contribute");
1716 
1717         uint256 contributionIndex = contributoor[msg.sender];
1718         uint256 amountToRefund = contribution[contributionIndex].amount;
1719 
1720         require(amountToRefund > 0, "nothing to refund");
1721         contribution[contributionIndex].amount = 0;
1722 
1723         address payable refundAddress = payable(contribution[contributionIndex].addr);
1724         refundAddress.transfer(amountToRefund);
1725     }
1726 
1727     /// mint the LP amount
1728     function mintLPAmount() external onlyOwner {
1729         require(!lpMinted, "LP Minted");
1730         lpMinted = true;
1731         _mint(msg.sender, LP_SUPPLY);
1732     }
1733 
1734     /// allows the owner to withdraw the funds in this contract
1735     function withdrawBalance(address payable _address) external onlyOwner {
1736         (bool success, ) = _address.call{value: address(this).balance}("");
1737         require(success, "Withdraw failed");
1738     }
1739 }