1 // File: @openzeppelin/contracts/utils/math/Math.sol
2 
3 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
4 // SPDX-License-Identifier: MIT
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library Math {
11     enum Rounding {
12         Down, // Toward negative infinity
13         Up, // Toward infinity
14         Zero // Toward zero
15     }
16 
17     /**
18      * @dev Returns the largest of two numbers.
19      */
20     function max(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a > b ? a : b;
22     }
23 
24     /**
25      * @dev Returns the smallest of two numbers.
26      */
27     function min(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a < b ? a : b;
29     }
30 
31     /**
32      * @dev Returns the average of two numbers. The result is rounded towards
33      * zero.
34      */
35     function average(uint256 a, uint256 b) internal pure returns (uint256) {
36         // (a + b) / 2 can overflow.
37         return (a & b) + (a ^ b) / 2;
38     }
39 
40     /**
41      * @dev Returns the ceiling of the division of two numbers.
42      *
43      * This differs from standard division with `/` in that it rounds up instead
44      * of rounding down.
45      */
46     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
47         // (a + b - 1) / b can overflow on addition, so we distribute.
48         return a == 0 ? 0 : (a - 1) / b + 1;
49     }
50 
51     /**
52      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
53      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
54      * with further edits by Uniswap Labs also under MIT license.
55      */
56     function mulDiv(
57         uint256 x,
58         uint256 y,
59         uint256 denominator
60     ) internal pure returns (uint256 result) {
61         unchecked {
62             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
63             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
64             // variables such that product = prod1 * 2^256 + prod0.
65             uint256 prod0; // Least significant 256 bits of the product
66             uint256 prod1; // Most significant 256 bits of the product
67             assembly {
68                 let mm := mulmod(x, y, not(0))
69                 prod0 := mul(x, y)
70                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
71             }
72 
73             // Handle non-overflow cases, 256 by 256 division.
74             if (prod1 == 0) {
75                 return prod0 / denominator;
76             }
77 
78             // Make sure the result is less than 2^256. Also prevents denominator == 0.
79             require(denominator > prod1);
80 
81             ///////////////////////////////////////////////
82             // 512 by 256 division.
83             ///////////////////////////////////////////////
84 
85             // Make division exact by subtracting the remainder from [prod1 prod0].
86             uint256 remainder;
87             assembly {
88                 // Compute remainder using mulmod.
89                 remainder := mulmod(x, y, denominator)
90 
91                 // Subtract 256 bit number from 512 bit number.
92                 prod1 := sub(prod1, gt(remainder, prod0))
93                 prod0 := sub(prod0, remainder)
94             }
95 
96             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
97             // See https://cs.stackexchange.com/q/138556/92363.
98 
99             // Does not overflow because the denominator cannot be zero at this stage in the function.
100             uint256 twos = denominator & (~denominator + 1);
101             assembly {
102                 // Divide denominator by twos.
103                 denominator := div(denominator, twos)
104 
105                 // Divide [prod1 prod0] by twos.
106                 prod0 := div(prod0, twos)
107 
108                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
109                 twos := add(div(sub(0, twos), twos), 1)
110             }
111 
112             // Shift in bits from prod1 into prod0.
113             prod0 |= prod1 * twos;
114 
115             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
116             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
117             // four bits. That is, denominator * inv = 1 mod 2^4.
118             uint256 inverse = (3 * denominator) ^ 2;
119 
120             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
121             // in modular arithmetic, doubling the correct bits in each step.
122             inverse *= 2 - denominator * inverse; // inverse mod 2^8
123             inverse *= 2 - denominator * inverse; // inverse mod 2^16
124             inverse *= 2 - denominator * inverse; // inverse mod 2^32
125             inverse *= 2 - denominator * inverse; // inverse mod 2^64
126             inverse *= 2 - denominator * inverse; // inverse mod 2^128
127             inverse *= 2 - denominator * inverse; // inverse mod 2^256
128 
129             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
130             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
131             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
132             // is no longer required.
133             result = prod0 * inverse;
134             return result;
135         }
136     }
137 
138     /**
139      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
140      */
141     function mulDiv(
142         uint256 x,
143         uint256 y,
144         uint256 denominator,
145         Rounding rounding
146     ) internal pure returns (uint256) {
147         uint256 result = mulDiv(x, y, denominator);
148         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
149             result += 1;
150         }
151         return result;
152     }
153 
154     /**
155      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
156      *
157      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
158      */
159     function sqrt(uint256 a) internal pure returns (uint256) {
160         if (a == 0) {
161             return 0;
162         }
163 
164         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
165         //
166         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
167         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
168         //
169         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
170         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
171         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
172         //
173         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
174         uint256 result = 1 << (log2(a) >> 1);
175 
176         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
177         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
178         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
179         // into the expected uint128 result.
180         unchecked {
181             result = (result + a / result) >> 1;
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             return min(result, a / result);
189         }
190     }
191 
192     /**
193      * @notice Calculates sqrt(a), following the selected rounding direction.
194      */
195     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
196         unchecked {
197             uint256 result = sqrt(a);
198             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
199         }
200     }
201 
202     /**
203      * @dev Return the log in base 2, rounded down, of a positive value.
204      * Returns 0 if given 0.
205      */
206     function log2(uint256 value) internal pure returns (uint256) {
207         uint256 result = 0;
208         unchecked {
209             if (value >> 128 > 0) {
210                 value >>= 128;
211                 result += 128;
212             }
213             if (value >> 64 > 0) {
214                 value >>= 64;
215                 result += 64;
216             }
217             if (value >> 32 > 0) {
218                 value >>= 32;
219                 result += 32;
220             }
221             if (value >> 16 > 0) {
222                 value >>= 16;
223                 result += 16;
224             }
225             if (value >> 8 > 0) {
226                 value >>= 8;
227                 result += 8;
228             }
229             if (value >> 4 > 0) {
230                 value >>= 4;
231                 result += 4;
232             }
233             if (value >> 2 > 0) {
234                 value >>= 2;
235                 result += 2;
236             }
237             if (value >> 1 > 0) {
238                 result += 1;
239             }
240         }
241         return result;
242     }
243 
244     /**
245      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
246      * Returns 0 if given 0.
247      */
248     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
249         unchecked {
250             uint256 result = log2(value);
251             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
252         }
253     }
254 
255     /**
256      * @dev Return the log in base 10, rounded down, of a positive value.
257      * Returns 0 if given 0.
258      */
259     function log10(uint256 value) internal pure returns (uint256) {
260         uint256 result = 0;
261         unchecked {
262             if (value >= 10**64) {
263                 value /= 10**64;
264                 result += 64;
265             }
266             if (value >= 10**32) {
267                 value /= 10**32;
268                 result += 32;
269             }
270             if (value >= 10**16) {
271                 value /= 10**16;
272                 result += 16;
273             }
274             if (value >= 10**8) {
275                 value /= 10**8;
276                 result += 8;
277             }
278             if (value >= 10**4) {
279                 value /= 10**4;
280                 result += 4;
281             }
282             if (value >= 10**2) {
283                 value /= 10**2;
284                 result += 2;
285             }
286             if (value >= 10**1) {
287                 result += 1;
288             }
289         }
290         return result;
291     }
292 
293     /**
294      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
295      * Returns 0 if given 0.
296      */
297     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
298         unchecked {
299             uint256 result = log10(value);
300             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
301         }
302     }
303 
304     /**
305      * @dev Return the log in base 256, rounded down, of a positive value.
306      * Returns 0 if given 0.
307      *
308      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
309      */
310     function log256(uint256 value) internal pure returns (uint256) {
311         uint256 result = 0;
312         unchecked {
313             if (value >> 128 > 0) {
314                 value >>= 128;
315                 result += 16;
316             }
317             if (value >> 64 > 0) {
318                 value >>= 64;
319                 result += 8;
320             }
321             if (value >> 32 > 0) {
322                 value >>= 32;
323                 result += 4;
324             }
325             if (value >> 16 > 0) {
326                 value >>= 16;
327                 result += 2;
328             }
329             if (value >> 8 > 0) {
330                 result += 1;
331             }
332         }
333         return result;
334     }
335 
336     /**
337      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
338      * Returns 0 if given 0.
339      */
340     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
341         unchecked {
342             uint256 result = log256(value);
343             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
344         }
345     }
346 }
347 
348 // File: @openzeppelin/contracts/utils/Strings.sol
349 
350 
351 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
352 
353 pragma solidity ^0.8.0;
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
420 // File: @openzeppelin/contracts/utils/Context.sol
421 
422 
423 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 /**
428  * @dev Provides information about the current execution context, including the
429  * sender of the transaction and its data. While these are generally available
430  * via msg.sender and msg.data, they should not be accessed in such a direct
431  * manner, since when dealing with meta-transactions the account sending and
432  * paying for execution may not be the actual sender (as far as an application
433  * is concerned).
434  *
435  * This contract is only required for intermediate, library-like contracts.
436  */
437 abstract contract Context {
438     function _msgSender() internal view virtual returns (address) {
439         return msg.sender;
440     }
441 
442     function _msgData() internal view virtual returns (bytes calldata) {
443         return msg.data;
444     }
445 }
446 
447 // File: @openzeppelin/contracts/access/Ownable.sol
448 
449 
450 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 
455 /**
456  * @dev Contract module which provides a basic access control mechanism, where
457  * there is an account (an owner) that can be granted exclusive access to
458  * specific functions.
459  *
460  * By default, the owner account will be the one that deploys the contract. This
461  * can later be changed with {transferOwnership}.
462  *
463  * This module is used through inheritance. It will make available the modifier
464  * `onlyOwner`, which can be applied to your functions to restrict their use to
465  * the owner.
466  */
467 abstract contract Ownable is Context {
468     address private _owner;
469 
470     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
471 
472     /**
473      * @dev Initializes the contract setting the deployer as the initial owner.
474      */
475     constructor() {
476         _transferOwnership(_msgSender());
477     }
478 
479     /**
480      * @dev Throws if called by any account other than the owner.
481      */
482     modifier onlyOwner() {
483         _checkOwner();
484         _;
485     }
486 
487     /**
488      * @dev Returns the address of the current owner.
489      */
490     function owner() public view virtual returns (address) {
491         return _owner;
492     }
493 
494     /**
495      * @dev Throws if the sender is not the owner.
496      */
497     function _checkOwner() internal view virtual {
498         require(owner() == _msgSender(), "Ownable: caller is not the owner");
499     }
500 
501     /**
502      * @dev Leaves the contract without owner. It will not be possible to call
503      * `onlyOwner` functions anymore. Can only be called by the current owner.
504      *
505      * NOTE: Renouncing ownership will leave the contract without an owner,
506      * thereby removing any functionality that is only available to the owner.
507      */
508     function renounceOwnership() public virtual onlyOwner {
509         _transferOwnership(address(0));
510     }
511 
512     /**
513      * @dev Transfers ownership of the contract to a new account (`newOwner`).
514      * Can only be called by the current owner.
515      */
516     function transferOwnership(address newOwner) public virtual onlyOwner {
517         require(newOwner != address(0), "Ownable: new owner is the zero address");
518         _transferOwnership(newOwner);
519     }
520 
521     /**
522      * @dev Transfers ownership of the contract to a new account (`newOwner`).
523      * Internal function without access restriction.
524      */
525     function _transferOwnership(address newOwner) internal virtual {
526         address oldOwner = _owner;
527         _owner = newOwner;
528         emit OwnershipTransferred(oldOwner, newOwner);
529     }
530 }
531 
532 // File: @openzeppelin/contracts/utils/Address.sol
533 
534 
535 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
536 
537 pragma solidity ^0.8.1;
538 
539 /**
540  * @dev Collection of functions related to the address type
541  */
542 library Address {
543     /**
544      * @dev Returns true if `account` is a contract.
545      *
546      * [IMPORTANT]
547      * ====
548      * It is unsafe to assume that an address for which this function returns
549      * false is an externally-owned account (EOA) and not a contract.
550      *
551      * Among others, `isContract` will return false for the following
552      * types of addresses:
553      *
554      *  - an externally-owned account
555      *  - a contract in construction
556      *  - an address where a contract will be created
557      *  - an address where a contract lived, but was destroyed
558      * ====
559      *
560      * [IMPORTANT]
561      * ====
562      * You shouldn't rely on `isContract` to protect against flash loan attacks!
563      *
564      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
565      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
566      * constructor.
567      * ====
568      */
569     function isContract(address account) internal view returns (bool) {
570         // This method relies on extcodesize/address.code.length, which returns 0
571         // for contracts in construction, since the code is only stored at the end
572         // of the constructor execution.
573 
574         return account.code.length > 0;
575     }
576 
577     /**
578      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
579      * `recipient`, forwarding all available gas and reverting on errors.
580      *
581      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
582      * of certain opcodes, possibly making contracts go over the 2300 gas limit
583      * imposed by `transfer`, making them unable to receive funds via
584      * `transfer`. {sendValue} removes this limitation.
585      *
586      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
587      *
588      * IMPORTANT: because control is transferred to `recipient`, care must be
589      * taken to not create reentrancy vulnerabilities. Consider using
590      * {ReentrancyGuard} or the
591      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
592      */
593     function sendValue(address payable recipient, uint256 amount) internal {
594         require(address(this).balance >= amount, "Address: insufficient balance");
595 
596         (bool success, ) = recipient.call{value: amount}("");
597         require(success, "Address: unable to send value, recipient may have reverted");
598     }
599 
600     /**
601      * @dev Performs a Solidity function call using a low level `call`. A
602      * plain `call` is an unsafe replacement for a function call: use this
603      * function instead.
604      *
605      * If `target` reverts with a revert reason, it is bubbled up by this
606      * function (like regular Solidity function calls).
607      *
608      * Returns the raw returned data. To convert to the expected return value,
609      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
610      *
611      * Requirements:
612      *
613      * - `target` must be a contract.
614      * - calling `target` with `data` must not revert.
615      *
616      * _Available since v3.1._
617      */
618     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
619         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
624      * `errorMessage` as a fallback revert reason when `target` reverts.
625      *
626      * _Available since v3.1._
627      */
628     function functionCall(
629         address target,
630         bytes memory data,
631         string memory errorMessage
632     ) internal returns (bytes memory) {
633         return functionCallWithValue(target, data, 0, errorMessage);
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
638      * but also transferring `value` wei to `target`.
639      *
640      * Requirements:
641      *
642      * - the calling contract must have an ETH balance of at least `value`.
643      * - the called Solidity function must be `payable`.
644      *
645      * _Available since v3.1._
646      */
647     function functionCallWithValue(
648         address target,
649         bytes memory data,
650         uint256 value
651     ) internal returns (bytes memory) {
652         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
657      * with `errorMessage` as a fallback revert reason when `target` reverts.
658      *
659      * _Available since v3.1._
660      */
661     function functionCallWithValue(
662         address target,
663         bytes memory data,
664         uint256 value,
665         string memory errorMessage
666     ) internal returns (bytes memory) {
667         require(address(this).balance >= value, "Address: insufficient balance for call");
668         (bool success, bytes memory returndata) = target.call{value: value}(data);
669         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
674      * but performing a static call.
675      *
676      * _Available since v3.3._
677      */
678     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
679         return functionStaticCall(target, data, "Address: low-level static call failed");
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
684      * but performing a static call.
685      *
686      * _Available since v3.3._
687      */
688     function functionStaticCall(
689         address target,
690         bytes memory data,
691         string memory errorMessage
692     ) internal view returns (bytes memory) {
693         (bool success, bytes memory returndata) = target.staticcall(data);
694         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
699      * but performing a delegate call.
700      *
701      * _Available since v3.4._
702      */
703     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
704         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
709      * but performing a delegate call.
710      *
711      * _Available since v3.4._
712      */
713     function functionDelegateCall(
714         address target,
715         bytes memory data,
716         string memory errorMessage
717     ) internal returns (bytes memory) {
718         (bool success, bytes memory returndata) = target.delegatecall(data);
719         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
720     }
721 
722     /**
723      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
724      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
725      *
726      * _Available since v4.8._
727      */
728     function verifyCallResultFromTarget(
729         address target,
730         bool success,
731         bytes memory returndata,
732         string memory errorMessage
733     ) internal view returns (bytes memory) {
734         if (success) {
735             if (returndata.length == 0) {
736                 // only check isContract if the call was successful and the return data is empty
737                 // otherwise we already know that it was a contract
738                 require(isContract(target), "Address: call to non-contract");
739             }
740             return returndata;
741         } else {
742             _revert(returndata, errorMessage);
743         }
744     }
745 
746     /**
747      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
748      * revert reason or using the provided one.
749      *
750      * _Available since v4.3._
751      */
752     function verifyCallResult(
753         bool success,
754         bytes memory returndata,
755         string memory errorMessage
756     ) internal pure returns (bytes memory) {
757         if (success) {
758             return returndata;
759         } else {
760             _revert(returndata, errorMessage);
761         }
762     }
763 
764     function _revert(bytes memory returndata, string memory errorMessage) private pure {
765         // Look for revert reason and bubble it up if present
766         if (returndata.length > 0) {
767             // The easiest way to bubble the revert reason is using memory via assembly
768             /// @solidity memory-safe-assembly
769             assembly {
770                 let returndata_size := mload(returndata)
771                 revert(add(32, returndata), returndata_size)
772             }
773         } else {
774             revert(errorMessage);
775         }
776     }
777 }
778 
779 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
780 
781 
782 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
783 
784 pragma solidity ^0.8.0;
785 
786 /**
787  * @title ERC721 token receiver interface
788  * @dev Interface for any contract that wants to support safeTransfers
789  * from ERC721 asset contracts.
790  */
791 interface IERC721Receiver {
792     /**
793      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
794      * by `operator` from `from`, this function is called.
795      *
796      * It must return its Solidity selector to confirm the token transfer.
797      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
798      *
799      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
800      */
801     function onERC721Received(
802         address operator,
803         address from,
804         uint256 tokenId,
805         bytes calldata data
806     ) external returns (bytes4);
807 }
808 
809 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
810 
811 
812 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
813 
814 pragma solidity ^0.8.0;
815 
816 /**
817  * @dev Interface of the ERC165 standard, as defined in the
818  * https://eips.ethereum.org/EIPS/eip-165[EIP].
819  *
820  * Implementers can declare support of contract interfaces, which can then be
821  * queried by others ({ERC165Checker}).
822  *
823  * For an implementation, see {ERC165}.
824  */
825 interface IERC165 {
826     /**
827      * @dev Returns true if this contract implements the interface defined by
828      * `interfaceId`. See the corresponding
829      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
830      * to learn more about how these ids are created.
831      *
832      * This function call must use less than 30 000 gas.
833      */
834     function supportsInterface(bytes4 interfaceId) external view returns (bool);
835 }
836 
837 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
838 
839 
840 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
841 
842 pragma solidity ^0.8.0;
843 
844 
845 /**
846  * @dev Implementation of the {IERC165} interface.
847  *
848  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
849  * for the additional interface id that will be supported. For example:
850  *
851  * ```solidity
852  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
853  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
854  * }
855  * ```
856  *
857  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
858  */
859 abstract contract ERC165 is IERC165 {
860     /**
861      * @dev See {IERC165-supportsInterface}.
862      */
863     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
864         return interfaceId == type(IERC165).interfaceId;
865     }
866 }
867 
868 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
869 
870 
871 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
872 
873 pragma solidity ^0.8.0;
874 
875 
876 /**
877  * @dev Required interface of an ERC721 compliant contract.
878  */
879 interface IERC721 is IERC165 {
880     /**
881      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
882      */
883     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
884 
885     /**
886      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
887      */
888     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
889 
890     /**
891      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
892      */
893     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
894 
895     /**
896      * @dev Returns the number of tokens in ``owner``'s account.
897      */
898     function balanceOf(address owner) external view returns (uint256 balance);
899 
900     /**
901      * @dev Returns the owner of the `tokenId` token.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must exist.
906      */
907     function ownerOf(uint256 tokenId) external view returns (address owner);
908 
909     /**
910      * @dev Safely transfers `tokenId` token from `from` to `to`.
911      *
912      * Requirements:
913      *
914      * - `from` cannot be the zero address.
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must exist and be owned by `from`.
917      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
918      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
919      *
920      * Emits a {Transfer} event.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes calldata data
927     ) external;
928 
929     /**
930      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
931      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
932      *
933      * Requirements:
934      *
935      * - `from` cannot be the zero address.
936      * - `to` cannot be the zero address.
937      * - `tokenId` token must exist and be owned by `from`.
938      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
939      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
940      *
941      * Emits a {Transfer} event.
942      */
943     function safeTransferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) external;
948 
949     /**
950      * @dev Transfers `tokenId` token from `from` to `to`.
951      *
952      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
953      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
954      * understand this adds an external call which potentially creates a reentrancy vulnerability.
955      *
956      * Requirements:
957      *
958      * - `from` cannot be the zero address.
959      * - `to` cannot be the zero address.
960      * - `tokenId` token must be owned by `from`.
961      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
962      *
963      * Emits a {Transfer} event.
964      */
965     function transferFrom(
966         address from,
967         address to,
968         uint256 tokenId
969     ) external;
970 
971     /**
972      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
973      * The approval is cleared when the token is transferred.
974      *
975      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
976      *
977      * Requirements:
978      *
979      * - The caller must own the token or be an approved operator.
980      * - `tokenId` must exist.
981      *
982      * Emits an {Approval} event.
983      */
984     function approve(address to, uint256 tokenId) external;
985 
986     /**
987      * @dev Approve or remove `operator` as an operator for the caller.
988      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
989      *
990      * Requirements:
991      *
992      * - The `operator` cannot be the caller.
993      *
994      * Emits an {ApprovalForAll} event.
995      */
996     function setApprovalForAll(address operator, bool _approved) external;
997 
998     /**
999      * @dev Returns the account approved for `tokenId` token.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must exist.
1004      */
1005     function getApproved(uint256 tokenId) external view returns (address operator);
1006 
1007     /**
1008      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1009      *
1010      * See {setApprovalForAll}
1011      */
1012     function isApprovedForAll(address owner, address operator) external view returns (bool);
1013 }
1014 
1015 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1016 
1017 
1018 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1019 
1020 pragma solidity ^0.8.0;
1021 
1022 
1023 /**
1024  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1025  * @dev See https://eips.ethereum.org/EIPS/eip-721
1026  */
1027 interface IERC721Metadata is IERC721 {
1028     /**
1029      * @dev Returns the token collection name.
1030      */
1031     function name() external view returns (string memory);
1032 
1033     /**
1034      * @dev Returns the token collection symbol.
1035      */
1036     function symbol() external view returns (string memory);
1037 
1038     /**
1039      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1040      */
1041     function tokenURI(uint256 tokenId) external view returns (string memory);
1042 }
1043 
1044 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1045 
1046 
1047 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1048 
1049 pragma solidity ^0.8.0;
1050 
1051 
1052 
1053 
1054 
1055 
1056 
1057 
1058 /**
1059  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1060  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1061  * {ERC721Enumerable}.
1062  */
1063 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1064     using Address for address;
1065     using Strings for uint256;
1066 
1067     // Token name
1068     string private _name;
1069 
1070     // Token symbol
1071     string private _symbol;
1072 
1073     // Mapping from token ID to owner address
1074     mapping(uint256 => address) private _owners;
1075 
1076     // Mapping owner address to token count
1077     mapping(address => uint256) private _balances;
1078 
1079     // Mapping from token ID to approved address
1080     mapping(uint256 => address) private _tokenApprovals;
1081 
1082     // Mapping from owner to operator approvals
1083     mapping(address => mapping(address => bool)) private _operatorApprovals;
1084 
1085     /**
1086      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1087      */
1088     constructor(string memory name_, string memory symbol_) {
1089         _name = name_;
1090         _symbol = symbol_;
1091     }
1092 
1093     /**
1094      * @dev See {IERC165-supportsInterface}.
1095      */
1096     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1097         return
1098             interfaceId == type(IERC721).interfaceId ||
1099             interfaceId == type(IERC721Metadata).interfaceId ||
1100             super.supportsInterface(interfaceId);
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-balanceOf}.
1105      */
1106     function balanceOf(address owner) public view virtual override returns (uint256) {
1107         require(owner != address(0), "ERC721: address zero is not a valid owner");
1108         return _balances[owner];
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-ownerOf}.
1113      */
1114     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1115         address owner = _ownerOf(tokenId);
1116         require(owner != address(0), "ERC721: invalid token ID");
1117         return owner;
1118     }
1119 
1120     /**
1121      * @dev See {IERC721Metadata-name}.
1122      */
1123     function name() public view virtual override returns (string memory) {
1124         return _name;
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Metadata-symbol}.
1129      */
1130     function symbol() public view virtual override returns (string memory) {
1131         return _symbol;
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Metadata-tokenURI}.
1136      */
1137     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1138         _requireMinted(tokenId);
1139 
1140         string memory baseURI = _baseURI();
1141         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1142     }
1143 
1144     /**
1145      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1146      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1147      * by default, can be overridden in child contracts.
1148      */
1149     function _baseURI() internal view virtual returns (string memory) {
1150         return "";
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-approve}.
1155      */
1156     function approve(address to, uint256 tokenId) public virtual override {
1157         address owner = ERC721.ownerOf(tokenId);
1158         require(to != owner, "ERC721: approval to current owner");
1159 
1160         require(
1161             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1162             "ERC721: approve caller is not token owner or approved for all"
1163         );
1164 
1165         _approve(to, tokenId);
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-getApproved}.
1170      */
1171     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1172         _requireMinted(tokenId);
1173 
1174         return _tokenApprovals[tokenId];
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-setApprovalForAll}.
1179      */
1180     function setApprovalForAll(address operator, bool approved) public virtual override {
1181         _setApprovalForAll(_msgSender(), operator, approved);
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-isApprovedForAll}.
1186      */
1187     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1188         return _operatorApprovals[owner][operator];
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-transferFrom}.
1193      */
1194     function transferFrom(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) public virtual override {
1199         //solhint-disable-next-line max-line-length
1200         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1201 
1202         _transfer(from, to, tokenId);
1203     }
1204 
1205     /**
1206      * @dev See {IERC721-safeTransferFrom}.
1207      */
1208     function safeTransferFrom(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) public virtual override {
1213         safeTransferFrom(from, to, tokenId, "");
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-safeTransferFrom}.
1218      */
1219     function safeTransferFrom(
1220         address from,
1221         address to,
1222         uint256 tokenId,
1223         bytes memory data
1224     ) public virtual override {
1225         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1226         _safeTransfer(from, to, tokenId, data);
1227     }
1228 
1229     /**
1230      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1231      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1232      *
1233      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1234      *
1235      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1236      * implement alternative mechanisms to perform token transfer, such as signature-based.
1237      *
1238      * Requirements:
1239      *
1240      * - `from` cannot be the zero address.
1241      * - `to` cannot be the zero address.
1242      * - `tokenId` token must exist and be owned by `from`.
1243      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _safeTransfer(
1248         address from,
1249         address to,
1250         uint256 tokenId,
1251         bytes memory data
1252     ) internal virtual {
1253         _transfer(from, to, tokenId);
1254         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1255     }
1256 
1257     /**
1258      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1259      */
1260     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1261         return _owners[tokenId];
1262     }
1263 
1264     /**
1265      * @dev Returns whether `tokenId` exists.
1266      *
1267      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1268      *
1269      * Tokens start existing when they are minted (`_mint`),
1270      * and stop existing when they are burned (`_burn`).
1271      */
1272     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1273         return _ownerOf(tokenId) != address(0);
1274     }
1275 
1276     /**
1277      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1278      *
1279      * Requirements:
1280      *
1281      * - `tokenId` must exist.
1282      */
1283     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1284         address owner = ERC721.ownerOf(tokenId);
1285         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1286     }
1287 
1288     /**
1289      * @dev Safely mints `tokenId` and transfers it to `to`.
1290      *
1291      * Requirements:
1292      *
1293      * - `tokenId` must not exist.
1294      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1295      *
1296      * Emits a {Transfer} event.
1297      */
1298     function _safeMint(address to, uint256 tokenId) internal virtual {
1299         _safeMint(to, tokenId, "");
1300     }
1301 
1302     /**
1303      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1304      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1305      */
1306     function _safeMint(
1307         address to,
1308         uint256 tokenId,
1309         bytes memory data
1310     ) internal virtual {
1311         _mint(to, tokenId);
1312         require(
1313             _checkOnERC721Received(address(0), to, tokenId, data),
1314             "ERC721: transfer to non ERC721Receiver implementer"
1315         );
1316     }
1317 
1318     /**
1319      * @dev Mints `tokenId` and transfers it to `to`.
1320      *
1321      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1322      *
1323      * Requirements:
1324      *
1325      * - `tokenId` must not exist.
1326      * - `to` cannot be the zero address.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function _mint(address to, uint256 tokenId) internal virtual {
1331         require(to != address(0), "ERC721: mint to the zero address");
1332         require(!_exists(tokenId), "ERC721: token already minted");
1333 
1334         _beforeTokenTransfer(address(0), to, tokenId, 1);
1335 
1336         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1337         require(!_exists(tokenId), "ERC721: token already minted");
1338 
1339         unchecked {
1340             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1341             // Given that tokens are minted one by one, it is impossible in practice that
1342             // this ever happens. Might change if we allow batch minting.
1343             // The ERC fails to describe this case.
1344             _balances[to] += 1;
1345         }
1346 
1347         _owners[tokenId] = to;
1348 
1349         emit Transfer(address(0), to, tokenId);
1350 
1351         _afterTokenTransfer(address(0), to, tokenId, 1);
1352     }
1353 
1354     /**
1355      * @dev Destroys `tokenId`.
1356      * The approval is cleared when the token is burned.
1357      * This is an internal function that does not check if the sender is authorized to operate on the token.
1358      *
1359      * Requirements:
1360      *
1361      * - `tokenId` must exist.
1362      *
1363      * Emits a {Transfer} event.
1364      */
1365     function _burn(uint256 tokenId) internal virtual {
1366         address owner = ERC721.ownerOf(tokenId);
1367 
1368         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1369 
1370         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1371         owner = ERC721.ownerOf(tokenId);
1372 
1373         // Clear approvals
1374         delete _tokenApprovals[tokenId];
1375 
1376         unchecked {
1377             // Cannot overflow, as that would require more tokens to be burned/transferred
1378             // out than the owner initially received through minting and transferring in.
1379             _balances[owner] -= 1;
1380         }
1381         delete _owners[tokenId];
1382 
1383         emit Transfer(owner, address(0), tokenId);
1384 
1385         _afterTokenTransfer(owner, address(0), tokenId, 1);
1386     }
1387 
1388     /**
1389      * @dev Transfers `tokenId` from `from` to `to`.
1390      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1391      *
1392      * Requirements:
1393      *
1394      * - `to` cannot be the zero address.
1395      * - `tokenId` token must be owned by `from`.
1396      *
1397      * Emits a {Transfer} event.
1398      */
1399     function _transfer(
1400         address from,
1401         address to,
1402         uint256 tokenId
1403     ) internal virtual {
1404         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1405         require(to != address(0), "ERC721: transfer to the zero address");
1406 
1407         _beforeTokenTransfer(from, to, tokenId, 1);
1408 
1409         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1410         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1411 
1412         // Clear approvals from the previous owner
1413         delete _tokenApprovals[tokenId];
1414 
1415         unchecked {
1416             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1417             // `from`'s balance is the number of token held, which is at least one before the current
1418             // transfer.
1419             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1420             // all 2**256 token ids to be minted, which in practice is impossible.
1421             _balances[from] -= 1;
1422             _balances[to] += 1;
1423         }
1424         _owners[tokenId] = to;
1425 
1426         emit Transfer(from, to, tokenId);
1427 
1428         _afterTokenTransfer(from, to, tokenId, 1);
1429     }
1430 
1431     /**
1432      * @dev Approve `to` to operate on `tokenId`
1433      *
1434      * Emits an {Approval} event.
1435      */
1436     function _approve(address to, uint256 tokenId) internal virtual {
1437         _tokenApprovals[tokenId] = to;
1438         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1439     }
1440 
1441     /**
1442      * @dev Approve `operator` to operate on all of `owner` tokens
1443      *
1444      * Emits an {ApprovalForAll} event.
1445      */
1446     function _setApprovalForAll(
1447         address owner,
1448         address operator,
1449         bool approved
1450     ) internal virtual {
1451         require(owner != operator, "ERC721: approve to caller");
1452         _operatorApprovals[owner][operator] = approved;
1453         emit ApprovalForAll(owner, operator, approved);
1454     }
1455 
1456     /**
1457      * @dev Reverts if the `tokenId` has not been minted yet.
1458      */
1459     function _requireMinted(uint256 tokenId) internal view virtual {
1460         require(_exists(tokenId), "ERC721: invalid token ID");
1461     }
1462 
1463     /**
1464      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1465      * The call is not executed if the target address is not a contract.
1466      *
1467      * @param from address representing the previous owner of the given token ID
1468      * @param to target address that will receive the tokens
1469      * @param tokenId uint256 ID of the token to be transferred
1470      * @param data bytes optional data to send along with the call
1471      * @return bool whether the call correctly returned the expected magic value
1472      */
1473     function _checkOnERC721Received(
1474         address from,
1475         address to,
1476         uint256 tokenId,
1477         bytes memory data
1478     ) private returns (bool) {
1479         if (to.isContract()) {
1480             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1481                 return retval == IERC721Receiver.onERC721Received.selector;
1482             } catch (bytes memory reason) {
1483                 if (reason.length == 0) {
1484                     revert("ERC721: transfer to non ERC721Receiver implementer");
1485                 } else {
1486                     /// @solidity memory-safe-assembly
1487                     assembly {
1488                         revert(add(32, reason), mload(reason))
1489                     }
1490                 }
1491             }
1492         } else {
1493             return true;
1494         }
1495     }
1496 
1497     /**
1498      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1499      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1500      *
1501      * Calling conditions:
1502      *
1503      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1504      * - When `from` is zero, the tokens will be minted for `to`.
1505      * - When `to` is zero, ``from``'s tokens will be burned.
1506      * - `from` and `to` are never both zero.
1507      * - `batchSize` is non-zero.
1508      *
1509      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1510      */
1511     function _beforeTokenTransfer(
1512         address from,
1513         address to,
1514         uint256, /* firstTokenId */
1515         uint256 batchSize
1516     ) internal virtual {
1517         if (batchSize > 1) {
1518             if (from != address(0)) {
1519                 _balances[from] -= batchSize;
1520             }
1521             if (to != address(0)) {
1522                 _balances[to] += batchSize;
1523             }
1524         }
1525     }
1526 
1527     /**
1528      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1529      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1530      *
1531      * Calling conditions:
1532      *
1533      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1534      * - When `from` is zero, the tokens were minted for `to`.
1535      * - When `to` is zero, ``from``'s tokens were burned.
1536      * - `from` and `to` are never both zero.
1537      * - `batchSize` is non-zero.
1538      *
1539      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1540      */
1541     function _afterTokenTransfer(
1542         address from,
1543         address to,
1544         uint256 firstTokenId,
1545         uint256 batchSize
1546     ) internal virtual {}
1547 }
1548 
1549 // File: contracts/TipsyLandCredit.sol
1550 
1551 
1552 pragma solidity ^0.8.0;
1553 
1554 
1555 
1556 contract TipsyLandCredit is ERC721, Ownable {
1557     event Transaction(address from, string txType);
1558 
1559     constructor() ERC721("TipsyLandCredit", "TSLCRD") {}
1560 
1561     function payment() external payable {
1562         emit Transaction(msg.sender, "sc");
1563     }
1564 
1565     function withdraw() external onlyOwner {
1566         uint256 balance = address(this).balance;
1567         payable(msg.sender).transfer(balance);
1568     }
1569 }