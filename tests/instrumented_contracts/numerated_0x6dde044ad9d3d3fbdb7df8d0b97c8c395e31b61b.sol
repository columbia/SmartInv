1 // SPDX-License-Identifier: MIT
2 // File: opensea-enforcement/IOperatorFilterRegistry.sol
3 
4 
5 pragma solidity ^0.8.13;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
9     function register(address registrant) external;
10     function registerAndSubscribe(address registrant, address subscription) external;
11     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: opensea-enforcement/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 abstract contract OperatorFilterer {
40     error OperatorNotAllowed(address operator);
41 
42     IOperatorFilterRegistry constant operatorFilterRegistry =
43         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
44 
45     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
46         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
47         // will not revert, but the contract will need to be registered with the registry once it is deployed in
48         // order for the modifier to filter addresses.
49         if (address(operatorFilterRegistry).code.length > 0) {
50             if (subscribe) {
51                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
52             } else {
53                 if (subscriptionOrRegistrantToCopy != address(0)) {
54                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
55                 } else {
56                     operatorFilterRegistry.register(address(this));
57                 }
58             }
59         }
60     }
61 
62     modifier onlyAllowedOperator(address from) virtual {
63         // Check registry code length to facilitate testing in environments without a deployed registry.
64         if (address(operatorFilterRegistry).code.length > 0) {
65             // Allow spending tokens from addresses with balance
66             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
67             // from an EOA.
68             if (from == msg.sender) {
69                 _;
70                 return;
71             }
72             if (
73                 !(
74                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
75                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
76                 )
77             ) {
78                 revert OperatorNotAllowed(msg.sender);
79             }
80         }
81         _;
82     }
83 }
84 
85 // File: opensea-enforcement/DefaultOperatorFilterer.sol
86 
87 
88 pragma solidity ^0.8.13;
89 
90 
91 abstract contract DefaultOperatorFilterer is OperatorFilterer {
92     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
93 
94     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
95 }
96 
97 // File: @openzeppelin/contracts/utils/Counters.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @title Counters
106  * @author Matt Condon (@shrugs)
107  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
108  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
109  *
110  * Include with `using Counters for Counters.Counter;`
111  */
112 library Counters {
113     struct Counter {
114         // This variable should never be directly accessed by users of the library: interactions must be restricted to
115         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
116         // this feature: see https://github.com/ethereum/solidity/issues/4637
117         uint256 _value; // default: 0
118     }
119 
120     function current(Counter storage counter) internal view returns (uint256) {
121         return counter._value;
122     }
123 
124     function increment(Counter storage counter) internal {
125         unchecked {
126             counter._value += 1;
127         }
128     }
129 
130     function decrement(Counter storage counter) internal {
131         uint256 value = counter._value;
132         require(value > 0, "Counter: decrement overflow");
133         unchecked {
134             counter._value = value - 1;
135         }
136     }
137 
138     function reset(Counter storage counter) internal {
139         counter._value = 0;
140     }
141 }
142 
143 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
144 
145 
146 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Contract module that helps prevent reentrant calls to a function.
152  *
153  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
154  * available, which can be applied to functions to make sure there are no nested
155  * (reentrant) calls to them.
156  *
157  * Note that because there is a single `nonReentrant` guard, functions marked as
158  * `nonReentrant` may not call one another. This can be worked around by making
159  * those functions `private`, and then adding `external` `nonReentrant` entry
160  * points to them.
161  *
162  * TIP: If you would like to learn more about reentrancy and alternative ways
163  * to protect against it, check out our blog post
164  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
165  */
166 abstract contract ReentrancyGuard {
167     // Booleans are more expensive than uint256 or any type that takes up a full
168     // word because each write operation emits an extra SLOAD to first read the
169     // slot's contents, replace the bits taken up by the boolean, and then write
170     // back. This is the compiler's defense against contract upgrades and
171     // pointer aliasing, and it cannot be disabled.
172 
173     // The values being non-zero value makes deployment a bit more expensive,
174     // but in exchange the refund on every call to nonReentrant will be lower in
175     // amount. Since refunds are capped to a percentage of the total
176     // transaction's gas, it is best to keep them low in cases like this one, to
177     // increase the likelihood of the full refund coming into effect.
178     uint256 private constant _NOT_ENTERED = 1;
179     uint256 private constant _ENTERED = 2;
180 
181     uint256 private _status;
182 
183     constructor() {
184         _status = _NOT_ENTERED;
185     }
186 
187     /**
188      * @dev Prevents a contract from calling itself, directly or indirectly.
189      * Calling a `nonReentrant` function from another `nonReentrant`
190      * function is not supported. It is possible to prevent this from happening
191      * by making the `nonReentrant` function external, and making it call a
192      * `private` function that does the actual work.
193      */
194     modifier nonReentrant() {
195         _nonReentrantBefore();
196         _;
197         _nonReentrantAfter();
198     }
199 
200     function _nonReentrantBefore() private {
201         // On the first call to nonReentrant, _status will be _NOT_ENTERED
202         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
203 
204         // Any calls to nonReentrant after this point will fail
205         _status = _ENTERED;
206     }
207 
208     function _nonReentrantAfter() private {
209         // By storing the original value once again, a refund is triggered (see
210         // https://eips.ethereum.org/EIPS/eip-2200)
211         _status = _NOT_ENTERED;
212     }
213 }
214 
215 // File: @openzeppelin/contracts/utils/math/Math.sol
216 
217 
218 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @dev Standard math utilities missing in the Solidity language.
224  */
225 library Math {
226     enum Rounding {
227         Down, // Toward negative infinity
228         Up, // Toward infinity
229         Zero // Toward zero
230     }
231 
232     /**
233      * @dev Returns the largest of two numbers.
234      */
235     function max(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a > b ? a : b;
237     }
238 
239     /**
240      * @dev Returns the smallest of two numbers.
241      */
242     function min(uint256 a, uint256 b) internal pure returns (uint256) {
243         return a < b ? a : b;
244     }
245 
246     /**
247      * @dev Returns the average of two numbers. The result is rounded towards
248      * zero.
249      */
250     function average(uint256 a, uint256 b) internal pure returns (uint256) {
251         // (a + b) / 2 can overflow.
252         return (a & b) + (a ^ b) / 2;
253     }
254 
255     /**
256      * @dev Returns the ceiling of the division of two numbers.
257      *
258      * This differs from standard division with `/` in that it rounds up instead
259      * of rounding down.
260      */
261     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
262         // (a + b - 1) / b can overflow on addition, so we distribute.
263         return a == 0 ? 0 : (a - 1) / b + 1;
264     }
265 
266     /**
267      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
268      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
269      * with further edits by Uniswap Labs also under MIT license.
270      */
271     function mulDiv(
272         uint256 x,
273         uint256 y,
274         uint256 denominator
275     ) internal pure returns (uint256 result) {
276         unchecked {
277             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
278             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
279             // variables such that product = prod1 * 2^256 + prod0.
280             uint256 prod0; // Least significant 256 bits of the product
281             uint256 prod1; // Most significant 256 bits of the product
282             assembly {
283                 let mm := mulmod(x, y, not(0))
284                 prod0 := mul(x, y)
285                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
286             }
287 
288             // Handle non-overflow cases, 256 by 256 division.
289             if (prod1 == 0) {
290                 return prod0 / denominator;
291             }
292 
293             // Make sure the result is less than 2^256. Also prevents denominator == 0.
294             require(denominator > prod1);
295 
296             ///////////////////////////////////////////////
297             // 512 by 256 division.
298             ///////////////////////////////////////////////
299 
300             // Make division exact by subtracting the remainder from [prod1 prod0].
301             uint256 remainder;
302             assembly {
303                 // Compute remainder using mulmod.
304                 remainder := mulmod(x, y, denominator)
305 
306                 // Subtract 256 bit number from 512 bit number.
307                 prod1 := sub(prod1, gt(remainder, prod0))
308                 prod0 := sub(prod0, remainder)
309             }
310 
311             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
312             // See https://cs.stackexchange.com/q/138556/92363.
313 
314             // Does not overflow because the denominator cannot be zero at this stage in the function.
315             uint256 twos = denominator & (~denominator + 1);
316             assembly {
317                 // Divide denominator by twos.
318                 denominator := div(denominator, twos)
319 
320                 // Divide [prod1 prod0] by twos.
321                 prod0 := div(prod0, twos)
322 
323                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
324                 twos := add(div(sub(0, twos), twos), 1)
325             }
326 
327             // Shift in bits from prod1 into prod0.
328             prod0 |= prod1 * twos;
329 
330             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
331             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
332             // four bits. That is, denominator * inv = 1 mod 2^4.
333             uint256 inverse = (3 * denominator) ^ 2;
334 
335             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
336             // in modular arithmetic, doubling the correct bits in each step.
337             inverse *= 2 - denominator * inverse; // inverse mod 2^8
338             inverse *= 2 - denominator * inverse; // inverse mod 2^16
339             inverse *= 2 - denominator * inverse; // inverse mod 2^32
340             inverse *= 2 - denominator * inverse; // inverse mod 2^64
341             inverse *= 2 - denominator * inverse; // inverse mod 2^128
342             inverse *= 2 - denominator * inverse; // inverse mod 2^256
343 
344             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
345             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
346             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
347             // is no longer required.
348             result = prod0 * inverse;
349             return result;
350         }
351     }
352 
353     /**
354      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
355      */
356     function mulDiv(
357         uint256 x,
358         uint256 y,
359         uint256 denominator,
360         Rounding rounding
361     ) internal pure returns (uint256) {
362         uint256 result = mulDiv(x, y, denominator);
363         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
364             result += 1;
365         }
366         return result;
367     }
368 
369     /**
370      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
371      *
372      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
373      */
374     function sqrt(uint256 a) internal pure returns (uint256) {
375         if (a == 0) {
376             return 0;
377         }
378 
379         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
380         //
381         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
382         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
383         //
384         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
385         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
386         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
387         //
388         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
389         uint256 result = 1 << (log2(a) >> 1);
390 
391         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
392         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
393         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
394         // into the expected uint128 result.
395         unchecked {
396             result = (result + a / result) >> 1;
397             result = (result + a / result) >> 1;
398             result = (result + a / result) >> 1;
399             result = (result + a / result) >> 1;
400             result = (result + a / result) >> 1;
401             result = (result + a / result) >> 1;
402             result = (result + a / result) >> 1;
403             return min(result, a / result);
404         }
405     }
406 
407     /**
408      * @notice Calculates sqrt(a), following the selected rounding direction.
409      */
410     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
411         unchecked {
412             uint256 result = sqrt(a);
413             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
414         }
415     }
416 
417     /**
418      * @dev Return the log in base 2, rounded down, of a positive value.
419      * Returns 0 if given 0.
420      */
421     function log2(uint256 value) internal pure returns (uint256) {
422         uint256 result = 0;
423         unchecked {
424             if (value >> 128 > 0) {
425                 value >>= 128;
426                 result += 128;
427             }
428             if (value >> 64 > 0) {
429                 value >>= 64;
430                 result += 64;
431             }
432             if (value >> 32 > 0) {
433                 value >>= 32;
434                 result += 32;
435             }
436             if (value >> 16 > 0) {
437                 value >>= 16;
438                 result += 16;
439             }
440             if (value >> 8 > 0) {
441                 value >>= 8;
442                 result += 8;
443             }
444             if (value >> 4 > 0) {
445                 value >>= 4;
446                 result += 4;
447             }
448             if (value >> 2 > 0) {
449                 value >>= 2;
450                 result += 2;
451             }
452             if (value >> 1 > 0) {
453                 result += 1;
454             }
455         }
456         return result;
457     }
458 
459     /**
460      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
461      * Returns 0 if given 0.
462      */
463     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
464         unchecked {
465             uint256 result = log2(value);
466             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
467         }
468     }
469 
470     /**
471      * @dev Return the log in base 10, rounded down, of a positive value.
472      * Returns 0 if given 0.
473      */
474     function log10(uint256 value) internal pure returns (uint256) {
475         uint256 result = 0;
476         unchecked {
477             if (value >= 10**64) {
478                 value /= 10**64;
479                 result += 64;
480             }
481             if (value >= 10**32) {
482                 value /= 10**32;
483                 result += 32;
484             }
485             if (value >= 10**16) {
486                 value /= 10**16;
487                 result += 16;
488             }
489             if (value >= 10**8) {
490                 value /= 10**8;
491                 result += 8;
492             }
493             if (value >= 10**4) {
494                 value /= 10**4;
495                 result += 4;
496             }
497             if (value >= 10**2) {
498                 value /= 10**2;
499                 result += 2;
500             }
501             if (value >= 10**1) {
502                 result += 1;
503             }
504         }
505         return result;
506     }
507 
508     /**
509      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
510      * Returns 0 if given 0.
511      */
512     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
513         unchecked {
514             uint256 result = log10(value);
515             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
516         }
517     }
518 
519     /**
520      * @dev Return the log in base 256, rounded down, of a positive value.
521      * Returns 0 if given 0.
522      *
523      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
524      */
525     function log256(uint256 value) internal pure returns (uint256) {
526         uint256 result = 0;
527         unchecked {
528             if (value >> 128 > 0) {
529                 value >>= 128;
530                 result += 16;
531             }
532             if (value >> 64 > 0) {
533                 value >>= 64;
534                 result += 8;
535             }
536             if (value >> 32 > 0) {
537                 value >>= 32;
538                 result += 4;
539             }
540             if (value >> 16 > 0) {
541                 value >>= 16;
542                 result += 2;
543             }
544             if (value >> 8 > 0) {
545                 result += 1;
546             }
547         }
548         return result;
549     }
550 
551     /**
552      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
553      * Returns 0 if given 0.
554      */
555     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
556         unchecked {
557             uint256 result = log256(value);
558             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
559         }
560     }
561 }
562 
563 // File: @openzeppelin/contracts/utils/Strings.sol
564 
565 
566 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 
571 /**
572  * @dev String operations.
573  */
574 library Strings {
575     bytes16 private constant _SYMBOLS = "0123456789abcdef";
576     uint8 private constant _ADDRESS_LENGTH = 20;
577 
578     /**
579      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
580      */
581     function toString(uint256 value) internal pure returns (string memory) {
582         unchecked {
583             uint256 length = Math.log10(value) + 1;
584             string memory buffer = new string(length);
585             uint256 ptr;
586             /// @solidity memory-safe-assembly
587             assembly {
588                 ptr := add(buffer, add(32, length))
589             }
590             while (true) {
591                 ptr--;
592                 /// @solidity memory-safe-assembly
593                 assembly {
594                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
595                 }
596                 value /= 10;
597                 if (value == 0) break;
598             }
599             return buffer;
600         }
601     }
602 
603     /**
604      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
605      */
606     function toHexString(uint256 value) internal pure returns (string memory) {
607         unchecked {
608             return toHexString(value, Math.log256(value) + 1);
609         }
610     }
611 
612     /**
613      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
614      */
615     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
616         bytes memory buffer = new bytes(2 * length + 2);
617         buffer[0] = "0";
618         buffer[1] = "x";
619         for (uint256 i = 2 * length + 1; i > 1; --i) {
620             buffer[i] = _SYMBOLS[value & 0xf];
621             value >>= 4;
622         }
623         require(value == 0, "Strings: hex length insufficient");
624         return string(buffer);
625     }
626 
627     /**
628      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
629      */
630     function toHexString(address addr) internal pure returns (string memory) {
631         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
632     }
633 }
634 
635 // File: @openzeppelin/contracts/utils/Context.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 /**
643  * @dev Provides information about the current execution context, including the
644  * sender of the transaction and its data. While these are generally available
645  * via msg.sender and msg.data, they should not be accessed in such a direct
646  * manner, since when dealing with meta-transactions the account sending and
647  * paying for execution may not be the actual sender (as far as an application
648  * is concerned).
649  *
650  * This contract is only required for intermediate, library-like contracts.
651  */
652 abstract contract Context {
653     function _msgSender() internal view virtual returns (address) {
654         return msg.sender;
655     }
656 
657     function _msgData() internal view virtual returns (bytes calldata) {
658         return msg.data;
659     }
660 }
661 
662 // File: @openzeppelin/contracts/access/Ownable.sol
663 
664 
665 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 
670 /**
671  * @dev Contract module which provides a basic access control mechanism, where
672  * there is an account (an owner) that can be granted exclusive access to
673  * specific functions.
674  *
675  * By default, the owner account will be the one that deploys the contract. This
676  * can later be changed with {transferOwnership}.
677  *
678  * This module is used through inheritance. It will make available the modifier
679  * `onlyOwner`, which can be applied to your functions to restrict their use to
680  * the owner.
681  */
682 abstract contract Ownable is Context {
683     address private _owner;
684 
685     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
686 
687     /**
688      * @dev Initializes the contract setting the deployer as the initial owner.
689      */
690     constructor() {
691         _transferOwnership(_msgSender());
692     }
693 
694     /**
695      * @dev Throws if called by any account other than the owner.
696      */
697     modifier onlyOwner() {
698         _checkOwner();
699         _;
700     }
701 
702     /**
703      * @dev Returns the address of the current owner.
704      */
705     function owner() public view virtual returns (address) {
706         return _owner;
707     }
708 
709     /**
710      * @dev Throws if the sender is not the owner.
711      */
712     function _checkOwner() internal view virtual {
713         require(owner() == _msgSender(), "Ownable: caller is not the owner");
714     }
715 
716     /**
717      * @dev Leaves the contract without owner. It will not be possible to call
718      * `onlyOwner` functions anymore. Can only be called by the current owner.
719      *
720      * NOTE: Renouncing ownership will leave the contract without an owner,
721      * thereby removing any functionality that is only available to the owner.
722      */
723     function renounceOwnership() public virtual onlyOwner {
724         _transferOwnership(address(0));
725     }
726 
727     /**
728      * @dev Transfers ownership of the contract to a new account (`newOwner`).
729      * Can only be called by the current owner.
730      */
731     function transferOwnership(address newOwner) public virtual onlyOwner {
732         require(newOwner != address(0), "Ownable: new owner is the zero address");
733         _transferOwnership(newOwner);
734     }
735 
736     /**
737      * @dev Transfers ownership of the contract to a new account (`newOwner`).
738      * Internal function without access restriction.
739      */
740     function _transferOwnership(address newOwner) internal virtual {
741         address oldOwner = _owner;
742         _owner = newOwner;
743         emit OwnershipTransferred(oldOwner, newOwner);
744     }
745 }
746 
747 // File: @openzeppelin/contracts/utils/Address.sol
748 
749 
750 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
751 
752 pragma solidity ^0.8.1;
753 
754 /**
755  * @dev Collection of functions related to the address type
756  */
757 library Address {
758     /**
759      * @dev Returns true if `account` is a contract.
760      *
761      * [IMPORTANT]
762      * ====
763      * It is unsafe to assume that an address for which this function returns
764      * false is an externally-owned account (EOA) and not a contract.
765      *
766      * Among others, `isContract` will return false for the following
767      * types of addresses:
768      *
769      *  - an externally-owned account
770      *  - a contract in construction
771      *  - an address where a contract will be created
772      *  - an address where a contract lived, but was destroyed
773      * ====
774      *
775      * [IMPORTANT]
776      * ====
777      * You shouldn't rely on `isContract` to protect against flash loan attacks!
778      *
779      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
780      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
781      * constructor.
782      * ====
783      */
784     function isContract(address account) internal view returns (bool) {
785         // This method relies on extcodesize/address.code.length, which returns 0
786         // for contracts in construction, since the code is only stored at the end
787         // of the constructor execution.
788 
789         return account.code.length > 0;
790     }
791 
792     /**
793      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
794      * `recipient`, forwarding all available gas and reverting on errors.
795      *
796      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
797      * of certain opcodes, possibly making contracts go over the 2300 gas limit
798      * imposed by `transfer`, making them unable to receive funds via
799      * `transfer`. {sendValue} removes this limitation.
800      *
801      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
802      *
803      * IMPORTANT: because control is transferred to `recipient`, care must be
804      * taken to not create reentrancy vulnerabilities. Consider using
805      * {ReentrancyGuard} or the
806      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
807      */
808     function sendValue(address payable recipient, uint256 amount) internal {
809         require(address(this).balance >= amount, "Address: insufficient balance");
810 
811         (bool success, ) = recipient.call{value: amount}("");
812         require(success, "Address: unable to send value, recipient may have reverted");
813     }
814 
815     /**
816      * @dev Performs a Solidity function call using a low level `call`. A
817      * plain `call` is an unsafe replacement for a function call: use this
818      * function instead.
819      *
820      * If `target` reverts with a revert reason, it is bubbled up by this
821      * function (like regular Solidity function calls).
822      *
823      * Returns the raw returned data. To convert to the expected return value,
824      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
825      *
826      * Requirements:
827      *
828      * - `target` must be a contract.
829      * - calling `target` with `data` must not revert.
830      *
831      * _Available since v3.1._
832      */
833     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
834         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
835     }
836 
837     /**
838      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
839      * `errorMessage` as a fallback revert reason when `target` reverts.
840      *
841      * _Available since v3.1._
842      */
843     function functionCall(
844         address target,
845         bytes memory data,
846         string memory errorMessage
847     ) internal returns (bytes memory) {
848         return functionCallWithValue(target, data, 0, errorMessage);
849     }
850 
851     /**
852      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
853      * but also transferring `value` wei to `target`.
854      *
855      * Requirements:
856      *
857      * - the calling contract must have an ETH balance of at least `value`.
858      * - the called Solidity function must be `payable`.
859      *
860      * _Available since v3.1._
861      */
862     function functionCallWithValue(
863         address target,
864         bytes memory data,
865         uint256 value
866     ) internal returns (bytes memory) {
867         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
868     }
869 
870     /**
871      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
872      * with `errorMessage` as a fallback revert reason when `target` reverts.
873      *
874      * _Available since v3.1._
875      */
876     function functionCallWithValue(
877         address target,
878         bytes memory data,
879         uint256 value,
880         string memory errorMessage
881     ) internal returns (bytes memory) {
882         require(address(this).balance >= value, "Address: insufficient balance for call");
883         (bool success, bytes memory returndata) = target.call{value: value}(data);
884         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
885     }
886 
887     /**
888      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
889      * but performing a static call.
890      *
891      * _Available since v3.3._
892      */
893     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
894         return functionStaticCall(target, data, "Address: low-level static call failed");
895     }
896 
897     /**
898      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
899      * but performing a static call.
900      *
901      * _Available since v3.3._
902      */
903     function functionStaticCall(
904         address target,
905         bytes memory data,
906         string memory errorMessage
907     ) internal view returns (bytes memory) {
908         (bool success, bytes memory returndata) = target.staticcall(data);
909         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
910     }
911 
912     /**
913      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
914      * but performing a delegate call.
915      *
916      * _Available since v3.4._
917      */
918     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
919         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
920     }
921 
922     /**
923      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
924      * but performing a delegate call.
925      *
926      * _Available since v3.4._
927      */
928     function functionDelegateCall(
929         address target,
930         bytes memory data,
931         string memory errorMessage
932     ) internal returns (bytes memory) {
933         (bool success, bytes memory returndata) = target.delegatecall(data);
934         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
935     }
936 
937     /**
938      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
939      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
940      *
941      * _Available since v4.8._
942      */
943     function verifyCallResultFromTarget(
944         address target,
945         bool success,
946         bytes memory returndata,
947         string memory errorMessage
948     ) internal view returns (bytes memory) {
949         if (success) {
950             if (returndata.length == 0) {
951                 // only check isContract if the call was successful and the return data is empty
952                 // otherwise we already know that it was a contract
953                 require(isContract(target), "Address: call to non-contract");
954             }
955             return returndata;
956         } else {
957             _revert(returndata, errorMessage);
958         }
959     }
960 
961     /**
962      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
963      * revert reason or using the provided one.
964      *
965      * _Available since v4.3._
966      */
967     function verifyCallResult(
968         bool success,
969         bytes memory returndata,
970         string memory errorMessage
971     ) internal pure returns (bytes memory) {
972         if (success) {
973             return returndata;
974         } else {
975             _revert(returndata, errorMessage);
976         }
977     }
978 
979     function _revert(bytes memory returndata, string memory errorMessage) private pure {
980         // Look for revert reason and bubble it up if present
981         if (returndata.length > 0) {
982             // The easiest way to bubble the revert reason is using memory via assembly
983             /// @solidity memory-safe-assembly
984             assembly {
985                 let returndata_size := mload(returndata)
986                 revert(add(32, returndata), returndata_size)
987             }
988         } else {
989             revert(errorMessage);
990         }
991     }
992 }
993 
994 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
995 
996 
997 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
998 
999 pragma solidity ^0.8.0;
1000 
1001 /**
1002  * @title ERC721 token receiver interface
1003  * @dev Interface for any contract that wants to support safeTransfers
1004  * from ERC721 asset contracts.
1005  */
1006 interface IERC721Receiver {
1007     /**
1008      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1009      * by `operator` from `from`, this function is called.
1010      *
1011      * It must return its Solidity selector to confirm the token transfer.
1012      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1013      *
1014      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1015      */
1016     function onERC721Received(
1017         address operator,
1018         address from,
1019         uint256 tokenId,
1020         bytes calldata data
1021     ) external returns (bytes4);
1022 }
1023 
1024 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1025 
1026 
1027 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1028 
1029 pragma solidity ^0.8.0;
1030 
1031 /**
1032  * @dev Interface of the ERC165 standard, as defined in the
1033  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1034  *
1035  * Implementers can declare support of contract interfaces, which can then be
1036  * queried by others ({ERC165Checker}).
1037  *
1038  * For an implementation, see {ERC165}.
1039  */
1040 interface IERC165 {
1041     /**
1042      * @dev Returns true if this contract implements the interface defined by
1043      * `interfaceId`. See the corresponding
1044      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1045      * to learn more about how these ids are created.
1046      *
1047      * This function call must use less than 30 000 gas.
1048      */
1049     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1050 }
1051 
1052 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1053 
1054 
1055 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1056 
1057 pragma solidity ^0.8.0;
1058 
1059 
1060 /**
1061  * @dev Implementation of the {IERC165} interface.
1062  *
1063  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1064  * for the additional interface id that will be supported. For example:
1065  *
1066  * ```solidity
1067  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1068  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1069  * }
1070  * ```
1071  *
1072  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1073  */
1074 abstract contract ERC165 is IERC165 {
1075     /**
1076      * @dev See {IERC165-supportsInterface}.
1077      */
1078     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1079         return interfaceId == type(IERC165).interfaceId;
1080     }
1081 }
1082 
1083 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1084 
1085 
1086 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1087 
1088 pragma solidity ^0.8.0;
1089 
1090 
1091 /**
1092  * @dev Required interface of an ERC721 compliant contract.
1093  */
1094 interface IERC721 is IERC165 {
1095     /**
1096      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1097      */
1098     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1099 
1100     /**
1101      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1102      */
1103     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1104 
1105     /**
1106      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1107      */
1108     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1109 
1110     /**
1111      * @dev Returns the number of tokens in ``owner``'s account.
1112      */
1113     function balanceOf(address owner) external view returns (uint256 balance);
1114 
1115     /**
1116      * @dev Returns the owner of the `tokenId` token.
1117      *
1118      * Requirements:
1119      *
1120      * - `tokenId` must exist.
1121      */
1122     function ownerOf(uint256 tokenId) external view returns (address owner);
1123 
1124     /**
1125      * @dev Safely transfers `tokenId` token from `from` to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - `from` cannot be the zero address.
1130      * - `to` cannot be the zero address.
1131      * - `tokenId` token must exist and be owned by `from`.
1132      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1133      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function safeTransferFrom(
1138         address from,
1139         address to,
1140         uint256 tokenId,
1141         bytes calldata data
1142     ) external;
1143 
1144     /**
1145      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1146      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1147      *
1148      * Requirements:
1149      *
1150      * - `from` cannot be the zero address.
1151      * - `to` cannot be the zero address.
1152      * - `tokenId` token must exist and be owned by `from`.
1153      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function safeTransferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) external;
1163 
1164     /**
1165      * @dev Transfers `tokenId` token from `from` to `to`.
1166      *
1167      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1168      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1169      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1170      *
1171      * Requirements:
1172      *
1173      * - `from` cannot be the zero address.
1174      * - `to` cannot be the zero address.
1175      * - `tokenId` token must be owned by `from`.
1176      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function transferFrom(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) external;
1185 
1186     /**
1187      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1188      * The approval is cleared when the token is transferred.
1189      *
1190      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1191      *
1192      * Requirements:
1193      *
1194      * - The caller must own the token or be an approved operator.
1195      * - `tokenId` must exist.
1196      *
1197      * Emits an {Approval} event.
1198      */
1199     function approve(address to, uint256 tokenId) external;
1200 
1201     /**
1202      * @dev Approve or remove `operator` as an operator for the caller.
1203      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1204      *
1205      * Requirements:
1206      *
1207      * - The `operator` cannot be the caller.
1208      *
1209      * Emits an {ApprovalForAll} event.
1210      */
1211     function setApprovalForAll(address operator, bool _approved) external;
1212 
1213     /**
1214      * @dev Returns the account approved for `tokenId` token.
1215      *
1216      * Requirements:
1217      *
1218      * - `tokenId` must exist.
1219      */
1220     function getApproved(uint256 tokenId) external view returns (address operator);
1221 
1222     /**
1223      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1224      *
1225      * See {setApprovalForAll}
1226      */
1227     function isApprovedForAll(address owner, address operator) external view returns (bool);
1228 }
1229 
1230 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1231 
1232 
1233 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1234 
1235 pragma solidity ^0.8.0;
1236 
1237 
1238 /**
1239  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1240  * @dev See https://eips.ethereum.org/EIPS/eip-721
1241  */
1242 interface IERC721Enumerable is IERC721 {
1243     /**
1244      * @dev Returns the total amount of tokens stored by the contract.
1245      */
1246     function totalSupply() external view returns (uint256);
1247 
1248     /**
1249      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1250      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1251      */
1252     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1253 
1254     /**
1255      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1256      * Use along with {totalSupply} to enumerate all tokens.
1257      */
1258     function tokenByIndex(uint256 index) external view returns (uint256);
1259 }
1260 
1261 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1262 
1263 
1264 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1265 
1266 pragma solidity ^0.8.0;
1267 
1268 
1269 /**
1270  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1271  * @dev See https://eips.ethereum.org/EIPS/eip-721
1272  */
1273 interface IERC721Metadata is IERC721 {
1274     /**
1275      * @dev Returns the token collection name.
1276      */
1277     function name() external view returns (string memory);
1278 
1279     /**
1280      * @dev Returns the token collection symbol.
1281      */
1282     function symbol() external view returns (string memory);
1283 
1284     /**
1285      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1286      */
1287     function tokenURI(uint256 tokenId) external view returns (string memory);
1288 }
1289 
1290 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1291 
1292 
1293 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1294 
1295 pragma solidity ^0.8.0;
1296 
1297 
1298 
1299 
1300 
1301 
1302 
1303 
1304 /**
1305  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1306  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1307  * {ERC721Enumerable}.
1308  */
1309 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1310     using Address for address;
1311     using Strings for uint256;
1312 
1313     // Token name
1314     string private _name;
1315 
1316     // Token symbol
1317     string private _symbol;
1318 
1319     // Mapping from token ID to owner address
1320     mapping(uint256 => address) public _owners;
1321 
1322     // Mapping owner address to token count
1323     mapping(address => uint256) private _balances;
1324 
1325     // Mapping from token ID to approved address
1326     mapping(uint256 => address) private _tokenApprovals;
1327 
1328     // Mapping from owner to operator approvals
1329     mapping(address => mapping(address => bool)) private _operatorApprovals;
1330 
1331     /**
1332      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1333      */
1334     constructor(string memory name_, string memory symbol_) {
1335         _name = name_;
1336         _symbol = symbol_;
1337     }
1338 
1339     /**
1340      * @dev See {IERC165-supportsInterface}.
1341      */
1342     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1343         return
1344             interfaceId == type(IERC721).interfaceId ||
1345             interfaceId == type(IERC721Metadata).interfaceId ||
1346             super.supportsInterface(interfaceId);
1347     }
1348 
1349     /**
1350      * @dev See {IERC721-balanceOf}.
1351      */
1352     function balanceOf(address owner) public view virtual override returns (uint256) {
1353         require(owner != address(0), "ERC721: address zero is not a valid owner");
1354         return _balances[owner];
1355     }
1356 
1357     /**
1358      * @dev See {IERC721-ownerOf}.
1359      */
1360     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1361         address owner = _ownerOf(tokenId);
1362         require(owner != address(0), "ERC721: invalid token ID");
1363         return owner;
1364     }
1365 
1366     /**
1367      * @dev See {IERC721Metadata-name}.
1368      */
1369     function name() public view virtual override returns (string memory) {
1370         return _name;
1371     }
1372 
1373     /**
1374      * @dev See {IERC721Metadata-symbol}.
1375      */
1376     function symbol() public view virtual override returns (string memory) {
1377         return _symbol;
1378     }
1379 
1380     /**
1381      * @dev See {IERC721Metadata-tokenURI}.
1382      */
1383     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1384         _requireMinted(tokenId);
1385 
1386         string memory baseURI = _baseURI();
1387         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1388     }
1389 
1390     /**
1391      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1392      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1393      * by default, can be overridden in child contracts.
1394      */
1395     function _baseURI() internal view virtual returns (string memory) {
1396         return "";
1397     }
1398 
1399     /**
1400      * @dev See {IERC721-approve}.
1401      */
1402     function approve(address to, uint256 tokenId) public virtual override {
1403         address owner = ERC721.ownerOf(tokenId);
1404         require(to != owner, "ERC721: approval to current owner");
1405 
1406         require(
1407             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1408             "ERC721: approve caller is not token owner or approved for all"
1409         );
1410 
1411         _approve(to, tokenId);
1412     }
1413 
1414     /**
1415      * @dev See {IERC721-getApproved}.
1416      */
1417     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1418         _requireMinted(tokenId);
1419 
1420         return _tokenApprovals[tokenId];
1421     }
1422 
1423     /**
1424      * @dev See {IERC721-setApprovalForAll}.
1425      */
1426     function setApprovalForAll(address operator, bool approved) public virtual override {
1427         _setApprovalForAll(_msgSender(), operator, approved);
1428     }
1429 
1430     /**
1431      * @dev See {IERC721-isApprovedForAll}.
1432      */
1433     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1434         return _operatorApprovals[owner][operator];
1435     }
1436 
1437     /**
1438      * @dev See {IERC721-transferFrom}.
1439      */
1440     function transferFrom(
1441         address from,
1442         address to,
1443         uint256 tokenId
1444     ) public virtual override {
1445         //solhint-disable-next-line max-line-length
1446         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1447 
1448         _transfer(from, to, tokenId);
1449     }
1450 
1451     /**
1452      * @dev See {IERC721-safeTransferFrom}.
1453      */
1454     function safeTransferFrom(
1455         address from,
1456         address to,
1457         uint256 tokenId
1458     ) public virtual override {
1459         safeTransferFrom(from, to, tokenId, "");
1460     }
1461 
1462     /**
1463      * @dev See {IERC721-safeTransferFrom}.
1464      */
1465     function safeTransferFrom(
1466         address from,
1467         address to,
1468         uint256 tokenId,
1469         bytes memory data
1470     ) public virtual override {
1471         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1472         _safeTransfer(from, to, tokenId, data);
1473     }
1474 
1475     /**
1476      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1477      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1478      *
1479      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1480      *
1481      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1482      * implement alternative mechanisms to perform token transfer, such as signature-based.
1483      *
1484      * Requirements:
1485      *
1486      * - `from` cannot be the zero address.
1487      * - `to` cannot be the zero address.
1488      * - `tokenId` token must exist and be owned by `from`.
1489      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1490      *
1491      * Emits a {Transfer} event.
1492      */
1493     function _safeTransfer(
1494         address from,
1495         address to,
1496         uint256 tokenId,
1497         bytes memory data
1498     ) internal virtual {
1499         _transfer(from, to, tokenId);
1500         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1501     }
1502 
1503     /**
1504      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1505      */
1506     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1507         return _owners[tokenId];
1508     }
1509 
1510     /**
1511      * @dev Returns whether `tokenId` exists.
1512      *
1513      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1514      *
1515      * Tokens start existing when they are minted (`_mint`),
1516      * and stop existing when they are burned (`_burn`).
1517      */
1518     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1519         return _ownerOf(tokenId) != address(0);
1520     }
1521 
1522     /**
1523      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1524      *
1525      * Requirements:
1526      *
1527      * - `tokenId` must exist.
1528      */
1529     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1530         address owner = ERC721.ownerOf(tokenId);
1531         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1532     }
1533 
1534     /**
1535      * @dev Safely mints `tokenId` and transfers it to `to`.
1536      *
1537      * Requirements:
1538      *
1539      * - `tokenId` must not exist.
1540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1541      *
1542      * Emits a {Transfer} event.
1543      */
1544     function _safeMint(address to, uint256 tokenId) internal virtual {
1545         _safeMint(to, tokenId, "");
1546     }
1547 
1548     /**
1549      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1550      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1551      */
1552     function _safeMint(
1553         address to,
1554         uint256 tokenId,
1555         bytes memory data
1556     ) internal virtual {
1557         _mint(to, tokenId);
1558         require(
1559             _checkOnERC721Received(address(0), to, tokenId, data),
1560             "ERC721: transfer to non ERC721Receiver implementer"
1561         );
1562     }
1563 
1564     /**
1565      * @dev Mints `tokenId` and transfers it to `to`.
1566      *
1567      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1568      *
1569      * Requirements:
1570      *
1571      * - `tokenId` must not exist.
1572      * - `to` cannot be the zero address.
1573      *
1574      * Emits a {Transfer} event.
1575      */
1576     function _mint(address to, uint256 tokenId) internal virtual {
1577         require(to != address(0), "ERC721: mint to the zero address");
1578         require(!_exists(tokenId), "ERC721: token already minted");
1579 
1580         _beforeTokenTransfer(address(0), to, tokenId, 1);
1581 
1582         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1583         require(!_exists(tokenId), "ERC721: token already minted");
1584 
1585         unchecked {
1586             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1587             // Given that tokens are minted one by one, it is impossible in practice that
1588             // this ever happens. Might change if we allow batch minting.
1589             // The ERC fails to describe this case.
1590             _balances[to] += 1;
1591         }
1592 
1593         _owners[tokenId] = to;
1594 
1595         emit Transfer(address(0), to, tokenId);
1596 
1597         _afterTokenTransfer(address(0), to, tokenId, 1);
1598     }
1599 
1600     /**
1601      * @dev Destroys `tokenId`.
1602      * The approval is cleared when the token is burned.
1603      * This is an internal function that does not check if the sender is authorized to operate on the token.
1604      *
1605      * Requirements:
1606      *
1607      * - `tokenId` must exist.
1608      *
1609      * Emits a {Transfer} event.
1610      */
1611     function _burn(uint256 tokenId) internal virtual {
1612         address owner = ERC721.ownerOf(tokenId);
1613 
1614         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1615 
1616         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1617         owner = ERC721.ownerOf(tokenId);
1618 
1619         // Clear approvals
1620         delete _tokenApprovals[tokenId];
1621 
1622         unchecked {
1623             // Cannot overflow, as that would require more tokens to be burned/transferred
1624             // out than the owner initially received through minting and transferring in.
1625             _balances[owner] -= 1;
1626         }
1627         delete _owners[tokenId];
1628 
1629         emit Transfer(owner, address(0), tokenId);
1630 
1631         _afterTokenTransfer(owner, address(0), tokenId, 1);
1632     }
1633 
1634     /**
1635      * @dev Transfers `tokenId` from `from` to `to`.
1636      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1637      *
1638      * Requirements:
1639      *
1640      * - `to` cannot be the zero address.
1641      * - `tokenId` token must be owned by `from`.
1642      *
1643      * Emits a {Transfer} event.
1644      */
1645     function _transfer(
1646         address from,
1647         address to,
1648         uint256 tokenId
1649     ) internal virtual {
1650         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1651         require(to != address(0), "ERC721: transfer to the zero address");
1652 
1653         _beforeTokenTransfer(from, to, tokenId, 1);
1654 
1655         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1656         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1657 
1658         // Clear approvals from the previous owner
1659         delete _tokenApprovals[tokenId];
1660 
1661         unchecked {
1662             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1663             // `from`'s balance is the number of token held, which is at least one before the current
1664             // transfer.
1665             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1666             // all 2**256 token ids to be minted, which in practice is impossible.
1667             _balances[from] -= 1;
1668             _balances[to] += 1;
1669         }
1670         _owners[tokenId] = to;
1671 
1672         emit Transfer(from, to, tokenId);
1673 
1674         _afterTokenTransfer(from, to, tokenId, 1);
1675     }
1676 
1677     /**
1678      * @dev Approve `to` to operate on `tokenId`
1679      *
1680      * Emits an {Approval} event.
1681      */
1682     function _approve(address to, uint256 tokenId) internal virtual {
1683         _tokenApprovals[tokenId] = to;
1684         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1685     }
1686 
1687     /**
1688      * @dev Approve `operator` to operate on all of `owner` tokens
1689      *
1690      * Emits an {ApprovalForAll} event.
1691      */
1692     function _setApprovalForAll(
1693         address owner,
1694         address operator,
1695         bool approved
1696     ) internal virtual {
1697         require(owner != operator, "ERC721: approve to caller");
1698         _operatorApprovals[owner][operator] = approved;
1699         emit ApprovalForAll(owner, operator, approved);
1700     }
1701 
1702     /**
1703      * @dev Reverts if the `tokenId` has not been minted yet.
1704      */
1705     function _requireMinted(uint256 tokenId) internal view virtual {
1706         require(_exists(tokenId), "ERC721: invalid token ID");
1707     }
1708 
1709     /**
1710      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1711      * The call is not executed if the target address is not a contract.
1712      *
1713      * @param from address representing the previous owner of the given token ID
1714      * @param to target address that will receive the tokens
1715      * @param tokenId uint256 ID of the token to be transferred
1716      * @param data bytes optional data to send along with the call
1717      * @return bool whether the call correctly returned the expected magic value
1718      */
1719     function _checkOnERC721Received(
1720         address from,
1721         address to,
1722         uint256 tokenId,
1723         bytes memory data
1724     ) private returns (bool) {
1725         if (to.isContract()) {
1726             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1727                 return retval == IERC721Receiver.onERC721Received.selector;
1728             } catch (bytes memory reason) {
1729                 if (reason.length == 0) {
1730                     revert("ERC721: transfer to non ERC721Receiver implementer");
1731                 } else {
1732                     /// @solidity memory-safe-assembly
1733                     assembly {
1734                         revert(add(32, reason), mload(reason))
1735                     }
1736                 }
1737             }
1738         } else {
1739             return true;
1740         }
1741     }
1742 
1743     /**
1744      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1745      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1746      *
1747      * Calling conditions:
1748      *
1749      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1750      * - When `from` is zero, the tokens will be minted for `to`.
1751      * - When `to` is zero, ``from``'s tokens will be burned.
1752      * - `from` and `to` are never both zero.
1753      * - `batchSize` is non-zero.
1754      *
1755      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1756      */
1757     function _beforeTokenTransfer(
1758         address from,
1759         address to,
1760         uint256, /* firstTokenId */
1761         uint256 batchSize
1762     ) internal virtual {
1763         if (batchSize > 1) {
1764             if (from != address(0)) {
1765                 _balances[from] -= batchSize;
1766             }
1767             if (to != address(0)) {
1768                 _balances[to] += batchSize;
1769             }
1770         }
1771     }
1772 
1773     /**
1774      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1775      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1776      *
1777      * Calling conditions:
1778      *
1779      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1780      * - When `from` is zero, the tokens were minted for `to`.
1781      * - When `to` is zero, ``from``'s tokens were burned.
1782      * - `from` and `to` are never both zero.
1783      * - `batchSize` is non-zero.
1784      *
1785      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1786      */
1787     function _afterTokenTransfer(
1788         address from,
1789         address to,
1790         uint256 firstTokenId,
1791         uint256 batchSize
1792     ) internal virtual {}
1793 }
1794 
1795 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1796 
1797 
1798 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1799 
1800 pragma solidity ^0.8.0;
1801 
1802 
1803 
1804 /**
1805  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1806  * enumerability of all the token ids in the contract as well as all token ids owned by each
1807  * account.
1808  */
1809 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1810     // Mapping from owner to list of owned token IDs
1811     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1812 
1813     // Mapping from token ID to index of the owner tokens list
1814     mapping(uint256 => uint256) private _ownedTokensIndex;
1815 
1816     // Array with all token ids, used for enumeration
1817     uint256[] private _allTokens;
1818 
1819     // Mapping from token id to position in the allTokens array
1820     mapping(uint256 => uint256) private _allTokensIndex;
1821 
1822     /**
1823      * @dev See {IERC165-supportsInterface}.
1824      */
1825     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1826         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1827     }
1828 
1829     /**
1830      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1831      */
1832     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1833         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1834         return _ownedTokens[owner][index];
1835     }
1836 
1837     /**
1838      * @dev See {IERC721Enumerable-totalSupply}.
1839      */
1840     function totalSupply() public view virtual override returns (uint256) {
1841         return _allTokens.length;
1842     }
1843 
1844     /**
1845      * @dev See {IERC721Enumerable-tokenByIndex}.
1846      */
1847     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1848         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1849         return _allTokens[index];
1850     }
1851 
1852     /**
1853      * @dev See {ERC721-_beforeTokenTransfer}.
1854      */
1855     function _beforeTokenTransfer(
1856         address from,
1857         address to,
1858         uint256 firstTokenId,
1859         uint256 batchSize
1860     ) internal virtual override {
1861         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1862 
1863         if (batchSize > 1) {
1864             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1865             revert("ERC721Enumerable: consecutive transfers not supported");
1866         }
1867 
1868         uint256 tokenId = firstTokenId;
1869 
1870         if (from == address(0)) {
1871             _addTokenToAllTokensEnumeration(tokenId);
1872         } else if (from != to) {
1873             _removeTokenFromOwnerEnumeration(from, tokenId);
1874         }
1875         if (to == address(0)) {
1876             _removeTokenFromAllTokensEnumeration(tokenId);
1877         } else if (to != from) {
1878             _addTokenToOwnerEnumeration(to, tokenId);
1879         }
1880     }
1881 
1882     /**
1883      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1884      * @param to address representing the new owner of the given token ID
1885      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1886      */
1887     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1888         uint256 length = ERC721.balanceOf(to);
1889         _ownedTokens[to][length] = tokenId;
1890         _ownedTokensIndex[tokenId] = length;
1891     }
1892 
1893     /**
1894      * @dev Private function to add a token to this extension's token tracking data structures.
1895      * @param tokenId uint256 ID of the token to be added to the tokens list
1896      */
1897     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1898         _allTokensIndex[tokenId] = _allTokens.length;
1899         _allTokens.push(tokenId);
1900     }
1901 
1902     /**
1903      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1904      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1905      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1906      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1907      * @param from address representing the previous owner of the given token ID
1908      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1909      */
1910     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1911         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1912         // then delete the last slot (swap and pop).
1913 
1914         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1915         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1916 
1917         // When the token to delete is the last token, the swap operation is unnecessary
1918         if (tokenIndex != lastTokenIndex) {
1919             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1920 
1921             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1922             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1923         }
1924 
1925         // This also deletes the contents at the last position of the array
1926         delete _ownedTokensIndex[tokenId];
1927         delete _ownedTokens[from][lastTokenIndex];
1928     }
1929 
1930     /**
1931      * @dev Private function to remove a token from this extension's token tracking data structures.
1932      * This has O(1) time complexity, but alters the order of the _allTokens array.
1933      * @param tokenId uint256 ID of the token to be removed from the tokens list
1934      */
1935     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1936         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1937         // then delete the last slot (swap and pop).
1938 
1939         uint256 lastTokenIndex = _allTokens.length - 1;
1940         uint256 tokenIndex = _allTokensIndex[tokenId];
1941 
1942         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1943         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1944         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1945         uint256 lastTokenId = _allTokens[lastTokenIndex];
1946 
1947         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1948         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1949 
1950         // This also deletes the contents at the last position of the array
1951         delete _allTokensIndex[tokenId];
1952         _allTokens.pop();
1953     }
1954 }
1955 
1956 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1957 
1958 
1959 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1960 
1961 pragma solidity ^0.8.0;
1962 
1963 
1964 
1965 /**
1966  * @title ERC721 Burnable Token
1967  * @dev ERC721 Token that can be burned (destroyed).
1968  */
1969 abstract contract ERC721Burnable is Context, ERC721 {
1970     /**
1971      * @dev Burns `tokenId`. See {ERC721-_burn}.
1972      *
1973      * Requirements:
1974      *
1975      * - The caller must own `tokenId` or be an approved operator.
1976      */
1977     function burn(uint256 tokenId) public virtual {
1978         //solhint-disable-next-line max-line-length
1979         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1980         _burn(tokenId);
1981     }
1982 }
1983 
1984 // File: ticket.sol
1985 
1986 
1987 pragma solidity ^0.8.13;
1988 
1989 contract MintPass is ERC721, ERC721Burnable, ERC721Enumerable, DefaultOperatorFilterer, Ownable, ReentrancyGuard{
1990     using Counters for Counters.Counter;
1991 
1992     Counters.Counter private _tokenIdCounter;
1993 
1994     bool public toggle;
1995     uint256 public startTime;
1996     uint256 public endTime;
1997     uint256 public publicCounter;
1998     uint256 public price;
1999     address public mintFeesAddress;
2000     uint256 internal constant MAX_SUPPLY = 1925;
2001     uint256 public ownerCounter;
2002     string private URI;
2003     mapping(address => bool) public whitelistedAddresses;
2004     mapping(address => uint256) public mintCounter;
2005     mapping(address => uint256[]) internal userNftId;
2006 
2007     event Minted (address to, uint256 tokenId, string uri, uint256 time);
2008 
2009     constructor(string memory _name, string memory _symbol) ERC721(_name,_symbol) {
2010     }
2011 
2012     modifier checkEssentials{
2013         require(startTime != 0, "Ticket: Set the startTime for perSale");
2014         require(endTime != 0, "Ticket: Set the endTime for perSale");
2015         require(price != 0, "Ticket: Set the price of NFT");
2016         _;
2017     }
2018 
2019     /*
2020     @dev All parameters should be set by owner before any functionality is performed
2021     @params _startTime: Owner set the start time for preSale
2022     @params _endTime: Owner set the end time for preSale
2023     @params _price: Owner set price of each NFT
2024     */
2025     function setEssentials(uint256 _startSaleTime, uint256 _endSaleTime, uint256 _price) external onlyOwner{
2026         startTime = _startSaleTime;
2027         endTime = _endSaleTime;
2028         price= _price;
2029     }
2030 
2031     function setToggle(bool toggle_) external onlyOwner{
2032         toggle = toggle_;
2033     }
2034 
2035     function setMintFeesAddress(address _mintFeesAddress) external onlyOwner{
2036         require(_mintFeesAddress != address(0), "Ticket: MintFeesAddress cannot be zero address");
2037         mintFeesAddress = _mintFeesAddress;
2038     } 
2039 
2040 
2041     /*
2042     @dev Whitelisting address is added by the owner
2043     @params _addressToWhitelist: Array of whitelisting addresses
2044     */
2045     function setWhitelistingAddress(address[] memory _addressToWhitelist) external onlyOwner{
2046         require(_addressToWhitelist.length < 500, "Ticket: Push only 500 address at once");
2047         uint256 length = _addressToWhitelist.length;
2048         for(uint256 i = 0; i < length; i++){
2049             whitelistedAddresses[_addressToWhitelist[i]] = true;
2050         }
2051     }
2052 
2053     /*
2054     @dev Owner mint function, owner will be able to mint 50 NFT at maximum
2055     @params _noOfToken: Total number of NFT owner wants to mint at once, maximum limit is 5
2056     */
2057     function mint(uint256 _noOfToken) external onlyOwner checkEssentials {
2058         require(ownerCounter + _noOfToken <= 50, "Ticket: You have reached limit of 50");
2059         require(_noOfToken != 0, "Ticket: Enter valid number");
2060         require(_noOfToken <= 5, "Ticket: You can only mint 5 NFT at once");
2061         for(uint256 i = 0; i < _noOfToken; i++){
2062             uint256 tokenId = _tokenIdCounter.current();
2063             _tokenIdCounter.increment();
2064             ownerCounter++;
2065             userNftId[msg.sender].push(tokenId);
2066             _safeMint(msg.sender, tokenId);
2067             emit Minted(msg.sender, tokenId, tokenURI(tokenId), block.timestamp);
2068         }
2069     }
2070 
2071     /*
2072     @dev This function can be called only by whitelisted user during preSale is active,
2073         user has to transfer the minimum amount of price set by the owner for each NFT. Whitelisted
2074         user can mint only one 1 NFT during preSale.
2075     */
2076     function preSaleMint() external payable checkEssentials nonReentrant{
2077         require(toggle == true, "Ticket: Toggle is off");
2078         require(whitelistedAddresses[msg.sender] == true, "Ticket: You are not whitelisted");
2079         require(mintCounter[msg.sender] < 1, "Ticket: You are only allowed to mint 1 ticket");
2080         require(block.timestamp > startTime - 86400 ,"Ticket: PreSale has not started yet");
2081         require(block.timestamp < startTime , "Ticket: Early sale has expired");
2082         require(block.timestamp < startTime - 14400 , "Ticket: Break duration is active" );
2083         require(msg.value == price, "Ticket: Didn't send minimum amount required");
2084         require(publicCounter <= 1875, "Ticket: Total Supply already accomplished");
2085         uint256 tokenId = _tokenIdCounter.current();
2086         _tokenIdCounter.increment();
2087         mintCounter[msg.sender]++;
2088         publicCounter++;
2089         userNftId[msg.sender].push(tokenId);
2090         _safeMint(msg.sender, tokenId);
2091         payable(mintFeesAddress).transfer(msg.value);
2092         emit Minted(msg.sender, tokenId, tokenURI(tokenId), block.timestamp);
2093     }
2094 
2095 
2096     /*
2097     @dev This function can be called by anyone once the preSale has ended, user has to transfer
2098         the minimum amount of price set by the owner for each NFT
2099     @params _noOfToken: Total number of NFT user wants to mint at once, maximum limit is 4
2100         and for whitelisted user maximum limit is 3
2101     */
2102     function mintPayingETH(uint256 noOfToken_) external payable checkEssentials nonReentrant{
2103         uint256 ethAmount = noOfToken_ * price;
2104         require(toggle == true, "Ticket: Toggle is off");
2105         require(block.timestamp > startTime, "Ticket: Sale has not started yet");
2106         require(block.timestamp < endTime , "Ticket: Minting is no longer active");
2107         require(noOfToken_ <= 4, "Ticket: You are only allowed to mint 4 ticket");
2108         require(msg.value == ethAmount, "Ticket: Didn't send total amount required");
2109         require(publicCounter + noOfToken_ <= 1875, "Ticket: Total Supply already accomplished");
2110         for(uint256 i = 0; i < noOfToken_; i++){
2111             require(mintCounter[msg.sender] < 4, "Ticket: You have reached maximum amount of mints");
2112             uint256 tokenId = _tokenIdCounter.current();
2113             _tokenIdCounter.increment();
2114             mintCounter[msg.sender]++;
2115             publicCounter++;
2116             userNftId[msg.sender].push(tokenId);
2117             _safeMint(msg.sender, tokenId);
2118             emit Minted(msg.sender, tokenId, tokenURI(tokenId), block.timestamp);
2119         }
2120         payable(mintFeesAddress).transfer(msg.value);
2121     }
2122 
2123     function transferFrom(address from,address to,uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from){
2124         require(_isApprovedOrOwner(_msgSender(), tokenId),"Ticket: transfer caller is not owner nor approved");
2125         uint256 temp;
2126         for (uint256 i; i < userNftId[from].length; i++) {
2127             if (userNftId[from][i] == tokenId) {
2128                 userNftId[from][i] = userNftId[from][userNftId[from].length - 1];
2129                 temp = userNftId[from].length - 1;
2130                 userNftId[from].pop();
2131                 userNftId[to].push(tokenId);
2132                 break;
2133             }
2134         }
2135         _transfer(from, to, tokenId);
2136     }
2137 
2138     function safeTransferFrom(address from,address to,uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from){
2139         uint256 temp;
2140         for (uint256 i; i < userNftId[from].length; i++) {
2141             if (userNftId[from][i] == tokenId) {
2142                 userNftId[from][i] = userNftId[from][userNftId[from].length - 1];
2143                 temp = userNftId[from].length - 1;
2144                 userNftId[from].pop();
2145                 userNftId[to].push(tokenId);
2146                 break;
2147             }
2148         }
2149         safeTransferFrom(from, to, tokenId, "");
2150     }
2151 
2152     function safeTransferFrom(address from,address to,uint256 tokenId,bytes memory _data) public  override(ERC721, IERC721) onlyAllowedOperator(from) {
2153         require(_isApprovedOrOwner(_msgSender(), tokenId),"Ticket: transfer caller is not owner nor approved");
2154         uint256 temp;
2155         for (uint256 i; i < userNftId[from].length; i++) {
2156             if (userNftId[from][i] == tokenId) {
2157                 userNftId[from][i] = userNftId[from][userNftId[from].length - 1];
2158                 temp = userNftId[from].length - 1;
2159                 userNftId[from].pop();
2160                 userNftId[to].push(tokenId);
2161                 break;
2162             }
2163         }
2164         _safeTransfer(from, to, tokenId, _data);
2165     }
2166 
2167     function nftOfUser(address user)public view returns(uint256[] memory){
2168         return userNftId[user];
2169     }
2170 
2171     function updateURI(string memory updateURI_) external onlyOwner{
2172         URI = updateURI_;
2173     }
2174 
2175     function burn(uint256 tokenId) public virtual override{
2176         //solhint-disable-next-line max-line-length
2177         _burn(tokenId);
2178     }
2179 
2180     function _burn(uint256 _tokenId) internal override(ERC721) {
2181         require(_isApprovedOrOwner(_msgSender(), _tokenId), "Ticket: caller is not token owner nor approved");
2182          for (uint256 i; i < userNftId[ownerOf(_tokenId)].length; i++) {
2183             if (userNftId[ownerOf(_tokenId)][i] == _tokenId) {
2184                 userNftId[ownerOf(_tokenId)][i] = userNftId[ownerOf(_tokenId)][userNftId[ownerOf(_tokenId)].length - 1];
2185                 userNftId[ownerOf(_tokenId)].pop();
2186                 break;
2187             }
2188         }
2189         super._burn(_tokenId);
2190     }
2191 
2192     function tokenURI(uint256 tokenId) public view virtual override(ERC721) returns (string memory) {
2193         _requireMinted(tokenId);
2194 
2195         string memory baseURI = _baseURI();
2196         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI)) : "";
2197     }
2198 
2199 
2200     function _baseURI() internal view override returns (string memory) {
2201         return URI;
2202     }
2203 
2204    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
2205         internal
2206         override(ERC721, ERC721Enumerable)
2207     {
2208         super._beforeTokenTransfer(from, to, tokenId, batchSize);
2209     }
2210 
2211     function supportsInterface(bytes4 interfaceId)
2212         public
2213         view
2214         override(ERC721 ,ERC721Enumerable)
2215         returns (bool)
2216     {
2217         return super.supportsInterface(interfaceId);
2218     }
2219 
2220 }