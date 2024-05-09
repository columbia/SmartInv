1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
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
344             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
345         }
346     }
347 }
348 
349 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
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
421 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
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
448 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
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
533 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
534 
535 
536 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
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
587      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
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
780 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
781 
782 
783 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 /**
788  * @title ERC721 token receiver interface
789  * @dev Interface for any contract that wants to support safeTransfers
790  * from ERC721 asset contracts.
791  */
792 interface IERC721Receiver {
793     /**
794      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
795      * by `operator` from `from`, this function is called.
796      *
797      * It must return its Solidity selector to confirm the token transfer.
798      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
799      *
800      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
801      */
802     function onERC721Received(
803         address operator,
804         address from,
805         uint256 tokenId,
806         bytes calldata data
807     ) external returns (bytes4);
808 }
809 
810 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
811 
812 
813 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
814 
815 pragma solidity ^0.8.0;
816 
817 /**
818  * @dev Interface of the ERC165 standard, as defined in the
819  * https://eips.ethereum.org/EIPS/eip-165[EIP].
820  *
821  * Implementers can declare support of contract interfaces, which can then be
822  * queried by others ({ERC165Checker}).
823  *
824  * For an implementation, see {ERC165}.
825  */
826 interface IERC165 {
827     /**
828      * @dev Returns true if this contract implements the interface defined by
829      * `interfaceId`. See the corresponding
830      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
831      * to learn more about how these ids are created.
832      *
833      * This function call must use less than 30 000 gas.
834      */
835     function supportsInterface(bytes4 interfaceId) external view returns (bool);
836 }
837 
838 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
839 
840 
841 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
842 
843 pragma solidity ^0.8.0;
844 
845 
846 /**
847  * @dev Implementation of the {IERC165} interface.
848  *
849  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
850  * for the additional interface id that will be supported. For example:
851  *
852  * ```solidity
853  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
854  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
855  * }
856  * ```
857  *
858  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
859  */
860 abstract contract ERC165 is IERC165 {
861     /**
862      * @dev See {IERC165-supportsInterface}.
863      */
864     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
865         return interfaceId == type(IERC165).interfaceId;
866     }
867 }
868 
869 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
870 
871 
872 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 
877 /**
878  * @dev Required interface of an ERC721 compliant contract.
879  */
880 interface IERC721 is IERC165 {
881     /**
882      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
883      */
884     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
885 
886     /**
887      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
888      */
889     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
890 
891     /**
892      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
893      */
894     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
895 
896     /**
897      * @dev Returns the number of tokens in ``owner``'s account.
898      */
899     function balanceOf(address owner) external view returns (uint256 balance);
900 
901     /**
902      * @dev Returns the owner of the `tokenId` token.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      */
908     function ownerOf(uint256 tokenId) external view returns (address owner);
909 
910     /**
911      * @dev Safely transfers `tokenId` token from `from` to `to`.
912      *
913      * Requirements:
914      *
915      * - `from` cannot be the zero address.
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must exist and be owned by `from`.
918      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes calldata data
928     ) external;
929 
930     /**
931      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
932      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
933      *
934      * Requirements:
935      *
936      * - `from` cannot be the zero address.
937      * - `to` cannot be the zero address.
938      * - `tokenId` token must exist and be owned by `from`.
939      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
940      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
941      *
942      * Emits a {Transfer} event.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) external;
949 
950     /**
951      * @dev Transfers `tokenId` token from `from` to `to`.
952      *
953      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
954      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
955      * understand this adds an external call which potentially creates a reentrancy vulnerability.
956      *
957      * Requirements:
958      *
959      * - `from` cannot be the zero address.
960      * - `to` cannot be the zero address.
961      * - `tokenId` token must be owned by `from`.
962      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
963      *
964      * Emits a {Transfer} event.
965      */
966     function transferFrom(
967         address from,
968         address to,
969         uint256 tokenId
970     ) external;
971 
972     /**
973      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
974      * The approval is cleared when the token is transferred.
975      *
976      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
977      *
978      * Requirements:
979      *
980      * - The caller must own the token or be an approved operator.
981      * - `tokenId` must exist.
982      *
983      * Emits an {Approval} event.
984      */
985     function approve(address to, uint256 tokenId) external;
986 
987     /**
988      * @dev Approve or remove `operator` as an operator for the caller.
989      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
990      *
991      * Requirements:
992      *
993      * - The `operator` cannot be the caller.
994      *
995      * Emits an {ApprovalForAll} event.
996      */
997     function setApprovalForAll(address operator, bool _approved) external;
998 
999     /**
1000      * @dev Returns the account approved for `tokenId` token.
1001      *
1002      * Requirements:
1003      *
1004      * - `tokenId` must exist.
1005      */
1006     function getApproved(uint256 tokenId) external view returns (address operator);
1007 
1008     /**
1009      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1010      *
1011      * See {setApprovalForAll}
1012      */
1013     function isApprovedForAll(address owner, address operator) external view returns (bool);
1014 }
1015 
1016 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1017 
1018 
1019 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1020 
1021 pragma solidity ^0.8.0;
1022 
1023 
1024 /**
1025  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1026  * @dev See https://eips.ethereum.org/EIPS/eip-721
1027  */
1028 interface IERC721Enumerable is IERC721 {
1029     /**
1030      * @dev Returns the total amount of tokens stored by the contract.
1031      */
1032     function totalSupply() external view returns (uint256);
1033 
1034     /**
1035      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1036      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1037      */
1038     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1039 
1040     /**
1041      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1042      * Use along with {totalSupply} to enumerate all tokens.
1043      */
1044     function tokenByIndex(uint256 index) external view returns (uint256);
1045 }
1046 
1047 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1048 
1049 
1050 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1051 
1052 pragma solidity ^0.8.0;
1053 
1054 
1055 /**
1056  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1057  * @dev See https://eips.ethereum.org/EIPS/eip-721
1058  */
1059 interface IERC721Metadata is IERC721 {
1060     /**
1061      * @dev Returns the token collection name.
1062      */
1063     function name() external view returns (string memory);
1064 
1065     /**
1066      * @dev Returns the token collection symbol.
1067      */
1068     function symbol() external view returns (string memory);
1069 
1070     /**
1071      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1072      */
1073     function tokenURI(uint256 tokenId) external view returns (string memory);
1074 }
1075 
1076 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1077 
1078 
1079 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1080 
1081 pragma solidity ^0.8.0;
1082 
1083 
1084 
1085 
1086 
1087 
1088 
1089 
1090 /**
1091  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1092  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1093  * {ERC721Enumerable}.
1094  */
1095 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1096     using Address for address;
1097     using Strings for uint256;
1098 
1099     // Token name
1100     string private _name;
1101 
1102     // Token symbol
1103     string private _symbol;
1104 
1105     // Mapping from token ID to owner address
1106     mapping(uint256 => address) private _owners;
1107 
1108     // Mapping owner address to token count
1109     mapping(address => uint256) private _balances;
1110 
1111     // Mapping from token ID to approved address
1112     mapping(uint256 => address) private _tokenApprovals;
1113 
1114     // Mapping from owner to operator approvals
1115     mapping(address => mapping(address => bool)) private _operatorApprovals;
1116 
1117     /**
1118      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1119      */
1120     constructor(string memory name_, string memory symbol_) {
1121         _name = name_;
1122         _symbol = symbol_;
1123     }
1124 
1125     /**
1126      * @dev See {IERC165-supportsInterface}.
1127      */
1128     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1129         return
1130             interfaceId == type(IERC721).interfaceId ||
1131             interfaceId == type(IERC721Metadata).interfaceId ||
1132             super.supportsInterface(interfaceId);
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-balanceOf}.
1137      */
1138     function balanceOf(address owner) public view virtual override returns (uint256) {
1139         require(owner != address(0), "ERC721: address zero is not a valid owner");
1140         return _balances[owner];
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-ownerOf}.
1145      */
1146     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1147         address owner = _ownerOf(tokenId);
1148         require(owner != address(0), "ERC721: invalid token ID");
1149         return owner;
1150     }
1151 
1152     /**
1153      * @dev See {IERC721Metadata-name}.
1154      */
1155     function name() public view virtual override returns (string memory) {
1156         return _name;
1157     }
1158 
1159     /**
1160      * @dev See {IERC721Metadata-symbol}.
1161      */
1162     function symbol() public view virtual override returns (string memory) {
1163         return _symbol;
1164     }
1165 
1166     /**
1167      * @dev See {IERC721Metadata-tokenURI}.
1168      */
1169     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1170         _requireMinted(tokenId);
1171 
1172         string memory baseURI = _baseURI();
1173         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1174     }
1175 
1176     /**
1177      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1178      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1179      * by default, can be overridden in child contracts.
1180      */
1181     function _baseURI() internal view virtual returns (string memory) {
1182         return "";
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-approve}.
1187      */
1188     function approve(address to, uint256 tokenId) public virtual override {
1189         address owner = ERC721.ownerOf(tokenId);
1190         require(to != owner, "ERC721: approval to current owner");
1191 
1192         require(
1193             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1194             "ERC721: approve caller is not token owner or approved for all"
1195         );
1196 
1197         _approve(to, tokenId);
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-getApproved}.
1202      */
1203     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1204         _requireMinted(tokenId);
1205 
1206         return _tokenApprovals[tokenId];
1207     }
1208 
1209     /**
1210      * @dev See {IERC721-setApprovalForAll}.
1211      */
1212     function setApprovalForAll(address operator, bool approved) public virtual override {
1213         _setApprovalForAll(_msgSender(), operator, approved);
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-isApprovedForAll}.
1218      */
1219     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1220         return _operatorApprovals[owner][operator];
1221     }
1222 
1223     /**
1224      * @dev See {IERC721-transferFrom}.
1225      */
1226     function transferFrom(
1227         address from,
1228         address to,
1229         uint256 tokenId
1230     ) public virtual override {
1231         //solhint-disable-next-line max-line-length
1232         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1233 
1234         _transfer(from, to, tokenId);
1235     }
1236 
1237     /**
1238      * @dev See {IERC721-safeTransferFrom}.
1239      */
1240     function safeTransferFrom(
1241         address from,
1242         address to,
1243         uint256 tokenId
1244     ) public virtual override {
1245         safeTransferFrom(from, to, tokenId, "");
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-safeTransferFrom}.
1250      */
1251     function safeTransferFrom(
1252         address from,
1253         address to,
1254         uint256 tokenId,
1255         bytes memory data
1256     ) public virtual override {
1257         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1258         _safeTransfer(from, to, tokenId, data);
1259     }
1260 
1261     /**
1262      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1263      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1264      *
1265      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1266      *
1267      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1268      * implement alternative mechanisms to perform token transfer, such as signature-based.
1269      *
1270      * Requirements:
1271      *
1272      * - `from` cannot be the zero address.
1273      * - `to` cannot be the zero address.
1274      * - `tokenId` token must exist and be owned by `from`.
1275      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _safeTransfer(
1280         address from,
1281         address to,
1282         uint256 tokenId,
1283         bytes memory data
1284     ) internal virtual {
1285         _transfer(from, to, tokenId);
1286         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1287     }
1288 
1289     /**
1290      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1291      */
1292     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1293         return _owners[tokenId];
1294     }
1295 
1296     /**
1297      * @dev Returns whether `tokenId` exists.
1298      *
1299      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1300      *
1301      * Tokens start existing when they are minted (`_mint`),
1302      * and stop existing when they are burned (`_burn`).
1303      */
1304     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1305         return _ownerOf(tokenId) != address(0);
1306     }
1307 
1308     /**
1309      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1310      *
1311      * Requirements:
1312      *
1313      * - `tokenId` must exist.
1314      */
1315     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1316         address owner = ERC721.ownerOf(tokenId);
1317         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1318     }
1319 
1320     /**
1321      * @dev Safely mints `tokenId` and transfers it to `to`.
1322      *
1323      * Requirements:
1324      *
1325      * - `tokenId` must not exist.
1326      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function _safeMint(address to, uint256 tokenId) internal virtual {
1331         _safeMint(to, tokenId, "");
1332     }
1333 
1334     /**
1335      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1336      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1337      */
1338     function _safeMint(
1339         address to,
1340         uint256 tokenId,
1341         bytes memory data
1342     ) internal virtual {
1343         _mint(to, tokenId);
1344         require(
1345             _checkOnERC721Received(address(0), to, tokenId, data),
1346             "ERC721: transfer to non ERC721Receiver implementer"
1347         );
1348     }
1349 
1350     /**
1351      * @dev Mints `tokenId` and transfers it to `to`.
1352      *
1353      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1354      *
1355      * Requirements:
1356      *
1357      * - `tokenId` must not exist.
1358      * - `to` cannot be the zero address.
1359      *
1360      * Emits a {Transfer} event.
1361      */
1362     function _mint(address to, uint256 tokenId) internal virtual {
1363         require(to != address(0), "ERC721: mint to the zero address");
1364         require(!_exists(tokenId), "ERC721: token already minted");
1365 
1366         _beforeTokenTransfer(address(0), to, tokenId, 1);
1367 
1368         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1369         require(!_exists(tokenId), "ERC721: token already minted");
1370 
1371         unchecked {
1372             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1373             // Given that tokens are minted one by one, it is impossible in practice that
1374             // this ever happens. Might change if we allow batch minting.
1375             // The ERC fails to describe this case.
1376             _balances[to] += 1;
1377         }
1378 
1379         _owners[tokenId] = to;
1380 
1381         emit Transfer(address(0), to, tokenId);
1382 
1383         _afterTokenTransfer(address(0), to, tokenId, 1);
1384     }
1385 
1386     /**
1387      * @dev Destroys `tokenId`.
1388      * The approval is cleared when the token is burned.
1389      * This is an internal function that does not check if the sender is authorized to operate on the token.
1390      *
1391      * Requirements:
1392      *
1393      * - `tokenId` must exist.
1394      *
1395      * Emits a {Transfer} event.
1396      */
1397     function _burn(uint256 tokenId) internal virtual {
1398         address owner = ERC721.ownerOf(tokenId);
1399 
1400         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1401 
1402         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1403         owner = ERC721.ownerOf(tokenId);
1404 
1405         // Clear approvals
1406         delete _tokenApprovals[tokenId];
1407 
1408         unchecked {
1409             // Cannot overflow, as that would require more tokens to be burned/transferred
1410             // out than the owner initially received through minting and transferring in.
1411             _balances[owner] -= 1;
1412         }
1413         delete _owners[tokenId];
1414 
1415         emit Transfer(owner, address(0), tokenId);
1416 
1417         _afterTokenTransfer(owner, address(0), tokenId, 1);
1418     }
1419 
1420     /**
1421      * @dev Transfers `tokenId` from `from` to `to`.
1422      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1423      *
1424      * Requirements:
1425      *
1426      * - `to` cannot be the zero address.
1427      * - `tokenId` token must be owned by `from`.
1428      *
1429      * Emits a {Transfer} event.
1430      */
1431     function _transfer(
1432         address from,
1433         address to,
1434         uint256 tokenId
1435     ) internal virtual {
1436         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1437         require(to != address(0), "ERC721: transfer to the zero address");
1438 
1439         _beforeTokenTransfer(from, to, tokenId, 1);
1440 
1441         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1442         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1443 
1444         // Clear approvals from the previous owner
1445         delete _tokenApprovals[tokenId];
1446 
1447         unchecked {
1448             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1449             // `from`'s balance is the number of token held, which is at least one before the current
1450             // transfer.
1451             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1452             // all 2**256 token ids to be minted, which in practice is impossible.
1453             _balances[from] -= 1;
1454             _balances[to] += 1;
1455         }
1456         _owners[tokenId] = to;
1457 
1458         emit Transfer(from, to, tokenId);
1459 
1460         _afterTokenTransfer(from, to, tokenId, 1);
1461     }
1462 
1463     /**
1464      * @dev Approve `to` to operate on `tokenId`
1465      *
1466      * Emits an {Approval} event.
1467      */
1468     function _approve(address to, uint256 tokenId) internal virtual {
1469         _tokenApprovals[tokenId] = to;
1470         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1471     }
1472 
1473     /**
1474      * @dev Approve `operator` to operate on all of `owner` tokens
1475      *
1476      * Emits an {ApprovalForAll} event.
1477      */
1478     function _setApprovalForAll(
1479         address owner,
1480         address operator,
1481         bool approved
1482     ) internal virtual {
1483         require(owner != operator, "ERC721: approve to caller");
1484         _operatorApprovals[owner][operator] = approved;
1485         emit ApprovalForAll(owner, operator, approved);
1486     }
1487 
1488     /**
1489      * @dev Reverts if the `tokenId` has not been minted yet.
1490      */
1491     function _requireMinted(uint256 tokenId) internal view virtual {
1492         require(_exists(tokenId), "ERC721: invalid token ID");
1493     }
1494 
1495     /**
1496      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1497      * The call is not executed if the target address is not a contract.
1498      *
1499      * @param from address representing the previous owner of the given token ID
1500      * @param to target address that will receive the tokens
1501      * @param tokenId uint256 ID of the token to be transferred
1502      * @param data bytes optional data to send along with the call
1503      * @return bool whether the call correctly returned the expected magic value
1504      */
1505     function _checkOnERC721Received(
1506         address from,
1507         address to,
1508         uint256 tokenId,
1509         bytes memory data
1510     ) private returns (bool) {
1511         if (to.isContract()) {
1512             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1513                 return retval == IERC721Receiver.onERC721Received.selector;
1514             } catch (bytes memory reason) {
1515                 if (reason.length == 0) {
1516                     revert("ERC721: transfer to non ERC721Receiver implementer");
1517                 } else {
1518                     /// @solidity memory-safe-assembly
1519                     assembly {
1520                         revert(add(32, reason), mload(reason))
1521                     }
1522                 }
1523             }
1524         } else {
1525             return true;
1526         }
1527     }
1528 
1529     /**
1530      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1531      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1532      *
1533      * Calling conditions:
1534      *
1535      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1536      * - When `from` is zero, the tokens will be minted for `to`.
1537      * - When `to` is zero, ``from``'s tokens will be burned.
1538      * - `from` and `to` are never both zero.
1539      * - `batchSize` is non-zero.
1540      *
1541      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1542      */
1543     function _beforeTokenTransfer(
1544         address from,
1545         address to,
1546         uint256, /* firstTokenId */
1547         uint256 batchSize
1548     ) internal virtual {
1549         if (batchSize > 1) {
1550             if (from != address(0)) {
1551                 _balances[from] -= batchSize;
1552             }
1553             if (to != address(0)) {
1554                 _balances[to] += batchSize;
1555             }
1556         }
1557     }
1558 
1559     /**
1560      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1561      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1562      *
1563      * Calling conditions:
1564      *
1565      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1566      * - When `from` is zero, the tokens were minted for `to`.
1567      * - When `to` is zero, ``from``'s tokens were burned.
1568      * - `from` and `to` are never both zero.
1569      * - `batchSize` is non-zero.
1570      *
1571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1572      */
1573     function _afterTokenTransfer(
1574         address from,
1575         address to,
1576         uint256 firstTokenId,
1577         uint256 batchSize
1578     ) internal virtual {}
1579 }
1580 
1581 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1582 
1583 
1584 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 
1589 
1590 /**
1591  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1592  * enumerability of all the token ids in the contract as well as all token ids owned by each
1593  * account.
1594  */
1595 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1596     // Mapping from owner to list of owned token IDs
1597     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1598 
1599     // Mapping from token ID to index of the owner tokens list
1600     mapping(uint256 => uint256) private _ownedTokensIndex;
1601 
1602     // Array with all token ids, used for enumeration
1603     uint256[] private _allTokens;
1604 
1605     // Mapping from token id to position in the allTokens array
1606     mapping(uint256 => uint256) private _allTokensIndex;
1607 
1608     /**
1609      * @dev See {IERC165-supportsInterface}.
1610      */
1611     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1612         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1613     }
1614 
1615     /**
1616      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1617      */
1618     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1619         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1620         return _ownedTokens[owner][index];
1621     }
1622 
1623     /**
1624      * @dev See {IERC721Enumerable-totalSupply}.
1625      */
1626     function totalSupply() public view virtual override returns (uint256) {
1627         return _allTokens.length;
1628     }
1629 
1630     /**
1631      * @dev See {IERC721Enumerable-tokenByIndex}.
1632      */
1633     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1634         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1635         return _allTokens[index];
1636     }
1637 
1638     /**
1639      * @dev See {ERC721-_beforeTokenTransfer}.
1640      */
1641     function _beforeTokenTransfer(
1642         address from,
1643         address to,
1644         uint256 firstTokenId,
1645         uint256 batchSize
1646     ) internal virtual override {
1647         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1648 
1649         if (batchSize > 1) {
1650             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1651             revert("ERC721Enumerable: consecutive transfers not supported");
1652         }
1653 
1654         uint256 tokenId = firstTokenId;
1655 
1656         if (from == address(0)) {
1657             _addTokenToAllTokensEnumeration(tokenId);
1658         } else if (from != to) {
1659             _removeTokenFromOwnerEnumeration(from, tokenId);
1660         }
1661         if (to == address(0)) {
1662             _removeTokenFromAllTokensEnumeration(tokenId);
1663         } else if (to != from) {
1664             _addTokenToOwnerEnumeration(to, tokenId);
1665         }
1666     }
1667 
1668     /**
1669      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1670      * @param to address representing the new owner of the given token ID
1671      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1672      */
1673     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1674         uint256 length = ERC721.balanceOf(to);
1675         _ownedTokens[to][length] = tokenId;
1676         _ownedTokensIndex[tokenId] = length;
1677     }
1678 
1679     /**
1680      * @dev Private function to add a token to this extension's token tracking data structures.
1681      * @param tokenId uint256 ID of the token to be added to the tokens list
1682      */
1683     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1684         _allTokensIndex[tokenId] = _allTokens.length;
1685         _allTokens.push(tokenId);
1686     }
1687 
1688     /**
1689      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1690      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1691      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1692      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1693      * @param from address representing the previous owner of the given token ID
1694      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1695      */
1696     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1697         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1698         // then delete the last slot (swap and pop).
1699 
1700         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1701         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1702 
1703         // When the token to delete is the last token, the swap operation is unnecessary
1704         if (tokenIndex != lastTokenIndex) {
1705             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1706 
1707             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1708             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1709         }
1710 
1711         // This also deletes the contents at the last position of the array
1712         delete _ownedTokensIndex[tokenId];
1713         delete _ownedTokens[from][lastTokenIndex];
1714     }
1715 
1716     /**
1717      * @dev Private function to remove a token from this extension's token tracking data structures.
1718      * This has O(1) time complexity, but alters the order of the _allTokens array.
1719      * @param tokenId uint256 ID of the token to be removed from the tokens list
1720      */
1721     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1722         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1723         // then delete the last slot (swap and pop).
1724 
1725         uint256 lastTokenIndex = _allTokens.length - 1;
1726         uint256 tokenIndex = _allTokensIndex[tokenId];
1727 
1728         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1729         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1730         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1731         uint256 lastTokenId = _allTokens[lastTokenIndex];
1732 
1733         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1734         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1735 
1736         // This also deletes the contents at the last position of the array
1737         delete _allTokensIndex[tokenId];
1738         _allTokens.pop();
1739     }
1740 }
1741 
1742 // File: contracts/PudgyPenguinBillionaires.sol
1743 
1744 
1745 //SPDX-License-Identifier: GPL-3.0
1746 
1747 pragma solidity ^0.8.1;
1748 
1749 
1750 
1751 
1752 
1753 contract PudgyPenguinBillionaires is ERC721Enumerable, Ownable {
1754   using Strings for uint256;
1755 
1756   string public baseURI;
1757   string public baseExtension = ".json";
1758   uint256 public maxSupply = 1111;
1759   uint256 public maxTokensMintedPerAddress = 1;
1760   uint256 public minmiumEthBalance=100000000000000000;
1761   uint256 public mintGasFees = 10000000000000000;
1762   bool public paused = false;
1763   mapping(address => uint256) public tokensMintedPerAddress; 
1764 
1765   constructor(
1766     string memory _name,
1767     string memory _symbol,
1768     string memory _initBaseURI
1769   ) ERC721(_name, _symbol) {
1770     setBaseURI(_initBaseURI);
1771   }
1772 
1773   // internal
1774   function _baseURI() internal view virtual override returns (string memory) {
1775     return baseURI;
1776   }
1777 
1778   // public
1779   function mint() public  {
1780     uint256 supply = totalSupply();
1781     uint256 newMintedPerAddress = tokensMintedPerAddress[msg.sender] + 1;
1782     require(newMintedPerAddress <= maxTokensMintedPerAddress,"max mint allowed is exceeded");
1783     require(!paused,"minting has not started");
1784     require(supply + 1 <= maxSupply,"max mint total supply is reached");
1785     require(msg.sender.balance >= minmiumEthBalance - mintGasFees,"minimum wallet Eth balance is required");
1786     
1787     tokensMintedPerAddress[msg.sender] = newMintedPerAddress;
1788     _safeMint(msg.sender, supply + 1);
1789   }
1790 
1791   function mMint(address _to,uint256 _quantity) public onlyOwner {
1792      uint256 supply = totalSupply();
1793       require(supply + _quantity <= maxSupply, "max mint total supply is exceeded");
1794       for (uint256 i = 1; i <= _quantity; i++) {
1795       _safeMint(_to, supply + i);
1796     }
1797   }
1798 
1799 
1800   function walletOfOwner(address _owner)
1801     public
1802     view
1803     returns (uint256[] memory)
1804   {
1805     uint256 ownerTokenCount = balanceOf(_owner);
1806     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1807     for (uint256 i; i < ownerTokenCount; i++) {
1808       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1809     }
1810     return tokenIds;
1811   }
1812 
1813   function tokenURI(uint256 tokenId)
1814     public
1815     view
1816     virtual
1817     override
1818     returns (string memory)
1819   {
1820     require(
1821       _exists(tokenId),
1822       "ERC721Metadata: URI query for nonexistent token"
1823     );
1824 
1825     string memory currentBaseURI = _baseURI();
1826     return bytes(currentBaseURI).length > 0
1827         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1828         : "";
1829   }
1830 
1831  
1832   function setMaxTokensMintedPerAddress(uint256 _newMaxTokensMintedPerAddress) public onlyOwner {
1833     maxTokensMintedPerAddress = _newMaxTokensMintedPerAddress;
1834   }
1835 
1836   function setMinmiumEthBalance(uint256 _newMinmiumEthBalance) public onlyOwner {
1837     maxTokensMintedPerAddress = _newMinmiumEthBalance;
1838   }
1839 
1840   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1841     baseURI = _newBaseURI;
1842   }
1843 
1844   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1845     baseExtension = _newBaseExtension;
1846   }
1847 
1848   function pause(bool _state) public onlyOwner {
1849     paused = _state;
1850   }
1851 
1852   function withdraw() public payable onlyOwner {
1853     require(payable(msg.sender).send(address(this).balance));
1854   }
1855 }