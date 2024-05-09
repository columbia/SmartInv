1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/math/Math.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Standard math utilities missing in the Solidity language.
12  */
13 library Math {
14     enum Rounding {
15         Down, // Toward negative infinity
16         Up, // Toward infinity
17         Zero // Toward zero
18     }
19 
20     /**
21      * @dev Returns the largest of two numbers.
22      */
23     function max(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a > b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the smallest of two numbers.
29      */
30     function min(uint256 a, uint256 b) internal pure returns (uint256) {
31         return a < b ? a : b;
32     }
33 
34     /**
35      * @dev Returns the average of two numbers. The result is rounded towards
36      * zero.
37      */
38     function average(uint256 a, uint256 b) internal pure returns (uint256) {
39         // (a + b) / 2 can overflow.
40         return (a & b) + (a ^ b) / 2;
41     }
42 
43     /**
44      * @dev Returns the ceiling of the division of two numbers.
45      *
46      * This differs from standard division with `/` in that it rounds up instead
47      * of rounding down.
48      */
49     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
50         // (a + b - 1) / b can overflow on addition, so we distribute.
51         return a == 0 ? 0 : (a - 1) / b + 1;
52     }
53 
54     /**
55      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
56      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
57      * with further edits by Uniswap Labs also under MIT license.
58      */
59     function mulDiv(
60         uint256 x,
61         uint256 y,
62         uint256 denominator
63     ) internal pure returns (uint256 result) {
64         unchecked {
65             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
66             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
67             // variables such that product = prod1 * 2^256 + prod0.
68             uint256 prod0; // Least significant 256 bits of the product
69             uint256 prod1; // Most significant 256 bits of the product
70             assembly {
71                 let mm := mulmod(x, y, not(0))
72                 prod0 := mul(x, y)
73                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
74             }
75 
76             // Handle non-overflow cases, 256 by 256 division.
77             if (prod1 == 0) {
78                 return prod0 / denominator;
79             }
80 
81             // Make sure the result is less than 2^256. Also prevents denominator == 0.
82             require(denominator > prod1);
83 
84             ///////////////////////////////////////////////
85             // 512 by 256 division.
86             ///////////////////////////////////////////////
87 
88             // Make division exact by subtracting the remainder from [prod1 prod0].
89             uint256 remainder;
90             assembly {
91                 // Compute remainder using mulmod.
92                 remainder := mulmod(x, y, denominator)
93 
94                 // Subtract 256 bit number from 512 bit number.
95                 prod1 := sub(prod1, gt(remainder, prod0))
96                 prod0 := sub(prod0, remainder)
97             }
98 
99             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
100             // See https://cs.stackexchange.com/q/138556/92363.
101 
102             // Does not overflow because the denominator cannot be zero at this stage in the function.
103             uint256 twos = denominator & (~denominator + 1);
104             assembly {
105                 // Divide denominator by twos.
106                 denominator := div(denominator, twos)
107 
108                 // Divide [prod1 prod0] by twos.
109                 prod0 := div(prod0, twos)
110 
111                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
112                 twos := add(div(sub(0, twos), twos), 1)
113             }
114 
115             // Shift in bits from prod1 into prod0.
116             prod0 |= prod1 * twos;
117 
118             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
119             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
120             // four bits. That is, denominator * inv = 1 mod 2^4.
121             uint256 inverse = (3 * denominator) ^ 2;
122 
123             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
124             // in modular arithmetic, doubling the correct bits in each step.
125             inverse *= 2 - denominator * inverse; // inverse mod 2^8
126             inverse *= 2 - denominator * inverse; // inverse mod 2^16
127             inverse *= 2 - denominator * inverse; // inverse mod 2^32
128             inverse *= 2 - denominator * inverse; // inverse mod 2^64
129             inverse *= 2 - denominator * inverse; // inverse mod 2^128
130             inverse *= 2 - denominator * inverse; // inverse mod 2^256
131 
132             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
133             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
134             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
135             // is no longer required.
136             result = prod0 * inverse;
137             return result;
138         }
139     }
140 
141     /**
142      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
143      */
144     function mulDiv(
145         uint256 x,
146         uint256 y,
147         uint256 denominator,
148         Rounding rounding
149     ) internal pure returns (uint256) {
150         uint256 result = mulDiv(x, y, denominator);
151         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
152             result += 1;
153         }
154         return result;
155     }
156 
157     /**
158      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
159      *
160      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
161      */
162     function sqrt(uint256 a) internal pure returns (uint256) {
163         if (a == 0) {
164             return 0;
165         }
166 
167         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
168         //
169         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
170         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
171         //
172         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
173         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
174         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
175         //
176         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
177         uint256 result = 1 << (log2(a) >> 1);
178 
179         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
180         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
181         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
182         // into the expected uint128 result.
183         unchecked {
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             result = (result + a / result) >> 1;
190             result = (result + a / result) >> 1;
191             return min(result, a / result);
192         }
193     }
194 
195     /**
196      * @notice Calculates sqrt(a), following the selected rounding direction.
197      */
198     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
199         unchecked {
200             uint256 result = sqrt(a);
201             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
202         }
203     }
204 
205     /**
206      * @dev Return the log in base 2, rounded down, of a positive value.
207      * Returns 0 if given 0.
208      */
209     function log2(uint256 value) internal pure returns (uint256) {
210         uint256 result = 0;
211         unchecked {
212             if (value >> 128 > 0) {
213                 value >>= 128;
214                 result += 128;
215             }
216             if (value >> 64 > 0) {
217                 value >>= 64;
218                 result += 64;
219             }
220             if (value >> 32 > 0) {
221                 value >>= 32;
222                 result += 32;
223             }
224             if (value >> 16 > 0) {
225                 value >>= 16;
226                 result += 16;
227             }
228             if (value >> 8 > 0) {
229                 value >>= 8;
230                 result += 8;
231             }
232             if (value >> 4 > 0) {
233                 value >>= 4;
234                 result += 4;
235             }
236             if (value >> 2 > 0) {
237                 value >>= 2;
238                 result += 2;
239             }
240             if (value >> 1 > 0) {
241                 result += 1;
242             }
243         }
244         return result;
245     }
246 
247     /**
248      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
249      * Returns 0 if given 0.
250      */
251     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
252         unchecked {
253             uint256 result = log2(value);
254             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
255         }
256     }
257 
258     /**
259      * @dev Return the log in base 10, rounded down, of a positive value.
260      * Returns 0 if given 0.
261      */
262     function log10(uint256 value) internal pure returns (uint256) {
263         uint256 result = 0;
264         unchecked {
265             if (value >= 10**64) {
266                 value /= 10**64;
267                 result += 64;
268             }
269             if (value >= 10**32) {
270                 value /= 10**32;
271                 result += 32;
272             }
273             if (value >= 10**16) {
274                 value /= 10**16;
275                 result += 16;
276             }
277             if (value >= 10**8) {
278                 value /= 10**8;
279                 result += 8;
280             }
281             if (value >= 10**4) {
282                 value /= 10**4;
283                 result += 4;
284             }
285             if (value >= 10**2) {
286                 value /= 10**2;
287                 result += 2;
288             }
289             if (value >= 10**1) {
290                 result += 1;
291             }
292         }
293         return result;
294     }
295 
296     /**
297      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
298      * Returns 0 if given 0.
299      */
300     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
301         unchecked {
302             uint256 result = log10(value);
303             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
304         }
305     }
306 
307     /**
308      * @dev Return the log in base 256, rounded down, of a positive value.
309      * Returns 0 if given 0.
310      *
311      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
312      */
313     function log256(uint256 value) internal pure returns (uint256) {
314         uint256 result = 0;
315         unchecked {
316             if (value >> 128 > 0) {
317                 value >>= 128;
318                 result += 16;
319             }
320             if (value >> 64 > 0) {
321                 value >>= 64;
322                 result += 8;
323             }
324             if (value >> 32 > 0) {
325                 value >>= 32;
326                 result += 4;
327             }
328             if (value >> 16 > 0) {
329                 value >>= 16;
330                 result += 2;
331             }
332             if (value >> 8 > 0) {
333                 result += 1;
334             }
335         }
336         return result;
337     }
338 
339     /**
340      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
341      * Returns 0 if given 0.
342      */
343     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
344         unchecked {
345             uint256 result = log256(value);
346             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
347         }
348     }
349 }
350 
351 // File: @openzeppelin/contracts/utils/Strings.sol
352 
353 
354 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 
359 /**
360  * @dev String operations.
361  */
362 library Strings {
363     bytes16 private constant _SYMBOLS = "0123456789abcdef";
364     uint8 private constant _ADDRESS_LENGTH = 20;
365 
366     /**
367      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
368      */
369     function toString(uint256 value) internal pure returns (string memory) {
370         unchecked {
371             uint256 length = Math.log10(value) + 1;
372             string memory buffer = new string(length);
373             uint256 ptr;
374             /// @solidity memory-safe-assembly
375             assembly {
376                 ptr := add(buffer, add(32, length))
377             }
378             while (true) {
379                 ptr--;
380                 /// @solidity memory-safe-assembly
381                 assembly {
382                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
383                 }
384                 value /= 10;
385                 if (value == 0) break;
386             }
387             return buffer;
388         }
389     }
390 
391     /**
392      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
393      */
394     function toHexString(uint256 value) internal pure returns (string memory) {
395         unchecked {
396             return toHexString(value, Math.log256(value) + 1);
397         }
398     }
399 
400     /**
401      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
402      */
403     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
404         bytes memory buffer = new bytes(2 * length + 2);
405         buffer[0] = "0";
406         buffer[1] = "x";
407         for (uint256 i = 2 * length + 1; i > 1; --i) {
408             buffer[i] = _SYMBOLS[value & 0xf];
409             value >>= 4;
410         }
411         require(value == 0, "Strings: hex length insufficient");
412         return string(buffer);
413     }
414 
415     /**
416      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
417      */
418     function toHexString(address addr) internal pure returns (string memory) {
419         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
420     }
421 }
422 
423 // File: @openzeppelin/contracts/utils/Context.sol
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Provides information about the current execution context, including the
432  * sender of the transaction and its data. While these are generally available
433  * via msg.sender and msg.data, they should not be accessed in such a direct
434  * manner, since when dealing with meta-transactions the account sending and
435  * paying for execution may not be the actual sender (as far as an application
436  * is concerned).
437  *
438  * This contract is only required for intermediate, library-like contracts.
439  */
440 abstract contract Context {
441     function _msgSender() internal view virtual returns (address) {
442         return msg.sender;
443     }
444 
445     function _msgData() internal view virtual returns (bytes calldata) {
446         return msg.data;
447     }
448 }
449 
450 // File: @openzeppelin/contracts/access/Ownable.sol
451 
452 
453 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 
458 /**
459  * @dev Contract module which provides a basic access control mechanism, where
460  * there is an account (an owner) that can be granted exclusive access to
461  * specific functions.
462  *
463  * By default, the owner account will be the one that deploys the contract. This
464  * can later be changed with {transferOwnership}.
465  *
466  * This module is used through inheritance. It will make available the modifier
467  * `onlyOwner`, which can be applied to your functions to restrict their use to
468  * the owner.
469  */
470 abstract contract Ownable is Context {
471     address private _owner;
472 
473     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
474 
475     /**
476      * @dev Initializes the contract setting the deployer as the initial owner.
477      */
478     constructor() {
479         _transferOwnership(_msgSender());
480     }
481 
482     /**
483      * @dev Throws if called by any account other than the owner.
484      */
485     modifier onlyOwner() {
486         _checkOwner();
487         _;
488     }
489 
490     /**
491      * @dev Returns the address of the current owner.
492      */
493     function owner() public view virtual returns (address) {
494         return _owner;
495     }
496 
497     /**
498      * @dev Throws if the sender is not the owner.
499      */
500     function _checkOwner() internal view virtual {
501         require(owner() == _msgSender(), "Ownable: caller is not the owner");
502     }
503 
504     /**
505      * @dev Leaves the contract without owner. It will not be possible to call
506      * `onlyOwner` functions anymore. Can only be called by the current owner.
507      *
508      * NOTE: Renouncing ownership will leave the contract without an owner,
509      * thereby removing any functionality that is only available to the owner.
510      */
511     function renounceOwnership() public virtual onlyOwner {
512         _transferOwnership(address(0));
513     }
514 
515     /**
516      * @dev Transfers ownership of the contract to a new account (`newOwner`).
517      * Can only be called by the current owner.
518      */
519     function transferOwnership(address newOwner) public virtual onlyOwner {
520         require(newOwner != address(0), "Ownable: new owner is the zero address");
521         _transferOwnership(newOwner);
522     }
523 
524     /**
525      * @dev Transfers ownership of the contract to a new account (`newOwner`).
526      * Internal function without access restriction.
527      */
528     function _transferOwnership(address newOwner) internal virtual {
529         address oldOwner = _owner;
530         _owner = newOwner;
531         emit OwnershipTransferred(oldOwner, newOwner);
532     }
533 }
534 
535 // File: @openzeppelin/contracts/utils/Address.sol
536 
537 
538 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
539 
540 pragma solidity ^0.8.1;
541 
542 /**
543  * @dev Collection of functions related to the address type
544  */
545 library Address {
546     /**
547      * @dev Returns true if `account` is a contract.
548      *
549      * [IMPORTANT]
550      * ====
551      * It is unsafe to assume that an address for which this function returns
552      * false is an externally-owned account (EOA) and not a contract.
553      *
554      * Among others, `isContract` will return false for the following
555      * types of addresses:
556      *
557      *  - an externally-owned account
558      *  - a contract in construction
559      *  - an address where a contract will be created
560      *  - an address where a contract lived, but was destroyed
561      * ====
562      *
563      * [IMPORTANT]
564      * ====
565      * You shouldn't rely on `isContract` to protect against flash loan attacks!
566      *
567      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
568      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
569      * constructor.
570      * ====
571      */
572     function isContract(address account) internal view returns (bool) {
573         // This method relies on extcodesize/address.code.length, which returns 0
574         // for contracts in construction, since the code is only stored at the end
575         // of the constructor execution.
576 
577         return account.code.length > 0;
578     }
579 
580     /**
581      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
582      * `recipient`, forwarding all available gas and reverting on errors.
583      *
584      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
585      * of certain opcodes, possibly making contracts go over the 2300 gas limit
586      * imposed by `transfer`, making them unable to receive funds via
587      * `transfer`. {sendValue} removes this limitation.
588      *
589      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
590      *
591      * IMPORTANT: because control is transferred to `recipient`, care must be
592      * taken to not create reentrancy vulnerabilities. Consider using
593      * {ReentrancyGuard} or the
594      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
595      */
596     function sendValue(address payable recipient, uint256 amount) internal {
597         require(address(this).balance >= amount, "Address: insufficient balance");
598 
599         (bool success, ) = recipient.call{value: amount}("");
600         require(success, "Address: unable to send value, recipient may have reverted");
601     }
602 
603     /**
604      * @dev Performs a Solidity function call using a low level `call`. A
605      * plain `call` is an unsafe replacement for a function call: use this
606      * function instead.
607      *
608      * If `target` reverts with a revert reason, it is bubbled up by this
609      * function (like regular Solidity function calls).
610      *
611      * Returns the raw returned data. To convert to the expected return value,
612      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
613      *
614      * Requirements:
615      *
616      * - `target` must be a contract.
617      * - calling `target` with `data` must not revert.
618      *
619      * _Available since v3.1._
620      */
621     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
622         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
627      * `errorMessage` as a fallback revert reason when `target` reverts.
628      *
629      * _Available since v3.1._
630      */
631     function functionCall(
632         address target,
633         bytes memory data,
634         string memory errorMessage
635     ) internal returns (bytes memory) {
636         return functionCallWithValue(target, data, 0, errorMessage);
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
641      * but also transferring `value` wei to `target`.
642      *
643      * Requirements:
644      *
645      * - the calling contract must have an ETH balance of at least `value`.
646      * - the called Solidity function must be `payable`.
647      *
648      * _Available since v3.1._
649      */
650     function functionCallWithValue(
651         address target,
652         bytes memory data,
653         uint256 value
654     ) internal returns (bytes memory) {
655         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
660      * with `errorMessage` as a fallback revert reason when `target` reverts.
661      *
662      * _Available since v3.1._
663      */
664     function functionCallWithValue(
665         address target,
666         bytes memory data,
667         uint256 value,
668         string memory errorMessage
669     ) internal returns (bytes memory) {
670         require(address(this).balance >= value, "Address: insufficient balance for call");
671         (bool success, bytes memory returndata) = target.call{value: value}(data);
672         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
677      * but performing a static call.
678      *
679      * _Available since v3.3._
680      */
681     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
682         return functionStaticCall(target, data, "Address: low-level static call failed");
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
687      * but performing a static call.
688      *
689      * _Available since v3.3._
690      */
691     function functionStaticCall(
692         address target,
693         bytes memory data,
694         string memory errorMessage
695     ) internal view returns (bytes memory) {
696         (bool success, bytes memory returndata) = target.staticcall(data);
697         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
698     }
699 
700     /**
701      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
702      * but performing a delegate call.
703      *
704      * _Available since v3.4._
705      */
706     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
707         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
708     }
709 
710     /**
711      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
712      * but performing a delegate call.
713      *
714      * _Available since v3.4._
715      */
716     function functionDelegateCall(
717         address target,
718         bytes memory data,
719         string memory errorMessage
720     ) internal returns (bytes memory) {
721         (bool success, bytes memory returndata) = target.delegatecall(data);
722         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
723     }
724 
725     /**
726      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
727      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
728      *
729      * _Available since v4.8._
730      */
731     function verifyCallResultFromTarget(
732         address target,
733         bool success,
734         bytes memory returndata,
735         string memory errorMessage
736     ) internal view returns (bytes memory) {
737         if (success) {
738             if (returndata.length == 0) {
739                 // only check isContract if the call was successful and the return data is empty
740                 // otherwise we already know that it was a contract
741                 require(isContract(target), "Address: call to non-contract");
742             }
743             return returndata;
744         } else {
745             _revert(returndata, errorMessage);
746         }
747     }
748 
749     /**
750      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
751      * revert reason or using the provided one.
752      *
753      * _Available since v4.3._
754      */
755     function verifyCallResult(
756         bool success,
757         bytes memory returndata,
758         string memory errorMessage
759     ) internal pure returns (bytes memory) {
760         if (success) {
761             return returndata;
762         } else {
763             _revert(returndata, errorMessage);
764         }
765     }
766 
767     function _revert(bytes memory returndata, string memory errorMessage) private pure {
768         // Look for revert reason and bubble it up if present
769         if (returndata.length > 0) {
770             // The easiest way to bubble the revert reason is using memory via assembly
771             /// @solidity memory-safe-assembly
772             assembly {
773                 let returndata_size := mload(returndata)
774                 revert(add(32, returndata), returndata_size)
775             }
776         } else {
777             revert(errorMessage);
778         }
779     }
780 }
781 
782 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
783 
784 
785 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
786 
787 pragma solidity ^0.8.0;
788 
789 /**
790  * @title ERC721 token receiver interface
791  * @dev Interface for any contract that wants to support safeTransfers
792  * from ERC721 asset contracts.
793  */
794 interface IERC721Receiver {
795     /**
796      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
797      * by `operator` from `from`, this function is called.
798      *
799      * It must return its Solidity selector to confirm the token transfer.
800      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
801      *
802      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
803      */
804     function onERC721Received(
805         address operator,
806         address from,
807         uint256 tokenId,
808         bytes calldata data
809     ) external returns (bytes4);
810 }
811 
812 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
813 
814 
815 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
816 
817 pragma solidity ^0.8.0;
818 
819 /**
820  * @dev Interface of the ERC165 standard, as defined in the
821  * https://eips.ethereum.org/EIPS/eip-165[EIP].
822  *
823  * Implementers can declare support of contract interfaces, which can then be
824  * queried by others ({ERC165Checker}).
825  *
826  * For an implementation, see {ERC165}.
827  */
828 interface IERC165 {
829     /**
830      * @dev Returns true if this contract implements the interface defined by
831      * `interfaceId`. See the corresponding
832      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
833      * to learn more about how these ids are created.
834      *
835      * This function call must use less than 30 000 gas.
836      */
837     function supportsInterface(bytes4 interfaceId) external view returns (bool);
838 }
839 
840 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
841 
842 
843 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
844 
845 pragma solidity ^0.8.0;
846 
847 
848 /**
849  * @dev Implementation of the {IERC165} interface.
850  *
851  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
852  * for the additional interface id that will be supported. For example:
853  *
854  * ```solidity
855  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
856  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
857  * }
858  * ```
859  *
860  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
861  */
862 abstract contract ERC165 is IERC165 {
863     /**
864      * @dev See {IERC165-supportsInterface}.
865      */
866     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
867         return interfaceId == type(IERC165).interfaceId;
868     }
869 }
870 
871 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
872 
873 
874 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
875 
876 pragma solidity ^0.8.0;
877 
878 
879 /**
880  * @dev Required interface of an ERC721 compliant contract.
881  */
882 interface IERC721 is IERC165 {
883     /**
884      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
885      */
886     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
887 
888     /**
889      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
890      */
891     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
892 
893     /**
894      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
895      */
896     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
897 
898     /**
899      * @dev Returns the number of tokens in ``owner``'s account.
900      */
901     function balanceOf(address owner) external view returns (uint256 balance);
902 
903     /**
904      * @dev Returns the owner of the `tokenId` token.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must exist.
909      */
910     function ownerOf(uint256 tokenId) external view returns (address owner);
911 
912     /**
913      * @dev Safely transfers `tokenId` token from `from` to `to`.
914      *
915      * Requirements:
916      *
917      * - `from` cannot be the zero address.
918      * - `to` cannot be the zero address.
919      * - `tokenId` token must exist and be owned by `from`.
920      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
921      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922      *
923      * Emits a {Transfer} event.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes calldata data
930     ) external;
931 
932     /**
933      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
934      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
935      *
936      * Requirements:
937      *
938      * - `from` cannot be the zero address.
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must exist and be owned by `from`.
941      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
942      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
943      *
944      * Emits a {Transfer} event.
945      */
946     function safeTransferFrom(
947         address from,
948         address to,
949         uint256 tokenId
950     ) external;
951 
952     /**
953      * @dev Transfers `tokenId` token from `from` to `to`.
954      *
955      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
956      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
957      * understand this adds an external call which potentially creates a reentrancy vulnerability.
958      *
959      * Requirements:
960      *
961      * - `from` cannot be the zero address.
962      * - `to` cannot be the zero address.
963      * - `tokenId` token must be owned by `from`.
964      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
965      *
966      * Emits a {Transfer} event.
967      */
968     function transferFrom(
969         address from,
970         address to,
971         uint256 tokenId
972     ) external;
973 
974     /**
975      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
976      * The approval is cleared when the token is transferred.
977      *
978      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
979      *
980      * Requirements:
981      *
982      * - The caller must own the token or be an approved operator.
983      * - `tokenId` must exist.
984      *
985      * Emits an {Approval} event.
986      */
987     function approve(address to, uint256 tokenId) external;
988 
989     /**
990      * @dev Approve or remove `operator` as an operator for the caller.
991      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
992      *
993      * Requirements:
994      *
995      * - The `operator` cannot be the caller.
996      *
997      * Emits an {ApprovalForAll} event.
998      */
999     function setApprovalForAll(address operator, bool _approved) external;
1000 
1001     /**
1002      * @dev Returns the account approved for `tokenId` token.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must exist.
1007      */
1008     function getApproved(uint256 tokenId) external view returns (address operator);
1009 
1010     /**
1011      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1012      *
1013      * See {setApprovalForAll}
1014      */
1015     function isApprovedForAll(address owner, address operator) external view returns (bool);
1016 }
1017 
1018 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1019 
1020 
1021 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1022 
1023 pragma solidity ^0.8.0;
1024 
1025 
1026 /**
1027  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1028  * @dev See https://eips.ethereum.org/EIPS/eip-721
1029  */
1030 interface IERC721Enumerable is IERC721 {
1031     /**
1032      * @dev Returns the total amount of tokens stored by the contract.
1033      */
1034     function totalSupply() external view returns (uint256);
1035 
1036     /**
1037      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1038      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1039      */
1040     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1041 
1042     /**
1043      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1044      * Use along with {totalSupply} to enumerate all tokens.
1045      */
1046     function tokenByIndex(uint256 index) external view returns (uint256);
1047 }
1048 
1049 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1050 
1051 
1052 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1053 
1054 pragma solidity ^0.8.0;
1055 
1056 
1057 /**
1058  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1059  * @dev See https://eips.ethereum.org/EIPS/eip-721
1060  */
1061 interface IERC721Metadata is IERC721 {
1062     /**
1063      * @dev Returns the token collection name.
1064      */
1065     function name() external view returns (string memory);
1066 
1067     /**
1068      * @dev Returns the token collection symbol.
1069      */
1070     function symbol() external view returns (string memory);
1071 
1072     /**
1073      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1074      */
1075     function tokenURI(uint256 tokenId) external view returns (string memory);
1076 }
1077 
1078 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1079 
1080 
1081 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1082 
1083 pragma solidity ^0.8.0;
1084 
1085 
1086 
1087 
1088 
1089 
1090 
1091 
1092 /**
1093  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1094  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1095  * {ERC721Enumerable}.
1096  */
1097 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1098     using Address for address;
1099     using Strings for uint256;
1100 
1101     // Token name
1102     string private _name;
1103 
1104     // Token symbol
1105     string private _symbol;
1106 
1107     // Mapping from token ID to owner address
1108     mapping(uint256 => address) private _owners;
1109 
1110     // Mapping owner address to token count
1111     mapping(address => uint256) private _balances;
1112 
1113     // Mapping from token ID to approved address
1114     mapping(uint256 => address) private _tokenApprovals;
1115 
1116     // Mapping from owner to operator approvals
1117     mapping(address => mapping(address => bool)) private _operatorApprovals;
1118 
1119     /**
1120      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1121      */
1122     constructor(string memory name_, string memory symbol_) {
1123         _name = name_;
1124         _symbol = symbol_;
1125     }
1126 
1127     /**
1128      * @dev See {IERC165-supportsInterface}.
1129      */
1130     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1131         return
1132             interfaceId == type(IERC721).interfaceId ||
1133             interfaceId == type(IERC721Metadata).interfaceId ||
1134             super.supportsInterface(interfaceId);
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-balanceOf}.
1139      */
1140     function balanceOf(address owner) public view virtual override returns (uint256) {
1141         require(owner != address(0), "ERC721: address zero is not a valid owner");
1142         return _balances[owner];
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-ownerOf}.
1147      */
1148     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1149         address owner = _ownerOf(tokenId);
1150         require(owner != address(0), "ERC721: invalid token ID");
1151         return owner;
1152     }
1153 
1154     /**
1155      * @dev See {IERC721Metadata-name}.
1156      */
1157     function name() public view virtual override returns (string memory) {
1158         return _name;
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Metadata-symbol}.
1163      */
1164     function symbol() public view virtual override returns (string memory) {
1165         return _symbol;
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Metadata-tokenURI}.
1170      */
1171     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1172         _requireMinted(tokenId);
1173 
1174         string memory baseURI = _baseURI();
1175         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1176     }
1177 
1178     /**
1179      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1180      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1181      * by default, can be overridden in child contracts.
1182      */
1183     function _baseURI() internal view virtual returns (string memory) {
1184         return "";
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-approve}.
1189      */
1190     function approve(address to, uint256 tokenId) public virtual override {
1191         address owner = ERC721.ownerOf(tokenId);
1192         require(to != owner, "ERC721: approval to current owner");
1193 
1194         require(
1195             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1196             "ERC721: approve caller is not token owner or approved for all"
1197         );
1198 
1199         _approve(to, tokenId);
1200     }
1201 
1202     /**
1203      * @dev See {IERC721-getApproved}.
1204      */
1205     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1206         _requireMinted(tokenId);
1207 
1208         return _tokenApprovals[tokenId];
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-setApprovalForAll}.
1213      */
1214     function setApprovalForAll(address operator, bool approved) public virtual override {
1215         _setApprovalForAll(_msgSender(), operator, approved);
1216     }
1217 
1218     /**
1219      * @dev See {IERC721-isApprovedForAll}.
1220      */
1221     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1222         return _operatorApprovals[owner][operator];
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-transferFrom}.
1227      */
1228     function transferFrom(
1229         address from,
1230         address to,
1231         uint256 tokenId
1232     ) public virtual override {
1233         //solhint-disable-next-line max-line-length
1234         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1235 
1236         _transfer(from, to, tokenId);
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-safeTransferFrom}.
1241      */
1242     function safeTransferFrom(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) public virtual override {
1247         safeTransferFrom(from, to, tokenId, "");
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-safeTransferFrom}.
1252      */
1253     function safeTransferFrom(
1254         address from,
1255         address to,
1256         uint256 tokenId,
1257         bytes memory data
1258     ) public virtual override {
1259         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1260         _safeTransfer(from, to, tokenId, data);
1261     }
1262 
1263     /**
1264      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1265      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1266      *
1267      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1268      *
1269      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1270      * implement alternative mechanisms to perform token transfer, such as signature-based.
1271      *
1272      * Requirements:
1273      *
1274      * - `from` cannot be the zero address.
1275      * - `to` cannot be the zero address.
1276      * - `tokenId` token must exist and be owned by `from`.
1277      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function _safeTransfer(
1282         address from,
1283         address to,
1284         uint256 tokenId,
1285         bytes memory data
1286     ) internal virtual {
1287         _transfer(from, to, tokenId);
1288         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1289     }
1290 
1291     /**
1292      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1293      */
1294     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1295         return _owners[tokenId];
1296     }
1297 
1298     /**
1299      * @dev Returns whether `tokenId` exists.
1300      *
1301      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1302      *
1303      * Tokens start existing when they are minted (`_mint`),
1304      * and stop existing when they are burned (`_burn`).
1305      */
1306     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1307         return _ownerOf(tokenId) != address(0);
1308     }
1309 
1310     /**
1311      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1312      *
1313      * Requirements:
1314      *
1315      * - `tokenId` must exist.
1316      */
1317     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1318         address owner = ERC721.ownerOf(tokenId);
1319         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1320     }
1321 
1322     /**
1323      * @dev Safely mints `tokenId` and transfers it to `to`.
1324      *
1325      * Requirements:
1326      *
1327      * - `tokenId` must not exist.
1328      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1329      *
1330      * Emits a {Transfer} event.
1331      */
1332     function _safeMint(address to, uint256 tokenId) internal virtual {
1333         _safeMint(to, tokenId, "");
1334     }
1335 
1336     /**
1337      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1338      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1339      */
1340     function _safeMint(
1341         address to,
1342         uint256 tokenId,
1343         bytes memory data
1344     ) internal virtual {
1345         _mint(to, tokenId);
1346         require(
1347             _checkOnERC721Received(address(0), to, tokenId, data),
1348             "ERC721: transfer to non ERC721Receiver implementer"
1349         );
1350     }
1351 
1352     /**
1353      * @dev Mints `tokenId` and transfers it to `to`.
1354      *
1355      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1356      *
1357      * Requirements:
1358      *
1359      * - `tokenId` must not exist.
1360      * - `to` cannot be the zero address.
1361      *
1362      * Emits a {Transfer} event.
1363      */
1364     function _mint(address to, uint256 tokenId) internal virtual {
1365         require(to != address(0), "ERC721: mint to the zero address");
1366         require(!_exists(tokenId), "ERC721: token already minted");
1367 
1368         _beforeTokenTransfer(address(0), to, tokenId, 1);
1369 
1370         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1371         require(!_exists(tokenId), "ERC721: token already minted");
1372 
1373         unchecked {
1374             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1375             // Given that tokens are minted one by one, it is impossible in practice that
1376             // this ever happens. Might change if we allow batch minting.
1377             // The ERC fails to describe this case.
1378             _balances[to] += 1;
1379         }
1380 
1381         _owners[tokenId] = to;
1382 
1383         emit Transfer(address(0), to, tokenId);
1384 
1385         _afterTokenTransfer(address(0), to, tokenId, 1);
1386     }
1387 
1388     /**
1389      * @dev Destroys `tokenId`.
1390      * The approval is cleared when the token is burned.
1391      * This is an internal function that does not check if the sender is authorized to operate on the token.
1392      *
1393      * Requirements:
1394      *
1395      * - `tokenId` must exist.
1396      *
1397      * Emits a {Transfer} event.
1398      */
1399     function _burn(uint256 tokenId) internal virtual {
1400         address owner = ERC721.ownerOf(tokenId);
1401 
1402         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1403 
1404         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1405         owner = ERC721.ownerOf(tokenId);
1406 
1407         // Clear approvals
1408         delete _tokenApprovals[tokenId];
1409 
1410         unchecked {
1411             // Cannot overflow, as that would require more tokens to be burned/transferred
1412             // out than the owner initially received through minting and transferring in.
1413             _balances[owner] -= 1;
1414         }
1415         delete _owners[tokenId];
1416 
1417         emit Transfer(owner, address(0), tokenId);
1418 
1419         _afterTokenTransfer(owner, address(0), tokenId, 1);
1420     }
1421 
1422     /**
1423      * @dev Transfers `tokenId` from `from` to `to`.
1424      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1425      *
1426      * Requirements:
1427      *
1428      * - `to` cannot be the zero address.
1429      * - `tokenId` token must be owned by `from`.
1430      *
1431      * Emits a {Transfer} event.
1432      */
1433     function _transfer(
1434         address from,
1435         address to,
1436         uint256 tokenId
1437     ) internal virtual {
1438         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1439         require(to != address(0), "ERC721: transfer to the zero address");
1440 
1441         _beforeTokenTransfer(from, to, tokenId, 1);
1442 
1443         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1444         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1445 
1446         // Clear approvals from the previous owner
1447         delete _tokenApprovals[tokenId];
1448 
1449         unchecked {
1450             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1451             // `from`'s balance is the number of token held, which is at least one before the current
1452             // transfer.
1453             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1454             // all 2**256 token ids to be minted, which in practice is impossible.
1455             _balances[from] -= 1;
1456             _balances[to] += 1;
1457         }
1458         _owners[tokenId] = to;
1459 
1460         emit Transfer(from, to, tokenId);
1461 
1462         _afterTokenTransfer(from, to, tokenId, 1);
1463     }
1464 
1465     /**
1466      * @dev Approve `to` to operate on `tokenId`
1467      *
1468      * Emits an {Approval} event.
1469      */
1470     function _approve(address to, uint256 tokenId) internal virtual {
1471         _tokenApprovals[tokenId] = to;
1472         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1473     }
1474 
1475     /**
1476      * @dev Approve `operator` to operate on all of `owner` tokens
1477      *
1478      * Emits an {ApprovalForAll} event.
1479      */
1480     function _setApprovalForAll(
1481         address owner,
1482         address operator,
1483         bool approved
1484     ) internal virtual {
1485         require(owner != operator, "ERC721: approve to caller");
1486         _operatorApprovals[owner][operator] = approved;
1487         emit ApprovalForAll(owner, operator, approved);
1488     }
1489 
1490     /**
1491      * @dev Reverts if the `tokenId` has not been minted yet.
1492      */
1493     function _requireMinted(uint256 tokenId) internal view virtual {
1494         require(_exists(tokenId), "ERC721: invalid token ID");
1495     }
1496 
1497     /**
1498      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1499      * The call is not executed if the target address is not a contract.
1500      *
1501      * @param from address representing the previous owner of the given token ID
1502      * @param to target address that will receive the tokens
1503      * @param tokenId uint256 ID of the token to be transferred
1504      * @param data bytes optional data to send along with the call
1505      * @return bool whether the call correctly returned the expected magic value
1506      */
1507     function _checkOnERC721Received(
1508         address from,
1509         address to,
1510         uint256 tokenId,
1511         bytes memory data
1512     ) private returns (bool) {
1513         if (to.isContract()) {
1514             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1515                 return retval == IERC721Receiver.onERC721Received.selector;
1516             } catch (bytes memory reason) {
1517                 if (reason.length == 0) {
1518                     revert("ERC721: transfer to non ERC721Receiver implementer");
1519                 } else {
1520                     /// @solidity memory-safe-assembly
1521                     assembly {
1522                         revert(add(32, reason), mload(reason))
1523                     }
1524                 }
1525             }
1526         } else {
1527             return true;
1528         }
1529     }
1530 
1531     /**
1532      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1533      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1534      *
1535      * Calling conditions:
1536      *
1537      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1538      * - When `from` is zero, the tokens will be minted for `to`.
1539      * - When `to` is zero, ``from``'s tokens will be burned.
1540      * - `from` and `to` are never both zero.
1541      * - `batchSize` is non-zero.
1542      *
1543      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1544      */
1545     function _beforeTokenTransfer(
1546         address from,
1547         address to,
1548         uint256, /* firstTokenId */
1549         uint256 batchSize
1550     ) internal virtual {
1551         if (batchSize > 1) {
1552             if (from != address(0)) {
1553                 _balances[from] -= batchSize;
1554             }
1555             if (to != address(0)) {
1556                 _balances[to] += batchSize;
1557             }
1558         }
1559     }
1560 
1561     /**
1562      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1563      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1564      *
1565      * Calling conditions:
1566      *
1567      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1568      * - When `from` is zero, the tokens were minted for `to`.
1569      * - When `to` is zero, ``from``'s tokens were burned.
1570      * - `from` and `to` are never both zero.
1571      * - `batchSize` is non-zero.
1572      *
1573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1574      */
1575     function _afterTokenTransfer(
1576         address from,
1577         address to,
1578         uint256 firstTokenId,
1579         uint256 batchSize
1580     ) internal virtual {}
1581 }
1582 
1583 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1584 
1585 
1586 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1587 
1588 pragma solidity ^0.8.0;
1589 
1590 
1591 
1592 /**
1593  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1594  * enumerability of all the token ids in the contract as well as all token ids owned by each
1595  * account.
1596  */
1597 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1598     // Mapping from owner to list of owned token IDs
1599     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1600 
1601     // Mapping from token ID to index of the owner tokens list
1602     mapping(uint256 => uint256) private _ownedTokensIndex;
1603 
1604     // Array with all token ids, used for enumeration
1605     uint256[] private _allTokens;
1606 
1607     // Mapping from token id to position in the allTokens array
1608     mapping(uint256 => uint256) private _allTokensIndex;
1609 
1610     /**
1611      * @dev See {IERC165-supportsInterface}.
1612      */
1613     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1614         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1615     }
1616 
1617     /**
1618      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1619      */
1620     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1621         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1622         return _ownedTokens[owner][index];
1623     }
1624 
1625     /**
1626      * @dev See {IERC721Enumerable-totalSupply}.
1627      */
1628     function totalSupply() public view virtual override returns (uint256) {
1629         return _allTokens.length;
1630     }
1631 
1632     /**
1633      * @dev See {IERC721Enumerable-tokenByIndex}.
1634      */
1635     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1636         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1637         return _allTokens[index];
1638     }
1639 
1640     /**
1641      * @dev See {ERC721-_beforeTokenTransfer}.
1642      */
1643     function _beforeTokenTransfer(
1644         address from,
1645         address to,
1646         uint256 firstTokenId,
1647         uint256 batchSize
1648     ) internal virtual override {
1649         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1650 
1651         if (batchSize > 1) {
1652             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1653             revert("ERC721Enumerable: consecutive transfers not supported");
1654         }
1655 
1656         uint256 tokenId = firstTokenId;
1657 
1658         if (from == address(0)) {
1659             _addTokenToAllTokensEnumeration(tokenId);
1660         } else if (from != to) {
1661             _removeTokenFromOwnerEnumeration(from, tokenId);
1662         }
1663         if (to == address(0)) {
1664             _removeTokenFromAllTokensEnumeration(tokenId);
1665         } else if (to != from) {
1666             _addTokenToOwnerEnumeration(to, tokenId);
1667         }
1668     }
1669 
1670     /**
1671      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1672      * @param to address representing the new owner of the given token ID
1673      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1674      */
1675     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1676         uint256 length = ERC721.balanceOf(to);
1677         _ownedTokens[to][length] = tokenId;
1678         _ownedTokensIndex[tokenId] = length;
1679     }
1680 
1681     /**
1682      * @dev Private function to add a token to this extension's token tracking data structures.
1683      * @param tokenId uint256 ID of the token to be added to the tokens list
1684      */
1685     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1686         _allTokensIndex[tokenId] = _allTokens.length;
1687         _allTokens.push(tokenId);
1688     }
1689 
1690     /**
1691      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1692      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1693      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1694      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1695      * @param from address representing the previous owner of the given token ID
1696      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1697      */
1698     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1699         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1700         // then delete the last slot (swap and pop).
1701 
1702         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1703         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1704 
1705         // When the token to delete is the last token, the swap operation is unnecessary
1706         if (tokenIndex != lastTokenIndex) {
1707             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1708 
1709             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1710             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1711         }
1712 
1713         // This also deletes the contents at the last position of the array
1714         delete _ownedTokensIndex[tokenId];
1715         delete _ownedTokens[from][lastTokenIndex];
1716     }
1717 
1718     /**
1719      * @dev Private function to remove a token from this extension's token tracking data structures.
1720      * This has O(1) time complexity, but alters the order of the _allTokens array.
1721      * @param tokenId uint256 ID of the token to be removed from the tokens list
1722      */
1723     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1724         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1725         // then delete the last slot (swap and pop).
1726 
1727         uint256 lastTokenIndex = _allTokens.length - 1;
1728         uint256 tokenIndex = _allTokensIndex[tokenId];
1729 
1730         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1731         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1732         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1733         uint256 lastTokenId = _allTokens[lastTokenIndex];
1734 
1735         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1736         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1737 
1738         // This also deletes the contents at the last position of the array
1739         delete _allTokensIndex[tokenId];
1740         _allTokens.pop();
1741     }
1742 }
1743 
1744 // File: contracts/PT_ERC721.sol
1745 
1746 
1747 
1748 pragma solidity >=0.7.0 <0.9.0;
1749 
1750 
1751 
1752 contract ProjectTreacherous is ERC721Enumerable, Ownable {
1753   using Strings for uint256;
1754 
1755   string public baseURI;
1756   string public baseExtension = ".json";
1757   string public notRevealedUri;
1758   uint256 public cost = 0.0 ether;
1759   uint256 public maxSupply = 350;
1760   uint256 public maxMintAmount = 1;
1761   uint256 public nftPerAddressLimit = 1;
1762   uint256 public ownerNftPerAddressLimit = 50;
1763   uint256 public ownerMaxMintAmount = 50;
1764   bool public paused = false;
1765   bool public revealed = false;
1766   bool public onlyWhitelisted = true;
1767   bool public onlyComrade = false;
1768   address[] public whitelistedAddresses;
1769   address[] public comradeAddresses;
1770   mapping(address => uint256) public addressMintedBalance;
1771 
1772 
1773   constructor(
1774     string memory _name,
1775     string memory _symbol,
1776     string memory _initBaseURI,
1777     string memory _initNotRevealedUri
1778   ) ERC721(_name, _symbol) {
1779     setBaseURI(_initBaseURI);
1780     setNotRevealedURI(_initNotRevealedUri);
1781   }
1782 
1783   // internal
1784   function _baseURI() internal view virtual override returns (string memory) {
1785     return baseURI;
1786   }
1787 
1788   //owner mint
1789   function ownerMint(uint256 _mintAmount) public payable {
1790     require(msg.sender == owner(), "Only the owner can call this function.");
1791     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1792       uint256 supply = totalSupply();
1793       require(ownerMintedCount + _mintAmount <= ownerNftPerAddressLimit, "max NFT per address exceeded");
1794       require(_mintAmount <= ownerMaxMintAmount, "max mint amount per session exceeded");
1795       require(msg.value >= cost * _mintAmount, "insufficient funds");
1796         for (uint256 i = 1; i <= _mintAmount; i++) {
1797           addressMintedBalance[msg.sender]++;
1798         _safeMint(msg.sender, supply + i);
1799     }
1800   }
1801   
1802   
1803   // public
1804   function mint(uint256 _mintAmount) public payable {
1805     require(!paused, "the contract is paused");
1806     uint256 supply = totalSupply();
1807     require(_mintAmount > 0, "need to mint at least 1 NFT");
1808     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1809     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1810     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1811     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1812      
1813 
1814     if (msg.sender != owner()) {
1815         if(onlyWhitelisted == true) {
1816             require(isWhitelisted(msg.sender), "user is not whitelisted");
1817             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1818         }
1819         require(msg.value >= cost * _mintAmount, "insufficient funds");
1820     }
1821 
1822     if (msg.sender != owner()) {
1823         if(onlyComrade == true) {
1824             require(isComrade(msg.sender), "user is not comrade");
1825             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1826         }
1827         require(msg.value >= cost * _mintAmount, "insufficient funds");
1828     }
1829     
1830     for (uint256 i = 1; i <= _mintAmount; i++) {
1831         addressMintedBalance[msg.sender]++;
1832       _safeMint(msg.sender, supply + i);
1833     }
1834   }
1835   
1836   function isWhitelisted(address _user) public view returns (bool) {
1837     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1838       if (whitelistedAddresses[i] == _user) {
1839           return true;
1840       }
1841     }
1842     return false;
1843   }
1844 
1845   function isComrade(address _user) public view returns (bool) {
1846     for (uint i = 0; i < comradeAddresses.length; i++) {
1847       if (comradeAddresses[i] == _user) {
1848           return true;
1849       }
1850     }
1851     return false;
1852   }
1853 
1854   function walletOfOwner(address _owner)
1855     public
1856     view
1857     returns (uint256[] memory)
1858   {
1859     uint256 ownerTokenCount = balanceOf(_owner);
1860     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1861     for (uint256 i; i < ownerTokenCount; i++) {
1862       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1863     }
1864     return tokenIds;
1865   }
1866 
1867   function tokenURI(uint256 tokenId)
1868     public
1869     view
1870     virtual
1871     override
1872     returns (string memory)
1873   {
1874     require(
1875       _exists(tokenId),
1876       "ERC721Metadata: URI query for nonexistent token"
1877     );
1878     
1879     if(revealed == false) {
1880         return notRevealedUri;
1881     }
1882 
1883     string memory currentBaseURI = _baseURI();
1884     return bytes(currentBaseURI).length > 0
1885         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1886         : "";
1887   }
1888 
1889   //only owner
1890 
1891   function reveal() public onlyOwner {
1892       revealed = true;
1893   }
1894   
1895   function editMintWindow(
1896     bool _onlyWhitelisted,
1897     bool _onlyComrade
1898   ) external onlyOwner {
1899       onlyWhitelisted = _onlyWhitelisted;
1900       onlyComrade = _onlyComrade;
1901   }
1902 
1903   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1904     nftPerAddressLimit = _limit;
1905   }
1906   
1907   function setCost(uint256 _newCost) public onlyOwner {
1908     cost = _newCost;
1909   }
1910 
1911   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1912     maxMintAmount = _newmaxMintAmount;
1913   }
1914 
1915   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1916     baseURI = _newBaseURI;
1917   }
1918 
1919   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1920     baseExtension = _newBaseExtension;
1921   }
1922   
1923   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1924     notRevealedUri = _notRevealedURI;
1925   }
1926 
1927   function pause(bool _state) public onlyOwner {
1928     paused = _state;
1929   }
1930   
1931   function setOnlyWhitelisted(bool _state) public onlyOwner {
1932     onlyWhitelisted = _state;
1933   }
1934   
1935   function whitelistUsers(address[] calldata _users) public onlyOwner {
1936     delete whitelistedAddresses;
1937     whitelistedAddresses = _users;
1938   }
1939  
1940   function comradeUsers(address[] calldata _users) public onlyOwner {
1941     delete comradeAddresses;
1942     comradeAddresses = _users;
1943   }
1944 
1945   function withdraw() public payable onlyOwner {
1946     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1947     require(os);
1948   }
1949 }