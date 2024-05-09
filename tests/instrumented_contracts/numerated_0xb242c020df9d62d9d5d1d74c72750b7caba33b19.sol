1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         _nonReentrantBefore();
55         _;
56         _nonReentrantAfter();
57     }
58 
59     function _nonReentrantBefore() private {
60         // On the first call to nonReentrant, _status will be _NOT_ENTERED
61         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
62 
63         // Any calls to nonReentrant after this point will fail
64         _status = _ENTERED;
65     }
66 
67     function _nonReentrantAfter() private {
68         // By storing the original value once again, a refund is triggered (see
69         // https://eips.ethereum.org/EIPS/eip-2200)
70         _status = _NOT_ENTERED;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/math/Math.sol
75 
76 
77 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Standard math utilities missing in the Solidity language.
83  */
84 library Math {
85     enum Rounding {
86         Down, // Toward negative infinity
87         Up, // Toward infinity
88         Zero // Toward zero
89     }
90 
91     /**
92      * @dev Returns the largest of two numbers.
93      */
94     function max(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a > b ? a : b;
96     }
97 
98     /**
99      * @dev Returns the smallest of two numbers.
100      */
101     function min(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a < b ? a : b;
103     }
104 
105     /**
106      * @dev Returns the average of two numbers. The result is rounded towards
107      * zero.
108      */
109     function average(uint256 a, uint256 b) internal pure returns (uint256) {
110         // (a + b) / 2 can overflow.
111         return (a & b) + (a ^ b) / 2;
112     }
113 
114     /**
115      * @dev Returns the ceiling of the division of two numbers.
116      *
117      * This differs from standard division with `/` in that it rounds up instead
118      * of rounding down.
119      */
120     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
121         // (a + b - 1) / b can overflow on addition, so we distribute.
122         return a == 0 ? 0 : (a - 1) / b + 1;
123     }
124 
125     /**
126      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
127      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
128      * with further edits by Uniswap Labs also under MIT license.
129      */
130     function mulDiv(
131         uint256 x,
132         uint256 y,
133         uint256 denominator
134     ) internal pure returns (uint256 result) {
135         unchecked {
136             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
137             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
138             // variables such that product = prod1 * 2^256 + prod0.
139             uint256 prod0; // Least significant 256 bits of the product
140             uint256 prod1; // Most significant 256 bits of the product
141             assembly {
142                 let mm := mulmod(x, y, not(0))
143                 prod0 := mul(x, y)
144                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
145             }
146 
147             // Handle non-overflow cases, 256 by 256 division.
148             if (prod1 == 0) {
149                 return prod0 / denominator;
150             }
151 
152             // Make sure the result is less than 2^256. Also prevents denominator == 0.
153             require(denominator > prod1);
154 
155             ///////////////////////////////////////////////
156             // 512 by 256 division.
157             ///////////////////////////////////////////////
158 
159             // Make division exact by subtracting the remainder from [prod1 prod0].
160             uint256 remainder;
161             assembly {
162                 // Compute remainder using mulmod.
163                 remainder := mulmod(x, y, denominator)
164 
165                 // Subtract 256 bit number from 512 bit number.
166                 prod1 := sub(prod1, gt(remainder, prod0))
167                 prod0 := sub(prod0, remainder)
168             }
169 
170             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
171             // See https://cs.stackexchange.com/q/138556/92363.
172 
173             // Does not overflow because the denominator cannot be zero at this stage in the function.
174             uint256 twos = denominator & (~denominator + 1);
175             assembly {
176                 // Divide denominator by twos.
177                 denominator := div(denominator, twos)
178 
179                 // Divide [prod1 prod0] by twos.
180                 prod0 := div(prod0, twos)
181 
182                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
183                 twos := add(div(sub(0, twos), twos), 1)
184             }
185 
186             // Shift in bits from prod1 into prod0.
187             prod0 |= prod1 * twos;
188 
189             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
190             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
191             // four bits. That is, denominator * inv = 1 mod 2^4.
192             uint256 inverse = (3 * denominator) ^ 2;
193 
194             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
195             // in modular arithmetic, doubling the correct bits in each step.
196             inverse *= 2 - denominator * inverse; // inverse mod 2^8
197             inverse *= 2 - denominator * inverse; // inverse mod 2^16
198             inverse *= 2 - denominator * inverse; // inverse mod 2^32
199             inverse *= 2 - denominator * inverse; // inverse mod 2^64
200             inverse *= 2 - denominator * inverse; // inverse mod 2^128
201             inverse *= 2 - denominator * inverse; // inverse mod 2^256
202 
203             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
204             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
205             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
206             // is no longer required.
207             result = prod0 * inverse;
208             return result;
209         }
210     }
211 
212     /**
213      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
214      */
215     function mulDiv(
216         uint256 x,
217         uint256 y,
218         uint256 denominator,
219         Rounding rounding
220     ) internal pure returns (uint256) {
221         uint256 result = mulDiv(x, y, denominator);
222         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
223             result += 1;
224         }
225         return result;
226     }
227 
228     /**
229      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
230      *
231      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
232      */
233     function sqrt(uint256 a) internal pure returns (uint256) {
234         if (a == 0) {
235             return 0;
236         }
237 
238         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
239         //
240         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
241         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
242         //
243         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
244         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
245         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
246         //
247         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
248         uint256 result = 1 << (log2(a) >> 1);
249 
250         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
251         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
252         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
253         // into the expected uint128 result.
254         unchecked {
255             result = (result + a / result) >> 1;
256             result = (result + a / result) >> 1;
257             result = (result + a / result) >> 1;
258             result = (result + a / result) >> 1;
259             result = (result + a / result) >> 1;
260             result = (result + a / result) >> 1;
261             result = (result + a / result) >> 1;
262             return min(result, a / result);
263         }
264     }
265 
266     /**
267      * @notice Calculates sqrt(a), following the selected rounding direction.
268      */
269     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
270         unchecked {
271             uint256 result = sqrt(a);
272             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
273         }
274     }
275 
276     /**
277      * @dev Return the log in base 2, rounded down, of a positive value.
278      * Returns 0 if given 0.
279      */
280     function log2(uint256 value) internal pure returns (uint256) {
281         uint256 result = 0;
282         unchecked {
283             if (value >> 128 > 0) {
284                 value >>= 128;
285                 result += 128;
286             }
287             if (value >> 64 > 0) {
288                 value >>= 64;
289                 result += 64;
290             }
291             if (value >> 32 > 0) {
292                 value >>= 32;
293                 result += 32;
294             }
295             if (value >> 16 > 0) {
296                 value >>= 16;
297                 result += 16;
298             }
299             if (value >> 8 > 0) {
300                 value >>= 8;
301                 result += 8;
302             }
303             if (value >> 4 > 0) {
304                 value >>= 4;
305                 result += 4;
306             }
307             if (value >> 2 > 0) {
308                 value >>= 2;
309                 result += 2;
310             }
311             if (value >> 1 > 0) {
312                 result += 1;
313             }
314         }
315         return result;
316     }
317 
318     /**
319      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
320      * Returns 0 if given 0.
321      */
322     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
323         unchecked {
324             uint256 result = log2(value);
325             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
326         }
327     }
328 
329     /**
330      * @dev Return the log in base 10, rounded down, of a positive value.
331      * Returns 0 if given 0.
332      */
333     function log10(uint256 value) internal pure returns (uint256) {
334         uint256 result = 0;
335         unchecked {
336             if (value >= 10**64) {
337                 value /= 10**64;
338                 result += 64;
339             }
340             if (value >= 10**32) {
341                 value /= 10**32;
342                 result += 32;
343             }
344             if (value >= 10**16) {
345                 value /= 10**16;
346                 result += 16;
347             }
348             if (value >= 10**8) {
349                 value /= 10**8;
350                 result += 8;
351             }
352             if (value >= 10**4) {
353                 value /= 10**4;
354                 result += 4;
355             }
356             if (value >= 10**2) {
357                 value /= 10**2;
358                 result += 2;
359             }
360             if (value >= 10**1) {
361                 result += 1;
362             }
363         }
364         return result;
365     }
366 
367     /**
368      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
369      * Returns 0 if given 0.
370      */
371     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
372         unchecked {
373             uint256 result = log10(value);
374             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
375         }
376     }
377 
378     /**
379      * @dev Return the log in base 256, rounded down, of a positive value.
380      * Returns 0 if given 0.
381      *
382      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
383      */
384     function log256(uint256 value) internal pure returns (uint256) {
385         uint256 result = 0;
386         unchecked {
387             if (value >> 128 > 0) {
388                 value >>= 128;
389                 result += 16;
390             }
391             if (value >> 64 > 0) {
392                 value >>= 64;
393                 result += 8;
394             }
395             if (value >> 32 > 0) {
396                 value >>= 32;
397                 result += 4;
398             }
399             if (value >> 16 > 0) {
400                 value >>= 16;
401                 result += 2;
402             }
403             if (value >> 8 > 0) {
404                 result += 1;
405             }
406         }
407         return result;
408     }
409 
410     /**
411      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
412      * Returns 0 if given 0.
413      */
414     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
415         unchecked {
416             uint256 result = log256(value);
417             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
418         }
419     }
420 }
421 
422 // File: @openzeppelin/contracts/utils/Strings.sol
423 
424 
425 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 
430 /**
431  * @dev String operations.
432  */
433 library Strings {
434     bytes16 private constant _SYMBOLS = "0123456789abcdef";
435     uint8 private constant _ADDRESS_LENGTH = 20;
436 
437     /**
438      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
439      */
440     function toString(uint256 value) internal pure returns (string memory) {
441         unchecked {
442             uint256 length = Math.log10(value) + 1;
443             string memory buffer = new string(length);
444             uint256 ptr;
445             /// @solidity memory-safe-assembly
446             assembly {
447                 ptr := add(buffer, add(32, length))
448             }
449             while (true) {
450                 ptr--;
451                 /// @solidity memory-safe-assembly
452                 assembly {
453                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
454                 }
455                 value /= 10;
456                 if (value == 0) break;
457             }
458             return buffer;
459         }
460     }
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
464      */
465     function toHexString(uint256 value) internal pure returns (string memory) {
466         unchecked {
467             return toHexString(value, Math.log256(value) + 1);
468         }
469     }
470 
471     /**
472      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
473      */
474     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
475         bytes memory buffer = new bytes(2 * length + 2);
476         buffer[0] = "0";
477         buffer[1] = "x";
478         for (uint256 i = 2 * length + 1; i > 1; --i) {
479             buffer[i] = _SYMBOLS[value & 0xf];
480             value >>= 4;
481         }
482         require(value == 0, "Strings: hex length insufficient");
483         return string(buffer);
484     }
485 
486     /**
487      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
488      */
489     function toHexString(address addr) internal pure returns (string memory) {
490         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
491     }
492 }
493 
494 // File: @openzeppelin/contracts/utils/Context.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Provides information about the current execution context, including the
503  * sender of the transaction and its data. While these are generally available
504  * via msg.sender and msg.data, they should not be accessed in such a direct
505  * manner, since when dealing with meta-transactions the account sending and
506  * paying for execution may not be the actual sender (as far as an application
507  * is concerned).
508  *
509  * This contract is only required for intermediate, library-like contracts.
510  */
511 abstract contract Context {
512     function _msgSender() internal view virtual returns (address) {
513         return msg.sender;
514     }
515 
516     function _msgData() internal view virtual returns (bytes calldata) {
517         return msg.data;
518     }
519 }
520 
521 // File: @openzeppelin/contracts/access/Ownable.sol
522 
523 
524 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @dev Contract module which provides a basic access control mechanism, where
531  * there is an account (an owner) that can be granted exclusive access to
532  * specific functions.
533  *
534  * By default, the owner account will be the one that deploys the contract. This
535  * can later be changed with {transferOwnership}.
536  *
537  * This module is used through inheritance. It will make available the modifier
538  * `onlyOwner`, which can be applied to your functions to restrict their use to
539  * the owner.
540  */
541 abstract contract Ownable is Context {
542     address private _owner;
543 
544     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
545 
546     /**
547      * @dev Initializes the contract setting the deployer as the initial owner.
548      */
549     constructor() {
550         _transferOwnership(_msgSender());
551     }
552 
553     /**
554      * @dev Throws if called by any account other than the owner.
555      */
556     modifier onlyOwner() {
557         _checkOwner();
558         _;
559     }
560 
561     /**
562      * @dev Returns the address of the current owner.
563      */
564     function owner() public view virtual returns (address) {
565         return _owner;
566     }
567 
568     /**
569      * @dev Throws if the sender is not the owner.
570      */
571     function _checkOwner() internal view virtual {
572         require(owner() == _msgSender(), "Ownable: caller is not the owner");
573     }
574 
575     /**
576      * @dev Leaves the contract without owner. It will not be possible to call
577      * `onlyOwner` functions anymore. Can only be called by the current owner.
578      *
579      * NOTE: Renouncing ownership will leave the contract without an owner,
580      * thereby removing any functionality that is only available to the owner.
581      */
582     function renounceOwnership() public virtual onlyOwner {
583         _transferOwnership(address(0));
584     }
585 
586     /**
587      * @dev Transfers ownership of the contract to a new account (`newOwner`).
588      * Can only be called by the current owner.
589      */
590     function transferOwnership(address newOwner) public virtual onlyOwner {
591         require(newOwner != address(0), "Ownable: new owner is the zero address");
592         _transferOwnership(newOwner);
593     }
594 
595     /**
596      * @dev Transfers ownership of the contract to a new account (`newOwner`).
597      * Internal function without access restriction.
598      */
599     function _transferOwnership(address newOwner) internal virtual {
600         address oldOwner = _owner;
601         _owner = newOwner;
602         emit OwnershipTransferred(oldOwner, newOwner);
603     }
604 }
605 
606 // File: operator-filter-registry/src/lib/Constants.sol
607 
608 
609 pragma solidity ^0.8.13;
610 
611 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
612 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
613 
614 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
615 
616 
617 pragma solidity ^0.8.13;
618 
619 interface IOperatorFilterRegistry {
620     /**
621      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
622      *         true if supplied registrant address is not registered.
623      */
624     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
625 
626     /**
627      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
628      */
629     function register(address registrant) external;
630 
631     /**
632      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
633      */
634     function registerAndSubscribe(address registrant, address subscription) external;
635 
636     /**
637      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
638      *         address without subscribing.
639      */
640     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
641 
642     /**
643      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
644      *         Note that this does not remove any filtered addresses or codeHashes.
645      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
646      */
647     function unregister(address addr) external;
648 
649     /**
650      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
651      */
652     function updateOperator(address registrant, address operator, bool filtered) external;
653 
654     /**
655      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
656      */
657     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
658 
659     /**
660      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
661      */
662     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
663 
664     /**
665      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
666      */
667     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
668 
669     /**
670      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
671      *         subscription if present.
672      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
673      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
674      *         used.
675      */
676     function subscribe(address registrant, address registrantToSubscribe) external;
677 
678     /**
679      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
680      */
681     function unsubscribe(address registrant, bool copyExistingEntries) external;
682 
683     /**
684      * @notice Get the subscription address of a given registrant, if any.
685      */
686     function subscriptionOf(address addr) external returns (address registrant);
687 
688     /**
689      * @notice Get the set of addresses subscribed to a given registrant.
690      *         Note that order is not guaranteed as updates are made.
691      */
692     function subscribers(address registrant) external returns (address[] memory);
693 
694     /**
695      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
696      *         Note that order is not guaranteed as updates are made.
697      */
698     function subscriberAt(address registrant, uint256 index) external returns (address);
699 
700     /**
701      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
702      */
703     function copyEntriesOf(address registrant, address registrantToCopy) external;
704 
705     /**
706      * @notice Returns true if operator is filtered by a given address or its subscription.
707      */
708     function isOperatorFiltered(address registrant, address operator) external returns (bool);
709 
710     /**
711      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
712      */
713     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
714 
715     /**
716      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
717      */
718     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
719 
720     /**
721      * @notice Returns a list of filtered operators for a given address or its subscription.
722      */
723     function filteredOperators(address addr) external returns (address[] memory);
724 
725     /**
726      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
727      *         Note that order is not guaranteed as updates are made.
728      */
729     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
730 
731     /**
732      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
733      *         its subscription.
734      *         Note that order is not guaranteed as updates are made.
735      */
736     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
737 
738     /**
739      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
740      *         its subscription.
741      *         Note that order is not guaranteed as updates are made.
742      */
743     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
744 
745     /**
746      * @notice Returns true if an address has registered
747      */
748     function isRegistered(address addr) external returns (bool);
749 
750     /**
751      * @dev Convenience method to compute the code hash of an arbitrary contract
752      */
753     function codeHashOf(address addr) external returns (bytes32);
754 }
755 
756 // File: operator-filter-registry/src/OperatorFilterer.sol
757 
758 
759 pragma solidity ^0.8.13;
760 
761 
762 /**
763  * @title  OperatorFilterer
764  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
765  *         registrant's entries in the OperatorFilterRegistry.
766  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
767  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
768  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
769  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
770  *         administration methods on the contract itself to interact with the registry otherwise the subscription
771  *         will be locked to the options set during construction.
772  */
773 
774 abstract contract OperatorFilterer {
775     /// @dev Emitted when an operator is not allowed.
776     error OperatorNotAllowed(address operator);
777 
778     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
779         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
780 
781     /// @dev The constructor that is called when the contract is being deployed.
782     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
783         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
784         // will not revert, but the contract will need to be registered with the registry once it is deployed in
785         // order for the modifier to filter addresses.
786         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
787             if (subscribe) {
788                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
789             } else {
790                 if (subscriptionOrRegistrantToCopy != address(0)) {
791                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
792                 } else {
793                     OPERATOR_FILTER_REGISTRY.register(address(this));
794                 }
795             }
796         }
797     }
798 
799     /**
800      * @dev A helper function to check if an operator is allowed.
801      */
802     modifier onlyAllowedOperator(address from) virtual {
803         // Allow spending tokens from addresses with balance
804         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
805         // from an EOA.
806         if (from != msg.sender) {
807             _checkFilterOperator(msg.sender);
808         }
809         _;
810     }
811 
812     /**
813      * @dev A helper function to check if an operator approval is allowed.
814      */
815     modifier onlyAllowedOperatorApproval(address operator) virtual {
816         _checkFilterOperator(operator);
817         _;
818     }
819 
820     /**
821      * @dev A helper function to check if an operator is allowed.
822      */
823     function _checkFilterOperator(address operator) internal view virtual {
824         // Check registry code length to facilitate testing in environments without a deployed registry.
825         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
826             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
827             // may specify their own OperatorFilterRegistry implementations, which may behave differently
828             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
829                 revert OperatorNotAllowed(operator);
830             }
831         }
832     }
833 }
834 
835 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
836 
837 
838 pragma solidity ^0.8.13;
839 
840 
841 /**
842  * @title  DefaultOperatorFilterer
843  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
844  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
845  *         administration methods on the contract itself to interact with the registry otherwise the subscription
846  *         will be locked to the options set during construction.
847  */
848 
849 abstract contract DefaultOperatorFilterer is OperatorFilterer {
850     /// @dev The constructor that is called when the contract is being deployed.
851     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
852 }
853 
854 // File: erc721a/contracts/IERC721A.sol
855 
856 
857 // ERC721A Contracts v4.2.3
858 // Creator: Chiru Labs
859 
860 pragma solidity ^0.8.4;
861 
862 /**
863  * @dev Interface of ERC721A.
864  */
865 interface IERC721A {
866     /**
867      * The caller must own the token or be an approved operator.
868      */
869     error ApprovalCallerNotOwnerNorApproved();
870 
871     /**
872      * The token does not exist.
873      */
874     error ApprovalQueryForNonexistentToken();
875 
876     /**
877      * Cannot query the balance for the zero address.
878      */
879     error BalanceQueryForZeroAddress();
880 
881     /**
882      * Cannot mint to the zero address.
883      */
884     error MintToZeroAddress();
885 
886     /**
887      * The quantity of tokens minted must be more than zero.
888      */
889     error MintZeroQuantity();
890 
891     /**
892      * The token does not exist.
893      */
894     error OwnerQueryForNonexistentToken();
895 
896     /**
897      * The caller must own the token or be an approved operator.
898      */
899     error TransferCallerNotOwnerNorApproved();
900 
901     /**
902      * The token must be owned by `from`.
903      */
904     error TransferFromIncorrectOwner();
905 
906     /**
907      * Cannot safely transfer to a contract that does not implement the
908      * ERC721Receiver interface.
909      */
910     error TransferToNonERC721ReceiverImplementer();
911 
912     /**
913      * Cannot transfer to the zero address.
914      */
915     error TransferToZeroAddress();
916 
917     /**
918      * The token does not exist.
919      */
920     error URIQueryForNonexistentToken();
921 
922     /**
923      * The `quantity` minted with ERC2309 exceeds the safety limit.
924      */
925     error MintERC2309QuantityExceedsLimit();
926 
927     /**
928      * The `extraData` cannot be set on an unintialized ownership slot.
929      */
930     error OwnershipNotInitializedForExtraData();
931 
932     // =============================================================
933     //                            STRUCTS
934     // =============================================================
935 
936     struct TokenOwnership {
937         // The address of the owner.
938         address addr;
939         // Stores the start time of ownership with minimal overhead for tokenomics.
940         uint64 startTimestamp;
941         // Whether the token has been burned.
942         bool burned;
943         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
944         uint24 extraData;
945     }
946 
947     // =============================================================
948     //                         TOKEN COUNTERS
949     // =============================================================
950 
951     /**
952      * @dev Returns the total number of tokens in existence.
953      * Burned tokens will reduce the count.
954      * To get the total number of tokens minted, please see {_totalMinted}.
955      */
956     function totalSupply() external view returns (uint256);
957 
958     // =============================================================
959     //                            IERC165
960     // =============================================================
961 
962     /**
963      * @dev Returns true if this contract implements the interface defined by
964      * `interfaceId`. See the corresponding
965      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
966      * to learn more about how these ids are created.
967      *
968      * This function call must use less than 30000 gas.
969      */
970     function supportsInterface(bytes4 interfaceId) external view returns (bool);
971 
972     // =============================================================
973     //                            IERC721
974     // =============================================================
975 
976     /**
977      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
978      */
979     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
980 
981     /**
982      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
983      */
984     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
985 
986     /**
987      * @dev Emitted when `owner` enables or disables
988      * (`approved`) `operator` to manage all of its assets.
989      */
990     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
991 
992     /**
993      * @dev Returns the number of tokens in `owner`'s account.
994      */
995     function balanceOf(address owner) external view returns (uint256 balance);
996 
997     /**
998      * @dev Returns the owner of the `tokenId` token.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      */
1004     function ownerOf(uint256 tokenId) external view returns (address owner);
1005 
1006     /**
1007      * @dev Safely transfers `tokenId` token from `from` to `to`,
1008      * checking first that contract recipients are aware of the ERC721 protocol
1009      * to prevent tokens from being forever locked.
1010      *
1011      * Requirements:
1012      *
1013      * - `from` cannot be the zero address.
1014      * - `to` cannot be the zero address.
1015      * - `tokenId` token must exist and be owned by `from`.
1016      * - If the caller is not `from`, it must be have been allowed to move
1017      * this token by either {approve} or {setApprovalForAll}.
1018      * - If `to` refers to a smart contract, it must implement
1019      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes calldata data
1028     ) external payable;
1029 
1030     /**
1031      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1032      */
1033     function safeTransferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) external payable;
1038 
1039     /**
1040      * @dev Transfers `tokenId` from `from` to `to`.
1041      *
1042      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1043      * whenever possible.
1044      *
1045      * Requirements:
1046      *
1047      * - `from` cannot be the zero address.
1048      * - `to` cannot be the zero address.
1049      * - `tokenId` token must be owned by `from`.
1050      * - If the caller is not `from`, it must be approved to move this token
1051      * by either {approve} or {setApprovalForAll}.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function transferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) external payable;
1060 
1061     /**
1062      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1063      * The approval is cleared when the token is transferred.
1064      *
1065      * Only a single account can be approved at a time, so approving the
1066      * zero address clears previous approvals.
1067      *
1068      * Requirements:
1069      *
1070      * - The caller must own the token or be an approved operator.
1071      * - `tokenId` must exist.
1072      *
1073      * Emits an {Approval} event.
1074      */
1075     function approve(address to, uint256 tokenId) external payable;
1076 
1077     /**
1078      * @dev Approve or remove `operator` as an operator for the caller.
1079      * Operators can call {transferFrom} or {safeTransferFrom}
1080      * for any token owned by the caller.
1081      *
1082      * Requirements:
1083      *
1084      * - The `operator` cannot be the caller.
1085      *
1086      * Emits an {ApprovalForAll} event.
1087      */
1088     function setApprovalForAll(address operator, bool _approved) external;
1089 
1090     /**
1091      * @dev Returns the account approved for `tokenId` token.
1092      *
1093      * Requirements:
1094      *
1095      * - `tokenId` must exist.
1096      */
1097     function getApproved(uint256 tokenId) external view returns (address operator);
1098 
1099     /**
1100      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1101      *
1102      * See {setApprovalForAll}.
1103      */
1104     function isApprovedForAll(address owner, address operator) external view returns (bool);
1105 
1106     // =============================================================
1107     //                        IERC721Metadata
1108     // =============================================================
1109 
1110     /**
1111      * @dev Returns the token collection name.
1112      */
1113     function name() external view returns (string memory);
1114 
1115     /**
1116      * @dev Returns the token collection symbol.
1117      */
1118     function symbol() external view returns (string memory);
1119 
1120     /**
1121      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1122      */
1123     function tokenURI(uint256 tokenId) external view returns (string memory);
1124 
1125     // =============================================================
1126     //                           IERC2309
1127     // =============================================================
1128 
1129     /**
1130      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1131      * (inclusive) is transferred from `from` to `to`, as defined in the
1132      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1133      *
1134      * See {_mintERC2309} for more details.
1135      */
1136     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1137 }
1138 
1139 // File: erc721a/contracts/ERC721A.sol
1140 
1141 
1142 // ERC721A Contracts v4.2.3
1143 // Creator: Chiru Labs
1144 
1145 pragma solidity ^0.8.4;
1146 
1147 
1148 /**
1149  * @dev Interface of ERC721 token receiver.
1150  */
1151 interface ERC721A__IERC721Receiver {
1152     function onERC721Received(
1153         address operator,
1154         address from,
1155         uint256 tokenId,
1156         bytes calldata data
1157     ) external returns (bytes4);
1158 }
1159 
1160 /**
1161  * @title ERC721A
1162  *
1163  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1164  * Non-Fungible Token Standard, including the Metadata extension.
1165  * Optimized for lower gas during batch mints.
1166  *
1167  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1168  * starting from `_startTokenId()`.
1169  *
1170  * Assumptions:
1171  *
1172  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1173  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1174  */
1175 contract ERC721A is IERC721A {
1176     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1177     struct TokenApprovalRef {
1178         address value;
1179     }
1180 
1181     // =============================================================
1182     //                           CONSTANTS
1183     // =============================================================
1184 
1185     // Mask of an entry in packed address data.
1186     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1187 
1188     // The bit position of `numberMinted` in packed address data.
1189     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1190 
1191     // The bit position of `numberBurned` in packed address data.
1192     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1193 
1194     // The bit position of `aux` in packed address data.
1195     uint256 private constant _BITPOS_AUX = 192;
1196 
1197     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1198     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1199 
1200     // The bit position of `startTimestamp` in packed ownership.
1201     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1202 
1203     // The bit mask of the `burned` bit in packed ownership.
1204     uint256 private constant _BITMASK_BURNED = 1 << 224;
1205 
1206     // The bit position of the `nextInitialized` bit in packed ownership.
1207     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1208 
1209     // The bit mask of the `nextInitialized` bit in packed ownership.
1210     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1211 
1212     // The bit position of `extraData` in packed ownership.
1213     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1214 
1215     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1216     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1217 
1218     // The mask of the lower 160 bits for addresses.
1219     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1220 
1221     // The maximum `quantity` that can be minted with {_mintERC2309}.
1222     // This limit is to prevent overflows on the address data entries.
1223     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1224     // is required to cause an overflow, which is unrealistic.
1225     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1226 
1227     // The `Transfer` event signature is given by:
1228     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1229     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1230         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1231 
1232     // =============================================================
1233     //                            STORAGE
1234     // =============================================================
1235 
1236     // The next token ID to be minted.
1237     uint256 private _currentIndex;
1238 
1239     // The number of tokens burned.
1240     uint256 private _burnCounter;
1241 
1242     // Token name
1243     string private _name;
1244 
1245     // Token symbol
1246     string private _symbol;
1247 
1248     // Mapping from token ID to ownership details
1249     // An empty struct value does not necessarily mean the token is unowned.
1250     // See {_packedOwnershipOf} implementation for details.
1251     //
1252     // Bits Layout:
1253     // - [0..159]   `addr`
1254     // - [160..223] `startTimestamp`
1255     // - [224]      `burned`
1256     // - [225]      `nextInitialized`
1257     // - [232..255] `extraData`
1258     mapping(uint256 => uint256) private _packedOwnerships;
1259 
1260     // Mapping owner address to address data.
1261     //
1262     // Bits Layout:
1263     // - [0..63]    `balance`
1264     // - [64..127]  `numberMinted`
1265     // - [128..191] `numberBurned`
1266     // - [192..255] `aux`
1267     mapping(address => uint256) private _packedAddressData;
1268 
1269     // Mapping from token ID to approved address.
1270     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1271 
1272     // Mapping from owner to operator approvals
1273     mapping(address => mapping(address => bool)) private _operatorApprovals;
1274 
1275     // =============================================================
1276     //                          CONSTRUCTOR
1277     // =============================================================
1278 
1279     constructor(string memory name_, string memory symbol_) {
1280         _name = name_;
1281         _symbol = symbol_;
1282         _currentIndex = _startTokenId();
1283     }
1284 
1285     // =============================================================
1286     //                   TOKEN COUNTING OPERATIONS
1287     // =============================================================
1288 
1289     /**
1290      * @dev Returns the starting token ID.
1291      * To change the starting token ID, please override this function.
1292      */
1293     function _startTokenId() internal view virtual returns (uint256) {
1294         return 1;
1295     }
1296 
1297     /**
1298      * @dev Returns the next token ID to be minted.
1299      */
1300     function _nextTokenId() internal view virtual returns (uint256) {
1301         return _currentIndex;
1302     }
1303 
1304     /**
1305      * @dev Returns the total number of tokens in existence.
1306      * Burned tokens will reduce the count.
1307      * To get the total number of tokens minted, please see {_totalMinted}.
1308      */
1309     function totalSupply() public view virtual override returns (uint256) {
1310         // Counter underflow is impossible as _burnCounter cannot be incremented
1311         // more than `_currentIndex - _startTokenId()` times.
1312         unchecked {
1313             return _currentIndex - _burnCounter - _startTokenId();
1314         }
1315     }
1316 
1317     /**
1318      * @dev Returns the total amount of tokens minted in the contract.
1319      */
1320     function _totalMinted() internal view virtual returns (uint256) {
1321         // Counter underflow is impossible as `_currentIndex` does not decrement,
1322         // and it is initialized to `_startTokenId()`.
1323         unchecked {
1324             return _currentIndex - _startTokenId();
1325         }
1326     }
1327 
1328     /**
1329      * @dev Returns the total number of tokens burned.
1330      */
1331     function _totalBurned() internal view virtual returns (uint256) {
1332         return _burnCounter;
1333     }
1334 
1335     // =============================================================
1336     //                    ADDRESS DATA OPERATIONS
1337     // =============================================================
1338 
1339     /**
1340      * @dev Returns the number of tokens in `owner`'s account.
1341      */
1342     function balanceOf(address owner) public view virtual override returns (uint256) {
1343         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1344         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1345     }
1346 
1347     /**
1348      * Returns the number of tokens minted by `owner`.
1349      */
1350     function _numberMinted(address owner) internal view returns (uint256) {
1351         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1352     }
1353 
1354     /**
1355      * Returns the number of tokens burned by or on behalf of `owner`.
1356      */
1357     function _numberBurned(address owner) internal view returns (uint256) {
1358         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1359     }
1360 
1361     /**
1362      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1363      */
1364     function _getAux(address owner) internal view returns (uint64) {
1365         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1366     }
1367 
1368     /**
1369      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1370      * If there are multiple variables, please pack them into a uint64.
1371      */
1372     function _setAux(address owner, uint64 aux) internal virtual {
1373         uint256 packed = _packedAddressData[owner];
1374         uint256 auxCasted;
1375         // Cast `aux` with assembly to avoid redundant masking.
1376         assembly {
1377             auxCasted := aux
1378         }
1379         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1380         _packedAddressData[owner] = packed;
1381     }
1382 
1383     // =============================================================
1384     //                            IERC165
1385     // =============================================================
1386 
1387     /**
1388      * @dev Returns true if this contract implements the interface defined by
1389      * `interfaceId`. See the corresponding
1390      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1391      * to learn more about how these ids are created.
1392      *
1393      * This function call must use less than 30000 gas.
1394      */
1395     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1396         // The interface IDs are constants representing the first 4 bytes
1397         // of the XOR of all function selectors in the interface.
1398         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1399         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1400         return
1401             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1402             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1403             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1404     }
1405 
1406     // =============================================================
1407     //                        IERC721Metadata
1408     // =============================================================
1409 
1410     /**
1411      * @dev Returns the token collection name.
1412      */
1413     function name() public view virtual override returns (string memory) {
1414         return _name;
1415     }
1416 
1417     /**
1418      * @dev Returns the token collection symbol.
1419      */
1420     function symbol() public view virtual override returns (string memory) {
1421         return _symbol;
1422     }
1423 
1424     /**
1425      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1426      */
1427     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1428         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1429 
1430         string memory baseURI = _baseURI();
1431         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1432     }
1433 
1434     /**
1435      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1436      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1437      * by default, it can be overridden in child contracts.
1438      */
1439     function _baseURI() internal view virtual returns (string memory) {
1440         return '';
1441     }
1442 
1443     // =============================================================
1444     //                     OWNERSHIPS OPERATIONS
1445     // =============================================================
1446 
1447     /**
1448      * @dev Returns the owner of the `tokenId` token.
1449      *
1450      * Requirements:
1451      *
1452      * - `tokenId` must exist.
1453      */
1454     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1455         return address(uint160(_packedOwnershipOf(tokenId)));
1456     }
1457 
1458     /**
1459      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1460      * It gradually moves to O(1) as tokens get transferred around over time.
1461      */
1462     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1463         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1464     }
1465 
1466     /**
1467      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1468      */
1469     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1470         return _unpackedOwnership(_packedOwnerships[index]);
1471     }
1472 
1473     /**
1474      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1475      */
1476     function _initializeOwnershipAt(uint256 index) internal virtual {
1477         if (_packedOwnerships[index] == 0) {
1478             _packedOwnerships[index] = _packedOwnershipOf(index);
1479         }
1480     }
1481 
1482     /**
1483      * Returns the packed ownership data of `tokenId`.
1484      */
1485     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1486         uint256 curr = tokenId;
1487 
1488         unchecked {
1489             if (_startTokenId() <= curr)
1490                 if (curr < _currentIndex) {
1491                     uint256 packed = _packedOwnerships[curr];
1492                     // If not burned.
1493                     if (packed & _BITMASK_BURNED == 0) {
1494                         // Invariant:
1495                         // There will always be an initialized ownership slot
1496                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1497                         // before an unintialized ownership slot
1498                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1499                         // Hence, `curr` will not underflow.
1500                         //
1501                         // We can directly compare the packed value.
1502                         // If the address is zero, packed will be zero.
1503                         while (packed == 0) {
1504                             packed = _packedOwnerships[--curr];
1505                         }
1506                         return packed;
1507                     }
1508                 }
1509         }
1510         revert OwnerQueryForNonexistentToken();
1511     }
1512 
1513     /**
1514      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1515      */
1516     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1517         ownership.addr = address(uint160(packed));
1518         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1519         ownership.burned = packed & _BITMASK_BURNED != 0;
1520         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1521     }
1522 
1523     /**
1524      * @dev Packs ownership data into a single uint256.
1525      */
1526     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1527         assembly {
1528             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1529             owner := and(owner, _BITMASK_ADDRESS)
1530             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1531             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1532         }
1533     }
1534 
1535     /**
1536      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1537      */
1538     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1539         // For branchless setting of the `nextInitialized` flag.
1540         assembly {
1541             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1542             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1543         }
1544     }
1545 
1546     // =============================================================
1547     //                      APPROVAL OPERATIONS
1548     // =============================================================
1549 
1550     /**
1551      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1552      * The approval is cleared when the token is transferred.
1553      *
1554      * Only a single account can be approved at a time, so approving the
1555      * zero address clears previous approvals.
1556      *
1557      * Requirements:
1558      *
1559      * - The caller must own the token or be an approved operator.
1560      * - `tokenId` must exist.
1561      *
1562      * Emits an {Approval} event.
1563      */
1564     function approve(address to, uint256 tokenId) public payable virtual override {
1565         address owner = ownerOf(tokenId);
1566 
1567         if (_msgSenderERC721A() != owner)
1568             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1569                 revert ApprovalCallerNotOwnerNorApproved();
1570             }
1571 
1572         _tokenApprovals[tokenId].value = to;
1573         emit Approval(owner, to, tokenId);
1574     }
1575 
1576     /**
1577      * @dev Returns the account approved for `tokenId` token.
1578      *
1579      * Requirements:
1580      *
1581      * - `tokenId` must exist.
1582      */
1583     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1584         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1585 
1586         return _tokenApprovals[tokenId].value;
1587     }
1588 
1589     /**
1590      * @dev Approve or remove `operator` as an operator for the caller.
1591      * Operators can call {transferFrom} or {safeTransferFrom}
1592      * for any token owned by the caller.
1593      *
1594      * Requirements:
1595      *
1596      * - The `operator` cannot be the caller.
1597      *
1598      * Emits an {ApprovalForAll} event.
1599      */
1600     function setApprovalForAll(address operator, bool approved) public virtual override {
1601         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1602         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1603     }
1604 
1605     /**
1606      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1607      *
1608      * See {setApprovalForAll}.
1609      */
1610     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1611         return _operatorApprovals[owner][operator];
1612     }
1613 
1614     /**
1615      * @dev Returns whether `tokenId` exists.
1616      *
1617      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1618      *
1619      * Tokens start existing when they are minted. See {_mint}.
1620      */
1621     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1622         return
1623             _startTokenId() <= tokenId &&
1624             tokenId < _currentIndex && // If within bounds,
1625             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1626     }
1627 
1628     /**
1629      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1630      */
1631     function _isSenderApprovedOrOwner(
1632         address approvedAddress,
1633         address owner,
1634         address msgSender
1635     ) private pure returns (bool result) {
1636         assembly {
1637             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1638             owner := and(owner, _BITMASK_ADDRESS)
1639             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1640             msgSender := and(msgSender, _BITMASK_ADDRESS)
1641             // `msgSender == owner || msgSender == approvedAddress`.
1642             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1643         }
1644     }
1645 
1646     /**
1647      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1648      */
1649     function _getApprovedSlotAndAddress(uint256 tokenId)
1650         private
1651         view
1652         returns (uint256 approvedAddressSlot, address approvedAddress)
1653     {
1654         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1655         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1656         assembly {
1657             approvedAddressSlot := tokenApproval.slot
1658             approvedAddress := sload(approvedAddressSlot)
1659         }
1660     }
1661 
1662     // =============================================================
1663     //                      TRANSFER OPERATIONS
1664     // =============================================================
1665 
1666     /**
1667      * @dev Transfers `tokenId` from `from` to `to`.
1668      *
1669      * Requirements:
1670      *
1671      * - `from` cannot be the zero address.
1672      * - `to` cannot be the zero address.
1673      * - `tokenId` token must be owned by `from`.
1674      * - If the caller is not `from`, it must be approved to move this token
1675      * by either {approve} or {setApprovalForAll}.
1676      *
1677      * Emits a {Transfer} event.
1678      */
1679     function transferFrom(
1680         address from,
1681         address to,
1682         uint256 tokenId
1683     ) public payable virtual override {
1684         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1685 
1686         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1687 
1688         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1689 
1690         // The nested ifs save around 20+ gas over a compound boolean condition.
1691         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1692             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1693 
1694         if (to == address(0)) revert TransferToZeroAddress();
1695 
1696         _beforeTokenTransfers(from, to, tokenId, 1);
1697 
1698         // Clear approvals from the previous owner.
1699         assembly {
1700             if approvedAddress {
1701                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1702                 sstore(approvedAddressSlot, 0)
1703             }
1704         }
1705 
1706         // Underflow of the sender's balance is impossible because we check for
1707         // ownership above and the recipient's balance can't realistically overflow.
1708         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1709         unchecked {
1710             // We can directly increment and decrement the balances.
1711             --_packedAddressData[from]; // Updates: `balance -= 1`.
1712             ++_packedAddressData[to]; // Updates: `balance += 1`.
1713 
1714             // Updates:
1715             // - `address` to the next owner.
1716             // - `startTimestamp` to the timestamp of transfering.
1717             // - `burned` to `false`.
1718             // - `nextInitialized` to `true`.
1719             _packedOwnerships[tokenId] = _packOwnershipData(
1720                 to,
1721                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1722             );
1723 
1724             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1725             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1726                 uint256 nextTokenId = tokenId + 1;
1727                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1728                 if (_packedOwnerships[nextTokenId] == 0) {
1729                     // If the next slot is within bounds.
1730                     if (nextTokenId != _currentIndex) {
1731                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1732                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1733                     }
1734                 }
1735             }
1736         }
1737 
1738         emit Transfer(from, to, tokenId);
1739         _afterTokenTransfers(from, to, tokenId, 1);
1740     }
1741 
1742     /**
1743      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1744      */
1745     function safeTransferFrom(
1746         address from,
1747         address to,
1748         uint256 tokenId
1749     ) public payable virtual override {
1750         safeTransferFrom(from, to, tokenId, '');
1751     }
1752 
1753     /**
1754      * @dev Safely transfers `tokenId` token from `from` to `to`.
1755      *
1756      * Requirements:
1757      *
1758      * - `from` cannot be the zero address.
1759      * - `to` cannot be the zero address.
1760      * - `tokenId` token must exist and be owned by `from`.
1761      * - If the caller is not `from`, it must be approved to move this token
1762      * by either {approve} or {setApprovalForAll}.
1763      * - If `to` refers to a smart contract, it must implement
1764      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1765      *
1766      * Emits a {Transfer} event.
1767      */
1768     function safeTransferFrom(
1769         address from,
1770         address to,
1771         uint256 tokenId,
1772         bytes memory _data
1773     ) public payable virtual override {
1774         transferFrom(from, to, tokenId);
1775         if (to.code.length != 0)
1776             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1777                 revert TransferToNonERC721ReceiverImplementer();
1778             }
1779     }
1780 
1781     /**
1782      * @dev Hook that is called before a set of serially-ordered token IDs
1783      * are about to be transferred. This includes minting.
1784      * And also called before burning one token.
1785      *
1786      * `startTokenId` - the first token ID to be transferred.
1787      * `quantity` - the amount to be transferred.
1788      *
1789      * Calling conditions:
1790      *
1791      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1792      * transferred to `to`.
1793      * - When `from` is zero, `tokenId` will be minted for `to`.
1794      * - When `to` is zero, `tokenId` will be burned by `from`.
1795      * - `from` and `to` are never both zero.
1796      */
1797     function _beforeTokenTransfers(
1798         address from,
1799         address to,
1800         uint256 startTokenId,
1801         uint256 quantity
1802     ) internal virtual {}
1803 
1804     /**
1805      * @dev Hook that is called after a set of serially-ordered token IDs
1806      * have been transferred. This includes minting.
1807      * And also called after one token has been burned.
1808      *
1809      * `startTokenId` - the first token ID to be transferred.
1810      * `quantity` - the amount to be transferred.
1811      *
1812      * Calling conditions:
1813      *
1814      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1815      * transferred to `to`.
1816      * - When `from` is zero, `tokenId` has been minted for `to`.
1817      * - When `to` is zero, `tokenId` has been burned by `from`.
1818      * - `from` and `to` are never both zero.
1819      */
1820     function _afterTokenTransfers(
1821         address from,
1822         address to,
1823         uint256 startTokenId,
1824         uint256 quantity
1825     ) internal virtual {}
1826 
1827     /**
1828      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1829      *
1830      * `from` - Previous owner of the given token ID.
1831      * `to` - Target address that will receive the token.
1832      * `tokenId` - Token ID to be transferred.
1833      * `_data` - Optional data to send along with the call.
1834      *
1835      * Returns whether the call correctly returned the expected magic value.
1836      */
1837     function _checkContractOnERC721Received(
1838         address from,
1839         address to,
1840         uint256 tokenId,
1841         bytes memory _data
1842     ) private returns (bool) {
1843         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1844             bytes4 retval
1845         ) {
1846             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1847         } catch (bytes memory reason) {
1848             if (reason.length == 0) {
1849                 revert TransferToNonERC721ReceiverImplementer();
1850             } else {
1851                 assembly {
1852                     revert(add(32, reason), mload(reason))
1853                 }
1854             }
1855         }
1856     }
1857 
1858     // =============================================================
1859     //                        MINT OPERATIONS
1860     // =============================================================
1861 
1862     /**
1863      * @dev Mints `quantity` tokens and transfers them to `to`.
1864      *
1865      * Requirements:
1866      *
1867      * - `to` cannot be the zero address.
1868      * - `quantity` must be greater than 0.
1869      *
1870      * Emits a {Transfer} event for each mint.
1871      */
1872     function _mint(address to, uint256 quantity) internal virtual {
1873         uint256 startTokenId = _currentIndex;
1874         if (quantity == 0) revert MintZeroQuantity();
1875 
1876         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1877 
1878         // Overflows are incredibly unrealistic.
1879         // `balance` and `numberMinted` have a maximum limit of 2**64.
1880         // `tokenId` has a maximum limit of 2**256.
1881         unchecked {
1882             // Updates:
1883             // - `balance += quantity`.
1884             // - `numberMinted += quantity`.
1885             //
1886             // We can directly add to the `balance` and `numberMinted`.
1887             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1888 
1889             // Updates:
1890             // - `address` to the owner.
1891             // - `startTimestamp` to the timestamp of minting.
1892             // - `burned` to `false`.
1893             // - `nextInitialized` to `quantity == 1`.
1894             _packedOwnerships[startTokenId] = _packOwnershipData(
1895                 to,
1896                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1897             );
1898 
1899             uint256 toMasked;
1900             uint256 end = startTokenId + quantity;
1901 
1902             // Use assembly to loop and emit the `Transfer` event for gas savings.
1903             // The duplicated `log4` removes an extra check and reduces stack juggling.
1904             // The assembly, together with the surrounding Solidity code, have been
1905             // delicately arranged to nudge the compiler into producing optimized opcodes.
1906             assembly {
1907                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1908                 toMasked := and(to, _BITMASK_ADDRESS)
1909                 // Emit the `Transfer` event.
1910                 log4(
1911                     0, // Start of data (0, since no data).
1912                     0, // End of data (0, since no data).
1913                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1914                     0, // `address(0)`.
1915                     toMasked, // `to`.
1916                     startTokenId // `tokenId`.
1917                 )
1918 
1919                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1920                 // that overflows uint256 will make the loop run out of gas.
1921                 // The compiler will optimize the `iszero` away for performance.
1922                 for {
1923                     let tokenId := add(startTokenId, 1)
1924                 } iszero(eq(tokenId, end)) {
1925                     tokenId := add(tokenId, 1)
1926                 } {
1927                     // Emit the `Transfer` event. Similar to above.
1928                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1929                 }
1930             }
1931             if (toMasked == 0) revert MintToZeroAddress();
1932 
1933             _currentIndex = end;
1934         }
1935         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1936     }
1937 
1938     /**
1939      * @dev Mints `quantity` tokens and transfers them to `to`.
1940      *
1941      * This function is intended for efficient minting only during contract creation.
1942      *
1943      * It emits only one {ConsecutiveTransfer} as defined in
1944      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1945      * instead of a sequence of {Transfer} event(s).
1946      *
1947      * Calling this function outside of contract creation WILL make your contract
1948      * non-compliant with the ERC721 standard.
1949      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1950      * {ConsecutiveTransfer} event is only permissible during contract creation.
1951      *
1952      * Requirements:
1953      *
1954      * - `to` cannot be the zero address.
1955      * - `quantity` must be greater than 0.
1956      *
1957      * Emits a {ConsecutiveTransfer} event.
1958      */
1959     function _mintERC2309(address to, uint256 quantity) internal virtual {
1960         uint256 startTokenId = _currentIndex;
1961         if (to == address(0)) revert MintToZeroAddress();
1962         if (quantity == 0) revert MintZeroQuantity();
1963         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1964 
1965         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1966 
1967         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1968         unchecked {
1969             // Updates:
1970             // - `balance += quantity`.
1971             // - `numberMinted += quantity`.
1972             //
1973             // We can directly add to the `balance` and `numberMinted`.
1974             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1975 
1976             // Updates:
1977             // - `address` to the owner.
1978             // - `startTimestamp` to the timestamp of minting.
1979             // - `burned` to `false`.
1980             // - `nextInitialized` to `quantity == 1`.
1981             _packedOwnerships[startTokenId] = _packOwnershipData(
1982                 to,
1983                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1984             );
1985 
1986             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1987 
1988             _currentIndex = startTokenId + quantity;
1989         }
1990         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1991     }
1992 
1993     /**
1994      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1995      *
1996      * Requirements:
1997      *
1998      * - If `to` refers to a smart contract, it must implement
1999      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2000      * - `quantity` must be greater than 0.
2001      *
2002      * See {_mint}.
2003      *
2004      * Emits a {Transfer} event for each mint.
2005      */
2006     function _safeMint(
2007         address to,
2008         uint256 quantity,
2009         bytes memory _data
2010     ) internal virtual {
2011         _mint(to, quantity);
2012 
2013         unchecked {
2014             if (to.code.length != 0) {
2015                 uint256 end = _currentIndex;
2016                 uint256 index = end - quantity;
2017                 do {
2018                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2019                         revert TransferToNonERC721ReceiverImplementer();
2020                     }
2021                 } while (index < end);
2022                 // Reentrancy protection.
2023                 if (_currentIndex != end) revert();
2024             }
2025         }
2026     }
2027 
2028     /**
2029      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2030      */
2031     function _safeMint(address to, uint256 quantity) internal virtual {
2032         _safeMint(to, quantity, '');
2033     }
2034 
2035     // =============================================================
2036     //                        BURN OPERATIONS
2037     // =============================================================
2038 
2039     /**
2040      * @dev Equivalent to `_burn(tokenId, false)`.
2041      */
2042     function _burn(uint256 tokenId) internal virtual {
2043         _burn(tokenId, false);
2044     }
2045 
2046     /**
2047      * @dev Destroys `tokenId`.
2048      * The approval is cleared when the token is burned.
2049      *
2050      * Requirements:
2051      *
2052      * - `tokenId` must exist.
2053      *
2054      * Emits a {Transfer} event.
2055      */
2056     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2057         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2058 
2059         address from = address(uint160(prevOwnershipPacked));
2060 
2061         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2062 
2063         if (approvalCheck) {
2064             // The nested ifs save around 20+ gas over a compound boolean condition.
2065             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2066                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2067         }
2068 
2069         _beforeTokenTransfers(from, address(0), tokenId, 1);
2070 
2071         // Clear approvals from the previous owner.
2072         assembly {
2073             if approvedAddress {
2074                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2075                 sstore(approvedAddressSlot, 0)
2076             }
2077         }
2078 
2079         // Underflow of the sender's balance is impossible because we check for
2080         // ownership above and the recipient's balance can't realistically overflow.
2081         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2082         unchecked {
2083             // Updates:
2084             // - `balance -= 1`.
2085             // - `numberBurned += 1`.
2086             //
2087             // We can directly decrement the balance, and increment the number burned.
2088             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2089             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2090 
2091             // Updates:
2092             // - `address` to the last owner.
2093             // - `startTimestamp` to the timestamp of burning.
2094             // - `burned` to `true`.
2095             // - `nextInitialized` to `true`.
2096             _packedOwnerships[tokenId] = _packOwnershipData(
2097                 from,
2098                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2099             );
2100 
2101             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2102             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2103                 uint256 nextTokenId = tokenId + 1;
2104                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2105                 if (_packedOwnerships[nextTokenId] == 0) {
2106                     // If the next slot is within bounds.
2107                     if (nextTokenId != _currentIndex) {
2108                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2109                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2110                     }
2111                 }
2112             }
2113         }
2114 
2115         emit Transfer(from, address(0), tokenId);
2116         _afterTokenTransfers(from, address(0), tokenId, 1);
2117 
2118         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2119         unchecked {
2120             _burnCounter++;
2121         }
2122     }
2123 
2124     // =============================================================
2125     //                     EXTRA DATA OPERATIONS
2126     // =============================================================
2127 
2128     /**
2129      * @dev Directly sets the extra data for the ownership data `index`.
2130      */
2131     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2132         uint256 packed = _packedOwnerships[index];
2133         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2134         uint256 extraDataCasted;
2135         // Cast `extraData` with assembly to avoid redundant masking.
2136         assembly {
2137             extraDataCasted := extraData
2138         }
2139         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2140         _packedOwnerships[index] = packed;
2141     }
2142 
2143     /**
2144      * @dev Called during each token transfer to set the 24bit `extraData` field.
2145      * Intended to be overridden by the cosumer contract.
2146      *
2147      * `previousExtraData` - the value of `extraData` before transfer.
2148      *
2149      * Calling conditions:
2150      *
2151      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2152      * transferred to `to`.
2153      * - When `from` is zero, `tokenId` will be minted for `to`.
2154      * - When `to` is zero, `tokenId` will be burned by `from`.
2155      * - `from` and `to` are never both zero.
2156      */
2157     function _extraData(
2158         address from,
2159         address to,
2160         uint24 previousExtraData
2161     ) internal view virtual returns (uint24) {}
2162 
2163     /**
2164      * @dev Returns the next extra data for the packed ownership data.
2165      * The returned result is shifted into position.
2166      */
2167     function _nextExtraData(
2168         address from,
2169         address to,
2170         uint256 prevOwnershipPacked
2171     ) private view returns (uint256) {
2172         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2173         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2174     }
2175 
2176     // =============================================================
2177     //                       OTHER OPERATIONS
2178     // =============================================================
2179 
2180     /**
2181      * @dev Returns the message sender (defaults to `msg.sender`).
2182      *
2183      * If you are writing GSN compatible contracts, you need to override this function.
2184      */
2185     function _msgSenderERC721A() internal view virtual returns (address) {
2186         return msg.sender;
2187     }
2188 
2189     /**
2190      * @dev Converts a uint256 to its ASCII string decimal representation.
2191      */
2192     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2193         assembly {
2194             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2195             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2196             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2197             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2198             let m := add(mload(0x40), 0xa0)
2199             // Update the free memory pointer to allocate.
2200             mstore(0x40, m)
2201             // Assign the `str` to the end.
2202             str := sub(m, 0x20)
2203             // Zeroize the slot after the string.
2204             mstore(str, 0)
2205 
2206             // Cache the end of the memory to calculate the length later.
2207             let end := str
2208 
2209             // We write the string from rightmost digit to leftmost digit.
2210             // The following is essentially a do-while loop that also handles the zero case.
2211             // prettier-ignore
2212             for { let temp := value } 1 {} {
2213                 str := sub(str, 1)
2214                 // Write the character to the pointer.
2215                 // The ASCII index of the '0' character is 48.
2216                 mstore8(str, add(48, mod(temp, 10)))
2217                 // Keep dividing `temp` until zero.
2218                 temp := div(temp, 10)
2219                 // prettier-ignore
2220                 if iszero(temp) { break }
2221             }
2222 
2223             let length := sub(end, str)
2224             // Move the pointer 32 bytes leftwards to make room for the length.
2225             str := sub(str, 0x20)
2226             // Store the length.
2227             mstore(str, length)
2228         }
2229     }
2230 }
2231 
2232 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
2233 
2234 
2235 // ERC721A Contracts v4.2.3
2236 // Creator: Chiru Labs
2237 
2238 pragma solidity ^0.8.4;
2239 
2240 
2241 /**
2242  * @dev Interface of ERC721AQueryable.
2243  */
2244 interface IERC721AQueryable is IERC721A {
2245     /**
2246      * Invalid query range (`start` >= `stop`).
2247      */
2248     error InvalidQueryRange();
2249 
2250     /**
2251      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2252      *
2253      * If the `tokenId` is out of bounds:
2254      *
2255      * - `addr = address(0)`
2256      * - `startTimestamp = 0`
2257      * - `burned = false`
2258      * - `extraData = 0`
2259      *
2260      * If the `tokenId` is burned:
2261      *
2262      * - `addr = <Address of owner before token was burned>`
2263      * - `startTimestamp = <Timestamp when token was burned>`
2264      * - `burned = true`
2265      * - `extraData = <Extra data when token was burned>`
2266      *
2267      * Otherwise:
2268      *
2269      * - `addr = <Address of owner>`
2270      * - `startTimestamp = <Timestamp of start of ownership>`
2271      * - `burned = false`
2272      * - `extraData = <Extra data at start of ownership>`
2273      */
2274     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
2275 
2276     /**
2277      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2278      * See {ERC721AQueryable-explicitOwnershipOf}
2279      */
2280     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
2281 
2282     /**
2283      * @dev Returns an array of token IDs owned by `owner`,
2284      * in the range [`start`, `stop`)
2285      * (i.e. `start <= tokenId < stop`).
2286      *
2287      * This function allows for tokens to be queried if the collection
2288      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2289      *
2290      * Requirements:
2291      *
2292      * - `start < stop`
2293      */
2294     function tokensOfOwnerIn(
2295         address owner,
2296         uint256 start,
2297         uint256 stop
2298     ) external view returns (uint256[] memory);
2299 
2300     /**
2301      * @dev Returns an array of token IDs owned by `owner`.
2302      *
2303      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2304      * It is meant to be called off-chain.
2305      *
2306      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2307      * multiple smaller scans if the collection is large enough to cause
2308      * an out-of-gas error (10K collections should be fine).
2309      */
2310     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2311 }
2312 
2313 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2314 
2315 
2316 // ERC721A Contracts v4.2.3
2317 // Creator: Chiru Labs
2318 
2319 pragma solidity ^0.8.4;
2320 
2321 
2322 
2323 /**
2324  * @title ERC721AQueryable.
2325  *
2326  * @dev ERC721A subclass with convenience query functions.
2327  */
2328 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2329     /**
2330      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2331      *
2332      * If the `tokenId` is out of bounds:
2333      *
2334      * - `addr = address(0)`
2335      * - `startTimestamp = 0`
2336      * - `burned = false`
2337      * - `extraData = 0`
2338      *
2339      * If the `tokenId` is burned:
2340      *
2341      * - `addr = <Address of owner before token was burned>`
2342      * - `startTimestamp = <Timestamp when token was burned>`
2343      * - `burned = true`
2344      * - `extraData = <Extra data when token was burned>`
2345      *
2346      * Otherwise:
2347      *
2348      * - `addr = <Address of owner>`
2349      * - `startTimestamp = <Timestamp of start of ownership>`
2350      * - `burned = false`
2351      * - `extraData = <Extra data at start of ownership>`
2352      */
2353     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2354         TokenOwnership memory ownership;
2355         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2356             return ownership;
2357         }
2358         ownership = _ownershipAt(tokenId);
2359         if (ownership.burned) {
2360             return ownership;
2361         }
2362         return _ownershipOf(tokenId);
2363     }
2364 
2365     /**
2366      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2367      * See {ERC721AQueryable-explicitOwnershipOf}
2368      */
2369     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2370         external
2371         view
2372         virtual
2373         override
2374         returns (TokenOwnership[] memory)
2375     {
2376         unchecked {
2377             uint256 tokenIdsLength = tokenIds.length;
2378             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2379             for (uint256 i; i != tokenIdsLength; ++i) {
2380                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2381             }
2382             return ownerships;
2383         }
2384     }
2385 
2386     /**
2387      * @dev Returns an array of token IDs owned by `owner`,
2388      * in the range [`start`, `stop`)
2389      * (i.e. `start <= tokenId < stop`).
2390      *
2391      * This function allows for tokens to be queried if the collection
2392      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2393      *
2394      * Requirements:
2395      *
2396      * - `start < stop`
2397      */
2398     function tokensOfOwnerIn(
2399         address owner,
2400         uint256 start,
2401         uint256 stop
2402     ) external view virtual override returns (uint256[] memory) {
2403         unchecked {
2404             if (start >= stop) revert InvalidQueryRange();
2405             uint256 tokenIdsIdx;
2406             uint256 stopLimit = _nextTokenId();
2407             // Set `start = max(start, _startTokenId())`.
2408             if (start < _startTokenId()) {
2409                 start = _startTokenId();
2410             }
2411             // Set `stop = min(stop, stopLimit)`.
2412             if (stop > stopLimit) {
2413                 stop = stopLimit;
2414             }
2415             uint256 tokenIdsMaxLength = balanceOf(owner);
2416             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2417             // to cater for cases where `balanceOf(owner)` is too big.
2418             if (start < stop) {
2419                 uint256 rangeLength = stop - start;
2420                 if (rangeLength < tokenIdsMaxLength) {
2421                     tokenIdsMaxLength = rangeLength;
2422                 }
2423             } else {
2424                 tokenIdsMaxLength = 0;
2425             }
2426             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2427             if (tokenIdsMaxLength == 0) {
2428                 return tokenIds;
2429             }
2430             // We need to call `explicitOwnershipOf(start)`,
2431             // because the slot at `start` may not be initialized.
2432             TokenOwnership memory ownership = explicitOwnershipOf(start);
2433             address currOwnershipAddr;
2434             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2435             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2436             if (!ownership.burned) {
2437                 currOwnershipAddr = ownership.addr;
2438             }
2439             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2440                 ownership = _ownershipAt(i);
2441                 if (ownership.burned) {
2442                     continue;
2443                 }
2444                 if (ownership.addr != address(0)) {
2445                     currOwnershipAddr = ownership.addr;
2446                 }
2447                 if (currOwnershipAddr == owner) {
2448                     tokenIds[tokenIdsIdx++] = i;
2449                 }
2450             }
2451             // Downsize the array to fit.
2452             assembly {
2453                 mstore(tokenIds, tokenIdsIdx)
2454             }
2455             return tokenIds;
2456         }
2457     }
2458 
2459     /**
2460      * @dev Returns an array of token IDs owned by `owner`.
2461      *
2462      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2463      * It is meant to be called off-chain.
2464      *
2465      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2466      * multiple smaller scans if the collection is large enough to cause
2467      * an out-of-gas error (10K collections should be fine).
2468      */
2469     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2470         unchecked {
2471             uint256 tokenIdsIdx;
2472             address currOwnershipAddr;
2473             uint256 tokenIdsLength = balanceOf(owner);
2474             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2475             TokenOwnership memory ownership;
2476             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2477                 ownership = _ownershipAt(i);
2478                 if (ownership.burned) {
2479                     continue;
2480                 }
2481                 if (ownership.addr != address(0)) {
2482                     currOwnershipAddr = ownership.addr;
2483                 }
2484                 if (currOwnershipAddr == owner) {
2485                     tokenIds[tokenIdsIdx++] = i;
2486                 }
2487             }
2488             return tokenIds;
2489         }
2490     }
2491 }
2492 
2493 // File: contracts/Lethal.sol
2494 
2495 
2496 
2497 pragma solidity ^0.8.18;
2498 
2499 
2500 
2501 
2502 
2503 
2504 contract Lethal is
2505     ERC721AQueryable,
2506     Ownable,
2507     DefaultOperatorFilterer,
2508     ReentrancyGuard
2509 {
2510     error Paused();
2511     error NotPublic();
2512     error WhitelistEnd();
2513     error NotWhitelisted();
2514     error InsufficientFunds();
2515     error ExceedsMaxSupply();
2516     error ExceedsMaxPerUser();
2517     using Strings for uint256;
2518 
2519     uint256 public _mintPriceWl = 0.01 ether;
2520     uint256 public _maxPerUserWl = 2;
2521     uint256 public _mintPricePublic = 0.02 ether;
2522     uint256 public _maxPerUserPublic = 3;
2523     uint256 public _maxSupply = 3333;
2524     bool public _paused = true;
2525     bool public whitelistMint = true;
2526     bool private _revealed;
2527     bytes32 private _MerkleRoot =
2528         0x1587fdc0ddc90fe1ffaf4fc40c5d74a93064c69ba00ff461ff6c70d02048fa26;
2529     string private _notRevealedUri;
2530     string private baseURI;
2531     string private _baseExtension = ".json";
2532     mapping(address => uint256) public _walletMintedCountWl;
2533 
2534     constructor(
2535         string memory _name,
2536         string memory _symbol,
2537         string memory _initBaseURI,
2538         string memory _initNotRevealedUri
2539     ) ERC721A(_name, _symbol) {
2540         setBaseURI(_initBaseURI);
2541         _notRevealedUri = _initNotRevealedUri;
2542     }
2543 
2544     // internal
2545     function _baseURI() internal view virtual override returns (string memory) {
2546         return baseURI;
2547     }
2548 
2549     // public mint
2550     function mint(uint256 _mintAmount) external payable {
2551         if (_paused) revert Paused();
2552         if (totalSupply() + _mintAmount > _maxSupply) revert ExceedsMaxSupply();
2553 
2554         if (msg.sender != owner()) {
2555             if (whitelistMint) revert NotPublic();
2556 
2557             if (_mintAmount > _maxPerUserPublic) revert ExceedsMaxPerUser();
2558 
2559             if (msg.value < _mintAmount * _mintPricePublic)
2560                 revert InsufficientFunds();
2561         }
2562 
2563         _mint(msg.sender, _mintAmount);
2564     }
2565 
2566     // whitelist mint
2567     function WLmint(bytes32[] calldata proof, uint256 _mintAmount)
2568         external
2569         payable
2570     {
2571         if (_paused) revert Paused();
2572         if (totalSupply() + _mintAmount > _maxSupply) revert ExceedsMaxSupply();
2573 
2574         if (!whitelistMint) revert WhitelistEnd();
2575 
2576         uint256 wlMints = _walletMintedCountWl[msg.sender];
2577         if (_mintAmount + wlMints > _maxPerUserWl) revert ExceedsMaxPerUser();
2578 
2579         if (msg.value < _mintAmount * _mintPriceWl) revert InsufficientFunds();
2580 
2581         if (!MerkleProofLib.verify(proof, _MerkleRoot, _leaf()))
2582             revert NotWhitelisted();
2583 
2584         _walletMintedCountWl[msg.sender] += _mintAmount;
2585         _mint(msg.sender, _mintAmount);
2586     }
2587 
2588     function tokenURI(uint256 tokenId)
2589         public
2590         view
2591         virtual
2592         override(ERC721A, IERC721A)
2593         returns (string memory)
2594     {
2595         require(
2596             _exists(tokenId),
2597             "ERC721Metadata: URI query for nonexistent token"
2598         );
2599 
2600         if (!_revealed) {
2601             return _notRevealedUri;
2602         }
2603 
2604         string memory currentBaseURI = _baseURI();
2605         return
2606             bytes(currentBaseURI).length > 0
2607                 ? string(
2608                     abi.encodePacked(
2609                         currentBaseURI,
2610                         tokenId.toString(),
2611                         _baseExtension
2612                     )
2613                 )
2614                 : "";
2615     }
2616 
2617     //GETTERS
2618     function _leaf() internal view returns (bytes32) {
2619         return keccak256(abi.encodePacked(msg.sender));
2620     }
2621 
2622     //only owner
2623     function setMerkleRoot(bytes32 _NewMerkleRoot) external onlyOwner {
2624         _MerkleRoot = _NewMerkleRoot;
2625     }
2626 
2627     function reveal() external onlyOwner {
2628         _revealed = true;
2629     }
2630 
2631     function setNotRevealedURI(string memory _notRevealedURI)
2632         external
2633         onlyOwner
2634     {
2635         _notRevealedUri = _notRevealedURI;
2636     }
2637 
2638     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2639         baseURI = _newBaseURI;
2640     }
2641 
2642     function setBaseExtension(string memory _newBaseExtension)
2643         external
2644         onlyOwner
2645     {
2646         _baseExtension = _newBaseExtension;
2647     }
2648 
2649     function pause(bool _state) external onlyOwner {
2650         _paused = _state;
2651     }
2652 
2653     function setOnlyWhitelisted(bool _state) external onlyOwner {
2654         whitelistMint = _state;
2655     }
2656 
2657     function setMintPriceWl(uint256 _newMintPrice) external onlyOwner {
2658         _mintPriceWl = _newMintPrice;
2659     }
2660 
2661     function setMintPricePublic(uint256 _newMintPrice) external onlyOwner {
2662         _mintPricePublic = _newMintPrice;
2663     }
2664 
2665     function setMaxPerUserWl(uint256 _newMaxPerUser) external onlyOwner {
2666         _maxPerUserWl = _newMaxPerUser;
2667     }
2668 
2669     function setMaxPerUserPublic(uint256 _newMaxPerUser) external onlyOwner {
2670         _maxPerUserPublic = _newMaxPerUser;
2671     }
2672 
2673     function setMaxSupply(uint256 _newMaxSupply) external onlyOwner {
2674         _maxSupply = _newMaxSupply;
2675     }
2676 
2677     function withdrawAll() external onlyOwner nonReentrant {
2678         uint256 balance = address(this).balance;
2679 
2680         (bool os, ) = payable(owner()).call{value: balance}("");
2681         require(os, "Withdrawal failed");
2682     }
2683 
2684     // OPENSEA OPERATOR OVERRIDES (ROYALTIES)
2685 
2686     function transferFrom(
2687         address from,
2688         address to,
2689         uint256 tokenId
2690     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2691         super.transferFrom(from, to, tokenId);
2692     }
2693 
2694     function safeTransferFrom(
2695         address from,
2696         address to,
2697         uint256 tokenId
2698     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2699         super.safeTransferFrom(from, to, tokenId);
2700     }
2701 
2702     function safeTransferFrom(
2703         address from,
2704         address to,
2705         uint256 tokenId,
2706         bytes memory data
2707     ) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2708         super.safeTransferFrom(from, to, tokenId, data);
2709     }
2710 }
2711 
2712 library MerkleProofLib {
2713     /// @dev Returns whether `leaf` exists in the Merkle tree with `root`, given `proof`.
2714     function verify(
2715         bytes32[] calldata proof,
2716         bytes32 root,
2717         bytes32 leaf
2718     ) internal pure returns (bool isValid) {
2719         /// @solidity memory-safe-assembly
2720         assembly {
2721             if proof.length {
2722                 // Left shift by 5 is equivalent to multiplying by 0x20.
2723                 let end := add(proof.offset, shl(5, proof.length))
2724                 // Initialize `offset` to the offset of `proof` in the calldata.
2725                 let offset := proof.offset
2726                 // Iterate over proof elements to compute root hash.
2727                 // prettier-ignore
2728                 for {} 1 {} {
2729                     // Slot of `leaf` in scratch space.
2730                     // If the condition is true: 0x20, otherwise: 0x00.
2731                     let scratch := shl(5, gt(leaf, calldataload(offset)))
2732                     // Store elements to hash contiguously in scratch space.
2733                     // Scratch space is 64 bytes (0x00 - 0x3f) and both elements are 32 bytes.
2734                     mstore(scratch, leaf)
2735                     mstore(xor(scratch, 0x20), calldataload(offset))
2736                     // Reuse `leaf` to store the hash to reduce stack operations.
2737                     leaf := keccak256(0x00, 0x40)
2738                     offset := add(offset, 0x20)
2739                     // prettier-ignore
2740                     if iszero(lt(offset, end)) { break }
2741                 }
2742             }
2743             isValid := eq(leaf, root)
2744         }
2745     }
2746 
2747     /// @dev Returns whether all `leafs` exist in the Merkle tree with `root`,
2748     /// given `proof` and `flags`.
2749     function verifyMultiProof(
2750         bytes32[] calldata proof,
2751         bytes32 root,
2752         bytes32[] calldata leafs,
2753         bool[] calldata flags
2754     ) internal pure returns (bool isValid) {
2755         // Rebuilds the root by consuming and producing values on a queue.
2756         // The queue starts with the `leafs` array, and goes into a `hashes` array.
2757         // After the process, the last element on the queue is verified
2758         // to be equal to the `root`.
2759         //
2760         // The `flags` array denotes whether the sibling
2761         // should be popped from the queue (`flag == true`), or
2762         // should be popped from the `proof` (`flag == false`).
2763         /// @solidity memory-safe-assembly
2764         assembly {
2765             // If the number of flags is correct.
2766             // prettier-ignore
2767             for {} eq(add(leafs.length, proof.length), add(flags.length, 1)) {} {
2768 
2769                 // For the case where `proof.length + leafs.length == 1`.
2770                 if iszero(flags.length) {
2771                     // `isValid = (proof.length == 1 ? proof[0] : leafs[0]) == root`.
2772                     isValid := eq(
2773                         calldataload(
2774                             xor(leafs.offset, mul(xor(proof.offset, leafs.offset), proof.length))
2775                         ),
2776                         root
2777                     )
2778                     break
2779                 }
2780 
2781                 // We can use the free memory space for the queue.
2782                 // We don't need to allocate, since the queue is temporary.
2783                 let hashesFront := mload(0x40)
2784                 // Copy the leafs into the hashes.
2785                 // Sometimes, a little memory expansion costs less than branching.
2786                 // Should cost less, even with a high free memory offset of 0x7d00.
2787                 // Left shift by 5 is equivalent to multiplying by 0x20.
2788                 calldatacopy(hashesFront, leafs.offset, shl(5, leafs.length))
2789                 // Compute the back of the hashes.
2790                 let hashesBack := add(hashesFront, shl(5, leafs.length))
2791                 // This is the end of the memory for the queue.
2792                 // We recycle `flags.length` to save on stack variables
2793                 // (this trick may not always save gas).
2794                 flags.length := add(hashesBack, shl(5, flags.length))
2795 
2796                 // We don't need to make a copy of `proof.offset` or `flags.offset`,
2797                 // as they are pass-by-value (this trick may not always save gas).
2798 
2799                 // prettier-ignore
2800                 for {} 1 {} {
2801                     // Pop from `hashes`.
2802                     let a := mload(hashesFront)
2803                     // Pop from `hashes`.
2804                     let b := mload(add(hashesFront, 0x20))
2805                     hashesFront := add(hashesFront, 0x40)
2806 
2807                     // If the flag is false, load the next proof,
2808                     // else, pops from the queue.
2809                     if iszero(calldataload(flags.offset)) {
2810                         // Loads the next proof.
2811                         b := calldataload(proof.offset)
2812                         proof.offset := add(proof.offset, 0x20)
2813                         // Unpop from `hashes`.
2814                         hashesFront := sub(hashesFront, 0x20)
2815                     }
2816                     
2817                     // Advance to the next flag offset.
2818                     flags.offset := add(flags.offset, 0x20)
2819 
2820                     // Slot of `a` in scratch space.
2821                     // If the condition is true: 0x20, otherwise: 0x00.
2822                     let scratch := shl(5, gt(a, b))
2823                     // Hash the scratch space and push the result onto the queue.
2824                     mstore(scratch, a)
2825                     mstore(xor(scratch, 0x20), b)
2826                     mstore(hashesBack, keccak256(0x00, 0x40))
2827                     hashesBack := add(hashesBack, 0x20)
2828                     // prettier-ignore
2829                     if iszero(lt(hashesBack, flags.length)) { break }
2830                 }
2831                 // Checks if the last value in the queue is same as the root.
2832                 isValid := eq(mload(sub(hashesBack, 0x20)), root)
2833                 break
2834             }
2835         }
2836     }
2837 }