1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SignedMath.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Standard signed math utilities missing in the Solidity language.
56  */
57 library SignedMath {
58     /**
59      * @dev Returns the largest of two signed numbers.
60      */
61     function max(int256 a, int256 b) internal pure returns (int256) {
62         return a > b ? a : b;
63     }
64 
65     /**
66      * @dev Returns the smallest of two signed numbers.
67      */
68     function min(int256 a, int256 b) internal pure returns (int256) {
69         return a < b ? a : b;
70     }
71 
72     /**
73      * @dev Returns the average of two signed numbers without overflow.
74      * The result is rounded towards zero.
75      */
76     function average(int256 a, int256 b) internal pure returns (int256) {
77         // Formula from the book "Hacker's Delight"
78         int256 x = (a & b) + ((a ^ b) >> 1);
79         return x + (int256(uint256(x) >> 255) & (a ^ b));
80     }
81 
82     /**
83      * @dev Returns the absolute unsigned value of a signed value.
84      */
85     function abs(int256 n) internal pure returns (uint256) {
86         unchecked {
87             // must be unchecked in order to support `n = type(int256).min`
88             return uint256(n >= 0 ? n : -n);
89         }
90     }
91 }
92 
93 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
94 
95 
96 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Standard math utilities missing in the Solidity language.
102  */
103 library Math {
104     enum Rounding {
105         Down, // Toward negative infinity
106         Up, // Toward infinity
107         Zero // Toward zero
108     }
109 
110     /**
111      * @dev Returns the largest of two numbers.
112      */
113     function max(uint256 a, uint256 b) internal pure returns (uint256) {
114         return a > b ? a : b;
115     }
116 
117     /**
118      * @dev Returns the smallest of two numbers.
119      */
120     function min(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a < b ? a : b;
122     }
123 
124     /**
125      * @dev Returns the average of two numbers. The result is rounded towards
126      * zero.
127      */
128     function average(uint256 a, uint256 b) internal pure returns (uint256) {
129         // (a + b) / 2 can overflow.
130         return (a & b) + (a ^ b) / 2;
131     }
132 
133     /**
134      * @dev Returns the ceiling of the division of two numbers.
135      *
136      * This differs from standard division with `/` in that it rounds up instead
137      * of rounding down.
138      */
139     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
140         // (a + b - 1) / b can overflow on addition, so we distribute.
141         return a == 0 ? 0 : (a - 1) / b + 1;
142     }
143 
144     /**
145      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
146      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
147      * with further edits by Uniswap Labs also under MIT license.
148      */
149     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
150         unchecked {
151             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
152             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
153             // variables such that product = prod1 * 2^256 + prod0.
154             uint256 prod0; // Least significant 256 bits of the product
155             uint256 prod1; // Most significant 256 bits of the product
156             assembly {
157                 let mm := mulmod(x, y, not(0))
158                 prod0 := mul(x, y)
159                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
160             }
161 
162             // Handle non-overflow cases, 256 by 256 division.
163             if (prod1 == 0) {
164                 return prod0 / denominator;
165             }
166 
167             // Make sure the result is less than 2^256. Also prevents denominator == 0.
168             require(denominator > prod1, "Math: mulDiv overflow");
169 
170             ///////////////////////////////////////////////
171             // 512 by 256 division.
172             ///////////////////////////////////////////////
173 
174             // Make division exact by subtracting the remainder from [prod1 prod0].
175             uint256 remainder;
176             assembly {
177                 // Compute remainder using mulmod.
178                 remainder := mulmod(x, y, denominator)
179 
180                 // Subtract 256 bit number from 512 bit number.
181                 prod1 := sub(prod1, gt(remainder, prod0))
182                 prod0 := sub(prod0, remainder)
183             }
184 
185             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
186             // See https://cs.stackexchange.com/q/138556/92363.
187 
188             // Does not overflow because the denominator cannot be zero at this stage in the function.
189             uint256 twos = denominator & (~denominator + 1);
190             assembly {
191                 // Divide denominator by twos.
192                 denominator := div(denominator, twos)
193 
194                 // Divide [prod1 prod0] by twos.
195                 prod0 := div(prod0, twos)
196 
197                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
198                 twos := add(div(sub(0, twos), twos), 1)
199             }
200 
201             // Shift in bits from prod1 into prod0.
202             prod0 |= prod1 * twos;
203 
204             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
205             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
206             // four bits. That is, denominator * inv = 1 mod 2^4.
207             uint256 inverse = (3 * denominator) ^ 2;
208 
209             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
210             // in modular arithmetic, doubling the correct bits in each step.
211             inverse *= 2 - denominator * inverse; // inverse mod 2^8
212             inverse *= 2 - denominator * inverse; // inverse mod 2^16
213             inverse *= 2 - denominator * inverse; // inverse mod 2^32
214             inverse *= 2 - denominator * inverse; // inverse mod 2^64
215             inverse *= 2 - denominator * inverse; // inverse mod 2^128
216             inverse *= 2 - denominator * inverse; // inverse mod 2^256
217 
218             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
219             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
220             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
221             // is no longer required.
222             result = prod0 * inverse;
223             return result;
224         }
225     }
226 
227     /**
228      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
229      */
230     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
231         uint256 result = mulDiv(x, y, denominator);
232         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
233             result += 1;
234         }
235         return result;
236     }
237 
238     /**
239      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
240      *
241      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
242      */
243     function sqrt(uint256 a) internal pure returns (uint256) {
244         if (a == 0) {
245             return 0;
246         }
247 
248         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
249         //
250         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
251         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
252         //
253         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
254         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
255         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
256         //
257         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
258         uint256 result = 1 << (log2(a) >> 1);
259 
260         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
261         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
262         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
263         // into the expected uint128 result.
264         unchecked {
265             result = (result + a / result) >> 1;
266             result = (result + a / result) >> 1;
267             result = (result + a / result) >> 1;
268             result = (result + a / result) >> 1;
269             result = (result + a / result) >> 1;
270             result = (result + a / result) >> 1;
271             result = (result + a / result) >> 1;
272             return min(result, a / result);
273         }
274     }
275 
276     /**
277      * @notice Calculates sqrt(a), following the selected rounding direction.
278      */
279     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
280         unchecked {
281             uint256 result = sqrt(a);
282             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
283         }
284     }
285 
286     /**
287      * @dev Return the log in base 2, rounded down, of a positive value.
288      * Returns 0 if given 0.
289      */
290     function log2(uint256 value) internal pure returns (uint256) {
291         uint256 result = 0;
292         unchecked {
293             if (value >> 128 > 0) {
294                 value >>= 128;
295                 result += 128;
296             }
297             if (value >> 64 > 0) {
298                 value >>= 64;
299                 result += 64;
300             }
301             if (value >> 32 > 0) {
302                 value >>= 32;
303                 result += 32;
304             }
305             if (value >> 16 > 0) {
306                 value >>= 16;
307                 result += 16;
308             }
309             if (value >> 8 > 0) {
310                 value >>= 8;
311                 result += 8;
312             }
313             if (value >> 4 > 0) {
314                 value >>= 4;
315                 result += 4;
316             }
317             if (value >> 2 > 0) {
318                 value >>= 2;
319                 result += 2;
320             }
321             if (value >> 1 > 0) {
322                 result += 1;
323             }
324         }
325         return result;
326     }
327 
328     /**
329      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
330      * Returns 0 if given 0.
331      */
332     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
333         unchecked {
334             uint256 result = log2(value);
335             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
336         }
337     }
338 
339     /**
340      * @dev Return the log in base 10, rounded down, of a positive value.
341      * Returns 0 if given 0.
342      */
343     function log10(uint256 value) internal pure returns (uint256) {
344         uint256 result = 0;
345         unchecked {
346             if (value >= 10 ** 64) {
347                 value /= 10 ** 64;
348                 result += 64;
349             }
350             if (value >= 10 ** 32) {
351                 value /= 10 ** 32;
352                 result += 32;
353             }
354             if (value >= 10 ** 16) {
355                 value /= 10 ** 16;
356                 result += 16;
357             }
358             if (value >= 10 ** 8) {
359                 value /= 10 ** 8;
360                 result += 8;
361             }
362             if (value >= 10 ** 4) {
363                 value /= 10 ** 4;
364                 result += 4;
365             }
366             if (value >= 10 ** 2) {
367                 value /= 10 ** 2;
368                 result += 2;
369             }
370             if (value >= 10 ** 1) {
371                 result += 1;
372             }
373         }
374         return result;
375     }
376 
377     /**
378      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
379      * Returns 0 if given 0.
380      */
381     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
382         unchecked {
383             uint256 result = log10(value);
384             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
385         }
386     }
387 
388     /**
389      * @dev Return the log in base 256, rounded down, of a positive value.
390      * Returns 0 if given 0.
391      *
392      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
393      */
394     function log256(uint256 value) internal pure returns (uint256) {
395         uint256 result = 0;
396         unchecked {
397             if (value >> 128 > 0) {
398                 value >>= 128;
399                 result += 16;
400             }
401             if (value >> 64 > 0) {
402                 value >>= 64;
403                 result += 8;
404             }
405             if (value >> 32 > 0) {
406                 value >>= 32;
407                 result += 4;
408             }
409             if (value >> 16 > 0) {
410                 value >>= 16;
411                 result += 2;
412             }
413             if (value >> 8 > 0) {
414                 result += 1;
415             }
416         }
417         return result;
418     }
419 
420     /**
421      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
422      * Returns 0 if given 0.
423      */
424     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
425         unchecked {
426             uint256 result = log256(value);
427             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
428         }
429     }
430 }
431 
432 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
433 
434 
435 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 
440 
441 /**
442  * @dev String operations.
443  */
444 library Strings {
445     bytes16 private constant _SYMBOLS = "0123456789abcdef";
446     uint8 private constant _ADDRESS_LENGTH = 20;
447 
448     /**
449      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
450      */
451     function toString(uint256 value) internal pure returns (string memory) {
452         unchecked {
453             uint256 length = Math.log10(value) + 1;
454             string memory buffer = new string(length);
455             uint256 ptr;
456             /// @solidity memory-safe-assembly
457             assembly {
458                 ptr := add(buffer, add(32, length))
459             }
460             while (true) {
461                 ptr--;
462                 /// @solidity memory-safe-assembly
463                 assembly {
464                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
465                 }
466                 value /= 10;
467                 if (value == 0) break;
468             }
469             return buffer;
470         }
471     }
472 
473     /**
474      * @dev Converts a `int256` to its ASCII `string` decimal representation.
475      */
476     function toString(int256 value) internal pure returns (string memory) {
477         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
478     }
479 
480     /**
481      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
482      */
483     function toHexString(uint256 value) internal pure returns (string memory) {
484         unchecked {
485             return toHexString(value, Math.log256(value) + 1);
486         }
487     }
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
491      */
492     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
493         bytes memory buffer = new bytes(2 * length + 2);
494         buffer[0] = "0";
495         buffer[1] = "x";
496         for (uint256 i = 2 * length + 1; i > 1; --i) {
497             buffer[i] = _SYMBOLS[value & 0xf];
498             value >>= 4;
499         }
500         require(value == 0, "Strings: hex length insufficient");
501         return string(buffer);
502     }
503 
504     /**
505      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
506      */
507     function toHexString(address addr) internal pure returns (string memory) {
508         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
509     }
510 
511     /**
512      * @dev Returns true if the two strings are equal.
513      */
514     function equal(string memory a, string memory b) internal pure returns (bool) {
515         return keccak256(bytes(a)) == keccak256(bytes(b));
516     }
517 }
518 
519 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
520 
521 
522 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev Provides information about the current execution context, including the
528  * sender of the transaction and its data. While these are generally available
529  * via msg.sender and msg.data, they should not be accessed in such a direct
530  * manner, since when dealing with meta-transactions the account sending and
531  * paying for execution may not be the actual sender (as far as an application
532  * is concerned).
533  *
534  * This contract is only required for intermediate, library-like contracts.
535  */
536 abstract contract Context {
537     function _msgSender() internal view virtual returns (address) {
538         return msg.sender;
539     }
540 
541     function _msgData() internal view virtual returns (bytes calldata) {
542         return msg.data;
543     }
544 }
545 
546 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
547 
548 
549 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev Contract module which provides a basic access control mechanism, where
556  * there is an account (an owner) that can be granted exclusive access to
557  * specific functions.
558  *
559  * By default, the owner account will be the one that deploys the contract. This
560  * can later be changed with {transferOwnership}.
561  *
562  * This module is used through inheritance. It will make available the modifier
563  * `onlyOwner`, which can be applied to your functions to restrict their use to
564  * the owner.
565  */
566 abstract contract Ownable is Context {
567     address private _owner;
568 
569     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
570 
571     /**
572      * @dev Initializes the contract setting the deployer as the initial owner.
573      */
574     constructor() {
575         _transferOwnership(_msgSender());
576     }
577 
578     /**
579      * @dev Throws if called by any account other than the owner.
580      */
581     modifier onlyOwner() {
582         _checkOwner();
583         _;
584     }
585 
586     /**
587      * @dev Returns the address of the current owner.
588      */
589     function owner() public view virtual returns (address) {
590         return _owner;
591     }
592 
593     /**
594      * @dev Throws if the sender is not the owner.
595      */
596     function _checkOwner() internal view virtual {
597         require(owner() == _msgSender(), "Ownable: caller is not the owner");
598     }
599 
600     /**
601      * @dev Leaves the contract without owner. It will not be possible to call
602      * `onlyOwner` functions anymore. Can only be called by the current owner.
603      *
604      * NOTE: Renouncing ownership will leave the contract without an owner,
605      * thereby removing any functionality that is only available to the owner.
606      */
607     function renounceOwnership() public virtual onlyOwner {
608         _transferOwnership(address(0));
609     }
610 
611     /**
612      * @dev Transfers ownership of the contract to a new account (`newOwner`).
613      * Can only be called by the current owner.
614      */
615     function transferOwnership(address newOwner) public virtual onlyOwner {
616         require(newOwner != address(0), "Ownable: new owner is the zero address");
617         _transferOwnership(newOwner);
618     }
619 
620     /**
621      * @dev Transfers ownership of the contract to a new account (`newOwner`).
622      * Internal function without access restriction.
623      */
624     function _transferOwnership(address newOwner) internal virtual {
625         address oldOwner = _owner;
626         _owner = newOwner;
627         emit OwnershipTransferred(oldOwner, newOwner);
628     }
629 }
630 
631 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol
632 
633 
634 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 
639 /**
640  * @dev Contract module which allows children to implement an emergency stop
641  * mechanism that can be triggered by an authorized account.
642  *
643  * This module is used through inheritance. It will make available the
644  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
645  * the functions of your contract. Note that they will not be pausable by
646  * simply including this module, only once the modifiers are put in place.
647  */
648 abstract contract Pausable is Context {
649     /**
650      * @dev Emitted when the pause is triggered by `account`.
651      */
652     event Paused(address account);
653 
654     /**
655      * @dev Emitted when the pause is lifted by `account`.
656      */
657     event Unpaused(address account);
658 
659     bool private _paused;
660 
661     /**
662      * @dev Initializes the contract in unpaused state.
663      */
664     constructor() {
665         _paused = false;
666     }
667 
668     /**
669      * @dev Modifier to make a function callable only when the contract is not paused.
670      *
671      * Requirements:
672      *
673      * - The contract must not be paused.
674      */
675     modifier whenNotPaused() {
676         _requireNotPaused();
677         _;
678     }
679 
680     /**
681      * @dev Modifier to make a function callable only when the contract is paused.
682      *
683      * Requirements:
684      *
685      * - The contract must be paused.
686      */
687     modifier whenPaused() {
688         _requirePaused();
689         _;
690     }
691 
692     /**
693      * @dev Returns true if the contract is paused, and false otherwise.
694      */
695     function paused() public view virtual returns (bool) {
696         return _paused;
697     }
698 
699     /**
700      * @dev Throws if the contract is paused.
701      */
702     function _requireNotPaused() internal view virtual {
703         require(!paused(), "Pausable: paused");
704     }
705 
706     /**
707      * @dev Throws if the contract is not paused.
708      */
709     function _requirePaused() internal view virtual {
710         require(paused(), "Pausable: not paused");
711     }
712 
713     /**
714      * @dev Triggers stopped state.
715      *
716      * Requirements:
717      *
718      * - The contract must not be paused.
719      */
720     function _pause() internal virtual whenNotPaused {
721         _paused = true;
722         emit Paused(_msgSender());
723     }
724 
725     /**
726      * @dev Returns to normal state.
727      *
728      * Requirements:
729      *
730      * - The contract must be paused.
731      */
732     function _unpause() internal virtual whenPaused {
733         _paused = false;
734         emit Unpaused(_msgSender());
735     }
736 }
737 
738 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
739 
740 
741 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
742 
743 pragma solidity ^0.8.1;
744 
745 /**
746  * @dev Collection of functions related to the address type
747  */
748 library Address {
749     /**
750      * @dev Returns true if `account` is a contract.
751      *
752      * [IMPORTANT]
753      * ====
754      * It is unsafe to assume that an address for which this function returns
755      * false is an externally-owned account (EOA) and not a contract.
756      *
757      * Among others, `isContract` will return false for the following
758      * types of addresses:
759      *
760      *  - an externally-owned account
761      *  - a contract in construction
762      *  - an address where a contract will be created
763      *  - an address where a contract lived, but was destroyed
764      *
765      * Furthermore, `isContract` will also return true if the target contract within
766      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
767      * which only has an effect at the end of a transaction.
768      * ====
769      *
770      * [IMPORTANT]
771      * ====
772      * You shouldn't rely on `isContract` to protect against flash loan attacks!
773      *
774      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
775      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
776      * constructor.
777      * ====
778      */
779     function isContract(address account) internal view returns (bool) {
780         // This method relies on extcodesize/address.code.length, which returns 0
781         // for contracts in construction, since the code is only stored at the end
782         // of the constructor execution.
783 
784         return account.code.length > 0;
785     }
786 
787     /**
788      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
789      * `recipient`, forwarding all available gas and reverting on errors.
790      *
791      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
792      * of certain opcodes, possibly making contracts go over the 2300 gas limit
793      * imposed by `transfer`, making them unable to receive funds via
794      * `transfer`. {sendValue} removes this limitation.
795      *
796      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
797      *
798      * IMPORTANT: because control is transferred to `recipient`, care must be
799      * taken to not create reentrancy vulnerabilities. Consider using
800      * {ReentrancyGuard} or the
801      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
802      */
803     function sendValue(address payable recipient, uint256 amount) internal {
804         require(address(this).balance >= amount, "Address: insufficient balance");
805 
806         (bool success, ) = recipient.call{value: amount}("");
807         require(success, "Address: unable to send value, recipient may have reverted");
808     }
809 
810     /**
811      * @dev Performs a Solidity function call using a low level `call`. A
812      * plain `call` is an unsafe replacement for a function call: use this
813      * function instead.
814      *
815      * If `target` reverts with a revert reason, it is bubbled up by this
816      * function (like regular Solidity function calls).
817      *
818      * Returns the raw returned data. To convert to the expected return value,
819      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
820      *
821      * Requirements:
822      *
823      * - `target` must be a contract.
824      * - calling `target` with `data` must not revert.
825      *
826      * _Available since v3.1._
827      */
828     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
829         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
830     }
831 
832     /**
833      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
834      * `errorMessage` as a fallback revert reason when `target` reverts.
835      *
836      * _Available since v3.1._
837      */
838     function functionCall(
839         address target,
840         bytes memory data,
841         string memory errorMessage
842     ) internal returns (bytes memory) {
843         return functionCallWithValue(target, data, 0, errorMessage);
844     }
845 
846     /**
847      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
848      * but also transferring `value` wei to `target`.
849      *
850      * Requirements:
851      *
852      * - the calling contract must have an ETH balance of at least `value`.
853      * - the called Solidity function must be `payable`.
854      *
855      * _Available since v3.1._
856      */
857     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
858         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
859     }
860 
861     /**
862      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
863      * with `errorMessage` as a fallback revert reason when `target` reverts.
864      *
865      * _Available since v3.1._
866      */
867     function functionCallWithValue(
868         address target,
869         bytes memory data,
870         uint256 value,
871         string memory errorMessage
872     ) internal returns (bytes memory) {
873         require(address(this).balance >= value, "Address: insufficient balance for call");
874         (bool success, bytes memory returndata) = target.call{value: value}(data);
875         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
876     }
877 
878     /**
879      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
880      * but performing a static call.
881      *
882      * _Available since v3.3._
883      */
884     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
885         return functionStaticCall(target, data, "Address: low-level static call failed");
886     }
887 
888     /**
889      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
890      * but performing a static call.
891      *
892      * _Available since v3.3._
893      */
894     function functionStaticCall(
895         address target,
896         bytes memory data,
897         string memory errorMessage
898     ) internal view returns (bytes memory) {
899         (bool success, bytes memory returndata) = target.staticcall(data);
900         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
901     }
902 
903     /**
904      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
905      * but performing a delegate call.
906      *
907      * _Available since v3.4._
908      */
909     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
910         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
911     }
912 
913     /**
914      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
915      * but performing a delegate call.
916      *
917      * _Available since v3.4._
918      */
919     function functionDelegateCall(
920         address target,
921         bytes memory data,
922         string memory errorMessage
923     ) internal returns (bytes memory) {
924         (bool success, bytes memory returndata) = target.delegatecall(data);
925         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
926     }
927 
928     /**
929      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
930      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
931      *
932      * _Available since v4.8._
933      */
934     function verifyCallResultFromTarget(
935         address target,
936         bool success,
937         bytes memory returndata,
938         string memory errorMessage
939     ) internal view returns (bytes memory) {
940         if (success) {
941             if (returndata.length == 0) {
942                 // only check isContract if the call was successful and the return data is empty
943                 // otherwise we already know that it was a contract
944                 require(isContract(target), "Address: call to non-contract");
945             }
946             return returndata;
947         } else {
948             _revert(returndata, errorMessage);
949         }
950     }
951 
952     /**
953      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
954      * revert reason or using the provided one.
955      *
956      * _Available since v4.3._
957      */
958     function verifyCallResult(
959         bool success,
960         bytes memory returndata,
961         string memory errorMessage
962     ) internal pure returns (bytes memory) {
963         if (success) {
964             return returndata;
965         } else {
966             _revert(returndata, errorMessage);
967         }
968     }
969 
970     function _revert(bytes memory returndata, string memory errorMessage) private pure {
971         // Look for revert reason and bubble it up if present
972         if (returndata.length > 0) {
973             // The easiest way to bubble the revert reason is using memory via assembly
974             /// @solidity memory-safe-assembly
975             assembly {
976                 let returndata_size := mload(returndata)
977                 revert(add(32, returndata), returndata_size)
978             }
979         } else {
980             revert(errorMessage);
981         }
982     }
983 }
984 
985 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
986 
987 
988 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
989 
990 pragma solidity ^0.8.0;
991 
992 /**
993  * @title ERC721 token receiver interface
994  * @dev Interface for any contract that wants to support safeTransfers
995  * from ERC721 asset contracts.
996  */
997 interface IERC721Receiver {
998     /**
999      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1000      * by `operator` from `from`, this function is called.
1001      *
1002      * It must return its Solidity selector to confirm the token transfer.
1003      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1004      *
1005      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1006      */
1007     function onERC721Received(
1008         address operator,
1009         address from,
1010         uint256 tokenId,
1011         bytes calldata data
1012     ) external returns (bytes4);
1013 }
1014 
1015 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1016 
1017 
1018 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1019 
1020 pragma solidity ^0.8.0;
1021 
1022 /**
1023  * @dev Interface of the ERC165 standard, as defined in the
1024  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1025  *
1026  * Implementers can declare support of contract interfaces, which can then be
1027  * queried by others ({ERC165Checker}).
1028  *
1029  * For an implementation, see {ERC165}.
1030  */
1031 interface IERC165 {
1032     /**
1033      * @dev Returns true if this contract implements the interface defined by
1034      * `interfaceId`. See the corresponding
1035      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1036      * to learn more about how these ids are created.
1037      *
1038      * This function call must use less than 30 000 gas.
1039      */
1040     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1041 }
1042 
1043 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1044 
1045 
1046 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1047 
1048 pragma solidity ^0.8.0;
1049 
1050 
1051 /**
1052  * @dev Implementation of the {IERC165} interface.
1053  *
1054  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1055  * for the additional interface id that will be supported. For example:
1056  *
1057  * ```solidity
1058  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1059  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1060  * }
1061  * ```
1062  *
1063  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1064  */
1065 abstract contract ERC165 is IERC165 {
1066     /**
1067      * @dev See {IERC165-supportsInterface}.
1068      */
1069     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1070         return interfaceId == type(IERC165).interfaceId;
1071     }
1072 }
1073 
1074 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1075 
1076 
1077 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1078 
1079 pragma solidity ^0.8.0;
1080 
1081 
1082 /**
1083  * @dev Required interface of an ERC721 compliant contract.
1084  */
1085 interface IERC721 is IERC165 {
1086     /**
1087      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1088      */
1089     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1090 
1091     /**
1092      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1093      */
1094     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1095 
1096     /**
1097      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1098      */
1099     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1100 
1101     /**
1102      * @dev Returns the number of tokens in ``owner``'s account.
1103      */
1104     function balanceOf(address owner) external view returns (uint256 balance);
1105 
1106     /**
1107      * @dev Returns the owner of the `tokenId` token.
1108      *
1109      * Requirements:
1110      *
1111      * - `tokenId` must exist.
1112      */
1113     function ownerOf(uint256 tokenId) external view returns (address owner);
1114 
1115     /**
1116      * @dev Safely transfers `tokenId` token from `from` to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `from` cannot be the zero address.
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must exist and be owned by `from`.
1123      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1129 
1130     /**
1131      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1132      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1133      *
1134      * Requirements:
1135      *
1136      * - `from` cannot be the zero address.
1137      * - `to` cannot be the zero address.
1138      * - `tokenId` token must exist and be owned by `from`.
1139      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1140      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1145 
1146     /**
1147      * @dev Transfers `tokenId` token from `from` to `to`.
1148      *
1149      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1150      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1151      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1152      *
1153      * Requirements:
1154      *
1155      * - `from` cannot be the zero address.
1156      * - `to` cannot be the zero address.
1157      * - `tokenId` token must be owned by `from`.
1158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function transferFrom(address from, address to, uint256 tokenId) external;
1163 
1164     /**
1165      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1166      * The approval is cleared when the token is transferred.
1167      *
1168      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1169      *
1170      * Requirements:
1171      *
1172      * - The caller must own the token or be an approved operator.
1173      * - `tokenId` must exist.
1174      *
1175      * Emits an {Approval} event.
1176      */
1177     function approve(address to, uint256 tokenId) external;
1178 
1179     /**
1180      * @dev Approve or remove `operator` as an operator for the caller.
1181      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1182      *
1183      * Requirements:
1184      *
1185      * - The `operator` cannot be the caller.
1186      *
1187      * Emits an {ApprovalForAll} event.
1188      */
1189     function setApprovalForAll(address operator, bool approved) external;
1190 
1191     /**
1192      * @dev Returns the account approved for `tokenId` token.
1193      *
1194      * Requirements:
1195      *
1196      * - `tokenId` must exist.
1197      */
1198     function getApproved(uint256 tokenId) external view returns (address operator);
1199 
1200     /**
1201      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1202      *
1203      * See {setApprovalForAll}
1204      */
1205     function isApprovedForAll(address owner, address operator) external view returns (bool);
1206 }
1207 
1208 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1209 
1210 
1211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1212 
1213 pragma solidity ^0.8.0;
1214 
1215 
1216 /**
1217  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1218  * @dev See https://eips.ethereum.org/EIPS/eip-721
1219  */
1220 interface IERC721Metadata is IERC721 {
1221     /**
1222      * @dev Returns the token collection name.
1223      */
1224     function name() external view returns (string memory);
1225 
1226     /**
1227      * @dev Returns the token collection symbol.
1228      */
1229     function symbol() external view returns (string memory);
1230 
1231     /**
1232      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1233      */
1234     function tokenURI(uint256 tokenId) external view returns (string memory);
1235 }
1236 
1237 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1238 
1239 
1240 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1241 
1242 pragma solidity ^0.8.0;
1243 
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 /**
1252  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1253  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1254  * {ERC721Enumerable}.
1255  */
1256 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1257     using Address for address;
1258     using Strings for uint256;
1259 
1260     // Token name
1261     string private _name;
1262 
1263     // Token symbol
1264     string private _symbol;
1265 
1266     // Mapping from token ID to owner address
1267     mapping(uint256 => address) private _owners;
1268 
1269     // Mapping owner address to token count
1270     mapping(address => uint256) private _balances;
1271 
1272     // Mapping from token ID to approved address
1273     mapping(uint256 => address) private _tokenApprovals;
1274 
1275     // Mapping from owner to operator approvals
1276     mapping(address => mapping(address => bool)) private _operatorApprovals;
1277 
1278     /**
1279      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1280      */
1281     constructor(string memory name_, string memory symbol_) {
1282         _name = name_;
1283         _symbol = symbol_;
1284     }
1285 
1286     /**
1287      * @dev See {IERC165-supportsInterface}.
1288      */
1289     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1290         return
1291             interfaceId == type(IERC721).interfaceId ||
1292             interfaceId == type(IERC721Metadata).interfaceId ||
1293             super.supportsInterface(interfaceId);
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-balanceOf}.
1298      */
1299     function balanceOf(address owner) public view virtual override returns (uint256) {
1300         require(owner != address(0), "ERC721: address zero is not a valid owner");
1301         return _balances[owner];
1302     }
1303 
1304     /**
1305      * @dev See {IERC721-ownerOf}.
1306      */
1307     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1308         address owner = _ownerOf(tokenId);
1309         require(owner != address(0), "ERC721: invalid token ID");
1310         return owner;
1311     }
1312 
1313     /**
1314      * @dev See {IERC721Metadata-name}.
1315      */
1316     function name() public view virtual override returns (string memory) {
1317         return _name;
1318     }
1319 
1320     /**
1321      * @dev See {IERC721Metadata-symbol}.
1322      */
1323     function symbol() public view virtual override returns (string memory) {
1324         return _symbol;
1325     }
1326 
1327     /**
1328      * @dev See {IERC721Metadata-tokenURI}.
1329      */
1330     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1331         _requireMinted(tokenId);
1332 
1333         string memory baseURI = _baseURI();
1334         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1335     }
1336 
1337     /**
1338      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1339      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1340      * by default, can be overridden in child contracts.
1341      */
1342     function _baseURI() internal view virtual returns (string memory) {
1343         return "";
1344     }
1345 
1346     /**
1347      * @dev See {IERC721-approve}.
1348      */
1349     function approve(address to, uint256 tokenId) public virtual override {
1350         address owner = ERC721.ownerOf(tokenId);
1351         require(to != owner, "ERC721: approval to current owner");
1352 
1353         require(
1354             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1355             "ERC721: approve caller is not token owner or approved for all"
1356         );
1357 
1358         _approve(to, tokenId);
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-getApproved}.
1363      */
1364     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1365         _requireMinted(tokenId);
1366 
1367         return _tokenApprovals[tokenId];
1368     }
1369 
1370     /**
1371      * @dev See {IERC721-setApprovalForAll}.
1372      */
1373     function setApprovalForAll(address operator, bool approved) public virtual override {
1374         _setApprovalForAll(_msgSender(), operator, approved);
1375     }
1376 
1377     /**
1378      * @dev See {IERC721-isApprovedForAll}.
1379      */
1380     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1381         return _operatorApprovals[owner][operator];
1382     }
1383 
1384     /**
1385      * @dev See {IERC721-transferFrom}.
1386      */
1387     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1388         //solhint-disable-next-line max-line-length
1389         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1390 
1391         _transfer(from, to, tokenId);
1392     }
1393 
1394     /**
1395      * @dev See {IERC721-safeTransferFrom}.
1396      */
1397     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1398         safeTransferFrom(from, to, tokenId, "");
1399     }
1400 
1401     /**
1402      * @dev See {IERC721-safeTransferFrom}.
1403      */
1404     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
1405         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1406         _safeTransfer(from, to, tokenId, data);
1407     }
1408 
1409     /**
1410      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1411      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1412      *
1413      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1414      *
1415      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1416      * implement alternative mechanisms to perform token transfer, such as signature-based.
1417      *
1418      * Requirements:
1419      *
1420      * - `from` cannot be the zero address.
1421      * - `to` cannot be the zero address.
1422      * - `tokenId` token must exist and be owned by `from`.
1423      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1424      *
1425      * Emits a {Transfer} event.
1426      */
1427     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
1428         _transfer(from, to, tokenId);
1429         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1430     }
1431 
1432     /**
1433      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1434      */
1435     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1436         return _owners[tokenId];
1437     }
1438 
1439     /**
1440      * @dev Returns whether `tokenId` exists.
1441      *
1442      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1443      *
1444      * Tokens start existing when they are minted (`_mint`),
1445      * and stop existing when they are burned (`_burn`).
1446      */
1447     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1448         return _ownerOf(tokenId) != address(0);
1449     }
1450 
1451     /**
1452      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1453      *
1454      * Requirements:
1455      *
1456      * - `tokenId` must exist.
1457      */
1458     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1459         address owner = ERC721.ownerOf(tokenId);
1460         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1461     }
1462 
1463     /**
1464      * @dev Safely mints `tokenId` and transfers it to `to`.
1465      *
1466      * Requirements:
1467      *
1468      * - `tokenId` must not exist.
1469      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1470      *
1471      * Emits a {Transfer} event.
1472      */
1473     function _safeMint(address to, uint256 tokenId) internal virtual {
1474         _safeMint(to, tokenId, "");
1475     }
1476 
1477     /**
1478      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1479      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1480      */
1481     function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
1482         _mint(to, tokenId);
1483         require(
1484             _checkOnERC721Received(address(0), to, tokenId, data),
1485             "ERC721: transfer to non ERC721Receiver implementer"
1486         );
1487     }
1488 
1489     /**
1490      * @dev Mints `tokenId` and transfers it to `to`.
1491      *
1492      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1493      *
1494      * Requirements:
1495      *
1496      * - `tokenId` must not exist.
1497      * - `to` cannot be the zero address.
1498      *
1499      * Emits a {Transfer} event.
1500      */
1501     function _mint(address to, uint256 tokenId) internal virtual {
1502         require(to != address(0), "ERC721: mint to the zero address");
1503         require(!_exists(tokenId), "ERC721: token already minted");
1504 
1505         _beforeTokenTransfer(address(0), to, tokenId, 1);
1506 
1507         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1508         require(!_exists(tokenId), "ERC721: token already minted");
1509 
1510         unchecked {
1511             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1512             // Given that tokens are minted one by one, it is impossible in practice that
1513             // this ever happens. Might change if we allow batch minting.
1514             // The ERC fails to describe this case.
1515             _balances[to] += 1;
1516         }
1517 
1518         _owners[tokenId] = to;
1519 
1520         emit Transfer(address(0), to, tokenId);
1521 
1522         _afterTokenTransfer(address(0), to, tokenId, 1);
1523     }
1524 
1525     /**
1526      * @dev Destroys `tokenId`.
1527      * The approval is cleared when the token is burned.
1528      * This is an internal function that does not check if the sender is authorized to operate on the token.
1529      *
1530      * Requirements:
1531      *
1532      * - `tokenId` must exist.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function _burn(uint256 tokenId) internal virtual {
1537         address owner = ERC721.ownerOf(tokenId);
1538 
1539         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1540 
1541         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1542         owner = ERC721.ownerOf(tokenId);
1543 
1544         // Clear approvals
1545         delete _tokenApprovals[tokenId];
1546 
1547         unchecked {
1548             // Cannot overflow, as that would require more tokens to be burned/transferred
1549             // out than the owner initially received through minting and transferring in.
1550             _balances[owner] -= 1;
1551         }
1552         delete _owners[tokenId];
1553 
1554         emit Transfer(owner, address(0), tokenId);
1555 
1556         _afterTokenTransfer(owner, address(0), tokenId, 1);
1557     }
1558 
1559     /**
1560      * @dev Transfers `tokenId` from `from` to `to`.
1561      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1562      *
1563      * Requirements:
1564      *
1565      * - `to` cannot be the zero address.
1566      * - `tokenId` token must be owned by `from`.
1567      *
1568      * Emits a {Transfer} event.
1569      */
1570     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1571         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1572         require(to != address(0), "ERC721: transfer to the zero address");
1573 
1574         _beforeTokenTransfer(from, to, tokenId, 1);
1575 
1576         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1577         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1578 
1579         // Clear approvals from the previous owner
1580         delete _tokenApprovals[tokenId];
1581 
1582         unchecked {
1583             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1584             // `from`'s balance is the number of token held, which is at least one before the current
1585             // transfer.
1586             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1587             // all 2**256 token ids to be minted, which in practice is impossible.
1588             _balances[from] -= 1;
1589             _balances[to] += 1;
1590         }
1591         _owners[tokenId] = to;
1592 
1593         emit Transfer(from, to, tokenId);
1594 
1595         _afterTokenTransfer(from, to, tokenId, 1);
1596     }
1597 
1598     /**
1599      * @dev Approve `to` to operate on `tokenId`
1600      *
1601      * Emits an {Approval} event.
1602      */
1603     function _approve(address to, uint256 tokenId) internal virtual {
1604         _tokenApprovals[tokenId] = to;
1605         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1606     }
1607 
1608     /**
1609      * @dev Approve `operator` to operate on all of `owner` tokens
1610      *
1611      * Emits an {ApprovalForAll} event.
1612      */
1613     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
1614         require(owner != operator, "ERC721: approve to caller");
1615         _operatorApprovals[owner][operator] = approved;
1616         emit ApprovalForAll(owner, operator, approved);
1617     }
1618 
1619     /**
1620      * @dev Reverts if the `tokenId` has not been minted yet.
1621      */
1622     function _requireMinted(uint256 tokenId) internal view virtual {
1623         require(_exists(tokenId), "ERC721: invalid token ID");
1624     }
1625 
1626     /**
1627      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1628      * The call is not executed if the target address is not a contract.
1629      *
1630      * @param from address representing the previous owner of the given token ID
1631      * @param to target address that will receive the tokens
1632      * @param tokenId uint256 ID of the token to be transferred
1633      * @param data bytes optional data to send along with the call
1634      * @return bool whether the call correctly returned the expected magic value
1635      */
1636     function _checkOnERC721Received(
1637         address from,
1638         address to,
1639         uint256 tokenId,
1640         bytes memory data
1641     ) private returns (bool) {
1642         if (to.isContract()) {
1643             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1644                 return retval == IERC721Receiver.onERC721Received.selector;
1645             } catch (bytes memory reason) {
1646                 if (reason.length == 0) {
1647                     revert("ERC721: transfer to non ERC721Receiver implementer");
1648                 } else {
1649                     /// @solidity memory-safe-assembly
1650                     assembly {
1651                         revert(add(32, reason), mload(reason))
1652                     }
1653                 }
1654             }
1655         } else {
1656             return true;
1657         }
1658     }
1659 
1660     /**
1661      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1662      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1663      *
1664      * Calling conditions:
1665      *
1666      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1667      * - When `from` is zero, the tokens will be minted for `to`.
1668      * - When `to` is zero, ``from``'s tokens will be burned.
1669      * - `from` and `to` are never both zero.
1670      * - `batchSize` is non-zero.
1671      *
1672      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1673      */
1674     function _beforeTokenTransfer(
1675         address from,
1676         address to,
1677         uint256 /* firstTokenId */,
1678         uint256 batchSize
1679     ) internal virtual {
1680         if (batchSize > 1) {
1681             if (from != address(0)) {
1682                 _balances[from] -= batchSize;
1683             }
1684             if (to != address(0)) {
1685                 _balances[to] += batchSize;
1686             }
1687         }
1688     }
1689 
1690     /**
1691      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1692      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1693      *
1694      * Calling conditions:
1695      *
1696      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1697      * - When `from` is zero, the tokens were minted for `to`.
1698      * - When `to` is zero, ``from``'s tokens were burned.
1699      * - `from` and `to` are never both zero.
1700      * - `batchSize` is non-zero.
1701      *
1702      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1703      */
1704     function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
1705 }
1706 
1707 // File: KNOT.sol
1708 
1709 
1710 pragma solidity ^0.8.9;
1711 
1712 
1713 
1714 
1715 
1716 contract KNOT is ERC721, Pausable, Ownable {
1717     
1718     using Counters for Counters.Counter;
1719 
1720     Counters.Counter private _tokenIdCounter;
1721     /** Maximum number of tokens per tx */
1722     uint256 public constant MAX_TX = 1;
1723     /** Maximum amount of tokens in collection */
1724     uint256 public constant MAX_SUPPLY = 256;
1725     /** Price per token */
1726     uint256 public cost_1 = 0.038 ether;
1727     uint256 public cost_2 = 1 ether;
1728     /** Max free */
1729     uint256 public free = 50 + 14;
1730 
1731     bytes32 public answer =
1732         0xccb1f717aa77602faf03a594761a36956b1c4cf44c6b336d1db57da799b331b8;
1733 
1734     string public baseURI = "https://dalle3.mypinata.cloud/ipfs/QmRGR6Azcc8r8XMH1iqBbuf17j2tUbr4wUyYoUKJSm3xjC/";
1735 
1736     constructor() ERC721("KNOT GENESIS by DALLE-3", "KNOT") {}
1737 
1738     function _baseURI() internal view virtual override returns (string memory) {
1739         return baseURI;
1740     }
1741 
1742     function totalSupply() public view returns (uint256) {
1743         return _tokenIdCounter.current();
1744     }
1745 
1746     function setBaseURI(string calldata _val) external onlyOwner {
1747         baseURI = _val;
1748     }
1749 
1750     function setCost1(uint256 _cost) external onlyOwner {
1751         cost_1 = _cost;
1752     }
1753 
1754     function setCost2(uint256 _cost) external onlyOwner {
1755         cost_2 = _cost;
1756     }
1757 
1758     function withdraw() external onlyOwner {
1759         (bool success, ) = payable(owner()).call{value: address(this).balance}('');
1760         require(success);
1761     }
1762 
1763     function pause() public onlyOwner {
1764         _pause();
1765     }
1766 
1767     function unpause() public onlyOwner {
1768         _unpause();
1769     }
1770 
1771     function adminMint(address to) public onlyOwner {
1772         for (uint i = 0; i < 14; ++i) {
1773             uint256 tokenId = _tokenIdCounter.current();
1774             _tokenIdCounter.increment();
1775             _safeMint(to, tokenId);
1776         }
1777     }
1778 
1779     function mint(string calldata ans) public whenNotPaused payable {
1780         require(_tokenIdCounter.current() < MAX_SUPPLY, "Purchase would exceed max supply");
1781 
1782         require(keccak256(abi.encodePacked(ans)) == answer && (msg.value >= cost_1 || _tokenIdCounter.current() < free)
1783             || keccak256(abi.encodePacked(ans)) != answer && msg.value >= cost_2, "Ether value sent is not correct");
1784         
1785         uint256 tokenId = _tokenIdCounter.current();
1786         _tokenIdCounter.increment();
1787         _safeMint(msg.sender, tokenId);
1788     }
1789 
1790     function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
1791         internal
1792         whenNotPaused
1793         override
1794     {
1795         super._beforeTokenTransfer(from, to, tokenId, batchSize);
1796     }
1797 }