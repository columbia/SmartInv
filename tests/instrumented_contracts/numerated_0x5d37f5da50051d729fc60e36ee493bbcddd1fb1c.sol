1 // SPDX-License-Identifier: MIT
2 
3 
4 // OpenZeppelin Contracts v4.4.1 
5 
6 pragma solidity ^0.8.0;
7 
8 // import "./IERC165-SupportsInterface.sol";
9 
10 ///
11 /// @dev Interface for the NFT Royalty Standard
12 ///
13 interface IERC2981 {
14     /// ERC165 bytes to add to interface array - set in parent contract
15     /// implementing this standard
16     ///
17     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
18     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
19     /// _registerInterface(_INTERFACE_ID_ERC2981);
20 
21     /// @notice Called with the sale price to determine how much royalty
22     //          is owed and to whom.
23     /// @param _tokenId - the NFT asset queried for royalty information
24     /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
25     /// @return receiver - address of who should be sent the royalty payment
26     /// @return royaltyAmount - the royalty payment amount for _salePrice
27     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (
28         address receiver,
29         uint256 royaltyAmount
30     );
31 }
32 // File: evm-contracts/src/RiserBotz/IERC173-Ownable.sol
33 
34 
35 
36 pragma solidity 0.8.13;
37 
38 interface IOwnable {
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40     function owner() external view returns (address);
41     function transferOwnership(address newOwner) external;
42 }
43 
44 // File: evm-contracts/src/RiserBotz/ErrorNotZeroAddress.sol
45 
46 
47 
48 pragma solidity 0.8.13;
49 
50 error NotZeroAddress();    // 0x66385fa3
51 error CallerNotApproved(); // 0x4014f1a5
52 error InvalidAddress();    // 0xe6c4247b
53 // File: evm-contracts/src/RiserBotz/IOperatorFilterRegistry.sol
54 
55 
56 pragma solidity ^0.8.13;
57 
58 interface IOperatorFilterRegistry {
59     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
60     function register(address registrant) external;
61     function registerAndSubscribe(address registrant, address subscription) external;
62     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
63     function unregister(address addr) external;
64     function updateOperator(address registrant, address operator, bool filtered) external;
65     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
66     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
67     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
68     function subscribe(address registrant, address registrantToSubscribe) external;
69     function unsubscribe(address registrant, bool copyExistingEntries) external;
70     function subscriptionOf(address addr) external returns (address registrant);
71     function subscribers(address registrant) external returns (address[] memory);
72     function subscriberAt(address registrant, uint256 index) external returns (address);
73     function copyEntriesOf(address registrant, address registrantToCopy) external;
74     function isOperatorFiltered(address registrant, address operator) external returns (bool);
75     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
76     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
77     function filteredOperators(address addr) external returns (address[] memory);
78     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
79     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
80     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
81     function isRegistered(address addr) external returns (bool);
82     function codeHashOf(address addr) external returns (bytes32);
83 }
84 // File: @openzeppelin/contracts/utils/math/Math.sol
85 
86 
87 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Standard math utilities missing in the Solidity language.
93  */
94 library Math {
95     enum Rounding {
96         Down, // Toward negative infinity
97         Up, // Toward infinity
98         Zero // Toward zero
99     }
100 
101     /**
102      * @dev Returns the largest of two numbers.
103      */
104     function max(uint256 a, uint256 b) internal pure returns (uint256) {
105         return a > b ? a : b;
106     }
107 
108     /**
109      * @dev Returns the smallest of two numbers.
110      */
111     function min(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a < b ? a : b;
113     }
114 
115     /**
116      * @dev Returns the average of two numbers. The result is rounded towards
117      * zero.
118      */
119     function average(uint256 a, uint256 b) internal pure returns (uint256) {
120         // (a + b) / 2 can overflow.
121         return (a & b) + (a ^ b) / 2;
122     }
123 
124     /**
125      * @dev Returns the ceiling of the division of two numbers.
126      *
127      * This differs from standard division with `/` in that it rounds up instead
128      * of rounding down.
129      */
130     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
131         // (a + b - 1) / b can overflow on addition, so we distribute.
132         return a == 0 ? 0 : (a - 1) / b + 1;
133     }
134 
135     /**
136      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
137      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
138      * with further edits by Uniswap Labs also under MIT license.
139      */
140     function mulDiv(
141         uint256 x,
142         uint256 y,
143         uint256 denominator
144     ) internal pure returns (uint256 result) {
145         unchecked {
146             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
147             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
148             // variables such that product = prod1 * 2^256 + prod0.
149             uint256 prod0; // Least significant 256 bits of the product
150             uint256 prod1; // Most significant 256 bits of the product
151             assembly {
152                 let mm := mulmod(x, y, not(0))
153                 prod0 := mul(x, y)
154                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
155             }
156 
157             // Handle non-overflow cases, 256 by 256 division.
158             if (prod1 == 0) {
159                 return prod0 / denominator;
160             }
161 
162             // Make sure the result is less than 2^256. Also prevents denominator == 0.
163             require(denominator > prod1);
164 
165             ///////////////////////////////////////////////
166             // 512 by 256 division.
167             ///////////////////////////////////////////////
168 
169             // Make division exact by subtracting the remainder from [prod1 prod0].
170             uint256 remainder;
171             assembly {
172                 // Compute remainder using mulmod.
173                 remainder := mulmod(x, y, denominator)
174 
175                 // Subtract 256 bit number from 512 bit number.
176                 prod1 := sub(prod1, gt(remainder, prod0))
177                 prod0 := sub(prod0, remainder)
178             }
179 
180             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
181             // See https://cs.stackexchange.com/q/138556/92363.
182 
183             // Does not overflow because the denominator cannot be zero at this stage in the function.
184             uint256 twos = denominator & (~denominator + 1);
185             assembly {
186                 // Divide denominator by twos.
187                 denominator := div(denominator, twos)
188 
189                 // Divide [prod1 prod0] by twos.
190                 prod0 := div(prod0, twos)
191 
192                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
193                 twos := add(div(sub(0, twos), twos), 1)
194             }
195 
196             // Shift in bits from prod1 into prod0.
197             prod0 |= prod1 * twos;
198 
199             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
200             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
201             // four bits. That is, denominator * inv = 1 mod 2^4.
202             uint256 inverse = (3 * denominator) ^ 2;
203 
204             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
205             // in modular arithmetic, doubling the correct bits in each step.
206             inverse *= 2 - denominator * inverse; // inverse mod 2^8
207             inverse *= 2 - denominator * inverse; // inverse mod 2^16
208             inverse *= 2 - denominator * inverse; // inverse mod 2^32
209             inverse *= 2 - denominator * inverse; // inverse mod 2^64
210             inverse *= 2 - denominator * inverse; // inverse mod 2^128
211             inverse *= 2 - denominator * inverse; // inverse mod 2^256
212 
213             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
214             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
215             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
216             // is no longer required.
217             result = prod0 * inverse;
218             return result;
219         }
220     }
221 
222     /**
223      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
224      */
225     function mulDiv(
226         uint256 x,
227         uint256 y,
228         uint256 denominator,
229         Rounding rounding
230     ) internal pure returns (uint256) {
231         uint256 result = mulDiv(x, y, denominator);
232         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
233             result += 1;
234         }
235         return result;
236     }
237 
238     /**
239      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
240      *
241      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
242      */
243     function sqrt(uint256 a) internal pure returns (uint256) {
244         if (a == 0) {
245             return 0;
246         }
247 
248         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
249         //
250         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
251         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
252         //
253         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
254         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
255         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
256         //
257         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
258         uint256 result = 1 << (log2(a) >> 1);
259 
260         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
261         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
262         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
263         // into the expected uint128 result.
264         unchecked {
265             result = (result + a / result) >> 1;
266             result = (result + a / result) >> 1;
267             result = (result + a / result) >> 1;
268             result = (result + a / result) >> 1;
269             result = (result + a / result) >> 1;
270             result = (result + a / result) >> 1;
271             result = (result + a / result) >> 1;
272             return min(result, a / result);
273         }
274     }
275 
276     /**
277      * @notice Calculates sqrt(a), following the selected rounding direction.
278      */
279     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
280         unchecked {
281             uint256 result = sqrt(a);
282             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
283         }
284     }
285 
286     /**
287      * @dev Return the log in base 2, rounded down, of a positive value.
288      * Returns 0 if given 0.
289      */
290     function log2(uint256 value) internal pure returns (uint256) {
291         uint256 result = 0;
292         unchecked {
293             if (value >> 128 > 0) {
294                 value >>= 128;
295                 result += 128;
296             }
297             if (value >> 64 > 0) {
298                 value >>= 64;
299                 result += 64;
300             }
301             if (value >> 32 > 0) {
302                 value >>= 32;
303                 result += 32;
304             }
305             if (value >> 16 > 0) {
306                 value >>= 16;
307                 result += 16;
308             }
309             if (value >> 8 > 0) {
310                 value >>= 8;
311                 result += 8;
312             }
313             if (value >> 4 > 0) {
314                 value >>= 4;
315                 result += 4;
316             }
317             if (value >> 2 > 0) {
318                 value >>= 2;
319                 result += 2;
320             }
321             if (value >> 1 > 0) {
322                 result += 1;
323             }
324         }
325         return result;
326     }
327 
328     /**
329      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
330      * Returns 0 if given 0.
331      */
332     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
333         unchecked {
334             uint256 result = log2(value);
335             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
336         }
337     }
338 
339     /**
340      * @dev Return the log in base 10, rounded down, of a positive value.
341      * Returns 0 if given 0.
342      */
343     function log10(uint256 value) internal pure returns (uint256) {
344         uint256 result = 0;
345         unchecked {
346             if (value >= 10**64) {
347                 value /= 10**64;
348                 result += 64;
349             }
350             if (value >= 10**32) {
351                 value /= 10**32;
352                 result += 32;
353             }
354             if (value >= 10**16) {
355                 value /= 10**16;
356                 result += 16;
357             }
358             if (value >= 10**8) {
359                 value /= 10**8;
360                 result += 8;
361             }
362             if (value >= 10**4) {
363                 value /= 10**4;
364                 result += 4;
365             }
366             if (value >= 10**2) {
367                 value /= 10**2;
368                 result += 2;
369             }
370             if (value >= 10**1) {
371                 result += 1;
372             }
373         }
374         return result;
375     }
376 
377     /**
378      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
379      * Returns 0 if given 0.
380      */
381     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
382         unchecked {
383             uint256 result = log10(value);
384             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
385         }
386     }
387 
388     /**
389      * @dev Return the log in base 256, rounded down, of a positive value.
390      * Returns 0 if given 0.
391      *
392      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
393      */
394     function log256(uint256 value) internal pure returns (uint256) {
395         uint256 result = 0;
396         unchecked {
397             if (value >> 128 > 0) {
398                 value >>= 128;
399                 result += 16;
400             }
401             if (value >> 64 > 0) {
402                 value >>= 64;
403                 result += 8;
404             }
405             if (value >> 32 > 0) {
406                 value >>= 32;
407                 result += 4;
408             }
409             if (value >> 16 > 0) {
410                 value >>= 16;
411                 result += 2;
412             }
413             if (value >> 8 > 0) {
414                 result += 1;
415             }
416         }
417         return result;
418     }
419 
420     /**
421      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
422      * Returns 0 if given 0.
423      */
424     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
425         unchecked {
426             uint256 result = log256(value);
427             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
428         }
429     }
430 }
431 
432 // File: @openzeppelin/contracts/utils/Strings.sol
433 
434 
435 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 
440 /**
441  * @dev String operations.
442  */
443 library Strings {
444     bytes16 private constant _SYMBOLS = "0123456789abcdef";
445     uint8 private constant _ADDRESS_LENGTH = 20;
446 
447     /**
448      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
449      */
450     function toString(uint256 value) internal pure returns (string memory) {
451         unchecked {
452             uint256 length = Math.log10(value) + 1;
453             string memory buffer = new string(length);
454             uint256 ptr;
455             /// @solidity memory-safe-assembly
456             assembly {
457                 ptr := add(buffer, add(32, length))
458             }
459             while (true) {
460                 ptr--;
461                 /// @solidity memory-safe-assembly
462                 assembly {
463                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
464                 }
465                 value /= 10;
466                 if (value == 0) break;
467             }
468             return buffer;
469         }
470     }
471 
472     /**
473      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
474      */
475     function toHexString(uint256 value) internal pure returns (string memory) {
476         unchecked {
477             return toHexString(value, Math.log256(value) + 1);
478         }
479     }
480 
481     /**
482      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
483      */
484     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
485         bytes memory buffer = new bytes(2 * length + 2);
486         buffer[0] = "0";
487         buffer[1] = "x";
488         for (uint256 i = 2 * length + 1; i > 1; --i) {
489             buffer[i] = _SYMBOLS[value & 0xf];
490             value >>= 4;
491         }
492         require(value == 0, "Strings: hex length insufficient");
493         return string(buffer);
494     }
495 
496     /**
497      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
498      */
499     function toHexString(address addr) internal pure returns (string memory) {
500         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
501     }
502 }
503 
504 // File: @openzeppelin/contracts/utils/Context.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 /**
512  * @dev Provides information about the current execution context, including the
513  * sender of the transaction and its data. While these are generally available
514  * via msg.sender and msg.data, they should not be accessed in such a direct
515  * manner, since when dealing with meta-transactions the account sending and
516  * paying for execution may not be the actual sender (as far as an application
517  * is concerned).
518  *
519  * This contract is only required for intermediate, library-like contracts.
520  */
521 abstract contract Context {
522     function _msgSender() internal view virtual returns (address) {
523         return msg.sender;
524     }
525 
526     function _msgData() internal view virtual returns (bytes calldata) {
527         return msg.data;
528     }
529 }
530 
531 // File: evm-contracts/src/RiserBotz/ERC173-Ownable.sol
532 
533 
534 
535 pragma solidity 0.8.13;
536 
537 
538 
539 
540 error CallerNotOwner();
541 
542 contract Ownable is IOwnable, Context {
543     address public owner;
544 
545     function _onlyOwner() private view {
546         if (owner != _msgSender()) revert CallerNotOwner();
547     }
548 
549     modifier onlyOwner() {
550         _onlyOwner();
551         _;
552     }
553 
554     constructor() {
555         address msgSender = _msgSender();
556         owner = msgSender;
557         emit OwnershipTransferred(address(0), msgSender);
558     }
559 
560     // Allow contract ownership and access to contract onlyOwner functions
561     // to be locked using EverOwn with control gated by community vote.
562     function transferOwnership(address newOwner) external virtual onlyOwner {
563         if (newOwner == address(0)) revert NotZeroAddress();
564 
565         emit OwnershipTransferred(owner, newOwner);
566         owner = newOwner;
567     }
568 }
569 // File: evm-contracts/src/RiserBotz/OperatorFilterer.sol
570 
571 
572 pragma solidity ^0.8.13;
573 
574 
575 
576 /**
577  * @title  OperatorFilterer
578  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
579  *         registrant's entries in the OperatorFilterRegistry.
580  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
581  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
582  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
583  */
584 abstract contract OperatorFilterer is Ownable {
585     error OperatorNotAllowed(address operator);
586 
587     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
588         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
589     bool skipCheck = false; //Just a safety flag to turn off, if something goes wrong
590 
591     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
592         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
593         // will not revert, but the contract will need to be registered with the registry once it is deployed in
594         // order for the modifier to filter addresses.
595         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
596             if (subscribe) {
597                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
598             } else {
599                 if (subscriptionOrRegistrantToCopy != address(0)) {
600                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
601                 } else {
602                     OPERATOR_FILTER_REGISTRY.register(address(this));
603                 }
604             }
605         }
606     }
607 
608     modifier onlyAllowedOperator(address from)  {
609         // Allow spending tokens from addresses with balance
610         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
611         // from an EOA.
612         if (!skipCheck) {
613             if (from != msg.sender) {
614                 _checkFilterOperator(msg.sender);
615             }
616         }
617         _;
618     }
619 
620     modifier onlyAllowedOperatorApproval(address operator)  {
621         if (!skipCheck) {
622             _checkFilterOperator(operator);
623         }
624         _;
625     }
626 
627     function setSkipCheck(bool checkValue) external onlyOwner {
628         skipCheck = checkValue;
629     }
630 
631     function _checkFilterOperator(address operator) internal view virtual {
632         // Check registry code length to facilitate testing in environments without a deployed registry.
633         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
634             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
635                 revert OperatorNotAllowed(operator);
636             }
637         }
638     }
639 }
640 // File: evm-contracts/src/RiserBotz/DefaultOperatorFilterer.sol
641 
642 
643 pragma solidity ^0.8.13;
644 
645 
646 /**
647  * @title  DefaultOperatorFilterer
648  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
649  */
650 abstract contract DefaultOperatorFilterer is OperatorFilterer {
651     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
652 
653     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
654 }
655 // File: @openzeppelin/contracts/utils/Address.sol
656 
657 
658 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
659 
660 pragma solidity ^0.8.1;
661 
662 /**
663  * @dev Collection of functions related to the address type
664  */
665 library Address {
666     /**
667      * @dev Returns true if `account` is a contract.
668      *
669      * [IMPORTANT]
670      * ====
671      * It is unsafe to assume that an address for which this function returns
672      * false is an externally-owned account (EOA) and not a contract.
673      *
674      * Among others, `isContract` will return false for the following
675      * types of addresses:
676      *
677      *  - an externally-owned account
678      *  - a contract in construction
679      *  - an address where a contract will be created
680      *  - an address where a contract lived, but was destroyed
681      * ====
682      *
683      * [IMPORTANT]
684      * ====
685      * You shouldn't rely on `isContract` to protect against flash loan attacks!
686      *
687      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
688      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
689      * constructor.
690      * ====
691      */
692     function isContract(address account) internal view returns (bool) {
693         // This method relies on extcodesize/address.code.length, which returns 0
694         // for contracts in construction, since the code is only stored at the end
695         // of the constructor execution.
696 
697         return account.code.length > 0;
698     }
699 
700     /**
701      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
702      * `recipient`, forwarding all available gas and reverting on errors.
703      *
704      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
705      * of certain opcodes, possibly making contracts go over the 2300 gas limit
706      * imposed by `transfer`, making them unable to receive funds via
707      * `transfer`. {sendValue} removes this limitation.
708      *
709      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
710      *
711      * IMPORTANT: because control is transferred to `recipient`, care must be
712      * taken to not create reentrancy vulnerabilities. Consider using
713      * {ReentrancyGuard} or the
714      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
715      */
716     function sendValue(address payable recipient, uint256 amount) internal {
717         require(address(this).balance >= amount, "Address: insufficient balance");
718 
719         (bool success, ) = recipient.call{value: amount}("");
720         require(success, "Address: unable to send value, recipient may have reverted");
721     }
722 
723     /**
724      * @dev Performs a Solidity function call using a low level `call`. A
725      * plain `call` is an unsafe replacement for a function call: use this
726      * function instead.
727      *
728      * If `target` reverts with a revert reason, it is bubbled up by this
729      * function (like regular Solidity function calls).
730      *
731      * Returns the raw returned data. To convert to the expected return value,
732      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
733      *
734      * Requirements:
735      *
736      * - `target` must be a contract.
737      * - calling `target` with `data` must not revert.
738      *
739      * _Available since v3.1._
740      */
741     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
742         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
747      * `errorMessage` as a fallback revert reason when `target` reverts.
748      *
749      * _Available since v3.1._
750      */
751     function functionCall(
752         address target,
753         bytes memory data,
754         string memory errorMessage
755     ) internal returns (bytes memory) {
756         return functionCallWithValue(target, data, 0, errorMessage);
757     }
758 
759     /**
760      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
761      * but also transferring `value` wei to `target`.
762      *
763      * Requirements:
764      *
765      * - the calling contract must have an ETH balance of at least `value`.
766      * - the called Solidity function must be `payable`.
767      *
768      * _Available since v3.1._
769      */
770     function functionCallWithValue(
771         address target,
772         bytes memory data,
773         uint256 value
774     ) internal returns (bytes memory) {
775         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
780      * with `errorMessage` as a fallback revert reason when `target` reverts.
781      *
782      * _Available since v3.1._
783      */
784     function functionCallWithValue(
785         address target,
786         bytes memory data,
787         uint256 value,
788         string memory errorMessage
789     ) internal returns (bytes memory) {
790         require(address(this).balance >= value, "Address: insufficient balance for call");
791         (bool success, bytes memory returndata) = target.call{value: value}(data);
792         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
793     }
794 
795     /**
796      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
797      * but performing a static call.
798      *
799      * _Available since v3.3._
800      */
801     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
802         return functionStaticCall(target, data, "Address: low-level static call failed");
803     }
804 
805     /**
806      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
807      * but performing a static call.
808      *
809      * _Available since v3.3._
810      */
811     function functionStaticCall(
812         address target,
813         bytes memory data,
814         string memory errorMessage
815     ) internal view returns (bytes memory) {
816         (bool success, bytes memory returndata) = target.staticcall(data);
817         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
818     }
819 
820     /**
821      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
822      * but performing a delegate call.
823      *
824      * _Available since v3.4._
825      */
826     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
827         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
828     }
829 
830     /**
831      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
832      * but performing a delegate call.
833      *
834      * _Available since v3.4._
835      */
836     function functionDelegateCall(
837         address target,
838         bytes memory data,
839         string memory errorMessage
840     ) internal returns (bytes memory) {
841         (bool success, bytes memory returndata) = target.delegatecall(data);
842         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
843     }
844 
845     /**
846      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
847      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
848      *
849      * _Available since v4.8._
850      */
851     function verifyCallResultFromTarget(
852         address target,
853         bool success,
854         bytes memory returndata,
855         string memory errorMessage
856     ) internal view returns (bytes memory) {
857         if (success) {
858             if (returndata.length == 0) {
859                 // only check isContract if the call was successful and the return data is empty
860                 // otherwise we already know that it was a contract
861                 require(isContract(target), "Address: call to non-contract");
862             }
863             return returndata;
864         } else {
865             _revert(returndata, errorMessage);
866         }
867     }
868 
869     /**
870      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
871      * revert reason or using the provided one.
872      *
873      * _Available since v4.3._
874      */
875     function verifyCallResult(
876         bool success,
877         bytes memory returndata,
878         string memory errorMessage
879     ) internal pure returns (bytes memory) {
880         if (success) {
881             return returndata;
882         } else {
883             _revert(returndata, errorMessage);
884         }
885     }
886 
887     function _revert(bytes memory returndata, string memory errorMessage) private pure {
888         // Look for revert reason and bubble it up if present
889         if (returndata.length > 0) {
890             // The easiest way to bubble the revert reason is using memory via assembly
891             /// @solidity memory-safe-assembly
892             assembly {
893                 let returndata_size := mload(returndata)
894                 revert(add(32, returndata), returndata_size)
895             }
896         } else {
897             revert(errorMessage);
898         }
899     }
900 }
901 
902 // File: evm-contracts/src/RiserBotz/Lockable.sol
903 
904 
905 
906 pragma solidity ^0.8.13;
907 
908 
909 
910 
911 error TokensLocked();                 
912 error LockTimeTooLong();              
913 error LockTimeTooShort();             
914 error Unlocked();
915 
916 abstract contract Lockable is Context {
917     using Address for address;
918     
919     event LockTokens(address indexed account, address indexed altAccount, uint256 length);
920     event LockTokensExtend(address indexed account, uint256 length);
921 
922     //Lock related fields
923     mapping (address => uint48) internal _lockTimestamps;
924     mapping(address => address) private _userUnlocks;
925 
926     function _tokensLock(address fromAddress) internal view {
927         if (isWalletLocked(fromAddress)) revert TokensLocked();
928     }
929 
930     modifier tokensLock(address fromAddress) {
931         _tokensLock(fromAddress);
932         _;
933     }
934 
935     function isWalletLocked(address fromAddress) public view returns(bool) {
936         return _lockTimestamps[fromAddress] > block.timestamp;
937     }
938     
939     function lockTokens(address altAccount, uint48 length) external tokensLock(_msgSender()) {
940         if (altAccount == address(0)) revert NotZeroAddress();
941         if (length / 1 days > 10 * 365 days) revert LockTimeTooLong();
942 
943         _lockTimestamps[_msgSender()] = uint48(block.timestamp) + length;
944         _userUnlocks[_msgSender()] = altAccount;
945 
946         emit LockTokens(_msgSender(), altAccount, length);
947     }
948 
949     function extendLockTokens(uint48 length) external {
950         if (length / 1 days > 10 * 365 days) revert LockTimeTooLong();
951         uint48 currentLock = _lockTimestamps[_msgSender()];
952 
953         if (currentLock < block.timestamp) revert Unlocked();
954 
955         uint48 newLock = uint48(block.timestamp) + length;
956         if (currentLock > newLock) revert LockTimeTooShort();
957         _lockTimestamps[_msgSender()] = newLock;
958 
959         emit LockTokensExtend(_msgSender(), length);
960     }
961 
962     function unlockTokens(address accountToUnlock) external {
963         if (_userUnlocks[accountToUnlock] != _msgSender()) revert CallerNotApproved();
964         uint48 currentLock = _lockTimestamps[accountToUnlock];
965         if (currentLock < block.timestamp) revert Unlocked();
966         _lockTimestamps[accountToUnlock] = 1;
967     }
968 }
969 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
970 
971 
972 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
973 
974 pragma solidity ^0.8.0;
975 
976 /**
977  * @title ERC721 token receiver interface
978  * @dev Interface for any contract that wants to support safeTransfers
979  * from ERC721 asset contracts.
980  */
981 interface IERC721Receiver {
982     /**
983      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
984      * by `operator` from `from`, this function is called.
985      *
986      * It must return its Solidity selector to confirm the token transfer.
987      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
988      *
989      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
990      */
991     function onERC721Received(
992         address operator,
993         address from,
994         uint256 tokenId,
995         bytes calldata data
996     ) external returns (bytes4);
997 }
998 
999 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1000 
1001 
1002 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1003 
1004 pragma solidity ^0.8.0;
1005 
1006 /**
1007  * @dev Interface of the ERC165 standard, as defined in the
1008  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1009  *
1010  * Implementers can declare support of contract interfaces, which can then be
1011  * queried by others ({ERC165Checker}).
1012  *
1013  * For an implementation, see {ERC165}.
1014  */
1015 interface IERC165 {
1016     /**
1017      * @dev Returns true if this contract implements the interface defined by
1018      * `interfaceId`. See the corresponding
1019      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1020      * to learn more about how these ids are created.
1021      *
1022      * This function call must use less than 30 000 gas.
1023      */
1024     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1025 }
1026 
1027 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1028 
1029 
1030 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1031 
1032 pragma solidity ^0.8.0;
1033 
1034 
1035 /**
1036  * @dev Implementation of the {IERC165} interface.
1037  *
1038  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1039  * for the additional interface id that will be supported. For example:
1040  *
1041  * ```solidity
1042  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1043  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1044  * }
1045  * ```
1046  *
1047  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1048  */
1049 abstract contract ERC165 is IERC165 {
1050     /**
1051      * @dev See {IERC165-supportsInterface}.
1052      */
1053     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1054         return interfaceId == type(IERC165).interfaceId;
1055     }
1056 }
1057 
1058 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1059 
1060 
1061 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1062 
1063 pragma solidity ^0.8.0;
1064 
1065 
1066 /**
1067  * @dev Required interface of an ERC721 compliant contract.
1068  */
1069 interface IERC721 is IERC165 {
1070     /**
1071      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1072      */
1073     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1074 
1075     /**
1076      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1077      */
1078     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1079 
1080     /**
1081      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1082      */
1083     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1084 
1085     /**
1086      * @dev Returns the number of tokens in ``owner``'s account.
1087      */
1088     function balanceOf(address owner) external view returns (uint256 balance);
1089 
1090     /**
1091      * @dev Returns the owner of the `tokenId` token.
1092      *
1093      * Requirements:
1094      *
1095      * - `tokenId` must exist.
1096      */
1097     function ownerOf(uint256 tokenId) external view returns (address owner);
1098 
1099     /**
1100      * @dev Safely transfers `tokenId` token from `from` to `to`.
1101      *
1102      * Requirements:
1103      *
1104      * - `from` cannot be the zero address.
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must exist and be owned by `from`.
1107      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function safeTransferFrom(
1113         address from,
1114         address to,
1115         uint256 tokenId,
1116         bytes calldata data
1117     ) external;
1118 
1119     /**
1120      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1121      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1122      *
1123      * Requirements:
1124      *
1125      * - `from` cannot be the zero address.
1126      * - `to` cannot be the zero address.
1127      * - `tokenId` token must exist and be owned by `from`.
1128      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1129      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function safeTransferFrom(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) external;
1138 
1139     /**
1140      * @dev Transfers `tokenId` token from `from` to `to`.
1141      *
1142      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1143      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1144      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1145      *
1146      * Requirements:
1147      *
1148      * - `from` cannot be the zero address.
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must be owned by `from`.
1151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function transferFrom(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) external;
1160 
1161     /**
1162      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1163      * The approval is cleared when the token is transferred.
1164      *
1165      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1166      *
1167      * Requirements:
1168      *
1169      * - The caller must own the token or be an approved operator.
1170      * - `tokenId` must exist.
1171      *
1172      * Emits an {Approval} event.
1173      */
1174     function approve(address to, uint256 tokenId) external;
1175 
1176     /**
1177      * @dev Approve or remove `operator` as an operator for the caller.
1178      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1179      *
1180      * Requirements:
1181      *
1182      * - The `operator` cannot be the caller.
1183      *
1184      * Emits an {ApprovalForAll} event.
1185      */
1186     function setApprovalForAll(address operator, bool _approved) external;
1187 
1188     /**
1189      * @dev Returns the account approved for `tokenId` token.
1190      *
1191      * Requirements:
1192      *
1193      * - `tokenId` must exist.
1194      */
1195     function getApproved(uint256 tokenId) external view returns (address operator);
1196 
1197     /**
1198      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1199      *
1200      * See {setApprovalForAll}
1201      */
1202     function isApprovedForAll(address owner, address operator) external view returns (bool);
1203 }
1204 
1205 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1206 
1207 
1208 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1209 
1210 pragma solidity ^0.8.0;
1211 
1212 
1213 /**
1214  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1215  * @dev See https://eips.ethereum.org/EIPS/eip-721
1216  */
1217 interface IERC721Metadata is IERC721 {
1218     /**
1219      * @dev Returns the token collection name.
1220      */
1221     function name() external view returns (string memory);
1222 
1223     /**
1224      * @dev Returns the token collection symbol.
1225      */
1226     function symbol() external view returns (string memory);
1227 
1228     /**
1229      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1230      */
1231     function tokenURI(uint256 tokenId) external view returns (string memory);
1232 }
1233 
1234 // File: evm-contracts/src/RiserBotz/ERC721R.sol
1235 
1236 
1237 
1238 pragma solidity ^0.8.13;
1239 
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 /**
1252  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1253  * the Metadata extension, but not including the Enumerable extension. This does random batch minting.
1254  */
1255 contract ERC721r is Context, DefaultOperatorFilterer, ERC165, IERC721, IERC721Metadata, IERC2981, Lockable {
1256     using Address for address;
1257     using Strings for uint256;
1258 
1259     event RoyaltyFeeUpdated(uint256 newValue);
1260     event RoyaltyAddressUpdated(address indexed contractAddress);
1261     
1262     // Token name
1263     string private _name;
1264 
1265     // Token symbol
1266     string private _symbol;
1267     
1268     mapping(uint => uint) private _availableTokens;
1269     uint256 private _numAvailableTokens;
1270     uint256 immutable _maxSupply;
1271     // Mapping from token ID to owner address
1272     mapping(uint256 => address) private _owners;
1273 
1274     // Mapping owner address to token count
1275     mapping(address => uint256) private _balances;
1276 
1277     // Mapping from token ID to approved address
1278     mapping(uint256 => address) private _tokenApprovals;
1279 
1280     // Mapping from owner to operator approvals
1281     mapping(address => mapping(address => bool)) private _operatorApprovals;
1282 
1283     //Adding RoyaltyInfo details
1284     uint256 royaltyFee = 750;
1285     address royaltyAddress;
1286 
1287     /**
1288      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1289      */
1290     constructor(string memory name_, string memory symbol_, uint maxSupply_, address rAddress) {
1291         _name = name_;
1292         _symbol = symbol_;
1293         _maxSupply = maxSupply_;
1294         _numAvailableTokens = maxSupply_;
1295         royaltyAddress = rAddress;
1296     }
1297     
1298     /**
1299      * @dev See {IERC165-supportsInterface}.
1300      */
1301     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1302         return
1303             interfaceId == type(IERC721).interfaceId ||
1304             interfaceId == type(IERC721Metadata).interfaceId ||
1305             super.supportsInterface(interfaceId);
1306     }
1307 
1308     function royaltyInfo(
1309         uint256, /* tokenId */
1310         uint256 salePrice
1311     ) public view returns (address receiver, uint256 royaltyAmount) {
1312         receiver = royaltyAddress;
1313         royaltyAmount = (royaltyFee * salePrice) / 10000;
1314     }
1315 
1316     function setRoyaltyAddress(address newAddress) external onlyOwner {
1317         royaltyAddress = newAddress;
1318         emit RoyaltyAddressUpdated(newAddress);
1319     }
1320 
1321     function setRoyaltyFee(uint256 newFee) external onlyOwner {
1322         royaltyFee = newFee;
1323         emit RoyaltyFeeUpdated(newFee);
1324     }
1325     
1326     function totalSupply() public view virtual returns (uint256) {
1327         return _maxSupply - _numAvailableTokens;
1328     }
1329     
1330     function maxSupply() public view virtual returns (uint256) {
1331         return _maxSupply;
1332     }
1333 
1334     /**
1335      * @dev See {IERC721-balanceOf}.
1336      */
1337     function balanceOf(address owner) public view virtual override returns (uint256) {
1338         require(owner != address(0), "ERC721: balance query for the zero address");
1339         return _balances[owner];
1340     }
1341 
1342     /**
1343      * @dev See {IERC721-ownerOf}.
1344      */
1345     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1346         address owner = _owners[tokenId];
1347         require(owner != address(0), "ERC721: owner query for nonexistent token");
1348         return owner;
1349     }
1350 
1351     /**
1352      * @dev See {IERC721Metadata-name}.
1353      */
1354     function name() public view virtual override returns (string memory) {
1355         return _name;
1356     }
1357 
1358     /**
1359      * @dev See {IERC721Metadata-symbol}.
1360      */
1361     function symbol() public view virtual override returns (string memory) {
1362         return _symbol;
1363     }
1364 
1365     /**
1366      * @dev See {IERC721Metadata-tokenURI}.
1367      */
1368     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1369         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1370 
1371         string memory baseURI = _baseURI();
1372         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1373     }
1374 
1375     /**
1376      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1377      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1378      * by default, can be overridden in child contracts.
1379      */
1380     function _baseURI() internal view virtual returns (string memory) {
1381         return "";
1382     }
1383 
1384     /**
1385      * @dev See {IERC721-approve}.
1386      */
1387     function approve(address to, uint256 tokenId) public virtual override onlyAllowedOperatorApproval(to) tokensLock(_msgSender()) {
1388         address owner = ERC721r.ownerOf(tokenId);
1389         require(to != owner, "ERC721: approval to current owner");
1390 
1391         require(
1392             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1393             "ERC721: approve caller is not owner nor approved for all"
1394         );
1395 
1396         _approve(to, tokenId);
1397     }
1398 
1399     /**
1400      * @dev See {IERC721-getApproved}.
1401      */
1402     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1403         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1404 
1405         return _tokenApprovals[tokenId];
1406     }
1407 
1408     /**
1409      * @dev See {IERC721-setApprovalForAll}.
1410      */
1411     function setApprovalForAll(address operator, bool approved) public virtual override onlyAllowedOperatorApproval(operator) tokensLock(_msgSender()) {
1412         _setApprovalForAll(_msgSender(), operator, approved);
1413     }
1414 
1415     /**
1416      * @dev See {IERC721-isApprovedForAll}.
1417      */
1418     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1419         return _operatorApprovals[owner][operator];
1420     }
1421 
1422     /**
1423      * @dev See {IERC721-transferFrom}.
1424      */
1425     function transferFrom(
1426         address from,
1427         address to,
1428         uint256 tokenId
1429     ) public virtual override onlyAllowedOperator(from) tokensLock(from) {
1430         //solhint-disable-next-line max-line-length
1431         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1432 
1433         _transfer(from, to, tokenId);
1434     }
1435 
1436     /**
1437      * @dev See {IERC721-safeTransferFrom}.
1438      */
1439     function safeTransferFrom(
1440         address from,
1441         address to,
1442         uint256 tokenId
1443     ) public virtual override onlyAllowedOperator(from) tokensLock(from) {
1444         safeTransferFrom(from, to, tokenId, "");
1445     }
1446 
1447     /**
1448      * @dev See {IERC721-safeTransferFrom}.
1449      */
1450     function safeTransferFrom(
1451         address from,
1452         address to,
1453         uint256 tokenId,
1454         bytes memory _data
1455     ) public virtual override onlyAllowedOperator(from) tokensLock(from) {
1456         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1457         _safeTransfer(from, to, tokenId, _data);
1458     }
1459 
1460     /**
1461      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1462      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1463      *
1464      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1465      *
1466      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1467      * implement alternative mechanisms to perform token transfer, such as signature-based.
1468      *
1469      * Requirements:
1470      *
1471      * - `from` cannot be the zero address.
1472      * - `to` cannot be the zero address.
1473      * - `tokenId` token must exist and be owned by `from`.
1474      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1475      *
1476      * Emits a {Transfer} event.
1477      */
1478     function _safeTransfer(
1479         address from,
1480         address to,
1481         uint256 tokenId,
1482         bytes memory _data
1483     ) internal virtual {
1484         _transfer(from, to, tokenId);
1485         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1486     }
1487 
1488     /**
1489      * @dev Returns whether `tokenId` exists.
1490      *
1491      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1492      *
1493      * Tokens start existing when they are minted (`_mint`),
1494      * and stop existing when they are burned (`_burn`).
1495      */
1496     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1497         return _owners[tokenId] != address(0);
1498     }
1499 
1500     /**
1501      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1502      *
1503      * Requirements:
1504      *
1505      * - `tokenId` must exist.
1506      */
1507     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1508         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1509         address owner = ERC721r.ownerOf(tokenId);
1510         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1511     }
1512 
1513     function _mintIdWithoutBalanceUpdate(address to, uint256 tokenId) private {
1514         _beforeTokenTransfer(address(0), to, tokenId);
1515         
1516         _owners[tokenId] = to;
1517         
1518         emit Transfer(address(0), to, tokenId);
1519         
1520         _afterTokenTransfer(address(0), to, tokenId);
1521     }
1522 
1523     function _mintRandom(address to, uint _numToMint) internal virtual {
1524         require(_msgSender() == tx.origin, "Contracts cannot mint");
1525         require(to != address(0), "ERC721: mint to the zero address");
1526         require(_numToMint > 0, "ERC721r: need to mint at least one token");
1527         
1528         // TODO: Probably don't need this as it will underflow and revert automatically in this case
1529         require(_numAvailableTokens >= _numToMint, "ERC721r: minting more tokens than available");
1530         
1531         uint updatedNumAvailableTokens = _numAvailableTokens;
1532         for (uint256 i; i < _numToMint; ++i) { // Do this ++ unchecked?
1533             uint256 tokenId = getRandomAvailableTokenId(to, updatedNumAvailableTokens);
1534             
1535             _mintIdWithoutBalanceUpdate(to, tokenId);
1536             
1537             --updatedNumAvailableTokens;
1538         }
1539         
1540         _numAvailableTokens = updatedNumAvailableTokens;
1541         _balances[to] += _numToMint;
1542     }
1543         
1544     function getRandomAvailableTokenId(address to, uint updatedNumAvailableTokens)
1545         internal
1546         returns (uint256)
1547     {
1548         uint256 randomNum = uint256(
1549             keccak256(
1550                 abi.encode(
1551                     to,
1552                     tx.gasprice,
1553                     block.number,
1554                     block.timestamp,
1555                     block.difficulty,
1556                     blockhash(block.number - 1),
1557                     address(this),
1558                     updatedNumAvailableTokens
1559                 )
1560             )
1561         );
1562         uint256 randomIndex = randomNum % updatedNumAvailableTokens;
1563         return getAvailableTokenAtIndex(randomIndex, updatedNumAvailableTokens);
1564     }
1565 
1566     // Implements https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle. Code taken from CryptoPhunksV2
1567     function getAvailableTokenAtIndex(uint256 indexToUse, uint updatedNumAvailableTokens)
1568         internal
1569         returns (uint256)
1570     {
1571         uint256 valAtIndex = _availableTokens[indexToUse];
1572         uint256 result;
1573         if (valAtIndex == 0) {
1574             // This means the index itself is still an available token
1575             result = indexToUse;
1576         } else {
1577             // This means the index itself is not an available token, but the val at that index is.
1578             result = valAtIndex;
1579         }
1580 
1581         uint256 lastIndex = updatedNumAvailableTokens - 1;
1582         uint256 lastValInArray = _availableTokens[lastIndex];
1583         if (indexToUse != lastIndex) {
1584             // Replace the value at indexToUse, now that it's been used.
1585             // Replace it with the data from the last index in the array, since we are going to decrease the array size afterwards.
1586             if (lastValInArray == 0) {
1587                 // This means the index itself is still an available token
1588                 _availableTokens[indexToUse] = lastIndex;
1589             } else {
1590                 // This means the index itself is not an available token, but the val at that index is.
1591                 _availableTokens[indexToUse] = lastValInArray;
1592             }
1593         }
1594         if (lastValInArray != 0) {
1595             // Gas refund courtsey of @dievardump
1596             delete _availableTokens[lastIndex];
1597         }
1598         
1599         return result;
1600     }
1601     
1602     // Not as good as minting a specific tokenId, but will behave the same at the start
1603     // allowing you to explicitly mint some tokens at launch.
1604     function _mintAtIndex(address to, uint index) internal virtual {
1605         require(_msgSender() == tx.origin, "Contracts cannot mint");
1606         require(to != address(0), "ERC721: mint to the zero address");
1607         require(_numAvailableTokens >= 1, "ERC721r: minting more tokens than available");
1608         
1609         uint tokenId = getAvailableTokenAtIndex(index, _numAvailableTokens);
1610         --_numAvailableTokens;
1611         
1612         _mintIdWithoutBalanceUpdate(to, tokenId);
1613         
1614         _balances[to] += 1;
1615     }
1616 
1617     /**
1618      * @dev Transfers `tokenId` from `from` to `to`.
1619      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1620      *
1621      * Requirements:
1622      *
1623      * - `to` cannot be the zero address.
1624      * - `tokenId` token must be owned by `from`.
1625      *
1626      * Emits a {Transfer} event.
1627      */
1628     function _transfer(
1629         address from,
1630         address to,
1631         uint256 tokenId
1632     ) internal virtual {
1633         require(ERC721r.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1634         require(to != address(0), "ERC721: transfer to the zero address");
1635 
1636         _beforeTokenTransfer(from, to, tokenId);
1637 
1638         // Clear approvals from the previous owner
1639         _approve(address(0), tokenId);
1640 
1641         _balances[from] -= 1;
1642         _balances[to] += 1;
1643         _owners[tokenId] = to;
1644 
1645         emit Transfer(from, to, tokenId);
1646 
1647         _afterTokenTransfer(from, to, tokenId);
1648     }
1649 
1650     /**
1651      * @dev Approve `to` to operate on `tokenId`
1652      *
1653      * Emits a {Approval} event.
1654      */
1655     function _approve(address to, uint256 tokenId) internal virtual {
1656         _tokenApprovals[tokenId] = to;
1657         emit Approval(ERC721r.ownerOf(tokenId), to, tokenId);
1658     }
1659 
1660     /**
1661      * @dev Approve `operator` to operate on all of `owner` tokens
1662      *
1663      * Emits a {ApprovalForAll} event.
1664      */
1665     function _setApprovalForAll(
1666         address owner,
1667         address operator,
1668         bool approved
1669     ) internal virtual {
1670         require(owner != operator, "ERC721: approve to caller");
1671         _operatorApprovals[owner][operator] = approved;
1672         emit ApprovalForAll(owner, operator, approved);
1673     }
1674 
1675     /**
1676      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1677      * The call is not executed if the target address is not a contract.
1678      *
1679      * @param from address representing the previous owner of the given token ID
1680      * @param to target address that will receive the tokens
1681      * @param tokenId uint256 ID of the token to be transferred
1682      * @param _data bytes optional data to send along with the call
1683      * @return bool whether the call correctly returned the expected magic value
1684      */
1685     function _checkOnERC721Received(
1686         address from,
1687         address to,
1688         uint256 tokenId,
1689         bytes memory _data
1690     ) private returns (bool) {
1691         if (to.isContract()) {
1692             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1693                 return retval == IERC721Receiver.onERC721Received.selector;
1694             } catch (bytes memory reason) {
1695                 if (reason.length == 0) {
1696                     revert("ERC721: transfer to non ERC721Receiver implementer");
1697                 } else {
1698                     assembly {
1699                         revert(add(32, reason), mload(reason))
1700                     }
1701                 }
1702             }
1703         } else {
1704             return true;
1705         }
1706     }
1707 
1708     /**
1709      * @dev Hook that is called before any token transfer. This includes minting
1710      * and burning.
1711      *
1712      * Calling conditions:
1713      *
1714      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1715      * transferred to `to`.
1716      * - When `from` is zero, `tokenId` will be minted for `to`.
1717      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1718      * - `from` and `to` are never both zero.
1719      *
1720      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1721      */
1722     function _beforeTokenTransfer(
1723         address from,
1724         address to,
1725         uint256 tokenId
1726     ) internal virtual {}
1727 
1728     /**
1729      * @dev Hook that is called after any transfer of tokens. This includes
1730      * minting and burning.
1731      *
1732      * Calling conditions:
1733      *
1734      * - when `from` and `to` are both non-zero.
1735      * - `from` and `to` are never both zero.
1736      *
1737      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1738      */
1739     function _afterTokenTransfer(
1740         address from,
1741         address to,
1742         uint256 tokenId
1743     ) internal virtual {}
1744 }
1745 // File: evm-contracts/src/RiserBotz/RiserBotz.sol
1746 
1747 
1748 
1749 pragma solidity ^0.8.13;
1750 
1751 
1752 
1753 
1754 abstract contract BotzConfigurable is Ownable {
1755 
1756     
1757     event MintFeeUpdated(uint256 newMintFee);
1758     event MaxLimitUpdated(uint256 newLimit);
1759     event MintActiveUpdated(bool active);
1760     event PreRevealURIUpdated(string uri);
1761 
1762     bool isMintActive = false;
1763     uint256 maxLimit = 5;
1764     uint256 public mintFee = 8 * 10**18 / 10**2;
1765     bool isRevealed = false;
1766     string preRevealURI = "ipfs://bafkreiarlfjadv23vdgqyt7pbpot7pfwzmrjucuz7c4akngk6b4ixwamay";
1767     string postRevealBaseURI = "";
1768 
1769     function setMintActive(bool active) external onlyOwner {
1770         isMintActive = active;
1771         emit MintActiveUpdated(active);
1772     }
1773 
1774     function setPreRevalURI(string memory uri) external onlyOwner {
1775         preRevealURI = uri;
1776         emit PreRevealURIUpdated(uri);
1777     }
1778 
1779     function setMaxLimit(uint256 newLimit) external onlyOwner {
1780         maxLimit = newLimit;
1781         emit MaxLimitUpdated(newLimit);
1782     }
1783 
1784     function setMintFee(uint256 newFee, uint256 decimals) external onlyOwner {
1785         uint256 newMintFee = (newFee * 10**18) / (10 ** decimals);
1786         mintFee = newMintFee;
1787         emit MintFeeUpdated(newMintFee);
1788     }
1789 
1790     function reveal(string memory baseURI) external onlyOwner {
1791         postRevealBaseURI = baseURI;
1792         isRevealed = true;
1793     }
1794 }
1795 
1796 contract RiserBotz is BotzConfigurable, ERC721r {
1797 
1798     error FailedEthSend();
1799     error MintNotActive();
1800     error ExceededTheLimit();
1801     error NotEnoughAmount();
1802     error AmountMustBeGreaterThanZero();
1803 
1804     constructor(address royaltyAddress) ERC721r ("RiserBotz", "RISERBOTZ", 10_000, royaltyAddress) {
1805 
1806     }
1807 
1808     function mint(address toAddress, uint numOfTokens) public payable {
1809         if (!isMintActive) _revert(MintNotActive.selector);
1810         if (numOfTokens > maxLimit) _revert (ExceededTheLimit.selector);
1811         if (msg.value < numOfTokens * mintFee) _revert (NotEnoughAmount.selector);
1812 
1813         _mintRandom(toAddress, numOfTokens);
1814     }
1815 
1816     function airDrop(address[] calldata addresses) external onlyOwner {
1817         for (uint256 i = 0; i < addresses.length; i++) {
1818             if (addresses[i] == address(0)) _revert (NotZeroAddress.selector);
1819             _mintRandom(addresses[i], 1);
1820         }
1821     }
1822 
1823     //@dev override tokenURI for prereveal
1824     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1825         if (!isRevealed) {
1826             return preRevealURI;
1827         }
1828         return super.tokenURI(tokenId);
1829     }
1830 
1831     //@dev override _baseURI
1832     function _baseURI() internal view override returns (string memory) {
1833         return postRevealBaseURI;
1834     }
1835 
1836     // function sendEthViaCall(address payable to, uint256 amount) private {
1837     //     (bool sent, ) = to.call{value: amount}("");
1838     //     if (!sent) revert FailedEthSend();
1839     // }
1840 
1841     function transferBalance() external onlyOwner {
1842         uint256 amount = address(this).balance;
1843         (bool sent, ) = _msgSender().call{value: amount}("");
1844         if (!sent) revert FailedEthSend();
1845     }
1846 
1847     function _revert(bytes4 errorSelector) internal pure {
1848         assembly {
1849             mstore(0x00, errorSelector)
1850             revert(0x00, 0x04)
1851         }
1852     }
1853 
1854 }