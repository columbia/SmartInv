1 // File: contracts/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
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
33 // File: contracts/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
44  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
45  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
46  */
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
58             if (subscribe) {
59                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     OPERATOR_FILTER_REGISTRY.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Allow spending tokens from addresses with balance
72         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
73         // from an EOA.
74         if (from != msg.sender) {
75             _checkFilterOperator(msg.sender);
76         }
77         _;
78     }
79 
80     modifier onlyAllowedOperatorApproval(address operator) virtual {
81         _checkFilterOperator(operator);
82         _;
83     }
84 
85     function _checkFilterOperator(address operator) internal view virtual {
86         // Check registry code length to facilitate testing in environments without a deployed registry.
87         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
88             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
89                 revert OperatorNotAllowed(operator);
90             }
91         }
92     }
93 }
94 
95 // File: contracts/DefaultOperatorFilterer.sol
96 
97 
98 pragma solidity ^0.8.13;
99 
100 
101 /**
102  * @title  DefaultOperatorFilterer
103  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
104  */
105 abstract contract DefaultOperatorFilterer is OperatorFilterer {
106     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
107 
108     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
109 }
110 
111 // File: @openzeppelin/contracts/utils/math/Math.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Standard math utilities missing in the Solidity language.
120  */
121 library Math {
122     enum Rounding {
123         Down, // Toward negative infinity
124         Up, // Toward infinity
125         Zero // Toward zero
126     }
127 
128     /**
129      * @dev Returns the largest of two numbers.
130      */
131     function max(uint256 a, uint256 b) internal pure returns (uint256) {
132         return a > b ? a : b;
133     }
134 
135     /**
136      * @dev Returns the smallest of two numbers.
137      */
138     function min(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a < b ? a : b;
140     }
141 
142     /**
143      * @dev Returns the average of two numbers. The result is rounded towards
144      * zero.
145      */
146     function average(uint256 a, uint256 b) internal pure returns (uint256) {
147         // (a + b) / 2 can overflow.
148         return (a & b) + (a ^ b) / 2;
149     }
150 
151     /**
152      * @dev Returns the ceiling of the division of two numbers.
153      *
154      * This differs from standard division with `/` in that it rounds up instead
155      * of rounding down.
156      */
157     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
158         // (a + b - 1) / b can overflow on addition, so we distribute.
159         return a == 0 ? 0 : (a - 1) / b + 1;
160     }
161 
162     /**
163      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
164      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
165      * with further edits by Uniswap Labs also under MIT license.
166      */
167     function mulDiv(
168         uint256 x,
169         uint256 y,
170         uint256 denominator
171     ) internal pure returns (uint256 result) {
172         unchecked {
173             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
174             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
175             // variables such that product = prod1 * 2^256 + prod0.
176             uint256 prod0; // Least significant 256 bits of the product
177             uint256 prod1; // Most significant 256 bits of the product
178             assembly {
179                 let mm := mulmod(x, y, not(0))
180                 prod0 := mul(x, y)
181                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
182             }
183 
184             // Handle non-overflow cases, 256 by 256 division.
185             if (prod1 == 0) {
186                 return prod0 / denominator;
187             }
188 
189             // Make sure the result is less than 2^256. Also prevents denominator == 0.
190             require(denominator > prod1);
191 
192             ///////////////////////////////////////////////
193             // 512 by 256 division.
194             ///////////////////////////////////////////////
195 
196             // Make division exact by subtracting the remainder from [prod1 prod0].
197             uint256 remainder;
198             assembly {
199                 // Compute remainder using mulmod.
200                 remainder := mulmod(x, y, denominator)
201 
202                 // Subtract 256 bit number from 512 bit number.
203                 prod1 := sub(prod1, gt(remainder, prod0))
204                 prod0 := sub(prod0, remainder)
205             }
206 
207             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
208             // See https://cs.stackexchange.com/q/138556/92363.
209 
210             // Does not overflow because the denominator cannot be zero at this stage in the function.
211             uint256 twos = denominator & (~denominator + 1);
212             assembly {
213                 // Divide denominator by twos.
214                 denominator := div(denominator, twos)
215 
216                 // Divide [prod1 prod0] by twos.
217                 prod0 := div(prod0, twos)
218 
219                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
220                 twos := add(div(sub(0, twos), twos), 1)
221             }
222 
223             // Shift in bits from prod1 into prod0.
224             prod0 |= prod1 * twos;
225 
226             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
227             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
228             // four bits. That is, denominator * inv = 1 mod 2^4.
229             uint256 inverse = (3 * denominator) ^ 2;
230 
231             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
232             // in modular arithmetic, doubling the correct bits in each step.
233             inverse *= 2 - denominator * inverse; // inverse mod 2^8
234             inverse *= 2 - denominator * inverse; // inverse mod 2^16
235             inverse *= 2 - denominator * inverse; // inverse mod 2^32
236             inverse *= 2 - denominator * inverse; // inverse mod 2^64
237             inverse *= 2 - denominator * inverse; // inverse mod 2^128
238             inverse *= 2 - denominator * inverse; // inverse mod 2^256
239 
240             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
241             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
242             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
243             // is no longer required.
244             result = prod0 * inverse;
245             return result;
246         }
247     }
248 
249     /**
250      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
251      */
252     function mulDiv(
253         uint256 x,
254         uint256 y,
255         uint256 denominator,
256         Rounding rounding
257     ) internal pure returns (uint256) {
258         uint256 result = mulDiv(x, y, denominator);
259         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
260             result += 1;
261         }
262         return result;
263     }
264 
265     /**
266      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
267      *
268      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
269      */
270     function sqrt(uint256 a) internal pure returns (uint256) {
271         if (a == 0) {
272             return 0;
273         }
274 
275         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
276         //
277         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
278         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
279         //
280         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
281         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
282         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
283         //
284         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
285         uint256 result = 1 << (log2(a) >> 1);
286 
287         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
288         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
289         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
290         // into the expected uint128 result.
291         unchecked {
292             result = (result + a / result) >> 1;
293             result = (result + a / result) >> 1;
294             result = (result + a / result) >> 1;
295             result = (result + a / result) >> 1;
296             result = (result + a / result) >> 1;
297             result = (result + a / result) >> 1;
298             result = (result + a / result) >> 1;
299             return min(result, a / result);
300         }
301     }
302 
303     /**
304      * @notice Calculates sqrt(a), following the selected rounding direction.
305      */
306     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
307         unchecked {
308             uint256 result = sqrt(a);
309             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
310         }
311     }
312 
313     /**
314      * @dev Return the log in base 2, rounded down, of a positive value.
315      * Returns 0 if given 0.
316      */
317     function log2(uint256 value) internal pure returns (uint256) {
318         uint256 result = 0;
319         unchecked {
320             if (value >> 128 > 0) {
321                 value >>= 128;
322                 result += 128;
323             }
324             if (value >> 64 > 0) {
325                 value >>= 64;
326                 result += 64;
327             }
328             if (value >> 32 > 0) {
329                 value >>= 32;
330                 result += 32;
331             }
332             if (value >> 16 > 0) {
333                 value >>= 16;
334                 result += 16;
335             }
336             if (value >> 8 > 0) {
337                 value >>= 8;
338                 result += 8;
339             }
340             if (value >> 4 > 0) {
341                 value >>= 4;
342                 result += 4;
343             }
344             if (value >> 2 > 0) {
345                 value >>= 2;
346                 result += 2;
347             }
348             if (value >> 1 > 0) {
349                 result += 1;
350             }
351         }
352         return result;
353     }
354 
355     /**
356      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
357      * Returns 0 if given 0.
358      */
359     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
360         unchecked {
361             uint256 result = log2(value);
362             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
363         }
364     }
365 
366     /**
367      * @dev Return the log in base 10, rounded down, of a positive value.
368      * Returns 0 if given 0.
369      */
370     function log10(uint256 value) internal pure returns (uint256) {
371         uint256 result = 0;
372         unchecked {
373             if (value >= 10**64) {
374                 value /= 10**64;
375                 result += 64;
376             }
377             if (value >= 10**32) {
378                 value /= 10**32;
379                 result += 32;
380             }
381             if (value >= 10**16) {
382                 value /= 10**16;
383                 result += 16;
384             }
385             if (value >= 10**8) {
386                 value /= 10**8;
387                 result += 8;
388             }
389             if (value >= 10**4) {
390                 value /= 10**4;
391                 result += 4;
392             }
393             if (value >= 10**2) {
394                 value /= 10**2;
395                 result += 2;
396             }
397             if (value >= 10**1) {
398                 result += 1;
399             }
400         }
401         return result;
402     }
403 
404     /**
405      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
406      * Returns 0 if given 0.
407      */
408     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
409         unchecked {
410             uint256 result = log10(value);
411             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
412         }
413     }
414 
415     /**
416      * @dev Return the log in base 256, rounded down, of a positive value.
417      * Returns 0 if given 0.
418      *
419      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
420      */
421     function log256(uint256 value) internal pure returns (uint256) {
422         uint256 result = 0;
423         unchecked {
424             if (value >> 128 > 0) {
425                 value >>= 128;
426                 result += 16;
427             }
428             if (value >> 64 > 0) {
429                 value >>= 64;
430                 result += 8;
431             }
432             if (value >> 32 > 0) {
433                 value >>= 32;
434                 result += 4;
435             }
436             if (value >> 16 > 0) {
437                 value >>= 16;
438                 result += 2;
439             }
440             if (value >> 8 > 0) {
441                 result += 1;
442             }
443         }
444         return result;
445     }
446 
447     /**
448      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
449      * Returns 0 if given 0.
450      */
451     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
452         unchecked {
453             uint256 result = log256(value);
454             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
455         }
456     }
457 }
458 
459 // File: @openzeppelin/contracts/utils/Strings.sol
460 
461 
462 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev String operations.
469  */
470 library Strings {
471     bytes16 private constant _SYMBOLS = "0123456789abcdef";
472     uint8 private constant _ADDRESS_LENGTH = 20;
473 
474     /**
475      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
476      */
477     function toString(uint256 value) internal pure returns (string memory) {
478         unchecked {
479             uint256 length = Math.log10(value) + 1;
480             string memory buffer = new string(length);
481             uint256 ptr;
482             /// @solidity memory-safe-assembly
483             assembly {
484                 ptr := add(buffer, add(32, length))
485             }
486             while (true) {
487                 ptr--;
488                 /// @solidity memory-safe-assembly
489                 assembly {
490                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
491                 }
492                 value /= 10;
493                 if (value == 0) break;
494             }
495             return buffer;
496         }
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
501      */
502     function toHexString(uint256 value) internal pure returns (string memory) {
503         unchecked {
504             return toHexString(value, Math.log256(value) + 1);
505         }
506     }
507 
508     /**
509      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
510      */
511     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
512         bytes memory buffer = new bytes(2 * length + 2);
513         buffer[0] = "0";
514         buffer[1] = "x";
515         for (uint256 i = 2 * length + 1; i > 1; --i) {
516             buffer[i] = _SYMBOLS[value & 0xf];
517             value >>= 4;
518         }
519         require(value == 0, "Strings: hex length insufficient");
520         return string(buffer);
521     }
522 
523     /**
524      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
525      */
526     function toHexString(address addr) internal pure returns (string memory) {
527         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
528     }
529 }
530 
531 // File: @openzeppelin/contracts/utils/Context.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @dev Provides information about the current execution context, including the
540  * sender of the transaction and its data. While these are generally available
541  * via msg.sender and msg.data, they should not be accessed in such a direct
542  * manner, since when dealing with meta-transactions the account sending and
543  * paying for execution may not be the actual sender (as far as an application
544  * is concerned).
545  *
546  * This contract is only required for intermediate, library-like contracts.
547  */
548 abstract contract Context {
549     function _msgSender() internal view virtual returns (address) {
550         return msg.sender;
551     }
552 
553     function _msgData() internal view virtual returns (bytes calldata) {
554         return msg.data;
555     }
556 }
557 
558 // File: @openzeppelin/contracts/access/Ownable.sol
559 
560 
561 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @dev Contract module which provides a basic access control mechanism, where
568  * there is an account (an owner) that can be granted exclusive access to
569  * specific functions.
570  *
571  * By default, the owner account will be the one that deploys the contract. This
572  * can later be changed with {transferOwnership}.
573  *
574  * This module is used through inheritance. It will make available the modifier
575  * `onlyOwner`, which can be applied to your functions to restrict their use to
576  * the owner.
577  */
578 abstract contract Ownable is Context {
579     address private _owner;
580 
581     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
582 
583     /**
584      * @dev Initializes the contract setting the deployer as the initial owner.
585      */
586     constructor() {
587         _transferOwnership(_msgSender());
588     }
589 
590     /**
591      * @dev Throws if called by any account other than the owner.
592      */
593     modifier onlyOwner() {
594         _checkOwner();
595         _;
596     }
597 
598     /**
599      * @dev Returns the address of the current owner.
600      */
601     function owner() public view virtual returns (address) {
602         return _owner;
603     }
604 
605     /**
606      * @dev Throws if the sender is not the owner.
607      */
608     function _checkOwner() internal view virtual {
609         require(owner() == _msgSender(), "Ownable: caller is not the owner");
610     }
611 
612     /**
613      * @dev Leaves the contract without owner. It will not be possible to call
614      * `onlyOwner` functions anymore. Can only be called by the current owner.
615      *
616      * NOTE: Renouncing ownership will leave the contract without an owner,
617      * thereby removing any functionality that is only available to the owner.
618      */
619     function renounceOwnership() public virtual onlyOwner {
620         _transferOwnership(address(0));
621     }
622 
623     /**
624      * @dev Transfers ownership of the contract to a new account (`newOwner`).
625      * Can only be called by the current owner.
626      */
627     function transferOwnership(address newOwner) public virtual onlyOwner {
628         require(newOwner != address(0), "Ownable: new owner is the zero address");
629         _transferOwnership(newOwner);
630     }
631 
632     /**
633      * @dev Transfers ownership of the contract to a new account (`newOwner`).
634      * Internal function without access restriction.
635      */
636     function _transferOwnership(address newOwner) internal virtual {
637         address oldOwner = _owner;
638         _owner = newOwner;
639         emit OwnershipTransferred(oldOwner, newOwner);
640     }
641 }
642 
643 // File: erc721a/contracts/IERC721A.sol
644 
645 
646 // ERC721A Contracts v4.2.3
647 // Creator: Chiru Labs
648 
649 pragma solidity ^0.8.4;
650 
651 /**
652  * @dev Interface of ERC721A.
653  */
654 interface IERC721A {
655     /**
656      * The caller must own the token or be an approved operator.
657      */
658     error ApprovalCallerNotOwnerNorApproved();
659 
660     /**
661      * The token does not exist.
662      */
663     error ApprovalQueryForNonexistentToken();
664 
665     /**
666      * Cannot query the balance for the zero address.
667      */
668     error BalanceQueryForZeroAddress();
669 
670     /**
671      * Cannot mint to the zero address.
672      */
673     error MintToZeroAddress();
674 
675     /**
676      * The quantity of tokens minted must be more than zero.
677      */
678     error MintZeroQuantity();
679 
680     /**
681      * The token does not exist.
682      */
683     error OwnerQueryForNonexistentToken();
684 
685     /**
686      * The caller must own the token or be an approved operator.
687      */
688     error TransferCallerNotOwnerNorApproved();
689 
690     /**
691      * The token must be owned by `from`.
692      */
693     error TransferFromIncorrectOwner();
694 
695     /**
696      * Cannot safely transfer to a contract that does not implement the
697      * ERC721Receiver interface.
698      */
699     error TransferToNonERC721ReceiverImplementer();
700 
701     /**
702      * Cannot transfer to the zero address.
703      */
704     error TransferToZeroAddress();
705 
706     /**
707      * The token does not exist.
708      */
709     error URIQueryForNonexistentToken();
710 
711     /**
712      * The `quantity` minted with ERC2309 exceeds the safety limit.
713      */
714     error MintERC2309QuantityExceedsLimit();
715 
716     /**
717      * The `extraData` cannot be set on an unintialized ownership slot.
718      */
719     error OwnershipNotInitializedForExtraData();
720 
721     // =============================================================
722     //                            STRUCTS
723     // =============================================================
724 
725     struct TokenOwnership {
726         // The address of the owner.
727         address addr;
728         // Stores the start time of ownership with minimal overhead for tokenomics.
729         uint64 startTimestamp;
730         // Whether the token has been burned.
731         bool burned;
732         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
733         uint24 extraData;
734     }
735 
736     // =============================================================
737     //                         TOKEN COUNTERS
738     // =============================================================
739 
740     /**
741      * @dev Returns the total number of tokens in existence.
742      * Burned tokens will reduce the count.
743      * To get the total number of tokens minted, please see {_totalMinted}.
744      */
745     function totalSupply() external view returns (uint256);
746 
747     // =============================================================
748     //                            IERC165
749     // =============================================================
750 
751     /**
752      * @dev Returns true if this contract implements the interface defined by
753      * `interfaceId`. See the corresponding
754      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
755      * to learn more about how these ids are created.
756      *
757      * This function call must use less than 30000 gas.
758      */
759     function supportsInterface(bytes4 interfaceId) external view returns (bool);
760 
761     // =============================================================
762     //                            IERC721
763     // =============================================================
764 
765     /**
766      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
767      */
768     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
769 
770     /**
771      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
772      */
773     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
774 
775     /**
776      * @dev Emitted when `owner` enables or disables
777      * (`approved`) `operator` to manage all of its assets.
778      */
779     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
780 
781     /**
782      * @dev Returns the number of tokens in `owner`'s account.
783      */
784     function balanceOf(address owner) external view returns (uint256 balance);
785 
786     /**
787      * @dev Returns the owner of the `tokenId` token.
788      *
789      * Requirements:
790      *
791      * - `tokenId` must exist.
792      */
793     function ownerOf(uint256 tokenId) external view returns (address owner);
794 
795     /**
796      * @dev Safely transfers `tokenId` token from `from` to `to`,
797      * checking first that contract recipients are aware of the ERC721 protocol
798      * to prevent tokens from being forever locked.
799      *
800      * Requirements:
801      *
802      * - `from` cannot be the zero address.
803      * - `to` cannot be the zero address.
804      * - `tokenId` token must exist and be owned by `from`.
805      * - If the caller is not `from`, it must be have been allowed to move
806      * this token by either {approve} or {setApprovalForAll}.
807      * - If `to` refers to a smart contract, it must implement
808      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
809      *
810      * Emits a {Transfer} event.
811      */
812     function safeTransferFrom(
813         address from,
814         address to,
815         uint256 tokenId,
816         bytes calldata data
817     ) external payable;
818 
819     /**
820      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) external payable;
827 
828     /**
829      * @dev Transfers `tokenId` from `from` to `to`.
830      *
831      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
832      * whenever possible.
833      *
834      * Requirements:
835      *
836      * - `from` cannot be the zero address.
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must be owned by `from`.
839      * - If the caller is not `from`, it must be approved to move this token
840      * by either {approve} or {setApprovalForAll}.
841      *
842      * Emits a {Transfer} event.
843      */
844     function transferFrom(
845         address from,
846         address to,
847         uint256 tokenId
848     ) external payable;
849 
850     /**
851      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
852      * The approval is cleared when the token is transferred.
853      *
854      * Only a single account can be approved at a time, so approving the
855      * zero address clears previous approvals.
856      *
857      * Requirements:
858      *
859      * - The caller must own the token or be an approved operator.
860      * - `tokenId` must exist.
861      *
862      * Emits an {Approval} event.
863      */
864     function approve(address to, uint256 tokenId) external payable;
865 
866     /**
867      * @dev Approve or remove `operator` as an operator for the caller.
868      * Operators can call {transferFrom} or {safeTransferFrom}
869      * for any token owned by the caller.
870      *
871      * Requirements:
872      *
873      * - The `operator` cannot be the caller.
874      *
875      * Emits an {ApprovalForAll} event.
876      */
877     function setApprovalForAll(address operator, bool _approved) external;
878 
879     /**
880      * @dev Returns the account approved for `tokenId` token.
881      *
882      * Requirements:
883      *
884      * - `tokenId` must exist.
885      */
886     function getApproved(uint256 tokenId) external view returns (address operator);
887 
888     /**
889      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
890      *
891      * See {setApprovalForAll}.
892      */
893     function isApprovedForAll(address owner, address operator) external view returns (bool);
894 
895     // =============================================================
896     //                        IERC721Metadata
897     // =============================================================
898 
899     /**
900      * @dev Returns the token collection name.
901      */
902     function name() external view returns (string memory);
903 
904     /**
905      * @dev Returns the token collection symbol.
906      */
907     function symbol() external view returns (string memory);
908 
909     /**
910      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
911      */
912     function tokenURI(uint256 tokenId) external view returns (string memory);
913 
914     // =============================================================
915     //                           IERC2309
916     // =============================================================
917 
918     /**
919      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
920      * (inclusive) is transferred from `from` to `to`, as defined in the
921      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
922      *
923      * See {_mintERC2309} for more details.
924      */
925     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
926 }
927 
928 // File: erc721a/contracts/ERC721A.sol
929 
930 
931 // ERC721A Contracts v4.2.3
932 // Creator: Chiru Labs
933 
934 pragma solidity ^0.8.4;
935 
936 
937 /**
938  * @dev Interface of ERC721 token receiver.
939  */
940 interface ERC721A__IERC721Receiver {
941     function onERC721Received(
942         address operator,
943         address from,
944         uint256 tokenId,
945         bytes calldata data
946     ) external returns (bytes4);
947 }
948 
949 /**
950  * @title ERC721A
951  *
952  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
953  * Non-Fungible Token Standard, including the Metadata extension.
954  * Optimized for lower gas during batch mints.
955  *
956  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
957  * starting from `_startTokenId()`.
958  *
959  * Assumptions:
960  *
961  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
962  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
963  */
964 contract ERC721A is IERC721A {
965     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
966     struct TokenApprovalRef {
967         address value;
968     }
969 
970     // =============================================================
971     //                           CONSTANTS
972     // =============================================================
973 
974     // Mask of an entry in packed address data.
975     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
976 
977     // The bit position of `numberMinted` in packed address data.
978     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
979 
980     // The bit position of `numberBurned` in packed address data.
981     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
982 
983     // The bit position of `aux` in packed address data.
984     uint256 private constant _BITPOS_AUX = 192;
985 
986     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
987     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
988 
989     // The bit position of `startTimestamp` in packed ownership.
990     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
991 
992     // The bit mask of the `burned` bit in packed ownership.
993     uint256 private constant _BITMASK_BURNED = 1 << 224;
994 
995     // The bit position of the `nextInitialized` bit in packed ownership.
996     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
997 
998     // The bit mask of the `nextInitialized` bit in packed ownership.
999     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1000 
1001     // The bit position of `extraData` in packed ownership.
1002     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1003 
1004     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1005     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1006 
1007     // The mask of the lower 160 bits for addresses.
1008     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1009 
1010     // The maximum `quantity` that can be minted with {_mintERC2309}.
1011     // This limit is to prevent overflows on the address data entries.
1012     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1013     // is required to cause an overflow, which is unrealistic.
1014     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1015 
1016     // The `Transfer` event signature is given by:
1017     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1018     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1019         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1020 
1021     // =============================================================
1022     //                            STORAGE
1023     // =============================================================
1024 
1025     // The next token ID to be minted.
1026     uint256 private _currentIndex;
1027 
1028     // The number of tokens burned.
1029     uint256 private _burnCounter;
1030 
1031     // Token name
1032     string private _name;
1033 
1034     // Token symbol
1035     string private _symbol;
1036 
1037     // Mapping from token ID to ownership details
1038     // An empty struct value does not necessarily mean the token is unowned.
1039     // See {_packedOwnershipOf} implementation for details.
1040     //
1041     // Bits Layout:
1042     // - [0..159]   `addr`
1043     // - [160..223] `startTimestamp`
1044     // - [224]      `burned`
1045     // - [225]      `nextInitialized`
1046     // - [232..255] `extraData`
1047     mapping(uint256 => uint256) private _packedOwnerships;
1048 
1049     // Mapping owner address to address data.
1050     //
1051     // Bits Layout:
1052     // - [0..63]    `balance`
1053     // - [64..127]  `numberMinted`
1054     // - [128..191] `numberBurned`
1055     // - [192..255] `aux`
1056     mapping(address => uint256) private _packedAddressData;
1057 
1058     // Mapping from token ID to approved address.
1059     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1060 
1061     // Mapping from owner to operator approvals
1062     mapping(address => mapping(address => bool)) private _operatorApprovals;
1063 
1064     // =============================================================
1065     //                          CONSTRUCTOR
1066     // =============================================================
1067 
1068     constructor(string memory name_, string memory symbol_) {
1069         _name = name_;
1070         _symbol = symbol_;
1071         _currentIndex = _startTokenId();
1072     }
1073 
1074     // =============================================================
1075     //                   TOKEN COUNTING OPERATIONS
1076     // =============================================================
1077 
1078     /**
1079      * @dev Returns the starting token ID.
1080      * To change the starting token ID, please override this function.
1081      */
1082     function _startTokenId() internal view virtual returns (uint256) {
1083         return 0;
1084     }
1085 
1086     /**
1087      * @dev Returns the next token ID to be minted.
1088      */
1089     function _nextTokenId() internal view virtual returns (uint256) {
1090         return _currentIndex;
1091     }
1092 
1093     /**
1094      * @dev Returns the total number of tokens in existence.
1095      * Burned tokens will reduce the count.
1096      * To get the total number of tokens minted, please see {_totalMinted}.
1097      */
1098     function totalSupply() public view virtual override returns (uint256) {
1099         // Counter underflow is impossible as _burnCounter cannot be incremented
1100         // more than `_currentIndex - _startTokenId()` times.
1101         unchecked {
1102             return _currentIndex - _burnCounter - _startTokenId();
1103         }
1104     }
1105 
1106     /**
1107      * @dev Returns the total amount of tokens minted in the contract.
1108      */
1109     function _totalMinted() internal view virtual returns (uint256) {
1110         // Counter underflow is impossible as `_currentIndex` does not decrement,
1111         // and it is initialized to `_startTokenId()`.
1112         unchecked {
1113             return _currentIndex - _startTokenId();
1114         }
1115     }
1116 
1117     /**
1118      * @dev Returns the total number of tokens burned.
1119      */
1120     function _totalBurned() internal view virtual returns (uint256) {
1121         return _burnCounter;
1122     }
1123 
1124     // =============================================================
1125     //                    ADDRESS DATA OPERATIONS
1126     // =============================================================
1127 
1128     /**
1129      * @dev Returns the number of tokens in `owner`'s account.
1130      */
1131     function balanceOf(address owner) public view virtual override returns (uint256) {
1132         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1133         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1134     }
1135 
1136     /**
1137      * Returns the number of tokens minted by `owner`.
1138      */
1139     function _numberMinted(address owner) internal view returns (uint256) {
1140         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1141     }
1142 
1143     /**
1144      * Returns the number of tokens burned by or on behalf of `owner`.
1145      */
1146     function _numberBurned(address owner) internal view returns (uint256) {
1147         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1148     }
1149 
1150     /**
1151      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1152      */
1153     function _getAux(address owner) internal view returns (uint64) {
1154         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1155     }
1156 
1157     /**
1158      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1159      * If there are multiple variables, please pack them into a uint64.
1160      */
1161     function _setAux(address owner, uint64 aux) internal virtual {
1162         uint256 packed = _packedAddressData[owner];
1163         uint256 auxCasted;
1164         // Cast `aux` with assembly to avoid redundant masking.
1165         assembly {
1166             auxCasted := aux
1167         }
1168         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1169         _packedAddressData[owner] = packed;
1170     }
1171 
1172     // =============================================================
1173     //                            IERC165
1174     // =============================================================
1175 
1176     /**
1177      * @dev Returns true if this contract implements the interface defined by
1178      * `interfaceId`. See the corresponding
1179      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1180      * to learn more about how these ids are created.
1181      *
1182      * This function call must use less than 30000 gas.
1183      */
1184     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1185         // The interface IDs are constants representing the first 4 bytes
1186         // of the XOR of all function selectors in the interface.
1187         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1188         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1189         return
1190             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1191             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1192             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1193     }
1194 
1195     // =============================================================
1196     //                        IERC721Metadata
1197     // =============================================================
1198 
1199     /**
1200      * @dev Returns the token collection name.
1201      */
1202     function name() public view virtual override returns (string memory) {
1203         return _name;
1204     }
1205 
1206     /**
1207      * @dev Returns the token collection symbol.
1208      */
1209     function symbol() public view virtual override returns (string memory) {
1210         return _symbol;
1211     }
1212 
1213     /**
1214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1215      */
1216     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1217         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1218 
1219         string memory baseURI = _baseURI();
1220         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1221     }
1222 
1223     /**
1224      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1225      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1226      * by default, it can be overridden in child contracts.
1227      */
1228     function _baseURI() internal view virtual returns (string memory) {
1229         return '';
1230     }
1231 
1232     // =============================================================
1233     //                     OWNERSHIPS OPERATIONS
1234     // =============================================================
1235 
1236     /**
1237      * @dev Returns the owner of the `tokenId` token.
1238      *
1239      * Requirements:
1240      *
1241      * - `tokenId` must exist.
1242      */
1243     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1244         return address(uint160(_packedOwnershipOf(tokenId)));
1245     }
1246 
1247     /**
1248      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1249      * It gradually moves to O(1) as tokens get transferred around over time.
1250      */
1251     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1252         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1253     }
1254 
1255     /**
1256      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1257      */
1258     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1259         return _unpackedOwnership(_packedOwnerships[index]);
1260     }
1261 
1262     /**
1263      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1264      */
1265     function _initializeOwnershipAt(uint256 index) internal virtual {
1266         if (_packedOwnerships[index] == 0) {
1267             _packedOwnerships[index] = _packedOwnershipOf(index);
1268         }
1269     }
1270 
1271     /**
1272      * Returns the packed ownership data of `tokenId`.
1273      */
1274     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1275         uint256 curr = tokenId;
1276 
1277         unchecked {
1278             if (_startTokenId() <= curr)
1279                 if (curr < _currentIndex) {
1280                     uint256 packed = _packedOwnerships[curr];
1281                     // If not burned.
1282                     if (packed & _BITMASK_BURNED == 0) {
1283                         // Invariant:
1284                         // There will always be an initialized ownership slot
1285                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1286                         // before an unintialized ownership slot
1287                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1288                         // Hence, `curr` will not underflow.
1289                         //
1290                         // We can directly compare the packed value.
1291                         // If the address is zero, packed will be zero.
1292                         while (packed == 0) {
1293                             packed = _packedOwnerships[--curr];
1294                         }
1295                         return packed;
1296                     }
1297                 }
1298         }
1299         revert OwnerQueryForNonexistentToken();
1300     }
1301 
1302     /**
1303      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1304      */
1305     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1306         ownership.addr = address(uint160(packed));
1307         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1308         ownership.burned = packed & _BITMASK_BURNED != 0;
1309         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1310     }
1311 
1312     /**
1313      * @dev Packs ownership data into a single uint256.
1314      */
1315     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1316         assembly {
1317             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1318             owner := and(owner, _BITMASK_ADDRESS)
1319             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1320             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1321         }
1322     }
1323 
1324     /**
1325      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1326      */
1327     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1328         // For branchless setting of the `nextInitialized` flag.
1329         assembly {
1330             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1331             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1332         }
1333     }
1334 
1335     // =============================================================
1336     //                      APPROVAL OPERATIONS
1337     // =============================================================
1338 
1339     /**
1340      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1341      * The approval is cleared when the token is transferred.
1342      *
1343      * Only a single account can be approved at a time, so approving the
1344      * zero address clears previous approvals.
1345      *
1346      * Requirements:
1347      *
1348      * - The caller must own the token or be an approved operator.
1349      * - `tokenId` must exist.
1350      *
1351      * Emits an {Approval} event.
1352      */
1353     function approve(address to, uint256 tokenId) public payable virtual override {
1354         address owner = ownerOf(tokenId);
1355 
1356         if (_msgSenderERC721A() != owner)
1357             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1358                 revert ApprovalCallerNotOwnerNorApproved();
1359             }
1360 
1361         _tokenApprovals[tokenId].value = to;
1362         emit Approval(owner, to, tokenId);
1363     }
1364 
1365     /**
1366      * @dev Returns the account approved for `tokenId` token.
1367      *
1368      * Requirements:
1369      *
1370      * - `tokenId` must exist.
1371      */
1372     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1373         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1374 
1375         return _tokenApprovals[tokenId].value;
1376     }
1377 
1378     /**
1379      * @dev Approve or remove `operator` as an operator for the caller.
1380      * Operators can call {transferFrom} or {safeTransferFrom}
1381      * for any token owned by the caller.
1382      *
1383      * Requirements:
1384      *
1385      * - The `operator` cannot be the caller.
1386      *
1387      * Emits an {ApprovalForAll} event.
1388      */
1389     function setApprovalForAll(address operator, bool approved) public virtual override {
1390         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1391         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1392     }
1393 
1394     /**
1395      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1396      *
1397      * See {setApprovalForAll}.
1398      */
1399     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1400         return _operatorApprovals[owner][operator];
1401     }
1402 
1403     /**
1404      * @dev Returns whether `tokenId` exists.
1405      *
1406      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1407      *
1408      * Tokens start existing when they are minted. See {_mint}.
1409      */
1410     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1411         return
1412             _startTokenId() <= tokenId &&
1413             tokenId < _currentIndex && // If within bounds,
1414             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1415     }
1416 
1417     /**
1418      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1419      */
1420     function _isSenderApprovedOrOwner(
1421         address approvedAddress,
1422         address owner,
1423         address msgSender
1424     ) private pure returns (bool result) {
1425         assembly {
1426             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1427             owner := and(owner, _BITMASK_ADDRESS)
1428             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1429             msgSender := and(msgSender, _BITMASK_ADDRESS)
1430             // `msgSender == owner || msgSender == approvedAddress`.
1431             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1432         }
1433     }
1434 
1435     /**
1436      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1437      */
1438     function _getApprovedSlotAndAddress(uint256 tokenId)
1439         private
1440         view
1441         returns (uint256 approvedAddressSlot, address approvedAddress)
1442     {
1443         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1444         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1445         assembly {
1446             approvedAddressSlot := tokenApproval.slot
1447             approvedAddress := sload(approvedAddressSlot)
1448         }
1449     }
1450 
1451     // =============================================================
1452     //                      TRANSFER OPERATIONS
1453     // =============================================================
1454 
1455     /**
1456      * @dev Transfers `tokenId` from `from` to `to`.
1457      *
1458      * Requirements:
1459      *
1460      * - `from` cannot be the zero address.
1461      * - `to` cannot be the zero address.
1462      * - `tokenId` token must be owned by `from`.
1463      * - If the caller is not `from`, it must be approved to move this token
1464      * by either {approve} or {setApprovalForAll}.
1465      *
1466      * Emits a {Transfer} event.
1467      */
1468     function transferFrom(
1469         address from,
1470         address to,
1471         uint256 tokenId
1472     ) public payable virtual override {
1473         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1474 
1475         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1476 
1477         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1478 
1479         // The nested ifs save around 20+ gas over a compound boolean condition.
1480         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1481             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1482 
1483         if (to == address(0)) revert TransferToZeroAddress();
1484 
1485         _beforeTokenTransfers(from, to, tokenId, 1);
1486 
1487         // Clear approvals from the previous owner.
1488         assembly {
1489             if approvedAddress {
1490                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1491                 sstore(approvedAddressSlot, 0)
1492             }
1493         }
1494 
1495         // Underflow of the sender's balance is impossible because we check for
1496         // ownership above and the recipient's balance can't realistically overflow.
1497         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1498         unchecked {
1499             // We can directly increment and decrement the balances.
1500             --_packedAddressData[from]; // Updates: `balance -= 1`.
1501             ++_packedAddressData[to]; // Updates: `balance += 1`.
1502 
1503             // Updates:
1504             // - `address` to the next owner.
1505             // - `startTimestamp` to the timestamp of transfering.
1506             // - `burned` to `false`.
1507             // - `nextInitialized` to `true`.
1508             _packedOwnerships[tokenId] = _packOwnershipData(
1509                 to,
1510                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1511             );
1512 
1513             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1514             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1515                 uint256 nextTokenId = tokenId + 1;
1516                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1517                 if (_packedOwnerships[nextTokenId] == 0) {
1518                     // If the next slot is within bounds.
1519                     if (nextTokenId != _currentIndex) {
1520                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1521                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1522                     }
1523                 }
1524             }
1525         }
1526 
1527         emit Transfer(from, to, tokenId);
1528         _afterTokenTransfers(from, to, tokenId, 1);
1529     }
1530 
1531     /**
1532      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1533      */
1534     function safeTransferFrom(
1535         address from,
1536         address to,
1537         uint256 tokenId
1538     ) public payable virtual override {
1539         safeTransferFrom(from, to, tokenId, '');
1540     }
1541 
1542     /**
1543      * @dev Safely transfers `tokenId` token from `from` to `to`.
1544      *
1545      * Requirements:
1546      *
1547      * - `from` cannot be the zero address.
1548      * - `to` cannot be the zero address.
1549      * - `tokenId` token must exist and be owned by `from`.
1550      * - If the caller is not `from`, it must be approved to move this token
1551      * by either {approve} or {setApprovalForAll}.
1552      * - If `to` refers to a smart contract, it must implement
1553      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1554      *
1555      * Emits a {Transfer} event.
1556      */
1557     function safeTransferFrom(
1558         address from,
1559         address to,
1560         uint256 tokenId,
1561         bytes memory _data
1562     ) public payable virtual override {
1563         transferFrom(from, to, tokenId);
1564         if (to.code.length != 0)
1565             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1566                 revert TransferToNonERC721ReceiverImplementer();
1567             }
1568     }
1569 
1570     /**
1571      * @dev Hook that is called before a set of serially-ordered token IDs
1572      * are about to be transferred. This includes minting.
1573      * And also called before burning one token.
1574      *
1575      * `startTokenId` - the first token ID to be transferred.
1576      * `quantity` - the amount to be transferred.
1577      *
1578      * Calling conditions:
1579      *
1580      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1581      * transferred to `to`.
1582      * - When `from` is zero, `tokenId` will be minted for `to`.
1583      * - When `to` is zero, `tokenId` will be burned by `from`.
1584      * - `from` and `to` are never both zero.
1585      */
1586     function _beforeTokenTransfers(
1587         address from,
1588         address to,
1589         uint256 startTokenId,
1590         uint256 quantity
1591     ) internal virtual {}
1592 
1593     /**
1594      * @dev Hook that is called after a set of serially-ordered token IDs
1595      * have been transferred. This includes minting.
1596      * And also called after one token has been burned.
1597      *
1598      * `startTokenId` - the first token ID to be transferred.
1599      * `quantity` - the amount to be transferred.
1600      *
1601      * Calling conditions:
1602      *
1603      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1604      * transferred to `to`.
1605      * - When `from` is zero, `tokenId` has been minted for `to`.
1606      * - When `to` is zero, `tokenId` has been burned by `from`.
1607      * - `from` and `to` are never both zero.
1608      */
1609     function _afterTokenTransfers(
1610         address from,
1611         address to,
1612         uint256 startTokenId,
1613         uint256 quantity
1614     ) internal virtual {}
1615 
1616     /**
1617      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1618      *
1619      * `from` - Previous owner of the given token ID.
1620      * `to` - Target address that will receive the token.
1621      * `tokenId` - Token ID to be transferred.
1622      * `_data` - Optional data to send along with the call.
1623      *
1624      * Returns whether the call correctly returned the expected magic value.
1625      */
1626     function _checkContractOnERC721Received(
1627         address from,
1628         address to,
1629         uint256 tokenId,
1630         bytes memory _data
1631     ) private returns (bool) {
1632         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1633             bytes4 retval
1634         ) {
1635             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1636         } catch (bytes memory reason) {
1637             if (reason.length == 0) {
1638                 revert TransferToNonERC721ReceiverImplementer();
1639             } else {
1640                 assembly {
1641                     revert(add(32, reason), mload(reason))
1642                 }
1643             }
1644         }
1645     }
1646 
1647     // =============================================================
1648     //                        MINT OPERATIONS
1649     // =============================================================
1650 
1651     /**
1652      * @dev Mints `quantity` tokens and transfers them to `to`.
1653      *
1654      * Requirements:
1655      *
1656      * - `to` cannot be the zero address.
1657      * - `quantity` must be greater than 0.
1658      *
1659      * Emits a {Transfer} event for each mint.
1660      */
1661     function _mint(address to, uint256 quantity) internal virtual {
1662         uint256 startTokenId = _currentIndex;
1663         if (quantity == 0) revert MintZeroQuantity();
1664 
1665         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1666 
1667         // Overflows are incredibly unrealistic.
1668         // `balance` and `numberMinted` have a maximum limit of 2**64.
1669         // `tokenId` has a maximum limit of 2**256.
1670         unchecked {
1671             // Updates:
1672             // - `balance += quantity`.
1673             // - `numberMinted += quantity`.
1674             //
1675             // We can directly add to the `balance` and `numberMinted`.
1676             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1677 
1678             // Updates:
1679             // - `address` to the owner.
1680             // - `startTimestamp` to the timestamp of minting.
1681             // - `burned` to `false`.
1682             // - `nextInitialized` to `quantity == 1`.
1683             _packedOwnerships[startTokenId] = _packOwnershipData(
1684                 to,
1685                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1686             );
1687 
1688             uint256 toMasked;
1689             uint256 end = startTokenId + quantity;
1690 
1691             // Use assembly to loop and emit the `Transfer` event for gas savings.
1692             // The duplicated `log4` removes an extra check and reduces stack juggling.
1693             // The assembly, together with the surrounding Solidity code, have been
1694             // delicately arranged to nudge the compiler into producing optimized opcodes.
1695             assembly {
1696                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1697                 toMasked := and(to, _BITMASK_ADDRESS)
1698                 // Emit the `Transfer` event.
1699                 log4(
1700                     0, // Start of data (0, since no data).
1701                     0, // End of data (0, since no data).
1702                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1703                     0, // `address(0)`.
1704                     toMasked, // `to`.
1705                     startTokenId // `tokenId`.
1706                 )
1707 
1708                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1709                 // that overflows uint256 will make the loop run out of gas.
1710                 // The compiler will optimize the `iszero` away for performance.
1711                 for {
1712                     let tokenId := add(startTokenId, 1)
1713                 } iszero(eq(tokenId, end)) {
1714                     tokenId := add(tokenId, 1)
1715                 } {
1716                     // Emit the `Transfer` event. Similar to above.
1717                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1718                 }
1719             }
1720             if (toMasked == 0) revert MintToZeroAddress();
1721 
1722             _currentIndex = end;
1723         }
1724         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1725     }
1726 
1727     /**
1728      * @dev Mints `quantity` tokens and transfers them to `to`.
1729      *
1730      * This function is intended for efficient minting only during contract creation.
1731      *
1732      * It emits only one {ConsecutiveTransfer} as defined in
1733      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1734      * instead of a sequence of {Transfer} event(s).
1735      *
1736      * Calling this function outside of contract creation WILL make your contract
1737      * non-compliant with the ERC721 standard.
1738      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1739      * {ConsecutiveTransfer} event is only permissible during contract creation.
1740      *
1741      * Requirements:
1742      *
1743      * - `to` cannot be the zero address.
1744      * - `quantity` must be greater than 0.
1745      *
1746      * Emits a {ConsecutiveTransfer} event.
1747      */
1748     function _mintERC2309(address to, uint256 quantity) internal virtual {
1749         uint256 startTokenId = _currentIndex;
1750         if (to == address(0)) revert MintToZeroAddress();
1751         if (quantity == 0) revert MintZeroQuantity();
1752         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1753 
1754         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1755 
1756         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1757         unchecked {
1758             // Updates:
1759             // - `balance += quantity`.
1760             // - `numberMinted += quantity`.
1761             //
1762             // We can directly add to the `balance` and `numberMinted`.
1763             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1764 
1765             // Updates:
1766             // - `address` to the owner.
1767             // - `startTimestamp` to the timestamp of minting.
1768             // - `burned` to `false`.
1769             // - `nextInitialized` to `quantity == 1`.
1770             _packedOwnerships[startTokenId] = _packOwnershipData(
1771                 to,
1772                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1773             );
1774 
1775             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1776 
1777             _currentIndex = startTokenId + quantity;
1778         }
1779         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1780     }
1781 
1782     /**
1783      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1784      *
1785      * Requirements:
1786      *
1787      * - If `to` refers to a smart contract, it must implement
1788      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1789      * - `quantity` must be greater than 0.
1790      *
1791      * See {_mint}.
1792      *
1793      * Emits a {Transfer} event for each mint.
1794      */
1795     function _safeMint(
1796         address to,
1797         uint256 quantity,
1798         bytes memory _data
1799     ) internal virtual {
1800         _mint(to, quantity);
1801 
1802         unchecked {
1803             if (to.code.length != 0) {
1804                 uint256 end = _currentIndex;
1805                 uint256 index = end - quantity;
1806                 do {
1807                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1808                         revert TransferToNonERC721ReceiverImplementer();
1809                     }
1810                 } while (index < end);
1811                 // Reentrancy protection.
1812                 if (_currentIndex != end) revert();
1813             }
1814         }
1815     }
1816 
1817     /**
1818      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1819      */
1820     function _safeMint(address to, uint256 quantity) internal virtual {
1821         _safeMint(to, quantity, '');
1822     }
1823 
1824     // =============================================================
1825     //                        BURN OPERATIONS
1826     // =============================================================
1827 
1828     /**
1829      * @dev Equivalent to `_burn(tokenId, false)`.
1830      */
1831     function _burn(uint256 tokenId) internal virtual {
1832         _burn(tokenId, false);
1833     }
1834 
1835     /**
1836      * @dev Destroys `tokenId`.
1837      * The approval is cleared when the token is burned.
1838      *
1839      * Requirements:
1840      *
1841      * - `tokenId` must exist.
1842      *
1843      * Emits a {Transfer} event.
1844      */
1845     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1846         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1847 
1848         address from = address(uint160(prevOwnershipPacked));
1849 
1850         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1851 
1852         if (approvalCheck) {
1853             // The nested ifs save around 20+ gas over a compound boolean condition.
1854             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1855                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1856         }
1857 
1858         _beforeTokenTransfers(from, address(0), tokenId, 1);
1859 
1860         // Clear approvals from the previous owner.
1861         assembly {
1862             if approvedAddress {
1863                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1864                 sstore(approvedAddressSlot, 0)
1865             }
1866         }
1867 
1868         // Underflow of the sender's balance is impossible because we check for
1869         // ownership above and the recipient's balance can't realistically overflow.
1870         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1871         unchecked {
1872             // Updates:
1873             // - `balance -= 1`.
1874             // - `numberBurned += 1`.
1875             //
1876             // We can directly decrement the balance, and increment the number burned.
1877             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1878             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1879 
1880             // Updates:
1881             // - `address` to the last owner.
1882             // - `startTimestamp` to the timestamp of burning.
1883             // - `burned` to `true`.
1884             // - `nextInitialized` to `true`.
1885             _packedOwnerships[tokenId] = _packOwnershipData(
1886                 from,
1887                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1888             );
1889 
1890             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1891             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1892                 uint256 nextTokenId = tokenId + 1;
1893                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1894                 if (_packedOwnerships[nextTokenId] == 0) {
1895                     // If the next slot is within bounds.
1896                     if (nextTokenId != _currentIndex) {
1897                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1898                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1899                     }
1900                 }
1901             }
1902         }
1903 
1904         emit Transfer(from, address(0), tokenId);
1905         _afterTokenTransfers(from, address(0), tokenId, 1);
1906 
1907         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1908         unchecked {
1909             _burnCounter++;
1910         }
1911     }
1912 
1913     // =============================================================
1914     //                     EXTRA DATA OPERATIONS
1915     // =============================================================
1916 
1917     /**
1918      * @dev Directly sets the extra data for the ownership data `index`.
1919      */
1920     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1921         uint256 packed = _packedOwnerships[index];
1922         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1923         uint256 extraDataCasted;
1924         // Cast `extraData` with assembly to avoid redundant masking.
1925         assembly {
1926             extraDataCasted := extraData
1927         }
1928         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1929         _packedOwnerships[index] = packed;
1930     }
1931 
1932     /**
1933      * @dev Called during each token transfer to set the 24bit `extraData` field.
1934      * Intended to be overridden by the cosumer contract.
1935      *
1936      * `previousExtraData` - the value of `extraData` before transfer.
1937      *
1938      * Calling conditions:
1939      *
1940      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1941      * transferred to `to`.
1942      * - When `from` is zero, `tokenId` will be minted for `to`.
1943      * - When `to` is zero, `tokenId` will be burned by `from`.
1944      * - `from` and `to` are never both zero.
1945      */
1946     function _extraData(
1947         address from,
1948         address to,
1949         uint24 previousExtraData
1950     ) internal view virtual returns (uint24) {}
1951 
1952     /**
1953      * @dev Returns the next extra data for the packed ownership data.
1954      * The returned result is shifted into position.
1955      */
1956     function _nextExtraData(
1957         address from,
1958         address to,
1959         uint256 prevOwnershipPacked
1960     ) private view returns (uint256) {
1961         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1962         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1963     }
1964 
1965     // =============================================================
1966     //                       OTHER OPERATIONS
1967     // =============================================================
1968 
1969     /**
1970      * @dev Returns the message sender (defaults to `msg.sender`).
1971      *
1972      * If you are writing GSN compatible contracts, you need to override this function.
1973      */
1974     function _msgSenderERC721A() internal view virtual returns (address) {
1975         return msg.sender;
1976     }
1977 
1978     /**
1979      * @dev Converts a uint256 to its ASCII string decimal representation.
1980      */
1981     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1982         assembly {
1983             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1984             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1985             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1986             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1987             let m := add(mload(0x40), 0xa0)
1988             // Update the free memory pointer to allocate.
1989             mstore(0x40, m)
1990             // Assign the `str` to the end.
1991             str := sub(m, 0x20)
1992             // Zeroize the slot after the string.
1993             mstore(str, 0)
1994 
1995             // Cache the end of the memory to calculate the length later.
1996             let end := str
1997 
1998             // We write the string from rightmost digit to leftmost digit.
1999             // The following is essentially a do-while loop that also handles the zero case.
2000             // prettier-ignore
2001             for { let temp := value } 1 {} {
2002                 str := sub(str, 1)
2003                 // Write the character to the pointer.
2004                 // The ASCII index of the '0' character is 48.
2005                 mstore8(str, add(48, mod(temp, 10)))
2006                 // Keep dividing `temp` until zero.
2007                 temp := div(temp, 10)
2008                 // prettier-ignore
2009                 if iszero(temp) { break }
2010             }
2011 
2012             let length := sub(end, str)
2013             // Move the pointer 32 bytes leftwards to make room for the length.
2014             str := sub(str, 0x20)
2015             // Store the length.
2016             mstore(str, length)
2017         }
2018     }
2019 }
2020 
2021 // File: contracts/BTC Hoomans.sol
2022 
2023 //SPDX-License-Identifier: MIT
2024 
2025 pragma solidity ^0.8.4;
2026 
2027 
2028 
2029 
2030 
2031 /*
2032 
2033 Bitcoin Hoomans NFT.sol
2034 Bitcoin Hoomans are the first ever BTC x ETH hybird PFP Collection launching in ETH which gets will be inscribed below 5 digit in the Ordinal Chain which is called as BTC NFTs
2035 Helping you gets the piece of history in bitcoin blockchain
2036 
2037 */
2038 
2039 contract BitcoinHoomansNFT is Ownable, DefaultOperatorFilterer, ERC721A {
2040     uint256 public MAX_SUPPLY = 1000;
2041     uint256 public TEAM_MINT_MAX = 2;
2042 
2043     uint256 public publicPrice = 0.05 ether;
2044 
2045     uint256 public PUBLIC_MINT_LIMIT_TXN = 10;
2046     uint256 public PUBLIC_MINT_LIMIT = 10;
2047 
2048     uint256 public TOTAL_SUPPLY_TEAM;
2049 
2050     string public revealedURI;
2051 
2052     string public hiddenURI = "https://bafybeidsstdcom6ojlqsexyi3efgmbr6drx5257pvftg7u5gxkce4lee2y.ipfs.nftstorage.link/";
2053     
2054     // OpenSea CONTRACT_URI - https://docs.opensea.io/docs/contract-level-metadata
2055     string public CONTRACT_URI = "https://bafybeidsstdcom6ojlqsexyi3efgmbr6drx5257pvftg7u5gxkce4lee2y.ipfs.nftstorage.link/";
2056 
2057     bool public paused = false;
2058     bool public revealed = false;
2059 
2060     bool public freeSale = true;
2061     bool public publicSale = false;
2062 
2063     address constant internal FOUNDER_ADDRESS = 0x71A3C80dA4d1Bc4887Ee63811747F2085Ec5D9aD;
2064     address public teamWallet = 0x71A3C80dA4d1Bc4887Ee63811747F2085Ec5D9aD;
2065 
2066     mapping(address => bool) public userMintedFree;
2067     mapping(address => uint256) public numUserMints;
2068 
2069     constructor() ERC721A("BitcoinHoomansNFT", "BTCHOOMANS") { }
2070 
2071     /*
2072      *
2073      Private Function                                                                                                                               
2074     *
2075     */
2076 
2077     function _startTokenId() internal view virtual override returns (uint256) {
2078         return 1;
2079     }
2080 
2081     function refundOverpay(uint256 price) private {
2082         if (msg.value > price) {
2083             (bool succ, ) = payable(msg.sender).call{
2084                 value: (msg.value - price)
2085             }("");
2086             require(succ, "Transfer failed");
2087         }
2088         else if (msg.value < price) {
2089             revert("Not enough ETH sent");
2090         }
2091     }
2092 
2093     /*
2094      *
2095      Public Function
2096     *
2097     */
2098 
2099     function teamMint(uint256 quantity) public payable mintCompliance(quantity) {
2100         require(msg.sender == teamWallet, "Team minting only");
2101         require(TOTAL_SUPPLY_TEAM + quantity <= TEAM_MINT_MAX, "No team mints left");
2102         require(totalSupply() >= 200, "Team mints after free");
2103 
2104         TOTAL_SUPPLY_TEAM += quantity;
2105 
2106         _safeMint(msg.sender, quantity);
2107     }
2108     
2109     function freeMint(uint256 quantity) external payable mintCompliance(quantity) {
2110         require(freeSale, "Free sale inactive");
2111         require(msg.value == 0, "This phase is free");
2112         require(quantity == 1, "Only 1 free");
2113 
2114         uint256 newSupply = totalSupply() + quantity;
2115         
2116         require(newSupply <= 200, "Not enough free supply");
2117 
2118         require(!userMintedFree[msg.sender], "User max free limit");
2119         
2120         userMintedFree[msg.sender] = true;
2121 
2122         if(newSupply == 200) {
2123             freeSale = false;
2124             publicSale = true;
2125         }
2126 
2127         _safeMint(msg.sender, quantity);
2128     }
2129 
2130     function publicMint(uint256 quantity) external payable mintCompliance(quantity) {
2131         require(publicSale, "Public sale inactive");
2132         require(quantity <= PUBLIC_MINT_LIMIT_TXN, "Quantity too high");
2133 
2134         uint256 price = publicPrice;
2135         uint256 currMints = numUserMints[msg.sender];
2136                 
2137         require(currMints + quantity <= PUBLIC_MINT_LIMIT, "User max mint limit");
2138         
2139         refundOverpay(price * quantity);
2140 
2141         numUserMints[msg.sender] = (currMints + quantity);
2142 
2143         _safeMint(msg.sender, quantity);
2144     }
2145 
2146     /*
2147      *
2148      View Function
2149     *
2150     */
2151 
2152     function walletOfOwner(address _owner) public view returns (uint256[] memory)
2153     {
2154         uint256 ownerTokenCount = balanceOf(_owner);
2155         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2156         uint256 currentTokenId = 1;
2157         uint256 ownedTokenIndex = 0;
2158 
2159         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
2160             address currentTokenOwner = ownerOf(currentTokenId);
2161 
2162             if (currentTokenOwner == _owner) {
2163                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
2164 
2165                 ownedTokenIndex++;
2166             }
2167 
2168         currentTokenId++;
2169         }
2170 
2171         return ownedTokenIds;
2172     }
2173 
2174     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
2175         // Note: You don't REALLY need this require statement since nothing should be querying for non-existing tokens after reveal.
2176             // That said, it's a public view method so gas efficiency shouldn't come into play.
2177         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2178         
2179         if (revealed) {
2180             return string(abi.encodePacked(revealedURI, Strings.toString(_tokenId), ".json"));
2181         }
2182         else {
2183             return hiddenURI;
2184         }
2185     }
2186 
2187     // https://docs.opensea.io/docs/contract-level-metadata
2188     // https://ethereum.stackexchange.com/questions/110924/how-to-properly-implement-a-contracturi-for-on-chain-nfts
2189     function contractURI() public view returns (string memory) {
2190         return CONTRACT_URI;
2191     }
2192 
2193     /*
2194      *
2195      Owner Function
2196      *
2197      */
2198 
2199     function setTeamMintMax(uint256 _teamMintMax) public onlyOwner {
2200         TEAM_MINT_MAX = _teamMintMax;
2201     }
2202 
2203     function setSupplyMax(uint256 _supplyMax) public onlyOwner {
2204         MAX_SUPPLY = _supplyMax;
2205     }
2206 
2207      function setPublicmintlimit(uint256 _publicmintlimit) public onlyOwner {
2208         PUBLIC_MINT_LIMIT = _publicmintlimit;
2209     }
2210 
2211     function setPublicmintperTransaction(uint256 _publicmintper) public onlyOwner {
2212         PUBLIC_MINT_LIMIT_TXN = _publicmintper;
2213     }
2214 
2215     function setPublicPrice(uint256 _newpublicPrice) external onlyOwner {
2216         publicPrice = _newpublicPrice;
2217     }
2218 
2219     function setBaseURI(string memory _baseUri) public onlyOwner {
2220         revealedURI = _baseUri;
2221     }
2222 
2223 
2224     // Note: This method can be hidden/removed if this is a constant.
2225     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2226         hiddenURI = _hiddenMetadataUri;
2227     }
2228 
2229     function revealCollection(bool _revealed, string memory _baseUri) public onlyOwner {
2230         revealed = _revealed;
2231         revealedURI = _baseUri;
2232     }
2233 
2234     // https://docs.opensea.io/docs/contract-level-metadata
2235     function setContractURI(string memory _contractURI) public onlyOwner {
2236         CONTRACT_URI = _contractURI;
2237     }
2238 
2239     // Note: Another option is to inherit Pausable without implementing the logic yourself.
2240         // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol
2241     function setPaused(bool _state) public onlyOwner {
2242         paused = _state;
2243     }
2244 
2245     function setRevealed(bool _state) public onlyOwner {
2246         revealed = _state;
2247     }
2248 
2249     function setPublicEnabled(bool _state) public onlyOwner {
2250         publicSale = _state;
2251         freeSale = !_state;
2252     }
2253     function setFreeEnabled(bool _state) public onlyOwner {
2254         freeSale = _state;
2255         publicSale = !_state;
2256     }
2257 
2258     function setTeamWalletAddress(address _teamWallet) public onlyOwner {
2259         teamWallet = _teamWallet;
2260     }
2261 
2262     function withdraw() external payable onlyOwner {
2263         // Get the current funds to calculate initial percentages
2264         uint256 currBalance = address(this).balance;
2265 
2266         (bool succ, ) = payable(FOUNDER_ADDRESS).call{
2267             value: (currBalance * 1000) / 10000
2268         }("");
2269         require(succ, "Founder transfer failed");
2270 
2271         // Withdraw the ENTIRE remaining balance to the team wallet
2272         (succ, ) = payable(teamWallet).call{
2273             value: address(this).balance
2274         }("");
2275         require(succ, "Team (remaining) transfer failed");
2276     }
2277 
2278     // Owner-only mint functionality to "Airdrop" mints to specific users
2279         // Note: These will likely end up hidden on OpenSea
2280     function mintToUser(uint256 quantity, address receiver) public onlyOwner mintCompliance(quantity) {
2281         _safeMint(receiver, quantity);
2282     }
2283 
2284     /*
2285      *
2286      Modifier 
2287     *
2288     */
2289 
2290     modifier mintCompliance(uint256 quantity) {
2291         require(!paused, "Contract is paused");
2292         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough mints left");
2293         require(tx.origin == msg.sender, "No contract minting");
2294         _;
2295     }
2296 
2297     
2298     /////////////////////////////
2299     // OPENSEA FILTER REGISTRY 
2300     /////////////////////////////
2301 
2302     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2303         super.setApprovalForAll(operator, approved);
2304     }
2305 
2306     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2307         super.approve(operator, tokenId);
2308     }
2309 
2310     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2311         super.transferFrom(from, to, tokenId);
2312     }
2313 
2314     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2315         super.safeTransferFrom(from, to, tokenId);
2316     }
2317 
2318     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2319         public
2320         payable
2321         override
2322         onlyAllowedOperator(from)
2323     {
2324         super.safeTransferFrom(from, to, tokenId, data);
2325     }
2326 
2327 }