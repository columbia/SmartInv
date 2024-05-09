1 // Sources flattened with hardhat v2.14.0 https://hardhat.org
2 // SPDX-License-Identifier: MIT
3 
4 // File @openzeppelin/contracts/utils/Context.sol@v4.8.3
5 
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
32 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.3
33 
34 
35 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         _checkOwner();
68         _;
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if the sender is not the owner.
80      */
81     function _checkOwner() internal view virtual {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 
117 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.3
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Interface of the ERC165 standard, as defined in the
126  * https://eips.ethereum.org/EIPS/eip-165[EIP].
127  *
128  * Implementers can declare support of contract interfaces, which can then be
129  * queried by others ({ERC165Checker}).
130  *
131  * For an implementation, see {ERC165}.
132  */
133 interface IERC165 {
134     /**
135      * @dev Returns true if this contract implements the interface defined by
136      * `interfaceId`. See the corresponding
137      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
138      * to learn more about how these ids are created.
139      *
140      * This function call must use less than 30 000 gas.
141      */
142     function supportsInterface(bytes4 interfaceId) external view returns (bool);
143 }
144 
145 
146 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.3
147 
148 
149 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Required interface of an ERC721 compliant contract.
155  */
156 interface IERC721 is IERC165 {
157     /**
158      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
159      */
160     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
161 
162     /**
163      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
164      */
165     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
166 
167     /**
168      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
169      */
170     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
171 
172     /**
173      * @dev Returns the number of tokens in ``owner``'s account.
174      */
175     function balanceOf(address owner) external view returns (uint256 balance);
176 
177     /**
178      * @dev Returns the owner of the `tokenId` token.
179      *
180      * Requirements:
181      *
182      * - `tokenId` must exist.
183      */
184     function ownerOf(uint256 tokenId) external view returns (address owner);
185 
186     /**
187      * @dev Safely transfers `tokenId` token from `from` to `to`.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must exist and be owned by `from`.
194      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
195      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
196      *
197      * Emits a {Transfer} event.
198      */
199     function safeTransferFrom(
200         address from,
201         address to,
202         uint256 tokenId,
203         bytes calldata data
204     ) external;
205 
206     /**
207      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
208      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
209      *
210      * Requirements:
211      *
212      * - `from` cannot be the zero address.
213      * - `to` cannot be the zero address.
214      * - `tokenId` token must exist and be owned by `from`.
215      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
216      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
217      *
218      * Emits a {Transfer} event.
219      */
220     function safeTransferFrom(
221         address from,
222         address to,
223         uint256 tokenId
224     ) external;
225 
226     /**
227      * @dev Transfers `tokenId` token from `from` to `to`.
228      *
229      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
230      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
231      * understand this adds an external call which potentially creates a reentrancy vulnerability.
232      *
233      * Requirements:
234      *
235      * - `from` cannot be the zero address.
236      * - `to` cannot be the zero address.
237      * - `tokenId` token must be owned by `from`.
238      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transferFrom(
243         address from,
244         address to,
245         uint256 tokenId
246     ) external;
247 
248     /**
249      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
250      * The approval is cleared when the token is transferred.
251      *
252      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
253      *
254      * Requirements:
255      *
256      * - The caller must own the token or be an approved operator.
257      * - `tokenId` must exist.
258      *
259      * Emits an {Approval} event.
260      */
261     function approve(address to, uint256 tokenId) external;
262 
263     /**
264      * @dev Approve or remove `operator` as an operator for the caller.
265      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
266      *
267      * Requirements:
268      *
269      * - The `operator` cannot be the caller.
270      *
271      * Emits an {ApprovalForAll} event.
272      */
273     function setApprovalForAll(address operator, bool _approved) external;
274 
275     /**
276      * @dev Returns the account approved for `tokenId` token.
277      *
278      * Requirements:
279      *
280      * - `tokenId` must exist.
281      */
282     function getApproved(uint256 tokenId) external view returns (address operator);
283 
284     /**
285      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
286      *
287      * See {setApprovalForAll}
288      */
289     function isApprovedForAll(address owner, address operator) external view returns (bool);
290 }
291 
292 
293 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.8.3
294 
295 
296 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
302  * @dev See https://eips.ethereum.org/EIPS/eip-721
303  */
304 interface IERC721Enumerable is IERC721 {
305     /**
306      * @dev Returns the total amount of tokens stored by the contract.
307      */
308     function totalSupply() external view returns (uint256);
309 
310     /**
311      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
312      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
313      */
314     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
315 
316     /**
317      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
318      * Use along with {totalSupply} to enumerate all tokens.
319      */
320     function tokenByIndex(uint256 index) external view returns (uint256);
321 }
322 
323 
324 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.8.3
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
333  * @dev See https://eips.ethereum.org/EIPS/eip-721
334  */
335 interface IERC721Metadata is IERC721 {
336     /**
337      * @dev Returns the token collection name.
338      */
339     function name() external view returns (string memory);
340 
341     /**
342      * @dev Returns the token collection symbol.
343      */
344     function symbol() external view returns (string memory);
345 
346     /**
347      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
348      */
349     function tokenURI(uint256 tokenId) external view returns (string memory);
350 }
351 
352 
353 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.3
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Implementation of the {IERC165} interface.
362  *
363  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
364  * for the additional interface id that will be supported. For example:
365  *
366  * ```solidity
367  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
369  * }
370  * ```
371  *
372  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
373  */
374 abstract contract ERC165 is IERC165 {
375     /**
376      * @dev See {IERC165-supportsInterface}.
377      */
378     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
379         return interfaceId == type(IERC165).interfaceId;
380     }
381 }
382 
383 
384 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.3
385 
386 
387 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 /**
392  * @dev Standard math utilities missing in the Solidity language.
393  */
394 library Math {
395     enum Rounding {
396         Down, // Toward negative infinity
397         Up, // Toward infinity
398         Zero // Toward zero
399     }
400 
401     /**
402      * @dev Returns the largest of two numbers.
403      */
404     function max(uint256 a, uint256 b) internal pure returns (uint256) {
405         return a > b ? a : b;
406     }
407 
408     /**
409      * @dev Returns the smallest of two numbers.
410      */
411     function min(uint256 a, uint256 b) internal pure returns (uint256) {
412         return a < b ? a : b;
413     }
414 
415     /**
416      * @dev Returns the average of two numbers. The result is rounded towards
417      * zero.
418      */
419     function average(uint256 a, uint256 b) internal pure returns (uint256) {
420         // (a + b) / 2 can overflow.
421         return (a & b) + (a ^ b) / 2;
422     }
423 
424     /**
425      * @dev Returns the ceiling of the division of two numbers.
426      *
427      * This differs from standard division with `/` in that it rounds up instead
428      * of rounding down.
429      */
430     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
431         // (a + b - 1) / b can overflow on addition, so we distribute.
432         return a == 0 ? 0 : (a - 1) / b + 1;
433     }
434 
435     /**
436      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
437      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
438      * with further edits by Uniswap Labs also under MIT license.
439      */
440     function mulDiv(
441         uint256 x,
442         uint256 y,
443         uint256 denominator
444     ) internal pure returns (uint256 result) {
445         unchecked {
446             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
447             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
448             // variables such that product = prod1 * 2^256 + prod0.
449             uint256 prod0; // Least significant 256 bits of the product
450             uint256 prod1; // Most significant 256 bits of the product
451             assembly {
452                 let mm := mulmod(x, y, not(0))
453                 prod0 := mul(x, y)
454                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
455             }
456 
457             // Handle non-overflow cases, 256 by 256 division.
458             if (prod1 == 0) {
459                 return prod0 / denominator;
460             }
461 
462             // Make sure the result is less than 2^256. Also prevents denominator == 0.
463             require(denominator > prod1);
464 
465             ///////////////////////////////////////////////
466             // 512 by 256 division.
467             ///////////////////////////////////////////////
468 
469             // Make division exact by subtracting the remainder from [prod1 prod0].
470             uint256 remainder;
471             assembly {
472                 // Compute remainder using mulmod.
473                 remainder := mulmod(x, y, denominator)
474 
475                 // Subtract 256 bit number from 512 bit number.
476                 prod1 := sub(prod1, gt(remainder, prod0))
477                 prod0 := sub(prod0, remainder)
478             }
479 
480             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
481             // See https://cs.stackexchange.com/q/138556/92363.
482 
483             // Does not overflow because the denominator cannot be zero at this stage in the function.
484             uint256 twos = denominator & (~denominator + 1);
485             assembly {
486                 // Divide denominator by twos.
487                 denominator := div(denominator, twos)
488 
489                 // Divide [prod1 prod0] by twos.
490                 prod0 := div(prod0, twos)
491 
492                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
493                 twos := add(div(sub(0, twos), twos), 1)
494             }
495 
496             // Shift in bits from prod1 into prod0.
497             prod0 |= prod1 * twos;
498 
499             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
500             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
501             // four bits. That is, denominator * inv = 1 mod 2^4.
502             uint256 inverse = (3 * denominator) ^ 2;
503 
504             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
505             // in modular arithmetic, doubling the correct bits in each step.
506             inverse *= 2 - denominator * inverse; // inverse mod 2^8
507             inverse *= 2 - denominator * inverse; // inverse mod 2^16
508             inverse *= 2 - denominator * inverse; // inverse mod 2^32
509             inverse *= 2 - denominator * inverse; // inverse mod 2^64
510             inverse *= 2 - denominator * inverse; // inverse mod 2^128
511             inverse *= 2 - denominator * inverse; // inverse mod 2^256
512 
513             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
514             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
515             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
516             // is no longer required.
517             result = prod0 * inverse;
518             return result;
519         }
520     }
521 
522     /**
523      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
524      */
525     function mulDiv(
526         uint256 x,
527         uint256 y,
528         uint256 denominator,
529         Rounding rounding
530     ) internal pure returns (uint256) {
531         uint256 result = mulDiv(x, y, denominator);
532         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
533             result += 1;
534         }
535         return result;
536     }
537 
538     /**
539      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
540      *
541      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
542      */
543     function sqrt(uint256 a) internal pure returns (uint256) {
544         if (a == 0) {
545             return 0;
546         }
547 
548         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
549         //
550         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
551         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
552         //
553         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
554         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
555         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
556         //
557         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
558         uint256 result = 1 << (log2(a) >> 1);
559 
560         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
561         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
562         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
563         // into the expected uint128 result.
564         unchecked {
565             result = (result + a / result) >> 1;
566             result = (result + a / result) >> 1;
567             result = (result + a / result) >> 1;
568             result = (result + a / result) >> 1;
569             result = (result + a / result) >> 1;
570             result = (result + a / result) >> 1;
571             result = (result + a / result) >> 1;
572             return min(result, a / result);
573         }
574     }
575 
576     /**
577      * @notice Calculates sqrt(a), following the selected rounding direction.
578      */
579     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
580         unchecked {
581             uint256 result = sqrt(a);
582             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
583         }
584     }
585 
586     /**
587      * @dev Return the log in base 2, rounded down, of a positive value.
588      * Returns 0 if given 0.
589      */
590     function log2(uint256 value) internal pure returns (uint256) {
591         uint256 result = 0;
592         unchecked {
593             if (value >> 128 > 0) {
594                 value >>= 128;
595                 result += 128;
596             }
597             if (value >> 64 > 0) {
598                 value >>= 64;
599                 result += 64;
600             }
601             if (value >> 32 > 0) {
602                 value >>= 32;
603                 result += 32;
604             }
605             if (value >> 16 > 0) {
606                 value >>= 16;
607                 result += 16;
608             }
609             if (value >> 8 > 0) {
610                 value >>= 8;
611                 result += 8;
612             }
613             if (value >> 4 > 0) {
614                 value >>= 4;
615                 result += 4;
616             }
617             if (value >> 2 > 0) {
618                 value >>= 2;
619                 result += 2;
620             }
621             if (value >> 1 > 0) {
622                 result += 1;
623             }
624         }
625         return result;
626     }
627 
628     /**
629      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
630      * Returns 0 if given 0.
631      */
632     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
633         unchecked {
634             uint256 result = log2(value);
635             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
636         }
637     }
638 
639     /**
640      * @dev Return the log in base 10, rounded down, of a positive value.
641      * Returns 0 if given 0.
642      */
643     function log10(uint256 value) internal pure returns (uint256) {
644         uint256 result = 0;
645         unchecked {
646             if (value >= 10**64) {
647                 value /= 10**64;
648                 result += 64;
649             }
650             if (value >= 10**32) {
651                 value /= 10**32;
652                 result += 32;
653             }
654             if (value >= 10**16) {
655                 value /= 10**16;
656                 result += 16;
657             }
658             if (value >= 10**8) {
659                 value /= 10**8;
660                 result += 8;
661             }
662             if (value >= 10**4) {
663                 value /= 10**4;
664                 result += 4;
665             }
666             if (value >= 10**2) {
667                 value /= 10**2;
668                 result += 2;
669             }
670             if (value >= 10**1) {
671                 result += 1;
672             }
673         }
674         return result;
675     }
676 
677     /**
678      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
679      * Returns 0 if given 0.
680      */
681     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
682         unchecked {
683             uint256 result = log10(value);
684             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
685         }
686     }
687 
688     /**
689      * @dev Return the log in base 256, rounded down, of a positive value.
690      * Returns 0 if given 0.
691      *
692      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
693      */
694     function log256(uint256 value) internal pure returns (uint256) {
695         uint256 result = 0;
696         unchecked {
697             if (value >> 128 > 0) {
698                 value >>= 128;
699                 result += 16;
700             }
701             if (value >> 64 > 0) {
702                 value >>= 64;
703                 result += 8;
704             }
705             if (value >> 32 > 0) {
706                 value >>= 32;
707                 result += 4;
708             }
709             if (value >> 16 > 0) {
710                 value >>= 16;
711                 result += 2;
712             }
713             if (value >> 8 > 0) {
714                 result += 1;
715             }
716         }
717         return result;
718     }
719 
720     /**
721      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
722      * Returns 0 if given 0.
723      */
724     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
725         unchecked {
726             uint256 result = log256(value);
727             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
728         }
729     }
730 }
731 
732 
733 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.3
734 
735 
736 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
737 
738 pragma solidity ^0.8.0;
739 
740 /**
741  * @dev String operations.
742  */
743 library Strings {
744     bytes16 private constant _SYMBOLS = "0123456789abcdef";
745     uint8 private constant _ADDRESS_LENGTH = 20;
746 
747     /**
748      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
749      */
750     function toString(uint256 value) internal pure returns (string memory) {
751         unchecked {
752             uint256 length = Math.log10(value) + 1;
753             string memory buffer = new string(length);
754             uint256 ptr;
755             /// @solidity memory-safe-assembly
756             assembly {
757                 ptr := add(buffer, add(32, length))
758             }
759             while (true) {
760                 ptr--;
761                 /// @solidity memory-safe-assembly
762                 assembly {
763                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
764                 }
765                 value /= 10;
766                 if (value == 0) break;
767             }
768             return buffer;
769         }
770     }
771 
772     /**
773      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
774      */
775     function toHexString(uint256 value) internal pure returns (string memory) {
776         unchecked {
777             return toHexString(value, Math.log256(value) + 1);
778         }
779     }
780 
781     /**
782      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
783      */
784     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
785         bytes memory buffer = new bytes(2 * length + 2);
786         buffer[0] = "0";
787         buffer[1] = "x";
788         for (uint256 i = 2 * length + 1; i > 1; --i) {
789             buffer[i] = _SYMBOLS[value & 0xf];
790             value >>= 4;
791         }
792         require(value == 0, "Strings: hex length insufficient");
793         return string(buffer);
794     }
795 
796     /**
797      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
798      */
799     function toHexString(address addr) internal pure returns (string memory) {
800         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
801     }
802 }
803 
804 
805 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.3
806 
807 
808 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
809 
810 pragma solidity ^0.8.0;
811 
812 /**
813  * @title ERC721 token receiver interface
814  * @dev Interface for any contract that wants to support safeTransfers
815  * from ERC721 asset contracts.
816  */
817 interface IERC721Receiver {
818     /**
819      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
820      * by `operator` from `from`, this function is called.
821      *
822      * It must return its Solidity selector to confirm the token transfer.
823      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
824      *
825      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
826      */
827     function onERC721Received(
828         address operator,
829         address from,
830         uint256 tokenId,
831         bytes calldata data
832     ) external returns (bytes4);
833 }
834 
835 
836 // File @openzeppelin/contracts/utils/Address.sol@v4.8.3
837 
838 
839 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
840 
841 pragma solidity ^0.8.1;
842 
843 /**
844  * @dev Collection of functions related to the address type
845  */
846 library Address {
847     /**
848      * @dev Returns true if `account` is a contract.
849      *
850      * [IMPORTANT]
851      * ====
852      * It is unsafe to assume that an address for which this function returns
853      * false is an externally-owned account (EOA) and not a contract.
854      *
855      * Among others, `isContract` will return false for the following
856      * types of addresses:
857      *
858      *  - an externally-owned account
859      *  - a contract in construction
860      *  - an address where a contract will be created
861      *  - an address where a contract lived, but was destroyed
862      * ====
863      *
864      * [IMPORTANT]
865      * ====
866      * You shouldn't rely on `isContract` to protect against flash loan attacks!
867      *
868      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
869      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
870      * constructor.
871      * ====
872      */
873     function isContract(address account) internal view returns (bool) {
874         // This method relies on extcodesize/address.code.length, which returns 0
875         // for contracts in construction, since the code is only stored at the end
876         // of the constructor execution.
877 
878         return account.code.length > 0;
879     }
880 
881     /**
882      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
883      * `recipient`, forwarding all available gas and reverting on errors.
884      *
885      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
886      * of certain opcodes, possibly making contracts go over the 2300 gas limit
887      * imposed by `transfer`, making them unable to receive funds via
888      * `transfer`. {sendValue} removes this limitation.
889      *
890      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
891      *
892      * IMPORTANT: because control is transferred to `recipient`, care must be
893      * taken to not create reentrancy vulnerabilities. Consider using
894      * {ReentrancyGuard} or the
895      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
896      */
897     function sendValue(address payable recipient, uint256 amount) internal {
898         require(address(this).balance >= amount, "Address: insufficient balance");
899 
900         (bool success, ) = recipient.call{value: amount}("");
901         require(success, "Address: unable to send value, recipient may have reverted");
902     }
903 
904     /**
905      * @dev Performs a Solidity function call using a low level `call`. A
906      * plain `call` is an unsafe replacement for a function call: use this
907      * function instead.
908      *
909      * If `target` reverts with a revert reason, it is bubbled up by this
910      * function (like regular Solidity function calls).
911      *
912      * Returns the raw returned data. To convert to the expected return value,
913      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
914      *
915      * Requirements:
916      *
917      * - `target` must be a contract.
918      * - calling `target` with `data` must not revert.
919      *
920      * _Available since v3.1._
921      */
922     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
923         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
924     }
925 
926     /**
927      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
928      * `errorMessage` as a fallback revert reason when `target` reverts.
929      *
930      * _Available since v3.1._
931      */
932     function functionCall(
933         address target,
934         bytes memory data,
935         string memory errorMessage
936     ) internal returns (bytes memory) {
937         return functionCallWithValue(target, data, 0, errorMessage);
938     }
939 
940     /**
941      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
942      * but also transferring `value` wei to `target`.
943      *
944      * Requirements:
945      *
946      * - the calling contract must have an ETH balance of at least `value`.
947      * - the called Solidity function must be `payable`.
948      *
949      * _Available since v3.1._
950      */
951     function functionCallWithValue(
952         address target,
953         bytes memory data,
954         uint256 value
955     ) internal returns (bytes memory) {
956         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
957     }
958 
959     /**
960      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
961      * with `errorMessage` as a fallback revert reason when `target` reverts.
962      *
963      * _Available since v3.1._
964      */
965     function functionCallWithValue(
966         address target,
967         bytes memory data,
968         uint256 value,
969         string memory errorMessage
970     ) internal returns (bytes memory) {
971         require(address(this).balance >= value, "Address: insufficient balance for call");
972         (bool success, bytes memory returndata) = target.call{value: value}(data);
973         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
974     }
975 
976     /**
977      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
978      * but performing a static call.
979      *
980      * _Available since v3.3._
981      */
982     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
983         return functionStaticCall(target, data, "Address: low-level static call failed");
984     }
985 
986     /**
987      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
988      * but performing a static call.
989      *
990      * _Available since v3.3._
991      */
992     function functionStaticCall(
993         address target,
994         bytes memory data,
995         string memory errorMessage
996     ) internal view returns (bytes memory) {
997         (bool success, bytes memory returndata) = target.staticcall(data);
998         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
999     }
1000 
1001     /**
1002      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1003      * but performing a delegate call.
1004      *
1005      * _Available since v3.4._
1006      */
1007     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1008         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1009     }
1010 
1011     /**
1012      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1013      * but performing a delegate call.
1014      *
1015      * _Available since v3.4._
1016      */
1017     function functionDelegateCall(
1018         address target,
1019         bytes memory data,
1020         string memory errorMessage
1021     ) internal returns (bytes memory) {
1022         (bool success, bytes memory returndata) = target.delegatecall(data);
1023         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1024     }
1025 
1026     /**
1027      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1028      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1029      *
1030      * _Available since v4.8._
1031      */
1032     function verifyCallResultFromTarget(
1033         address target,
1034         bool success,
1035         bytes memory returndata,
1036         string memory errorMessage
1037     ) internal view returns (bytes memory) {
1038         if (success) {
1039             if (returndata.length == 0) {
1040                 // only check isContract if the call was successful and the return data is empty
1041                 // otherwise we already know that it was a contract
1042                 require(isContract(target), "Address: call to non-contract");
1043             }
1044             return returndata;
1045         } else {
1046             _revert(returndata, errorMessage);
1047         }
1048     }
1049 
1050     /**
1051      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1052      * revert reason or using the provided one.
1053      *
1054      * _Available since v4.3._
1055      */
1056     function verifyCallResult(
1057         bool success,
1058         bytes memory returndata,
1059         string memory errorMessage
1060     ) internal pure returns (bytes memory) {
1061         if (success) {
1062             return returndata;
1063         } else {
1064             _revert(returndata, errorMessage);
1065         }
1066     }
1067 
1068     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1069         // Look for revert reason and bubble it up if present
1070         if (returndata.length > 0) {
1071             // The easiest way to bubble the revert reason is using memory via assembly
1072             /// @solidity memory-safe-assembly
1073             assembly {
1074                 let returndata_size := mload(returndata)
1075                 revert(add(32, returndata), returndata_size)
1076             }
1077         } else {
1078             revert(errorMessage);
1079         }
1080     }
1081 }
1082 
1083 
1084 // File contracts/ERC721A.sol
1085 
1086 
1087 
1088 pragma solidity ^0.8.0;
1089 
1090 
1091 
1092 
1093 
1094 
1095 
1096 
1097 /**
1098  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1099  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1100  *
1101  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1102  *
1103  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1104  *
1105  * Does not support burning tokens to address(0).
1106  */
1107 contract ERC721A is
1108   Context,
1109   ERC165,
1110   IERC721,
1111   IERC721Metadata,
1112   IERC721Enumerable
1113 {
1114   using Address for address;
1115   using Strings for uint256;
1116 
1117   struct TokenOwnership {
1118     address addr;
1119     uint64 startTimestamp;
1120   }
1121 
1122   struct AddressData {
1123     uint128 balance;
1124     uint128 numberMinted;
1125   }
1126 
1127   uint256 private currentIndex = 1;
1128 
1129   uint256 internal immutable collectionSize;
1130   uint256 internal immutable maxBatchSize;
1131 
1132   // Token name
1133   string private _name;
1134 
1135   // Token symbol
1136   string private _symbol;
1137 
1138   // Mapping from token ID to ownership details
1139   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1140   mapping(uint256 => TokenOwnership) private _ownerships;
1141 
1142   // Mapping owner address to address data
1143   mapping(address => AddressData) private _addressData;
1144 
1145   // Mapping from token ID to approved address
1146   mapping(uint256 => address) private _tokenApprovals;
1147 
1148   // Mapping from owner to operator approvals
1149   mapping(address => mapping(address => bool)) private _operatorApprovals;
1150 
1151   /**
1152    * @dev
1153    * `maxBatchSize` refers to how much a minter can mint at a time.
1154    * `collectionSize_` refers to how many tokens are in the collection.
1155    */
1156   constructor(
1157     string memory name_,
1158     string memory symbol_,
1159     uint256 maxBatchSize_,
1160     uint256 collectionSize_
1161   ) {
1162     require(
1163       collectionSize_ > 0,
1164       "ERC721A: collection must have a nonzero supply"
1165     );
1166     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1167     _name = name_;
1168     _symbol = symbol_;
1169     maxBatchSize = maxBatchSize_;
1170     collectionSize = collectionSize_;
1171   }
1172 
1173   /**
1174    * @dev See {IERC721Enumerable-totalSupply}.
1175    */
1176   function totalSupply() public view override returns (uint256) {
1177     return currentIndex - 1;
1178   }
1179 
1180   /**
1181    * @dev See {IERC721Enumerable-tokenByIndex}.
1182    */
1183   function tokenByIndex(uint256 index) public view override returns (uint256) {
1184     require(index < totalSupply(), "ERC721A: global index out of bounds");
1185     return index;
1186   }
1187 
1188   /**
1189    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1190    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1191    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1192    */
1193   function tokenOfOwnerByIndex(address owner, uint256 index)
1194     public
1195     view
1196     override
1197     returns (uint256)
1198   {
1199     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1200     uint256 numMintedSoFar = totalSupply();
1201     uint256 tokenIdsIdx = 0;
1202     address currOwnershipAddr = address(0);
1203     for (uint256 i = 0; i < numMintedSoFar; i++) {
1204       TokenOwnership memory ownership = _ownerships[i];
1205       if (ownership.addr != address(0)) {
1206         currOwnershipAddr = ownership.addr;
1207       }
1208       if (currOwnershipAddr == owner) {
1209         if (tokenIdsIdx == index) {
1210           return i;
1211         }
1212         tokenIdsIdx++;
1213       }
1214     }
1215     revert("ERC721A: unable to get token of owner by index");
1216   }
1217 
1218   /**
1219    * @dev See {IERC165-supportsInterface}.
1220    */
1221   function supportsInterface(bytes4 interfaceId)
1222     public
1223     view
1224     virtual
1225     override(ERC165, IERC165)
1226     returns (bool)
1227   {
1228     return
1229       interfaceId == type(IERC721).interfaceId ||
1230       interfaceId == type(IERC721Metadata).interfaceId ||
1231       interfaceId == type(IERC721Enumerable).interfaceId ||
1232       super.supportsInterface(interfaceId);
1233   }
1234 
1235   /**
1236    * @dev See {IERC721-balanceOf}.
1237    */
1238   function balanceOf(address owner) public view override returns (uint256) {
1239     require(owner != address(0), "ERC721A: balance query for the zero address");
1240     return uint256(_addressData[owner].balance);
1241   }
1242 
1243   function _numberMinted(address owner) internal view returns (uint256) {
1244     require(
1245       owner != address(0),
1246       "ERC721A: number minted query for the zero address"
1247     );
1248     return uint256(_addressData[owner].numberMinted);
1249   }
1250 
1251   function ownershipOf(uint256 tokenId)
1252     internal
1253     view
1254     returns (TokenOwnership memory)
1255   {
1256     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1257 
1258     uint256 lowestTokenToCheck;
1259     if (tokenId >= maxBatchSize) {
1260       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1261     }
1262 
1263     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1264       TokenOwnership memory ownership = _ownerships[curr];
1265       if (ownership.addr != address(0)) {
1266         return ownership;
1267       }
1268     }
1269 
1270     revert("ERC721A: unable to determine the owner of token");
1271   }
1272 
1273   /**
1274    * @dev See {IERC721-ownerOf}.
1275    */
1276   function ownerOf(uint256 tokenId) public view override returns (address) {
1277     return ownershipOf(tokenId).addr;
1278   }
1279 
1280   /**
1281    * @dev See {IERC721Metadata-name}.
1282    */
1283   function name() public view virtual override returns (string memory) {
1284     return _name;
1285   }
1286 
1287   /**
1288    * @dev See {IERC721Metadata-symbol}.
1289    */
1290   function symbol() public view virtual override returns (string memory) {
1291     return _symbol;
1292   }
1293 
1294   /**
1295    * @dev See {IERC721Metadata-tokenURI}.
1296    */
1297   function tokenURI(uint256 tokenId)
1298     public
1299     view
1300     virtual
1301     override
1302     returns (string memory)
1303   {
1304     require(
1305       _exists(tokenId),
1306       "ERC721Metadata: URI query for nonexistent token"
1307     );
1308 
1309     string memory baseURI = _baseURI();
1310     return
1311       bytes(baseURI).length > 0
1312         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1313         : "";
1314   }
1315 
1316   /**
1317    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1318    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1319    * by default, can be overriden in child contracts.
1320    */
1321   function _baseURI() internal view virtual returns (string memory) {
1322     return "";
1323   }
1324 
1325   /**
1326    * @dev See {IERC721-approve}.
1327    */
1328   function approve(address to, uint256 tokenId) public override {
1329     address owner = ERC721A.ownerOf(tokenId);
1330     require(to != owner, "ERC721A: approval to current owner");
1331 
1332     require(
1333       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1334       "ERC721A: approve caller is not owner nor approved for all"
1335     );
1336 
1337     _approve(to, tokenId, owner);
1338   }
1339 
1340   /**
1341    * @dev See {IERC721-getApproved}.
1342    */
1343   function getApproved(uint256 tokenId) public view override returns (address) {
1344     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1345 
1346     return _tokenApprovals[tokenId];
1347   }
1348 
1349   /**
1350    * @dev See {IERC721-setApprovalForAll}.
1351    */
1352   function setApprovalForAll(address operator, bool approved) public override {
1353     require(operator != _msgSender(), "ERC721A: approve to caller");
1354 
1355     _operatorApprovals[_msgSender()][operator] = approved;
1356     emit ApprovalForAll(_msgSender(), operator, approved);
1357   }
1358 
1359   /**
1360    * @dev See {IERC721-isApprovedForAll}.
1361    */
1362   function isApprovedForAll(address owner, address operator)
1363     public
1364     view
1365     virtual
1366     override
1367     returns (bool)
1368   {
1369     return _operatorApprovals[owner][operator];
1370   }
1371 
1372   /**
1373    * @dev See {IERC721-transferFrom}.
1374    */
1375   function transferFrom(
1376     address from,
1377     address to,
1378     uint256 tokenId
1379   ) public override {
1380     _transfer(from, to, tokenId);
1381   }
1382 
1383   /**
1384    * @dev See {IERC721-safeTransferFrom}.
1385    */
1386   function safeTransferFrom(
1387     address from,
1388     address to,
1389     uint256 tokenId
1390   ) public override {
1391     safeTransferFrom(from, to, tokenId, "");
1392   }
1393 
1394   /**
1395    * @dev See {IERC721-safeTransferFrom}.
1396    */
1397   function safeTransferFrom(
1398     address from,
1399     address to,
1400     uint256 tokenId,
1401     bytes memory _data
1402   ) public override {
1403     _transfer(from, to, tokenId);
1404     require(
1405       _checkOnERC721Received(from, to, tokenId, _data),
1406       "ERC721A: transfer to non ERC721Receiver implementer"
1407     );
1408   }
1409 
1410   /**
1411    * @dev Returns whether `tokenId` exists.
1412    *
1413    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1414    *
1415    * Tokens start existing when they are minted (`_mint`),
1416    */
1417   function _exists(uint256 tokenId) internal view returns (bool) {
1418     return tokenId < currentIndex;
1419   }
1420 
1421   function _safeMint(address to, uint256 quantity) internal {
1422     _safeMint(to, quantity, "");
1423   }
1424 
1425   /**
1426    * @dev Mints `quantity` tokens and transfers them to `to`.
1427    *
1428    * Requirements:
1429    *
1430    * - there must be `quantity` tokens remaining unminted in the total collection.
1431    * - `to` cannot be the zero address.
1432    * - `quantity` cannot be larger than the max batch size.
1433    *
1434    * Emits a {Transfer} event.
1435    */
1436   function _safeMint(
1437     address to,
1438     uint256 quantity,
1439     bytes memory _data
1440   ) internal {
1441     uint256 startTokenId = currentIndex;
1442     require(to != address(0), "ERC721A: mint to the zero address");
1443     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1444     require(!_exists(startTokenId), "ERC721A: token already minted");
1445     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1446 
1447     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1448 
1449     AddressData memory addressData = _addressData[to];
1450     _addressData[to] = AddressData(
1451       addressData.balance + uint128(quantity),
1452       addressData.numberMinted + uint128(quantity)
1453     );
1454     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1455 
1456     uint256 updatedIndex = startTokenId;
1457 
1458     for (uint256 i = 0; i < quantity; i++) {
1459       emit Transfer(address(0), to, updatedIndex);
1460       require(
1461         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1462         "ERC721A: transfer to non ERC721Receiver implementer"
1463       );
1464       updatedIndex++;
1465     }
1466 
1467     currentIndex = updatedIndex;
1468     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1469   }
1470 
1471   /**
1472    * @dev Transfers `tokenId` from `from` to `to`.
1473    *
1474    * Requirements:
1475    *
1476    * - `to` cannot be the zero address.
1477    * - `tokenId` token must be owned by `from`.
1478    *
1479    * Emits a {Transfer} event.
1480    */
1481   function _transfer(
1482     address from,
1483     address to,
1484     uint256 tokenId
1485   ) private {
1486     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1487 
1488     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1489       getApproved(tokenId) == _msgSender() ||
1490       isApprovedForAll(prevOwnership.addr, _msgSender()));
1491 
1492     require(
1493       isApprovedOrOwner,
1494       "ERC721A: transfer caller is not owner nor approved"
1495     );
1496 
1497     require(
1498       prevOwnership.addr == from,
1499       "ERC721A: transfer from incorrect owner"
1500     );
1501     require(to != address(0), "ERC721A: transfer to the zero address");
1502 
1503     _beforeTokenTransfers(from, to, tokenId, 1);
1504 
1505     // Clear approvals from the previous owner
1506     _approve(address(0), tokenId, prevOwnership.addr);
1507 
1508     _addressData[from].balance -= 1;
1509     _addressData[to].balance += 1;
1510     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1511 
1512     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1513     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1514     uint256 nextTokenId = tokenId + 1;
1515     if (_ownerships[nextTokenId].addr == address(0)) {
1516       if (_exists(nextTokenId)) {
1517         _ownerships[nextTokenId] = TokenOwnership(
1518           prevOwnership.addr,
1519           prevOwnership.startTimestamp
1520         );
1521       }
1522     }
1523 
1524     emit Transfer(from, to, tokenId);
1525     _afterTokenTransfers(from, to, tokenId, 1);
1526   }
1527 
1528   /**
1529    * @dev Approve `to` to operate on `tokenId`
1530    *
1531    * Emits a {Approval} event.
1532    */
1533   function _approve(
1534     address to,
1535     uint256 tokenId,
1536     address owner
1537   ) private {
1538     _tokenApprovals[tokenId] = to;
1539     emit Approval(owner, to, tokenId);
1540   }
1541 
1542   uint256 public nextOwnerToExplicitlySet = 0;
1543 
1544   /**
1545    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1546    */
1547   function _setOwnersExplicit(uint256 quantity) internal {
1548     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1549     require(quantity > 0, "quantity must be nonzero");
1550     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1551     if (endIndex > collectionSize - 1) {
1552       endIndex = collectionSize - 1;
1553     }
1554     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1555     require(_exists(endIndex), "not enough minted yet for this cleanup");
1556     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1557       if (_ownerships[i].addr == address(0)) {
1558         TokenOwnership memory ownership = ownershipOf(i);
1559         _ownerships[i] = TokenOwnership(
1560           ownership.addr,
1561           ownership.startTimestamp
1562         );
1563       }
1564     }
1565     nextOwnerToExplicitlySet = endIndex + 1;
1566   }
1567 
1568   /**
1569    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1570    * The call is not executed if the target address is not a contract.
1571    *
1572    * @param from address representing the previous owner of the given token ID
1573    * @param to target address that will receive the tokens
1574    * @param tokenId uint256 ID of the token to be transferred
1575    * @param _data bytes optional data to send along with the call
1576    * @return bool whether the call correctly returned the expected magic value
1577    */
1578   function _checkOnERC721Received(
1579     address from,
1580     address to,
1581     uint256 tokenId,
1582     bytes memory _data
1583   ) private returns (bool) {
1584     if (to.isContract()) {
1585       try
1586         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1587       returns (bytes4 retval) {
1588         return retval == IERC721Receiver(to).onERC721Received.selector;
1589       } catch (bytes memory reason) {
1590         if (reason.length == 0) {
1591           revert("ERC721A: transfer to non ERC721Receiver implementer");
1592         } else {
1593           assembly {
1594             revert(add(32, reason), mload(reason))
1595           }
1596         }
1597       }
1598     } else {
1599       return true;
1600     }
1601   }
1602 
1603   /**
1604    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1605    *
1606    * startTokenId - the first token id to be transferred
1607    * quantity - the amount to be transferred
1608    *
1609    * Calling conditions:
1610    *
1611    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1612    * transferred to `to`.
1613    * - When `from` is zero, `tokenId` will be minted for `to`.
1614    */
1615   function _beforeTokenTransfers(
1616     address from,
1617     address to,
1618     uint256 startTokenId,
1619     uint256 quantity
1620   ) internal virtual {}
1621 
1622   /**
1623    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1624    * minting.
1625    *
1626    * startTokenId - the first token id to be transferred
1627    * quantity - the amount to be transferred
1628    *
1629    * Calling conditions:
1630    *
1631    * - when `from` and `to` are both non-zero.
1632    * - `from` and `to` are never both zero.
1633    */
1634   function _afterTokenTransfers(
1635     address from,
1636     address to,
1637     uint256 startTokenId,
1638     uint256 quantity
1639   ) internal virtual {}
1640 }
1641 
1642 
1643 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.3
1644 
1645 
1646 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1647 
1648 pragma solidity ^0.8.0;
1649 
1650 /**
1651  * @dev Contract module that helps prevent reentrant calls to a function.
1652  *
1653  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1654  * available, which can be applied to functions to make sure there are no nested
1655  * (reentrant) calls to them.
1656  *
1657  * Note that because there is a single `nonReentrant` guard, functions marked as
1658  * `nonReentrant` may not call one another. This can be worked around by making
1659  * those functions `private`, and then adding `external` `nonReentrant` entry
1660  * points to them.
1661  *
1662  * TIP: If you would like to learn more about reentrancy and alternative ways
1663  * to protect against it, check out our blog post
1664  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1665  */
1666 abstract contract ReentrancyGuard {
1667     // Booleans are more expensive than uint256 or any type that takes up a full
1668     // word because each write operation emits an extra SLOAD to first read the
1669     // slot's contents, replace the bits taken up by the boolean, and then write
1670     // back. This is the compiler's defense against contract upgrades and
1671     // pointer aliasing, and it cannot be disabled.
1672 
1673     // The values being non-zero value makes deployment a bit more expensive,
1674     // but in exchange the refund on every call to nonReentrant will be lower in
1675     // amount. Since refunds are capped to a percentage of the total
1676     // transaction's gas, it is best to keep them low in cases like this one, to
1677     // increase the likelihood of the full refund coming into effect.
1678     uint256 private constant _NOT_ENTERED = 1;
1679     uint256 private constant _ENTERED = 2;
1680 
1681     uint256 private _status;
1682 
1683     constructor() {
1684         _status = _NOT_ENTERED;
1685     }
1686 
1687     /**
1688      * @dev Prevents a contract from calling itself, directly or indirectly.
1689      * Calling a `nonReentrant` function from another `nonReentrant`
1690      * function is not supported. It is possible to prevent this from happening
1691      * by making the `nonReentrant` function external, and making it call a
1692      * `private` function that does the actual work.
1693      */
1694     modifier nonReentrant() {
1695         _nonReentrantBefore();
1696         _;
1697         _nonReentrantAfter();
1698     }
1699 
1700     function _nonReentrantBefore() private {
1701         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1702         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1703 
1704         // Any calls to nonReentrant after this point will fail
1705         _status = _ENTERED;
1706     }
1707 
1708     function _nonReentrantAfter() private {
1709         // By storing the original value once again, a refund is triggered (see
1710         // https://eips.ethereum.org/EIPS/eip-2200)
1711         _status = _NOT_ENTERED;
1712     }
1713 }
1714 
1715 
1716 // File contracts/FancyNouns.sol
1717 
1718 
1719 
1720 pragma solidity ^0.8.9;
1721 
1722 
1723 
1724 
1725 contract FancyNouns is Ownable, ERC721A, ReentrancyGuard {
1726   uint256 public immutable maxPerAddressDuringMint;
1727   string private _baseTokenURI;
1728 
1729   constructor(
1730     uint256 maxBatchSize_,
1731     uint256 collectionSize_
1732   ) ERC721A("Fancy-Nouns", "FANCY-NOUNS", maxBatchSize_, collectionSize_) {
1733     maxPerAddressDuringMint = maxBatchSize_;
1734   }
1735 
1736   mapping(address => uint256) public allowlist;
1737 
1738   function uploadAllowlist(address[] memory addresses)
1739     external
1740     onlyOwner
1741   {
1742     for (uint256 i = 0; i < addresses.length; i++) {
1743       allowlist[addresses[i]] = 1;
1744     }
1745   }
1746 
1747   function FancyMintNouns(uint256 quantity) external {
1748     require(
1749       totalSupply() + quantity <= collectionSize,
1750       "too many already minted"
1751     );
1752     require(allowlist[msg.sender] == 1, "not in whitelist");
1753     require(
1754       balanceOf(msg.sender) + quantity <= maxBatchSize, "can only have nfts less than maxBatchSize"
1755     );
1756     _safeMint(msg.sender, quantity);
1757   }
1758 
1759   function _baseURI() internal view virtual override returns (string memory) {
1760     return _baseTokenURI;
1761   }
1762 
1763   function setBaseURI(string calldata baseURI) external onlyOwner {
1764     _baseTokenURI = baseURI;
1765   }
1766 
1767   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1768     _setOwnersExplicit(quantity);
1769   }
1770 
1771   function numberMinted(address owner) public view returns (uint256) {
1772     return _numberMinted(owner);
1773   }
1774 
1775   function getOwnershipData(uint256 tokenId)
1776     external
1777     view
1778     returns (TokenOwnership memory)
1779   {
1780     return ownershipOf(tokenId);
1781   }
1782 }