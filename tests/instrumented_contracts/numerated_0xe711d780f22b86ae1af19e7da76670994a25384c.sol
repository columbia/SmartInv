1 // File: @openzeppelin/contracts/utils/math/Math.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     enum Rounding {
13         Down, // Toward negative infinity
14         Up, // Toward infinity
15         Zero // Toward zero
16     }
17 
18     /**
19      * @dev Returns the largest of two numbers.
20      */
21     function max(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a > b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the smallest of two numbers.
27      */
28     function min(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a < b ? a : b;
30     }
31 
32     /**
33      * @dev Returns the average of two numbers. The result is rounded towards
34      * zero.
35      */
36     function average(uint256 a, uint256 b) internal pure returns (uint256) {
37         // (a + b) / 2 can overflow.
38         return (a & b) + (a ^ b) / 2;
39     }
40 
41     /**
42      * @dev Returns the ceiling of the division of two numbers.
43      *
44      * This differs from standard division with `/` in that it rounds up instead
45      * of rounding down.
46      */
47     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
48         // (a + b - 1) / b can overflow on addition, so we distribute.
49         return a == 0 ? 0 : (a - 1) / b + 1;
50     }
51 
52     /**
53      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
54      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
55      * with further edits by Uniswap Labs also under MIT license.
56      */
57     function mulDiv(
58         uint256 x,
59         uint256 y,
60         uint256 denominator
61     ) internal pure returns (uint256 result) {
62         unchecked {
63             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
64             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
65             // variables such that product = prod1 * 2^256 + prod0.
66             uint256 prod0; // Least significant 256 bits of the product
67             uint256 prod1; // Most significant 256 bits of the product
68             assembly {
69                 let mm := mulmod(x, y, not(0))
70                 prod0 := mul(x, y)
71                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
72             }
73 
74             // Handle non-overflow cases, 256 by 256 division.
75             if (prod1 == 0) {
76                 return prod0 / denominator;
77             }
78 
79             // Make sure the result is less than 2^256. Also prevents denominator == 0.
80             require(denominator > prod1);
81 
82             ///////////////////////////////////////////////
83             // 512 by 256 division.
84             ///////////////////////////////////////////////
85 
86             // Make division exact by subtracting the remainder from [prod1 prod0].
87             uint256 remainder;
88             assembly {
89                 // Compute remainder using mulmod.
90                 remainder := mulmod(x, y, denominator)
91 
92                 // Subtract 256 bit number from 512 bit number.
93                 prod1 := sub(prod1, gt(remainder, prod0))
94                 prod0 := sub(prod0, remainder)
95             }
96 
97             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
98             // See https://cs.stackexchange.com/q/138556/92363.
99 
100             // Does not overflow because the denominator cannot be zero at this stage in the function.
101             uint256 twos = denominator & (~denominator + 1);
102             assembly {
103                 // Divide denominator by twos.
104                 denominator := div(denominator, twos)
105 
106                 // Divide [prod1 prod0] by twos.
107                 prod0 := div(prod0, twos)
108 
109                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
110                 twos := add(div(sub(0, twos), twos), 1)
111             }
112 
113             // Shift in bits from prod1 into prod0.
114             prod0 |= prod1 * twos;
115 
116             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
117             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
118             // four bits. That is, denominator * inv = 1 mod 2^4.
119             uint256 inverse = (3 * denominator) ^ 2;
120 
121             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
122             // in modular arithmetic, doubling the correct bits in each step.
123             inverse *= 2 - denominator * inverse; // inverse mod 2^8
124             inverse *= 2 - denominator * inverse; // inverse mod 2^16
125             inverse *= 2 - denominator * inverse; // inverse mod 2^32
126             inverse *= 2 - denominator * inverse; // inverse mod 2^64
127             inverse *= 2 - denominator * inverse; // inverse mod 2^128
128             inverse *= 2 - denominator * inverse; // inverse mod 2^256
129 
130             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
131             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
132             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
133             // is no longer required.
134             result = prod0 * inverse;
135             return result;
136         }
137     }
138 
139     /**
140      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
141      */
142     function mulDiv(
143         uint256 x,
144         uint256 y,
145         uint256 denominator,
146         Rounding rounding
147     ) internal pure returns (uint256) {
148         uint256 result = mulDiv(x, y, denominator);
149         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
150             result += 1;
151         }
152         return result;
153     }
154 
155     /**
156      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
157      *
158      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
159      */
160     function sqrt(uint256 a) internal pure returns (uint256) {
161         if (a == 0) {
162             return 0;
163         }
164 
165         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
166         //
167         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
168         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
169         //
170         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
171         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
172         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
173         //
174         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
175         uint256 result = 1 << (log2(a) >> 1);
176 
177         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
178         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
179         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
180         // into the expected uint128 result.
181         unchecked {
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             return min(result, a / result);
190         }
191     }
192 
193     /**
194      * @notice Calculates sqrt(a), following the selected rounding direction.
195      */
196     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
197         unchecked {
198             uint256 result = sqrt(a);
199             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
200         }
201     }
202 
203     /**
204      * @dev Return the log in base 2, rounded down, of a positive value.
205      * Returns 0 if given 0.
206      */
207     function log2(uint256 value) internal pure returns (uint256) {
208         uint256 result = 0;
209         unchecked {
210             if (value >> 128 > 0) {
211                 value >>= 128;
212                 result += 128;
213             }
214             if (value >> 64 > 0) {
215                 value >>= 64;
216                 result += 64;
217             }
218             if (value >> 32 > 0) {
219                 value >>= 32;
220                 result += 32;
221             }
222             if (value >> 16 > 0) {
223                 value >>= 16;
224                 result += 16;
225             }
226             if (value >> 8 > 0) {
227                 value >>= 8;
228                 result += 8;
229             }
230             if (value >> 4 > 0) {
231                 value >>= 4;
232                 result += 4;
233             }
234             if (value >> 2 > 0) {
235                 value >>= 2;
236                 result += 2;
237             }
238             if (value >> 1 > 0) {
239                 result += 1;
240             }
241         }
242         return result;
243     }
244 
245     /**
246      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
247      * Returns 0 if given 0.
248      */
249     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
250         unchecked {
251             uint256 result = log2(value);
252             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
253         }
254     }
255 
256     /**
257      * @dev Return the log in base 10, rounded down, of a positive value.
258      * Returns 0 if given 0.
259      */
260     function log10(uint256 value) internal pure returns (uint256) {
261         uint256 result = 0;
262         unchecked {
263             if (value >= 10**64) {
264                 value /= 10**64;
265                 result += 64;
266             }
267             if (value >= 10**32) {
268                 value /= 10**32;
269                 result += 32;
270             }
271             if (value >= 10**16) {
272                 value /= 10**16;
273                 result += 16;
274             }
275             if (value >= 10**8) {
276                 value /= 10**8;
277                 result += 8;
278             }
279             if (value >= 10**4) {
280                 value /= 10**4;
281                 result += 4;
282             }
283             if (value >= 10**2) {
284                 value /= 10**2;
285                 result += 2;
286             }
287             if (value >= 10**1) {
288                 result += 1;
289             }
290         }
291         return result;
292     }
293 
294     /**
295      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
296      * Returns 0 if given 0.
297      */
298     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
299         unchecked {
300             uint256 result = log10(value);
301             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
302         }
303     }
304 
305     /**
306      * @dev Return the log in base 256, rounded down, of a positive value.
307      * Returns 0 if given 0.
308      *
309      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
310      */
311     function log256(uint256 value) internal pure returns (uint256) {
312         uint256 result = 0;
313         unchecked {
314             if (value >> 128 > 0) {
315                 value >>= 128;
316                 result += 16;
317             }
318             if (value >> 64 > 0) {
319                 value >>= 64;
320                 result += 8;
321             }
322             if (value >> 32 > 0) {
323                 value >>= 32;
324                 result += 4;
325             }
326             if (value >> 16 > 0) {
327                 value >>= 16;
328                 result += 2;
329             }
330             if (value >> 8 > 0) {
331                 result += 1;
332             }
333         }
334         return result;
335     }
336 
337     /**
338      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
339      * Returns 0 if given 0.
340      */
341     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
342         unchecked {
343             uint256 result = log256(value);
344             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
345         }
346     }
347 }
348 
349 // File: @openzeppelin/contracts/utils/Strings.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev String operations.
359  */
360 library Strings {
361     bytes16 private constant _SYMBOLS = "0123456789abcdef";
362     uint8 private constant _ADDRESS_LENGTH = 20;
363 
364     /**
365      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
366      */
367     function toString(uint256 value) internal pure returns (string memory) {
368         unchecked {
369             uint256 length = Math.log10(value) + 1;
370             string memory buffer = new string(length);
371             uint256 ptr;
372             /// @solidity memory-safe-assembly
373             assembly {
374                 ptr := add(buffer, add(32, length))
375             }
376             while (true) {
377                 ptr--;
378                 /// @solidity memory-safe-assembly
379                 assembly {
380                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
381                 }
382                 value /= 10;
383                 if (value == 0) break;
384             }
385             return buffer;
386         }
387     }
388 
389     /**
390      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
391      */
392     function toHexString(uint256 value) internal pure returns (string memory) {
393         unchecked {
394             return toHexString(value, Math.log256(value) + 1);
395         }
396     }
397 
398     /**
399      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
400      */
401     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
402         bytes memory buffer = new bytes(2 * length + 2);
403         buffer[0] = "0";
404         buffer[1] = "x";
405         for (uint256 i = 2 * length + 1; i > 1; --i) {
406             buffer[i] = _SYMBOLS[value & 0xf];
407             value >>= 4;
408         }
409         require(value == 0, "Strings: hex length insufficient");
410         return string(buffer);
411     }
412 
413     /**
414      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
415      */
416     function toHexString(address addr) internal pure returns (string memory) {
417         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
418     }
419 }
420 
421 // File: @openzeppelin/contracts/utils/Context.sol
422 
423 
424 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @dev Provides information about the current execution context, including the
430  * sender of the transaction and its data. While these are generally available
431  * via msg.sender and msg.data, they should not be accessed in such a direct
432  * manner, since when dealing with meta-transactions the account sending and
433  * paying for execution may not be the actual sender (as far as an application
434  * is concerned).
435  *
436  * This contract is only required for intermediate, library-like contracts.
437  */
438 abstract contract Context {
439     function _msgSender() internal view virtual returns (address) {
440         return msg.sender;
441     }
442 
443     function _msgData() internal view virtual returns (bytes calldata) {
444         return msg.data;
445     }
446 }
447 
448 // File: @openzeppelin/contracts/access/Ownable.sol
449 
450 
451 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 
456 /**
457  * @dev Contract module which provides a basic access control mechanism, where
458  * there is an account (an owner) that can be granted exclusive access to
459  * specific functions.
460  *
461  * By default, the owner account will be the one that deploys the contract. This
462  * can later be changed with {transferOwnership}.
463  *
464  * This module is used through inheritance. It will make available the modifier
465  * `onlyOwner`, which can be applied to your functions to restrict their use to
466  * the owner.
467  */
468 abstract contract Ownable is Context {
469     address private _owner;
470 
471     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
472 
473     /**
474      * @dev Initializes the contract setting the deployer as the initial owner.
475      */
476     constructor() {
477         _transferOwnership(_msgSender());
478     }
479 
480     /**
481      * @dev Throws if called by any account other than the owner.
482      */
483     modifier onlyOwner() {
484         _checkOwner();
485         _;
486     }
487 
488     /**
489      * @dev Returns the address of the current owner.
490      */
491     function owner() public view virtual returns (address) {
492         return _owner;
493     }
494 
495     /**
496      * @dev Throws if the sender is not the owner.
497      */
498     function _checkOwner() internal view virtual {
499         require(owner() == _msgSender(), "Ownable: caller is not the owner");
500     }
501 
502     /**
503      * @dev Leaves the contract without owner. It will not be possible to call
504      * `onlyOwner` functions anymore. Can only be called by the current owner.
505      *
506      * NOTE: Renouncing ownership will leave the contract without an owner,
507      * thereby removing any functionality that is only available to the owner.
508      */
509     function renounceOwnership() public virtual onlyOwner {
510         _transferOwnership(address(0));
511     }
512 
513     /**
514      * @dev Transfers ownership of the contract to a new account (`newOwner`).
515      * Can only be called by the current owner.
516      */
517     function transferOwnership(address newOwner) public virtual onlyOwner {
518         require(newOwner != address(0), "Ownable: new owner is the zero address");
519         _transferOwnership(newOwner);
520     }
521 
522     /**
523      * @dev Transfers ownership of the contract to a new account (`newOwner`).
524      * Internal function without access restriction.
525      */
526     function _transferOwnership(address newOwner) internal virtual {
527         address oldOwner = _owner;
528         _owner = newOwner;
529         emit OwnershipTransferred(oldOwner, newOwner);
530     }
531 }
532 
533 // File: @openzeppelin/contracts/utils/Address.sol
534 
535 
536 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
537 
538 pragma solidity ^0.8.1;
539 
540 /**
541  * @dev Collection of functions related to the address type
542  */
543 library Address {
544     /**
545      * @dev Returns true if `account` is a contract.
546      *
547      * [IMPORTANT]
548      * ====
549      * It is unsafe to assume that an address for which this function returns
550      * false is an externally-owned account (EOA) and not a contract.
551      *
552      * Among others, `isContract` will return false for the following
553      * types of addresses:
554      *
555      *  - an externally-owned account
556      *  - a contract in construction
557      *  - an address where a contract will be created
558      *  - an address where a contract lived, but was destroyed
559      * ====
560      *
561      * [IMPORTANT]
562      * ====
563      * You shouldn't rely on `isContract` to protect against flash loan attacks!
564      *
565      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
566      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
567      * constructor.
568      * ====
569      */
570     function isContract(address account) internal view returns (bool) {
571         // This method relies on extcodesize/address.code.length, which returns 0
572         // for contracts in construction, since the code is only stored at the end
573         // of the constructor execution.
574 
575         return account.code.length > 0;
576     }
577 
578     /**
579      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
580      * `recipient`, forwarding all available gas and reverting on errors.
581      *
582      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
583      * of certain opcodes, possibly making contracts go over the 2300 gas limit
584      * imposed by `transfer`, making them unable to receive funds via
585      * `transfer`. {sendValue} removes this limitation.
586      *
587      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
588      *
589      * IMPORTANT: because control is transferred to `recipient`, care must be
590      * taken to not create reentrancy vulnerabilities. Consider using
591      * {ReentrancyGuard} or the
592      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
593      */
594     function sendValue(address payable recipient, uint256 amount) internal {
595         require(address(this).balance >= amount, "Address: insufficient balance");
596 
597         (bool success, ) = recipient.call{value: amount}("");
598         require(success, "Address: unable to send value, recipient may have reverted");
599     }
600 
601     /**
602      * @dev Performs a Solidity function call using a low level `call`. A
603      * plain `call` is an unsafe replacement for a function call: use this
604      * function instead.
605      *
606      * If `target` reverts with a revert reason, it is bubbled up by this
607      * function (like regular Solidity function calls).
608      *
609      * Returns the raw returned data. To convert to the expected return value,
610      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
611      *
612      * Requirements:
613      *
614      * - `target` must be a contract.
615      * - calling `target` with `data` must not revert.
616      *
617      * _Available since v3.1._
618      */
619     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
620         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
625      * `errorMessage` as a fallback revert reason when `target` reverts.
626      *
627      * _Available since v3.1._
628      */
629     function functionCall(
630         address target,
631         bytes memory data,
632         string memory errorMessage
633     ) internal returns (bytes memory) {
634         return functionCallWithValue(target, data, 0, errorMessage);
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
639      * but also transferring `value` wei to `target`.
640      *
641      * Requirements:
642      *
643      * - the calling contract must have an ETH balance of at least `value`.
644      * - the called Solidity function must be `payable`.
645      *
646      * _Available since v3.1._
647      */
648     function functionCallWithValue(
649         address target,
650         bytes memory data,
651         uint256 value
652     ) internal returns (bytes memory) {
653         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
658      * with `errorMessage` as a fallback revert reason when `target` reverts.
659      *
660      * _Available since v3.1._
661      */
662     function functionCallWithValue(
663         address target,
664         bytes memory data,
665         uint256 value,
666         string memory errorMessage
667     ) internal returns (bytes memory) {
668         require(address(this).balance >= value, "Address: insufficient balance for call");
669         (bool success, bytes memory returndata) = target.call{value: value}(data);
670         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but performing a static call.
676      *
677      * _Available since v3.3._
678      */
679     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
680         return functionStaticCall(target, data, "Address: low-level static call failed");
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
685      * but performing a static call.
686      *
687      * _Available since v3.3._
688      */
689     function functionStaticCall(
690         address target,
691         bytes memory data,
692         string memory errorMessage
693     ) internal view returns (bytes memory) {
694         (bool success, bytes memory returndata) = target.staticcall(data);
695         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
700      * but performing a delegate call.
701      *
702      * _Available since v3.4._
703      */
704     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
705         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
710      * but performing a delegate call.
711      *
712      * _Available since v3.4._
713      */
714     function functionDelegateCall(
715         address target,
716         bytes memory data,
717         string memory errorMessage
718     ) internal returns (bytes memory) {
719         (bool success, bytes memory returndata) = target.delegatecall(data);
720         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
721     }
722 
723     /**
724      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
725      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
726      *
727      * _Available since v4.8._
728      */
729     function verifyCallResultFromTarget(
730         address target,
731         bool success,
732         bytes memory returndata,
733         string memory errorMessage
734     ) internal view returns (bytes memory) {
735         if (success) {
736             if (returndata.length == 0) {
737                 // only check isContract if the call was successful and the return data is empty
738                 // otherwise we already know that it was a contract
739                 require(isContract(target), "Address: call to non-contract");
740             }
741             return returndata;
742         } else {
743             _revert(returndata, errorMessage);
744         }
745     }
746 
747     /**
748      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
749      * revert reason or using the provided one.
750      *
751      * _Available since v4.3._
752      */
753     function verifyCallResult(
754         bool success,
755         bytes memory returndata,
756         string memory errorMessage
757     ) internal pure returns (bytes memory) {
758         if (success) {
759             return returndata;
760         } else {
761             _revert(returndata, errorMessage);
762         }
763     }
764 
765     function _revert(bytes memory returndata, string memory errorMessage) private pure {
766         // Look for revert reason and bubble it up if present
767         if (returndata.length > 0) {
768             // The easiest way to bubble the revert reason is using memory via assembly
769             /// @solidity memory-safe-assembly
770             assembly {
771                 let returndata_size := mload(returndata)
772                 revert(add(32, returndata), returndata_size)
773             }
774         } else {
775             revert(errorMessage);
776         }
777     }
778 }
779 
780 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
781 
782 
783 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 /**
788  * @dev Interface of the ERC165 standard, as defined in the
789  * https://eips.ethereum.org/EIPS/eip-165[EIP].
790  *
791  * Implementers can declare support of contract interfaces, which can then be
792  * queried by others ({ERC165Checker}).
793  *
794  * For an implementation, see {ERC165}.
795  */
796 interface IERC165 {
797     /**
798      * @dev Returns true if this contract implements the interface defined by
799      * `interfaceId`. See the corresponding
800      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
801      * to learn more about how these ids are created.
802      *
803      * This function call must use less than 30 000 gas.
804      */
805     function supportsInterface(bytes4 interfaceId) external view returns (bool);
806 }
807 
808 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
809 
810 
811 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
812 
813 pragma solidity ^0.8.0;
814 
815 
816 /**
817  * @dev Implementation of the {IERC165} interface.
818  *
819  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
820  * for the additional interface id that will be supported. For example:
821  *
822  * ```solidity
823  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
824  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
825  * }
826  * ```
827  *
828  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
829  */
830 abstract contract ERC165 is IERC165 {
831     /**
832      * @dev See {IERC165-supportsInterface}.
833      */
834     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
835         return interfaceId == type(IERC165).interfaceId;
836     }
837 }
838 
839 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
840 
841 
842 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
843 
844 pragma solidity ^0.8.0;
845 
846 
847 /**
848  * @dev _Available since v3.1._
849  */
850 interface IERC1155Receiver is IERC165 {
851     /**
852      * @dev Handles the receipt of a single ERC1155 token type. This function is
853      * called at the end of a `safeTransferFrom` after the balance has been updated.
854      *
855      * NOTE: To accept the transfer, this must return
856      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
857      * (i.e. 0xf23a6e61, or its own function selector).
858      *
859      * @param operator The address which initiated the transfer (i.e. msg.sender)
860      * @param from The address which previously owned the token
861      * @param id The ID of the token being transferred
862      * @param value The amount of tokens being transferred
863      * @param data Additional data with no specified format
864      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
865      */
866     function onERC1155Received(
867         address operator,
868         address from,
869         uint256 id,
870         uint256 value,
871         bytes calldata data
872     ) external returns (bytes4);
873 
874     /**
875      * @dev Handles the receipt of a multiple ERC1155 token types. This function
876      * is called at the end of a `safeBatchTransferFrom` after the balances have
877      * been updated.
878      *
879      * NOTE: To accept the transfer(s), this must return
880      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
881      * (i.e. 0xbc197c81, or its own function selector).
882      *
883      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
884      * @param from The address which previously owned the token
885      * @param ids An array containing ids of each token being transferred (order and length must match values array)
886      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
887      * @param data Additional data with no specified format
888      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
889      */
890     function onERC1155BatchReceived(
891         address operator,
892         address from,
893         uint256[] calldata ids,
894         uint256[] calldata values,
895         bytes calldata data
896     ) external returns (bytes4);
897 }
898 
899 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
900 
901 
902 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 
907 /**
908  * @dev Required interface of an ERC1155 compliant contract, as defined in the
909  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
910  *
911  * _Available since v3.1._
912  */
913 interface IERC1155 is IERC165 {
914     /**
915      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
916      */
917     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
918 
919     /**
920      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
921      * transfers.
922      */
923     event TransferBatch(
924         address indexed operator,
925         address indexed from,
926         address indexed to,
927         uint256[] ids,
928         uint256[] values
929     );
930 
931     /**
932      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
933      * `approved`.
934      */
935     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
936 
937     /**
938      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
939      *
940      * If an {URI} event was emitted for `id`, the standard
941      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
942      * returned by {IERC1155MetadataURI-uri}.
943      */
944     event URI(string value, uint256 indexed id);
945 
946     /**
947      * @dev Returns the amount of tokens of token type `id` owned by `account`.
948      *
949      * Requirements:
950      *
951      * - `account` cannot be the zero address.
952      */
953     function balanceOf(address account, uint256 id) external view returns (uint256);
954 
955     /**
956      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
957      *
958      * Requirements:
959      *
960      * - `accounts` and `ids` must have the same length.
961      */
962     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
963         external
964         view
965         returns (uint256[] memory);
966 
967     /**
968      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
969      *
970      * Emits an {ApprovalForAll} event.
971      *
972      * Requirements:
973      *
974      * - `operator` cannot be the caller.
975      */
976     function setApprovalForAll(address operator, bool approved) external;
977 
978     /**
979      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
980      *
981      * See {setApprovalForAll}.
982      */
983     function isApprovedForAll(address account, address operator) external view returns (bool);
984 
985     /**
986      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
987      *
988      * Emits a {TransferSingle} event.
989      *
990      * Requirements:
991      *
992      * - `to` cannot be the zero address.
993      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
994      * - `from` must have a balance of tokens of type `id` of at least `amount`.
995      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
996      * acceptance magic value.
997      */
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 id,
1002         uint256 amount,
1003         bytes calldata data
1004     ) external;
1005 
1006     /**
1007      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1008      *
1009      * Emits a {TransferBatch} event.
1010      *
1011      * Requirements:
1012      *
1013      * - `ids` and `amounts` must have the same length.
1014      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1015      * acceptance magic value.
1016      */
1017     function safeBatchTransferFrom(
1018         address from,
1019         address to,
1020         uint256[] calldata ids,
1021         uint256[] calldata amounts,
1022         bytes calldata data
1023     ) external;
1024 }
1025 
1026 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1027 
1028 
1029 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1030 
1031 pragma solidity ^0.8.0;
1032 
1033 
1034 /**
1035  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1036  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1037  *
1038  * _Available since v3.1._
1039  */
1040 interface IERC1155MetadataURI is IERC1155 {
1041     /**
1042      * @dev Returns the URI for token type `id`.
1043      *
1044      * If the `\{id\}` substring is present in the URI, it must be replaced by
1045      * clients with the actual token type ID.
1046      */
1047     function uri(uint256 id) external view returns (string memory);
1048 }
1049 
1050 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1051 
1052 
1053 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)
1054 
1055 pragma solidity ^0.8.0;
1056 
1057 
1058 
1059 
1060 
1061 
1062 
1063 /**
1064  * @dev Implementation of the basic standard multi-token.
1065  * See https://eips.ethereum.org/EIPS/eip-1155
1066  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1067  *
1068  * _Available since v3.1._
1069  */
1070 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1071     using Address for address;
1072 
1073     // Mapping from token ID to account balances
1074     mapping(uint256 => mapping(address => uint256)) private _balances;
1075 
1076     // Mapping from account to operator approvals
1077     mapping(address => mapping(address => bool)) private _operatorApprovals;
1078 
1079     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1080     string private _uri;
1081 
1082     /**
1083      * @dev See {_setURI}.
1084      */
1085     constructor(string memory uri_) {
1086         _setURI(uri_);
1087     }
1088 
1089     /**
1090      * @dev See {IERC165-supportsInterface}.
1091      */
1092     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1093         return
1094             interfaceId == type(IERC1155).interfaceId ||
1095             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1096             super.supportsInterface(interfaceId);
1097     }
1098 
1099     /**
1100      * @dev See {IERC1155MetadataURI-uri}.
1101      *
1102      * This implementation returns the same URI for *all* token types. It relies
1103      * on the token type ID substitution mechanism
1104      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1105      *
1106      * Clients calling this function must replace the `\{id\}` substring with the
1107      * actual token type ID.
1108      */
1109     function uri(uint256) public view virtual override returns (string memory) {
1110         return _uri;
1111     }
1112 
1113     /**
1114      * @dev See {IERC1155-balanceOf}.
1115      *
1116      * Requirements:
1117      *
1118      * - `account` cannot be the zero address.
1119      */
1120     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1121         require(account != address(0), "ERC1155: address zero is not a valid owner");
1122         return _balances[id][account];
1123     }
1124 
1125     /**
1126      * @dev See {IERC1155-balanceOfBatch}.
1127      *
1128      * Requirements:
1129      *
1130      * - `accounts` and `ids` must have the same length.
1131      */
1132     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1133         public
1134         view
1135         virtual
1136         override
1137         returns (uint256[] memory)
1138     {
1139         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1140 
1141         uint256[] memory batchBalances = new uint256[](accounts.length);
1142 
1143         for (uint256 i = 0; i < accounts.length; ++i) {
1144             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1145         }
1146 
1147         return batchBalances;
1148     }
1149 
1150     /**
1151      * @dev See {IERC1155-setApprovalForAll}.
1152      */
1153     function setApprovalForAll(address operator, bool approved) public virtual override {
1154         _setApprovalForAll(_msgSender(), operator, approved);
1155     }
1156 
1157     /**
1158      * @dev See {IERC1155-isApprovedForAll}.
1159      */
1160     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1161         return _operatorApprovals[account][operator];
1162     }
1163 
1164     /**
1165      * @dev See {IERC1155-safeTransferFrom}.
1166      */
1167     function safeTransferFrom(
1168         address from,
1169         address to,
1170         uint256 id,
1171         uint256 amount,
1172         bytes memory data
1173     ) public virtual override {
1174         require(
1175             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1176             "ERC1155: caller is not token owner or approved"
1177         );
1178         _safeTransferFrom(from, to, id, amount, data);
1179     }
1180 
1181     /**
1182      * @dev See {IERC1155-safeBatchTransferFrom}.
1183      */
1184     function safeBatchTransferFrom(
1185         address from,
1186         address to,
1187         uint256[] memory ids,
1188         uint256[] memory amounts,
1189         bytes memory data
1190     ) public virtual override {
1191         require(
1192             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1193             "ERC1155: caller is not token owner or approved"
1194         );
1195         _safeBatchTransferFrom(from, to, ids, amounts, data);
1196     }
1197 
1198     /**
1199      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1200      *
1201      * Emits a {TransferSingle} event.
1202      *
1203      * Requirements:
1204      *
1205      * - `to` cannot be the zero address.
1206      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1207      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1208      * acceptance magic value.
1209      */
1210     function _safeTransferFrom(
1211         address from,
1212         address to,
1213         uint256 id,
1214         uint256 amount,
1215         bytes memory data
1216     ) internal virtual {
1217         require(to != address(0), "ERC1155: transfer to the zero address");
1218 
1219         address operator = _msgSender();
1220         uint256[] memory ids = _asSingletonArray(id);
1221         uint256[] memory amounts = _asSingletonArray(amount);
1222 
1223         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1224 
1225         uint256 fromBalance = _balances[id][from];
1226         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1227         unchecked {
1228             _balances[id][from] = fromBalance - amount;
1229         }
1230         _balances[id][to] += amount;
1231 
1232         emit TransferSingle(operator, from, to, id, amount);
1233 
1234         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1235 
1236         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1237     }
1238 
1239     /**
1240      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1241      *
1242      * Emits a {TransferBatch} event.
1243      *
1244      * Requirements:
1245      *
1246      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1247      * acceptance magic value.
1248      */
1249     function _safeBatchTransferFrom(
1250         address from,
1251         address to,
1252         uint256[] memory ids,
1253         uint256[] memory amounts,
1254         bytes memory data
1255     ) internal virtual {
1256         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1257         require(to != address(0), "ERC1155: transfer to the zero address");
1258 
1259         address operator = _msgSender();
1260 
1261         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1262 
1263         for (uint256 i = 0; i < ids.length; ++i) {
1264             uint256 id = ids[i];
1265             uint256 amount = amounts[i];
1266 
1267             uint256 fromBalance = _balances[id][from];
1268             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1269             unchecked {
1270                 _balances[id][from] = fromBalance - amount;
1271             }
1272             _balances[id][to] += amount;
1273         }
1274 
1275         emit TransferBatch(operator, from, to, ids, amounts);
1276 
1277         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1278 
1279         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1280     }
1281 
1282     /**
1283      * @dev Sets a new URI for all token types, by relying on the token type ID
1284      * substitution mechanism
1285      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1286      *
1287      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1288      * URI or any of the amounts in the JSON file at said URI will be replaced by
1289      * clients with the token type ID.
1290      *
1291      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1292      * interpreted by clients as
1293      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1294      * for token type ID 0x4cce0.
1295      *
1296      * See {uri}.
1297      *
1298      * Because these URIs cannot be meaningfully represented by the {URI} event,
1299      * this function emits no events.
1300      */
1301     function _setURI(string memory newuri) internal virtual {
1302         _uri = newuri;
1303     }
1304 
1305     /**
1306      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1307      *
1308      * Emits a {TransferSingle} event.
1309      *
1310      * Requirements:
1311      *
1312      * - `to` cannot be the zero address.
1313      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1314      * acceptance magic value.
1315      */
1316     function _mint(
1317         address to,
1318         uint256 id,
1319         uint256 amount,
1320         bytes memory data
1321     ) internal virtual {
1322         require(to != address(0), "ERC1155: mint to the zero address");
1323 
1324         address operator = _msgSender();
1325         uint256[] memory ids = _asSingletonArray(id);
1326         uint256[] memory amounts = _asSingletonArray(amount);
1327 
1328         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1329 
1330         _balances[id][to] += amount;
1331         emit TransferSingle(operator, address(0), to, id, amount);
1332 
1333         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1334 
1335         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1336     }
1337 
1338     /**
1339      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1340      *
1341      * Emits a {TransferBatch} event.
1342      *
1343      * Requirements:
1344      *
1345      * - `ids` and `amounts` must have the same length.
1346      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1347      * acceptance magic value.
1348      */
1349     function _mintBatch(
1350         address to,
1351         uint256[] memory ids,
1352         uint256[] memory amounts,
1353         bytes memory data
1354     ) internal virtual {
1355         require(to != address(0), "ERC1155: mint to the zero address");
1356         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1357 
1358         address operator = _msgSender();
1359 
1360         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1361 
1362         for (uint256 i = 0; i < ids.length; i++) {
1363             _balances[ids[i]][to] += amounts[i];
1364         }
1365 
1366         emit TransferBatch(operator, address(0), to, ids, amounts);
1367 
1368         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1369 
1370         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1371     }
1372 
1373     /**
1374      * @dev Destroys `amount` tokens of token type `id` from `from`
1375      *
1376      * Emits a {TransferSingle} event.
1377      *
1378      * Requirements:
1379      *
1380      * - `from` cannot be the zero address.
1381      * - `from` must have at least `amount` tokens of token type `id`.
1382      */
1383     function _burn(
1384         address from,
1385         uint256 id,
1386         uint256 amount
1387     ) internal virtual {
1388         require(from != address(0), "ERC1155: burn from the zero address");
1389 
1390         address operator = _msgSender();
1391         uint256[] memory ids = _asSingletonArray(id);
1392         uint256[] memory amounts = _asSingletonArray(amount);
1393 
1394         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1395 
1396         uint256 fromBalance = _balances[id][from];
1397         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1398         unchecked {
1399             _balances[id][from] = fromBalance - amount;
1400         }
1401 
1402         emit TransferSingle(operator, from, address(0), id, amount);
1403 
1404         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1405     }
1406 
1407     /**
1408      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1409      *
1410      * Emits a {TransferBatch} event.
1411      *
1412      * Requirements:
1413      *
1414      * - `ids` and `amounts` must have the same length.
1415      */
1416     function _burnBatch(
1417         address from,
1418         uint256[] memory ids,
1419         uint256[] memory amounts
1420     ) internal virtual {
1421         require(from != address(0), "ERC1155: burn from the zero address");
1422         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1423 
1424         address operator = _msgSender();
1425 
1426         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1427 
1428         for (uint256 i = 0; i < ids.length; i++) {
1429             uint256 id = ids[i];
1430             uint256 amount = amounts[i];
1431 
1432             uint256 fromBalance = _balances[id][from];
1433             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1434             unchecked {
1435                 _balances[id][from] = fromBalance - amount;
1436             }
1437         }
1438 
1439         emit TransferBatch(operator, from, address(0), ids, amounts);
1440 
1441         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1442     }
1443 
1444     /**
1445      * @dev Approve `operator` to operate on all of `owner` tokens
1446      *
1447      * Emits an {ApprovalForAll} event.
1448      */
1449     function _setApprovalForAll(
1450         address owner,
1451         address operator,
1452         bool approved
1453     ) internal virtual {
1454         require(owner != operator, "ERC1155: setting approval status for self");
1455         _operatorApprovals[owner][operator] = approved;
1456         emit ApprovalForAll(owner, operator, approved);
1457     }
1458 
1459     /**
1460      * @dev Hook that is called before any token transfer. This includes minting
1461      * and burning, as well as batched variants.
1462      *
1463      * The same hook is called on both single and batched variants. For single
1464      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1465      *
1466      * Calling conditions (for each `id` and `amount` pair):
1467      *
1468      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1469      * of token type `id` will be  transferred to `to`.
1470      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1471      * for `to`.
1472      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1473      * will be burned.
1474      * - `from` and `to` are never both zero.
1475      * - `ids` and `amounts` have the same, non-zero length.
1476      *
1477      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1478      */
1479     function _beforeTokenTransfer(
1480         address operator,
1481         address from,
1482         address to,
1483         uint256[] memory ids,
1484         uint256[] memory amounts,
1485         bytes memory data
1486     ) internal virtual {}
1487 
1488     /**
1489      * @dev Hook that is called after any token transfer. This includes minting
1490      * and burning, as well as batched variants.
1491      *
1492      * The same hook is called on both single and batched variants. For single
1493      * transfers, the length of the `id` and `amount` arrays will be 1.
1494      *
1495      * Calling conditions (for each `id` and `amount` pair):
1496      *
1497      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1498      * of token type `id` will be  transferred to `to`.
1499      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1500      * for `to`.
1501      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1502      * will be burned.
1503      * - `from` and `to` are never both zero.
1504      * - `ids` and `amounts` have the same, non-zero length.
1505      *
1506      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1507      */
1508     function _afterTokenTransfer(
1509         address operator,
1510         address from,
1511         address to,
1512         uint256[] memory ids,
1513         uint256[] memory amounts,
1514         bytes memory data
1515     ) internal virtual {}
1516 
1517     function _doSafeTransferAcceptanceCheck(
1518         address operator,
1519         address from,
1520         address to,
1521         uint256 id,
1522         uint256 amount,
1523         bytes memory data
1524     ) private {
1525         if (to.isContract()) {
1526             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1527                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1528                     revert("ERC1155: ERC1155Receiver rejected tokens");
1529                 }
1530             } catch Error(string memory reason) {
1531                 revert(reason);
1532             } catch {
1533                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1534             }
1535         }
1536     }
1537 
1538     function _doSafeBatchTransferAcceptanceCheck(
1539         address operator,
1540         address from,
1541         address to,
1542         uint256[] memory ids,
1543         uint256[] memory amounts,
1544         bytes memory data
1545     ) private {
1546         if (to.isContract()) {
1547             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1548                 bytes4 response
1549             ) {
1550                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1551                     revert("ERC1155: ERC1155Receiver rejected tokens");
1552                 }
1553             } catch Error(string memory reason) {
1554                 revert(reason);
1555             } catch {
1556                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1557             }
1558         }
1559     }
1560 
1561     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1562         uint256[] memory array = new uint256[](1);
1563         array[0] = element;
1564 
1565         return array;
1566     }
1567 }
1568 
1569 // File: contracts/els1155.sol
1570 
1571 
1572 
1573 pragma solidity ^0.8.17;
1574 
1575 
1576 
1577 
1578 contract ELSSPACE is ERC1155, Ownable {
1579     // Token name
1580     string private _name;
1581 
1582     // Token symbol
1583     string private _symbol;
1584 
1585     // Supplies
1586     uint public supply = 0;
1587     uint public period = 1;
1588     uint public price = 120000000000000000;
1589     uint public maxPeriodSupply = 833;
1590     uint public maxSupply = 3333;
1591 
1592     // Beneficiary
1593     address public beneficiaryAddress;
1594 
1595     constructor(address _beneficiaryAddress) ERC1155("ipfs://QmYMK5962vMoM2BSko16tHg2cXi6e8x1xX23vANvfsjvHN/{id}.json") {
1596         _name = "ELS SPACE";
1597         _symbol = "ELSS";
1598         beneficiaryAddress = _beneficiaryAddress;
1599     }
1600 
1601     function name() public view returns (string memory) {
1602         return _name;
1603     }
1604 
1605     function symbol() public view returns (string memory) {
1606         return _symbol;
1607     }
1608 
1609     function changeBeneficiaryAddress(address _beneficiaryAddress) external onlyOwner {
1610         beneficiaryAddress = _beneficiaryAddress;
1611     }
1612 
1613     function changePrice(uint _price) external onlyOwner {
1614         price = _price;
1615     }
1616 
1617     function mint(uint _tokenId) public payable returns (uint) {
1618         supply += 1;
1619 
1620         require(supply <= maxPeriodSupply, "Mint: Max tokens supply for current period reached!");
1621 
1622         require(supply <= maxSupply, "Mint: Max tokens supply reached!");
1623 
1624         require(msg.value >= price, "Mint: Not enough gold has been sent!");
1625 
1626         payable(beneficiaryAddress).transfer(msg.value);
1627 
1628         _mint(msg.sender, _tokenId, 1, "");
1629 
1630         return _tokenId;
1631     }
1632 
1633     function mintBatch(uint[] memory _tokenIds, uint[] memory _amounts) external onlyOwner {
1634         _mintBatch(beneficiaryAddress, _tokenIds, _amounts, "");
1635     }
1636 
1637     function totalSupply() public view returns (uint) {
1638         return supply;
1639     }
1640 
1641     function startNewPeriod(uint _newPeriod, uint _newPrice, uint _maxPeriodSupply) external onlyOwner {
1642         period = _newPeriod;
1643         price = _newPrice;
1644         maxPeriodSupply = _maxPeriodSupply;
1645     }
1646 
1647     function stopPeriod() external onlyOwner {
1648         period = 0;
1649     }
1650 }