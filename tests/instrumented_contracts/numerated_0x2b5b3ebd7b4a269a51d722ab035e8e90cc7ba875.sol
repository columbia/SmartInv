1 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
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
33 // File: operator-filter-registry/src/OperatorFilterer.sol
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
95 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
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
603 // File: @openzeppelin/contracts/utils/Context.sol
604 
605 
606 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 /**
611  * @dev Provides information about the current execution context, including the
612  * sender of the transaction and its data. While these are generally available
613  * via msg.sender and msg.data, they should not be accessed in such a direct
614  * manner, since when dealing with meta-transactions the account sending and
615  * paying for execution may not be the actual sender (as far as an application
616  * is concerned).
617  *
618  * This contract is only required for intermediate, library-like contracts.
619  */
620 abstract contract Context {
621     function _msgSender() internal view virtual returns (address) {
622         return msg.sender;
623     }
624 
625     function _msgData() internal view virtual returns (bytes calldata) {
626         return msg.data;
627     }
628 }
629 
630 // File: @openzeppelin/contracts/access/Ownable.sol
631 
632 
633 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @dev Contract module which provides a basic access control mechanism, where
640  * there is an account (an owner) that can be granted exclusive access to
641  * specific functions.
642  *
643  * By default, the owner account will be the one that deploys the contract. This
644  * can later be changed with {transferOwnership}.
645  *
646  * This module is used through inheritance. It will make available the modifier
647  * `onlyOwner`, which can be applied to your functions to restrict their use to
648  * the owner.
649  */
650 abstract contract Ownable is Context {
651     address private _owner;
652 
653     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
654 
655     /**
656      * @dev Initializes the contract setting the deployer as the initial owner.
657      */
658     constructor() {
659         _transferOwnership(_msgSender());
660     }
661 
662     /**
663      * @dev Throws if called by any account other than the owner.
664      */
665     modifier onlyOwner() {
666         _checkOwner();
667         _;
668     }
669 
670     /**
671      * @dev Returns the address of the current owner.
672      */
673     function owner() public view virtual returns (address) {
674         return _owner;
675     }
676 
677     /**
678      * @dev Throws if the sender is not the owner.
679      */
680     function _checkOwner() internal view virtual {
681         require(owner() == _msgSender(), "Ownable: caller is not the owner");
682     }
683 
684     /**
685      * @dev Leaves the contract without owner. It will not be possible to call
686      * `onlyOwner` functions anymore. Can only be called by the current owner.
687      *
688      * NOTE: Renouncing ownership will leave the contract without an owner,
689      * thereby removing any functionality that is only available to the owner.
690      */
691     function renounceOwnership() public virtual onlyOwner {
692         _transferOwnership(address(0));
693     }
694 
695     /**
696      * @dev Transfers ownership of the contract to a new account (`newOwner`).
697      * Can only be called by the current owner.
698      */
699     function transferOwnership(address newOwner) public virtual onlyOwner {
700         require(newOwner != address(0), "Ownable: new owner is the zero address");
701         _transferOwnership(newOwner);
702     }
703 
704     /**
705      * @dev Transfers ownership of the contract to a new account (`newOwner`).
706      * Internal function without access restriction.
707      */
708     function _transferOwnership(address newOwner) internal virtual {
709         address oldOwner = _owner;
710         _owner = newOwner;
711         emit OwnershipTransferred(oldOwner, newOwner);
712     }
713 }
714 
715 // File: erc721a/contracts/IERC721A.sol
716 
717 
718 // ERC721A Contracts v4.2.3
719 // Creator: Chiru Labs
720 
721 pragma solidity ^0.8.4;
722 
723 /**
724  * @dev Interface of ERC721A.
725  */
726 interface IERC721A {
727     /**
728      * The caller must own the token or be an approved operator.
729      */
730     error ApprovalCallerNotOwnerNorApproved();
731 
732     /**
733      * The token does not exist.
734      */
735     error ApprovalQueryForNonexistentToken();
736 
737     /**
738      * Cannot query the balance for the zero address.
739      */
740     error BalanceQueryForZeroAddress();
741 
742     /**
743      * Cannot mint to the zero address.
744      */
745     error MintToZeroAddress();
746 
747     /**
748      * The quantity of tokens minted must be more than zero.
749      */
750     error MintZeroQuantity();
751 
752     /**
753      * The token does not exist.
754      */
755     error OwnerQueryForNonexistentToken();
756 
757     /**
758      * The caller must own the token or be an approved operator.
759      */
760     error TransferCallerNotOwnerNorApproved();
761 
762     /**
763      * The token must be owned by `from`.
764      */
765     error TransferFromIncorrectOwner();
766 
767     /**
768      * Cannot safely transfer to a contract that does not implement the
769      * ERC721Receiver interface.
770      */
771     error TransferToNonERC721ReceiverImplementer();
772 
773     /**
774      * Cannot transfer to the zero address.
775      */
776     error TransferToZeroAddress();
777 
778     /**
779      * The token does not exist.
780      */
781     error URIQueryForNonexistentToken();
782 
783     /**
784      * The `quantity` minted with ERC2309 exceeds the safety limit.
785      */
786     error MintERC2309QuantityExceedsLimit();
787 
788     /**
789      * The `extraData` cannot be set on an unintialized ownership slot.
790      */
791     error OwnershipNotInitializedForExtraData();
792 
793     // =============================================================
794     //                            STRUCTS
795     // =============================================================
796 
797     struct TokenOwnership {
798         // The address of the owner.
799         address addr;
800         // Stores the start time of ownership with minimal overhead for tokenomics.
801         uint64 startTimestamp;
802         // Whether the token has been burned.
803         bool burned;
804         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
805         uint24 extraData;
806     }
807 
808     // =============================================================
809     //                         TOKEN COUNTERS
810     // =============================================================
811 
812     /**
813      * @dev Returns the total number of tokens in existence.
814      * Burned tokens will reduce the count.
815      * To get the total number of tokens minted, please see {_totalMinted}.
816      */
817     function totalSupply() external view returns (uint256);
818 
819     // =============================================================
820     //                            IERC165
821     // =============================================================
822 
823     /**
824      * @dev Returns true if this contract implements the interface defined by
825      * `interfaceId`. See the corresponding
826      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
827      * to learn more about how these ids are created.
828      *
829      * This function call must use less than 30000 gas.
830      */
831     function supportsInterface(bytes4 interfaceId) external view returns (bool);
832 
833     // =============================================================
834     //                            IERC721
835     // =============================================================
836 
837     /**
838      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
839      */
840     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
841 
842     /**
843      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
844      */
845     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
846 
847     /**
848      * @dev Emitted when `owner` enables or disables
849      * (`approved`) `operator` to manage all of its assets.
850      */
851     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
852 
853     /**
854      * @dev Returns the number of tokens in `owner`'s account.
855      */
856     function balanceOf(address owner) external view returns (uint256 balance);
857 
858     /**
859      * @dev Returns the owner of the `tokenId` token.
860      *
861      * Requirements:
862      *
863      * - `tokenId` must exist.
864      */
865     function ownerOf(uint256 tokenId) external view returns (address owner);
866 
867     /**
868      * @dev Safely transfers `tokenId` token from `from` to `to`,
869      * checking first that contract recipients are aware of the ERC721 protocol
870      * to prevent tokens from being forever locked.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must exist and be owned by `from`.
877      * - If the caller is not `from`, it must be have been allowed to move
878      * this token by either {approve} or {setApprovalForAll}.
879      * - If `to` refers to a smart contract, it must implement
880      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
881      *
882      * Emits a {Transfer} event.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes calldata data
889     ) external payable;
890 
891     /**
892      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
893      */
894     function safeTransferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) external payable;
899 
900     /**
901      * @dev Transfers `tokenId` from `from` to `to`.
902      *
903      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
904      * whenever possible.
905      *
906      * Requirements:
907      *
908      * - `from` cannot be the zero address.
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must be owned by `from`.
911      * - If the caller is not `from`, it must be approved to move this token
912      * by either {approve} or {setApprovalForAll}.
913      *
914      * Emits a {Transfer} event.
915      */
916     function transferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) external payable;
921 
922     /**
923      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
924      * The approval is cleared when the token is transferred.
925      *
926      * Only a single account can be approved at a time, so approving the
927      * zero address clears previous approvals.
928      *
929      * Requirements:
930      *
931      * - The caller must own the token or be an approved operator.
932      * - `tokenId` must exist.
933      *
934      * Emits an {Approval} event.
935      */
936     function approve(address to, uint256 tokenId) external payable;
937 
938     /**
939      * @dev Approve or remove `operator` as an operator for the caller.
940      * Operators can call {transferFrom} or {safeTransferFrom}
941      * for any token owned by the caller.
942      *
943      * Requirements:
944      *
945      * - The `operator` cannot be the caller.
946      *
947      * Emits an {ApprovalForAll} event.
948      */
949     function setApprovalForAll(address operator, bool _approved) external;
950 
951     /**
952      * @dev Returns the account approved for `tokenId` token.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      */
958     function getApproved(uint256 tokenId) external view returns (address operator);
959 
960     /**
961      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
962      *
963      * See {setApprovalForAll}.
964      */
965     function isApprovedForAll(address owner, address operator) external view returns (bool);
966 
967     // =============================================================
968     //                        IERC721Metadata
969     // =============================================================
970 
971     /**
972      * @dev Returns the token collection name.
973      */
974     function name() external view returns (string memory);
975 
976     /**
977      * @dev Returns the token collection symbol.
978      */
979     function symbol() external view returns (string memory);
980 
981     /**
982      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
983      */
984     function tokenURI(uint256 tokenId) external view returns (string memory);
985 
986     // =============================================================
987     //                           IERC2309
988     // =============================================================
989 
990     /**
991      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
992      * (inclusive) is transferred from `from` to `to`, as defined in the
993      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
994      *
995      * See {_mintERC2309} for more details.
996      */
997     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
998 }
999 
1000 // File: erc721a/contracts/ERC721A.sol
1001 
1002 
1003 // ERC721A Contracts v4.2.3
1004 // Creator: Chiru Labs
1005 
1006 pragma solidity ^0.8.4;
1007 
1008 
1009 /**
1010  * @dev Interface of ERC721 token receiver.
1011  */
1012 interface ERC721A__IERC721Receiver {
1013     function onERC721Received(
1014         address operator,
1015         address from,
1016         uint256 tokenId,
1017         bytes calldata data
1018     ) external returns (bytes4);
1019 }
1020 
1021 /**
1022  * @title ERC721A
1023  *
1024  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1025  * Non-Fungible Token Standard, including the Metadata extension.
1026  * Optimized for lower gas during batch mints.
1027  *
1028  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1029  * starting from `_startTokenId()`.
1030  *
1031  * Assumptions:
1032  *
1033  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1034  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1035  */
1036 contract ERC721A is IERC721A {
1037     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1038     struct TokenApprovalRef {
1039         address value;
1040     }
1041 
1042     // =============================================================
1043     //                           CONSTANTS
1044     // =============================================================
1045 
1046     // Mask of an entry in packed address data.
1047     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1048 
1049     // The bit position of `numberMinted` in packed address data.
1050     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1051 
1052     // The bit position of `numberBurned` in packed address data.
1053     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1054 
1055     // The bit position of `aux` in packed address data.
1056     uint256 private constant _BITPOS_AUX = 192;
1057 
1058     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1059     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1060 
1061     // The bit position of `startTimestamp` in packed ownership.
1062     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1063 
1064     // The bit mask of the `burned` bit in packed ownership.
1065     uint256 private constant _BITMASK_BURNED = 1 << 224;
1066 
1067     // The bit position of the `nextInitialized` bit in packed ownership.
1068     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1069 
1070     // The bit mask of the `nextInitialized` bit in packed ownership.
1071     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1072 
1073     // The bit position of `extraData` in packed ownership.
1074     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1075 
1076     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1077     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1078 
1079     // The mask of the lower 160 bits for addresses.
1080     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1081 
1082     // The maximum `quantity` that can be minted with {_mintERC2309}.
1083     // This limit is to prevent overflows on the address data entries.
1084     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1085     // is required to cause an overflow, which is unrealistic.
1086     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1087 
1088     // The `Transfer` event signature is given by:
1089     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1090     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1091         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1092 
1093     // =============================================================
1094     //                            STORAGE
1095     // =============================================================
1096 
1097     // The next token ID to be minted.
1098     uint256 private _currentIndex;
1099 
1100     // The number of tokens burned.
1101     uint256 private _burnCounter;
1102 
1103     // Token name
1104     string private _name;
1105 
1106     // Token symbol
1107     string private _symbol;
1108 
1109     // Mapping from token ID to ownership details
1110     // An empty struct value does not necessarily mean the token is unowned.
1111     // See {_packedOwnershipOf} implementation for details.
1112     //
1113     // Bits Layout:
1114     // - [0..159]   `addr`
1115     // - [160..223] `startTimestamp`
1116     // - [224]      `burned`
1117     // - [225]      `nextInitialized`
1118     // - [232..255] `extraData`
1119     mapping(uint256 => uint256) private _packedOwnerships;
1120 
1121     // Mapping owner address to address data.
1122     //
1123     // Bits Layout:
1124     // - [0..63]    `balance`
1125     // - [64..127]  `numberMinted`
1126     // - [128..191] `numberBurned`
1127     // - [192..255] `aux`
1128     mapping(address => uint256) private _packedAddressData;
1129 
1130     // Mapping from token ID to approved address.
1131     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1132 
1133     // Mapping from owner to operator approvals
1134     mapping(address => mapping(address => bool)) private _operatorApprovals;
1135 
1136     // =============================================================
1137     //                          CONSTRUCTOR
1138     // =============================================================
1139 
1140     constructor(string memory name_, string memory symbol_) {
1141         _name = name_;
1142         _symbol = symbol_;
1143         _currentIndex = _startTokenId();
1144     }
1145 
1146     // =============================================================
1147     //                   TOKEN COUNTING OPERATIONS
1148     // =============================================================
1149 
1150     /**
1151      * @dev Returns the starting token ID.
1152      * To change the starting token ID, please override this function.
1153      */
1154     function _startTokenId() internal view virtual returns (uint256) {
1155         return 0;
1156     }
1157 
1158     /**
1159      * @dev Returns the next token ID to be minted.
1160      */
1161     function _nextTokenId() internal view virtual returns (uint256) {
1162         return _currentIndex;
1163     }
1164 
1165     /**
1166      * @dev Returns the total number of tokens in existence.
1167      * Burned tokens will reduce the count.
1168      * To get the total number of tokens minted, please see {_totalMinted}.
1169      */
1170     function totalSupply() public view virtual override returns (uint256) {
1171         // Counter underflow is impossible as _burnCounter cannot be incremented
1172         // more than `_currentIndex - _startTokenId()` times.
1173         unchecked {
1174             return _currentIndex - _burnCounter - _startTokenId();
1175         }
1176     }
1177 
1178     /**
1179      * @dev Returns the total amount of tokens minted in the contract.
1180      */
1181     function _totalMinted() internal view virtual returns (uint256) {
1182         // Counter underflow is impossible as `_currentIndex` does not decrement,
1183         // and it is initialized to `_startTokenId()`.
1184         unchecked {
1185             return _currentIndex - _startTokenId();
1186         }
1187     }
1188 
1189     /**
1190      * @dev Returns the total number of tokens burned.
1191      */
1192     function _totalBurned() internal view virtual returns (uint256) {
1193         return _burnCounter;
1194     }
1195 
1196     // =============================================================
1197     //                    ADDRESS DATA OPERATIONS
1198     // =============================================================
1199 
1200     /**
1201      * @dev Returns the number of tokens in `owner`'s account.
1202      */
1203     function balanceOf(address owner) public view virtual override returns (uint256) {
1204         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1205         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1206     }
1207 
1208     /**
1209      * Returns the number of tokens minted by `owner`.
1210      */
1211     function _numberMinted(address owner) internal view returns (uint256) {
1212         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1213     }
1214 
1215     /**
1216      * Returns the number of tokens burned by or on behalf of `owner`.
1217      */
1218     function _numberBurned(address owner) internal view returns (uint256) {
1219         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1220     }
1221 
1222     /**
1223      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1224      */
1225     function _getAux(address owner) internal view returns (uint64) {
1226         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1227     }
1228 
1229     /**
1230      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1231      * If there are multiple variables, please pack them into a uint64.
1232      */
1233     function _setAux(address owner, uint64 aux) internal virtual {
1234         uint256 packed = _packedAddressData[owner];
1235         uint256 auxCasted;
1236         // Cast `aux` with assembly to avoid redundant masking.
1237         assembly {
1238             auxCasted := aux
1239         }
1240         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1241         _packedAddressData[owner] = packed;
1242     }
1243 
1244     // =============================================================
1245     //                            IERC165
1246     // =============================================================
1247 
1248     /**
1249      * @dev Returns true if this contract implements the interface defined by
1250      * `interfaceId`. See the corresponding
1251      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1252      * to learn more about how these ids are created.
1253      *
1254      * This function call must use less than 30000 gas.
1255      */
1256     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1257         // The interface IDs are constants representing the first 4 bytes
1258         // of the XOR of all function selectors in the interface.
1259         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1260         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1261         return
1262             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1263             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1264             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1265     }
1266 
1267     // =============================================================
1268     //                        IERC721Metadata
1269     // =============================================================
1270 
1271     /**
1272      * @dev Returns the token collection name.
1273      */
1274     function name() public view virtual override returns (string memory) {
1275         return _name;
1276     }
1277 
1278     /**
1279      * @dev Returns the token collection symbol.
1280      */
1281     function symbol() public view virtual override returns (string memory) {
1282         return _symbol;
1283     }
1284 
1285     /**
1286      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1287      */
1288     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1289         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1290 
1291         string memory baseURI = _baseURI();
1292         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1293     }
1294 
1295     /**
1296      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1297      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1298      * by default, it can be overridden in child contracts.
1299      */
1300     function _baseURI() internal view virtual returns (string memory) {
1301         return '';
1302     }
1303 
1304     // =============================================================
1305     //                     OWNERSHIPS OPERATIONS
1306     // =============================================================
1307 
1308     /**
1309      * @dev Returns the owner of the `tokenId` token.
1310      *
1311      * Requirements:
1312      *
1313      * - `tokenId` must exist.
1314      */
1315     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1316         return address(uint160(_packedOwnershipOf(tokenId)));
1317     }
1318 
1319     /**
1320      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1321      * It gradually moves to O(1) as tokens get transferred around over time.
1322      */
1323     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1324         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1325     }
1326 
1327     /**
1328      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1329      */
1330     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1331         return _unpackedOwnership(_packedOwnerships[index]);
1332     }
1333 
1334     /**
1335      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1336      */
1337     function _initializeOwnershipAt(uint256 index) internal virtual {
1338         if (_packedOwnerships[index] == 0) {
1339             _packedOwnerships[index] = _packedOwnershipOf(index);
1340         }
1341     }
1342 
1343     /**
1344      * Returns the packed ownership data of `tokenId`.
1345      */
1346     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1347         uint256 curr = tokenId;
1348 
1349         unchecked {
1350             if (_startTokenId() <= curr)
1351                 if (curr < _currentIndex) {
1352                     uint256 packed = _packedOwnerships[curr];
1353                     // If not burned.
1354                     if (packed & _BITMASK_BURNED == 0) {
1355                         // Invariant:
1356                         // There will always be an initialized ownership slot
1357                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1358                         // before an unintialized ownership slot
1359                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1360                         // Hence, `curr` will not underflow.
1361                         //
1362                         // We can directly compare the packed value.
1363                         // If the address is zero, packed will be zero.
1364                         while (packed == 0) {
1365                             packed = _packedOwnerships[--curr];
1366                         }
1367                         return packed;
1368                     }
1369                 }
1370         }
1371         revert OwnerQueryForNonexistentToken();
1372     }
1373 
1374     /**
1375      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1376      */
1377     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1378         ownership.addr = address(uint160(packed));
1379         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1380         ownership.burned = packed & _BITMASK_BURNED != 0;
1381         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1382     }
1383 
1384     /**
1385      * @dev Packs ownership data into a single uint256.
1386      */
1387     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1388         assembly {
1389             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1390             owner := and(owner, _BITMASK_ADDRESS)
1391             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1392             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1393         }
1394     }
1395 
1396     /**
1397      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1398      */
1399     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1400         // For branchless setting of the `nextInitialized` flag.
1401         assembly {
1402             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1403             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1404         }
1405     }
1406 
1407     // =============================================================
1408     //                      APPROVAL OPERATIONS
1409     // =============================================================
1410 
1411     /**
1412      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1413      * The approval is cleared when the token is transferred.
1414      *
1415      * Only a single account can be approved at a time, so approving the
1416      * zero address clears previous approvals.
1417      *
1418      * Requirements:
1419      *
1420      * - The caller must own the token or be an approved operator.
1421      * - `tokenId` must exist.
1422      *
1423      * Emits an {Approval} event.
1424      */
1425     function approve(address to, uint256 tokenId) public payable virtual override {
1426         address owner = ownerOf(tokenId);
1427 
1428         if (_msgSenderERC721A() != owner)
1429             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1430                 revert ApprovalCallerNotOwnerNorApproved();
1431             }
1432 
1433         _tokenApprovals[tokenId].value = to;
1434         emit Approval(owner, to, tokenId);
1435     }
1436 
1437     /**
1438      * @dev Returns the account approved for `tokenId` token.
1439      *
1440      * Requirements:
1441      *
1442      * - `tokenId` must exist.
1443      */
1444     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1445         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1446 
1447         return _tokenApprovals[tokenId].value;
1448     }
1449 
1450     /**
1451      * @dev Approve or remove `operator` as an operator for the caller.
1452      * Operators can call {transferFrom} or {safeTransferFrom}
1453      * for any token owned by the caller.
1454      *
1455      * Requirements:
1456      *
1457      * - The `operator` cannot be the caller.
1458      *
1459      * Emits an {ApprovalForAll} event.
1460      */
1461     function setApprovalForAll(address operator, bool approved) public virtual override {
1462         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1463         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1464     }
1465 
1466     /**
1467      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1468      *
1469      * See {setApprovalForAll}.
1470      */
1471     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1472         return _operatorApprovals[owner][operator];
1473     }
1474 
1475     /**
1476      * @dev Returns whether `tokenId` exists.
1477      *
1478      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1479      *
1480      * Tokens start existing when they are minted. See {_mint}.
1481      */
1482     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1483         return
1484             _startTokenId() <= tokenId &&
1485             tokenId < _currentIndex && // If within bounds,
1486             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1487     }
1488 
1489     /**
1490      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1491      */
1492     function _isSenderApprovedOrOwner(
1493         address approvedAddress,
1494         address owner,
1495         address msgSender
1496     ) private pure returns (bool result) {
1497         assembly {
1498             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1499             owner := and(owner, _BITMASK_ADDRESS)
1500             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1501             msgSender := and(msgSender, _BITMASK_ADDRESS)
1502             // `msgSender == owner || msgSender == approvedAddress`.
1503             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1504         }
1505     }
1506 
1507     /**
1508      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1509      */
1510     function _getApprovedSlotAndAddress(uint256 tokenId)
1511         private
1512         view
1513         returns (uint256 approvedAddressSlot, address approvedAddress)
1514     {
1515         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1516         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1517         assembly {
1518             approvedAddressSlot := tokenApproval.slot
1519             approvedAddress := sload(approvedAddressSlot)
1520         }
1521     }
1522 
1523     // =============================================================
1524     //                      TRANSFER OPERATIONS
1525     // =============================================================
1526 
1527     /**
1528      * @dev Transfers `tokenId` from `from` to `to`.
1529      *
1530      * Requirements:
1531      *
1532      * - `from` cannot be the zero address.
1533      * - `to` cannot be the zero address.
1534      * - `tokenId` token must be owned by `from`.
1535      * - If the caller is not `from`, it must be approved to move this token
1536      * by either {approve} or {setApprovalForAll}.
1537      *
1538      * Emits a {Transfer} event.
1539      */
1540     function transferFrom(
1541         address from,
1542         address to,
1543         uint256 tokenId
1544     ) public payable virtual override {
1545         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1546 
1547         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1548 
1549         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1550 
1551         // The nested ifs save around 20+ gas over a compound boolean condition.
1552         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1553             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1554 
1555         if (to == address(0)) revert TransferToZeroAddress();
1556 
1557         _beforeTokenTransfers(from, to, tokenId, 1);
1558 
1559         // Clear approvals from the previous owner.
1560         assembly {
1561             if approvedAddress {
1562                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1563                 sstore(approvedAddressSlot, 0)
1564             }
1565         }
1566 
1567         // Underflow of the sender's balance is impossible because we check for
1568         // ownership above and the recipient's balance can't realistically overflow.
1569         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1570         unchecked {
1571             // We can directly increment and decrement the balances.
1572             --_packedAddressData[from]; // Updates: `balance -= 1`.
1573             ++_packedAddressData[to]; // Updates: `balance += 1`.
1574 
1575             // Updates:
1576             // - `address` to the next owner.
1577             // - `startTimestamp` to the timestamp of transfering.
1578             // - `burned` to `false`.
1579             // - `nextInitialized` to `true`.
1580             _packedOwnerships[tokenId] = _packOwnershipData(
1581                 to,
1582                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1583             );
1584 
1585             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1586             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1587                 uint256 nextTokenId = tokenId + 1;
1588                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1589                 if (_packedOwnerships[nextTokenId] == 0) {
1590                     // If the next slot is within bounds.
1591                     if (nextTokenId != _currentIndex) {
1592                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1593                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1594                     }
1595                 }
1596             }
1597         }
1598 
1599         emit Transfer(from, to, tokenId);
1600         _afterTokenTransfers(from, to, tokenId, 1);
1601     }
1602 
1603     /**
1604      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1605      */
1606     function safeTransferFrom(
1607         address from,
1608         address to,
1609         uint256 tokenId
1610     ) public payable virtual override {
1611         safeTransferFrom(from, to, tokenId, '');
1612     }
1613 
1614     /**
1615      * @dev Safely transfers `tokenId` token from `from` to `to`.
1616      *
1617      * Requirements:
1618      *
1619      * - `from` cannot be the zero address.
1620      * - `to` cannot be the zero address.
1621      * - `tokenId` token must exist and be owned by `from`.
1622      * - If the caller is not `from`, it must be approved to move this token
1623      * by either {approve} or {setApprovalForAll}.
1624      * - If `to` refers to a smart contract, it must implement
1625      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1626      *
1627      * Emits a {Transfer} event.
1628      */
1629     function safeTransferFrom(
1630         address from,
1631         address to,
1632         uint256 tokenId,
1633         bytes memory _data
1634     ) public payable virtual override {
1635         transferFrom(from, to, tokenId);
1636         if (to.code.length != 0)
1637             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1638                 revert TransferToNonERC721ReceiverImplementer();
1639             }
1640     }
1641 
1642     /**
1643      * @dev Hook that is called before a set of serially-ordered token IDs
1644      * are about to be transferred. This includes minting.
1645      * And also called before burning one token.
1646      *
1647      * `startTokenId` - the first token ID to be transferred.
1648      * `quantity` - the amount to be transferred.
1649      *
1650      * Calling conditions:
1651      *
1652      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1653      * transferred to `to`.
1654      * - When `from` is zero, `tokenId` will be minted for `to`.
1655      * - When `to` is zero, `tokenId` will be burned by `from`.
1656      * - `from` and `to` are never both zero.
1657      */
1658     function _beforeTokenTransfers(
1659         address from,
1660         address to,
1661         uint256 startTokenId,
1662         uint256 quantity
1663     ) internal virtual {}
1664 
1665     /**
1666      * @dev Hook that is called after a set of serially-ordered token IDs
1667      * have been transferred. This includes minting.
1668      * And also called after one token has been burned.
1669      *
1670      * `startTokenId` - the first token ID to be transferred.
1671      * `quantity` - the amount to be transferred.
1672      *
1673      * Calling conditions:
1674      *
1675      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1676      * transferred to `to`.
1677      * - When `from` is zero, `tokenId` has been minted for `to`.
1678      * - When `to` is zero, `tokenId` has been burned by `from`.
1679      * - `from` and `to` are never both zero.
1680      */
1681     function _afterTokenTransfers(
1682         address from,
1683         address to,
1684         uint256 startTokenId,
1685         uint256 quantity
1686     ) internal virtual {}
1687 
1688     /**
1689      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1690      *
1691      * `from` - Previous owner of the given token ID.
1692      * `to` - Target address that will receive the token.
1693      * `tokenId` - Token ID to be transferred.
1694      * `_data` - Optional data to send along with the call.
1695      *
1696      * Returns whether the call correctly returned the expected magic value.
1697      */
1698     function _checkContractOnERC721Received(
1699         address from,
1700         address to,
1701         uint256 tokenId,
1702         bytes memory _data
1703     ) private returns (bool) {
1704         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1705             bytes4 retval
1706         ) {
1707             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1708         } catch (bytes memory reason) {
1709             if (reason.length == 0) {
1710                 revert TransferToNonERC721ReceiverImplementer();
1711             } else {
1712                 assembly {
1713                     revert(add(32, reason), mload(reason))
1714                 }
1715             }
1716         }
1717     }
1718 
1719     // =============================================================
1720     //                        MINT OPERATIONS
1721     // =============================================================
1722 
1723     /**
1724      * @dev Mints `quantity` tokens and transfers them to `to`.
1725      *
1726      * Requirements:
1727      *
1728      * - `to` cannot be the zero address.
1729      * - `quantity` must be greater than 0.
1730      *
1731      * Emits a {Transfer} event for each mint.
1732      */
1733     function _mint(address to, uint256 quantity) internal virtual {
1734         uint256 startTokenId = _currentIndex;
1735         if (quantity == 0) revert MintZeroQuantity();
1736 
1737         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1738 
1739         // Overflows are incredibly unrealistic.
1740         // `balance` and `numberMinted` have a maximum limit of 2**64.
1741         // `tokenId` has a maximum limit of 2**256.
1742         unchecked {
1743             // Updates:
1744             // - `balance += quantity`.
1745             // - `numberMinted += quantity`.
1746             //
1747             // We can directly add to the `balance` and `numberMinted`.
1748             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1749 
1750             // Updates:
1751             // - `address` to the owner.
1752             // - `startTimestamp` to the timestamp of minting.
1753             // - `burned` to `false`.
1754             // - `nextInitialized` to `quantity == 1`.
1755             _packedOwnerships[startTokenId] = _packOwnershipData(
1756                 to,
1757                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1758             );
1759 
1760             uint256 toMasked;
1761             uint256 end = startTokenId + quantity;
1762 
1763             // Use assembly to loop and emit the `Transfer` event for gas savings.
1764             // The duplicated `log4` removes an extra check and reduces stack juggling.
1765             // The assembly, together with the surrounding Solidity code, have been
1766             // delicately arranged to nudge the compiler into producing optimized opcodes.
1767             assembly {
1768                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1769                 toMasked := and(to, _BITMASK_ADDRESS)
1770                 // Emit the `Transfer` event.
1771                 log4(
1772                     0, // Start of data (0, since no data).
1773                     0, // End of data (0, since no data).
1774                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1775                     0, // `address(0)`.
1776                     toMasked, // `to`.
1777                     startTokenId // `tokenId`.
1778                 )
1779 
1780                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1781                 // that overflows uint256 will make the loop run out of gas.
1782                 // The compiler will optimize the `iszero` away for performance.
1783                 for {
1784                     let tokenId := add(startTokenId, 1)
1785                 } iszero(eq(tokenId, end)) {
1786                     tokenId := add(tokenId, 1)
1787                 } {
1788                     // Emit the `Transfer` event. Similar to above.
1789                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1790                 }
1791             }
1792             if (toMasked == 0) revert MintToZeroAddress();
1793 
1794             _currentIndex = end;
1795         }
1796         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1797     }
1798 
1799     /**
1800      * @dev Mints `quantity` tokens and transfers them to `to`.
1801      *
1802      * This function is intended for efficient minting only during contract creation.
1803      *
1804      * It emits only one {ConsecutiveTransfer} as defined in
1805      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1806      * instead of a sequence of {Transfer} event(s).
1807      *
1808      * Calling this function outside of contract creation WILL make your contract
1809      * non-compliant with the ERC721 standard.
1810      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1811      * {ConsecutiveTransfer} event is only permissible during contract creation.
1812      *
1813      * Requirements:
1814      *
1815      * - `to` cannot be the zero address.
1816      * - `quantity` must be greater than 0.
1817      *
1818      * Emits a {ConsecutiveTransfer} event.
1819      */
1820     function _mintERC2309(address to, uint256 quantity) internal virtual {
1821         uint256 startTokenId = _currentIndex;
1822         if (to == address(0)) revert MintToZeroAddress();
1823         if (quantity == 0) revert MintZeroQuantity();
1824         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1825 
1826         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1827 
1828         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1829         unchecked {
1830             // Updates:
1831             // - `balance += quantity`.
1832             // - `numberMinted += quantity`.
1833             //
1834             // We can directly add to the `balance` and `numberMinted`.
1835             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1836 
1837             // Updates:
1838             // - `address` to the owner.
1839             // - `startTimestamp` to the timestamp of minting.
1840             // - `burned` to `false`.
1841             // - `nextInitialized` to `quantity == 1`.
1842             _packedOwnerships[startTokenId] = _packOwnershipData(
1843                 to,
1844                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1845             );
1846 
1847             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1848 
1849             _currentIndex = startTokenId + quantity;
1850         }
1851         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1852     }
1853 
1854     /**
1855      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1856      *
1857      * Requirements:
1858      *
1859      * - If `to` refers to a smart contract, it must implement
1860      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1861      * - `quantity` must be greater than 0.
1862      *
1863      * See {_mint}.
1864      *
1865      * Emits a {Transfer} event for each mint.
1866      */
1867     function _safeMint(
1868         address to,
1869         uint256 quantity,
1870         bytes memory _data
1871     ) internal virtual {
1872         _mint(to, quantity);
1873 
1874         unchecked {
1875             if (to.code.length != 0) {
1876                 uint256 end = _currentIndex;
1877                 uint256 index = end - quantity;
1878                 do {
1879                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1880                         revert TransferToNonERC721ReceiverImplementer();
1881                     }
1882                 } while (index < end);
1883                 // Reentrancy protection.
1884                 if (_currentIndex != end) revert();
1885             }
1886         }
1887     }
1888 
1889     /**
1890      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1891      */
1892     function _safeMint(address to, uint256 quantity) internal virtual {
1893         _safeMint(to, quantity, '');
1894     }
1895 
1896     // =============================================================
1897     //                        BURN OPERATIONS
1898     // =============================================================
1899 
1900     /**
1901      * @dev Equivalent to `_burn(tokenId, false)`.
1902      */
1903     function _burn(uint256 tokenId) internal virtual {
1904         _burn(tokenId, false);
1905     }
1906 
1907     /**
1908      * @dev Destroys `tokenId`.
1909      * The approval is cleared when the token is burned.
1910      *
1911      * Requirements:
1912      *
1913      * - `tokenId` must exist.
1914      *
1915      * Emits a {Transfer} event.
1916      */
1917     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1918         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1919 
1920         address from = address(uint160(prevOwnershipPacked));
1921 
1922         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1923 
1924         if (approvalCheck) {
1925             // The nested ifs save around 20+ gas over a compound boolean condition.
1926             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1927                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1928         }
1929 
1930         _beforeTokenTransfers(from, address(0), tokenId, 1);
1931 
1932         // Clear approvals from the previous owner.
1933         assembly {
1934             if approvedAddress {
1935                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1936                 sstore(approvedAddressSlot, 0)
1937             }
1938         }
1939 
1940         // Underflow of the sender's balance is impossible because we check for
1941         // ownership above and the recipient's balance can't realistically overflow.
1942         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1943         unchecked {
1944             // Updates:
1945             // - `balance -= 1`.
1946             // - `numberBurned += 1`.
1947             //
1948             // We can directly decrement the balance, and increment the number burned.
1949             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1950             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1951 
1952             // Updates:
1953             // - `address` to the last owner.
1954             // - `startTimestamp` to the timestamp of burning.
1955             // - `burned` to `true`.
1956             // - `nextInitialized` to `true`.
1957             _packedOwnerships[tokenId] = _packOwnershipData(
1958                 from,
1959                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1960             );
1961 
1962             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1963             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1964                 uint256 nextTokenId = tokenId + 1;
1965                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1966                 if (_packedOwnerships[nextTokenId] == 0) {
1967                     // If the next slot is within bounds.
1968                     if (nextTokenId != _currentIndex) {
1969                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1970                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1971                     }
1972                 }
1973             }
1974         }
1975 
1976         emit Transfer(from, address(0), tokenId);
1977         _afterTokenTransfers(from, address(0), tokenId, 1);
1978 
1979         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1980         unchecked {
1981             _burnCounter++;
1982         }
1983     }
1984 
1985     // =============================================================
1986     //                     EXTRA DATA OPERATIONS
1987     // =============================================================
1988 
1989     /**
1990      * @dev Directly sets the extra data for the ownership data `index`.
1991      */
1992     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1993         uint256 packed = _packedOwnerships[index];
1994         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1995         uint256 extraDataCasted;
1996         // Cast `extraData` with assembly to avoid redundant masking.
1997         assembly {
1998             extraDataCasted := extraData
1999         }
2000         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2001         _packedOwnerships[index] = packed;
2002     }
2003 
2004     /**
2005      * @dev Called during each token transfer to set the 24bit `extraData` field.
2006      * Intended to be overridden by the cosumer contract.
2007      *
2008      * `previousExtraData` - the value of `extraData` before transfer.
2009      *
2010      * Calling conditions:
2011      *
2012      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2013      * transferred to `to`.
2014      * - When `from` is zero, `tokenId` will be minted for `to`.
2015      * - When `to` is zero, `tokenId` will be burned by `from`.
2016      * - `from` and `to` are never both zero.
2017      */
2018     function _extraData(
2019         address from,
2020         address to,
2021         uint24 previousExtraData
2022     ) internal view virtual returns (uint24) {}
2023 
2024     /**
2025      * @dev Returns the next extra data for the packed ownership data.
2026      * The returned result is shifted into position.
2027      */
2028     function _nextExtraData(
2029         address from,
2030         address to,
2031         uint256 prevOwnershipPacked
2032     ) private view returns (uint256) {
2033         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2034         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2035     }
2036 
2037     // =============================================================
2038     //                       OTHER OPERATIONS
2039     // =============================================================
2040 
2041     /**
2042      * @dev Returns the message sender (defaults to `msg.sender`).
2043      *
2044      * If you are writing GSN compatible contracts, you need to override this function.
2045      */
2046     function _msgSenderERC721A() internal view virtual returns (address) {
2047         return msg.sender;
2048     }
2049 
2050     /**
2051      * @dev Converts a uint256 to its ASCII string decimal representation.
2052      */
2053     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2054         assembly {
2055             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2056             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2057             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2058             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2059             let m := add(mload(0x40), 0xa0)
2060             // Update the free memory pointer to allocate.
2061             mstore(0x40, m)
2062             // Assign the `str` to the end.
2063             str := sub(m, 0x20)
2064             // Zeroize the slot after the string.
2065             mstore(str, 0)
2066 
2067             // Cache the end of the memory to calculate the length later.
2068             let end := str
2069 
2070             // We write the string from rightmost digit to leftmost digit.
2071             // The following is essentially a do-while loop that also handles the zero case.
2072             // prettier-ignore
2073             for { let temp := value } 1 {} {
2074                 str := sub(str, 1)
2075                 // Write the character to the pointer.
2076                 // The ASCII index of the '0' character is 48.
2077                 mstore8(str, add(48, mod(temp, 10)))
2078                 // Keep dividing `temp` until zero.
2079                 temp := div(temp, 10)
2080                 // prettier-ignore
2081                 if iszero(temp) { break }
2082             }
2083 
2084             let length := sub(end, str)
2085             // Move the pointer 32 bytes leftwards to make room for the length.
2086             str := sub(str, 0x20)
2087             // Store the length.
2088             mstore(str, length)
2089         }
2090     }
2091 }
2092 
2093 // File: 444.sol
2094 
2095 
2096 pragma solidity ^0.8.9;
2097 
2098 
2099 
2100 
2101 
2102 
2103  
2104  
2105  
2106 contract PEPEJ is ERC721A, DefaultOperatorFilterer, Ownable, ReentrancyGuard { 
2107 event DevMintEvent(address ownerAddress, uint256 startWith, uint256 amountMinted);
2108 uint256 public devTotal;
2109     uint256 public _maxSupply = 999;
2110     uint256 public _mintPrice = 0.003 ether;
2111     uint256 public _maxMintPerTx = 10;
2112  
2113     uint256 public _maxFreeMintPerAddr = 1;
2114     uint256 public _maxFreeMintSupply = 0;
2115      uint256 public devSupply = 0;
2116  
2117     using Strings for uint256;
2118     string public baseURI;
2119  
2120     mapping(address => uint256) private _mintedFreeAmount;
2121  
2122  
2123     constructor(string memory initBaseURI) ERC721A("PePe JAPAN", "PEPEJ") {
2124         baseURI = initBaseURI;
2125     }
2126  
2127     function mint(uint256 count) external payable {
2128         uint256 cost = _mintPrice;
2129         bool isFree = ((totalSupply() + count < _maxFreeMintSupply + 1) &&
2130             (_mintedFreeAmount[msg.sender] + count <= _maxFreeMintPerAddr)) ||
2131             (msg.sender == owner());
2132  
2133         if (isFree) {
2134             cost = 0;
2135         }
2136  
2137         require(msg.value >= count * cost, "Please send the exact amount.");
2138         require(totalSupply() + count < _maxSupply - devSupply + 1, "Sold out!");
2139         require(count < _maxMintPerTx + 1, "Max per TX reached.");
2140  
2141         if (isFree) {
2142             _mintedFreeAmount[msg.sender] += count;
2143         }
2144  
2145         _safeMint(msg.sender, count);
2146     }
2147  
2148      function devMint() public onlyOwner {
2149         devTotal += devSupply;
2150         emit DevMintEvent(_msgSender(), devTotal, devSupply);
2151         _safeMint(msg.sender, devSupply);
2152     }
2153  
2154     function _baseURI() internal view virtual override returns (string memory) {
2155         return baseURI;
2156     }
2157  
2158  
2159 function isApprovedForAll(address owner, address operator)
2160         override
2161         public
2162         view
2163         returns (bool)
2164     {
2165         // Block X2Y2
2166         if (operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354) {
2167             return false;
2168         }
2169  
2170  
2171         return super.isApprovedForAll(owner, operator);
2172     }
2173  
2174  
2175  
2176     function tokenURI(uint256 tokenId)
2177         public
2178         view
2179         virtual
2180         override
2181         returns (string memory)
2182     {
2183         require(
2184             _exists(tokenId),
2185             "ERC721Metadata: URI query for nonexistent token"
2186         );
2187         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2188     }
2189  
2190     function setBaseURI(string memory uri) public onlyOwner {
2191         baseURI = uri;
2192     }
2193 
2194     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2195         super.setApprovalForAll(operator, approved);
2196     }
2197 
2198     function approve(address operator, uint256 tokenId) public payable  override onlyAllowedOperatorApproval(operator) {
2199         super.approve(operator, tokenId);
2200     }
2201 
2202     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2203         super.transferFrom(from, to, tokenId);
2204     }
2205 
2206     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2207         super.safeTransferFrom(from, to, tokenId);
2208     }
2209 
2210     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2211         public payable
2212         override
2213         onlyAllowedOperator(from)
2214     {
2215         super.safeTransferFrom(from, to, tokenId, data);
2216     }
2217  
2218     function setFreeAmount(uint256 amount) external onlyOwner {
2219         _maxFreeMintSupply = amount;
2220     }
2221  
2222     function setPrice(uint256 _newPrice) external onlyOwner {
2223         _mintPrice = _newPrice;
2224     }
2225  
2226     function withdraw() public payable onlyOwner nonReentrant {
2227         (bool success, ) = payable(msg.sender).call{
2228             value: address(this).balance
2229         }("");
2230         require(success);
2231     }
2232 }