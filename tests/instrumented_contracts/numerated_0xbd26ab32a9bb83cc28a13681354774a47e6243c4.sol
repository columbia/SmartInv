1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.15;
3 
4 interface IERC165 {
5     /**
6      * @dev Returns true if this contract implements the interface defined by
7      * `interfaceId`. See the corresponding
8      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
9      * to learn more about how these ids are created.
10      *
11      * This function call must use less than 30 000 gas.
12      */
13     function supportsInterface(bytes4 interfaceId) external view returns (bool);
14 }
15 
16 /**
17  * @dev Required interface of an ERC721 compliant contract.
18  */
19 interface IERC721 is IERC165 {
20     /**
21      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
22      */
23     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
24 
25     /**
26      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
27      */
28     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
29 
30     /**
31      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
32      */
33     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
34 
35     /**
36      * @dev Returns the number of tokens in ``owner``'s account.
37      */
38     function balanceOf(address owner) external view returns (uint256 balance);
39 
40     /**
41      * @dev Returns the owner of the `tokenId` token.
42      *
43      * Requirements:
44      *
45      * - `tokenId` must exist.
46      */
47     function ownerOf(uint256 tokenId) external view returns (address owner);
48 
49     /**
50      * @dev Safely transfers `tokenId` token from `from` to `to`.
51      *
52      * Requirements:
53      *
54      * - `from` cannot be the zero address.
55      * - `to` cannot be the zero address.
56      * - `tokenId` token must exist and be owned by `from`.
57      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
58      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
59      *
60      * Emits a {Transfer} event.
61      */
62     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(address from, address to, uint256 tokenId) external;
79 
80     /**
81      * @dev Transfers `tokenId` token from `from` to `to`.
82      *
83      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
84      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
85      * understand this adds an external call which potentially creates a reentrancy vulnerability.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(address from, address to, uint256 tokenId) external;
97 
98     /**
99      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
100      * The approval is cleared when the token is transferred.
101      *
102      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
103      *
104      * Requirements:
105      *
106      * - The caller must own the token or be an approved operator.
107      * - `tokenId` must exist.
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address to, uint256 tokenId) external;
112 
113     /**
114      * @dev Approve or remove `operator` as an operator for the caller.
115      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
116      *
117      * Requirements:
118      *
119      * - The `operator` cannot be the caller.
120      *
121      * Emits an {ApprovalForAll} event.
122      */
123     function setApprovalForAll(address operator, bool approved) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
136      *
137      * See {setApprovalForAll}
138      */
139     function isApprovedForAll(address owner, address operator) external view returns (bool);
140 }
141 
142 interface IERC721Receiver {
143     function onERC721Received(
144         address operator,
145         address from,
146         uint256 tokenId,
147         bytes calldata data
148     ) external returns (bytes4);
149 }
150 
151 interface IERC721Metadata is IERC721 {
152     /**
153      * @dev Returns the token collection name.
154      */
155     function name() external view returns (string memory);
156 
157     /**
158      * @dev Returns the token collection symbol.
159      */
160     function symbol() external view returns (string memory);
161 
162     /**
163      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
164      */
165     function tokenURI(uint256 tokenId) external view returns (string memory);
166 }
167 
168 library Address {
169     /**
170      * @dev Returns true if `account` is a contract.
171      *
172      * [IMPORTANT]
173      * ====
174      * It is unsafe to assume that an address for which this function returns
175      * false is an externally-owned account (EOA) and not a contract.
176      *
177      * Among others, `isContract` will return false for the following
178      * types of addresses:
179      *
180      *  - an externally-owned account
181      *  - a contract in construction
182      *  - an address where a contract will be created
183      *  - an address where a contract lived, but was destroyed
184      *
185      * Furthermore, `isContract` will also return true if the target contract within
186      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
187      * which only has an effect at the end of a transaction.
188      * ====
189      *
190      * [IMPORTANT]
191      * ====
192      * You shouldn't rely on `isContract` to protect against flash loan attacks!
193      *
194      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
195      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
196      * constructor.
197      * ====
198      */
199     function isContract(address account) internal view returns (bool) {
200         // This method relies on extcodesize/address.code.length, which returns 0
201         // for contracts in construction, since the code is only stored at the end
202         // of the constructor execution.
203 
204         return account.code.length > 0;
205     }
206 }
207 
208 abstract contract Context {
209     function _msgSender() internal view virtual returns (address) {
210         return msg.sender;
211     }
212 }
213 
214 library Math {
215     enum Rounding {
216         Down, // Toward negative infinity
217         Up, // Toward infinity
218         Zero // Toward zero
219     }
220 
221     /**
222      * @dev Returns the largest of two numbers.
223      */
224     function max(uint256 a, uint256 b) internal pure returns (uint256) {
225         return a > b ? a : b;
226     }
227 
228     /**
229      * @dev Returns the smallest of two numbers.
230      */
231     function min(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a < b ? a : b;
233     }
234 
235     /**
236      * @dev Returns the average of two numbers. The result is rounded towards
237      * zero.
238      */
239     function average(uint256 a, uint256 b) internal pure returns (uint256) {
240         // (a + b) / 2 can overflow.
241         return (a & b) + (a ^ b) / 2;
242     }
243 
244     /**
245      * @dev Returns the ceiling of the division of two numbers.
246      *
247      * This differs from standard division with `/` in that it rounds up instead
248      * of rounding down.
249      */
250     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
251         // (a + b - 1) / b can overflow on addition, so we distribute.
252         return a == 0 ? 0 : (a - 1) / b + 1;
253     }
254 
255     /**
256      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
257      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
258      * with further edits by Uniswap Labs also under MIT license.
259      */
260     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
261         unchecked {
262             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
263             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
264             // variables such that product = prod1 * 2^256 + prod0.
265             uint256 prod0; // Least significant 256 bits of the product
266             uint256 prod1; // Most significant 256 bits of the product
267             assembly {
268                 let mm := mulmod(x, y, not(0))
269                 prod0 := mul(x, y)
270                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
271             }
272 
273             // Handle non-overflow cases, 256 by 256 division.
274             if (prod1 == 0) {
275                 return prod0 / denominator;
276             }
277 
278             // Make sure the result is less than 2^256. Also prevents denominator == 0.
279             require(denominator > prod1, "Math: mulDiv overflow");
280 
281             ///////////////////////////////////////////////
282             // 512 by 256 division.
283             ///////////////////////////////////////////////
284 
285             // Make division exact by subtracting the remainder from [prod1 prod0].
286             uint256 remainder;
287             assembly {
288                 // Compute remainder using mulmod.
289                 remainder := mulmod(x, y, denominator)
290 
291                 // Subtract 256 bit number from 512 bit number.
292                 prod1 := sub(prod1, gt(remainder, prod0))
293                 prod0 := sub(prod0, remainder)
294             }
295 
296             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
297             // See https://cs.stackexchange.com/q/138556/92363.
298 
299             // Does not overflow because the denominator cannot be zero at this stage in the function.
300             uint256 twos = denominator & (~denominator + 1);
301             assembly {
302                 // Divide denominator by twos.
303                 denominator := div(denominator, twos)
304 
305                 // Divide [prod1 prod0] by twos.
306                 prod0 := div(prod0, twos)
307 
308                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
309                 twos := add(div(sub(0, twos), twos), 1)
310             }
311 
312             // Shift in bits from prod1 into prod0.
313             prod0 |= prod1 * twos;
314 
315             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
316             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
317             // four bits. That is, denominator * inv = 1 mod 2^4.
318             uint256 inverse = (3 * denominator) ^ 2;
319 
320             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
321             // in modular arithmetic, doubling the correct bits in each step.
322             inverse *= 2 - denominator * inverse; // inverse mod 2^8
323             inverse *= 2 - denominator * inverse; // inverse mod 2^16
324             inverse *= 2 - denominator * inverse; // inverse mod 2^32
325             inverse *= 2 - denominator * inverse; // inverse mod 2^64
326             inverse *= 2 - denominator * inverse; // inverse mod 2^128
327             inverse *= 2 - denominator * inverse; // inverse mod 2^256
328 
329             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
330             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
331             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
332             // is no longer required.
333             result = prod0 * inverse;
334             return result;
335         }
336     }
337 
338     /**
339      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
340      */
341     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
342         uint256 result = mulDiv(x, y, denominator);
343         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
344             result += 1;
345         }
346         return result;
347     }
348 
349     /**
350      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
351      *
352      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
353      */
354     function sqrt(uint256 a) internal pure returns (uint256) {
355         if (a == 0) {
356             return 0;
357         }
358 
359         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
360         //
361         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
362         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
363         //
364         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
365         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
366         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
367         //
368         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
369         uint256 result = 1 << (log2(a) >> 1);
370 
371         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
372         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
373         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
374         // into the expected uint128 result.
375         unchecked {
376             result = (result + a / result) >> 1;
377             result = (result + a / result) >> 1;
378             result = (result + a / result) >> 1;
379             result = (result + a / result) >> 1;
380             result = (result + a / result) >> 1;
381             result = (result + a / result) >> 1;
382             result = (result + a / result) >> 1;
383             return min(result, a / result);
384         }
385     }
386 
387     /**
388      * @notice Calculates sqrt(a), following the selected rounding direction.
389      */
390     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
391         unchecked {
392             uint256 result = sqrt(a);
393             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
394         }
395     }
396 
397     /**
398      * @dev Return the log in base 2, rounded down, of a positive value.
399      * Returns 0 if given 0.
400      */
401     function log2(uint256 value) internal pure returns (uint256) {
402         uint256 result = 0;
403         unchecked {
404             if (value >> 128 > 0) {
405                 value >>= 128;
406                 result += 128;
407             }
408             if (value >> 64 > 0) {
409                 value >>= 64;
410                 result += 64;
411             }
412             if (value >> 32 > 0) {
413                 value >>= 32;
414                 result += 32;
415             }
416             if (value >> 16 > 0) {
417                 value >>= 16;
418                 result += 16;
419             }
420             if (value >> 8 > 0) {
421                 value >>= 8;
422                 result += 8;
423             }
424             if (value >> 4 > 0) {
425                 value >>= 4;
426                 result += 4;
427             }
428             if (value >> 2 > 0) {
429                 value >>= 2;
430                 result += 2;
431             }
432             if (value >> 1 > 0) {
433                 result += 1;
434             }
435         }
436         return result;
437     }
438 
439     /**
440      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
441      * Returns 0 if given 0.
442      */
443     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
444         unchecked {
445             uint256 result = log2(value);
446             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
447         }
448     }
449 
450     /**
451      * @dev Return the log in base 10, rounded down, of a positive value.
452      * Returns 0 if given 0.
453      */
454     function log10(uint256 value) internal pure returns (uint256) {
455         uint256 result = 0;
456         unchecked {
457             if (value >= 10 ** 64) {
458                 value /= 10 ** 64;
459                 result += 64;
460             }
461             if (value >= 10 ** 32) {
462                 value /= 10 ** 32;
463                 result += 32;
464             }
465             if (value >= 10 ** 16) {
466                 value /= 10 ** 16;
467                 result += 16;
468             }
469             if (value >= 10 ** 8) {
470                 value /= 10 ** 8;
471                 result += 8;
472             }
473             if (value >= 10 ** 4) {
474                 value /= 10 ** 4;
475                 result += 4;
476             }
477             if (value >= 10 ** 2) {
478                 value /= 10 ** 2;
479                 result += 2;
480             }
481             if (value >= 10 ** 1) {
482                 result += 1;
483             }
484         }
485         return result;
486     }
487 
488     /**
489      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
490      * Returns 0 if given 0.
491      */
492     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
493         unchecked {
494             uint256 result = log10(value);
495             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
496         }
497     }
498 
499     /**
500      * @dev Return the log in base 256, rounded down, of a positive value.
501      * Returns 0 if given 0.
502      *
503      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
504      */
505     function log256(uint256 value) internal pure returns (uint256) {
506         uint256 result = 0;
507         unchecked {
508             if (value >> 128 > 0) {
509                 value >>= 128;
510                 result += 16;
511             }
512             if (value >> 64 > 0) {
513                 value >>= 64;
514                 result += 8;
515             }
516             if (value >> 32 > 0) {
517                 value >>= 32;
518                 result += 4;
519             }
520             if (value >> 16 > 0) {
521                 value >>= 16;
522                 result += 2;
523             }
524             if (value >> 8 > 0) {
525                 result += 1;
526             }
527         }
528         return result;
529     }
530 
531     /**
532      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
533      * Returns 0 if given 0.
534      */
535     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
536         unchecked {
537             uint256 result = log256(value);
538             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
539         }
540     }
541 }
542 
543 library SignedMath {
544     /**
545      * @dev Returns the largest of two signed numbers.
546      */
547     function max(int256 a, int256 b) internal pure returns (int256) {
548         return a > b ? a : b;
549     }
550 
551     /**
552      * @dev Returns the smallest of two signed numbers.
553      */
554     function min(int256 a, int256 b) internal pure returns (int256) {
555         return a < b ? a : b;
556     }
557 
558     /**
559      * @dev Returns the average of two signed numbers without overflow.
560      * The result is rounded towards zero.
561      */
562     function average(int256 a, int256 b) internal pure returns (int256) {
563         // Formula from the book "Hacker's Delight"
564         int256 x = (a & b) + ((a ^ b) >> 1);
565         return x + (int256(uint256(x) >> 255) & (a ^ b));
566     }
567 
568     /**
569      * @dev Returns the absolute unsigned value of a signed value.
570      */
571     function abs(int256 n) internal pure returns (uint256) {
572         unchecked {
573             // must be unchecked in order to support `n = type(int256).min`
574             return uint256(n >= 0 ? n : -n);
575         }
576     }
577 }
578 
579 /**
580  * @dev String operations.
581  */
582 library Strings {
583     bytes16 private constant _SYMBOLS = "0123456789abcdef";
584     uint8 private constant _ADDRESS_LENGTH = 20;
585 
586     /**
587      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
588      */
589     function toString(uint256 value) internal pure returns (string memory) {
590         unchecked {
591             uint256 length = Math.log10(value) + 1;
592             string memory buffer = new string(length);
593             uint256 ptr;
594             /// @solidity memory-safe-assembly
595             assembly {
596                 ptr := add(buffer, add(32, length))
597             }
598             while (true) {
599                 ptr--;
600                 /// @solidity memory-safe-assembly
601                 assembly {
602                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
603                 }
604                 value /= 10;
605                 if (value == 0) break;
606             }
607             return buffer;
608         }
609     }
610 
611     /**
612      * @dev Converts a `int256` to its ASCII `string` decimal representation.
613      */
614     function toString(int256 value) internal pure returns (string memory) {
615         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
616     }
617 
618     /**
619      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
620      */
621     function toHexString(uint256 value) internal pure returns (string memory) {
622         unchecked {
623             return toHexString(value, Math.log256(value) + 1);
624         }
625     }
626 
627     /**
628      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
629      */
630     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
631         bytes memory buffer = new bytes(2 * length + 2);
632         buffer[0] = "0";
633         buffer[1] = "x";
634         for (uint256 i = 2 * length + 1; i > 1; --i) {
635             buffer[i] = _SYMBOLS[value & 0xf];
636             value >>= 4;
637         }
638         require(value == 0, "Strings: hex length insufficient");
639         return string(buffer);
640     }
641 
642     /**
643      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
644      */
645     function toHexString(address addr) internal pure returns (string memory) {
646         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
647     }
648 
649     /**
650      * @dev Returns true if the two strings are equal.
651      */
652     function equal(string memory a, string memory b) internal pure returns (bool) {
653         return keccak256(bytes(a)) == keccak256(bytes(b));
654     }
655 }
656 
657 abstract contract ERC165 is IERC165 {
658     /**
659      * @dev See {IERC165-supportsInterface}.
660      */
661     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
662         return interfaceId == type(IERC165).interfaceId;
663     }
664 }
665 
666 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
667     using Address for address;
668     using Strings for uint256;
669 
670     // Token name
671     string private _name;
672 
673     // Token symbol
674     string private _symbol;
675 
676     // Mapping from token ID to owner address
677     mapping(uint256 => address) private _owners;
678 
679     // Mapping owner address to token count
680     mapping(address => uint256) private _balances;
681 
682     // Mapping from token ID to approved address
683     mapping(uint256 => address) private _tokenApprovals;
684 
685     // Mapping from owner to operator approvals
686     mapping(address => mapping(address => bool)) private _operatorApprovals;
687 
688     /**
689      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
690      */
691     constructor(string memory name_, string memory symbol_) {
692         _name = name_;
693         _symbol = symbol_;
694     }
695 
696     /**
697      * @dev See {IERC165-supportsInterface}.
698      */
699     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
700         return
701             interfaceId == type(IERC721).interfaceId ||
702             interfaceId == type(IERC721Metadata).interfaceId ||
703             super.supportsInterface(interfaceId);
704     }
705 
706     /**
707      * @dev See {IERC721-balanceOf}.
708      */
709     function balanceOf(address owner) public view virtual override returns (uint256) {
710         require(owner != address(0), "ERC721: address zero is not a valid owner");
711         return _balances[owner];
712     }
713 
714     /**
715      * @dev See {IERC721-ownerOf}.
716      */
717     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
718         address owner = _ownerOf(tokenId);
719         require(owner != address(0), "ERC721: invalid token ID");
720         return owner;
721     }
722 
723     /**
724      * @dev See {IERC721Metadata-name}.
725      */
726     function name() public view virtual override returns (string memory) {
727         return _name;
728     }
729 
730     /**
731      * @dev See {IERC721Metadata-symbol}.
732      */
733     function symbol() public view virtual override returns (string memory) {
734         return _symbol;
735     }
736 
737     /**
738      * @dev See {IERC721Metadata-tokenURI}.
739      */
740     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
741         _requireMinted(tokenId);
742 
743         string memory baseURI = _baseURI();
744         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
745     }
746 
747     /**
748      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
749      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
750      * by default, can be overridden in child contracts.
751      */
752     function _baseURI() internal view virtual returns (string memory) {
753         return "";
754     }
755 
756     /**
757      * @dev See {IERC721-approve}.
758      */
759     function approve(address to, uint256 tokenId) public virtual override {
760         address owner = ERC721.ownerOf(tokenId);
761         require(to != owner, "ERC721: approval to current owner");
762 
763         require(
764             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
765             "ERC721: approve caller is not token owner or approved for all"
766         );
767 
768         _approve(to, tokenId);
769     }
770 
771     /**
772      * @dev See {IERC721-getApproved}.
773      */
774     function getApproved(uint256 tokenId) public view virtual override returns (address) {
775         _requireMinted(tokenId);
776 
777         return _tokenApprovals[tokenId];
778     }
779 
780     /**
781      * @dev See {IERC721-setApprovalForAll}.
782      */
783     function setApprovalForAll(address operator, bool approved) public virtual override {
784         _setApprovalForAll(_msgSender(), operator, approved);
785     }
786 
787     /**
788      * @dev See {IERC721-isApprovedForAll}.
789      */
790     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
791         return _operatorApprovals[owner][operator];
792     }
793 
794     /**
795      * @dev See {IERC721-transferFrom}.
796      */
797     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
798         //solhint-disable-next-line max-line-length
799         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
800 
801         _transfer(from, to, tokenId);
802     }
803 
804     /**
805      * @dev See {IERC721-safeTransferFrom}.
806      */
807     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
808         safeTransferFrom(from, to, tokenId, "");
809     }
810 
811     /**
812      * @dev See {IERC721-safeTransferFrom}.
813      */
814     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
815         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
816         _safeTransfer(from, to, tokenId, data);
817     }
818 
819     /**
820      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
821      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
822      *
823      * `data` is additional data, it has no specified format and it is sent in call to `to`.
824      *
825      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
826      * implement alternative mechanisms to perform token transfer, such as signature-based.
827      *
828      * Requirements:
829      *
830      * - `from` cannot be the zero address.
831      * - `to` cannot be the zero address.
832      * - `tokenId` token must exist and be owned by `from`.
833      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
838         _transfer(from, to, tokenId);
839         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
840     }
841 
842     /**
843      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
844      */
845     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
846         return _owners[tokenId];
847     }
848 
849     /**
850      * @dev Returns whether `tokenId` exists.
851      *
852      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
853      *
854      * Tokens start existing when they are minted (`_mint`),
855      * and stop existing when they are burned (`_burn`).
856      */
857     function _exists(uint256 tokenId) internal view virtual returns (bool) {
858         return _ownerOf(tokenId) != address(0);
859     }
860 
861     /**
862      * @dev Returns whether `spender` is allowed to manage `tokenId`.
863      *
864      * Requirements:
865      *
866      * - `tokenId` must exist.
867      */
868     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
869         address owner = ERC721.ownerOf(tokenId);
870         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
871     }
872 
873     /**
874      * @dev Safely mints `tokenId` and transfers it to `to`.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must not exist.
879      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _safeMint(address to, uint256 tokenId) internal virtual {
884         _safeMint(to, tokenId, "");
885     }
886 
887     /**
888      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
889      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
890      */
891     function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
892         _mint(to, tokenId);
893         require(
894             _checkOnERC721Received(address(0), to, tokenId, data),
895             "ERC721: transfer to non ERC721Receiver implementer"
896         );
897     }
898 
899     /**
900      * @dev Mints `tokenId` and transfers it to `to`.
901      *
902      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
903      *
904      * Requirements:
905      *
906      * - `tokenId` must not exist.
907      * - `to` cannot be the zero address.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _mint(address to, uint256 tokenId) internal virtual {
912         require(to != address(0), "ERC721: mint to the zero address");
913         require(!_exists(tokenId), "ERC721: token already minted");
914 
915         _beforeTokenTransfer(address(0), to, tokenId, 1);
916 
917         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
918         require(!_exists(tokenId), "ERC721: token already minted");
919 
920         unchecked {
921             // Will not overflow unless all 2**256 token ids are minted to the same owner.
922             // Given that tokens are minted one by one, it is impossible in practice that
923             // this ever happens. Might change if we allow batch minting.
924             // The ERC fails to describe this case.
925             _balances[to] += 1;
926         }
927 
928         _owners[tokenId] = to;
929 
930         emit Transfer(address(0), to, tokenId);
931 
932         _afterTokenTransfer(address(0), to, tokenId, 1);
933     }
934 
935     /**
936      * @dev Destroys `tokenId`.
937      * The approval is cleared when the token is burned.
938      * This is an internal function that does not check if the sender is authorized to operate on the token.
939      *
940      * Requirements:
941      *
942      * - `tokenId` must exist.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _burn(uint256 tokenId) internal virtual {
947         address owner = ERC721.ownerOf(tokenId);
948 
949         _beforeTokenTransfer(owner, address(0), tokenId, 1);
950 
951         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
952         owner = ERC721.ownerOf(tokenId);
953 
954         // Clear approvals
955         delete _tokenApprovals[tokenId];
956 
957         unchecked {
958             // Cannot overflow, as that would require more tokens to be burned/transferred
959             // out than the owner initially received through minting and transferring in.
960             _balances[owner] -= 1;
961         }
962         delete _owners[tokenId];
963 
964         emit Transfer(owner, address(0), tokenId);
965 
966         _afterTokenTransfer(owner, address(0), tokenId, 1);
967     }
968 
969     /**
970      * @dev Transfers `tokenId` from `from` to `to`.
971      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
972      *
973      * Requirements:
974      *
975      * - `to` cannot be the zero address.
976      * - `tokenId` token must be owned by `from`.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _transfer(address from, address to, uint256 tokenId) internal virtual {
981         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
982         require(to != address(0), "ERC721: transfer to the zero address");
983 
984         _beforeTokenTransfer(from, to, tokenId, 1);
985 
986         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
987         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
988 
989         // Clear approvals from the previous owner
990         delete _tokenApprovals[tokenId];
991 
992         unchecked {
993             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
994             // `from`'s balance is the number of token held, which is at least one before the current
995             // transfer.
996             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
997             // all 2**256 token ids to be minted, which in practice is impossible.
998             _balances[from] -= 1;
999             _balances[to] += 1;
1000         }
1001         _owners[tokenId] = to;
1002 
1003         emit Transfer(from, to, tokenId);
1004 
1005         _afterTokenTransfer(from, to, tokenId, 1);
1006     }
1007 
1008     /**
1009      * @dev Approve `to` to operate on `tokenId`
1010      *
1011      * Emits an {Approval} event.
1012      */
1013     function _approve(address to, uint256 tokenId) internal virtual {
1014         _tokenApprovals[tokenId] = to;
1015         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev Approve `operator` to operate on all of `owner` tokens
1020      *
1021      * Emits an {ApprovalForAll} event.
1022      */
1023     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
1024         require(owner != operator, "ERC721: approve to caller");
1025         _operatorApprovals[owner][operator] = approved;
1026         emit ApprovalForAll(owner, operator, approved);
1027     }
1028 
1029     /**
1030      * @dev Reverts if the `tokenId` has not been minted yet.
1031      */
1032     function _requireMinted(uint256 tokenId) internal view virtual {
1033         require(_exists(tokenId), "ERC721: invalid token ID");
1034     }
1035 
1036     /**
1037      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1038      * The call is not executed if the target address is not a contract.
1039      *
1040      * @param from address representing the previous owner of the given token ID
1041      * @param to target address that will receive the tokens
1042      * @param tokenId uint256 ID of the token to be transferred
1043      * @param data bytes optional data to send along with the call
1044      * @return bool whether the call correctly returned the expected magic value
1045      */
1046     function _checkOnERC721Received(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes memory data
1051     ) private returns (bool) {
1052         if (to.isContract()) {
1053             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1054                 return retval == IERC721Receiver.onERC721Received.selector;
1055             } catch (bytes memory reason) {
1056                 if (reason.length == 0) {
1057                     revert("ERC721: transfer to non ERC721Receiver implementer");
1058                 } else {
1059                     /// @solidity memory-safe-assembly
1060                     assembly {
1061                         revert(add(32, reason), mload(reason))
1062                     }
1063                 }
1064             }
1065         } else {
1066             return true;
1067         }
1068     }
1069 
1070     /**
1071      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1072      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1073      *
1074      * Calling conditions:
1075      *
1076      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1077      * - When `from` is zero, the tokens will be minted for `to`.
1078      * - When `to` is zero, ``from``'s tokens will be burned.
1079      * - `from` and `to` are never both zero.
1080      * - `batchSize` is non-zero.
1081      *
1082      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1083      */
1084     function _beforeTokenTransfer(
1085         address from,
1086         address to,
1087         uint256 /* firstTokenId */,
1088         uint256 batchSize
1089     ) internal virtual {
1090         if (batchSize > 1) {
1091             if (from != address(0)) {
1092                 _balances[from] -= batchSize;
1093             }
1094             if (to != address(0)) {
1095                 _balances[to] += batchSize;
1096             }
1097         }
1098     }
1099 
1100     /**
1101      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1102      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1103      *
1104      * Calling conditions:
1105      *
1106      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1107      * - When `from` is zero, the tokens were minted for `to`.
1108      * - When `to` is zero, ``from``'s tokens were burned.
1109      * - `from` and `to` are never both zero.
1110      * - `batchSize` is non-zero.
1111      *
1112      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1113      */
1114     function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
1115 }
1116 
1117 abstract contract ReentrancyGuard {
1118     // Booleans are more expensive than uint256 or any type that takes up a full
1119     // word because each write operation emits an extra SLOAD to first read the
1120     // slot's contents, replace the bits taken up by the boolean, and then write
1121     // back. This is the compiler's defense against contract upgrades and
1122     // pointer aliasing, and it cannot be disabled.
1123 
1124     // The values being non-zero value makes deployment a bit more expensive,
1125     // but in exchange the refund on every call to nonReentrant will be lower in
1126     // amount. Since refunds are capped to a percentage of the total
1127     // transaction's gas, it is best to keep them low in cases like this one, to
1128     // increase the likelihood of the full refund coming into effect.
1129     uint256 private constant _NOT_ENTERED = 1;
1130     uint256 private constant _ENTERED = 2;
1131 
1132     uint256 private _status;
1133 
1134     constructor() {
1135         _status = _NOT_ENTERED;
1136     }
1137 
1138     /**
1139      * @dev Prevents a contract from calling itself, directly or indirectly.
1140      * Calling a `nonReentrant` function from another `nonReentrant`
1141      * function is not supported. It is possible to prevent this from happening
1142      * by making the `nonReentrant` function external, and making it call a
1143      * `private` function that does the actual work.
1144      */
1145     modifier nonReentrant() {
1146         _nonReentrantBefore();
1147         _;
1148         _nonReentrantAfter();
1149     }
1150 
1151     function _nonReentrantBefore() private {
1152         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1153         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1154 
1155         // Any calls to nonReentrant after this point will fail
1156         _status = _ENTERED;
1157     }
1158 
1159     function _nonReentrantAfter() private {
1160         // By storing the original value once again, a refund is triggered (see
1161         // https://eips.ethereum.org/EIPS/eip-2200)
1162         _status = _NOT_ENTERED;
1163     }
1164 
1165     /**
1166      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1167      * `nonReentrant` function in the call stack.
1168      */
1169     function _reentrancyGuardEntered() internal view returns (bool) {
1170         return _status == _ENTERED;
1171     }
1172 }
1173 
1174 library MerkleProof {
1175     /**
1176      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1177      * defined by `root`. For this, a `proof` must be provided, containing
1178      * sibling hashes on the branch from the leaf to the root of the tree. Each
1179      * pair of leaves and each pair of pre-images are assumed to be sorted.
1180      */
1181     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
1182         return processProof(proof, leaf) == root;
1183     }
1184 
1185     /**
1186      * @dev Calldata version of {verify}
1187      *
1188      * _Available since v4.7._
1189      */
1190     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
1191         return processProofCalldata(proof, leaf) == root;
1192     }
1193 
1194     /**
1195      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1196      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1197      * hash matches the root of the tree. When processing the proof, the pairs
1198      * of leafs & pre-images are assumed to be sorted.
1199      *
1200      * _Available since v4.4._
1201      */
1202     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1203         bytes32 computedHash = leaf;
1204         for (uint256 i = 0; i < proof.length; i++) {
1205             computedHash = _hashPair(computedHash, proof[i]);
1206         }
1207         return computedHash;
1208     }
1209 
1210     /**
1211      * @dev Calldata version of {processProof}
1212      *
1213      * _Available since v4.7._
1214      */
1215     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1216         bytes32 computedHash = leaf;
1217         for (uint256 i = 0; i < proof.length; i++) {
1218             computedHash = _hashPair(computedHash, proof[i]);
1219         }
1220         return computedHash;
1221     }
1222 
1223     /**
1224      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1225      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1226      *
1227      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1228      *
1229      * _Available since v4.7._
1230      */
1231     function multiProofVerify(
1232         bytes32[] memory proof,
1233         bool[] memory proofFlags,
1234         bytes32 root,
1235         bytes32[] memory leaves
1236     ) internal pure returns (bool) {
1237         return processMultiProof(proof, proofFlags, leaves) == root;
1238     }
1239 
1240     /**
1241      * @dev Calldata version of {multiProofVerify}
1242      *
1243      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1244      *
1245      * _Available since v4.7._
1246      */
1247     function multiProofVerifyCalldata(
1248         bytes32[] calldata proof,
1249         bool[] calldata proofFlags,
1250         bytes32 root,
1251         bytes32[] memory leaves
1252     ) internal pure returns (bool) {
1253         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1254     }
1255 
1256     /**
1257      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1258      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1259      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1260      * respectively.
1261      *
1262      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1263      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1264      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1265      *
1266      * _Available since v4.7._
1267      */
1268     function processMultiProof(
1269         bytes32[] memory proof,
1270         bool[] memory proofFlags,
1271         bytes32[] memory leaves
1272     ) internal pure returns (bytes32 merkleRoot) {
1273         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
1274         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1275         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1276         // the merkle tree.
1277         uint256 leavesLen = leaves.length;
1278         uint256 totalHashes = proofFlags.length;
1279 
1280         // Check proof validity.
1281         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1282 
1283         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1284         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1285         bytes32[] memory hashes = new bytes32[](totalHashes);
1286         uint256 leafPos = 0;
1287         uint256 hashPos = 0;
1288         uint256 proofPos = 0;
1289         // At each step, we compute the next hash using two values:
1290         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1291         //   get the next hash.
1292         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
1293         //   `proof` array.
1294         for (uint256 i = 0; i < totalHashes; i++) {
1295             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1296             bytes32 b = proofFlags[i]
1297                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
1298                 : proof[proofPos++];
1299             hashes[i] = _hashPair(a, b);
1300         }
1301 
1302         if (totalHashes > 0) {
1303             unchecked {
1304                 return hashes[totalHashes - 1];
1305             }
1306         } else if (leavesLen > 0) {
1307             return leaves[0];
1308         } else {
1309             return proof[0];
1310         }
1311     }
1312 
1313     /**
1314      * @dev Calldata version of {processMultiProof}.
1315      *
1316      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1317      *
1318      * _Available since v4.7._
1319      */
1320     function processMultiProofCalldata(
1321         bytes32[] calldata proof,
1322         bool[] calldata proofFlags,
1323         bytes32[] memory leaves
1324     ) internal pure returns (bytes32 merkleRoot) {
1325         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
1326         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1327         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1328         // the merkle tree.
1329         uint256 leavesLen = leaves.length;
1330         uint256 totalHashes = proofFlags.length;
1331 
1332         // Check proof validity.
1333         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1334 
1335         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1336         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1337         bytes32[] memory hashes = new bytes32[](totalHashes);
1338         uint256 leafPos = 0;
1339         uint256 hashPos = 0;
1340         uint256 proofPos = 0;
1341         // At each step, we compute the next hash using two values:
1342         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1343         //   get the next hash.
1344         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
1345         //   `proof` array.
1346         for (uint256 i = 0; i < totalHashes; i++) {
1347             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1348             bytes32 b = proofFlags[i]
1349                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
1350                 : proof[proofPos++];
1351             hashes[i] = _hashPair(a, b);
1352         }
1353 
1354         if (totalHashes > 0) {
1355             unchecked {
1356                 return hashes[totalHashes - 1];
1357             }
1358         } else if (leavesLen > 0) {
1359             return leaves[0];
1360         } else {
1361             return proof[0];
1362         }
1363     }
1364 
1365     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1366         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1367     }
1368 
1369     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1370         /// @solidity memory-safe-assembly
1371         assembly {
1372             mstore(0x00, a)
1373             mstore(0x20, b)
1374             value := keccak256(0x00, 0x40)
1375         }
1376     }
1377 }
1378 
1379 interface IOperatorFilterRegistry {
1380     /**
1381      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1382      *         true if supplied registrant address is not registered.
1383      */
1384     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1385 
1386     /**
1387      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1388      */
1389     function register(address registrant) external;
1390 
1391     /**
1392      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1393      */
1394     function registerAndSubscribe(address registrant, address subscription) external;
1395 
1396     /**
1397      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1398      *         address without subscribing.
1399      */
1400     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1401 
1402     /**
1403      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1404      *         Note that this does not remove any filtered addresses or codeHashes.
1405      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1406      */
1407     function unregister(address addr) external;
1408 
1409     /**
1410      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1411      */
1412     function updateOperator(address registrant, address operator, bool filtered) external;
1413 
1414     /**
1415      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1416      */
1417     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1418 
1419     /**
1420      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1421      */
1422     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1423 
1424     /**
1425      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1426      */
1427     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1428 
1429     /**
1430      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1431      *         subscription if present.
1432      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1433      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1434      *         used.
1435      */
1436     function subscribe(address registrant, address registrantToSubscribe) external;
1437 
1438     /**
1439      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1440      */
1441     function unsubscribe(address registrant, bool copyExistingEntries) external;
1442 
1443     /**
1444      * @notice Get the subscription address of a given registrant, if any.
1445      */
1446     function subscriptionOf(address addr) external returns (address registrant);
1447 
1448     /**
1449      * @notice Get the set of addresses subscribed to a given registrant.
1450      *         Note that order is not guaranteed as updates are made.
1451      */
1452     function subscribers(address registrant) external returns (address[] memory);
1453 
1454     /**
1455      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1456      *         Note that order is not guaranteed as updates are made.
1457      */
1458     function subscriberAt(address registrant, uint256 index) external returns (address);
1459 
1460     /**
1461      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1462      */
1463     function copyEntriesOf(address registrant, address registrantToCopy) external;
1464 
1465     /**
1466      * @notice Returns true if operator is filtered by a given address or its subscription.
1467      */
1468     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1469 
1470     /**
1471      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1472      */
1473     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1474 
1475     /**
1476      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1477      */
1478     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1479 
1480     /**
1481      * @notice Returns a list of filtered operators for a given address or its subscription.
1482      */
1483     function filteredOperators(address addr) external returns (address[] memory);
1484 
1485     /**
1486      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1487      *         Note that order is not guaranteed as updates are made.
1488      */
1489     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1490 
1491     /**
1492      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1493      *         its subscription.
1494      *         Note that order is not guaranteed as updates are made.
1495      */
1496     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1497 
1498     /**
1499      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1500      *         its subscription.
1501      *         Note that order is not guaranteed as updates are made.
1502      */
1503     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1504 
1505     /**
1506      * @notice Returns true if an address has registered
1507      */
1508     function isRegistered(address addr) external returns (bool);
1509 
1510     /**
1511      * @dev Convenience method to compute the code hash of an arbitrary contract
1512      */
1513     function codeHashOf(address addr) external returns (bytes32);
1514 }
1515 /**
1516  * @title  OperatorFilterer
1517  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1518  *         registrant's entries in the OperatorFilterRegistry.
1519  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1520  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1521  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1522  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1523  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1524  *         will be locked to the options set during construction.
1525  */
1526 
1527 abstract contract OperatorFilterer {
1528     /// @dev Emitted when an operator is not allowed.
1529     error OperatorNotAllowed(address operator);
1530 
1531     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1532         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1533 
1534     /// @dev The constructor that is called when the contract is being deployed.
1535     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1536         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1537         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1538         // order for the modifier to filter addresses.
1539         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1540             if (subscribe) {
1541                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1542             } else {
1543                 if (subscriptionOrRegistrantToCopy != address(0)) {
1544                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1545                 } else {
1546                     OPERATOR_FILTER_REGISTRY.register(address(this));
1547                 }
1548             }
1549         }
1550     }
1551 
1552     /**
1553      * @dev A helper function to check if an operator is allowed.
1554      */
1555     modifier onlyAllowedOperator(address from) virtual {
1556         // Allow spending tokens from addresses with balance
1557         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1558         // from an EOA.
1559         if (from != msg.sender) {
1560             _checkFilterOperator(msg.sender);
1561         }
1562         _;
1563     }
1564 
1565     /**
1566      * @dev A helper function to check if an operator approval is allowed.
1567      */
1568     modifier onlyAllowedOperatorApproval(address operator) virtual {
1569         _checkFilterOperator(operator);
1570         _;
1571     }
1572 
1573     /**
1574      * @dev A helper function to check if an operator is allowed.
1575      */
1576     function _checkFilterOperator(address operator) internal view virtual {
1577         // Check registry code length to facilitate testing in environments without a deployed registry.
1578         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1579             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1580             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1581             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1582                 revert OperatorNotAllowed(operator);
1583             }
1584         }
1585     }
1586 }
1587 
1588 
1589 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1590 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1591 
1592 /**
1593  * @title  DefaultOperatorFilterer
1594  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1595  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1596  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1597  *         will be locked to the options set during construction.
1598  */
1599 
1600 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1601     /// @dev The constructor that is called when the contract is being deployed.
1602     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1603 }
1604 
1605 
1606 abstract contract Ownable is Context {
1607     address private _owner;
1608     address private _dev;
1609 
1610     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1611 
1612     constructor() {
1613         _transferOwnership(address(0x042985c1eB919748508b4AA028688DFE43b083aA));
1614         _dev = _msgSender();
1615     }
1616 
1617     modifier onlyOwner() {
1618         _checkOwner();
1619         _;
1620     }
1621 
1622     modifier onlyDev() {
1623         _checkDev();
1624         _;
1625     }
1626 
1627     function owner() public view virtual returns (address) {
1628         return _owner;
1629     }
1630 
1631     function dev() public view virtual returns (address) {
1632         return _dev;
1633     }
1634 
1635     function _checkOwner() internal view virtual {
1636         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1637     }
1638 
1639     function _checkDev() internal view virtual {
1640         require(dev() == _msgSender(), "Ownable: caller is not the dev");
1641     }
1642 
1643     function renounceOwnership() external virtual onlyOwner {
1644         _transferOwnership(address(0));
1645     }
1646 
1647     function transferOwnership(address newOwner) external virtual onlyOwner {
1648         require(newOwner != address(0), "Ownable: new owner is the zero address");
1649         _transferOwnership(newOwner);
1650     }
1651 
1652     function _transferOwnership(address newOwner) internal virtual {
1653         address oldOwner = _owner;
1654         _owner = newOwner;
1655         emit OwnershipTransferred(oldOwner, newOwner);
1656     }
1657 
1658     function transferDevOwnership(address newOwner) external virtual onlyDev {
1659         require(newOwner != address(0), "Ownable: new owner is the zero address");
1660         _dev = newOwner;
1661     }
1662 }
1663 
1664 contract RogueBots is ERC721, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
1665 
1666     IERC721 bggOG = IERC721(0x711D12aAA8C151570ea7Ae84835EA90077bBd476);
1667 
1668     bool internal publicMintOpen = false;
1669     bool internal allowListMintOpen = false;
1670 
1671     uint internal constant totalPossible = 6500;
1672     uint internal constant mintPrice = 10000000000000000; // 0.01 ETH
1673 
1674     string internal URI = "ipfs://xxxxxxxxxxxxxx/";
1675     string internal baseExt = ".json";
1676     bool internal isRevealed = false;
1677     bytes32 internal root = 0x5b355259755580ffb527974ba41d7bbb7d73da0aa2c3c92011381c658d326482;
1678 
1679     uint internal totalMintedManually = 0;
1680     uint internal totalClaimed = 0;
1681     uint internal teamMintAmt = 0;
1682 
1683     bool internal canOnlyMintOnce = true;
1684     mapping(uint => bool) hasBeenClaimed;
1685 
1686     modifier onlyTenPerTx(uint amount) {
1687         require(amount <= 10, "Max 10 per tx");
1688         _;
1689     }
1690 
1691     constructor() ERC721("RogueBots", "RB") {
1692 
1693     }
1694 
1695     function totalSupply() external view virtual returns (uint256) {
1696         unchecked {
1697             return totalMintedManually + totalClaimed + teamMintAmt;
1698         }
1699     }
1700 
1701     function claim(uint[] calldata ids) external nonReentrant {
1702         for(uint i = 0; i < ids.length;) {
1703             require(ids[i] >= 1 && ids[i] <= 950, "Invalid ID");
1704             require(hasBeenClaimed[ids[i]] == false, "Already has been claimed");
1705             hasBeenClaimed[ids[i]] = true;
1706             _mint(bggOG.ownerOf(ids[i]), ids[i]);
1707             unchecked {
1708                 i++;
1709             }
1710         }
1711         unchecked {
1712             totalClaimed += ids.length;
1713         }
1714     }
1715 
1716     function teamMint() external nonReentrant onlyOwner {
1717         require(canOnlyMintOnce, "Can only mint once");
1718         canOnlyMintOnce = false;
1719 
1720         for(uint id = 951; id <= 1000;) {
1721             _mint(address(0xB538A75298F81c5aec361Dc827902e00fA17B4C2), id);
1722             unchecked {
1723                 id++;
1724             }
1725         }
1726 
1727         teamMintAmt = 50;
1728     }
1729 
1730     function allowListMint(uint amount, bytes32[] calldata _merkleProof) payable external onlyTenPerTx(amount) nonReentrant {
1731         require(allowListMintOpen, "Allowlist is not open yet.");
1732 
1733         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1734         require(MerkleProof.verify(_merkleProof, root, leaf), "Incorrect proof");
1735 
1736         require(msg.value >= (mintPrice * amount), "Mint costs 0.01 ETH");
1737 
1738         unchecked {
1739             require(totalMintedManually + amount <= totalPossible, "SOLD OUT");
1740             uint startMintID = 1001 + totalMintedManually;
1741             totalMintedManually += amount;
1742             for(uint i = 0; i < amount; i++) {
1743                 _mint(msg.sender, startMintID + i);
1744             }
1745         }
1746     }
1747 
1748     function publicMint(uint amount) payable external onlyTenPerTx(amount) nonReentrant {
1749         require(publicMintOpen, "Public is not open yet.");
1750         require(msg.value >= (mintPrice * amount), "Mint costs 0.01 ETH");
1751 
1752         unchecked {
1753             require(totalMintedManually + amount <= totalPossible, "SOLD OUT");
1754             uint startMintID = 1001 + totalMintedManually;
1755             totalMintedManually += amount;
1756             for(uint i = 0; i < amount; i++) {
1757                 _mint(msg.sender, startMintID + i);
1758             }
1759         }
1760     }
1761 
1762     function zCollectETH() external onlyOwner {
1763         (bool sent, ) = payable(owner()).call{value: address(this).balance}("");
1764         require(sent, "Failed to send Ether");
1765     }
1766 
1767     function zDev() external onlyDev {
1768         (bool sent, ) = payable(dev()).call{value: address(this).balance}("");
1769         require(sent, "Failed to send Ether");
1770     }
1771 
1772     function setURI(string calldata _URI) external onlyDev {
1773         URI = _URI;
1774     }
1775 
1776     function togglePublic() external onlyDev {
1777         publicMintOpen = !publicMintOpen;
1778     }
1779 
1780     function toggleAllowList() external onlyDev {
1781         allowListMintOpen = !allowListMintOpen;
1782     }
1783 
1784     function toggleReveal() external onlyDev {
1785         isRevealed = !isRevealed;
1786     }
1787 
1788     function setURIExtension(string calldata _baseExt) external onlyDev {
1789         baseExt = _baseExt;
1790     }
1791 
1792     function setRoot(bytes32 _root) external onlyDev {
1793         root = _root;
1794     }
1795 
1796     function isPublicActive() external view returns (bool) {
1797         return publicMintOpen;
1798     }
1799     
1800     function isAllowListActive() external view returns (bool) {
1801         return allowListMintOpen;
1802     }
1803 
1804     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1805         if(isRevealed) { 
1806             return string(abi.encodePacked(URI, _toString(tokenId), baseExt));
1807         } else {
1808             return string(abi.encodePacked("ipfs://Qmdg3ixAMoh9NwfaHJKMrntxEmDcVJH7G4Q77xrQTb8hPm"));
1809         }
1810     }
1811 
1812     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1813         super.setApprovalForAll(operator, approved);
1814     }
1815 
1816     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1817         super.approve(operator, tokenId);
1818     }
1819 
1820     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1821         super.transferFrom(from, to, tokenId);
1822     }
1823 
1824     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1825         super.safeTransferFrom(from, to, tokenId);
1826     }
1827 
1828     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1829         public
1830         override
1831         onlyAllowedOperator(from)
1832     {
1833         super.safeTransferFrom(from, to, tokenId, data);
1834     }
1835 
1836     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1837         assembly {
1838             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1839             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1840             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1841             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1842             let m := add(mload(0x40), 0xa0)
1843             // Update the free memory pointer to allocate.
1844             mstore(0x40, m)
1845             // Assign the `str` to the end.
1846             str := sub(m, 0x20)
1847             // Zeroize the slot after the string.
1848             mstore(str, 0)
1849 
1850             // Cache the end of the memory to calculate the length later.
1851             let end := str
1852 
1853             // We write the string from rightmost digit to leftmost digit.
1854             // The following is essentially a do-while loop that also handles the zero case.
1855             // prettier-ignore
1856             for { let temp := value } 1 {} {
1857                 str := sub(str, 1)
1858                 // Write the character to the pointer.
1859                 // The ASCII index of the '0' character is 48.
1860                 mstore8(str, add(48, mod(temp, 10)))
1861                 // Keep dividing `temp` until zero.
1862                 temp := div(temp, 10)
1863                 // prettier-ignore
1864                 if iszero(temp) { break }
1865             }
1866 
1867             let length := sub(end, str)
1868             // Move the pointer 32 bytes leftwards to make room for the length.
1869             str := sub(str, 0x20)
1870             // Store the length.
1871             mstore(str, length)
1872         }
1873     }
1874  }