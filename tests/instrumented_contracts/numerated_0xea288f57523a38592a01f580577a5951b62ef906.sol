1 // File: code-sample/KawaiiRobot/interfaces/IToken.sol
2 
3 
4 
5 /// @title IToken interface
6 
7 pragma solidity ^0.8.6;
8 
9 interface IToken {
10     function mintAdmin(uint256 quantity, address to) external;
11 }
12 // File: code-sample/KawaiiRobot/interfaces/IDescriptor.sol
13 
14 
15 
16 /// @title IDescriptor interface
17 
18 pragma solidity ^0.8.6;
19 
20 interface IDescriptor {
21     function tokenURI(uint256 tokenId) external view returns (string memory);
22 }
23 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
24 
25 
26 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
32  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
33  *
34  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
35  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
36  * need to send a transaction, and thus is not required to hold Ether at all.
37  */
38 interface IERC20Permit {
39     /**
40      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
41      * given ``owner``'s signed approval.
42      *
43      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
44      * ordering also apply here.
45      *
46      * Emits an {Approval} event.
47      *
48      * Requirements:
49      *
50      * - `spender` cannot be the zero address.
51      * - `deadline` must be a timestamp in the future.
52      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
53      * over the EIP712-formatted function arguments.
54      * - the signature must use ``owner``'s current nonce (see {nonces}).
55      *
56      * For more information on the signature format, see the
57      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
58      * section].
59      */
60     function permit(
61         address owner,
62         address spender,
63         uint256 value,
64         uint256 deadline,
65         uint8 v,
66         bytes32 r,
67         bytes32 s
68     ) external;
69 
70     /**
71      * @dev Returns the current nonce for `owner`. This value must be
72      * included whenever a signature is generated for {permit}.
73      *
74      * Every successful call to {permit} increases ``owner``'s nonce by one. This
75      * prevents a signature from being used multiple times.
76      */
77     function nonces(address owner) external view returns (uint256);
78 
79     /**
80      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
81      */
82     // solhint-disable-next-line func-name-mixedcase
83     function DOMAIN_SEPARATOR() external view returns (bytes32);
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
87 
88 
89 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Interface of the ERC20 standard as defined in the EIP.
95  */
96 interface IERC20 {
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `to`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address to, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `from` to `to` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(
165         address from,
166         address to,
167         uint256 amount
168     ) external returns (bool);
169 }
170 
171 // File: @openzeppelin/contracts/utils/math/Math.sol
172 
173 
174 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (utils/math/Math.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev Standard math utilities missing in the Solidity language.
180  */
181 library Math {
182     enum Rounding {
183         Down, // Toward negative infinity
184         Up, // Toward infinity
185         Zero // Toward zero
186     }
187 
188     /**
189      * @dev Returns the largest of two numbers.
190      */
191     function max(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a > b ? a : b;
193     }
194 
195     /**
196      * @dev Returns the smallest of two numbers.
197      */
198     function min(uint256 a, uint256 b) internal pure returns (uint256) {
199         return a < b ? a : b;
200     }
201 
202     /**
203      * @dev Returns the average of two numbers. The result is rounded towards
204      * zero.
205      */
206     function average(uint256 a, uint256 b) internal pure returns (uint256) {
207         // (a + b) / 2 can overflow.
208         return (a & b) + (a ^ b) / 2;
209     }
210 
211     /**
212      * @dev Returns the ceiling of the division of two numbers.
213      *
214      * This differs from standard division with `/` in that it rounds up instead
215      * of rounding down.
216      */
217     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
218         // (a + b - 1) / b can overflow on addition, so we distribute.
219         return a == 0 ? 0 : (a - 1) / b + 1;
220     }
221 
222     /**
223      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
224      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
225      * with further edits by Uniswap Labs also under MIT license.
226      */
227     function mulDiv(
228         uint256 x,
229         uint256 y,
230         uint256 denominator
231     ) internal pure returns (uint256 result) {
232         unchecked {
233             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
234             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
235             // variables such that product = prod1 * 2^256 + prod0.
236             uint256 prod0; // Least significant 256 bits of the product
237             uint256 prod1; // Most significant 256 bits of the product
238             assembly {
239                 let mm := mulmod(x, y, not(0))
240                 prod0 := mul(x, y)
241                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
242             }
243 
244             // Handle non-overflow cases, 256 by 256 division.
245             if (prod1 == 0) {
246                 return prod0 / denominator;
247             }
248 
249             // Make sure the result is less than 2^256. Also prevents denominator == 0.
250             require(denominator > prod1);
251 
252             ///////////////////////////////////////////////
253             // 512 by 256 division.
254             ///////////////////////////////////////////////
255 
256             // Make division exact by subtracting the remainder from [prod1 prod0].
257             uint256 remainder;
258             assembly {
259                 // Compute remainder using mulmod.
260                 remainder := mulmod(x, y, denominator)
261 
262                 // Subtract 256 bit number from 512 bit number.
263                 prod1 := sub(prod1, gt(remainder, prod0))
264                 prod0 := sub(prod0, remainder)
265             }
266 
267             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
268             // See https://cs.stackexchange.com/q/138556/92363.
269 
270             // Does not overflow because the denominator cannot be zero at this stage in the function.
271             uint256 twos = denominator & (~denominator + 1);
272             assembly {
273                 // Divide denominator by twos.
274                 denominator := div(denominator, twos)
275 
276                 // Divide [prod1 prod0] by twos.
277                 prod0 := div(prod0, twos)
278 
279                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
280                 twos := add(div(sub(0, twos), twos), 1)
281             }
282 
283             // Shift in bits from prod1 into prod0.
284             prod0 |= prod1 * twos;
285 
286             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
287             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
288             // four bits. That is, denominator * inv = 1 mod 2^4.
289             uint256 inverse = (3 * denominator) ^ 2;
290 
291             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
292             // in modular arithmetic, doubling the correct bits in each step.
293             inverse *= 2 - denominator * inverse; // inverse mod 2^8
294             inverse *= 2 - denominator * inverse; // inverse mod 2^16
295             inverse *= 2 - denominator * inverse; // inverse mod 2^32
296             inverse *= 2 - denominator * inverse; // inverse mod 2^64
297             inverse *= 2 - denominator * inverse; // inverse mod 2^128
298             inverse *= 2 - denominator * inverse; // inverse mod 2^256
299 
300             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
301             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
302             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
303             // is no longer required.
304             result = prod0 * inverse;
305             return result;
306         }
307     }
308 
309     /**
310      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
311      */
312     function mulDiv(
313         uint256 x,
314         uint256 y,
315         uint256 denominator,
316         Rounding rounding
317     ) internal pure returns (uint256) {
318         uint256 result = mulDiv(x, y, denominator);
319         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
320             result += 1;
321         }
322         return result;
323     }
324 
325     /**
326      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
327      *
328      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
329      */
330     function sqrt(uint256 a) internal pure returns (uint256) {
331         if (a == 0) {
332             return 0;
333         }
334 
335         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
336         //
337         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
338         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
339         //
340         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
341         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
342         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
343         //
344         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
345         uint256 result = 1 << (log2(a) >> 1);
346 
347         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
348         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
349         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
350         // into the expected uint128 result.
351         unchecked {
352             result = (result + a / result) >> 1;
353             result = (result + a / result) >> 1;
354             result = (result + a / result) >> 1;
355             result = (result + a / result) >> 1;
356             result = (result + a / result) >> 1;
357             result = (result + a / result) >> 1;
358             result = (result + a / result) >> 1;
359             return min(result, a / result);
360         }
361     }
362 
363     /**
364      * @notice Calculates sqrt(a), following the selected rounding direction.
365      */
366     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
367         unchecked {
368             uint256 result = sqrt(a);
369             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
370         }
371     }
372 
373     /**
374      * @dev Return the log in base 2, rounded down, of a positive value.
375      * Returns 0 if given 0.
376      */
377     function log2(uint256 value) internal pure returns (uint256) {
378         uint256 result = 0;
379         unchecked {
380             if (value >> 128 > 0) {
381                 value >>= 128;
382                 result += 128;
383             }
384             if (value >> 64 > 0) {
385                 value >>= 64;
386                 result += 64;
387             }
388             if (value >> 32 > 0) {
389                 value >>= 32;
390                 result += 32;
391             }
392             if (value >> 16 > 0) {
393                 value >>= 16;
394                 result += 16;
395             }
396             if (value >> 8 > 0) {
397                 value >>= 8;
398                 result += 8;
399             }
400             if (value >> 4 > 0) {
401                 value >>= 4;
402                 result += 4;
403             }
404             if (value >> 2 > 0) {
405                 value >>= 2;
406                 result += 2;
407             }
408             if (value >> 1 > 0) {
409                 result += 1;
410             }
411         }
412         return result;
413     }
414 
415     /**
416      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
417      * Returns 0 if given 0.
418      */
419     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
420         unchecked {
421             uint256 result = log2(value);
422             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
423         }
424     }
425 
426     /**
427      * @dev Return the log in base 10, rounded down, of a positive value.
428      * Returns 0 if given 0.
429      */
430     function log10(uint256 value) internal pure returns (uint256) {
431         uint256 result = 0;
432         unchecked {
433             if (value >= 10**64) {
434                 value /= 10**64;
435                 result += 64;
436             }
437             if (value >= 10**32) {
438                 value /= 10**32;
439                 result += 32;
440             }
441             if (value >= 10**16) {
442                 value /= 10**16;
443                 result += 16;
444             }
445             if (value >= 10**8) {
446                 value /= 10**8;
447                 result += 8;
448             }
449             if (value >= 10**4) {
450                 value /= 10**4;
451                 result += 4;
452             }
453             if (value >= 10**2) {
454                 value /= 10**2;
455                 result += 2;
456             }
457             if (value >= 10**1) {
458                 result += 1;
459             }
460         }
461         return result;
462     }
463 
464     /**
465      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
466      * Returns 0 if given 0.
467      */
468     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
469         unchecked {
470             uint256 result = log10(value);
471             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
472         }
473     }
474 
475     /**
476      * @dev Return the log in base 256, rounded down, of a positive value.
477      * Returns 0 if given 0.
478      *
479      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
480      */
481     function log256(uint256 value) internal pure returns (uint256) {
482         uint256 result = 0;
483         unchecked {
484             if (value >> 128 > 0) {
485                 value >>= 128;
486                 result += 16;
487             }
488             if (value >> 64 > 0) {
489                 value >>= 64;
490                 result += 8;
491             }
492             if (value >> 32 > 0) {
493                 value >>= 32;
494                 result += 4;
495             }
496             if (value >> 16 > 0) {
497                 value >>= 16;
498                 result += 2;
499             }
500             if (value >> 8 > 0) {
501                 result += 1;
502             }
503         }
504         return result;
505     }
506 
507     /**
508      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
509      * Returns 0 if given 0.
510      */
511     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
512         unchecked {
513             uint256 result = log256(value);
514             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
515         }
516     }
517 }
518 
519 // File: @openzeppelin/contracts/utils/Strings.sol
520 
521 
522 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (utils/Strings.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 
527 /**
528  * @dev String operations.
529  */
530 library Strings {
531     bytes16 private constant _SYMBOLS = "0123456789abcdef";
532     uint8 private constant _ADDRESS_LENGTH = 20;
533 
534     /**
535      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
536      */
537     function toString(uint256 value) internal pure returns (string memory) {
538         unchecked {
539             uint256 length = Math.log10(value) + 1;
540             string memory buffer = new string(length);
541             uint256 ptr;
542             /// @solidity memory-safe-assembly
543             assembly {
544                 ptr := add(buffer, add(32, length))
545             }
546             while (true) {
547                 ptr--;
548                 /// @solidity memory-safe-assembly
549                 assembly {
550                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
551                 }
552                 value /= 10;
553                 if (value == 0) break;
554             }
555             return buffer;
556         }
557     }
558 
559     /**
560      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
561      */
562     function toHexString(uint256 value) internal pure returns (string memory) {
563         unchecked {
564             return toHexString(value, Math.log256(value) + 1);
565         }
566     }
567 
568     /**
569      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
570      */
571     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
572         bytes memory buffer = new bytes(2 * length + 2);
573         buffer[0] = "0";
574         buffer[1] = "x";
575         for (uint256 i = 2 * length + 1; i > 1; --i) {
576             buffer[i] = _SYMBOLS[value & 0xf];
577             value >>= 4;
578         }
579         require(value == 0, "Strings: hex length insufficient");
580         return string(buffer);
581     }
582 
583     /**
584      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
585      */
586     function toHexString(address addr) internal pure returns (string memory) {
587         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
588     }
589 }
590 
591 // File: @openzeppelin/contracts/utils/Address.sol
592 
593 
594 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (utils/Address.sol)
595 
596 pragma solidity ^0.8.1;
597 
598 /**
599  * @dev Collection of functions related to the address type
600  */
601 library Address {
602     /**
603      * @dev Returns true if `account` is a contract.
604      *
605      * [IMPORTANT]
606      * ====
607      * It is unsafe to assume that an address for which this function returns
608      * false is an externally-owned account (EOA) and not a contract.
609      *
610      * Among others, `isContract` will return false for the following
611      * types of addresses:
612      *
613      *  - an externally-owned account
614      *  - a contract in construction
615      *  - an address where a contract will be created
616      *  - an address where a contract lived, but was destroyed
617      * ====
618      *
619      * [IMPORTANT]
620      * ====
621      * You shouldn't rely on `isContract` to protect against flash loan attacks!
622      *
623      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
624      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
625      * constructor.
626      * ====
627      */
628     function isContract(address account) internal view returns (bool) {
629         // This method relies on extcodesize/address.code.length, which returns 0
630         // for contracts in construction, since the code is only stored at the end
631         // of the constructor execution.
632 
633         return account.code.length > 0;
634     }
635 
636     /**
637      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
638      * `recipient`, forwarding all available gas and reverting on errors.
639      *
640      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
641      * of certain opcodes, possibly making contracts go over the 2300 gas limit
642      * imposed by `transfer`, making them unable to receive funds via
643      * `transfer`. {sendValue} removes this limitation.
644      *
645      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
646      *
647      * IMPORTANT: because control is transferred to `recipient`, care must be
648      * taken to not create reentrancy vulnerabilities. Consider using
649      * {ReentrancyGuard} or the
650      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
651      */
652     function sendValue(address payable recipient, uint256 amount) internal {
653         require(address(this).balance >= amount, "Address: insufficient balance");
654 
655         (bool success, ) = recipient.call{value: amount}("");
656         require(success, "Address: unable to send value, recipient may have reverted");
657     }
658 
659     /**
660      * @dev Performs a Solidity function call using a low level `call`. A
661      * plain `call` is an unsafe replacement for a function call: use this
662      * function instead.
663      *
664      * If `target` reverts with a revert reason, it is bubbled up by this
665      * function (like regular Solidity function calls).
666      *
667      * Returns the raw returned data. To convert to the expected return value,
668      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
669      *
670      * Requirements:
671      *
672      * - `target` must be a contract.
673      * - calling `target` with `data` must not revert.
674      *
675      * _Available since v3.1._
676      */
677     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
678         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
683      * `errorMessage` as a fallback revert reason when `target` reverts.
684      *
685      * _Available since v3.1._
686      */
687     function functionCall(
688         address target,
689         bytes memory data,
690         string memory errorMessage
691     ) internal returns (bytes memory) {
692         return functionCallWithValue(target, data, 0, errorMessage);
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
697      * but also transferring `value` wei to `target`.
698      *
699      * Requirements:
700      *
701      * - the calling contract must have an ETH balance of at least `value`.
702      * - the called Solidity function must be `payable`.
703      *
704      * _Available since v3.1._
705      */
706     function functionCallWithValue(
707         address target,
708         bytes memory data,
709         uint256 value
710     ) internal returns (bytes memory) {
711         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
716      * with `errorMessage` as a fallback revert reason when `target` reverts.
717      *
718      * _Available since v3.1._
719      */
720     function functionCallWithValue(
721         address target,
722         bytes memory data,
723         uint256 value,
724         string memory errorMessage
725     ) internal returns (bytes memory) {
726         require(address(this).balance >= value, "Address: insufficient balance for call");
727         (bool success, bytes memory returndata) = target.call{value: value}(data);
728         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
733      * but performing a static call.
734      *
735      * _Available since v3.3._
736      */
737     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
738         return functionStaticCall(target, data, "Address: low-level static call failed");
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
743      * but performing a static call.
744      *
745      * _Available since v3.3._
746      */
747     function functionStaticCall(
748         address target,
749         bytes memory data,
750         string memory errorMessage
751     ) internal view returns (bytes memory) {
752         (bool success, bytes memory returndata) = target.staticcall(data);
753         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
754     }
755 
756     /**
757      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
758      * but performing a delegate call.
759      *
760      * _Available since v3.4._
761      */
762     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
763         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
764     }
765 
766     /**
767      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
768      * but performing a delegate call.
769      *
770      * _Available since v3.4._
771      */
772     function functionDelegateCall(
773         address target,
774         bytes memory data,
775         string memory errorMessage
776     ) internal returns (bytes memory) {
777         (bool success, bytes memory returndata) = target.delegatecall(data);
778         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
779     }
780 
781     /**
782      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
783      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
784      *
785      * _Available since v4.8._
786      */
787     function verifyCallResultFromTarget(
788         address target,
789         bool success,
790         bytes memory returndata,
791         string memory errorMessage
792     ) internal view returns (bytes memory) {
793         if (success) {
794             if (returndata.length == 0) {
795                 // only check isContract if the call was successful and the return data is empty
796                 // otherwise we already know that it was a contract
797                 require(isContract(target), "Address: call to non-contract");
798             }
799             return returndata;
800         } else {
801             _revert(returndata, errorMessage);
802         }
803     }
804 
805     /**
806      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
807      * revert reason or using the provided one.
808      *
809      * _Available since v4.3._
810      */
811     function verifyCallResult(
812         bool success,
813         bytes memory returndata,
814         string memory errorMessage
815     ) internal pure returns (bytes memory) {
816         if (success) {
817             return returndata;
818         } else {
819             _revert(returndata, errorMessage);
820         }
821     }
822 
823     function _revert(bytes memory returndata, string memory errorMessage) private pure {
824         // Look for revert reason and bubble it up if present
825         if (returndata.length > 0) {
826             // The easiest way to bubble the revert reason is using memory via assembly
827             /// @solidity memory-safe-assembly
828             assembly {
829                 let returndata_size := mload(returndata)
830                 revert(add(32, returndata), returndata_size)
831             }
832         } else {
833             revert(errorMessage);
834         }
835     }
836 }
837 
838 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
839 
840 
841 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
842 
843 pragma solidity ^0.8.0;
844 
845 
846 
847 
848 /**
849  * @title SafeERC20
850  * @dev Wrappers around ERC20 operations that throw on failure (when the token
851  * contract returns false). Tokens that return no value (and instead revert or
852  * throw on failure) are also supported, non-reverting calls are assumed to be
853  * successful.
854  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
855  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
856  */
857 library SafeERC20 {
858     using Address for address;
859 
860     function safeTransfer(
861         IERC20 token,
862         address to,
863         uint256 value
864     ) internal {
865         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
866     }
867 
868     function safeTransferFrom(
869         IERC20 token,
870         address from,
871         address to,
872         uint256 value
873     ) internal {
874         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
875     }
876 
877     /**
878      * @dev Deprecated. This function has issues similar to the ones found in
879      * {IERC20-approve}, and its usage is discouraged.
880      *
881      * Whenever possible, use {safeIncreaseAllowance} and
882      * {safeDecreaseAllowance} instead.
883      */
884     function safeApprove(
885         IERC20 token,
886         address spender,
887         uint256 value
888     ) internal {
889         // safeApprove should only be called when setting an initial allowance,
890         // or when resetting it to zero. To increase and decrease it, use
891         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
892         require(
893             (value == 0) || (token.allowance(address(this), spender) == 0),
894             "SafeERC20: approve from non-zero to non-zero allowance"
895         );
896         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
897     }
898 
899     function safeIncreaseAllowance(
900         IERC20 token,
901         address spender,
902         uint256 value
903     ) internal {
904         uint256 newAllowance = token.allowance(address(this), spender) + value;
905         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
906     }
907 
908     function safeDecreaseAllowance(
909         IERC20 token,
910         address spender,
911         uint256 value
912     ) internal {
913         unchecked {
914             uint256 oldAllowance = token.allowance(address(this), spender);
915             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
916             uint256 newAllowance = oldAllowance - value;
917             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
918         }
919     }
920 
921     function safePermit(
922         IERC20Permit token,
923         address owner,
924         address spender,
925         uint256 value,
926         uint256 deadline,
927         uint8 v,
928         bytes32 r,
929         bytes32 s
930     ) internal {
931         uint256 nonceBefore = token.nonces(owner);
932         token.permit(owner, spender, value, deadline, v, r, s);
933         uint256 nonceAfter = token.nonces(owner);
934         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
935     }
936 
937     /**
938      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
939      * on the return value: the return value is optional (but if data is returned, it must not be false).
940      * @param token The token targeted by the call.
941      * @param data The call data (encoded using abi.encode or one of its variants).
942      */
943     function _callOptionalReturn(IERC20 token, bytes memory data) private {
944         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
945         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
946         // the target address contains contract code and also asserts for success in the low-level call.
947 
948         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
949         if (returndata.length > 0) {
950             // Return data is optional
951             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
952         }
953     }
954 }
955 
956 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
957 
958 
959 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
960 
961 pragma solidity ^0.8.0;
962 
963 /**
964  * @title ERC721 token receiver interface
965  * @dev Interface for any contract that wants to support safeTransfers
966  * from ERC721 asset contracts.
967  */
968 interface IERC721Receiver {
969     /**
970      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
971      * by `operator` from `from`, this function is called.
972      *
973      * It must return its Solidity selector to confirm the token transfer.
974      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
975      *
976      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
977      */
978     function onERC721Received(
979         address operator,
980         address from,
981         uint256 tokenId,
982         bytes calldata data
983     ) external returns (bytes4);
984 }
985 
986 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
987 
988 
989 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
990 
991 pragma solidity ^0.8.0;
992 
993 /**
994  * @dev Interface of the ERC165 standard, as defined in the
995  * https://eips.ethereum.org/EIPS/eip-165[EIP].
996  *
997  * Implementers can declare support of contract interfaces, which can then be
998  * queried by others ({ERC165Checker}).
999  *
1000  * For an implementation, see {ERC165}.
1001  */
1002 interface IERC165 {
1003     /**
1004      * @dev Returns true if this contract implements the interface defined by
1005      * `interfaceId`. See the corresponding
1006      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1007      * to learn more about how these ids are created.
1008      *
1009      * This function call must use less than 30 000 gas.
1010      */
1011     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1012 }
1013 
1014 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1015 
1016 
1017 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 
1022 /**
1023  * @dev Implementation of the {IERC165} interface.
1024  *
1025  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1026  * for the additional interface id that will be supported. For example:
1027  *
1028  * ```solidity
1029  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1030  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1031  * }
1032  * ```
1033  *
1034  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1035  */
1036 abstract contract ERC165 is IERC165 {
1037     /**
1038      * @dev See {IERC165-supportsInterface}.
1039      */
1040     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1041         return interfaceId == type(IERC165).interfaceId;
1042     }
1043 }
1044 
1045 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1046 
1047 
1048 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (token/ERC721/IERC721.sol)
1049 
1050 pragma solidity ^0.8.0;
1051 
1052 
1053 /**
1054  * @dev Required interface of an ERC721 compliant contract.
1055  */
1056 interface IERC721 is IERC165 {
1057     /**
1058      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1059      */
1060     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1061 
1062     /**
1063      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1064      */
1065     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1066 
1067     /**
1068      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1069      */
1070     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1071 
1072     /**
1073      * @dev Returns the number of tokens in ``owner``'s account.
1074      */
1075     function balanceOf(address owner) external view returns (uint256 balance);
1076 
1077     /**
1078      * @dev Returns the owner of the `tokenId` token.
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must exist.
1083      */
1084     function ownerOf(uint256 tokenId) external view returns (address owner);
1085 
1086     /**
1087      * @dev Safely transfers `tokenId` token from `from` to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `from` cannot be the zero address.
1092      * - `to` cannot be the zero address.
1093      * - `tokenId` token must exist and be owned by `from`.
1094      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1095      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function safeTransferFrom(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes calldata data
1104     ) external;
1105 
1106     /**
1107      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1108      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1109      *
1110      * Requirements:
1111      *
1112      * - `from` cannot be the zero address.
1113      * - `to` cannot be the zero address.
1114      * - `tokenId` token must exist and be owned by `from`.
1115      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1116      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function safeTransferFrom(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) external;
1125 
1126     /**
1127      * @dev Transfers `tokenId` token from `from` to `to`.
1128      *
1129      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1130      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1131      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1132      *
1133      * Requirements:
1134      *
1135      * - `from` cannot be the zero address.
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must be owned by `from`.
1138      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function transferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) external;
1147 
1148     /**
1149      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1150      * The approval is cleared when the token is transferred.
1151      *
1152      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1153      *
1154      * Requirements:
1155      *
1156      * - The caller must own the token or be an approved operator.
1157      * - `tokenId` must exist.
1158      *
1159      * Emits an {Approval} event.
1160      */
1161     function approve(address to, uint256 tokenId) external;
1162 
1163     /**
1164      * @dev Approve or remove `operator` as an operator for the caller.
1165      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1166      *
1167      * Requirements:
1168      *
1169      * - The `operator` cannot be the caller.
1170      *
1171      * Emits an {ApprovalForAll} event.
1172      */
1173     function setApprovalForAll(address operator, bool _approved) external;
1174 
1175     /**
1176      * @dev Returns the account approved for `tokenId` token.
1177      *
1178      * Requirements:
1179      *
1180      * - `tokenId` must exist.
1181      */
1182     function getApproved(uint256 tokenId) external view returns (address operator);
1183 
1184     /**
1185      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1186      *
1187      * See {setApprovalForAll}
1188      */
1189     function isApprovedForAll(address owner, address operator) external view returns (bool);
1190 }
1191 
1192 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1193 
1194 
1195 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1196 
1197 pragma solidity ^0.8.0;
1198 
1199 
1200 /**
1201  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1202  * @dev See https://eips.ethereum.org/EIPS/eip-721
1203  */
1204 interface IERC721Metadata is IERC721 {
1205     /**
1206      * @dev Returns the token collection name.
1207      */
1208     function name() external view returns (string memory);
1209 
1210     /**
1211      * @dev Returns the token collection symbol.
1212      */
1213     function symbol() external view returns (string memory);
1214 
1215     /**
1216      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1217      */
1218     function tokenURI(uint256 tokenId) external view returns (string memory);
1219 }
1220 
1221 // File: @openzeppelin/contracts/utils/Context.sol
1222 
1223 
1224 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 /**
1229  * @dev Provides information about the current execution context, including the
1230  * sender of the transaction and its data. While these are generally available
1231  * via msg.sender and msg.data, they should not be accessed in such a direct
1232  * manner, since when dealing with meta-transactions the account sending and
1233  * paying for execution may not be the actual sender (as far as an application
1234  * is concerned).
1235  *
1236  * This contract is only required for intermediate, library-like contracts.
1237  */
1238 abstract contract Context {
1239     function _msgSender() internal view virtual returns (address) {
1240         return msg.sender;
1241     }
1242 
1243     function _msgData() internal view virtual returns (bytes calldata) {
1244         return msg.data;
1245     }
1246 }
1247 
1248 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
1249 
1250 
1251 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (finance/PaymentSplitter.sol)
1252 
1253 pragma solidity ^0.8.0;
1254 
1255 
1256 
1257 
1258 /**
1259  * @title PaymentSplitter
1260  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1261  * that the Ether will be split in this way, since it is handled transparently by the contract.
1262  *
1263  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1264  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1265  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
1266  * time of contract deployment and can't be updated thereafter.
1267  *
1268  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1269  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1270  * function.
1271  *
1272  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1273  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1274  * to run tests before sending real value to this contract.
1275  */
1276 contract PaymentSplitter is Context {
1277     event PayeeAdded(address account, uint256 shares);
1278     event PaymentReleased(address to, uint256 amount);
1279     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1280     event PaymentReceived(address from, uint256 amount);
1281 
1282     uint256 private _totalShares;
1283     uint256 private _totalReleased;
1284 
1285     mapping(address => uint256) private _shares;
1286     mapping(address => uint256) private _released;
1287     address[] private _payees;
1288 
1289     mapping(IERC20 => uint256) private _erc20TotalReleased;
1290     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1291 
1292     /**
1293      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1294      * the matching position in the `shares` array.
1295      *
1296      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1297      * duplicates in `payees`.
1298      */
1299     constructor(address[] memory payees, uint256[] memory shares_) payable {
1300         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1301         require(payees.length > 0, "PaymentSplitter: no payees");
1302 
1303         for (uint256 i = 0; i < payees.length; i++) {
1304             _addPayee(payees[i], shares_[i]);
1305         }
1306     }
1307 
1308     /**
1309      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1310      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1311      * reliability of the events, and not the actual splitting of Ether.
1312      *
1313      * To learn more about this see the Solidity documentation for
1314      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1315      * functions].
1316      */
1317     receive() external payable virtual {
1318         emit PaymentReceived(_msgSender(), msg.value);
1319     }
1320 
1321     /**
1322      * @dev Getter for the total shares held by payees.
1323      */
1324     function totalShares() public view returns (uint256) {
1325         return _totalShares;
1326     }
1327 
1328     /**
1329      * @dev Getter for the total amount of Ether already released.
1330      */
1331     function totalReleased() public view returns (uint256) {
1332         return _totalReleased;
1333     }
1334 
1335     /**
1336      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1337      * contract.
1338      */
1339     function totalReleased(IERC20 token) public view returns (uint256) {
1340         return _erc20TotalReleased[token];
1341     }
1342 
1343     /**
1344      * @dev Getter for the amount of shares held by an account.
1345      */
1346     function shares(address account) public view returns (uint256) {
1347         return _shares[account];
1348     }
1349 
1350     /**
1351      * @dev Getter for the amount of Ether already released to a payee.
1352      */
1353     function released(address account) public view returns (uint256) {
1354         return _released[account];
1355     }
1356 
1357     /**
1358      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1359      * IERC20 contract.
1360      */
1361     function released(IERC20 token, address account) public view returns (uint256) {
1362         return _erc20Released[token][account];
1363     }
1364 
1365     /**
1366      * @dev Getter for the address of the payee number `index`.
1367      */
1368     function payee(uint256 index) public view returns (address) {
1369         return _payees[index];
1370     }
1371 
1372     /**
1373      * @dev Getter for the amount of payee's releasable Ether.
1374      */
1375     function releasable(address account) public view returns (uint256) {
1376         uint256 totalReceived = address(this).balance + totalReleased();
1377         return _pendingPayment(account, totalReceived, released(account));
1378     }
1379 
1380     /**
1381      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1382      * IERC20 contract.
1383      */
1384     function releasable(IERC20 token, address account) public view returns (uint256) {
1385         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1386         return _pendingPayment(account, totalReceived, released(token, account));
1387     }
1388 
1389     /**
1390      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1391      * total shares and their previous withdrawals.
1392      */
1393     function release(address payable account) public virtual {
1394         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1395 
1396         uint256 payment = releasable(account);
1397 
1398         require(payment != 0, "PaymentSplitter: account is not due payment");
1399 
1400         // _totalReleased is the sum of all values in _released.
1401         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
1402         _totalReleased += payment;
1403         unchecked {
1404             _released[account] += payment;
1405         }
1406 
1407         Address.sendValue(account, payment);
1408         emit PaymentReleased(account, payment);
1409     }
1410 
1411     /**
1412      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1413      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1414      * contract.
1415      */
1416     function release(IERC20 token, address account) public virtual {
1417         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1418 
1419         uint256 payment = releasable(token, account);
1420 
1421         require(payment != 0, "PaymentSplitter: account is not due payment");
1422 
1423         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
1424         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
1425         // cannot overflow.
1426         _erc20TotalReleased[token] += payment;
1427         unchecked {
1428             _erc20Released[token][account] += payment;
1429         }
1430 
1431         SafeERC20.safeTransfer(token, account, payment);
1432         emit ERC20PaymentReleased(token, account, payment);
1433     }
1434 
1435     /**
1436      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1437      * already released amounts.
1438      */
1439     function _pendingPayment(
1440         address account,
1441         uint256 totalReceived,
1442         uint256 alreadyReleased
1443     ) private view returns (uint256) {
1444         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1445     }
1446 
1447     /**
1448      * @dev Add a new payee to the contract.
1449      * @param account The address of the payee to add.
1450      * @param shares_ The number of shares owned by the payee.
1451      */
1452     function _addPayee(address account, uint256 shares_) private {
1453         require(account != address(0), "PaymentSplitter: account is the zero address");
1454         require(shares_ > 0, "PaymentSplitter: shares are 0");
1455         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1456 
1457         _payees.push(account);
1458         _shares[account] = shares_;
1459         _totalShares = _totalShares + shares_;
1460         emit PayeeAdded(account, shares_);
1461     }
1462 }
1463 
1464 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1465 
1466 
1467 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (token/ERC721/ERC721.sol)
1468 
1469 pragma solidity ^0.8.0;
1470 
1471 
1472 
1473 
1474 
1475 
1476 
1477 
1478 /**
1479  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1480  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1481  * {ERC721Enumerable}.
1482  */
1483 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1484     using Address for address;
1485     using Strings for uint256;
1486 
1487     // Token name
1488     string private _name;
1489 
1490     // Token symbol
1491     string private _symbol;
1492 
1493     // Mapping from token ID to owner address
1494     mapping(uint256 => address) private _owners;
1495 
1496     // Mapping owner address to token count
1497     mapping(address => uint256) private _balances;
1498 
1499     // Mapping from token ID to approved address
1500     mapping(uint256 => address) private _tokenApprovals;
1501 
1502     // Mapping from owner to operator approvals
1503     mapping(address => mapping(address => bool)) private _operatorApprovals;
1504 
1505     /**
1506      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1507      */
1508     constructor(string memory name_, string memory symbol_) {
1509         _name = name_;
1510         _symbol = symbol_;
1511     }
1512 
1513     /**
1514      * @dev See {IERC165-supportsInterface}.
1515      */
1516     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1517         return
1518             interfaceId == type(IERC721).interfaceId ||
1519             interfaceId == type(IERC721Metadata).interfaceId ||
1520             super.supportsInterface(interfaceId);
1521     }
1522 
1523     /**
1524      * @dev See {IERC721-balanceOf}.
1525      */
1526     function balanceOf(address owner) public view virtual override returns (uint256) {
1527         require(owner != address(0), "ERC721: address zero is not a valid owner");
1528         return _balances[owner];
1529     }
1530 
1531     /**
1532      * @dev See {IERC721-ownerOf}.
1533      */
1534     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1535         address owner = _ownerOf(tokenId);
1536         require(owner != address(0), "ERC721: invalid token ID");
1537         return owner;
1538     }
1539 
1540     /**
1541      * @dev See {IERC721Metadata-name}.
1542      */
1543     function name() public view virtual override returns (string memory) {
1544         return _name;
1545     }
1546 
1547     /**
1548      * @dev See {IERC721Metadata-symbol}.
1549      */
1550     function symbol() public view virtual override returns (string memory) {
1551         return _symbol;
1552     }
1553 
1554     /**
1555      * @dev See {IERC721Metadata-tokenURI}.
1556      */
1557     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1558         _requireMinted(tokenId);
1559 
1560         string memory baseURI = _baseURI();
1561         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1562     }
1563 
1564     /**
1565      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1566      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1567      * by default, can be overridden in child contracts.
1568      */
1569     function _baseURI() internal view virtual returns (string memory) {
1570         return "";
1571     }
1572 
1573     /**
1574      * @dev See {IERC721-approve}.
1575      */
1576     function approve(address to, uint256 tokenId) public virtual override {
1577         address owner = ERC721.ownerOf(tokenId);
1578         require(to != owner, "ERC721: approval to current owner");
1579 
1580         require(
1581             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1582             "ERC721: approve caller is not token owner or approved for all"
1583         );
1584 
1585         _approve(to, tokenId);
1586     }
1587 
1588     /**
1589      * @dev See {IERC721-getApproved}.
1590      */
1591     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1592         _requireMinted(tokenId);
1593 
1594         return _tokenApprovals[tokenId];
1595     }
1596 
1597     /**
1598      * @dev See {IERC721-setApprovalForAll}.
1599      */
1600     function setApprovalForAll(address operator, bool approved) public virtual override {
1601         _setApprovalForAll(_msgSender(), operator, approved);
1602     }
1603 
1604     /**
1605      * @dev See {IERC721-isApprovedForAll}.
1606      */
1607     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1608         return _operatorApprovals[owner][operator];
1609     }
1610 
1611     /**
1612      * @dev See {IERC721-transferFrom}.
1613      */
1614     function transferFrom(
1615         address from,
1616         address to,
1617         uint256 tokenId
1618     ) public virtual override {
1619         //solhint-disable-next-line max-line-length
1620         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1621 
1622         _transfer(from, to, tokenId);
1623     }
1624 
1625     /**
1626      * @dev See {IERC721-safeTransferFrom}.
1627      */
1628     function safeTransferFrom(
1629         address from,
1630         address to,
1631         uint256 tokenId
1632     ) public virtual override {
1633         safeTransferFrom(from, to, tokenId, "");
1634     }
1635 
1636     /**
1637      * @dev See {IERC721-safeTransferFrom}.
1638      */
1639     function safeTransferFrom(
1640         address from,
1641         address to,
1642         uint256 tokenId,
1643         bytes memory data
1644     ) public virtual override {
1645         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1646         _safeTransfer(from, to, tokenId, data);
1647     }
1648 
1649     /**
1650      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1651      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1652      *
1653      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1654      *
1655      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1656      * implement alternative mechanisms to perform token transfer, such as signature-based.
1657      *
1658      * Requirements:
1659      *
1660      * - `from` cannot be the zero address.
1661      * - `to` cannot be the zero address.
1662      * - `tokenId` token must exist and be owned by `from`.
1663      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1664      *
1665      * Emits a {Transfer} event.
1666      */
1667     function _safeTransfer(
1668         address from,
1669         address to,
1670         uint256 tokenId,
1671         bytes memory data
1672     ) internal virtual {
1673         _transfer(from, to, tokenId);
1674         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1675     }
1676 
1677     /**
1678      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1679      */
1680     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1681         return _owners[tokenId];
1682     }
1683 
1684     /**
1685      * @dev Returns whether `tokenId` exists.
1686      *
1687      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1688      *
1689      * Tokens start existing when they are minted (`_mint`),
1690      * and stop existing when they are burned (`_burn`).
1691      */
1692     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1693         return _ownerOf(tokenId) != address(0);
1694     }
1695 
1696     /**
1697      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1698      *
1699      * Requirements:
1700      *
1701      * - `tokenId` must exist.
1702      */
1703     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1704         address owner = ERC721.ownerOf(tokenId);
1705         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1706     }
1707 
1708     /**
1709      * @dev Safely mints `tokenId` and transfers it to `to`.
1710      *
1711      * Requirements:
1712      *
1713      * - `tokenId` must not exist.
1714      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1715      *
1716      * Emits a {Transfer} event.
1717      */
1718     function _safeMint(address to, uint256 tokenId) internal virtual {
1719         _safeMint(to, tokenId, "");
1720     }
1721 
1722     /**
1723      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1724      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1725      */
1726     function _safeMint(
1727         address to,
1728         uint256 tokenId,
1729         bytes memory data
1730     ) internal virtual {
1731         _mint(to, tokenId);
1732         require(
1733             _checkOnERC721Received(address(0), to, tokenId, data),
1734             "ERC721: transfer to non ERC721Receiver implementer"
1735         );
1736     }
1737 
1738     /**
1739      * @dev Mints `tokenId` and transfers it to `to`.
1740      *
1741      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1742      *
1743      * Requirements:
1744      *
1745      * - `tokenId` must not exist.
1746      * - `to` cannot be the zero address.
1747      *
1748      * Emits a {Transfer} event.
1749      */
1750     function _mint(address to, uint256 tokenId) internal virtual {
1751         require(to != address(0), "ERC721: mint to the zero address");
1752         require(!_exists(tokenId), "ERC721: token already minted");
1753 
1754         _beforeTokenTransfer(address(0), to, tokenId);
1755 
1756         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1757         require(!_exists(tokenId), "ERC721: token already minted");
1758 
1759         unchecked {
1760             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1761             // Given that tokens are minted one by one, it is impossible in practice that
1762             // this ever happens. Might change if we allow batch minting.
1763             // The ERC fails to describe this case.
1764             _balances[to] += 1;
1765         }
1766 
1767         _owners[tokenId] = to;
1768 
1769         emit Transfer(address(0), to, tokenId);
1770 
1771         _afterTokenTransfer(address(0), to, tokenId);
1772     }
1773 
1774     /**
1775      * @dev Destroys `tokenId`.
1776      * The approval is cleared when the token is burned.
1777      * This is an internal function that does not check if the sender is authorized to operate on the token.
1778      *
1779      * Requirements:
1780      *
1781      * - `tokenId` must exist.
1782      *
1783      * Emits a {Transfer} event.
1784      */
1785     function _burn(uint256 tokenId) internal virtual {
1786         address owner = ERC721.ownerOf(tokenId);
1787 
1788         _beforeTokenTransfer(owner, address(0), tokenId);
1789 
1790         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1791         owner = ERC721.ownerOf(tokenId);
1792 
1793         // Clear approvals
1794         delete _tokenApprovals[tokenId];
1795 
1796         unchecked {
1797             // Cannot overflow, as that would require more tokens to be burned/transferred
1798             // out than the owner initially received through minting and transferring in.
1799             _balances[owner] -= 1;
1800         }
1801         delete _owners[tokenId];
1802 
1803         emit Transfer(owner, address(0), tokenId);
1804 
1805         _afterTokenTransfer(owner, address(0), tokenId);
1806     }
1807 
1808     /**
1809      * @dev Transfers `tokenId` from `from` to `to`.
1810      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1811      *
1812      * Requirements:
1813      *
1814      * - `to` cannot be the zero address.
1815      * - `tokenId` token must be owned by `from`.
1816      *
1817      * Emits a {Transfer} event.
1818      */
1819     function _transfer(
1820         address from,
1821         address to,
1822         uint256 tokenId
1823     ) internal virtual {
1824         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1825         require(to != address(0), "ERC721: transfer to the zero address");
1826 
1827         _beforeTokenTransfer(from, to, tokenId);
1828 
1829         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1830         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1831 
1832         // Clear approvals from the previous owner
1833         delete _tokenApprovals[tokenId];
1834 
1835         unchecked {
1836             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1837             // `from`'s balance is the number of token held, which is at least one before the current
1838             // transfer.
1839             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1840             // all 2**256 token ids to be minted, which in practice is impossible.
1841             _balances[from] -= 1;
1842             _balances[to] += 1;
1843         }
1844         _owners[tokenId] = to;
1845 
1846         emit Transfer(from, to, tokenId);
1847 
1848         _afterTokenTransfer(from, to, tokenId);
1849     }
1850 
1851     /**
1852      * @dev Approve `to` to operate on `tokenId`
1853      *
1854      * Emits an {Approval} event.
1855      */
1856     function _approve(address to, uint256 tokenId) internal virtual {
1857         _tokenApprovals[tokenId] = to;
1858         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1859     }
1860 
1861     /**
1862      * @dev Approve `operator` to operate on all of `owner` tokens
1863      *
1864      * Emits an {ApprovalForAll} event.
1865      */
1866     function _setApprovalForAll(
1867         address owner,
1868         address operator,
1869         bool approved
1870     ) internal virtual {
1871         require(owner != operator, "ERC721: approve to caller");
1872         _operatorApprovals[owner][operator] = approved;
1873         emit ApprovalForAll(owner, operator, approved);
1874     }
1875 
1876     /**
1877      * @dev Reverts if the `tokenId` has not been minted yet.
1878      */
1879     function _requireMinted(uint256 tokenId) internal view virtual {
1880         require(_exists(tokenId), "ERC721: invalid token ID");
1881     }
1882 
1883     /**
1884      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1885      * The call is not executed if the target address is not a contract.
1886      *
1887      * @param from address representing the previous owner of the given token ID
1888      * @param to target address that will receive the tokens
1889      * @param tokenId uint256 ID of the token to be transferred
1890      * @param data bytes optional data to send along with the call
1891      * @return bool whether the call correctly returned the expected magic value
1892      */
1893     function _checkOnERC721Received(
1894         address from,
1895         address to,
1896         uint256 tokenId,
1897         bytes memory data
1898     ) private returns (bool) {
1899         if (to.isContract()) {
1900             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1901                 return retval == IERC721Receiver.onERC721Received.selector;
1902             } catch (bytes memory reason) {
1903                 if (reason.length == 0) {
1904                     revert("ERC721: transfer to non ERC721Receiver implementer");
1905                 } else {
1906                     /// @solidity memory-safe-assembly
1907                     assembly {
1908                         revert(add(32, reason), mload(reason))
1909                     }
1910                 }
1911             }
1912         } else {
1913             return true;
1914         }
1915     }
1916 
1917     /**
1918      * @dev Hook that is called before any (single) token transfer. This includes minting and burning.
1919      * See {_beforeConsecutiveTokenTransfer}.
1920      *
1921      * Calling conditions:
1922      *
1923      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1924      * transferred to `to`.
1925      * - When `from` is zero, `tokenId` will be minted for `to`.
1926      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1927      * - `from` and `to` are never both zero.
1928      *
1929      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1930      */
1931     function _beforeTokenTransfer(
1932         address from,
1933         address to,
1934         uint256 tokenId
1935     ) internal virtual {}
1936 
1937     /**
1938      * @dev Hook that is called after any (single) transfer of tokens. This includes minting and burning.
1939      * See {_afterConsecutiveTokenTransfer}.
1940      *
1941      * Calling conditions:
1942      *
1943      * - when `from` and `to` are both non-zero.
1944      * - `from` and `to` are never both zero.
1945      *
1946      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1947      */
1948     function _afterTokenTransfer(
1949         address from,
1950         address to,
1951         uint256 tokenId
1952     ) internal virtual {}
1953 
1954     /**
1955      * @dev Hook that is called before consecutive token transfers.
1956      * Calling conditions are similar to {_beforeTokenTransfer}.
1957      *
1958      * The default implementation include balances updates that extensions such as {ERC721Consecutive} cannot perform
1959      * directly.
1960      */
1961     function _beforeConsecutiveTokenTransfer(
1962         address from,
1963         address to,
1964         uint256, /*first*/
1965         uint96 size
1966     ) internal virtual {
1967         if (from != address(0)) {
1968             _balances[from] -= size;
1969         }
1970         if (to != address(0)) {
1971             _balances[to] += size;
1972         }
1973     }
1974 
1975     /**
1976      * @dev Hook that is called after consecutive token transfers.
1977      * Calling conditions are similar to {_afterTokenTransfer}.
1978      */
1979     function _afterConsecutiveTokenTransfer(
1980         address, /*from*/
1981         address, /*to*/
1982         uint256, /*first*/
1983         uint96 /*size*/
1984     ) internal virtual {}
1985 }
1986 
1987 // File: @openzeppelin/contracts/access/Ownable.sol
1988 
1989 
1990 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1991 
1992 pragma solidity ^0.8.0;
1993 
1994 
1995 /**
1996  * @dev Contract module which provides a basic access control mechanism, where
1997  * there is an account (an owner) that can be granted exclusive access to
1998  * specific functions.
1999  *
2000  * By default, the owner account will be the one that deploys the contract. This
2001  * can later be changed with {transferOwnership}.
2002  *
2003  * This module is used through inheritance. It will make available the modifier
2004  * `onlyOwner`, which can be applied to your functions to restrict their use to
2005  * the owner.
2006  */
2007 abstract contract Ownable is Context {
2008     address private _owner;
2009 
2010     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2011 
2012     /**
2013      * @dev Initializes the contract setting the deployer as the initial owner.
2014      */
2015     constructor() {
2016         _transferOwnership(_msgSender());
2017     }
2018 
2019     /**
2020      * @dev Throws if called by any account other than the owner.
2021      */
2022     modifier onlyOwner() {
2023         _checkOwner();
2024         _;
2025     }
2026 
2027     /**
2028      * @dev Returns the address of the current owner.
2029      */
2030     function owner() public view virtual returns (address) {
2031         return _owner;
2032     }
2033 
2034     /**
2035      * @dev Throws if the sender is not the owner.
2036      */
2037     function _checkOwner() internal view virtual {
2038         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2039     }
2040 
2041     /**
2042      * @dev Leaves the contract without owner. It will not be possible to call
2043      * `onlyOwner` functions anymore. Can only be called by the current owner.
2044      *
2045      * NOTE: Renouncing ownership will leave the contract without an owner,
2046      * thereby removing any functionality that is only available to the owner.
2047      */
2048     function renounceOwnership() public virtual onlyOwner {
2049         _transferOwnership(address(0));
2050     }
2051 
2052     /**
2053      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2054      * Can only be called by the current owner.
2055      */
2056     function transferOwnership(address newOwner) public virtual onlyOwner {
2057         require(newOwner != address(0), "Ownable: new owner is the zero address");
2058         _transferOwnership(newOwner);
2059     }
2060 
2061     /**
2062      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2063      * Internal function without access restriction.
2064      */
2065     function _transferOwnership(address newOwner) internal virtual {
2066         address oldOwner = _owner;
2067         _owner = newOwner;
2068         emit OwnershipTransferred(oldOwner, newOwner);
2069     }
2070 }
2071 
2072 // File: code-sample/KawaiiRobot/KawaiiRobot.sol
2073 
2074 
2075 
2076 pragma solidity ^0.8.6;
2077 
2078 
2079 
2080 
2081 
2082 
2083 
2084 contract KawaiiRobot is Ownable, ERC721, PaymentSplitter,IToken  {
2085     using Strings for uint256;
2086 
2087     // Sale details
2088     uint256 public maxTokens = 999; // presale amount
2089     uint256 public maxMintsPerTx = 2;
2090     uint256 public price = .005 ether; // presale price
2091     bool public saleActive;
2092 
2093     // When set, diverts tokenURI calls to external contract
2094     address public descriptor;
2095     // Only used when `descriptor` is 0x0
2096     string public baseURI;
2097 
2098     uint256 private nextTokenId;
2099 
2100     // Admin access for privileged contracts
2101     mapping(address => bool) public admins;
2102 
2103     /**
2104      * @notice Caller must be owner or privileged admin contract.
2105      */
2106     modifier onlyAdmin() {
2107         require(owner() == _msgSender() || admins[msg.sender], "Not admin");
2108         _;
2109     }
2110 
2111     constructor(address[] memory payees, uint256[] memory shares)
2112       ERC721("KawaiiRobot", "KAWAIIROBOT")
2113       PaymentSplitter(payees, shares)
2114     {}
2115 
2116     /**
2117      * @dev Public mint.
2118      */
2119     function mint(uint256 quantity) external payable {
2120         require(saleActive, "Sale inactive");
2121         require(quantity <= maxMintsPerTx, "Too many mints per txn");
2122         require(nextTokenId + quantity <= maxTokens, "Exceeds max supply");
2123         require(msg.value >= price * quantity, "Not enough ether");
2124         require(msg.sender == tx.origin, "No contract mints");
2125 
2126         for (uint256 i = 0; i < quantity; i++) {
2127             _safeMint(msg.sender, nextTokenId++);
2128         }
2129     }
2130 
2131     /**
2132      * @dev Return tokenURI directly or via alternative `descriptor` contract
2133      */
2134     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2135         require(_exists(tokenId), "URI query for nonexistent token");
2136 
2137         if (descriptor == address(0)) {
2138             return string(abi.encodePacked(baseURI, tokenId.toString()));
2139         } else {
2140             return IDescriptor(descriptor).tokenURI(tokenId);
2141         }
2142         
2143     }
2144 
2145     /**
2146      * @dev Simplified version of ERC721Enumberable's `totalSupply`
2147      */
2148     function totalSupply() external view returns (uint256) {
2149         return nextTokenId;
2150     }
2151 
2152     /**
2153      * @dev Set `descriptor` contract address to route `tokenURI`
2154      */
2155     function setDescriptor(address _descriptor) external onlyOwner {
2156         descriptor = _descriptor;
2157     }
2158 
2159     /**
2160      * @dev Set the `baseURI` used to construct `tokenURI`.
2161      */
2162     function setBaseURI(string memory _baseURI) external onlyOwner {
2163         baseURI = _baseURI;
2164     }
2165 
2166     /**
2167      * @dev Enable adjusting max mints per transaction.
2168      */
2169     function setMaxMintsPerTxn(uint256 newMax) external onlyOwner {
2170         maxMintsPerTx = newMax;
2171     }
2172 
2173     /**
2174      * @dev Enable adjusting price.
2175      */
2176     function setPrice(uint256 newPriceWei) external onlyOwner {
2177         price = newPriceWei;
2178     }
2179 
2180     /**
2181      * @dev Toggle sale status.
2182      */
2183     function toggleSale() external onlyOwner {
2184         saleActive = !saleActive;
2185     }
2186 
2187     /**
2188      * @dev Toggle admin status for an address.
2189      */
2190     function setAdmin(address _address) external onlyOwner {
2191         admins[_address] = !admins[_address];
2192     }
2193 
2194     /**
2195      * @dev Admin mint. To be used in future expansions. New admin contract
2196      * must enforce mint mechanics.
2197      */
2198     function mintAdmin(uint256 quantity, address to) external override onlyAdmin {
2199         for (uint256 i = 0; i < quantity; i++) {
2200             _safeMint(to, nextTokenId++);
2201         }
2202     }
2203 
2204 }