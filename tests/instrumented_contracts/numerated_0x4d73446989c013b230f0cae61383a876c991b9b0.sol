1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
27 
28 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(
48         address indexed previousOwner,
49         address indexed newOwner
50     );
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         _checkOwner();
64         _;
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if the sender is not the owner.
76      */
77     function _checkOwner() internal view virtual {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(
98             newOwner != address(0),
99             "Ownable: new owner is the zero address"
100         );
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.0
116 
117 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Contract module that helps prevent reentrant calls to a function.
123  *
124  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
125  * available, which can be applied to functions to make sure there are no nested
126  * (reentrant) calls to them.
127  *
128  * Note that because there is a single `nonReentrant` guard, functions marked as
129  * `nonReentrant` may not call one another. This can be worked around by making
130  * those functions `private`, and then adding `external` `nonReentrant` entry
131  * points to them.
132  *
133  * TIP: If you would like to learn more about reentrancy and alternative ways
134  * to protect against it, check out our blog post
135  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
136  */
137 abstract contract ReentrancyGuard {
138     // Booleans are more expensive than uint256 or any type that takes up a full
139     // word because each write operation emits an extra SLOAD to first read the
140     // slot's contents, replace the bits taken up by the boolean, and then write
141     // back. This is the compiler's defense against contract upgrades and
142     // pointer aliasing, and it cannot be disabled.
143 
144     // The values being non-zero value makes deployment a bit more expensive,
145     // but in exchange the refund on every call to nonReentrant will be lower in
146     // amount. Since refunds are capped to a percentage of the total
147     // transaction's gas, it is best to keep them low in cases like this one, to
148     // increase the likelihood of the full refund coming into effect.
149     uint256 private constant _NOT_ENTERED = 1;
150     uint256 private constant _ENTERED = 2;
151 
152     uint256 private _status;
153 
154     constructor() {
155         _status = _NOT_ENTERED;
156     }
157 
158     /**
159      * @dev Prevents a contract from calling itself, directly or indirectly.
160      * Calling a `nonReentrant` function from another `nonReentrant`
161      * function is not supported. It is possible to prevent this from happening
162      * by making the `nonReentrant` function external, and making it call a
163      * `private` function that does the actual work.
164      */
165     modifier nonReentrant() {
166         _nonReentrantBefore();
167         _;
168         _nonReentrantAfter();
169     }
170 
171     function _nonReentrantBefore() private {
172         // On the first call to nonReentrant, _status will be _NOT_ENTERED
173         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
174 
175         // Any calls to nonReentrant after this point will fail
176         _status = _ENTERED;
177     }
178 
179     function _nonReentrantAfter() private {
180         // By storing the original value once again, a refund is triggered (see
181         // https://eips.ethereum.org/EIPS/eip-2200)
182         _status = _NOT_ENTERED;
183     }
184 }
185 
186 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
187 
188 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @dev Standard math utilities missing in the Solidity language.
194  */
195 library Math {
196     enum Rounding {
197         Down, // Toward negative infinity
198         Up, // Toward infinity
199         Zero // Toward zero
200     }
201 
202     /**
203      * @dev Returns the largest of two numbers.
204      */
205     function max(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a > b ? a : b;
207     }
208 
209     /**
210      * @dev Returns the smallest of two numbers.
211      */
212     function min(uint256 a, uint256 b) internal pure returns (uint256) {
213         return a < b ? a : b;
214     }
215 
216     /**
217      * @dev Returns the average of two numbers. The result is rounded towards
218      * zero.
219      */
220     function average(uint256 a, uint256 b) internal pure returns (uint256) {
221         // (a + b) / 2 can overflow.
222         return (a & b) + (a ^ b) / 2;
223     }
224 
225     /**
226      * @dev Returns the ceiling of the division of two numbers.
227      *
228      * This differs from standard division with `/` in that it rounds up instead
229      * of rounding down.
230      */
231     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
232         // (a + b - 1) / b can overflow on addition, so we distribute.
233         return a == 0 ? 0 : (a - 1) / b + 1;
234     }
235 
236     /**
237      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
238      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
239      * with further edits by Uniswap Labs also under MIT license.
240      */
241     function mulDiv(
242         uint256 x,
243         uint256 y,
244         uint256 denominator
245     ) internal pure returns (uint256 result) {
246         unchecked {
247             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
248             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
249             // variables such that product = prod1 * 2^256 + prod0.
250             uint256 prod0; // Least significant 256 bits of the product
251             uint256 prod1; // Most significant 256 bits of the product
252             assembly {
253                 let mm := mulmod(x, y, not(0))
254                 prod0 := mul(x, y)
255                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
256             }
257 
258             // Handle non-overflow cases, 256 by 256 division.
259             if (prod1 == 0) {
260                 return prod0 / denominator;
261             }
262 
263             // Make sure the result is less than 2^256. Also prevents denominator == 0.
264             require(denominator > prod1);
265 
266             ///////////////////////////////////////////////
267             // 512 by 256 division.
268             ///////////////////////////////////////////////
269 
270             // Make division exact by subtracting the remainder from [prod1 prod0].
271             uint256 remainder;
272             assembly {
273                 // Compute remainder using mulmod.
274                 remainder := mulmod(x, y, denominator)
275 
276                 // Subtract 256 bit number from 512 bit number.
277                 prod1 := sub(prod1, gt(remainder, prod0))
278                 prod0 := sub(prod0, remainder)
279             }
280 
281             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
282             // See https://cs.stackexchange.com/q/138556/92363.
283 
284             // Does not overflow because the denominator cannot be zero at this stage in the function.
285             uint256 twos = denominator & (~denominator + 1);
286             assembly {
287                 // Divide denominator by twos.
288                 denominator := div(denominator, twos)
289 
290                 // Divide [prod1 prod0] by twos.
291                 prod0 := div(prod0, twos)
292 
293                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
294                 twos := add(div(sub(0, twos), twos), 1)
295             }
296 
297             // Shift in bits from prod1 into prod0.
298             prod0 |= prod1 * twos;
299 
300             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
301             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
302             // four bits. That is, denominator * inv = 1 mod 2^4.
303             uint256 inverse = (3 * denominator) ^ 2;
304 
305             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
306             // in modular arithmetic, doubling the correct bits in each step.
307             inverse *= 2 - denominator * inverse; // inverse mod 2^8
308             inverse *= 2 - denominator * inverse; // inverse mod 2^16
309             inverse *= 2 - denominator * inverse; // inverse mod 2^32
310             inverse *= 2 - denominator * inverse; // inverse mod 2^64
311             inverse *= 2 - denominator * inverse; // inverse mod 2^128
312             inverse *= 2 - denominator * inverse; // inverse mod 2^256
313 
314             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
315             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
316             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
317             // is no longer required.
318             result = prod0 * inverse;
319             return result;
320         }
321     }
322 
323     /**
324      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
325      */
326     function mulDiv(
327         uint256 x,
328         uint256 y,
329         uint256 denominator,
330         Rounding rounding
331     ) internal pure returns (uint256) {
332         uint256 result = mulDiv(x, y, denominator);
333         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
334             result += 1;
335         }
336         return result;
337     }
338 
339     /**
340      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
341      *
342      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
343      */
344     function sqrt(uint256 a) internal pure returns (uint256) {
345         if (a == 0) {
346             return 0;
347         }
348 
349         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
350         //
351         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
352         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
353         //
354         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
355         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
356         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
357         //
358         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
359         uint256 result = 1 << (log2(a) >> 1);
360 
361         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
362         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
363         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
364         // into the expected uint128 result.
365         unchecked {
366             result = (result + a / result) >> 1;
367             result = (result + a / result) >> 1;
368             result = (result + a / result) >> 1;
369             result = (result + a / result) >> 1;
370             result = (result + a / result) >> 1;
371             result = (result + a / result) >> 1;
372             result = (result + a / result) >> 1;
373             return min(result, a / result);
374         }
375     }
376 
377     /**
378      * @notice Calculates sqrt(a), following the selected rounding direction.
379      */
380     function sqrt(uint256 a, Rounding rounding)
381         internal
382         pure
383         returns (uint256)
384     {
385         unchecked {
386             uint256 result = sqrt(a);
387             return
388                 result +
389                 (rounding == Rounding.Up && result * result < a ? 1 : 0);
390         }
391     }
392 
393     /**
394      * @dev Return the log in base 2, rounded down, of a positive value.
395      * Returns 0 if given 0.
396      */
397     function log2(uint256 value) internal pure returns (uint256) {
398         uint256 result = 0;
399         unchecked {
400             if (value >> 128 > 0) {
401                 value >>= 128;
402                 result += 128;
403             }
404             if (value >> 64 > 0) {
405                 value >>= 64;
406                 result += 64;
407             }
408             if (value >> 32 > 0) {
409                 value >>= 32;
410                 result += 32;
411             }
412             if (value >> 16 > 0) {
413                 value >>= 16;
414                 result += 16;
415             }
416             if (value >> 8 > 0) {
417                 value >>= 8;
418                 result += 8;
419             }
420             if (value >> 4 > 0) {
421                 value >>= 4;
422                 result += 4;
423             }
424             if (value >> 2 > 0) {
425                 value >>= 2;
426                 result += 2;
427             }
428             if (value >> 1 > 0) {
429                 result += 1;
430             }
431         }
432         return result;
433     }
434 
435     /**
436      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
437      * Returns 0 if given 0.
438      */
439     function log2(uint256 value, Rounding rounding)
440         internal
441         pure
442         returns (uint256)
443     {
444         unchecked {
445             uint256 result = log2(value);
446             return
447                 result +
448                 (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
449         }
450     }
451 
452     /**
453      * @dev Return the log in base 10, rounded down, of a positive value.
454      * Returns 0 if given 0.
455      */
456     function log10(uint256 value) internal pure returns (uint256) {
457         uint256 result = 0;
458         unchecked {
459             if (value >= 10**64) {
460                 value /= 10**64;
461                 result += 64;
462             }
463             if (value >= 10**32) {
464                 value /= 10**32;
465                 result += 32;
466             }
467             if (value >= 10**16) {
468                 value /= 10**16;
469                 result += 16;
470             }
471             if (value >= 10**8) {
472                 value /= 10**8;
473                 result += 8;
474             }
475             if (value >= 10**4) {
476                 value /= 10**4;
477                 result += 4;
478             }
479             if (value >= 10**2) {
480                 value /= 10**2;
481                 result += 2;
482             }
483             if (value >= 10**1) {
484                 result += 1;
485             }
486         }
487         return result;
488     }
489 
490     /**
491      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
492      * Returns 0 if given 0.
493      */
494     function log10(uint256 value, Rounding rounding)
495         internal
496         pure
497         returns (uint256)
498     {
499         unchecked {
500             uint256 result = log10(value);
501             return
502                 result +
503                 (rounding == Rounding.Up && 10**result < value ? 1 : 0);
504         }
505     }
506 
507     /**
508      * @dev Return the log in base 256, rounded down, of a positive value.
509      * Returns 0 if given 0.
510      *
511      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
512      */
513     function log256(uint256 value) internal pure returns (uint256) {
514         uint256 result = 0;
515         unchecked {
516             if (value >> 128 > 0) {
517                 value >>= 128;
518                 result += 16;
519             }
520             if (value >> 64 > 0) {
521                 value >>= 64;
522                 result += 8;
523             }
524             if (value >> 32 > 0) {
525                 value >>= 32;
526                 result += 4;
527             }
528             if (value >> 16 > 0) {
529                 value >>= 16;
530                 result += 2;
531             }
532             if (value >> 8 > 0) {
533                 result += 1;
534             }
535         }
536         return result;
537     }
538 
539     /**
540      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
541      * Returns 0 if given 0.
542      */
543     function log256(uint256 value, Rounding rounding)
544         internal
545         pure
546         returns (uint256)
547     {
548         unchecked {
549             uint256 result = log256(value);
550             return
551                 result +
552                 (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
553         }
554     }
555 }
556 
557 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
558 
559 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev String operations.
565  */
566 library Strings {
567     bytes16 private constant _SYMBOLS = "0123456789abcdef";
568     uint8 private constant _ADDRESS_LENGTH = 20;
569 
570     /**
571      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
572      */
573     function toString(uint256 value) internal pure returns (string memory) {
574         unchecked {
575             uint256 length = Math.log10(value) + 1;
576             string memory buffer = new string(length);
577             uint256 ptr;
578             /// @solidity memory-safe-assembly
579             assembly {
580                 ptr := add(buffer, add(32, length))
581             }
582             while (true) {
583                 ptr--;
584                 /// @solidity memory-safe-assembly
585                 assembly {
586                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
587                 }
588                 value /= 10;
589                 if (value == 0) break;
590             }
591             return buffer;
592         }
593     }
594 
595     /**
596      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
597      */
598     function toHexString(uint256 value) internal pure returns (string memory) {
599         unchecked {
600             return toHexString(value, Math.log256(value) + 1);
601         }
602     }
603 
604     /**
605      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
606      */
607     function toHexString(uint256 value, uint256 length)
608         internal
609         pure
610         returns (string memory)
611     {
612         bytes memory buffer = new bytes(2 * length + 2);
613         buffer[0] = "0";
614         buffer[1] = "x";
615         for (uint256 i = 2 * length + 1; i > 1; --i) {
616             buffer[i] = _SYMBOLS[value & 0xf];
617             value >>= 4;
618         }
619         require(value == 0, "Strings: hex length insufficient");
620         return string(buffer);
621     }
622 
623     /**
624      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
625      */
626     function toHexString(address addr) internal pure returns (string memory) {
627         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
628     }
629 }
630 
631 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0
632 
633 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 /**
638  * @dev Interface of the ERC165 standard, as defined in the
639  * https://eips.ethereum.org/EIPS/eip-165[EIP].
640  *
641  * Implementers can declare support of contract interfaces, which can then be
642  * queried by others ({ERC165Checker}).
643  *
644  * For an implementation, see {ERC165}.
645  */
646 interface IERC165 {
647     /**
648      * @dev Returns true if this contract implements the interface defined by
649      * `interfaceId`. See the corresponding
650      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
651      * to learn more about how these ids are created.
652      *
653      * This function call must use less than 30 000 gas.
654      */
655     function supportsInterface(bytes4 interfaceId) external view returns (bool);
656 }
657 
658 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.0
659 
660 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @dev Implementation of the {IERC165} interface.
666  *
667  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
668  * for the additional interface id that will be supported. For example:
669  *
670  * ```solidity
671  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
672  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
673  * }
674  * ```
675  *
676  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
677  */
678 abstract contract ERC165 is IERC165 {
679     /**
680      * @dev See {IERC165-supportsInterface}.
681      */
682     function supportsInterface(bytes4 interfaceId)
683         public
684         view
685         virtual
686         override
687         returns (bool)
688     {
689         return interfaceId == type(IERC165).interfaceId;
690     }
691 }
692 
693 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.0
694 
695 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @dev Required interface of an ERC721 compliant contract.
701  */
702 interface IERC721 is IERC165 {
703     /**
704      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
705      */
706     event Transfer(
707         address indexed from,
708         address indexed to,
709         uint256 indexed tokenId
710     );
711 
712     /**
713      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
714      */
715     event Approval(
716         address indexed owner,
717         address indexed approved,
718         uint256 indexed tokenId
719     );
720 
721     /**
722      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
723      */
724     event ApprovalForAll(
725         address indexed owner,
726         address indexed operator,
727         bool approved
728     );
729 
730     /**
731      * @dev Returns the number of tokens in ``owner``'s account.
732      */
733     function balanceOf(address owner) external view returns (uint256 balance);
734 
735     /**
736      * @dev Returns the owner of the `tokenId` token.
737      *
738      * Requirements:
739      *
740      * - `tokenId` must exist.
741      */
742     function ownerOf(uint256 tokenId) external view returns (address owner);
743 
744     /**
745      * @dev Safely transfers `tokenId` token from `from` to `to`.
746      *
747      * Requirements:
748      *
749      * - `from` cannot be the zero address.
750      * - `to` cannot be the zero address.
751      * - `tokenId` token must exist and be owned by `from`.
752      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
753      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
754      *
755      * Emits a {Transfer} event.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes calldata data
762     ) external;
763 
764     /**
765      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
766      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must exist and be owned by `from`.
773      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 tokenId
782     ) external;
783 
784     /**
785      * @dev Transfers `tokenId` token from `from` to `to`.
786      *
787      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
788      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
789      * understand this adds an external call which potentially creates a reentrancy vulnerability.
790      *
791      * Requirements:
792      *
793      * - `from` cannot be the zero address.
794      * - `to` cannot be the zero address.
795      * - `tokenId` token must be owned by `from`.
796      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
797      *
798      * Emits a {Transfer} event.
799      */
800     function transferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) external;
805 
806     /**
807      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
808      * The approval is cleared when the token is transferred.
809      *
810      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
811      *
812      * Requirements:
813      *
814      * - The caller must own the token or be an approved operator.
815      * - `tokenId` must exist.
816      *
817      * Emits an {Approval} event.
818      */
819     function approve(address to, uint256 tokenId) external;
820 
821     /**
822      * @dev Approve or remove `operator` as an operator for the caller.
823      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
824      *
825      * Requirements:
826      *
827      * - The `operator` cannot be the caller.
828      *
829      * Emits an {ApprovalForAll} event.
830      */
831     function setApprovalForAll(address operator, bool _approved) external;
832 
833     /**
834      * @dev Returns the account approved for `tokenId` token.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      */
840     function getApproved(uint256 tokenId)
841         external
842         view
843         returns (address operator);
844 
845     /**
846      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
847      *
848      * See {setApprovalForAll}
849      */
850     function isApprovedForAll(address owner, address operator)
851         external
852         view
853         returns (bool);
854 }
855 
856 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.0
857 
858 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
859 
860 pragma solidity ^0.8.0;
861 
862 /**
863  * @title ERC721 token receiver interface
864  * @dev Interface for any contract that wants to support safeTransfers
865  * from ERC721 asset contracts.
866  */
867 interface IERC721Receiver {
868     /**
869      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
870      * by `operator` from `from`, this function is called.
871      *
872      * It must return its Solidity selector to confirm the token transfer.
873      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
874      *
875      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
876      */
877     function onERC721Received(
878         address operator,
879         address from,
880         uint256 tokenId,
881         bytes calldata data
882     ) external returns (bytes4);
883 }
884 
885 // File @openzeppelin/contracts/utils/Address.sol@v4.8.0
886 
887 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
888 
889 pragma solidity ^0.8.1;
890 
891 /**
892  * @dev Collection of functions related to the address type
893  */
894 library Address {
895     /**
896      * @dev Returns true if `account` is a contract.
897      *
898      * [IMPORTANT]
899      * ====
900      * It is unsafe to assume that an address for which this function returns
901      * false is an externally-owned account (EOA) and not a contract.
902      *
903      * Among others, `isContract` will return false for the following
904      * types of addresses:
905      *
906      *  - an externally-owned account
907      *  - a contract in construction
908      *  - an address where a contract will be created
909      *  - an address where a contract lived, but was destroyed
910      * ====
911      *
912      * [IMPORTANT]
913      * ====
914      * You shouldn't rely on `isContract` to protect against flash loan attacks!
915      *
916      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
917      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
918      * constructor.
919      * ====
920      */
921     function isContract(address account) internal view returns (bool) {
922         // This method relies on extcodesize/address.code.length, which returns 0
923         // for contracts in construction, since the code is only stored at the end
924         // of the constructor execution.
925 
926         return account.code.length > 0;
927     }
928 
929     /**
930      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
931      * `recipient`, forwarding all available gas and reverting on errors.
932      *
933      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
934      * of certain opcodes, possibly making contracts go over the 2300 gas limit
935      * imposed by `transfer`, making them unable to receive funds via
936      * `transfer`. {sendValue} removes this limitation.
937      *
938      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
939      *
940      * IMPORTANT: because control is transferred to `recipient`, care must be
941      * taken to not create reentrancy vulnerabilities. Consider using
942      * {ReentrancyGuard} or the
943      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
944      */
945     function sendValue(address payable recipient, uint256 amount) internal {
946         require(
947             address(this).balance >= amount,
948             "Address: insufficient balance"
949         );
950 
951         (bool success, ) = recipient.call{value: amount}("");
952         require(
953             success,
954             "Address: unable to send value, recipient may have reverted"
955         );
956     }
957 
958     /**
959      * @dev Performs a Solidity function call using a low level `call`. A
960      * plain `call` is an unsafe replacement for a function call: use this
961      * function instead.
962      *
963      * If `target` reverts with a revert reason, it is bubbled up by this
964      * function (like regular Solidity function calls).
965      *
966      * Returns the raw returned data. To convert to the expected return value,
967      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
968      *
969      * Requirements:
970      *
971      * - `target` must be a contract.
972      * - calling `target` with `data` must not revert.
973      *
974      * _Available since v3.1._
975      */
976     function functionCall(address target, bytes memory data)
977         internal
978         returns (bytes memory)
979     {
980         return
981             functionCallWithValue(
982                 target,
983                 data,
984                 0,
985                 "Address: low-level call failed"
986             );
987     }
988 
989     /**
990      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
991      * `errorMessage` as a fallback revert reason when `target` reverts.
992      *
993      * _Available since v3.1._
994      */
995     function functionCall(
996         address target,
997         bytes memory data,
998         string memory errorMessage
999     ) internal returns (bytes memory) {
1000         return functionCallWithValue(target, data, 0, errorMessage);
1001     }
1002 
1003     /**
1004      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1005      * but also transferring `value` wei to `target`.
1006      *
1007      * Requirements:
1008      *
1009      * - the calling contract must have an ETH balance of at least `value`.
1010      * - the called Solidity function must be `payable`.
1011      *
1012      * _Available since v3.1._
1013      */
1014     function functionCallWithValue(
1015         address target,
1016         bytes memory data,
1017         uint256 value
1018     ) internal returns (bytes memory) {
1019         return
1020             functionCallWithValue(
1021                 target,
1022                 data,
1023                 value,
1024                 "Address: low-level call with value failed"
1025             );
1026     }
1027 
1028     /**
1029      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1030      * with `errorMessage` as a fallback revert reason when `target` reverts.
1031      *
1032      * _Available since v3.1._
1033      */
1034     function functionCallWithValue(
1035         address target,
1036         bytes memory data,
1037         uint256 value,
1038         string memory errorMessage
1039     ) internal returns (bytes memory) {
1040         require(
1041             address(this).balance >= value,
1042             "Address: insufficient balance for call"
1043         );
1044         (bool success, bytes memory returndata) = target.call{value: value}(
1045             data
1046         );
1047         return
1048             verifyCallResultFromTarget(
1049                 target,
1050                 success,
1051                 returndata,
1052                 errorMessage
1053             );
1054     }
1055 
1056     /**
1057      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1058      * but performing a static call.
1059      *
1060      * _Available since v3.3._
1061      */
1062     function functionStaticCall(address target, bytes memory data)
1063         internal
1064         view
1065         returns (bytes memory)
1066     {
1067         return
1068             functionStaticCall(
1069                 target,
1070                 data,
1071                 "Address: low-level static call failed"
1072             );
1073     }
1074 
1075     /**
1076      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1077      * but performing a static call.
1078      *
1079      * _Available since v3.3._
1080      */
1081     function functionStaticCall(
1082         address target,
1083         bytes memory data,
1084         string memory errorMessage
1085     ) internal view returns (bytes memory) {
1086         (bool success, bytes memory returndata) = target.staticcall(data);
1087         return
1088             verifyCallResultFromTarget(
1089                 target,
1090                 success,
1091                 returndata,
1092                 errorMessage
1093             );
1094     }
1095 
1096     /**
1097      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1098      * but performing a delegate call.
1099      *
1100      * _Available since v3.4._
1101      */
1102     function functionDelegateCall(address target, bytes memory data)
1103         internal
1104         returns (bytes memory)
1105     {
1106         return
1107             functionDelegateCall(
1108                 target,
1109                 data,
1110                 "Address: low-level delegate call failed"
1111             );
1112     }
1113 
1114     /**
1115      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1116      * but performing a delegate call.
1117      *
1118      * _Available since v3.4._
1119      */
1120     function functionDelegateCall(
1121         address target,
1122         bytes memory data,
1123         string memory errorMessage
1124     ) internal returns (bytes memory) {
1125         (bool success, bytes memory returndata) = target.delegatecall(data);
1126         return
1127             verifyCallResultFromTarget(
1128                 target,
1129                 success,
1130                 returndata,
1131                 errorMessage
1132             );
1133     }
1134 
1135     /**
1136      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1137      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1138      *
1139      * _Available since v4.8._
1140      */
1141     function verifyCallResultFromTarget(
1142         address target,
1143         bool success,
1144         bytes memory returndata,
1145         string memory errorMessage
1146     ) internal view returns (bytes memory) {
1147         if (success) {
1148             if (returndata.length == 0) {
1149                 // only check isContract if the call was successful and the return data is empty
1150                 // otherwise we already know that it was a contract
1151                 require(isContract(target), "Address: call to non-contract");
1152             }
1153             return returndata;
1154         } else {
1155             _revert(returndata, errorMessage);
1156         }
1157     }
1158 
1159     /**
1160      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1161      * revert reason or using the provided one.
1162      *
1163      * _Available since v4.3._
1164      */
1165     function verifyCallResult(
1166         bool success,
1167         bytes memory returndata,
1168         string memory errorMessage
1169     ) internal pure returns (bytes memory) {
1170         if (success) {
1171             return returndata;
1172         } else {
1173             _revert(returndata, errorMessage);
1174         }
1175     }
1176 
1177     function _revert(bytes memory returndata, string memory errorMessage)
1178         private
1179         pure
1180     {
1181         // Look for revert reason and bubble it up if present
1182         if (returndata.length > 0) {
1183             // The easiest way to bubble the revert reason is using memory via assembly
1184             /// @solidity memory-safe-assembly
1185             assembly {
1186                 let returndata_size := mload(returndata)
1187                 revert(add(32, returndata), returndata_size)
1188             }
1189         } else {
1190             revert(errorMessage);
1191         }
1192     }
1193 }
1194 
1195 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.8.0
1196 
1197 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1198 
1199 pragma solidity ^0.8.0;
1200 
1201 /**
1202  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1203  * @dev See https://eips.ethereum.org/EIPS/eip-721
1204  */
1205 interface IERC721Metadata is IERC721 {
1206     /**
1207      * @dev Returns the token collection name.
1208      */
1209     function name() external view returns (string memory);
1210 
1211     /**
1212      * @dev Returns the token collection symbol.
1213      */
1214     function symbol() external view returns (string memory);
1215 
1216     /**
1217      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1218      */
1219     function tokenURI(uint256 tokenId) external view returns (string memory);
1220 }
1221 
1222 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.8.0
1223 
1224 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 /**
1229  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1230  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1231  * {ERC721Enumerable}.
1232  */
1233 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1234     using Address for address;
1235     using Strings for uint256;
1236 
1237     // Token name
1238     string private _name;
1239 
1240     // Token symbol
1241     string private _symbol;
1242 
1243     // Mapping from token ID to owner address
1244     mapping(uint256 => address) private _owners;
1245 
1246     // Mapping owner address to token count
1247     mapping(address => uint256) private _balances;
1248 
1249     // Mapping from token ID to approved address
1250     mapping(uint256 => address) private _tokenApprovals;
1251 
1252     // Mapping from owner to operator approvals
1253     mapping(address => mapping(address => bool)) private _operatorApprovals;
1254 
1255     /**
1256      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1257      */
1258     constructor(string memory name_, string memory symbol_) {
1259         _name = name_;
1260         _symbol = symbol_;
1261     }
1262 
1263     /**
1264      * @dev See {IERC165-supportsInterface}.
1265      */
1266     function supportsInterface(bytes4 interfaceId)
1267         public
1268         view
1269         virtual
1270         override(ERC165, IERC165)
1271         returns (bool)
1272     {
1273         return
1274             interfaceId == type(IERC721).interfaceId ||
1275             interfaceId == type(IERC721Metadata).interfaceId ||
1276             super.supportsInterface(interfaceId);
1277     }
1278 
1279     /**
1280      * @dev See {IERC721-balanceOf}.
1281      */
1282     function balanceOf(address owner)
1283         public
1284         view
1285         virtual
1286         override
1287         returns (uint256)
1288     {
1289         require(
1290             owner != address(0),
1291             "ERC721: address zero is not a valid owner"
1292         );
1293         return _balances[owner];
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-ownerOf}.
1298      */
1299     function ownerOf(uint256 tokenId)
1300         public
1301         view
1302         virtual
1303         override
1304         returns (address)
1305     {
1306         address owner = _ownerOf(tokenId);
1307         require(owner != address(0), "ERC721: invalid token ID");
1308         return owner;
1309     }
1310 
1311     /**
1312      * @dev See {IERC721Metadata-name}.
1313      */
1314     function name() public view virtual override returns (string memory) {
1315         return _name;
1316     }
1317 
1318     /**
1319      * @dev See {IERC721Metadata-symbol}.
1320      */
1321     function symbol() public view virtual override returns (string memory) {
1322         return _symbol;
1323     }
1324 
1325     /**
1326      * @dev See {IERC721Metadata-tokenURI}.
1327      */
1328     function tokenURI(uint256 tokenId)
1329         public
1330         view
1331         virtual
1332         override
1333         returns (string memory)
1334     {
1335         _requireMinted(tokenId);
1336 
1337         string memory baseURI = _baseURI();
1338         return
1339             bytes(baseURI).length > 0
1340                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1341                 : "";
1342     }
1343 
1344     /**
1345      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1346      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1347      * by default, can be overridden in child contracts.
1348      */
1349     function _baseURI() internal view virtual returns (string memory) {
1350         return "";
1351     }
1352 
1353     /**
1354      * @dev See {IERC721-approve}.
1355      */
1356     function approve(address to, uint256 tokenId) public virtual override {
1357         address owner = ERC721.ownerOf(tokenId);
1358         require(to != owner, "ERC721: approval to current owner");
1359 
1360         require(
1361             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1362             "ERC721: approve caller is not token owner or approved for all"
1363         );
1364 
1365         _approve(to, tokenId);
1366     }
1367 
1368     /**
1369      * @dev See {IERC721-getApproved}.
1370      */
1371     function getApproved(uint256 tokenId)
1372         public
1373         view
1374         virtual
1375         override
1376         returns (address)
1377     {
1378         _requireMinted(tokenId);
1379 
1380         return _tokenApprovals[tokenId];
1381     }
1382 
1383     /**
1384      * @dev See {IERC721-setApprovalForAll}.
1385      */
1386     function setApprovalForAll(address operator, bool approved)
1387         public
1388         virtual
1389         override
1390     {
1391         _setApprovalForAll(_msgSender(), operator, approved);
1392     }
1393 
1394     /**
1395      * @dev See {IERC721-isApprovedForAll}.
1396      */
1397     function isApprovedForAll(address owner, address operator)
1398         public
1399         view
1400         virtual
1401         override
1402         returns (bool)
1403     {
1404         return _operatorApprovals[owner][operator];
1405     }
1406 
1407     /**
1408      * @dev See {IERC721-transferFrom}.
1409      */
1410     function transferFrom(
1411         address from,
1412         address to,
1413         uint256 tokenId
1414     ) public virtual override {
1415         //solhint-disable-next-line max-line-length
1416         require(
1417             _isApprovedOrOwner(_msgSender(), tokenId),
1418             "ERC721: caller is not token owner or approved"
1419         );
1420 
1421         _transfer(from, to, tokenId);
1422     }
1423 
1424     /**
1425      * @dev See {IERC721-safeTransferFrom}.
1426      */
1427     function safeTransferFrom(
1428         address from,
1429         address to,
1430         uint256 tokenId
1431     ) public virtual override {
1432         safeTransferFrom(from, to, tokenId, "");
1433     }
1434 
1435     /**
1436      * @dev See {IERC721-safeTransferFrom}.
1437      */
1438     function safeTransferFrom(
1439         address from,
1440         address to,
1441         uint256 tokenId,
1442         bytes memory data
1443     ) public virtual override {
1444         require(
1445             _isApprovedOrOwner(_msgSender(), tokenId),
1446             "ERC721: caller is not token owner or approved"
1447         );
1448         _safeTransfer(from, to, tokenId, data);
1449     }
1450 
1451     /**
1452      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1453      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1454      *
1455      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1456      *
1457      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1458      * implement alternative mechanisms to perform token transfer, such as signature-based.
1459      *
1460      * Requirements:
1461      *
1462      * - `from` cannot be the zero address.
1463      * - `to` cannot be the zero address.
1464      * - `tokenId` token must exist and be owned by `from`.
1465      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1466      *
1467      * Emits a {Transfer} event.
1468      */
1469     function _safeTransfer(
1470         address from,
1471         address to,
1472         uint256 tokenId,
1473         bytes memory data
1474     ) internal virtual {
1475         _transfer(from, to, tokenId);
1476         require(
1477             _checkOnERC721Received(from, to, tokenId, data),
1478             "ERC721: transfer to non ERC721Receiver implementer"
1479         );
1480     }
1481 
1482     /**
1483      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1484      */
1485     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1486         return _owners[tokenId];
1487     }
1488 
1489     /**
1490      * @dev Returns whether `tokenId` exists.
1491      *
1492      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1493      *
1494      * Tokens start existing when they are minted (`_mint`),
1495      * and stop existing when they are burned (`_burn`).
1496      */
1497     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1498         return _ownerOf(tokenId) != address(0);
1499     }
1500 
1501     /**
1502      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1503      *
1504      * Requirements:
1505      *
1506      * - `tokenId` must exist.
1507      */
1508     function _isApprovedOrOwner(address spender, uint256 tokenId)
1509         internal
1510         view
1511         virtual
1512         returns (bool)
1513     {
1514         address owner = ERC721.ownerOf(tokenId);
1515         return (spender == owner ||
1516             isApprovedForAll(owner, spender) ||
1517             getApproved(tokenId) == spender);
1518     }
1519 
1520     /**
1521      * @dev Safely mints `tokenId` and transfers it to `to`.
1522      *
1523      * Requirements:
1524      *
1525      * - `tokenId` must not exist.
1526      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1527      *
1528      * Emits a {Transfer} event.
1529      */
1530     function _safeMint(address to, uint256 tokenId) internal virtual {
1531         _safeMint(to, tokenId, "");
1532     }
1533 
1534     /**
1535      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1536      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1537      */
1538     function _safeMint(
1539         address to,
1540         uint256 tokenId,
1541         bytes memory data
1542     ) internal virtual {
1543         _mint(to, tokenId);
1544         require(
1545             _checkOnERC721Received(address(0), to, tokenId, data),
1546             "ERC721: transfer to non ERC721Receiver implementer"
1547         );
1548     }
1549 
1550     /**
1551      * @dev Mints `tokenId` and transfers it to `to`.
1552      *
1553      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1554      *
1555      * Requirements:
1556      *
1557      * - `tokenId` must not exist.
1558      * - `to` cannot be the zero address.
1559      *
1560      * Emits a {Transfer} event.
1561      */
1562     function _mint(address to, uint256 tokenId) internal virtual {
1563         require(to != address(0), "ERC721: mint to the zero address");
1564         require(!_exists(tokenId), "ERC721: token already minted");
1565 
1566         _beforeTokenTransfer(address(0), to, tokenId, 1);
1567 
1568         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1569         require(!_exists(tokenId), "ERC721: token already minted");
1570 
1571         unchecked {
1572             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1573             // Given that tokens are minted one by one, it is impossible in practice that
1574             // this ever happens. Might change if we allow batch minting.
1575             // The ERC fails to describe this case.
1576             _balances[to] += 1;
1577         }
1578 
1579         _owners[tokenId] = to;
1580 
1581         emit Transfer(address(0), to, tokenId);
1582 
1583         _afterTokenTransfer(address(0), to, tokenId, 1);
1584     }
1585 
1586     /**
1587      * @dev Destroys `tokenId`.
1588      * The approval is cleared when the token is burned.
1589      * This is an internal function that does not check if the sender is authorized to operate on the token.
1590      *
1591      * Requirements:
1592      *
1593      * - `tokenId` must exist.
1594      *
1595      * Emits a {Transfer} event.
1596      */
1597     function _burn(uint256 tokenId) internal virtual {
1598         address owner = ERC721.ownerOf(tokenId);
1599 
1600         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1601 
1602         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1603         owner = ERC721.ownerOf(tokenId);
1604 
1605         // Clear approvals
1606         delete _tokenApprovals[tokenId];
1607 
1608         unchecked {
1609             // Cannot overflow, as that would require more tokens to be burned/transferred
1610             // out than the owner initially received through minting and transferring in.
1611             _balances[owner] -= 1;
1612         }
1613         delete _owners[tokenId];
1614 
1615         emit Transfer(owner, address(0), tokenId);
1616 
1617         _afterTokenTransfer(owner, address(0), tokenId, 1);
1618     }
1619 
1620     /**
1621      * @dev Transfers `tokenId` from `from` to `to`.
1622      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1623      *
1624      * Requirements:
1625      *
1626      * - `to` cannot be the zero address.
1627      * - `tokenId` token must be owned by `from`.
1628      *
1629      * Emits a {Transfer} event.
1630      */
1631     function _transfer(
1632         address from,
1633         address to,
1634         uint256 tokenId
1635     ) internal virtual {
1636         require(
1637             ERC721.ownerOf(tokenId) == from,
1638             "ERC721: transfer from incorrect owner"
1639         );
1640         require(to != address(0), "ERC721: transfer to the zero address");
1641 
1642         _beforeTokenTransfer(from, to, tokenId, 1);
1643 
1644         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1645         require(
1646             ERC721.ownerOf(tokenId) == from,
1647             "ERC721: transfer from incorrect owner"
1648         );
1649 
1650         // Clear approvals from the previous owner
1651         delete _tokenApprovals[tokenId];
1652 
1653         unchecked {
1654             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1655             // `from`'s balance is the number of token held, which is at least one before the current
1656             // transfer.
1657             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1658             // all 2**256 token ids to be minted, which in practice is impossible.
1659             _balances[from] -= 1;
1660             _balances[to] += 1;
1661         }
1662         _owners[tokenId] = to;
1663 
1664         emit Transfer(from, to, tokenId);
1665 
1666         _afterTokenTransfer(from, to, tokenId, 1);
1667     }
1668 
1669     /**
1670      * @dev Approve `to` to operate on `tokenId`
1671      *
1672      * Emits an {Approval} event.
1673      */
1674     function _approve(address to, uint256 tokenId) internal virtual {
1675         _tokenApprovals[tokenId] = to;
1676         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1677     }
1678 
1679     /**
1680      * @dev Approve `operator` to operate on all of `owner` tokens
1681      *
1682      * Emits an {ApprovalForAll} event.
1683      */
1684     function _setApprovalForAll(
1685         address owner,
1686         address operator,
1687         bool approved
1688     ) internal virtual {
1689         require(owner != operator, "ERC721: approve to caller");
1690         _operatorApprovals[owner][operator] = approved;
1691         emit ApprovalForAll(owner, operator, approved);
1692     }
1693 
1694     /**
1695      * @dev Reverts if the `tokenId` has not been minted yet.
1696      */
1697     function _requireMinted(uint256 tokenId) internal view virtual {
1698         require(_exists(tokenId), "ERC721: invalid token ID");
1699     }
1700 
1701     /**
1702      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1703      * The call is not executed if the target address is not a contract.
1704      *
1705      * @param from address representing the previous owner of the given token ID
1706      * @param to target address that will receive the tokens
1707      * @param tokenId uint256 ID of the token to be transferred
1708      * @param data bytes optional data to send along with the call
1709      * @return bool whether the call correctly returned the expected magic value
1710      */
1711     function _checkOnERC721Received(
1712         address from,
1713         address to,
1714         uint256 tokenId,
1715         bytes memory data
1716     ) private returns (bool) {
1717         if (to.isContract()) {
1718             try
1719                 IERC721Receiver(to).onERC721Received(
1720                     _msgSender(),
1721                     from,
1722                     tokenId,
1723                     data
1724                 )
1725             returns (bytes4 retval) {
1726                 return retval == IERC721Receiver.onERC721Received.selector;
1727             } catch (bytes memory reason) {
1728                 if (reason.length == 0) {
1729                     revert(
1730                         "ERC721: transfer to non ERC721Receiver implementer"
1731                     );
1732                 } else {
1733                     /// @solidity memory-safe-assembly
1734                     assembly {
1735                         revert(add(32, reason), mload(reason))
1736                     }
1737                 }
1738             }
1739         } else {
1740             return true;
1741         }
1742     }
1743 
1744     /**
1745      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1746      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1747      *
1748      * Calling conditions:
1749      *
1750      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1751      * - When `from` is zero, the tokens will be minted for `to`.
1752      * - When `to` is zero, ``from``'s tokens will be burned.
1753      * - `from` and `to` are never both zero.
1754      * - `batchSize` is non-zero.
1755      *
1756      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1757      */
1758     function _beforeTokenTransfer(
1759         address from,
1760         address to,
1761         uint256, /* firstTokenId */
1762         uint256 batchSize
1763     ) internal virtual {
1764         if (batchSize > 1) {
1765             if (from != address(0)) {
1766                 _balances[from] -= batchSize;
1767             }
1768             if (to != address(0)) {
1769                 _balances[to] += batchSize;
1770             }
1771         }
1772     }
1773 
1774     /**
1775      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1776      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1777      *
1778      * Calling conditions:
1779      *
1780      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1781      * - When `from` is zero, the tokens were minted for `to`.
1782      * - When `to` is zero, ``from``'s tokens were burned.
1783      * - `from` and `to` are never both zero.
1784      * - `batchSize` is non-zero.
1785      *
1786      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1787      */
1788     function _afterTokenTransfer(
1789         address from,
1790         address to,
1791         uint256 firstTokenId,
1792         uint256 batchSize
1793     ) internal virtual {}
1794 }
1795 
1796 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.8.0
1797 
1798 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1799 
1800 pragma solidity ^0.8.0;
1801 
1802 /**
1803  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1804  * @dev See https://eips.ethereum.org/EIPS/eip-721
1805  */
1806 interface IERC721Enumerable is IERC721 {
1807     /**
1808      * @dev Returns the total amount of tokens stored by the contract.
1809      */
1810     function totalSupply() external view returns (uint256);
1811 
1812     /**
1813      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1814      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1815      */
1816     function tokenOfOwnerByIndex(address owner, uint256 index)
1817         external
1818         view
1819         returns (uint256);
1820 
1821     /**
1822      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1823      * Use along with {totalSupply} to enumerate all tokens.
1824      */
1825     function tokenByIndex(uint256 index) external view returns (uint256);
1826 }
1827 
1828 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.8.0
1829 
1830 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1831 
1832 pragma solidity ^0.8.0;
1833 
1834 /**
1835  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1836  * enumerability of all the token ids in the contract as well as all token ids owned by each
1837  * account.
1838  */
1839 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1840     // Mapping from owner to list of owned token IDs
1841     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1842 
1843     // Mapping from token ID to index of the owner tokens list
1844     mapping(uint256 => uint256) private _ownedTokensIndex;
1845 
1846     // Array with all token ids, used for enumeration
1847     uint256[] private _allTokens;
1848 
1849     // Mapping from token id to position in the allTokens array
1850     mapping(uint256 => uint256) private _allTokensIndex;
1851 
1852     /**
1853      * @dev See {IERC165-supportsInterface}.
1854      */
1855     function supportsInterface(bytes4 interfaceId)
1856         public
1857         view
1858         virtual
1859         override(IERC165, ERC721)
1860         returns (bool)
1861     {
1862         return
1863             interfaceId == type(IERC721Enumerable).interfaceId ||
1864             super.supportsInterface(interfaceId);
1865     }
1866 
1867     /**
1868      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1869      */
1870     function tokenOfOwnerByIndex(address owner, uint256 index)
1871         public
1872         view
1873         virtual
1874         override
1875         returns (uint256)
1876     {
1877         require(
1878             index < ERC721.balanceOf(owner),
1879             "ERC721Enumerable: owner index out of bounds"
1880         );
1881         return _ownedTokens[owner][index];
1882     }
1883 
1884     /**
1885      * @dev See {IERC721Enumerable-totalSupply}.
1886      */
1887     function totalSupply() public view virtual override returns (uint256) {
1888         return _allTokens.length;
1889     }
1890 
1891     /**
1892      * @dev See {IERC721Enumerable-tokenByIndex}.
1893      */
1894     function tokenByIndex(uint256 index)
1895         public
1896         view
1897         virtual
1898         override
1899         returns (uint256)
1900     {
1901         require(
1902             index < ERC721Enumerable.totalSupply(),
1903             "ERC721Enumerable: global index out of bounds"
1904         );
1905         return _allTokens[index];
1906     }
1907 
1908     /**
1909      * @dev See {ERC721-_beforeTokenTransfer}.
1910      */
1911     function _beforeTokenTransfer(
1912         address from,
1913         address to,
1914         uint256 firstTokenId,
1915         uint256 batchSize
1916     ) internal virtual override {
1917         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1918 
1919         if (batchSize > 1) {
1920             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1921             revert("ERC721Enumerable: consecutive transfers not supported");
1922         }
1923 
1924         uint256 tokenId = firstTokenId;
1925 
1926         if (from == address(0)) {
1927             _addTokenToAllTokensEnumeration(tokenId);
1928         } else if (from != to) {
1929             _removeTokenFromOwnerEnumeration(from, tokenId);
1930         }
1931         if (to == address(0)) {
1932             _removeTokenFromAllTokensEnumeration(tokenId);
1933         } else if (to != from) {
1934             _addTokenToOwnerEnumeration(to, tokenId);
1935         }
1936     }
1937 
1938     /**
1939      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1940      * @param to address representing the new owner of the given token ID
1941      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1942      */
1943     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1944         uint256 length = ERC721.balanceOf(to);
1945         _ownedTokens[to][length] = tokenId;
1946         _ownedTokensIndex[tokenId] = length;
1947     }
1948 
1949     /**
1950      * @dev Private function to add a token to this extension's token tracking data structures.
1951      * @param tokenId uint256 ID of the token to be added to the tokens list
1952      */
1953     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1954         _allTokensIndex[tokenId] = _allTokens.length;
1955         _allTokens.push(tokenId);
1956     }
1957 
1958     /**
1959      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1960      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1961      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1962      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1963      * @param from address representing the previous owner of the given token ID
1964      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1965      */
1966     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1967         private
1968     {
1969         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1970         // then delete the last slot (swap and pop).
1971 
1972         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1973         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1974 
1975         // When the token to delete is the last token, the swap operation is unnecessary
1976         if (tokenIndex != lastTokenIndex) {
1977             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1978 
1979             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1980             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1981         }
1982 
1983         // This also deletes the contents at the last position of the array
1984         delete _ownedTokensIndex[tokenId];
1985         delete _ownedTokens[from][lastTokenIndex];
1986     }
1987 
1988     /**
1989      * @dev Private function to remove a token from this extension's token tracking data structures.
1990      * This has O(1) time complexity, but alters the order of the _allTokens array.
1991      * @param tokenId uint256 ID of the token to be removed from the tokens list
1992      */
1993     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1994         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1995         // then delete the last slot (swap and pop).
1996 
1997         uint256 lastTokenIndex = _allTokens.length - 1;
1998         uint256 tokenIndex = _allTokensIndex[tokenId];
1999 
2000         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2001         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2002         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2003         uint256 lastTokenId = _allTokens[lastTokenIndex];
2004 
2005         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2006         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2007 
2008         // This also deletes the contents at the last position of the array
2009         delete _allTokensIndex[tokenId];
2010         _allTokens.pop();
2011     }
2012 }
2013 
2014 // File contracts/Soseiki.sol
2015 
2016 pragma solidity >=0.7.0 <0.9.0;
2017 
2018 contract Soseiki is ERC721Enumerable, Ownable {
2019     bool internal locked;
2020 
2021     modifier noReentrant() {
2022         require(!locked, "NO NO!");
2023         locked = true;
2024         _;
2025         locked = false;
2026     }
2027 
2028     using Strings for uint256;
2029 
2030     string public baseURI;
2031     string public baseExtension = ".json";
2032     string public notRevealedUri;
2033     uint256 public cost = 0 ether;
2034     uint256 public maxSupply = 1888;
2035     uint256 public maxMintAmount = 2;
2036     uint256 public nftPerAddressLimit = 2;
2037     bool public paused = true;
2038     bool public revealed = false;
2039     bool public onlyWhitelisted = true;
2040     address[] public whitelistedAddresses;
2041     mapping(address => uint256) public addressMintedBalance;
2042 
2043     constructor(
2044         string memory _name,
2045         string memory _symbol,
2046         string memory _initBaseURI,
2047         string memory _initNotRevealedUri
2048     ) ERC721(_name, _symbol) {
2049         setBaseURI(_initBaseURI);
2050         setNotRevealedURI(_initNotRevealedUri);
2051     }
2052 
2053     // internal
2054     function _baseURI() internal view virtual override returns (string memory) {
2055         return baseURI;
2056     }
2057 
2058     // public
2059     function mint(uint256 _mintAmount) public payable noReentrant {
2060         require(!paused, "the contract is paused");
2061         uint256 supply = totalSupply();
2062         require(_mintAmount > 0, "need to mint at least 1 NFT");
2063         require(
2064             _mintAmount <= maxMintAmount,
2065             "max mint amount per session exceeded"
2066         );
2067         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
2068 
2069         if (msg.sender != owner()) {
2070             if (onlyWhitelisted == true) {
2071                 require(isWhitelisted(msg.sender), "user is not whitelisted");
2072                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
2073                 require(
2074                     ownerMintedCount + _mintAmount <= nftPerAddressLimit,
2075                     "max NFT per address exceeded"
2076                 );
2077             }
2078             require(msg.value >= cost * _mintAmount, "insufficient funds");
2079         }
2080 
2081         for (uint256 i = 1; i <= _mintAmount; i++) {
2082             addressMintedBalance[msg.sender]++;
2083             _safeMint(msg.sender, supply + i);
2084         }
2085     }
2086 
2087     function isWhitelisted(address _user) public view returns (bool) {
2088         for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
2089             if (whitelistedAddresses[i] == _user) {
2090                 return true;
2091             }
2092         }
2093         return false;
2094     }
2095 
2096     function walletOfOwner(address _owner)
2097         public
2098         view
2099         returns (uint256[] memory)
2100     {
2101         uint256 ownerTokenCount = balanceOf(_owner);
2102         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2103         for (uint256 i; i < ownerTokenCount; i++) {
2104             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
2105         }
2106         return tokenIds;
2107     }
2108 
2109     function tokenURI(uint256 tokenId)
2110         public
2111         view
2112         virtual
2113         override
2114         returns (string memory)
2115     {
2116         require(
2117             _exists(tokenId),
2118             "ERC721Metadata: URI query for nonexistent token"
2119         );
2120 
2121         if (revealed == false) {
2122             return notRevealedUri;
2123         }
2124 
2125         string memory currentBaseURI = _baseURI();
2126         return
2127             bytes(currentBaseURI).length > 0
2128                 ? string(
2129                     abi.encodePacked(
2130                         currentBaseURI,
2131                         tokenId.toString(),
2132                         baseExtension
2133                     )
2134                 )
2135                 : "";
2136     }
2137 
2138     //only owner
2139     function reveal() public onlyOwner {
2140         revealed = true;
2141     }
2142 
2143     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
2144         nftPerAddressLimit = _limit;
2145     }
2146 
2147     function setCost(uint256 _newCost) public onlyOwner {
2148         cost = _newCost;
2149     }
2150 
2151     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
2152         maxMintAmount = _newmaxMintAmount;
2153     }
2154 
2155     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2156         baseURI = _newBaseURI;
2157     }
2158 
2159     function setBaseExtension(string memory _newBaseExtension)
2160         public
2161         onlyOwner
2162     {
2163         baseExtension = _newBaseExtension;
2164     }
2165 
2166     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2167         notRevealedUri = _notRevealedURI;
2168     }
2169 
2170     function pause(bool _state) public onlyOwner {
2171         paused = _state;
2172     }
2173 
2174     function setOnlyWhitelisted(bool _state) public onlyOwner {
2175         onlyWhitelisted = _state;
2176     }
2177 
2178     function whitelistUsers(address[] calldata _users) public onlyOwner {
2179         delete whitelistedAddresses;
2180         whitelistedAddresses = _users;
2181     }
2182 
2183     function withdraw() public payable onlyOwner {
2184         (bool success, ) = payable(msg.sender).call{
2185             value: address(this).balance
2186         }("");
2187         require(success);
2188     }
2189 }
2190 
2191 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.8.0
2192 
2193 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
2194 
2195 pragma solidity ^0.8.0;
2196 
2197 // CAUTION
2198 // This version of SafeMath should only be used with Solidity 0.8 or later,
2199 // because it relies on the compiler's built in overflow checks.
2200 
2201 /**
2202  * @dev Wrappers over Solidity's arithmetic operations.
2203  *
2204  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
2205  * now has built in overflow checking.
2206  */
2207 library SafeMath {
2208     /**
2209      * @dev Returns the addition of two unsigned integers, with an overflow flag.
2210      *
2211      * _Available since v3.4._
2212      */
2213     function tryAdd(uint256 a, uint256 b)
2214         internal
2215         pure
2216         returns (bool, uint256)
2217     {
2218         unchecked {
2219             uint256 c = a + b;
2220             if (c < a) return (false, 0);
2221             return (true, c);
2222         }
2223     }
2224 
2225     /**
2226      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
2227      *
2228      * _Available since v3.4._
2229      */
2230     function trySub(uint256 a, uint256 b)
2231         internal
2232         pure
2233         returns (bool, uint256)
2234     {
2235         unchecked {
2236             if (b > a) return (false, 0);
2237             return (true, a - b);
2238         }
2239     }
2240 
2241     /**
2242      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2243      *
2244      * _Available since v3.4._
2245      */
2246     function tryMul(uint256 a, uint256 b)
2247         internal
2248         pure
2249         returns (bool, uint256)
2250     {
2251         unchecked {
2252             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2253             // benefit is lost if 'b' is also tested.
2254             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2255             if (a == 0) return (true, 0);
2256             uint256 c = a * b;
2257             if (c / a != b) return (false, 0);
2258             return (true, c);
2259         }
2260     }
2261 
2262     /**
2263      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2264      *
2265      * _Available since v3.4._
2266      */
2267     function tryDiv(uint256 a, uint256 b)
2268         internal
2269         pure
2270         returns (bool, uint256)
2271     {
2272         unchecked {
2273             if (b == 0) return (false, 0);
2274             return (true, a / b);
2275         }
2276     }
2277 
2278     /**
2279      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2280      *
2281      * _Available since v3.4._
2282      */
2283     function tryMod(uint256 a, uint256 b)
2284         internal
2285         pure
2286         returns (bool, uint256)
2287     {
2288         unchecked {
2289             if (b == 0) return (false, 0);
2290             return (true, a % b);
2291         }
2292     }
2293 
2294     /**
2295      * @dev Returns the addition of two unsigned integers, reverting on
2296      * overflow.
2297      *
2298      * Counterpart to Solidity's `+` operator.
2299      *
2300      * Requirements:
2301      *
2302      * - Addition cannot overflow.
2303      */
2304     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2305         return a + b;
2306     }
2307 
2308     /**
2309      * @dev Returns the subtraction of two unsigned integers, reverting on
2310      * overflow (when the result is negative).
2311      *
2312      * Counterpart to Solidity's `-` operator.
2313      *
2314      * Requirements:
2315      *
2316      * - Subtraction cannot overflow.
2317      */
2318     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2319         return a - b;
2320     }
2321 
2322     /**
2323      * @dev Returns the multiplication of two unsigned integers, reverting on
2324      * overflow.
2325      *
2326      * Counterpart to Solidity's `*` operator.
2327      *
2328      * Requirements:
2329      *
2330      * - Multiplication cannot overflow.
2331      */
2332     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2333         return a * b;
2334     }
2335 
2336     /**
2337      * @dev Returns the integer division of two unsigned integers, reverting on
2338      * division by zero. The result is rounded towards zero.
2339      *
2340      * Counterpart to Solidity's `/` operator.
2341      *
2342      * Requirements:
2343      *
2344      * - The divisor cannot be zero.
2345      */
2346     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2347         return a / b;
2348     }
2349 
2350     /**
2351      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2352      * reverting when dividing by zero.
2353      *
2354      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2355      * opcode (which leaves remaining gas untouched) while Solidity uses an
2356      * invalid opcode to revert (consuming all remaining gas).
2357      *
2358      * Requirements:
2359      *
2360      * - The divisor cannot be zero.
2361      */
2362     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2363         return a % b;
2364     }
2365 
2366     /**
2367      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2368      * overflow (when the result is negative).
2369      *
2370      * CAUTION: This function is deprecated because it requires allocating memory for the error
2371      * message unnecessarily. For custom revert reasons use {trySub}.
2372      *
2373      * Counterpart to Solidity's `-` operator.
2374      *
2375      * Requirements:
2376      *
2377      * - Subtraction cannot overflow.
2378      */
2379     function sub(
2380         uint256 a,
2381         uint256 b,
2382         string memory errorMessage
2383     ) internal pure returns (uint256) {
2384         unchecked {
2385             require(b <= a, errorMessage);
2386             return a - b;
2387         }
2388     }
2389 
2390     /**
2391      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2392      * division by zero. The result is rounded towards zero.
2393      *
2394      * Counterpart to Solidity's `/` operator. Note: this function uses a
2395      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2396      * uses an invalid opcode to revert (consuming all remaining gas).
2397      *
2398      * Requirements:
2399      *
2400      * - The divisor cannot be zero.
2401      */
2402     function div(
2403         uint256 a,
2404         uint256 b,
2405         string memory errorMessage
2406     ) internal pure returns (uint256) {
2407         unchecked {
2408             require(b > 0, errorMessage);
2409             return a / b;
2410         }
2411     }
2412 
2413     /**
2414      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2415      * reverting with custom message when dividing by zero.
2416      *
2417      * CAUTION: This function is deprecated because it requires allocating memory for the error
2418      * message unnecessarily. For custom revert reasons use {tryMod}.
2419      *
2420      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2421      * opcode (which leaves remaining gas untouched) while Solidity uses an
2422      * invalid opcode to revert (consuming all remaining gas).
2423      *
2424      * Requirements:
2425      *
2426      * - The divisor cannot be zero.
2427      */
2428     function mod(
2429         uint256 a,
2430         uint256 b,
2431         string memory errorMessage
2432     ) internal pure returns (uint256) {
2433         unchecked {
2434             require(b > 0, errorMessage);
2435             return a % b;
2436         }
2437     }
2438 }
2439 
2440 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.0
2441 
2442 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2443 
2444 pragma solidity ^0.8.0;
2445 
2446 /**
2447  * @dev Interface of the ERC20 standard as defined in the EIP.
2448  */
2449 interface IERC20 {
2450     /**
2451      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2452      * another (`to`).
2453      *
2454      * Note that `value` may be zero.
2455      */
2456     event Transfer(address indexed from, address indexed to, uint256 value);
2457 
2458     /**
2459      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2460      * a call to {approve}. `value` is the new allowance.
2461      */
2462     event Approval(
2463         address indexed owner,
2464         address indexed spender,
2465         uint256 value
2466     );
2467 
2468     /**
2469      * @dev Returns the amount of tokens in existence.
2470      */
2471     function totalSupply() external view returns (uint256);
2472 
2473     /**
2474      * @dev Returns the amount of tokens owned by `account`.
2475      */
2476     function balanceOf(address account) external view returns (uint256);
2477 
2478     /**
2479      * @dev Moves `amount` tokens from the caller's account to `to`.
2480      *
2481      * Returns a boolean value indicating whether the operation succeeded.
2482      *
2483      * Emits a {Transfer} event.
2484      */
2485     function transfer(address to, uint256 amount) external returns (bool);
2486 
2487     /**
2488      * @dev Returns the remaining number of tokens that `spender` will be
2489      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2490      * zero by default.
2491      *
2492      * This value changes when {approve} or {transferFrom} are called.
2493      */
2494     function allowance(address owner, address spender)
2495         external
2496         view
2497         returns (uint256);
2498 
2499     /**
2500      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2501      *
2502      * Returns a boolean value indicating whether the operation succeeded.
2503      *
2504      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2505      * that someone may use both the old and the new allowance by unfortunate
2506      * transaction ordering. One possible solution to mitigate this race
2507      * condition is to first reduce the spender's allowance to 0 and set the
2508      * desired value afterwards:
2509      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2510      *
2511      * Emits an {Approval} event.
2512      */
2513     function approve(address spender, uint256 amount) external returns (bool);
2514 
2515     /**
2516      * @dev Moves `amount` tokens from `from` to `to` using the
2517      * allowance mechanism. `amount` is then deducted from the caller's
2518      * allowance.
2519      *
2520      * Returns a boolean value indicating whether the operation succeeded.
2521      *
2522      * Emits a {Transfer} event.
2523      */
2524     function transferFrom(
2525         address from,
2526         address to,
2527         uint256 amount
2528     ) external returns (bool);
2529 }
2530 
2531 // File @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol@v4.8.0
2532 
2533 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
2534 
2535 pragma solidity ^0.8.0;
2536 
2537 /**
2538  * @dev Implementation of the {IERC721Receiver} interface.
2539  *
2540  * Accepts all token transfers.
2541  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
2542  */
2543 contract ERC721Holder is IERC721Receiver {
2544     /**
2545      * @dev See {IERC721Receiver-onERC721Received}.
2546      *
2547      * Always returns `IERC721Receiver.onERC721Received.selector`.
2548      */
2549     function onERC721Received(
2550         address,
2551         address,
2552         uint256,
2553         bytes memory
2554     ) public virtual override returns (bytes4) {
2555         return this.onERC721Received.selector;
2556     }
2557 }
2558 
2559 // File contracts/SoseikiFarm.sol
2560 
2561 pragma solidity ^0.8.9;
2562 
2563 // import "./soseikiToken.sol";
2564 
2565 interface RewardToken is IERC20 {
2566     function mint(address to, uint256 amount) external;
2567 }
2568 
2569 contract SoseikiFarm is Ownable {
2570     IERC721 public soseikiNFT;
2571     RewardToken public soseikiToken;
2572 
2573     uint256 public stakedTotal;
2574     uint256 public stakingStartTime;
2575     uint256 constant stakingTime = 43200 seconds;
2576     uint256 constant token = 10e18;
2577 
2578     struct Staker {
2579         uint256[] tokenIds;
2580         mapping(uint256 => uint256) tokenStakingCoolDown;
2581         uint256 balance;
2582         uint256 rewardsReleased;
2583     }
2584 
2585     bool internal locked;
2586 
2587     modifier noReentrant() {
2588         require(!locked, "NO NO!");
2589         locked = true;
2590         _;
2591         locked = false;
2592     }
2593 
2594     constructor(IERC721 _soseikiNFT, RewardToken _soseikiToken) {
2595         soseikiNFT = _soseikiNFT;
2596         soseikiToken = _soseikiToken;
2597     }
2598 
2599     mapping(address => Staker) public stakers;
2600     mapping(uint256 => address) public tokenOwner;
2601     bool public tokenClaimable;
2602     bool initialised;
2603 
2604     event Staked(address owner, uint256 amount);
2605     event Unstaked(address owner, uint256 amount);
2606     event RewardPaid(address indexed user, uint256 reward);
2607     event ClaimableStatusUpdated(bool status);
2608     event EmergenctUnstake(address indexed user, uint256 tokenId);
2609 
2610     function initStaking() public onlyOwner {
2611         require(!initialised, "Already initialised");
2612         stakingStartTime = block.timestamp;
2613         initialised = true;
2614     }
2615 
2616     function setTokenClaimable(bool _enabled) public onlyOwner {
2617         tokenClaimable = _enabled;
2618         emit ClaimableStatusUpdated(_enabled);
2619     }
2620 
2621     function getStakedTokens(address _user)
2622         public
2623         view
2624         returns (uint256[] memory tokenIds)
2625     {
2626         return stakers[_user].tokenIds;
2627     }
2628 
2629     function stake(uint256 tokenId) public {
2630         _stake(msg.sender, tokenId);
2631     }
2632 
2633     function unstake(uint256 tokenId) public {
2634         _unstake(msg.sender, tokenId);
2635     }
2636 
2637     function _stake(address _user, uint256 _tokenId) internal {
2638         require(initialised, "Staking System: the stacking has not started");
2639         require(
2640             soseikiNFT.ownerOf(_tokenId) == _user,
2641             "user must be the owner of the token"
2642         );
2643         Staker storage staker = stakers[_user];
2644 
2645         staker.tokenIds.push(_tokenId);
2646         staker.tokenStakingCoolDown[_tokenId] = block.timestamp;
2647         tokenOwner[_tokenId] = _user;
2648         soseikiNFT.approve(address(this), _tokenId);
2649         soseikiNFT.safeTransferFrom(_user, address(this), _tokenId);
2650 
2651         emit Staked(_user, _tokenId);
2652         stakedTotal++;
2653     }
2654 
2655     function _unstake(address _user, uint256 _tokenId) internal {
2656         require(
2657             tokenOwner[_tokenId] == _user,
2658             "Nft Staking Syetem: User must be the owner of the staked NFT"
2659         );
2660 
2661         Staker storage staker = stakers[_user];
2662         //   uint256 lastIndex = staker.tokenIds.length -1;
2663         //   uint256 lastIndexKey = staker.tokenIds[lastIndex];
2664 
2665         if (staker.tokenIds.length > 0 && tokenOwner[_tokenId] == _user) {
2666             uint256 lastIndex = staker.tokenIds.length - 1;
2667             uint256 lastIndexKey = staker.tokenIds[lastIndex];
2668             for (uint256 i = 0; i <= lastIndex; i++) {
2669                 if (_tokenId == staker.tokenIds[i]) {
2670                     staker.tokenIds[i] = lastIndexKey;
2671                 }
2672             }
2673             staker.tokenIds.pop();
2674             staker.tokenStakingCoolDown[_tokenId] = 0;
2675             delete tokenOwner[_tokenId];
2676             soseikiNFT.safeTransferFrom(address(this), _user, _tokenId);
2677             emit Unstaked(_user, _tokenId);
2678             stakedTotal--;
2679         }
2680     }
2681 
2682     function updateReward(address _user) public {
2683         Staker storage staker = stakers[_user];
2684         uint256[] storage ids = staker.tokenIds;
2685         for (uint256 i = 0; i < ids.length; i++) {
2686             if (
2687                 staker.tokenStakingCoolDown[ids[i]] <
2688                 block.timestamp + stakingTime &&
2689                 staker.tokenStakingCoolDown[ids[i]] > 0
2690             ) {
2691                 uint256 stakeDays = (
2692                     (block.timestamp -
2693                         uint256(staker.tokenStakingCoolDown[ids[i]]))
2694                 ) / stakingTime;
2695                 uint256 partialTime = (
2696                     (block.timestamp -
2697                         uint256(staker.tokenStakingCoolDown[ids[i]]))
2698                 ) % stakingTime;
2699 
2700                 staker.balance += token * stakeDays;
2701                 staker.tokenStakingCoolDown[ids[i]] =
2702                     block.timestamp +
2703                     partialTime;
2704 
2705                 // console.log uint(staker.tokenStakingCoolDown[ids[i]]);
2706                 // console.log uint(staker.balance);
2707             }
2708         }
2709     }
2710 
2711     function claimReward(address _user) public noReentrant {
2712         require(tokenClaimable == true, "Tokens cannot be claimed yet");
2713         require(stakers[_user].balance > 0, "0 reward yet");
2714 
2715         stakers[_user].rewardsReleased += stakers[_user].balance;
2716 
2717         soseikiToken.mint(_user, stakers[_user].balance);
2718         stakers[_user].balance = 0;
2719         emit RewardPaid(_user, stakers[_user].balance);
2720     }
2721 
2722     function onERC721Received(
2723         address operator,
2724         address from,
2725         uint256 id,
2726         bytes calldata data
2727     ) external returns (bytes4) {
2728         return
2729             bytes4(
2730                 keccak256("onERC721Received(address,address,uint256,bytes)")
2731             );
2732     }
2733 }
2734 
2735 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.8.0
2736 
2737 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
2738 
2739 pragma solidity ^0.8.0;
2740 
2741 /**
2742  * @dev External interface of AccessControl declared to support ERC165 detection.
2743  */
2744 interface IAccessControl {
2745     /**
2746      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
2747      *
2748      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
2749      * {RoleAdminChanged} not being emitted signaling this.
2750      *
2751      * _Available since v3.1._
2752      */
2753     event RoleAdminChanged(
2754         bytes32 indexed role,
2755         bytes32 indexed previousAdminRole,
2756         bytes32 indexed newAdminRole
2757     );
2758 
2759     /**
2760      * @dev Emitted when `account` is granted `role`.
2761      *
2762      * `sender` is the account that originated the contract call, an admin role
2763      * bearer except when using {AccessControl-_setupRole}.
2764      */
2765     event RoleGranted(
2766         bytes32 indexed role,
2767         address indexed account,
2768         address indexed sender
2769     );
2770 
2771     /**
2772      * @dev Emitted when `account` is revoked `role`.
2773      *
2774      * `sender` is the account that originated the contract call:
2775      *   - if using `revokeRole`, it is the admin role bearer
2776      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
2777      */
2778     event RoleRevoked(
2779         bytes32 indexed role,
2780         address indexed account,
2781         address indexed sender
2782     );
2783 
2784     /**
2785      * @dev Returns `true` if `account` has been granted `role`.
2786      */
2787     function hasRole(bytes32 role, address account)
2788         external
2789         view
2790         returns (bool);
2791 
2792     /**
2793      * @dev Returns the admin role that controls `role`. See {grantRole} and
2794      * {revokeRole}.
2795      *
2796      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
2797      */
2798     function getRoleAdmin(bytes32 role) external view returns (bytes32);
2799 
2800     /**
2801      * @dev Grants `role` to `account`.
2802      *
2803      * If `account` had not been already granted `role`, emits a {RoleGranted}
2804      * event.
2805      *
2806      * Requirements:
2807      *
2808      * - the caller must have ``role``'s admin role.
2809      */
2810     function grantRole(bytes32 role, address account) external;
2811 
2812     /**
2813      * @dev Revokes `role` from `account`.
2814      *
2815      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2816      *
2817      * Requirements:
2818      *
2819      * - the caller must have ``role``'s admin role.
2820      */
2821     function revokeRole(bytes32 role, address account) external;
2822 
2823     /**
2824      * @dev Revokes `role` from the calling account.
2825      *
2826      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2827      * purpose is to provide a mechanism for accounts to lose their privileges
2828      * if they are compromised (such as when a trusted device is misplaced).
2829      *
2830      * If the calling account had been granted `role`, emits a {RoleRevoked}
2831      * event.
2832      *
2833      * Requirements:
2834      *
2835      * - the caller must be `account`.
2836      */
2837     function renounceRole(bytes32 role, address account) external;
2838 }
2839 
2840 // File @openzeppelin/contracts/access/AccessControl.sol@v4.8.0
2841 
2842 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
2843 
2844 pragma solidity ^0.8.0;
2845 
2846 /**
2847  * @dev Contract module that allows children to implement role-based access
2848  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2849  * members except through off-chain means by accessing the contract event logs. Some
2850  * applications may benefit from on-chain enumerability, for those cases see
2851  * {AccessControlEnumerable}.
2852  *
2853  * Roles are referred to by their `bytes32` identifier. These should be exposed
2854  * in the external API and be unique. The best way to achieve this is by
2855  * using `public constant` hash digests:
2856  *
2857  * ```
2858  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2859  * ```
2860  *
2861  * Roles can be used to represent a set of permissions. To restrict access to a
2862  * function call, use {hasRole}:
2863  *
2864  * ```
2865  * function foo() public {
2866  *     require(hasRole(MY_ROLE, msg.sender));
2867  *     ...
2868  * }
2869  * ```
2870  *
2871  * Roles can be granted and revoked dynamically via the {grantRole} and
2872  * {revokeRole} functions. Each role has an associated admin role, and only
2873  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2874  *
2875  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2876  * that only accounts with this role will be able to grant or revoke other
2877  * roles. More complex role relationships can be created by using
2878  * {_setRoleAdmin}.
2879  *
2880  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2881  * grant and revoke this role. Extra precautions should be taken to secure
2882  * accounts that have been granted it.
2883  */
2884 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2885     struct RoleData {
2886         mapping(address => bool) members;
2887         bytes32 adminRole;
2888     }
2889 
2890     mapping(bytes32 => RoleData) private _roles;
2891 
2892     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2893 
2894     /**
2895      * @dev Modifier that checks that an account has a specific role. Reverts
2896      * with a standardized message including the required role.
2897      *
2898      * The format of the revert reason is given by the following regular expression:
2899      *
2900      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2901      *
2902      * _Available since v4.1._
2903      */
2904     modifier onlyRole(bytes32 role) {
2905         _checkRole(role);
2906         _;
2907     }
2908 
2909     /**
2910      * @dev See {IERC165-supportsInterface}.
2911      */
2912     function supportsInterface(bytes4 interfaceId)
2913         public
2914         view
2915         virtual
2916         override
2917         returns (bool)
2918     {
2919         return
2920             interfaceId == type(IAccessControl).interfaceId ||
2921             super.supportsInterface(interfaceId);
2922     }
2923 
2924     /**
2925      * @dev Returns `true` if `account` has been granted `role`.
2926      */
2927     function hasRole(bytes32 role, address account)
2928         public
2929         view
2930         virtual
2931         override
2932         returns (bool)
2933     {
2934         return _roles[role].members[account];
2935     }
2936 
2937     /**
2938      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2939      * Overriding this function changes the behavior of the {onlyRole} modifier.
2940      *
2941      * Format of the revert message is described in {_checkRole}.
2942      *
2943      * _Available since v4.6._
2944      */
2945     function _checkRole(bytes32 role) internal view virtual {
2946         _checkRole(role, _msgSender());
2947     }
2948 
2949     /**
2950      * @dev Revert with a standard message if `account` is missing `role`.
2951      *
2952      * The format of the revert reason is given by the following regular expression:
2953      *
2954      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2955      */
2956     function _checkRole(bytes32 role, address account) internal view virtual {
2957         if (!hasRole(role, account)) {
2958             revert(
2959                 string(
2960                     abi.encodePacked(
2961                         "AccessControl: account ",
2962                         Strings.toHexString(account),
2963                         " is missing role ",
2964                         Strings.toHexString(uint256(role), 32)
2965                     )
2966                 )
2967             );
2968         }
2969     }
2970 
2971     /**
2972      * @dev Returns the admin role that controls `role`. See {grantRole} and
2973      * {revokeRole}.
2974      *
2975      * To change a role's admin, use {_setRoleAdmin}.
2976      */
2977     function getRoleAdmin(bytes32 role)
2978         public
2979         view
2980         virtual
2981         override
2982         returns (bytes32)
2983     {
2984         return _roles[role].adminRole;
2985     }
2986 
2987     /**
2988      * @dev Grants `role` to `account`.
2989      *
2990      * If `account` had not been already granted `role`, emits a {RoleGranted}
2991      * event.
2992      *
2993      * Requirements:
2994      *
2995      * - the caller must have ``role``'s admin role.
2996      *
2997      * May emit a {RoleGranted} event.
2998      */
2999     function grantRole(bytes32 role, address account)
3000         public
3001         virtual
3002         override
3003         onlyRole(getRoleAdmin(role))
3004     {
3005         _grantRole(role, account);
3006     }
3007 
3008     /**
3009      * @dev Revokes `role` from `account`.
3010      *
3011      * If `account` had been granted `role`, emits a {RoleRevoked} event.
3012      *
3013      * Requirements:
3014      *
3015      * - the caller must have ``role``'s admin role.
3016      *
3017      * May emit a {RoleRevoked} event.
3018      */
3019     function revokeRole(bytes32 role, address account)
3020         public
3021         virtual
3022         override
3023         onlyRole(getRoleAdmin(role))
3024     {
3025         _revokeRole(role, account);
3026     }
3027 
3028     /**
3029      * @dev Revokes `role` from the calling account.
3030      *
3031      * Roles are often managed via {grantRole} and {revokeRole}: this function's
3032      * purpose is to provide a mechanism for accounts to lose their privileges
3033      * if they are compromised (such as when a trusted device is misplaced).
3034      *
3035      * If the calling account had been revoked `role`, emits a {RoleRevoked}
3036      * event.
3037      *
3038      * Requirements:
3039      *
3040      * - the caller must be `account`.
3041      *
3042      * May emit a {RoleRevoked} event.
3043      */
3044     function renounceRole(bytes32 role, address account)
3045         public
3046         virtual
3047         override
3048     {
3049         require(
3050             account == _msgSender(),
3051             "AccessControl: can only renounce roles for self"
3052         );
3053 
3054         _revokeRole(role, account);
3055     }
3056 
3057     /**
3058      * @dev Grants `role` to `account`.
3059      *
3060      * If `account` had not been already granted `role`, emits a {RoleGranted}
3061      * event. Note that unlike {grantRole}, this function doesn't perform any
3062      * checks on the calling account.
3063      *
3064      * May emit a {RoleGranted} event.
3065      *
3066      * [WARNING]
3067      * ====
3068      * This function should only be called from the constructor when setting
3069      * up the initial roles for the system.
3070      *
3071      * Using this function in any other way is effectively circumventing the admin
3072      * system imposed by {AccessControl}.
3073      * ====
3074      *
3075      * NOTE: This function is deprecated in favor of {_grantRole}.
3076      */
3077     function _setupRole(bytes32 role, address account) internal virtual {
3078         _grantRole(role, account);
3079     }
3080 
3081     /**
3082      * @dev Sets `adminRole` as ``role``'s admin role.
3083      *
3084      * Emits a {RoleAdminChanged} event.
3085      */
3086     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
3087         bytes32 previousAdminRole = getRoleAdmin(role);
3088         _roles[role].adminRole = adminRole;
3089         emit RoleAdminChanged(role, previousAdminRole, adminRole);
3090     }
3091 
3092     /**
3093      * @dev Grants `role` to `account`.
3094      *
3095      * Internal function without access restriction.
3096      *
3097      * May emit a {RoleGranted} event.
3098      */
3099     function _grantRole(bytes32 role, address account) internal virtual {
3100         if (!hasRole(role, account)) {
3101             _roles[role].members[account] = true;
3102             emit RoleGranted(role, account, _msgSender());
3103         }
3104     }
3105 
3106     /**
3107      * @dev Revokes `role` from `account`.
3108      *
3109      * Internal function without access restriction.
3110      *
3111      * May emit a {RoleRevoked} event.
3112      */
3113     function _revokeRole(bytes32 role, address account) internal virtual {
3114         if (hasRole(role, account)) {
3115             _roles[role].members[account] = false;
3116             emit RoleRevoked(role, account, _msgSender());
3117         }
3118     }
3119 }
3120 
3121 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.0
3122 
3123 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
3124 
3125 pragma solidity ^0.8.0;
3126 
3127 /**
3128  * @dev Interface for the optional metadata functions from the ERC20 standard.
3129  *
3130  * _Available since v4.1._
3131  */
3132 interface IERC20Metadata is IERC20 {
3133     /**
3134      * @dev Returns the name of the token.
3135      */
3136     function name() external view returns (string memory);
3137 
3138     /**
3139      * @dev Returns the symbol of the token.
3140      */
3141     function symbol() external view returns (string memory);
3142 
3143     /**
3144      * @dev Returns the decimals places of the token.
3145      */
3146     function decimals() external view returns (uint8);
3147 }
3148 
3149 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.0
3150 
3151 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
3152 
3153 pragma solidity ^0.8.0;
3154 
3155 /**
3156  * @dev Implementation of the {IERC20} interface.
3157  *
3158  * This implementation is agnostic to the way tokens are created. This means
3159  * that a supply mechanism has to be added in a derived contract using {_mint}.
3160  * For a generic mechanism see {ERC20PresetMinterPauser}.
3161  *
3162  * TIP: For a detailed writeup see our guide
3163  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
3164  * to implement supply mechanisms].
3165  *
3166  * We have followed general OpenZeppelin Contracts guidelines: functions revert
3167  * instead returning `false` on failure. This behavior is nonetheless
3168  * conventional and does not conflict with the expectations of ERC20
3169  * applications.
3170  *
3171  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
3172  * This allows applications to reconstruct the allowance for all accounts just
3173  * by listening to said events. Other implementations of the EIP may not emit
3174  * these events, as it isn't required by the specification.
3175  *
3176  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
3177  * functions have been added to mitigate the well-known issues around setting
3178  * allowances. See {IERC20-approve}.
3179  */
3180 contract ERC20 is Context, IERC20, IERC20Metadata {
3181     mapping(address => uint256) private _balances;
3182 
3183     mapping(address => mapping(address => uint256)) private _allowances;
3184 
3185     uint256 private _totalSupply;
3186 
3187     string private _name;
3188     string private _symbol;
3189 
3190     /**
3191      * @dev Sets the values for {name} and {symbol}.
3192      *
3193      * The default value of {decimals} is 18. To select a different value for
3194      * {decimals} you should overload it.
3195      *
3196      * All two of these values are immutable: they can only be set once during
3197      * construction.
3198      */
3199     constructor(string memory name_, string memory symbol_) {
3200         _name = name_;
3201         _symbol = symbol_;
3202     }
3203 
3204     /**
3205      * @dev Returns the name of the token.
3206      */
3207     function name() public view virtual override returns (string memory) {
3208         return _name;
3209     }
3210 
3211     /**
3212      * @dev Returns the symbol of the token, usually a shorter version of the
3213      * name.
3214      */
3215     function symbol() public view virtual override returns (string memory) {
3216         return _symbol;
3217     }
3218 
3219     /**
3220      * @dev Returns the number of decimals used to get its user representation.
3221      * For example, if `decimals` equals `2`, a balance of `505` tokens should
3222      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
3223      *
3224      * Tokens usually opt for a value of 18, imitating the relationship between
3225      * Ether and Wei. This is the value {ERC20} uses, unless this function is
3226      * overridden;
3227      *
3228      * NOTE: This information is only used for _display_ purposes: it in
3229      * no way affects any of the arithmetic of the contract, including
3230      * {IERC20-balanceOf} and {IERC20-transfer}.
3231      */
3232     function decimals() public view virtual override returns (uint8) {
3233         return 18;
3234     }
3235 
3236     /**
3237      * @dev See {IERC20-totalSupply}.
3238      */
3239     function totalSupply() public view virtual override returns (uint256) {
3240         return _totalSupply;
3241     }
3242 
3243     /**
3244      * @dev See {IERC20-balanceOf}.
3245      */
3246     function balanceOf(address account)
3247         public
3248         view
3249         virtual
3250         override
3251         returns (uint256)
3252     {
3253         return _balances[account];
3254     }
3255 
3256     /**
3257      * @dev See {IERC20-transfer}.
3258      *
3259      * Requirements:
3260      *
3261      * - `to` cannot be the zero address.
3262      * - the caller must have a balance of at least `amount`.
3263      */
3264     function transfer(address to, uint256 amount)
3265         public
3266         virtual
3267         override
3268         returns (bool)
3269     {
3270         address owner = _msgSender();
3271         _transfer(owner, to, amount);
3272         return true;
3273     }
3274 
3275     /**
3276      * @dev See {IERC20-allowance}.
3277      */
3278     function allowance(address owner, address spender)
3279         public
3280         view
3281         virtual
3282         override
3283         returns (uint256)
3284     {
3285         return _allowances[owner][spender];
3286     }
3287 
3288     /**
3289      * @dev See {IERC20-approve}.
3290      *
3291      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
3292      * `transferFrom`. This is semantically equivalent to an infinite approval.
3293      *
3294      * Requirements:
3295      *
3296      * - `spender` cannot be the zero address.
3297      */
3298     function approve(address spender, uint256 amount)
3299         public
3300         virtual
3301         override
3302         returns (bool)
3303     {
3304         address owner = _msgSender();
3305         _approve(owner, spender, amount);
3306         return true;
3307     }
3308 
3309     /**
3310      * @dev See {IERC20-transferFrom}.
3311      *
3312      * Emits an {Approval} event indicating the updated allowance. This is not
3313      * required by the EIP. See the note at the beginning of {ERC20}.
3314      *
3315      * NOTE: Does not update the allowance if the current allowance
3316      * is the maximum `uint256`.
3317      *
3318      * Requirements:
3319      *
3320      * - `from` and `to` cannot be the zero address.
3321      * - `from` must have a balance of at least `amount`.
3322      * - the caller must have allowance for ``from``'s tokens of at least
3323      * `amount`.
3324      */
3325     function transferFrom(
3326         address from,
3327         address to,
3328         uint256 amount
3329     ) public virtual override returns (bool) {
3330         address spender = _msgSender();
3331         _spendAllowance(from, spender, amount);
3332         _transfer(from, to, amount);
3333         return true;
3334     }
3335 
3336     /**
3337      * @dev Atomically increases the allowance granted to `spender` by the caller.
3338      *
3339      * This is an alternative to {approve} that can be used as a mitigation for
3340      * problems described in {IERC20-approve}.
3341      *
3342      * Emits an {Approval} event indicating the updated allowance.
3343      *
3344      * Requirements:
3345      *
3346      * - `spender` cannot be the zero address.
3347      */
3348     function increaseAllowance(address spender, uint256 addedValue)
3349         public
3350         virtual
3351         returns (bool)
3352     {
3353         address owner = _msgSender();
3354         _approve(owner, spender, allowance(owner, spender) + addedValue);
3355         return true;
3356     }
3357 
3358     /**
3359      * @dev Atomically decreases the allowance granted to `spender` by the caller.
3360      *
3361      * This is an alternative to {approve} that can be used as a mitigation for
3362      * problems described in {IERC20-approve}.
3363      *
3364      * Emits an {Approval} event indicating the updated allowance.
3365      *
3366      * Requirements:
3367      *
3368      * - `spender` cannot be the zero address.
3369      * - `spender` must have allowance for the caller of at least
3370      * `subtractedValue`.
3371      */
3372     function decreaseAllowance(address spender, uint256 subtractedValue)
3373         public
3374         virtual
3375         returns (bool)
3376     {
3377         address owner = _msgSender();
3378         uint256 currentAllowance = allowance(owner, spender);
3379         require(
3380             currentAllowance >= subtractedValue,
3381             "ERC20: decreased allowance below zero"
3382         );
3383         unchecked {
3384             _approve(owner, spender, currentAllowance - subtractedValue);
3385         }
3386 
3387         return true;
3388     }
3389 
3390     /**
3391      * @dev Moves `amount` of tokens from `from` to `to`.
3392      *
3393      * This internal function is equivalent to {transfer}, and can be used to
3394      * e.g. implement automatic token fees, slashing mechanisms, etc.
3395      *
3396      * Emits a {Transfer} event.
3397      *
3398      * Requirements:
3399      *
3400      * - `from` cannot be the zero address.
3401      * - `to` cannot be the zero address.
3402      * - `from` must have a balance of at least `amount`.
3403      */
3404     function _transfer(
3405         address from,
3406         address to,
3407         uint256 amount
3408     ) internal virtual {
3409         require(from != address(0), "ERC20: transfer from the zero address");
3410         require(to != address(0), "ERC20: transfer to the zero address");
3411 
3412         _beforeTokenTransfer(from, to, amount);
3413 
3414         uint256 fromBalance = _balances[from];
3415         require(
3416             fromBalance >= amount,
3417             "ERC20: transfer amount exceeds balance"
3418         );
3419         unchecked {
3420             _balances[from] = fromBalance - amount;
3421             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
3422             // decrementing then incrementing.
3423             _balances[to] += amount;
3424         }
3425 
3426         emit Transfer(from, to, amount);
3427 
3428         _afterTokenTransfer(from, to, amount);
3429     }
3430 
3431     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
3432      * the total supply.
3433      *
3434      * Emits a {Transfer} event with `from` set to the zero address.
3435      *
3436      * Requirements:
3437      *
3438      * - `account` cannot be the zero address.
3439      */
3440     function _mint(address account, uint256 amount) internal virtual {
3441         require(account != address(0), "ERC20: mint to the zero address");
3442 
3443         _beforeTokenTransfer(address(0), account, amount);
3444 
3445         _totalSupply += amount;
3446         unchecked {
3447             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
3448             _balances[account] += amount;
3449         }
3450         emit Transfer(address(0), account, amount);
3451 
3452         _afterTokenTransfer(address(0), account, amount);
3453     }
3454 
3455     /**
3456      * @dev Destroys `amount` tokens from `account`, reducing the
3457      * total supply.
3458      *
3459      * Emits a {Transfer} event with `to` set to the zero address.
3460      *
3461      * Requirements:
3462      *
3463      * - `account` cannot be the zero address.
3464      * - `account` must have at least `amount` tokens.
3465      */
3466     function _burn(address account, uint256 amount) internal virtual {
3467         require(account != address(0), "ERC20: burn from the zero address");
3468 
3469         _beforeTokenTransfer(account, address(0), amount);
3470 
3471         uint256 accountBalance = _balances[account];
3472         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
3473         unchecked {
3474             _balances[account] = accountBalance - amount;
3475             // Overflow not possible: amount <= accountBalance <= totalSupply.
3476             _totalSupply -= amount;
3477         }
3478 
3479         emit Transfer(account, address(0), amount);
3480 
3481         _afterTokenTransfer(account, address(0), amount);
3482     }
3483 
3484     /**
3485      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
3486      *
3487      * This internal function is equivalent to `approve`, and can be used to
3488      * e.g. set automatic allowances for certain subsystems, etc.
3489      *
3490      * Emits an {Approval} event.
3491      *
3492      * Requirements:
3493      *
3494      * - `owner` cannot be the zero address.
3495      * - `spender` cannot be the zero address.
3496      */
3497     function _approve(
3498         address owner,
3499         address spender,
3500         uint256 amount
3501     ) internal virtual {
3502         require(owner != address(0), "ERC20: approve from the zero address");
3503         require(spender != address(0), "ERC20: approve to the zero address");
3504 
3505         _allowances[owner][spender] = amount;
3506         emit Approval(owner, spender, amount);
3507     }
3508 
3509     /**
3510      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
3511      *
3512      * Does not update the allowance amount in case of infinite allowance.
3513      * Revert if not enough allowance is available.
3514      *
3515      * Might emit an {Approval} event.
3516      */
3517     function _spendAllowance(
3518         address owner,
3519         address spender,
3520         uint256 amount
3521     ) internal virtual {
3522         uint256 currentAllowance = allowance(owner, spender);
3523         if (currentAllowance != type(uint256).max) {
3524             require(
3525                 currentAllowance >= amount,
3526                 "ERC20: insufficient allowance"
3527             );
3528             unchecked {
3529                 _approve(owner, spender, currentAllowance - amount);
3530             }
3531         }
3532     }
3533 
3534     /**
3535      * @dev Hook that is called before any transfer of tokens. This includes
3536      * minting and burning.
3537      *
3538      * Calling conditions:
3539      *
3540      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
3541      * will be transferred to `to`.
3542      * - when `from` is zero, `amount` tokens will be minted for `to`.
3543      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
3544      * - `from` and `to` are never both zero.
3545      *
3546      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3547      */
3548     function _beforeTokenTransfer(
3549         address from,
3550         address to,
3551         uint256 amount
3552     ) internal virtual {}
3553 
3554     /**
3555      * @dev Hook that is called after any transfer of tokens. This includes
3556      * minting and burning.
3557      *
3558      * Calling conditions:
3559      *
3560      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
3561      * has been transferred to `to`.
3562      * - when `from` is zero, `amount` tokens have been minted for `to`.
3563      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
3564      * - `from` and `to` are never both zero.
3565      *
3566      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3567      */
3568     function _afterTokenTransfer(
3569         address from,
3570         address to,
3571         uint256 amount
3572     ) internal virtual {}
3573 }
3574 
3575 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.8.0
3576 
3577 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
3578 
3579 pragma solidity ^0.8.0;
3580 
3581 /**
3582  * @dev Extension of {ERC20} that allows token holders to destroy both their own
3583  * tokens and those that they have an allowance for, in a way that can be
3584  * recognized off-chain (via event analysis).
3585  */
3586 abstract contract ERC20Burnable is Context, ERC20 {
3587     /**
3588      * @dev Destroys `amount` tokens from the caller.
3589      *
3590      * See {ERC20-_burn}.
3591      */
3592     function burn(uint256 amount) public virtual {
3593         _burn(_msgSender(), amount);
3594     }
3595 
3596     /**
3597      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
3598      * allowance.
3599      *
3600      * See {ERC20-_burn} and {ERC20-allowance}.
3601      *
3602      * Requirements:
3603      *
3604      * - the caller must have allowance for ``accounts``'s tokens of at least
3605      * `amount`.
3606      */
3607     function burnFrom(address account, uint256 amount) public virtual {
3608         _spendAllowance(account, _msgSender(), amount);
3609         _burn(account, amount);
3610     }
3611 }
3612 
3613 // File contracts/SoseikiToken.sol
3614 
3615 pragma solidity ^0.8.9;
3616 
3617 contract SoseikiToken is ERC20, ERC20Burnable, AccessControl, Ownable {
3618     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
3619 
3620     constructor() ERC20("Soseiki Token", "SDT") {
3621         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
3622         _grantRole(MINTER_ROLE, msg.sender);
3623     }
3624 
3625     function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
3626         _mint(to, amount);
3627     }
3628 }