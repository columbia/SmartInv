1 // File: solidity-bits/contracts/BitScan.sol
2 
3 /**
4    _____       ___     ___ __           ____  _ __
5   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
6   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
7  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  )
8 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/
9                            /____/
10 
11 - npm: https://www.npmjs.com/package/solidity-bits
12 - github: https://github.com/estarriolvetch/solidity-bits
13 
14  */
15 
16 pragma solidity ^0.8.0;
17 
18 
19 library BitScan {
20     uint256 constant private DEBRUIJN_256 = 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
21     bytes constant private LOOKUP_TABLE_256 = hex"0001020903110a19042112290b311a3905412245134d2a550c5d32651b6d3a7506264262237d468514804e8d2b95569d0d495ea533a966b11c886eb93bc176c9071727374353637324837e9b47af86c7155181ad4fd18ed32c9096db57d59ee30e2e4a6a5f92a6be3498aae067ddb2eb1d5989b56fd7baf33ca0c2ee77e5caf7ff0810182028303840444c545c646c7425617c847f8c949c48a4a8b087b8c0c816365272829aaec650acd0d28fdad4e22d6991bd97dfdcea58b4d6f29fede4f6fe0f1f2f3f4b5b6b607b8b93a3a7b7bf357199c5abcfd9e168bcdee9b3f1ecf5fd1e3e5a7a8aa2b670c4ced8bbe8f0f4fc3d79a1c3cde7effb78cce6facbf9f8";
22 
23     /**
24         @dev Isolate the least significant set bit.
25      */
26     function isolateLS1B256(uint256 bb) pure internal returns (uint256) {
27         require(bb > 0);
28         unchecked {
29             return bb & (0 - bb);
30         }
31     }
32 
33     /**
34         @dev Isolate the most significant set bit.
35      */
36     function isolateMS1B256(uint256 bb) pure internal returns (uint256) {
37         require(bb > 0);
38         unchecked {
39             bb |= bb >> 128;
40             bb |= bb >> 64;
41             bb |= bb >> 32;
42             bb |= bb >> 16;
43             bb |= bb >> 8;
44             bb |= bb >> 4;
45             bb |= bb >> 2;
46             bb |= bb >> 1;
47 
48             return (bb >> 1) + 1;
49         }
50     }
51 
52     /**
53         @dev Find the index of the lest significant set bit. (trailing zero count)
54      */
55     function bitScanForward256(uint256 bb) pure internal returns (uint8) {
56         unchecked {
57             return uint8(LOOKUP_TABLE_256[(isolateLS1B256(bb) * DEBRUIJN_256) >> 248]);
58         }
59     }
60 
61     /**
62         @dev Find the index of the most significant set bit.
63      */
64     function bitScanReverse256(uint256 bb) pure internal returns (uint8) {
65         unchecked {
66             return 255 - uint8(LOOKUP_TABLE_256[((isolateMS1B256(bb) * DEBRUIJN_256) >> 248)]);
67         }
68     }
69 
70     function log2(uint256 bb) pure internal returns (uint8) {
71         unchecked {
72             return uint8(LOOKUP_TABLE_256[(isolateMS1B256(bb) * DEBRUIJN_256) >> 248]);
73         }
74     }
75 }
76 
77 // File: solidity-bits/contracts/BitMaps.sol
78 
79 /**
80    _____       ___     ___ __           ____  _ __
81   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
82   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
83  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  )
84 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/
85                            /____/
86 
87 - npm: https://www.npmjs.com/package/solidity-bits
88 - github: https://github.com/estarriolvetch/solidity-bits
89 
90  */
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev This Library is a modified version of Openzeppelin's BitMaps library.
95  * Functions of finding the index of the closest set bit from a given index are added.
96  * The indexing of each bucket is modifed to count from the MSB to the LSB instead of from the LSB to the MSB.
97  * The modification of indexing makes finding the closest previous set bit more efficient in gas usage.
98 */
99 
100 /**
101  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
102  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
103  */
104 
105 library BitMaps {
106     using BitScan for uint256;
107     uint256 private constant MASK_INDEX_ZERO = (1 << 255);
108     uint256 private constant MASK_FULL = type(uint256).max;
109 
110     struct BitMap {
111         mapping(uint256 => uint256) _data;
112     }
113 
114     /**
115      * @dev Returns whether the bit at `index` is set.
116      */
117     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
118         uint256 bucket = index >> 8;
119         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
120         return bitmap._data[bucket] & mask != 0;
121     }
122 
123     /**
124      * @dev Sets the bit at `index` to the boolean `value`.
125      */
126     function setTo(
127         BitMap storage bitmap,
128         uint256 index,
129         bool value
130     ) internal {
131         if (value) {
132             set(bitmap, index);
133         } else {
134             unset(bitmap, index);
135         }
136     }
137 
138     /**
139      * @dev Sets the bit at `index`.
140      */
141     function set(BitMap storage bitmap, uint256 index) internal {
142         uint256 bucket = index >> 8;
143         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
144         bitmap._data[bucket] |= mask;
145     }
146 
147     /**
148      * @dev Unsets the bit at `index`.
149      */
150     function unset(BitMap storage bitmap, uint256 index) internal {
151         uint256 bucket = index >> 8;
152         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
153         bitmap._data[bucket] &= ~mask;
154     }
155 
156 
157     /**
158      * @dev Consecutively sets `amount` of bits starting from the bit at `startIndex`.
159      */
160     function setBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
161         uint256 bucket = startIndex >> 8;
162 
163         uint256 bucketStartIndex = (startIndex & 0xff);
164 
165         unchecked {
166             if(bucketStartIndex + amount < 256) {
167                 bitmap._data[bucket] |= MASK_FULL << (256 - amount) >> bucketStartIndex;
168             } else {
169                 bitmap._data[bucket] |= MASK_FULL >> bucketStartIndex;
170                 amount -= (256 - bucketStartIndex);
171                 bucket++;
172 
173                 while(amount > 256) {
174                     bitmap._data[bucket] = MASK_FULL;
175                     amount -= 256;
176                     bucket++;
177                 }
178 
179                 bitmap._data[bucket] |= MASK_FULL << (256 - amount);
180             }
181         }
182     }
183 
184 
185     /**
186      * @dev Consecutively unsets `amount` of bits starting from the bit at `startIndex`.
187      */
188     function unsetBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
189         uint256 bucket = startIndex >> 8;
190 
191         uint256 bucketStartIndex = (startIndex & 0xff);
192 
193         unchecked {
194             if(bucketStartIndex + amount < 256) {
195                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount) >> bucketStartIndex);
196             } else {
197                 bitmap._data[bucket] &= ~(MASK_FULL >> bucketStartIndex);
198                 amount -= (256 - bucketStartIndex);
199                 bucket++;
200 
201                 while(amount > 256) {
202                     bitmap._data[bucket] = 0;
203                     amount -= 256;
204                     bucket++;
205                 }
206 
207                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount));
208             }
209         }
210     }
211 
212 
213     /**
214      * @dev Find the closest index of the set bit before `index`.
215      */
216     function scanForward(BitMap storage bitmap, uint256 index) internal view returns (uint256 setBitIndex) {
217         uint256 bucket = index >> 8;
218 
219         // index within the bucket
220         uint256 bucketIndex = (index & 0xff);
221 
222         // load a bitboard from the bitmap.
223         uint256 bb = bitmap._data[bucket];
224 
225         // offset the bitboard to scan from `bucketIndex`.
226         bb = bb >> (0xff ^ bucketIndex); // bb >> (255 - bucketIndex)
227 
228         if(bb > 0) {
229             unchecked {
230                 setBitIndex = (bucket << 8) | (bucketIndex -  bb.bitScanForward256());
231             }
232         } else {
233             while(true) {
234                 require(bucket > 0, "BitMaps: The set bit before the index doesn't exist.");
235                 unchecked {
236                     bucket--;
237                 }
238                 // No offset. Always scan from the least significiant bit now.
239                 bb = bitmap._data[bucket];
240 
241                 if(bb > 0) {
242                     unchecked {
243                         setBitIndex = (bucket << 8) | (255 -  bb.bitScanForward256());
244                         break;
245                     }
246                 }
247             }
248         }
249     }
250 
251     function getBucket(BitMap storage bitmap, uint256 bucket) internal view returns (uint256) {
252         return bitmap._data[bucket];
253     }
254 }
255 
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @dev Interface of the ERC165 standard, as defined in the
264  * https://eips.ethereum.org/EIPS/eip-165[EIP].
265  *
266  * Implementers can declare support of contract interfaces, which can then be
267  * queried by others ({ERC165Checker}).
268  *
269  * For an implementation, see {ERC165}.
270  */
271 interface IERC165 {
272     /**
273      * @dev Returns true if this contract implements the interface defined by
274      * `interfaceId`. See the corresponding
275      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
276      * to learn more about how these ids are created.
277      *
278      * This function call must use less than 30 000 gas.
279      */
280     function supportsInterface(bytes4 interfaceId) external view returns (bool);
281 }
282 
283 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
284 
285 
286 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev Required interface of an ERC721 compliant contract.
292  */
293 interface IERC721 is IERC165 {
294     /**
295      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
296      */
297     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
298 
299     /**
300      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
301      */
302     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
303 
304     /**
305      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
306      */
307     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
308 
309     /**
310      * @dev Returns the number of tokens in ``owner``'s account.
311      */
312     function balanceOf(address owner) external view returns (uint256 balance);
313 
314     /**
315      * @dev Returns the owner of the `tokenId` token.
316      *
317      * Requirements:
318      *
319      * - `tokenId` must exist.
320      */
321     function ownerOf(uint256 tokenId) external view returns (address owner);
322 
323     /**
324      * @dev Safely transfers `tokenId` token from `from` to `to`.
325      *
326      * Requirements:
327      *
328      * - `from` cannot be the zero address.
329      * - `to` cannot be the zero address.
330      * - `tokenId` token must exist and be owned by `from`.
331      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
332      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
333      *
334      * Emits a {Transfer} event.
335      */
336     function safeTransferFrom(
337         address from,
338         address to,
339         uint256 tokenId,
340         bytes calldata data
341     ) external;
342 
343     /**
344      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
345      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
346      *
347      * Requirements:
348      *
349      * - `from` cannot be the zero address.
350      * - `to` cannot be the zero address.
351      * - `tokenId` token must exist and be owned by `from`.
352      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
353      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
354      *
355      * Emits a {Transfer} event.
356      */
357     function safeTransferFrom(
358         address from,
359         address to,
360         uint256 tokenId
361     ) external;
362 
363     /**
364      * @dev Transfers `tokenId` token from `from` to `to`.
365      *
366      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
367      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
368      * understand this adds an external call which potentially creates a reentrancy vulnerability.
369      *
370      * Requirements:
371      *
372      * - `from` cannot be the zero address.
373      * - `to` cannot be the zero address.
374      * - `tokenId` token must be owned by `from`.
375      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
376      *
377      * Emits a {Transfer} event.
378      */
379     function transferFrom(
380         address from,
381         address to,
382         uint256 tokenId
383     ) external;
384 
385     /**
386      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
387      * The approval is cleared when the token is transferred.
388      *
389      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
390      *
391      * Requirements:
392      *
393      * - The caller must own the token or be an approved operator.
394      * - `tokenId` must exist.
395      *
396      * Emits an {Approval} event.
397      */
398     function approve(address to, uint256 tokenId) external;
399 
400     /**
401      * @dev Approve or remove `operator` as an operator for the caller.
402      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
403      *
404      * Requirements:
405      *
406      * - The `operator` cannot be the caller.
407      *
408      * Emits an {ApprovalForAll} event.
409      */
410     function setApprovalForAll(address operator, bool _approved) external;
411 
412     /**
413      * @dev Returns the account approved for `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function getApproved(uint256 tokenId) external view returns (address operator);
420 
421     /**
422      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
423      *
424      * See {setApprovalForAll}
425      */
426     function isApprovedForAll(address owner, address operator) external view returns (bool);
427 }
428 
429 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
430 
431 
432 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 /**
437  * @title ERC721 token receiver interface
438  * @dev Interface for any contract that wants to support safeTransfers
439  * from ERC721 asset contracts.
440  */
441 interface IERC721Receiver {
442     /**
443      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
444      * by `operator` from `from`, this function is called.
445      *
446      * It must return its Solidity selector to confirm the token transfer.
447      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
448      *
449      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
450      */
451     function onERC721Received(
452         address operator,
453         address from,
454         uint256 tokenId,
455         bytes calldata data
456     ) external returns (bytes4);
457 }
458 
459 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
468  * @dev See https://eips.ethereum.org/EIPS/eip-721
469  */
470 interface IERC721Metadata is IERC721 {
471     /**
472      * @dev Returns the token collection name.
473      */
474     function name() external view returns (string memory);
475 
476     /**
477      * @dev Returns the token collection symbol.
478      */
479     function symbol() external view returns (string memory);
480 
481     /**
482      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
483      */
484     function tokenURI(uint256 tokenId) external view returns (string memory);
485 }
486 
487 // File: @openzeppelin/contracts/utils/Context.sol
488 
489 
490 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 /**
495  * @dev Provides information about the current execution context, including the
496  * sender of the transaction and its data. While these are generally available
497  * via msg.sender and msg.data, they should not be accessed in such a direct
498  * manner, since when dealing with meta-transactions the account sending and
499  * paying for execution may not be the actual sender (as far as an application
500  * is concerned).
501  *
502  * This contract is only required for intermediate, library-like contracts.
503  */
504 abstract contract Context {
505     function _msgSender() internal view virtual returns (address) {
506         return msg.sender;
507     }
508 
509     function _msgData() internal view virtual returns (bytes calldata) {
510         return msg.data;
511     }
512 }
513 
514 // File: @openzeppelin/contracts/utils/math/Math.sol
515 
516 
517 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @dev Standard math utilities missing in the Solidity language.
523  */
524 library Math {
525     enum Rounding {
526         Down, // Toward negative infinity
527         Up, // Toward infinity
528         Zero // Toward zero
529     }
530 
531     /**
532      * @dev Returns the largest of two numbers.
533      */
534     function max(uint256 a, uint256 b) internal pure returns (uint256) {
535         return a > b ? a : b;
536     }
537 
538     /**
539      * @dev Returns the smallest of two numbers.
540      */
541     function min(uint256 a, uint256 b) internal pure returns (uint256) {
542         return a < b ? a : b;
543     }
544 
545     /**
546      * @dev Returns the average of two numbers. The result is rounded towards
547      * zero.
548      */
549     function average(uint256 a, uint256 b) internal pure returns (uint256) {
550         // (a + b) / 2 can overflow.
551         return (a & b) + (a ^ b) / 2;
552     }
553 
554     /**
555      * @dev Returns the ceiling of the division of two numbers.
556      *
557      * This differs from standard division with `/` in that it rounds up instead
558      * of rounding down.
559      */
560     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
561         // (a + b - 1) / b can overflow on addition, so we distribute.
562         return a == 0 ? 0 : (a - 1) / b + 1;
563     }
564 
565     /**
566      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
567      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
568      * with further edits by Uniswap Labs also under MIT license.
569      */
570     function mulDiv(
571         uint256 x,
572         uint256 y,
573         uint256 denominator
574     ) internal pure returns (uint256 result) {
575         unchecked {
576             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
577             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
578             // variables such that product = prod1 * 2^256 + prod0.
579             uint256 prod0; // Least significant 256 bits of the product
580             uint256 prod1; // Most significant 256 bits of the product
581             assembly {
582                 let mm := mulmod(x, y, not(0))
583                 prod0 := mul(x, y)
584                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
585             }
586 
587             // Handle non-overflow cases, 256 by 256 division.
588             if (prod1 == 0) {
589                 return prod0 / denominator;
590             }
591 
592             // Make sure the result is less than 2^256. Also prevents denominator == 0.
593             require(denominator > prod1);
594 
595             ///////////////////////////////////////////////
596             // 512 by 256 division.
597             ///////////////////////////////////////////////
598 
599             // Make division exact by subtracting the remainder from [prod1 prod0].
600             uint256 remainder;
601             assembly {
602                 // Compute remainder using mulmod.
603                 remainder := mulmod(x, y, denominator)
604 
605                 // Subtract 256 bit number from 512 bit number.
606                 prod1 := sub(prod1, gt(remainder, prod0))
607                 prod0 := sub(prod0, remainder)
608             }
609 
610             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
611             // See https://cs.stackexchange.com/q/138556/92363.
612 
613             // Does not overflow because the denominator cannot be zero at this stage in the function.
614             uint256 twos = denominator & (~denominator + 1);
615             assembly {
616                 // Divide denominator by twos.
617                 denominator := div(denominator, twos)
618 
619                 // Divide [prod1 prod0] by twos.
620                 prod0 := div(prod0, twos)
621 
622                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
623                 twos := add(div(sub(0, twos), twos), 1)
624             }
625 
626             // Shift in bits from prod1 into prod0.
627             prod0 |= prod1 * twos;
628 
629             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
630             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
631             // four bits. That is, denominator * inv = 1 mod 2^4.
632             uint256 inverse = (3 * denominator) ^ 2;
633 
634             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
635             // in modular arithmetic, doubling the correct bits in each step.
636             inverse *= 2 - denominator * inverse; // inverse mod 2^8
637             inverse *= 2 - denominator * inverse; // inverse mod 2^16
638             inverse *= 2 - denominator * inverse; // inverse mod 2^32
639             inverse *= 2 - denominator * inverse; // inverse mod 2^64
640             inverse *= 2 - denominator * inverse; // inverse mod 2^128
641             inverse *= 2 - denominator * inverse; // inverse mod 2^256
642 
643             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
644             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
645             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
646             // is no longer required.
647             result = prod0 * inverse;
648             return result;
649         }
650     }
651 
652     /**
653      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
654      */
655     function mulDiv(
656         uint256 x,
657         uint256 y,
658         uint256 denominator,
659         Rounding rounding
660     ) internal pure returns (uint256) {
661         uint256 result = mulDiv(x, y, denominator);
662         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
663             result += 1;
664         }
665         return result;
666     }
667 
668     /**
669      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
670      *
671      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
672      */
673     function sqrt(uint256 a) internal pure returns (uint256) {
674         if (a == 0) {
675             return 0;
676         }
677 
678         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
679         //
680         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
681         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
682         //
683         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
684         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
685         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
686         //
687         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
688         uint256 result = 1 << (log2(a) >> 1);
689 
690         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
691         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
692         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
693         // into the expected uint128 result.
694         unchecked {
695             result = (result + a / result) >> 1;
696             result = (result + a / result) >> 1;
697             result = (result + a / result) >> 1;
698             result = (result + a / result) >> 1;
699             result = (result + a / result) >> 1;
700             result = (result + a / result) >> 1;
701             result = (result + a / result) >> 1;
702             return min(result, a / result);
703         }
704     }
705 
706     /**
707      * @notice Calculates sqrt(a), following the selected rounding direction.
708      */
709     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
710         unchecked {
711             uint256 result = sqrt(a);
712             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
713         }
714     }
715 
716     /**
717      * @dev Return the log in base 2, rounded down, of a positive value.
718      * Returns 0 if given 0.
719      */
720     function log2(uint256 value) internal pure returns (uint256) {
721         uint256 result = 0;
722         unchecked {
723             if (value >> 128 > 0) {
724                 value >>= 128;
725                 result += 128;
726             }
727             if (value >> 64 > 0) {
728                 value >>= 64;
729                 result += 64;
730             }
731             if (value >> 32 > 0) {
732                 value >>= 32;
733                 result += 32;
734             }
735             if (value >> 16 > 0) {
736                 value >>= 16;
737                 result += 16;
738             }
739             if (value >> 8 > 0) {
740                 value >>= 8;
741                 result += 8;
742             }
743             if (value >> 4 > 0) {
744                 value >>= 4;
745                 result += 4;
746             }
747             if (value >> 2 > 0) {
748                 value >>= 2;
749                 result += 2;
750             }
751             if (value >> 1 > 0) {
752                 result += 1;
753             }
754         }
755         return result;
756     }
757 
758     /**
759      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
760      * Returns 0 if given 0.
761      */
762     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
763         unchecked {
764             uint256 result = log2(value);
765             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
766         }
767     }
768 
769     /**
770      * @dev Return the log in base 10, rounded down, of a positive value.
771      * Returns 0 if given 0.
772      */
773     function log10(uint256 value) internal pure returns (uint256) {
774         uint256 result = 0;
775         unchecked {
776             if (value >= 10**64) {
777                 value /= 10**64;
778                 result += 64;
779             }
780             if (value >= 10**32) {
781                 value /= 10**32;
782                 result += 32;
783             }
784             if (value >= 10**16) {
785                 value /= 10**16;
786                 result += 16;
787             }
788             if (value >= 10**8) {
789                 value /= 10**8;
790                 result += 8;
791             }
792             if (value >= 10**4) {
793                 value /= 10**4;
794                 result += 4;
795             }
796             if (value >= 10**2) {
797                 value /= 10**2;
798                 result += 2;
799             }
800             if (value >= 10**1) {
801                 result += 1;
802             }
803         }
804         return result;
805     }
806 
807     /**
808      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
809      * Returns 0 if given 0.
810      */
811     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
812         unchecked {
813             uint256 result = log10(value);
814             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
815         }
816     }
817 
818     /**
819      * @dev Return the log in base 256, rounded down, of a positive value.
820      * Returns 0 if given 0.
821      *
822      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
823      */
824     function log256(uint256 value) internal pure returns (uint256) {
825         uint256 result = 0;
826         unchecked {
827             if (value >> 128 > 0) {
828                 value >>= 128;
829                 result += 16;
830             }
831             if (value >> 64 > 0) {
832                 value >>= 64;
833                 result += 8;
834             }
835             if (value >> 32 > 0) {
836                 value >>= 32;
837                 result += 4;
838             }
839             if (value >> 16 > 0) {
840                 value >>= 16;
841                 result += 2;
842             }
843             if (value >> 8 > 0) {
844                 result += 1;
845             }
846         }
847         return result;
848     }
849 
850     /**
851      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
852      * Returns 0 if given 0.
853      */
854     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
855         unchecked {
856             uint256 result = log256(value);
857             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
858         }
859     }
860 }
861 
862 // File: @openzeppelin/contracts/utils/Strings.sol
863 
864 
865 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 /**
870  * @dev String operations.
871  */
872 library Strings {
873     bytes16 private constant _SYMBOLS = "0123456789abcdef";
874     uint8 private constant _ADDRESS_LENGTH = 20;
875 
876     /**
877      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
878      */
879     function toString(uint256 value) internal pure returns (string memory) {
880         unchecked {
881             uint256 length = Math.log10(value) + 1;
882             string memory buffer = new string(length);
883             uint256 ptr;
884             /// @solidity memory-safe-assembly
885             assembly {
886                 ptr := add(buffer, add(32, length))
887             }
888             while (true) {
889                 ptr--;
890                 /// @solidity memory-safe-assembly
891                 assembly {
892                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
893                 }
894                 value /= 10;
895                 if (value == 0) break;
896             }
897             return buffer;
898         }
899     }
900 
901     /**
902      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
903      */
904     function toHexString(uint256 value) internal pure returns (string memory) {
905         unchecked {
906             return toHexString(value, Math.log256(value) + 1);
907         }
908     }
909 
910     /**
911      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
912      */
913     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
914         bytes memory buffer = new bytes(2 * length + 2);
915         buffer[0] = "0";
916         buffer[1] = "x";
917         for (uint256 i = 2 * length + 1; i > 1; --i) {
918             buffer[i] = _SYMBOLS[value & 0xf];
919             value >>= 4;
920         }
921         require(value == 0, "Strings: hex length insufficient");
922         return string(buffer);
923     }
924 
925     /**
926      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
927      */
928     function toHexString(address addr) internal pure returns (string memory) {
929         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
930     }
931 }
932 
933 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
934 
935 
936 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
937 
938 pragma solidity ^0.8.0;
939 
940 /**
941  * @dev Implementation of the {IERC165} interface.
942  *
943  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
944  * for the additional interface id that will be supported. For example:
945  *
946  * ```solidity
947  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
948  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
949  * }
950  * ```
951  *
952  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
953  */
954 abstract contract ERC165 is IERC165 {
955     /**
956      * @dev See {IERC165-supportsInterface}.
957      */
958     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
959         return interfaceId == type(IERC165).interfaceId;
960     }
961 }
962 
963 // File: @openzeppelin/contracts/utils/Address.sol
964 
965 
966 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
967 
968 pragma solidity ^0.8.1;
969 
970 /**
971  * @dev Collection of functions related to the address type
972  */
973 library Address {
974     /**
975      * @dev Returns true if `account` is a contract.
976      *
977      * [IMPORTANT]
978      * ====
979      * It is unsafe to assume that an address for which this function returns
980      * false is an externally-owned account (EOA) and not a contract.
981      *
982      * Among others, `isContract` will return false for the following
983      * types of addresses:
984      *
985      *  - an externally-owned account
986      *  - a contract in construction
987      *  - an address where a contract will be created
988      *  - an address where a contract lived, but was destroyed
989      * ====
990      *
991      * [IMPORTANT]
992      * ====
993      * You shouldn't rely on `isContract` to protect against flash loan attacks!
994      *
995      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
996      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
997      * constructor.
998      * ====
999      */
1000     function isContract(address account) internal view returns (bool) {
1001         // This method relies on extcodesize/address.code.length, which returns 0
1002         // for contracts in construction, since the code is only stored at the end
1003         // of the constructor execution.
1004 
1005         return account.code.length > 0;
1006     }
1007 
1008     /**
1009      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1010      * `recipient`, forwarding all available gas and reverting on errors.
1011      *
1012      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1013      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1014      * imposed by `transfer`, making them unable to receive funds via
1015      * `transfer`. {sendValue} removes this limitation.
1016      *
1017      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1018      *
1019      * IMPORTANT: because control is transferred to `recipient`, care must be
1020      * taken to not create reentrancy vulnerabilities. Consider using
1021      * {ReentrancyGuard} or the
1022      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1023      */
1024     function sendValue(address payable recipient, uint256 amount) internal {
1025         require(address(this).balance >= amount, "Address: insufficient balance");
1026 
1027         (bool success, ) = recipient.call{value: amount}("");
1028         require(success, "Address: unable to send value, recipient may have reverted");
1029     }
1030 
1031     /**
1032      * @dev Performs a Solidity function call using a low level `call`. A
1033      * plain `call` is an unsafe replacement for a function call: use this
1034      * function instead.
1035      *
1036      * If `target` reverts with a revert reason, it is bubbled up by this
1037      * function (like regular Solidity function calls).
1038      *
1039      * Returns the raw returned data. To convert to the expected return value,
1040      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1041      *
1042      * Requirements:
1043      *
1044      * - `target` must be a contract.
1045      * - calling `target` with `data` must not revert.
1046      *
1047      * _Available since v3.1._
1048      */
1049     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1050         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1051     }
1052 
1053     /**
1054      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1055      * `errorMessage` as a fallback revert reason when `target` reverts.
1056      *
1057      * _Available since v3.1._
1058      */
1059     function functionCall(
1060         address target,
1061         bytes memory data,
1062         string memory errorMessage
1063     ) internal returns (bytes memory) {
1064         return functionCallWithValue(target, data, 0, errorMessage);
1065     }
1066 
1067     /**
1068      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1069      * but also transferring `value` wei to `target`.
1070      *
1071      * Requirements:
1072      *
1073      * - the calling contract must have an ETH balance of at least `value`.
1074      * - the called Solidity function must be `payable`.
1075      *
1076      * _Available since v3.1._
1077      */
1078     function functionCallWithValue(
1079         address target,
1080         bytes memory data,
1081         uint256 value
1082     ) internal returns (bytes memory) {
1083         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1084     }
1085 
1086     /**
1087      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1088      * with `errorMessage` as a fallback revert reason when `target` reverts.
1089      *
1090      * _Available since v3.1._
1091      */
1092     function functionCallWithValue(
1093         address target,
1094         bytes memory data,
1095         uint256 value,
1096         string memory errorMessage
1097     ) internal returns (bytes memory) {
1098         require(address(this).balance >= value, "Address: insufficient balance for call");
1099         (bool success, bytes memory returndata) = target.call{value: value}(data);
1100         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1101     }
1102 
1103     /**
1104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1105      * but performing a static call.
1106      *
1107      * _Available since v3.3._
1108      */
1109     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1110         return functionStaticCall(target, data, "Address: low-level static call failed");
1111     }
1112 
1113     /**
1114      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1115      * but performing a static call.
1116      *
1117      * _Available since v3.3._
1118      */
1119     function functionStaticCall(
1120         address target,
1121         bytes memory data,
1122         string memory errorMessage
1123     ) internal view returns (bytes memory) {
1124         (bool success, bytes memory returndata) = target.staticcall(data);
1125         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1126     }
1127 
1128     /**
1129      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1130      * but performing a delegate call.
1131      *
1132      * _Available since v3.4._
1133      */
1134     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1135         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1136     }
1137 
1138     /**
1139      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1140      * but performing a delegate call.
1141      *
1142      * _Available since v3.4._
1143      */
1144     function functionDelegateCall(
1145         address target,
1146         bytes memory data,
1147         string memory errorMessage
1148     ) internal returns (bytes memory) {
1149         (bool success, bytes memory returndata) = target.delegatecall(data);
1150         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1151     }
1152 
1153     /**
1154      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1155      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1156      *
1157      * _Available since v4.8._
1158      */
1159     function verifyCallResultFromTarget(
1160         address target,
1161         bool success,
1162         bytes memory returndata,
1163         string memory errorMessage
1164     ) internal view returns (bytes memory) {
1165         if (success) {
1166             if (returndata.length == 0) {
1167                 // only check isContract if the call was successful and the return data is empty
1168                 // otherwise we already know that it was a contract
1169                 require(isContract(target), "Address: call to non-contract");
1170             }
1171             return returndata;
1172         } else {
1173             _revert(returndata, errorMessage);
1174         }
1175     }
1176 
1177     /**
1178      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1179      * revert reason or using the provided one.
1180      *
1181      * _Available since v4.3._
1182      */
1183     function verifyCallResult(
1184         bool success,
1185         bytes memory returndata,
1186         string memory errorMessage
1187     ) internal pure returns (bytes memory) {
1188         if (success) {
1189             return returndata;
1190         } else {
1191             _revert(returndata, errorMessage);
1192         }
1193     }
1194 
1195     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1196         // Look for revert reason and bubble it up if present
1197         if (returndata.length > 0) {
1198             // The easiest way to bubble the revert reason is using memory via assembly
1199             /// @solidity memory-safe-assembly
1200             assembly {
1201                 let returndata_size := mload(returndata)
1202                 revert(add(32, returndata), returndata_size)
1203             }
1204         } else {
1205             revert(errorMessage);
1206         }
1207     }
1208 }
1209 
1210 // File: @openzeppelin/contracts/utils/StorageSlot.sol
1211 
1212 
1213 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 /**
1218  * @dev Library for reading and writing primitive types to specific storage slots.
1219  *
1220  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
1221  * This library helps with reading and writing to such slots without the need for inline assembly.
1222  *
1223  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
1224  *
1225  * Example usage to set ERC1967 implementation slot:
1226  * ```
1227  * contract ERC1967 {
1228  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
1229  *
1230  *     function _getImplementation() internal view returns (address) {
1231  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
1232  *     }
1233  *
1234  *     function _setImplementation(address newImplementation) internal {
1235  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
1236  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
1237  *     }
1238  * }
1239  * ```
1240  *
1241  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
1242  */
1243 library StorageSlot {
1244     struct AddressSlot {
1245         address value;
1246     }
1247 
1248     struct BooleanSlot {
1249         bool value;
1250     }
1251 
1252     struct Bytes32Slot {
1253         bytes32 value;
1254     }
1255 
1256     struct Uint256Slot {
1257         uint256 value;
1258     }
1259 
1260     /**
1261      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
1262      */
1263     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
1264         /// @solidity memory-safe-assembly
1265         assembly {
1266             r.slot := slot
1267         }
1268     }
1269 
1270     /**
1271      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
1272      */
1273     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
1274         /// @solidity memory-safe-assembly
1275         assembly {
1276             r.slot := slot
1277         }
1278     }
1279 
1280     /**
1281      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
1282      */
1283     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
1284         /// @solidity memory-safe-assembly
1285         assembly {
1286             r.slot := slot
1287         }
1288     }
1289 
1290     /**
1291      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
1292      */
1293     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
1294         /// @solidity memory-safe-assembly
1295         assembly {
1296             r.slot := slot
1297         }
1298     }
1299 }
1300 
1301 // File: erc721psi/contracts/ERC721Psi.sol
1302 
1303 
1304 /**
1305   ______ _____   _____ ______ ___  __ _  _  _
1306  |  ____|  __ \ / ____|____  |__ \/_ | || || |
1307  | |__  | |__) | |        / /   ) || | \| |/ |
1308  |  __| |  _  /| |       / /   / / | |\_   _/
1309  | |____| | \ \| |____  / /   / /_ | |  | |
1310  |______|_|  \_\\_____|/_/   |____||_|  |_|
1311 
1312  - github: https://github.com/estarriolvetch/ERC721Psi
1313  - npm: https://www.npmjs.com/package/erc721psi
1314 
1315  */
1316 
1317 pragma solidity ^0.8.0;
1318 
1319 
1320 
1321 
1322 
1323 
1324 
1325 
1326 
1327 contract ERC721Psi is Context, ERC165, IERC721, IERC721Metadata {
1328     using Address for address;
1329     using Strings for uint256;
1330     using BitMaps for BitMaps.BitMap;
1331 
1332     BitMaps.BitMap private _batchHead;
1333 
1334     string private _name;
1335     string private _symbol;
1336 
1337     // Mapping from token ID to owner address
1338     mapping(uint256 => address) internal _owners;
1339     uint256 private _currentIndex;
1340 
1341     mapping(uint256 => address) private _tokenApprovals;
1342     mapping(address => mapping(address => bool)) private _operatorApprovals;
1343 
1344     /**
1345      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1346      */
1347     constructor(string memory name_, string memory symbol_) {
1348         _name = name_;
1349         _symbol = symbol_;
1350         _currentIndex = _startTokenId();
1351     }
1352 
1353     /**
1354      * @dev Returns the starting token ID.
1355      * To change the starting token ID, please override this function.
1356      */
1357     function _startTokenId() internal pure returns (uint256) {
1358         // It will become modifiable in the future versions
1359         return 0;
1360     }
1361 
1362     /**
1363      * @dev Returns the next token ID to be minted.
1364      */
1365     function _nextTokenId() internal view virtual returns (uint256) {
1366         return _currentIndex;
1367     }
1368 
1369     /**
1370      * @dev Returns the total amount of tokens minted in the contract.
1371      */
1372     function _totalMinted() internal view virtual returns (uint256) {
1373         return _currentIndex - _startTokenId();
1374     }
1375 
1376 
1377     /**
1378      * @dev See {IERC165-supportsInterface}.
1379      */
1380     function supportsInterface(bytes4 interfaceId)
1381         public
1382         view
1383         virtual
1384         override(ERC165, IERC165)
1385         returns (bool)
1386     {
1387         return
1388             interfaceId == type(IERC721).interfaceId ||
1389             interfaceId == type(IERC721Metadata).interfaceId ||
1390             super.supportsInterface(interfaceId);
1391     }
1392 
1393     /**
1394      * @dev See {IERC721-balanceOf}.
1395      */
1396     function balanceOf(address owner)
1397         public
1398         view
1399         virtual
1400         override
1401         returns (uint)
1402     {
1403         require(owner != address(0), "ERC721Psi: balance query for the zero address");
1404 
1405         uint count;
1406         for( uint i = _startTokenId(); i < _nextTokenId(); ++i ){
1407             if(_exists(i)){
1408                 if( owner == ownerOf(i)){
1409                     ++count;
1410                 }
1411             }
1412         }
1413         return count;
1414     }
1415 
1416     /**
1417      * @dev See {IERC721-ownerOf}.
1418      */
1419     function ownerOf(uint256 tokenId)
1420         public
1421         view
1422         virtual
1423         override
1424         returns (address)
1425     {
1426         (address owner, ) = _ownerAndBatchHeadOf(tokenId);
1427         return owner;
1428     }
1429 
1430     function _ownerAndBatchHeadOf(uint256 tokenId) internal view returns (address owner, uint256 tokenIdBatchHead){
1431         require(_exists(tokenId), "ERC721Psi: owner query for nonexistent token");
1432         tokenIdBatchHead = _getBatchHead(tokenId);
1433         owner = _owners[tokenIdBatchHead];
1434     }
1435 
1436     /**
1437      * @dev See {IERC721Metadata-name}.
1438      */
1439     function name() public view virtual override returns (string memory) {
1440         return _name;
1441     }
1442 
1443     /**
1444      * @dev See {IERC721Metadata-symbol}.
1445      */
1446     function symbol() public view virtual override returns (string memory) {
1447         return _symbol;
1448     }
1449 
1450     /**
1451      * @dev See {IERC721Metadata-tokenURI}.
1452      */
1453     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1454         require(_exists(tokenId), "ERC721Psi: URI query for nonexistent token");
1455 
1456         string memory baseURI = _baseURI();
1457         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1458     }
1459 
1460     /**
1461      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1462      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1463      * by default, can be overriden in child contracts.
1464      */
1465     function _baseURI() internal view virtual returns (string memory) {
1466         return "";
1467     }
1468 
1469 
1470     /**
1471      * @dev See {IERC721-approve}.
1472      */
1473     function approve(address to, uint256 tokenId) public virtual override {
1474         address owner = ownerOf(tokenId);
1475         require(to != owner, "ERC721Psi: approval to current owner");
1476 
1477         require(
1478             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1479             "ERC721Psi: approve caller is not owner nor approved for all"
1480         );
1481 
1482         _approve(to, tokenId);
1483     }
1484 
1485     /**
1486      * @dev See {IERC721-getApproved}.
1487      */
1488     function getApproved(uint256 tokenId)
1489         public
1490         view
1491         virtual
1492         override
1493         returns (address)
1494     {
1495         require(
1496             _exists(tokenId),
1497             "ERC721Psi: approved query for nonexistent token"
1498         );
1499 
1500         return _tokenApprovals[tokenId];
1501     }
1502 
1503     /**
1504      * @dev See {IERC721-setApprovalForAll}.
1505      */
1506     function setApprovalForAll(address operator, bool approved)
1507         public
1508         virtual
1509         override
1510     {
1511         require(operator != _msgSender(), "ERC721Psi: approve to caller");
1512 
1513         _operatorApprovals[_msgSender()][operator] = approved;
1514         emit ApprovalForAll(_msgSender(), operator, approved);
1515     }
1516 
1517     /**
1518      * @dev See {IERC721-isApprovedForAll}.
1519      */
1520     function isApprovedForAll(address owner, address operator)
1521         public
1522         view
1523         virtual
1524         override
1525         returns (bool)
1526     {
1527         return _operatorApprovals[owner][operator];
1528     }
1529 
1530     /**
1531      * @dev See {IERC721-transferFrom}.
1532      */
1533     function transferFrom(
1534         address from,
1535         address to,
1536         uint256 tokenId
1537     ) public virtual override {
1538         //solhint-disable-next-line max-line-length
1539         require(
1540             _isApprovedOrOwner(_msgSender(), tokenId),
1541             "ERC721Psi: transfer caller is not owner nor approved"
1542         );
1543 
1544         _transfer(from, to, tokenId);
1545     }
1546 
1547     /**
1548      * @dev See {IERC721-safeTransferFrom}.
1549      */
1550     function safeTransferFrom(
1551         address from,
1552         address to,
1553         uint256 tokenId
1554     ) public virtual override {
1555         safeTransferFrom(from, to, tokenId, "");
1556     }
1557 
1558     /**
1559      * @dev See {IERC721-safeTransferFrom}.
1560      */
1561     function safeTransferFrom(
1562         address from,
1563         address to,
1564         uint256 tokenId,
1565         bytes memory _data
1566     ) public virtual override {
1567         require(
1568             _isApprovedOrOwner(_msgSender(), tokenId),
1569             "ERC721Psi: transfer caller is not owner nor approved"
1570         );
1571         _safeTransfer(from, to, tokenId, _data);
1572     }
1573 
1574     /**
1575      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1576      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1577      *
1578      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1579      *
1580      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1581      * implement alternative mechanisms to perform token transfer, such as signature-based.
1582      *
1583      * Requirements:
1584      *
1585      * - `from` cannot be the zero address.
1586      * - `to` cannot be the zero address.
1587      * - `tokenId` token must exist and be owned by `from`.
1588      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1589      *
1590      * Emits a {Transfer} event.
1591      */
1592     function _safeTransfer(
1593         address from,
1594         address to,
1595         uint256 tokenId,
1596         bytes memory _data
1597     ) internal virtual {
1598         _transfer(from, to, tokenId);
1599         require(
1600             _checkOnERC721Received(from, to, tokenId, 1,_data),
1601             "ERC721Psi: transfer to non ERC721Receiver implementer"
1602         );
1603     }
1604 
1605     /**
1606      * @dev Returns whether `tokenId` exists.
1607      *
1608      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1609      *
1610      * Tokens start existing when they are minted (`_mint`).
1611      */
1612     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1613         return tokenId < _nextTokenId() && _startTokenId() <= tokenId;
1614     }
1615 
1616     /**
1617      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1618      *
1619      * Requirements:
1620      *
1621      * - `tokenId` must exist.
1622      */
1623     function _isApprovedOrOwner(address spender, uint256 tokenId)
1624         internal
1625         view
1626         virtual
1627         returns (bool)
1628     {
1629         require(
1630             _exists(tokenId),
1631             "ERC721Psi: operator query for nonexistent token"
1632         );
1633         address owner = ownerOf(tokenId);
1634         return (spender == owner ||
1635             getApproved(tokenId) == spender ||
1636             isApprovedForAll(owner, spender));
1637     }
1638 
1639     /**
1640      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1641      *
1642      * Requirements:
1643      *
1644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1645      * - `quantity` must be greater than 0.
1646      *
1647      * Emits a {Transfer} event.
1648      */
1649     function _safeMint(address to, uint256 quantity) internal virtual {
1650         _safeMint(to, quantity, "");
1651     }
1652 
1653 
1654     function _safeMint(
1655         address to,
1656         uint256 quantity,
1657         bytes memory _data
1658     ) internal virtual {
1659         uint256 nextTokenId = _nextTokenId();
1660         _mint(to, quantity);
1661         require(
1662             _checkOnERC721Received(address(0), to, nextTokenId, quantity, _data),
1663             "ERC721Psi: transfer to non ERC721Receiver implementer"
1664         );
1665     }
1666 
1667 
1668     function _mint(
1669         address to,
1670         uint256 quantity
1671     ) internal virtual {
1672         uint256 nextTokenId = _nextTokenId();
1673 
1674         require(quantity > 0, "ERC721Psi: quantity must be greater 0");
1675         require(to != address(0), "ERC721Psi: mint to the zero address");
1676 
1677         _beforeTokenTransfers(address(0), to, nextTokenId, quantity);
1678         _currentIndex += quantity;
1679         _owners[nextTokenId] = to;
1680         _batchHead.set(nextTokenId);
1681         _afterTokenTransfers(address(0), to, nextTokenId, quantity);
1682 
1683         // Emit events
1684         for(uint256 tokenId=nextTokenId; tokenId < nextTokenId + quantity; tokenId++){
1685             emit Transfer(address(0), to, tokenId);
1686         }
1687     }
1688 
1689 
1690     /**
1691      * @dev Transfers `tokenId` from `from` to `to`.
1692      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1693      *
1694      * Requirements:
1695      *
1696      * - `to` cannot be the zero address.
1697      * - `tokenId` token must be owned by `from`.
1698      *
1699      * Emits a {Transfer} event.
1700      */
1701     function _transfer(
1702         address from,
1703         address to,
1704         uint256 tokenId
1705     ) internal virtual {
1706         (address owner, uint256 tokenIdBatchHead) = _ownerAndBatchHeadOf(tokenId);
1707 
1708         require(
1709             owner == from,
1710             "ERC721Psi: transfer of token that is not own"
1711         );
1712         require(to != address(0), "ERC721Psi: transfer to the zero address");
1713 
1714         _beforeTokenTransfers(from, to, tokenId, 1);
1715 
1716         // Clear approvals from the previous owner
1717         _approve(address(0), tokenId);
1718 
1719         uint256 subsequentTokenId = tokenId + 1;
1720 
1721         if(!_batchHead.get(subsequentTokenId) &&
1722             subsequentTokenId < _nextTokenId()
1723         ) {
1724             _owners[subsequentTokenId] = from;
1725             _batchHead.set(subsequentTokenId);
1726         }
1727 
1728         _owners[tokenId] = to;
1729         if(tokenId != tokenIdBatchHead) {
1730             _batchHead.set(tokenId);
1731         }
1732 
1733         emit Transfer(from, to, tokenId);
1734 
1735         _afterTokenTransfers(from, to, tokenId, 1);
1736     }
1737 
1738     /**
1739      * @dev Approve `to` to operate on `tokenId`
1740      *
1741      * Emits a {Approval} event.
1742      */
1743     function _approve(address to, uint256 tokenId) internal virtual {
1744         _tokenApprovals[tokenId] = to;
1745         emit Approval(ownerOf(tokenId), to, tokenId);
1746     }
1747 
1748     /**
1749      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1750      * The call is not executed if the target address is not a contract.
1751      *
1752      * @param from address representing the previous owner of the given token ID
1753      * @param to target address that will receive the tokens
1754      * @param startTokenId uint256 the first ID of the tokens to be transferred
1755      * @param quantity uint256 amount of the tokens to be transfered.
1756      * @param _data bytes optional data to send along with the call
1757      * @return r bool whether the call correctly returned the expected magic value
1758      */
1759     function _checkOnERC721Received(
1760         address from,
1761         address to,
1762         uint256 startTokenId,
1763         uint256 quantity,
1764         bytes memory _data
1765     ) private returns (bool r) {
1766         if (to.isContract()) {
1767             r = true;
1768             for(uint256 tokenId = startTokenId; tokenId < startTokenId + quantity; tokenId++){
1769                 try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1770                     r = r && retval == IERC721Receiver.onERC721Received.selector;
1771                 } catch (bytes memory reason) {
1772                     if (reason.length == 0) {
1773                         revert("ERC721Psi: transfer to non ERC721Receiver implementer");
1774                     } else {
1775                         assembly {
1776                             revert(add(32, reason), mload(reason))
1777                         }
1778                     }
1779                 }
1780             }
1781             return r;
1782         } else {
1783             return true;
1784         }
1785     }
1786 
1787     function _getBatchHead(uint256 tokenId) internal view returns (uint256 tokenIdBatchHead) {
1788         tokenIdBatchHead = _batchHead.scanForward(tokenId);
1789     }
1790 
1791 
1792     function totalSupply() public virtual view returns (uint256) {
1793         return _totalMinted();
1794     }
1795 
1796     /**
1797      * @dev Returns an array of token IDs owned by `owner`.
1798      *
1799      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1800      * It is meant to be called off-chain.
1801      *
1802      * This function is compatiable with ERC721AQueryable.
1803      */
1804     function tokensOfOwner(address owner) external view virtual returns (uint256[] memory) {
1805         unchecked {
1806             uint256 tokenIdsIdx;
1807             uint256 tokenIdsLength = balanceOf(owner);
1808             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1809             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1810                 if (_exists(i)) {
1811                     if (ownerOf(i) == owner) {
1812                         tokenIds[tokenIdsIdx++] = i;
1813                     }
1814                 }
1815             }
1816             return tokenIds;
1817         }
1818     }
1819 
1820     /**
1821      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1822      *
1823      * startTokenId - the first token id to be transferred
1824      * quantity - the amount to be transferred
1825      *
1826      * Calling conditions:
1827      *
1828      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1829      * transferred to `to`.
1830      * - When `from` is zero, `tokenId` will be minted for `to`.
1831      */
1832     function _beforeTokenTransfers(
1833         address from,
1834         address to,
1835         uint256 startTokenId,
1836         uint256 quantity
1837     ) internal virtual {}
1838 
1839     /**
1840      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1841      * minting.
1842      *
1843      * startTokenId - the first token id to be transferred
1844      * quantity - the amount to be transferred
1845      *
1846      * Calling conditions:
1847      *
1848      * - when `from` and `to` are both non-zero.
1849      * - `from` and `to` are never both zero.
1850      */
1851     function _afterTokenTransfers(
1852         address from,
1853         address to,
1854         uint256 startTokenId,
1855         uint256 quantity
1856     ) internal virtual {}
1857 }
1858 
1859 // File: erc721psi/contracts/extension/ERC721PsiBurnable.sol
1860 
1861 
1862 /**
1863   ______ _____   _____ ______ ___  __ _  _  _
1864  |  ____|  __ \ / ____|____  |__ \/_ | || || |
1865  | |__  | |__) | |        / /   ) || | \| |/ |
1866  |  __| |  _  /| |       / /   / / | |\_   _/
1867  | |____| | \ \| |____  / /   / /_ | |  | |
1868  |______|_|  \_\\_____|/_/   |____||_|  |_|
1869 
1870 
1871  */
1872 pragma solidity ^0.8.0;
1873 
1874 
1875 abstract contract ERC721PsiBurnable is ERC721Psi {
1876     using BitMaps for BitMaps.BitMap;
1877     BitMaps.BitMap private _burnedToken;
1878 
1879     /**
1880      * @dev Destroys `tokenId`.
1881      * The approval is cleared when the token is burned.
1882      *
1883      * Requirements:
1884      *
1885      * - `tokenId` must exist.
1886      *
1887      * Emits a {Transfer} event.
1888      */
1889     function _burn(uint256 tokenId) internal virtual {
1890         address from = ownerOf(tokenId);
1891         _beforeTokenTransfers(from, address(0), tokenId, 1);
1892         _burnedToken.set(tokenId);
1893 
1894         emit Transfer(from, address(0), tokenId);
1895 
1896         _afterTokenTransfers(from, address(0), tokenId, 1);
1897     }
1898 
1899     /**
1900      * @dev Returns whether `tokenId` exists.
1901      *
1902      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1903      *
1904      * Tokens start existing when they are minted (`_mint`),
1905      * and stop existing when they are burned (`_burn`).
1906      */
1907     function _exists(uint256 tokenId) internal view override virtual returns (bool){
1908         if(_burnedToken.get(tokenId)) {
1909             return false;
1910         }
1911         return super._exists(tokenId);
1912     }
1913 
1914     /**
1915      * @dev See {IERC721Enumerable-totalSupply}.
1916      */
1917     function totalSupply() public view virtual override returns (uint256) {
1918         return _totalMinted() - _burned();
1919     }
1920 
1921     /**
1922      * @dev Returns number of token burned.
1923      */
1924     function _burned() internal view returns (uint256 burned){
1925         uint256 startBucket = _startTokenId() >> 8;
1926         uint256 lastBucket = (_nextTokenId() >> 8) + 1;
1927 
1928         for(uint256 i=startBucket; i < lastBucket; i++) {
1929             uint256 bucket = _burnedToken.getBucket(i);
1930             burned += _popcount(bucket);
1931         }
1932     }
1933 
1934     /**
1935      * @dev Returns number of set bits.
1936      */
1937     function _popcount(uint256 x) private pure returns (uint256 count) {
1938         unchecked{
1939             for (count=0; x!=0; count++)
1940                 x &= x - 1;
1941         }
1942     }
1943 }
1944 
1945 // File: @openzeppelin/contracts/access/Ownable.sol
1946 
1947 
1948 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1949 
1950 pragma solidity ^0.8.0;
1951 
1952 /**
1953  * @dev Contract module which provides a basic access control mechanism, where
1954  * there is an account (an owner) that can be granted exclusive access to
1955  * specific functions.
1956  *
1957  * By default, the owner account will be the one that deploys the contract. This
1958  * can later be changed with {transferOwnership}.
1959  *
1960  * This module is used through inheritance. It will make available the modifier
1961  * `onlyOwner`, which can be applied to your functions to restrict their use to
1962  * the owner.
1963  */
1964 abstract contract Ownable is Context {
1965     address private _owner;
1966 
1967     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1968 
1969     /**
1970      * @dev Initializes the contract setting the deployer as the initial owner.
1971      */
1972     constructor() {
1973         _transferOwnership(_msgSender());
1974     }
1975 
1976     /**
1977      * @dev Throws if called by any account other than the owner.
1978      */
1979     modifier onlyOwner() {
1980         _checkOwner();
1981         _;
1982     }
1983 
1984     /**
1985      * @dev Returns the address of the current owner.
1986      */
1987     function owner() public view virtual returns (address) {
1988         return _owner;
1989     }
1990 
1991     /**
1992      * @dev Throws if the sender is not the owner.
1993      */
1994     function _checkOwner() internal view virtual {
1995         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1996     }
1997 
1998     /**
1999      * @dev Leaves the contract without owner. It will not be possible to call
2000      * `onlyOwner` functions anymore. Can only be called by the current owner.
2001      *
2002      * NOTE: Renouncing ownership will leave the contract without an owner,
2003      * thereby removing any functionality that is only available to the owner.
2004      */
2005     function renounceOwnership() public virtual onlyOwner {
2006         _transferOwnership(address(0));
2007     }
2008 
2009     /**
2010      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2011      * Can only be called by the current owner.
2012      */
2013     function transferOwnership(address newOwner) public virtual onlyOwner {
2014         require(newOwner != address(0), "Ownable: new owner is the zero address");
2015         _transferOwnership(newOwner);
2016     }
2017 
2018     /**
2019      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2020      * Internal function without access restriction.
2021      */
2022     function _transferOwnership(address newOwner) internal virtual {
2023         address oldOwner = _owner;
2024         _owner = newOwner;
2025         emit OwnershipTransferred(oldOwner, newOwner);
2026     }
2027 }
2028 
2029 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2030 
2031 
2032 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
2033 
2034 pragma solidity ^0.8.0;
2035 
2036 /**
2037  * @dev These functions deal with verification of Merkle Tree proofs.
2038  *
2039  * The tree and the proofs can be generated using our
2040  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
2041  * You will find a quickstart guide in the readme.
2042  *
2043  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
2044  * hashing, or use a hash function other than keccak256 for hashing leaves.
2045  * This is because the concatenation of a sorted pair of internal nodes in
2046  * the merkle tree could be reinterpreted as a leaf value.
2047  * OpenZeppelin's JavaScript library generates merkle trees that are safe
2048  * against this attack out of the box.
2049  */
2050 library MerkleProof {
2051     /**
2052      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2053      * defined by `root`. For this, a `proof` must be provided, containing
2054      * sibling hashes on the branch from the leaf to the root of the tree. Each
2055      * pair of leaves and each pair of pre-images are assumed to be sorted.
2056      */
2057     function verify(
2058         bytes32[] memory proof,
2059         bytes32 root,
2060         bytes32 leaf
2061     ) internal pure returns (bool) {
2062         return processProof(proof, leaf) == root;
2063     }
2064 
2065     /**
2066      * @dev Calldata version of {verify}
2067      *
2068      * _Available since v4.7._
2069      */
2070     function verifyCalldata(
2071         bytes32[] calldata proof,
2072         bytes32 root,
2073         bytes32 leaf
2074     ) internal pure returns (bool) {
2075         return processProofCalldata(proof, leaf) == root;
2076     }
2077 
2078     /**
2079      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
2080      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2081      * hash matches the root of the tree. When processing the proof, the pairs
2082      * of leafs & pre-images are assumed to be sorted.
2083      *
2084      * _Available since v4.4._
2085      */
2086     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2087         bytes32 computedHash = leaf;
2088         for (uint256 i = 0; i < proof.length; i++) {
2089             computedHash = _hashPair(computedHash, proof[i]);
2090         }
2091         return computedHash;
2092     }
2093 
2094     /**
2095      * @dev Calldata version of {processProof}
2096      *
2097      * _Available since v4.7._
2098      */
2099     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
2100         bytes32 computedHash = leaf;
2101         for (uint256 i = 0; i < proof.length; i++) {
2102             computedHash = _hashPair(computedHash, proof[i]);
2103         }
2104         return computedHash;
2105     }
2106 
2107     /**
2108      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
2109      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
2110      *
2111      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2112      *
2113      * _Available since v4.7._
2114      */
2115     function multiProofVerify(
2116         bytes32[] memory proof,
2117         bool[] memory proofFlags,
2118         bytes32 root,
2119         bytes32[] memory leaves
2120     ) internal pure returns (bool) {
2121         return processMultiProof(proof, proofFlags, leaves) == root;
2122     }
2123 
2124     /**
2125      * @dev Calldata version of {multiProofVerify}
2126      *
2127      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2128      *
2129      * _Available since v4.7._
2130      */
2131     function multiProofVerifyCalldata(
2132         bytes32[] calldata proof,
2133         bool[] calldata proofFlags,
2134         bytes32 root,
2135         bytes32[] memory leaves
2136     ) internal pure returns (bool) {
2137         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2138     }
2139 
2140     /**
2141      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2142      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2143      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2144      * respectively.
2145      *
2146      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2147      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2148      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2149      *
2150      * _Available since v4.7._
2151      */
2152     function processMultiProof(
2153         bytes32[] memory proof,
2154         bool[] memory proofFlags,
2155         bytes32[] memory leaves
2156     ) internal pure returns (bytes32 merkleRoot) {
2157         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2158         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2159         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2160         // the merkle tree.
2161         uint256 leavesLen = leaves.length;
2162         uint256 totalHashes = proofFlags.length;
2163 
2164         // Check proof validity.
2165         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2166 
2167         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2168         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2169         bytes32[] memory hashes = new bytes32[](totalHashes);
2170         uint256 leafPos = 0;
2171         uint256 hashPos = 0;
2172         uint256 proofPos = 0;
2173         // At each step, we compute the next hash using two values:
2174         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2175         //   get the next hash.
2176         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2177         //   `proof` array.
2178         for (uint256 i = 0; i < totalHashes; i++) {
2179             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2180             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2181             hashes[i] = _hashPair(a, b);
2182         }
2183 
2184         if (totalHashes > 0) {
2185             return hashes[totalHashes - 1];
2186         } else if (leavesLen > 0) {
2187             return leaves[0];
2188         } else {
2189             return proof[0];
2190         }
2191     }
2192 
2193     /**
2194      * @dev Calldata version of {processMultiProof}.
2195      *
2196      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2197      *
2198      * _Available since v4.7._
2199      */
2200     function processMultiProofCalldata(
2201         bytes32[] calldata proof,
2202         bool[] calldata proofFlags,
2203         bytes32[] memory leaves
2204     ) internal pure returns (bytes32 merkleRoot) {
2205         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2206         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2207         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2208         // the merkle tree.
2209         uint256 leavesLen = leaves.length;
2210         uint256 totalHashes = proofFlags.length;
2211 
2212         // Check proof validity.
2213         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2214 
2215         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2216         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2217         bytes32[] memory hashes = new bytes32[](totalHashes);
2218         uint256 leafPos = 0;
2219         uint256 hashPos = 0;
2220         uint256 proofPos = 0;
2221         // At each step, we compute the next hash using two values:
2222         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2223         //   get the next hash.
2224         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2225         //   `proof` array.
2226         for (uint256 i = 0; i < totalHashes; i++) {
2227             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2228             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2229             hashes[i] = _hashPair(a, b);
2230         }
2231 
2232         if (totalHashes > 0) {
2233             return hashes[totalHashes - 1];
2234         } else if (leavesLen > 0) {
2235             return leaves[0];
2236         } else {
2237             return proof[0];
2238         }
2239     }
2240 
2241     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2242         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2243     }
2244 
2245     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2246         /// @solidity memory-safe-assembly
2247         assembly {
2248             mstore(0x00, a)
2249             mstore(0x20, b)
2250             value := keccak256(0x00, 0x40)
2251         }
2252     }
2253 }
2254 
2255 // File: contracts/BEBO.sol
2256 
2257 // SPDX-License-Identifier: UNLICENSED
2258 pragma solidity ^0.8.0;
2259 
2260 
2261 
2262 error MerkleProofVerificationFailed();
2263 error CallerIsContract();
2264 error MintIsOff();
2265 error RoleCodeIsIllegal();
2266 error AddressIsMinted();
2267 error ReachMaxSupply();
2268 error NeedSendMoreETH();
2269 error TokenNotExistent();
2270 error NotOwnerOrApproval();
2271 error MintMoreThanAllowed();
2272 
2273 contract BEBO is ERC721PsiBurnable, Ownable {
2274     using Strings for uint256;
2275 
2276     struct MintConfig {
2277         uint8 preMintMaxCount;
2278         uint8 publicMintMaxCount;
2279         uint32 preMintStartTime;
2280         uint32 publicMintStartTime;
2281         uint256 preMintPriceWei;
2282         uint256 publicMintPriceWei;
2283         string baseTokenURI;
2284         string blindTokenURI;
2285         bytes32 merkleRoot;
2286     }
2287 
2288     mapping(address => uint256) private _preMintedNum;
2289     mapping(address => uint256) private _publicMintedNum;
2290     bool public boxingOpen = false;
2291     uint256 public immutable collectionSize;
2292     MintConfig public config;
2293 
2294     constructor(uint256 collectionSize_) ERC721Psi("BEBO", "BEBO") {
2295         collectionSize = collectionSize_;
2296     }
2297 
2298     modifier callerIsUser() {
2299         if (tx.origin != msg.sender) {
2300             revert CallerIsContract();
2301         }
2302         _;
2303     }
2304 
2305     modifier lessThenMaxSupply(uint256 quantity) {
2306         if (totalSupply() + quantity > collectionSize) {
2307             revert ReachMaxSupply();
2308         }
2309         _;
2310     }
2311 
2312     function airdrop(address receiver,uint256 quantity)external onlyOwner lessThenMaxSupply(quantity){
2313         _safeMint(receiver, quantity);
2314     }
2315 
2316     function reserve(uint256 quantity)external onlyOwner lessThenMaxSupply(quantity){
2317         _safeMint(msg.sender, quantity);
2318     }
2319 
2320     function purchase(uint256 quantity, bytes32[] calldata merkleProof, uint8 roleCode) external payable returns(bool){
2321         // pre—mint
2322         if (roleCode == 1) {
2323             if (isOnlyPreMint(config.preMintStartTime, config.publicMintStartTime)) {
2324                 bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2325                 if (!MerkleProof.verify(merkleProof, config.merkleRoot, leaf)) {
2326                     revert MerkleProofVerificationFailed();
2327                 }
2328                 _mintHelper(
2329                     msg.value,
2330                     config.preMintPriceWei,
2331                     config.preMintStartTime,
2332                     quantity
2333                 );
2334                 return true;
2335             }
2336         }
2337         // public—mint
2338         _mintHelper(
2339             msg.value,
2340             config.publicMintPriceWei,
2341             config.publicMintStartTime,
2342             quantity
2343         );
2344         return true;
2345     }
2346 
2347     function _mintHelper(
2348         uint256 ethValue,
2349         uint256 price,
2350         uint256 mintStartTime,
2351         uint256 quantity
2352     ) private callerIsUser lessThenMaxSupply(quantity) {
2353         if (!isSaleOn(mintStartTime, price)) {
2354             revert MintIsOff();
2355         }
2356         if (ethValue < price) {
2357             revert NeedSendMoreETH();
2358         }
2359         if (price == config.preMintPriceWei) {
2360             if (preMintedNum(msg.sender) + quantity > config.preMintMaxCount) {
2361                 revert MintMoreThanAllowed();
2362             }
2363             _safeMint(msg.sender, quantity);
2364             _preMintedNum[msg.sender] += quantity;
2365         }
2366 
2367         if (price == config.publicMintPriceWei) {
2368             if (
2369                 publicMintedNum(msg.sender) + quantity >
2370                 config.publicMintMaxCount
2371             ) {
2372                 revert MintMoreThanAllowed();
2373             }
2374             _safeMint(msg.sender, quantity);
2375             _publicMintedNum[msg.sender] += quantity;
2376         }
2377     }
2378 
2379     function burn(uint256 tokenId) external virtual {
2380         if (!_isApprovedOrOwner(_msgSender(), tokenId)) {
2381             revert NotOwnerOrApproval();
2382         }
2383         _burn(tokenId);
2384     }
2385 
2386     function withdrawMoney() external onlyOwner {
2387         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2388         require(success, "Transfer failed");
2389     }
2390 
2391     function setConfig(
2392         uint8 preMintMaxCount,
2393         uint8 publicMintMaxCount,
2394         uint32 preMintStartTime,
2395         uint32 publicMintStartTime,
2396         uint256 preMintPriceWei,
2397         uint256 publicMintPriceWei
2398     ) external onlyOwner {
2399         config.preMintMaxCount = preMintMaxCount;
2400         config.publicMintMaxCount = publicMintMaxCount;
2401         config.preMintStartTime = preMintStartTime;
2402         config.publicMintStartTime = publicMintStartTime;
2403         config.preMintPriceWei = preMintPriceWei;
2404         config.publicMintPriceWei = publicMintPriceWei;
2405     }
2406 
2407     function setBaseURI(string calldata baseURI) external onlyOwner {
2408         config.baseTokenURI = baseURI;
2409     }
2410 
2411     function setMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2412         config.merkleRoot = merkleRoot;
2413     }
2414 
2415     function setBlindTokenURI(string calldata blindTokenURI)
2416         external
2417         onlyOwner
2418     {
2419         config.blindTokenURI = blindTokenURI;
2420     }
2421 
2422     function setBoxingStatus(bool status) external onlyOwner {
2423         boxingOpen = status;
2424     }
2425 
2426     function isSaleOn(uint256 mintStartTime, uint256 price)
2427         public
2428         view
2429         returns (bool)
2430     {
2431         return
2432             mintStartTime != 0 &&
2433             price != 0 &&
2434             block.timestamp >= mintStartTime;
2435     }
2436 
2437     function isOnlyPreMint(uint32 preMintStartTime, uint32 publicMintStartTime)
2438         public
2439         view
2440         returns (bool)
2441     {
2442         return
2443             preMintStartTime != 0 &&
2444             block.timestamp < publicMintStartTime &&
2445             block.timestamp >= preMintStartTime;
2446     }
2447 
2448     function preMintedNum(address minter) public view returns (uint256) {
2449         return _preMintedNum[minter];
2450     }
2451 
2452     function publicMintedNum(address minter) public view returns (uint256) {
2453         return _publicMintedNum[minter];
2454     }
2455 
2456     function _baseURI()
2457         internal
2458         view
2459         virtual
2460         override(ERC721Psi)
2461         returns (string memory)
2462     {
2463         return config.baseTokenURI;
2464     }
2465 
2466     function tokenURI(uint256 tokenId)
2467         public
2468         view
2469         virtual
2470         override(ERC721Psi)
2471         returns (string memory)
2472     {
2473         if (!_exists(tokenId)) {
2474             revert TokenNotExistent();
2475         }
2476         if (boxingOpen) {
2477             return
2478                 bytes(_baseURI()).length > 0
2479                     ? string(
2480                         abi.encodePacked(
2481                             _baseURI(),
2482                             tokenId.toString(),
2483                             ".json"
2484                         )
2485                     )
2486                     : "";
2487         } else {
2488             return config.blindTokenURI;
2489         }
2490     }
2491 }