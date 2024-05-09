1 // The one has no purpose. No utility. The only one.
2 // https://twitter.com/theoneco1n
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 
10 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
11 
12 
13 
14 /**
15  * @dev Standard math utilities missing in the Solidity language.
16  */
17 library Math {
18     enum Rounding {
19         Down, // Toward negative infinity
20         Up, // Toward infinity
21         Zero // Toward zero
22     }
23 
24     /**
25      * @dev Returns the largest of two numbers.
26      */
27     function max(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a > b ? a : b;
29     }
30 
31     /**
32      * @dev Returns the smallest of two numbers.
33      */
34     function min(uint256 a, uint256 b) internal pure returns (uint256) {
35         return a < b ? a : b;
36     }
37 
38     /**
39      * @dev Returns the average of two numbers. The result is rounded towards
40      * zero.
41      */
42     function average(uint256 a, uint256 b) internal pure returns (uint256) {
43         // (a + b) / 2 can overflow.
44         return (a & b) + (a ^ b) / 2;
45     }
46 
47     /**
48      * @dev Returns the ceiling of the division of two numbers.
49      *
50      * This differs from standard division with `/` in that it rounds up instead
51      * of rounding down.
52      */
53     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
54         // (a + b - 1) / b can overflow on addition, so we distribute.
55         return a == 0 ? 0 : (a - 1) / b + 1;
56     }
57 
58     /**
59      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
60      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
61      * with further edits by Uniswap Labs also under MIT license.
62      */
63     function mulDiv(
64         uint256 x,
65         uint256 y,
66         uint256 denominator
67     ) internal pure returns (uint256 result) {
68         unchecked {
69             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
70             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
71             // variables such that product = prod1 * 2^256 + prod0.
72             uint256 prod0; // Least significant 256 bits of the product
73             uint256 prod1; // Most significant 256 bits of the product
74             assembly {
75                 let mm := mulmod(x, y, not(0))
76                 prod0 := mul(x, y)
77                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
78             }
79 
80             // Handle non-overflow cases, 256 by 256 division.
81             if (prod1 == 0) {
82                 return prod0 / denominator;
83             }
84 
85             // Make sure the result is less than 2^256. Also prevents denominator == 0.
86             require(denominator > prod1);
87 
88             ///////////////////////////////////////////////
89             // 512 by 256 division.
90             ///////////////////////////////////////////////
91 
92             // Make division exact by subtracting the remainder from [prod1 prod0].
93             uint256 remainder;
94             assembly {
95                 // Compute remainder using mulmod.
96                 remainder := mulmod(x, y, denominator)
97 
98                 // Subtract 256 bit number from 512 bit number.
99                 prod1 := sub(prod1, gt(remainder, prod0))
100                 prod0 := sub(prod0, remainder)
101             }
102 
103             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
104             // See https://cs.stackexchange.com/q/138556/92363.
105 
106             // Does not overflow because the denominator cannot be zero at this stage in the function.
107             uint256 twos = denominator & (~denominator + 1);
108             assembly {
109                 // Divide denominator by twos.
110                 denominator := div(denominator, twos)
111 
112                 // Divide [prod1 prod0] by twos.
113                 prod0 := div(prod0, twos)
114 
115                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
116                 twos := add(div(sub(0, twos), twos), 1)
117             }
118 
119             // Shift in bits from prod1 into prod0.
120             prod0 |= prod1 * twos;
121 
122             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
123             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
124             // four bits. That is, denominator * inv = 1 mod 2^4.
125             uint256 inverse = (3 * denominator) ^ 2;
126 
127             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
128             // in modular arithmetic, doubling the correct bits in each step.
129             inverse *= 2 - denominator * inverse; // inverse mod 2^8
130             inverse *= 2 - denominator * inverse; // inverse mod 2^16
131             inverse *= 2 - denominator * inverse; // inverse mod 2^32
132             inverse *= 2 - denominator * inverse; // inverse mod 2^64
133             inverse *= 2 - denominator * inverse; // inverse mod 2^128
134             inverse *= 2 - denominator * inverse; // inverse mod 2^256
135 
136             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
137             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
138             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
139             // is no longer required.
140             result = prod0 * inverse;
141             return result;
142         }
143     }
144 
145     /**
146      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
147      */
148     function mulDiv(
149         uint256 x,
150         uint256 y,
151         uint256 denominator,
152         Rounding rounding
153     ) internal pure returns (uint256) {
154         uint256 result = mulDiv(x, y, denominator);
155         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
156             result += 1;
157         }
158         return result;
159     }
160 
161     /**
162      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
163      *
164      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
165      */
166     function sqrt(uint256 a) internal pure returns (uint256) {
167         if (a == 0) {
168             return 0;
169         }
170 
171         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
172         //
173         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
174         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
175         //
176         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
177         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
178         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
179         //
180         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
181         uint256 result = 1 << (log2(a) >> 1);
182 
183         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
184         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
185         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
186         // into the expected uint128 result.
187         unchecked {
188             result = (result + a / result) >> 1;
189             result = (result + a / result) >> 1;
190             result = (result + a / result) >> 1;
191             result = (result + a / result) >> 1;
192             result = (result + a / result) >> 1;
193             result = (result + a / result) >> 1;
194             result = (result + a / result) >> 1;
195             return min(result, a / result);
196         }
197     }
198 
199     /**
200      * @notice Calculates sqrt(a), following the selected rounding direction.
201      */
202     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
203         unchecked {
204             uint256 result = sqrt(a);
205             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
206         }
207     }
208 
209     /**
210      * @dev Return the log in base 2, rounded down, of a positive value.
211      * Returns 0 if given 0.
212      */
213     function log2(uint256 value) internal pure returns (uint256) {
214         uint256 result = 0;
215         unchecked {
216             if (value >> 128 > 0) {
217                 value >>= 128;
218                 result += 128;
219             }
220             if (value >> 64 > 0) {
221                 value >>= 64;
222                 result += 64;
223             }
224             if (value >> 32 > 0) {
225                 value >>= 32;
226                 result += 32;
227             }
228             if (value >> 16 > 0) {
229                 value >>= 16;
230                 result += 16;
231             }
232             if (value >> 8 > 0) {
233                 value >>= 8;
234                 result += 8;
235             }
236             if (value >> 4 > 0) {
237                 value >>= 4;
238                 result += 4;
239             }
240             if (value >> 2 > 0) {
241                 value >>= 2;
242                 result += 2;
243             }
244             if (value >> 1 > 0) {
245                 result += 1;
246             }
247         }
248         return result;
249     }
250 
251     /**
252      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
253      * Returns 0 if given 0.
254      */
255     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
256         unchecked {
257             uint256 result = log2(value);
258             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
259         }
260     }
261 
262     /**
263      * @dev Return the log in base 10, rounded down, of a positive value.
264      * Returns 0 if given 0.
265      */
266     function log10(uint256 value) internal pure returns (uint256) {
267         uint256 result = 0;
268         unchecked {
269             if (value >= 10**64) {
270                 value /= 10**64;
271                 result += 64;
272             }
273             if (value >= 10**32) {
274                 value /= 10**32;
275                 result += 32;
276             }
277             if (value >= 10**16) {
278                 value /= 10**16;
279                 result += 16;
280             }
281             if (value >= 10**8) {
282                 value /= 10**8;
283                 result += 8;
284             }
285             if (value >= 10**4) {
286                 value /= 10**4;
287                 result += 4;
288             }
289             if (value >= 10**2) {
290                 value /= 10**2;
291                 result += 2;
292             }
293             if (value >= 10**1) {
294                 result += 1;
295             }
296         }
297         return result;
298     }
299 
300     /**
301      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
302      * Returns 0 if given 0.
303      */
304     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
305         unchecked {
306             uint256 result = log10(value);
307             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
308         }
309     }
310 
311     /**
312      * @dev Return the log in base 256, rounded down, of a positive value.
313      * Returns 0 if given 0.
314      *
315      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
316      */
317     function log256(uint256 value) internal pure returns (uint256) {
318         uint256 result = 0;
319         unchecked {
320             if (value >> 128 > 0) {
321                 value >>= 128;
322                 result += 16;
323             }
324             if (value >> 64 > 0) {
325                 value >>= 64;
326                 result += 8;
327             }
328             if (value >> 32 > 0) {
329                 value >>= 32;
330                 result += 4;
331             }
332             if (value >> 16 > 0) {
333                 value >>= 16;
334                 result += 2;
335             }
336             if (value >> 8 > 0) {
337                 result += 1;
338             }
339         }
340         return result;
341     }
342 
343     /**
344      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
345      * Returns 0 if given 0.
346      */
347     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
348         unchecked {
349             uint256 result = log256(value);
350             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
351         }
352     }
353 }
354 
355 
356 /**
357  * @dev String operations.
358  */
359 library Strings {
360     bytes16 private constant _SYMBOLS = "0123456789abcdef";
361     uint8 private constant _ADDRESS_LENGTH = 20;
362 
363     /**
364      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
365      */
366     function toString(uint256 value) internal pure returns (string memory) {
367         unchecked {
368             uint256 length = Math.log10(value) + 1;
369             string memory buffer = new string(length);
370             uint256 ptr;
371             /// @solidity memory-safe-assembly
372             assembly {
373                 ptr := add(buffer, add(32, length))
374             }
375             while (true) {
376                 ptr--;
377                 /// @solidity memory-safe-assembly
378                 assembly {
379                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
380                 }
381                 value /= 10;
382                 if (value == 0) break;
383             }
384             return buffer;
385         }
386     }
387 
388     /**
389      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
390      */
391     function toHexString(uint256 value) internal pure returns (string memory) {
392         unchecked {
393             return toHexString(value, Math.log256(value) + 1);
394         }
395     }
396 
397     /**
398      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
399      */
400     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
401         bytes memory buffer = new bytes(2 * length + 2);
402         buffer[0] = "0";
403         buffer[1] = "x";
404         for (uint256 i = 2 * length + 1; i > 1; --i) {
405             buffer[i] = _SYMBOLS[value & 0xf];
406             value >>= 4;
407         }
408         require(value == 0, "Strings: hex length insufficient");
409         return string(buffer);
410     }
411 
412     /**
413      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
414      */
415     function toHexString(address addr) internal pure returns (string memory) {
416         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
417     }
418 }
419 
420 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
421 
422 
423 
424 
425 /**
426  * @dev Interface of the ERC20 standard as defined in the EIP.
427  */
428 interface IERC20 {
429     /**
430      * @dev Emitted when `value` tokens are moved from one account (`from`) to
431      * another (`to`).
432      *
433      * Note that `value` may be zero.
434      */
435     event Transfer(address indexed from, address indexed to, uint256 value);
436 
437     /**
438      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
439      * a call to {approve}. `value` is the new allowance.
440      */
441     event Approval(address indexed owner, address indexed spender, uint256 value);
442 
443     /**
444      * @dev Returns the amount of tokens in existence.
445      */
446     function totalSupply() external view returns (uint256);
447 
448     /**
449      * @dev Returns the amount of tokens owned by `account`.
450      */
451     function balanceOf(address account) external view returns (uint256);
452 
453     /**
454      * @dev Moves `amount` tokens from the caller's account to `to`.
455      *
456      * Returns a boolean value indicating whether the operation succeeded.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transfer(address to, uint256 amount) external returns (bool);
461 
462     /**
463      * @dev Returns the remaining number of tokens that `spender` will be
464      * allowed to spend on behalf of `owner` through {transferFrom}. This is
465      * zero by default.
466      *
467      * This value changes when {approve} or {transferFrom} are called.
468      */
469     function allowance(address owner, address spender) external view returns (uint256);
470 
471     /**
472      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
473      *
474      * Returns a boolean value indicating whether the operation succeeded.
475      *
476      * IMPORTANT: Beware that changing an allowance with this method brings the risk
477      * that someone may use both the old and the new allowance by unfortunate
478      * transaction ordering. One possible solution to mitigate this race
479      * condition is to first reduce the spender's allowance to 0 and set the
480      * desired value afterwards:
481      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
482      *
483      * Emits an {Approval} event.
484      */
485     function approve(address spender, uint256 amount) external returns (bool);
486 
487     /**
488      * @dev Moves `amount` tokens from `from` to `to` using the
489      * allowance mechanism. `amount` is then deducted from the caller's
490      * allowance.
491      *
492      * Returns a boolean value indicating whether the operation succeeded.
493      *
494      * Emits a {Transfer} event.
495      */
496     function transferFrom(address from, address to, uint256 amount) external returns (bool);
497 }
498 
499 
500 
501 
502 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
503 
504 
505 
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
509 
510 
511 
512 
513 
514 /**
515  * @dev Interface for the optional metadata functions from the ERC20 standard.
516  *
517  * _Available since v4.1._
518  */
519 interface IERC20Metadata is IERC20 {
520     /**
521      * @dev Returns the name of the token.
522      */
523     function name() external view returns (string memory);
524 
525     /**
526      * @dev Returns the symbol of the token.
527      */
528     function symbol() external view returns (string memory);
529 
530     /**
531      * @dev Returns the decimals places of the token.
532      */
533     function decimals() external view returns (uint8);
534 }
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
538 
539 
540 
541 /**
542  * @dev Provides information about the current execution context, including the
543  * sender of the transaction and its data. While these are generally available
544  * via msg.sender and msg.data, they should not be accessed in such a direct
545  * manner, since when dealing with meta-transactions the account sending and
546  * paying for execution may not be the actual sender (as far as an application
547  * is concerned).
548  *
549  * This contract is only required for intermediate, library-like contracts.
550  */
551 abstract contract Context {
552     function _msgSender() internal view virtual returns (address) {
553         return msg.sender;
554     }
555 
556     function _msgData() internal view virtual returns (bytes calldata) {
557         return msg.data;
558     }
559 }
560 
561 
562 /**
563  * @dev Implementation of the {IERC20} interface.
564  *
565  * This implementation is agnostic to the way tokens are created. This means
566  * that a supply mechanism has to be added in a derived contract using {_mint}.
567  * For a generic mechanism see {ERC20PresetMinterPauser}.
568  *
569  * TIP: For a detailed writeup see our guide
570  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
571  * to implement supply mechanisms].
572  *
573  * We have followed general OpenZeppelin Contracts guidelines: functions revert
574  * instead returning `false` on failure. This behavior is nonetheless
575  * conventional and does not conflict with the expectations of ERC20
576  * applications.
577  *
578  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
579  * This allows applications to reconstruct the allowance for all accounts just
580  * by listening to said events. Other implementations of the EIP may not emit
581  * these events, as it isn't required by the specification.
582  *
583  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
584  * functions have been added to mitigate the well-known issues around setting
585  * allowances. See {IERC20-approve}.
586  */
587 contract ERC20 is Context, IERC20, IERC20Metadata {
588     mapping(address => uint256) private _balances;
589 
590     mapping(address => mapping(address => uint256)) private _allowances;
591 
592     uint256 private _totalSupply;
593 
594     string private _name;
595     string private _symbol;
596 
597     /**
598      * @dev Sets the values for {name} and {symbol}.
599      *
600      * The default value of {decimals} is 18. To select a different value for
601      * {decimals} you should overload it.
602      *
603      * All two of these values are immutable: they can only be set once during
604      * construction.
605      */
606     constructor(string memory name_, string memory symbol_) {
607         _name = name_;
608         _symbol = symbol_;
609     }
610 
611     /**
612      * @dev Returns the name of the token.
613      */
614     function name() public view virtual override returns (string memory) {
615         return _name;
616     }
617 
618     /**
619      * @dev Returns the symbol of the token, usually a shorter version of the
620      * name.
621      */
622     function symbol() public view virtual override returns (string memory) {
623         return _symbol;
624     }
625 
626     /**
627      * @dev Returns the number of decimals used to get its user representation.
628      * For example, if `decimals` equals `2`, a balance of `505` tokens should
629      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
630      *
631      * Tokens usually opt for a value of 18, imitating the relationship between
632      * Ether and Wei. This is the value {ERC20} uses, unless this function is
633      * overridden;
634      *
635      * NOTE: This information is only used for _display_ purposes: it in
636      * no way affects any of the arithmetic of the contract, including
637      * {IERC20-balanceOf} and {IERC20-transfer}.
638      */
639     function decimals() public view virtual override returns (uint8) {
640         return 18;
641     }
642 
643     /**
644      * @dev See {IERC20-totalSupply}.
645      */
646     function totalSupply() public view virtual override returns (uint256) {
647         return _totalSupply;
648     }
649 
650     /**
651      * @dev See {IERC20-balanceOf}.
652      */
653     function balanceOf(address account) public view virtual override returns (uint256) {
654         return _balances[account];
655     }
656 
657     /**
658      * @dev See {IERC20-transfer}.
659      *
660      * Requirements:
661      *
662      * - `to` cannot be the zero address.
663      * - the caller must have a balance of at least `amount`.
664      */
665     function transfer(address to, uint256 amount) public virtual override returns (bool) {
666         address owner = _msgSender();
667         _transfer(owner, to, amount);
668         return true;
669     }
670 
671     /**
672      * @dev See {IERC20-allowance}.
673      */
674     function allowance(address owner, address spender) public view virtual override returns (uint256) {
675         return _allowances[owner][spender];
676     }
677 
678     /**
679      * @dev See {IERC20-approve}.
680      *
681      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
682      * `transferFrom`. This is semantically equivalent to an infinite approval.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      */
688     function approve(address spender, uint256 amount) public virtual override returns (bool) {
689         address owner = _msgSender();
690         _approve(owner, spender, amount);
691         return true;
692     }
693 
694     /**
695      * @dev See {IERC20-transferFrom}.
696      *
697      * Emits an {Approval} event indicating the updated allowance. This is not
698      * required by the EIP. See the note at the beginning of {ERC20}.
699      *
700      * NOTE: Does not update the allowance if the current allowance
701      * is the maximum `uint256`.
702      *
703      * Requirements:
704      *
705      * - `from` and `to` cannot be the zero address.
706      * - `from` must have a balance of at least `amount`.
707      * - the caller must have allowance for ``from``'s tokens of at least
708      * `amount`.
709      */
710     function transferFrom(
711         address from,
712         address to,
713         uint256 amount
714     ) public virtual override returns (bool) {
715         address spender = _msgSender();
716         _spendAllowance(from, spender, amount);
717         _transfer(from, to, amount);
718         return true;
719     }
720 
721     /**
722      * @dev Atomically increases the allowance granted to `spender` by the caller.
723      *
724      * This is an alternative to {approve} that can be used as a mitigation for
725      * problems described in {IERC20-approve}.
726      *
727      * Emits an {Approval} event indicating the updated allowance.
728      *
729      * Requirements:
730      *
731      * - `spender` cannot be the zero address.
732      */
733     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
734         address owner = _msgSender();
735         _approve(owner, spender, allowance(owner, spender) + addedValue);
736         return true;
737     }
738 
739     /**
740      * @dev Atomically decreases the allowance granted to `spender` by the caller.
741      *
742      * This is an alternative to {approve} that can be used as a mitigation for
743      * problems described in {IERC20-approve}.
744      *
745      * Emits an {Approval} event indicating the updated allowance.
746      *
747      * Requirements:
748      *
749      * - `spender` cannot be the zero address.
750      * - `spender` must have allowance for the caller of at least
751      * `subtractedValue`.
752      */
753     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
754         address owner = _msgSender();
755         uint256 currentAllowance = allowance(owner, spender);
756         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
757         unchecked {
758             _approve(owner, spender, currentAllowance - subtractedValue);
759         }
760 
761         return true;
762     }
763 
764     /**
765      * @dev Moves `amount` of tokens from `from` to `to`.
766      *
767      * This internal function is equivalent to {transfer}, and can be used to
768      * e.g. implement automatic token fees, slashing mechanisms, etc.
769      *
770      * Emits a {Transfer} event.
771      *
772      * Requirements:
773      *
774      * - `from` cannot be the zero address.
775      * - `to` cannot be the zero address.
776      * - `from` must have a balance of at least `amount`.
777      */
778     function _transfer(
779         address from,
780         address to,
781         uint256 amount
782     ) internal virtual {
783         require(from != address(0), "ERC20: transfer from the zero address");
784         require(to != address(0), "ERC20: transfer to the zero address");
785 
786         _beforeTokenTransfer(from, to, amount);
787 
788         uint256 fromBalance = _balances[from];
789         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
790         unchecked {
791             _balances[from] = fromBalance - amount;
792             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
793             // decrementing then incrementing.
794             _balances[to] += amount;
795         }
796 
797         emit Transfer(from, to, amount);
798 
799         _afterTokenTransfer(from, to, amount);
800     }
801 
802     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
803      * the total supply.
804      *
805      * Emits a {Transfer} event with `from` set to the zero address.
806      *
807      * Requirements:
808      *
809      * - `account` cannot be the zero address.
810      */
811     function _mint(address account, uint256 amount) internal virtual {
812         require(account != address(0), "ERC20: mint to the zero address");
813 
814         _beforeTokenTransfer(address(0), account, amount);
815 
816         _totalSupply += amount;
817         unchecked {
818             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
819             _balances[account] += amount;
820         }
821         emit Transfer(address(0), account, amount);
822 
823         _afterTokenTransfer(address(0), account, amount);
824     }
825 
826     /**
827      * @dev Destroys `amount` tokens from `account`, reducing the
828      * total supply.
829      *
830      * Emits a {Transfer} event with `to` set to the zero address.
831      *
832      * Requirements:
833      *
834      * - `account` cannot be the zero address.
835      * - `account` must have at least `amount` tokens.
836      */
837     function _burn(address account, uint256 amount) internal virtual {
838         require(account != address(0), "ERC20: burn from the zero address");
839 
840         _beforeTokenTransfer(account, address(0), amount);
841 
842         uint256 accountBalance = _balances[account];
843         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
844         unchecked {
845             _balances[account] = accountBalance - amount;
846             // Overflow not possible: amount <= accountBalance <= totalSupply.
847             _totalSupply -= amount;
848         }
849 
850         emit Transfer(account, address(0), amount);
851 
852         _afterTokenTransfer(account, address(0), amount);
853     }
854 
855     /**
856      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
857      *
858      * This internal function is equivalent to `approve`, and can be used to
859      * e.g. set automatic allowances for certain subsystems, etc.
860      *
861      * Emits an {Approval} event.
862      *
863      * Requirements:
864      *
865      * - `owner` cannot be the zero address.
866      * - `spender` cannot be the zero address.
867      */
868     function _approve(
869         address owner,
870         address spender,
871         uint256 amount
872     ) internal virtual {
873         require(owner != address(0), "ERC20: approve from the zero address");
874         require(spender != address(0), "ERC20: approve to the zero address");
875 
876         _allowances[owner][spender] = amount;
877         emit Approval(owner, spender, amount);
878     }
879 
880     /**
881      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
882      *
883      * Does not update the allowance amount in case of infinite allowance.
884      * Revert if not enough allowance is available.
885      *
886      * Might emit an {Approval} event.
887      */
888     function _spendAllowance(
889         address owner,
890         address spender,
891         uint256 amount
892     ) internal virtual {
893         uint256 currentAllowance = allowance(owner, spender);
894         if (currentAllowance != type(uint256).max) {
895             require(currentAllowance >= amount, "ERC20: insufficient allowance");
896             unchecked {
897                 _approve(owner, spender, currentAllowance - amount);
898             }
899         }
900     }
901 
902     /**
903      * @dev Hook that is called before any transfer of tokens. This includes
904      * minting and burning.
905      *
906      * Calling conditions:
907      *
908      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
909      * will be transferred to `to`.
910      * - when `from` is zero, `amount` tokens will be minted for `to`.
911      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
912      * - `from` and `to` are never both zero.
913      *
914      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
915      */
916     function _beforeTokenTransfer(
917         address from,
918         address to,
919         uint256 amount
920     ) internal virtual {}
921 
922     /**
923      * @dev Hook that is called after any transfer of tokens. This includes
924      * minting and burning.
925      *
926      * Calling conditions:
927      *
928      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
929      * has been transferred to `to`.
930      * - when `from` is zero, `amount` tokens have been minted for `to`.
931      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
932      * - `from` and `to` are never both zero.
933      *
934      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
935      */
936     function _afterTokenTransfer(
937         address from,
938         address to,
939         uint256 amount
940     ) internal virtual {}
941 }
942 
943 
944 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/extensions/draft-ERC20Permit.sol)
945 
946 
947 
948 
949 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
950 
951 
952 
953 /**
954  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
955  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
956  *
957  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
958  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
959  * need to send a transaction, and thus is not required to hold Ether at all.
960  */
961 interface IERC20Permit {
962     /**
963      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
964      * given ``owner``'s signed approval.
965      *
966      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
967      * ordering also apply here.
968      *
969      * Emits an {Approval} event.
970      *
971      * Requirements:
972      *
973      * - `spender` cannot be the zero address.
974      * - `deadline` must be a timestamp in the future.
975      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
976      * over the EIP712-formatted function arguments.
977      * - the signature must use ``owner``'s current nonce (see {nonces}).
978      *
979      * For more information on the signature format, see the
980      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
981      * section].
982      */
983     function permit(
984         address owner,
985         address spender,
986         uint256 value,
987         uint256 deadline,
988         uint8 v,
989         bytes32 r,
990         bytes32 s
991     ) external;
992 
993     /**
994      * @dev Returns the current nonce for `owner`. This value must be
995      * included whenever a signature is generated for {permit}.
996      *
997      * Every successful call to {permit} increases ``owner``'s nonce by one. This
998      * prevents a signature from being used multiple times.
999      */
1000     function nonces(address owner) external view returns (uint256);
1001 
1002     /**
1003      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1004      */
1005     // solhint-disable-next-line func-name-mixedcase
1006     function DOMAIN_SEPARATOR() external view returns (bytes32);
1007 }
1008 
1009 
1010 
1011 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1012 
1013 
1014 
1015 
1016 
1017 /**
1018  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1019  *
1020  * These functions can be used to verify that a message was signed by the holder
1021  * of the private keys of a given address.
1022  */
1023 library ECDSA {
1024     enum RecoverError {
1025         NoError,
1026         InvalidSignature,
1027         InvalidSignatureLength,
1028         InvalidSignatureS,
1029         InvalidSignatureV // Deprecated in v4.8
1030     }
1031 
1032     function _throwError(RecoverError error) private pure {
1033         if (error == RecoverError.NoError) {
1034             return; // no error: do nothing
1035         } else if (error == RecoverError.InvalidSignature) {
1036             revert("ECDSA: invalid signature");
1037         } else if (error == RecoverError.InvalidSignatureLength) {
1038             revert("ECDSA: invalid signature length");
1039         } else if (error == RecoverError.InvalidSignatureS) {
1040             revert("ECDSA: invalid signature 's' value");
1041         }
1042     }
1043 
1044     /**
1045      * @dev Returns the address that signed a hashed message (`hash`) with
1046      * `signature` or error string. This address can then be used for verification purposes.
1047      *
1048      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1049      * this function rejects them by requiring the `s` value to be in the lower
1050      * half order, and the `v` value to be either 27 or 28.
1051      *
1052      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1053      * verification to be secure: it is possible to craft signatures that
1054      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1055      * this is by receiving a hash of the original message (which may otherwise
1056      * be too long), and then calling {toEthSignedMessageHash} on it.
1057      *
1058      * Documentation for signature generation:
1059      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1060      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1061      *
1062      * _Available since v4.3._
1063      */
1064     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1065         if (signature.length == 65) {
1066             bytes32 r;
1067             bytes32 s;
1068             uint8 v;
1069             // ecrecover takes the signature parameters, and the only way to get them
1070             // currently is to use assembly.
1071             /// @solidity memory-safe-assembly
1072             assembly {
1073                 r := mload(add(signature, 0x20))
1074                 s := mload(add(signature, 0x40))
1075                 v := byte(0, mload(add(signature, 0x60)))
1076             }
1077             return tryRecover(hash, v, r, s);
1078         } else {
1079             return (address(0), RecoverError.InvalidSignatureLength);
1080         }
1081     }
1082 
1083     /**
1084      * @dev Returns the address that signed a hashed message (`hash`) with
1085      * `signature`. This address can then be used for verification purposes.
1086      *
1087      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1088      * this function rejects them by requiring the `s` value to be in the lower
1089      * half order, and the `v` value to be either 27 or 28.
1090      *
1091      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1092      * verification to be secure: it is possible to craft signatures that
1093      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1094      * this is by receiving a hash of the original message (which may otherwise
1095      * be too long), and then calling {toEthSignedMessageHash} on it.
1096      */
1097     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1098         (address recovered, RecoverError error) = tryRecover(hash, signature);
1099         _throwError(error);
1100         return recovered;
1101     }
1102 
1103     /**
1104      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1105      *
1106      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1107      *
1108      * _Available since v4.3._
1109      */
1110     function tryRecover(
1111         bytes32 hash,
1112         bytes32 r,
1113         bytes32 vs
1114     ) internal pure returns (address, RecoverError) {
1115         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1116         uint8 v = uint8((uint256(vs) >> 255) + 27);
1117         return tryRecover(hash, v, r, s);
1118     }
1119 
1120     /**
1121      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1122      *
1123      * _Available since v4.2._
1124      */
1125     function recover(
1126         bytes32 hash,
1127         bytes32 r,
1128         bytes32 vs
1129     ) internal pure returns (address) {
1130         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1131         _throwError(error);
1132         return recovered;
1133     }
1134 
1135     /**
1136      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1137      * `r` and `s` signature fields separately.
1138      *
1139      * _Available since v4.3._
1140      */
1141     function tryRecover(
1142         bytes32 hash,
1143         uint8 v,
1144         bytes32 r,
1145         bytes32 s
1146     ) internal pure returns (address, RecoverError) {
1147         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1148         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1149         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1150         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1151         //
1152         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1153         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1154         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1155         // these malleable signatures as well.
1156         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1157             return (address(0), RecoverError.InvalidSignatureS);
1158         }
1159 
1160         // If the signature is valid (and not malleable), return the signer address
1161         address signer = ecrecover(hash, v, r, s);
1162         if (signer == address(0)) {
1163             return (address(0), RecoverError.InvalidSignature);
1164         }
1165 
1166         return (signer, RecoverError.NoError);
1167     }
1168 
1169     /**
1170      * @dev Overload of {ECDSA-recover} that receives the `v`,
1171      * `r` and `s` signature fields separately.
1172      */
1173     function recover(
1174         bytes32 hash,
1175         uint8 v,
1176         bytes32 r,
1177         bytes32 s
1178     ) internal pure returns (address) {
1179         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1180         _throwError(error);
1181         return recovered;
1182     }
1183 
1184     /**
1185      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1186      * produces hash corresponding to the one signed with the
1187      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1188      * JSON-RPC method as part of EIP-191.
1189      *
1190      * See {recover}.
1191      */
1192     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1193         // 32 is the length in bytes of hash,
1194         // enforced by the type signature above
1195         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1196     }
1197 
1198     /**
1199      * @dev Returns an Ethereum Signed Message, created from `s`. This
1200      * produces hash corresponding to the one signed with the
1201      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1202      * JSON-RPC method as part of EIP-191.
1203      *
1204      * See {recover}.
1205      */
1206     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1207         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1208     }
1209 
1210     /**
1211      * @dev Returns an Ethereum Signed Typed Data, created from a
1212      * `domainSeparator` and a `structHash`. This produces hash corresponding
1213      * to the one signed with the
1214      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1215      * JSON-RPC method as part of EIP-712.
1216      *
1217      * See {recover}.
1218      */
1219     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1220         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1221     }
1222 }
1223 
1224 
1225 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
1226 
1227 
1228 
1229 
1230 
1231 /**
1232  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1233  *
1234  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1235  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1236  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1237  *
1238  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1239  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1240  * ({_hashTypedDataV4}).
1241  *
1242  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1243  * the chain id to protect against replay attacks on an eventual fork of the chain.
1244  *
1245  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1246  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1247  *
1248  * _Available since v3.4._
1249  */
1250 abstract contract EIP712 {
1251     /* solhint-disable var-name-mixedcase */
1252     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1253     // invalidate the cached domain separator if the chain id changes.
1254     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1255     uint256 private immutable _CACHED_CHAIN_ID;
1256     address private immutable _CACHED_THIS;
1257 
1258     bytes32 private immutable _HASHED_NAME;
1259     bytes32 private immutable _HASHED_VERSION;
1260     bytes32 private immutable _TYPE_HASH;
1261 
1262     /* solhint-enable var-name-mixedcase */
1263 
1264     /**
1265      * @dev Initializes the domain separator and parameter caches.
1266      *
1267      * The meaning of `name` and `version` is specified in
1268      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1269      *
1270      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1271      * - `version`: the current major version of the signing domain.
1272      *
1273      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1274      * contract upgrade].
1275      */
1276     constructor(string memory name, string memory version) {
1277         bytes32 hashedName = keccak256(bytes(name));
1278         bytes32 hashedVersion = keccak256(bytes(version));
1279         bytes32 typeHash = keccak256(
1280             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1281         );
1282         _HASHED_NAME = hashedName;
1283         _HASHED_VERSION = hashedVersion;
1284         _CACHED_CHAIN_ID = block.chainid;
1285         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1286         _CACHED_THIS = address(this);
1287         _TYPE_HASH = typeHash;
1288     }
1289 
1290     /**
1291      * @dev Returns the domain separator for the current chain.
1292      */
1293     function _domainSeparatorV4() internal view returns (bytes32) {
1294         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1295             return _CACHED_DOMAIN_SEPARATOR;
1296         } else {
1297             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1298         }
1299     }
1300 
1301     function _buildDomainSeparator(
1302         bytes32 typeHash,
1303         bytes32 nameHash,
1304         bytes32 versionHash
1305     ) private view returns (bytes32) {
1306         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1307     }
1308 
1309     /**
1310      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1311      * function returns the hash of the fully encoded EIP712 message for this domain.
1312      *
1313      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1314      *
1315      * ```solidity
1316      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1317      *     keccak256("Mail(address to,string contents)"),
1318      *     mailTo,
1319      *     keccak256(bytes(mailContents))
1320      * )));
1321      * address signer = ECDSA.recover(digest, signature);
1322      * ```
1323      */
1324     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1325         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1326     }
1327 }
1328 
1329 
1330 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1331 
1332 
1333 
1334 /**
1335  * @title Counters
1336  * @author Matt Condon (@shrugs)
1337  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1338  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1339  *
1340  * Include with `using Counters for Counters.Counter;`
1341  */
1342 library Counters {
1343     struct Counter {
1344         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1345         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1346         // this feature: see https://github.com/ethereum/solidity/issues/4637
1347         uint256 _value; // default: 0
1348     }
1349 
1350     function current(Counter storage counter) internal view returns (uint256) {
1351         return counter._value;
1352     }
1353 
1354     function increment(Counter storage counter) internal {
1355         unchecked {
1356             counter._value += 1;
1357         }
1358     }
1359 
1360     function decrement(Counter storage counter) internal {
1361         uint256 value = counter._value;
1362         require(value > 0, "Counter: decrement overflow");
1363         unchecked {
1364             counter._value = value - 1;
1365         }
1366     }
1367 
1368     function reset(Counter storage counter) internal {
1369         counter._value = 0;
1370     }
1371 }
1372 
1373 
1374 /**
1375  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1376  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1377  *
1378  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1379  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1380  * need to send a transaction, and thus is not required to hold Ether at all.
1381  *
1382  * _Available since v3.4._
1383  */
1384 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1385     using Counters for Counters.Counter;
1386 
1387     mapping(address => Counters.Counter) private _nonces;
1388 
1389     // solhint-disable-next-line var-name-mixedcase
1390     bytes32 private constant _PERMIT_TYPEHASH =
1391         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1392     /**
1393      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
1394      * However, to ensure consistency with the upgradeable transpiler, we will continue
1395      * to reserve a slot.
1396      * @custom:oz-renamed-from _PERMIT_TYPEHASH
1397      */
1398     // solhint-disable-next-line var-name-mixedcase
1399     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
1400 
1401     /**
1402      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1403      *
1404      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1405      */
1406     constructor(string memory name) EIP712(name, "1") {}
1407 
1408     /**
1409      * @dev See {IERC20Permit-permit}.
1410      */
1411     function permit(
1412         address owner,
1413         address spender,
1414         uint256 value,
1415         uint256 deadline,
1416         uint8 v,
1417         bytes32 r,
1418         bytes32 s
1419     ) public virtual override {
1420         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1421 
1422         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1423 
1424         bytes32 hash = _hashTypedDataV4(structHash);
1425 
1426         address signer = ECDSA.recover(hash, v, r, s);
1427         require(signer == owner, "ERC20Permit: invalid signature");
1428 
1429         _approve(owner, spender, value);
1430     }
1431 
1432     /**
1433      * @dev See {IERC20Permit-nonces}.
1434      */
1435     function nonces(address owner) public view virtual override returns (uint256) {
1436         return _nonces[owner].current();
1437     }
1438 
1439     /**
1440      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1441      */
1442     // solhint-disable-next-line func-name-mixedcase
1443     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1444         return _domainSeparatorV4();
1445     }
1446 
1447     /**
1448      * @dev "Consume a nonce": return the current value and increment.
1449      *
1450      * _Available since v4.1._
1451      */
1452     function _useNonce(address owner) internal virtual returns (uint256 current) {
1453         Counters.Counter storage nonce = _nonces[owner];
1454         current = nonce.current();
1455         nonce.increment();
1456     }
1457 }
1458 
1459 
1460 contract THEONE is ERC20, ERC20Permit {
1461     constructor() ERC20("THEONE", "THE ONE") ERC20Permit("THE ONE") {
1462         _mint(msg.sender, 1 * 10 ** decimals());
1463     }
1464 }