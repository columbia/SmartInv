1 // SPDX-License-Identifier: MIT
2 
3 /*********************************
4             _
5    lol      /\) _
6        _   / / (/\  lol
7       /\) ( Y)  \ \
8      / /   ""   (Y )
9     ( Y)  _      ""
10      ""  (/\ lol   _
11    lol    \ \     /\)
12           (Y )   / /
13            ""   ( Y)
14                  ""
15  *********************************/
16 
17  // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Standard math utilities missing in the Solidity language.
23  */
24 library Math {
25     enum Rounding {
26         Down, // Toward negative infinity
27         Up, // Toward infinity
28         Zero // Toward zero
29     }
30 
31     /**
32      * @dev Returns the largest of two numbers.
33      */
34     function max(uint256 a, uint256 b) internal pure returns (uint256) {
35         return a > b ? a : b;
36     }
37 
38     /**
39      * @dev Returns the smallest of two numbers.
40      */
41     function min(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a < b ? a : b;
43     }
44 
45     /**
46      * @dev Returns the average of two numbers. The result is rounded towards
47      * zero.
48      */
49     function average(uint256 a, uint256 b) internal pure returns (uint256) {
50         // (a + b) / 2 can overflow.
51         return (a & b) + (a ^ b) / 2;
52     }
53 
54     /**
55      * @dev Returns the ceiling of the division of two numbers.
56      *
57      * This differs from standard division with `/` in that it rounds up instead
58      * of rounding down.
59      */
60     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
61         // (a + b - 1) / b can overflow on addition, so we distribute.
62         return a == 0 ? 0 : (a - 1) / b + 1;
63     }
64 
65     /**
66      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
67      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
68      * with further edits by Uniswap Labs also under MIT license.
69      */
70     function mulDiv(
71         uint256 x,
72         uint256 y,
73         uint256 denominator
74     ) internal pure returns (uint256 result) {
75         unchecked {
76             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
77             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
78             // variables such that product = prod1 * 2^256 + prod0.
79             uint256 prod0; // Least significant 256 bits of the product
80             uint256 prod1; // Most significant 256 bits of the product
81             assembly {
82                 let mm := mulmod(x, y, not(0))
83                 prod0 := mul(x, y)
84                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
85             }
86 
87             // Handle non-overflow cases, 256 by 256 division.
88             if (prod1 == 0) {
89                 return prod0 / denominator;
90             }
91 
92             // Make sure the result is less than 2^256. Also prevents denominator == 0.
93             require(denominator > prod1);
94 
95             ///////////////////////////////////////////////
96             // 512 by 256 division.
97             ///////////////////////////////////////////////
98 
99             // Make division exact by subtracting the remainder from [prod1 prod0].
100             uint256 remainder;
101             assembly {
102                 // Compute remainder using mulmod.
103                 remainder := mulmod(x, y, denominator)
104 
105                 // Subtract 256 bit number from 512 bit number.
106                 prod1 := sub(prod1, gt(remainder, prod0))
107                 prod0 := sub(prod0, remainder)
108             }
109 
110             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
111             // See https://cs.stackexchange.com/q/138556/92363.
112 
113             // Does not overflow because the denominator cannot be zero at this stage in the function.
114             uint256 twos = denominator & (~denominator + 1);
115             assembly {
116                 // Divide denominator by twos.
117                 denominator := div(denominator, twos)
118 
119                 // Divide [prod1 prod0] by twos.
120                 prod0 := div(prod0, twos)
121 
122                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
123                 twos := add(div(sub(0, twos), twos), 1)
124             }
125 
126             // Shift in bits from prod1 into prod0.
127             prod0 |= prod1 * twos;
128 
129             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
130             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
131             // four bits. That is, denominator * inv = 1 mod 2^4.
132             uint256 inverse = (3 * denominator) ^ 2;
133 
134             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
135             // in modular arithmetic, doubling the correct bits in each step.
136             inverse *= 2 - denominator * inverse; // inverse mod 2^8
137             inverse *= 2 - denominator * inverse; // inverse mod 2^16
138             inverse *= 2 - denominator * inverse; // inverse mod 2^32
139             inverse *= 2 - denominator * inverse; // inverse mod 2^64
140             inverse *= 2 - denominator * inverse; // inverse mod 2^128
141             inverse *= 2 - denominator * inverse; // inverse mod 2^256
142 
143             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
144             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
145             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
146             // is no longer required.
147             result = prod0 * inverse;
148             return result;
149         }
150     }
151 
152     /**
153      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
154      */
155     function mulDiv(
156         uint256 x,
157         uint256 y,
158         uint256 denominator,
159         Rounding rounding
160     ) internal pure returns (uint256) {
161         uint256 result = mulDiv(x, y, denominator);
162         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
163             result += 1;
164         }
165         return result;
166     }
167 
168     /**
169      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
170      *
171      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
172      */
173     function sqrt(uint256 a) internal pure returns (uint256) {
174         if (a == 0) {
175             return 0;
176         }
177 
178         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
179         //
180         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
181         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
182         //
183         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
184         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
185         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
186         //
187         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
188         uint256 result = 1 << (log2(a) >> 1);
189 
190         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
191         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
192         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
193         // into the expected uint128 result.
194         unchecked {
195             result = (result + a / result) >> 1;
196             result = (result + a / result) >> 1;
197             result = (result + a / result) >> 1;
198             result = (result + a / result) >> 1;
199             result = (result + a / result) >> 1;
200             result = (result + a / result) >> 1;
201             result = (result + a / result) >> 1;
202             return min(result, a / result);
203         }
204     }
205 
206     /**
207      * @notice Calculates sqrt(a), following the selected rounding direction.
208      */
209     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
210         unchecked {
211             uint256 result = sqrt(a);
212             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
213         }
214     }
215 
216     /**
217      * @dev Return the log in base 2, rounded down, of a positive value.
218      * Returns 0 if given 0.
219      */
220     function log2(uint256 value) internal pure returns (uint256) {
221         uint256 result = 0;
222         unchecked {
223             if (value >> 128 > 0) {
224                 value >>= 128;
225                 result += 128;
226             }
227             if (value >> 64 > 0) {
228                 value >>= 64;
229                 result += 64;
230             }
231             if (value >> 32 > 0) {
232                 value >>= 32;
233                 result += 32;
234             }
235             if (value >> 16 > 0) {
236                 value >>= 16;
237                 result += 16;
238             }
239             if (value >> 8 > 0) {
240                 value >>= 8;
241                 result += 8;
242             }
243             if (value >> 4 > 0) {
244                 value >>= 4;
245                 result += 4;
246             }
247             if (value >> 2 > 0) {
248                 value >>= 2;
249                 result += 2;
250             }
251             if (value >> 1 > 0) {
252                 result += 1;
253             }
254         }
255         return result;
256     }
257 
258     /**
259      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
260      * Returns 0 if given 0.
261      */
262     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
263         unchecked {
264             uint256 result = log2(value);
265             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
266         }
267     }
268 
269     /**
270      * @dev Return the log in base 10, rounded down, of a positive value.
271      * Returns 0 if given 0.
272      */
273     function log10(uint256 value) internal pure returns (uint256) {
274         uint256 result = 0;
275         unchecked {
276             if (value >= 10**64) {
277                 value /= 10**64;
278                 result += 64;
279             }
280             if (value >= 10**32) {
281                 value /= 10**32;
282                 result += 32;
283             }
284             if (value >= 10**16) {
285                 value /= 10**16;
286                 result += 16;
287             }
288             if (value >= 10**8) {
289                 value /= 10**8;
290                 result += 8;
291             }
292             if (value >= 10**4) {
293                 value /= 10**4;
294                 result += 4;
295             }
296             if (value >= 10**2) {
297                 value /= 10**2;
298                 result += 2;
299             }
300             if (value >= 10**1) {
301                 result += 1;
302             }
303         }
304         return result;
305     }
306 
307     /**
308      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
309      * Returns 0 if given 0.
310      */
311     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
312         unchecked {
313             uint256 result = log10(value);
314             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
315         }
316     }
317 
318     /**
319      * @dev Return the log in base 256, rounded down, of a positive value.
320      * Returns 0 if given 0.
321      *
322      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
323      */
324     function log256(uint256 value) internal pure returns (uint256) {
325         uint256 result = 0;
326         unchecked {
327             if (value >> 128 > 0) {
328                 value >>= 128;
329                 result += 16;
330             }
331             if (value >> 64 > 0) {
332                 value >>= 64;
333                 result += 8;
334             }
335             if (value >> 32 > 0) {
336                 value >>= 32;
337                 result += 4;
338             }
339             if (value >> 16 > 0) {
340                 value >>= 16;
341                 result += 2;
342             }
343             if (value >> 8 > 0) {
344                 result += 1;
345             }
346         }
347         return result;
348     }
349 
350     /**
351      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
352      * Returns 0 if given 0.
353      */
354     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
355         unchecked {
356             uint256 result = log256(value);
357             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
358         }
359     }
360 }
361 
362 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 
367 /**
368  * @dev String operations.
369  */
370 library Strings {
371     bytes16 private constant _SYMBOLS = "0123456789abcdef";
372     uint8 private constant _ADDRESS_LENGTH = 20;
373 
374     /**
375      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
376      */
377     function toString(uint256 value) internal pure returns (string memory) {
378         unchecked {
379             uint256 length = Math.log10(value) + 1;
380             string memory buffer = new string(length);
381             uint256 ptr;
382             /// @solidity memory-safe-assembly
383             assembly {
384                 ptr := add(buffer, add(32, length))
385             }
386             while (true) {
387                 ptr--;
388                 /// @solidity memory-safe-assembly
389                 assembly {
390                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
391                 }
392                 value /= 10;
393                 if (value == 0) break;
394             }
395             return buffer;
396         }
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
401      */
402     function toHexString(uint256 value) internal pure returns (string memory) {
403         unchecked {
404             return toHexString(value, Math.log256(value) + 1);
405         }
406     }
407 
408     /**
409      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
410      */
411     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
412         bytes memory buffer = new bytes(2 * length + 2);
413         buffer[0] = "0";
414         buffer[1] = "x";
415         for (uint256 i = 2 * length + 1; i > 1; --i) {
416             buffer[i] = _SYMBOLS[value & 0xf];
417             value >>= 4;
418         }
419         require(value == 0, "Strings: hex length insufficient");
420         return string(buffer);
421     }
422 
423     /**
424      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
425      */
426     function toHexString(address addr) internal pure returns (string memory) {
427         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
428     }
429 }
430 
431 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Interface of the ERC165 standard, as defined in the
437  * https://eips.ethereum.org/EIPS/eip-165[EIP].
438  *
439  * Implementers can declare support of contract interfaces, which can then be
440  * queried by others ({ERC165Checker}).
441  *
442  * For an implementation, see {ERC165}.
443  */
444 interface IERC165 {
445     /**
446      * @dev Returns true if this contract implements the interface defined by
447      * `interfaceId`. See the corresponding
448      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
449      * to learn more about how these ids are created.
450      *
451      * This function call must use less than 30 000 gas.
452      */
453     function supportsInterface(bytes4 interfaceId) external view returns (bool);
454 }
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 
462 /**
463  * @dev Implementation of the {IERC165} interface.
464  *
465  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
466  * for the additional interface id that will be supported. For example:
467  *
468  * ```solidity
469  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
470  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
471  * }
472  * ```
473  *
474  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
475  */
476 abstract contract ERC165 is IERC165 {
477     /**
478      * @dev See {IERC165-supportsInterface}.
479      */
480     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
481         return interfaceId == type(IERC165).interfaceId;
482     }
483 }
484 pragma solidity ^0.8.13;
485 
486 library Address {
487     function isContract(address account) internal view returns (bool) {
488         uint size;
489         assembly {
490             size := extcodesize(account)
491         }
492         return size > 0;
493     }
494 }
495 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev Required interface of an ERC721 compliant contract.
501  */
502 interface IERC721 is IERC165 {
503     /**
504      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
505      */
506     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
510      */
511     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
512 
513     /**
514      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
515      */
516     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
517 
518     /**
519      * @dev Returns the number of tokens in ``owner``'s account.
520      */
521     function balanceOf(address owner) external view returns (uint256 balance);
522 
523     /**
524      * @dev Returns the owner of the `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function ownerOf(uint256 tokenId) external view returns (address owner);
531 
532     /**
533      * @dev Safely transfers `tokenId` token from `from` to `to`.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId,
549         bytes calldata data
550     ) external;
551 
552     /**
553      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
554      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563      *
564      * Emits a {Transfer} event.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) external;
571 
572     /**
573      * @dev Transfers `tokenId` token from `from` to `to`.
574      *
575      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
576      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
577      * understand this adds an external call which potentially creates a reentrancy vulnerability.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must be owned by `from`.
584      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
585      *
586      * Emits a {Transfer} event.
587      */
588     function transferFrom(
589         address from,
590         address to,
591         uint256 tokenId
592     ) external;
593 
594     /**
595      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
596      * The approval is cleared when the token is transferred.
597      *
598      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
599      *
600      * Requirements:
601      *
602      * - The caller must own the token or be an approved operator.
603      * - `tokenId` must exist.
604      *
605      * Emits an {Approval} event.
606      */
607     function approve(address to, uint256 tokenId) external;
608 
609     /**
610      * @dev Approve or remove `operator` as an operator for the caller.
611      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
612      *
613      * Requirements:
614      *
615      * - The `operator` cannot be the caller.
616      *
617      * Emits an {ApprovalForAll} event.
618      */
619     function setApprovalForAll(address operator, bool _approved) external;
620 
621     /**
622      * @dev Returns the account approved for `tokenId` token.
623      *
624      * Requirements:
625      *
626      * - `tokenId` must exist.
627      */
628     function getApproved(uint256 tokenId) external view returns (address operator);
629 
630     /**
631      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
632      *
633      * See {setApprovalForAll}
634      */
635     function isApprovedForAll(address owner, address operator) external view returns (bool);
636 }
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 /**
643  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
644  * @dev See https://eips.ethereum.org/EIPS/eip-721
645  */
646 interface IERC721Metadata is IERC721 {
647     /**
648      * @dev Returns the token collection name.
649      */
650     function name() external view returns (string memory);
651 
652     /**
653      * @dev Returns the token collection symbol.
654      */
655     function symbol() external view returns (string memory);
656 
657     /**
658      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
659      */
660     function tokenURI(uint256 tokenId) external view returns (string memory);
661 }
662 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 /**
667  * @dev Provides information about the current execution context, including the
668  * sender of the transaction and its data. While these are generally available
669  * via msg.sender and msg.data, they should not be accessed in such a direct
670  * manner, since when dealing with meta-transactions the account sending and
671  * paying for execution may not be the actual sender (as far as an application
672  * is concerned).
673  *
674  * This contract is only required for intermediate, library-like contracts.
675  */
676 abstract contract Context {
677     function _msgSender() internal view virtual returns (address) {
678         return msg.sender;
679     }
680 
681     function _msgData() internal view virtual returns (bytes calldata) {
682         return msg.data;
683     }
684 }
685 
686 pragma solidity ^0.8.13;
687 
688 
689 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
690     using Address for address;
691     using Strings for uint256;
692 
693     string private _name;
694     string private _symbol;
695 
696     address[] internal _owners;
697 
698     mapping(uint256 => address) private _tokenApprovals;
699     mapping(address => mapping(address => bool)) private _operatorApprovals;
700 
701     constructor(string memory name_, string memory symbol_) {
702         _name = name_;
703         _symbol = symbol_;
704     }
705 
706     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
707         return interfaceId == type(IERC721).interfaceId
708         || interfaceId == type(IERC721Metadata).interfaceId
709         || super.supportsInterface(interfaceId);
710     }
711 
712     function balanceOf(address owner) public view virtual override returns (uint256) {
713         require(owner != address(0), "ERC721: address zero is not a valid owner");
714 
715         uint256 count;
716         for (uint256 i; i < _owners.length;) {
717             if (owner == _owners[i]) {
718                 unchecked {
719                     ++count;
720                 }
721             }
722             unchecked {
723                 ++i;
724             }
725         }
726         return count;
727     }
728 
729     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
730         address owner = _owners[tokenId];
731         require(owner != address(0), "ERC721: invalid token ID");
732         return owner;
733     }
734 
735     function name() public view virtual override returns (string memory) {
736         return _name;
737     }
738 
739     function symbol() public view virtual override returns (string memory) {
740         return _symbol;
741     }
742 
743     function approve(address to, uint256 tokenId) public virtual override {
744         address owner = ERC721.ownerOf(tokenId);
745         require(to != owner, "ERC721: approval to current owner");
746 
747         require(
748             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
749             "ERC721: approve caller is not owner nor approved for all"
750         );
751 
752         _approve(to, tokenId);
753     }
754 
755     function getApproved(uint256 tokenId) public view virtual override returns (address) {
756         require(_exists(tokenId), "ERC721: invalid token ID");
757 
758         return _tokenApprovals[tokenId];
759     }
760 
761     function setApprovalForAll(address operator, bool approved) public virtual override {
762         require(_msgSender() != operator, "ERC721: approve to caller");
763         _operatorApprovals[_msgSender()][operator] = approved;
764         emit ApprovalForAll(_msgSender(), operator, approved);
765     }
766 
767     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
768         return _operatorApprovals[owner][operator];
769     }
770 
771     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
772         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
773         _transfer(from, to, tokenId);
774     }
775 
776     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
777         safeTransferFrom(from, to, tokenId, "");
778     }
779 
780     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
781         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
782         _safeTransfer(from, to, tokenId, data);
783     }
784 
785     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
786         _transfer(from, to, tokenId);
787         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
788     }
789 
790     function _exists(uint256 tokenId) internal view virtual returns (bool) {
791         return tokenId < _owners.length && _owners[tokenId] != address(0);
792     }
793 
794     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
795         address owner = ERC721.ownerOf(tokenId);
796         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
797     }
798 
799     function _mint(address to, uint256 tokenId) internal virtual {
800         require(!_exists(tokenId), "ERC721: token already minted");
801 
802         _owners.push(to);
803 
804         emit Transfer(address(0), to, tokenId);
805     }
806 
807     function _burn(uint256 tokenId) internal virtual {
808         address owner = ERC721.ownerOf(tokenId);
809 
810         delete _tokenApprovals[tokenId];
811         delete _owners[tokenId];
812 
813         emit Transfer(owner, address(0), tokenId);
814     }
815 
816     function _transfer(address from, address to, uint256 tokenId) internal virtual {
817         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
818         require(to != address(0), "ERC721: transfer to the zero address");
819 
820         // Clear approvals from the previous owner
821         delete _tokenApprovals[tokenId];
822         _owners[tokenId] = to;
823 
824         emit Transfer(from, to, tokenId);
825     }
826 
827     function _approve(address to, uint256 tokenId) internal virtual {
828         _tokenApprovals[tokenId] = to;
829         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
830     }
831 
832     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private returns (bool) {
833         if (to.isContract()) {
834             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
835                 return retval == IERC721Receiver.onERC721Received.selector;
836             } catch (bytes memory reason) {
837                 if (reason.length == 0) {
838                     revert("ERC721: transfer to non ERC721Receiver implementer");
839                 } else {
840                     assembly {
841                         revert(add(32, reason), mload(reason))
842                     }
843                 }
844             }
845         }
846 
847         return true;
848     }
849 }
850 
851 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
852 
853 pragma solidity ^0.8.0;
854 
855 /**
856  * @title ERC721 token receiver interface
857  * @dev Interface for any contract that wants to support safeTransfers
858  * from ERC721 asset contracts.
859  */
860 interface IERC721Receiver {
861     /**
862      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
863      * by `operator` from `from`, this function is called.
864      *
865      * It must return its Solidity selector to confirm the token transfer.
866      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
867      *
868      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
869      */
870     function onERC721Received(
871         address operator,
872         address from,
873         uint256 tokenId,
874         bytes calldata data
875     ) external returns (bytes4);
876 }
877 
878 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
879 
880 pragma solidity ^0.8.0;
881 
882 
883 /**
884  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
885  * @dev See https://eips.ethereum.org/EIPS/eip-721
886  */
887 interface IERC721Enumerable is IERC721 {
888     /**
889      * @dev Returns the total amount of tokens stored by the contract.
890      */
891     function totalSupply() external view returns (uint256);
892 
893     /**
894      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
895      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
896      */
897     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
898 
899     /**
900      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
901      * Use along with {totalSupply} to enumerate all tokens.
902      */
903     function tokenByIndex(uint256 index) external view returns (uint256);
904 }
905 
906 pragma solidity ^0.8.7;
907 
908 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
909     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
910         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
911     }
912 
913     function totalSupply() public view virtual override returns (uint256) {
914         uint256 count;
915         for (uint256 i; i < _owners.length;) {
916             if (_owners[i] != address(0)) {
917                 unchecked {
918                     ++count;
919                 }
920             }
921 
922             unchecked {
923                 ++i;
924             }
925         }
926 
927         return count;
928     }
929 
930     function tokenByIndex(uint256 index) public view virtual override returns (uint256 tokenId) {
931         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
932         return index;
933     }
934 
935     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
936         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
937 
938         uint256 count;
939         for(uint256 i; i < _owners.length;){
940             if(owner == _owners[i]) {
941                 if(count == index) return i;
942                 else {
943                     unchecked {
944                         ++count;
945                     }
946                 }
947             }
948 
949             unchecked {
950                 ++i;
951             }
952         }
953 
954         revert("ERC721Enumerable: owner index out of bounds");
955     }
956 }
957 
958 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
959 
960 pragma solidity ^0.8.0;
961 
962 /**
963  * @dev Contract module which provides a basic access control mechanism, where
964  * there is an account (an owner) that can be granted exclusive access to
965  * specific functions.
966  *
967  * By default, the owner account will be the one that deploys the contract. This
968  * can later be changed with {transferOwnership}.
969  *
970  * This module is used through inheritance. It will make available the modifier
971  * `onlyOwner`, which can be applied to your functions to restrict their use to
972  * the owner.
973  */
974 abstract contract Ownable is Context {
975     address private _owner;
976 
977     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
978 
979     /**
980      * @dev Initializes the contract setting the deployer as the initial owner.
981      */
982     constructor() {
983         _transferOwnership(_msgSender());
984     }
985 
986     /**
987      * @dev Throws if called by any account other than the owner.
988      */
989     modifier onlyOwner() {
990         _checkOwner();
991         _;
992     }
993 
994     /**
995      * @dev Returns the address of the current owner.
996      */
997     function owner() public view virtual returns (address) {
998         return _owner;
999     }
1000 
1001     /**
1002      * @dev Throws if the sender is not the owner.
1003      */
1004     function _checkOwner() internal view virtual {
1005         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1006     }
1007 
1008     /**
1009      * @dev Leaves the contract without owner. It will not be possible to call
1010      * `onlyOwner` functions anymore. Can only be called by the current owner.
1011      *
1012      * NOTE: Renouncing ownership will leave the contract without an owner,
1013      * thereby removing any functionality that is only available to the owner.
1014      */
1015     function renounceOwnership() public virtual onlyOwner {
1016         _transferOwnership(address(0));
1017     }
1018 
1019     /**
1020      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1021      * Can only be called by the current owner.
1022      */
1023     function transferOwnership(address newOwner) public virtual onlyOwner {
1024         require(newOwner != address(0), "Ownable: new owner is the zero address");
1025         _transferOwnership(newOwner);
1026     }
1027 
1028     /**
1029      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1030      * Internal function without access restriction.
1031      */
1032     function _transferOwnership(address newOwner) internal virtual {
1033         address oldOwner = _owner;
1034         _owner = newOwner;
1035         emit OwnershipTransferred(oldOwner, newOwner);
1036     }
1037 }
1038 
1039 pragma solidity ^0.8.13;
1040 
1041 interface IDickriptor {
1042     function tokenURI(uint256 tokenId, uint256 seed) external view returns (string memory);
1043 }
1044 pragma solidity ^0.8.13;
1045 
1046 contract Dicks is ERC721Enumerable, Ownable {
1047     event SeedUpdated(uint256 indexed tokenId, uint256 seed);
1048 
1049     mapping(uint256 => uint256) internal seeds;
1050     IDickriptor public descriptor;
1051     uint256 public maxSupply = 10000;
1052     uint32 public maxFreeMintAmountPerWallet = 1;
1053     uint256 public cost = 0.001 ether;
1054     bool public minting = false;
1055     bool public canUpdateSeed = true;
1056 
1057     mapping (address => uint32) public NFTPerPublicAddress;
1058 
1059     constructor(IDickriptor newDescriptor) ERC721("Dicks", "DICKS") {
1060         descriptor = newDescriptor;
1061     }
1062 
1063     function mint(uint32 count) external payable {
1064         uint32 nft = NFTPerPublicAddress[msg.sender];
1065         require(minting, "Minting needs to be enabled to start minting");
1066         require(count < 101, "Exceeds max per transaction.");
1067         uint256 nextTokenId = _owners.length;
1068         unchecked {
1069             require(nextTokenId + count < maxSupply, "Exceeds max supply.");
1070         }
1071            if(nft >= maxFreeMintAmountPerWallet)
1072         {
1073             require(msg.value >= cost * count, "Insufficient funds!");
1074         }
1075         else {
1076             uint32 costAmount = count + nft;
1077             if(costAmount > maxFreeMintAmountPerWallet)
1078         {
1079             costAmount = costAmount - maxFreeMintAmountPerWallet;
1080             require(msg.value >= cost * costAmount, "Insufficient funds!");
1081         }
1082         }
1083         NFTPerPublicAddress[msg.sender] = count + nft;
1084 
1085         for (uint32 i; i < count;) {
1086             seeds[nextTokenId] = generateSeed(nextTokenId);
1087             _mint(_msgSender(), nextTokenId);
1088             unchecked { ++nextTokenId; ++i; }
1089         }
1090     }
1091 
1092     function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1093         maxSupply = _maxSupply;
1094     }
1095 
1096     function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1097         maxFreeMintAmountPerWallet = _limit;
1098         delete _limit;
1099     }
1100 
1101     function setMinting(bool value) external onlyOwner {
1102         minting = value;
1103     }
1104 
1105     function setDescriptor(IDickriptor newDescriptor) external onlyOwner {
1106         descriptor = newDescriptor;
1107     }
1108 
1109     function withdraw() external payable onlyOwner {
1110         (bool os,)= payable(owner()).call{value: address(this).balance}("");
1111         require(os);
1112     }
1113 
1114     function updateSeed(uint256 tokenId, uint256 seed) external onlyOwner {
1115         require(canUpdateSeed, "Cannot set the seed");
1116         seeds[tokenId] = seed;
1117         emit SeedUpdated(tokenId, seed);
1118     }
1119 
1120     function disableSeedUpdate() external onlyOwner {
1121         canUpdateSeed = false;
1122     }
1123 
1124     function burn(uint256 tokenId) public {
1125         require(_isApprovedOrOwner(_msgSender(), tokenId), "Not approved to burn.");
1126         delete seeds[tokenId];
1127         _burn(tokenId);
1128     }
1129 
1130     function getSeed(uint256 tokenId) public view returns (uint256) {
1131         require(_exists(tokenId), "Dick does not exist.");
1132         return seeds[tokenId];
1133     }
1134 
1135     function tokenURI(uint256 tokenId) public view returns (string memory) {
1136         require(_exists(tokenId), "Dick does not exist.");
1137         uint256 seed = seeds[tokenId];
1138         return descriptor.tokenURI(tokenId, seed);
1139     }
1140 
1141     function generateSeed(uint256 tokenId) private view returns (uint256) {
1142         uint256 r = random(tokenId);
1143         uint256 headSeed = 100 * (r % 7 + 10) + ((r >> 48) % 20 + 10);
1144         uint256 topshaftSeed = 100 * ((r >> 96) % 6 + 10) + ((r >> 96) % 20 + 10);
1145         uint256 bottomshaftSeed = 100 * ((r >> 192) % 2 + 10) + ((r >> 192) % 20 + 10);
1146         uint256 ballsSeed = 100 * ((r >> 144) % 7 + 10) + ((r >> 144) % 20 + 10);
1147         return 10000 * (10000 * (10000 * headSeed + topshaftSeed) + ballsSeed) + bottomshaftSeed;
1148     }
1149 
1150     function random(uint256 tokenId) private view returns (uint256 pseudoRandomness) {
1151         pseudoRandomness = uint256(
1152             keccak256(abi.encodePacked(blockhash(block.number - 1), tokenId))
1153         );
1154 
1155         return pseudoRandomness;
1156     }
1157 }