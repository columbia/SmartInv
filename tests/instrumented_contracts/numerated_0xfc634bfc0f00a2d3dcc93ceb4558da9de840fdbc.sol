1 // File: @openzeppelin/contracts/utils/math/Math.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     enum Rounding {
13         Down, // Toward negative infinity
14         Up, // Toward infinity
15         Zero // Toward zero
16     }
17 
18     /**
19      * @dev Returns the largest of two numbers.
20      */
21     function max(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a > b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the smallest of two numbers.
27      */
28     function min(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a < b ? a : b;
30     }
31 
32     /**
33      * @dev Returns the average of two numbers. The result is rounded towards
34      * zero.
35      */
36     function average(uint256 a, uint256 b) internal pure returns (uint256) {
37         // (a + b) / 2 can overflow.
38         return (a & b) + (a ^ b) / 2;
39     }
40 
41     /**
42      * @dev Returns the ceiling of the division of two numbers.
43      *
44      * This differs from standard division with `/` in that it rounds up instead
45      * of rounding down.
46      */
47     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
48         // (a + b - 1) / b can overflow on addition, so we distribute.
49         return a == 0 ? 0 : (a - 1) / b + 1;
50     }
51 
52     /**
53      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
54      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
55      * with further edits by Uniswap Labs also under MIT license.
56      */
57     function mulDiv(
58         uint256 x,
59         uint256 y,
60         uint256 denominator
61     ) internal pure returns (uint256 result) {
62         unchecked {
63             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
64             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
65             // variables such that product = prod1 * 2^256 + prod0.
66             uint256 prod0; // Least significant 256 bits of the product
67             uint256 prod1; // Most significant 256 bits of the product
68             assembly {
69                 let mm := mulmod(x, y, not(0))
70                 prod0 := mul(x, y)
71                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
72             }
73 
74             // Handle non-overflow cases, 256 by 256 division.
75             if (prod1 == 0) {
76                 return prod0 / denominator;
77             }
78 
79             // Make sure the result is less than 2^256. Also prevents denominator == 0.
80             require(denominator > prod1);
81 
82             ///////////////////////////////////////////////
83             // 512 by 256 division.
84             ///////////////////////////////////////////////
85 
86             // Make division exact by subtracting the remainder from [prod1 prod0].
87             uint256 remainder;
88             assembly {
89                 // Compute remainder using mulmod.
90                 remainder := mulmod(x, y, denominator)
91 
92                 // Subtract 256 bit number from 512 bit number.
93                 prod1 := sub(prod1, gt(remainder, prod0))
94                 prod0 := sub(prod0, remainder)
95             }
96 
97             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
98             // See https://cs.stackexchange.com/q/138556/92363.
99 
100             // Does not overflow because the denominator cannot be zero at this stage in the function.
101             uint256 twos = denominator & (~denominator + 1);
102             assembly {
103                 // Divide denominator by twos.
104                 denominator := div(denominator, twos)
105 
106                 // Divide [prod1 prod0] by twos.
107                 prod0 := div(prod0, twos)
108 
109                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
110                 twos := add(div(sub(0, twos), twos), 1)
111             }
112 
113             // Shift in bits from prod1 into prod0.
114             prod0 |= prod1 * twos;
115 
116             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
117             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
118             // four bits. That is, denominator * inv = 1 mod 2^4.
119             uint256 inverse = (3 * denominator) ^ 2;
120 
121             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
122             // in modular arithmetic, doubling the correct bits in each step.
123             inverse *= 2 - denominator * inverse; // inverse mod 2^8
124             inverse *= 2 - denominator * inverse; // inverse mod 2^16
125             inverse *= 2 - denominator * inverse; // inverse mod 2^32
126             inverse *= 2 - denominator * inverse; // inverse mod 2^64
127             inverse *= 2 - denominator * inverse; // inverse mod 2^128
128             inverse *= 2 - denominator * inverse; // inverse mod 2^256
129 
130             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
131             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
132             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
133             // is no longer required.
134             result = prod0 * inverse;
135             return result;
136         }
137     }
138 
139     /**
140      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
141      */
142     function mulDiv(
143         uint256 x,
144         uint256 y,
145         uint256 denominator,
146         Rounding rounding
147     ) internal pure returns (uint256) {
148         uint256 result = mulDiv(x, y, denominator);
149         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
150             result += 1;
151         }
152         return result;
153     }
154 
155     /**
156      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
157      *
158      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
159      */
160     function sqrt(uint256 a) internal pure returns (uint256) {
161         if (a == 0) {
162             return 0;
163         }
164 
165         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
166         //
167         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
168         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
169         //
170         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
171         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
172         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
173         //
174         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
175         uint256 result = 1 << (log2(a) >> 1);
176 
177         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
178         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
179         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
180         // into the expected uint128 result.
181         unchecked {
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             return min(result, a / result);
190         }
191     }
192 
193     /**
194      * @notice Calculates sqrt(a), following the selected rounding direction.
195      */
196     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
197         unchecked {
198             uint256 result = sqrt(a);
199             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
200         }
201     }
202 
203     /**
204      * @dev Return the log in base 2, rounded down, of a positive value.
205      * Returns 0 if given 0.
206      */
207     function log2(uint256 value) internal pure returns (uint256) {
208         uint256 result = 0;
209         unchecked {
210             if (value >> 128 > 0) {
211                 value >>= 128;
212                 result += 128;
213             }
214             if (value >> 64 > 0) {
215                 value >>= 64;
216                 result += 64;
217             }
218             if (value >> 32 > 0) {
219                 value >>= 32;
220                 result += 32;
221             }
222             if (value >> 16 > 0) {
223                 value >>= 16;
224                 result += 16;
225             }
226             if (value >> 8 > 0) {
227                 value >>= 8;
228                 result += 8;
229             }
230             if (value >> 4 > 0) {
231                 value >>= 4;
232                 result += 4;
233             }
234             if (value >> 2 > 0) {
235                 value >>= 2;
236                 result += 2;
237             }
238             if (value >> 1 > 0) {
239                 result += 1;
240             }
241         }
242         return result;
243     }
244 
245     /**
246      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
247      * Returns 0 if given 0.
248      */
249     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
250         unchecked {
251             uint256 result = log2(value);
252             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
253         }
254     }
255 
256     /**
257      * @dev Return the log in base 10, rounded down, of a positive value.
258      * Returns 0 if given 0.
259      */
260     function log10(uint256 value) internal pure returns (uint256) {
261         uint256 result = 0;
262         unchecked {
263             if (value >= 10**64) {
264                 value /= 10**64;
265                 result += 64;
266             }
267             if (value >= 10**32) {
268                 value /= 10**32;
269                 result += 32;
270             }
271             if (value >= 10**16) {
272                 value /= 10**16;
273                 result += 16;
274             }
275             if (value >= 10**8) {
276                 value /= 10**8;
277                 result += 8;
278             }
279             if (value >= 10**4) {
280                 value /= 10**4;
281                 result += 4;
282             }
283             if (value >= 10**2) {
284                 value /= 10**2;
285                 result += 2;
286             }
287             if (value >= 10**1) {
288                 result += 1;
289             }
290         }
291         return result;
292     }
293 
294     /**
295      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
296      * Returns 0 if given 0.
297      */
298     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
299         unchecked {
300             uint256 result = log10(value);
301             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
302         }
303     }
304 
305     /**
306      * @dev Return the log in base 256, rounded down, of a positive value.
307      * Returns 0 if given 0.
308      *
309      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
310      */
311     function log256(uint256 value) internal pure returns (uint256) {
312         uint256 result = 0;
313         unchecked {
314             if (value >> 128 > 0) {
315                 value >>= 128;
316                 result += 16;
317             }
318             if (value >> 64 > 0) {
319                 value >>= 64;
320                 result += 8;
321             }
322             if (value >> 32 > 0) {
323                 value >>= 32;
324                 result += 4;
325             }
326             if (value >> 16 > 0) {
327                 value >>= 16;
328                 result += 2;
329             }
330             if (value >> 8 > 0) {
331                 result += 1;
332             }
333         }
334         return result;
335     }
336 
337     /**
338      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
339      * Returns 0 if given 0.
340      */
341     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
342         unchecked {
343             uint256 result = log256(value);
344             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
345         }
346     }
347 }
348 
349 // File: @openzeppelin/contracts/utils/Strings.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev String operations.
358  */
359 library Strings {
360     bytes16 private constant _SYMBOLS = "0123456789abcdef";
361     uint8 private constant _ADDRESS_LENGTH = 20;
362 
363     /**
364      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
365      */
366     function toString(uint256 value) internal pure returns (string memory) {
367         unchecked {
368             uint256 length = Math.log10(value) + 1;
369             string memory buffer = new string(length);
370             uint256 ptr;
371             /// @solidity memory-safe-assembly
372             assembly {
373                 ptr := add(buffer, add(32, length))
374             }
375             while (true) {
376                 ptr--;
377                 /// @solidity memory-safe-assembly
378                 assembly {
379                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
380                 }
381                 value /= 10;
382                 if (value == 0) break;
383             }
384             return buffer;
385         }
386     }
387 
388     /**
389      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
390      */
391     function toHexString(uint256 value) internal pure returns (string memory) {
392         unchecked {
393             return toHexString(value, Math.log256(value) + 1);
394         }
395     }
396 
397     /**
398      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
399      */
400     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
401         bytes memory buffer = new bytes(2 * length + 2);
402         buffer[0] = "0";
403         buffer[1] = "x";
404         for (uint256 i = 2 * length + 1; i > 1; --i) {
405             buffer[i] = _SYMBOLS[value & 0xf];
406             value >>= 4;
407         }
408         require(value == 0, "Strings: hex length insufficient");
409         return string(buffer);
410     }
411 
412     /**
413      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
414      */
415     function toHexString(address addr) internal pure returns (string memory) {
416         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
417     }
418 }
419 
420 // File: @openzeppelin/contracts/utils/Context.sol
421 
422 
423 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 /**
428  * @dev Provides information about the current execution context, including the
429  * sender of the transaction and its data. While these are generally available
430  * via msg.sender and msg.data, they should not be accessed in such a direct
431  * manner, since when dealing with meta-transactions the account sending and
432  * paying for execution may not be the actual sender (as far as an application
433  * is concerned).
434  *
435  * This contract is only required for intermediate, library-like contracts.
436  */
437 abstract contract Context {
438     function _msgSender() internal view virtual returns (address) {
439         return msg.sender;
440     }
441 
442     function _msgData() internal view virtual returns (bytes calldata) {
443         return msg.data;
444     }
445 }
446 
447 // File: @openzeppelin/contracts/access/Ownable.sol
448 
449 
450 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @dev Contract module which provides a basic access control mechanism, where
456  * there is an account (an owner) that can be granted exclusive access to
457  * specific functions.
458  *
459  * By default, the owner account will be the one that deploys the contract. This
460  * can later be changed with {transferOwnership}.
461  *
462  * This module is used through inheritance. It will make available the modifier
463  * `onlyOwner`, which can be applied to your functions to restrict their use to
464  * the owner.
465  */
466 abstract contract Ownable is Context {
467     address private _owner;
468 
469     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
470 
471     /**
472      * @dev Initializes the contract setting the deployer as the initial owner.
473      */
474     constructor() {
475         _transferOwnership(_msgSender());
476     }
477 
478     /**
479      * @dev Throws if called by any account other than the owner.
480      */
481     modifier onlyOwner() {
482         _checkOwner();
483         _;
484     }
485 
486     /**
487      * @dev Returns the address of the current owner.
488      */
489     function owner() public view virtual returns (address) {
490         return _owner;
491     }
492 
493     /**
494      * @dev Throws if the sender is not the owner.
495      */
496     function _checkOwner() internal view virtual {
497         require(owner() == _msgSender(), "Ownable: caller is not the owner");
498     }
499 
500     /**
501      * @dev Leaves the contract without owner. It will not be possible to call
502      * `onlyOwner` functions anymore. Can only be called by the current owner.
503      *
504      * NOTE: Renouncing ownership will leave the contract without an owner,
505      * thereby removing any functionality that is only available to the owner.
506      */
507     function renounceOwnership() public virtual onlyOwner {
508         _transferOwnership(address(0));
509     }
510 
511     /**
512      * @dev Transfers ownership of the contract to a new account (`newOwner`).
513      * Can only be called by the current owner.
514      */
515     function transferOwnership(address newOwner) public virtual onlyOwner {
516         require(newOwner != address(0), "Ownable: new owner is the zero address");
517         _transferOwnership(newOwner);
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Internal function without access restriction.
523      */
524     function _transferOwnership(address newOwner) internal virtual {
525         address oldOwner = _owner;
526         _owner = newOwner;
527         emit OwnershipTransferred(oldOwner, newOwner);
528     }
529 }
530 
531 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
532 
533 
534 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @dev Contract module that helps prevent reentrant calls to a function.
540  *
541  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
542  * available, which can be applied to functions to make sure there are no nested
543  * (reentrant) calls to them.
544  *
545  * Note that because there is a single `nonReentrant` guard, functions marked as
546  * `nonReentrant` may not call one another. This can be worked around by making
547  * those functions `private`, and then adding `external` `nonReentrant` entry
548  * points to them.
549  *
550  * TIP: If you would like to learn more about reentrancy and alternative ways
551  * to protect against it, check out our blog post
552  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
553  */
554 abstract contract ReentrancyGuard {
555     // Booleans are more expensive than uint256 or any type that takes up a full
556     // word because each write operation emits an extra SLOAD to first read the
557     // slot's contents, replace the bits taken up by the boolean, and then write
558     // back. This is the compiler's defense against contract upgrades and
559     // pointer aliasing, and it cannot be disabled.
560 
561     // The values being non-zero value makes deployment a bit more expensive,
562     // but in exchange the refund on every call to nonReentrant will be lower in
563     // amount. Since refunds are capped to a percentage of the total
564     // transaction's gas, it is best to keep them low in cases like this one, to
565     // increase the likelihood of the full refund coming into effect.
566     uint256 private constant _NOT_ENTERED = 1;
567     uint256 private constant _ENTERED = 2;
568 
569     uint256 private _status;
570 
571     constructor() {
572         _status = _NOT_ENTERED;
573     }
574 
575     /**
576      * @dev Prevents a contract from calling itself, directly or indirectly.
577      * Calling a `nonReentrant` function from another `nonReentrant`
578      * function is not supported. It is possible to prevent this from happening
579      * by making the `nonReentrant` function external, and making it call a
580      * `private` function that does the actual work.
581      */
582     modifier nonReentrant() {
583         _nonReentrantBefore();
584         _;
585         _nonReentrantAfter();
586     }
587 
588     function _nonReentrantBefore() private {
589         // On the first call to nonReentrant, _status will be _NOT_ENTERED
590         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
591 
592         // Any calls to nonReentrant after this point will fail
593         _status = _ENTERED;
594     }
595 
596     function _nonReentrantAfter() private {
597         // By storing the original value once again, a refund is triggered (see
598         // https://eips.ethereum.org/EIPS/eip-2200)
599         _status = _NOT_ENTERED;
600     }
601 }
602 
603 // File: contracts/ERC721.sol
604 
605 
606 pragma solidity ^0.8.4;
607 
608 /// @notice Simple ERC721 implementation with storage hitchhiking.
609 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/tokens/ERC721.sol)
610 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
611 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token/ERC721/ERC721.sol)
612 ///
613 /// @dev Note:
614 /// The ERC721 standard allows for self-approvals.
615 /// For performance, this implementation WILL NOT revert for such actions.
616 /// Please add any checks with overrides if desired.
617 abstract contract ERC721 {
618     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
619     /*                         CONSTANTS                          */
620     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
621 
622     /// @dev An account can hold up to 4294967295 tokens.
623     uint256 internal constant _MAX_ACCOUNT_BALANCE = 0xffffffff;
624 
625     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
626     /*                       CUSTOM ERRORS                        */
627     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
628 
629     /// @dev Only the token owner or an approved account can manage the token.
630     error NotOwnerNorApproved();
631 
632     /// @dev The token does not exist.
633     error TokenDoesNotExist();
634 
635     /// @dev The token already exists.
636     error TokenAlreadyExists();
637 
638     /// @dev Cannot query the balance for the zero address.
639     error BalanceQueryForZeroAddress();
640 
641     /// @dev Cannot mint or transfer to the zero address.
642     error TransferToZeroAddress();
643 
644     /// @dev The token must be owned by `from`.
645     error TransferFromIncorrectOwner();
646 
647     /// @dev The recipient's balance has overflowed.
648     error AccountBalanceOverflow();
649 
650     /// @dev Cannot safely transfer to a contract that does not implement
651     /// the ERC721Receiver interface.
652     error TransferToNonERC721ReceiverImplementer();
653 
654     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
655     /*                           EVENTS                           */
656     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
657 
658     /// @dev Emitted when token `id` is transferred from `from` to `to`.
659     event Transfer(address indexed from, address indexed to, uint256 indexed id);
660 
661     /// @dev Emitted when `owner` enables `account` to manage the `id` token.
662     event Approval(address indexed owner, address indexed account, uint256 indexed id);
663 
664     /// @dev Emitted when `owner` enables or disables `operator` to manage all of their tokens.
665     event ApprovalForAll(address indexed owner, address indexed operator, bool isApproved);
666 
667     /// @dev `keccak256(bytes("Transfer(address,address,uint256)"))`.
668     uint256 private constant _TRANSFER_EVENT_SIGNATURE =
669     0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
670 
671     /// @dev `keccak256(bytes("Approval(address,address,uint256)"))`.
672     uint256 private constant _APPROVAL_EVENT_SIGNATURE =
673     0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;
674 
675     /// @dev `keccak256(bytes("ApprovalForAll(address,address,bool)"))`.
676     uint256 private constant _APPROVAL_FOR_ALL_EVENT_SIGNATURE =
677     0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31;
678 
679     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
680     /*                          STORAGE                           */
681     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
682 
683     /// @dev The ownership data slot of `id` is given by:
684     /// ```
685     ///     mstore(0x00, id)
686     ///     mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
687     ///     let ownershipSlot := add(id, add(id, keccak256(0x00, 0x20)))
688     /// ```
689     /// Bits Layout:
690     // - [0..159]   `addr`
691     // - [160..223] `extraData`
692     ///
693     /// The approved address slot is given by: `add(1, ownershipSlot)`.
694     ///
695     /// See: https://notes.ethereum.org/%40vbuterin/verkle_tree_eip
696     ///
697     /// The balance slot of `owner` is given by:
698     /// ```
699     ///     mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
700     ///     mstore(0x00, owner)
701     ///     let balanceSlot := keccak256(0x0c, 0x1c)
702     /// ```
703     /// Bits Layout:
704     /// - [0..31]   `balance`
705     /// - [32..225] `aux`
706     ///
707     /// The `operator` approval slot of `owner` is given by:
708     /// ```
709     ///     mstore(0x1c, or(_ERC721_MASTER_SLOT_SEED, operator))
710     ///     mstore(0x00, owner)
711     ///     let operatorApprovalSlot := keccak256(0x0c, 0x30)
712     /// ```
713     uint256 private constant _ERC721_MASTER_SLOT_SEED = 0x7d8825530a5a2e7a << 192;
714 
715     /// @dev Pre-shifted and pre-masked constant.
716     uint256 private constant _ERC721_MASTER_SLOT_SEED_MASKED = 0x0a5a2e7a00000000;
717 
718     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
719     /*                      ERC721 METADATA                       */
720     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
721 
722     /// @dev Returns the token collection name.
723     function name() public view virtual returns (string memory);
724 
725     /// @dev Returns the token collection symbol.
726     function symbol() public view virtual returns (string memory);
727 
728     /// @dev Returns the Uniform Resource Identifier (URI) for token `id`.
729     function tokenURI(uint256 id) public view virtual returns (string memory);
730 
731     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
732     /*                           ERC721                           */
733     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
734 
735     /// @dev Returns the owner of token `id`.
736     ///
737     /// Requirements:
738     /// - Token `id` must exist.
739     function ownerOf(uint256 id) public view virtual returns (address result) {
740         result = _ownerOf(id);
741         /// @solidity memory-safe-assembly
742         assembly {
743             if iszero(result) {
744                 mstore(0x00, 0xceea21b6) // `TokenDoesNotExist()`.
745                 revert(0x1c, 0x04)
746             }
747         }
748     }
749 
750     /// @dev Returns the number of tokens owned by `owner`.
751     ///
752     /// Requirements:
753     /// - `owner` must not be the zero address.
754     function balanceOf(address owner) public view virtual returns (uint256 result) {
755         /// @solidity memory-safe-assembly
756         assembly {
757         // Revert if the `owner` is the zero address.
758             if iszero(owner) {
759                 mstore(0x00, 0x8f4eb604) // `BalanceQueryForZeroAddress()`.
760                 revert(0x1c, 0x04)
761             }
762             mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
763             mstore(0x00, owner)
764             result := and(sload(keccak256(0x0c, 0x1c)), _MAX_ACCOUNT_BALANCE)
765         }
766     }
767 
768     /// @dev Returns the account approved to managed token `id`.
769     ///
770     /// Requirements:
771     /// - Token `id` must exist.
772     function getApproved(uint256 id) public view virtual returns (address result) {
773         /// @solidity memory-safe-assembly
774         assembly {
775             mstore(0x00, id)
776             mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
777             let ownershipSlot := add(id, add(id, keccak256(0x00, 0x20)))
778             if iszero(shr(96, shl(96, sload(ownershipSlot)))) {
779                 mstore(0x00, 0xceea21b6) // `TokenDoesNotExist()`.
780                 revert(0x1c, 0x04)
781             }
782             result := sload(add(1, ownershipSlot))
783         }
784     }
785 
786     /// @dev Sets `account` as the approved account to manage token `id`.
787     ///
788     /// Requirements:
789     /// - Token `id` must exist.
790     /// - The caller must be the owner of the token,
791     ///   or an approved operator for the token owner.
792     ///
793     /// Emits a {Approval} event.
794     function approve(address account, uint256 id) public payable virtual {
795         _approve(msg.sender, account, id);
796     }
797 
798     /// @dev Returns whether `operator` is approved to manage the tokens of `owner`.
799     function isApprovedForAll(address owner, address operator)
800     public
801     view
802     virtual
803     returns (bool result)
804     {
805         /// @solidity memory-safe-assembly
806         assembly {
807             mstore(0x1c, operator)
808             mstore(0x08, _ERC721_MASTER_SLOT_SEED_MASKED)
809             mstore(0x00, owner)
810             result := sload(keccak256(0x0c, 0x30))
811         }
812     }
813 
814     /// @dev Sets whether `operator` is approved to manage the tokens of the caller.
815     ///
816     /// Emits a {ApprovalForAll} event.
817     function setApprovalForAll(address operator, bool isApproved) public virtual {
818         /// @solidity memory-safe-assembly
819         assembly {
820         // Convert to 0 or 1.
821             isApproved := iszero(iszero(isApproved))
822         // Update the `isApproved` for (`msg.sender`, `operator`).
823             mstore(0x1c, operator)
824             mstore(0x08, _ERC721_MASTER_SLOT_SEED_MASKED)
825             mstore(0x00, caller())
826             sstore(keccak256(0x0c, 0x30), isApproved)
827         // Emit the {ApprovalForAll} event.
828             mstore(0x00, isApproved)
829             log3(
830             0x00, 0x20, _APPROVAL_FOR_ALL_EVENT_SIGNATURE, caller(), shr(96, shl(96, operator))
831             )
832         }
833     }
834 
835     /// @dev Transfers token `id` from `from` to `to`.
836     ///
837     /// Requirements:
838     ///
839     /// - Token `id` must exist.
840     /// - `from` must be the owner of the token.
841     /// - `to` cannot be the zero address.
842     /// - The caller must be the owner of the token, or be approved to manage the token.
843     ///
844     /// Emits a {Transfer} event.
845     function transferFrom(address from, address to, uint256 id) public payable virtual {
846         _beforeTokenTransfer(from, to, id);
847         /// @solidity memory-safe-assembly
848         assembly {
849         // Clear the upper 96 bits.
850             let bitmaskAddress := shr(96, not(0))
851             from := and(bitmaskAddress, from)
852             to := and(bitmaskAddress, to)
853         // Load the ownership data.
854             mstore(0x00, id)
855             mstore(0x1c, or(_ERC721_MASTER_SLOT_SEED, caller()))
856             let ownershipSlot := add(id, add(id, keccak256(0x00, 0x20)))
857             let ownershipPacked := sload(ownershipSlot)
858             let owner := and(bitmaskAddress, ownershipPacked)
859         // Revert if `from` is not the owner, or does not exist.
860             if iszero(mul(owner, eq(owner, from))) {
861                 if iszero(owner) {
862                     mstore(0x00, 0xceea21b6) // `TokenDoesNotExist()`.
863                     revert(0x1c, 0x04)
864                 }
865                 mstore(0x00, 0xa1148100) // `TransferFromIncorrectOwner()`.
866                 revert(0x1c, 0x04)
867             }
868         // Revert if `to` is the zero address.
869             if iszero(to) {
870                 mstore(0x00, 0xea553b34) // `TransferToZeroAddress()`.
871                 revert(0x1c, 0x04)
872             }
873         // Load, check, and update the token approval.
874             {
875                 mstore(0x00, from)
876                 let approvedAddress := sload(add(1, ownershipSlot))
877             // Revert if the caller is not the owner, nor approved.
878                 if iszero(or(eq(caller(), from), eq(caller(), approvedAddress))) {
879                     if iszero(sload(keccak256(0x0c, 0x30))) {
880                         mstore(0x00, 0x4b6e7f18) // `NotOwnerNorApproved()`.
881                         revert(0x1c, 0x04)
882                     }
883                 }
884             // Delete the approved address if any.
885                 if approvedAddress { sstore(add(1, ownershipSlot), 0) }
886             }
887         // Update with the new owner.
888             sstore(ownershipSlot, xor(ownershipPacked, xor(from, to)))
889         // Decrement the balance of `from`.
890             {
891                 let fromBalanceSlot := keccak256(0x0c, 0x1c)
892                 sstore(fromBalanceSlot, sub(sload(fromBalanceSlot), 1))
893             }
894         // Increment the balance of `to`.
895             {
896                 mstore(0x00, to)
897                 let toBalanceSlot := keccak256(0x0c, 0x1c)
898                 let toBalanceSlotPacked := add(sload(toBalanceSlot), 1)
899                 if iszero(and(toBalanceSlotPacked, _MAX_ACCOUNT_BALANCE)) {
900                     mstore(0x00, 0x01336cea) // `AccountBalanceOverflow()`.
901                     revert(0x1c, 0x04)
902                 }
903                 sstore(toBalanceSlot, toBalanceSlotPacked)
904             }
905         // Emit the {Transfer} event.
906             log4(0x00, 0x00, _TRANSFER_EVENT_SIGNATURE, from, to, id)
907         }
908         _afterTokenTransfer(from, to, id);
909     }
910 
911     /// @dev Equivalent to `safeTransferFrom(from, to, id, "")`.
912     function safeTransferFrom(address from, address to, uint256 id) public payable virtual {
913         transferFrom(from, to, id);
914         if (_hasCode(to)) _checkOnERC721Received(from, to, id, "");
915     }
916 
917     /// @dev Transfers token `id` from `from` to `to`.
918     ///
919     /// Requirements:
920     ///
921     /// - Token `id` must exist.
922     /// - `from` must be the owner of the token.
923     /// - `to` cannot be the zero address.
924     /// - The caller must be the owner of the token, or be approved to manage the token.
925     /// - If `to` refers to a smart contract, it must implement
926     ///   {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
927     ///
928     /// Emits a {Transfer} event.
929     function safeTransferFrom(address from, address to, uint256 id, bytes calldata data)
930     public
931     payable
932     virtual
933     {
934         transferFrom(from, to, id);
935         if (_hasCode(to)) _checkOnERC721Received(from, to, id, data);
936     }
937 
938     /// @dev Returns true if this contract implements the interface defined by `interfaceId`.
939     /// See: https://eips.ethereum.org/EIPS/eip-165
940     /// This function call must use less than 30000 gas.
941     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool result) {
942         /// @solidity memory-safe-assembly
943         assembly {
944             let s := shr(224, interfaceId)
945         // ERC165: 0x01ffc9a7, ERC721: 0x80ac58cd, ERC721Metadata: 0x5b5e139f.
946             result := or(or(eq(s, 0x01ffc9a7), eq(s, 0x80ac58cd)), eq(s, 0x5b5e139f))
947         }
948     }
949 
950     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
951     /*                  INTERNAL QUERY FUNCTIONS                  */
952     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
953 
954     /// @dev Returns if token `id` exists.
955     function _exists(uint256 id) internal view virtual returns (bool result) {
956         /// @solidity memory-safe-assembly
957         assembly {
958             mstore(0x00, id)
959             mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
960             result := shl(96, sload(add(id, add(id, keccak256(0x00, 0x20)))))
961         }
962     }
963 
964     /// @dev Returns the owner of token `id`.
965     /// Returns the zero address instead of reverting if the token does not exist.
966     function _ownerOf(uint256 id) internal view virtual returns (address result) {
967         /// @solidity memory-safe-assembly
968         assembly {
969             mstore(0x00, id)
970             mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
971             result := shr(96, shl(96, sload(add(id, add(id, keccak256(0x00, 0x20))))))
972         }
973     }
974 
975     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
976     /*            INTERNAL DATA HITCHHIKING FUNCTIONS             */
977     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
978 
979     /// @dev Returns the auxiliary data for `owner`.
980     /// Minting, transferring, burning the tokens of `owner` will not change the auxiliary data.
981     /// Auxiliary data can be set for any address, even if it does not have any tokens.
982     function _getAux(address owner) internal view virtual returns (uint224 result) {
983         /// @solidity memory-safe-assembly
984         assembly {
985             mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
986             mstore(0x00, owner)
987             result := shr(32, sload(keccak256(0x0c, 0x1c)))
988         }
989     }
990 
991     /// @dev Set the auxiliary data for `owner` to `value`.
992     /// Minting, transferring, burning the tokens of `owner` will not change the auxiliary data.
993     /// Auxiliary data can be set for any address, even if it does not have any tokens.
994     function _setAux(address owner, uint224 value) internal virtual {
995         /// @solidity memory-safe-assembly
996         assembly {
997             mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
998             mstore(0x00, owner)
999             let balanceSlot := keccak256(0x0c, 0x1c)
1000             let packed := sload(balanceSlot)
1001             sstore(balanceSlot, xor(packed, shl(32, xor(value, shr(32, packed)))))
1002         }
1003     }
1004 
1005     /// @dev Returns the extra data for token `id`.
1006     /// Minting, transferring, burning a token will not change the extra data.
1007     /// The extra data can be set on a non-existent token.
1008     function _getExtraData(uint256 id) internal view virtual returns (uint96 result) {
1009         /// @solidity memory-safe-assembly
1010         assembly {
1011             mstore(0x00, id)
1012             mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
1013             result := shr(160, sload(add(id, add(id, keccak256(0x00, 0x20)))))
1014         }
1015     }
1016 
1017     /// @dev Sets the extra data for token `id` to `value`.
1018     /// Minting, transferring, burning a token will not change the extra data.
1019     /// The extra data can be set on a non-existent token.
1020     function _setExtraData(uint256 id, uint96 value) internal virtual {
1021         /// @solidity memory-safe-assembly
1022         assembly {
1023             mstore(0x00, id)
1024             mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
1025             let ownershipSlot := add(id, add(id, keccak256(0x00, 0x20)))
1026             let packed := sload(ownershipSlot)
1027             sstore(ownershipSlot, xor(packed, shl(160, xor(value, shr(160, packed)))))
1028         }
1029     }
1030 
1031     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1032     /*                  INTERNAL MINT FUNCTIONS                   */
1033     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1034 
1035     /// @dev Mints token `id` to `to`.
1036     ///
1037     /// Requirements:
1038     ///
1039     /// - Token `id` must not exist.
1040     /// - `to` cannot be the zero address.
1041     ///
1042     /// Emits a {Transfer} event.
1043     function _mint(address to, uint256 id) internal virtual {
1044         _beforeTokenTransfer(address(0), to, id);
1045         /// @solidity memory-safe-assembly
1046         assembly {
1047         // Clear the upper 96 bits.
1048             to := shr(96, shl(96, to))
1049         // Revert if `to` is the zero address.
1050             if iszero(to) {
1051                 mstore(0x00, 0xea553b34) // `TransferToZeroAddress()`.
1052                 revert(0x1c, 0x04)
1053             }
1054         // Load the ownership data.
1055             mstore(0x00, id)
1056             mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
1057             let ownershipSlot := add(id, add(id, keccak256(0x00, 0x20)))
1058             let ownershipPacked := sload(ownershipSlot)
1059         // Revert if the token already exists.
1060             if shl(96, ownershipPacked) {
1061                 mstore(0x00, 0xc991cbb1) // `TokenAlreadyExists()`.
1062                 revert(0x1c, 0x04)
1063             }
1064         // Update with the owner.
1065             sstore(ownershipSlot, or(ownershipPacked, to))
1066         // Increment the balance of the owner.
1067             {
1068                 mstore(0x00, to)
1069                 let balanceSlot := keccak256(0x0c, 0x1c)
1070                 let balanceSlotPacked := add(sload(balanceSlot), 1)
1071                 if iszero(and(balanceSlotPacked, _MAX_ACCOUNT_BALANCE)) {
1072                     mstore(0x00, 0x01336cea) // `AccountBalanceOverflow()`.
1073                     revert(0x1c, 0x04)
1074                 }
1075                 sstore(balanceSlot, balanceSlotPacked)
1076             }
1077         // Emit the {Transfer} event.
1078             log4(0x00, 0x00, _TRANSFER_EVENT_SIGNATURE, 0, to, id)
1079         }
1080         _afterTokenTransfer(address(0), to, id);
1081     }
1082 
1083     /// @dev Equivalent to `_safeMint(to, id, "")`.
1084     function _safeMint(address to, uint256 id) internal virtual {
1085         _safeMint(to, id, "");
1086     }
1087 
1088     /// @dev Mints token `id` to `to`.
1089     ///
1090     /// Requirements:
1091     ///
1092     /// - Token `id` must not exist.
1093     /// - `to` cannot be the zero address.
1094     /// - If `to` refers to a smart contract, it must implement
1095     ///   {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1096     ///
1097     /// Emits a {Transfer} event.
1098     function _safeMint(address to, uint256 id, bytes memory data) internal virtual {
1099         _mint(to, id);
1100         if (_hasCode(to)) _checkOnERC721Received(address(0), to, id, data);
1101     }
1102 
1103     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1104     /*                  INTERNAL BURN FUNCTIONS                   */
1105     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1106 
1107     /// @dev Equivalent to `_burn(address(0), id)`.
1108     function _burn(uint256 id) internal virtual {
1109         _burn(address(0), id);
1110     }
1111 
1112     /// @dev Destroys token `id`, using `by`.
1113     ///
1114     /// Requirements:
1115     ///
1116     /// - Token `id` must exist.
1117     /// - If `by` is not the zero address,
1118     ///   it must be the owner of the token, or be approved to manage the token.
1119     ///
1120     /// Emits a {Transfer} event.
1121     function _burn(address by, uint256 id) internal virtual {
1122         address owner = ownerOf(id);
1123         _beforeTokenTransfer(owner, address(0), id);
1124         /// @solidity memory-safe-assembly
1125         assembly {
1126         // Clear the upper 96 bits.
1127             by := shr(96, shl(96, by))
1128         // Load the ownership data.
1129             mstore(0x00, id)
1130             mstore(0x1c, or(_ERC721_MASTER_SLOT_SEED, by))
1131             let ownershipSlot := add(id, add(id, keccak256(0x00, 0x20)))
1132             let ownershipPacked := sload(ownershipSlot)
1133         // Reload the owner in case it is changed in `_beforeTokenTransfer`.
1134             owner := shr(96, shl(96, ownershipPacked))
1135         // Revert if the token does not exist.
1136             if iszero(owner) {
1137                 mstore(0x00, 0xceea21b6) // `TokenDoesNotExist()`.
1138                 revert(0x1c, 0x04)
1139             }
1140         // Load and check the token approval.
1141             {
1142                 mstore(0x00, owner)
1143                 let approvedAddress := sload(add(1, ownershipSlot))
1144             // If `by` is not the zero address, do the authorization check.
1145             // Revert if the `by` is not the owner, nor approved.
1146                 if iszero(or(iszero(by), or(eq(by, owner), eq(by, approvedAddress)))) {
1147                     if iszero(sload(keccak256(0x0c, 0x30))) {
1148                         mstore(0x00, 0x4b6e7f18) // `NotOwnerNorApproved()`.
1149                         revert(0x1c, 0x04)
1150                     }
1151                 }
1152             // Delete the approved address if any.
1153                 if approvedAddress { sstore(add(1, ownershipSlot), 0) }
1154             }
1155         // Clear the owner.
1156             sstore(ownershipSlot, xor(ownershipPacked, owner))
1157         // Decrement the balance of `owner`.
1158             {
1159                 let balanceSlot := keccak256(0x0c, 0x1c)
1160                 sstore(balanceSlot, sub(sload(balanceSlot), 1))
1161             }
1162         // Emit the {Transfer} event.
1163             log4(0x00, 0x00, _TRANSFER_EVENT_SIGNATURE, owner, 0, id)
1164         }
1165         _afterTokenTransfer(owner, address(0), id);
1166     }
1167 
1168     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1169     /*                INTERNAL APPROVAL FUNCTIONS                 */
1170     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1171 
1172     /// @dev Returns whether `account` is the owner of token `id`, or is approved to managed it.
1173     ///
1174     /// Requirements:
1175     /// - Token `id` must exist.
1176     function _isApprovedOrOwner(address account, uint256 id)
1177     internal
1178     view
1179     virtual
1180     returns (bool result)
1181     {
1182         /// @solidity memory-safe-assembly
1183         assembly {
1184             result := 1
1185         // Clear the upper 96 bits.
1186             account := shr(96, shl(96, account))
1187         // Load the ownership data.
1188             mstore(0x00, id)
1189             mstore(0x1c, or(_ERC721_MASTER_SLOT_SEED, account))
1190             let ownershipSlot := add(id, add(id, keccak256(0x00, 0x20)))
1191             let owner := shr(96, shl(96, sload(ownershipSlot)))
1192         // Revert if the token does not exist.
1193             if iszero(owner) {
1194                 mstore(0x00, 0xceea21b6) // `TokenDoesNotExist()`.
1195                 revert(0x1c, 0x04)
1196             }
1197         // Check if `account` is the `owner`.
1198             if iszero(eq(account, owner)) {
1199                 mstore(0x00, owner)
1200             // Check if `account` is approved to
1201                 if iszero(sload(keccak256(0x0c, 0x30))) {
1202                     result := eq(account, sload(add(1, ownershipSlot)))
1203                 }
1204             }
1205         }
1206     }
1207 
1208     /// @dev Returns the account approved to manage token `id`.
1209     /// Returns the zero address instead of reverting if the token does not exist.
1210     function _getApproved(uint256 id) internal view virtual returns (address result) {
1211         /// @solidity memory-safe-assembly
1212         assembly {
1213             mstore(0x00, id)
1214             mstore(0x1c, _ERC721_MASTER_SLOT_SEED)
1215             result := sload(add(1, add(id, add(id, keccak256(0x00, 0x20)))))
1216         }
1217     }
1218 
1219     /// @dev Equivalent to `_approve(address(0), account, id)`.
1220     function _approve(address account, uint256 id) internal virtual {
1221         _approve(address(0), account, id);
1222     }
1223 
1224     /// @dev Sets `account` as the approved account to manage token `id`, using `by`.
1225     ///
1226     /// Requirements:
1227     /// - Token `id` must exist.
1228     /// - If `by` is not the zero address, `by` must be the owner
1229     ///   or an approved operator for the token owner.
1230     ///
1231     /// Emits a {Transfer} event.
1232     function _approve(address by, address account, uint256 id) internal virtual {
1233         assembly {
1234         // Clear the upper 96 bits.
1235             let bitmaskAddress := shr(96, not(0))
1236             account := and(bitmaskAddress, account)
1237             by := and(bitmaskAddress, by)
1238         // Load the owner of the token.
1239             mstore(0x00, id)
1240             mstore(0x1c, or(_ERC721_MASTER_SLOT_SEED, by))
1241             let ownershipSlot := add(id, add(id, keccak256(0x00, 0x20)))
1242             let owner := and(bitmaskAddress, sload(ownershipSlot))
1243         // Revert if the token does not exist.
1244             if iszero(owner) {
1245                 mstore(0x00, 0xceea21b6) // `TokenDoesNotExist()`.
1246                 revert(0x1c, 0x04)
1247             }
1248         // If `by` is not the zero address, do the authorization check.
1249         // Revert if `by` is not the owner, nor approved.
1250             if iszero(or(iszero(by), eq(by, owner))) {
1251                 mstore(0x00, owner)
1252                 if iszero(sload(keccak256(0x0c, 0x30))) {
1253                     mstore(0x00, 0x4b6e7f18) // `NotOwnerNorApproved()`.
1254                     revert(0x1c, 0x04)
1255                 }
1256             }
1257         // Sets `account` as the approved account to manage `id`.
1258             sstore(add(1, ownershipSlot), account)
1259         // Emit the {Approval} event.
1260             log4(0x00, 0x00, _APPROVAL_EVENT_SIGNATURE, owner, account, id)
1261         }
1262     }
1263 
1264     /// @dev Approve or remove the `operator` as an operator for `by`,
1265     /// without authorization checks.
1266     ///
1267     /// Emits a {ApprovalForAll} event.
1268     function _setApprovalForAll(address by, address operator, bool isApproved) internal virtual {
1269         /// @solidity memory-safe-assembly
1270         assembly {
1271         // Clear the upper 96 bits.
1272             by := shr(96, shl(96, by))
1273             operator := shr(96, shl(96, operator))
1274         // Convert to 0 or 1.
1275             isApproved := iszero(iszero(isApproved))
1276         // Update the `isApproved` for (`by`, `operator`).
1277             mstore(0x1c, or(_ERC721_MASTER_SLOT_SEED, operator))
1278             mstore(0x00, by)
1279             sstore(keccak256(0x0c, 0x30), isApproved)
1280         // Emit the {ApprovalForAll} event.
1281             mstore(0x00, isApproved)
1282             log3(0x00, 0x20, _APPROVAL_FOR_ALL_EVENT_SIGNATURE, by, operator)
1283         }
1284     }
1285 
1286     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1287     /*                INTERNAL TRANSFER FUNCTIONS                 */
1288     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1289 
1290     /// @dev Equivalent to `_transfer(address(0), from, to, id)`.
1291     function _transfer(address from, address to, uint256 id) internal virtual {
1292         _transfer(address(0), from, to, id);
1293     }
1294 
1295     /// @dev Transfers token `id` from `from` to `to`.
1296     ///
1297     /// Requirements:
1298     ///
1299     /// - Token `id` must exist.
1300     /// - `from` must be the owner of the token.
1301     /// - `to` cannot be the zero address.
1302     /// - If `by` is not the zero address,
1303     ///   it must be the owner of the token, or be approved to manage the token.
1304     ///
1305     /// Emits a {Transfer} event.
1306     function _transfer(address by, address from, address to, uint256 id) internal virtual {
1307         _beforeTokenTransfer(from, to, id);
1308         /// @solidity memory-safe-assembly
1309         assembly {
1310         // Clear the upper 96 bits.
1311             let bitmaskAddress := shr(96, not(0))
1312             from := and(bitmaskAddress, from)
1313             to := and(bitmaskAddress, to)
1314             by := and(bitmaskAddress, by)
1315         // Load the ownership data.
1316             mstore(0x00, id)
1317             mstore(0x1c, or(_ERC721_MASTER_SLOT_SEED, by))
1318             let ownershipSlot := add(id, add(id, keccak256(0x00, 0x20)))
1319             let ownershipPacked := sload(ownershipSlot)
1320             let owner := and(bitmaskAddress, ownershipPacked)
1321         // Revert if `from` is not the owner, or does not exist.
1322             if iszero(mul(owner, eq(owner, from))) {
1323                 if iszero(owner) {
1324                     mstore(0x00, 0xceea21b6) // `TokenDoesNotExist()`.
1325                     revert(0x1c, 0x04)
1326                 }
1327                 mstore(0x00, 0xa1148100) // `TransferFromIncorrectOwner()`.
1328                 revert(0x1c, 0x04)
1329             }
1330         // Revert if `to` is the zero address.
1331             if iszero(to) {
1332                 mstore(0x00, 0xea553b34) // `TransferToZeroAddress()`.
1333                 revert(0x1c, 0x04)
1334             }
1335         // Load, check, and update the token approval.
1336             {
1337                 mstore(0x00, from)
1338                 let approvedAddress := sload(add(1, ownershipSlot))
1339             // If `by` is not the zero address, do the authorization check.
1340             // Revert if the `by` is not the owner, nor approved.
1341                 if iszero(or(iszero(by), or(eq(by, from), eq(by, approvedAddress)))) {
1342                     if iszero(sload(keccak256(0x0c, 0x30))) {
1343                         mstore(0x00, 0x4b6e7f18) // `NotOwnerNorApproved()`.
1344                         revert(0x1c, 0x04)
1345                     }
1346                 }
1347             // Delete the approved address if any.
1348                 if approvedAddress { sstore(add(1, ownershipSlot), 0) }
1349             }
1350         // Update with the new owner.
1351             sstore(ownershipSlot, xor(ownershipPacked, xor(from, to)))
1352         // Decrement the balance of `from`.
1353             {
1354                 let fromBalanceSlot := keccak256(0x0c, 0x1c)
1355                 sstore(fromBalanceSlot, sub(sload(fromBalanceSlot), 1))
1356             }
1357         // Increment the balance of `to`.
1358             {
1359                 mstore(0x00, to)
1360                 let toBalanceSlot := keccak256(0x0c, 0x1c)
1361                 let toBalanceSlotPacked := add(sload(toBalanceSlot), 1)
1362                 if iszero(and(toBalanceSlotPacked, _MAX_ACCOUNT_BALANCE)) {
1363                     mstore(0x00, 0x01336cea) // `AccountBalanceOverflow()`.
1364                     revert(0x1c, 0x04)
1365                 }
1366                 sstore(toBalanceSlot, toBalanceSlotPacked)
1367             }
1368         // Emit the {Transfer} event.
1369             log4(0x00, 0x00, _TRANSFER_EVENT_SIGNATURE, from, to, id)
1370         }
1371         _afterTokenTransfer(from, to, id);
1372     }
1373 
1374     /// @dev Equivalent to `_safeTransfer(from, to, id, "")`.
1375     function _safeTransfer(address from, address to, uint256 id) internal virtual {
1376         _safeTransfer(from, to, id, "");
1377     }
1378 
1379     /// @dev Transfers token `id` from `from` to `to`.
1380     ///
1381     /// Requirements:
1382     ///
1383     /// - Token `id` must exist.
1384     /// - `from` must be the owner of the token.
1385     /// - `to` cannot be the zero address.
1386     /// - The caller must be the owner of the token, or be approved to manage the token.
1387     /// - If `to` refers to a smart contract, it must implement
1388     ///   {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1389     ///
1390     /// Emits a {Transfer} event.
1391     function _safeTransfer(address from, address to, uint256 id, bytes memory data)
1392     internal
1393     virtual
1394     {
1395         _transfer(address(0), from, to, id);
1396         if (_hasCode(to)) _checkOnERC721Received(from, to, id, data);
1397     }
1398 
1399     /// @dev Equivalent to `_safeTransfer(by, from, to, id, "")`.
1400     function _safeTransfer(address by, address from, address to, uint256 id) internal virtual {
1401         _safeTransfer(by, from, to, id, "");
1402     }
1403 
1404     /// @dev Transfers token `id` from `from` to `to`.
1405     ///
1406     /// Requirements:
1407     ///
1408     /// - Token `id` must exist.
1409     /// - `from` must be the owner of the token.
1410     /// - `to` cannot be the zero address.
1411     /// - If `by` is not the zero address,
1412     ///   it must be the owner of the token, or be approved to manage the token.
1413     /// - If `to` refers to a smart contract, it must implement
1414     ///   {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1415     ///
1416     /// Emits a {Transfer} event.
1417     function _safeTransfer(address by, address from, address to, uint256 id, bytes memory data)
1418     internal
1419     virtual
1420     {
1421         _transfer(by, from, to, id);
1422         if (_hasCode(to)) _checkOnERC721Received(from, to, id, data);
1423     }
1424 
1425     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1426     /*                    HOOKS FOR OVERRIDING                    */
1427     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1428 
1429     /// @dev Hook that is called before any token transfers, including minting and burning.
1430     function _beforeTokenTransfer(address from, address to, uint256 id) internal virtual {}
1431 
1432     /// @dev Hook that is called after any token transfers, including minting and burning.
1433     function _afterTokenTransfer(address from, address to, uint256 id) internal virtual {}
1434 
1435     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1436     /*                      PRIVATE HELPERS                       */
1437     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1438 
1439     /// @dev Returns if `a` has bytecode of non-zero length.
1440     function _hasCode(address a) private view returns (bool result) {
1441         /// @solidity memory-safe-assembly
1442         assembly {
1443             result := extcodesize(a) // Can handle dirty upper bits.
1444         }
1445     }
1446 
1447     /// @dev Perform a call to invoke {IERC721Receiver-onERC721Received} on `to`.
1448     /// Reverts if the target does not support the function correctly.
1449     function _checkOnERC721Received(address from, address to, uint256 id, bytes memory data)
1450     private
1451     {
1452         /// @solidity memory-safe-assembly
1453         assembly {
1454         // Prepare the calldata.
1455             let m := mload(0x40)
1456             let onERC721ReceivedSelector := 0x150b7a02
1457             mstore(m, onERC721ReceivedSelector)
1458             mstore(add(m, 0x20), caller()) // The `operator`, which is always `msg.sender`.
1459             mstore(add(m, 0x40), shr(96, shl(96, from)))
1460             mstore(add(m, 0x60), id)
1461             mstore(add(m, 0x80), 0x80)
1462             let n := mload(data)
1463             mstore(add(m, 0xa0), n)
1464             if n { pop(staticcall(gas(), 4, add(data, 0x20), n, add(m, 0xc0), n)) }
1465         // Revert if the call reverts.
1466             if iszero(call(gas(), to, 0, add(m, 0x1c), add(n, 0xa4), m, 0x20)) {
1467                 if returndatasize() {
1468                 // Bubble up the revert if the call reverts.
1469                     returndatacopy(0x00, 0x00, returndatasize())
1470                     revert(0x00, returndatasize())
1471                 }
1472                 mstore(m, 0)
1473             }
1474         // Load the returndata and compare it.
1475             if iszero(eq(mload(m), shl(224, onERC721ReceivedSelector))) {
1476                 mstore(0x00, 0xd1a57ed6) // `TransferToNonERC721ReceiverImplementer()`.
1477                 revert(0x1c, 0x04)
1478             }
1479         }
1480     }
1481 }
1482 
1483 // File: contracts/LibPRNG.sol
1484 
1485 
1486 pragma solidity ^0.8.4;
1487 
1488 /// @notice Library for generating psuedorandom numbers.
1489 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/LibPRNG.sol)
1490 library LibPRNG {
1491     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1492     /*                          STRUCTS                           */
1493     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1494 
1495     /// @dev A psuedorandom number state in memory.
1496     struct PRNG {
1497         uint256 state;
1498     }
1499 
1500     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1501     /*                         OPERATIONS                         */
1502     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1503 
1504     /// @dev Seeds the `prng` with `state`.
1505     function seed(PRNG memory prng, uint256 state) internal pure {
1506         /// @solidity memory-safe-assembly
1507         assembly {
1508             mstore(prng, state)
1509         }
1510     }
1511 
1512     /// @dev Returns the next psuedorandom uint256.
1513     /// All bits of the returned uint256 pass the NIST Statistical Test Suite.
1514     function next(PRNG memory prng) internal pure returns (uint256 result) {
1515         // We simply use `keccak256` for a great balance between
1516         // runtime gas costs, bytecode size, and statistical properties.
1517         //
1518         // A high-quality LCG with a 32-byte state
1519         // is only about 30% more gas efficient during runtime,
1520         // but requires a 32-byte multiplier, which can cause bytecode bloat
1521         // when this function is inlined.
1522         //
1523         // Using this method is about 2x more efficient than
1524         // `nextRandomness = uint256(keccak256(abi.encode(randomness)))`.
1525         /// @solidity memory-safe-assembly
1526         assembly {
1527             result := keccak256(prng, 0x20)
1528             mstore(prng, result)
1529         }
1530     }
1531 
1532     /// @dev Returns a psuedorandom uint256, uniformly distributed
1533     /// between 0 (inclusive) and `upper` (exclusive).
1534     /// If your modulus is big, this method is recommended
1535     /// for uniform sampling to avoid modulo bias.
1536     /// For uniform sampling across all uint256 values,
1537     /// or for small enough moduli such that the bias is neligible,
1538     /// use {next} instead.
1539     function uniform(PRNG memory prng, uint256 upper) internal pure returns (uint256 result) {
1540         /// @solidity memory-safe-assembly
1541         assembly {
1542             for {} 1 {} {
1543                 result := keccak256(prng, 0x20)
1544                 mstore(prng, result)
1545                 if iszero(lt(result, mod(sub(0, upper), upper))) { break }
1546             }
1547             result := mod(result, upper)
1548         }
1549     }
1550 
1551     /// @dev Shuffles the array in-place with Fisher-Yates shuffle.
1552     function shuffle(PRNG memory prng, uint256[] memory a) internal pure {
1553         /// @solidity memory-safe-assembly
1554         assembly {
1555             let n := mload(a)
1556             let w := not(0)
1557             let mask := shr(128, w)
1558             if n {
1559                 for { a := add(a, 0x20) } 1 {} {
1560                 // We can just directly use `keccak256`, cuz
1561                 // the other approaches don't save much.
1562                     let r := keccak256(prng, 0x20)
1563                     mstore(prng, r)
1564 
1565                 // Note that there will be a very tiny modulo bias
1566                 // if the length of the array is not a power of 2.
1567                 // For all practical purposes, it is negligible
1568                 // and will not be a fairness or security concern.
1569                     {
1570                         let j := add(a, shl(5, mod(shr(128, r), n)))
1571                         n := add(n, w) // `sub(n, 1)`.
1572                         if iszero(n) { break }
1573 
1574                         let i := add(a, shl(5, n))
1575                         let t := mload(i)
1576                         mstore(i, mload(j))
1577                         mstore(j, t)
1578                     }
1579 
1580                     {
1581                         let j := add(a, shl(5, mod(and(r, mask), n)))
1582                         n := add(n, w) // `sub(n, 1)`.
1583                         if iszero(n) { break }
1584 
1585                         let i := add(a, shl(5, n))
1586                         let t := mload(i)
1587                         mstore(i, mload(j))
1588                         mstore(j, t)
1589                     }
1590                 }
1591             }
1592         }
1593     }
1594 
1595     /// @dev Shuffles the bytes in-place with Fisher-Yates shuffle.
1596     function shuffle(PRNG memory prng, bytes memory a) internal pure {
1597         /// @solidity memory-safe-assembly
1598         assembly {
1599             let n := mload(a)
1600             let w := not(0)
1601             let mask := shr(128, w)
1602             if n {
1603                 let b := add(a, 0x01)
1604                 for { a := add(a, 0x20) } 1 {} {
1605                 // We can just directly use `keccak256`, cuz
1606                 // the other approaches don't save much.
1607                     let r := keccak256(prng, 0x20)
1608                     mstore(prng, r)
1609 
1610                 // Note that there will be a very tiny modulo bias
1611                 // if the length of the array is not a power of 2.
1612                 // For all practical purposes, it is negligible
1613                 // and will not be a fairness or security concern.
1614                     {
1615                         let o := mod(shr(128, r), n)
1616                         n := add(n, w) // `sub(n, 1)`.
1617                         if iszero(n) { break }
1618 
1619                         let t := mload(add(b, n))
1620                         mstore8(add(a, n), mload(add(b, o)))
1621                         mstore8(add(a, o), t)
1622                     }
1623 
1624                     {
1625                         let o := mod(and(r, mask), n)
1626                         n := add(n, w) // `sub(n, 1)`.
1627                         if iszero(n) { break }
1628 
1629                         let t := mload(add(b, n))
1630                         mstore8(add(a, n), mload(add(b, o)))
1631                         mstore8(add(a, o), t)
1632                     }
1633                 }
1634             }
1635         }
1636     }
1637 }
1638 
1639 // File: contracts/LibString.sol
1640 
1641 
1642 pragma solidity ^0.8.4;
1643 
1644 /// @notice Library for converting numbers into strings and other string operations.
1645 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/LibString.sol)
1646 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/LibString.sol)
1647 library LibString {
1648     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1649     /*                        CUSTOM ERRORS                       */
1650     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1651 
1652     /// @dev The `length` of the output is too small to contain all the hex digits.
1653     error HexLengthInsufficient();
1654 
1655     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1656     /*                         CONSTANTS                          */
1657     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1658 
1659     /// @dev The constant returned when the `search` is not found in the string.
1660     uint256 internal constant NOT_FOUND = type(uint256).max;
1661 
1662     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1663     /*                     DECIMAL OPERATIONS                     */
1664     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1665 
1666     /// @dev Returns the base 10 decimal representation of `value`.
1667     function toString(uint256 value) internal pure returns (string memory str) {
1668         /// @solidity memory-safe-assembly
1669         assembly {
1670         // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1671         // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1672         // We will need 1 word for the trailing zeros padding, 1 word for the length,
1673         // and 3 words for a maximum of 78 digits.
1674             str := add(mload(0x40), 0x80)
1675         // Update the free memory pointer to allocate.
1676             mstore(0x40, add(str, 0x20))
1677         // Zeroize the slot after the string.
1678             mstore(str, 0)
1679 
1680         // Cache the end of the memory to calculate the length later.
1681             let end := str
1682 
1683             let w := not(0) // Tsk.
1684         // We write the string from rightmost digit to leftmost digit.
1685         // The following is essentially a do-while loop that also handles the zero case.
1686             for { let temp := value } 1 {} {
1687                 str := add(str, w) // `sub(str, 1)`.
1688             // Write the character to the pointer.
1689             // The ASCII index of the '0' character is 48.
1690                 mstore8(str, add(48, mod(temp, 10)))
1691             // Keep dividing `temp` until zero.
1692                 temp := div(temp, 10)
1693                 if iszero(temp) { break }
1694             }
1695 
1696             let length := sub(end, str)
1697         // Move the pointer 32 bytes leftwards to make room for the length.
1698             str := sub(str, 0x20)
1699         // Store the length.
1700             mstore(str, length)
1701         }
1702     }
1703 
1704     /// @dev Returns the base 10 decimal representation of `value`.
1705     function toString(int256 value) internal pure returns (string memory str) {
1706         if (value >= 0) {
1707             return toString(uint256(value));
1708         }
1709     unchecked {
1710         str = toString(uint256(-value));
1711     }
1712         /// @solidity memory-safe-assembly
1713         assembly {
1714         // We still have some spare memory space on the left,
1715         // as we have allocated 3 words (96 bytes) for up to 78 digits.
1716             let length := mload(str) // Load the string length.
1717             mstore(str, 0x2d) // Store the '-' character.
1718             str := sub(str, 1) // Move back the string pointer by a byte.
1719             mstore(str, add(length, 1)) // Update the string length.
1720         }
1721     }
1722 
1723     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1724     /*                   HEXADECIMAL OPERATIONS                   */
1725     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1726 
1727     /// @dev Returns the hexadecimal representation of `value`,
1728     /// left-padded to an input length of `length` bytes.
1729     /// The output is prefixed with "0x" encoded using 2 hexadecimal digits per byte,
1730     /// giving a total length of `length * 2 + 2` bytes.
1731     /// Reverts if `length` is too small for the output to contain all the digits.
1732     function toHexString(uint256 value, uint256 length) internal pure returns (string memory str) {
1733         str = toHexStringNoPrefix(value, length);
1734         /// @solidity memory-safe-assembly
1735         assembly {
1736             let strLength := add(mload(str), 2) // Compute the length.
1737             mstore(str, 0x3078) // Write the "0x" prefix.
1738             str := sub(str, 2) // Move the pointer.
1739             mstore(str, strLength) // Write the length.
1740         }
1741     }
1742 
1743     /// @dev Returns the hexadecimal representation of `value`,
1744     /// left-padded to an input length of `length` bytes.
1745     /// The output is prefixed with "0x" encoded using 2 hexadecimal digits per byte,
1746     /// giving a total length of `length * 2` bytes.
1747     /// Reverts if `length` is too small for the output to contain all the digits.
1748     function toHexStringNoPrefix(uint256 value, uint256 length)
1749     internal
1750     pure
1751     returns (string memory str)
1752     {
1753         /// @solidity memory-safe-assembly
1754         assembly {
1755         // We need 0x20 bytes for the trailing zeros padding, `length * 2` bytes
1756         // for the digits, 0x02 bytes for the prefix, and 0x20 bytes for the length.
1757         // We add 0x20 to the total and round down to a multiple of 0x20.
1758         // (0x20 + 0x20 + 0x02 + 0x20) = 0x62.
1759             str := add(mload(0x40), and(add(shl(1, length), 0x42), not(0x1f)))
1760         // Allocate the memory.
1761             mstore(0x40, add(str, 0x20))
1762         // Zeroize the slot after the string.
1763             mstore(str, 0)
1764 
1765         // Cache the end to calculate the length later.
1766             let end := str
1767         // Store "0123456789abcdef" in scratch space.
1768             mstore(0x0f, 0x30313233343536373839616263646566)
1769 
1770             let start := sub(str, add(length, length))
1771             let w := not(1) // Tsk.
1772             let temp := value
1773         // We write the string from rightmost digit to leftmost digit.
1774         // The following is essentially a do-while loop that also handles the zero case.
1775             for {} 1 {} {
1776                 str := add(str, w) // `sub(str, 2)`.
1777                 mstore8(add(str, 1), mload(and(temp, 15)))
1778                 mstore8(str, mload(and(shr(4, temp), 15)))
1779                 temp := shr(8, temp)
1780                 if iszero(xor(str, start)) { break }
1781             }
1782 
1783             if temp {
1784             // Store the function selector of `HexLengthInsufficient()`.
1785                 mstore(0x00, 0x2194895a)
1786             // Revert with (offset, size).
1787                 revert(0x1c, 0x04)
1788             }
1789 
1790         // Compute the string's length.
1791             let strLength := sub(end, str)
1792         // Move the pointer and write the length.
1793             str := sub(str, 0x20)
1794             mstore(str, strLength)
1795         }
1796     }
1797 
1798     /// @dev Returns the hexadecimal representation of `value`.
1799     /// The output is prefixed with "0x" and encoded using 2 hexadecimal digits per byte.
1800     /// As address are 20 bytes long, the output will left-padded to have
1801     /// a length of `20 * 2 + 2` bytes.
1802     function toHexString(uint256 value) internal pure returns (string memory str) {
1803         str = toHexStringNoPrefix(value);
1804         /// @solidity memory-safe-assembly
1805         assembly {
1806             let strLength := add(mload(str), 2) // Compute the length.
1807             mstore(str, 0x3078) // Write the "0x" prefix.
1808             str := sub(str, 2) // Move the pointer.
1809             mstore(str, strLength) // Write the length.
1810         }
1811     }
1812 
1813     /// @dev Returns the hexadecimal representation of `value`.
1814     /// The output is encoded using 2 hexadecimal digits per byte.
1815     /// As address are 20 bytes long, the output will left-padded to have
1816     /// a length of `20 * 2` bytes.
1817     function toHexStringNoPrefix(uint256 value) internal pure returns (string memory str) {
1818         /// @solidity memory-safe-assembly
1819         assembly {
1820         // We need 0x20 bytes for the trailing zeros padding, 0x20 bytes for the length,
1821         // 0x02 bytes for the prefix, and 0x40 bytes for the digits.
1822         // The next multiple of 0x20 above (0x20 + 0x20 + 0x02 + 0x40) is 0xa0.
1823             str := add(mload(0x40), 0x80)
1824         // Allocate the memory.
1825             mstore(0x40, add(str, 0x20))
1826         // Zeroize the slot after the string.
1827             mstore(str, 0)
1828 
1829         // Cache the end to calculate the length later.
1830             let end := str
1831         // Store "0123456789abcdef" in scratch space.
1832             mstore(0x0f, 0x30313233343536373839616263646566)
1833 
1834             let w := not(1) // Tsk.
1835         // We write the string from rightmost digit to leftmost digit.
1836         // The following is essentially a do-while loop that also handles the zero case.
1837             for { let temp := value } 1 {} {
1838                 str := add(str, w) // `sub(str, 2)`.
1839                 mstore8(add(str, 1), mload(and(temp, 15)))
1840                 mstore8(str, mload(and(shr(4, temp), 15)))
1841                 temp := shr(8, temp)
1842                 if iszero(temp) { break }
1843             }
1844 
1845         // Compute the string's length.
1846             let strLength := sub(end, str)
1847         // Move the pointer and write the length.
1848             str := sub(str, 0x20)
1849             mstore(str, strLength)
1850         }
1851     }
1852 
1853     /// @dev Returns the hexadecimal representation of `value`.
1854     /// The output is prefixed with "0x", encoded using 2 hexadecimal digits per byte,
1855     /// and the alphabets are capitalized conditionally according to
1856     /// https://eips.ethereum.org/EIPS/eip-55
1857     function toHexStringChecksummed(address value) internal pure returns (string memory str) {
1858         str = toHexString(value);
1859         /// @solidity memory-safe-assembly
1860         assembly {
1861             let mask := shl(6, div(not(0), 255)) // `0b010000000100000000 ...`
1862             let o := add(str, 0x22)
1863             let hashed := and(keccak256(o, 40), mul(34, mask)) // `0b10001000 ... `
1864             let t := shl(240, 136) // `0b10001000 << 240`
1865             for { let i := 0 } 1 {} {
1866                 mstore(add(i, i), mul(t, byte(i, hashed)))
1867                 i := add(i, 1)
1868                 if eq(i, 20) { break }
1869             }
1870             mstore(o, xor(mload(o), shr(1, and(mload(0x00), and(mload(o), mask)))))
1871             o := add(o, 0x20)
1872             mstore(o, xor(mload(o), shr(1, and(mload(0x20), and(mload(o), mask)))))
1873         }
1874     }
1875 
1876     /// @dev Returns the hexadecimal representation of `value`.
1877     /// The output is prefixed with "0x" and encoded using 2 hexadecimal digits per byte.
1878     function toHexString(address value) internal pure returns (string memory str) {
1879         str = toHexStringNoPrefix(value);
1880         /// @solidity memory-safe-assembly
1881         assembly {
1882             let strLength := add(mload(str), 2) // Compute the length.
1883             mstore(str, 0x3078) // Write the "0x" prefix.
1884             str := sub(str, 2) // Move the pointer.
1885             mstore(str, strLength) // Write the length.
1886         }
1887     }
1888 
1889     /// @dev Returns the hexadecimal representation of `value`.
1890     /// The output is encoded using 2 hexadecimal digits per byte.
1891     function toHexStringNoPrefix(address value) internal pure returns (string memory str) {
1892         /// @solidity memory-safe-assembly
1893         assembly {
1894             str := mload(0x40)
1895 
1896         // Allocate the memory.
1897         // We need 0x20 bytes for the trailing zeros padding, 0x20 bytes for the length,
1898         // 0x02 bytes for the prefix, and 0x28 bytes for the digits.
1899         // The next multiple of 0x20 above (0x20 + 0x20 + 0x02 + 0x28) is 0x80.
1900             mstore(0x40, add(str, 0x80))
1901 
1902         // Store "0123456789abcdef" in scratch space.
1903             mstore(0x0f, 0x30313233343536373839616263646566)
1904 
1905             str := add(str, 2)
1906             mstore(str, 40)
1907 
1908             let o := add(str, 0x20)
1909             mstore(add(o, 40), 0)
1910 
1911             value := shl(96, value)
1912 
1913         // We write the string from rightmost digit to leftmost digit.
1914         // The following is essentially a do-while loop that also handles the zero case.
1915             for { let i := 0 } 1 {} {
1916                 let p := add(o, add(i, i))
1917                 let temp := byte(i, value)
1918                 mstore8(add(p, 1), mload(and(temp, 15)))
1919                 mstore8(p, mload(shr(4, temp)))
1920                 i := add(i, 1)
1921                 if eq(i, 20) { break }
1922             }
1923         }
1924     }
1925 
1926     /// @dev Returns the hex encoded string from the raw bytes.
1927     /// The output is encoded using 2 hexadecimal digits per byte.
1928     function toHexString(bytes memory raw) internal pure returns (string memory str) {
1929         str = toHexStringNoPrefix(raw);
1930         /// @solidity memory-safe-assembly
1931         assembly {
1932             let strLength := add(mload(str), 2) // Compute the length.
1933             mstore(str, 0x3078) // Write the "0x" prefix.
1934             str := sub(str, 2) // Move the pointer.
1935             mstore(str, strLength) // Write the length.
1936         }
1937     }
1938 
1939     /// @dev Returns the hex encoded string from the raw bytes.
1940     /// The output is encoded using 2 hexadecimal digits per byte.
1941     function toHexStringNoPrefix(bytes memory raw) internal pure returns (string memory str) {
1942         /// @solidity memory-safe-assembly
1943         assembly {
1944             let length := mload(raw)
1945             str := add(mload(0x40), 2) // Skip 2 bytes for the optional prefix.
1946             mstore(str, add(length, length)) // Store the length of the output.
1947 
1948         // Store "0123456789abcdef" in scratch space.
1949             mstore(0x0f, 0x30313233343536373839616263646566)
1950 
1951             let o := add(str, 0x20)
1952             let end := add(raw, length)
1953 
1954             for {} iszero(eq(raw, end)) {} {
1955                 raw := add(raw, 1)
1956                 mstore8(add(o, 1), mload(and(mload(raw), 15)))
1957                 mstore8(o, mload(and(shr(4, mload(raw)), 15)))
1958                 o := add(o, 2)
1959             }
1960             mstore(o, 0) // Zeroize the slot after the string.
1961             mstore(0x40, add(o, 0x20)) // Allocate the memory.
1962         }
1963     }
1964 
1965     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1966     /*                   RUNE STRING OPERATIONS                   */
1967     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1968 
1969     /// @dev Returns the number of UTF characters in the string.
1970     function runeCount(string memory s) internal pure returns (uint256 result) {
1971         /// @solidity memory-safe-assembly
1972         assembly {
1973             if mload(s) {
1974                 mstore(0x00, div(not(0), 255))
1975                 mstore(0x20, 0x0202020202020202020202020202020202020202020202020303030304040506)
1976                 let o := add(s, 0x20)
1977                 let end := add(o, mload(s))
1978                 for { result := 1 } 1 { result := add(result, 1) } {
1979                     o := add(o, byte(0, mload(shr(250, mload(o)))))
1980                     if iszero(lt(o, end)) { break }
1981                 }
1982             }
1983         }
1984     }
1985 
1986     /// @dev Returns if this string is a 7-bit ASCII string.
1987     /// (i.e. all characters codes are in [0..127])
1988     function is7BitASCII(string memory s) internal pure returns (bool result) {
1989         /// @solidity memory-safe-assembly
1990         assembly {
1991             let mask := shl(7, div(not(0), 255))
1992             result := 1
1993             let n := mload(s)
1994             if n {
1995                 let o := add(s, 0x20)
1996                 let end := add(o, n)
1997                 let last := mload(end)
1998                 mstore(end, 0)
1999                 for {} 1 {} {
2000                     if and(mask, mload(o)) {
2001                         result := 0
2002                         break
2003                     }
2004                     o := add(o, 0x20)
2005                     if iszero(lt(o, end)) { break }
2006                 }
2007                 mstore(end, last)
2008             }
2009         }
2010     }
2011 
2012     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
2013     /*                   BYTE STRING OPERATIONS                   */
2014     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
2015 
2016     // For performance and bytecode compactness, all indices of the following operations
2017     // are byte (ASCII) offsets, not UTF character offsets.
2018 
2019     /// @dev Returns `subject` all occurrences of `search` replaced with `replacement`.
2020     function replace(string memory subject, string memory search, string memory replacement)
2021     internal
2022     pure
2023     returns (string memory result)
2024     {
2025         /// @solidity memory-safe-assembly
2026         assembly {
2027             let subjectLength := mload(subject)
2028             let searchLength := mload(search)
2029             let replacementLength := mload(replacement)
2030 
2031             subject := add(subject, 0x20)
2032             search := add(search, 0x20)
2033             replacement := add(replacement, 0x20)
2034             result := add(mload(0x40), 0x20)
2035 
2036             let subjectEnd := add(subject, subjectLength)
2037             if iszero(gt(searchLength, subjectLength)) {
2038                 let subjectSearchEnd := add(sub(subjectEnd, searchLength), 1)
2039                 let h := 0
2040                 if iszero(lt(searchLength, 0x20)) { h := keccak256(search, searchLength) }
2041                 let m := shl(3, sub(0x20, and(searchLength, 0x1f)))
2042                 let s := mload(search)
2043                 for {} 1 {} {
2044                     let t := mload(subject)
2045                 // Whether the first `searchLength % 32` bytes of
2046                 // `subject` and `search` matches.
2047                     if iszero(shr(m, xor(t, s))) {
2048                         if h {
2049                             if iszero(eq(keccak256(subject, searchLength), h)) {
2050                                 mstore(result, t)
2051                                 result := add(result, 1)
2052                                 subject := add(subject, 1)
2053                                 if iszero(lt(subject, subjectSearchEnd)) { break }
2054                                 continue
2055                             }
2056                         }
2057                     // Copy the `replacement` one word at a time.
2058                         for { let o := 0 } 1 {} {
2059                             mstore(add(result, o), mload(add(replacement, o)))
2060                             o := add(o, 0x20)
2061                             if iszero(lt(o, replacementLength)) { break }
2062                         }
2063                         result := add(result, replacementLength)
2064                         subject := add(subject, searchLength)
2065                         if searchLength {
2066                             if iszero(lt(subject, subjectSearchEnd)) { break }
2067                             continue
2068                         }
2069                     }
2070                     mstore(result, t)
2071                     result := add(result, 1)
2072                     subject := add(subject, 1)
2073                     if iszero(lt(subject, subjectSearchEnd)) { break }
2074                 }
2075             }
2076 
2077             let resultRemainder := result
2078             result := add(mload(0x40), 0x20)
2079             let k := add(sub(resultRemainder, result), sub(subjectEnd, subject))
2080         // Copy the rest of the string one word at a time.
2081             for {} lt(subject, subjectEnd) {} {
2082                 mstore(resultRemainder, mload(subject))
2083                 resultRemainder := add(resultRemainder, 0x20)
2084                 subject := add(subject, 0x20)
2085             }
2086             result := sub(result, 0x20)
2087             let last := add(add(result, 0x20), k) // Zeroize the slot after the string.
2088             mstore(last, 0)
2089             mstore(0x40, add(last, 0x20)) // Allocate the memory.
2090             mstore(result, k) // Store the length.
2091         }
2092     }
2093 
2094     /// @dev Returns the byte index of the first location of `search` in `subject`,
2095     /// searching from left to right, starting from `from`.
2096     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
2097     function indexOf(string memory subject, string memory search, uint256 from)
2098     internal
2099     pure
2100     returns (uint256 result)
2101     {
2102         /// @solidity memory-safe-assembly
2103         assembly {
2104             for { let subjectLength := mload(subject) } 1 {} {
2105                 if iszero(mload(search)) {
2106                     if iszero(gt(from, subjectLength)) {
2107                         result := from
2108                         break
2109                     }
2110                     result := subjectLength
2111                     break
2112                 }
2113                 let searchLength := mload(search)
2114                 let subjectStart := add(subject, 0x20)
2115 
2116                 result := not(0) // Initialize to `NOT_FOUND`.
2117 
2118                 subject := add(subjectStart, from)
2119                 let end := add(sub(add(subjectStart, subjectLength), searchLength), 1)
2120 
2121                 let m := shl(3, sub(0x20, and(searchLength, 0x1f)))
2122                 let s := mload(add(search, 0x20))
2123 
2124                 if iszero(and(lt(subject, end), lt(from, subjectLength))) { break }
2125 
2126                 if iszero(lt(searchLength, 0x20)) {
2127                     for { let h := keccak256(add(search, 0x20), searchLength) } 1 {} {
2128                         if iszero(shr(m, xor(mload(subject), s))) {
2129                             if eq(keccak256(subject, searchLength), h) {
2130                                 result := sub(subject, subjectStart)
2131                                 break
2132                             }
2133                         }
2134                         subject := add(subject, 1)
2135                         if iszero(lt(subject, end)) { break }
2136                     }
2137                     break
2138                 }
2139                 for {} 1 {} {
2140                     if iszero(shr(m, xor(mload(subject), s))) {
2141                         result := sub(subject, subjectStart)
2142                         break
2143                     }
2144                     subject := add(subject, 1)
2145                     if iszero(lt(subject, end)) { break }
2146                 }
2147                 break
2148             }
2149         }
2150     }
2151 
2152     /// @dev Returns the byte index of the first location of `search` in `subject`,
2153     /// searching from left to right.
2154     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
2155     function indexOf(string memory subject, string memory search)
2156     internal
2157     pure
2158     returns (uint256 result)
2159     {
2160         result = indexOf(subject, search, 0);
2161     }
2162 
2163     /// @dev Returns the byte index of the first location of `search` in `subject`,
2164     /// searching from right to left, starting from `from`.
2165     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
2166     function lastIndexOf(string memory subject, string memory search, uint256 from)
2167     internal
2168     pure
2169     returns (uint256 result)
2170     {
2171         /// @solidity memory-safe-assembly
2172         assembly {
2173             for {} 1 {} {
2174                 result := not(0) // Initialize to `NOT_FOUND`.
2175                 let searchLength := mload(search)
2176                 if gt(searchLength, mload(subject)) { break }
2177                 let w := result
2178 
2179                 let fromMax := sub(mload(subject), searchLength)
2180                 if iszero(gt(fromMax, from)) { from := fromMax }
2181 
2182                 let end := add(add(subject, 0x20), w)
2183                 subject := add(add(subject, 0x20), from)
2184                 if iszero(gt(subject, end)) { break }
2185             // As this function is not too often used,
2186             // we shall simply use keccak256 for smaller bytecode size.
2187                 for { let h := keccak256(add(search, 0x20), searchLength) } 1 {} {
2188                     if eq(keccak256(subject, searchLength), h) {
2189                         result := sub(subject, add(end, 1))
2190                         break
2191                     }
2192                     subject := add(subject, w) // `sub(subject, 1)`.
2193                     if iszero(gt(subject, end)) { break }
2194                 }
2195                 break
2196             }
2197         }
2198     }
2199 
2200     /// @dev Returns the byte index of the first location of `search` in `subject`,
2201     /// searching from right to left.
2202     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
2203     function lastIndexOf(string memory subject, string memory search)
2204     internal
2205     pure
2206     returns (uint256 result)
2207     {
2208         result = lastIndexOf(subject, search, uint256(int256(-1)));
2209     }
2210 
2211     /// @dev Returns whether `subject` starts with `search`.
2212     function startsWith(string memory subject, string memory search)
2213     internal
2214     pure
2215     returns (bool result)
2216     {
2217         /// @solidity memory-safe-assembly
2218         assembly {
2219             let searchLength := mload(search)
2220         // Just using keccak256 directly is actually cheaper.
2221         // forgefmt: disable-next-item
2222             result := and(
2223             iszero(gt(searchLength, mload(subject))),
2224             eq(
2225             keccak256(add(subject, 0x20), searchLength),
2226             keccak256(add(search, 0x20), searchLength)
2227             )
2228             )
2229         }
2230     }
2231 
2232     /// @dev Returns whether `subject` ends with `search`.
2233     function endsWith(string memory subject, string memory search)
2234     internal
2235     pure
2236     returns (bool result)
2237     {
2238         /// @solidity memory-safe-assembly
2239         assembly {
2240             let searchLength := mload(search)
2241             let subjectLength := mload(subject)
2242         // Whether `search` is not longer than `subject`.
2243             let withinRange := iszero(gt(searchLength, subjectLength))
2244         // Just using keccak256 directly is actually cheaper.
2245         // forgefmt: disable-next-item
2246             result := and(
2247             withinRange,
2248             eq(
2249             keccak256(
2250             // `subject + 0x20 + max(subjectLength - searchLength, 0)`.
2251             add(add(subject, 0x20), mul(withinRange, sub(subjectLength, searchLength))),
2252             searchLength
2253             ),
2254             keccak256(add(search, 0x20), searchLength)
2255             )
2256             )
2257         }
2258     }
2259 
2260     /// @dev Returns `subject` repeated `times`.
2261     function repeat(string memory subject, uint256 times)
2262     internal
2263     pure
2264     returns (string memory result)
2265     {
2266         /// @solidity memory-safe-assembly
2267         assembly {
2268             let subjectLength := mload(subject)
2269             if iszero(or(iszero(times), iszero(subjectLength))) {
2270                 subject := add(subject, 0x20)
2271                 result := mload(0x40)
2272                 let output := add(result, 0x20)
2273                 for {} 1 {} {
2274                 // Copy the `subject` one word at a time.
2275                     for { let o := 0 } 1 {} {
2276                         mstore(add(output, o), mload(add(subject, o)))
2277                         o := add(o, 0x20)
2278                         if iszero(lt(o, subjectLength)) { break }
2279                     }
2280                     output := add(output, subjectLength)
2281                     times := sub(times, 1)
2282                     if iszero(times) { break }
2283                 }
2284                 mstore(output, 0) // Zeroize the slot after the string.
2285                 let resultLength := sub(output, add(result, 0x20))
2286                 mstore(result, resultLength) // Store the length.
2287             // Allocate the memory.
2288                 mstore(0x40, add(result, add(resultLength, 0x20)))
2289             }
2290         }
2291     }
2292 
2293     /// @dev Returns a copy of `subject` sliced from `start` to `end` (exclusive).
2294     /// `start` and `end` are byte offsets.
2295     function slice(string memory subject, uint256 start, uint256 end)
2296     internal
2297     pure
2298     returns (string memory result)
2299     {
2300         /// @solidity memory-safe-assembly
2301         assembly {
2302             let subjectLength := mload(subject)
2303             if iszero(gt(subjectLength, end)) { end := subjectLength }
2304             if iszero(gt(subjectLength, start)) { start := subjectLength }
2305             if lt(start, end) {
2306                 result := mload(0x40)
2307                 let resultLength := sub(end, start)
2308                 mstore(result, resultLength)
2309                 subject := add(subject, start)
2310                 let w := not(0x1f)
2311             // Copy the `subject` one word at a time, backwards.
2312                 for { let o := and(add(resultLength, 0x1f), w) } 1 {} {
2313                     mstore(add(result, o), mload(add(subject, o)))
2314                     o := add(o, w) // `sub(o, 0x20)`.
2315                     if iszero(o) { break }
2316                 }
2317             // Zeroize the slot after the string.
2318                 mstore(add(add(result, 0x20), resultLength), 0)
2319             // Allocate memory for the length and the bytes,
2320             // rounded up to a multiple of 32.
2321                 mstore(0x40, add(result, and(add(resultLength, 0x3f), w)))
2322             }
2323         }
2324     }
2325 
2326     /// @dev Returns a copy of `subject` sliced from `start` to the end of the string.
2327     /// `start` is a byte offset.
2328     function slice(string memory subject, uint256 start)
2329     internal
2330     pure
2331     returns (string memory result)
2332     {
2333         result = slice(subject, start, uint256(int256(-1)));
2334     }
2335 
2336     /// @dev Returns all the indices of `search` in `subject`.
2337     /// The indices are byte offsets.
2338     function indicesOf(string memory subject, string memory search)
2339     internal
2340     pure
2341     returns (uint256[] memory result)
2342     {
2343         /// @solidity memory-safe-assembly
2344         assembly {
2345             let subjectLength := mload(subject)
2346             let searchLength := mload(search)
2347 
2348             if iszero(gt(searchLength, subjectLength)) {
2349                 subject := add(subject, 0x20)
2350                 search := add(search, 0x20)
2351                 result := add(mload(0x40), 0x20)
2352 
2353                 let subjectStart := subject
2354                 let subjectSearchEnd := add(sub(add(subject, subjectLength), searchLength), 1)
2355                 let h := 0
2356                 if iszero(lt(searchLength, 0x20)) { h := keccak256(search, searchLength) }
2357                 let m := shl(3, sub(0x20, and(searchLength, 0x1f)))
2358                 let s := mload(search)
2359                 for {} 1 {} {
2360                     let t := mload(subject)
2361                 // Whether the first `searchLength % 32` bytes of
2362                 // `subject` and `search` matches.
2363                     if iszero(shr(m, xor(t, s))) {
2364                         if h {
2365                             if iszero(eq(keccak256(subject, searchLength), h)) {
2366                                 subject := add(subject, 1)
2367                                 if iszero(lt(subject, subjectSearchEnd)) { break }
2368                                 continue
2369                             }
2370                         }
2371                     // Append to `result`.
2372                         mstore(result, sub(subject, subjectStart))
2373                         result := add(result, 0x20)
2374                     // Advance `subject` by `searchLength`.
2375                         subject := add(subject, searchLength)
2376                         if searchLength {
2377                             if iszero(lt(subject, subjectSearchEnd)) { break }
2378                             continue
2379                         }
2380                     }
2381                     subject := add(subject, 1)
2382                     if iszero(lt(subject, subjectSearchEnd)) { break }
2383                 }
2384                 let resultEnd := result
2385             // Assign `result` to the free memory pointer.
2386                 result := mload(0x40)
2387             // Store the length of `result`.
2388                 mstore(result, shr(5, sub(resultEnd, add(result, 0x20))))
2389             // Allocate memory for result.
2390             // We allocate one more word, so this array can be recycled for {split}.
2391                 mstore(0x40, add(resultEnd, 0x20))
2392             }
2393         }
2394     }
2395 
2396     /// @dev Returns a arrays of strings based on the `delimiter` inside of the `subject` string.
2397     function split(string memory subject, string memory delimiter)
2398     internal
2399     pure
2400     returns (string[] memory result)
2401     {
2402         uint256[] memory indices = indicesOf(subject, delimiter);
2403         /// @solidity memory-safe-assembly
2404         assembly {
2405             let w := not(0x1f)
2406             let indexPtr := add(indices, 0x20)
2407             let indicesEnd := add(indexPtr, shl(5, add(mload(indices), 1)))
2408             mstore(add(indicesEnd, w), mload(subject))
2409             mstore(indices, add(mload(indices), 1))
2410             let prevIndex := 0
2411             for {} 1 {} {
2412                 let index := mload(indexPtr)
2413                 mstore(indexPtr, 0x60)
2414                 if iszero(eq(index, prevIndex)) {
2415                     let element := mload(0x40)
2416                     let elementLength := sub(index, prevIndex)
2417                     mstore(element, elementLength)
2418                 // Copy the `subject` one word at a time, backwards.
2419                     for { let o := and(add(elementLength, 0x1f), w) } 1 {} {
2420                         mstore(add(element, o), mload(add(add(subject, prevIndex), o)))
2421                         o := add(o, w) // `sub(o, 0x20)`.
2422                         if iszero(o) { break }
2423                     }
2424                 // Zeroize the slot after the string.
2425                     mstore(add(add(element, 0x20), elementLength), 0)
2426                 // Allocate memory for the length and the bytes,
2427                 // rounded up to a multiple of 32.
2428                     mstore(0x40, add(element, and(add(elementLength, 0x3f), w)))
2429                 // Store the `element` into the array.
2430                     mstore(indexPtr, element)
2431                 }
2432                 prevIndex := add(index, mload(delimiter))
2433                 indexPtr := add(indexPtr, 0x20)
2434                 if iszero(lt(indexPtr, indicesEnd)) { break }
2435             }
2436             result := indices
2437             if iszero(mload(delimiter)) {
2438                 result := add(indices, 0x20)
2439                 mstore(result, sub(mload(indices), 2))
2440             }
2441         }
2442     }
2443 
2444     /// @dev Returns a concatenated string of `a` and `b`.
2445     /// Cheaper than `string.concat()` and does not de-align the free memory pointer.
2446     function concat(string memory a, string memory b)
2447     internal
2448     pure
2449     returns (string memory result)
2450     {
2451         /// @solidity memory-safe-assembly
2452         assembly {
2453             let w := not(0x1f)
2454             result := mload(0x40)
2455             let aLength := mload(a)
2456         // Copy `a` one word at a time, backwards.
2457             for { let o := and(add(mload(a), 0x20), w) } 1 {} {
2458                 mstore(add(result, o), mload(add(a, o)))
2459                 o := add(o, w) // `sub(o, 0x20)`.
2460                 if iszero(o) { break }
2461             }
2462             let bLength := mload(b)
2463             let output := add(result, mload(a))
2464         // Copy `b` one word at a time, backwards.
2465             for { let o := and(add(bLength, 0x20), w) } 1 {} {
2466                 mstore(add(output, o), mload(add(b, o)))
2467                 o := add(o, w) // `sub(o, 0x20)`.
2468                 if iszero(o) { break }
2469             }
2470             let totalLength := add(aLength, bLength)
2471             let last := add(add(result, 0x20), totalLength)
2472         // Zeroize the slot after the string.
2473             mstore(last, 0)
2474         // Stores the length.
2475             mstore(result, totalLength)
2476         // Allocate memory for the length and the bytes,
2477         // rounded up to a multiple of 32.
2478             mstore(0x40, and(add(last, 0x1f), w))
2479         }
2480     }
2481 
2482     /// @dev Returns a copy of the string in either lowercase or UPPERCASE.
2483     /// WARNING! This function is only compatible with 7-bit ASCII strings.
2484     function toCase(string memory subject, bool toUpper)
2485     internal
2486     pure
2487     returns (string memory result)
2488     {
2489         /// @solidity memory-safe-assembly
2490         assembly {
2491             let length := mload(subject)
2492             if length {
2493                 result := add(mload(0x40), 0x20)
2494                 subject := add(subject, 1)
2495                 let flags := shl(add(70, shl(5, toUpper)), 0x3ffffff)
2496                 let w := not(0)
2497                 for { let o := length } 1 {} {
2498                     o := add(o, w)
2499                     let b := and(0xff, mload(add(subject, o)))
2500                     mstore8(add(result, o), xor(b, and(shr(b, flags), 0x20)))
2501                     if iszero(o) { break }
2502                 }
2503                 result := mload(0x40)
2504                 mstore(result, length) // Store the length.
2505                 let last := add(add(result, 0x20), length)
2506                 mstore(last, 0) // Zeroize the slot after the string.
2507                 mstore(0x40, add(last, 0x20)) // Allocate the memory.
2508             }
2509         }
2510     }
2511 
2512     /// @dev Returns a lowercased copy of the string.
2513     /// WARNING! This function is only compatible with 7-bit ASCII strings.
2514     function lower(string memory subject) internal pure returns (string memory result) {
2515         result = toCase(subject, false);
2516     }
2517 
2518     /// @dev Returns an UPPERCASED copy of the string.
2519     /// WARNING! This function is only compatible with 7-bit ASCII strings.
2520     function upper(string memory subject) internal pure returns (string memory result) {
2521         result = toCase(subject, true);
2522     }
2523 
2524     /// @dev Escapes the string to be used within HTML tags.
2525     function escapeHTML(string memory s) internal pure returns (string memory result) {
2526         /// @solidity memory-safe-assembly
2527         assembly {
2528             for {
2529                 let end := add(s, mload(s))
2530                 result := add(mload(0x40), 0x20)
2531             // Store the bytes of the packed offsets and strides into the scratch space.
2532             // `packed = (stride << 5) | offset`. Max offset is 20. Max stride is 6.
2533                 mstore(0x1f, 0x900094)
2534                 mstore(0x08, 0xc0000000a6ab)
2535             // Store "&quot;&amp;&#39;&lt;&gt;" into the scratch space.
2536                 mstore(0x00, shl(64, 0x2671756f743b26616d703b262333393b266c743b2667743b))
2537             } iszero(eq(s, end)) {} {
2538                 s := add(s, 1)
2539                 let c := and(mload(s), 0xff)
2540             // Not in `["\"","'","&","<",">"]`.
2541                 if iszero(and(shl(c, 1), 0x500000c400000000)) {
2542                     mstore8(result, c)
2543                     result := add(result, 1)
2544                     continue
2545                 }
2546                 let t := shr(248, mload(c))
2547                 mstore(result, mload(and(t, 0x1f)))
2548                 result := add(result, shr(5, t))
2549             }
2550             let last := result
2551             mstore(last, 0) // Zeroize the slot after the string.
2552             result := mload(0x40)
2553             mstore(result, sub(last, add(result, 0x20))) // Store the length.
2554             mstore(0x40, add(last, 0x20)) // Allocate the memory.
2555         }
2556     }
2557 
2558     /// @dev Escapes the string to be used within double-quotes in a JSON.
2559     function escapeJSON(string memory s) internal pure returns (string memory result) {
2560         /// @solidity memory-safe-assembly
2561         assembly {
2562             for {
2563                 let end := add(s, mload(s))
2564                 result := add(mload(0x40), 0x20)
2565             // Store "\\u0000" in scratch space.
2566             // Store "0123456789abcdef" in scratch space.
2567             // Also, store `{0x08:"b", 0x09:"t", 0x0a:"n", 0x0c:"f", 0x0d:"r"}`.
2568             // into the scratch space.
2569                 mstore(0x15, 0x5c75303030303031323334353637383961626364656662746e006672)
2570             // Bitmask for detecting `["\"","\\"]`.
2571                 let e := or(shl(0x22, 1), shl(0x5c, 1))
2572             } iszero(eq(s, end)) {} {
2573                 s := add(s, 1)
2574                 let c := and(mload(s), 0xff)
2575                 if iszero(lt(c, 0x20)) {
2576                     if iszero(and(shl(c, 1), e)) {
2577                     // Not in `["\"","\\"]`.
2578                         mstore8(result, c)
2579                         result := add(result, 1)
2580                         continue
2581                     }
2582                     mstore8(result, 0x5c) // "\\".
2583                     mstore8(add(result, 1), c)
2584                     result := add(result, 2)
2585                     continue
2586                 }
2587                 if iszero(and(shl(c, 1), 0x3700)) {
2588                 // Not in `["\b","\t","\n","\f","\d"]`.
2589                     mstore8(0x1d, mload(shr(4, c))) // Hex value.
2590                     mstore8(0x1e, mload(and(c, 15))) // Hex value.
2591                     mstore(result, mload(0x19)) // "\\u00XX".
2592                     result := add(result, 6)
2593                     continue
2594                 }
2595                 mstore8(result, 0x5c) // "\\".
2596                 mstore8(add(result, 1), mload(add(c, 8)))
2597                 result := add(result, 2)
2598             }
2599             let last := result
2600             mstore(last, 0) // Zeroize the slot after the string.
2601             result := mload(0x40)
2602             mstore(result, sub(last, add(result, 0x20))) // Store the length.
2603             mstore(0x40, add(last, 0x20)) // Allocate the memory.
2604         }
2605     }
2606 
2607     /// @dev Returns whether `a` equals `b`.
2608     function eq(string memory a, string memory b) internal pure returns (bool result) {
2609         assembly {
2610             result := eq(keccak256(add(a, 0x20), mload(a)), keccak256(add(b, 0x20), mload(b)))
2611         }
2612     }
2613 
2614     /// @dev Packs a single string with its length into a single word.
2615     /// Returns `bytes32(0)` if the length is zero or greater than 31.
2616     function packOne(string memory a) internal pure returns (bytes32 result) {
2617         /// @solidity memory-safe-assembly
2618         assembly {
2619         // We don't need to zero right pad the string,
2620         // since this is our own custom non-standard packing scheme.
2621             result :=
2622             mul(
2623             // Load the length and the bytes.
2624             mload(add(a, 0x1f)),
2625             // `length != 0 && length < 32`. Abuses underflow.
2626             // Assumes that the length is valid and within the block gas limit.
2627             lt(sub(mload(a), 1), 0x1f)
2628             )
2629         }
2630     }
2631 
2632     /// @dev Unpacks a string packed using {packOne}.
2633     /// Returns the empty string if `packed` is `bytes32(0)`.
2634     /// If `packed` is not an output of {packOne}, the output behaviour is undefined.
2635     function unpackOne(bytes32 packed) internal pure returns (string memory result) {
2636         /// @solidity memory-safe-assembly
2637         assembly {
2638         // Grab the free memory pointer.
2639             result := mload(0x40)
2640         // Allocate 2 words (1 for the length, 1 for the bytes).
2641             mstore(0x40, add(result, 0x40))
2642         // Zeroize the length slot.
2643             mstore(result, 0)
2644         // Store the length and bytes.
2645             mstore(add(result, 0x1f), packed)
2646         // Right pad with zeroes.
2647             mstore(add(add(result, 0x20), mload(result)), 0)
2648         }
2649     }
2650 
2651     /// @dev Packs two strings with their lengths into a single word.
2652     /// Returns `bytes32(0)` if combined length is zero or greater than 30.
2653     function packTwo(string memory a, string memory b) internal pure returns (bytes32 result) {
2654         /// @solidity memory-safe-assembly
2655         assembly {
2656             let aLength := mload(a)
2657         // We don't need to zero right pad the strings,
2658         // since this is our own custom non-standard packing scheme.
2659             result :=
2660             mul(
2661             // Load the length and the bytes of `a` and `b`.
2662             or(
2663             shl(shl(3, sub(0x1f, aLength)), mload(add(a, aLength))),
2664             mload(sub(add(b, 0x1e), aLength))
2665             ),
2666             // `totalLength != 0 && totalLength < 31`. Abuses underflow.
2667             // Assumes that the lengths are valid and within the block gas limit.
2668             lt(sub(add(aLength, mload(b)), 1), 0x1e)
2669             )
2670         }
2671     }
2672 
2673     /// @dev Unpacks strings packed using {packTwo}.
2674     /// Returns the empty strings if `packed` is `bytes32(0)`.
2675     /// If `packed` is not an output of {packTwo}, the output behaviour is undefined.
2676     function unpackTwo(bytes32 packed)
2677     internal
2678     pure
2679     returns (string memory resultA, string memory resultB)
2680     {
2681         /// @solidity memory-safe-assembly
2682         assembly {
2683         // Grab the free memory pointer.
2684             resultA := mload(0x40)
2685             resultB := add(resultA, 0x40)
2686         // Allocate 2 words for each string (1 for the length, 1 for the byte). Total 4 words.
2687             mstore(0x40, add(resultB, 0x40))
2688         // Zeroize the length slots.
2689             mstore(resultA, 0)
2690             mstore(resultB, 0)
2691         // Store the lengths and bytes.
2692             mstore(add(resultA, 0x1f), packed)
2693             mstore(add(resultB, 0x1f), mload(add(add(resultA, 0x20), mload(resultA))))
2694         // Right pad with zeroes.
2695             mstore(add(add(resultA, 0x20), mload(resultA)), 0)
2696             mstore(add(add(resultB, 0x20), mload(resultB)), 0)
2697         }
2698     }
2699 
2700     /// @dev Directly returns `a` without copying.
2701     function directReturn(string memory a) internal pure {
2702         assembly {
2703         // Assumes that the string does not start from the scratch space.
2704             let retStart := sub(a, 0x20)
2705             let retSize := add(mload(a), 0x40)
2706         // Right pad with zeroes. Just in case the string is produced
2707         // by a method that doesn't zero right pad.
2708             mstore(add(retStart, retSize), 0)
2709         // Store the return offset.
2710             mstore(retStart, 0x20)
2711         // End the transaction, returning the string.
2712             return(retStart, retSize)
2713         }
2714     }
2715 }
2716 
2717 // File: contracts/ERC721r.sol
2718 
2719 
2720 pragma solidity ^0.8.17;
2721 
2722 //import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
2723 
2724 
2725 
2726 //import {ERC721} from "solady/src/tokens/ERC721.sol";
2727 //import {LibPRNG} from "solady/src/utils/LibPRNG.sol";
2728 //import {LibString} from "solady/src/utils/LibString.sol";
2729 
2730 
2731 abstract contract ERC721r is ERC721 {
2732     using LibPRNG for LibPRNG.PRNG;
2733     using LibString for uint256;
2734 
2735     error ContractsCannotMint();
2736     error MustMintAtLeastOneToken();
2737     error NotEnoughAvailableTokens();
2738 
2739     string private _name;
2740     string private _symbol;
2741 
2742     mapping(uint256 => uint256) private _availableTokens;
2743     uint256 public remainingSupply;
2744 
2745     uint256 public immutable maxSupply;
2746 
2747     constructor(string memory name_, string memory symbol_, uint256 maxSupply_) {
2748         _name = name_;
2749         _symbol = symbol_;
2750         maxSupply = maxSupply_;
2751         remainingSupply = maxSupply_;
2752     }
2753 
2754     function totalSupply() public view virtual returns (uint256) {
2755         return maxSupply - remainingSupply;
2756     }
2757 
2758     function name() public view virtual override returns (string memory) {
2759         return _name;
2760     }
2761 
2762     function symbol() public view virtual override returns (string memory) {
2763         return _symbol;
2764     }
2765 
2766     function numberMinted(address minter) public view virtual returns (uint32) {
2767         return uint32(ERC721._getAux(minter) >> 192);
2768     }
2769 
2770     function _mintRandom(address to, uint256 _numToMint) internal virtual {
2771         if (msg.sender != tx.origin) revert ContractsCannotMint();
2772         if (_numToMint == 0) revert MustMintAtLeastOneToken();
2773         if (remainingSupply < _numToMint) revert NotEnoughAvailableTokens();
2774 
2775         LibPRNG.PRNG memory prng = LibPRNG.PRNG(uint256(keccak256(abi.encodePacked(
2776             block.timestamp, block.prevrandao
2777         ))));
2778 
2779         uint256 updatedRemainingSupply = remainingSupply;
2780 
2781         for (uint256 i; i < _numToMint; ) {
2782             uint256 randomIndex = prng.uniform(updatedRemainingSupply);
2783 
2784             uint256 tokenId = getAvailableTokenAtIndex(randomIndex, updatedRemainingSupply);
2785 
2786             _mint(to, tokenId);
2787 
2788             --updatedRemainingSupply;
2789 
2790         unchecked {++i;}
2791         }
2792 
2793         _incrementAmountMinted(to, uint32(_numToMint));
2794         remainingSupply = updatedRemainingSupply;
2795     }
2796 
2797     // Must be called in descending order of index
2798     function _mintAtIndex(address to, uint256 index) internal virtual {
2799         if (msg.sender != tx.origin) revert ContractsCannotMint();
2800         if (remainingSupply == 0) revert NotEnoughAvailableTokens();
2801 
2802         uint256 tokenId = getAvailableTokenAtIndex(index, remainingSupply);
2803 
2804         --remainingSupply;
2805         _incrementAmountMinted(to, 1);
2806 
2807         _mint(to, tokenId);
2808     }
2809 
2810     // Implements https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle. Code taken from CryptoPhunksV2
2811     function getAvailableTokenAtIndex(uint256 indexToUse, uint256 updatedNumAvailableTokens)
2812     private
2813     returns (uint256 result)
2814     {
2815         uint256 valAtIndex = _availableTokens[indexToUse];
2816         uint256 lastIndex = updatedNumAvailableTokens - 1;
2817         uint256 lastValInArray = _availableTokens[lastIndex];
2818 
2819         result = valAtIndex == 0 ? indexToUse : valAtIndex;
2820 
2821         if (indexToUse != lastIndex) {
2822             _availableTokens[indexToUse] = lastValInArray == 0 ? lastIndex : lastValInArray;
2823         }
2824 
2825         if (lastValInArray != 0) {
2826             delete _availableTokens[lastIndex];
2827         }
2828     }
2829 
2830     function _setExtraAddressData(address minter, uint192 extraData) internal virtual {
2831         uint32 numMinted = numberMinted(minter);
2832 
2833         ERC721._setAux(
2834             minter,
2835             uint224((uint256(numMinted) << 192)) | uint224(extraData)
2836         );
2837     }
2838 
2839     function _getAddressExtraData(address minter) internal view virtual returns (uint192) {
2840         return uint192(_getAux(minter));
2841     }
2842 
2843     function _incrementAmountMinted(address minter, uint32 newMints) private {
2844         uint32 numMinted = numberMinted(minter);
2845         uint32 newMintNumMinted = numMinted + uint32(newMints);
2846         uint224 auxData = ERC721._getAux(minter);
2847 
2848         ERC721._setAux(
2849             minter,
2850             uint224(uint256(newMintNumMinted) << 192) | uint224(uint192(auxData))
2851         );
2852     }
2853 }
2854 
2855 // File: contracts/MetaLifeOgPets.sol
2856 
2857 
2858 pragma solidity 0.8.19;
2859 
2860 
2861 
2862 
2863 contract MetaLifeOgPets is ReentrancyGuard, Ownable, ERC721r {
2864 
2865   using Strings for uint256;
2866   string public baseURI;                              // PUBLIC
2867   uint16 public mainMaxSupply = 1500;                // PRIVATE
2868 
2869   uint16 public nbMintedCouncil = 0;
2870   uint16 public nbMintedHonorary = 0;
2871   uint16 public nbMintedGuardian = 0;
2872   uint16 public nbMintedJudge = 0;
2873   uint16 public nbMintedWhale = 0;
2874 
2875   uint16 public maxSupplyCouncil = 305;
2876   uint16 public maxSupplyHonorary = 66;
2877   uint16 public maxSupplyGuardian = 36;
2878   uint16 public maxSupplyJudge = 11;
2879   uint16 public maxSupplyWhale = 26;
2880 
2881   uint256 public limitMintSpecific = 0;
2882   address payable private collector;
2883 
2884   mapping(address => uint8) private addressesRandom;
2885   event MintedRandom(address indexed from, uint256 timestamp);
2886   uint16 private _tokenIdCurrentCouncil = 1057;
2887   mapping(address => uint8) private addressesCouncil;
2888   event MintedCouncil(address indexed from, uint256 timestamp, uint256[] tokenIds);
2889   uint16 private _tokenIdCurrentHonorary = 1362;
2890   mapping(address => uint8) private addressesHonorary;
2891   event MintedHonorary(address indexed from, uint256 timestamp, uint256 tokenId);
2892   uint16 private _tokenIdCurrentGuardian = 1428;
2893   mapping(address => uint8) private addressesGuardian;
2894   event MintedGuardian(address indexed from, uint256 timestamp, uint256 tokenId);
2895   uint16 private _tokenIdCurrentJudge = 1464;
2896   mapping(address => uint8) private addressesJudge;
2897   event MintedJudge(address indexed from, uint256 timestamp, uint256 tokenId);
2898   uint16 private _tokenIdCurrentWhale = 1475;
2899   mapping(address => uint8) private addressesWhale;
2900   event MintedWhale(address indexed from, uint256 timestamp, uint256 tokenId);
2901 
2902   uint16 private tokenGivewayIndex = 0;
2903   mapping(address => uint8) private addressesGiveway;
2904   uint256[] private tokenAvailables;
2905   event MintedGiveway(address indexed from, uint256 timestamp, uint256 tokenId);
2906 
2907   constructor() ERC721r('MetaLife OG Pets', 'MLP', 10_56){
2908     limitMintSpecific = block.timestamp + ((365/2) * 24 * 60 * 60);
2909   }
2910 
2911   function withdrawAll() public payable onlyOwner {
2912     collector.transfer(address(this).balance);
2913   }
2914 
2915   function setCollector(address payable _newCollector) public onlyOwner {
2916     collector = _newCollector;
2917   }
2918 
2919   function _setBaseURI(string memory _newBaseURI) public onlyOwner {
2920     baseURI = _newBaseURI;
2921   }
2922 
2923   function _baseURI() internal view virtual returns (string memory) {
2924     return baseURI;
2925   }
2926 
2927   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2928     require(_exists(tokenId), 'unknow token');
2929 
2930     string memory uri = _baseURI();
2931     return bytes(uri).length > 0 ? string(abi.encodePacked(uri, tokenId.toString())) : "";
2932   }
2933 
2934   function addAddressesRandom(address[] calldata _toAddAddresses, uint8[] calldata _quantities) external onlyOwner {
2935     require(_toAddAddresses.length == _quantities.length, 'Nb address and nb quantities must be equal');
2936     for (uint i = 0; i < _toAddAddresses.length; i++) {
2937       addressesRandom[_toAddAddresses[i]] = _quantities[i];
2938     }
2939   }
2940 
2941   function addAddressesCouncil(address[] calldata _toAddAddresses, uint8[] calldata _quantities) external onlyOwner {
2942     require(_toAddAddresses.length == _quantities.length, 'Nb address and nb quantities must be equal');
2943     for (uint i = 0; i < _toAddAddresses.length; i++) {
2944       addressesCouncil[_toAddAddresses[i]] = _quantities[i];
2945     }
2946   }
2947 
2948   function addAddressesHonorary(address[] calldata _toAddAddresses) external onlyOwner {
2949     for (uint i = 0; i < _toAddAddresses.length; i++) {
2950       addressesHonorary[_toAddAddresses[i]] = 1;
2951     }
2952   }
2953 
2954   function addAddressesGuardian(address[] calldata _toAddAddresses) external onlyOwner {
2955     for (uint i = 0; i < _toAddAddresses.length; i++) {
2956       addressesGuardian[_toAddAddresses[i]] = 1;
2957     }
2958   }
2959 
2960   function addAddressesJudge(address[] calldata _toAddAddresses) external onlyOwner {
2961     for (uint i = 0; i < _toAddAddresses.length; i++) {
2962       addressesJudge[_toAddAddresses[i]] = 1;
2963     }
2964   }
2965 
2966   function addAddressesWhale(address[] calldata _toAddAddresses, uint8[] calldata _quantities) external onlyOwner {
2967     require(_toAddAddresses.length == _quantities.length, 'Nb address and nb quantities must be equal');
2968     for (uint i = 0; i < _toAddAddresses.length; i++) {
2969       addressesWhale[_toAddAddresses[i]] = _quantities[i];
2970     }
2971   }
2972 
2973   function addressClaimbleRandom(address _wallet) public view returns(uint8) {
2974     return addressesRandom[_wallet];
2975   }
2976 
2977   function addressClaimbleCouncil(address _wallet) public view returns(uint8) {
2978     return addressesCouncil[_wallet];
2979   }
2980 
2981   function addressClaimbleHonorary(address _wallet) public view returns(uint8) {
2982     return addressesHonorary[_wallet];
2983   }
2984 
2985   function addressClaimbleGuardian(address _wallet) public view returns(uint8) {
2986     return addressesGuardian[_wallet];
2987   }
2988 
2989   function addressClaimbleJudge(address _wallet) public view returns(uint8) {
2990     return addressesJudge[_wallet];
2991   }
2992 
2993   function addressClaimbleWhale(address _wallet) public view returns(uint8) {
2994     return addressesWhale[_wallet];
2995   }
2996 
2997   function mintRandom(uint8 _nb) external {
2998     require(addressesRandom[msg.sender] > 0, "Not eligible");
2999     require(addressesRandom[msg.sender] >= _nb, "Not enough claimable tokens");
3000     require(maxSupply >= totalSupply() + _nb, "Supply limit exeedx");
3001     require(_nb <= 5, "Limit max");
3002     addressesRandom[msg.sender] = addressesRandom[msg.sender] - _nb;
3003     _mintRandom(msg.sender, _nb);
3004     emit MintedRandom(msg.sender, block.timestamp);
3005   }
3006 
3007   function mainTotalSupply() public view returns (uint256){
3008     return totalSupply() + nbMintedCouncil + nbMintedHonorary + nbMintedGuardian + nbMintedJudge + nbMintedWhale;
3009   }
3010 
3011   function mintCouncil(uint256 _nb) external {
3012     require(block.timestamp < limitMintSpecific, "Council mint close");
3013     require(addressesCouncil[msg.sender] > 0, "Not eligible");
3014     require(addressesCouncil[msg.sender] >= _nb, "Not enough claimable tokens");
3015     require(nbMintedCouncil + 1 <= maxSupplyCouncil, "Max supply council exceed");
3016     require(_nb <= 5, "Limit max");
3017     uint256[] memory _tokenIdsMinted = new uint256[](_nb);
3018     for (uint32 i = 0; i < _nb; i++) {
3019       addressesCouncil[msg.sender]--;
3020       _safeMint(msg.sender, _tokenIdCurrentCouncil);
3021       _tokenIdsMinted[i] = _tokenIdCurrentCouncil;
3022       _tokenIdCurrentCouncil++;
3023       nbMintedCouncil++;
3024     }
3025     emit MintedCouncil(msg.sender, block.timestamp, _tokenIdsMinted);
3026   }
3027 
3028   function mintHonorary() external {
3029     require(block.timestamp < limitMintSpecific, "Honorary mint close");
3030     require(addressesHonorary[msg.sender] > 0, "No giveway");
3031     require(nbMintedHonorary + 1 <= maxSupplyHonorary, "Max supply honorary exceed");
3032     addressesHonorary[msg.sender] = 0;
3033     _safeMint(msg.sender, _tokenIdCurrentHonorary);
3034     emit MintedHonorary(msg.sender, block.timestamp, _tokenIdCurrentHonorary);
3035     _tokenIdCurrentHonorary++;
3036     nbMintedHonorary++;
3037   }
3038 
3039   function mintGuardian() external {
3040     require(block.timestamp < limitMintSpecific, "Guardian mint close");
3041     require(addressesGuardian[msg.sender] > 0, "No giveway");
3042     require(nbMintedGuardian + 1 <= maxSupplyGuardian, "Max supply guardian exceed");
3043     addressesGuardian[msg.sender] = 0;
3044     _safeMint(msg.sender, _tokenIdCurrentGuardian);
3045     emit MintedGuardian(msg.sender, block.timestamp, _tokenIdCurrentGuardian);
3046     _tokenIdCurrentGuardian++;
3047     nbMintedGuardian++;
3048   }
3049 
3050   function mintJudge() external {
3051     require(block.timestamp < limitMintSpecific, "Judge mint close");
3052     require(addressesJudge[msg.sender] > 0, "Not eligible");
3053     require(nbMintedJudge + 1 <= maxSupplyJudge, "Max supply judge exceed");
3054     addressesJudge[msg.sender] = 0;
3055     _safeMint(msg.sender, _tokenIdCurrentJudge);
3056     emit MintedJudge(msg.sender, block.timestamp, _tokenIdCurrentJudge);
3057     _tokenIdCurrentJudge++;
3058     nbMintedJudge++;
3059   }
3060 
3061   function mintWhale() external {
3062     require(block.timestamp < limitMintSpecific, "Whale mint close");
3063     require(addressesWhale[msg.sender] > 0, "No giveway");
3064     require(nbMintedWhale + 1 <= maxSupplyWhale, "Max supply whale exceed");
3065     addressesWhale[msg.sender] = 0;
3066     _safeMint(msg.sender, _tokenIdCurrentWhale);
3067     emit MintedWhale(msg.sender, block.timestamp, _tokenIdCurrentWhale);
3068     _tokenIdCurrentWhale++;
3069     nbMintedWhale++;
3070   }
3071 
3072   function tokenExist(uint256 tokenId) public view returns(bool) {
3073     return _exists(tokenId);
3074   }
3075 
3076   function setTokenAvailables(uint256[] calldata _tokenIdsAvailable) external onlyOwner {
3077     require(block.timestamp > limitMintSpecific, "Giveway not activate");
3078     tokenAvailables = _tokenIdsAvailable;
3079   }
3080 
3081   function getTokenAvailables() public view returns(uint256[] memory) {
3082     return tokenAvailables;
3083   }
3084 
3085   function countTokenAvailables() public view returns(uint256) {
3086     return tokenAvailables.length;
3087   }
3088 
3089   function addAddressesGiveway(address[] calldata _toAddAddresses) external onlyOwner {
3090     for (uint i = 0; i < _toAddAddresses.length; i++) {
3091       addressesGiveway[_toAddAddresses[i]] = 1;
3092     }
3093   }
3094 
3095   function mintGiveway() external {
3096     require(addressesGiveway[msg.sender] > 0, "No giveway");
3097     require(mainMaxSupply >= mainTotalSupply() + 1, "Max supply exceed");
3098     addressesGiveway[msg.sender] = 0;
3099     _safeMint(msg.sender, tokenAvailables[tokenGivewayIndex]);
3100     emit MintedGiveway(msg.sender, block.timestamp, tokenAvailables[tokenGivewayIndex]);
3101     tokenGivewayIndex++;
3102   }
3103 }