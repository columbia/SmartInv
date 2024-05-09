1 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard signed math utilities missing in the Solidity language.
10  */
11 library SignedMath {
12     /**
13      * @dev Returns the largest of two signed numbers.
14      */
15     function max(int256 a, int256 b) internal pure returns (int256) {
16         return a > b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two signed numbers.
21      */
22     function min(int256 a, int256 b) internal pure returns (int256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the average of two signed numbers without overflow.
28      * The result is rounded towards zero.
29      */
30     function average(int256 a, int256 b) internal pure returns (int256) {
31         // Formula from the book "Hacker's Delight"
32         int256 x = (a & b) + ((a ^ b) >> 1);
33         return x + (int256(uint256(x) >> 255) & (a ^ b));
34     }
35 
36     /**
37      * @dev Returns the absolute unsigned value of a signed value.
38      */
39     function abs(int256 n) internal pure returns (uint256) {
40         unchecked {
41             // must be unchecked in order to support `n = type(int256).min`
42             return uint256(n >= 0 ? n : -n);
43         }
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/math/Math.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Standard math utilities missing in the Solidity language.
56  */
57 library Math {
58     enum Rounding {
59         Down, // Toward negative infinity
60         Up, // Toward infinity
61         Zero // Toward zero
62     }
63 
64     /**
65      * @dev Returns the largest of two numbers.
66      */
67     function max(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a > b ? a : b;
69     }
70 
71     /**
72      * @dev Returns the smallest of two numbers.
73      */
74     function min(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a < b ? a : b;
76     }
77 
78     /**
79      * @dev Returns the average of two numbers. The result is rounded towards
80      * zero.
81      */
82     function average(uint256 a, uint256 b) internal pure returns (uint256) {
83         // (a + b) / 2 can overflow.
84         return (a & b) + (a ^ b) / 2;
85     }
86 
87     /**
88      * @dev Returns the ceiling of the division of two numbers.
89      *
90      * This differs from standard division with `/` in that it rounds up instead
91      * of rounding down.
92      */
93     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
94         // (a + b - 1) / b can overflow on addition, so we distribute.
95         return a == 0 ? 0 : (a - 1) / b + 1;
96     }
97 
98     /**
99      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
100      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
101      * with further edits by Uniswap Labs also under MIT license.
102      */
103     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
104         unchecked {
105             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
106             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
107             // variables such that product = prod1 * 2^256 + prod0.
108             uint256 prod0; // Least significant 256 bits of the product
109             uint256 prod1; // Most significant 256 bits of the product
110             assembly {
111                 let mm := mulmod(x, y, not(0))
112                 prod0 := mul(x, y)
113                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
114             }
115 
116             // Handle non-overflow cases, 256 by 256 division.
117             if (prod1 == 0) {
118                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
119                 // The surrounding unchecked block does not change this fact.
120                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
121                 return prod0 / denominator;
122             }
123 
124             // Make sure the result is less than 2^256. Also prevents denominator == 0.
125             require(denominator > prod1, "Math: mulDiv overflow");
126 
127             ///////////////////////////////////////////////
128             // 512 by 256 division.
129             ///////////////////////////////////////////////
130 
131             // Make division exact by subtracting the remainder from [prod1 prod0].
132             uint256 remainder;
133             assembly {
134                 // Compute remainder using mulmod.
135                 remainder := mulmod(x, y, denominator)
136 
137                 // Subtract 256 bit number from 512 bit number.
138                 prod1 := sub(prod1, gt(remainder, prod0))
139                 prod0 := sub(prod0, remainder)
140             }
141 
142             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
143             // See https://cs.stackexchange.com/q/138556/92363.
144 
145             // Does not overflow because the denominator cannot be zero at this stage in the function.
146             uint256 twos = denominator & (~denominator + 1);
147             assembly {
148                 // Divide denominator by twos.
149                 denominator := div(denominator, twos)
150 
151                 // Divide [prod1 prod0] by twos.
152                 prod0 := div(prod0, twos)
153 
154                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
155                 twos := add(div(sub(0, twos), twos), 1)
156             }
157 
158             // Shift in bits from prod1 into prod0.
159             prod0 |= prod1 * twos;
160 
161             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
162             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
163             // four bits. That is, denominator * inv = 1 mod 2^4.
164             uint256 inverse = (3 * denominator) ^ 2;
165 
166             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
167             // in modular arithmetic, doubling the correct bits in each step.
168             inverse *= 2 - denominator * inverse; // inverse mod 2^8
169             inverse *= 2 - denominator * inverse; // inverse mod 2^16
170             inverse *= 2 - denominator * inverse; // inverse mod 2^32
171             inverse *= 2 - denominator * inverse; // inverse mod 2^64
172             inverse *= 2 - denominator * inverse; // inverse mod 2^128
173             inverse *= 2 - denominator * inverse; // inverse mod 2^256
174 
175             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
176             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
177             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
178             // is no longer required.
179             result = prod0 * inverse;
180             return result;
181         }
182     }
183 
184     /**
185      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
186      */
187     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
188         uint256 result = mulDiv(x, y, denominator);
189         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
190             result += 1;
191         }
192         return result;
193     }
194 
195     /**
196      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
197      *
198      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
199      */
200     function sqrt(uint256 a) internal pure returns (uint256) {
201         if (a == 0) {
202             return 0;
203         }
204 
205         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
206         //
207         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
208         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
209         //
210         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
211         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
212         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
213         //
214         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
215         uint256 result = 1 << (log2(a) >> 1);
216 
217         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
218         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
219         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
220         // into the expected uint128 result.
221         unchecked {
222             result = (result + a / result) >> 1;
223             result = (result + a / result) >> 1;
224             result = (result + a / result) >> 1;
225             result = (result + a / result) >> 1;
226             result = (result + a / result) >> 1;
227             result = (result + a / result) >> 1;
228             result = (result + a / result) >> 1;
229             return min(result, a / result);
230         }
231     }
232 
233     /**
234      * @notice Calculates sqrt(a), following the selected rounding direction.
235      */
236     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
237         unchecked {
238             uint256 result = sqrt(a);
239             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
240         }
241     }
242 
243     /**
244      * @dev Return the log in base 2, rounded down, of a positive value.
245      * Returns 0 if given 0.
246      */
247     function log2(uint256 value) internal pure returns (uint256) {
248         uint256 result = 0;
249         unchecked {
250             if (value >> 128 > 0) {
251                 value >>= 128;
252                 result += 128;
253             }
254             if (value >> 64 > 0) {
255                 value >>= 64;
256                 result += 64;
257             }
258             if (value >> 32 > 0) {
259                 value >>= 32;
260                 result += 32;
261             }
262             if (value >> 16 > 0) {
263                 value >>= 16;
264                 result += 16;
265             }
266             if (value >> 8 > 0) {
267                 value >>= 8;
268                 result += 8;
269             }
270             if (value >> 4 > 0) {
271                 value >>= 4;
272                 result += 4;
273             }
274             if (value >> 2 > 0) {
275                 value >>= 2;
276                 result += 2;
277             }
278             if (value >> 1 > 0) {
279                 result += 1;
280             }
281         }
282         return result;
283     }
284 
285     /**
286      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
287      * Returns 0 if given 0.
288      */
289     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
290         unchecked {
291             uint256 result = log2(value);
292             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
293         }
294     }
295 
296     /**
297      * @dev Return the log in base 10, rounded down, of a positive value.
298      * Returns 0 if given 0.
299      */
300     function log10(uint256 value) internal pure returns (uint256) {
301         uint256 result = 0;
302         unchecked {
303             if (value >= 10 ** 64) {
304                 value /= 10 ** 64;
305                 result += 64;
306             }
307             if (value >= 10 ** 32) {
308                 value /= 10 ** 32;
309                 result += 32;
310             }
311             if (value >= 10 ** 16) {
312                 value /= 10 ** 16;
313                 result += 16;
314             }
315             if (value >= 10 ** 8) {
316                 value /= 10 ** 8;
317                 result += 8;
318             }
319             if (value >= 10 ** 4) {
320                 value /= 10 ** 4;
321                 result += 4;
322             }
323             if (value >= 10 ** 2) {
324                 value /= 10 ** 2;
325                 result += 2;
326             }
327             if (value >= 10 ** 1) {
328                 result += 1;
329             }
330         }
331         return result;
332     }
333 
334     /**
335      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
336      * Returns 0 if given 0.
337      */
338     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
339         unchecked {
340             uint256 result = log10(value);
341             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
342         }
343     }
344 
345     /**
346      * @dev Return the log in base 256, rounded down, of a positive value.
347      * Returns 0 if given 0.
348      *
349      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
350      */
351     function log256(uint256 value) internal pure returns (uint256) {
352         uint256 result = 0;
353         unchecked {
354             if (value >> 128 > 0) {
355                 value >>= 128;
356                 result += 16;
357             }
358             if (value >> 64 > 0) {
359                 value >>= 64;
360                 result += 8;
361             }
362             if (value >> 32 > 0) {
363                 value >>= 32;
364                 result += 4;
365             }
366             if (value >> 16 > 0) {
367                 value >>= 16;
368                 result += 2;
369             }
370             if (value >> 8 > 0) {
371                 result += 1;
372             }
373         }
374         return result;
375     }
376 
377     /**
378      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
379      * Returns 0 if given 0.
380      */
381     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
382         unchecked {
383             uint256 result = log256(value);
384             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
385         }
386     }
387 }
388 
389 // File: @openzeppelin/contracts/utils/Strings.sol
390 
391 
392 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 
398 /**
399  * @dev String operations.
400  */
401 library Strings {
402     bytes16 private constant _SYMBOLS = "0123456789abcdef";
403     uint8 private constant _ADDRESS_LENGTH = 20;
404 
405     /**
406      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
407      */
408     function toString(uint256 value) internal pure returns (string memory) {
409         unchecked {
410             uint256 length = Math.log10(value) + 1;
411             string memory buffer = new string(length);
412             uint256 ptr;
413             /// @solidity memory-safe-assembly
414             assembly {
415                 ptr := add(buffer, add(32, length))
416             }
417             while (true) {
418                 ptr--;
419                 /// @solidity memory-safe-assembly
420                 assembly {
421                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
422                 }
423                 value /= 10;
424                 if (value == 0) break;
425             }
426             return buffer;
427         }
428     }
429 
430     /**
431      * @dev Converts a `int256` to its ASCII `string` decimal representation.
432      */
433     function toString(int256 value) internal pure returns (string memory) {
434         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
435     }
436 
437     /**
438      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
439      */
440     function toHexString(uint256 value) internal pure returns (string memory) {
441         unchecked {
442             return toHexString(value, Math.log256(value) + 1);
443         }
444     }
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
448      */
449     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
450         bytes memory buffer = new bytes(2 * length + 2);
451         buffer[0] = "0";
452         buffer[1] = "x";
453         for (uint256 i = 2 * length + 1; i > 1; --i) {
454             buffer[i] = _SYMBOLS[value & 0xf];
455             value >>= 4;
456         }
457         require(value == 0, "Strings: hex length insufficient");
458         return string(buffer);
459     }
460 
461     /**
462      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
463      */
464     function toHexString(address addr) internal pure returns (string memory) {
465         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
466     }
467 
468     /**
469      * @dev Returns true if the two strings are equal.
470      */
471     function equal(string memory a, string memory b) internal pure returns (bool) {
472         return keccak256(bytes(a)) == keccak256(bytes(b));
473     }
474 }
475 
476 // File: @openzeppelin/contracts/utils/Context.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @dev Provides information about the current execution context, including the
485  * sender of the transaction and its data. While these are generally available
486  * via msg.sender and msg.data, they should not be accessed in such a direct
487  * manner, since when dealing with meta-transactions the account sending and
488  * paying for execution may not be the actual sender (as far as an application
489  * is concerned).
490  *
491  * This contract is only required for intermediate, library-like contracts.
492  */
493 abstract contract Context {
494     function _msgSender() internal view virtual returns (address) {
495         return msg.sender;
496     }
497 
498     function _msgData() internal view virtual returns (bytes calldata) {
499         return msg.data;
500     }
501 }
502 
503 // File: @openzeppelin/contracts/access/Ownable.sol
504 
505 
506 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @dev Contract module which provides a basic access control mechanism, where
513  * there is an account (an owner) that can be granted exclusive access to
514  * specific functions.
515  *
516  * By default, the owner account will be the one that deploys the contract. This
517  * can later be changed with {transferOwnership}.
518  *
519  * This module is used through inheritance. It will make available the modifier
520  * `onlyOwner`, which can be applied to your functions to restrict their use to
521  * the owner.
522  */
523 abstract contract Ownable is Context {
524     address private _owner;
525 
526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
527 
528     /**
529      * @dev Initializes the contract setting the deployer as the initial owner.
530      */
531     constructor() {
532         _transferOwnership(_msgSender());
533     }
534 
535     /**
536      * @dev Throws if called by any account other than the owner.
537      */
538     modifier onlyOwner() {
539         _checkOwner();
540         _;
541     }
542 
543     /**
544      * @dev Returns the address of the current owner.
545      */
546     function owner() public view virtual returns (address) {
547         return _owner;
548     }
549 
550     /**
551      * @dev Throws if the sender is not the owner.
552      */
553     function _checkOwner() internal view virtual {
554         require(owner() == _msgSender(), "Ownable: caller is not the owner");
555     }
556 
557     /**
558      * @dev Leaves the contract without owner. It will not be possible to call
559      * `onlyOwner` functions. Can only be called by the current owner.
560      *
561      * NOTE: Renouncing ownership will leave the contract without an owner,
562      * thereby disabling any functionality that is only available to the owner.
563      */
564     function renounceOwnership() public virtual onlyOwner {
565         _transferOwnership(address(0));
566     }
567 
568     /**
569      * @dev Transfers ownership of the contract to a new account (`newOwner`).
570      * Can only be called by the current owner.
571      */
572     function transferOwnership(address newOwner) public virtual onlyOwner {
573         require(newOwner != address(0), "Ownable: new owner is the zero address");
574         _transferOwnership(newOwner);
575     }
576 
577     /**
578      * @dev Transfers ownership of the contract to a new account (`newOwner`).
579      * Internal function without access restriction.
580      */
581     function _transferOwnership(address newOwner) internal virtual {
582         address oldOwner = _owner;
583         _owner = newOwner;
584         emit OwnershipTransferred(oldOwner, newOwner);
585     }
586 }
587 
588 // File: @openzeppelin/contracts/utils/Address.sol
589 
590 
591 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
592 
593 pragma solidity ^0.8.1;
594 
595 /**
596  * @dev Collection of functions related to the address type
597  */
598 library Address {
599     /**
600      * @dev Returns true if `account` is a contract.
601      *
602      * [IMPORTANT]
603      * ====
604      * It is unsafe to assume that an address for which this function returns
605      * false is an externally-owned account (EOA) and not a contract.
606      *
607      * Among others, `isContract` will return false for the following
608      * types of addresses:
609      *
610      *  - an externally-owned account
611      *  - a contract in construction
612      *  - an address where a contract will be created
613      *  - an address where a contract lived, but was destroyed
614      *
615      * Furthermore, `isContract` will also return true if the target contract within
616      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
617      * which only has an effect at the end of a transaction.
618      * ====
619      *
620      * [IMPORTANT]
621      * ====
622      * You shouldn't rely on `isContract` to protect against flash loan attacks!
623      *
624      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
625      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
626      * constructor.
627      * ====
628      */
629     function isContract(address account) internal view returns (bool) {
630         // This method relies on extcodesize/address.code.length, which returns 0
631         // for contracts in construction, since the code is only stored at the end
632         // of the constructor execution.
633 
634         return account.code.length > 0;
635     }
636 
637     /**
638      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
639      * `recipient`, forwarding all available gas and reverting on errors.
640      *
641      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
642      * of certain opcodes, possibly making contracts go over the 2300 gas limit
643      * imposed by `transfer`, making them unable to receive funds via
644      * `transfer`. {sendValue} removes this limitation.
645      *
646      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
647      *
648      * IMPORTANT: because control is transferred to `recipient`, care must be
649      * taken to not create reentrancy vulnerabilities. Consider using
650      * {ReentrancyGuard} or the
651      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
652      */
653     function sendValue(address payable recipient, uint256 amount) internal {
654         require(address(this).balance >= amount, "Address: insufficient balance");
655 
656         (bool success, ) = recipient.call{value: amount}("");
657         require(success, "Address: unable to send value, recipient may have reverted");
658     }
659 
660     /**
661      * @dev Performs a Solidity function call using a low level `call`. A
662      * plain `call` is an unsafe replacement for a function call: use this
663      * function instead.
664      *
665      * If `target` reverts with a revert reason, it is bubbled up by this
666      * function (like regular Solidity function calls).
667      *
668      * Returns the raw returned data. To convert to the expected return value,
669      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
670      *
671      * Requirements:
672      *
673      * - `target` must be a contract.
674      * - calling `target` with `data` must not revert.
675      *
676      * _Available since v3.1._
677      */
678     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
679         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
684      * `errorMessage` as a fallback revert reason when `target` reverts.
685      *
686      * _Available since v3.1._
687      */
688     function functionCall(
689         address target,
690         bytes memory data,
691         string memory errorMessage
692     ) internal returns (bytes memory) {
693         return functionCallWithValue(target, data, 0, errorMessage);
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
698      * but also transferring `value` wei to `target`.
699      *
700      * Requirements:
701      *
702      * - the calling contract must have an ETH balance of at least `value`.
703      * - the called Solidity function must be `payable`.
704      *
705      * _Available since v3.1._
706      */
707     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
708         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
713      * with `errorMessage` as a fallback revert reason when `target` reverts.
714      *
715      * _Available since v3.1._
716      */
717     function functionCallWithValue(
718         address target,
719         bytes memory data,
720         uint256 value,
721         string memory errorMessage
722     ) internal returns (bytes memory) {
723         require(address(this).balance >= value, "Address: insufficient balance for call");
724         (bool success, bytes memory returndata) = target.call{value: value}(data);
725         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
726     }
727 
728     /**
729      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
730      * but performing a static call.
731      *
732      * _Available since v3.3._
733      */
734     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
735         return functionStaticCall(target, data, "Address: low-level static call failed");
736     }
737 
738     /**
739      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
740      * but performing a static call.
741      *
742      * _Available since v3.3._
743      */
744     function functionStaticCall(
745         address target,
746         bytes memory data,
747         string memory errorMessage
748     ) internal view returns (bytes memory) {
749         (bool success, bytes memory returndata) = target.staticcall(data);
750         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
755      * but performing a delegate call.
756      *
757      * _Available since v3.4._
758      */
759     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
760         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
761     }
762 
763     /**
764      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
765      * but performing a delegate call.
766      *
767      * _Available since v3.4._
768      */
769     function functionDelegateCall(
770         address target,
771         bytes memory data,
772         string memory errorMessage
773     ) internal returns (bytes memory) {
774         (bool success, bytes memory returndata) = target.delegatecall(data);
775         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
776     }
777 
778     /**
779      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
780      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
781      *
782      * _Available since v4.8._
783      */
784     function verifyCallResultFromTarget(
785         address target,
786         bool success,
787         bytes memory returndata,
788         string memory errorMessage
789     ) internal view returns (bytes memory) {
790         if (success) {
791             if (returndata.length == 0) {
792                 // only check isContract if the call was successful and the return data is empty
793                 // otherwise we already know that it was a contract
794                 require(isContract(target), "Address: call to non-contract");
795             }
796             return returndata;
797         } else {
798             _revert(returndata, errorMessage);
799         }
800     }
801 
802     /**
803      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
804      * revert reason or using the provided one.
805      *
806      * _Available since v4.3._
807      */
808     function verifyCallResult(
809         bool success,
810         bytes memory returndata,
811         string memory errorMessage
812     ) internal pure returns (bytes memory) {
813         if (success) {
814             return returndata;
815         } else {
816             _revert(returndata, errorMessage);
817         }
818     }
819 
820     function _revert(bytes memory returndata, string memory errorMessage) private pure {
821         // Look for revert reason and bubble it up if present
822         if (returndata.length > 0) {
823             // The easiest way to bubble the revert reason is using memory via assembly
824             /// @solidity memory-safe-assembly
825             assembly {
826                 let returndata_size := mload(returndata)
827                 revert(add(32, returndata), returndata_size)
828             }
829         } else {
830             revert(errorMessage);
831         }
832     }
833 }
834 
835 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
836 
837 
838 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
839 
840 pragma solidity ^0.8.0;
841 
842 /**
843  * @title ERC721 token receiver interface
844  * @dev Interface for any contract that wants to support safeTransfers
845  * from ERC721 asset contracts.
846  */
847 interface IERC721Receiver {
848     /**
849      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
850      * by `operator` from `from`, this function is called.
851      *
852      * It must return its Solidity selector to confirm the token transfer.
853      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
854      *
855      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
856      */
857     function onERC721Received(
858         address operator,
859         address from,
860         uint256 tokenId,
861         bytes calldata data
862     ) external returns (bytes4);
863 }
864 
865 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
866 
867 
868 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
869 
870 pragma solidity ^0.8.0;
871 
872 /**
873  * @dev Interface of the ERC165 standard, as defined in the
874  * https://eips.ethereum.org/EIPS/eip-165[EIP].
875  *
876  * Implementers can declare support of contract interfaces, which can then be
877  * queried by others ({ERC165Checker}).
878  *
879  * For an implementation, see {ERC165}.
880  */
881 interface IERC165 {
882     /**
883      * @dev Returns true if this contract implements the interface defined by
884      * `interfaceId`. See the corresponding
885      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
886      * to learn more about how these ids are created.
887      *
888      * This function call must use less than 30 000 gas.
889      */
890     function supportsInterface(bytes4 interfaceId) external view returns (bool);
891 }
892 
893 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
894 
895 
896 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
897 
898 pragma solidity ^0.8.0;
899 
900 
901 /**
902  * @dev Implementation of the {IERC165} interface.
903  *
904  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
905  * for the additional interface id that will be supported. For example:
906  *
907  * ```solidity
908  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
909  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
910  * }
911  * ```
912  *
913  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
914  */
915 abstract contract ERC165 is IERC165 {
916     /**
917      * @dev See {IERC165-supportsInterface}.
918      */
919     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
920         return interfaceId == type(IERC165).interfaceId;
921     }
922 }
923 
924 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
925 
926 
927 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
928 
929 pragma solidity ^0.8.0;
930 
931 
932 /**
933  * @dev Required interface of an ERC721 compliant contract.
934  */
935 interface IERC721 is IERC165 {
936     /**
937      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
938      */
939     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
940 
941     /**
942      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
943      */
944     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
945 
946     /**
947      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
948      */
949     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
950 
951     /**
952      * @dev Returns the number of tokens in ``owner``'s account.
953      */
954     function balanceOf(address owner) external view returns (uint256 balance);
955 
956     /**
957      * @dev Returns the owner of the `tokenId` token.
958      *
959      * Requirements:
960      *
961      * - `tokenId` must exist.
962      */
963     function ownerOf(uint256 tokenId) external view returns (address owner);
964 
965     /**
966      * @dev Safely transfers `tokenId` token from `from` to `to`.
967      *
968      * Requirements:
969      *
970      * - `from` cannot be the zero address.
971      * - `to` cannot be the zero address.
972      * - `tokenId` token must exist and be owned by `from`.
973      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
974      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
975      *
976      * Emits a {Transfer} event.
977      */
978     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
979 
980     /**
981      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
982      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
983      *
984      * Requirements:
985      *
986      * - `from` cannot be the zero address.
987      * - `to` cannot be the zero address.
988      * - `tokenId` token must exist and be owned by `from`.
989      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
990      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
991      *
992      * Emits a {Transfer} event.
993      */
994     function safeTransferFrom(address from, address to, uint256 tokenId) external;
995 
996     /**
997      * @dev Transfers `tokenId` token from `from` to `to`.
998      *
999      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1000      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1001      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1002      *
1003      * Requirements:
1004      *
1005      * - `from` cannot be the zero address.
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must be owned by `from`.
1008      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function transferFrom(address from, address to, uint256 tokenId) external;
1013 
1014     /**
1015      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1016      * The approval is cleared when the token is transferred.
1017      *
1018      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1019      *
1020      * Requirements:
1021      *
1022      * - The caller must own the token or be an approved operator.
1023      * - `tokenId` must exist.
1024      *
1025      * Emits an {Approval} event.
1026      */
1027     function approve(address to, uint256 tokenId) external;
1028 
1029     /**
1030      * @dev Approve or remove `operator` as an operator for the caller.
1031      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1032      *
1033      * Requirements:
1034      *
1035      * - The `operator` cannot be the caller.
1036      *
1037      * Emits an {ApprovalForAll} event.
1038      */
1039     function setApprovalForAll(address operator, bool approved) external;
1040 
1041     /**
1042      * @dev Returns the account approved for `tokenId` token.
1043      *
1044      * Requirements:
1045      *
1046      * - `tokenId` must exist.
1047      */
1048     function getApproved(uint256 tokenId) external view returns (address operator);
1049 
1050     /**
1051      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1052      *
1053      * See {setApprovalForAll}
1054      */
1055     function isApprovedForAll(address owner, address operator) external view returns (bool);
1056 }
1057 
1058 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1059 
1060 
1061 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1062 
1063 pragma solidity ^0.8.0;
1064 
1065 
1066 /**
1067  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1068  * @dev See https://eips.ethereum.org/EIPS/eip-721
1069  */
1070 interface IERC721Enumerable is IERC721 {
1071     /**
1072      * @dev Returns the total amount of tokens stored by the contract.
1073      */
1074     function totalSupply() external view returns (uint256);
1075 
1076     /**
1077      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1078      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1079      */
1080     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1081 
1082     /**
1083      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1084      * Use along with {totalSupply} to enumerate all tokens.
1085      */
1086     function tokenByIndex(uint256 index) external view returns (uint256);
1087 }
1088 
1089 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1090 
1091 
1092 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 
1097 /**
1098  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1099  * @dev See https://eips.ethereum.org/EIPS/eip-721
1100  */
1101 interface IERC721Metadata is IERC721 {
1102     /**
1103      * @dev Returns the token collection name.
1104      */
1105     function name() external view returns (string memory);
1106 
1107     /**
1108      * @dev Returns the token collection symbol.
1109      */
1110     function symbol() external view returns (string memory);
1111 
1112     /**
1113      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1114      */
1115     function tokenURI(uint256 tokenId) external view returns (string memory);
1116 }
1117 
1118 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1119 
1120 
1121 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/ERC721.sol)
1122 
1123 pragma solidity ^0.8.0;
1124 
1125 
1126 
1127 
1128 
1129 
1130 
1131 
1132 /**
1133  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1134  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1135  * {ERC721Enumerable}.
1136  */
1137 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1138     using Address for address;
1139     using Strings for uint256;
1140 
1141     // Token name
1142     string private _name;
1143 
1144     // Token symbol
1145     string private _symbol;
1146 
1147     // Mapping from token ID to owner address
1148     mapping(uint256 => address) private _owners;
1149 
1150     // Mapping owner address to token count
1151     mapping(address => uint256) private _balances;
1152 
1153     // Mapping from token ID to approved address
1154     mapping(uint256 => address) private _tokenApprovals;
1155 
1156     // Mapping from owner to operator approvals
1157     mapping(address => mapping(address => bool)) private _operatorApprovals;
1158 
1159     /**
1160      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1161      */
1162     constructor(string memory name_, string memory symbol_) {
1163         _name = name_;
1164         _symbol = symbol_;
1165     }
1166 
1167     /**
1168      * @dev See {IERC165-supportsInterface}.
1169      */
1170     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1171         return
1172             interfaceId == type(IERC721).interfaceId ||
1173             interfaceId == type(IERC721Metadata).interfaceId ||
1174             super.supportsInterface(interfaceId);
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-balanceOf}.
1179      */
1180     function balanceOf(address owner) public view virtual override returns (uint256) {
1181         require(owner != address(0), "ERC721: address zero is not a valid owner");
1182         return _balances[owner];
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-ownerOf}.
1187      */
1188     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1189         address owner = _ownerOf(tokenId);
1190         require(owner != address(0), "ERC721: invalid token ID");
1191         return owner;
1192     }
1193 
1194     /**
1195      * @dev See {IERC721Metadata-name}.
1196      */
1197     function name() public view virtual override returns (string memory) {
1198         return _name;
1199     }
1200 
1201     /**
1202      * @dev See {IERC721Metadata-symbol}.
1203      */
1204     function symbol() public view virtual override returns (string memory) {
1205         return _symbol;
1206     }
1207 
1208     /**
1209      * @dev See {IERC721Metadata-tokenURI}.
1210      */
1211     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1212         _requireMinted(tokenId);
1213 
1214         string memory baseURI = _baseURI();
1215         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1216     }
1217 
1218     /**
1219      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1220      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1221      * by default, can be overridden in child contracts.
1222      */
1223     function _baseURI() internal view virtual returns (string memory) {
1224         return "";
1225     }
1226 
1227     /**
1228      * @dev See {IERC721-approve}.
1229      */
1230     function approve(address to, uint256 tokenId) public virtual override {
1231         address owner = ERC721.ownerOf(tokenId);
1232         require(to != owner, "ERC721: approval to current owner");
1233 
1234         require(
1235             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1236             "ERC721: approve caller is not token owner or approved for all"
1237         );
1238 
1239         _approve(to, tokenId);
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-getApproved}.
1244      */
1245     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1246         _requireMinted(tokenId);
1247 
1248         return _tokenApprovals[tokenId];
1249     }
1250 
1251     /**
1252      * @dev See {IERC721-setApprovalForAll}.
1253      */
1254     function setApprovalForAll(address operator, bool approved) public virtual override {
1255         _setApprovalForAll(_msgSender(), operator, approved);
1256     }
1257 
1258     /**
1259      * @dev See {IERC721-isApprovedForAll}.
1260      */
1261     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1262         return _operatorApprovals[owner][operator];
1263     }
1264 
1265     /**
1266      * @dev See {IERC721-transferFrom}.
1267      */
1268     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1269         //solhint-disable-next-line max-line-length
1270         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1271 
1272         _transfer(from, to, tokenId);
1273     }
1274 
1275     /**
1276      * @dev See {IERC721-safeTransferFrom}.
1277      */
1278     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1279         safeTransferFrom(from, to, tokenId, "");
1280     }
1281 
1282     /**
1283      * @dev See {IERC721-safeTransferFrom}.
1284      */
1285     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
1286         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1287         _safeTransfer(from, to, tokenId, data);
1288     }
1289 
1290     /**
1291      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1292      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1293      *
1294      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1295      *
1296      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1297      * implement alternative mechanisms to perform token transfer, such as signature-based.
1298      *
1299      * Requirements:
1300      *
1301      * - `from` cannot be the zero address.
1302      * - `to` cannot be the zero address.
1303      * - `tokenId` token must exist and be owned by `from`.
1304      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1305      *
1306      * Emits a {Transfer} event.
1307      */
1308     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
1309         _transfer(from, to, tokenId);
1310         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1311     }
1312 
1313     /**
1314      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1315      */
1316     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1317         return _owners[tokenId];
1318     }
1319 
1320     /**
1321      * @dev Returns whether `tokenId` exists.
1322      *
1323      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1324      *
1325      * Tokens start existing when they are minted (`_mint`),
1326      * and stop existing when they are burned (`_burn`).
1327      */
1328     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1329         return _ownerOf(tokenId) != address(0);
1330     }
1331 
1332     /**
1333      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1334      *
1335      * Requirements:
1336      *
1337      * - `tokenId` must exist.
1338      */
1339     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1340         address owner = ERC721.ownerOf(tokenId);
1341         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1342     }
1343 
1344     /**
1345      * @dev Safely mints `tokenId` and transfers it to `to`.
1346      *
1347      * Requirements:
1348      *
1349      * - `tokenId` must not exist.
1350      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1351      *
1352      * Emits a {Transfer} event.
1353      */
1354     function _safeMint(address to, uint256 tokenId) internal virtual {
1355         _safeMint(to, tokenId, "");
1356     }
1357 
1358     /**
1359      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1360      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1361      */
1362     function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
1363         _mint(to, tokenId);
1364         require(
1365             _checkOnERC721Received(address(0), to, tokenId, data),
1366             "ERC721: transfer to non ERC721Receiver implementer"
1367         );
1368     }
1369 
1370     /**
1371      * @dev Mints `tokenId` and transfers it to `to`.
1372      *
1373      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1374      *
1375      * Requirements:
1376      *
1377      * - `tokenId` must not exist.
1378      * - `to` cannot be the zero address.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _mint(address to, uint256 tokenId) internal virtual {
1383         require(to != address(0), "ERC721: mint to the zero address");
1384         require(!_exists(tokenId), "ERC721: token already minted");
1385 
1386         _beforeTokenTransfer(address(0), to, tokenId, 1);
1387 
1388         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1389         require(!_exists(tokenId), "ERC721: token already minted");
1390 
1391         unchecked {
1392             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1393             // Given that tokens are minted one by one, it is impossible in practice that
1394             // this ever happens. Might change if we allow batch minting.
1395             // The ERC fails to describe this case.
1396             _balances[to] += 1;
1397         }
1398 
1399         _owners[tokenId] = to;
1400 
1401         emit Transfer(address(0), to, tokenId);
1402 
1403         _afterTokenTransfer(address(0), to, tokenId, 1);
1404     }
1405 
1406     /**
1407      * @dev Destroys `tokenId`.
1408      * The approval is cleared when the token is burned.
1409      * This is an internal function that does not check if the sender is authorized to operate on the token.
1410      *
1411      * Requirements:
1412      *
1413      * - `tokenId` must exist.
1414      *
1415      * Emits a {Transfer} event.
1416      */
1417     function _burn(uint256 tokenId) internal virtual {
1418         address owner = ERC721.ownerOf(tokenId);
1419 
1420         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1421 
1422         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1423         owner = ERC721.ownerOf(tokenId);
1424 
1425         // Clear approvals
1426         delete _tokenApprovals[tokenId];
1427 
1428         unchecked {
1429             // Cannot overflow, as that would require more tokens to be burned/transferred
1430             // out than the owner initially received through minting and transferring in.
1431             _balances[owner] -= 1;
1432         }
1433         delete _owners[tokenId];
1434 
1435         emit Transfer(owner, address(0), tokenId);
1436 
1437         _afterTokenTransfer(owner, address(0), tokenId, 1);
1438     }
1439 
1440     /**
1441      * @dev Transfers `tokenId` from `from` to `to`.
1442      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1443      *
1444      * Requirements:
1445      *
1446      * - `to` cannot be the zero address.
1447      * - `tokenId` token must be owned by `from`.
1448      *
1449      * Emits a {Transfer} event.
1450      */
1451     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1452         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1453         require(to != address(0), "ERC721: transfer to the zero address");
1454 
1455         _beforeTokenTransfer(from, to, tokenId, 1);
1456 
1457         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1458         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1459 
1460         // Clear approvals from the previous owner
1461         delete _tokenApprovals[tokenId];
1462 
1463         unchecked {
1464             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1465             // `from`'s balance is the number of token held, which is at least one before the current
1466             // transfer.
1467             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1468             // all 2**256 token ids to be minted, which in practice is impossible.
1469             _balances[from] -= 1;
1470             _balances[to] += 1;
1471         }
1472         _owners[tokenId] = to;
1473 
1474         emit Transfer(from, to, tokenId);
1475 
1476         _afterTokenTransfer(from, to, tokenId, 1);
1477     }
1478 
1479     /**
1480      * @dev Approve `to` to operate on `tokenId`
1481      *
1482      * Emits an {Approval} event.
1483      */
1484     function _approve(address to, uint256 tokenId) internal virtual {
1485         _tokenApprovals[tokenId] = to;
1486         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1487     }
1488 
1489     /**
1490      * @dev Approve `operator` to operate on all of `owner` tokens
1491      *
1492      * Emits an {ApprovalForAll} event.
1493      */
1494     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
1495         require(owner != operator, "ERC721: approve to caller");
1496         _operatorApprovals[owner][operator] = approved;
1497         emit ApprovalForAll(owner, operator, approved);
1498     }
1499 
1500     /**
1501      * @dev Reverts if the `tokenId` has not been minted yet.
1502      */
1503     function _requireMinted(uint256 tokenId) internal view virtual {
1504         require(_exists(tokenId), "ERC721: invalid token ID");
1505     }
1506 
1507     /**
1508      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1509      * The call is not executed if the target address is not a contract.
1510      *
1511      * @param from address representing the previous owner of the given token ID
1512      * @param to target address that will receive the tokens
1513      * @param tokenId uint256 ID of the token to be transferred
1514      * @param data bytes optional data to send along with the call
1515      * @return bool whether the call correctly returned the expected magic value
1516      */
1517     function _checkOnERC721Received(
1518         address from,
1519         address to,
1520         uint256 tokenId,
1521         bytes memory data
1522     ) private returns (bool) {
1523         if (to.isContract()) {
1524             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1525                 return retval == IERC721Receiver.onERC721Received.selector;
1526             } catch (bytes memory reason) {
1527                 if (reason.length == 0) {
1528                     revert("ERC721: transfer to non ERC721Receiver implementer");
1529                 } else {
1530                     /// @solidity memory-safe-assembly
1531                     assembly {
1532                         revert(add(32, reason), mload(reason))
1533                     }
1534                 }
1535             }
1536         } else {
1537             return true;
1538         }
1539     }
1540 
1541     /**
1542      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1543      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1544      *
1545      * Calling conditions:
1546      *
1547      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1548      * - When `from` is zero, the tokens will be minted for `to`.
1549      * - When `to` is zero, ``from``'s tokens will be burned.
1550      * - `from` and `to` are never both zero.
1551      * - `batchSize` is non-zero.
1552      *
1553      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1554      */
1555     function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
1556 
1557     /**
1558      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1559      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1560      *
1561      * Calling conditions:
1562      *
1563      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1564      * - When `from` is zero, the tokens were minted for `to`.
1565      * - When `to` is zero, ``from``'s tokens were burned.
1566      * - `from` and `to` are never both zero.
1567      * - `batchSize` is non-zero.
1568      *
1569      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1570      */
1571     function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
1572 
1573     /**
1574      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
1575      *
1576      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
1577      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
1578      * that `ownerOf(tokenId)` is `a`.
1579      */
1580     // solhint-disable-next-line func-name-mixedcase
1581     function __unsafe_increaseBalance(address account, uint256 amount) internal {
1582         _balances[account] += amount;
1583     }
1584 }
1585 
1586 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1587 
1588 
1589 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1590 
1591 pragma solidity ^0.8.0;
1592 
1593 
1594 
1595 /**
1596  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1597  * enumerability of all the token ids in the contract as well as all token ids owned by each
1598  * account.
1599  */
1600 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1601     // Mapping from owner to list of owned token IDs
1602     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1603 
1604     // Mapping from token ID to index of the owner tokens list
1605     mapping(uint256 => uint256) private _ownedTokensIndex;
1606 
1607     // Array with all token ids, used for enumeration
1608     uint256[] private _allTokens;
1609 
1610     // Mapping from token id to position in the allTokens array
1611     mapping(uint256 => uint256) private _allTokensIndex;
1612 
1613     /**
1614      * @dev See {IERC165-supportsInterface}.
1615      */
1616     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1617         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1618     }
1619 
1620     /**
1621      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1622      */
1623     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1624         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1625         return _ownedTokens[owner][index];
1626     }
1627 
1628     /**
1629      * @dev See {IERC721Enumerable-totalSupply}.
1630      */
1631     function totalSupply() public view virtual override returns (uint256) {
1632         return _allTokens.length;
1633     }
1634 
1635     /**
1636      * @dev See {IERC721Enumerable-tokenByIndex}.
1637      */
1638     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1639         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1640         return _allTokens[index];
1641     }
1642 
1643     /**
1644      * @dev See {ERC721-_beforeTokenTransfer}.
1645      */
1646     function _beforeTokenTransfer(
1647         address from,
1648         address to,
1649         uint256 firstTokenId,
1650         uint256 batchSize
1651     ) internal virtual override {
1652         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1653 
1654         if (batchSize > 1) {
1655             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1656             revert("ERC721Enumerable: consecutive transfers not supported");
1657         }
1658 
1659         uint256 tokenId = firstTokenId;
1660 
1661         if (from == address(0)) {
1662             _addTokenToAllTokensEnumeration(tokenId);
1663         } else if (from != to) {
1664             _removeTokenFromOwnerEnumeration(from, tokenId);
1665         }
1666         if (to == address(0)) {
1667             _removeTokenFromAllTokensEnumeration(tokenId);
1668         } else if (to != from) {
1669             _addTokenToOwnerEnumeration(to, tokenId);
1670         }
1671     }
1672 
1673     /**
1674      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1675      * @param to address representing the new owner of the given token ID
1676      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1677      */
1678     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1679         uint256 length = ERC721.balanceOf(to);
1680         _ownedTokens[to][length] = tokenId;
1681         _ownedTokensIndex[tokenId] = length;
1682     }
1683 
1684     /**
1685      * @dev Private function to add a token to this extension's token tracking data structures.
1686      * @param tokenId uint256 ID of the token to be added to the tokens list
1687      */
1688     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1689         _allTokensIndex[tokenId] = _allTokens.length;
1690         _allTokens.push(tokenId);
1691     }
1692 
1693     /**
1694      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1695      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1696      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1697      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1698      * @param from address representing the previous owner of the given token ID
1699      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1700      */
1701     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1702         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1703         // then delete the last slot (swap and pop).
1704 
1705         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1706         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1707 
1708         // When the token to delete is the last token, the swap operation is unnecessary
1709         if (tokenIndex != lastTokenIndex) {
1710             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1711 
1712             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1713             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1714         }
1715 
1716         // This also deletes the contents at the last position of the array
1717         delete _ownedTokensIndex[tokenId];
1718         delete _ownedTokens[from][lastTokenIndex];
1719     }
1720 
1721     /**
1722      * @dev Private function to remove a token from this extension's token tracking data structures.
1723      * This has O(1) time complexity, but alters the order of the _allTokens array.
1724      * @param tokenId uint256 ID of the token to be removed from the tokens list
1725      */
1726     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1727         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1728         // then delete the last slot (swap and pop).
1729 
1730         uint256 lastTokenIndex = _allTokens.length - 1;
1731         uint256 tokenIndex = _allTokensIndex[tokenId];
1732 
1733         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1734         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1735         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1736         uint256 lastTokenId = _allTokens[lastTokenIndex];
1737 
1738         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1739         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1740 
1741         // This also deletes the contents at the last position of the array
1742         delete _allTokensIndex[tokenId];
1743         _allTokens.pop();
1744     }
1745 }
1746 
1747 // File: BORED PEPE.sol
1748 
1749 
1750 
1751 
1752 
1753 pragma solidity >=0.7.0 <0.9.0;
1754 
1755 
1756 
1757 contract NFT is ERC721Enumerable, Ownable {
1758   using Strings for uint256;
1759 
1760   string baseURI;
1761   string public baseExtension = ".json";
1762   uint256 public pepePrice = 0.08 ether;
1763   uint256 public MAX_PEPES = 10000;
1764   uint256 public maxPepePurchase = 20;
1765   bool public paused = true;
1766   bool public revealed = false;
1767   string public notRevealedUri;
1768 
1769   constructor(
1770     string memory _name,
1771     string memory _symbol,
1772     string memory _initBaseURI,
1773     string memory _initNotRevealedUri
1774   ) ERC721(_name, _symbol) {
1775     setBaseURI(_initBaseURI);
1776     setNotRevealedURI(_initNotRevealedUri);
1777   }
1778 
1779   // internal
1780   function _baseURI() internal view virtual override returns (string memory) {
1781     return baseURI;
1782   }
1783 
1784   // public
1785   function mintPepe(uint256 _mintAmount) public payable {
1786     uint256 supply = totalSupply();
1787     require(!paused);
1788     require(_mintAmount > 0);
1789     require(_mintAmount <= maxPepePurchase);
1790     require(supply + _mintAmount <= MAX_PEPES);
1791 
1792     if (msg.sender != owner()) {
1793       require(msg.value >= pepePrice * _mintAmount);
1794     }
1795 
1796     for (uint256 i = 1; i <= _mintAmount; i++) {
1797       _safeMint(msg.sender, supply + i);
1798     }
1799   }
1800 
1801   function walletOfOwner(address _owner)
1802     public
1803     view
1804     returns (uint256[] memory)
1805   {
1806     uint256 ownerTokenCount = balanceOf(_owner);
1807     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1808     for (uint256 i; i < ownerTokenCount; i++) {
1809       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1810     }
1811     return tokenIds;
1812   }
1813 
1814   function tokenURI(uint256 tokenId)
1815     public
1816     view
1817     virtual
1818     override
1819     returns (string memory)
1820   {
1821     require(
1822       _exists(tokenId),
1823       "ERC721Metadata: URI query for nonexistent token"
1824     );
1825     
1826     if(revealed == false) {
1827         return notRevealedUri;
1828     }
1829 
1830     string memory currentBaseURI = _baseURI();
1831     return bytes(currentBaseURI).length > 0
1832         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1833         : "";
1834   }
1835 
1836   //only owner
1837   function reveal() public onlyOwner {
1838       revealed = true;
1839   }
1840   
1841   function setPepePrice(uint256 _pepePrice) public onlyOwner {
1842     pepePrice = _pepePrice;
1843   }
1844 
1845   function setMaxPepePurchase(uint256 _maxPepePurchase) public onlyOwner {
1846     maxPepePurchase = _maxPepePurchase;
1847   }
1848   
1849   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1850     notRevealedUri = _notRevealedURI;
1851   }
1852 
1853   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1854     baseURI = _newBaseURI;
1855   }
1856 
1857   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1858     baseExtension = _newBaseExtension;
1859   }
1860 
1861   function pause(bool _state) public onlyOwner {
1862     paused = _state;
1863   }
1864  
1865   function withdraw() public payable onlyOwner {
1866     // =============================================================================
1867     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1868     require(os);
1869     // =============================================================================
1870   }
1871 }