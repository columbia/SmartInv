1 /**
2  *Submitted for verification at Etherscan.io on 2023-01-10
3 */
4 
5 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
6 
7 
8 pragma solidity ^0.8.13;
9 
10 interface IOperatorFilterRegistry {
11     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
12     function register(address registrant) external;
13     function registerAndSubscribe(address registrant, address subscription) external;
14     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
15     function unregister(address addr) external;
16     function updateOperator(address registrant, address operator, bool filtered) external;
17     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
18     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
19     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
20     function subscribe(address registrant, address registrantToSubscribe) external;
21     function unsubscribe(address registrant, bool copyExistingEntries) external;
22     function subscriptionOf(address addr) external returns (address registrant);
23     function subscribers(address registrant) external returns (address[] memory);
24     function subscriberAt(address registrant, uint256 index) external returns (address);
25     function copyEntriesOf(address registrant, address registrantToCopy) external;
26     function isOperatorFiltered(address registrant, address operator) external returns (bool);
27     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
28     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
29     function filteredOperators(address addr) external returns (address[] memory);
30     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
31     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
32     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
33     function isRegistered(address addr) external returns (bool);
34     function codeHashOf(address addr) external returns (bytes32);
35 }
36 
37 // File: operator-filter-registry/src/OperatorFilterer.sol
38 
39 
40 pragma solidity ^0.8.13;
41 
42 
43 /**
44  * @title  OperatorFilterer
45  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
46  *         registrant's entries in the OperatorFilterRegistry.
47  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
48  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
49  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
50  */
51 abstract contract OperatorFilterer {
52     error OperatorNotAllowed(address operator);
53 
54     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
55         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
56 
57     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
58         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
59         // will not revert, but the contract will need to be registered with the registry once it is deployed in
60         // order for the modifier to filter addresses.
61         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
62             if (subscribe) {
63                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
64             } else {
65                 if (subscriptionOrRegistrantToCopy != address(0)) {
66                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
67                 } else {
68                     OPERATOR_FILTER_REGISTRY.register(address(this));
69                 }
70             }
71         }
72     }
73 
74     modifier onlyAllowedOperator(address from) virtual {
75         // Allow spending tokens from addresses with balance
76         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
77         // from an EOA.
78         if (from != msg.sender) {
79             _checkFilterOperator(msg.sender);
80         }
81         _;
82     }
83 
84     modifier onlyAllowedOperatorApproval(address operator) virtual {
85         _checkFilterOperator(operator);
86         _;
87     }
88 
89     function _checkFilterOperator(address operator) internal view virtual {
90         // Check registry code length to facilitate testing in environments without a deployed registry.
91         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
92             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
93                 revert OperatorNotAllowed(operator);
94             }
95         }
96     }
97 }
98 
99 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
100 
101 
102 pragma solidity ^0.8.13;
103 
104 
105 /**
106  * @title  DefaultOperatorFilterer
107  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
108  */
109 abstract contract DefaultOperatorFilterer is OperatorFilterer {
110     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
111 
112     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
113 }
114 
115 // File: @openzeppelin/contracts/utils/math/Math.sol
116 
117 
118 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Standard math utilities missing in the Solidity language.
124  */
125 library Math {
126     enum Rounding {
127         Down, // Toward negative infinity
128         Up, // Toward infinity
129         Zero // Toward zero
130     }
131 
132     /**
133      * @dev Returns the largest of two numbers.
134      */
135     function max(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a > b ? a : b;
137     }
138 
139     /**
140      * @dev Returns the smallest of two numbers.
141      */
142     function min(uint256 a, uint256 b) internal pure returns (uint256) {
143         return a < b ? a : b;
144     }
145 
146     /**
147      * @dev Returns the average of two numbers. The result is rounded towards
148      * zero.
149      */
150     function average(uint256 a, uint256 b) internal pure returns (uint256) {
151         // (a + b) / 2 can overflow.
152         return (a & b) + (a ^ b) / 2;
153     }
154 
155     /**
156      * @dev Returns the ceiling of the division of two numbers.
157      *
158      * This differs from standard division with `/` in that it rounds up instead
159      * of rounding down.
160      */
161     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
162         // (a + b - 1) / b can overflow on addition, so we distribute.
163         return a == 0 ? 0 : (a - 1) / b + 1;
164     }
165 
166     /**
167      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
168      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
169      * with further edits by Uniswap Labs also under MIT license.
170      */
171     function mulDiv(
172         uint256 x,
173         uint256 y,
174         uint256 denominator
175     ) internal pure returns (uint256 result) {
176         unchecked {
177             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
178             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
179             // variables such that product = prod1 * 2^256 + prod0.
180             uint256 prod0; // Least significant 256 bits of the product
181             uint256 prod1; // Most significant 256 bits of the product
182             assembly {
183                 let mm := mulmod(x, y, not(0))
184                 prod0 := mul(x, y)
185                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
186             }
187 
188             // Handle non-overflow cases, 256 by 256 division.
189             if (prod1 == 0) {
190                 return prod0 / denominator;
191             }
192 
193             // Make sure the result is less than 2^256. Also prevents denominator == 0.
194             require(denominator > prod1);
195 
196             ///////////////////////////////////////////////
197             // 512 by 256 division.
198             ///////////////////////////////////////////////
199 
200             // Make division exact by subtracting the remainder from [prod1 prod0].
201             uint256 remainder;
202             assembly {
203                 // Compute remainder using mulmod.
204                 remainder := mulmod(x, y, denominator)
205 
206                 // Subtract 256 bit number from 512 bit number.
207                 prod1 := sub(prod1, gt(remainder, prod0))
208                 prod0 := sub(prod0, remainder)
209             }
210 
211             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
212             // See https://cs.stackexchange.com/q/138556/92363.
213 
214             // Does not overflow because the denominator cannot be zero at this stage in the function.
215             uint256 twos = denominator & (~denominator + 1);
216             assembly {
217                 // Divide denominator by twos.
218                 denominator := div(denominator, twos)
219 
220                 // Divide [prod1 prod0] by twos.
221                 prod0 := div(prod0, twos)
222 
223                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
224                 twos := add(div(sub(0, twos), twos), 1)
225             }
226 
227             // Shift in bits from prod1 into prod0.
228             prod0 |= prod1 * twos;
229 
230             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
231             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
232             // four bits. That is, denominator * inv = 1 mod 2^4.
233             uint256 inverse = (3 * denominator) ^ 2;
234 
235             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
236             // in modular arithmetic, doubling the correct bits in each step.
237             inverse *= 2 - denominator * inverse; // inverse mod 2^8
238             inverse *= 2 - denominator * inverse; // inverse mod 2^16
239             inverse *= 2 - denominator * inverse; // inverse mod 2^32
240             inverse *= 2 - denominator * inverse; // inverse mod 2^64
241             inverse *= 2 - denominator * inverse; // inverse mod 2^128
242             inverse *= 2 - denominator * inverse; // inverse mod 2^256
243 
244             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
245             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
246             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
247             // is no longer required.
248             result = prod0 * inverse;
249             return result;
250         }
251     }
252 
253     /**
254      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
255      */
256     function mulDiv(
257         uint256 x,
258         uint256 y,
259         uint256 denominator,
260         Rounding rounding
261     ) internal pure returns (uint256) {
262         uint256 result = mulDiv(x, y, denominator);
263         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
264             result += 1;
265         }
266         return result;
267     }
268 
269     /**
270      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
271      *
272      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
273      */
274     function sqrt(uint256 a) internal pure returns (uint256) {
275         if (a == 0) {
276             return 0;
277         }
278 
279         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
280         //
281         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
282         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
283         //
284         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
285         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
286         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
287         //
288         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
289         uint256 result = 1 << (log2(a) >> 1);
290 
291         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
292         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
293         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
294         // into the expected uint128 result.
295         unchecked {
296             result = (result + a / result) >> 1;
297             result = (result + a / result) >> 1;
298             result = (result + a / result) >> 1;
299             result = (result + a / result) >> 1;
300             result = (result + a / result) >> 1;
301             result = (result + a / result) >> 1;
302             result = (result + a / result) >> 1;
303             return min(result, a / result);
304         }
305     }
306 
307     /**
308      * @notice Calculates sqrt(a), following the selected rounding direction.
309      */
310     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
311         unchecked {
312             uint256 result = sqrt(a);
313             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
314         }
315     }
316 
317     /**
318      * @dev Return the log in base 2, rounded down, of a positive value.
319      * Returns 0 if given 0.
320      */
321     function log2(uint256 value) internal pure returns (uint256) {
322         uint256 result = 0;
323         unchecked {
324             if (value >> 128 > 0) {
325                 value >>= 128;
326                 result += 128;
327             }
328             if (value >> 64 > 0) {
329                 value >>= 64;
330                 result += 64;
331             }
332             if (value >> 32 > 0) {
333                 value >>= 32;
334                 result += 32;
335             }
336             if (value >> 16 > 0) {
337                 value >>= 16;
338                 result += 16;
339             }
340             if (value >> 8 > 0) {
341                 value >>= 8;
342                 result += 8;
343             }
344             if (value >> 4 > 0) {
345                 value >>= 4;
346                 result += 4;
347             }
348             if (value >> 2 > 0) {
349                 value >>= 2;
350                 result += 2;
351             }
352             if (value >> 1 > 0) {
353                 result += 1;
354             }
355         }
356         return result;
357     }
358 
359     /**
360      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
361      * Returns 0 if given 0.
362      */
363     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
364         unchecked {
365             uint256 result = log2(value);
366             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
367         }
368     }
369 
370     /**
371      * @dev Return the log in base 10, rounded down, of a positive value.
372      * Returns 0 if given 0.
373      */
374     function log10(uint256 value) internal pure returns (uint256) {
375         uint256 result = 0;
376         unchecked {
377             if (value >= 10**64) {
378                 value /= 10**64;
379                 result += 64;
380             }
381             if (value >= 10**32) {
382                 value /= 10**32;
383                 result += 32;
384             }
385             if (value >= 10**16) {
386                 value /= 10**16;
387                 result += 16;
388             }
389             if (value >= 10**8) {
390                 value /= 10**8;
391                 result += 8;
392             }
393             if (value >= 10**4) {
394                 value /= 10**4;
395                 result += 4;
396             }
397             if (value >= 10**2) {
398                 value /= 10**2;
399                 result += 2;
400             }
401             if (value >= 10**1) {
402                 result += 1;
403             }
404         }
405         return result;
406     }
407 
408     /**
409      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
410      * Returns 0 if given 0.
411      */
412     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
413         unchecked {
414             uint256 result = log10(value);
415             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
416         }
417     }
418 
419     /**
420      * @dev Return the log in base 256, rounded down, of a positive value.
421      * Returns 0 if given 0.
422      *
423      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
424      */
425     function log256(uint256 value) internal pure returns (uint256) {
426         uint256 result = 0;
427         unchecked {
428             if (value >> 128 > 0) {
429                 value >>= 128;
430                 result += 16;
431             }
432             if (value >> 64 > 0) {
433                 value >>= 64;
434                 result += 8;
435             }
436             if (value >> 32 > 0) {
437                 value >>= 32;
438                 result += 4;
439             }
440             if (value >> 16 > 0) {
441                 value >>= 16;
442                 result += 2;
443             }
444             if (value >> 8 > 0) {
445                 result += 1;
446             }
447         }
448         return result;
449     }
450 
451     /**
452      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
453      * Returns 0 if given 0.
454      */
455     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
456         unchecked {
457             uint256 result = log256(value);
458             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
459         }
460     }
461 }
462 
463 // File: @openzeppelin/contracts/utils/Strings.sol
464 
465 
466 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 
471 /**
472  * @dev String operations.
473  */
474 library Strings {
475     bytes16 private constant _SYMBOLS = "0123456789abcdef";
476     uint8 private constant _ADDRESS_LENGTH = 20;
477 
478     /**
479      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
480      */
481     function toString(uint256 value) internal pure returns (string memory) {
482         unchecked {
483             uint256 length = Math.log10(value) + 1;
484             string memory buffer = new string(length);
485             uint256 ptr;
486             /// @solidity memory-safe-assembly
487             assembly {
488                 ptr := add(buffer, add(32, length))
489             }
490             while (true) {
491                 ptr--;
492                 /// @solidity memory-safe-assembly
493                 assembly {
494                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
495                 }
496                 value /= 10;
497                 if (value == 0) break;
498             }
499             return buffer;
500         }
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
505      */
506     function toHexString(uint256 value) internal pure returns (string memory) {
507         unchecked {
508             return toHexString(value, Math.log256(value) + 1);
509         }
510     }
511 
512     /**
513      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
514      */
515     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
516         bytes memory buffer = new bytes(2 * length + 2);
517         buffer[0] = "0";
518         buffer[1] = "x";
519         for (uint256 i = 2 * length + 1; i > 1; --i) {
520             buffer[i] = _SYMBOLS[value & 0xf];
521             value >>= 4;
522         }
523         require(value == 0, "Strings: hex length insufficient");
524         return string(buffer);
525     }
526 
527     /**
528      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
529      */
530     function toHexString(address addr) internal pure returns (string memory) {
531         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
532     }
533 }
534 
535 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
536 
537 
538 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev Contract module that helps prevent reentrant calls to a function.
544  *
545  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
546  * available, which can be applied to functions to make sure there are no nested
547  * (reentrant) calls to them.
548  *
549  * Note that because there is a single `nonReentrant` guard, functions marked as
550  * `nonReentrant` may not call one another. This can be worked around by making
551  * those functions `private`, and then adding `external` `nonReentrant` entry
552  * points to them.
553  *
554  * TIP: If you would like to learn more about reentrancy and alternative ways
555  * to protect against it, check out our blog post
556  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
557  */
558 abstract contract ReentrancyGuard {
559     // Booleans are more expensive than uint256 or any type that takes up a full
560     // word because each write operation emits an extra SLOAD to first read the
561     // slot's contents, replace the bits taken up by the boolean, and then write
562     // back. This is the compiler's defense against contract upgrades and
563     // pointer aliasing, and it cannot be disabled.
564 
565     // The values being non-zero value makes deployment a bit more expensive,
566     // but in exchange the refund on every call to nonReentrant will be lower in
567     // amount. Since refunds are capped to a percentage of the total
568     // transaction's gas, it is best to keep them low in cases like this one, to
569     // increase the likelihood of the full refund coming into effect.
570     uint256 private constant _NOT_ENTERED = 1;
571     uint256 private constant _ENTERED = 2;
572 
573     uint256 private _status;
574 
575     constructor() {
576         _status = _NOT_ENTERED;
577     }
578 
579     /**
580      * @dev Prevents a contract from calling itself, directly or indirectly.
581      * Calling a `nonReentrant` function from another `nonReentrant`
582      * function is not supported. It is possible to prevent this from happening
583      * by making the `nonReentrant` function external, and making it call a
584      * `private` function that does the actual work.
585      */
586     modifier nonReentrant() {
587         _nonReentrantBefore();
588         _;
589         _nonReentrantAfter();
590     }
591 
592     function _nonReentrantBefore() private {
593         // On the first call to nonReentrant, _status will be _NOT_ENTERED
594         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
595 
596         // Any calls to nonReentrant after this point will fail
597         _status = _ENTERED;
598     }
599 
600     function _nonReentrantAfter() private {
601         // By storing the original value once again, a refund is triggered (see
602         // https://eips.ethereum.org/EIPS/eip-2200)
603         _status = _NOT_ENTERED;
604     }
605 }
606 
607 // File: @openzeppelin/contracts/utils/Context.sol
608 
609 
610 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @dev Provides information about the current execution context, including the
616  * sender of the transaction and its data. While these are generally available
617  * via msg.sender and msg.data, they should not be accessed in such a direct
618  * manner, since when dealing with meta-transactions the account sending and
619  * paying for execution may not be the actual sender (as far as an application
620  * is concerned).
621  *
622  * This contract is only required for intermediate, library-like contracts.
623  */
624 abstract contract Context {
625     function _msgSender() internal view virtual returns (address) {
626         return msg.sender;
627     }
628 
629     function _msgData() internal view virtual returns (bytes calldata) {
630         return msg.data;
631     }
632 }
633 
634 // File: @openzeppelin/contracts/access/Ownable.sol
635 
636 
637 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 /**
643  * @dev Contract module which provides a basic access control mechanism, where
644  * there is an account (an owner) that can be granted exclusive access to
645  * specific functions.
646  *
647  * By default, the owner account will be the one that deploys the contract. This
648  * can later be changed with {transferOwnership}.
649  *
650  * This module is used through inheritance. It will make available the modifier
651  * `onlyOwner`, which can be applied to your functions to restrict their use to
652  * the owner.
653  */
654 abstract contract Ownable is Context {
655     address private _owner;
656 
657     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
658 
659     /**
660      * @dev Initializes the contract setting the deployer as the initial owner.
661      */
662     constructor() {
663         _transferOwnership(_msgSender());
664     }
665 
666     /**
667      * @dev Throws if called by any account other than the owner.
668      */
669     modifier onlyOwner() {
670         _checkOwner();
671         _;
672     }
673 
674     /**
675      * @dev Returns the address of the current owner.
676      */
677     function owner() public view virtual returns (address) {
678         return _owner;
679     }
680 
681     /**
682      * @dev Throws if the sender is not the owner.
683      */
684     function _checkOwner() internal view virtual {
685         require(owner() == _msgSender(), "Ownable: caller is not the owner");
686     }
687 
688     /**
689      * @dev Leaves the contract without owner. It will not be possible to call
690      * `onlyOwner` functions anymore. Can only be called by the current owner.
691      *
692      * NOTE: Renouncing ownership will leave the contract without an owner,
693      * thereby removing any functionality that is only available to the owner.
694      */
695     function renounceOwnership() public virtual onlyOwner {
696         _transferOwnership(address(0));
697     }
698 
699     /**
700      * @dev Transfers ownership of the contract to a new account (`newOwner`).
701      * Can only be called by the current owner.
702      */
703     function transferOwnership(address newOwner) public virtual onlyOwner {
704         require(newOwner != address(0), "Ownable: new owner is the zero address");
705         _transferOwnership(newOwner);
706     }
707 
708     /**
709      * @dev Transfers ownership of the contract to a new account (`newOwner`).
710      * Internal function without access restriction.
711      */
712     function _transferOwnership(address newOwner) internal virtual {
713         address oldOwner = _owner;
714         _owner = newOwner;
715         emit OwnershipTransferred(oldOwner, newOwner);
716     }
717 }
718 
719 // File: erc721a/contracts/IERC721A.sol
720 
721 
722 // ERC721A Contracts v4.2.3
723 // Creator: Chiru Labs
724 
725 pragma solidity ^0.8.4;
726 
727 /**
728  * @dev Interface of ERC721A.
729  */
730 interface IERC721A {
731     /**
732      * The caller must own the token or be an approved operator.
733      */
734     error ApprovalCallerNotOwnerNorApproved();
735 
736     /**
737      * The token does not exist.
738      */
739     error ApprovalQueryForNonexistentToken();
740 
741     /**
742      * Cannot query the balance for the zero address.
743      */
744     error BalanceQueryForZeroAddress();
745 
746     /**
747      * Cannot mint to the zero address.
748      */
749     error MintToZeroAddress();
750 
751     /**
752      * The quantity of tokens minted must be more than zero.
753      */
754     error MintZeroQuantity();
755 
756     /**
757      * The token does not exist.
758      */
759     error OwnerQueryForNonexistentToken();
760 
761     /**
762      * The caller must own the token or be an approved operator.
763      */
764     error TransferCallerNotOwnerNorApproved();
765 
766     /**
767      * The token must be owned by `from`.
768      */
769     error TransferFromIncorrectOwner();
770 
771     /**
772      * Cannot safely transfer to a contract that does not implement the
773      * ERC721Receiver interface.
774      */
775     error TransferToNonERC721ReceiverImplementer();
776 
777     /**
778      * Cannot transfer to the zero address.
779      */
780     error TransferToZeroAddress();
781 
782     /**
783      * The token does not exist.
784      */
785     error URIQueryForNonexistentToken();
786 
787     /**
788      * The `quantity` minted with ERC2309 exceeds the safety limit.
789      */
790     error MintERC2309QuantityExceedsLimit();
791 
792     /**
793      * The `extraData` cannot be set on an unintialized ownership slot.
794      */
795     error OwnershipNotInitializedForExtraData();
796 
797     // =============================================================
798     //                            STRUCTS
799     // =============================================================
800 
801     struct TokenOwnership {
802         // The address of the owner.
803         address addr;
804         // Stores the start time of ownership with minimal overhead for tokenomics.
805         uint64 startTimestamp;
806         // Whether the token has been burned.
807         bool burned;
808         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
809         uint24 extraData;
810     }
811 
812     // =============================================================
813     //                         TOKEN COUNTERS
814     // =============================================================
815 
816     /**
817      * @dev Returns the total number of tokens in existence.
818      * Burned tokens will reduce the count.
819      * To get the total number of tokens minted, please see {_totalMinted}.
820      */
821     function totalSupply() external view returns (uint256);
822 
823     // =============================================================
824     //                            IERC165
825     // =============================================================
826 
827     /**
828      * @dev Returns true if this contract implements the interface defined by
829      * `interfaceId`. See the corresponding
830      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
831      * to learn more about how these ids are created.
832      *
833      * This function call must use less than 30000 gas.
834      */
835     function supportsInterface(bytes4 interfaceId) external view returns (bool);
836 
837     // =============================================================
838     //                            IERC721
839     // =============================================================
840 
841     /**
842      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
843      */
844     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
845 
846     /**
847      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
848      */
849     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
850 
851     /**
852      * @dev Emitted when `owner` enables or disables
853      * (`approved`) `operator` to manage all of its assets.
854      */
855     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
856 
857     /**
858      * @dev Returns the number of tokens in `owner`'s account.
859      */
860     function balanceOf(address owner) external view returns (uint256 balance);
861 
862     /**
863      * @dev Returns the owner of the `tokenId` token.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      */
869     function ownerOf(uint256 tokenId) external view returns (address owner);
870 
871     /**
872      * @dev Safely transfers `tokenId` token from `from` to `to`,
873      * checking first that contract recipients are aware of the ERC721 protocol
874      * to prevent tokens from being forever locked.
875      *
876      * Requirements:
877      *
878      * - `from` cannot be the zero address.
879      * - `to` cannot be the zero address.
880      * - `tokenId` token must exist and be owned by `from`.
881      * - If the caller is not `from`, it must be have been allowed to move
882      * this token by either {approve} or {setApprovalForAll}.
883      * - If `to` refers to a smart contract, it must implement
884      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
885      *
886      * Emits a {Transfer} event.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId,
892         bytes calldata data
893     ) external payable;
894 
895     /**
896      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) external payable;
903 
904     /**
905      * @dev Transfers `tokenId` from `from` to `to`.
906      *
907      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
908      * whenever possible.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must be owned by `from`.
915      * - If the caller is not `from`, it must be approved to move this token
916      * by either {approve} or {setApprovalForAll}.
917      *
918      * Emits a {Transfer} event.
919      */
920     function transferFrom(
921         address from,
922         address to,
923         uint256 tokenId
924     ) external payable;
925 
926     /**
927      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
928      * The approval is cleared when the token is transferred.
929      *
930      * Only a single account can be approved at a time, so approving the
931      * zero address clears previous approvals.
932      *
933      * Requirements:
934      *
935      * - The caller must own the token or be an approved operator.
936      * - `tokenId` must exist.
937      *
938      * Emits an {Approval} event.
939      */
940     function approve(address to, uint256 tokenId) external payable;
941 
942     /**
943      * @dev Approve or remove `operator` as an operator for the caller.
944      * Operators can call {transferFrom} or {safeTransferFrom}
945      * for any token owned by the caller.
946      *
947      * Requirements:
948      *
949      * - The `operator` cannot be the caller.
950      *
951      * Emits an {ApprovalForAll} event.
952      */
953     function setApprovalForAll(address operator, bool _approved) external;
954 
955     /**
956      * @dev Returns the account approved for `tokenId` token.
957      *
958      * Requirements:
959      *
960      * - `tokenId` must exist.
961      */
962     function getApproved(uint256 tokenId) external view returns (address operator);
963 
964     /**
965      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
966      *
967      * See {setApprovalForAll}.
968      */
969     function isApprovedForAll(address owner, address operator) external view returns (bool);
970 
971     // =============================================================
972     //                        IERC721Metadata
973     // =============================================================
974 
975     /**
976      * @dev Returns the token collection name.
977      */
978     function name() external view returns (string memory);
979 
980     /**
981      * @dev Returns the token collection symbol.
982      */
983     function symbol() external view returns (string memory);
984 
985     /**
986      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
987      */
988     function tokenURI(uint256 tokenId) external view returns (string memory);
989 
990     // =============================================================
991     //                           IERC2309
992     // =============================================================
993 
994     /**
995      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
996      * (inclusive) is transferred from `from` to `to`, as defined in the
997      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
998      *
999      * See {_mintERC2309} for more details.
1000      */
1001     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1002 }
1003 
1004 // File: erc721a/contracts/ERC721A.sol
1005 
1006 
1007 // ERC721A Contracts v4.2.3
1008 // Creator: Chiru Labs
1009 
1010 pragma solidity ^0.8.4;
1011 
1012 
1013 /**
1014  * @dev Interface of ERC721 token receiver.
1015  */
1016 interface ERC721A__IERC721Receiver {
1017     function onERC721Received(
1018         address operator,
1019         address from,
1020         uint256 tokenId,
1021         bytes calldata data
1022     ) external returns (bytes4);
1023 }
1024 
1025 /**
1026  * @title ERC721A
1027  *
1028  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1029  * Non-Fungible Token Standard, including the Metadata extension.
1030  * Optimized for lower gas during batch mints.
1031  *
1032  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1033  * starting from `_startTokenId()`.
1034  *
1035  * Assumptions:
1036  *
1037  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1038  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1039  */
1040 contract ERC721A is IERC721A {
1041     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1042     struct TokenApprovalRef {
1043         address value;
1044     }
1045 
1046     // =============================================================
1047     //                           CONSTANTS
1048     // =============================================================
1049 
1050     // Mask of an entry in packed address data.
1051     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1052 
1053     // The bit position of `numberMinted` in packed address data.
1054     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1055 
1056     // The bit position of `numberBurned` in packed address data.
1057     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1058 
1059     // The bit position of `aux` in packed address data.
1060     uint256 private constant _BITPOS_AUX = 192;
1061 
1062     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1063     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1064 
1065     // The bit position of `startTimestamp` in packed ownership.
1066     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1067 
1068     // The bit mask of the `burned` bit in packed ownership.
1069     uint256 private constant _BITMASK_BURNED = 1 << 224;
1070 
1071     // The bit position of the `nextInitialized` bit in packed ownership.
1072     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1073 
1074     // The bit mask of the `nextInitialized` bit in packed ownership.
1075     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1076 
1077     // The bit position of `extraData` in packed ownership.
1078     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1079 
1080     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1081     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1082 
1083     // The mask of the lower 160 bits for addresses.
1084     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1085 
1086     // The maximum `quantity` that can be minted with {_mintERC2309}.
1087     // This limit is to prevent overflows on the address data entries.
1088     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1089     // is required to cause an overflow, which is unrealistic.
1090     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1091 
1092     // The `Transfer` event signature is given by:
1093     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1094     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1095         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1096 
1097     // =============================================================
1098     //                            STORAGE
1099     // =============================================================
1100 
1101     // The next token ID to be minted.
1102     uint256 private _currentIndex;
1103 
1104     // The number of tokens burned.
1105     uint256 private _burnCounter;
1106 
1107     // Token name
1108     string private _name;
1109 
1110     // Token symbol
1111     string private _symbol;
1112 
1113     // Mapping from token ID to ownership details
1114     // An empty struct value does not necessarily mean the token is unowned.
1115     // See {_packedOwnershipOf} implementation for details.
1116     //
1117     // Bits Layout:
1118     // - [0..159]   `addr`
1119     // - [160..223] `startTimestamp`
1120     // - [224]      `burned`
1121     // - [225]      `nextInitialized`
1122     // - [232..255] `extraData`
1123     mapping(uint256 => uint256) private _packedOwnerships;
1124 
1125     // Mapping owner address to address data.
1126     //
1127     // Bits Layout:
1128     // - [0..63]    `balance`
1129     // - [64..127]  `numberMinted`
1130     // - [128..191] `numberBurned`
1131     // - [192..255] `aux`
1132     mapping(address => uint256) private _packedAddressData;
1133 
1134     // Mapping from token ID to approved address.
1135     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1136 
1137     // Mapping from owner to operator approvals
1138     mapping(address => mapping(address => bool)) private _operatorApprovals;
1139 
1140     // =============================================================
1141     //                          CONSTRUCTOR
1142     // =============================================================
1143 
1144     constructor(string memory name_, string memory symbol_) {
1145         _name = name_;
1146         _symbol = symbol_;
1147         _currentIndex = _startTokenId();
1148     }
1149 
1150     // =============================================================
1151     //                   TOKEN COUNTING OPERATIONS
1152     // =============================================================
1153 
1154     /**
1155      * @dev Returns the starting token ID.
1156      * To change the starting token ID, please override this function.
1157      */
1158     function _startTokenId() internal view virtual returns (uint256) {
1159         return 0;
1160     }
1161 
1162     /**
1163      * @dev Returns the next token ID to be minted.
1164      */
1165     function _nextTokenId() internal view virtual returns (uint256) {
1166         return _currentIndex;
1167     }
1168 
1169     /**
1170      * @dev Returns the total number of tokens in existence.
1171      * Burned tokens will reduce the count.
1172      * To get the total number of tokens minted, please see {_totalMinted}.
1173      */
1174     function totalSupply() public view virtual override returns (uint256) {
1175         // Counter underflow is impossible as _burnCounter cannot be incremented
1176         // more than `_currentIndex - _startTokenId()` times.
1177         unchecked {
1178             return _currentIndex - _burnCounter - _startTokenId();
1179         }
1180     }
1181 
1182     /**
1183      * @dev Returns the total amount of tokens minted in the contract.
1184      */
1185     function _totalMinted() internal view virtual returns (uint256) {
1186         // Counter underflow is impossible as `_currentIndex` does not decrement,
1187         // and it is initialized to `_startTokenId()`.
1188         unchecked {
1189             return _currentIndex - _startTokenId();
1190         }
1191     }
1192 
1193     /**
1194      * @dev Returns the total number of tokens burned.
1195      */
1196     function _totalBurned() internal view virtual returns (uint256) {
1197         return _burnCounter;
1198     }
1199 
1200     // =============================================================
1201     //                    ADDRESS DATA OPERATIONS
1202     // =============================================================
1203 
1204     /**
1205      * @dev Returns the number of tokens in `owner`'s account.
1206      */
1207     function balanceOf(address owner) public view virtual override returns (uint256) {
1208         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1209         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1210     }
1211 
1212     /**
1213      * Returns the number of tokens minted by `owner`.
1214      */
1215     function _numberMinted(address owner) internal view returns (uint256) {
1216         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1217     }
1218 
1219     /**
1220      * Returns the number of tokens burned by or on behalf of `owner`.
1221      */
1222     function _numberBurned(address owner) internal view returns (uint256) {
1223         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1224     }
1225 
1226     /**
1227      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1228      */
1229     function _getAux(address owner) internal view returns (uint64) {
1230         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1231     }
1232 
1233     /**
1234      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1235      * If there are multiple variables, please pack them into a uint64.
1236      */
1237     function _setAux(address owner, uint64 aux) internal virtual {
1238         uint256 packed = _packedAddressData[owner];
1239         uint256 auxCasted;
1240         // Cast `aux` with assembly to avoid redundant masking.
1241         assembly {
1242             auxCasted := aux
1243         }
1244         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1245         _packedAddressData[owner] = packed;
1246     }
1247 
1248     // =============================================================
1249     //                            IERC165
1250     // =============================================================
1251 
1252     /**
1253      * @dev Returns true if this contract implements the interface defined by
1254      * `interfaceId`. See the corresponding
1255      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1256      * to learn more about how these ids are created.
1257      *
1258      * This function call must use less than 30000 gas.
1259      */
1260     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1261         // The interface IDs are constants representing the first 4 bytes
1262         // of the XOR of all function selectors in the interface.
1263         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1264         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1265         return
1266             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1267             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1268             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1269     }
1270 
1271     // =============================================================
1272     //                        IERC721Metadata
1273     // =============================================================
1274 
1275     /**
1276      * @dev Returns the token collection name.
1277      */
1278     function name() public view virtual override returns (string memory) {
1279         return _name;
1280     }
1281 
1282     /**
1283      * @dev Returns the token collection symbol.
1284      */
1285     function symbol() public view virtual override returns (string memory) {
1286         return _symbol;
1287     }
1288 
1289     /**
1290      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1291      */
1292     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1293         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1294 
1295         string memory baseURI = _baseURI();
1296         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1297     }
1298 
1299     /**
1300      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1301      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1302      * by default, it can be overridden in child contracts.
1303      */
1304     function _baseURI() internal view virtual returns (string memory) {
1305         return '';
1306     }
1307 
1308     // =============================================================
1309     //                     OWNERSHIPS OPERATIONS
1310     // =============================================================
1311 
1312     /**
1313      * @dev Returns the owner of the `tokenId` token.
1314      *
1315      * Requirements:
1316      *
1317      * - `tokenId` must exist.
1318      */
1319     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1320         return address(uint160(_packedOwnershipOf(tokenId)));
1321     }
1322 
1323     /**
1324      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1325      * It gradually moves to O(1) as tokens get transferred around over time.
1326      */
1327     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1328         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1329     }
1330 
1331     /**
1332      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1333      */
1334     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1335         return _unpackedOwnership(_packedOwnerships[index]);
1336     }
1337 
1338     /**
1339      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1340      */
1341     function _initializeOwnershipAt(uint256 index) internal virtual {
1342         if (_packedOwnerships[index] == 0) {
1343             _packedOwnerships[index] = _packedOwnershipOf(index);
1344         }
1345     }
1346 
1347     /**
1348      * Returns the packed ownership data of `tokenId`.
1349      */
1350     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1351         uint256 curr = tokenId;
1352 
1353         unchecked {
1354             if (_startTokenId() <= curr)
1355                 if (curr < _currentIndex) {
1356                     uint256 packed = _packedOwnerships[curr];
1357                     // If not burned.
1358                     if (packed & _BITMASK_BURNED == 0) {
1359                         // Invariant:
1360                         // There will always be an initialized ownership slot
1361                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1362                         // before an unintialized ownership slot
1363                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1364                         // Hence, `curr` will not underflow.
1365                         //
1366                         // We can directly compare the packed value.
1367                         // If the address is zero, packed will be zero.
1368                         while (packed == 0) {
1369                             packed = _packedOwnerships[--curr];
1370                         }
1371                         return packed;
1372                     }
1373                 }
1374         }
1375         revert OwnerQueryForNonexistentToken();
1376     }
1377 
1378     /**
1379      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1380      */
1381     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1382         ownership.addr = address(uint160(packed));
1383         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1384         ownership.burned = packed & _BITMASK_BURNED != 0;
1385         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1386     }
1387 
1388     /**
1389      * @dev Packs ownership data into a single uint256.
1390      */
1391     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1392         assembly {
1393             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1394             owner := and(owner, _BITMASK_ADDRESS)
1395             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1396             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1397         }
1398     }
1399 
1400     /**
1401      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1402      */
1403     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1404         // For branchless setting of the `nextInitialized` flag.
1405         assembly {
1406             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1407             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1408         }
1409     }
1410 
1411     // =============================================================
1412     //                      APPROVAL OPERATIONS
1413     // =============================================================
1414 
1415     /**
1416      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1417      * The approval is cleared when the token is transferred.
1418      *
1419      * Only a single account can be approved at a time, so approving the
1420      * zero address clears previous approvals.
1421      *
1422      * Requirements:
1423      *
1424      * - The caller must own the token or be an approved operator.
1425      * - `tokenId` must exist.
1426      *
1427      * Emits an {Approval} event.
1428      */
1429     function approve(address to, uint256 tokenId) public payable virtual override {
1430         address owner = ownerOf(tokenId);
1431 
1432         if (_msgSenderERC721A() != owner)
1433             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1434                 revert ApprovalCallerNotOwnerNorApproved();
1435             }
1436 
1437         _tokenApprovals[tokenId].value = to;
1438         emit Approval(owner, to, tokenId);
1439     }
1440 
1441     /**
1442      * @dev Returns the account approved for `tokenId` token.
1443      *
1444      * Requirements:
1445      *
1446      * - `tokenId` must exist.
1447      */
1448     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1449         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1450 
1451         return _tokenApprovals[tokenId].value;
1452     }
1453 
1454     /**
1455      * @dev Approve or remove `operator` as an operator for the caller.
1456      * Operators can call {transferFrom} or {safeTransferFrom}
1457      * for any token owned by the caller.
1458      *
1459      * Requirements:
1460      *
1461      * - The `operator` cannot be the caller.
1462      *
1463      * Emits an {ApprovalForAll} event.
1464      */
1465     function setApprovalForAll(address operator, bool approved) public virtual override {
1466         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1467         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1468     }
1469 
1470     /**
1471      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1472      *
1473      * See {setApprovalForAll}.
1474      */
1475     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1476         return _operatorApprovals[owner][operator];
1477     }
1478 
1479     /**
1480      * @dev Returns whether `tokenId` exists.
1481      *
1482      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1483      *
1484      * Tokens start existing when they are minted. See {_mint}.
1485      */
1486     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1487         return
1488             _startTokenId() <= tokenId &&
1489             tokenId < _currentIndex && // If within bounds,
1490             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1491     }
1492 
1493     /**
1494      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1495      */
1496     function _isSenderApprovedOrOwner(
1497         address approvedAddress,
1498         address owner,
1499         address msgSender
1500     ) private pure returns (bool result) {
1501         assembly {
1502             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1503             owner := and(owner, _BITMASK_ADDRESS)
1504             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1505             msgSender := and(msgSender, _BITMASK_ADDRESS)
1506             // `msgSender == owner || msgSender == approvedAddress`.
1507             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1508         }
1509     }
1510 
1511     /**
1512      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1513      */
1514     function _getApprovedSlotAndAddress(uint256 tokenId)
1515         private
1516         view
1517         returns (uint256 approvedAddressSlot, address approvedAddress)
1518     {
1519         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1520         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1521         assembly {
1522             approvedAddressSlot := tokenApproval.slot
1523             approvedAddress := sload(approvedAddressSlot)
1524         }
1525     }
1526 
1527     // =============================================================
1528     //                      TRANSFER OPERATIONS
1529     // =============================================================
1530 
1531     /**
1532      * @dev Transfers `tokenId` from `from` to `to`.
1533      *
1534      * Requirements:
1535      *
1536      * - `from` cannot be the zero address.
1537      * - `to` cannot be the zero address.
1538      * - `tokenId` token must be owned by `from`.
1539      * - If the caller is not `from`, it must be approved to move this token
1540      * by either {approve} or {setApprovalForAll}.
1541      *
1542      * Emits a {Transfer} event.
1543      */
1544     function transferFrom(
1545         address from,
1546         address to,
1547         uint256 tokenId
1548     ) public payable virtual override {
1549         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1550 
1551         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1552 
1553         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1554 
1555         // The nested ifs save around 20+ gas over a compound boolean condition.
1556         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1557             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1558 
1559         if (to == address(0)) revert TransferToZeroAddress();
1560 
1561         _beforeTokenTransfers(from, to, tokenId, 1);
1562 
1563         // Clear approvals from the previous owner.
1564         assembly {
1565             if approvedAddress {
1566                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1567                 sstore(approvedAddressSlot, 0)
1568             }
1569         }
1570 
1571         // Underflow of the sender's balance is impossible because we check for
1572         // ownership above and the recipient's balance can't realistically overflow.
1573         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1574         unchecked {
1575             // We can directly increment and decrement the balances.
1576             --_packedAddressData[from]; // Updates: `balance -= 1`.
1577             ++_packedAddressData[to]; // Updates: `balance += 1`.
1578 
1579             // Updates:
1580             // - `address` to the next owner.
1581             // - `startTimestamp` to the timestamp of transfering.
1582             // - `burned` to `false`.
1583             // - `nextInitialized` to `true`.
1584             _packedOwnerships[tokenId] = _packOwnershipData(
1585                 to,
1586                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1587             );
1588 
1589             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1590             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1591                 uint256 nextTokenId = tokenId + 1;
1592                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1593                 if (_packedOwnerships[nextTokenId] == 0) {
1594                     // If the next slot is within bounds.
1595                     if (nextTokenId != _currentIndex) {
1596                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1597                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1598                     }
1599                 }
1600             }
1601         }
1602 
1603         emit Transfer(from, to, tokenId);
1604         _afterTokenTransfers(from, to, tokenId, 1);
1605     }
1606 
1607     /**
1608      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1609      */
1610     function safeTransferFrom(
1611         address from,
1612         address to,
1613         uint256 tokenId
1614     ) public payable virtual override {
1615         safeTransferFrom(from, to, tokenId, '');
1616     }
1617 
1618     /**
1619      * @dev Safely transfers `tokenId` token from `from` to `to`.
1620      *
1621      * Requirements:
1622      *
1623      * - `from` cannot be the zero address.
1624      * - `to` cannot be the zero address.
1625      * - `tokenId` token must exist and be owned by `from`.
1626      * - If the caller is not `from`, it must be approved to move this token
1627      * by either {approve} or {setApprovalForAll}.
1628      * - If `to` refers to a smart contract, it must implement
1629      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1630      *
1631      * Emits a {Transfer} event.
1632      */
1633     function safeTransferFrom(
1634         address from,
1635         address to,
1636         uint256 tokenId,
1637         bytes memory _data
1638     ) public payable virtual override {
1639         transferFrom(from, to, tokenId);
1640         if (to.code.length != 0)
1641             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1642                 revert TransferToNonERC721ReceiverImplementer();
1643             }
1644     }
1645 
1646     /**
1647      * @dev Hook that is called before a set of serially-ordered token IDs
1648      * are about to be transferred. This includes minting.
1649      * And also called before burning one token.
1650      *
1651      * `startTokenId` - the first token ID to be transferred.
1652      * `quantity` - the amount to be transferred.
1653      *
1654      * Calling conditions:
1655      *
1656      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1657      * transferred to `to`.
1658      * - When `from` is zero, `tokenId` will be minted for `to`.
1659      * - When `to` is zero, `tokenId` will be burned by `from`.
1660      * - `from` and `to` are never both zero.
1661      */
1662     function _beforeTokenTransfers(
1663         address from,
1664         address to,
1665         uint256 startTokenId,
1666         uint256 quantity
1667     ) internal virtual {}
1668 
1669     /**
1670      * @dev Hook that is called after a set of serially-ordered token IDs
1671      * have been transferred. This includes minting.
1672      * And also called after one token has been burned.
1673      *
1674      * `startTokenId` - the first token ID to be transferred.
1675      * `quantity` - the amount to be transferred.
1676      *
1677      * Calling conditions:
1678      *
1679      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1680      * transferred to `to`.
1681      * - When `from` is zero, `tokenId` has been minted for `to`.
1682      * - When `to` is zero, `tokenId` has been burned by `from`.
1683      * - `from` and `to` are never both zero.
1684      */
1685     function _afterTokenTransfers(
1686         address from,
1687         address to,
1688         uint256 startTokenId,
1689         uint256 quantity
1690     ) internal virtual {}
1691 
1692     /**
1693      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1694      *
1695      * `from` - Previous owner of the given token ID.
1696      * `to` - Target address that will receive the token.
1697      * `tokenId` - Token ID to be transferred.
1698      * `_data` - Optional data to send along with the call.
1699      *
1700      * Returns whether the call correctly returned the expected magic value.
1701      */
1702     function _checkContractOnERC721Received(
1703         address from,
1704         address to,
1705         uint256 tokenId,
1706         bytes memory _data
1707     ) private returns (bool) {
1708         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1709             bytes4 retval
1710         ) {
1711             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1712         } catch (bytes memory reason) {
1713             if (reason.length == 0) {
1714                 revert TransferToNonERC721ReceiverImplementer();
1715             } else {
1716                 assembly {
1717                     revert(add(32, reason), mload(reason))
1718                 }
1719             }
1720         }
1721     }
1722 
1723     // =============================================================
1724     //                        MINT OPERATIONS
1725     // =============================================================
1726 
1727     /**
1728      * @dev Mints `quantity` tokens and transfers them to `to`.
1729      *
1730      * Requirements:
1731      *
1732      * - `to` cannot be the zero address.
1733      * - `quantity` must be greater than 0.
1734      *
1735      * Emits a {Transfer} event for each mint.
1736      */
1737     function _mint(address to, uint256 quantity) internal virtual {
1738         uint256 startTokenId = _currentIndex;
1739         if (quantity == 0) revert MintZeroQuantity();
1740 
1741         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1742 
1743         // Overflows are incredibly unrealistic.
1744         // `balance` and `numberMinted` have a maximum limit of 2**64.
1745         // `tokenId` has a maximum limit of 2**256.
1746         unchecked {
1747             // Updates:
1748             // - `balance += quantity`.
1749             // - `numberMinted += quantity`.
1750             //
1751             // We can directly add to the `balance` and `numberMinted`.
1752             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1753 
1754             // Updates:
1755             // - `address` to the owner.
1756             // - `startTimestamp` to the timestamp of minting.
1757             // - `burned` to `false`.
1758             // - `nextInitialized` to `quantity == 1`.
1759             _packedOwnerships[startTokenId] = _packOwnershipData(
1760                 to,
1761                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1762             );
1763 
1764             uint256 toMasked;
1765             uint256 end = startTokenId + quantity;
1766 
1767             // Use assembly to loop and emit the `Transfer` event for gas savings.
1768             // The duplicated `log4` removes an extra check and reduces stack juggling.
1769             // The assembly, together with the surrounding Solidity code, have been
1770             // delicately arranged to nudge the compiler into producing optimized opcodes.
1771             assembly {
1772                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1773                 toMasked := and(to, _BITMASK_ADDRESS)
1774                 // Emit the `Transfer` event.
1775                 log4(
1776                     0, // Start of data (0, since no data).
1777                     0, // End of data (0, since no data).
1778                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1779                     0, // `address(0)`.
1780                     toMasked, // `to`.
1781                     startTokenId // `tokenId`.
1782                 )
1783 
1784                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1785                 // that overflows uint256 will make the loop run out of gas.
1786                 // The compiler will optimize the `iszero` away for performance.
1787                 for {
1788                     let tokenId := add(startTokenId, 1)
1789                 } iszero(eq(tokenId, end)) {
1790                     tokenId := add(tokenId, 1)
1791                 } {
1792                     // Emit the `Transfer` event. Similar to above.
1793                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1794                 }
1795             }
1796             if (toMasked == 0) revert MintToZeroAddress();
1797 
1798             _currentIndex = end;
1799         }
1800         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1801     }
1802 
1803     /**
1804      * @dev Mints `quantity` tokens and transfers them to `to`.
1805      *
1806      * This function is intended for efficient minting only during contract creation.
1807      *
1808      * It emits only one {ConsecutiveTransfer} as defined in
1809      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1810      * instead of a sequence of {Transfer} event(s).
1811      *
1812      * Calling this function outside of contract creation WILL make your contract
1813      * non-compliant with the ERC721 standard.
1814      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1815      * {ConsecutiveTransfer} event is only permissible during contract creation.
1816      *
1817      * Requirements:
1818      *
1819      * - `to` cannot be the zero address.
1820      * - `quantity` must be greater than 0.
1821      *
1822      * Emits a {ConsecutiveTransfer} event.
1823      */
1824     function _mintERC2309(address to, uint256 quantity) internal virtual {
1825         uint256 startTokenId = _currentIndex;
1826         if (to == address(0)) revert MintToZeroAddress();
1827         if (quantity == 0) revert MintZeroQuantity();
1828         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1829 
1830         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1831 
1832         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1833         unchecked {
1834             // Updates:
1835             // - `balance += quantity`.
1836             // - `numberMinted += quantity`.
1837             //
1838             // We can directly add to the `balance` and `numberMinted`.
1839             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1840 
1841             // Updates:
1842             // - `address` to the owner.
1843             // - `startTimestamp` to the timestamp of minting.
1844             // - `burned` to `false`.
1845             // - `nextInitialized` to `quantity == 1`.
1846             _packedOwnerships[startTokenId] = _packOwnershipData(
1847                 to,
1848                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1849             );
1850 
1851             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1852 
1853             _currentIndex = startTokenId + quantity;
1854         }
1855         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1856     }
1857 
1858     /**
1859      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1860      *
1861      * Requirements:
1862      *
1863      * - If `to` refers to a smart contract, it must implement
1864      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1865      * - `quantity` must be greater than 0.
1866      *
1867      * See {_mint}.
1868      *
1869      * Emits a {Transfer} event for each mint.
1870      */
1871     function _safeMint(
1872         address to,
1873         uint256 quantity,
1874         bytes memory _data
1875     ) internal virtual {
1876         _mint(to, quantity);
1877 
1878         unchecked {
1879             if (to.code.length != 0) {
1880                 uint256 end = _currentIndex;
1881                 uint256 index = end - quantity;
1882                 do {
1883                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1884                         revert TransferToNonERC721ReceiverImplementer();
1885                     }
1886                 } while (index < end);
1887                 // Reentrancy protection.
1888                 if (_currentIndex != end) revert();
1889             }
1890         }
1891     }
1892 
1893     /**
1894      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1895      */
1896     function _safeMint(address to, uint256 quantity) internal virtual {
1897         _safeMint(to, quantity, '');
1898     }
1899 
1900     // =============================================================
1901     //                        BURN OPERATIONS
1902     // =============================================================
1903 
1904     /**
1905      * @dev Equivalent to `_burn(tokenId, false)`.
1906      */
1907     function _burn(uint256 tokenId) internal virtual {
1908         _burn(tokenId, false);
1909     }
1910 
1911     /**
1912      * @dev Destroys `tokenId`.
1913      * The approval is cleared when the token is burned.
1914      *
1915      * Requirements:
1916      *
1917      * - `tokenId` must exist.
1918      *
1919      * Emits a {Transfer} event.
1920      */
1921     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1922         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1923 
1924         address from = address(uint160(prevOwnershipPacked));
1925 
1926         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1927 
1928         if (approvalCheck) {
1929             // The nested ifs save around 20+ gas over a compound boolean condition.
1930             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1931                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1932         }
1933 
1934         _beforeTokenTransfers(from, address(0), tokenId, 1);
1935 
1936         // Clear approvals from the previous owner.
1937         assembly {
1938             if approvedAddress {
1939                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1940                 sstore(approvedAddressSlot, 0)
1941             }
1942         }
1943 
1944         // Underflow of the sender's balance is impossible because we check for
1945         // ownership above and the recipient's balance can't realistically overflow.
1946         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1947         unchecked {
1948             // Updates:
1949             // - `balance -= 1`.
1950             // - `numberBurned += 1`.
1951             //
1952             // We can directly decrement the balance, and increment the number burned.
1953             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1954             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1955 
1956             // Updates:
1957             // - `address` to the last owner.
1958             // - `startTimestamp` to the timestamp of burning.
1959             // - `burned` to `true`.
1960             // - `nextInitialized` to `true`.
1961             _packedOwnerships[tokenId] = _packOwnershipData(
1962                 from,
1963                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1964             );
1965 
1966             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1967             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1968                 uint256 nextTokenId = tokenId + 1;
1969                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1970                 if (_packedOwnerships[nextTokenId] == 0) {
1971                     // If the next slot is within bounds.
1972                     if (nextTokenId != _currentIndex) {
1973                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1974                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1975                     }
1976                 }
1977             }
1978         }
1979 
1980         emit Transfer(from, address(0), tokenId);
1981         _afterTokenTransfers(from, address(0), tokenId, 1);
1982 
1983         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1984         unchecked {
1985             _burnCounter++;
1986         }
1987     }
1988 
1989     // =============================================================
1990     //                     EXTRA DATA OPERATIONS
1991     // =============================================================
1992 
1993     /**
1994      * @dev Directly sets the extra data for the ownership data `index`.
1995      */
1996     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1997         uint256 packed = _packedOwnerships[index];
1998         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1999         uint256 extraDataCasted;
2000         // Cast `extraData` with assembly to avoid redundant masking.
2001         assembly {
2002             extraDataCasted := extraData
2003         }
2004         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2005         _packedOwnerships[index] = packed;
2006     }
2007 
2008     /**
2009      * @dev Called during each token transfer to set the 24bit `extraData` field.
2010      * Intended to be overridden by the cosumer contract.
2011      *
2012      * `previousExtraData` - the value of `extraData` before transfer.
2013      *
2014      * Calling conditions:
2015      *
2016      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2017      * transferred to `to`.
2018      * - When `from` is zero, `tokenId` will be minted for `to`.
2019      * - When `to` is zero, `tokenId` will be burned by `from`.
2020      * - `from` and `to` are never both zero.
2021      */
2022     function _extraData(
2023         address from,
2024         address to,
2025         uint24 previousExtraData
2026     ) internal view virtual returns (uint24) {}
2027 
2028     /**
2029      * @dev Returns the next extra data for the packed ownership data.
2030      * The returned result is shifted into position.
2031      */
2032     function _nextExtraData(
2033         address from,
2034         address to,
2035         uint256 prevOwnershipPacked
2036     ) private view returns (uint256) {
2037         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2038         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2039     }
2040 
2041     // =============================================================
2042     //                       OTHER OPERATIONS
2043     // =============================================================
2044 
2045     /**
2046      * @dev Returns the message sender (defaults to `msg.sender`).
2047      *
2048      * If you are writing GSN compatible contracts, you need to override this function.
2049      */
2050     function _msgSenderERC721A() internal view virtual returns (address) {
2051         return msg.sender;
2052     }
2053 
2054     /**
2055      * @dev Converts a uint256 to its ASCII string decimal representation.
2056      */
2057     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2058         assembly {
2059             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2060             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2061             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2062             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2063             let m := add(mload(0x40), 0xa0)
2064             // Update the free memory pointer to allocate.
2065             mstore(0x40, m)
2066             // Assign the `str` to the end.
2067             str := sub(m, 0x20)
2068             // Zeroize the slot after the string.
2069             mstore(str, 0)
2070 
2071             // Cache the end of the memory to calculate the length later.
2072             let end := str
2073 
2074             // We write the string from rightmost digit to leftmost digit.
2075             // The following is essentially a do-while loop that also handles the zero case.
2076             // prettier-ignore
2077             for { let temp := value } 1 {} {
2078                 str := sub(str, 1)
2079                 // Write the character to the pointer.
2080                 // The ASCII index of the '0' character is 48.
2081                 mstore8(str, add(48, mod(temp, 10)))
2082                 // Keep dividing `temp` until zero.
2083                 temp := div(temp, 10)
2084                 // prettier-ignore
2085                 if iszero(temp) { break }
2086             }
2087 
2088             let length := sub(end, str)
2089             // Move the pointer 32 bytes leftwards to make room for the length.
2090             str := sub(str, 0x20)
2091             // Store the length.
2092             mstore(str, length)
2093         }
2094     }
2095 }
2096 
2097 // File: 11.sol
2098 
2099 
2100 pragma solidity ^0.8.9;
2101 
2102 
2103 
2104 
2105 
2106 
2107  
2108  
2109  
2110 contract PEPEDETECTIVEAGENCY is ERC721A, DefaultOperatorFilterer, Ownable, ReentrancyGuard { 
2111 event DevMintEvent(address ownerAddress, uint256 startWith, uint256 amountMinted);
2112 uint256 public devTotal;
2113     uint256 public _maxSupply = 400;
2114     uint256 public _mintPrice = 0.004 ether;
2115     uint256 public _maxMintPerTx = 10;
2116  
2117     uint256 public _maxFreeMintPerAddr = 1;
2118     uint256 public _maxFreeMintSupply = 300;
2119      uint256 public devSupply = 0;
2120  
2121     using Strings for uint256;
2122     string public baseURI;
2123  
2124     mapping(address => uint256) private _mintedFreeAmount;
2125  
2126  
2127     constructor(string memory initBaseURI) ERC721A("Pepe Detective Agency", "PDA") {
2128         baseURI = initBaseURI;
2129     }
2130  
2131     function mint(uint256 count) external payable {
2132         uint256 cost = _mintPrice;
2133         bool isFree = ((totalSupply() + count < _maxFreeMintSupply + 1) &&
2134             (_mintedFreeAmount[msg.sender] + count <= _maxFreeMintPerAddr)) ||
2135             (msg.sender == owner());
2136  
2137         if (isFree) {
2138             cost = 0;
2139         }
2140  
2141         require(msg.value >= count * cost, "Please send the exact amount.");
2142         require(totalSupply() + count < _maxSupply - devSupply + 1, "Sold out!");
2143         require(count < _maxMintPerTx + 1, "Max per TX reached.");
2144  
2145         if (isFree) {
2146             _mintedFreeAmount[msg.sender] += count;
2147         }
2148  
2149         _safeMint(msg.sender, count);
2150     }
2151  
2152      function devMint() public onlyOwner {
2153         devTotal += devSupply;
2154         emit DevMintEvent(_msgSender(), devTotal, devSupply);
2155         _safeMint(msg.sender, devSupply);
2156     }
2157  
2158     function _baseURI() internal view virtual override returns (string memory) {
2159         return baseURI;
2160     }
2161  
2162  
2163 function isApprovedForAll(address owner, address operator)
2164         override
2165         public
2166         view
2167         returns (bool)
2168     {
2169         // Block X2Y2
2170         if (operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354) {
2171             return false;
2172         }
2173  
2174  
2175         return super.isApprovedForAll(owner, operator);
2176     }
2177  
2178  
2179  
2180     function tokenURI(uint256 tokenId)
2181         public
2182         view
2183         virtual
2184         override
2185         returns (string memory)
2186     {
2187         require(
2188             _exists(tokenId),
2189             "ERC721Metadata: URI query for nonexistent token"
2190         );
2191         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2192     }
2193  
2194     function setBaseURI(string memory uri) public onlyOwner {
2195         baseURI = uri;
2196     }
2197 
2198     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2199         super.setApprovalForAll(operator, approved);
2200     }
2201 
2202     function approve(address operator, uint256 tokenId) public payable  override onlyAllowedOperatorApproval(operator) {
2203         super.approve(operator, tokenId);
2204     }
2205 
2206     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2207         super.transferFrom(from, to, tokenId);
2208     }
2209 
2210     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2211         super.safeTransferFrom(from, to, tokenId);
2212     }
2213 
2214     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2215         public payable
2216         override
2217         onlyAllowedOperator(from)
2218     {
2219         super.safeTransferFrom(from, to, tokenId, data);
2220     }
2221  
2222     function setFreeAmount(uint256 amount) external onlyOwner {
2223         _maxFreeMintSupply = amount;
2224     }
2225  
2226     function setPrice(uint256 _newPrice) external onlyOwner {
2227         _mintPrice = _newPrice;
2228     }
2229  
2230     function withdraw() public payable onlyOwner nonReentrant {
2231         (bool success, ) = payable(msg.sender).call{
2232             value: address(this).balance
2233         }("");
2234         require(success);
2235     }
2236 }