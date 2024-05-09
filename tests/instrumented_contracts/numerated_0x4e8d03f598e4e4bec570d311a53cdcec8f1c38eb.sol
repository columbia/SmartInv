1 /* SPDX-License-Identifier: MIT */
2 
3 // Sources flattened with hardhat v2.12.7 https://hardhat.org
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 
32 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
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
115 
116 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Interface of the ERC165 standard, as defined in the
124  * https://eips.ethereum.org/EIPS/eip-165[EIP].
125  *
126  * Implementers can declare support of contract interfaces, which can then be
127  * queried by others ({ERC165Checker}).
128  *
129  * For an implementation, see {ERC165}.
130  */
131 interface IERC165 {
132     /**
133      * @dev Returns true if this contract implements the interface defined by
134      * `interfaceId`. See the corresponding
135      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
136      * to learn more about how these ids are created.
137      *
138      * This function call must use less than 30 000 gas.
139      */
140     function supportsInterface(bytes4 interfaceId) external view returns (bool);
141 }
142 
143 
144 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.0
145 
146 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Required interface of an ERC721 compliant contract.
152  */
153 interface IERC721 is IERC165 {
154     /**
155      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
156      */
157     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
158 
159     /**
160      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
161      */
162     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
163 
164     /**
165      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
166      */
167     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
168 
169     /**
170      * @dev Returns the number of tokens in ``owner``'s account.
171      */
172     function balanceOf(address owner) external view returns (uint256 balance);
173 
174     /**
175      * @dev Returns the owner of the `tokenId` token.
176      *
177      * Requirements:
178      *
179      * - `tokenId` must exist.
180      */
181     function ownerOf(uint256 tokenId) external view returns (address owner);
182 
183     /**
184      * @dev Safely transfers `tokenId` token from `from` to `to`.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must exist and be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
193      *
194      * Emits a {Transfer} event.
195      */
196     function safeTransferFrom(
197         address from,
198         address to,
199         uint256 tokenId,
200         bytes calldata data
201     ) external;
202 
203     /**
204      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
205      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
206      *
207      * Requirements:
208      *
209      * - `from` cannot be the zero address.
210      * - `to` cannot be the zero address.
211      * - `tokenId` token must exist and be owned by `from`.
212      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
213      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
214      *
215      * Emits a {Transfer} event.
216      */
217     function safeTransferFrom(
218         address from,
219         address to,
220         uint256 tokenId
221     ) external;
222 
223     /**
224      * @dev Transfers `tokenId` token from `from` to `to`.
225      *
226      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
227      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
228      * understand this adds an external call which potentially creates a reentrancy vulnerability.
229      *
230      * Requirements:
231      *
232      * - `from` cannot be the zero address.
233      * - `to` cannot be the zero address.
234      * - `tokenId` token must be owned by `from`.
235      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transferFrom(
240         address from,
241         address to,
242         uint256 tokenId
243     ) external;
244 
245     /**
246      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
247      * The approval is cleared when the token is transferred.
248      *
249      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
250      *
251      * Requirements:
252      *
253      * - The caller must own the token or be an approved operator.
254      * - `tokenId` must exist.
255      *
256      * Emits an {Approval} event.
257      */
258     function approve(address to, uint256 tokenId) external;
259 
260     /**
261      * @dev Approve or remove `operator` as an operator for the caller.
262      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
263      *
264      * Requirements:
265      *
266      * - The `operator` cannot be the caller.
267      *
268      * Emits an {ApprovalForAll} event.
269      */
270     function setApprovalForAll(address operator, bool _approved) external;
271 
272     /**
273      * @dev Returns the account approved for `tokenId` token.
274      *
275      * Requirements:
276      *
277      * - `tokenId` must exist.
278      */
279     function getApproved(uint256 tokenId) external view returns (address operator);
280 
281     /**
282      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
283      *
284      * See {setApprovalForAll}
285      */
286     function isApprovedForAll(address owner, address operator) external view returns (bool);
287 }
288 
289 
290 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
291 
292 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Standard math utilities missing in the Solidity language.
298  */
299 library Math {
300     enum Rounding {
301         Down, // Toward negative infinity
302         Up, // Toward infinity
303         Zero // Toward zero
304     }
305 
306     /**
307      * @dev Returns the largest of two numbers.
308      */
309     function max(uint256 a, uint256 b) internal pure returns (uint256) {
310         return a > b ? a : b;
311     }
312 
313     /**
314      * @dev Returns the smallest of two numbers.
315      */
316     function min(uint256 a, uint256 b) internal pure returns (uint256) {
317         return a < b ? a : b;
318     }
319 
320     /**
321      * @dev Returns the average of two numbers. The result is rounded towards
322      * zero.
323      */
324     function average(uint256 a, uint256 b) internal pure returns (uint256) {
325         // (a + b) / 2 can overflow.
326         return (a & b) + (a ^ b) / 2;
327     }
328 
329     /**
330      * @dev Returns the ceiling of the division of two numbers.
331      *
332      * This differs from standard division with `/` in that it rounds up instead
333      * of rounding down.
334      */
335     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
336         // (a + b - 1) / b can overflow on addition, so we distribute.
337         return a == 0 ? 0 : (a - 1) / b + 1;
338     }
339 
340     /**
341      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
342      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
343      * with further edits by Uniswap Labs also under MIT license.
344      */
345     function mulDiv(
346         uint256 x,
347         uint256 y,
348         uint256 denominator
349     ) internal pure returns (uint256 result) {
350         unchecked {
351             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
352             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
353             // variables such that product = prod1 * 2^256 + prod0.
354             uint256 prod0; // Least significant 256 bits of the product
355             uint256 prod1; // Most significant 256 bits of the product
356             assembly {
357                 let mm := mulmod(x, y, not(0))
358                 prod0 := mul(x, y)
359                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
360             }
361 
362             // Handle non-overflow cases, 256 by 256 division.
363             if (prod1 == 0) {
364                 return prod0 / denominator;
365             }
366 
367             // Make sure the result is less than 2^256. Also prevents denominator == 0.
368             require(denominator > prod1);
369 
370             ///////////////////////////////////////////////
371             // 512 by 256 division.
372             ///////////////////////////////////////////////
373 
374             // Make division exact by subtracting the remainder from [prod1 prod0].
375             uint256 remainder;
376             assembly {
377                 // Compute remainder using mulmod.
378                 remainder := mulmod(x, y, denominator)
379 
380                 // Subtract 256 bit number from 512 bit number.
381                 prod1 := sub(prod1, gt(remainder, prod0))
382                 prod0 := sub(prod0, remainder)
383             }
384 
385             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
386             // See https://cs.stackexchange.com/q/138556/92363.
387 
388             // Does not overflow because the denominator cannot be zero at this stage in the function.
389             uint256 twos = denominator & (~denominator + 1);
390             assembly {
391                 // Divide denominator by twos.
392                 denominator := div(denominator, twos)
393 
394                 // Divide [prod1 prod0] by twos.
395                 prod0 := div(prod0, twos)
396 
397                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
398                 twos := add(div(sub(0, twos), twos), 1)
399             }
400 
401             // Shift in bits from prod1 into prod0.
402             prod0 |= prod1 * twos;
403 
404             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
405             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
406             // four bits. That is, denominator * inv = 1 mod 2^4.
407             uint256 inverse = (3 * denominator) ^ 2;
408 
409             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
410             // in modular arithmetic, doubling the correct bits in each step.
411             inverse *= 2 - denominator * inverse; // inverse mod 2^8
412             inverse *= 2 - denominator * inverse; // inverse mod 2^16
413             inverse *= 2 - denominator * inverse; // inverse mod 2^32
414             inverse *= 2 - denominator * inverse; // inverse mod 2^64
415             inverse *= 2 - denominator * inverse; // inverse mod 2^128
416             inverse *= 2 - denominator * inverse; // inverse mod 2^256
417 
418             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
419             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
420             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
421             // is no longer required.
422             result = prod0 * inverse;
423             return result;
424         }
425     }
426 
427     /**
428      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
429      */
430     function mulDiv(
431         uint256 x,
432         uint256 y,
433         uint256 denominator,
434         Rounding rounding
435     ) internal pure returns (uint256) {
436         uint256 result = mulDiv(x, y, denominator);
437         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
438             result += 1;
439         }
440         return result;
441     }
442 
443     /**
444      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
445      *
446      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
447      */
448     function sqrt(uint256 a) internal pure returns (uint256) {
449         if (a == 0) {
450             return 0;
451         }
452 
453         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
454         //
455         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
456         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
457         //
458         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
459         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
460         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
461         //
462         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
463         uint256 result = 1 << (log2(a) >> 1);
464 
465         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
466         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
467         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
468         // into the expected uint128 result.
469         unchecked {
470             result = (result + a / result) >> 1;
471             result = (result + a / result) >> 1;
472             result = (result + a / result) >> 1;
473             result = (result + a / result) >> 1;
474             result = (result + a / result) >> 1;
475             result = (result + a / result) >> 1;
476             result = (result + a / result) >> 1;
477             return min(result, a / result);
478         }
479     }
480 
481     /**
482      * @notice Calculates sqrt(a), following the selected rounding direction.
483      */
484     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
485         unchecked {
486             uint256 result = sqrt(a);
487             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
488         }
489     }
490 
491     /**
492      * @dev Return the log in base 2, rounded down, of a positive value.
493      * Returns 0 if given 0.
494      */
495     function log2(uint256 value) internal pure returns (uint256) {
496         uint256 result = 0;
497         unchecked {
498             if (value >> 128 > 0) {
499                 value >>= 128;
500                 result += 128;
501             }
502             if (value >> 64 > 0) {
503                 value >>= 64;
504                 result += 64;
505             }
506             if (value >> 32 > 0) {
507                 value >>= 32;
508                 result += 32;
509             }
510             if (value >> 16 > 0) {
511                 value >>= 16;
512                 result += 16;
513             }
514             if (value >> 8 > 0) {
515                 value >>= 8;
516                 result += 8;
517             }
518             if (value >> 4 > 0) {
519                 value >>= 4;
520                 result += 4;
521             }
522             if (value >> 2 > 0) {
523                 value >>= 2;
524                 result += 2;
525             }
526             if (value >> 1 > 0) {
527                 result += 1;
528             }
529         }
530         return result;
531     }
532 
533     /**
534      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
535      * Returns 0 if given 0.
536      */
537     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
538         unchecked {
539             uint256 result = log2(value);
540             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
541         }
542     }
543 
544     /**
545      * @dev Return the log in base 10, rounded down, of a positive value.
546      * Returns 0 if given 0.
547      */
548     function log10(uint256 value) internal pure returns (uint256) {
549         uint256 result = 0;
550         unchecked {
551             if (value >= 10**64) {
552                 value /= 10**64;
553                 result += 64;
554             }
555             if (value >= 10**32) {
556                 value /= 10**32;
557                 result += 32;
558             }
559             if (value >= 10**16) {
560                 value /= 10**16;
561                 result += 16;
562             }
563             if (value >= 10**8) {
564                 value /= 10**8;
565                 result += 8;
566             }
567             if (value >= 10**4) {
568                 value /= 10**4;
569                 result += 4;
570             }
571             if (value >= 10**2) {
572                 value /= 10**2;
573                 result += 2;
574             }
575             if (value >= 10**1) {
576                 result += 1;
577             }
578         }
579         return result;
580     }
581 
582     /**
583      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
584      * Returns 0 if given 0.
585      */
586     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
587         unchecked {
588             uint256 result = log10(value);
589             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
590         }
591     }
592 
593     /**
594      * @dev Return the log in base 256, rounded down, of a positive value.
595      * Returns 0 if given 0.
596      *
597      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
598      */
599     function log256(uint256 value) internal pure returns (uint256) {
600         uint256 result = 0;
601         unchecked {
602             if (value >> 128 > 0) {
603                 value >>= 128;
604                 result += 16;
605             }
606             if (value >> 64 > 0) {
607                 value >>= 64;
608                 result += 8;
609             }
610             if (value >> 32 > 0) {
611                 value >>= 32;
612                 result += 4;
613             }
614             if (value >> 16 > 0) {
615                 value >>= 16;
616                 result += 2;
617             }
618             if (value >> 8 > 0) {
619                 result += 1;
620             }
621         }
622         return result;
623     }
624 
625     /**
626      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
627      * Returns 0 if given 0.
628      */
629     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
630         unchecked {
631             uint256 result = log256(value);
632             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
633         }
634     }
635 }
636 
637 
638 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
639 
640 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev String operations.
646  */
647 library Strings {
648     bytes16 private constant _SYMBOLS = "0123456789abcdef";
649     uint8 private constant _ADDRESS_LENGTH = 20;
650 
651     /**
652      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
653      */
654     function toString(uint256 value) internal pure returns (string memory) {
655         unchecked {
656             uint256 length = Math.log10(value) + 1;
657             string memory buffer = new string(length);
658             uint256 ptr;
659             /// @solidity memory-safe-assembly
660             assembly {
661                 ptr := add(buffer, add(32, length))
662             }
663             while (true) {
664                 ptr--;
665                 /// @solidity memory-safe-assembly
666                 assembly {
667                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
668                 }
669                 value /= 10;
670                 if (value == 0) break;
671             }
672             return buffer;
673         }
674     }
675 
676     /**
677      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
678      */
679     function toHexString(uint256 value) internal pure returns (string memory) {
680         unchecked {
681             return toHexString(value, Math.log256(value) + 1);
682         }
683     }
684 
685     /**
686      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
687      */
688     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
689         bytes memory buffer = new bytes(2 * length + 2);
690         buffer[0] = "0";
691         buffer[1] = "x";
692         for (uint256 i = 2 * length + 1; i > 1; --i) {
693             buffer[i] = _SYMBOLS[value & 0xf];
694             value >>= 4;
695         }
696         require(value == 0, "Strings: hex length insufficient");
697         return string(buffer);
698     }
699 
700     /**
701      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
702      */
703     function toHexString(address addr) internal pure returns (string memory) {
704         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
705     }
706 }
707 
708 
709 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.8.0
710 
711 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 /**
716  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
717  *
718  * These functions can be used to verify that a message was signed by the holder
719  * of the private keys of a given address.
720  */
721 library ECDSA {
722     enum RecoverError {
723         NoError,
724         InvalidSignature,
725         InvalidSignatureLength,
726         InvalidSignatureS,
727         InvalidSignatureV // Deprecated in v4.8
728     }
729 
730     function _throwError(RecoverError error) private pure {
731         if (error == RecoverError.NoError) {
732             return; // no error: do nothing
733         } else if (error == RecoverError.InvalidSignature) {
734             revert("ECDSA: invalid signature");
735         } else if (error == RecoverError.InvalidSignatureLength) {
736             revert("ECDSA: invalid signature length");
737         } else if (error == RecoverError.InvalidSignatureS) {
738             revert("ECDSA: invalid signature 's' value");
739         }
740     }
741 
742     /**
743      * @dev Returns the address that signed a hashed message (`hash`) with
744      * `signature` or error string. This address can then be used for verification purposes.
745      *
746      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
747      * this function rejects them by requiring the `s` value to be in the lower
748      * half order, and the `v` value to be either 27 or 28.
749      *
750      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
751      * verification to be secure: it is possible to craft signatures that
752      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
753      * this is by receiving a hash of the original message (which may otherwise
754      * be too long), and then calling {toEthSignedMessageHash} on it.
755      *
756      * Documentation for signature generation:
757      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
758      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
759      *
760      * _Available since v4.3._
761      */
762     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
763         if (signature.length == 65) {
764             bytes32 r;
765             bytes32 s;
766             uint8 v;
767             // ecrecover takes the signature parameters, and the only way to get them
768             // currently is to use assembly.
769             /// @solidity memory-safe-assembly
770             assembly {
771                 r := mload(add(signature, 0x20))
772                 s := mload(add(signature, 0x40))
773                 v := byte(0, mload(add(signature, 0x60)))
774             }
775             return tryRecover(hash, v, r, s);
776         } else {
777             return (address(0), RecoverError.InvalidSignatureLength);
778         }
779     }
780 
781     /**
782      * @dev Returns the address that signed a hashed message (`hash`) with
783      * `signature`. This address can then be used for verification purposes.
784      *
785      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
786      * this function rejects them by requiring the `s` value to be in the lower
787      * half order, and the `v` value to be either 27 or 28.
788      *
789      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
790      * verification to be secure: it is possible to craft signatures that
791      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
792      * this is by receiving a hash of the original message (which may otherwise
793      * be too long), and then calling {toEthSignedMessageHash} on it.
794      */
795     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
796         (address recovered, RecoverError error) = tryRecover(hash, signature);
797         _throwError(error);
798         return recovered;
799     }
800 
801     /**
802      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
803      *
804      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
805      *
806      * _Available since v4.3._
807      */
808     function tryRecover(
809         bytes32 hash,
810         bytes32 r,
811         bytes32 vs
812     ) internal pure returns (address, RecoverError) {
813         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
814         uint8 v = uint8((uint256(vs) >> 255) + 27);
815         return tryRecover(hash, v, r, s);
816     }
817 
818     /**
819      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
820      *
821      * _Available since v4.2._
822      */
823     function recover(
824         bytes32 hash,
825         bytes32 r,
826         bytes32 vs
827     ) internal pure returns (address) {
828         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
829         _throwError(error);
830         return recovered;
831     }
832 
833     /**
834      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
835      * `r` and `s` signature fields separately.
836      *
837      * _Available since v4.3._
838      */
839     function tryRecover(
840         bytes32 hash,
841         uint8 v,
842         bytes32 r,
843         bytes32 s
844     ) internal pure returns (address, RecoverError) {
845         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
846         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
847         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
848         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
849         //
850         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
851         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
852         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
853         // these malleable signatures as well.
854         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
855             return (address(0), RecoverError.InvalidSignatureS);
856         }
857 
858         // If the signature is valid (and not malleable), return the signer address
859         address signer = ecrecover(hash, v, r, s);
860         if (signer == address(0)) {
861             return (address(0), RecoverError.InvalidSignature);
862         }
863 
864         return (signer, RecoverError.NoError);
865     }
866 
867     /**
868      * @dev Overload of {ECDSA-recover} that receives the `v`,
869      * `r` and `s` signature fields separately.
870      */
871     function recover(
872         bytes32 hash,
873         uint8 v,
874         bytes32 r,
875         bytes32 s
876     ) internal pure returns (address) {
877         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
878         _throwError(error);
879         return recovered;
880     }
881 
882     /**
883      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
884      * produces hash corresponding to the one signed with the
885      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
886      * JSON-RPC method as part of EIP-191.
887      *
888      * See {recover}.
889      */
890     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
891         // 32 is the length in bytes of hash,
892         // enforced by the type signature above
893         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
894     }
895 
896     /**
897      * @dev Returns an Ethereum Signed Message, created from `s`. This
898      * produces hash corresponding to the one signed with the
899      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
900      * JSON-RPC method as part of EIP-191.
901      *
902      * See {recover}.
903      */
904     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
905         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
906     }
907 
908     /**
909      * @dev Returns an Ethereum Signed Typed Data, created from a
910      * `domainSeparator` and a `structHash`. This produces hash corresponding
911      * to the one signed with the
912      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
913      * JSON-RPC method as part of EIP-712.
914      *
915      * See {recover}.
916      */
917     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
918         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
919     }
920 }
921 
922 
923 // File contracts/wasd/WAESUpgrade.sol
924 pragma solidity ^0.8.18;
925 
926 contract WAESUpgrade is Ownable {
927     using ECDSA for bytes32;
928 
929     IERC721 public WAES;
930     mapping(address => bool) private _operators;
931     mapping(string => bool) private _requestIdUsed;
932 
933     event PickaxesBought(
934         string requestId,
935         uint256 pickaxesPrice,
936         uint256[] tokenIds,
937         uint256[] extraData
938     );
939 
940     constructor(address waesAddress) Ownable() {
941         WAES = IERC721(waesAddress);
942         _operators[msg.sender] = true;
943     }
944 
945     modifier onlyOperators() {
946         require(
947             _operators[msg.sender],
948             "WAESUpgrade: the caller is not the operator"
949         );
950         _;
951     }
952 
953     function checkTokenOwnershipBulk(
954         address owner,
955         IERC721 nftContract,
956         uint256[] calldata tokenIds
957     ) public view returns (bool) {
958         for (uint256 i = 0; i < tokenIds.length; i++)
959             try nftContract.ownerOf(tokenIds[i]) returns (address nftOwner) {
960                 if (owner != nftOwner) return false;
961             } catch {
962                 return false;
963             }
964         return true;
965     }
966 
967     function setOperators(
968         address[] calldata operators,
969         bool[] calldata isOperators
970     ) external onlyOwner {
971         require(
972             operators.length == isOperators.length,
973             "WAESUpgrade: the number of operators and the number of statuses must equal"
974         );
975         for (uint256 i = 0; i < operators.length; i++)
976             _operators[operators[i]] = isOperators[i];
977     }
978 
979     function updateConfigs(address waesAddress) external onlyOperators {
980         WAES = IERC721(waesAddress);
981     }
982 
983     function buyPickaxes(
984         string calldata requestId,
985         uint256 pickaxesPrice,
986         uint256[] calldata tokenIds,
987         uint256[] calldata extraData,
988         bytes calldata signature
989     ) external payable {
990         require(
991             !_requestIdUsed[requestId],
992             "WAESUpgrade: the request ID has been used before"
993         );
994 
995         // Verify signature
996         bytes memory message = abi.encodePacked(
997             msg.sender,
998             requestId,
999             pickaxesPrice
1000         );
1001         for (uint256 i = 0; i < tokenIds.length; i++)
1002             message = bytes.concat(message, abi.encodePacked(tokenIds[i]));
1003         for (uint256 i = 0; i < extraData.length; i++)
1004             message = bytes.concat(message, abi.encodePacked(extraData[i]));
1005         bytes32 messageHash = keccak256(message).toEthSignedMessageHash();
1006         require(
1007             _operators[messageHash.recover(signature)],
1008             "WAESUpgrade: the signature is invalid"
1009         );
1010 
1011         // Verify payment
1012         require(
1013             msg.value >= pickaxesPrice,
1014             "WAESUpgrade: the payment is insufficient"
1015         );
1016         if (msg.value > pickaxesPrice) {
1017             (bool success, ) = payable(msg.sender).call{
1018                 value: msg.value - pickaxesPrice
1019             }("");
1020             require(
1021                 success,
1022                 "WAESUpgrade: the excess is failed to be returned"
1023             );
1024         }
1025 
1026         // Verify WAES ownership
1027         require(
1028             checkTokenOwnershipBulk(msg.sender, WAES, tokenIds),
1029             "WAESUpgrade: holders must own all these NFTs to upgrade"
1030         );
1031 
1032         _requestIdUsed[requestId] = true;
1033 
1034         emit PickaxesBought(requestId, pickaxesPrice, tokenIds, extraData);
1035     }
1036 
1037     function withdrawUpgradingFee(address recipient) external onlyOwner {
1038         (bool success, ) = payable(recipient).call{
1039             value: address(this).balance
1040         }("");
1041         require(
1042             success,
1043             "WAESUpgrade: the process of withdrawing airdrop fee is failed"
1044         );
1045     }
1046 }